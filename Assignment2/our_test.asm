
_our_test:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  }
  printf(1,"All Tests passed\n");
  exit();
}

int main(int argc, char** argv){
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	53                   	push   %ebx
  12:	bb 14 00 00 00       	mov    $0x14,%ebx
  17:	51                   	push   %ecx
  18:	eb 1e                	jmp    38 <main+0x38>
  1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    for (int i = 0; i < 20; i++){
        int pid = fork();
        if (pid != 0){
            printf(1, "%d\n", pid);
  20:	83 ec 04             	sub    $0x4,%esp
  23:	50                   	push   %eax
  24:	68 da 0c 00 00       	push   $0xcda
  29:	6a 01                	push   $0x1
  2b:	e8 c0 08 00 00       	call   8f0 <printf>
    for (int i = 0; i < 20; i++){
  30:	83 c4 10             	add    $0x10,%esp
  33:	83 eb 01             	sub    $0x1,%ebx
  36:	74 0e                	je     46 <main+0x46>
        int pid = fork();
  38:	e8 3e 07 00 00       	call   77b <fork>
        if (pid != 0){
  3d:	85 c0                	test   %eax,%eax
  3f:	75 df                	jne    20 <main+0x20>
        }
        else{
            wait();
  41:	e8 45 07 00 00       	call   78b <wait>
            break;
        }
    }
    wait();
  46:	e8 40 07 00 00       	call   78b <wait>
    exit();
  4b:	e8 33 07 00 00       	call   783 <exit>

00000050 <action_handler>:
void action_handler(int signum){
  50:	f3 0f 1e fb          	endbr32 
  54:	55                   	push   %ebp
  55:	89 e5                	mov    %esp,%ebp
  57:	83 ec 0c             	sub    $0xc,%esp
    printf(1, "SIGNAL %d HANDLED\n", signum);
  5a:	ff 75 08             	pushl  0x8(%ebp)
  5d:	68 58 0c 00 00       	push   $0xc58
  62:	6a 01                	push   $0x1
  64:	e8 87 08 00 00       	call   8f0 <printf>
    return;
  69:	83 c4 10             	add    $0x10,%esp
}
  6c:	c9                   	leave  
  6d:	c3                   	ret    
  6e:	66 90                	xchg   %ax,%ax

00000070 <main4>:
int main4(int argc, char** argv){
  70:	f3 0f 1e fb          	endbr32 
  74:	55                   	push   %ebp
  75:	89 e5                	mov    %esp,%ebp
  77:	57                   	push   %edi
  ushort ss;
  ushort padding6;
};

static inline int cas(volatile void* addr, int expected, int newval){
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
  78:	bf 02 00 00 00       	mov    $0x2,%edi
  7d:	56                   	push   %esi
  7e:	be 03 00 00 00       	mov    $0x3,%esi
  83:	53                   	push   %ebx
  84:	8d 5d e4             	lea    -0x1c(%ebp),%ebx
  87:	83 ec 38             	sub    $0x38,%esp
  a = 1; b = 2; c = 3;
  8a:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  printf(1,"a %d b %d c %d\n",a,b,c);
  91:	6a 03                	push   $0x3
  93:	6a 02                	push   $0x2
  95:	6a 01                	push   $0x1
  97:	68 6b 0c 00 00       	push   $0xc6b
  9c:	6a 01                	push   $0x1
  9e:	e8 4d 08 00 00       	call   8f0 <printf>
  a3:	89 f8                	mov    %edi,%eax
  a5:	f0 0f b1 33          	lock cmpxchg %esi,(%ebx)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  a9:	9c                   	pushf  
  aa:	58                   	pop    %eax
  printf(1,"ret %d, a %d \n\n",ret, a);
  ab:	83 c4 20             	add    $0x20,%esp
 : :"r" (addr), "a" (expected), "r" (newval));
  return (readeflags() & 0x0040);
  ae:	83 e0 40             	and    $0x40,%eax
  b1:	ff 75 e4             	pushl  -0x1c(%ebp)
  b4:	50                   	push   %eax
  b5:	68 7b 0c 00 00       	push   $0xc7b
  ba:	6a 01                	push   $0x1
  bc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  bf:	e8 2c 08 00 00       	call   8f0 <printf>
  if(ret){
  c4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  c7:	83 c4 10             	add    $0x10,%esp
  ca:	85 c0                	test   %eax,%eax
  cc:	74 14                	je     e2 <main4+0x72>
    printf(1,"Case %d Fail\n ",i);
  ce:	50                   	push   %eax
  cf:	6a 01                	push   $0x1
  d1:	68 8b 0c 00 00       	push   $0xc8b
  d6:	6a 01                	push   $0x1
  d8:	e8 13 08 00 00       	call   8f0 <printf>
    exit();
  dd:	e8 a1 06 00 00       	call   783 <exit>
  printf(1,"a %d b %d c %d\n",a,b,c);
  e2:	83 ec 0c             	sub    $0xc,%esp
  a = 2; b = 2; c = 3;
  e5:	c7 45 e4 02 00 00 00 	movl   $0x2,-0x1c(%ebp)
  printf(1,"a %d b %d c %d\n",a,b,c);
  ec:	6a 03                	push   $0x3
  ee:	6a 02                	push   $0x2
  f0:	6a 02                	push   $0x2
  f2:	68 6b 0c 00 00       	push   $0xc6b
  f7:	6a 01                	push   $0x1
  f9:	e8 f2 07 00 00       	call   8f0 <printf>
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
  fe:	89 f8                	mov    %edi,%eax
 100:	f0 0f b1 33          	lock cmpxchg %esi,(%ebx)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
 104:	9c                   	pushf  
 105:	58                   	pop    %eax
  printf(1,"ret %d, a %d \n\n",ret, a);
 106:	83 c4 20             	add    $0x20,%esp
  return (readeflags() & 0x0040);
 109:	83 e0 40             	and    $0x40,%eax
 10c:	ff 75 e4             	pushl  -0x1c(%ebp)
 10f:	50                   	push   %eax
 110:	68 7b 0c 00 00       	push   $0xc7b
 115:	6a 01                	push   $0x1
 117:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 11a:	e8 d1 07 00 00       	call   8f0 <printf>
  if(!ret){
 11f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 122:	83 c4 10             	add    $0x10,%esp
 125:	85 c0                	test   %eax,%eax
 127:	75 14                	jne    13d <main4+0xcd>
    printf(1,"Case %d Fail\n ",i);
 129:	50                   	push   %eax
 12a:	6a 02                	push   $0x2
 12c:	68 8b 0c 00 00       	push   $0xc8b
 131:	6a 01                	push   $0x1
 133:	e8 b8 07 00 00       	call   8f0 <printf>
    exit();
 138:	e8 46 06 00 00       	call   783 <exit>
  printf(1,"a %d b %d c %d\n",a,b,c);
 13d:	83 ec 0c             	sub    $0xc,%esp
  a = 3; b = 2; c = 3;
 140:	c7 45 e4 03 00 00 00 	movl   $0x3,-0x1c(%ebp)
  printf(1,"a %d b %d c %d\n",a,b,c);
 147:	6a 03                	push   $0x3
 149:	6a 02                	push   $0x2
 14b:	6a 03                	push   $0x3
 14d:	68 6b 0c 00 00       	push   $0xc6b
 152:	6a 01                	push   $0x1
 154:	e8 97 07 00 00       	call   8f0 <printf>
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
 159:	89 f8                	mov    %edi,%eax
 15b:	f0 0f b1 33          	lock cmpxchg %esi,(%ebx)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
 15f:	9c                   	pushf  
 160:	5f                   	pop    %edi
  printf(1,"ret %d, a %d \n\n",ret, a);
 161:	83 c4 20             	add    $0x20,%esp
  return (readeflags() & 0x0040);
 164:	83 e7 40             	and    $0x40,%edi
 167:	ff 75 e4             	pushl  -0x1c(%ebp)
 16a:	57                   	push   %edi
 16b:	68 7b 0c 00 00       	push   $0xc7b
 170:	6a 01                	push   $0x1
 172:	e8 79 07 00 00       	call   8f0 <printf>
  if(ret){
 177:	83 c4 10             	add    $0x10,%esp
 17a:	85 ff                	test   %edi,%edi
 17c:	75 60                	jne    1de <main4+0x16e>
  printf(1,"a %d b %d c %d\n",a,b,c);
 17e:	83 ec 0c             	sub    $0xc,%esp
  a = 3; b = 3; c = 30;
 181:	c7 45 e4 03 00 00 00 	movl   $0x3,-0x1c(%ebp)
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
 188:	bf 1e 00 00 00       	mov    $0x1e,%edi
  printf(1,"a %d b %d c %d\n",a,b,c);
 18d:	6a 1e                	push   $0x1e
 18f:	6a 03                	push   $0x3
 191:	6a 03                	push   $0x3
 193:	68 6b 0c 00 00       	push   $0xc6b
 198:	6a 01                	push   $0x1
 19a:	e8 51 07 00 00       	call   8f0 <printf>
 19f:	89 f0                	mov    %esi,%eax
 1a1:	f0 0f b1 3b          	lock cmpxchg %edi,(%ebx)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
 1a5:	9c                   	pushf  
 1a6:	58                   	pop    %eax
  printf(1,"ret %d, a %d \n\n",ret, a);
 1a7:	83 c4 20             	add    $0x20,%esp
  return (readeflags() & 0x0040);
 1aa:	83 e0 40             	and    $0x40,%eax
 1ad:	ff 75 e4             	pushl  -0x1c(%ebp)
 1b0:	50                   	push   %eax
 1b1:	68 7b 0c 00 00       	push   $0xc7b
 1b6:	6a 01                	push   $0x1
 1b8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 1bb:	e8 30 07 00 00       	call   8f0 <printf>
  if(!ret){
 1c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 1c3:	83 c4 10             	add    $0x10,%esp
 1c6:	85 c0                	test   %eax,%eax
 1c8:	75 28                	jne    1f2 <main4+0x182>
    printf(1,"Case %d Fail\n ",i);
 1ca:	56                   	push   %esi
 1cb:	6a 04                	push   $0x4
 1cd:	68 8b 0c 00 00       	push   $0xc8b
 1d2:	6a 01                	push   $0x1
 1d4:	e8 17 07 00 00       	call   8f0 <printf>
    exit();
 1d9:	e8 a5 05 00 00       	call   783 <exit>
    printf(1,"Case %d Fail\n ",i);
 1de:	57                   	push   %edi
 1df:	6a 03                	push   $0x3
 1e1:	68 8b 0c 00 00       	push   $0xc8b
 1e6:	6a 01                	push   $0x1
 1e8:	e8 03 07 00 00       	call   8f0 <printf>
    exit();
 1ed:	e8 91 05 00 00       	call   783 <exit>
  printf(1,"a %d b %d c %d\n",a,b,c);
 1f2:	83 ec 0c             	sub    $0xc,%esp
  a = 2; b = 4; c = 3;
 1f5:	c7 45 e4 02 00 00 00 	movl   $0x2,-0x1c(%ebp)
  printf(1,"a %d b %d c %d\n",a,b,c);
 1fc:	6a 03                	push   $0x3
 1fe:	6a 04                	push   $0x4
 200:	6a 02                	push   $0x2
 202:	68 6b 0c 00 00       	push   $0xc6b
 207:	6a 01                	push   $0x1
 209:	e8 e2 06 00 00       	call   8f0 <printf>
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
 20e:	b8 04 00 00 00       	mov    $0x4,%eax
 213:	f0 0f b1 33          	lock cmpxchg %esi,(%ebx)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
 217:	9c                   	pushf  
 218:	5e                   	pop    %esi
  printf(1,"ret %d, a %d \n\n",ret, a);
 219:	83 c4 20             	add    $0x20,%esp
  return (readeflags() & 0x0040);
 21c:	83 e6 40             	and    $0x40,%esi
 21f:	ff 75 e4             	pushl  -0x1c(%ebp)
 222:	56                   	push   %esi
 223:	68 7b 0c 00 00       	push   $0xc7b
 228:	6a 01                	push   $0x1
 22a:	e8 c1 06 00 00       	call   8f0 <printf>
  if(ret){
 22f:	83 c4 10             	add    $0x10,%esp
 232:	85 f6                	test   %esi,%esi
 234:	75 58                	jne    28e <main4+0x21e>
  printf(1,"a %d b %d c %d\n",a,b,c);
 236:	83 ec 0c             	sub    $0xc,%esp
   a = 3; b = 4; c = 30;
 239:	c7 45 e4 03 00 00 00 	movl   $0x3,-0x1c(%ebp)
  printf(1,"a %d b %d c %d\n",a,b,c);
 240:	6a 1e                	push   $0x1e
 242:	6a 04                	push   $0x4
 244:	6a 03                	push   $0x3
 246:	68 6b 0c 00 00       	push   $0xc6b
 24b:	6a 01                	push   $0x1
 24d:	e8 9e 06 00 00       	call   8f0 <printf>
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
 252:	b8 04 00 00 00       	mov    $0x4,%eax
 257:	f0 0f b1 3b          	lock cmpxchg %edi,(%ebx)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
 25b:	9c                   	pushf  
 25c:	5e                   	pop    %esi
  printf(1,"ret %d, a %d \n\n",ret, a);
 25d:	83 c4 20             	add    $0x20,%esp
  return (readeflags() & 0x0040);
 260:	83 e6 40             	and    $0x40,%esi
 263:	ff 75 e4             	pushl  -0x1c(%ebp)
 266:	56                   	push   %esi
 267:	68 7b 0c 00 00       	push   $0xc7b
 26c:	6a 01                	push   $0x1
 26e:	e8 7d 06 00 00       	call   8f0 <printf>
  if(ret){
 273:	83 c4 10             	add    $0x10,%esp
 276:	85 f6                	test   %esi,%esi
 278:	74 28                	je     2a2 <main4+0x232>
    printf(1,"Case %d Fail\n ",i);
 27a:	51                   	push   %ecx
 27b:	6a 06                	push   $0x6
 27d:	68 8b 0c 00 00       	push   $0xc8b
 282:	6a 01                	push   $0x1
 284:	e8 67 06 00 00       	call   8f0 <printf>
    exit();
 289:	e8 f5 04 00 00       	call   783 <exit>
    printf(1,"Case i %d Fail\n ",i);
 28e:	53                   	push   %ebx
 28f:	6a 05                	push   $0x5
 291:	68 9a 0c 00 00       	push   $0xc9a
 296:	6a 01                	push   $0x1
 298:	e8 53 06 00 00       	call   8f0 <printf>
    exit();
 29d:	e8 e1 04 00 00       	call   783 <exit>
  printf(1,"a %d b %d c %d\n",a,b,c);
 2a2:	83 ec 0c             	sub    $0xc,%esp
   a = 4; b = 4; c = 30;
 2a5:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
  printf(1,"a %d b %d c %d\n",a,b,c);
 2ac:	6a 1e                	push   $0x1e
 2ae:	6a 04                	push   $0x4
 2b0:	6a 04                	push   $0x4
 2b2:	68 6b 0c 00 00       	push   $0xc6b
 2b7:	6a 01                	push   $0x1
 2b9:	e8 32 06 00 00       	call   8f0 <printf>
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
 2be:	b8 04 00 00 00       	mov    $0x4,%eax
 2c3:	f0 0f b1 3b          	lock cmpxchg %edi,(%ebx)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
 2c7:	9c                   	pushf  
 2c8:	5b                   	pop    %ebx
  printf(1,"ret %d, a %d \n\n",ret, a);
 2c9:	83 c4 20             	add    $0x20,%esp
  return (readeflags() & 0x0040);
 2cc:	83 e3 40             	and    $0x40,%ebx
 2cf:	ff 75 e4             	pushl  -0x1c(%ebp)
 2d2:	53                   	push   %ebx
 2d3:	68 7b 0c 00 00       	push   $0xc7b
 2d8:	6a 01                	push   $0x1
 2da:	e8 11 06 00 00       	call   8f0 <printf>
  if(!ret){
 2df:	83 c4 10             	add    $0x10,%esp
 2e2:	85 db                	test   %ebx,%ebx
 2e4:	75 14                	jne    2fa <main4+0x28a>
    printf(1,"Case %d Fail\n ",i);
 2e6:	52                   	push   %edx
 2e7:	6a 07                	push   $0x7
 2e9:	68 8b 0c 00 00       	push   $0xc8b
 2ee:	6a 01                	push   $0x1
 2f0:	e8 fb 05 00 00       	call   8f0 <printf>
    exit();
 2f5:	e8 89 04 00 00       	call   783 <exit>
  printf(1,"All Tests passed\n");
 2fa:	50                   	push   %eax
 2fb:	50                   	push   %eax
 2fc:	68 ab 0c 00 00       	push   $0xcab
 301:	6a 01                	push   $0x1
 303:	e8 e8 05 00 00       	call   8f0 <printf>
  exit();
 308:	e8 76 04 00 00       	call   783 <exit>
 30d:	8d 76 00             	lea    0x0(%esi),%esi

00000310 <main1>:
}

int main1(int argc, char** argv){
 310:	f3 0f 1e fb          	endbr32 
 314:	55                   	push   %ebp
 315:	89 e5                	mov    %esp,%ebp
 317:	53                   	push   %ebx
    struct sigaction sigact = {action_handler, 0};
    sigaction(1, &sigact, null);
 318:	8d 45 f0             	lea    -0x10(%ebp),%eax
int main1(int argc, char** argv){
 31b:	83 ec 18             	sub    $0x18,%esp
    struct sigaction sigact = {action_handler, 0};
 31e:	c7 45 f0 50 00 00 00 	movl   $0x50,-0x10(%ebp)
    sigaction(1, &sigact, null);
 325:	6a 00                	push   $0x0
 327:	50                   	push   %eax
 328:	6a 01                	push   $0x1
    struct sigaction sigact = {action_handler, 0};
 32a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    sigaction(1, &sigact, null);
 331:	e8 f5 04 00 00       	call   82b <sigaction>
    kill(getpid(), 1);
 336:	e8 c8 04 00 00       	call   803 <getpid>
 33b:	5a                   	pop    %edx
 33c:	59                   	pop    %ecx
 33d:	6a 01                	push   $0x1
 33f:	50                   	push   %eax
 340:	e8 6e 04 00 00       	call   7b3 <kill>
    kill(getpid(), 9);
 345:	e8 b9 04 00 00       	call   803 <getpid>
 34a:	5b                   	pop    %ebx
 34b:	5a                   	pop    %edx
 34c:	6a 09                	push   $0x9
 34e:	50                   	push   %eax

    for (int i = 0; i < 1000000; i++){
 34f:	31 db                	xor    %ebx,%ebx
    kill(getpid(), 9);
 351:	e8 5d 04 00 00       	call   7b3 <kill>
 356:	83 c4 10             	add    $0x10,%esp
 359:	eb 22                	jmp    37d <main1+0x6d>
 35b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 35f:	90                   	nop
            if (i % 1000 == 0){
                printf(1, "hi\n");
            }
            printf(1, "");
 360:	83 ec 08             	sub    $0x8,%esp
    for (int i = 0; i < 1000000; i++){
 363:	83 c3 01             	add    $0x1,%ebx
            printf(1, "");
 366:	68 8a 0c 00 00       	push   $0xc8a
 36b:	6a 01                	push   $0x1
 36d:	e8 7e 05 00 00       	call   8f0 <printf>
    for (int i = 0; i < 1000000; i++){
 372:	83 c4 10             	add    $0x10,%esp
 375:	81 fb 40 42 0f 00    	cmp    $0xf4240,%ebx
 37b:	74 24                	je     3a1 <main1+0x91>
    kill(getpid(), 9);
 37d:	69 c3 d5 78 e9 26    	imul   $0x26e978d5,%ebx,%eax
 383:	c1 c8 03             	ror    $0x3,%eax
            if (i % 1000 == 0){
 386:	3d 37 89 41 00       	cmp    $0x418937,%eax
 38b:	77 d3                	ja     360 <main1+0x50>
                printf(1, "hi\n");
 38d:	83 ec 08             	sub    $0x8,%esp
 390:	68 bd 0c 00 00       	push   $0xcbd
 395:	6a 01                	push   $0x1
 397:	e8 54 05 00 00       	call   8f0 <printf>
 39c:	83 c4 10             	add    $0x10,%esp
 39f:	eb bf                	jmp    360 <main1+0x50>
        }
    return 0;
}
 3a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 3a4:	31 c0                	xor    %eax,%eax
 3a6:	c9                   	leave  
 3a7:	c3                   	ret    
 3a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3af:	90                   	nop

000003b0 <main2>:

int main2(int argc, char** argv){
 3b0:	f3 0f 1e fb          	endbr32 
 3b4:	55                   	push   %ebp
 3b5:	89 e5                	mov    %esp,%ebp
 3b7:	56                   	push   %esi
 3b8:	53                   	push   %ebx
 3b9:	83 ec 10             	sub    $0x10,%esp
    struct sigaction sigact = {action_handler, 0};
 3bc:	c7 45 f0 50 00 00 00 	movl   $0x50,-0x10(%ebp)
 3c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int pid = fork();
 3ca:	e8 ac 03 00 00       	call   77b <fork>
 3cf:	89 c3                	mov    %eax,%ebx
    if (pid == 0){
 3d1:	85 c0                	test   %eax,%eax
 3d3:	0f 85 8c 00 00 00    	jne    465 <main2+0xb5>
        printf(1, "childs here");
 3d9:	50                   	push   %eax
        sigaction(1, &sigact, null);
 3da:	8d 75 f0             	lea    -0x10(%ebp),%esi
        printf(1, "childs here");
 3dd:	50                   	push   %eax
 3de:	68 c1 0c 00 00       	push   $0xcc1
 3e3:	6a 01                	push   $0x1
 3e5:	e8 06 05 00 00       	call   8f0 <printf>
        sigaction(1, &sigact, null);
 3ea:	83 c4 0c             	add    $0xc,%esp
 3ed:	6a 00                	push   $0x0
 3ef:	56                   	push   %esi
 3f0:	6a 01                	push   $0x1
 3f2:	e8 34 04 00 00       	call   82b <sigaction>
        sigaction(2, &sigact, null);
 3f7:	83 c4 0c             	add    $0xc,%esp
 3fa:	6a 00                	push   $0x0
 3fc:	56                   	push   %esi
 3fd:	6a 02                	push   $0x2
 3ff:	e8 27 04 00 00       	call   82b <sigaction>
        sigaction(3, &sigact, null);
 404:	83 c4 0c             	add    $0xc,%esp
 407:	6a 00                	push   $0x0
 409:	56                   	push   %esi
 40a:	6a 03                	push   $0x3
 40c:	e8 1a 04 00 00       	call   82b <sigaction>
 411:	83 c4 10             	add    $0x10,%esp
 414:	eb 2b                	jmp    441 <main2+0x91>
 416:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 41d:	8d 76 00             	lea    0x0(%esi),%esi
        for (int i = 0; i < 1000000; i++){
            if (i % 1000 == 0){
                printf(1, "hi\n");
            }
            printf(1, "");
 420:	83 ec 08             	sub    $0x8,%esp
        for (int i = 0; i < 1000000; i++){
 423:	83 c3 01             	add    $0x1,%ebx
            printf(1, "");
 426:	68 8a 0c 00 00       	push   $0xc8a
 42b:	6a 01                	push   $0x1
 42d:	e8 be 04 00 00       	call   8f0 <printf>
        for (int i = 0; i < 1000000; i++){
 432:	83 c4 10             	add    $0x10,%esp
 435:	81 fb 40 42 0f 00    	cmp    $0xf4240,%ebx
 43b:	0f 84 d1 00 00 00    	je     512 <main2+0x162>
        sigaction(3, &sigact, null);
 441:	69 c3 d5 78 e9 26    	imul   $0x26e978d5,%ebx,%eax
 447:	c1 c8 03             	ror    $0x3,%eax
            if (i % 1000 == 0){
 44a:	3d 37 89 41 00       	cmp    $0x418937,%eax
 44f:	77 cf                	ja     420 <main2+0x70>
                printf(1, "hi\n");
 451:	83 ec 08             	sub    $0x8,%esp
 454:	68 bd 0c 00 00       	push   $0xcbd
 459:	6a 01                	push   $0x1
 45b:	e8 90 04 00 00       	call   8f0 <printf>
 460:	83 c4 10             	add    $0x10,%esp
 463:	eb bb                	jmp    420 <main2+0x70>
        }
    }
    else{
        printf(1, "childs pid : %d\n", pid);
 465:	50                   	push   %eax
 466:	53                   	push   %ebx
 467:	68 cd 0c 00 00       	push   $0xccd
 46c:	6a 01                	push   $0x1
 46e:	e8 7d 04 00 00       	call   8f0 <printf>
        sleep(100);
 473:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
 47a:	e8 94 03 00 00       	call   813 <sleep>
        printf(1, "sending signal %d to child\n", 1);
 47f:	83 c4 0c             	add    $0xc,%esp
 482:	6a 01                	push   $0x1
 484:	68 de 0c 00 00       	push   $0xcde
 489:	6a 01                	push   $0x1
 48b:	e8 60 04 00 00       	call   8f0 <printf>
        kill(pid, 1);
 490:	5a                   	pop    %edx
 491:	59                   	pop    %ecx
 492:	6a 01                	push   $0x1
 494:	53                   	push   %ebx
 495:	e8 19 03 00 00       	call   7b3 <kill>
        sleep(100);
 49a:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
 4a1:	e8 6d 03 00 00       	call   813 <sleep>
        printf(1, "sending signal %d to child\n", 2);
 4a6:	83 c4 0c             	add    $0xc,%esp
 4a9:	6a 02                	push   $0x2
 4ab:	68 de 0c 00 00       	push   $0xcde
 4b0:	6a 01                	push   $0x1
 4b2:	e8 39 04 00 00       	call   8f0 <printf>
        kill(pid, 2);
 4b7:	5e                   	pop    %esi
 4b8:	58                   	pop    %eax
 4b9:	6a 02                	push   $0x2
 4bb:	53                   	push   %ebx
 4bc:	e8 f2 02 00 00       	call   7b3 <kill>
        sleep(100);
 4c1:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
 4c8:	e8 46 03 00 00       	call   813 <sleep>
        printf(1, "sending signal %d to child\n", 3);
 4cd:	83 c4 0c             	add    $0xc,%esp
 4d0:	6a 03                	push   $0x3
 4d2:	68 de 0c 00 00       	push   $0xcde
 4d7:	6a 01                	push   $0x1
 4d9:	e8 12 04 00 00       	call   8f0 <printf>
        kill(pid, 3);
 4de:	58                   	pop    %eax
 4df:	5a                   	pop    %edx
 4e0:	6a 03                	push   $0x3
 4e2:	53                   	push   %ebx
 4e3:	e8 cb 02 00 00       	call   7b3 <kill>
        sleep(100);
 4e8:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
 4ef:	e8 1f 03 00 00       	call   813 <sleep>
        kill(pid, 9);
 4f4:	59                   	pop    %ecx
 4f5:	5e                   	pop    %esi
 4f6:	6a 09                	push   $0x9
 4f8:	53                   	push   %ebx
 4f9:	e8 b5 02 00 00       	call   7b3 <kill>

        wait();
 4fe:	e8 88 02 00 00       	call   78b <wait>
        sleep(300);
 503:	c7 04 24 2c 01 00 00 	movl   $0x12c,(%esp)
 50a:	e8 04 03 00 00       	call   813 <sleep>
 50f:	83 c4 10             	add    $0x10,%esp


    }
    exit();
 512:	e8 6c 02 00 00       	call   783 <exit>
 517:	66 90                	xchg   %ax,%ax
 519:	66 90                	xchg   %ax,%ax
 51b:	66 90                	xchg   %ax,%ax
 51d:	66 90                	xchg   %ax,%ax
 51f:	90                   	nop

00000520 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 520:	f3 0f 1e fb          	endbr32 
 524:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 525:	31 c0                	xor    %eax,%eax
{
 527:	89 e5                	mov    %esp,%ebp
 529:	53                   	push   %ebx
 52a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 52d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
 530:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 534:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 537:	83 c0 01             	add    $0x1,%eax
 53a:	84 d2                	test   %dl,%dl
 53c:	75 f2                	jne    530 <strcpy+0x10>
    ;
  return os;
}
 53e:	89 c8                	mov    %ecx,%eax
 540:	5b                   	pop    %ebx
 541:	5d                   	pop    %ebp
 542:	c3                   	ret    
 543:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 54a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000550 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 550:	f3 0f 1e fb          	endbr32 
 554:	55                   	push   %ebp
 555:	89 e5                	mov    %esp,%ebp
 557:	53                   	push   %ebx
 558:	8b 4d 08             	mov    0x8(%ebp),%ecx
 55b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 55e:	0f b6 01             	movzbl (%ecx),%eax
 561:	0f b6 1a             	movzbl (%edx),%ebx
 564:	84 c0                	test   %al,%al
 566:	75 19                	jne    581 <strcmp+0x31>
 568:	eb 26                	jmp    590 <strcmp+0x40>
 56a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 570:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 574:	83 c1 01             	add    $0x1,%ecx
 577:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 57a:	0f b6 1a             	movzbl (%edx),%ebx
 57d:	84 c0                	test   %al,%al
 57f:	74 0f                	je     590 <strcmp+0x40>
 581:	38 d8                	cmp    %bl,%al
 583:	74 eb                	je     570 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 585:	29 d8                	sub    %ebx,%eax
}
 587:	5b                   	pop    %ebx
 588:	5d                   	pop    %ebp
 589:	c3                   	ret    
 58a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 590:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 592:	29 d8                	sub    %ebx,%eax
}
 594:	5b                   	pop    %ebx
 595:	5d                   	pop    %ebp
 596:	c3                   	ret    
 597:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 59e:	66 90                	xchg   %ax,%ax

000005a0 <strlen>:

uint
strlen(const char *s)
{
 5a0:	f3 0f 1e fb          	endbr32 
 5a4:	55                   	push   %ebp
 5a5:	89 e5                	mov    %esp,%ebp
 5a7:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 5aa:	80 3a 00             	cmpb   $0x0,(%edx)
 5ad:	74 21                	je     5d0 <strlen+0x30>
 5af:	31 c0                	xor    %eax,%eax
 5b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5b8:	83 c0 01             	add    $0x1,%eax
 5bb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 5bf:	89 c1                	mov    %eax,%ecx
 5c1:	75 f5                	jne    5b8 <strlen+0x18>
    ;
  return n;
}
 5c3:	89 c8                	mov    %ecx,%eax
 5c5:	5d                   	pop    %ebp
 5c6:	c3                   	ret    
 5c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5ce:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
 5d0:	31 c9                	xor    %ecx,%ecx
}
 5d2:	5d                   	pop    %ebp
 5d3:	89 c8                	mov    %ecx,%eax
 5d5:	c3                   	ret    
 5d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5dd:	8d 76 00             	lea    0x0(%esi),%esi

000005e0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 5e0:	f3 0f 1e fb          	endbr32 
 5e4:	55                   	push   %ebp
 5e5:	89 e5                	mov    %esp,%ebp
 5e7:	57                   	push   %edi
 5e8:	8b 55 08             	mov    0x8(%ebp),%edx
  asm volatile("cld; rep stosb" :
 5eb:	8b 4d 10             	mov    0x10(%ebp),%ecx
 5ee:	8b 45 0c             	mov    0xc(%ebp),%eax
 5f1:	89 d7                	mov    %edx,%edi
 5f3:	fc                   	cld    
 5f4:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 5f6:	89 d0                	mov    %edx,%eax
 5f8:	5f                   	pop    %edi
 5f9:	5d                   	pop    %ebp
 5fa:	c3                   	ret    
 5fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 5ff:	90                   	nop

00000600 <strchr>:

char*
strchr(const char *s, char c)
{
 600:	f3 0f 1e fb          	endbr32 
 604:	55                   	push   %ebp
 605:	89 e5                	mov    %esp,%ebp
 607:	8b 45 08             	mov    0x8(%ebp),%eax
 60a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 60e:	0f b6 10             	movzbl (%eax),%edx
 611:	84 d2                	test   %dl,%dl
 613:	75 16                	jne    62b <strchr+0x2b>
 615:	eb 21                	jmp    638 <strchr+0x38>
 617:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 61e:	66 90                	xchg   %ax,%ax
 620:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 624:	83 c0 01             	add    $0x1,%eax
 627:	84 d2                	test   %dl,%dl
 629:	74 0d                	je     638 <strchr+0x38>
    if(*s == c)
 62b:	38 d1                	cmp    %dl,%cl
 62d:	75 f1                	jne    620 <strchr+0x20>
      return (char*)s;
  return 0;
}
 62f:	5d                   	pop    %ebp
 630:	c3                   	ret    
 631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 638:	31 c0                	xor    %eax,%eax
}
 63a:	5d                   	pop    %ebp
 63b:	c3                   	ret    
 63c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000640 <gets>:

char*
gets(char *buf, int max)
{
 640:	f3 0f 1e fb          	endbr32 
 644:	55                   	push   %ebp
 645:	89 e5                	mov    %esp,%ebp
 647:	57                   	push   %edi
 648:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 649:	31 f6                	xor    %esi,%esi
{
 64b:	53                   	push   %ebx
 64c:	89 f3                	mov    %esi,%ebx
 64e:	83 ec 1c             	sub    $0x1c,%esp
 651:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 654:	eb 33                	jmp    689 <gets+0x49>
 656:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 65d:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 660:	83 ec 04             	sub    $0x4,%esp
 663:	8d 45 e7             	lea    -0x19(%ebp),%eax
 666:	6a 01                	push   $0x1
 668:	50                   	push   %eax
 669:	6a 00                	push   $0x0
 66b:	e8 2b 01 00 00       	call   79b <read>
    if(cc < 1)
 670:	83 c4 10             	add    $0x10,%esp
 673:	85 c0                	test   %eax,%eax
 675:	7e 1c                	jle    693 <gets+0x53>
      break;
    buf[i++] = c;
 677:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 67b:	83 c7 01             	add    $0x1,%edi
 67e:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 681:	3c 0a                	cmp    $0xa,%al
 683:	74 23                	je     6a8 <gets+0x68>
 685:	3c 0d                	cmp    $0xd,%al
 687:	74 1f                	je     6a8 <gets+0x68>
  for(i=0; i+1 < max; ){
 689:	83 c3 01             	add    $0x1,%ebx
 68c:	89 fe                	mov    %edi,%esi
 68e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 691:	7c cd                	jl     660 <gets+0x20>
 693:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 695:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 698:	c6 03 00             	movb   $0x0,(%ebx)
}
 69b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 69e:	5b                   	pop    %ebx
 69f:	5e                   	pop    %esi
 6a0:	5f                   	pop    %edi
 6a1:	5d                   	pop    %ebp
 6a2:	c3                   	ret    
 6a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6a7:	90                   	nop
 6a8:	8b 75 08             	mov    0x8(%ebp),%esi
 6ab:	8b 45 08             	mov    0x8(%ebp),%eax
 6ae:	01 de                	add    %ebx,%esi
 6b0:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 6b2:	c6 03 00             	movb   $0x0,(%ebx)
}
 6b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6b8:	5b                   	pop    %ebx
 6b9:	5e                   	pop    %esi
 6ba:	5f                   	pop    %edi
 6bb:	5d                   	pop    %ebp
 6bc:	c3                   	ret    
 6bd:	8d 76 00             	lea    0x0(%esi),%esi

000006c0 <stat>:

int
stat(const char *n, struct stat *st)
{
 6c0:	f3 0f 1e fb          	endbr32 
 6c4:	55                   	push   %ebp
 6c5:	89 e5                	mov    %esp,%ebp
 6c7:	56                   	push   %esi
 6c8:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 6c9:	83 ec 08             	sub    $0x8,%esp
 6cc:	6a 00                	push   $0x0
 6ce:	ff 75 08             	pushl  0x8(%ebp)
 6d1:	e8 ed 00 00 00       	call   7c3 <open>
  if(fd < 0)
 6d6:	83 c4 10             	add    $0x10,%esp
 6d9:	85 c0                	test   %eax,%eax
 6db:	78 2b                	js     708 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 6dd:	83 ec 08             	sub    $0x8,%esp
 6e0:	ff 75 0c             	pushl  0xc(%ebp)
 6e3:	89 c3                	mov    %eax,%ebx
 6e5:	50                   	push   %eax
 6e6:	e8 f0 00 00 00       	call   7db <fstat>
  close(fd);
 6eb:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 6ee:	89 c6                	mov    %eax,%esi
  close(fd);
 6f0:	e8 b6 00 00 00       	call   7ab <close>
  return r;
 6f5:	83 c4 10             	add    $0x10,%esp
}
 6f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
 6fb:	89 f0                	mov    %esi,%eax
 6fd:	5b                   	pop    %ebx
 6fe:	5e                   	pop    %esi
 6ff:	5d                   	pop    %ebp
 700:	c3                   	ret    
 701:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 708:	be ff ff ff ff       	mov    $0xffffffff,%esi
 70d:	eb e9                	jmp    6f8 <stat+0x38>
 70f:	90                   	nop

00000710 <atoi>:

int
atoi(const char *s)
{
 710:	f3 0f 1e fb          	endbr32 
 714:	55                   	push   %ebp
 715:	89 e5                	mov    %esp,%ebp
 717:	53                   	push   %ebx
 718:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 71b:	0f be 02             	movsbl (%edx),%eax
 71e:	8d 48 d0             	lea    -0x30(%eax),%ecx
 721:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 724:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 729:	77 1a                	ja     745 <atoi+0x35>
 72b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 72f:	90                   	nop
    n = n*10 + *s++ - '0';
 730:	83 c2 01             	add    $0x1,%edx
 733:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 736:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 73a:	0f be 02             	movsbl (%edx),%eax
 73d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 740:	80 fb 09             	cmp    $0x9,%bl
 743:	76 eb                	jbe    730 <atoi+0x20>
  return n;
}
 745:	89 c8                	mov    %ecx,%eax
 747:	5b                   	pop    %ebx
 748:	5d                   	pop    %ebp
 749:	c3                   	ret    
 74a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000750 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 750:	f3 0f 1e fb          	endbr32 
 754:	55                   	push   %ebp
 755:	89 e5                	mov    %esp,%ebp
 757:	57                   	push   %edi
 758:	8b 45 10             	mov    0x10(%ebp),%eax
 75b:	8b 55 08             	mov    0x8(%ebp),%edx
 75e:	56                   	push   %esi
 75f:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 762:	85 c0                	test   %eax,%eax
 764:	7e 0f                	jle    775 <memmove+0x25>
 766:	01 d0                	add    %edx,%eax
  dst = vdst;
 768:	89 d7                	mov    %edx,%edi
 76a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
 770:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 771:	39 f8                	cmp    %edi,%eax
 773:	75 fb                	jne    770 <memmove+0x20>
  return vdst;
}
 775:	5e                   	pop    %esi
 776:	89 d0                	mov    %edx,%eax
 778:	5f                   	pop    %edi
 779:	5d                   	pop    %ebp
 77a:	c3                   	ret    

0000077b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 77b:	b8 01 00 00 00       	mov    $0x1,%eax
 780:	cd 40                	int    $0x40
 782:	c3                   	ret    

00000783 <exit>:
SYSCALL(exit)
 783:	b8 02 00 00 00       	mov    $0x2,%eax
 788:	cd 40                	int    $0x40
 78a:	c3                   	ret    

0000078b <wait>:
SYSCALL(wait)
 78b:	b8 03 00 00 00       	mov    $0x3,%eax
 790:	cd 40                	int    $0x40
 792:	c3                   	ret    

00000793 <pipe>:
SYSCALL(pipe)
 793:	b8 04 00 00 00       	mov    $0x4,%eax
 798:	cd 40                	int    $0x40
 79a:	c3                   	ret    

0000079b <read>:
SYSCALL(read)
 79b:	b8 05 00 00 00       	mov    $0x5,%eax
 7a0:	cd 40                	int    $0x40
 7a2:	c3                   	ret    

000007a3 <write>:
SYSCALL(write)
 7a3:	b8 10 00 00 00       	mov    $0x10,%eax
 7a8:	cd 40                	int    $0x40
 7aa:	c3                   	ret    

000007ab <close>:
SYSCALL(close)
 7ab:	b8 15 00 00 00       	mov    $0x15,%eax
 7b0:	cd 40                	int    $0x40
 7b2:	c3                   	ret    

000007b3 <kill>:
SYSCALL(kill)
 7b3:	b8 06 00 00 00       	mov    $0x6,%eax
 7b8:	cd 40                	int    $0x40
 7ba:	c3                   	ret    

000007bb <exec>:
SYSCALL(exec)
 7bb:	b8 07 00 00 00       	mov    $0x7,%eax
 7c0:	cd 40                	int    $0x40
 7c2:	c3                   	ret    

000007c3 <open>:
SYSCALL(open)
 7c3:	b8 0f 00 00 00       	mov    $0xf,%eax
 7c8:	cd 40                	int    $0x40
 7ca:	c3                   	ret    

000007cb <mknod>:
SYSCALL(mknod)
 7cb:	b8 11 00 00 00       	mov    $0x11,%eax
 7d0:	cd 40                	int    $0x40
 7d2:	c3                   	ret    

000007d3 <unlink>:
SYSCALL(unlink)
 7d3:	b8 12 00 00 00       	mov    $0x12,%eax
 7d8:	cd 40                	int    $0x40
 7da:	c3                   	ret    

000007db <fstat>:
SYSCALL(fstat)
 7db:	b8 08 00 00 00       	mov    $0x8,%eax
 7e0:	cd 40                	int    $0x40
 7e2:	c3                   	ret    

000007e3 <link>:
SYSCALL(link)
 7e3:	b8 13 00 00 00       	mov    $0x13,%eax
 7e8:	cd 40                	int    $0x40
 7ea:	c3                   	ret    

000007eb <mkdir>:
SYSCALL(mkdir)
 7eb:	b8 14 00 00 00       	mov    $0x14,%eax
 7f0:	cd 40                	int    $0x40
 7f2:	c3                   	ret    

000007f3 <chdir>:
SYSCALL(chdir)
 7f3:	b8 09 00 00 00       	mov    $0x9,%eax
 7f8:	cd 40                	int    $0x40
 7fa:	c3                   	ret    

000007fb <dup>:
SYSCALL(dup)
 7fb:	b8 0a 00 00 00       	mov    $0xa,%eax
 800:	cd 40                	int    $0x40
 802:	c3                   	ret    

00000803 <getpid>:
SYSCALL(getpid)
 803:	b8 0b 00 00 00       	mov    $0xb,%eax
 808:	cd 40                	int    $0x40
 80a:	c3                   	ret    

0000080b <sbrk>:
SYSCALL(sbrk)
 80b:	b8 0c 00 00 00       	mov    $0xc,%eax
 810:	cd 40                	int    $0x40
 812:	c3                   	ret    

00000813 <sleep>:
SYSCALL(sleep)
 813:	b8 0d 00 00 00       	mov    $0xd,%eax
 818:	cd 40                	int    $0x40
 81a:	c3                   	ret    

0000081b <uptime>:
SYSCALL(uptime)
 81b:	b8 0e 00 00 00       	mov    $0xe,%eax
 820:	cd 40                	int    $0x40
 822:	c3                   	ret    

00000823 <sigprocmask>:
SYSCALL(sigprocmask)
 823:	b8 16 00 00 00       	mov    $0x16,%eax
 828:	cd 40                	int    $0x40
 82a:	c3                   	ret    

0000082b <sigaction>:
SYSCALL(sigaction)
 82b:	b8 17 00 00 00       	mov    $0x17,%eax
 830:	cd 40                	int    $0x40
 832:	c3                   	ret    

00000833 <sigret>:
SYSCALL(sigret)
 833:	b8 18 00 00 00       	mov    $0x18,%eax
 838:	cd 40                	int    $0x40
 83a:	c3                   	ret    
 83b:	66 90                	xchg   %ax,%ax
 83d:	66 90                	xchg   %ax,%ax
 83f:	90                   	nop

00000840 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 840:	55                   	push   %ebp
 841:	89 e5                	mov    %esp,%ebp
 843:	57                   	push   %edi
 844:	56                   	push   %esi
 845:	53                   	push   %ebx
 846:	83 ec 3c             	sub    $0x3c,%esp
 849:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 84c:	89 d1                	mov    %edx,%ecx
{
 84e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 851:	85 d2                	test   %edx,%edx
 853:	0f 89 7f 00 00 00    	jns    8d8 <printint+0x98>
 859:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 85d:	74 79                	je     8d8 <printint+0x98>
    neg = 1;
 85f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 866:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 868:	31 db                	xor    %ebx,%ebx
 86a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 86d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 870:	89 c8                	mov    %ecx,%eax
 872:	31 d2                	xor    %edx,%edx
 874:	89 cf                	mov    %ecx,%edi
 876:	f7 75 c4             	divl   -0x3c(%ebp)
 879:	0f b6 92 04 0d 00 00 	movzbl 0xd04(%edx),%edx
 880:	89 45 c0             	mov    %eax,-0x40(%ebp)
 883:	89 d8                	mov    %ebx,%eax
 885:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 888:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 88b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 88e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 891:	76 dd                	jbe    870 <printint+0x30>
  if(neg)
 893:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 896:	85 c9                	test   %ecx,%ecx
 898:	74 0c                	je     8a6 <printint+0x66>
    buf[i++] = '-';
 89a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 89f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 8a1:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 8a6:	8b 7d b8             	mov    -0x48(%ebp),%edi
 8a9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 8ad:	eb 07                	jmp    8b6 <printint+0x76>
 8af:	90                   	nop
 8b0:	0f b6 13             	movzbl (%ebx),%edx
 8b3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 8b6:	83 ec 04             	sub    $0x4,%esp
 8b9:	88 55 d7             	mov    %dl,-0x29(%ebp)
 8bc:	6a 01                	push   $0x1
 8be:	56                   	push   %esi
 8bf:	57                   	push   %edi
 8c0:	e8 de fe ff ff       	call   7a3 <write>
  while(--i >= 0)
 8c5:	83 c4 10             	add    $0x10,%esp
 8c8:	39 de                	cmp    %ebx,%esi
 8ca:	75 e4                	jne    8b0 <printint+0x70>
    putc(fd, buf[i]);
}
 8cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 8cf:	5b                   	pop    %ebx
 8d0:	5e                   	pop    %esi
 8d1:	5f                   	pop    %edi
 8d2:	5d                   	pop    %ebp
 8d3:	c3                   	ret    
 8d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 8d8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 8df:	eb 87                	jmp    868 <printint+0x28>
 8e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8ef:	90                   	nop

000008f0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 8f0:	f3 0f 1e fb          	endbr32 
 8f4:	55                   	push   %ebp
 8f5:	89 e5                	mov    %esp,%ebp
 8f7:	57                   	push   %edi
 8f8:	56                   	push   %esi
 8f9:	53                   	push   %ebx
 8fa:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 8fd:	8b 75 0c             	mov    0xc(%ebp),%esi
 900:	0f b6 1e             	movzbl (%esi),%ebx
 903:	84 db                	test   %bl,%bl
 905:	0f 84 b4 00 00 00    	je     9bf <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
 90b:	8d 45 10             	lea    0x10(%ebp),%eax
 90e:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 911:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 914:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 916:	89 45 d0             	mov    %eax,-0x30(%ebp)
 919:	eb 33                	jmp    94e <printf+0x5e>
 91b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 91f:	90                   	nop
 920:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 923:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 928:	83 f8 25             	cmp    $0x25,%eax
 92b:	74 17                	je     944 <printf+0x54>
  write(fd, &c, 1);
 92d:	83 ec 04             	sub    $0x4,%esp
 930:	88 5d e7             	mov    %bl,-0x19(%ebp)
 933:	6a 01                	push   $0x1
 935:	57                   	push   %edi
 936:	ff 75 08             	pushl  0x8(%ebp)
 939:	e8 65 fe ff ff       	call   7a3 <write>
 93e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 941:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 944:	0f b6 1e             	movzbl (%esi),%ebx
 947:	83 c6 01             	add    $0x1,%esi
 94a:	84 db                	test   %bl,%bl
 94c:	74 71                	je     9bf <printf+0xcf>
    c = fmt[i] & 0xff;
 94e:	0f be cb             	movsbl %bl,%ecx
 951:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 954:	85 d2                	test   %edx,%edx
 956:	74 c8                	je     920 <printf+0x30>
      }
    } else if(state == '%'){
 958:	83 fa 25             	cmp    $0x25,%edx
 95b:	75 e7                	jne    944 <printf+0x54>
      if(c == 'd'){
 95d:	83 f8 64             	cmp    $0x64,%eax
 960:	0f 84 9a 00 00 00    	je     a00 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 966:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 96c:	83 f9 70             	cmp    $0x70,%ecx
 96f:	74 5f                	je     9d0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 971:	83 f8 73             	cmp    $0x73,%eax
 974:	0f 84 d6 00 00 00    	je     a50 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 97a:	83 f8 63             	cmp    $0x63,%eax
 97d:	0f 84 8d 00 00 00    	je     a10 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 983:	83 f8 25             	cmp    $0x25,%eax
 986:	0f 84 b4 00 00 00    	je     a40 <printf+0x150>
  write(fd, &c, 1);
 98c:	83 ec 04             	sub    $0x4,%esp
 98f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 993:	6a 01                	push   $0x1
 995:	57                   	push   %edi
 996:	ff 75 08             	pushl  0x8(%ebp)
 999:	e8 05 fe ff ff       	call   7a3 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 99e:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 9a1:	83 c4 0c             	add    $0xc,%esp
 9a4:	6a 01                	push   $0x1
 9a6:	83 c6 01             	add    $0x1,%esi
 9a9:	57                   	push   %edi
 9aa:	ff 75 08             	pushl  0x8(%ebp)
 9ad:	e8 f1 fd ff ff       	call   7a3 <write>
  for(i = 0; fmt[i]; i++){
 9b2:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 9b6:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 9b9:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 9bb:	84 db                	test   %bl,%bl
 9bd:	75 8f                	jne    94e <printf+0x5e>
    }
  }
}
 9bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
 9c2:	5b                   	pop    %ebx
 9c3:	5e                   	pop    %esi
 9c4:	5f                   	pop    %edi
 9c5:	5d                   	pop    %ebp
 9c6:	c3                   	ret    
 9c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 9ce:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 9d0:	83 ec 0c             	sub    $0xc,%esp
 9d3:	b9 10 00 00 00       	mov    $0x10,%ecx
 9d8:	6a 00                	push   $0x0
 9da:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 9dd:	8b 45 08             	mov    0x8(%ebp),%eax
 9e0:	8b 13                	mov    (%ebx),%edx
 9e2:	e8 59 fe ff ff       	call   840 <printint>
        ap++;
 9e7:	89 d8                	mov    %ebx,%eax
 9e9:	83 c4 10             	add    $0x10,%esp
      state = 0;
 9ec:	31 d2                	xor    %edx,%edx
        ap++;
 9ee:	83 c0 04             	add    $0x4,%eax
 9f1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 9f4:	e9 4b ff ff ff       	jmp    944 <printf+0x54>
 9f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 a00:	83 ec 0c             	sub    $0xc,%esp
 a03:	b9 0a 00 00 00       	mov    $0xa,%ecx
 a08:	6a 01                	push   $0x1
 a0a:	eb ce                	jmp    9da <printf+0xea>
 a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 a10:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 a13:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 a16:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 a18:	6a 01                	push   $0x1
        ap++;
 a1a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 a1d:	57                   	push   %edi
 a1e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 a21:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 a24:	e8 7a fd ff ff       	call   7a3 <write>
        ap++;
 a29:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 a2c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 a2f:	31 d2                	xor    %edx,%edx
 a31:	e9 0e ff ff ff       	jmp    944 <printf+0x54>
 a36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a3d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 a40:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 a43:	83 ec 04             	sub    $0x4,%esp
 a46:	e9 59 ff ff ff       	jmp    9a4 <printf+0xb4>
 a4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 a4f:	90                   	nop
        s = (char*)*ap;
 a50:	8b 45 d0             	mov    -0x30(%ebp),%eax
 a53:	8b 18                	mov    (%eax),%ebx
        ap++;
 a55:	83 c0 04             	add    $0x4,%eax
 a58:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 a5b:	85 db                	test   %ebx,%ebx
 a5d:	74 17                	je     a76 <printf+0x186>
        while(*s != 0){
 a5f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 a62:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 a64:	84 c0                	test   %al,%al
 a66:	0f 84 d8 fe ff ff    	je     944 <printf+0x54>
 a6c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 a6f:	89 de                	mov    %ebx,%esi
 a71:	8b 5d 08             	mov    0x8(%ebp),%ebx
 a74:	eb 1a                	jmp    a90 <printf+0x1a0>
          s = "(null)";
 a76:	bb fa 0c 00 00       	mov    $0xcfa,%ebx
        while(*s != 0){
 a7b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 a7e:	b8 28 00 00 00       	mov    $0x28,%eax
 a83:	89 de                	mov    %ebx,%esi
 a85:	8b 5d 08             	mov    0x8(%ebp),%ebx
 a88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a8f:	90                   	nop
  write(fd, &c, 1);
 a90:	83 ec 04             	sub    $0x4,%esp
          s++;
 a93:	83 c6 01             	add    $0x1,%esi
 a96:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 a99:	6a 01                	push   $0x1
 a9b:	57                   	push   %edi
 a9c:	53                   	push   %ebx
 a9d:	e8 01 fd ff ff       	call   7a3 <write>
        while(*s != 0){
 aa2:	0f b6 06             	movzbl (%esi),%eax
 aa5:	83 c4 10             	add    $0x10,%esp
 aa8:	84 c0                	test   %al,%al
 aaa:	75 e4                	jne    a90 <printf+0x1a0>
 aac:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 aaf:	31 d2                	xor    %edx,%edx
 ab1:	e9 8e fe ff ff       	jmp    944 <printf+0x54>
 ab6:	66 90                	xchg   %ax,%ax
 ab8:	66 90                	xchg   %ax,%ax
 aba:	66 90                	xchg   %ax,%ax
 abc:	66 90                	xchg   %ax,%ax
 abe:	66 90                	xchg   %ax,%ax

00000ac0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 ac0:	f3 0f 1e fb          	endbr32 
 ac4:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ac5:	a1 38 10 00 00       	mov    0x1038,%eax
{
 aca:	89 e5                	mov    %esp,%ebp
 acc:	57                   	push   %edi
 acd:	56                   	push   %esi
 ace:	53                   	push   %ebx
 acf:	8b 5d 08             	mov    0x8(%ebp),%ebx
 ad2:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 ad4:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ad7:	39 c8                	cmp    %ecx,%eax
 ad9:	73 15                	jae    af0 <free+0x30>
 adb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 adf:	90                   	nop
 ae0:	39 d1                	cmp    %edx,%ecx
 ae2:	72 14                	jb     af8 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ae4:	39 d0                	cmp    %edx,%eax
 ae6:	73 10                	jae    af8 <free+0x38>
{
 ae8:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 aea:	8b 10                	mov    (%eax),%edx
 aec:	39 c8                	cmp    %ecx,%eax
 aee:	72 f0                	jb     ae0 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 af0:	39 d0                	cmp    %edx,%eax
 af2:	72 f4                	jb     ae8 <free+0x28>
 af4:	39 d1                	cmp    %edx,%ecx
 af6:	73 f0                	jae    ae8 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 af8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 afb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 afe:	39 fa                	cmp    %edi,%edx
 b00:	74 1e                	je     b20 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 b02:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 b05:	8b 50 04             	mov    0x4(%eax),%edx
 b08:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 b0b:	39 f1                	cmp    %esi,%ecx
 b0d:	74 28                	je     b37 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 b0f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 b11:	5b                   	pop    %ebx
  freep = p;
 b12:	a3 38 10 00 00       	mov    %eax,0x1038
}
 b17:	5e                   	pop    %esi
 b18:	5f                   	pop    %edi
 b19:	5d                   	pop    %ebp
 b1a:	c3                   	ret    
 b1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 b1f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 b20:	03 72 04             	add    0x4(%edx),%esi
 b23:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 b26:	8b 10                	mov    (%eax),%edx
 b28:	8b 12                	mov    (%edx),%edx
 b2a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 b2d:	8b 50 04             	mov    0x4(%eax),%edx
 b30:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 b33:	39 f1                	cmp    %esi,%ecx
 b35:	75 d8                	jne    b0f <free+0x4f>
    p->s.size += bp->s.size;
 b37:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 b3a:	a3 38 10 00 00       	mov    %eax,0x1038
    p->s.size += bp->s.size;
 b3f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 b42:	8b 53 f8             	mov    -0x8(%ebx),%edx
 b45:	89 10                	mov    %edx,(%eax)
}
 b47:	5b                   	pop    %ebx
 b48:	5e                   	pop    %esi
 b49:	5f                   	pop    %edi
 b4a:	5d                   	pop    %ebp
 b4b:	c3                   	ret    
 b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000b50 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b50:	f3 0f 1e fb          	endbr32 
 b54:	55                   	push   %ebp
 b55:	89 e5                	mov    %esp,%ebp
 b57:	57                   	push   %edi
 b58:	56                   	push   %esi
 b59:	53                   	push   %ebx
 b5a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 b60:	8b 3d 38 10 00 00    	mov    0x1038,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b66:	8d 70 07             	lea    0x7(%eax),%esi
 b69:	c1 ee 03             	shr    $0x3,%esi
 b6c:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 b6f:	85 ff                	test   %edi,%edi
 b71:	0f 84 a9 00 00 00    	je     c20 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b77:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 b79:	8b 48 04             	mov    0x4(%eax),%ecx
 b7c:	39 f1                	cmp    %esi,%ecx
 b7e:	73 6d                	jae    bed <malloc+0x9d>
 b80:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 b86:	bb 00 10 00 00       	mov    $0x1000,%ebx
 b8b:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 b8e:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 b95:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 b98:	eb 17                	jmp    bb1 <malloc+0x61>
 b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ba0:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 ba2:	8b 4a 04             	mov    0x4(%edx),%ecx
 ba5:	39 f1                	cmp    %esi,%ecx
 ba7:	73 4f                	jae    bf8 <malloc+0xa8>
 ba9:	8b 3d 38 10 00 00    	mov    0x1038,%edi
 baf:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 bb1:	39 c7                	cmp    %eax,%edi
 bb3:	75 eb                	jne    ba0 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 bb5:	83 ec 0c             	sub    $0xc,%esp
 bb8:	ff 75 e4             	pushl  -0x1c(%ebp)
 bbb:	e8 4b fc ff ff       	call   80b <sbrk>
  if(p == (char*)-1)
 bc0:	83 c4 10             	add    $0x10,%esp
 bc3:	83 f8 ff             	cmp    $0xffffffff,%eax
 bc6:	74 1b                	je     be3 <malloc+0x93>
  hp->s.size = nu;
 bc8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 bcb:	83 ec 0c             	sub    $0xc,%esp
 bce:	83 c0 08             	add    $0x8,%eax
 bd1:	50                   	push   %eax
 bd2:	e8 e9 fe ff ff       	call   ac0 <free>
  return freep;
 bd7:	a1 38 10 00 00       	mov    0x1038,%eax
      if((p = morecore(nunits)) == 0)
 bdc:	83 c4 10             	add    $0x10,%esp
 bdf:	85 c0                	test   %eax,%eax
 be1:	75 bd                	jne    ba0 <malloc+0x50>
        return 0;
  }
}
 be3:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 be6:	31 c0                	xor    %eax,%eax
}
 be8:	5b                   	pop    %ebx
 be9:	5e                   	pop    %esi
 bea:	5f                   	pop    %edi
 beb:	5d                   	pop    %ebp
 bec:	c3                   	ret    
    if(p->s.size >= nunits){
 bed:	89 c2                	mov    %eax,%edx
 bef:	89 f8                	mov    %edi,%eax
 bf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 bf8:	39 ce                	cmp    %ecx,%esi
 bfa:	74 54                	je     c50 <malloc+0x100>
        p->s.size -= nunits;
 bfc:	29 f1                	sub    %esi,%ecx
 bfe:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 c01:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 c04:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 c07:	a3 38 10 00 00       	mov    %eax,0x1038
}
 c0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 c0f:	8d 42 08             	lea    0x8(%edx),%eax
}
 c12:	5b                   	pop    %ebx
 c13:	5e                   	pop    %esi
 c14:	5f                   	pop    %edi
 c15:	5d                   	pop    %ebp
 c16:	c3                   	ret    
 c17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 c1e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 c20:	c7 05 38 10 00 00 3c 	movl   $0x103c,0x1038
 c27:	10 00 00 
    base.s.size = 0;
 c2a:	bf 3c 10 00 00       	mov    $0x103c,%edi
    base.s.ptr = freep = prevp = &base;
 c2f:	c7 05 3c 10 00 00 3c 	movl   $0x103c,0x103c
 c36:	10 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c39:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 c3b:	c7 05 40 10 00 00 00 	movl   $0x0,0x1040
 c42:	00 00 00 
    if(p->s.size >= nunits){
 c45:	e9 36 ff ff ff       	jmp    b80 <malloc+0x30>
 c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 c50:	8b 0a                	mov    (%edx),%ecx
 c52:	89 08                	mov    %ecx,(%eax)
 c54:	eb b1                	jmp    c07 <malloc+0xb7>
