#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  int exit_status;
  argint(0, &exit_status);
  exit(exit_status);
  return 0;  // not reached
}

int
sys_wait(void)
{
  char *status_ptr;
  argptr(0, &status_ptr, 4);
  return wait((int*)status_ptr);
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

int sys_memsize(void){
  return myproc()->sz;
}

int sys_set_ps_priority(void)
{
  int priority;
  argint(0, &priority);
  return set_ps_priority(priority);
}

int sys_policy(void)
{
  int policy_type;
  argint(0, &policy_type);
  return policy(policy_type);
}

int sys_set_cfs_priority(void){
  int priority;
  argint(0, &priority);
  return set_cfs_priority(priority);
}

int sys_proc_info(void){
  char* performance;
  argptr(0, &performance, sizeof(struct perf));
  return proc_info((struct perf*) performance);
}
