
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
  18:	eb 10                	jmp    2a <main+0x2a>
  1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    for (int i = 0; i < 20; i++){
        int pid = fork();
        if (pid != 0){
            wait();
  20:	e8 76 07 00 00       	call   79b <wait>
    for (int i = 0; i < 20; i++){
  25:	83 eb 01             	sub    $0x1,%ebx
  28:	74 1f                	je     49 <main+0x49>
        int pid = fork();
  2a:	e8 5c 07 00 00       	call   78b <fork>
        if (pid != 0){
  2f:	85 c0                	test   %eax,%eax
  31:	75 ed                	jne    20 <main+0x20>
        }
        else{
            printf(1, "%d\n", getpid());
  33:	e8 db 07 00 00       	call   813 <getpid>
  38:	52                   	push   %edx
  39:	50                   	push   %eax
  3a:	68 ea 0c 00 00       	push   $0xcea
  3f:	6a 01                	push   $0x1
  41:	e8 ba 08 00 00       	call   900 <printf>
            break;
  46:	83 c4 10             	add    $0x10,%esp
        }
    }
    exit();
  49:	e8 45 07 00 00       	call   793 <exit>
  4e:	66 90                	xchg   %ax,%ax

00000050 <action_handler>:
void action_handler(int signum){
  50:	f3 0f 1e fb          	endbr32 
  54:	55                   	push   %ebp
  55:	89 e5                	mov    %esp,%ebp
  57:	83 ec 0c             	sub    $0xc,%esp
    printf(1, "SIGNAL %d HANDLED\n", signum);
  5a:	ff 75 08             	pushl  0x8(%ebp)
  5d:	68 68 0c 00 00       	push   $0xc68
  62:	6a 01                	push   $0x1
  64:	e8 97 08 00 00       	call   900 <printf>
    return;
  69:	83 c4 10             	add    $0x10,%esp
}
  6c:	c9                   	leave  
  6d:	c3                   	ret    
  6e:	66 90                	xchg   %ax,%ax

00000070 <main8>:
int main8(int argc, char** argv){
  70:	f3 0f 1e fb          	endbr32 
  74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(1){}
  78:	eb fe                	jmp    78 <main8+0x8>
  7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000080 <main4>:
int main4(int argc, char** argv){
  80:	f3 0f 1e fb          	endbr32 
  84:	55                   	push   %ebp
  85:	89 e5                	mov    %esp,%ebp
  87:	57                   	push   %edi
  ushort ss;
  ushort padding6;
};

static inline int cas(volatile void* addr, int expected, int newval){
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
  88:	bf 02 00 00 00       	mov    $0x2,%edi
  8d:	56                   	push   %esi
  8e:	be 03 00 00 00       	mov    $0x3,%esi
  93:	53                   	push   %ebx
  94:	8d 5d e4             	lea    -0x1c(%ebp),%ebx
  97:	83 ec 38             	sub    $0x38,%esp
  a = 1; b = 2; c = 3;
  9a:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  printf(1,"a %d b %d c %d\n",a,b,c);
  a1:	6a 03                	push   $0x3
  a3:	6a 02                	push   $0x2
  a5:	6a 01                	push   $0x1
  a7:	68 7b 0c 00 00       	push   $0xc7b
  ac:	6a 01                	push   $0x1
  ae:	e8 4d 08 00 00       	call   900 <printf>
  b3:	89 f8                	mov    %edi,%eax
  b5:	f0 0f b1 33          	lock cmpxchg %esi,(%ebx)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  b9:	9c                   	pushf  
  ba:	58                   	pop    %eax
  printf(1,"ret %d, a %d \n\n",ret, a);
  bb:	83 c4 20             	add    $0x20,%esp
 : :"r" (addr), "a" (expected), "r" (newval));
  return (readeflags() & 0x0040);
  be:	83 e0 40             	and    $0x40,%eax
  c1:	ff 75 e4             	pushl  -0x1c(%ebp)
  c4:	50                   	push   %eax
  c5:	68 8b 0c 00 00       	push   $0xc8b
  ca:	6a 01                	push   $0x1
  cc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  cf:	e8 2c 08 00 00       	call   900 <printf>
  if(ret){
  d4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  d7:	83 c4 10             	add    $0x10,%esp
  da:	85 c0                	test   %eax,%eax
  dc:	74 14                	je     f2 <main4+0x72>
    printf(1,"Case %d Fail\n ",i);
  de:	50                   	push   %eax
  df:	6a 01                	push   $0x1
  e1:	68 9b 0c 00 00       	push   $0xc9b
  e6:	6a 01                	push   $0x1
  e8:	e8 13 08 00 00       	call   900 <printf>
    exit();
  ed:	e8 a1 06 00 00       	call   793 <exit>
  printf(1,"a %d b %d c %d\n",a,b,c);
  f2:	83 ec 0c             	sub    $0xc,%esp
  a = 2; b = 2; c = 3;
  f5:	c7 45 e4 02 00 00 00 	movl   $0x2,-0x1c(%ebp)
  printf(1,"a %d b %d c %d\n",a,b,c);
  fc:	6a 03                	push   $0x3
  fe:	6a 02                	push   $0x2
 100:	6a 02                	push   $0x2
 102:	68 7b 0c 00 00       	push   $0xc7b
 107:	6a 01                	push   $0x1
 109:	e8 f2 07 00 00       	call   900 <printf>
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
 10e:	89 f8                	mov    %edi,%eax
 110:	f0 0f b1 33          	lock cmpxchg %esi,(%ebx)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
 114:	9c                   	pushf  
 115:	58                   	pop    %eax
  printf(1,"ret %d, a %d \n\n",ret, a);
 116:	83 c4 20             	add    $0x20,%esp
  return (readeflags() & 0x0040);
 119:	83 e0 40             	and    $0x40,%eax
 11c:	ff 75 e4             	pushl  -0x1c(%ebp)
 11f:	50                   	push   %eax
 120:	68 8b 0c 00 00       	push   $0xc8b
 125:	6a 01                	push   $0x1
 127:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 12a:	e8 d1 07 00 00       	call   900 <printf>
  if(!ret){
 12f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 132:	83 c4 10             	add    $0x10,%esp
 135:	85 c0                	test   %eax,%eax
 137:	75 14                	jne    14d <main4+0xcd>
    printf(1,"Case %d Fail\n ",i);
 139:	50                   	push   %eax
 13a:	6a 02                	push   $0x2
 13c:	68 9b 0c 00 00       	push   $0xc9b
 141:	6a 01                	push   $0x1
 143:	e8 b8 07 00 00       	call   900 <printf>
    exit();
 148:	e8 46 06 00 00       	call   793 <exit>
  printf(1,"a %d b %d c %d\n",a,b,c);
 14d:	83 ec 0c             	sub    $0xc,%esp
  a = 3; b = 2; c = 3;
 150:	c7 45 e4 03 00 00 00 	movl   $0x3,-0x1c(%ebp)
  printf(1,"a %d b %d c %d\n",a,b,c);
 157:	6a 03                	push   $0x3
 159:	6a 02                	push   $0x2
 15b:	6a 03                	push   $0x3
 15d:	68 7b 0c 00 00       	push   $0xc7b
 162:	6a 01                	push   $0x1
 164:	e8 97 07 00 00       	call   900 <printf>
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
 169:	89 f8                	mov    %edi,%eax
 16b:	f0 0f b1 33          	lock cmpxchg %esi,(%ebx)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
 16f:	9c                   	pushf  
 170:	5f                   	pop    %edi
  printf(1,"ret %d, a %d \n\n",ret, a);
 171:	83 c4 20             	add    $0x20,%esp
  return (readeflags() & 0x0040);
 174:	83 e7 40             	and    $0x40,%edi
 177:	ff 75 e4             	pushl  -0x1c(%ebp)
 17a:	57                   	push   %edi
 17b:	68 8b 0c 00 00       	push   $0xc8b
 180:	6a 01                	push   $0x1
 182:	e8 79 07 00 00       	call   900 <printf>
  if(ret){
 187:	83 c4 10             	add    $0x10,%esp
 18a:	85 ff                	test   %edi,%edi
 18c:	75 60                	jne    1ee <main4+0x16e>
  printf(1,"a %d b %d c %d\n",a,b,c);
 18e:	83 ec 0c             	sub    $0xc,%esp
  a = 3; b = 3; c = 30;
 191:	c7 45 e4 03 00 00 00 	movl   $0x3,-0x1c(%ebp)
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
 198:	bf 1e 00 00 00       	mov    $0x1e,%edi
  printf(1,"a %d b %d c %d\n",a,b,c);
 19d:	6a 1e                	push   $0x1e
 19f:	6a 03                	push   $0x3
 1a1:	6a 03                	push   $0x3
 1a3:	68 7b 0c 00 00       	push   $0xc7b
 1a8:	6a 01                	push   $0x1
 1aa:	e8 51 07 00 00       	call   900 <printf>
 1af:	89 f0                	mov    %esi,%eax
 1b1:	f0 0f b1 3b          	lock cmpxchg %edi,(%ebx)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
 1b5:	9c                   	pushf  
 1b6:	58                   	pop    %eax
  printf(1,"ret %d, a %d \n\n",ret, a);
 1b7:	83 c4 20             	add    $0x20,%esp
  return (readeflags() & 0x0040);
 1ba:	83 e0 40             	and    $0x40,%eax
 1bd:	ff 75 e4             	pushl  -0x1c(%ebp)
 1c0:	50                   	push   %eax
 1c1:	68 8b 0c 00 00       	push   $0xc8b
 1c6:	6a 01                	push   $0x1
 1c8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 1cb:	e8 30 07 00 00       	call   900 <printf>
  if(!ret){
 1d0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 1d3:	83 c4 10             	add    $0x10,%esp
 1d6:	85 c0                	test   %eax,%eax
 1d8:	75 28                	jne    202 <main4+0x182>
    printf(1,"Case %d Fail\n ",i);
 1da:	56                   	push   %esi
 1db:	6a 04                	push   $0x4
 1dd:	68 9b 0c 00 00       	push   $0xc9b
 1e2:	6a 01                	push   $0x1
 1e4:	e8 17 07 00 00       	call   900 <printf>
    exit();
 1e9:	e8 a5 05 00 00       	call   793 <exit>
    printf(1,"Case %d Fail\n ",i);
 1ee:	57                   	push   %edi
 1ef:	6a 03                	push   $0x3
 1f1:	68 9b 0c 00 00       	push   $0xc9b
 1f6:	6a 01                	push   $0x1
 1f8:	e8 03 07 00 00       	call   900 <printf>
    exit();
 1fd:	e8 91 05 00 00       	call   793 <exit>
  printf(1,"a %d b %d c %d\n",a,b,c);
 202:	83 ec 0c             	sub    $0xc,%esp
  a = 2; b = 4; c = 3;
 205:	c7 45 e4 02 00 00 00 	movl   $0x2,-0x1c(%ebp)
  printf(1,"a %d b %d c %d\n",a,b,c);
 20c:	6a 03                	push   $0x3
 20e:	6a 04                	push   $0x4
 210:	6a 02                	push   $0x2
 212:	68 7b 0c 00 00       	push   $0xc7b
 217:	6a 01                	push   $0x1
 219:	e8 e2 06 00 00       	call   900 <printf>
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
 21e:	b8 04 00 00 00       	mov    $0x4,%eax
 223:	f0 0f b1 33          	lock cmpxchg %esi,(%ebx)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
 227:	9c                   	pushf  
 228:	5e                   	pop    %esi
  printf(1,"ret %d, a %d \n\n",ret, a);
 229:	83 c4 20             	add    $0x20,%esp
  return (readeflags() & 0x0040);
 22c:	83 e6 40             	and    $0x40,%esi
 22f:	ff 75 e4             	pushl  -0x1c(%ebp)
 232:	56                   	push   %esi
 233:	68 8b 0c 00 00       	push   $0xc8b
 238:	6a 01                	push   $0x1
 23a:	e8 c1 06 00 00       	call   900 <printf>
  if(ret){
 23f:	83 c4 10             	add    $0x10,%esp
 242:	85 f6                	test   %esi,%esi
 244:	75 58                	jne    29e <main4+0x21e>
  printf(1,"a %d b %d c %d\n",a,b,c);
 246:	83 ec 0c             	sub    $0xc,%esp
   a = 3; b = 4; c = 30;
 249:	c7 45 e4 03 00 00 00 	movl   $0x3,-0x1c(%ebp)
  printf(1,"a %d b %d c %d\n",a,b,c);
 250:	6a 1e                	push   $0x1e
 252:	6a 04                	push   $0x4
 254:	6a 03                	push   $0x3
 256:	68 7b 0c 00 00       	push   $0xc7b
 25b:	6a 01                	push   $0x1
 25d:	e8 9e 06 00 00       	call   900 <printf>
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
 262:	b8 04 00 00 00       	mov    $0x4,%eax
 267:	f0 0f b1 3b          	lock cmpxchg %edi,(%ebx)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
 26b:	9c                   	pushf  
 26c:	5e                   	pop    %esi
  printf(1,"ret %d, a %d \n\n",ret, a);
 26d:	83 c4 20             	add    $0x20,%esp
  return (readeflags() & 0x0040);
 270:	83 e6 40             	and    $0x40,%esi
 273:	ff 75 e4             	pushl  -0x1c(%ebp)
 276:	56                   	push   %esi
 277:	68 8b 0c 00 00       	push   $0xc8b
 27c:	6a 01                	push   $0x1
 27e:	e8 7d 06 00 00       	call   900 <printf>
  if(ret){
 283:	83 c4 10             	add    $0x10,%esp
 286:	85 f6                	test   %esi,%esi
 288:	74 28                	je     2b2 <main4+0x232>
    printf(1,"Case %d Fail\n ",i);
 28a:	51                   	push   %ecx
 28b:	6a 06                	push   $0x6
 28d:	68 9b 0c 00 00       	push   $0xc9b
 292:	6a 01                	push   $0x1
 294:	e8 67 06 00 00       	call   900 <printf>
    exit();
 299:	e8 f5 04 00 00       	call   793 <exit>
    printf(1,"Case i %d Fail\n ",i);
 29e:	53                   	push   %ebx
 29f:	6a 05                	push   $0x5
 2a1:	68 aa 0c 00 00       	push   $0xcaa
 2a6:	6a 01                	push   $0x1
 2a8:	e8 53 06 00 00       	call   900 <printf>
    exit();
 2ad:	e8 e1 04 00 00       	call   793 <exit>
  printf(1,"a %d b %d c %d\n",a,b,c);
 2b2:	83 ec 0c             	sub    $0xc,%esp
   a = 4; b = 4; c = 30;
 2b5:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
  printf(1,"a %d b %d c %d\n",a,b,c);
 2bc:	6a 1e                	push   $0x1e
 2be:	6a 04                	push   $0x4
 2c0:	6a 04                	push   $0x4
 2c2:	68 7b 0c 00 00       	push   $0xc7b
 2c7:	6a 01                	push   $0x1
 2c9:	e8 32 06 00 00       	call   900 <printf>
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
 2ce:	b8 04 00 00 00       	mov    $0x4,%eax
 2d3:	f0 0f b1 3b          	lock cmpxchg %edi,(%ebx)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
 2d7:	9c                   	pushf  
 2d8:	5b                   	pop    %ebx
  printf(1,"ret %d, a %d \n\n",ret, a);
 2d9:	83 c4 20             	add    $0x20,%esp
  return (readeflags() & 0x0040);
 2dc:	83 e3 40             	and    $0x40,%ebx
 2df:	ff 75 e4             	pushl  -0x1c(%ebp)
 2e2:	53                   	push   %ebx
 2e3:	68 8b 0c 00 00       	push   $0xc8b
 2e8:	6a 01                	push   $0x1
 2ea:	e8 11 06 00 00       	call   900 <printf>
  if(!ret){
 2ef:	83 c4 10             	add    $0x10,%esp
 2f2:	85 db                	test   %ebx,%ebx
 2f4:	75 14                	jne    30a <main4+0x28a>
    printf(1,"Case %d Fail\n ",i);
 2f6:	52                   	push   %edx
 2f7:	6a 07                	push   $0x7
 2f9:	68 9b 0c 00 00       	push   $0xc9b
 2fe:	6a 01                	push   $0x1
 300:	e8 fb 05 00 00       	call   900 <printf>
    exit();
 305:	e8 89 04 00 00       	call   793 <exit>
  printf(1,"All Tests passed\n");
 30a:	50                   	push   %eax
 30b:	50                   	push   %eax
 30c:	68 bb 0c 00 00       	push   $0xcbb
 311:	6a 01                	push   $0x1
 313:	e8 e8 05 00 00       	call   900 <printf>
  exit();
 318:	e8 76 04 00 00       	call   793 <exit>
 31d:	8d 76 00             	lea    0x0(%esi),%esi

00000320 <main1>:
}

int main1(int argc, char** argv){
 320:	f3 0f 1e fb          	endbr32 
 324:	55                   	push   %ebp
 325:	89 e5                	mov    %esp,%ebp
 327:	53                   	push   %ebx
    struct sigaction sigact = {action_handler, 0};
    sigaction(1, &sigact, null);
 328:	8d 45 f0             	lea    -0x10(%ebp),%eax
int main1(int argc, char** argv){
 32b:	83 ec 18             	sub    $0x18,%esp
    struct sigaction sigact = {action_handler, 0};
 32e:	c7 45 f0 50 00 00 00 	movl   $0x50,-0x10(%ebp)
    sigaction(1, &sigact, null);
 335:	6a 00                	push   $0x0
 337:	50                   	push   %eax
 338:	6a 01                	push   $0x1
    struct sigaction sigact = {action_handler, 0};
 33a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    sigaction(1, &sigact, null);
 341:	e8 f5 04 00 00       	call   83b <sigaction>
    kill(getpid(), 1);
 346:	e8 c8 04 00 00       	call   813 <getpid>
 34b:	5a                   	pop    %edx
 34c:	59                   	pop    %ecx
 34d:	6a 01                	push   $0x1
 34f:	50                   	push   %eax
 350:	e8 6e 04 00 00       	call   7c3 <kill>
    kill(getpid(), 9);
 355:	e8 b9 04 00 00       	call   813 <getpid>
 35a:	5b                   	pop    %ebx
 35b:	5a                   	pop    %edx
 35c:	6a 09                	push   $0x9
 35e:	50                   	push   %eax

    for (int i = 0; i < 1000000; i++){
 35f:	31 db                	xor    %ebx,%ebx
    kill(getpid(), 9);
 361:	e8 5d 04 00 00       	call   7c3 <kill>
 366:	83 c4 10             	add    $0x10,%esp
 369:	eb 22                	jmp    38d <main1+0x6d>
 36b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 36f:	90                   	nop
            if (i % 1000 == 0){
                printf(1, "hi\n");
            }
            printf(1, "");
 370:	83 ec 08             	sub    $0x8,%esp
    for (int i = 0; i < 1000000; i++){
 373:	83 c3 01             	add    $0x1,%ebx
            printf(1, "");
 376:	68 9a 0c 00 00       	push   $0xc9a
 37b:	6a 01                	push   $0x1
 37d:	e8 7e 05 00 00       	call   900 <printf>
    for (int i = 0; i < 1000000; i++){
 382:	83 c4 10             	add    $0x10,%esp
 385:	81 fb 40 42 0f 00    	cmp    $0xf4240,%ebx
 38b:	74 24                	je     3b1 <main1+0x91>
    kill(getpid(), 9);
 38d:	69 c3 d5 78 e9 26    	imul   $0x26e978d5,%ebx,%eax
 393:	c1 c8 03             	ror    $0x3,%eax
            if (i % 1000 == 0){
 396:	3d 37 89 41 00       	cmp    $0x418937,%eax
 39b:	77 d3                	ja     370 <main1+0x50>
                printf(1, "hi\n");
 39d:	83 ec 08             	sub    $0x8,%esp
 3a0:	68 cd 0c 00 00       	push   $0xccd
 3a5:	6a 01                	push   $0x1
 3a7:	e8 54 05 00 00       	call   900 <printf>
 3ac:	83 c4 10             	add    $0x10,%esp
 3af:	eb bf                	jmp    370 <main1+0x50>
        }
    return 0;
}
 3b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 3b4:	31 c0                	xor    %eax,%eax
 3b6:	c9                   	leave  
 3b7:	c3                   	ret    
 3b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3bf:	90                   	nop

000003c0 <main2>:

int main2(int argc, char** argv){
 3c0:	f3 0f 1e fb          	endbr32 
 3c4:	55                   	push   %ebp
 3c5:	89 e5                	mov    %esp,%ebp
 3c7:	56                   	push   %esi
 3c8:	53                   	push   %ebx
 3c9:	83 ec 10             	sub    $0x10,%esp
    struct sigaction sigact = {action_handler, 0};
 3cc:	c7 45 f0 50 00 00 00 	movl   $0x50,-0x10(%ebp)
 3d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int pid = fork();
 3da:	e8 ac 03 00 00       	call   78b <fork>
 3df:	89 c3                	mov    %eax,%ebx
    if (pid == 0){
 3e1:	85 c0                	test   %eax,%eax
 3e3:	0f 85 8c 00 00 00    	jne    475 <main2+0xb5>
        printf(1, "childs here");
 3e9:	50                   	push   %eax
        sigaction(1, &sigact, null);
 3ea:	8d 75 f0             	lea    -0x10(%ebp),%esi
        printf(1, "childs here");
 3ed:	50                   	push   %eax
 3ee:	68 d1 0c 00 00       	push   $0xcd1
 3f3:	6a 01                	push   $0x1
 3f5:	e8 06 05 00 00       	call   900 <printf>
        sigaction(1, &sigact, null);
 3fa:	83 c4 0c             	add    $0xc,%esp
 3fd:	6a 00                	push   $0x0
 3ff:	56                   	push   %esi
 400:	6a 01                	push   $0x1
 402:	e8 34 04 00 00       	call   83b <sigaction>
        sigaction(2, &sigact, null);
 407:	83 c4 0c             	add    $0xc,%esp
 40a:	6a 00                	push   $0x0
 40c:	56                   	push   %esi
 40d:	6a 02                	push   $0x2
 40f:	e8 27 04 00 00       	call   83b <sigaction>
        sigaction(3, &sigact, null);
 414:	83 c4 0c             	add    $0xc,%esp
 417:	6a 00                	push   $0x0
 419:	56                   	push   %esi
 41a:	6a 03                	push   $0x3
 41c:	e8 1a 04 00 00       	call   83b <sigaction>
 421:	83 c4 10             	add    $0x10,%esp
 424:	eb 2b                	jmp    451 <main2+0x91>
 426:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 42d:	8d 76 00             	lea    0x0(%esi),%esi
        for (int i = 0; i < 1000000; i++){
            if (i % 1000 == 0){
                printf(1, "hi\n");
            }
            printf(1, "");
 430:	83 ec 08             	sub    $0x8,%esp
        for (int i = 0; i < 1000000; i++){
 433:	83 c3 01             	add    $0x1,%ebx
            printf(1, "");
 436:	68 9a 0c 00 00       	push   $0xc9a
 43b:	6a 01                	push   $0x1
 43d:	e8 be 04 00 00       	call   900 <printf>
        for (int i = 0; i < 1000000; i++){
 442:	83 c4 10             	add    $0x10,%esp
 445:	81 fb 40 42 0f 00    	cmp    $0xf4240,%ebx
 44b:	0f 84 d1 00 00 00    	je     522 <main2+0x162>
        sigaction(3, &sigact, null);
 451:	69 c3 d5 78 e9 26    	imul   $0x26e978d5,%ebx,%eax
 457:	c1 c8 03             	ror    $0x3,%eax
            if (i % 1000 == 0){
 45a:	3d 37 89 41 00       	cmp    $0x418937,%eax
 45f:	77 cf                	ja     430 <main2+0x70>
                printf(1, "hi\n");
 461:	83 ec 08             	sub    $0x8,%esp
 464:	68 cd 0c 00 00       	push   $0xccd
 469:	6a 01                	push   $0x1
 46b:	e8 90 04 00 00       	call   900 <printf>
 470:	83 c4 10             	add    $0x10,%esp
 473:	eb bb                	jmp    430 <main2+0x70>
        }
    }
    else{
        printf(1, "childs pid : %d\n", pid);
 475:	50                   	push   %eax
 476:	53                   	push   %ebx
 477:	68 dd 0c 00 00       	push   $0xcdd
 47c:	6a 01                	push   $0x1
 47e:	e8 7d 04 00 00       	call   900 <printf>
        sleep(100);
 483:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
 48a:	e8 94 03 00 00       	call   823 <sleep>
        printf(1, "sending signal %d to child\n", 1);
 48f:	83 c4 0c             	add    $0xc,%esp
 492:	6a 01                	push   $0x1
 494:	68 ee 0c 00 00       	push   $0xcee
 499:	6a 01                	push   $0x1
 49b:	e8 60 04 00 00       	call   900 <printf>
        kill(pid, 1);
 4a0:	5a                   	pop    %edx
 4a1:	59                   	pop    %ecx
 4a2:	6a 01                	push   $0x1
 4a4:	53                   	push   %ebx
 4a5:	e8 19 03 00 00       	call   7c3 <kill>
        sleep(100);
 4aa:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
 4b1:	e8 6d 03 00 00       	call   823 <sleep>
        printf(1, "sending signal %d to child\n", 2);
 4b6:	83 c4 0c             	add    $0xc,%esp
 4b9:	6a 02                	push   $0x2
 4bb:	68 ee 0c 00 00       	push   $0xcee
 4c0:	6a 01                	push   $0x1
 4c2:	e8 39 04 00 00       	call   900 <printf>
        kill(pid, 2);
 4c7:	5e                   	pop    %esi
 4c8:	58                   	pop    %eax
 4c9:	6a 02                	push   $0x2
 4cb:	53                   	push   %ebx
 4cc:	e8 f2 02 00 00       	call   7c3 <kill>
        sleep(100);
 4d1:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
 4d8:	e8 46 03 00 00       	call   823 <sleep>
        printf(1, "sending signal %d to child\n", 3);
 4dd:	83 c4 0c             	add    $0xc,%esp
 4e0:	6a 03                	push   $0x3
 4e2:	68 ee 0c 00 00       	push   $0xcee
 4e7:	6a 01                	push   $0x1
 4e9:	e8 12 04 00 00       	call   900 <printf>
        kill(pid, 3);
 4ee:	58                   	pop    %eax
 4ef:	5a                   	pop    %edx
 4f0:	6a 03                	push   $0x3
 4f2:	53                   	push   %ebx
 4f3:	e8 cb 02 00 00       	call   7c3 <kill>
        sleep(100);
 4f8:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
 4ff:	e8 1f 03 00 00       	call   823 <sleep>
        kill(pid, 9);
 504:	59                   	pop    %ecx
 505:	5e                   	pop    %esi
 506:	6a 09                	push   $0x9
 508:	53                   	push   %ebx
 509:	e8 b5 02 00 00       	call   7c3 <kill>

        wait();
 50e:	e8 88 02 00 00       	call   79b <wait>
        sleep(300);
 513:	c7 04 24 2c 01 00 00 	movl   $0x12c,(%esp)
 51a:	e8 04 03 00 00       	call   823 <sleep>
 51f:	83 c4 10             	add    $0x10,%esp


    }
    exit();
 522:	e8 6c 02 00 00       	call   793 <exit>
 527:	66 90                	xchg   %ax,%ax
 529:	66 90                	xchg   %ax,%ax
 52b:	66 90                	xchg   %ax,%ax
 52d:	66 90                	xchg   %ax,%ax
 52f:	90                   	nop

00000530 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 530:	f3 0f 1e fb          	endbr32 
 534:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 535:	31 c0                	xor    %eax,%eax
{
 537:	89 e5                	mov    %esp,%ebp
 539:	53                   	push   %ebx
 53a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 53d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
 540:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 544:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 547:	83 c0 01             	add    $0x1,%eax
 54a:	84 d2                	test   %dl,%dl
 54c:	75 f2                	jne    540 <strcpy+0x10>
    ;
  return os;
}
 54e:	89 c8                	mov    %ecx,%eax
 550:	5b                   	pop    %ebx
 551:	5d                   	pop    %ebp
 552:	c3                   	ret    
 553:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 55a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000560 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 560:	f3 0f 1e fb          	endbr32 
 564:	55                   	push   %ebp
 565:	89 e5                	mov    %esp,%ebp
 567:	53                   	push   %ebx
 568:	8b 4d 08             	mov    0x8(%ebp),%ecx
 56b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 56e:	0f b6 01             	movzbl (%ecx),%eax
 571:	0f b6 1a             	movzbl (%edx),%ebx
 574:	84 c0                	test   %al,%al
 576:	75 19                	jne    591 <strcmp+0x31>
 578:	eb 26                	jmp    5a0 <strcmp+0x40>
 57a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 580:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 584:	83 c1 01             	add    $0x1,%ecx
 587:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 58a:	0f b6 1a             	movzbl (%edx),%ebx
 58d:	84 c0                	test   %al,%al
 58f:	74 0f                	je     5a0 <strcmp+0x40>
 591:	38 d8                	cmp    %bl,%al
 593:	74 eb                	je     580 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 595:	29 d8                	sub    %ebx,%eax
}
 597:	5b                   	pop    %ebx
 598:	5d                   	pop    %ebp
 599:	c3                   	ret    
 59a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 5a0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 5a2:	29 d8                	sub    %ebx,%eax
}
 5a4:	5b                   	pop    %ebx
 5a5:	5d                   	pop    %ebp
 5a6:	c3                   	ret    
 5a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5ae:	66 90                	xchg   %ax,%ax

000005b0 <strlen>:

uint
strlen(const char *s)
{
 5b0:	f3 0f 1e fb          	endbr32 
 5b4:	55                   	push   %ebp
 5b5:	89 e5                	mov    %esp,%ebp
 5b7:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 5ba:	80 3a 00             	cmpb   $0x0,(%edx)
 5bd:	74 21                	je     5e0 <strlen+0x30>
 5bf:	31 c0                	xor    %eax,%eax
 5c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5c8:	83 c0 01             	add    $0x1,%eax
 5cb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 5cf:	89 c1                	mov    %eax,%ecx
 5d1:	75 f5                	jne    5c8 <strlen+0x18>
    ;
  return n;
}
 5d3:	89 c8                	mov    %ecx,%eax
 5d5:	5d                   	pop    %ebp
 5d6:	c3                   	ret    
 5d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5de:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
 5e0:	31 c9                	xor    %ecx,%ecx
}
 5e2:	5d                   	pop    %ebp
 5e3:	89 c8                	mov    %ecx,%eax
 5e5:	c3                   	ret    
 5e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5ed:	8d 76 00             	lea    0x0(%esi),%esi

000005f0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 5f0:	f3 0f 1e fb          	endbr32 
 5f4:	55                   	push   %ebp
 5f5:	89 e5                	mov    %esp,%ebp
 5f7:	57                   	push   %edi
 5f8:	8b 55 08             	mov    0x8(%ebp),%edx
  asm volatile("cld; rep stosb" :
 5fb:	8b 4d 10             	mov    0x10(%ebp),%ecx
 5fe:	8b 45 0c             	mov    0xc(%ebp),%eax
 601:	89 d7                	mov    %edx,%edi
 603:	fc                   	cld    
 604:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 606:	89 d0                	mov    %edx,%eax
 608:	5f                   	pop    %edi
 609:	5d                   	pop    %ebp
 60a:	c3                   	ret    
 60b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 60f:	90                   	nop

00000610 <strchr>:

char*
strchr(const char *s, char c)
{
 610:	f3 0f 1e fb          	endbr32 
 614:	55                   	push   %ebp
 615:	89 e5                	mov    %esp,%ebp
 617:	8b 45 08             	mov    0x8(%ebp),%eax
 61a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 61e:	0f b6 10             	movzbl (%eax),%edx
 621:	84 d2                	test   %dl,%dl
 623:	75 16                	jne    63b <strchr+0x2b>
 625:	eb 21                	jmp    648 <strchr+0x38>
 627:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 62e:	66 90                	xchg   %ax,%ax
 630:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 634:	83 c0 01             	add    $0x1,%eax
 637:	84 d2                	test   %dl,%dl
 639:	74 0d                	je     648 <strchr+0x38>
    if(*s == c)
 63b:	38 d1                	cmp    %dl,%cl
 63d:	75 f1                	jne    630 <strchr+0x20>
      return (char*)s;
  return 0;
}
 63f:	5d                   	pop    %ebp
 640:	c3                   	ret    
 641:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 648:	31 c0                	xor    %eax,%eax
}
 64a:	5d                   	pop    %ebp
 64b:	c3                   	ret    
 64c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000650 <gets>:

char*
gets(char *buf, int max)
{
 650:	f3 0f 1e fb          	endbr32 
 654:	55                   	push   %ebp
 655:	89 e5                	mov    %esp,%ebp
 657:	57                   	push   %edi
 658:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 659:	31 f6                	xor    %esi,%esi
{
 65b:	53                   	push   %ebx
 65c:	89 f3                	mov    %esi,%ebx
 65e:	83 ec 1c             	sub    $0x1c,%esp
 661:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 664:	eb 33                	jmp    699 <gets+0x49>
 666:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 66d:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 670:	83 ec 04             	sub    $0x4,%esp
 673:	8d 45 e7             	lea    -0x19(%ebp),%eax
 676:	6a 01                	push   $0x1
 678:	50                   	push   %eax
 679:	6a 00                	push   $0x0
 67b:	e8 2b 01 00 00       	call   7ab <read>
    if(cc < 1)
 680:	83 c4 10             	add    $0x10,%esp
 683:	85 c0                	test   %eax,%eax
 685:	7e 1c                	jle    6a3 <gets+0x53>
      break;
    buf[i++] = c;
 687:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 68b:	83 c7 01             	add    $0x1,%edi
 68e:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 691:	3c 0a                	cmp    $0xa,%al
 693:	74 23                	je     6b8 <gets+0x68>
 695:	3c 0d                	cmp    $0xd,%al
 697:	74 1f                	je     6b8 <gets+0x68>
  for(i=0; i+1 < max; ){
 699:	83 c3 01             	add    $0x1,%ebx
 69c:	89 fe                	mov    %edi,%esi
 69e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 6a1:	7c cd                	jl     670 <gets+0x20>
 6a3:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 6a5:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 6a8:	c6 03 00             	movb   $0x0,(%ebx)
}
 6ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6ae:	5b                   	pop    %ebx
 6af:	5e                   	pop    %esi
 6b0:	5f                   	pop    %edi
 6b1:	5d                   	pop    %ebp
 6b2:	c3                   	ret    
 6b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6b7:	90                   	nop
 6b8:	8b 75 08             	mov    0x8(%ebp),%esi
 6bb:	8b 45 08             	mov    0x8(%ebp),%eax
 6be:	01 de                	add    %ebx,%esi
 6c0:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 6c2:	c6 03 00             	movb   $0x0,(%ebx)
}
 6c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6c8:	5b                   	pop    %ebx
 6c9:	5e                   	pop    %esi
 6ca:	5f                   	pop    %edi
 6cb:	5d                   	pop    %ebp
 6cc:	c3                   	ret    
 6cd:	8d 76 00             	lea    0x0(%esi),%esi

000006d0 <stat>:

int
stat(const char *n, struct stat *st)
{
 6d0:	f3 0f 1e fb          	endbr32 
 6d4:	55                   	push   %ebp
 6d5:	89 e5                	mov    %esp,%ebp
 6d7:	56                   	push   %esi
 6d8:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 6d9:	83 ec 08             	sub    $0x8,%esp
 6dc:	6a 00                	push   $0x0
 6de:	ff 75 08             	pushl  0x8(%ebp)
 6e1:	e8 ed 00 00 00       	call   7d3 <open>
  if(fd < 0)
 6e6:	83 c4 10             	add    $0x10,%esp
 6e9:	85 c0                	test   %eax,%eax
 6eb:	78 2b                	js     718 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 6ed:	83 ec 08             	sub    $0x8,%esp
 6f0:	ff 75 0c             	pushl  0xc(%ebp)
 6f3:	89 c3                	mov    %eax,%ebx
 6f5:	50                   	push   %eax
 6f6:	e8 f0 00 00 00       	call   7eb <fstat>
  close(fd);
 6fb:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 6fe:	89 c6                	mov    %eax,%esi
  close(fd);
 700:	e8 b6 00 00 00       	call   7bb <close>
  return r;
 705:	83 c4 10             	add    $0x10,%esp
}
 708:	8d 65 f8             	lea    -0x8(%ebp),%esp
 70b:	89 f0                	mov    %esi,%eax
 70d:	5b                   	pop    %ebx
 70e:	5e                   	pop    %esi
 70f:	5d                   	pop    %ebp
 710:	c3                   	ret    
 711:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 718:	be ff ff ff ff       	mov    $0xffffffff,%esi
 71d:	eb e9                	jmp    708 <stat+0x38>
 71f:	90                   	nop

00000720 <atoi>:

int
atoi(const char *s)
{
 720:	f3 0f 1e fb          	endbr32 
 724:	55                   	push   %ebp
 725:	89 e5                	mov    %esp,%ebp
 727:	53                   	push   %ebx
 728:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 72b:	0f be 02             	movsbl (%edx),%eax
 72e:	8d 48 d0             	lea    -0x30(%eax),%ecx
 731:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 734:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 739:	77 1a                	ja     755 <atoi+0x35>
 73b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 73f:	90                   	nop
    n = n*10 + *s++ - '0';
 740:	83 c2 01             	add    $0x1,%edx
 743:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 746:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 74a:	0f be 02             	movsbl (%edx),%eax
 74d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 750:	80 fb 09             	cmp    $0x9,%bl
 753:	76 eb                	jbe    740 <atoi+0x20>
  return n;
}
 755:	89 c8                	mov    %ecx,%eax
 757:	5b                   	pop    %ebx
 758:	5d                   	pop    %ebp
 759:	c3                   	ret    
 75a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000760 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 760:	f3 0f 1e fb          	endbr32 
 764:	55                   	push   %ebp
 765:	89 e5                	mov    %esp,%ebp
 767:	57                   	push   %edi
 768:	8b 45 10             	mov    0x10(%ebp),%eax
 76b:	8b 55 08             	mov    0x8(%ebp),%edx
 76e:	56                   	push   %esi
 76f:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 772:	85 c0                	test   %eax,%eax
 774:	7e 0f                	jle    785 <memmove+0x25>
 776:	01 d0                	add    %edx,%eax
  dst = vdst;
 778:	89 d7                	mov    %edx,%edi
 77a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
 780:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 781:	39 f8                	cmp    %edi,%eax
 783:	75 fb                	jne    780 <memmove+0x20>
  return vdst;
}
 785:	5e                   	pop    %esi
 786:	89 d0                	mov    %edx,%eax
 788:	5f                   	pop    %edi
 789:	5d                   	pop    %ebp
 78a:	c3                   	ret    

0000078b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 78b:	b8 01 00 00 00       	mov    $0x1,%eax
 790:	cd 40                	int    $0x40
 792:	c3                   	ret    

00000793 <exit>:
SYSCALL(exit)
 793:	b8 02 00 00 00       	mov    $0x2,%eax
 798:	cd 40                	int    $0x40
 79a:	c3                   	ret    

0000079b <wait>:
SYSCALL(wait)
 79b:	b8 03 00 00 00       	mov    $0x3,%eax
 7a0:	cd 40                	int    $0x40
 7a2:	c3                   	ret    

000007a3 <pipe>:
SYSCALL(pipe)
 7a3:	b8 04 00 00 00       	mov    $0x4,%eax
 7a8:	cd 40                	int    $0x40
 7aa:	c3                   	ret    

000007ab <read>:
SYSCALL(read)
 7ab:	b8 05 00 00 00       	mov    $0x5,%eax
 7b0:	cd 40                	int    $0x40
 7b2:	c3                   	ret    

000007b3 <write>:
SYSCALL(write)
 7b3:	b8 10 00 00 00       	mov    $0x10,%eax
 7b8:	cd 40                	int    $0x40
 7ba:	c3                   	ret    

000007bb <close>:
SYSCALL(close)
 7bb:	b8 15 00 00 00       	mov    $0x15,%eax
 7c0:	cd 40                	int    $0x40
 7c2:	c3                   	ret    

000007c3 <kill>:
SYSCALL(kill)
 7c3:	b8 06 00 00 00       	mov    $0x6,%eax
 7c8:	cd 40                	int    $0x40
 7ca:	c3                   	ret    

000007cb <exec>:
SYSCALL(exec)
 7cb:	b8 07 00 00 00       	mov    $0x7,%eax
 7d0:	cd 40                	int    $0x40
 7d2:	c3                   	ret    

000007d3 <open>:
SYSCALL(open)
 7d3:	b8 0f 00 00 00       	mov    $0xf,%eax
 7d8:	cd 40                	int    $0x40
 7da:	c3                   	ret    

000007db <mknod>:
SYSCALL(mknod)
 7db:	b8 11 00 00 00       	mov    $0x11,%eax
 7e0:	cd 40                	int    $0x40
 7e2:	c3                   	ret    

000007e3 <unlink>:
SYSCALL(unlink)
 7e3:	b8 12 00 00 00       	mov    $0x12,%eax
 7e8:	cd 40                	int    $0x40
 7ea:	c3                   	ret    

000007eb <fstat>:
SYSCALL(fstat)
 7eb:	b8 08 00 00 00       	mov    $0x8,%eax
 7f0:	cd 40                	int    $0x40
 7f2:	c3                   	ret    

000007f3 <link>:
SYSCALL(link)
 7f3:	b8 13 00 00 00       	mov    $0x13,%eax
 7f8:	cd 40                	int    $0x40
 7fa:	c3                   	ret    

000007fb <mkdir>:
SYSCALL(mkdir)
 7fb:	b8 14 00 00 00       	mov    $0x14,%eax
 800:	cd 40                	int    $0x40
 802:	c3                   	ret    

00000803 <chdir>:
SYSCALL(chdir)
 803:	b8 09 00 00 00       	mov    $0x9,%eax
 808:	cd 40                	int    $0x40
 80a:	c3                   	ret    

0000080b <dup>:
SYSCALL(dup)
 80b:	b8 0a 00 00 00       	mov    $0xa,%eax
 810:	cd 40                	int    $0x40
 812:	c3                   	ret    

00000813 <getpid>:
SYSCALL(getpid)
 813:	b8 0b 00 00 00       	mov    $0xb,%eax
 818:	cd 40                	int    $0x40
 81a:	c3                   	ret    

0000081b <sbrk>:
SYSCALL(sbrk)
 81b:	b8 0c 00 00 00       	mov    $0xc,%eax
 820:	cd 40                	int    $0x40
 822:	c3                   	ret    

00000823 <sleep>:
SYSCALL(sleep)
 823:	b8 0d 00 00 00       	mov    $0xd,%eax
 828:	cd 40                	int    $0x40
 82a:	c3                   	ret    

0000082b <uptime>:
SYSCALL(uptime)
 82b:	b8 0e 00 00 00       	mov    $0xe,%eax
 830:	cd 40                	int    $0x40
 832:	c3                   	ret    

00000833 <sigprocmask>:
SYSCALL(sigprocmask)
 833:	b8 16 00 00 00       	mov    $0x16,%eax
 838:	cd 40                	int    $0x40
 83a:	c3                   	ret    

0000083b <sigaction>:
SYSCALL(sigaction)
 83b:	b8 17 00 00 00       	mov    $0x17,%eax
 840:	cd 40                	int    $0x40
 842:	c3                   	ret    

00000843 <sigret>:
SYSCALL(sigret)
 843:	b8 18 00 00 00       	mov    $0x18,%eax
 848:	cd 40                	int    $0x40
 84a:	c3                   	ret    
 84b:	66 90                	xchg   %ax,%ax
 84d:	66 90                	xchg   %ax,%ax
 84f:	90                   	nop

00000850 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 850:	55                   	push   %ebp
 851:	89 e5                	mov    %esp,%ebp
 853:	57                   	push   %edi
 854:	56                   	push   %esi
 855:	53                   	push   %ebx
 856:	83 ec 3c             	sub    $0x3c,%esp
 859:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 85c:	89 d1                	mov    %edx,%ecx
{
 85e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 861:	85 d2                	test   %edx,%edx
 863:	0f 89 7f 00 00 00    	jns    8e8 <printint+0x98>
 869:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 86d:	74 79                	je     8e8 <printint+0x98>
    neg = 1;
 86f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 876:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 878:	31 db                	xor    %ebx,%ebx
 87a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 87d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 880:	89 c8                	mov    %ecx,%eax
 882:	31 d2                	xor    %edx,%edx
 884:	89 cf                	mov    %ecx,%edi
 886:	f7 75 c4             	divl   -0x3c(%ebp)
 889:	0f b6 92 14 0d 00 00 	movzbl 0xd14(%edx),%edx
 890:	89 45 c0             	mov    %eax,-0x40(%ebp)
 893:	89 d8                	mov    %ebx,%eax
 895:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 898:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 89b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 89e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 8a1:	76 dd                	jbe    880 <printint+0x30>
  if(neg)
 8a3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 8a6:	85 c9                	test   %ecx,%ecx
 8a8:	74 0c                	je     8b6 <printint+0x66>
    buf[i++] = '-';
 8aa:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 8af:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 8b1:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 8b6:	8b 7d b8             	mov    -0x48(%ebp),%edi
 8b9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 8bd:	eb 07                	jmp    8c6 <printint+0x76>
 8bf:	90                   	nop
 8c0:	0f b6 13             	movzbl (%ebx),%edx
 8c3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 8c6:	83 ec 04             	sub    $0x4,%esp
 8c9:	88 55 d7             	mov    %dl,-0x29(%ebp)
 8cc:	6a 01                	push   $0x1
 8ce:	56                   	push   %esi
 8cf:	57                   	push   %edi
 8d0:	e8 de fe ff ff       	call   7b3 <write>
  while(--i >= 0)
 8d5:	83 c4 10             	add    $0x10,%esp
 8d8:	39 de                	cmp    %ebx,%esi
 8da:	75 e4                	jne    8c0 <printint+0x70>
    putc(fd, buf[i]);
}
 8dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 8df:	5b                   	pop    %ebx
 8e0:	5e                   	pop    %esi
 8e1:	5f                   	pop    %edi
 8e2:	5d                   	pop    %ebp
 8e3:	c3                   	ret    
 8e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 8e8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 8ef:	eb 87                	jmp    878 <printint+0x28>
 8f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8ff:	90                   	nop

00000900 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 900:	f3 0f 1e fb          	endbr32 
 904:	55                   	push   %ebp
 905:	89 e5                	mov    %esp,%ebp
 907:	57                   	push   %edi
 908:	56                   	push   %esi
 909:	53                   	push   %ebx
 90a:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 90d:	8b 75 0c             	mov    0xc(%ebp),%esi
 910:	0f b6 1e             	movzbl (%esi),%ebx
 913:	84 db                	test   %bl,%bl
 915:	0f 84 b4 00 00 00    	je     9cf <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
 91b:	8d 45 10             	lea    0x10(%ebp),%eax
 91e:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 921:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 924:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 926:	89 45 d0             	mov    %eax,-0x30(%ebp)
 929:	eb 33                	jmp    95e <printf+0x5e>
 92b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 92f:	90                   	nop
 930:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 933:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 938:	83 f8 25             	cmp    $0x25,%eax
 93b:	74 17                	je     954 <printf+0x54>
  write(fd, &c, 1);
 93d:	83 ec 04             	sub    $0x4,%esp
 940:	88 5d e7             	mov    %bl,-0x19(%ebp)
 943:	6a 01                	push   $0x1
 945:	57                   	push   %edi
 946:	ff 75 08             	pushl  0x8(%ebp)
 949:	e8 65 fe ff ff       	call   7b3 <write>
 94e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 951:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 954:	0f b6 1e             	movzbl (%esi),%ebx
 957:	83 c6 01             	add    $0x1,%esi
 95a:	84 db                	test   %bl,%bl
 95c:	74 71                	je     9cf <printf+0xcf>
    c = fmt[i] & 0xff;
 95e:	0f be cb             	movsbl %bl,%ecx
 961:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 964:	85 d2                	test   %edx,%edx
 966:	74 c8                	je     930 <printf+0x30>
      }
    } else if(state == '%'){
 968:	83 fa 25             	cmp    $0x25,%edx
 96b:	75 e7                	jne    954 <printf+0x54>
      if(c == 'd'){
 96d:	83 f8 64             	cmp    $0x64,%eax
 970:	0f 84 9a 00 00 00    	je     a10 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 976:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 97c:	83 f9 70             	cmp    $0x70,%ecx
 97f:	74 5f                	je     9e0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 981:	83 f8 73             	cmp    $0x73,%eax
 984:	0f 84 d6 00 00 00    	je     a60 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 98a:	83 f8 63             	cmp    $0x63,%eax
 98d:	0f 84 8d 00 00 00    	je     a20 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 993:	83 f8 25             	cmp    $0x25,%eax
 996:	0f 84 b4 00 00 00    	je     a50 <printf+0x150>
  write(fd, &c, 1);
 99c:	83 ec 04             	sub    $0x4,%esp
 99f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 9a3:	6a 01                	push   $0x1
 9a5:	57                   	push   %edi
 9a6:	ff 75 08             	pushl  0x8(%ebp)
 9a9:	e8 05 fe ff ff       	call   7b3 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 9ae:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 9b1:	83 c4 0c             	add    $0xc,%esp
 9b4:	6a 01                	push   $0x1
 9b6:	83 c6 01             	add    $0x1,%esi
 9b9:	57                   	push   %edi
 9ba:	ff 75 08             	pushl  0x8(%ebp)
 9bd:	e8 f1 fd ff ff       	call   7b3 <write>
  for(i = 0; fmt[i]; i++){
 9c2:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 9c6:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 9c9:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 9cb:	84 db                	test   %bl,%bl
 9cd:	75 8f                	jne    95e <printf+0x5e>
    }
  }
}
 9cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
 9d2:	5b                   	pop    %ebx
 9d3:	5e                   	pop    %esi
 9d4:	5f                   	pop    %edi
 9d5:	5d                   	pop    %ebp
 9d6:	c3                   	ret    
 9d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 9de:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 9e0:	83 ec 0c             	sub    $0xc,%esp
 9e3:	b9 10 00 00 00       	mov    $0x10,%ecx
 9e8:	6a 00                	push   $0x0
 9ea:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 9ed:	8b 45 08             	mov    0x8(%ebp),%eax
 9f0:	8b 13                	mov    (%ebx),%edx
 9f2:	e8 59 fe ff ff       	call   850 <printint>
        ap++;
 9f7:	89 d8                	mov    %ebx,%eax
 9f9:	83 c4 10             	add    $0x10,%esp
      state = 0;
 9fc:	31 d2                	xor    %edx,%edx
        ap++;
 9fe:	83 c0 04             	add    $0x4,%eax
 a01:	89 45 d0             	mov    %eax,-0x30(%ebp)
 a04:	e9 4b ff ff ff       	jmp    954 <printf+0x54>
 a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 a10:	83 ec 0c             	sub    $0xc,%esp
 a13:	b9 0a 00 00 00       	mov    $0xa,%ecx
 a18:	6a 01                	push   $0x1
 a1a:	eb ce                	jmp    9ea <printf+0xea>
 a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 a20:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 a23:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 a26:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 a28:	6a 01                	push   $0x1
        ap++;
 a2a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 a2d:	57                   	push   %edi
 a2e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 a31:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 a34:	e8 7a fd ff ff       	call   7b3 <write>
        ap++;
 a39:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 a3c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 a3f:	31 d2                	xor    %edx,%edx
 a41:	e9 0e ff ff ff       	jmp    954 <printf+0x54>
 a46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a4d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 a50:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 a53:	83 ec 04             	sub    $0x4,%esp
 a56:	e9 59 ff ff ff       	jmp    9b4 <printf+0xb4>
 a5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 a5f:	90                   	nop
        s = (char*)*ap;
 a60:	8b 45 d0             	mov    -0x30(%ebp),%eax
 a63:	8b 18                	mov    (%eax),%ebx
        ap++;
 a65:	83 c0 04             	add    $0x4,%eax
 a68:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 a6b:	85 db                	test   %ebx,%ebx
 a6d:	74 17                	je     a86 <printf+0x186>
        while(*s != 0){
 a6f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 a72:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 a74:	84 c0                	test   %al,%al
 a76:	0f 84 d8 fe ff ff    	je     954 <printf+0x54>
 a7c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 a7f:	89 de                	mov    %ebx,%esi
 a81:	8b 5d 08             	mov    0x8(%ebp),%ebx
 a84:	eb 1a                	jmp    aa0 <printf+0x1a0>
          s = "(null)";
 a86:	bb 0a 0d 00 00       	mov    $0xd0a,%ebx
        while(*s != 0){
 a8b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 a8e:	b8 28 00 00 00       	mov    $0x28,%eax
 a93:	89 de                	mov    %ebx,%esi
 a95:	8b 5d 08             	mov    0x8(%ebp),%ebx
 a98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a9f:	90                   	nop
  write(fd, &c, 1);
 aa0:	83 ec 04             	sub    $0x4,%esp
          s++;
 aa3:	83 c6 01             	add    $0x1,%esi
 aa6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 aa9:	6a 01                	push   $0x1
 aab:	57                   	push   %edi
 aac:	53                   	push   %ebx
 aad:	e8 01 fd ff ff       	call   7b3 <write>
        while(*s != 0){
 ab2:	0f b6 06             	movzbl (%esi),%eax
 ab5:	83 c4 10             	add    $0x10,%esp
 ab8:	84 c0                	test   %al,%al
 aba:	75 e4                	jne    aa0 <printf+0x1a0>
 abc:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 abf:	31 d2                	xor    %edx,%edx
 ac1:	e9 8e fe ff ff       	jmp    954 <printf+0x54>
 ac6:	66 90                	xchg   %ax,%ax
 ac8:	66 90                	xchg   %ax,%ax
 aca:	66 90                	xchg   %ax,%ax
 acc:	66 90                	xchg   %ax,%ax
 ace:	66 90                	xchg   %ax,%ax

00000ad0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 ad0:	f3 0f 1e fb          	endbr32 
 ad4:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ad5:	a1 5c 10 00 00       	mov    0x105c,%eax
{
 ada:	89 e5                	mov    %esp,%ebp
 adc:	57                   	push   %edi
 add:	56                   	push   %esi
 ade:	53                   	push   %ebx
 adf:	8b 5d 08             	mov    0x8(%ebp),%ebx
 ae2:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 ae4:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ae7:	39 c8                	cmp    %ecx,%eax
 ae9:	73 15                	jae    b00 <free+0x30>
 aeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 aef:	90                   	nop
 af0:	39 d1                	cmp    %edx,%ecx
 af2:	72 14                	jb     b08 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 af4:	39 d0                	cmp    %edx,%eax
 af6:	73 10                	jae    b08 <free+0x38>
{
 af8:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 afa:	8b 10                	mov    (%eax),%edx
 afc:	39 c8                	cmp    %ecx,%eax
 afe:	72 f0                	jb     af0 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b00:	39 d0                	cmp    %edx,%eax
 b02:	72 f4                	jb     af8 <free+0x28>
 b04:	39 d1                	cmp    %edx,%ecx
 b06:	73 f0                	jae    af8 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 b08:	8b 73 fc             	mov    -0x4(%ebx),%esi
 b0b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 b0e:	39 fa                	cmp    %edi,%edx
 b10:	74 1e                	je     b30 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 b12:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 b15:	8b 50 04             	mov    0x4(%eax),%edx
 b18:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 b1b:	39 f1                	cmp    %esi,%ecx
 b1d:	74 28                	je     b47 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 b1f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 b21:	5b                   	pop    %ebx
  freep = p;
 b22:	a3 5c 10 00 00       	mov    %eax,0x105c
}
 b27:	5e                   	pop    %esi
 b28:	5f                   	pop    %edi
 b29:	5d                   	pop    %ebp
 b2a:	c3                   	ret    
 b2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 b2f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 b30:	03 72 04             	add    0x4(%edx),%esi
 b33:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 b36:	8b 10                	mov    (%eax),%edx
 b38:	8b 12                	mov    (%edx),%edx
 b3a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 b3d:	8b 50 04             	mov    0x4(%eax),%edx
 b40:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 b43:	39 f1                	cmp    %esi,%ecx
 b45:	75 d8                	jne    b1f <free+0x4f>
    p->s.size += bp->s.size;
 b47:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 b4a:	a3 5c 10 00 00       	mov    %eax,0x105c
    p->s.size += bp->s.size;
 b4f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 b52:	8b 53 f8             	mov    -0x8(%ebx),%edx
 b55:	89 10                	mov    %edx,(%eax)
}
 b57:	5b                   	pop    %ebx
 b58:	5e                   	pop    %esi
 b59:	5f                   	pop    %edi
 b5a:	5d                   	pop    %ebp
 b5b:	c3                   	ret    
 b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000b60 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b60:	f3 0f 1e fb          	endbr32 
 b64:	55                   	push   %ebp
 b65:	89 e5                	mov    %esp,%ebp
 b67:	57                   	push   %edi
 b68:	56                   	push   %esi
 b69:	53                   	push   %ebx
 b6a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 b70:	8b 3d 5c 10 00 00    	mov    0x105c,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b76:	8d 70 07             	lea    0x7(%eax),%esi
 b79:	c1 ee 03             	shr    $0x3,%esi
 b7c:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 b7f:	85 ff                	test   %edi,%edi
 b81:	0f 84 a9 00 00 00    	je     c30 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b87:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 b89:	8b 48 04             	mov    0x4(%eax),%ecx
 b8c:	39 f1                	cmp    %esi,%ecx
 b8e:	73 6d                	jae    bfd <malloc+0x9d>
 b90:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 b96:	bb 00 10 00 00       	mov    $0x1000,%ebx
 b9b:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 b9e:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 ba5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 ba8:	eb 17                	jmp    bc1 <malloc+0x61>
 baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bb0:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 bb2:	8b 4a 04             	mov    0x4(%edx),%ecx
 bb5:	39 f1                	cmp    %esi,%ecx
 bb7:	73 4f                	jae    c08 <malloc+0xa8>
 bb9:	8b 3d 5c 10 00 00    	mov    0x105c,%edi
 bbf:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 bc1:	39 c7                	cmp    %eax,%edi
 bc3:	75 eb                	jne    bb0 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 bc5:	83 ec 0c             	sub    $0xc,%esp
 bc8:	ff 75 e4             	pushl  -0x1c(%ebp)
 bcb:	e8 4b fc ff ff       	call   81b <sbrk>
  if(p == (char*)-1)
 bd0:	83 c4 10             	add    $0x10,%esp
 bd3:	83 f8 ff             	cmp    $0xffffffff,%eax
 bd6:	74 1b                	je     bf3 <malloc+0x93>
  hp->s.size = nu;
 bd8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 bdb:	83 ec 0c             	sub    $0xc,%esp
 bde:	83 c0 08             	add    $0x8,%eax
 be1:	50                   	push   %eax
 be2:	e8 e9 fe ff ff       	call   ad0 <free>
  return freep;
 be7:	a1 5c 10 00 00       	mov    0x105c,%eax
      if((p = morecore(nunits)) == 0)
 bec:	83 c4 10             	add    $0x10,%esp
 bef:	85 c0                	test   %eax,%eax
 bf1:	75 bd                	jne    bb0 <malloc+0x50>
        return 0;
  }
}
 bf3:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 bf6:	31 c0                	xor    %eax,%eax
}
 bf8:	5b                   	pop    %ebx
 bf9:	5e                   	pop    %esi
 bfa:	5f                   	pop    %edi
 bfb:	5d                   	pop    %ebp
 bfc:	c3                   	ret    
    if(p->s.size >= nunits){
 bfd:	89 c2                	mov    %eax,%edx
 bff:	89 f8                	mov    %edi,%eax
 c01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 c08:	39 ce                	cmp    %ecx,%esi
 c0a:	74 54                	je     c60 <malloc+0x100>
        p->s.size -= nunits;
 c0c:	29 f1                	sub    %esi,%ecx
 c0e:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 c11:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 c14:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 c17:	a3 5c 10 00 00       	mov    %eax,0x105c
}
 c1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 c1f:	8d 42 08             	lea    0x8(%edx),%eax
}
 c22:	5b                   	pop    %ebx
 c23:	5e                   	pop    %esi
 c24:	5f                   	pop    %edi
 c25:	5d                   	pop    %ebp
 c26:	c3                   	ret    
 c27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 c2e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 c30:	c7 05 5c 10 00 00 60 	movl   $0x1060,0x105c
 c37:	10 00 00 
    base.s.size = 0;
 c3a:	bf 60 10 00 00       	mov    $0x1060,%edi
    base.s.ptr = freep = prevp = &base;
 c3f:	c7 05 60 10 00 00 60 	movl   $0x1060,0x1060
 c46:	10 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c49:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 c4b:	c7 05 64 10 00 00 00 	movl   $0x0,0x1064
 c52:	00 00 00 
    if(p->s.size >= nunits){
 c55:	e9 36 ff ff ff       	jmp    b90 <malloc+0x30>
 c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 c60:	8b 0a                	mov    (%edx),%ecx
 c62:	89 08                	mov    %ecx,(%eax)
 c64:	eb b1                	jmp    c17 <malloc+0xb7>
