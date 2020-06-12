// Per-CPU state
struct cpu {
  uchar apicid;                // Local APIC ID
  struct context *scheduler;   // swtch() here to enter scheduler
  struct taskstate ts;         // Used by x86 to find stack for interrupt
  struct segdesc gdt[NSEGS];   // x86 global descriptor table
  volatile uint started;       // Has the CPU started?
  int ncli;                    // Depth of pushcli nesting.
  int intena;                  // Were interrupts enabled before pushcli?
  struct proc *proc;           // The process running on this cpu or null
};

extern struct cpu cpus[NCPU];
extern int ncpu;

//PAGEBREAK: 17
// Saved registers for kernel context switches.
// Don't need to save all the segment registers (%cs, etc),
// because they are constant across kernel contexts.
// Don't need to save %eax, %ecx, %edx, because the
// x86 convention is that the caller has saved them.
// Contexts are stored at the bottom of the stack they
// describe; the stack pointer is the address of the context.
// The layout of the context matches the layout of the stack in swtch.S
// at the "Switch stacks" comment. Switch doesn't save eip explicitly,
// but it is on the stack and allocproc() manipulates it.
struct context {
  uint edi;
  uint esi;
  uint ebx;
  uint ebp;
  uint eip;
};

struct pageinfo {
  int is_free;   
  uint swap_file_offset; //if page is in swapfile
  uint aging_counter;
  uint page_index;  // usefull for SCFIFO, is the global index of the page
  void* va;         // virtual address of the page (offset will be ignore because we are not intersted in the physical memory)
  pde_t* pgdir_of_va;
};

enum procstate { UNUSED, EMBRYO, SLEEPING, RUNNABLE, RUNNING, ZOMBIE };

// Per-process state
struct proc {
  uint sz;                     // Size of process memory (bytes)
  pde_t* pgdir;                // Page table
  char *kstack;                // Bottom of kernel stack for this process
  enum procstate state;        // Process state
  int pid;                     // Process ID
  struct proc *parent;         // Parent process
  struct trapframe *tf;        // Trap frame for current syscall
  struct context *context;     // swtch() here to run process
  void *chan;                  // If non-zero, sleeping on chan
  int killed;                  // If non-zero, have been killed
  struct file *ofile[NOFILE];  // Open files
  struct inode *cwd;           // Current directory
  char name[16];               // Process name (debugging)
  //Swap file. must initiate with create swap file
  struct file *swapFile;      //page file
  
  // INV  : cell swapped_out_pages[i] is free iff there isnt a page that is written in offset i * PGSIZE in the swap file
  struct pageinfo swapped_out_pages[MAX_TOTAL_PAGES-MAX_PYSC_PAGES];
  struct pageinfo ram_pages[MAX_PYSC_PAGES];
  int advance_queue[MAX_PYSC_PAGES];//each cell contains the index of page in ram_pages array
                                    // index 0 begin of queue 15 end of queue - last page in queue is to be removed next

  //halpful parameters also required for debug at task 4
  int num_of_pages_in_swap_file; //num of pages on disk
  int num_of_actual_pages_in_mem;   // num of pages at ram ------ckeck it's correct
  int num_of_pagefaults_occurs;
  int num_of_pageOut_occured;
};

// Process memory is laid out contiguously, low addresses first:
//   text
//   original data and bss
//   fixed-size stack
//   expandable heap
int sys_get_number_of_free_pages_impl(void);


