
_our_test:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
void action_handler(int signum){
    printf(1, "SIGNAL %d HANDLED\n", signum);
    return;
}

int main(int argc, char** argv){
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	53                   	push   %ebx
  for (int i = 0; i < 100; i++){
  12:	31 db                	xor    %ebx,%ebx
int main(int argc, char** argv){
  14:	51                   	push   %ecx
  15:	8d 76 00             	lea    0x0(%esi),%esi
    printf(1, "sleeping for %d\n", i);
  18:	83 ec 04             	sub    $0x4,%esp
  1b:	53                   	push   %ebx
  1c:	68 bb 0c 00 00       	push   $0xcbb
  21:	6a 01                	push   $0x1
  23:	e8 18 09 00 00       	call   940 <printf>
    sleep(i);
  28:	89 1c 24             	mov    %ebx,(%esp)
  for (int i = 0; i < 100; i++){
  2b:	83 c3 01             	add    $0x1,%ebx
    sleep(i);
  2e:	e8 30 08 00 00       	call   863 <sleep>
  for (int i = 0; i < 100; i++){
  33:	83 c4 10             	add    $0x10,%esp
  36:	83 fb 64             	cmp    $0x64,%ebx
  39:	75 dd                	jne    18 <main+0x18>
  }
}
  3b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  3e:	31 c0                	xor    %eax,%eax
  40:	59                   	pop    %ecx
  41:	5b                   	pop    %ebx
  42:	5d                   	pop    %ebp
  43:	8d 61 fc             	lea    -0x4(%ecx),%esp
  46:	c3                   	ret    
  47:	66 90                	xchg   %ax,%ax
  49:	66 90                	xchg   %ax,%ax
  4b:	66 90                	xchg   %ax,%ax
  4d:	66 90                	xchg   %ax,%ax
  4f:	90                   	nop

00000050 <action_handler>:
void action_handler(int signum){
  50:	f3 0f 1e fb          	endbr32 
  54:	55                   	push   %ebp
  55:	89 e5                	mov    %esp,%ebp
  57:	83 ec 0c             	sub    $0xc,%esp
    printf(1, "SIGNAL %d HANDLED\n", signum);
  5a:	ff 75 08             	pushl  0x8(%ebp)
  5d:	68 a8 0c 00 00       	push   $0xca8
  62:	6a 01                	push   $0x1
  64:	e8 d7 08 00 00       	call   940 <printf>
    return;
  69:	83 c4 10             	add    $0x10,%esp
}
  6c:	c9                   	leave  
  6d:	c3                   	ret    
  6e:	66 90                	xchg   %ax,%ax

00000070 <main20>:

int main20(int argc, char** argv){
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
      int a, b, c,ret;
  a = 1; b = 2; c = 3;
  8a:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  int i=1;
  printf(1,"a %d b %d c %d\n",a,b,c);
  91:	6a 03                	push   $0x3
  93:	6a 02                	push   $0x2
  95:	6a 01                	push   $0x1
  97:	68 cc 0c 00 00       	push   $0xccc
  9c:	6a 01                	push   $0x1
  9e:	e8 9d 08 00 00       	call   940 <printf>
  a3:	89 f8                	mov    %edi,%eax
  a5:	f0 0f b1 33          	lock cmpxchg %esi,(%ebx)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
  a9:	9c                   	pushf  
  aa:	58                   	pop    %eax
  ret = cas(&a,b,c);
  printf(1,"ret %d, a %d \n\n",ret, a);
  ab:	83 c4 20             	add    $0x20,%esp
 : :"r" (addr), "a" (expected), "r" (newval));
  return (readeflags() & 0x0040);
  ae:	83 e0 40             	and    $0x40,%eax
  b1:	ff 75 e4             	pushl  -0x1c(%ebp)
  b4:	50                   	push   %eax
  b5:	68 dc 0c 00 00       	push   $0xcdc
  ba:	6a 01                	push   $0x1
  bc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  bf:	e8 7c 08 00 00       	call   940 <printf>
  if(ret){
  c4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  c7:	83 c4 10             	add    $0x10,%esp
  ca:	85 c0                	test   %eax,%eax
  cc:	74 14                	je     e2 <main20+0x72>
    printf(1,"Case %d Fail\n ",i);
  ce:	50                   	push   %eax
  cf:	6a 01                	push   $0x1
  d1:	68 ec 0c 00 00       	push   $0xcec
  d6:	6a 01                	push   $0x1
  d8:	e8 63 08 00 00       	call   940 <printf>
    exit();
  dd:	e8 f1 06 00 00       	call   7d3 <exit>
  }
  i++;
  a = 2; b = 2; c = 3;
  
  printf(1,"a %d b %d c %d\n",a,b,c);
  e2:	83 ec 0c             	sub    $0xc,%esp
  a = 2; b = 2; c = 3;
  e5:	c7 45 e4 02 00 00 00 	movl   $0x2,-0x1c(%ebp)
  printf(1,"a %d b %d c %d\n",a,b,c);
  ec:	6a 03                	push   $0x3
  ee:	6a 02                	push   $0x2
  f0:	6a 02                	push   $0x2
  f2:	68 cc 0c 00 00       	push   $0xccc
  f7:	6a 01                	push   $0x1
  f9:	e8 42 08 00 00       	call   940 <printf>
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
  fe:	89 f8                	mov    %edi,%eax
 100:	f0 0f b1 33          	lock cmpxchg %esi,(%ebx)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
 104:	9c                   	pushf  
 105:	58                   	pop    %eax
  ret = cas(&a,b,c);
  printf(1,"ret %d, a %d \n\n",ret, a);
 106:	83 c4 20             	add    $0x20,%esp
  return (readeflags() & 0x0040);
 109:	83 e0 40             	and    $0x40,%eax
 10c:	ff 75 e4             	pushl  -0x1c(%ebp)
 10f:	50                   	push   %eax
 110:	68 dc 0c 00 00       	push   $0xcdc
 115:	6a 01                	push   $0x1
 117:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 11a:	e8 21 08 00 00       	call   940 <printf>
  if(!ret){
 11f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 122:	83 c4 10             	add    $0x10,%esp
 125:	85 c0                	test   %eax,%eax
 127:	75 14                	jne    13d <main20+0xcd>
    printf(1,"Case %d Fail\n ",i);
 129:	50                   	push   %eax
 12a:	6a 02                	push   $0x2
 12c:	68 ec 0c 00 00       	push   $0xcec
 131:	6a 01                	push   $0x1
 133:	e8 08 08 00 00       	call   940 <printf>
    exit();
 138:	e8 96 06 00 00       	call   7d3 <exit>
  }
  i++;
  a = 3; b = 2; c = 3;
  
  printf(1,"a %d b %d c %d\n",a,b,c);
 13d:	83 ec 0c             	sub    $0xc,%esp
  a = 3; b = 2; c = 3;
 140:	c7 45 e4 03 00 00 00 	movl   $0x3,-0x1c(%ebp)
  printf(1,"a %d b %d c %d\n",a,b,c);
 147:	6a 03                	push   $0x3
 149:	6a 02                	push   $0x2
 14b:	6a 03                	push   $0x3
 14d:	68 cc 0c 00 00       	push   $0xccc
 152:	6a 01                	push   $0x1
 154:	e8 e7 07 00 00       	call   940 <printf>
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
 159:	89 f8                	mov    %edi,%eax
 15b:	f0 0f b1 33          	lock cmpxchg %esi,(%ebx)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
 15f:	9c                   	pushf  
 160:	5f                   	pop    %edi
  ret = cas(&a,b,c);
  printf(1,"ret %d, a %d \n\n",ret, a);
 161:	83 c4 20             	add    $0x20,%esp
  return (readeflags() & 0x0040);
 164:	83 e7 40             	and    $0x40,%edi
 167:	ff 75 e4             	pushl  -0x1c(%ebp)
 16a:	57                   	push   %edi
 16b:	68 dc 0c 00 00       	push   $0xcdc
 170:	6a 01                	push   $0x1
 172:	e8 c9 07 00 00       	call   940 <printf>
  if(ret){
 177:	83 c4 10             	add    $0x10,%esp
 17a:	85 ff                	test   %edi,%edi
 17c:	75 60                	jne    1de <main20+0x16e>
    exit();
  }
  i++;
  a = 3; b = 3; c = 30;
  
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
 193:	68 cc 0c 00 00       	push   $0xccc
 198:	6a 01                	push   $0x1
 19a:	e8 a1 07 00 00       	call   940 <printf>
 19f:	89 f0                	mov    %esi,%eax
 1a1:	f0 0f b1 3b          	lock cmpxchg %edi,(%ebx)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
 1a5:	9c                   	pushf  
 1a6:	58                   	pop    %eax
  ret = cas(&a,b,c);
  printf(1,"ret %d, a %d \n\n",ret, a);
 1a7:	83 c4 20             	add    $0x20,%esp
  return (readeflags() & 0x0040);
 1aa:	83 e0 40             	and    $0x40,%eax
 1ad:	ff 75 e4             	pushl  -0x1c(%ebp)
 1b0:	50                   	push   %eax
 1b1:	68 dc 0c 00 00       	push   $0xcdc
 1b6:	6a 01                	push   $0x1
 1b8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 1bb:	e8 80 07 00 00       	call   940 <printf>
  if(!ret){
 1c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 1c3:	83 c4 10             	add    $0x10,%esp
 1c6:	85 c0                	test   %eax,%eax
 1c8:	75 28                	jne    1f2 <main20+0x182>
    printf(1,"Case %d Fail\n ",i);
 1ca:	56                   	push   %esi
 1cb:	6a 04                	push   $0x4
 1cd:	68 ec 0c 00 00       	push   $0xcec
 1d2:	6a 01                	push   $0x1
 1d4:	e8 67 07 00 00       	call   940 <printf>
    exit();
 1d9:	e8 f5 05 00 00       	call   7d3 <exit>
    printf(1,"Case %d Fail\n ",i);
 1de:	57                   	push   %edi
 1df:	6a 03                	push   $0x3
 1e1:	68 ec 0c 00 00       	push   $0xcec
 1e6:	6a 01                	push   $0x1
 1e8:	e8 53 07 00 00       	call   940 <printf>
    exit();
 1ed:	e8 e1 05 00 00       	call   7d3 <exit>
  }
  i++;
  a = 2; b = 4; c = 3;
  
  printf(1,"a %d b %d c %d\n",a,b,c);
 1f2:	83 ec 0c             	sub    $0xc,%esp
  a = 2; b = 4; c = 3;
 1f5:	c7 45 e4 02 00 00 00 	movl   $0x2,-0x1c(%ebp)
  printf(1,"a %d b %d c %d\n",a,b,c);
 1fc:	6a 03                	push   $0x3
 1fe:	6a 04                	push   $0x4
 200:	6a 02                	push   $0x2
 202:	68 cc 0c 00 00       	push   $0xccc
 207:	6a 01                	push   $0x1
 209:	e8 32 07 00 00       	call   940 <printf>
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
 20e:	b8 04 00 00 00       	mov    $0x4,%eax
 213:	f0 0f b1 33          	lock cmpxchg %esi,(%ebx)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
 217:	9c                   	pushf  
 218:	5e                   	pop    %esi
  ret = cas(&a,b,c);
  printf(1,"ret %d, a %d \n\n",ret, a);
 219:	83 c4 20             	add    $0x20,%esp
  return (readeflags() & 0x0040);
 21c:	83 e6 40             	and    $0x40,%esi
 21f:	ff 75 e4             	pushl  -0x1c(%ebp)
 222:	56                   	push   %esi
 223:	68 dc 0c 00 00       	push   $0xcdc
 228:	6a 01                	push   $0x1
 22a:	e8 11 07 00 00       	call   940 <printf>
  if(ret){
 22f:	83 c4 10             	add    $0x10,%esp
 232:	85 f6                	test   %esi,%esi
 234:	75 58                	jne    28e <main20+0x21e>
    exit();
  }
  i++;
   a = 3; b = 4; c = 30;
  
  printf(1,"a %d b %d c %d\n",a,b,c);
 236:	83 ec 0c             	sub    $0xc,%esp
   a = 3; b = 4; c = 30;
 239:	c7 45 e4 03 00 00 00 	movl   $0x3,-0x1c(%ebp)
  printf(1,"a %d b %d c %d\n",a,b,c);
 240:	6a 1e                	push   $0x1e
 242:	6a 04                	push   $0x4
 244:	6a 03                	push   $0x3
 246:	68 cc 0c 00 00       	push   $0xccc
 24b:	6a 01                	push   $0x1
 24d:	e8 ee 06 00 00       	call   940 <printf>
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
 252:	b8 04 00 00 00       	mov    $0x4,%eax
 257:	f0 0f b1 3b          	lock cmpxchg %edi,(%ebx)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
 25b:	9c                   	pushf  
 25c:	5e                   	pop    %esi
  ret = cas(&a,b,c);
  printf(1,"ret %d, a %d \n\n",ret, a);
 25d:	83 c4 20             	add    $0x20,%esp
  return (readeflags() & 0x0040);
 260:	83 e6 40             	and    $0x40,%esi
 263:	ff 75 e4             	pushl  -0x1c(%ebp)
 266:	56                   	push   %esi
 267:	68 dc 0c 00 00       	push   $0xcdc
 26c:	6a 01                	push   $0x1
 26e:	e8 cd 06 00 00       	call   940 <printf>
  if(ret){
 273:	83 c4 10             	add    $0x10,%esp
 276:	85 f6                	test   %esi,%esi
 278:	74 28                	je     2a2 <main20+0x232>
    printf(1,"Case %d Fail\n ",i);
 27a:	51                   	push   %ecx
 27b:	6a 06                	push   $0x6
 27d:	68 ec 0c 00 00       	push   $0xcec
 282:	6a 01                	push   $0x1
 284:	e8 b7 06 00 00       	call   940 <printf>
    exit();
 289:	e8 45 05 00 00       	call   7d3 <exit>
    printf(1,"Case i %d Fail\n ",i);
 28e:	53                   	push   %ebx
 28f:	6a 05                	push   $0x5
 291:	68 fb 0c 00 00       	push   $0xcfb
 296:	6a 01                	push   $0x1
 298:	e8 a3 06 00 00       	call   940 <printf>
    exit();
 29d:	e8 31 05 00 00       	call   7d3 <exit>
  }
  i++;
   a = 4; b = 4; c = 30;
  
  printf(1,"a %d b %d c %d\n",a,b,c);
 2a2:	83 ec 0c             	sub    $0xc,%esp
   a = 4; b = 4; c = 30;
 2a5:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
  printf(1,"a %d b %d c %d\n",a,b,c);
 2ac:	6a 1e                	push   $0x1e
 2ae:	6a 04                	push   $0x4
 2b0:	6a 04                	push   $0x4
 2b2:	68 cc 0c 00 00       	push   $0xccc
 2b7:	6a 01                	push   $0x1
 2b9:	e8 82 06 00 00       	call   940 <printf>
  asm volatile("lock cmpxchgl %2, (%0)\n\t"
 2be:	b8 04 00 00 00       	mov    $0x4,%eax
 2c3:	f0 0f b1 3b          	lock cmpxchg %edi,(%ebx)
  asm volatile("pushfl; popl %0" : "=r" (eflags));
 2c7:	9c                   	pushf  
 2c8:	5b                   	pop    %ebx
  ret = cas(&a,b,c);
  printf(1,"ret %d, a %d \n\n",ret, a);
 2c9:	83 c4 20             	add    $0x20,%esp
  return (readeflags() & 0x0040);
 2cc:	83 e3 40             	and    $0x40,%ebx
 2cf:	ff 75 e4             	pushl  -0x1c(%ebp)
 2d2:	53                   	push   %ebx
 2d3:	68 dc 0c 00 00       	push   $0xcdc
 2d8:	6a 01                	push   $0x1
 2da:	e8 61 06 00 00       	call   940 <printf>
  if(!ret){
 2df:	83 c4 10             	add    $0x10,%esp
 2e2:	85 db                	test   %ebx,%ebx
 2e4:	75 14                	jne    2fa <main20+0x28a>
    printf(1,"Case %d Fail\n ",i);
 2e6:	52                   	push   %edx
 2e7:	6a 07                	push   $0x7
 2e9:	68 ec 0c 00 00       	push   $0xcec
 2ee:	6a 01                	push   $0x1
 2f0:	e8 4b 06 00 00       	call   940 <printf>
    exit();
 2f5:	e8 d9 04 00 00       	call   7d3 <exit>
  }
  printf(1,"All Tests passed\n");
 2fa:	50                   	push   %eax
 2fb:	50                   	push   %eax
 2fc:	68 0c 0d 00 00       	push   $0xd0c
 301:	6a 01                	push   $0x1
 303:	e8 38 06 00 00       	call   940 <printf>
  exit();
 308:	e8 c6 04 00 00       	call   7d3 <exit>
 30d:	8d 76 00             	lea    0x0(%esi),%esi

00000310 <main10>:
}

int main10(int argc, char** argv){
 310:	f3 0f 1e fb          	endbr32 
 314:	55                   	push   %ebp
 315:	89 e5                	mov    %esp,%ebp
 317:	53                   	push   %ebx
 318:	bb 14 00 00 00       	mov    $0x14,%ebx
 31d:	83 ec 04             	sub    $0x4,%esp
 320:	eb 10                	jmp    332 <main10+0x22>
 322:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    for (int i = 0; i < 20; i++){
        int pid = fork();
        if (pid != 0){
            wait();
 328:	e8 ae 04 00 00       	call   7db <wait>
    for (int i = 0; i < 20; i++){
 32d:	83 eb 01             	sub    $0x1,%ebx
 330:	74 1f                	je     351 <main10+0x41>
        int pid = fork();
 332:	e8 94 04 00 00       	call   7cb <fork>
        if (pid != 0){
 337:	85 c0                	test   %eax,%eax
 339:	75 ed                	jne    328 <main10+0x18>
        }
        else{
            printf(1, "%d\n", getpid());
 33b:	e8 13 05 00 00       	call   853 <getpid>
 340:	52                   	push   %edx
 341:	50                   	push   %eax
 342:	68 3b 0d 00 00       	push   $0xd3b
 347:	6a 01                	push   $0x1
 349:	e8 f2 05 00 00       	call   940 <printf>
            break;
 34e:	83 c4 10             	add    $0x10,%esp
        }
    }
    exit();
 351:	e8 7d 04 00 00       	call   7d3 <exit>
 356:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 35d:	8d 76 00             	lea    0x0(%esi),%esi

00000360 <main1>:
}

int main1(int argc, char** argv){
 360:	f3 0f 1e fb          	endbr32 
 364:	55                   	push   %ebp
 365:	89 e5                	mov    %esp,%ebp
 367:	53                   	push   %ebx
    struct sigaction sigact = {action_handler, 0};
    sigaction(1, &sigact, null);
 368:	8d 45 f0             	lea    -0x10(%ebp),%eax
int main1(int argc, char** argv){
 36b:	83 ec 18             	sub    $0x18,%esp
    struct sigaction sigact = {action_handler, 0};
 36e:	c7 45 f0 50 00 00 00 	movl   $0x50,-0x10(%ebp)
    sigaction(1, &sigact, null);
 375:	6a 00                	push   $0x0
 377:	50                   	push   %eax
 378:	6a 01                	push   $0x1
    struct sigaction sigact = {action_handler, 0};
 37a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    sigaction(1, &sigact, null);
 381:	e8 f5 04 00 00       	call   87b <sigaction>
    kill(getpid(), 1);
 386:	e8 c8 04 00 00       	call   853 <getpid>
 38b:	5a                   	pop    %edx
 38c:	59                   	pop    %ecx
 38d:	6a 01                	push   $0x1
 38f:	50                   	push   %eax
 390:	e8 6e 04 00 00       	call   803 <kill>
    kill(getpid(), 9);
 395:	e8 b9 04 00 00       	call   853 <getpid>
 39a:	5b                   	pop    %ebx
 39b:	5a                   	pop    %edx
 39c:	6a 09                	push   $0x9
 39e:	50                   	push   %eax

    for (int i = 0; i < 1000000; i++){
 39f:	31 db                	xor    %ebx,%ebx
    kill(getpid(), 9);
 3a1:	e8 5d 04 00 00       	call   803 <kill>
 3a6:	83 c4 10             	add    $0x10,%esp
 3a9:	eb 22                	jmp    3cd <main1+0x6d>
 3ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3af:	90                   	nop
            if (i % 1000 == 0){
                printf(1, "hi\n");
            }
            printf(1, "");
 3b0:	83 ec 08             	sub    $0x8,%esp
    for (int i = 0; i < 1000000; i++){
 3b3:	83 c3 01             	add    $0x1,%ebx
            printf(1, "");
 3b6:	68 eb 0c 00 00       	push   $0xceb
 3bb:	6a 01                	push   $0x1
 3bd:	e8 7e 05 00 00       	call   940 <printf>
    for (int i = 0; i < 1000000; i++){
 3c2:	83 c4 10             	add    $0x10,%esp
 3c5:	81 fb 40 42 0f 00    	cmp    $0xf4240,%ebx
 3cb:	74 24                	je     3f1 <main1+0x91>
    kill(getpid(), 9);
 3cd:	69 c3 d5 78 e9 26    	imul   $0x26e978d5,%ebx,%eax
 3d3:	c1 c8 03             	ror    $0x3,%eax
            if (i % 1000 == 0){
 3d6:	3d 37 89 41 00       	cmp    $0x418937,%eax
 3db:	77 d3                	ja     3b0 <main1+0x50>
                printf(1, "hi\n");
 3dd:	83 ec 08             	sub    $0x8,%esp
 3e0:	68 1e 0d 00 00       	push   $0xd1e
 3e5:	6a 01                	push   $0x1
 3e7:	e8 54 05 00 00       	call   940 <printf>
 3ec:	83 c4 10             	add    $0x10,%esp
 3ef:	eb bf                	jmp    3b0 <main1+0x50>
        }
    return 0;
}
 3f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 3f4:	31 c0                	xor    %eax,%eax
 3f6:	c9                   	leave  
 3f7:	c3                   	ret    
 3f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3ff:	90                   	nop

00000400 <main2>:

int main2(int argc, char** argv){
 400:	f3 0f 1e fb          	endbr32 
 404:	55                   	push   %ebp
 405:	89 e5                	mov    %esp,%ebp
 407:	56                   	push   %esi
 408:	53                   	push   %ebx
 409:	83 ec 10             	sub    $0x10,%esp
    struct sigaction sigact = {action_handler, 0};
 40c:	c7 45 f0 50 00 00 00 	movl   $0x50,-0x10(%ebp)
 413:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int pid = fork();
 41a:	e8 ac 03 00 00       	call   7cb <fork>
 41f:	89 c3                	mov    %eax,%ebx
    if (pid == 0){
 421:	85 c0                	test   %eax,%eax
 423:	0f 85 8c 00 00 00    	jne    4b5 <main2+0xb5>
        printf(1, "childs here");
 429:	50                   	push   %eax
        sigaction(1, &sigact, null);
 42a:	8d 75 f0             	lea    -0x10(%ebp),%esi
        printf(1, "childs here");
 42d:	50                   	push   %eax
 42e:	68 22 0d 00 00       	push   $0xd22
 433:	6a 01                	push   $0x1
 435:	e8 06 05 00 00       	call   940 <printf>
        sigaction(1, &sigact, null);
 43a:	83 c4 0c             	add    $0xc,%esp
 43d:	6a 00                	push   $0x0
 43f:	56                   	push   %esi
 440:	6a 01                	push   $0x1
 442:	e8 34 04 00 00       	call   87b <sigaction>
        sigaction(2, &sigact, null);
 447:	83 c4 0c             	add    $0xc,%esp
 44a:	6a 00                	push   $0x0
 44c:	56                   	push   %esi
 44d:	6a 02                	push   $0x2
 44f:	e8 27 04 00 00       	call   87b <sigaction>
        sigaction(3, &sigact, null);
 454:	83 c4 0c             	add    $0xc,%esp
 457:	6a 00                	push   $0x0
 459:	56                   	push   %esi
 45a:	6a 03                	push   $0x3
 45c:	e8 1a 04 00 00       	call   87b <sigaction>
 461:	83 c4 10             	add    $0x10,%esp
 464:	eb 2b                	jmp    491 <main2+0x91>
 466:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 46d:	8d 76 00             	lea    0x0(%esi),%esi
        for (int i = 0; i < 1000000; i++){
            if (i % 1000 == 0){
                printf(1, "hi\n");
            }
            printf(1, "");
 470:	83 ec 08             	sub    $0x8,%esp
        for (int i = 0; i < 1000000; i++){
 473:	83 c3 01             	add    $0x1,%ebx
            printf(1, "");
 476:	68 eb 0c 00 00       	push   $0xceb
 47b:	6a 01                	push   $0x1
 47d:	e8 be 04 00 00       	call   940 <printf>
        for (int i = 0; i < 1000000; i++){
 482:	83 c4 10             	add    $0x10,%esp
 485:	81 fb 40 42 0f 00    	cmp    $0xf4240,%ebx
 48b:	0f 84 d1 00 00 00    	je     562 <main2+0x162>
        sigaction(3, &sigact, null);
 491:	69 c3 d5 78 e9 26    	imul   $0x26e978d5,%ebx,%eax
 497:	c1 c8 03             	ror    $0x3,%eax
            if (i % 1000 == 0){
 49a:	3d 37 89 41 00       	cmp    $0x418937,%eax
 49f:	77 cf                	ja     470 <main2+0x70>
                printf(1, "hi\n");
 4a1:	83 ec 08             	sub    $0x8,%esp
 4a4:	68 1e 0d 00 00       	push   $0xd1e
 4a9:	6a 01                	push   $0x1
 4ab:	e8 90 04 00 00       	call   940 <printf>
 4b0:	83 c4 10             	add    $0x10,%esp
 4b3:	eb bb                	jmp    470 <main2+0x70>
        }
    }
    else{
        printf(1, "childs pid : %d\n", pid);
 4b5:	50                   	push   %eax
 4b6:	53                   	push   %ebx
 4b7:	68 2e 0d 00 00       	push   $0xd2e
 4bc:	6a 01                	push   $0x1
 4be:	e8 7d 04 00 00       	call   940 <printf>
        sleep(100);
 4c3:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
 4ca:	e8 94 03 00 00       	call   863 <sleep>
        printf(1, "sending signal %d to child\n", 1);
 4cf:	83 c4 0c             	add    $0xc,%esp
 4d2:	6a 01                	push   $0x1
 4d4:	68 3f 0d 00 00       	push   $0xd3f
 4d9:	6a 01                	push   $0x1
 4db:	e8 60 04 00 00       	call   940 <printf>
        kill(pid, 1);
 4e0:	5a                   	pop    %edx
 4e1:	59                   	pop    %ecx
 4e2:	6a 01                	push   $0x1
 4e4:	53                   	push   %ebx
 4e5:	e8 19 03 00 00       	call   803 <kill>
        sleep(100);
 4ea:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
 4f1:	e8 6d 03 00 00       	call   863 <sleep>
        printf(1, "sending signal %d to child\n", 2);
 4f6:	83 c4 0c             	add    $0xc,%esp
 4f9:	6a 02                	push   $0x2
 4fb:	68 3f 0d 00 00       	push   $0xd3f
 500:	6a 01                	push   $0x1
 502:	e8 39 04 00 00       	call   940 <printf>
        kill(pid, 2);
 507:	5e                   	pop    %esi
 508:	58                   	pop    %eax
 509:	6a 02                	push   $0x2
 50b:	53                   	push   %ebx
 50c:	e8 f2 02 00 00       	call   803 <kill>
        sleep(100);
 511:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
 518:	e8 46 03 00 00       	call   863 <sleep>
        printf(1, "sending signal %d to child\n", 3);
 51d:	83 c4 0c             	add    $0xc,%esp
 520:	6a 03                	push   $0x3
 522:	68 3f 0d 00 00       	push   $0xd3f
 527:	6a 01                	push   $0x1
 529:	e8 12 04 00 00       	call   940 <printf>
        kill(pid, 3);
 52e:	58                   	pop    %eax
 52f:	5a                   	pop    %edx
 530:	6a 03                	push   $0x3
 532:	53                   	push   %ebx
 533:	e8 cb 02 00 00       	call   803 <kill>
        sleep(100);
 538:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
 53f:	e8 1f 03 00 00       	call   863 <sleep>
        kill(pid, 9);
 544:	59                   	pop    %ecx
 545:	5e                   	pop    %esi
 546:	6a 09                	push   $0x9
 548:	53                   	push   %ebx
 549:	e8 b5 02 00 00       	call   803 <kill>

        wait();
 54e:	e8 88 02 00 00       	call   7db <wait>
        sleep(300);
 553:	c7 04 24 2c 01 00 00 	movl   $0x12c,(%esp)
 55a:	e8 04 03 00 00       	call   863 <sleep>
 55f:	83 c4 10             	add    $0x10,%esp


    }
    exit();
 562:	e8 6c 02 00 00       	call   7d3 <exit>
 567:	66 90                	xchg   %ax,%ax
 569:	66 90                	xchg   %ax,%ax
 56b:	66 90                	xchg   %ax,%ax
 56d:	66 90                	xchg   %ax,%ax
 56f:	90                   	nop

00000570 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 570:	f3 0f 1e fb          	endbr32 
 574:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 575:	31 c0                	xor    %eax,%eax
{
 577:	89 e5                	mov    %esp,%ebp
 579:	53                   	push   %ebx
 57a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 57d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
 580:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 584:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 587:	83 c0 01             	add    $0x1,%eax
 58a:	84 d2                	test   %dl,%dl
 58c:	75 f2                	jne    580 <strcpy+0x10>
    ;
  return os;
}
 58e:	89 c8                	mov    %ecx,%eax
 590:	5b                   	pop    %ebx
 591:	5d                   	pop    %ebp
 592:	c3                   	ret    
 593:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 59a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000005a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 5a0:	f3 0f 1e fb          	endbr32 
 5a4:	55                   	push   %ebp
 5a5:	89 e5                	mov    %esp,%ebp
 5a7:	53                   	push   %ebx
 5a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
 5ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 5ae:	0f b6 01             	movzbl (%ecx),%eax
 5b1:	0f b6 1a             	movzbl (%edx),%ebx
 5b4:	84 c0                	test   %al,%al
 5b6:	75 19                	jne    5d1 <strcmp+0x31>
 5b8:	eb 26                	jmp    5e0 <strcmp+0x40>
 5ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 5c0:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 5c4:	83 c1 01             	add    $0x1,%ecx
 5c7:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 5ca:	0f b6 1a             	movzbl (%edx),%ebx
 5cd:	84 c0                	test   %al,%al
 5cf:	74 0f                	je     5e0 <strcmp+0x40>
 5d1:	38 d8                	cmp    %bl,%al
 5d3:	74 eb                	je     5c0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 5d5:	29 d8                	sub    %ebx,%eax
}
 5d7:	5b                   	pop    %ebx
 5d8:	5d                   	pop    %ebp
 5d9:	c3                   	ret    
 5da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 5e0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 5e2:	29 d8                	sub    %ebx,%eax
}
 5e4:	5b                   	pop    %ebx
 5e5:	5d                   	pop    %ebp
 5e6:	c3                   	ret    
 5e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5ee:	66 90                	xchg   %ax,%ax

000005f0 <strlen>:

uint
strlen(const char *s)
{
 5f0:	f3 0f 1e fb          	endbr32 
 5f4:	55                   	push   %ebp
 5f5:	89 e5                	mov    %esp,%ebp
 5f7:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 5fa:	80 3a 00             	cmpb   $0x0,(%edx)
 5fd:	74 21                	je     620 <strlen+0x30>
 5ff:	31 c0                	xor    %eax,%eax
 601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 608:	83 c0 01             	add    $0x1,%eax
 60b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 60f:	89 c1                	mov    %eax,%ecx
 611:	75 f5                	jne    608 <strlen+0x18>
    ;
  return n;
}
 613:	89 c8                	mov    %ecx,%eax
 615:	5d                   	pop    %ebp
 616:	c3                   	ret    
 617:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 61e:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
 620:	31 c9                	xor    %ecx,%ecx
}
 622:	5d                   	pop    %ebp
 623:	89 c8                	mov    %ecx,%eax
 625:	c3                   	ret    
 626:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 62d:	8d 76 00             	lea    0x0(%esi),%esi

00000630 <memset>:

void*
memset(void *dst, int c, uint n)
{
 630:	f3 0f 1e fb          	endbr32 
 634:	55                   	push   %ebp
 635:	89 e5                	mov    %esp,%ebp
 637:	57                   	push   %edi
 638:	8b 55 08             	mov    0x8(%ebp),%edx
  asm volatile("cld; rep stosb" :
 63b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 63e:	8b 45 0c             	mov    0xc(%ebp),%eax
 641:	89 d7                	mov    %edx,%edi
 643:	fc                   	cld    
 644:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 646:	89 d0                	mov    %edx,%eax
 648:	5f                   	pop    %edi
 649:	5d                   	pop    %ebp
 64a:	c3                   	ret    
 64b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 64f:	90                   	nop

00000650 <strchr>:

char*
strchr(const char *s, char c)
{
 650:	f3 0f 1e fb          	endbr32 
 654:	55                   	push   %ebp
 655:	89 e5                	mov    %esp,%ebp
 657:	8b 45 08             	mov    0x8(%ebp),%eax
 65a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 65e:	0f b6 10             	movzbl (%eax),%edx
 661:	84 d2                	test   %dl,%dl
 663:	75 16                	jne    67b <strchr+0x2b>
 665:	eb 21                	jmp    688 <strchr+0x38>
 667:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 66e:	66 90                	xchg   %ax,%ax
 670:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 674:	83 c0 01             	add    $0x1,%eax
 677:	84 d2                	test   %dl,%dl
 679:	74 0d                	je     688 <strchr+0x38>
    if(*s == c)
 67b:	38 d1                	cmp    %dl,%cl
 67d:	75 f1                	jne    670 <strchr+0x20>
      return (char*)s;
  return 0;
}
 67f:	5d                   	pop    %ebp
 680:	c3                   	ret    
 681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 688:	31 c0                	xor    %eax,%eax
}
 68a:	5d                   	pop    %ebp
 68b:	c3                   	ret    
 68c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000690 <gets>:

char*
gets(char *buf, int max)
{
 690:	f3 0f 1e fb          	endbr32 
 694:	55                   	push   %ebp
 695:	89 e5                	mov    %esp,%ebp
 697:	57                   	push   %edi
 698:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 699:	31 f6                	xor    %esi,%esi
{
 69b:	53                   	push   %ebx
 69c:	89 f3                	mov    %esi,%ebx
 69e:	83 ec 1c             	sub    $0x1c,%esp
 6a1:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 6a4:	eb 33                	jmp    6d9 <gets+0x49>
 6a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6ad:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 6b0:	83 ec 04             	sub    $0x4,%esp
 6b3:	8d 45 e7             	lea    -0x19(%ebp),%eax
 6b6:	6a 01                	push   $0x1
 6b8:	50                   	push   %eax
 6b9:	6a 00                	push   $0x0
 6bb:	e8 2b 01 00 00       	call   7eb <read>
    if(cc < 1)
 6c0:	83 c4 10             	add    $0x10,%esp
 6c3:	85 c0                	test   %eax,%eax
 6c5:	7e 1c                	jle    6e3 <gets+0x53>
      break;
    buf[i++] = c;
 6c7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 6cb:	83 c7 01             	add    $0x1,%edi
 6ce:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 6d1:	3c 0a                	cmp    $0xa,%al
 6d3:	74 23                	je     6f8 <gets+0x68>
 6d5:	3c 0d                	cmp    $0xd,%al
 6d7:	74 1f                	je     6f8 <gets+0x68>
  for(i=0; i+1 < max; ){
 6d9:	83 c3 01             	add    $0x1,%ebx
 6dc:	89 fe                	mov    %edi,%esi
 6de:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 6e1:	7c cd                	jl     6b0 <gets+0x20>
 6e3:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 6e5:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 6e8:	c6 03 00             	movb   $0x0,(%ebx)
}
 6eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6ee:	5b                   	pop    %ebx
 6ef:	5e                   	pop    %esi
 6f0:	5f                   	pop    %edi
 6f1:	5d                   	pop    %ebp
 6f2:	c3                   	ret    
 6f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6f7:	90                   	nop
 6f8:	8b 75 08             	mov    0x8(%ebp),%esi
 6fb:	8b 45 08             	mov    0x8(%ebp),%eax
 6fe:	01 de                	add    %ebx,%esi
 700:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 702:	c6 03 00             	movb   $0x0,(%ebx)
}
 705:	8d 65 f4             	lea    -0xc(%ebp),%esp
 708:	5b                   	pop    %ebx
 709:	5e                   	pop    %esi
 70a:	5f                   	pop    %edi
 70b:	5d                   	pop    %ebp
 70c:	c3                   	ret    
 70d:	8d 76 00             	lea    0x0(%esi),%esi

00000710 <stat>:

int
stat(const char *n, struct stat *st)
{
 710:	f3 0f 1e fb          	endbr32 
 714:	55                   	push   %ebp
 715:	89 e5                	mov    %esp,%ebp
 717:	56                   	push   %esi
 718:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 719:	83 ec 08             	sub    $0x8,%esp
 71c:	6a 00                	push   $0x0
 71e:	ff 75 08             	pushl  0x8(%ebp)
 721:	e8 ed 00 00 00       	call   813 <open>
  if(fd < 0)
 726:	83 c4 10             	add    $0x10,%esp
 729:	85 c0                	test   %eax,%eax
 72b:	78 2b                	js     758 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 72d:	83 ec 08             	sub    $0x8,%esp
 730:	ff 75 0c             	pushl  0xc(%ebp)
 733:	89 c3                	mov    %eax,%ebx
 735:	50                   	push   %eax
 736:	e8 f0 00 00 00       	call   82b <fstat>
  close(fd);
 73b:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 73e:	89 c6                	mov    %eax,%esi
  close(fd);
 740:	e8 b6 00 00 00       	call   7fb <close>
  return r;
 745:	83 c4 10             	add    $0x10,%esp
}
 748:	8d 65 f8             	lea    -0x8(%ebp),%esp
 74b:	89 f0                	mov    %esi,%eax
 74d:	5b                   	pop    %ebx
 74e:	5e                   	pop    %esi
 74f:	5d                   	pop    %ebp
 750:	c3                   	ret    
 751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 758:	be ff ff ff ff       	mov    $0xffffffff,%esi
 75d:	eb e9                	jmp    748 <stat+0x38>
 75f:	90                   	nop

00000760 <atoi>:

int
atoi(const char *s)
{
 760:	f3 0f 1e fb          	endbr32 
 764:	55                   	push   %ebp
 765:	89 e5                	mov    %esp,%ebp
 767:	53                   	push   %ebx
 768:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 76b:	0f be 02             	movsbl (%edx),%eax
 76e:	8d 48 d0             	lea    -0x30(%eax),%ecx
 771:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 774:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 779:	77 1a                	ja     795 <atoi+0x35>
 77b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 77f:	90                   	nop
    n = n*10 + *s++ - '0';
 780:	83 c2 01             	add    $0x1,%edx
 783:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 786:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 78a:	0f be 02             	movsbl (%edx),%eax
 78d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 790:	80 fb 09             	cmp    $0x9,%bl
 793:	76 eb                	jbe    780 <atoi+0x20>
  return n;
}
 795:	89 c8                	mov    %ecx,%eax
 797:	5b                   	pop    %ebx
 798:	5d                   	pop    %ebp
 799:	c3                   	ret    
 79a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000007a0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 7a0:	f3 0f 1e fb          	endbr32 
 7a4:	55                   	push   %ebp
 7a5:	89 e5                	mov    %esp,%ebp
 7a7:	57                   	push   %edi
 7a8:	8b 45 10             	mov    0x10(%ebp),%eax
 7ab:	8b 55 08             	mov    0x8(%ebp),%edx
 7ae:	56                   	push   %esi
 7af:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 7b2:	85 c0                	test   %eax,%eax
 7b4:	7e 0f                	jle    7c5 <memmove+0x25>
 7b6:	01 d0                	add    %edx,%eax
  dst = vdst;
 7b8:	89 d7                	mov    %edx,%edi
 7ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
 7c0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 7c1:	39 f8                	cmp    %edi,%eax
 7c3:	75 fb                	jne    7c0 <memmove+0x20>
  return vdst;
}
 7c5:	5e                   	pop    %esi
 7c6:	89 d0                	mov    %edx,%eax
 7c8:	5f                   	pop    %edi
 7c9:	5d                   	pop    %ebp
 7ca:	c3                   	ret    

000007cb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 7cb:	b8 01 00 00 00       	mov    $0x1,%eax
 7d0:	cd 40                	int    $0x40
 7d2:	c3                   	ret    

000007d3 <exit>:
SYSCALL(exit)
 7d3:	b8 02 00 00 00       	mov    $0x2,%eax
 7d8:	cd 40                	int    $0x40
 7da:	c3                   	ret    

000007db <wait>:
SYSCALL(wait)
 7db:	b8 03 00 00 00       	mov    $0x3,%eax
 7e0:	cd 40                	int    $0x40
 7e2:	c3                   	ret    

000007e3 <pipe>:
SYSCALL(pipe)
 7e3:	b8 04 00 00 00       	mov    $0x4,%eax
 7e8:	cd 40                	int    $0x40
 7ea:	c3                   	ret    

000007eb <read>:
SYSCALL(read)
 7eb:	b8 05 00 00 00       	mov    $0x5,%eax
 7f0:	cd 40                	int    $0x40
 7f2:	c3                   	ret    

000007f3 <write>:
SYSCALL(write)
 7f3:	b8 10 00 00 00       	mov    $0x10,%eax
 7f8:	cd 40                	int    $0x40
 7fa:	c3                   	ret    

000007fb <close>:
SYSCALL(close)
 7fb:	b8 15 00 00 00       	mov    $0x15,%eax
 800:	cd 40                	int    $0x40
 802:	c3                   	ret    

00000803 <kill>:
SYSCALL(kill)
 803:	b8 06 00 00 00       	mov    $0x6,%eax
 808:	cd 40                	int    $0x40
 80a:	c3                   	ret    

0000080b <exec>:
SYSCALL(exec)
 80b:	b8 07 00 00 00       	mov    $0x7,%eax
 810:	cd 40                	int    $0x40
 812:	c3                   	ret    

00000813 <open>:
SYSCALL(open)
 813:	b8 0f 00 00 00       	mov    $0xf,%eax
 818:	cd 40                	int    $0x40
 81a:	c3                   	ret    

0000081b <mknod>:
SYSCALL(mknod)
 81b:	b8 11 00 00 00       	mov    $0x11,%eax
 820:	cd 40                	int    $0x40
 822:	c3                   	ret    

00000823 <unlink>:
SYSCALL(unlink)
 823:	b8 12 00 00 00       	mov    $0x12,%eax
 828:	cd 40                	int    $0x40
 82a:	c3                   	ret    

0000082b <fstat>:
SYSCALL(fstat)
 82b:	b8 08 00 00 00       	mov    $0x8,%eax
 830:	cd 40                	int    $0x40
 832:	c3                   	ret    

00000833 <link>:
SYSCALL(link)
 833:	b8 13 00 00 00       	mov    $0x13,%eax
 838:	cd 40                	int    $0x40
 83a:	c3                   	ret    

0000083b <mkdir>:
SYSCALL(mkdir)
 83b:	b8 14 00 00 00       	mov    $0x14,%eax
 840:	cd 40                	int    $0x40
 842:	c3                   	ret    

00000843 <chdir>:
SYSCALL(chdir)
 843:	b8 09 00 00 00       	mov    $0x9,%eax
 848:	cd 40                	int    $0x40
 84a:	c3                   	ret    

0000084b <dup>:
SYSCALL(dup)
 84b:	b8 0a 00 00 00       	mov    $0xa,%eax
 850:	cd 40                	int    $0x40
 852:	c3                   	ret    

00000853 <getpid>:
SYSCALL(getpid)
 853:	b8 0b 00 00 00       	mov    $0xb,%eax
 858:	cd 40                	int    $0x40
 85a:	c3                   	ret    

0000085b <sbrk>:
SYSCALL(sbrk)
 85b:	b8 0c 00 00 00       	mov    $0xc,%eax
 860:	cd 40                	int    $0x40
 862:	c3                   	ret    

00000863 <sleep>:
SYSCALL(sleep)
 863:	b8 0d 00 00 00       	mov    $0xd,%eax
 868:	cd 40                	int    $0x40
 86a:	c3                   	ret    

0000086b <uptime>:
SYSCALL(uptime)
 86b:	b8 0e 00 00 00       	mov    $0xe,%eax
 870:	cd 40                	int    $0x40
 872:	c3                   	ret    

00000873 <sigprocmask>:
SYSCALL(sigprocmask)
 873:	b8 16 00 00 00       	mov    $0x16,%eax
 878:	cd 40                	int    $0x40
 87a:	c3                   	ret    

0000087b <sigaction>:
SYSCALL(sigaction)
 87b:	b8 17 00 00 00       	mov    $0x17,%eax
 880:	cd 40                	int    $0x40
 882:	c3                   	ret    

00000883 <sigret>:
SYSCALL(sigret)
 883:	b8 18 00 00 00       	mov    $0x18,%eax
 888:	cd 40                	int    $0x40
 88a:	c3                   	ret    
 88b:	66 90                	xchg   %ax,%ax
 88d:	66 90                	xchg   %ax,%ax
 88f:	90                   	nop

00000890 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 890:	55                   	push   %ebp
 891:	89 e5                	mov    %esp,%ebp
 893:	57                   	push   %edi
 894:	56                   	push   %esi
 895:	53                   	push   %ebx
 896:	83 ec 3c             	sub    $0x3c,%esp
 899:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 89c:	89 d1                	mov    %edx,%ecx
{
 89e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 8a1:	85 d2                	test   %edx,%edx
 8a3:	0f 89 7f 00 00 00    	jns    928 <printint+0x98>
 8a9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 8ad:	74 79                	je     928 <printint+0x98>
    neg = 1;
 8af:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 8b6:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 8b8:	31 db                	xor    %ebx,%ebx
 8ba:	8d 75 d7             	lea    -0x29(%ebp),%esi
 8bd:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 8c0:	89 c8                	mov    %ecx,%eax
 8c2:	31 d2                	xor    %edx,%edx
 8c4:	89 cf                	mov    %ecx,%edi
 8c6:	f7 75 c4             	divl   -0x3c(%ebp)
 8c9:	0f b6 92 64 0d 00 00 	movzbl 0xd64(%edx),%edx
 8d0:	89 45 c0             	mov    %eax,-0x40(%ebp)
 8d3:	89 d8                	mov    %ebx,%eax
 8d5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 8d8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 8db:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 8de:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 8e1:	76 dd                	jbe    8c0 <printint+0x30>
  if(neg)
 8e3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 8e6:	85 c9                	test   %ecx,%ecx
 8e8:	74 0c                	je     8f6 <printint+0x66>
    buf[i++] = '-';
 8ea:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 8ef:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 8f1:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 8f6:	8b 7d b8             	mov    -0x48(%ebp),%edi
 8f9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 8fd:	eb 07                	jmp    906 <printint+0x76>
 8ff:	90                   	nop
 900:	0f b6 13             	movzbl (%ebx),%edx
 903:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 906:	83 ec 04             	sub    $0x4,%esp
 909:	88 55 d7             	mov    %dl,-0x29(%ebp)
 90c:	6a 01                	push   $0x1
 90e:	56                   	push   %esi
 90f:	57                   	push   %edi
 910:	e8 de fe ff ff       	call   7f3 <write>
  while(--i >= 0)
 915:	83 c4 10             	add    $0x10,%esp
 918:	39 de                	cmp    %ebx,%esi
 91a:	75 e4                	jne    900 <printint+0x70>
    putc(fd, buf[i]);
}
 91c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 91f:	5b                   	pop    %ebx
 920:	5e                   	pop    %esi
 921:	5f                   	pop    %edi
 922:	5d                   	pop    %ebp
 923:	c3                   	ret    
 924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 928:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 92f:	eb 87                	jmp    8b8 <printint+0x28>
 931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 938:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 93f:	90                   	nop

00000940 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 940:	f3 0f 1e fb          	endbr32 
 944:	55                   	push   %ebp
 945:	89 e5                	mov    %esp,%ebp
 947:	57                   	push   %edi
 948:	56                   	push   %esi
 949:	53                   	push   %ebx
 94a:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 94d:	8b 75 0c             	mov    0xc(%ebp),%esi
 950:	0f b6 1e             	movzbl (%esi),%ebx
 953:	84 db                	test   %bl,%bl
 955:	0f 84 b4 00 00 00    	je     a0f <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
 95b:	8d 45 10             	lea    0x10(%ebp),%eax
 95e:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 961:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 964:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 966:	89 45 d0             	mov    %eax,-0x30(%ebp)
 969:	eb 33                	jmp    99e <printf+0x5e>
 96b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 96f:	90                   	nop
 970:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 973:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 978:	83 f8 25             	cmp    $0x25,%eax
 97b:	74 17                	je     994 <printf+0x54>
  write(fd, &c, 1);
 97d:	83 ec 04             	sub    $0x4,%esp
 980:	88 5d e7             	mov    %bl,-0x19(%ebp)
 983:	6a 01                	push   $0x1
 985:	57                   	push   %edi
 986:	ff 75 08             	pushl  0x8(%ebp)
 989:	e8 65 fe ff ff       	call   7f3 <write>
 98e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 991:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 994:	0f b6 1e             	movzbl (%esi),%ebx
 997:	83 c6 01             	add    $0x1,%esi
 99a:	84 db                	test   %bl,%bl
 99c:	74 71                	je     a0f <printf+0xcf>
    c = fmt[i] & 0xff;
 99e:	0f be cb             	movsbl %bl,%ecx
 9a1:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 9a4:	85 d2                	test   %edx,%edx
 9a6:	74 c8                	je     970 <printf+0x30>
      }
    } else if(state == '%'){
 9a8:	83 fa 25             	cmp    $0x25,%edx
 9ab:	75 e7                	jne    994 <printf+0x54>
      if(c == 'd'){
 9ad:	83 f8 64             	cmp    $0x64,%eax
 9b0:	0f 84 9a 00 00 00    	je     a50 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 9b6:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 9bc:	83 f9 70             	cmp    $0x70,%ecx
 9bf:	74 5f                	je     a20 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 9c1:	83 f8 73             	cmp    $0x73,%eax
 9c4:	0f 84 d6 00 00 00    	je     aa0 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 9ca:	83 f8 63             	cmp    $0x63,%eax
 9cd:	0f 84 8d 00 00 00    	je     a60 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 9d3:	83 f8 25             	cmp    $0x25,%eax
 9d6:	0f 84 b4 00 00 00    	je     a90 <printf+0x150>
  write(fd, &c, 1);
 9dc:	83 ec 04             	sub    $0x4,%esp
 9df:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 9e3:	6a 01                	push   $0x1
 9e5:	57                   	push   %edi
 9e6:	ff 75 08             	pushl  0x8(%ebp)
 9e9:	e8 05 fe ff ff       	call   7f3 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 9ee:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 9f1:	83 c4 0c             	add    $0xc,%esp
 9f4:	6a 01                	push   $0x1
 9f6:	83 c6 01             	add    $0x1,%esi
 9f9:	57                   	push   %edi
 9fa:	ff 75 08             	pushl  0x8(%ebp)
 9fd:	e8 f1 fd ff ff       	call   7f3 <write>
  for(i = 0; fmt[i]; i++){
 a02:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 a06:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 a09:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 a0b:	84 db                	test   %bl,%bl
 a0d:	75 8f                	jne    99e <printf+0x5e>
    }
  }
}
 a0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 a12:	5b                   	pop    %ebx
 a13:	5e                   	pop    %esi
 a14:	5f                   	pop    %edi
 a15:	5d                   	pop    %ebp
 a16:	c3                   	ret    
 a17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a1e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 a20:	83 ec 0c             	sub    $0xc,%esp
 a23:	b9 10 00 00 00       	mov    $0x10,%ecx
 a28:	6a 00                	push   $0x0
 a2a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 a2d:	8b 45 08             	mov    0x8(%ebp),%eax
 a30:	8b 13                	mov    (%ebx),%edx
 a32:	e8 59 fe ff ff       	call   890 <printint>
        ap++;
 a37:	89 d8                	mov    %ebx,%eax
 a39:	83 c4 10             	add    $0x10,%esp
      state = 0;
 a3c:	31 d2                	xor    %edx,%edx
        ap++;
 a3e:	83 c0 04             	add    $0x4,%eax
 a41:	89 45 d0             	mov    %eax,-0x30(%ebp)
 a44:	e9 4b ff ff ff       	jmp    994 <printf+0x54>
 a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 a50:	83 ec 0c             	sub    $0xc,%esp
 a53:	b9 0a 00 00 00       	mov    $0xa,%ecx
 a58:	6a 01                	push   $0x1
 a5a:	eb ce                	jmp    a2a <printf+0xea>
 a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 a60:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 a63:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 a66:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 a68:	6a 01                	push   $0x1
        ap++;
 a6a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 a6d:	57                   	push   %edi
 a6e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 a71:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 a74:	e8 7a fd ff ff       	call   7f3 <write>
        ap++;
 a79:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 a7c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 a7f:	31 d2                	xor    %edx,%edx
 a81:	e9 0e ff ff ff       	jmp    994 <printf+0x54>
 a86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a8d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 a90:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 a93:	83 ec 04             	sub    $0x4,%esp
 a96:	e9 59 ff ff ff       	jmp    9f4 <printf+0xb4>
 a9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 a9f:	90                   	nop
        s = (char*)*ap;
 aa0:	8b 45 d0             	mov    -0x30(%ebp),%eax
 aa3:	8b 18                	mov    (%eax),%ebx
        ap++;
 aa5:	83 c0 04             	add    $0x4,%eax
 aa8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 aab:	85 db                	test   %ebx,%ebx
 aad:	74 17                	je     ac6 <printf+0x186>
        while(*s != 0){
 aaf:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 ab2:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 ab4:	84 c0                	test   %al,%al
 ab6:	0f 84 d8 fe ff ff    	je     994 <printf+0x54>
 abc:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 abf:	89 de                	mov    %ebx,%esi
 ac1:	8b 5d 08             	mov    0x8(%ebp),%ebx
 ac4:	eb 1a                	jmp    ae0 <printf+0x1a0>
          s = "(null)";
 ac6:	bb 5b 0d 00 00       	mov    $0xd5b,%ebx
        while(*s != 0){
 acb:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 ace:	b8 28 00 00 00       	mov    $0x28,%eax
 ad3:	89 de                	mov    %ebx,%esi
 ad5:	8b 5d 08             	mov    0x8(%ebp),%ebx
 ad8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 adf:	90                   	nop
  write(fd, &c, 1);
 ae0:	83 ec 04             	sub    $0x4,%esp
          s++;
 ae3:	83 c6 01             	add    $0x1,%esi
 ae6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 ae9:	6a 01                	push   $0x1
 aeb:	57                   	push   %edi
 aec:	53                   	push   %ebx
 aed:	e8 01 fd ff ff       	call   7f3 <write>
        while(*s != 0){
 af2:	0f b6 06             	movzbl (%esi),%eax
 af5:	83 c4 10             	add    $0x10,%esp
 af8:	84 c0                	test   %al,%al
 afa:	75 e4                	jne    ae0 <printf+0x1a0>
 afc:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 aff:	31 d2                	xor    %edx,%edx
 b01:	e9 8e fe ff ff       	jmp    994 <printf+0x54>
 b06:	66 90                	xchg   %ax,%ax
 b08:	66 90                	xchg   %ax,%ax
 b0a:	66 90                	xchg   %ax,%ax
 b0c:	66 90                	xchg   %ax,%ax
 b0e:	66 90                	xchg   %ax,%ax

00000b10 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b10:	f3 0f 1e fb          	endbr32 
 b14:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b15:	a1 c0 10 00 00       	mov    0x10c0,%eax
{
 b1a:	89 e5                	mov    %esp,%ebp
 b1c:	57                   	push   %edi
 b1d:	56                   	push   %esi
 b1e:	53                   	push   %ebx
 b1f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 b22:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 b24:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b27:	39 c8                	cmp    %ecx,%eax
 b29:	73 15                	jae    b40 <free+0x30>
 b2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 b2f:	90                   	nop
 b30:	39 d1                	cmp    %edx,%ecx
 b32:	72 14                	jb     b48 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b34:	39 d0                	cmp    %edx,%eax
 b36:	73 10                	jae    b48 <free+0x38>
{
 b38:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b3a:	8b 10                	mov    (%eax),%edx
 b3c:	39 c8                	cmp    %ecx,%eax
 b3e:	72 f0                	jb     b30 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b40:	39 d0                	cmp    %edx,%eax
 b42:	72 f4                	jb     b38 <free+0x28>
 b44:	39 d1                	cmp    %edx,%ecx
 b46:	73 f0                	jae    b38 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 b48:	8b 73 fc             	mov    -0x4(%ebx),%esi
 b4b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 b4e:	39 fa                	cmp    %edi,%edx
 b50:	74 1e                	je     b70 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 b52:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 b55:	8b 50 04             	mov    0x4(%eax),%edx
 b58:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 b5b:	39 f1                	cmp    %esi,%ecx
 b5d:	74 28                	je     b87 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 b5f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 b61:	5b                   	pop    %ebx
  freep = p;
 b62:	a3 c0 10 00 00       	mov    %eax,0x10c0
}
 b67:	5e                   	pop    %esi
 b68:	5f                   	pop    %edi
 b69:	5d                   	pop    %ebp
 b6a:	c3                   	ret    
 b6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 b6f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 b70:	03 72 04             	add    0x4(%edx),%esi
 b73:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 b76:	8b 10                	mov    (%eax),%edx
 b78:	8b 12                	mov    (%edx),%edx
 b7a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 b7d:	8b 50 04             	mov    0x4(%eax),%edx
 b80:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 b83:	39 f1                	cmp    %esi,%ecx
 b85:	75 d8                	jne    b5f <free+0x4f>
    p->s.size += bp->s.size;
 b87:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 b8a:	a3 c0 10 00 00       	mov    %eax,0x10c0
    p->s.size += bp->s.size;
 b8f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 b92:	8b 53 f8             	mov    -0x8(%ebx),%edx
 b95:	89 10                	mov    %edx,(%eax)
}
 b97:	5b                   	pop    %ebx
 b98:	5e                   	pop    %esi
 b99:	5f                   	pop    %edi
 b9a:	5d                   	pop    %ebp
 b9b:	c3                   	ret    
 b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000ba0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 ba0:	f3 0f 1e fb          	endbr32 
 ba4:	55                   	push   %ebp
 ba5:	89 e5                	mov    %esp,%ebp
 ba7:	57                   	push   %edi
 ba8:	56                   	push   %esi
 ba9:	53                   	push   %ebx
 baa:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 bad:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 bb0:	8b 3d c0 10 00 00    	mov    0x10c0,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 bb6:	8d 70 07             	lea    0x7(%eax),%esi
 bb9:	c1 ee 03             	shr    $0x3,%esi
 bbc:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 bbf:	85 ff                	test   %edi,%edi
 bc1:	0f 84 a9 00 00 00    	je     c70 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bc7:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 bc9:	8b 48 04             	mov    0x4(%eax),%ecx
 bcc:	39 f1                	cmp    %esi,%ecx
 bce:	73 6d                	jae    c3d <malloc+0x9d>
 bd0:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 bd6:	bb 00 10 00 00       	mov    $0x1000,%ebx
 bdb:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 bde:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 be5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 be8:	eb 17                	jmp    c01 <malloc+0x61>
 bea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bf0:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 bf2:	8b 4a 04             	mov    0x4(%edx),%ecx
 bf5:	39 f1                	cmp    %esi,%ecx
 bf7:	73 4f                	jae    c48 <malloc+0xa8>
 bf9:	8b 3d c0 10 00 00    	mov    0x10c0,%edi
 bff:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 c01:	39 c7                	cmp    %eax,%edi
 c03:	75 eb                	jne    bf0 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 c05:	83 ec 0c             	sub    $0xc,%esp
 c08:	ff 75 e4             	pushl  -0x1c(%ebp)
 c0b:	e8 4b fc ff ff       	call   85b <sbrk>
  if(p == (char*)-1)
 c10:	83 c4 10             	add    $0x10,%esp
 c13:	83 f8 ff             	cmp    $0xffffffff,%eax
 c16:	74 1b                	je     c33 <malloc+0x93>
  hp->s.size = nu;
 c18:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 c1b:	83 ec 0c             	sub    $0xc,%esp
 c1e:	83 c0 08             	add    $0x8,%eax
 c21:	50                   	push   %eax
 c22:	e8 e9 fe ff ff       	call   b10 <free>
  return freep;
 c27:	a1 c0 10 00 00       	mov    0x10c0,%eax
      if((p = morecore(nunits)) == 0)
 c2c:	83 c4 10             	add    $0x10,%esp
 c2f:	85 c0                	test   %eax,%eax
 c31:	75 bd                	jne    bf0 <malloc+0x50>
        return 0;
  }
}
 c33:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 c36:	31 c0                	xor    %eax,%eax
}
 c38:	5b                   	pop    %ebx
 c39:	5e                   	pop    %esi
 c3a:	5f                   	pop    %edi
 c3b:	5d                   	pop    %ebp
 c3c:	c3                   	ret    
    if(p->s.size >= nunits){
 c3d:	89 c2                	mov    %eax,%edx
 c3f:	89 f8                	mov    %edi,%eax
 c41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 c48:	39 ce                	cmp    %ecx,%esi
 c4a:	74 54                	je     ca0 <malloc+0x100>
        p->s.size -= nunits;
 c4c:	29 f1                	sub    %esi,%ecx
 c4e:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 c51:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 c54:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 c57:	a3 c0 10 00 00       	mov    %eax,0x10c0
}
 c5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 c5f:	8d 42 08             	lea    0x8(%edx),%eax
}
 c62:	5b                   	pop    %ebx
 c63:	5e                   	pop    %esi
 c64:	5f                   	pop    %edi
 c65:	5d                   	pop    %ebp
 c66:	c3                   	ret    
 c67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 c6e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 c70:	c7 05 c0 10 00 00 c4 	movl   $0x10c4,0x10c0
 c77:	10 00 00 
    base.s.size = 0;
 c7a:	bf c4 10 00 00       	mov    $0x10c4,%edi
    base.s.ptr = freep = prevp = &base;
 c7f:	c7 05 c4 10 00 00 c4 	movl   $0x10c4,0x10c4
 c86:	10 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c89:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 c8b:	c7 05 c8 10 00 00 00 	movl   $0x0,0x10c8
 c92:	00 00 00 
    if(p->s.size >= nunits){
 c95:	e9 36 ff ff ff       	jmp    bd0 <malloc+0x30>
 c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 ca0:	8b 0a                	mov    (%edx),%ecx
 ca2:	89 08                	mov    %ecx,(%eax)
 ca4:	eb b1                	jmp    c57 <malloc+0xb7>
