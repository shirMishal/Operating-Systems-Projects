#include "param.h"
#include "types.h"
#include "defs.h"
#include "x86.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "elf.h"

struct pageinfo* find_page_to_swap(struct proc* p);
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc);
int swap_in(struct proc* p, struct pageinfo* pi);
void swap_out(struct proc* p, struct pageinfo* page_to_swap, void* buffer, pde_t* pgdir);

// #if SELECTION == NONE
// struct pageinfo* find_page_to_swap(struct proc* p){
//   return 0;
// }
// #endif

// #if SELECTION == SCFIFO
uint page_counter = 0;
struct pageinfo* find_page_to_swap(struct proc* p){
  while(1){
    uint min = 0x0FFFFFFF;
    struct pageinfo* min_pi = 0;
    for (int i = 0; i < MAX_PYSC_PAGES; i++){
      struct pageinfo* pi = &(p->ram_pages[i]); 
      // if ((*(walkpgdir(p->pgdir, pi, 0)) & PTE_U) == 0){
      //   continue;
      // }
      if (!pi->is_free && pi->page_index < min){
          min = pi->page_index;
          min_pi = pi;
      }
    }
    pte_t* pte = walkpgdir(p->pgdir, min_pi, 0);
    // giving the page a second chance
    if (*pte & PTE_A){
      min_pi->page_index = (++page_counter);
      *pte &= ~PTE_A;
    }
    else{
      return min_pi;
    }
  }
}

struct pageinfo* find_page_to_swap1(struct proc* p){
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
    if (!p->ram_pages[i].is_free){
      return &p->ram_pages[i];
    }
  }
  return 0;
}
// #endif

// #if SELECTION == NONE
// struct pageinfo* find_page_to_swap(struct proc* p){
  
// }
// #endif

// #if SELECTION == NONE
// struct pageinfo* find_page_to_swap(struct proc* p){
  
// }
// #endif

// #if SELECTION == NONE
// struct pageinfo* find_page_to_swap(struct proc* p){
  
// }
// #endif

extern char data[];  // defined by kernel.ld
pde_t *kpgdir;  // for use in scheduler()

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
  struct cpu *c;

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
  lgdt(c->gdt, sizeof(c->gdt));
}

// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}

uint*
public_walkpgdir(pde_t *pgdir, const void *va, int alloc){
  return walkpgdir(pgdir, va, alloc);
}
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}

// There is one page table per process, plus one that's used when
// a CPU is not running any process (kpgdir). The kernel uses the
// current process's page table during system calls and interrupts;
// page protection bits prevent user code from using the kernel's
// mappings.
//
// setupkvm() and exec() set up every page table like this:
//
//   0..KERNBASE: user memory (text+data+stack+heap), mapped to
//                phys memory allocated by the kernel
//   KERNBASE..KERNBASE+EXTMEM: mapped to 0..EXTMEM (for I/O space)
//   KERNBASE+EXTMEM..data: mapped to EXTMEM..V2P(data)
//                for the kernel's instructions and r/o data
//   data..KERNBASE+PHYSTOP: mapped to V2P(data)..PHYSTOP,
//                                  rw data + free physical memory
//   0xfe000000..0: mapped direct (devices such as ioapic)
//
// The kernel allocates physical memory for its heap and for user memory
// between V2P(end) and the end of physical memory (PHYSTOP)
// (directly addressable from end..P2V(PHYSTOP)).

