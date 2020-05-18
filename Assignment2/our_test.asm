
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
  20:	e8 a6 07 00 00       	call   7cb <wait>
    for (int i = 0; i < 20; i++){
  25:	83 eb 01             	sub    $0x1,%ebx
  28:	74 1f                	je     49 <main+0x49>
        int pid = fork();
  2a:	e8 8c 07 00 00       	call   7bb <fork>
        if (pid != 0){
  2f:	85 c0                	test   %eax,%eax
  31:	75 ed                	jne    20 <main+0x20>
        }
        else{
            printf(1, "%d\n", getpid());
  33:	e8 0b 08 00 00       	call   843 <getpid>
  38:	52                   	push   %edx
  39:	50                   	push   %eax
  3a:	68 2b 0d 00 00       	push   $0xd2b
  3f:	6a 01                	push   $0x1
  41:	e8 ea 08 00 00       	call   930 <printf>
            break;
  46:	83 c4 10             	add    $0x10,%esp
        }
    }
    exit();
  49:	e8 75 07 00 00       	call   7c3 <exit>
  4e:	66 90                	xchg   %ax,%ax

00000050 <action_handler>:
void action_handler(int signum){
  50:	f3 0f 1e fb          	endbr32 
  54:	55                   	push   %ebp
  55:	89 e5                	mov    %esp,%ebp
  57:	83 ec 0c             	sub    $0xc,%esp
    printf(1, "SIGNAL %d HANDLED\n", signum);
  5a:	ff 75 08             	pushl  0x8(%ebp)
  5d:	68 98 0c 00 00       	push   $0xc98
  62:	6a 01                	push   $0x1
  64:	e8 c7 08 00 00       	call   930 <printf>
    return;
  69:	83 c4 10             	add    $0x10,%esp
}
  6c:	c9                   	leave  
  6d:	c3                   	ret    
  6e:	66 90                	xchg   %ax,%ax

