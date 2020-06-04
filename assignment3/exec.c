#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "defs.h"
#include "x86.h"
#include "elf.h"

void intiate_pg_info(struct proc* p){
  p->num_of_pageOut_occured = 0;
  p->num_of_pagefaults_occurs = 0;
  p->num_of_actual_pages_in_mem = 0;
  p->num_of_pages_in_swap_file = 0;
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
    p->ram_pages[i].is_free = p->swapped_out_pages[i].is_free = 1;
    p->ram_pages[i].aging_counter = p->swapped_out_pages[i].aging_counter = 0;
    p->ram_pages[i].swap_file_offset = p->swapped_out_pages[i].swap_file_offset = 0;
    p->ram_pages[i].va = p->swapped_out_pages[i].va = 0;
  }
}


int
exec(char *path, char **argv)
{
  char *s, *last;
  int i, off;
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
  uint pg_out_bu = 0, pg_flt_bu = 0, pg_mem_bu = 0, pg_swp_bu = 0;
  struct pageinfo mem_pginfo_bu[MAX_PYSC_PAGES];
  struct pageinfo swp_pginfo_bu[MAX_PYSC_PAGES];
  struct file* swap_file_bu = 0;
  struct file* temp_swap_file = 0;

  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
    goto bad;

  if((pgdir = setupkvm()) == 0)
    goto bad;

  if (curproc->pid > 2){
    // lets backup the pageinfo of the old process for case the exec fails
    // ******************BACKUP****************************
    pg_flt_bu = curproc->num_of_pagefaults_occurs;
    pg_mem_bu = curproc->num_of_actual_pages_in_mem;
    pg_swp_bu = curproc->num_of_pages_in_swap_file;
    pg_out_bu = curproc->num_of_pageOut_occured;
    for (int i = 0; i < MAX_PYSC_PAGES; i++){
      mem_pginfo_bu[i] = curproc->ram_pages[i];
      swp_pginfo_bu[i] = curproc->swapped_out_pages[i];
    }
    // ******************BACKUP****************************
    intiate_pg_info(curproc);
    swap_file_bu = curproc->swapFile;
    createSwapFile(curproc);
  }

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
  end_op();
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
  curproc->sz = sz;
  curproc->tf->eip = elf.entry;  // main
  curproc->tf->esp = sp;

  if (curproc->pid > 2){
    // ##### REMOVE OLD SWAP FILE ##################
    temp_swap_file = curproc->swapFile;
    curproc->swapFile = swap_file_bu;
    removeSwapFile(curproc);
    curproc->swapFile = temp_swap_file;
    // ##### REMOVE OLD SWAP FILE ##################
  }
  switchuvm(curproc);
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir){
    if (curproc->pid > 2){
      // lets restore the pageinfo of the old process
      // ******************RESTORE****************************
      curproc->num_of_pagefaults_occurs = pg_flt_bu;
      curproc->num_of_actual_pages_in_mem = pg_mem_bu;
      curproc->num_of_pages_in_swap_file = pg_swp_bu;
      curproc->num_of_pageOut_occured = pg_out_bu;
      for (int i = 0; i < MAX_PYSC_PAGES; i++){
        curproc->ram_pages[i] = mem_pginfo_bu[i];
        curproc->swapped_out_pages[i] = swp_pginfo_bu[i];
      }
      // ******************RESTORE****************************
      removeSwapFile(curproc);
      curproc->swapFile = swap_file_bu;
    }
    freevm(pgdir);
  }
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
}