// This table defines the kernel's mappings, which are present in
// every process's page table.
static struct kmap {
  void *virt;
  uint phys_start;
  uint phys_end;
  int perm;
} kmap[] = {
 { (void*)KERNBASE, 0,             EXTMEM,    PTE_W}, // I/O space
 { (void*)KERNLINK, V2P(KERNLINK), V2P(data), 0},     // kern text+rodata
 { (void*)data,     V2P(data),     PHYSTOP,   PTE_W}, // kern data+memory
 { (void*)DEVSPACE, DEVSPACE,      0,         PTE_W}, // more devices
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
  kpgdir = setupkvm();
  switchkvm();
}

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
}

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
}

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  char *mem;
  uint a;
  struct proc* p = myproc();
  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);

  
  for(; a < newsz; a += PGSIZE){
    // our code
    // #if SELECTION != NONE
    if (p->pid > 2){
      // uint number_of_pages_to_alloc = (PGROUNDUP(newsz) - a) / PGSIZE;
      // uint number_of_pages_to_swap = number_of_pages_to_alloc - (MAX_PYSC_PAGES - p->num_of_actual_pages_in_mem);
      if (p->num_of_actual_pages_in_mem >= 16){
        struct pageinfo* page_to_swap = find_page_to_swap(p);
        // swap page
        // INV  : cell swapped_out_pages[i] is free iff there isnt a page that is written in offset i * PGSIZE in the swap file
        swap_out(p, page_to_swap, 0, pgdir);
      }
      p->num_of_actual_pages_in_mem++;
    }
    // now we are sure that we have enough free pages in ram (except maybe some race conditions)
    // #endif
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
    }
    if (p->pid > 2){
      for (int i = 0; i < MAX_PYSC_PAGES; i++){
        if (p->ram_pages[i].is_free){
          // alocating one pageinfo and saving the details
          p->ram_pages[i].is_free = 0;
          p->ram_pages[i].page_index = ++page_counter;
          p->ram_pages[i].va = (void *)a;
          break;
        }
      }
    }
  }
  return newsz;
}

// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;
  struct proc* p = myproc();

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
      if (p->pid > 2 && pgdir == p->pgdir){
        for (int i = 0; i < MAX_PYSC_PAGES; i++){
          if (p->ram_pages[i].va == (void*)a){
            p->num_of_actual_pages_in_mem--;
            p->ram_pages[i].is_free = 1;
            p->ram_pages[i].aging_counter = 0;
            p->ram_pages[i].va = 0;
            break;
          }
        }
      }
      *pte = 0;
    }
  }

  return newsz;
}

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
  uint i;
  struct proc* p = myproc();
  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  if (p->pid > 2 && p->pgdir == pgdir){
    p->num_of_actual_pages_in_mem = 0;
    p->num_of_pages_in_swap_file = 0;
    for (int i = 0; i < MAX_PYSC_PAGES; i++){
      p->ram_pages[i].is_free = p->swapped_out_pages[i].is_free = 1;
      p->ram_pages[i].aging_counter = p->swapped_out_pages[i].aging_counter = 0;
      p->ram_pages[i].swap_file_offset = p->swapped_out_pages[i].swap_file_offset = 0;
      p->ram_pages[i].va = p->swapped_out_pages[i].va = 0;
    }
  }
  for(i = 0; i < NPDENTRIES; i++){
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
}

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
  *pte &= ~PTE_U;
}

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P) && !(*pte & PTE_PG))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
      kfree(mem);
      goto bad;
    }
  }
  return d;

bad:
  freevm(d);
  return 0;
}

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}

// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
//  if buffer == 0 then we put buffer <-- kernel_va(page_to_swap->va)  // p2v(phiscal(va))
//  and use buffer to swap out from
//  we assume that if buffer is not 0, it is kernel virtual address
void swap_out(struct proc* p, struct pageinfo* page_to_swap, void* buffer, pde_t* pgdir){
  // cprintf("SWAP OUT: index = %d, offset = %d, va = %d\n", page_to_swap->page_index, page_to_swap->swap_file_offset, page_to_swap->va);
  if (buffer == 0){
    // page_to_swap->va
    buffer = P2V((PTE_ADDR(*(walkpgdir(pgdir, page_to_swap->va, 0)))));
  }
  // swap page
  // INV  : cell swapped_out_pages[i] is free iff there isnt a page that is written in offset i * PGSIZE in the swap file
  int index;
  int found = 0;
  p->num_of_pages_in_swap_file++;
  for (index = 0; index < MAX_PYSC_PAGES; index++){
    if (p->swapped_out_pages[index].is_free){
      p->swapped_out_pages[index].is_free = 0;
      p->swapped_out_pages[index].va = page_to_swap->va;
      p->swapped_out_pages[index].swap_file_offset = index * PGSIZE;
      found = 1;
      break;
    }
  }
  if (!found){
    panic("SWAP IN BALAGAN\n");
  }
  if (index < 0 || index > 15){
    panic("we have a bug\n");
  }
  int result = writeToSwapFile(p, buffer, index * PGSIZE, PGSIZE);


  
  // update flags in PTE
  pte_t* pte_ptr = walkpgdir(pgdir, page_to_swap->va, 0);
  *pte_ptr |= PTE_PG;
  *pte_ptr &= ~PTE_P;
  // *pte_ptr |= PTE_U;
  kfree(buffer);
  // refresh cr3
  lcr3(V2P(p->pgdir));
  page_to_swap->is_free = 1;
  if (result < 0){
    panic("swap out failed\n");
  }
  p->num_of_pageOut_occured++;
  p->num_of_actual_pages_in_mem--;
}

