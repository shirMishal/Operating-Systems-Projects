#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "traps.h"
#include "spinlock.h"

// Interrupt descriptor table (shared by all CPUs).
struct gatedesc idt[256];
extern uint vectors[];  // in vectors.S: array of 256 entry pointers
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
}

void
idtinit(void)
{
  lidt(idt, sizeof(idt));
}

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_COM1:
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
    break;

  case T_PGFLT:
  ;//verify none includes cow
    uint faulting_addr = rcr2();
    struct proc* p = myproc();
    pte_t* pte_ptr = public_walkpgdir(p->pgdir, (void *)faulting_addr, 0);
    #if SELECTION != NONE
    if (!(pte_ptr == 0) && (*pte_ptr & PTE_U) && (*pte_ptr & PTE_PG)){
      // this is a swapped out page, we need to get it back
      for (int i = 0; i < MAX_PYSC_PAGES; i++){
        if (PGROUNDDOWN((uint)(p->swapped_out_pages[i].va)) == PGROUNDDOWN(faulting_addr)){
          cprintf("\nPGFAULT flting_addr = %d\n", faulting_addr);
          swap_page_back(p, &(p->swapped_out_pages[i]));
          break;
        }
      }
      p->num_of_pagefaults_occurs++;
      return;
    }
    #endif
    if (!(pte_ptr == 0) && *pte_ptr & PTE_COW){
      //cprintf("trap - pid = %d, pa = 0x%x, va = 0x%x\n", p->pid, PTE_ADDR(*pte_ptr), faulting_addr);
      acquire(cow_lock);
      char* ref_count = &(pg_ref_counts[PGROUNDDOWN(PTE_ADDR(*pte_ptr)) / PGSIZE]);
      if (*ref_count == 1){
        *pte_ptr |= PTE_W;
        // make sure its ok to turn off the cow bit
        *pte_ptr &= (~PTE_COW);
        // cprintf("rel trap %d\n", p->pid);
        release(cow_lock);
        return;
      }
      else if (*ref_count > 1){
        (*ref_count)--;
        // cprintf("rel trap %d\n", p->pid);
        int result = copy_page(p->pgdir, pte_ptr);
        release(cow_lock);
        // cprintf("trap - after copy. pid = %d, pa = 0x%x\n", p->pid, PTE_ADDR(*pte_ptr));
        if (result < 0){
          p->killed = 1;
          exit();
        }
        return;
      }
      else{
        panic("ref count to page is 0 but it was reffed");
      }
    }
    cprintf("pid %d %s: trap %d err %d on cpu %d "
            "eip 0x%x addr 0x%x pte %x pid %d --kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2(), *pte_ptr, p->pid);
  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER){
      // #if SELECTION==NFUA
      // struct proc* p = myproc();
      // update_age_nfua(p);
      // #endif
      yield();
    }
    

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
