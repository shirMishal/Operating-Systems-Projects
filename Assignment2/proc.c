#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"



struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

int sigkill();

int sigcont();
int sigstop();

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}



// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
  int apicid, signum;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[signum].
  for (signum = 0; signum < ncpu; ++signum) {
    if (cpus[signum].apicid == apicid)
      return &cpus[signum];
  }
  panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
  popcli();
  return p;
}




int 
allocpid(void) 
{
  pushcli();
  int oldval;
  do{
    oldval = nextpid;
  } while(!cas(&nextpid, oldval, nextpid + 1));
  return nextpid;
  popcli();
}

void switch_state(enum procstate* state_ptr, enum procstate old, enum procstate new){
  while (!cas(state_ptr, old, new)){
    // cprintf("switch has not worked from state %d to state %d, current state = %d\n", old, new, *state_ptr);
  }
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  pushcli();
  p = ptable.proc;
  while (p < &ptable.proc[NPROC] && !cas(&(p->state), UNUSED, EMBRYO)){
    p++;
  }
  p->debug = 3;
  if (p < &ptable.proc[NPROC]){
    goto found;
  }
  popcli();
  return 0;

found:
  popcli();
  p->pid = allocpid();

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }


  sp = p->kstack + KSTACKSIZE;

  // sp -= sizeof(*p->user_trapframe_backup);
  // p->user_trapframe_backup = (struct trapframe*)sp;

  p->user_trapframe_backup = (struct trapframe*)kalloc();

  // reserving space for the trapframe backup. TODO: verify

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  // Set up the signal state
  p->blocked_signal_mask = 0;
  p->pending_signals = 0;

  for (int signum = 0; signum < 32; signum++){
    // 16 bytes struct
    p->signal_handlers[signum].sa_handler = SIG_DFL;
    p->signal_handlers[signum].sigmask = 0;
  }

  p->flag_frozen = 0;
  p->flag_in_user_handler = 0;
  return p;
}




//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  // possible bug
  pushcli();
  if (!cas(&(p->state), EMBRYO, RUNNABLE)){
    panic("switch state from embryo to runnable failed in userinit");
  }
  p->debug = 4;
  popcli();
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int signum, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(signum = 0; signum < NOFILE; signum++)
    if(curproc->ofile[signum])
      np->ofile[signum] = filedup(curproc->ofile[signum]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;

  // possible bug
  pushcli();
  if (!cas(&(np->state), EMBRYO, RUNNABLE)){
    panic("process in fork not at embryo");
  }
  np->debug = 5;
  popcli();

  // Inheriting parent's signal mask and handlers

  np->blocked_signal_mask = np->parent->blocked_signal_mask;
  np->pending_signals = 0;

  for (int signum = 0; signum < 32; signum++){
    // 16 bytes struct
    np->signal_handlers[signum] = np->parent->signal_handlers[signum];
  }

  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  // acquire(&ptable.lock);
  pushcli();


    // Jump into the scheduler, never to return.
  if (!cas(&(curproc->state), RUNNING, MINUS_ZOMBIE)){
    // // cprintf("exit is not at running state, real state is %d", curproc->state);
    panic("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
  }

  // curproc->debug = 6;


  // int has_abandoned_children = 0;;
  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
      if(p->state == ZOMBIE || p->state == MINUS_ZOMBIE){
        wakeup1(initproc);
        // has_abandoned_children = 1;
      }
    }
  }

  // Parent might be sleeping in wait().
  // wakeup1(curproc->parent);


  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  struct proc *p;
  int havekids, found, pid;
  struct proc *curproc = myproc();
  
  // acquire(&ptable.lock);
  pushcli();

  for(;;){
    while(!cas(&(curproc->state), curproc->state, MINUS_SLEEPING));
    curproc->chan = (void*) curproc;
    // curproc->debug = 7;
    //start_loop:

    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc)
        continue;
      havekids = 1;
      found = 0;
      // if (cas(&(curproc->state), MINUS_RUNNABLE, MINUS_RUNNABLE)){

      //   goto start_loop;
      // }

      if (p->state == MINUS_ZOMBIE){
        curproc->chan = 0;
        found = 1;
        while(!cas(&(curproc->state), curproc->state, RUNNING));
      }
      while(p->state == MINUS_ZOMBIE);
      if(cas(&(p->state), ZOMBIE, MINUS_UNUSED)){
        while(!cas(&(curproc->state), curproc->state, RUNNING));
        p->debug = 8;
        // Found one.
        pid = p->pid;
        kfree((char *)p->user_trapframe_backup);
        p->user_trapframe_backup = null;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        switch_state(&(p->state), MINUS_UNUSED, UNUSED);
        // p->debug = 1;
        // release(&ptable.lock);
        // curproc->debug = 9;
        popcli();
        return pid;
      }
      else if (found){
        panic("not possible from wait");
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      // release(&ptable.lock);
      curproc->chan = null;
      if (!cas(&(curproc->state), MINUS_SLEEPING, RUNNING)){
          panic("unable to return to running state in wait\n");
      }
      curproc->debug = 10;
      popcli();
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    // sleep(curproc, null);  //DOC: wait-sleep
    // curproc->chan = (void* )curproc;

    sched();

    // Tidy up.
    // curproc->chan = 0;
  }
}