// we assume there are at most MAX_PYSC_PAGES in the RAM 
int swap_in(struct proc* p, struct pageinfo* pi){
  pde_t* pgdir = p->pgdir;
  uint offset = pi->swap_file_offset;
  int found = 0;
  int index;
  // cprintf("SWAP IN: index = %d, offset = %d, va = %d\n", pi->page_index, pi->swap_file_offset, pi->va);
  for (index = 0; index < MAX_PYSC_PAGES; index++){
    if (p->ram_pages[index].is_free){
      found = 1;
      p->ram_pages[index].is_free = 0;
      break;
    }
  }
  if (!found){
    panic("SWAP IN BALAGAN\n");
  }
  void* mem = kalloc();
  // mem = kalloc();
  if(mem == 0){
    cprintf("swap in - out of memory\n");
    // deallocuvm(pgdir, newsz, oldsz);
    return -1;
  }

  void* va = pi->va;
  pte_t* pte_ptr = walkpgdir(pgdir, va, 0);
  // update flags
  *pte_ptr &= ~PTE_PG;
  *pte_ptr |= (PTE_P | PTE_U | PTE_W);

  // updating physical address written in the page table entry
  *pte_ptr = PTE_FLAGS(*pte_ptr);
  *pte_ptr |= PTE_ADDR(V2P(mem));

  p->ram_pages[index].page_index = ++page_counter;
  p->ram_pages[index].va = va;
  int result = readFromSwapFile(p, mem, offset, PGSIZE);

  // clean the struct
  pi->is_free = 1;
  pi->va = 0;
  pi->swap_file_offset = 0;

  // refresh rc3
  lcr3(V2P(p->pgdir));

  p->num_of_actual_pages_in_mem++;
  p->num_of_pages_in_swap_file--;

  if (result < 0){
    panic("swap in failed");
  }
  return result;
}
/**
 * 
 * 1. ram full file full - temp and swap in and swap out
 * 2. ram full file not full - swap out swap in
 * 3. ram not full - swap in
 * 
 * 
 * */

void swap_page_back(struct proc* p, struct pageinfo* pi_to_swapin){
  // cprintf("RAM: %d SWAP: %d\n", p->num_of_actual_pages_in_mem, p->num_of_pages_in_swap_file);
  // int ram = 0, swap = 0;
  // for (int i = 0; i < MAX_PYSC_PAGES; i++){
  //   if (!p->ram_pages[i].is_free){
  //     ram++;
  //   }
  //   if (!p->swapped_out_pages[i].is_free){
  //     swap++;
  //   }
  // }
  // cprintf("RAM: %d SWAP: %d\n", ram, swap);
  if (p->num_of_actual_pages_in_mem == MAX_PYSC_PAGES && p->num_of_pages_in_swap_file == MAX_PYSC_PAGES){
    // cprintf("PGFAULT A\n");
    // file and ram are full - we need temp buffer
    char* buffer = kalloc();
    struct pageinfo pi;
    struct pageinfo* page_to_swap = find_page_to_swap(p);
    // TODO: make sure that memmove gets virtual address
    memmove(buffer, page_to_swap->va, PGSIZE);
    pi = *page_to_swap;
    page_to_swap->is_free = 1;
    // we want to override the page we just backed up
    swap_in(p, page_to_swap);

    // swap out from buffer
    // pi is a deep copy of the pageinfo struct so we dont care that swap_out will change it
    swap_out(p, &pi, buffer, p->pgdir);
  }
  else if (p->num_of_actual_pages_in_mem == MAX_PYSC_PAGES && p->num_of_pages_in_swap_file < MAX_PYSC_PAGES){
    // cprintf("PGFAULT B\n");
    struct pageinfo* page_to_swap = find_page_to_swap(p);
    swap_out(p, page_to_swap, 0, p->pgdir);
    swap_in(p, pi_to_swapin);
  }
  else{
    // cprintf("PGFAULT C\n");
    swap_in(p, pi_to_swapin);
  }
}

//PAGEBREAK!
// Blank page.
//PAGEBREAK!
// Blank page.
//PAGEBREAK!
// Blank page.