00000070 <main11>:
int main11(int argc, char** argv){
  70:	f3 0f 1e fb          	endbr32 
  74:	55                   	push   %ebp
  75:	89 e5                	mov    %esp,%ebp
  77:	53                   	push   %ebx
  for (int i = 0; i < 100; i++){
  78:	31 db                	xor    %ebx,%ebx
int main11(int argc, char** argv){
  7a:	83 ec 04             	sub    $0x4,%esp
  7d:	8d 76 00             	lea    0x0(%esi),%esi
    printf(1, "sleeping for %d\n", i);
  80:	83 ec 04             	sub    $0x4,%esp
  83:	53                   	push   %ebx
  84:	68 ab 0c 00 00       	push   $0xcab
  89:	6a 01                	push   $0x1
  8b:	e8 a0 08 00 00       	call   930 <printf>
    sleep(i);
  90:	89 1c 24             	mov    %ebx,(%esp)
  for (int i = 0; i < 100; i++){
  93:	83 c3 01             	add    $0x1,%ebx
    sleep(i);
  96:	e8 b8 07 00 00       	call   853 <sleep>
  for (int i = 0; i < 100; i++){
  9b:	83 c4 10             	add    $0x10,%esp
  9e:	83 fb 64             	cmp    $0x64,%ebx
  a1:	75 dd                	jne    80 <main11+0x10>
}
  a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  a6:	31 c0                	xor    %eax,%eax
  a8:	c9                   	leave  
  a9:	c3                   	ret    
  aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000000b0 <main20>:
int main20(int argc, char** argv){
  b0:	f3 0f 1e fb          	endbr32 
  b4:	55                   	push   %ebp
  b5:	89 e5                	mov    %esp,%ebp
  b7:	57                   	push   %edi
  ushort ss;
  ushort padding6;
};

static inline int cas(volatile void* addr, int expected, int newval){
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
  b8:	bf 02 00 00 00       	mov    $0x2,%edi
  bd:	56                   	push   %esi
  be:	be 03 00 00 00       	mov    $0x3,%esi
  c3:	53                   	push   %ebx
  c4:	8d 5d e4             	lea    -0x1c(%ebp),%ebx
  c7:	83 ec 38             	sub    $0x38,%esp
  a = 1; b = 2; c = 3;
  ca:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  printf(1,"a %d b %d c %d\n",a,b,c);
  d1:	6a 03                	push   $0x3
  d3:	6a 02                	push   $0x2
  d5:	6a 01                	push   $0x1
  d7:	68 bc 0c 00 00       	push   $0xcbc
  dc:	6a 01                	push   $0x1
  de:	e8 4d 08 00 00       	call   930 <printf>
  e3:	89 f8                	mov    %edi,%eax
  e5:	f0 0f b1 33          	lock cmpxchg %esi,(%ebx)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  e9:	9c                   	pushf  
  ea:	58                   	pop    %eax
  printf(1,"ret %d, a %d \n\n",ret, a);
  eb:	83 c4 20             	add    $0x20,%esp
 : :"r" (addr), "a" (expected), "r" (newval));
  return (readeflags() & 0x0040);
  ee:	83 e0 40             	and    $0x40,%eax
  f1:	ff 75 e4             	pushl  -0x1c(%ebp)
  f4:	50                   	push   %eax
  f5:	68 cc 0c 00 00       	push   $0xccc
  fa:	6a 01                	push   $0x1
  fc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  ff:	e8 2c 08 00 00       	call   930 <printf>
  if(ret){
 104:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 107:	83 c4 10             	add    $0x10,%esp
 10a:	85 c0                	test   %eax,%eax
 10c:	74 14                	je     122 <main20+0x72>
    printf(1,"Case %d Fail\n ",i);
 10e:	50                   	push   %eax
 10f:	6a 01                	push   $0x1
 111:	68 dc 0c 00 00       	push   $0xcdc
 116:	6a 01                	push   $0x1
 118:	e8 13 08 00 00       	call   930 <printf>
    exit();
 11d:	e8 a1 06 00 00       	call   7c3 <exit>
  printf(1,"a %d b %d c %d\n",a,b,c);
 122:	83 ec 0c             	sub    $0xc,%esp
  a = 2; b = 2; c = 3;
 125:	c7 45 e4 02 00 00 00 	movl   $0x2,-0x1c(%ebp)
  printf(1,"a %d b %d c %d\n",a,b,c);
 12c:	6a 03                	push   $0x3
 12e:	6a 02                	push   $0x2
 130:	6a 02                	push   $0x2
 132:	68 bc 0c 00 00       	push   $0xcbc
 137:	6a 01                	push   $0x1
 139:	e8 f2 07 00 00       	call   930 <printf>
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
 13e:	89 f8                	mov    %edi,%eax
 140:	f0 0f b1 33          	lock cmpxchg %esi,(%ebx)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
 144:	9c                   	pushf  
 145:	58                   	pop    %eax
  printf(1,"ret %d, a %d \n\n",ret, a);
 146:	83 c4 20             	add    $0x20,%esp
  return (readeflags() & 0x0040);
 149:	83 e0 40             	and    $0x40,%eax
 14c:	ff 75 e4             	pushl  -0x1c(%ebp)
 14f:	50                   	push   %eax
 150:	68 cc 0c 00 00       	push   $0xccc
 155:	6a 01                	push   $0x1
 157:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 15a:	e8 d1 07 00 00       	call   930 <printf>
  if(!ret){
 15f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 162:	83 c4 10             	add    $0x10,%esp
 165:	85 c0                	test   %eax,%eax
 167:	75 14                	jne    17d <main20+0xcd>
    printf(1,"Case %d Fail\n ",i);
 169:	50                   	push   %eax
 16a:	6a 02                	push   $0x2
 16c:	68 dc 0c 00 00       	push   $0xcdc
 171:	6a 01                	push   $0x1
 173:	e8 b8 07 00 00       	call   930 <printf>
    exit();
 178:	e8 46 06 00 00       	call   7c3 <exit>
  printf(1,"a %d b %d c %d\n",a,b,c);
 17d:	83 ec 0c             	sub    $0xc,%esp
  a = 3; b = 2; c = 3;
 180:	c7 45 e4 03 00 00 00 	movl   $0x3,-0x1c(%ebp)
  printf(1,"a %d b %d c %d\n",a,b,c);
 187:	6a 03                	push   $0x3
 189:	6a 02                	push   $0x2
 18b:	6a 03                	push   $0x3
 18d:	68 bc 0c 00 00       	push   $0xcbc
 192:	6a 01                	push   $0x1
 194:	e8 97 07 00 00       	call   930 <printf>
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
 199:	89 f8                	mov    %edi,%eax
 19b:	f0 0f b1 33          	lock cmpxchg %esi,(%ebx)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
 19f:	9c                   	pushf  
 1a0:	5f                   	pop    %edi
  printf(1,"ret %d, a %d \n\n",ret, a);
 1a1:	83 c4 20             	add    $0x20,%esp
  return (readeflags() & 0x0040);
 1a4:	83 e7 40             	and    $0x40,%edi
 1a7:	ff 75 e4             	pushl  -0x1c(%ebp)
 1aa:	57                   	push   %edi
 1ab:	68 cc 0c 00 00       	push   $0xccc
 1b0:	6a 01                	push   $0x1
 1b2:	e8 79 07 00 00       	call   930 <printf>
  if(ret){
 1b7:	83 c4 10             	add    $0x10,%esp
 1ba:	85 ff                	test   %edi,%edi
 1bc:	75 60                	jne    21e <main20+0x16e>
  printf(1,"a %d b %d c %d\n",a,b,c);
 1be:	83 ec 0c             	sub    $0xc,%esp
  a = 3; b = 3; c = 30;
 1c1:	c7 45 e4 03 00 00 00 	movl   $0x3,-0x1c(%ebp)
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
 1c8:	bf 1e 00 00 00       	mov    $0x1e,%edi
  printf(1,"a %d b %d c %d\n",a,b,c);
 1cd:	6a 1e                	push   $0x1e
 1cf:	6a 03                	push   $0x3
 1d1:	6a 03                	push   $0x3
 1d3:	68 bc 0c 00 00       	push   $0xcbc
 1d8:	6a 01                	push   $0x1
 1da:	e8 51 07 00 00       	call   930 <printf>
 1df:	89 f0                	mov    %esi,%eax
 1e1:	f0 0f b1 3b          	lock cmpxchg %edi,(%ebx)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
 1e5:	9c                   	pushf  
 1e6:	58                   	pop    %eax
  printf(1,"ret %d, a %d \n\n",ret, a);
 1e7:	83 c4 20             	add    $0x20,%esp
  return (readeflags() & 0x0040);
 1ea:	83 e0 40             	and    $0x40,%eax
 1ed:	ff 75 e4             	pushl  -0x1c(%ebp)
 1f0:	50                   	push   %eax
 1f1:	68 cc 0c 00 00       	push   $0xccc
 1f6:	6a 01                	push   $0x1
 1f8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 1fb:	e8 30 07 00 00       	call   930 <printf>
  if(!ret){
 200:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 203:	83 c4 10             	add    $0x10,%esp
 206:	85 c0                	test   %eax,%eax
 208:	75 28                	jne    232 <main20+0x182>
    printf(1,"Case %d Fail\n ",i);
 20a:	56                   	push   %esi
 20b:	6a 04                	push   $0x4
 20d:	68 dc 0c 00 00       	push   $0xcdc
 212:	6a 01                	push   $0x1
 214:	e8 17 07 00 00       	call   930 <printf>
    exit();
 219:	e8 a5 05 00 00       	call   7c3 <exit>
    printf(1,"Case %d Fail\n ",i);
 21e:	57                   	push   %edi
 21f:	6a 03                	push   $0x3
 221:	68 dc 0c 00 00       	push   $0xcdc
 226:	6a 01                	push   $0x1
 228:	e8 03 07 00 00       	call   930 <printf>
    exit();
 22d:	e8 91 05 00 00       	call   7c3 <exit>
  printf(1,"a %d b %d c %d\n",a,b,c);
 232:	83 ec 0c             	sub    $0xc,%esp
  a = 2; b = 4; c = 3;
 235:	c7 45 e4 02 00 00 00 	movl   $0x2,-0x1c(%ebp)
  printf(1,"a %d b %d c %d\n",a,b,c);
 23c:	6a 03                	push   $0x3
 23e:	6a 04                	push   $0x4
 240:	6a 02                	push   $0x2
 242:	68 bc 0c 00 00       	push   $0xcbc
 247:	6a 01                	push   $0x1
 249:	e8 e2 06 00 00       	call   930 <printf>
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
 24e:	b8 04 00 00 00       	mov    $0x4,%eax
 253:	f0 0f b1 33          	lock cmpxchg %esi,(%ebx)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
 257:	9c                   	pushf  
 258:	5e                   	pop    %esi
  printf(1,"ret %d, a %d \n\n",ret, a);
 259:	83 c4 20             	add    $0x20,%esp
  return (readeflags() & 0x0040);
 25c:	83 e6 40             	and    $0x40,%esi
 25f:	ff 75 e4             	pushl  -0x1c(%ebp)
 262:	56                   	push   %esi
 263:	68 cc 0c 00 00       	push   $0xccc
 268:	6a 01                	push   $0x1
 26a:	e8 c1 06 00 00       	call   930 <printf>
  if(ret){
 26f:	83 c4 10             	add    $0x10,%esp
 272:	85 f6                	test   %esi,%esi
 274:	75 58                	jne    2ce <main20+0x21e>
  printf(1,"a %d b %d c %d\n",a,b,c);
 276:	83 ec 0c             	sub    $0xc,%esp
   a = 3; b = 4; c = 30;
 279:	c7 45 e4 03 00 00 00 	movl   $0x3,-0x1c(%ebp)
  printf(1,"a %d b %d c %d\n",a,b,c);
 280:	6a 1e                	push   $0x1e
 282:	6a 04                	push   $0x4
 284:	6a 03                	push   $0x3
 286:	68 bc 0c 00 00       	push   $0xcbc
 28b:	6a 01                	push   $0x1
 28d:	e8 9e 06 00 00       	call   930 <printf>
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
 292:	b8 04 00 00 00       	mov    $0x4,%eax
 297:	f0 0f b1 3b          	lock cmpxchg %edi,(%ebx)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
 29b:	9c                   	pushf  
 29c:	5e                   	pop    %esi
  printf(1,"ret %d, a %d \n\n",ret, a);
 29d:	83 c4 20             	add    $0x20,%esp
  return (readeflags() & 0x0040);
 2a0:	83 e6 40             	and    $0x40,%esi
 2a3:	ff 75 e4             	pushl  -0x1c(%ebp)
 2a6:	56                   	push   %esi
 2a7:	68 cc 0c 00 00       	push   $0xccc
 2ac:	6a 01                	push   $0x1
 2ae:	e8 7d 06 00 00       	call   930 <printf>
  if(ret){
 2b3:	83 c4 10             	add    $0x10,%esp
 2b6:	85 f6                	test   %esi,%esi
 2b8:	74 28                	je     2e2 <main20+0x232>
    printf(1,"Case %d Fail\n ",i);
 2ba:	51                   	push   %ecx
 2bb:	6a 06                	push   $0x6
 2bd:	68 dc 0c 00 00       	push   $0xcdc
 2c2:	6a 01                	push   $0x1
 2c4:	e8 67 06 00 00       	call   930 <printf>
    exit();
 2c9:	e8 f5 04 00 00       	call   7c3 <exit>
    printf(1,"Case i %d Fail\n ",i);
 2ce:	53                   	push   %ebx
 2cf:	6a 05                	push   $0x5
 2d1:	68 eb 0c 00 00       	push   $0xceb
 2d6:	6a 01                	push   $0x1
 2d8:	e8 53 06 00 00       	call   930 <printf>
    exit();
 2dd:	e8 e1 04 00 00       	call   7c3 <exit>
  printf(1,"a %d b %d c %d\n",a,b,c);
 2e2:	83 ec 0c             	sub    $0xc,%esp
   a = 4; b = 4; c = 30;
 2e5:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
  printf(1,"a %d b %d c %d\n",a,b,c);
 2ec:	6a 1e                	push   $0x1e
 2ee:	6a 04                	push   $0x4
 2f0:	6a 04                	push   $0x4
 2f2:	68 bc 0c 00 00       	push   $0xcbc
 2f7:	6a 01                	push   $0x1
 2f9:	e8 32 06 00 00       	call   930 <printf>
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
 2fe:	b8 04 00 00 00       	mov    $0x4,%eax
 303:	f0 0f b1 3b          	lock cmpxchg %edi,(%ebx)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
 307:	9c                   	pushf  
 308:	5b                   	pop    %ebx
  printf(1,"ret %d, a %d \n\n",ret, a);
 309:	83 c4 20             	add    $0x20,%esp
  return (readeflags() & 0x0040);
 30c:	83 e3 40             	and    $0x40,%ebx
 30f:	ff 75 e4             	pushl  -0x1c(%ebp)
 312:	53                   	push   %ebx
 313:	68 cc 0c 00 00       	push   $0xccc
 318:	6a 01                	push   $0x1
 31a:	e8 11 06 00 00       	call   930 <printf>
  if(!ret){
 31f:	83 c4 10             	add    $0x10,%esp
 322:	85 db                	test   %ebx,%ebx
 324:	75 14                	jne    33a <main20+0x28a>
    printf(1,"Case %d Fail\n ",i);
 326:	52                   	push   %edx
 327:	6a 07                	push   $0x7
 329:	68 dc 0c 00 00       	push   $0xcdc
 32e:	6a 01                	push   $0x1
 330:	e8 fb 05 00 00       	call   930 <printf>
    exit();
 335:	e8 89 04 00 00       	call   7c3 <exit>
  printf(1,"All Tests passed\n");
 33a:	50                   	push   %eax
 33b:	50                   	push   %eax
 33c:	68 fc 0c 00 00       	push   $0xcfc
 341:	6a 01                	push   $0x1
 343:	e8 e8 05 00 00       	call   930 <printf>
  exit();
 348:	e8 76 04 00 00       	call   7c3 <exit>
 34d:	8d 76 00             	lea    0x0(%esi),%esi

00000350 <main1>:
}

int main1(int argc, char** argv){
 350:	f3 0f 1e fb          	endbr32 
 354:	55                   	push   %ebp
 355:	89 e5                	mov    %esp,%ebp
 357:	53                   	push   %ebx
    struct sigaction sigact = {action_handler, 0};
    sigaction(1, &sigact, null);
 358:	8d 45 f0             	lea    -0x10(%ebp),%eax
int main1(int argc, char** argv){
 35b:	83 ec 18             	sub    $0x18,%esp
    struct sigaction sigact = {action_handler, 0};
 35e:	c7 45 f0 50 00 00 00 	movl   $0x50,-0x10(%ebp)
    sigaction(1, &sigact, null);
 365:	6a 00                	push   $0x0
 367:	50                   	push   %eax
 368:	6a 01                	push   $0x1
    struct sigaction sigact = {action_handler, 0};
 36a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    sigaction(1, &sigact, null);
 371:	e8 f5 04 00 00       	call   86b <sigaction>
    kill(getpid(), 1);
 376:	e8 c8 04 00 00       	call   843 <getpid>
 37b:	5a                   	pop    %edx
 37c:	59                   	pop    %ecx
 37d:	6a 01                	push   $0x1
 37f:	50                   	push   %eax
 380:	e8 6e 04 00 00       	call   7f3 <kill>
    kill(getpid(), 9);
 385:	e8 b9 04 00 00       	call   843 <getpid>
 38a:	5b                   	pop    %ebx
 38b:	5a                   	pop    %edx
 38c:	6a 09                	push   $0x9
 38e:	50                   	push   %eax

    for (int i = 0; i < 1000000; i++){
 38f:	31 db                	xor    %ebx,%ebx
    kill(getpid(), 9);
 391:	e8 5d 04 00 00       	call   7f3 <kill>
 396:	83 c4 10             	add    $0x10,%esp
 399:	eb 22                	jmp    3bd <main1+0x6d>
 39b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 39f:	90                   	nop
            if (i % 1000 == 0){
                printf(1, "hi\n");
            }
            printf(1, "");
 3a0:	83 ec 08             	sub    $0x8,%esp
    for (int i = 0; i < 1000000; i++){
 3a3:	83 c3 01             	add    $0x1,%ebx
            printf(1, "");
 3a6:	68 db 0c 00 00       	push   $0xcdb
 3ab:	6a 01                	push   $0x1
 3ad:	e8 7e 05 00 00       	call   930 <printf>
    for (int i = 0; i < 1000000; i++){
 3b2:	83 c4 10             	add    $0x10,%esp
 3b5:	81 fb 40 42 0f 00    	cmp    $0xf4240,%ebx
 3bb:	74 24                	je     3e1 <main1+0x91>
    kill(getpid(), 9);
 3bd:	69 c3 d5 78 e9 26    	imul   $0x26e978d5,%ebx,%eax
 3c3:	c1 c8 03             	ror    $0x3,%eax
            if (i % 1000 == 0){
 3c6:	3d 37 89 41 00       	cmp    $0x418937,%eax
 3cb:	77 d3                	ja     3a0 <main1+0x50>
                printf(1, "hi\n");
 3cd:	83 ec 08             	sub    $0x8,%esp
 3d0:	68 0e 0d 00 00       	push   $0xd0e
 3d5:	6a 01                	push   $0x1
 3d7:	e8 54 05 00 00       	call   930 <printf>
 3dc:	83 c4 10             	add    $0x10,%esp
 3df:	eb bf                	jmp    3a0 <main1+0x50>
        }
    return 0;
}
 3e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 3e4:	31 c0                	xor    %eax,%eax
 3e6:	c9                   	leave  
 3e7:	c3                   	ret    
 3e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3ef:	90                   	nop

000003f0 <main2>:

int main2(int argc, char** argv){
 3f0:	f3 0f 1e fb          	endbr32 
 3f4:	55                   	push   %ebp
 3f5:	89 e5                	mov    %esp,%ebp
 3f7:	56                   	push   %esi
 3f8:	53                   	push   %ebx
 3f9:	83 ec 10             	sub    $0x10,%esp
    struct sigaction sigact = {action_handler, 0};
 3fc:	c7 45 f0 50 00 00 00 	movl   $0x50,-0x10(%ebp)
 403:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int pid = fork();
 40a:	e8 ac 03 00 00       	call   7bb <fork>
 40f:	89 c3                	mov    %eax,%ebx
    if (pid == 0){
 411:	85 c0                	test   %eax,%eax
 413:	0f 85 8c 00 00 00    	jne    4a5 <main2+0xb5>
        printf(1, "childs here");
 419:	50                   	push   %eax
        sigaction(1, &sigact, null);
 41a:	8d 75 f0             	lea    -0x10(%ebp),%esi
        printf(1, "childs here");
 41d:	50                   	push   %eax
 41e:	68 12 0d 00 00       	push   $0xd12
 423:	6a 01                	push   $0x1
 425:	e8 06 05 00 00       	call   930 <printf>
        sigaction(1, &sigact, null);
 42a:	83 c4 0c             	add    $0xc,%esp
 42d:	6a 00                	push   $0x0
 42f:	56                   	push   %esi
 430:	6a 01                	push   $0x1
 432:	e8 34 04 00 00       	call   86b <sigaction>
        sigaction(2, &sigact, null);
 437:	83 c4 0c             	add    $0xc,%esp
 43a:	6a 00                	push   $0x0
 43c:	56                   	push   %esi
 43d:	6a 02                	push   $0x2
 43f:	e8 27 04 00 00       	call   86b <sigaction>
        sigaction(3, &sigact, null);
 444:	83 c4 0c             	add    $0xc,%esp
 447:	6a 00                	push   $0x0
 449:	56                   	push   %esi
 44a:	6a 03                	push   $0x3
 44c:	e8 1a 04 00 00       	call   86b <sigaction>
 451:	83 c4 10             	add    $0x10,%esp
 454:	eb 2b                	jmp    481 <main2+0x91>
 456:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 45d:	8d 76 00             	lea    0x0(%esi),%esi
        for (int i = 0; i < 1000000; i++){
            if (i % 1000 == 0){
                printf(1, "hi\n");
            }
            printf(1, "");
 460:	83 ec 08             	sub    $0x8,%esp
        for (int i = 0; i < 1000000; i++){
 463:	83 c3 01             	add    $0x1,%ebx
            printf(1, "");
 466:	68 db 0c 00 00       	push   $0xcdb
 46b:	6a 01                	push   $0x1
 46d:	e8 be 04 00 00       	call   930 <printf>
        for (int i = 0; i < 1000000; i++){
 472:	83 c4 10             	add    $0x10,%esp
 475:	81 fb 40 42 0f 00    	cmp    $0xf4240,%ebx
 47b:	0f 84 d1 00 00 00    	je     552 <main2+0x162>
        sigaction(3, &sigact, null);
 481:	69 c3 d5 78 e9 26    	imul   $0x26e978d5,%ebx,%eax
 487:	c1 c8 03             	ror    $0x3,%eax
            if (i % 1000 == 0){
 48a:	3d 37 89 41 00       	cmp    $0x418937,%eax
 48f:	77 cf                	ja     460 <main2+0x70>
                printf(1, "hi\n");
 491:	83 ec 08             	sub    $0x8,%esp
 494:	68 0e 0d 00 00       	push   $0xd0e
 499:	6a 01                	push   $0x1
 49b:	e8 90 04 00 00       	call   930 <printf>
 4a0:	83 c4 10             	add    $0x10,%esp
 4a3:	eb bb                	jmp    460 <main2+0x70>
        }
    }
    else{
        printf(1, "childs pid : %d\n", pid);
 4a5:	50                   	push   %eax
 4a6:	53                   	push   %ebx
 4a7:	68 1e 0d 00 00       	push   $0xd1e
 4ac:	6a 01                	push   $0x1
 4ae:	e8 7d 04 00 00       	call   930 <printf>
        sleep(100);
 4b3:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
 4ba:	e8 94 03 00 00       	call   853 <sleep>
        printf(1, "sending signal %d to child\n", 1);
 4bf:	83 c4 0c             	add    $0xc,%esp
 4c2:	6a 01                	push   $0x1
 4c4:	68 2f 0d 00 00       	push   $0xd2f
 4c9:	6a 01                	push   $0x1
 4cb:	e8 60 04 00 00       	call   930 <printf>
        kill(pid, 1);
 4d0:	5a                   	pop    %edx
 4d1:	59                   	pop    %ecx
 4d2:	6a 01                	push   $0x1
 4d4:	53                   	push   %ebx
 4d5:	e8 19 03 00 00       	call   7f3 <kill>
        sleep(100);
 4da:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
 4e1:	e8 6d 03 00 00       	call   853 <sleep>
        printf(1, "sending signal %d to child\n", 2);
 4e6:	83 c4 0c             	add    $0xc,%esp
 4e9:	6a 02                	push   $0x2
 4eb:	68 2f 0d 00 00       	push   $0xd2f
 4f0:	6a 01                	push   $0x1
 4f2:	e8 39 04 00 00       	call   930 <printf>
        kill(pid, 2);
 4f7:	5e                   	pop    %esi
 4f8:	58                   	pop    %eax
 4f9:	6a 02                	push   $0x2
 4fb:	53                   	push   %ebx
 4fc:	e8 f2 02 00 00       	call   7f3 <kill>
        sleep(100);
 501:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
 508:	e8 46 03 00 00       	call   853 <sleep>
        printf(1, "sending signal %d to child\n", 3);
 50d:	83 c4 0c             	add    $0xc,%esp
 510:	6a 03                	push   $0x3
 512:	68 2f 0d 00 00       	push   $0xd2f
 517:	6a 01                	push   $0x1
 519:	e8 12 04 00 00       	call   930 <printf>
        kill(pid, 3);
 51e:	58                   	pop    %eax
 51f:	5a                   	pop    %edx
 520:	6a 03                	push   $0x3
 522:	53                   	push   %ebx
 523:	e8 cb 02 00 00       	call   7f3 <kill>
        sleep(100);
 528:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
 52f:	e8 1f 03 00 00       	call   853 <sleep>
        kill(pid, 9);
 534:	59                   	pop    %ecx
 535:	5e                   	pop    %esi
 536:	6a 09                	push   $0x9
 538:	53                   	push   %ebx
 539:	e8 b5 02 00 00       	call   7f3 <kill>

        wait();
 53e:	e8 88 02 00 00       	call   7cb <wait>
        sleep(300);
 543:	c7 04 24 2c 01 00 00 	movl   $0x12c,(%esp)
 54a:	e8 04 03 00 00       	call   853 <sleep>
 54f:	83 c4 10             	add    $0x10,%esp


    }
    exit();
 552:	e8 6c 02 00 00       	call   7c3 <exit>
 557:	66 90                	xchg   %ax,%ax
 559:	66 90                	xchg   %ax,%ax
 55b:	66 90                	xchg   %ax,%ax
 55d:	66 90                	xchg   %ax,%ax
 55f:	90                   	nop

00000560 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 560:	f3 0f 1e fb          	endbr32 
 564:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 565:	31 c0                	xor    %eax,%eax
{
 567:	89 e5                	mov    %esp,%ebp
 569:	53                   	push   %ebx
 56a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 56d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
 570:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 574:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 577:	83 c0 01             	add    $0x1,%eax
 57a:	84 d2                	test   %dl,%dl
 57c:	75 f2                	jne    570 <strcpy+0x10>
    ;
  return os;
}
 57e:	89 c8                	mov    %ecx,%eax
 580:	5b                   	pop    %ebx
 581:	5d                   	pop    %ebp
 582:	c3                   	ret    
 583:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 58a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000590 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 590:	f3 0f 1e fb          	endbr32 
 594:	55                   	push   %ebp
 595:	89 e5                	mov    %esp,%ebp
 597:	53                   	push   %ebx
 598:	8b 4d 08             	mov    0x8(%ebp),%ecx
 59b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 59e:	0f b6 01             	movzbl (%ecx),%eax
 5a1:	0f b6 1a             	movzbl (%edx),%ebx
 5a4:	84 c0                	test   %al,%al
 5a6:	75 19                	jne    5c1 <strcmp+0x31>
 5a8:	eb 26                	jmp    5d0 <strcmp+0x40>
 5aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 5b0:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 5b4:	83 c1 01             	add    $0x1,%ecx
 5b7:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 5ba:	0f b6 1a             	movzbl (%edx),%ebx
 5bd:	84 c0                	test   %al,%al
 5bf:	74 0f                	je     5d0 <strcmp+0x40>
 5c1:	38 d8                	cmp    %bl,%al
 5c3:	74 eb                	je     5b0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 5c5:	29 d8                	sub    %ebx,%eax
}
 5c7:	5b                   	pop    %ebx
 5c8:	5d                   	pop    %ebp
 5c9:	c3                   	ret    
 5ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 5d0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 5d2:	29 d8                	sub    %ebx,%eax
}
 5d4:	5b                   	pop    %ebx
 5d5:	5d                   	pop    %ebp
 5d6:	c3                   	ret    
 5d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5de:	66 90                	xchg   %ax,%ax

000005e0 <strlen>:

uint
strlen(const char *s)
{
 5e0:	f3 0f 1e fb          	endbr32 
 5e4:	55                   	push   %ebp
 5e5:	89 e5                	mov    %esp,%ebp
 5e7:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 5ea:	80 3a 00             	cmpb   $0x0,(%edx)
 5ed:	74 21                	je     610 <strlen+0x30>
 5ef:	31 c0                	xor    %eax,%eax
 5f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5f8:	83 c0 01             	add    $0x1,%eax
 5fb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 5ff:	89 c1                	mov    %eax,%ecx
 601:	75 f5                	jne    5f8 <strlen+0x18>
    ;
  return n;
}
 603:	89 c8                	mov    %ecx,%eax
 605:	5d                   	pop    %ebp
 606:	c3                   	ret    
 607:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 60e:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
 610:	31 c9                	xor    %ecx,%ecx
}
 612:	5d                   	pop    %ebp
 613:	89 c8                	mov    %ecx,%eax
 615:	c3                   	ret    
 616:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 61d:	8d 76 00             	lea    0x0(%esi),%esi

00000620 <memset>:

void*
memset(void *dst, int c, uint n)
{
 620:	f3 0f 1e fb          	endbr32 
 624:	55                   	push   %ebp
 625:	89 e5                	mov    %esp,%ebp
 627:	57                   	push   %edi
 628:	8b 55 08             	mov    0x8(%ebp),%edx
  asm volatile("cld; rep stosb" :
 62b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 62e:	8b 45 0c             	mov    0xc(%ebp),%eax
 631:	89 d7                	mov    %edx,%edi
 633:	fc                   	cld    
 634:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 636:	89 d0                	mov    %edx,%eax
 638:	5f                   	pop    %edi
 639:	5d                   	pop    %ebp
 63a:	c3                   	ret    
 63b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 63f:	90                   	nop

00000640 <strchr>:

char*
strchr(const char *s, char c)
{
 640:	f3 0f 1e fb          	endbr32 
 644:	55                   	push   %ebp
 645:	89 e5                	mov    %esp,%ebp
 647:	8b 45 08             	mov    0x8(%ebp),%eax
 64a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 64e:	0f b6 10             	movzbl (%eax),%edx
 651:	84 d2                	test   %dl,%dl
 653:	75 16                	jne    66b <strchr+0x2b>
 655:	eb 21                	jmp    678 <strchr+0x38>
 657:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 65e:	66 90                	xchg   %ax,%ax
 660:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 664:	83 c0 01             	add    $0x1,%eax
 667:	84 d2                	test   %dl,%dl
 669:	74 0d                	je     678 <strchr+0x38>
    if(*s == c)
 66b:	38 d1                	cmp    %dl,%cl
 66d:	75 f1                	jne    660 <strchr+0x20>
      return (char*)s;
  return 0;
}
 66f:	5d                   	pop    %ebp
 670:	c3                   	ret    
 671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 678:	31 c0                	xor    %eax,%eax
}
 67a:	5d                   	pop    %ebp
 67b:	c3                   	ret    
 67c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000680 <gets>:

char*
gets(char *buf, int max)
{
 680:	f3 0f 1e fb          	endbr32 
 684:	55                   	push   %ebp
 685:	89 e5                	mov    %esp,%ebp
 687:	57                   	push   %edi
 688:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 689:	31 f6                	xor    %esi,%esi
{
 68b:	53                   	push   %ebx
 68c:	89 f3                	mov    %esi,%ebx
 68e:	83 ec 1c             	sub    $0x1c,%esp
 691:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 694:	eb 33                	jmp    6c9 <gets+0x49>
 696:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 69d:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 6a0:	83 ec 04             	sub    $0x4,%esp
 6a3:	8d 45 e7             	lea    -0x19(%ebp),%eax
 6a6:	6a 01                	push   $0x1
 6a8:	50                   	push   %eax
 6a9:	6a 00                	push   $0x0
 6ab:	e8 2b 01 00 00       	call   7db <read>
    if(cc < 1)
 6b0:	83 c4 10             	add    $0x10,%esp
 6b3:	85 c0                	test   %eax,%eax
 6b5:	7e 1c                	jle    6d3 <gets+0x53>
      break;
    buf[i++] = c;
 6b7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 6bb:	83 c7 01             	add    $0x1,%edi
 6be:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 6c1:	3c 0a                	cmp    $0xa,%al
 6c3:	74 23                	je     6e8 <gets+0x68>
 6c5:	3c 0d                	cmp    $0xd,%al
 6c7:	74 1f                	je     6e8 <gets+0x68>
  for(i=0; i+1 < max; ){
 6c9:	83 c3 01             	add    $0x1,%ebx
 6cc:	89 fe                	mov    %edi,%esi
 6ce:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 6d1:	7c cd                	jl     6a0 <gets+0x20>
 6d3:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 6d5:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 6d8:	c6 03 00             	movb   $0x0,(%ebx)
}
 6db:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6de:	5b                   	pop    %ebx
 6df:	5e                   	pop    %esi
 6e0:	5f                   	pop    %edi
 6e1:	5d                   	pop    %ebp
 6e2:	c3                   	ret    
 6e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6e7:	90                   	nop
 6e8:	8b 75 08             	mov    0x8(%ebp),%esi
 6eb:	8b 45 08             	mov    0x8(%ebp),%eax
 6ee:	01 de                	add    %ebx,%esi
 6f0:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 6f2:	c6 03 00             	movb   $0x0,(%ebx)
}
 6f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6f8:	5b                   	pop    %ebx
 6f9:	5e                   	pop    %esi
 6fa:	5f                   	pop    %edi
 6fb:	5d                   	pop    %ebp
 6fc:	c3                   	ret    
 6fd:	8d 76 00             	lea    0x0(%esi),%esi

00000700 <stat>:

int
stat(const char *n, struct stat *st)
{
 700:	f3 0f 1e fb          	endbr32 
 704:	55                   	push   %ebp
 705:	89 e5                	mov    %esp,%ebp
 707:	56                   	push   %esi
 708:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 709:	83 ec 08             	sub    $0x8,%esp
 70c:	6a 00                	push   $0x0
 70e:	ff 75 08             	pushl  0x8(%ebp)
 711:	e8 ed 00 00 00       	call   803 <open>
  if(fd < 0)
 716:	83 c4 10             	add    $0x10,%esp
 719:	85 c0                	test   %eax,%eax
 71b:	78 2b                	js     748 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 71d:	83 ec 08             	sub    $0x8,%esp
 720:	ff 75 0c             	pushl  0xc(%ebp)
 723:	89 c3                	mov    %eax,%ebx
 725:	50                   	push   %eax
 726:	e8 f0 00 00 00       	call   81b <fstat>
  close(fd);
 72b:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 72e:	89 c6                	mov    %eax,%esi
  close(fd);
 730:	e8 b6 00 00 00       	call   7eb <close>
  return r;
 735:	83 c4 10             	add    $0x10,%esp
}
 738:	8d 65 f8             	lea    -0x8(%ebp),%esp
 73b:	89 f0                	mov    %esi,%eax
 73d:	5b                   	pop    %ebx
 73e:	5e                   	pop    %esi
 73f:	5d                   	pop    %ebp
 740:	c3                   	ret    
 741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 748:	be ff ff ff ff       	mov    $0xffffffff,%esi
 74d:	eb e9                	jmp    738 <stat+0x38>
 74f:	90                   	nop

00000750 <atoi>:

int
atoi(const char *s)
{
 750:	f3 0f 1e fb          	endbr32 
 754:	55                   	push   %ebp
 755:	89 e5                	mov    %esp,%ebp
 757:	53                   	push   %ebx
 758:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 75b:	0f be 02             	movsbl (%edx),%eax
 75e:	8d 48 d0             	lea    -0x30(%eax),%ecx
 761:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 764:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 769:	77 1a                	ja     785 <atoi+0x35>
 76b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 76f:	90                   	nop
    n = n*10 + *s++ - '0';
 770:	83 c2 01             	add    $0x1,%edx
 773:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 776:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 77a:	0f be 02             	movsbl (%edx),%eax
 77d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 780:	80 fb 09             	cmp    $0x9,%bl
 783:	76 eb                	jbe    770 <atoi+0x20>
  return n;
}
 785:	89 c8                	mov    %ecx,%eax
 787:	5b                   	pop    %ebx
 788:	5d                   	pop    %ebp
 789:	c3                   	ret    
 78a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000790 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 790:	f3 0f 1e fb          	endbr32 
 794:	55                   	push   %ebp
 795:	89 e5                	mov    %esp,%ebp
 797:	57                   	push   %edi
 798:	8b 45 10             	mov    0x10(%ebp),%eax
 79b:	8b 55 08             	mov    0x8(%ebp),%edx
 79e:	56                   	push   %esi
 79f:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 7a2:	85 c0                	test   %eax,%eax
 7a4:	7e 0f                	jle    7b5 <memmove+0x25>
 7a6:	01 d0                	add    %edx,%eax
  dst = vdst;
 7a8:	89 d7                	mov    %edx,%edi
 7aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
 7b0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 7b1:	39 f8                	cmp    %edi,%eax
 7b3:	75 fb                	jne    7b0 <memmove+0x20>
  return vdst;
}
 7b5:	5e                   	pop    %esi
 7b6:	89 d0                	mov    %edx,%eax
 7b8:	5f                   	pop    %edi
 7b9:	5d                   	pop    %ebp
 7ba:	c3                   	ret    

000007bb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 7bb:	b8 01 00 00 00       	mov    $0x1,%eax
 7c0:	cd 40                	int    $0x40
 7c2:	c3                   	ret    

000007c3 <exit>:
SYSCALL(exit)
 7c3:	b8 02 00 00 00       	mov    $0x2,%eax
 7c8:	cd 40                	int    $0x40
 7ca:	c3                   	ret    

000007cb <wait>:
SYSCALL(wait)
 7cb:	b8 03 00 00 00       	mov    $0x3,%eax
 7d0:	cd 40                	int    $0x40
 7d2:	c3                   	ret    

000007d3 <pipe>:
SYSCALL(pipe)
 7d3:	b8 04 00 00 00       	mov    $0x4,%eax
 7d8:	cd 40                	int    $0x40
 7da:	c3                   	ret    

000007db <read>:
SYSCALL(read)
 7db:	b8 05 00 00 00       	mov    $0x5,%eax
 7e0:	cd 40                	int    $0x40
 7e2:	c3                   	ret    

000007e3 <write>:
SYSCALL(write)
 7e3:	b8 10 00 00 00       	mov    $0x10,%eax
 7e8:	cd 40                	int    $0x40
 7ea:	c3                   	ret    

000007eb <close>:
SYSCALL(close)
 7eb:	b8 15 00 00 00       	mov    $0x15,%eax
 7f0:	cd 40                	int    $0x40
 7f2:	c3                   	ret    

000007f3 <kill>:
SYSCALL(kill)
 7f3:	b8 06 00 00 00       	mov    $0x6,%eax
 7f8:	cd 40                	int    $0x40
 7fa:	c3                   	ret    

000007fb <exec>:
SYSCALL(exec)
 7fb:	b8 07 00 00 00       	mov    $0x7,%eax
 800:	cd 40                	int    $0x40
 802:	c3                   	ret    

00000803 <open>:
SYSCALL(open)
 803:	b8 0f 00 00 00       	mov    $0xf,%eax
 808:	cd 40                	int    $0x40
 80a:	c3                   	ret    

0000080b <mknod>:
SYSCALL(mknod)
 80b:	b8 11 00 00 00       	mov    $0x11,%eax
 810:	cd 40                	int    $0x40
 812:	c3                   	ret    

00000813 <unlink>:
SYSCALL(unlink)
 813:	b8 12 00 00 00       	mov    $0x12,%eax
 818:	cd 40                	int    $0x40
 81a:	c3                   	ret    

0000081b <fstat>:
SYSCALL(fstat)
 81b:	b8 08 00 00 00       	mov    $0x8,%eax
 820:	cd 40                	int    $0x40
 822:	c3                   	ret    

00000823 <link>:
SYSCALL(link)
 823:	b8 13 00 00 00       	mov    $0x13,%eax
 828:	cd 40                	int    $0x40
 82a:	c3                   	ret    

0000082b <mkdir>:
SYSCALL(mkdir)
 82b:	b8 14 00 00 00       	mov    $0x14,%eax
 830:	cd 40                	int    $0x40
 832:	c3                   	ret    

00000833 <chdir>:
SYSCALL(chdir)
 833:	b8 09 00 00 00       	mov    $0x9,%eax
 838:	cd 40                	int    $0x40
 83a:	c3                   	ret    

0000083b <dup>:
SYSCALL(dup)
 83b:	b8 0a 00 00 00       	mov    $0xa,%eax
 840:	cd 40                	int    $0x40
 842:	c3                   	ret    

00000843 <getpid>:
SYSCALL(getpid)
 843:	b8 0b 00 00 00       	mov    $0xb,%eax
 848:	cd 40                	int    $0x40
 84a:	c3                   	ret    

0000084b <sbrk>:
SYSCALL(sbrk)
 84b:	b8 0c 00 00 00       	mov    $0xc,%eax
 850:	cd 40                	int    $0x40
 852:	c3                   	ret    

00000853 <sleep>:
SYSCALL(sleep)
 853:	b8 0d 00 00 00       	mov    $0xd,%eax
 858:	cd 40                	int    $0x40
 85a:	c3                   	ret    

0000085b <uptime>:
SYSCALL(uptime)
 85b:	b8 0e 00 00 00       	mov    $0xe,%eax
 860:	cd 40                	int    $0x40
 862:	c3                   	ret    

00000863 <sigprocmask>:
SYSCALL(sigprocmask)
 863:	b8 16 00 00 00       	mov    $0x16,%eax
 868:	cd 40                	int    $0x40
 86a:	c3                   	ret    

0000086b <sigaction>:
SYSCALL(sigaction)
 86b:	b8 17 00 00 00       	mov    $0x17,%eax
 870:	cd 40                	int    $0x40
 872:	c3                   	ret    

00000873 <sigret>:
SYSCALL(sigret)
 873:	b8 18 00 00 00       	mov    $0x18,%eax
 878:	cd 40                	int    $0x40
 87a:	c3                   	ret    
 87b:	66 90                	xchg   %ax,%ax
 87d:	66 90                	xchg   %ax,%ax
 87f:	90                   	nop

00000880 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 880:	55                   	push   %ebp
 881:	89 e5                	mov    %esp,%ebp
 883:	57                   	push   %edi
 884:	56                   	push   %esi
 885:	53                   	push   %ebx
 886:	83 ec 3c             	sub    $0x3c,%esp
 889:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 88c:	89 d1                	mov    %edx,%ecx
{
 88e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 891:	85 d2                	test   %edx,%edx
 893:	0f 89 7f 00 00 00    	jns    918 <printint+0x98>
 899:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 89d:	74 79                	je     918 <printint+0x98>
    neg = 1;
 89f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 8a6:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 8a8:	31 db                	xor    %ebx,%ebx
 8aa:	8d 75 d7             	lea    -0x29(%ebp),%esi
 8ad:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 8b0:	89 c8                	mov    %ecx,%eax
 8b2:	31 d2                	xor    %edx,%edx
 8b4:	89 cf                	mov    %ecx,%edi
 8b6:	f7 75 c4             	divl   -0x3c(%ebp)
 8b9:	0f b6 92 54 0d 00 00 	movzbl 0xd54(%edx),%edx
 8c0:	89 45 c0             	mov    %eax,-0x40(%ebp)
 8c3:	89 d8                	mov    %ebx,%eax
 8c5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 8c8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 8cb:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 8ce:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 8d1:	76 dd                	jbe    8b0 <printint+0x30>
  if(neg)
 8d3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 8d6:	85 c9                	test   %ecx,%ecx
 8d8:	74 0c                	je     8e6 <printint+0x66>
    buf[i++] = '-';
 8da:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 8df:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 8e1:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 8e6:	8b 7d b8             	mov    -0x48(%ebp),%edi
 8e9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 8ed:	eb 07                	jmp    8f6 <printint+0x76>
 8ef:	90                   	nop
 8f0:	0f b6 13             	movzbl (%ebx),%edx
 8f3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 8f6:	83 ec 04             	sub    $0x4,%esp
 8f9:	88 55 d7             	mov    %dl,-0x29(%ebp)
 8fc:	6a 01                	push   $0x1
 8fe:	56                   	push   %esi
 8ff:	57                   	push   %edi
 900:	e8 de fe ff ff       	call   7e3 <write>
  while(--i >= 0)
 905:	83 c4 10             	add    $0x10,%esp
 908:	39 de                	cmp    %ebx,%esi
 90a:	75 e4                	jne    8f0 <printint+0x70>
    putc(fd, buf[i]);
}
 90c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 90f:	5b                   	pop    %ebx
 910:	5e                   	pop    %esi
 911:	5f                   	pop    %edi
 912:	5d                   	pop    %ebp
 913:	c3                   	ret    
 914:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 918:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 91f:	eb 87                	jmp    8a8 <printint+0x28>
 921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 928:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 92f:	90                   	nop

00000930 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 930:	f3 0f 1e fb          	endbr32 
 934:	55                   	push   %ebp
 935:	89 e5                	mov    %esp,%ebp
 937:	57                   	push   %edi
 938:	56                   	push   %esi
 939:	53                   	push   %ebx
 93a:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 93d:	8b 75 0c             	mov    0xc(%ebp),%esi
 940:	0f b6 1e             	movzbl (%esi),%ebx
 943:	84 db                	test   %bl,%bl
 945:	0f 84 b4 00 00 00    	je     9ff <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
 94b:	8d 45 10             	lea    0x10(%ebp),%eax
 94e:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 951:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 954:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 956:	89 45 d0             	mov    %eax,-0x30(%ebp)
 959:	eb 33                	jmp    98e <printf+0x5e>
 95b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 95f:	90                   	nop
 960:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 963:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 968:	83 f8 25             	cmp    $0x25,%eax
 96b:	74 17                	je     984 <printf+0x54>
  write(fd, &c, 1);
 96d:	83 ec 04             	sub    $0x4,%esp
 970:	88 5d e7             	mov    %bl,-0x19(%ebp)
 973:	6a 01                	push   $0x1
 975:	57                   	push   %edi
 976:	ff 75 08             	pushl  0x8(%ebp)
 979:	e8 65 fe ff ff       	call   7e3 <write>
 97e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 981:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 984:	0f b6 1e             	movzbl (%esi),%ebx
 987:	83 c6 01             	add    $0x1,%esi
 98a:	84 db                	test   %bl,%bl
 98c:	74 71                	je     9ff <printf+0xcf>
    c = fmt[i] & 0xff;
 98e:	0f be cb             	movsbl %bl,%ecx
 991:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 994:	85 d2                	test   %edx,%edx
 996:	74 c8                	je     960 <printf+0x30>
      }
    } else if(state == '%'){
 998:	83 fa 25             	cmp    $0x25,%edx
 99b:	75 e7                	jne    984 <printf+0x54>
      if(c == 'd'){
 99d:	83 f8 64             	cmp    $0x64,%eax
 9a0:	0f 84 9a 00 00 00    	je     a40 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 9a6:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 9ac:	83 f9 70             	cmp    $0x70,%ecx
 9af:	74 5f                	je     a10 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 9b1:	83 f8 73             	cmp    $0x73,%eax
 9b4:	0f 84 d6 00 00 00    	je     a90 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 9ba:	83 f8 63             	cmp    $0x63,%eax
 9bd:	0f 84 8d 00 00 00    	je     a50 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 9c3:	83 f8 25             	cmp    $0x25,%eax
 9c6:	0f 84 b4 00 00 00    	je     a80 <printf+0x150>
  write(fd, &c, 1);
 9cc:	83 ec 04             	sub    $0x4,%esp
 9cf:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 9d3:	6a 01                	push   $0x1
 9d5:	57                   	push   %edi
 9d6:	ff 75 08             	pushl  0x8(%ebp)
 9d9:	e8 05 fe ff ff       	call   7e3 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 9de:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 9e1:	83 c4 0c             	add    $0xc,%esp
 9e4:	6a 01                	push   $0x1
 9e6:	83 c6 01             	add    $0x1,%esi
 9e9:	57                   	push   %edi
 9ea:	ff 75 08             	pushl  0x8(%ebp)
 9ed:	e8 f1 fd ff ff       	call   7e3 <write>
  for(i = 0; fmt[i]; i++){
 9f2:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 9f6:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 9f9:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 9fb:	84 db                	test   %bl,%bl
 9fd:	75 8f                	jne    98e <printf+0x5e>
    }
  }
}
 9ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
 a02:	5b                   	pop    %ebx
 a03:	5e                   	pop    %esi
 a04:	5f                   	pop    %edi
 a05:	5d                   	pop    %ebp
 a06:	c3                   	ret    
 a07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a0e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 a10:	83 ec 0c             	sub    $0xc,%esp
 a13:	b9 10 00 00 00       	mov    $0x10,%ecx
 a18:	6a 00                	push   $0x0
 a1a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 a1d:	8b 45 08             	mov    0x8(%ebp),%eax
 a20:	8b 13                	mov    (%ebx),%edx
 a22:	e8 59 fe ff ff       	call   880 <printint>
        ap++;
 a27:	89 d8                	mov    %ebx,%eax
 a29:	83 c4 10             	add    $0x10,%esp
      state = 0;
 a2c:	31 d2                	xor    %edx,%edx
        ap++;
 a2e:	83 c0 04             	add    $0x4,%eax
 a31:	89 45 d0             	mov    %eax,-0x30(%ebp)
 a34:	e9 4b ff ff ff       	jmp    984 <printf+0x54>
 a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 a40:	83 ec 0c             	sub    $0xc,%esp
 a43:	b9 0a 00 00 00       	mov    $0xa,%ecx
 a48:	6a 01                	push   $0x1
 a4a:	eb ce                	jmp    a1a <printf+0xea>
 a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 a50:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 a53:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 a56:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 a58:	6a 01                	push   $0x1
        ap++;
 a5a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 a5d:	57                   	push   %edi
 a5e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 a61:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 a64:	e8 7a fd ff ff       	call   7e3 <write>
        ap++;
 a69:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 a6c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 a6f:	31 d2                	xor    %edx,%edx
 a71:	e9 0e ff ff ff       	jmp    984 <printf+0x54>
 a76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a7d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 a80:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 a83:	83 ec 04             	sub    $0x4,%esp
 a86:	e9 59 ff ff ff       	jmp    9e4 <printf+0xb4>
 a8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 a8f:	90                   	nop
        s = (char*)*ap;
 a90:	8b 45 d0             	mov    -0x30(%ebp),%eax
 a93:	8b 18                	mov    (%eax),%ebx
        ap++;
 a95:	83 c0 04             	add    $0x4,%eax
 a98:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 a9b:	85 db                	test   %ebx,%ebx
 a9d:	74 17                	je     ab6 <printf+0x186>
        while(*s != 0){
 a9f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 aa2:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 aa4:	84 c0                	test   %al,%al
 aa6:	0f 84 d8 fe ff ff    	je     984 <printf+0x54>
 aac:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 aaf:	89 de                	mov    %ebx,%esi
 ab1:	8b 5d 08             	mov    0x8(%ebp),%ebx
 ab4:	eb 1a                	jmp    ad0 <printf+0x1a0>
          s = "(null)";
 ab6:	bb 4b 0d 00 00       	mov    $0xd4b,%ebx
        while(*s != 0){
 abb:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 abe:	b8 28 00 00 00       	mov    $0x28,%eax
 ac3:	89 de                	mov    %ebx,%esi
 ac5:	8b 5d 08             	mov    0x8(%ebp),%ebx
 ac8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 acf:	90                   	nop
  write(fd, &c, 1);
 ad0:	83 ec 04             	sub    $0x4,%esp
          s++;
 ad3:	83 c6 01             	add    $0x1,%esi
 ad6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 ad9:	6a 01                	push   $0x1
 adb:	57                   	push   %edi
 adc:	53                   	push   %ebx
 add:	e8 01 fd ff ff       	call   7e3 <write>
        while(*s != 0){
 ae2:	0f b6 06             	movzbl (%esi),%eax
 ae5:	83 c4 10             	add    $0x10,%esp
 ae8:	84 c0                	test   %al,%al
 aea:	75 e4                	jne    ad0 <printf+0x1a0>
 aec:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 aef:	31 d2                	xor    %edx,%edx
 af1:	e9 8e fe ff ff       	jmp    984 <printf+0x54>
 af6:	66 90                	xchg   %ax,%ax
 af8:	66 90                	xchg   %ax,%ax
 afa:	66 90                	xchg   %ax,%ax
 afc:	66 90                	xchg   %ax,%ax
 afe:	66 90                	xchg   %ax,%ax

00000b00 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b00:	f3 0f 1e fb          	endbr32 
 b04:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b05:	a1 ac 10 00 00       	mov    0x10ac,%eax
{
 b0a:	89 e5                	mov    %esp,%ebp
 b0c:	57                   	push   %edi
 b0d:	56                   	push   %esi
 b0e:	53                   	push   %ebx
 b0f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 b12:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 b14:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b17:	39 c8                	cmp    %ecx,%eax
 b19:	73 15                	jae    b30 <free+0x30>
 b1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 b1f:	90                   	nop
 b20:	39 d1                	cmp    %edx,%ecx
 b22:	72 14                	jb     b38 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b24:	39 d0                	cmp    %edx,%eax
 b26:	73 10                	jae    b38 <free+0x38>
{
 b28:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b2a:	8b 10                	mov    (%eax),%edx
 b2c:	39 c8                	cmp    %ecx,%eax
 b2e:	72 f0                	jb     b20 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b30:	39 d0                	cmp    %edx,%eax
 b32:	72 f4                	jb     b28 <free+0x28>
 b34:	39 d1                	cmp    %edx,%ecx
 b36:	73 f0                	jae    b28 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 b38:	8b 73 fc             	mov    -0x4(%ebx),%esi
 b3b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 b3e:	39 fa                	cmp    %edi,%edx
 b40:	74 1e                	je     b60 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 b42:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 b45:	8b 50 04             	mov    0x4(%eax),%edx
 b48:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 b4b:	39 f1                	cmp    %esi,%ecx
 b4d:	74 28                	je     b77 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 b4f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 b51:	5b                   	pop    %ebx
  freep = p;
 b52:	a3 ac 10 00 00       	mov    %eax,0x10ac
}
 b57:	5e                   	pop    %esi
 b58:	5f                   	pop    %edi
 b59:	5d                   	pop    %ebp
 b5a:	c3                   	ret    
 b5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 b5f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 b60:	03 72 04             	add    0x4(%edx),%esi
 b63:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 b66:	8b 10                	mov    (%eax),%edx
 b68:	8b 12                	mov    (%edx),%edx
 b6a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 b6d:	8b 50 04             	mov    0x4(%eax),%edx
 b70:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 b73:	39 f1                	cmp    %esi,%ecx
 b75:	75 d8                	jne    b4f <free+0x4f>
    p->s.size += bp->s.size;
 b77:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 b7a:	a3 ac 10 00 00       	mov    %eax,0x10ac
    p->s.size += bp->s.size;
 b7f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 b82:	8b 53 f8             	mov    -0x8(%ebx),%edx
 b85:	89 10                	mov    %edx,(%eax)
}
 b87:	5b                   	pop    %ebx
 b88:	5e                   	pop    %esi
 b89:	5f                   	pop    %edi
 b8a:	5d                   	pop    %ebp
 b8b:	c3                   	ret    
 b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000b90 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b90:	f3 0f 1e fb          	endbr32 
 b94:	55                   	push   %ebp
 b95:	89 e5                	mov    %esp,%ebp
 b97:	57                   	push   %edi
 b98:	56                   	push   %esi
 b99:	53                   	push   %ebx
 b9a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 ba0:	8b 3d ac 10 00 00    	mov    0x10ac,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 ba6:	8d 70 07             	lea    0x7(%eax),%esi
 ba9:	c1 ee 03             	shr    $0x3,%esi
 bac:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 baf:	85 ff                	test   %edi,%edi
 bb1:	0f 84 a9 00 00 00    	je     c60 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bb7:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 bb9:	8b 48 04             	mov    0x4(%eax),%ecx
 bbc:	39 f1                	cmp    %esi,%ecx
 bbe:	73 6d                	jae    c2d <malloc+0x9d>
 bc0:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 bc6:	bb 00 10 00 00       	mov    $0x1000,%ebx
 bcb:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 bce:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 bd5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 bd8:	eb 17                	jmp    bf1 <malloc+0x61>
 bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 be0:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 be2:	8b 4a 04             	mov    0x4(%edx),%ecx
 be5:	39 f1                	cmp    %esi,%ecx
 be7:	73 4f                	jae    c38 <malloc+0xa8>
 be9:	8b 3d ac 10 00 00    	mov    0x10ac,%edi
 bef:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 bf1:	39 c7                	cmp    %eax,%edi
 bf3:	75 eb                	jne    be0 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 bf5:	83 ec 0c             	sub    $0xc,%esp
 bf8:	ff 75 e4             	pushl  -0x1c(%ebp)
 bfb:	e8 4b fc ff ff       	call   84b <sbrk>
  if(p == (char*)-1)
 c00:	83 c4 10             	add    $0x10,%esp
 c03:	83 f8 ff             	cmp    $0xffffffff,%eax
 c06:	74 1b                	je     c23 <malloc+0x93>
  hp->s.size = nu;
 c08:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 c0b:	83 ec 0c             	sub    $0xc,%esp
 c0e:	83 c0 08             	add    $0x8,%eax
 c11:	50                   	push   %eax
 c12:	e8 e9 fe ff ff       	call   b00 <free>
  return freep;
 c17:	a1 ac 10 00 00       	mov    0x10ac,%eax
      if((p = morecore(nunits)) == 0)
 c1c:	83 c4 10             	add    $0x10,%esp
 c1f:	85 c0                	test   %eax,%eax
 c21:	75 bd                	jne    be0 <malloc+0x50>
        return 0;
  }
}
 c23:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 c26:	31 c0                	xor    %eax,%eax
}
 c28:	5b                   	pop    %ebx
 c29:	5e                   	pop    %esi
 c2a:	5f                   	pop    %edi
 c2b:	5d                   	pop    %ebp
 c2c:	c3                   	ret    
    if(p->s.size >= nunits){
 c2d:	89 c2                	mov    %eax,%edx
 c2f:	89 f8                	mov    %edi,%eax
 c31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 c38:	39 ce                	cmp    %ecx,%esi
 c3a:	74 54                	je     c90 <malloc+0x100>
        p->s.size -= nunits;
 c3c:	29 f1                	sub    %esi,%ecx
 c3e:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 c41:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 c44:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 c47:	a3 ac 10 00 00       	mov    %eax,0x10ac
}
 c4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 c4f:	8d 42 08             	lea    0x8(%edx),%eax
}
 c52:	5b                   	pop    %ebx
 c53:	5e                   	pop    %esi
 c54:	5f                   	pop    %edi
 c55:	5d                   	pop    %ebp
 c56:	c3                   	ret    
 c57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 c5e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 c60:	c7 05 ac 10 00 00 b0 	movl   $0x10b0,0x10ac
 c67:	10 00 00 
    base.s.size = 0;
 c6a:	bf b0 10 00 00       	mov    $0x10b0,%edi
    base.s.ptr = freep = prevp = &base;
 c6f:	c7 05 b0 10 00 00 b0 	movl   $0x10b0,0x10b0
 c76:	10 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c79:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 c7b:	c7 05 b4 10 00 00 00 	movl   $0x0,0x10b4
 c82:	00 00 00 
    if(p->s.size >= nunits){
 c85:	e9 36 ff ff ff       	jmp    bc0 <malloc+0x30>
 c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 c90:	8b 0a                	mov    (%edx),%ecx
 c92:	89 08                	mov    %ecx,(%eax)
 c94:	eb b1                	jmp    c47 <malloc+0xb7>