int has_cont_pending(struct proc* p){
  for (int i = 0; i < 32; i++){
    if (!((1 << i) & p->pending_signals)){
      continue;
    }
    if (i == SIGCONT && p->signal_handlers[i].sa_handler == SIG_DFL){
      return 1;
    }
    if ((int)(p->signal_handlers[i].sa_handler) == SIGCONT){
      return 1;
    }
  }
  return 0;
}

//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  struct proc *p;
  struct cpu *c = mycpu();
  c->proc = 0;
  
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    // acquire(&ptable.lock);
    pushcli();
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
   
      if (p->flag_frozen && !has_cont_pending(p)){
        continue;
      }

      if (!cas(&(p->state), RUNNABLE, MINUS_RUNNING)){
        // switchkvm();
        // c->proc = 0;
        continue;
      }
      
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      
      switch_state(&(p->state), MINUS_RUNNING, RUNNING);

      swtch(&(c->scheduler), p->context);
      switchkvm();

      

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
      if (cas(&(p->state), MINUS_SLEEPING, SLEEPING) || cas(&(p->state), MINUS_RUNNABLE, RUNNABLE) || cas(&(p->state), MINUS_ZOMBIE, ZOMBIE)){
        p->debug = 12;
        if (p->state == ZOMBIE){
          wakeup1(p->parent);
        }
        continue;
      }

      // else{
      //   cprintf("real state = %d, pid = %d\n", p->state, p->pid);
      //   panic("something is wrong in scheduler");
      // }
    }
    // release(&ptable.lock);
    popcli();

  }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();

  // possible bug
  // if(!holding(&ptable.lock))
  //   panic("sched ptable.lock");
  // if(mycpu()->ncli != 1)
  //   panic("sched locks");
  if((p->state == RUNNING))
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  // acquire(&ptable.lock);  //DOC: yieldlock
  pushcli();
  switch_state(&(myproc()->state), RUNNING, MINUS_RUNNABLE);
  // myproc()->debug = 2;
  sched();
  popcli();
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  // release(&ptable.lock);

  // switch_state(&(myproc()->state), -RUNNING, RUNNING);
  popcli();
  
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0 || lk == 0)
    panic("sleep");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  pushcli();
  release(lk);
  // Go to sleep.
  // switch_state((&(p->chan)), (int)p->chan, (int)chan);
  if (!cas(&(p->chan), (int)p->chan, (int)chan)){
    panic("sleep wrong");
  }
  if (!cas(&(p->state), p->state, MINUS_SLEEPING)){
    // cprintf("real state = %d\n", p->state);
    panic("sleep change state failed");
  }

  p->debug = 13;

  sched();

  if (p->state != RUNNING){
    panic("no way");
  }

  // Tidy up.
  if (!cas(&(p->chan), (int)p->chan, 0)){
    panic("sleep wrong");
  }

  // Reacquire original lock.
  popcli();
  acquire(lk);
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->chan == chan){
      if (cas(&(p->state), MINUS_SLEEPING, MINUS_RUNNABLE)){
        p->chan = null;
      }
      if (cas(&(p->state), SLEEPING, MINUS_RUNNABLE)){
        p->chan = null;
        if (!cas(&(p->state), MINUS_RUNNABLE, RUNNABLE)){
          panic("not possible");
        }
      }
      // if (p->state == MINUS_SLEEPING){
      //   goto wake;
      // }
        // cprintf("wakeup boohoo \n");
    }
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  // possible bug
  // acquire(&ptable.lock);
  pushcli();
  wakeup1(chan);
  popcli();
  // release(&ptable.lock);
}

int is_blocked(uint mask, int signum){
  return (mask & (1 << signum));
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid, int signum)
{
  if (signum < 0 || signum > 31){
    return -1;
  }
  struct proc *p;
  // acquire(&ptable.lock);
  pushcli();
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      if ((((int)(p->signal_handlers[signum].sa_handler) == SIGKILL && !is_blocked(p->blocked_signal_mask, signum)) || signum == SIGKILL || signum == SIGSTOP)){
        if (cas(&(p->state), MINUS_SLEEPING, MINUS_RUNNABLE)){
         p->chan = null;
        }
        if (cas(&(p->state), SLEEPING, MINUS_RUNNABLE)){
         p->chan = null;
         if (!cas(&(p->state), MINUS_RUNNABLE, RUNNABLE)){
           panic("not possible");
         }
       }
      }
      while(cas(&(p->pending_signals), p->pending_signals, p->pending_signals | (1 << signum)));
      // p->pending_signals = p->pending_signals | (1 << signum);
      // release(&ptable.lock);
      popcli();
      return 0;
    }
  }
  // release(&ptable.lock);
  popcli();
  return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie",
  [MINUS_UNUSED]   "minus unused",
  [MINUS_EMBRYO]    "minus embryo",
  [MINUS_SLEEPING]  "minus sleep ",
  [MINUS_RUNNABLE]  "minus runble",
  [MINUS_RUNNING]   "minus run   ",
  [MINUS_ZOMBIE]    "minus zombie",
  
  };
  int signum;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if((p->state == UNUSED) || (p->state == MINUS_UNUSED))
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s pid = %x first dword = %x", p->pid, state, p->name, (p->state == SLEEPING ? ((struct proc *)(p->chan))->pid : 52684), (p->state == SLEEPING ? *((int *)(p->chan)) : 52684));
    if(p->state == SLEEPING || p->state == MINUS_SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(signum=0; signum<10 && pc[signum] != 0; signum++)
        cprintf(" %p", pc[signum]);
    }
    cprintf("\n");
  }
}

