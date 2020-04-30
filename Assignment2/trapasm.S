#include "mmu.h"

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
  pushl %es
  pushl %fs
  pushl %gs
  pushal
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
  movw %ax, %ds
  movw %ax, %es

  # Call trap(tf), where tf=%esp
  pushl %esp
  call trap
  addl $4, %esp

  # Return falls through to trapret...
.globl trapret
trapret:
  call myproc ; eax = proc struct address

  addl $124, %eax ; eax = pending_signals address
  mov (%eax), %ebx ; ebx = pending_signals
  addl $4, %eax  ; eax = signal_mask address
  mov (%eax), %edx ; edx = signal_mask

  pushl %eax ; saving signal_mask address for later
  pushl %edx ; saving signal_mask for later

  not %edx
  and %edx, %ebx ; ebx = mask that specifies all the processes we want to handle.

  not %ebx
  and %ebx, -4(%eax) ; zeroing out the bits we are about to handle
  not %ebx

  addl $4, %eax ; eax = handlers array address
  mov $0, %ecx

  handlers_loop:
  pushl %ecx
  ; We made sure that on the start of every iteration i=ecx, eax has the address of i'th sigaction struct in the signal_handlers array
  xor %edx, %edx
  shr %ebx
  adc $0, %edx
  ; Now edx is 1 iff the i'th bit was set in ebx, meaning we want to handle this signal.
  cmp $0, %edx
  je continue
  ; free to use regs are ecx, edx
  ; we know that the stack is:
  ; [esp] = i , [esp + 4] = signal_mask , [esp + 8] = signal_mask address
  mov 4(%eax), %edx
  mov 8(%esp), %ecx
  mov %edx, (%ecx) ; updating mask to be the new


  mov (%eax), %ecx ; ecx = current sa_handler
  cmp %ecx, SIG_IGN
  je continue

  cmp %ecx, SIGSTOP
  jne skip_stop
  call sigstop
  jmp continue

  skip_stop:
  cmp %ecx, SIGCONT
  jne skip_cont
  call sigcont
  jmp continue

  skip_cont:
  cmp %ecx, SIGKILL
  jne skip_kill
  call sigkill
  jmp continue

  skip_kill:
  cmp %ecx, SIG_DFL
  jne user_handler

  mov (%esp), %ecx

  cmp %ecx, SIGCONT
  jne not_cont_signal
  call sigcont
  jmp continue

  not_cont_signal:

  cmp %ecx, SIGSTOP
  jne not_stop_signal
  call sigstop
  jmp continue

  not_stop_signal:
  call sigkill
  jmp continue

  user_handler:
  



  continue:
  addl $8, %eax
  popl %ecx
  inc %ecx
  cmp %ecx, $32
  jge handlers_loop

  popal
  popl %gs
  popl %fs
  popl %es
  popl %ds
  addl $0x8, %esp  # trapno and errcode
  iret  