uint sigprocmask(uint sigmask){
  uint temp = myproc()->blocked_signal_mask;
  // Ignoring kill, stop, cont signals
  uint kill_mask = 1 << SIGKILL;
  uint cont_mask = 1 << SIGCONT;
  uint stop_mask = 1 << SIGSTOP;
  myproc()->blocked_signal_mask = sigmask & ~(kill_mask | stop_mask | cont_mask);
  return temp;
}

int sigaction(int signum, const struct sigaction* act, struct sigaction* oldact){
  // make sure SIGCONT also here
  if (signum == SIGKILL || signum == SIGSTOP || signum == SIGCONT){
    return -1;
  }
  if (signum < 0 || signum > 31){
    return -1;
  }
  // 16 bytes struct
  struct proc* p = myproc();
  if (oldact != null){
    *oldact = p->signal_handlers[signum];
  }
  p->signal_handlers[signum] = *act;
  return 0;
}

void sigret(){
  struct proc* p = myproc();
  if (p!= null){
    *(p->tf) = *(p->user_trapframe_backup);
    //memmove( p->tf, p->user_trapframe_backup, sizeof(*p->user_trapframe_backup));
    p->blocked_signal_mask = p->mask_backup;
    p->flag_in_user_handler = 0;
    // // cprintf("sigret debug\n");
  }
  return;
 }

// Signals implementation
// Assumed that the signal is being clear from the pending signals by the caller
int
sigkill(){
  // // cprintf("process with pid %d killed handled\n", myproc()->pid);
  myproc()->killed = 1;
  // release(&ptable.lock);
  return 0;
}

int 
sigcont(){
  myproc()->flag_frozen = 0;
  return 0;
}

int 
sigstop(){
  myproc()->flag_frozen = 1;
  return 0;
}


void handle_signals(){
  struct proc* p = myproc();
  if (p == null){
    return;
  }
 
  uint mask = p->blocked_signal_mask;
  uint pending = p->pending_signals;
  uint signals_to_handle = (~mask) & pending;
  for (int signum = 0; signum < 32; signum++){
    if (((signals_to_handle >> signum) & 0x1) == 0){
        continue;
    }
    // turning off the bit in pending signals
    // p->pending_signals &= ~(1 << signum);
    while(cas(&(p->pending_signals), p->pending_signals, p->pending_signals & ~(1 << signum)));

    // handle if kernel handler
    int sa_handler = (int)p->signal_handlers[signum].sa_handler;
    switch (sa_handler){
      case SIGKILL:
        sigkill();
        break;
      case SIGSTOP:
        sigstop();
        break;
      case SIGCONT:
        sigcont();
        break;
      case SIG_IGN:
        break;
      case SIG_DFL:
        if (signum == SIGSTOP){
          sigstop();
        }
        else if (signum == SIGCONT){
          sigcont();
        }
        else{
          sigkill();
        }
        break;
      default:
        if (p->flag_in_user_handler == 0){ 
          // cprintf("in user_handle_signals\n");
          // user signal handler
          p->flag_in_user_handler = 1;
          p->mask_backup = p->blocked_signal_mask;
          p->blocked_signal_mask = p->signal_handlers[signum].sigmask;
          //memmove(p->user_trapframe_backup, p->tf, sizeof(*p->tf));
          *(p->user_trapframe_backup) = *(p->tf);
          char call_sigret[7] = { 0xB8, 0x18, 0x00, 0x00, 0x00, 0xCD, 0x40 };
          // 7 bytes for the compiled code calling to sigret (mov eax, 0x18 ; int 0x40)
          // 4 bytes for signum param and 4 bytes for the return address
          p->tf->esp -= 0xF;
          *((int*)(p->tf->esp)) = p->tf->esp + 0x8;
          *((int*)(p->tf->esp + 4)) = signum;
          memmove((void*)(p->tf->esp + 8), call_sigret, 7);
          // for (int i = 0; i < 7; i++){
          //   *((char *)(p->tf->esp + 8 + i)) = call_sigret[i];
          // }
          p->tf->eip = sa_handler + 4;
          return;
        }
    } 
    
  }
  return;
}
