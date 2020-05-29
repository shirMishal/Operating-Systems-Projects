
_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  return 0;
}

int
main(void)
{
       0:	f3 0f 1e fb          	endbr32 
       4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
       8:	83 e4 f0             	and    $0xfffffff0,%esp
       b:	ff 71 fc             	pushl  -0x4(%ecx)
       e:	55                   	push   %ebp
       f:	89 e5                	mov    %esp,%ebp
      11:	51                   	push   %ecx
      12:	83 ec 04             	sub    $0x4,%esp
  static char buf[100];
  int fd;

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
      15:	eb 12                	jmp    29 <main+0x29>
      17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      1e:	66 90                	xchg   %ax,%ax
    if(fd >= 3){
      20:	83 f8 02             	cmp    $0x2,%eax
      23:	0f 8f c4 00 00 00    	jg     ed <main+0xed>
  while((fd = open("console", O_RDWR)) >= 0){
      29:	83 ec 08             	sub    $0x8,%esp
      2c:	6a 02                	push   $0x2
      2e:	68 69 13 00 00       	push   $0x1369
      33:	e8 eb 0d 00 00       	call   e23 <open>
      38:	83 c4 10             	add    $0x10,%esp
      3b:	85 c0                	test   %eax,%eax
      3d:	79 e1                	jns    20 <main+0x20>
      3f:	eb 3a                	jmp    7b <main+0x7b>
      41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
      48:	80 3d a2 19 00 00 20 	cmpb   $0x20,0x19a2
      4f:	74 5e                	je     af <main+0xaf>
      51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
int
fork1(void)
{
  int pid;

  pid = fork();
      58:	e8 7e 0d 00 00       	call   ddb <fork>
  if(pid == -1)
      5d:	83 f8 ff             	cmp    $0xffffffff,%eax
      60:	0f 84 aa 00 00 00    	je     110 <main+0x110>
    if(fork1() == 0)
      66:	85 c0                	test   %eax,%eax
      68:	0f 84 8d 00 00 00    	je     fb <main+0xfb>
    wait(null);
      6e:	83 ec 0c             	sub    $0xc,%esp
      71:	6a 00                	push   $0x0
      73:	e8 73 0d 00 00       	call   deb <wait>
      78:	83 c4 10             	add    $0x10,%esp
  while(getcmd(buf, sizeof(buf)) >= 0){
      7b:	83 ec 08             	sub    $0x8,%esp
      7e:	6a 64                	push   $0x64
      80:	68 a0 19 00 00       	push   $0x19a0
      85:	e8 96 00 00 00       	call   120 <getcmd>
      8a:	83 c4 10             	add    $0x10,%esp
      8d:	85 c0                	test   %eax,%eax
      8f:	78 14                	js     a5 <main+0xa5>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
      91:	80 3d a0 19 00 00 63 	cmpb   $0x63,0x19a0
      98:	75 be                	jne    58 <main+0x58>
      9a:	80 3d a1 19 00 00 64 	cmpb   $0x64,0x19a1
      a1:	75 b5                	jne    58 <main+0x58>
      a3:	eb a3                	jmp    48 <main+0x48>
  exit(0);
      a5:	83 ec 0c             	sub    $0xc,%esp
      a8:	6a 00                	push   $0x0
      aa:	e8 34 0d 00 00       	call   de3 <exit>
      buf[strlen(buf)-1] = 0;  // chop \n
      af:	83 ec 0c             	sub    $0xc,%esp
      b2:	68 a0 19 00 00       	push   $0x19a0
      b7:	e8 44 0b 00 00       	call   c00 <strlen>
      if(chdir(buf+3) < 0)
      bc:	c7 04 24 a3 19 00 00 	movl   $0x19a3,(%esp)
      buf[strlen(buf)-1] = 0;  // chop \n
      c3:	c6 80 9f 19 00 00 00 	movb   $0x0,0x199f(%eax)
      if(chdir(buf+3) < 0)
      ca:	e8 84 0d 00 00       	call   e53 <chdir>
      cf:	83 c4 10             	add    $0x10,%esp
      d2:	85 c0                	test   %eax,%eax
      d4:	79 a5                	jns    7b <main+0x7b>
        printf(2, "cannot cd %s\n", buf+3);
      d6:	50                   	push   %eax
      d7:	68 a3 19 00 00       	push   $0x19a3
      dc:	68 71 13 00 00       	push   $0x1371
      e1:	6a 02                	push   $0x2
      e3:	e8 78 0e 00 00       	call   f60 <printf>
      e8:	83 c4 10             	add    $0x10,%esp
      eb:	eb 8e                	jmp    7b <main+0x7b>
      close(fd);
      ed:	83 ec 0c             	sub    $0xc,%esp
      f0:	50                   	push   %eax
      f1:	e8 15 0d 00 00       	call   e0b <close>
      break;
      f6:	83 c4 10             	add    $0x10,%esp
      f9:	eb 80                	jmp    7b <main+0x7b>
      runcmd(parsecmd(buf));
      fb:	83 ec 0c             	sub    $0xc,%esp
      fe:	68 a0 19 00 00       	push   $0x19a0
     103:	e8 08 0a 00 00       	call   b10 <parsecmd>
     108:	89 04 24             	mov    %eax,(%esp)
     10b:	e8 90 00 00 00       	call   1a0 <runcmd>
    panic("fork");
     110:	83 ec 0c             	sub    $0xc,%esp
     113:	68 f2 12 00 00       	push   $0x12f2
     118:	e8 53 00 00 00       	call   170 <panic>
     11d:	66 90                	xchg   %ax,%ax
     11f:	90                   	nop

00000120 <getcmd>:
{
     120:	f3 0f 1e fb          	endbr32 
     124:	55                   	push   %ebp
     125:	89 e5                	mov    %esp,%ebp
     127:	56                   	push   %esi
     128:	53                   	push   %ebx
     129:	8b 75 0c             	mov    0xc(%ebp),%esi
     12c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  printf(2, "$ ");
     12f:	83 ec 08             	sub    $0x8,%esp
     132:	68 c8 12 00 00       	push   $0x12c8
     137:	6a 02                	push   $0x2
     139:	e8 22 0e 00 00       	call   f60 <printf>
  memset(buf, 0, nbuf);
     13e:	83 c4 0c             	add    $0xc,%esp
     141:	56                   	push   %esi
     142:	6a 00                	push   $0x0
     144:	53                   	push   %ebx
     145:	e8 f6 0a 00 00       	call   c40 <memset>
  gets(buf, nbuf);
     14a:	58                   	pop    %eax
     14b:	5a                   	pop    %edx
     14c:	56                   	push   %esi
     14d:	53                   	push   %ebx
     14e:	e8 4d 0b 00 00       	call   ca0 <gets>
  if(buf[0] == 0) // EOF
     153:	83 c4 10             	add    $0x10,%esp
     156:	31 c0                	xor    %eax,%eax
     158:	80 3b 00             	cmpb   $0x0,(%ebx)
     15b:	0f 94 c0             	sete   %al
}
     15e:	8d 65 f8             	lea    -0x8(%ebp),%esp
     161:	5b                   	pop    %ebx
  if(buf[0] == 0) // EOF
     162:	f7 d8                	neg    %eax
}
     164:	5e                   	pop    %esi
     165:	5d                   	pop    %ebp
     166:	c3                   	ret    
     167:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     16e:	66 90                	xchg   %ax,%ax

00000170 <panic>:
{
     170:	f3 0f 1e fb          	endbr32 
     174:	55                   	push   %ebp
     175:	89 e5                	mov    %esp,%ebp
     177:	83 ec 0c             	sub    $0xc,%esp
  printf(2, "%s\n", s);
     17a:	ff 75 08             	pushl  0x8(%ebp)
     17d:	68 65 13 00 00       	push   $0x1365
     182:	6a 02                	push   $0x2
     184:	e8 d7 0d 00 00       	call   f60 <printf>
  exit(1);
     189:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     190:	e8 4e 0c 00 00       	call   de3 <exit>
     195:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     19c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000001a0 <runcmd>:
{
     1a0:	f3 0f 1e fb          	endbr32 
     1a4:	55                   	push   %ebp
     1a5:	89 e5                	mov    %esp,%ebp
     1a7:	53                   	push   %ebx
     1a8:	83 ec 14             	sub    $0x14,%esp
     1ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(cmd == 0)
     1ae:	85 db                	test   %ebx,%ebx
     1b0:	0f 84 23 01 00 00    	je     2d9 <runcmd+0x139>
  switch(cmd->type){
     1b6:	83 3b 05             	cmpl   $0x5,(%ebx)
     1b9:	0f 87 24 01 00 00    	ja     2e3 <runcmd+0x143>
     1bf:	8b 03                	mov    (%ebx),%eax
     1c1:	3e ff 24 85 80 13 00 	notrack jmp *0x1380(,%eax,4)
     1c8:	00 
  pid = fork();
     1c9:	e8 0d 0c 00 00       	call   ddb <fork>
  if(pid == -1)
     1ce:	83 f8 ff             	cmp    $0xffffffff,%eax
     1d1:	0f 84 9e 01 00 00    	je     375 <runcmd+0x1d5>
    if(fork1() == 0)
     1d7:	85 c0                	test   %eax,%eax
     1d9:	0f 84 ef 00 00 00    	je     2ce <runcmd+0x12e>
      exit(0);
     1df:	83 ec 0c             	sub    $0xc,%esp
     1e2:	6a 00                	push   $0x0
     1e4:	e8 fa 0b 00 00       	call   de3 <exit>
    if(ecmd->argv[0] == 0)
     1e9:	8b 43 04             	mov    0x4(%ebx),%eax
     1ec:	85 c0                	test   %eax,%eax
     1ee:	74 ef                	je     1df <runcmd+0x3f>
    exec(ecmd->argv[0], ecmd->argv);
     1f0:	8d 53 04             	lea    0x4(%ebx),%edx
     1f3:	51                   	push   %ecx
     1f4:	51                   	push   %ecx
     1f5:	52                   	push   %edx
     1f6:	50                   	push   %eax
     1f7:	e8 1f 0c 00 00       	call   e1b <exec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
     1fc:	83 c4 0c             	add    $0xc,%esp
     1ff:	ff 73 04             	pushl  0x4(%ebx)
     202:	68 d2 12 00 00       	push   $0x12d2
     207:	6a 02                	push   $0x2
     209:	e8 52 0d 00 00       	call   f60 <printf>
    break;
     20e:	83 c4 10             	add    $0x10,%esp
     211:	eb cc                	jmp    1df <runcmd+0x3f>
    if(pipe(p) < 0)
     213:	83 ec 0c             	sub    $0xc,%esp
     216:	8d 45 f0             	lea    -0x10(%ebp),%eax
     219:	50                   	push   %eax
     21a:	e8 d4 0b 00 00       	call   df3 <pipe>
     21f:	83 c4 10             	add    $0x10,%esp
     222:	85 c0                	test   %eax,%eax
     224:	0f 88 e2 00 00 00    	js     30c <runcmd+0x16c>
  pid = fork();
     22a:	e8 ac 0b 00 00       	call   ddb <fork>
  if(pid == -1)
     22f:	83 f8 ff             	cmp    $0xffffffff,%eax
     232:	0f 84 3d 01 00 00    	je     375 <runcmd+0x1d5>
    if(fork1() == 0){
     238:	85 c0                	test   %eax,%eax
     23a:	0f 84 d9 00 00 00    	je     319 <runcmd+0x179>
  pid = fork();
     240:	e8 96 0b 00 00       	call   ddb <fork>
  if(pid == -1)
     245:	83 f8 ff             	cmp    $0xffffffff,%eax
     248:	0f 84 27 01 00 00    	je     375 <runcmd+0x1d5>
    if(fork1() == 0){
     24e:	85 c0                	test   %eax,%eax
     250:	0f 84 f1 00 00 00    	je     347 <runcmd+0x1a7>
    close(p[0]);
     256:	83 ec 0c             	sub    $0xc,%esp
     259:	ff 75 f0             	pushl  -0x10(%ebp)
     25c:	e8 aa 0b 00 00       	call   e0b <close>
    close(p[1]);
     261:	58                   	pop    %eax
     262:	ff 75 f4             	pushl  -0xc(%ebp)
     265:	e8 a1 0b 00 00       	call   e0b <close>
    wait(null);
     26a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     271:	e8 75 0b 00 00       	call   deb <wait>
    wait(null);
     276:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     27d:	e8 69 0b 00 00       	call   deb <wait>
    break;
     282:	83 c4 10             	add    $0x10,%esp
     285:	e9 55 ff ff ff       	jmp    1df <runcmd+0x3f>
  pid = fork();
     28a:	e8 4c 0b 00 00       	call   ddb <fork>
  if(pid == -1)
     28f:	83 f8 ff             	cmp    $0xffffffff,%eax
     292:	0f 84 dd 00 00 00    	je     375 <runcmd+0x1d5>
    if(fork1() == 0)
     298:	85 c0                	test   %eax,%eax
     29a:	74 32                	je     2ce <runcmd+0x12e>
    wait(null);
     29c:	83 ec 0c             	sub    $0xc,%esp
     29f:	6a 00                	push   $0x0
     2a1:	e8 45 0b 00 00       	call   deb <wait>
    runcmd(lcmd->right);
     2a6:	59                   	pop    %ecx
     2a7:	ff 73 08             	pushl  0x8(%ebx)
     2aa:	e8 f1 fe ff ff       	call   1a0 <runcmd>
    close(rcmd->fd);
     2af:	83 ec 0c             	sub    $0xc,%esp
     2b2:	ff 73 14             	pushl  0x14(%ebx)
     2b5:	e8 51 0b 00 00       	call   e0b <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     2ba:	58                   	pop    %eax
     2bb:	5a                   	pop    %edx
     2bc:	ff 73 10             	pushl  0x10(%ebx)
     2bf:	ff 73 08             	pushl  0x8(%ebx)
     2c2:	e8 5c 0b 00 00       	call   e23 <open>
     2c7:	83 c4 10             	add    $0x10,%esp
     2ca:	85 c0                	test   %eax,%eax
     2cc:	78 22                	js     2f0 <runcmd+0x150>
      runcmd(bcmd->cmd);
     2ce:	83 ec 0c             	sub    $0xc,%esp
     2d1:	ff 73 04             	pushl  0x4(%ebx)
     2d4:	e8 c7 fe ff ff       	call   1a0 <runcmd>
    exit(1);
     2d9:	83 ec 0c             	sub    $0xc,%esp
     2dc:	6a 01                	push   $0x1
     2de:	e8 00 0b 00 00       	call   de3 <exit>
    panic("runcmd");
     2e3:	83 ec 0c             	sub    $0xc,%esp
     2e6:	68 cb 12 00 00       	push   $0x12cb
     2eb:	e8 80 fe ff ff       	call   170 <panic>
      printf(2, "open %s failed\n", rcmd->file);
     2f0:	50                   	push   %eax
     2f1:	ff 73 08             	pushl  0x8(%ebx)
     2f4:	68 e2 12 00 00       	push   $0x12e2
     2f9:	6a 02                	push   $0x2
     2fb:	e8 60 0c 00 00       	call   f60 <printf>
      exit(1);
     300:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     307:	e8 d7 0a 00 00       	call   de3 <exit>
      panic("pipe");
     30c:	83 ec 0c             	sub    $0xc,%esp
     30f:	68 f7 12 00 00       	push   $0x12f7
     314:	e8 57 fe ff ff       	call   170 <panic>
      close(1);
     319:	83 ec 0c             	sub    $0xc,%esp
     31c:	6a 01                	push   $0x1
     31e:	e8 e8 0a 00 00       	call   e0b <close>
      dup(p[1]);
     323:	58                   	pop    %eax
     324:	ff 75 f4             	pushl  -0xc(%ebp)
     327:	e8 2f 0b 00 00       	call   e5b <dup>
      close(p[0]);
     32c:	58                   	pop    %eax
     32d:	ff 75 f0             	pushl  -0x10(%ebp)
     330:	e8 d6 0a 00 00       	call   e0b <close>
      close(p[1]);
     335:	58                   	pop    %eax
     336:	ff 75 f4             	pushl  -0xc(%ebp)
     339:	e8 cd 0a 00 00       	call   e0b <close>
      runcmd(pcmd->left);
     33e:	5a                   	pop    %edx
     33f:	ff 73 04             	pushl  0x4(%ebx)
     342:	e8 59 fe ff ff       	call   1a0 <runcmd>
      close(0);
     347:	83 ec 0c             	sub    $0xc,%esp
     34a:	6a 00                	push   $0x0
     34c:	e8 ba 0a 00 00       	call   e0b <close>
      dup(p[0]);
     351:	5a                   	pop    %edx
     352:	ff 75 f0             	pushl  -0x10(%ebp)
     355:	e8 01 0b 00 00       	call   e5b <dup>
      close(p[0]);
     35a:	59                   	pop    %ecx
     35b:	ff 75 f0             	pushl  -0x10(%ebp)
     35e:	e8 a8 0a 00 00       	call   e0b <close>
      close(p[1]);
     363:	58                   	pop    %eax
     364:	ff 75 f4             	pushl  -0xc(%ebp)
     367:	e8 9f 0a 00 00       	call   e0b <close>
      runcmd(pcmd->right);
     36c:	58                   	pop    %eax
     36d:	ff 73 08             	pushl  0x8(%ebx)
     370:	e8 2b fe ff ff       	call   1a0 <runcmd>
    panic("fork");
     375:	83 ec 0c             	sub    $0xc,%esp
     378:	68 f2 12 00 00       	push   $0x12f2
     37d:	e8 ee fd ff ff       	call   170 <panic>
     382:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000390 <fork1>:
{
     390:	f3 0f 1e fb          	endbr32 
     394:	55                   	push   %ebp
     395:	89 e5                	mov    %esp,%ebp
     397:	83 ec 08             	sub    $0x8,%esp
  pid = fork();
     39a:	e8 3c 0a 00 00       	call   ddb <fork>
  if(pid == -1)
     39f:	83 f8 ff             	cmp    $0xffffffff,%eax
     3a2:	74 02                	je     3a6 <fork1+0x16>
  return pid;
}
     3a4:	c9                   	leave  
     3a5:	c3                   	ret    
    panic("fork");
     3a6:	83 ec 0c             	sub    $0xc,%esp
     3a9:	68 f2 12 00 00       	push   $0x12f2
     3ae:	e8 bd fd ff ff       	call   170 <panic>
     3b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     3ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000003c0 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     3c0:	f3 0f 1e fb          	endbr32 
     3c4:	55                   	push   %ebp
     3c5:	89 e5                	mov    %esp,%ebp
     3c7:	53                   	push   %ebx
     3c8:	83 ec 10             	sub    $0x10,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3cb:	6a 54                	push   $0x54
     3cd:	e8 ee 0d 00 00       	call   11c0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     3d2:	83 c4 0c             	add    $0xc,%esp
     3d5:	6a 54                	push   $0x54
  cmd = malloc(sizeof(*cmd));
     3d7:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     3d9:	6a 00                	push   $0x0
     3db:	50                   	push   %eax
     3dc:	e8 5f 08 00 00       	call   c40 <memset>
  cmd->type = EXEC;
     3e1:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  return (struct cmd*)cmd;
}
     3e7:	89 d8                	mov    %ebx,%eax
     3e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     3ec:	c9                   	leave  
     3ed:	c3                   	ret    
     3ee:	66 90                	xchg   %ax,%ax

000003f0 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     3f0:	f3 0f 1e fb          	endbr32 
     3f4:	55                   	push   %ebp
     3f5:	89 e5                	mov    %esp,%ebp
     3f7:	53                   	push   %ebx
     3f8:	83 ec 10             	sub    $0x10,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3fb:	6a 18                	push   $0x18
     3fd:	e8 be 0d 00 00       	call   11c0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     402:	83 c4 0c             	add    $0xc,%esp
     405:	6a 18                	push   $0x18
  cmd = malloc(sizeof(*cmd));
     407:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     409:	6a 00                	push   $0x0
     40b:	50                   	push   %eax
     40c:	e8 2f 08 00 00       	call   c40 <memset>
  cmd->type = REDIR;
  cmd->cmd = subcmd;
     411:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = REDIR;
     414:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  cmd->cmd = subcmd;
     41a:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->file = file;
     41d:	8b 45 0c             	mov    0xc(%ebp),%eax
     420:	89 43 08             	mov    %eax,0x8(%ebx)
  cmd->efile = efile;
     423:	8b 45 10             	mov    0x10(%ebp),%eax
     426:	89 43 0c             	mov    %eax,0xc(%ebx)
  cmd->mode = mode;
     429:	8b 45 14             	mov    0x14(%ebp),%eax
     42c:	89 43 10             	mov    %eax,0x10(%ebx)
  cmd->fd = fd;
     42f:	8b 45 18             	mov    0x18(%ebp),%eax
     432:	89 43 14             	mov    %eax,0x14(%ebx)
  return (struct cmd*)cmd;
}
     435:	89 d8                	mov    %ebx,%eax
     437:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     43a:	c9                   	leave  
     43b:	c3                   	ret    
     43c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000440 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     440:	f3 0f 1e fb          	endbr32 
     444:	55                   	push   %ebp
     445:	89 e5                	mov    %esp,%ebp
     447:	53                   	push   %ebx
     448:	83 ec 10             	sub    $0x10,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     44b:	6a 0c                	push   $0xc
     44d:	e8 6e 0d 00 00       	call   11c0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     452:	83 c4 0c             	add    $0xc,%esp
     455:	6a 0c                	push   $0xc
  cmd = malloc(sizeof(*cmd));
     457:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     459:	6a 00                	push   $0x0
     45b:	50                   	push   %eax
     45c:	e8 df 07 00 00       	call   c40 <memset>
  cmd->type = PIPE;
  cmd->left = left;
     461:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = PIPE;
     464:	c7 03 03 00 00 00    	movl   $0x3,(%ebx)
  cmd->left = left;
     46a:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     46d:	8b 45 0c             	mov    0xc(%ebp),%eax
     470:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     473:	89 d8                	mov    %ebx,%eax
     475:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     478:	c9                   	leave  
     479:	c3                   	ret    
     47a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000480 <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     480:	f3 0f 1e fb          	endbr32 
     484:	55                   	push   %ebp
     485:	89 e5                	mov    %esp,%ebp
     487:	53                   	push   %ebx
     488:	83 ec 10             	sub    $0x10,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     48b:	6a 0c                	push   $0xc
     48d:	e8 2e 0d 00 00       	call   11c0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     492:	83 c4 0c             	add    $0xc,%esp
     495:	6a 0c                	push   $0xc
  cmd = malloc(sizeof(*cmd));
     497:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     499:	6a 00                	push   $0x0
     49b:	50                   	push   %eax
     49c:	e8 9f 07 00 00       	call   c40 <memset>
  cmd->type = LIST;
  cmd->left = left;
     4a1:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = LIST;
     4a4:	c7 03 04 00 00 00    	movl   $0x4,(%ebx)
  cmd->left = left;
     4aa:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     4ad:	8b 45 0c             	mov    0xc(%ebp),%eax
     4b0:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     4b3:	89 d8                	mov    %ebx,%eax
     4b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     4b8:	c9                   	leave  
     4b9:	c3                   	ret    
     4ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000004c0 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     4c0:	f3 0f 1e fb          	endbr32 
     4c4:	55                   	push   %ebp
     4c5:	89 e5                	mov    %esp,%ebp
     4c7:	53                   	push   %ebx
     4c8:	83 ec 10             	sub    $0x10,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     4cb:	6a 08                	push   $0x8
     4cd:	e8 ee 0c 00 00       	call   11c0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     4d2:	83 c4 0c             	add    $0xc,%esp
     4d5:	6a 08                	push   $0x8
  cmd = malloc(sizeof(*cmd));
     4d7:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     4d9:	6a 00                	push   $0x0
     4db:	50                   	push   %eax
     4dc:	e8 5f 07 00 00       	call   c40 <memset>
  cmd->type = BACK;
  cmd->cmd = subcmd;
     4e1:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = BACK;
     4e4:	c7 03 05 00 00 00    	movl   $0x5,(%ebx)
  cmd->cmd = subcmd;
     4ea:	89 43 04             	mov    %eax,0x4(%ebx)
  return (struct cmd*)cmd;
}
     4ed:	89 d8                	mov    %ebx,%eax
     4ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     4f2:	c9                   	leave  
     4f3:	c3                   	ret    
     4f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     4fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     4ff:	90                   	nop

00000500 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     500:	f3 0f 1e fb          	endbr32 
     504:	55                   	push   %ebp
     505:	89 e5                	mov    %esp,%ebp
     507:	57                   	push   %edi
     508:	56                   	push   %esi
     509:	53                   	push   %ebx
     50a:	83 ec 0c             	sub    $0xc,%esp
  char *s;
  int ret;

  s = *ps;
     50d:	8b 45 08             	mov    0x8(%ebp),%eax
{
     510:	8b 5d 0c             	mov    0xc(%ebp),%ebx
     513:	8b 75 10             	mov    0x10(%ebp),%esi
  s = *ps;
     516:	8b 38                	mov    (%eax),%edi
  while(s < es && strchr(whitespace, *s))
     518:	39 df                	cmp    %ebx,%edi
     51a:	72 0b                	jb     527 <gettoken+0x27>
     51c:	eb 21                	jmp    53f <gettoken+0x3f>
     51e:	66 90                	xchg   %ax,%ax
    s++;
     520:	83 c7 01             	add    $0x1,%edi
  while(s < es && strchr(whitespace, *s))
     523:	39 fb                	cmp    %edi,%ebx
     525:	74 18                	je     53f <gettoken+0x3f>
     527:	0f be 07             	movsbl (%edi),%eax
     52a:	83 ec 08             	sub    $0x8,%esp
     52d:	50                   	push   %eax
     52e:	68 90 19 00 00       	push   $0x1990
     533:	e8 28 07 00 00       	call   c60 <strchr>
     538:	83 c4 10             	add    $0x10,%esp
     53b:	85 c0                	test   %eax,%eax
     53d:	75 e1                	jne    520 <gettoken+0x20>
  if(q)
     53f:	85 f6                	test   %esi,%esi
     541:	74 02                	je     545 <gettoken+0x45>
    *q = s;
     543:	89 3e                	mov    %edi,(%esi)
  ret = *s;
     545:	0f b6 07             	movzbl (%edi),%eax
  switch(*s){
     548:	3c 3c                	cmp    $0x3c,%al
     54a:	0f 8f d0 00 00 00    	jg     620 <gettoken+0x120>
     550:	3c 3a                	cmp    $0x3a,%al
     552:	0f 8f b4 00 00 00    	jg     60c <gettoken+0x10c>
     558:	84 c0                	test   %al,%al
     55a:	75 44                	jne    5a0 <gettoken+0xa0>
     55c:	31 f6                	xor    %esi,%esi
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     55e:	8b 55 14             	mov    0x14(%ebp),%edx
     561:	85 d2                	test   %edx,%edx
     563:	74 05                	je     56a <gettoken+0x6a>
    *eq = s;
     565:	8b 45 14             	mov    0x14(%ebp),%eax
     568:	89 38                	mov    %edi,(%eax)

  while(s < es && strchr(whitespace, *s))
     56a:	39 df                	cmp    %ebx,%edi
     56c:	72 09                	jb     577 <gettoken+0x77>
     56e:	eb 1f                	jmp    58f <gettoken+0x8f>
    s++;
     570:	83 c7 01             	add    $0x1,%edi
  while(s < es && strchr(whitespace, *s))
     573:	39 fb                	cmp    %edi,%ebx
     575:	74 18                	je     58f <gettoken+0x8f>
     577:	0f be 07             	movsbl (%edi),%eax
     57a:	83 ec 08             	sub    $0x8,%esp
     57d:	50                   	push   %eax
     57e:	68 90 19 00 00       	push   $0x1990
     583:	e8 d8 06 00 00       	call   c60 <strchr>
     588:	83 c4 10             	add    $0x10,%esp
     58b:	85 c0                	test   %eax,%eax
     58d:	75 e1                	jne    570 <gettoken+0x70>
  *ps = s;
     58f:	8b 45 08             	mov    0x8(%ebp),%eax
     592:	89 38                	mov    %edi,(%eax)
  return ret;
}
     594:	8d 65 f4             	lea    -0xc(%ebp),%esp
     597:	89 f0                	mov    %esi,%eax
     599:	5b                   	pop    %ebx
     59a:	5e                   	pop    %esi
     59b:	5f                   	pop    %edi
     59c:	5d                   	pop    %ebp
     59d:	c3                   	ret    
     59e:	66 90                	xchg   %ax,%ax
  switch(*s){
     5a0:	79 5e                	jns    600 <gettoken+0x100>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     5a2:	39 fb                	cmp    %edi,%ebx
     5a4:	77 34                	ja     5da <gettoken+0xda>
  if(eq)
     5a6:	8b 45 14             	mov    0x14(%ebp),%eax
     5a9:	be 61 00 00 00       	mov    $0x61,%esi
     5ae:	85 c0                	test   %eax,%eax
     5b0:	75 b3                	jne    565 <gettoken+0x65>
     5b2:	eb db                	jmp    58f <gettoken+0x8f>
     5b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     5b8:	0f be 07             	movsbl (%edi),%eax
     5bb:	83 ec 08             	sub    $0x8,%esp
     5be:	50                   	push   %eax
     5bf:	68 88 19 00 00       	push   $0x1988
     5c4:	e8 97 06 00 00       	call   c60 <strchr>
     5c9:	83 c4 10             	add    $0x10,%esp
     5cc:	85 c0                	test   %eax,%eax
     5ce:	75 22                	jne    5f2 <gettoken+0xf2>
      s++;
     5d0:	83 c7 01             	add    $0x1,%edi
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     5d3:	39 fb                	cmp    %edi,%ebx
     5d5:	74 cf                	je     5a6 <gettoken+0xa6>
     5d7:	0f b6 07             	movzbl (%edi),%eax
     5da:	83 ec 08             	sub    $0x8,%esp
     5dd:	0f be f0             	movsbl %al,%esi
     5e0:	56                   	push   %esi
     5e1:	68 90 19 00 00       	push   $0x1990
     5e6:	e8 75 06 00 00       	call   c60 <strchr>
     5eb:	83 c4 10             	add    $0x10,%esp
     5ee:	85 c0                	test   %eax,%eax
     5f0:	74 c6                	je     5b8 <gettoken+0xb8>
    ret = 'a';
     5f2:	be 61 00 00 00       	mov    $0x61,%esi
     5f7:	e9 62 ff ff ff       	jmp    55e <gettoken+0x5e>
     5fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  switch(*s){
     600:	3c 26                	cmp    $0x26,%al
     602:	74 08                	je     60c <gettoken+0x10c>
     604:	8d 48 d8             	lea    -0x28(%eax),%ecx
     607:	80 f9 01             	cmp    $0x1,%cl
     60a:	77 96                	ja     5a2 <gettoken+0xa2>
  ret = *s;
     60c:	0f be f0             	movsbl %al,%esi
    s++;
     60f:	83 c7 01             	add    $0x1,%edi
    break;
     612:	e9 47 ff ff ff       	jmp    55e <gettoken+0x5e>
     617:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     61e:	66 90                	xchg   %ax,%ax
  switch(*s){
     620:	3c 3e                	cmp    $0x3e,%al
     622:	75 1c                	jne    640 <gettoken+0x140>
    if(*s == '>'){
     624:	80 7f 01 3e          	cmpb   $0x3e,0x1(%edi)
    s++;
     628:	8d 47 01             	lea    0x1(%edi),%eax
    if(*s == '>'){
     62b:	74 1c                	je     649 <gettoken+0x149>
    s++;
     62d:	89 c7                	mov    %eax,%edi
     62f:	be 3e 00 00 00       	mov    $0x3e,%esi
     634:	e9 25 ff ff ff       	jmp    55e <gettoken+0x5e>
     639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  switch(*s){
     640:	3c 7c                	cmp    $0x7c,%al
     642:	74 c8                	je     60c <gettoken+0x10c>
     644:	e9 59 ff ff ff       	jmp    5a2 <gettoken+0xa2>
      s++;
     649:	83 c7 02             	add    $0x2,%edi
      ret = '+';
     64c:	be 2b 00 00 00       	mov    $0x2b,%esi
     651:	e9 08 ff ff ff       	jmp    55e <gettoken+0x5e>
     656:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     65d:	8d 76 00             	lea    0x0(%esi),%esi

00000660 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     660:	f3 0f 1e fb          	endbr32 
     664:	55                   	push   %ebp
     665:	89 e5                	mov    %esp,%ebp
     667:	57                   	push   %edi
     668:	56                   	push   %esi
     669:	53                   	push   %ebx
     66a:	83 ec 0c             	sub    $0xc,%esp
     66d:	8b 7d 08             	mov    0x8(%ebp),%edi
     670:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *s;

  s = *ps;
     673:	8b 1f                	mov    (%edi),%ebx
  while(s < es && strchr(whitespace, *s))
     675:	39 f3                	cmp    %esi,%ebx
     677:	72 0e                	jb     687 <peek+0x27>
     679:	eb 24                	jmp    69f <peek+0x3f>
     67b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     67f:	90                   	nop
    s++;
     680:	83 c3 01             	add    $0x1,%ebx
  while(s < es && strchr(whitespace, *s))
     683:	39 de                	cmp    %ebx,%esi
     685:	74 18                	je     69f <peek+0x3f>
     687:	0f be 03             	movsbl (%ebx),%eax
     68a:	83 ec 08             	sub    $0x8,%esp
     68d:	50                   	push   %eax
     68e:	68 90 19 00 00       	push   $0x1990
     693:	e8 c8 05 00 00       	call   c60 <strchr>
     698:	83 c4 10             	add    $0x10,%esp
     69b:	85 c0                	test   %eax,%eax
     69d:	75 e1                	jne    680 <peek+0x20>
  *ps = s;
     69f:	89 1f                	mov    %ebx,(%edi)
  return *s && strchr(toks, *s);
     6a1:	0f be 03             	movsbl (%ebx),%eax
     6a4:	31 d2                	xor    %edx,%edx
     6a6:	84 c0                	test   %al,%al
     6a8:	75 0e                	jne    6b8 <peek+0x58>
}
     6aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
     6ad:	89 d0                	mov    %edx,%eax
     6af:	5b                   	pop    %ebx
     6b0:	5e                   	pop    %esi
     6b1:	5f                   	pop    %edi
     6b2:	5d                   	pop    %ebp
     6b3:	c3                   	ret    
     6b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return *s && strchr(toks, *s);
     6b8:	83 ec 08             	sub    $0x8,%esp
     6bb:	50                   	push   %eax
     6bc:	ff 75 10             	pushl  0x10(%ebp)
     6bf:	e8 9c 05 00 00       	call   c60 <strchr>
     6c4:	83 c4 10             	add    $0x10,%esp
     6c7:	31 d2                	xor    %edx,%edx
     6c9:	85 c0                	test   %eax,%eax
     6cb:	0f 95 c2             	setne  %dl
}
     6ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
     6d1:	5b                   	pop    %ebx
     6d2:	89 d0                	mov    %edx,%eax
     6d4:	5e                   	pop    %esi
     6d5:	5f                   	pop    %edi
     6d6:	5d                   	pop    %ebp
     6d7:	c3                   	ret    
     6d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     6df:	90                   	nop

000006e0 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     6e0:	f3 0f 1e fb          	endbr32 
     6e4:	55                   	push   %ebp
     6e5:	89 e5                	mov    %esp,%ebp
     6e7:	57                   	push   %edi
     6e8:	56                   	push   %esi
     6e9:	53                   	push   %ebx
     6ea:	83 ec 1c             	sub    $0x1c,%esp
     6ed:	8b 75 0c             	mov    0xc(%ebp),%esi
     6f0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     6f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     6f7:	90                   	nop
     6f8:	83 ec 04             	sub    $0x4,%esp
     6fb:	68 19 13 00 00       	push   $0x1319
     700:	53                   	push   %ebx
     701:	56                   	push   %esi
     702:	e8 59 ff ff ff       	call   660 <peek>
     707:	83 c4 10             	add    $0x10,%esp
     70a:	85 c0                	test   %eax,%eax
     70c:	74 6a                	je     778 <parseredirs+0x98>
    tok = gettoken(ps, es, 0, 0);
     70e:	6a 00                	push   $0x0
     710:	6a 00                	push   $0x0
     712:	53                   	push   %ebx
     713:	56                   	push   %esi
     714:	e8 e7 fd ff ff       	call   500 <gettoken>
     719:	89 c7                	mov    %eax,%edi
    if(gettoken(ps, es, &q, &eq) != 'a')
     71b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     71e:	50                   	push   %eax
     71f:	8d 45 e0             	lea    -0x20(%ebp),%eax
     722:	50                   	push   %eax
     723:	53                   	push   %ebx
     724:	56                   	push   %esi
     725:	e8 d6 fd ff ff       	call   500 <gettoken>
     72a:	83 c4 20             	add    $0x20,%esp
     72d:	83 f8 61             	cmp    $0x61,%eax
     730:	75 51                	jne    783 <parseredirs+0xa3>
      panic("missing file for redirection");
    switch(tok){
     732:	83 ff 3c             	cmp    $0x3c,%edi
     735:	74 31                	je     768 <parseredirs+0x88>
     737:	83 ff 3e             	cmp    $0x3e,%edi
     73a:	74 05                	je     741 <parseredirs+0x61>
     73c:	83 ff 2b             	cmp    $0x2b,%edi
     73f:	75 b7                	jne    6f8 <parseredirs+0x18>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     741:	83 ec 0c             	sub    $0xc,%esp
     744:	6a 01                	push   $0x1
     746:	68 01 02 00 00       	push   $0x201
     74b:	ff 75 e4             	pushl  -0x1c(%ebp)
     74e:	ff 75 e0             	pushl  -0x20(%ebp)
     751:	ff 75 08             	pushl  0x8(%ebp)
     754:	e8 97 fc ff ff       	call   3f0 <redircmd>
      break;
     759:	83 c4 20             	add    $0x20,%esp
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     75c:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     75f:	eb 97                	jmp    6f8 <parseredirs+0x18>
     761:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     768:	83 ec 0c             	sub    $0xc,%esp
     76b:	6a 00                	push   $0x0
     76d:	6a 00                	push   $0x0
     76f:	eb da                	jmp    74b <parseredirs+0x6b>
     771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
  }
  return cmd;
}
     778:	8b 45 08             	mov    0x8(%ebp),%eax
     77b:	8d 65 f4             	lea    -0xc(%ebp),%esp
     77e:	5b                   	pop    %ebx
     77f:	5e                   	pop    %esi
     780:	5f                   	pop    %edi
     781:	5d                   	pop    %ebp
     782:	c3                   	ret    
      panic("missing file for redirection");
     783:	83 ec 0c             	sub    $0xc,%esp
     786:	68 fc 12 00 00       	push   $0x12fc
     78b:	e8 e0 f9 ff ff       	call   170 <panic>

00000790 <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     790:	f3 0f 1e fb          	endbr32 
     794:	55                   	push   %ebp
     795:	89 e5                	mov    %esp,%ebp
     797:	57                   	push   %edi
     798:	56                   	push   %esi
     799:	53                   	push   %ebx
     79a:	83 ec 30             	sub    $0x30,%esp
     79d:	8b 75 08             	mov    0x8(%ebp),%esi
     7a0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     7a3:	68 1c 13 00 00       	push   $0x131c
     7a8:	57                   	push   %edi
     7a9:	56                   	push   %esi
     7aa:	e8 b1 fe ff ff       	call   660 <peek>
     7af:	83 c4 10             	add    $0x10,%esp
     7b2:	85 c0                	test   %eax,%eax
     7b4:	0f 85 96 00 00 00    	jne    850 <parseexec+0xc0>
     7ba:	89 c3                	mov    %eax,%ebx
    return parseblock(ps, es);

  ret = execcmd();
     7bc:	e8 ff fb ff ff       	call   3c0 <execcmd>
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     7c1:	83 ec 04             	sub    $0x4,%esp
     7c4:	57                   	push   %edi
     7c5:	56                   	push   %esi
     7c6:	50                   	push   %eax
  ret = execcmd();
     7c7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  ret = parseredirs(ret, ps, es);
     7ca:	e8 11 ff ff ff       	call   6e0 <parseredirs>
  while(!peek(ps, es, "|)&;")){
     7cf:	83 c4 10             	add    $0x10,%esp
  ret = parseredirs(ret, ps, es);
     7d2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  while(!peek(ps, es, "|)&;")){
     7d5:	eb 1c                	jmp    7f3 <parseexec+0x63>
     7d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     7de:	66 90                	xchg   %ax,%ax
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
     7e0:	83 ec 04             	sub    $0x4,%esp
     7e3:	57                   	push   %edi
     7e4:	56                   	push   %esi
     7e5:	ff 75 d4             	pushl  -0x2c(%ebp)
     7e8:	e8 f3 fe ff ff       	call   6e0 <parseredirs>
     7ed:	83 c4 10             	add    $0x10,%esp
     7f0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  while(!peek(ps, es, "|)&;")){
     7f3:	83 ec 04             	sub    $0x4,%esp
     7f6:	68 33 13 00 00       	push   $0x1333
     7fb:	57                   	push   %edi
     7fc:	56                   	push   %esi
     7fd:	e8 5e fe ff ff       	call   660 <peek>
     802:	83 c4 10             	add    $0x10,%esp
     805:	85 c0                	test   %eax,%eax
     807:	75 67                	jne    870 <parseexec+0xe0>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     809:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     80c:	50                   	push   %eax
     80d:	8d 45 e0             	lea    -0x20(%ebp),%eax
     810:	50                   	push   %eax
     811:	57                   	push   %edi
     812:	56                   	push   %esi
     813:	e8 e8 fc ff ff       	call   500 <gettoken>
     818:	83 c4 10             	add    $0x10,%esp
     81b:	85 c0                	test   %eax,%eax
     81d:	74 51                	je     870 <parseexec+0xe0>
    if(tok != 'a')
     81f:	83 f8 61             	cmp    $0x61,%eax
     822:	75 6b                	jne    88f <parseexec+0xff>
    cmd->argv[argc] = q;
     824:	8b 45 e0             	mov    -0x20(%ebp),%eax
     827:	8b 55 d0             	mov    -0x30(%ebp),%edx
     82a:	89 44 9a 04          	mov    %eax,0x4(%edx,%ebx,4)
    cmd->eargv[argc] = eq;
     82e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     831:	89 44 9a 2c          	mov    %eax,0x2c(%edx,%ebx,4)
    argc++;
     835:	83 c3 01             	add    $0x1,%ebx
    if(argc >= MAXARGS)
     838:	83 fb 0a             	cmp    $0xa,%ebx
     83b:	75 a3                	jne    7e0 <parseexec+0x50>
      panic("too many args");
     83d:	83 ec 0c             	sub    $0xc,%esp
     840:	68 25 13 00 00       	push   $0x1325
     845:	e8 26 f9 ff ff       	call   170 <panic>
     84a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return parseblock(ps, es);
     850:	83 ec 08             	sub    $0x8,%esp
     853:	57                   	push   %edi
     854:	56                   	push   %esi
     855:	e8 66 01 00 00       	call   9c0 <parseblock>
     85a:	83 c4 10             	add    $0x10,%esp
     85d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     860:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     863:	8d 65 f4             	lea    -0xc(%ebp),%esp
     866:	5b                   	pop    %ebx
     867:	5e                   	pop    %esi
     868:	5f                   	pop    %edi
     869:	5d                   	pop    %ebp
     86a:	c3                   	ret    
     86b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     86f:	90                   	nop
  cmd->argv[argc] = 0;
     870:	8b 45 d0             	mov    -0x30(%ebp),%eax
     873:	8d 04 98             	lea    (%eax,%ebx,4),%eax
     876:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  cmd->eargv[argc] = 0;
     87d:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
}
     884:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     887:	8d 65 f4             	lea    -0xc(%ebp),%esp
     88a:	5b                   	pop    %ebx
     88b:	5e                   	pop    %esi
     88c:	5f                   	pop    %edi
     88d:	5d                   	pop    %ebp
     88e:	c3                   	ret    
      panic("syntax");
     88f:	83 ec 0c             	sub    $0xc,%esp
     892:	68 1e 13 00 00       	push   $0x131e
     897:	e8 d4 f8 ff ff       	call   170 <panic>
     89c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000008a0 <parsepipe>:
{
     8a0:	f3 0f 1e fb          	endbr32 
     8a4:	55                   	push   %ebp
     8a5:	89 e5                	mov    %esp,%ebp
     8a7:	57                   	push   %edi
     8a8:	56                   	push   %esi
     8a9:	53                   	push   %ebx
     8aa:	83 ec 14             	sub    $0x14,%esp
     8ad:	8b 75 08             	mov    0x8(%ebp),%esi
     8b0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  cmd = parseexec(ps, es);
     8b3:	57                   	push   %edi
     8b4:	56                   	push   %esi
     8b5:	e8 d6 fe ff ff       	call   790 <parseexec>
  if(peek(ps, es, "|")){
     8ba:	83 c4 0c             	add    $0xc,%esp
     8bd:	68 38 13 00 00       	push   $0x1338
  cmd = parseexec(ps, es);
     8c2:	89 c3                	mov    %eax,%ebx
  if(peek(ps, es, "|")){
     8c4:	57                   	push   %edi
     8c5:	56                   	push   %esi
     8c6:	e8 95 fd ff ff       	call   660 <peek>
     8cb:	83 c4 10             	add    $0x10,%esp
     8ce:	85 c0                	test   %eax,%eax
     8d0:	75 0e                	jne    8e0 <parsepipe+0x40>
}
     8d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
     8d5:	89 d8                	mov    %ebx,%eax
     8d7:	5b                   	pop    %ebx
     8d8:	5e                   	pop    %esi
     8d9:	5f                   	pop    %edi
     8da:	5d                   	pop    %ebp
     8db:	c3                   	ret    
     8dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    gettoken(ps, es, 0, 0);
     8e0:	6a 00                	push   $0x0
     8e2:	6a 00                	push   $0x0
     8e4:	57                   	push   %edi
     8e5:	56                   	push   %esi
     8e6:	e8 15 fc ff ff       	call   500 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     8eb:	58                   	pop    %eax
     8ec:	5a                   	pop    %edx
     8ed:	57                   	push   %edi
     8ee:	56                   	push   %esi
     8ef:	e8 ac ff ff ff       	call   8a0 <parsepipe>
     8f4:	89 5d 08             	mov    %ebx,0x8(%ebp)
     8f7:	83 c4 10             	add    $0x10,%esp
     8fa:	89 45 0c             	mov    %eax,0xc(%ebp)
}
     8fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
     900:	5b                   	pop    %ebx
     901:	5e                   	pop    %esi
     902:	5f                   	pop    %edi
     903:	5d                   	pop    %ebp
    cmd = pipecmd(cmd, parsepipe(ps, es));
     904:	e9 37 fb ff ff       	jmp    440 <pipecmd>
     909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000910 <parseline>:
{
     910:	f3 0f 1e fb          	endbr32 
     914:	55                   	push   %ebp
     915:	89 e5                	mov    %esp,%ebp
     917:	57                   	push   %edi
     918:	56                   	push   %esi
     919:	53                   	push   %ebx
     91a:	83 ec 14             	sub    $0x14,%esp
     91d:	8b 75 08             	mov    0x8(%ebp),%esi
     920:	8b 7d 0c             	mov    0xc(%ebp),%edi
  cmd = parsepipe(ps, es);
     923:	57                   	push   %edi
     924:	56                   	push   %esi
     925:	e8 76 ff ff ff       	call   8a0 <parsepipe>
  while(peek(ps, es, "&")){
     92a:	83 c4 10             	add    $0x10,%esp
  cmd = parsepipe(ps, es);
     92d:	89 c3                	mov    %eax,%ebx
  while(peek(ps, es, "&")){
     92f:	eb 1f                	jmp    950 <parseline+0x40>
     931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    gettoken(ps, es, 0, 0);
     938:	6a 00                	push   $0x0
     93a:	6a 00                	push   $0x0
     93c:	57                   	push   %edi
     93d:	56                   	push   %esi
     93e:	e8 bd fb ff ff       	call   500 <gettoken>
    cmd = backcmd(cmd);
     943:	89 1c 24             	mov    %ebx,(%esp)
     946:	e8 75 fb ff ff       	call   4c0 <backcmd>
     94b:	83 c4 10             	add    $0x10,%esp
     94e:	89 c3                	mov    %eax,%ebx
  while(peek(ps, es, "&")){
     950:	83 ec 04             	sub    $0x4,%esp
     953:	68 3a 13 00 00       	push   $0x133a
     958:	57                   	push   %edi
     959:	56                   	push   %esi
     95a:	e8 01 fd ff ff       	call   660 <peek>
     95f:	83 c4 10             	add    $0x10,%esp
     962:	85 c0                	test   %eax,%eax
     964:	75 d2                	jne    938 <parseline+0x28>
  if(peek(ps, es, ";")){
     966:	83 ec 04             	sub    $0x4,%esp
     969:	68 36 13 00 00       	push   $0x1336
     96e:	57                   	push   %edi
     96f:	56                   	push   %esi
     970:	e8 eb fc ff ff       	call   660 <peek>
     975:	83 c4 10             	add    $0x10,%esp
     978:	85 c0                	test   %eax,%eax
     97a:	75 14                	jne    990 <parseline+0x80>
}
     97c:	8d 65 f4             	lea    -0xc(%ebp),%esp
     97f:	89 d8                	mov    %ebx,%eax
     981:	5b                   	pop    %ebx
     982:	5e                   	pop    %esi
     983:	5f                   	pop    %edi
     984:	5d                   	pop    %ebp
     985:	c3                   	ret    
     986:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     98d:	8d 76 00             	lea    0x0(%esi),%esi
    gettoken(ps, es, 0, 0);
     990:	6a 00                	push   $0x0
     992:	6a 00                	push   $0x0
     994:	57                   	push   %edi
     995:	56                   	push   %esi
     996:	e8 65 fb ff ff       	call   500 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     99b:	58                   	pop    %eax
     99c:	5a                   	pop    %edx
     99d:	57                   	push   %edi
     99e:	56                   	push   %esi
     99f:	e8 6c ff ff ff       	call   910 <parseline>
     9a4:	89 5d 08             	mov    %ebx,0x8(%ebp)
     9a7:	83 c4 10             	add    $0x10,%esp
     9aa:	89 45 0c             	mov    %eax,0xc(%ebp)
}
     9ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
     9b0:	5b                   	pop    %ebx
     9b1:	5e                   	pop    %esi
     9b2:	5f                   	pop    %edi
     9b3:	5d                   	pop    %ebp
    cmd = listcmd(cmd, parseline(ps, es));
     9b4:	e9 c7 fa ff ff       	jmp    480 <listcmd>
     9b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000009c0 <parseblock>:
{
     9c0:	f3 0f 1e fb          	endbr32 
     9c4:	55                   	push   %ebp
     9c5:	89 e5                	mov    %esp,%ebp
     9c7:	57                   	push   %edi
     9c8:	56                   	push   %esi
     9c9:	53                   	push   %ebx
     9ca:	83 ec 10             	sub    $0x10,%esp
     9cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
     9d0:	8b 75 0c             	mov    0xc(%ebp),%esi
  if(!peek(ps, es, "("))
     9d3:	68 1c 13 00 00       	push   $0x131c
     9d8:	56                   	push   %esi
     9d9:	53                   	push   %ebx
     9da:	e8 81 fc ff ff       	call   660 <peek>
     9df:	83 c4 10             	add    $0x10,%esp
     9e2:	85 c0                	test   %eax,%eax
     9e4:	74 4a                	je     a30 <parseblock+0x70>
  gettoken(ps, es, 0, 0);
     9e6:	6a 00                	push   $0x0
     9e8:	6a 00                	push   $0x0
     9ea:	56                   	push   %esi
     9eb:	53                   	push   %ebx
     9ec:	e8 0f fb ff ff       	call   500 <gettoken>
  cmd = parseline(ps, es);
     9f1:	58                   	pop    %eax
     9f2:	5a                   	pop    %edx
     9f3:	56                   	push   %esi
     9f4:	53                   	push   %ebx
     9f5:	e8 16 ff ff ff       	call   910 <parseline>
  if(!peek(ps, es, ")"))
     9fa:	83 c4 0c             	add    $0xc,%esp
     9fd:	68 58 13 00 00       	push   $0x1358
  cmd = parseline(ps, es);
     a02:	89 c7                	mov    %eax,%edi
  if(!peek(ps, es, ")"))
     a04:	56                   	push   %esi
     a05:	53                   	push   %ebx
     a06:	e8 55 fc ff ff       	call   660 <peek>
     a0b:	83 c4 10             	add    $0x10,%esp
     a0e:	85 c0                	test   %eax,%eax
     a10:	74 2b                	je     a3d <parseblock+0x7d>
  gettoken(ps, es, 0, 0);
     a12:	6a 00                	push   $0x0
     a14:	6a 00                	push   $0x0
     a16:	56                   	push   %esi
     a17:	53                   	push   %ebx
     a18:	e8 e3 fa ff ff       	call   500 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     a1d:	83 c4 0c             	add    $0xc,%esp
     a20:	56                   	push   %esi
     a21:	53                   	push   %ebx
     a22:	57                   	push   %edi
     a23:	e8 b8 fc ff ff       	call   6e0 <parseredirs>
}
     a28:	8d 65 f4             	lea    -0xc(%ebp),%esp
     a2b:	5b                   	pop    %ebx
     a2c:	5e                   	pop    %esi
     a2d:	5f                   	pop    %edi
     a2e:	5d                   	pop    %ebp
     a2f:	c3                   	ret    
    panic("parseblock");
     a30:	83 ec 0c             	sub    $0xc,%esp
     a33:	68 3c 13 00 00       	push   $0x133c
     a38:	e8 33 f7 ff ff       	call   170 <panic>
    panic("syntax - missing )");
     a3d:	83 ec 0c             	sub    $0xc,%esp
     a40:	68 47 13 00 00       	push   $0x1347
     a45:	e8 26 f7 ff ff       	call   170 <panic>
     a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000a50 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     a50:	f3 0f 1e fb          	endbr32 
     a54:	55                   	push   %ebp
     a55:	89 e5                	mov    %esp,%ebp
     a57:	53                   	push   %ebx
     a58:	83 ec 04             	sub    $0x4,%esp
     a5b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     a5e:	85 db                	test   %ebx,%ebx
     a60:	0f 84 9a 00 00 00    	je     b00 <nulterminate+0xb0>
    return 0;

  switch(cmd->type){
     a66:	83 3b 05             	cmpl   $0x5,(%ebx)
     a69:	77 6d                	ja     ad8 <nulterminate+0x88>
     a6b:	8b 03                	mov    (%ebx),%eax
     a6d:	3e ff 24 85 98 13 00 	notrack jmp *0x1398(,%eax,4)
     a74:	00 
     a75:	8d 76 00             	lea    0x0(%esi),%esi
    nulterminate(pcmd->right);
    break;

  case LIST:
    lcmd = (struct listcmd*)cmd;
    nulterminate(lcmd->left);
     a78:	83 ec 0c             	sub    $0xc,%esp
     a7b:	ff 73 04             	pushl  0x4(%ebx)
     a7e:	e8 cd ff ff ff       	call   a50 <nulterminate>
    nulterminate(lcmd->right);
     a83:	58                   	pop    %eax
     a84:	ff 73 08             	pushl  0x8(%ebx)
     a87:	e8 c4 ff ff ff       	call   a50 <nulterminate>
    break;
     a8c:	83 c4 10             	add    $0x10,%esp
     a8f:	89 d8                	mov    %ebx,%eax
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     a91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     a94:	c9                   	leave  
     a95:	c3                   	ret    
     a96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     a9d:	8d 76 00             	lea    0x0(%esi),%esi
    nulterminate(bcmd->cmd);
     aa0:	83 ec 0c             	sub    $0xc,%esp
     aa3:	ff 73 04             	pushl  0x4(%ebx)
     aa6:	e8 a5 ff ff ff       	call   a50 <nulterminate>
    break;
     aab:	89 d8                	mov    %ebx,%eax
     aad:	83 c4 10             	add    $0x10,%esp
}
     ab0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     ab3:	c9                   	leave  
     ab4:	c3                   	ret    
     ab5:	8d 76 00             	lea    0x0(%esi),%esi
    for(i=0; ecmd->argv[i]; i++)
     ab8:	8b 4b 04             	mov    0x4(%ebx),%ecx
     abb:	8d 43 08             	lea    0x8(%ebx),%eax
     abe:	85 c9                	test   %ecx,%ecx
     ac0:	74 16                	je     ad8 <nulterminate+0x88>
     ac2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      *ecmd->eargv[i] = 0;
     ac8:	8b 50 24             	mov    0x24(%eax),%edx
     acb:	83 c0 04             	add    $0x4,%eax
     ace:	c6 02 00             	movb   $0x0,(%edx)
    for(i=0; ecmd->argv[i]; i++)
     ad1:	8b 50 fc             	mov    -0x4(%eax),%edx
     ad4:	85 d2                	test   %edx,%edx
     ad6:	75 f0                	jne    ac8 <nulterminate+0x78>
  switch(cmd->type){
     ad8:	89 d8                	mov    %ebx,%eax
}
     ada:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     add:	c9                   	leave  
     ade:	c3                   	ret    
     adf:	90                   	nop
    nulterminate(rcmd->cmd);
     ae0:	83 ec 0c             	sub    $0xc,%esp
     ae3:	ff 73 04             	pushl  0x4(%ebx)
     ae6:	e8 65 ff ff ff       	call   a50 <nulterminate>
    *rcmd->efile = 0;
     aeb:	8b 43 0c             	mov    0xc(%ebx),%eax
    break;
     aee:	83 c4 10             	add    $0x10,%esp
    *rcmd->efile = 0;
     af1:	c6 00 00             	movb   $0x0,(%eax)
    break;
     af4:	89 d8                	mov    %ebx,%eax
}
     af6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     af9:	c9                   	leave  
     afa:	c3                   	ret    
     afb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     aff:	90                   	nop
    return 0;
     b00:	31 c0                	xor    %eax,%eax
     b02:	eb 8d                	jmp    a91 <nulterminate+0x41>
     b04:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     b0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     b0f:	90                   	nop

00000b10 <parsecmd>:
{
     b10:	f3 0f 1e fb          	endbr32 
     b14:	55                   	push   %ebp
     b15:	89 e5                	mov    %esp,%ebp
     b17:	56                   	push   %esi
     b18:	53                   	push   %ebx
  es = s + strlen(s);
     b19:	8b 5d 08             	mov    0x8(%ebp),%ebx
     b1c:	83 ec 0c             	sub    $0xc,%esp
     b1f:	53                   	push   %ebx
     b20:	e8 db 00 00 00       	call   c00 <strlen>
  cmd = parseline(&s, es);
     b25:	59                   	pop    %ecx
     b26:	5e                   	pop    %esi
  es = s + strlen(s);
     b27:	01 c3                	add    %eax,%ebx
  cmd = parseline(&s, es);
     b29:	8d 45 08             	lea    0x8(%ebp),%eax
     b2c:	53                   	push   %ebx
     b2d:	50                   	push   %eax
     b2e:	e8 dd fd ff ff       	call   910 <parseline>
  peek(&s, es, "");
     b33:	83 c4 0c             	add    $0xc,%esp
  cmd = parseline(&s, es);
     b36:	89 c6                	mov    %eax,%esi
  peek(&s, es, "");
     b38:	8d 45 08             	lea    0x8(%ebp),%eax
     b3b:	68 e1 12 00 00       	push   $0x12e1
     b40:	53                   	push   %ebx
     b41:	50                   	push   %eax
     b42:	e8 19 fb ff ff       	call   660 <peek>
  if(s != es){
     b47:	8b 45 08             	mov    0x8(%ebp),%eax
     b4a:	83 c4 10             	add    $0x10,%esp
     b4d:	39 d8                	cmp    %ebx,%eax
     b4f:	75 12                	jne    b63 <parsecmd+0x53>
  nulterminate(cmd);
     b51:	83 ec 0c             	sub    $0xc,%esp
     b54:	56                   	push   %esi
     b55:	e8 f6 fe ff ff       	call   a50 <nulterminate>
}
     b5a:	8d 65 f8             	lea    -0x8(%ebp),%esp
     b5d:	89 f0                	mov    %esi,%eax
     b5f:	5b                   	pop    %ebx
     b60:	5e                   	pop    %esi
     b61:	5d                   	pop    %ebp
     b62:	c3                   	ret    
    printf(2, "leftovers: %s\n", s);
     b63:	52                   	push   %edx
     b64:	50                   	push   %eax
     b65:	68 5a 13 00 00       	push   $0x135a
     b6a:	6a 02                	push   $0x2
     b6c:	e8 ef 03 00 00       	call   f60 <printf>
    panic("syntax");
     b71:	c7 04 24 1e 13 00 00 	movl   $0x131e,(%esp)
     b78:	e8 f3 f5 ff ff       	call   170 <panic>
     b7d:	66 90                	xchg   %ax,%ax
     b7f:	90                   	nop

00000b80 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
     b80:	f3 0f 1e fb          	endbr32 
     b84:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     b85:	31 c0                	xor    %eax,%eax
{
     b87:	89 e5                	mov    %esp,%ebp
     b89:	53                   	push   %ebx
     b8a:	8b 4d 08             	mov    0x8(%ebp),%ecx
     b8d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
     b90:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
     b94:	88 14 01             	mov    %dl,(%ecx,%eax,1)
     b97:	83 c0 01             	add    $0x1,%eax
     b9a:	84 d2                	test   %dl,%dl
     b9c:	75 f2                	jne    b90 <strcpy+0x10>
    ;
  return os;
}
     b9e:	89 c8                	mov    %ecx,%eax
     ba0:	5b                   	pop    %ebx
     ba1:	5d                   	pop    %ebp
     ba2:	c3                   	ret    
     ba3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000bb0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     bb0:	f3 0f 1e fb          	endbr32 
     bb4:	55                   	push   %ebp
     bb5:	89 e5                	mov    %esp,%ebp
     bb7:	53                   	push   %ebx
     bb8:	8b 4d 08             	mov    0x8(%ebp),%ecx
     bbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
     bbe:	0f b6 01             	movzbl (%ecx),%eax
     bc1:	0f b6 1a             	movzbl (%edx),%ebx
     bc4:	84 c0                	test   %al,%al
     bc6:	75 19                	jne    be1 <strcmp+0x31>
     bc8:	eb 26                	jmp    bf0 <strcmp+0x40>
     bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     bd0:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
     bd4:	83 c1 01             	add    $0x1,%ecx
     bd7:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
     bda:	0f b6 1a             	movzbl (%edx),%ebx
     bdd:	84 c0                	test   %al,%al
     bdf:	74 0f                	je     bf0 <strcmp+0x40>
     be1:	38 d8                	cmp    %bl,%al
     be3:	74 eb                	je     bd0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
     be5:	29 d8                	sub    %ebx,%eax
}
     be7:	5b                   	pop    %ebx
     be8:	5d                   	pop    %ebp
     be9:	c3                   	ret    
     bea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     bf0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
     bf2:	29 d8                	sub    %ebx,%eax
}
     bf4:	5b                   	pop    %ebx
     bf5:	5d                   	pop    %ebp
     bf6:	c3                   	ret    
     bf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     bfe:	66 90                	xchg   %ax,%ax

00000c00 <strlen>:

uint
strlen(const char *s)
{
     c00:	f3 0f 1e fb          	endbr32 
     c04:	55                   	push   %ebp
     c05:	89 e5                	mov    %esp,%ebp
     c07:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
     c0a:	80 3a 00             	cmpb   $0x0,(%edx)
     c0d:	74 21                	je     c30 <strlen+0x30>
     c0f:	31 c0                	xor    %eax,%eax
     c11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     c18:	83 c0 01             	add    $0x1,%eax
     c1b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
     c1f:	89 c1                	mov    %eax,%ecx
     c21:	75 f5                	jne    c18 <strlen+0x18>
    ;
  return n;
}
     c23:	89 c8                	mov    %ecx,%eax
     c25:	5d                   	pop    %ebp
     c26:	c3                   	ret    
     c27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     c2e:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
     c30:	31 c9                	xor    %ecx,%ecx
}
     c32:	5d                   	pop    %ebp
     c33:	89 c8                	mov    %ecx,%eax
     c35:	c3                   	ret    
     c36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     c3d:	8d 76 00             	lea    0x0(%esi),%esi

00000c40 <memset>:

void*
memset(void *dst, int c, uint n)
{
     c40:	f3 0f 1e fb          	endbr32 
     c44:	55                   	push   %ebp
     c45:	89 e5                	mov    %esp,%ebp
     c47:	57                   	push   %edi
     c48:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
     c4b:	8b 4d 10             	mov    0x10(%ebp),%ecx
     c4e:	8b 45 0c             	mov    0xc(%ebp),%eax
     c51:	89 d7                	mov    %edx,%edi
     c53:	fc                   	cld    
     c54:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
     c56:	89 d0                	mov    %edx,%eax
     c58:	5f                   	pop    %edi
     c59:	5d                   	pop    %ebp
     c5a:	c3                   	ret    
     c5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     c5f:	90                   	nop

00000c60 <strchr>:

char*
strchr(const char *s, char c)
{
     c60:	f3 0f 1e fb          	endbr32 
     c64:	55                   	push   %ebp
     c65:	89 e5                	mov    %esp,%ebp
     c67:	8b 45 08             	mov    0x8(%ebp),%eax
     c6a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
     c6e:	0f b6 10             	movzbl (%eax),%edx
     c71:	84 d2                	test   %dl,%dl
     c73:	75 16                	jne    c8b <strchr+0x2b>
     c75:	eb 21                	jmp    c98 <strchr+0x38>
     c77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     c7e:	66 90                	xchg   %ax,%ax
     c80:	0f b6 50 01          	movzbl 0x1(%eax),%edx
     c84:	83 c0 01             	add    $0x1,%eax
     c87:	84 d2                	test   %dl,%dl
     c89:	74 0d                	je     c98 <strchr+0x38>
    if(*s == c)
     c8b:	38 d1                	cmp    %dl,%cl
     c8d:	75 f1                	jne    c80 <strchr+0x20>
      return (char*)s;
  return 0;
}
     c8f:	5d                   	pop    %ebp
     c90:	c3                   	ret    
     c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
     c98:	31 c0                	xor    %eax,%eax
}
     c9a:	5d                   	pop    %ebp
     c9b:	c3                   	ret    
     c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000ca0 <gets>:

char*
gets(char *buf, int max)
{
     ca0:	f3 0f 1e fb          	endbr32 
     ca4:	55                   	push   %ebp
     ca5:	89 e5                	mov    %esp,%ebp
     ca7:	57                   	push   %edi
     ca8:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     ca9:	31 f6                	xor    %esi,%esi
{
     cab:	53                   	push   %ebx
     cac:	89 f3                	mov    %esi,%ebx
     cae:	83 ec 1c             	sub    $0x1c,%esp
     cb1:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
     cb4:	eb 33                	jmp    ce9 <gets+0x49>
     cb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     cbd:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
     cc0:	83 ec 04             	sub    $0x4,%esp
     cc3:	8d 45 e7             	lea    -0x19(%ebp),%eax
     cc6:	6a 01                	push   $0x1
     cc8:	50                   	push   %eax
     cc9:	6a 00                	push   $0x0
     ccb:	e8 2b 01 00 00       	call   dfb <read>
    if(cc < 1)
     cd0:	83 c4 10             	add    $0x10,%esp
     cd3:	85 c0                	test   %eax,%eax
     cd5:	7e 1c                	jle    cf3 <gets+0x53>
      break;
    buf[i++] = c;
     cd7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
     cdb:	83 c7 01             	add    $0x1,%edi
     cde:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
     ce1:	3c 0a                	cmp    $0xa,%al
     ce3:	74 23                	je     d08 <gets+0x68>
     ce5:	3c 0d                	cmp    $0xd,%al
     ce7:	74 1f                	je     d08 <gets+0x68>
  for(i=0; i+1 < max; ){
     ce9:	83 c3 01             	add    $0x1,%ebx
     cec:	89 fe                	mov    %edi,%esi
     cee:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
     cf1:	7c cd                	jl     cc0 <gets+0x20>
     cf3:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
     cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
     cf8:	c6 03 00             	movb   $0x0,(%ebx)
}
     cfb:	8d 65 f4             	lea    -0xc(%ebp),%esp
     cfe:	5b                   	pop    %ebx
     cff:	5e                   	pop    %esi
     d00:	5f                   	pop    %edi
     d01:	5d                   	pop    %ebp
     d02:	c3                   	ret    
     d03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     d07:	90                   	nop
     d08:	8b 75 08             	mov    0x8(%ebp),%esi
     d0b:	8b 45 08             	mov    0x8(%ebp),%eax
     d0e:	01 de                	add    %ebx,%esi
     d10:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
     d12:	c6 03 00             	movb   $0x0,(%ebx)
}
     d15:	8d 65 f4             	lea    -0xc(%ebp),%esp
     d18:	5b                   	pop    %ebx
     d19:	5e                   	pop    %esi
     d1a:	5f                   	pop    %edi
     d1b:	5d                   	pop    %ebp
     d1c:	c3                   	ret    
     d1d:	8d 76 00             	lea    0x0(%esi),%esi

00000d20 <stat>:

int
stat(const char *n, struct stat *st)
{
     d20:	f3 0f 1e fb          	endbr32 
     d24:	55                   	push   %ebp
     d25:	89 e5                	mov    %esp,%ebp
     d27:	56                   	push   %esi
     d28:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     d29:	83 ec 08             	sub    $0x8,%esp
     d2c:	6a 00                	push   $0x0
     d2e:	ff 75 08             	pushl  0x8(%ebp)
     d31:	e8 ed 00 00 00       	call   e23 <open>
  if(fd < 0)
     d36:	83 c4 10             	add    $0x10,%esp
     d39:	85 c0                	test   %eax,%eax
     d3b:	78 2b                	js     d68 <stat+0x48>
    return -1;
  r = fstat(fd, st);
     d3d:	83 ec 08             	sub    $0x8,%esp
     d40:	ff 75 0c             	pushl  0xc(%ebp)
     d43:	89 c3                	mov    %eax,%ebx
     d45:	50                   	push   %eax
     d46:	e8 f0 00 00 00       	call   e3b <fstat>
  close(fd);
     d4b:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
     d4e:	89 c6                	mov    %eax,%esi
  close(fd);
     d50:	e8 b6 00 00 00       	call   e0b <close>
  return r;
     d55:	83 c4 10             	add    $0x10,%esp
}
     d58:	8d 65 f8             	lea    -0x8(%ebp),%esp
     d5b:	89 f0                	mov    %esi,%eax
     d5d:	5b                   	pop    %ebx
     d5e:	5e                   	pop    %esi
     d5f:	5d                   	pop    %ebp
     d60:	c3                   	ret    
     d61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
     d68:	be ff ff ff ff       	mov    $0xffffffff,%esi
     d6d:	eb e9                	jmp    d58 <stat+0x38>
     d6f:	90                   	nop

00000d70 <atoi>:

int
atoi(const char *s)
{
     d70:	f3 0f 1e fb          	endbr32 
     d74:	55                   	push   %ebp
     d75:	89 e5                	mov    %esp,%ebp
     d77:	53                   	push   %ebx
     d78:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     d7b:	0f be 02             	movsbl (%edx),%eax
     d7e:	8d 48 d0             	lea    -0x30(%eax),%ecx
     d81:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
     d84:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
     d89:	77 1a                	ja     da5 <atoi+0x35>
     d8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     d8f:	90                   	nop
    n = n*10 + *s++ - '0';
     d90:	83 c2 01             	add    $0x1,%edx
     d93:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
     d96:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
     d9a:	0f be 02             	movsbl (%edx),%eax
     d9d:	8d 58 d0             	lea    -0x30(%eax),%ebx
     da0:	80 fb 09             	cmp    $0x9,%bl
     da3:	76 eb                	jbe    d90 <atoi+0x20>
  return n;
}
     da5:	89 c8                	mov    %ecx,%eax
     da7:	5b                   	pop    %ebx
     da8:	5d                   	pop    %ebp
     da9:	c3                   	ret    
     daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000db0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     db0:	f3 0f 1e fb          	endbr32 
     db4:	55                   	push   %ebp
     db5:	89 e5                	mov    %esp,%ebp
     db7:	57                   	push   %edi
     db8:	8b 45 10             	mov    0x10(%ebp),%eax
     dbb:	8b 55 08             	mov    0x8(%ebp),%edx
     dbe:	56                   	push   %esi
     dbf:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     dc2:	85 c0                	test   %eax,%eax
     dc4:	7e 0f                	jle    dd5 <memmove+0x25>
     dc6:	01 d0                	add    %edx,%eax
  dst = vdst;
     dc8:	89 d7                	mov    %edx,%edi
     dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
     dd0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
     dd1:	39 f8                	cmp    %edi,%eax
     dd3:	75 fb                	jne    dd0 <memmove+0x20>
  return vdst;
}
     dd5:	5e                   	pop    %esi
     dd6:	89 d0                	mov    %edx,%eax
     dd8:	5f                   	pop    %edi
     dd9:	5d                   	pop    %ebp
     dda:	c3                   	ret    

00000ddb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     ddb:	b8 01 00 00 00       	mov    $0x1,%eax
     de0:	cd 40                	int    $0x40
     de2:	c3                   	ret    

00000de3 <exit>:
SYSCALL(exit)
     de3:	b8 02 00 00 00       	mov    $0x2,%eax
     de8:	cd 40                	int    $0x40
     dea:	c3                   	ret    

00000deb <wait>:
SYSCALL(wait)
     deb:	b8 03 00 00 00       	mov    $0x3,%eax
     df0:	cd 40                	int    $0x40
     df2:	c3                   	ret    

00000df3 <pipe>:
SYSCALL(pipe)
     df3:	b8 04 00 00 00       	mov    $0x4,%eax
     df8:	cd 40                	int    $0x40
     dfa:	c3                   	ret    

00000dfb <read>:
SYSCALL(read)
     dfb:	b8 05 00 00 00       	mov    $0x5,%eax
     e00:	cd 40                	int    $0x40
     e02:	c3                   	ret    

00000e03 <write>:
SYSCALL(write)
     e03:	b8 10 00 00 00       	mov    $0x10,%eax
     e08:	cd 40                	int    $0x40
     e0a:	c3                   	ret    

00000e0b <close>:
SYSCALL(close)
     e0b:	b8 15 00 00 00       	mov    $0x15,%eax
     e10:	cd 40                	int    $0x40
     e12:	c3                   	ret    

00000e13 <kill>:
SYSCALL(kill)
     e13:	b8 06 00 00 00       	mov    $0x6,%eax
     e18:	cd 40                	int    $0x40
     e1a:	c3                   	ret    

00000e1b <exec>:
SYSCALL(exec)
     e1b:	b8 07 00 00 00       	mov    $0x7,%eax
     e20:	cd 40                	int    $0x40
     e22:	c3                   	ret    

00000e23 <open>:
SYSCALL(open)
     e23:	b8 0f 00 00 00       	mov    $0xf,%eax
     e28:	cd 40                	int    $0x40
     e2a:	c3                   	ret    

00000e2b <mknod>:
SYSCALL(mknod)
     e2b:	b8 11 00 00 00       	mov    $0x11,%eax
     e30:	cd 40                	int    $0x40
     e32:	c3                   	ret    

00000e33 <unlink>:
SYSCALL(unlink)
     e33:	b8 12 00 00 00       	mov    $0x12,%eax
     e38:	cd 40                	int    $0x40
     e3a:	c3                   	ret    

00000e3b <fstat>:
SYSCALL(fstat)
     e3b:	b8 08 00 00 00       	mov    $0x8,%eax
     e40:	cd 40                	int    $0x40
     e42:	c3                   	ret    

00000e43 <link>:
SYSCALL(link)
     e43:	b8 13 00 00 00       	mov    $0x13,%eax
     e48:	cd 40                	int    $0x40
     e4a:	c3                   	ret    

00000e4b <mkdir>:
SYSCALL(mkdir)
     e4b:	b8 14 00 00 00       	mov    $0x14,%eax
     e50:	cd 40                	int    $0x40
     e52:	c3                   	ret    

00000e53 <chdir>:
SYSCALL(chdir)
     e53:	b8 09 00 00 00       	mov    $0x9,%eax
     e58:	cd 40                	int    $0x40
     e5a:	c3                   	ret    

00000e5b <dup>:
SYSCALL(dup)
     e5b:	b8 0a 00 00 00       	mov    $0xa,%eax
     e60:	cd 40                	int    $0x40
     e62:	c3                   	ret    

00000e63 <getpid>:
SYSCALL(getpid)
     e63:	b8 0b 00 00 00       	mov    $0xb,%eax
     e68:	cd 40                	int    $0x40
     e6a:	c3                   	ret    

00000e6b <sbrk>:
SYSCALL(sbrk)
     e6b:	b8 0c 00 00 00       	mov    $0xc,%eax
     e70:	cd 40                	int    $0x40
     e72:	c3                   	ret    

00000e73 <sleep>:
SYSCALL(sleep)
     e73:	b8 0d 00 00 00       	mov    $0xd,%eax
     e78:	cd 40                	int    $0x40
     e7a:	c3                   	ret    

00000e7b <uptime>:
SYSCALL(uptime)
     e7b:	b8 0e 00 00 00       	mov    $0xe,%eax
     e80:	cd 40                	int    $0x40
     e82:	c3                   	ret    

00000e83 <memsize>:
SYSCALL(memsize)
     e83:	b8 16 00 00 00       	mov    $0x16,%eax
     e88:	cd 40                	int    $0x40
     e8a:	c3                   	ret    

00000e8b <set_ps_priority>:
SYSCALL(set_ps_priority)
     e8b:	b8 17 00 00 00       	mov    $0x17,%eax
     e90:	cd 40                	int    $0x40
     e92:	c3                   	ret    

00000e93 <policy>:
SYSCALL(policy)
     e93:	b8 18 00 00 00       	mov    $0x18,%eax
     e98:	cd 40                	int    $0x40
     e9a:	c3                   	ret    

00000e9b <set_cfs_priority>:
SYSCALL(set_cfs_priority)
     e9b:	b8 19 00 00 00       	mov    $0x19,%eax
     ea0:	cd 40                	int    $0x40
     ea2:	c3                   	ret    

00000ea3 <proc_info>:
SYSCALL(proc_info)
     ea3:	b8 1a 00 00 00       	mov    $0x1a,%eax
     ea8:	cd 40                	int    $0x40
     eaa:	c3                   	ret    
     eab:	66 90                	xchg   %ax,%ax
     ead:	66 90                	xchg   %ax,%ax
     eaf:	90                   	nop

00000eb0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
     eb0:	55                   	push   %ebp
     eb1:	89 e5                	mov    %esp,%ebp
     eb3:	57                   	push   %edi
     eb4:	56                   	push   %esi
     eb5:	53                   	push   %ebx
     eb6:	83 ec 3c             	sub    $0x3c,%esp
     eb9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
     ebc:	89 d1                	mov    %edx,%ecx
{
     ebe:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
     ec1:	85 d2                	test   %edx,%edx
     ec3:	0f 89 7f 00 00 00    	jns    f48 <printint+0x98>
     ec9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
     ecd:	74 79                	je     f48 <printint+0x98>
    neg = 1;
     ecf:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
     ed6:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
     ed8:	31 db                	xor    %ebx,%ebx
     eda:	8d 75 d7             	lea    -0x29(%ebp),%esi
     edd:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
     ee0:	89 c8                	mov    %ecx,%eax
     ee2:	31 d2                	xor    %edx,%edx
     ee4:	89 cf                	mov    %ecx,%edi
     ee6:	f7 75 c4             	divl   -0x3c(%ebp)
     ee9:	0f b6 92 b8 13 00 00 	movzbl 0x13b8(%edx),%edx
     ef0:	89 45 c0             	mov    %eax,-0x40(%ebp)
     ef3:	89 d8                	mov    %ebx,%eax
     ef5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
     ef8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
     efb:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
     efe:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
     f01:	76 dd                	jbe    ee0 <printint+0x30>
  if(neg)
     f03:	8b 4d bc             	mov    -0x44(%ebp),%ecx
     f06:	85 c9                	test   %ecx,%ecx
     f08:	74 0c                	je     f16 <printint+0x66>
    buf[i++] = '-';
     f0a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
     f0f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
     f11:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
     f16:	8b 7d b8             	mov    -0x48(%ebp),%edi
     f19:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
     f1d:	eb 07                	jmp    f26 <printint+0x76>
     f1f:	90                   	nop
     f20:	0f b6 13             	movzbl (%ebx),%edx
     f23:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
     f26:	83 ec 04             	sub    $0x4,%esp
     f29:	88 55 d7             	mov    %dl,-0x29(%ebp)
     f2c:	6a 01                	push   $0x1
     f2e:	56                   	push   %esi
     f2f:	57                   	push   %edi
     f30:	e8 ce fe ff ff       	call   e03 <write>
  while(--i >= 0)
     f35:	83 c4 10             	add    $0x10,%esp
     f38:	39 de                	cmp    %ebx,%esi
     f3a:	75 e4                	jne    f20 <printint+0x70>
    putc(fd, buf[i]);
}
     f3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
     f3f:	5b                   	pop    %ebx
     f40:	5e                   	pop    %esi
     f41:	5f                   	pop    %edi
     f42:	5d                   	pop    %ebp
     f43:	c3                   	ret    
     f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
     f48:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
     f4f:	eb 87                	jmp    ed8 <printint+0x28>
     f51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     f58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     f5f:	90                   	nop

00000f60 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
     f60:	f3 0f 1e fb          	endbr32 
     f64:	55                   	push   %ebp
     f65:	89 e5                	mov    %esp,%ebp
     f67:	57                   	push   %edi
     f68:	56                   	push   %esi
     f69:	53                   	push   %ebx
     f6a:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     f6d:	8b 75 0c             	mov    0xc(%ebp),%esi
     f70:	0f b6 1e             	movzbl (%esi),%ebx
     f73:	84 db                	test   %bl,%bl
     f75:	0f 84 b4 00 00 00    	je     102f <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
     f7b:	8d 45 10             	lea    0x10(%ebp),%eax
     f7e:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
     f81:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
     f84:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
     f86:	89 45 d0             	mov    %eax,-0x30(%ebp)
     f89:	eb 33                	jmp    fbe <printf+0x5e>
     f8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     f8f:	90                   	nop
     f90:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
     f93:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
     f98:	83 f8 25             	cmp    $0x25,%eax
     f9b:	74 17                	je     fb4 <printf+0x54>
  write(fd, &c, 1);
     f9d:	83 ec 04             	sub    $0x4,%esp
     fa0:	88 5d e7             	mov    %bl,-0x19(%ebp)
     fa3:	6a 01                	push   $0x1
     fa5:	57                   	push   %edi
     fa6:	ff 75 08             	pushl  0x8(%ebp)
     fa9:	e8 55 fe ff ff       	call   e03 <write>
     fae:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
     fb1:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
     fb4:	0f b6 1e             	movzbl (%esi),%ebx
     fb7:	83 c6 01             	add    $0x1,%esi
     fba:	84 db                	test   %bl,%bl
     fbc:	74 71                	je     102f <printf+0xcf>
    c = fmt[i] & 0xff;
     fbe:	0f be cb             	movsbl %bl,%ecx
     fc1:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
     fc4:	85 d2                	test   %edx,%edx
     fc6:	74 c8                	je     f90 <printf+0x30>
      }
    } else if(state == '%'){
     fc8:	83 fa 25             	cmp    $0x25,%edx
     fcb:	75 e7                	jne    fb4 <printf+0x54>
      if(c == 'd'){
     fcd:	83 f8 64             	cmp    $0x64,%eax
     fd0:	0f 84 9a 00 00 00    	je     1070 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
     fd6:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
     fdc:	83 f9 70             	cmp    $0x70,%ecx
     fdf:	74 5f                	je     1040 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
     fe1:	83 f8 73             	cmp    $0x73,%eax
     fe4:	0f 84 d6 00 00 00    	je     10c0 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     fea:	83 f8 63             	cmp    $0x63,%eax
     fed:	0f 84 8d 00 00 00    	je     1080 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
     ff3:	83 f8 25             	cmp    $0x25,%eax
     ff6:	0f 84 b4 00 00 00    	je     10b0 <printf+0x150>
  write(fd, &c, 1);
     ffc:	83 ec 04             	sub    $0x4,%esp
     fff:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    1003:	6a 01                	push   $0x1
    1005:	57                   	push   %edi
    1006:	ff 75 08             	pushl  0x8(%ebp)
    1009:	e8 f5 fd ff ff       	call   e03 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
    100e:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
    1011:	83 c4 0c             	add    $0xc,%esp
    1014:	6a 01                	push   $0x1
    1016:	83 c6 01             	add    $0x1,%esi
    1019:	57                   	push   %edi
    101a:	ff 75 08             	pushl  0x8(%ebp)
    101d:	e8 e1 fd ff ff       	call   e03 <write>
  for(i = 0; fmt[i]; i++){
    1022:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
    1026:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    1029:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
    102b:	84 db                	test   %bl,%bl
    102d:	75 8f                	jne    fbe <printf+0x5e>
    }
  }
}
    102f:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1032:	5b                   	pop    %ebx
    1033:	5e                   	pop    %esi
    1034:	5f                   	pop    %edi
    1035:	5d                   	pop    %ebp
    1036:	c3                   	ret    
    1037:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    103e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
    1040:	83 ec 0c             	sub    $0xc,%esp
    1043:	b9 10 00 00 00       	mov    $0x10,%ecx
    1048:	6a 00                	push   $0x0
    104a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
    104d:	8b 45 08             	mov    0x8(%ebp),%eax
    1050:	8b 13                	mov    (%ebx),%edx
    1052:	e8 59 fe ff ff       	call   eb0 <printint>
        ap++;
    1057:	89 d8                	mov    %ebx,%eax
    1059:	83 c4 10             	add    $0x10,%esp
      state = 0;
    105c:	31 d2                	xor    %edx,%edx
        ap++;
    105e:	83 c0 04             	add    $0x4,%eax
    1061:	89 45 d0             	mov    %eax,-0x30(%ebp)
    1064:	e9 4b ff ff ff       	jmp    fb4 <printf+0x54>
    1069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
    1070:	83 ec 0c             	sub    $0xc,%esp
    1073:	b9 0a 00 00 00       	mov    $0xa,%ecx
    1078:	6a 01                	push   $0x1
    107a:	eb ce                	jmp    104a <printf+0xea>
    107c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
    1080:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
    1083:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
    1086:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
    1088:	6a 01                	push   $0x1
        ap++;
    108a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
    108d:	57                   	push   %edi
    108e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
    1091:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    1094:	e8 6a fd ff ff       	call   e03 <write>
        ap++;
    1099:	89 5d d0             	mov    %ebx,-0x30(%ebp)
    109c:	83 c4 10             	add    $0x10,%esp
      state = 0;
    109f:	31 d2                	xor    %edx,%edx
    10a1:	e9 0e ff ff ff       	jmp    fb4 <printf+0x54>
    10a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    10ad:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
    10b0:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
    10b3:	83 ec 04             	sub    $0x4,%esp
    10b6:	e9 59 ff ff ff       	jmp    1014 <printf+0xb4>
    10bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    10bf:	90                   	nop
        s = (char*)*ap;
    10c0:	8b 45 d0             	mov    -0x30(%ebp),%eax
    10c3:	8b 18                	mov    (%eax),%ebx
        ap++;
    10c5:	83 c0 04             	add    $0x4,%eax
    10c8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
    10cb:	85 db                	test   %ebx,%ebx
    10cd:	74 17                	je     10e6 <printf+0x186>
        while(*s != 0){
    10cf:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
    10d2:	31 d2                	xor    %edx,%edx
        while(*s != 0){
    10d4:	84 c0                	test   %al,%al
    10d6:	0f 84 d8 fe ff ff    	je     fb4 <printf+0x54>
    10dc:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    10df:	89 de                	mov    %ebx,%esi
    10e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
    10e4:	eb 1a                	jmp    1100 <printf+0x1a0>
          s = "(null)";
    10e6:	bb b0 13 00 00       	mov    $0x13b0,%ebx
        while(*s != 0){
    10eb:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    10ee:	b8 28 00 00 00       	mov    $0x28,%eax
    10f3:	89 de                	mov    %ebx,%esi
    10f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
    10f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    10ff:	90                   	nop
  write(fd, &c, 1);
    1100:	83 ec 04             	sub    $0x4,%esp
          s++;
    1103:	83 c6 01             	add    $0x1,%esi
    1106:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    1109:	6a 01                	push   $0x1
    110b:	57                   	push   %edi
    110c:	53                   	push   %ebx
    110d:	e8 f1 fc ff ff       	call   e03 <write>
        while(*s != 0){
    1112:	0f b6 06             	movzbl (%esi),%eax
    1115:	83 c4 10             	add    $0x10,%esp
    1118:	84 c0                	test   %al,%al
    111a:	75 e4                	jne    1100 <printf+0x1a0>
    111c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
    111f:	31 d2                	xor    %edx,%edx
    1121:	e9 8e fe ff ff       	jmp    fb4 <printf+0x54>
    1126:	66 90                	xchg   %ax,%ax
    1128:	66 90                	xchg   %ax,%ax
    112a:	66 90                	xchg   %ax,%ax
    112c:	66 90                	xchg   %ax,%ax
    112e:	66 90                	xchg   %ax,%ax

00001130 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1130:	f3 0f 1e fb          	endbr32 
    1134:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1135:	a1 04 1a 00 00       	mov    0x1a04,%eax
{
    113a:	89 e5                	mov    %esp,%ebp
    113c:	57                   	push   %edi
    113d:	56                   	push   %esi
    113e:	53                   	push   %ebx
    113f:	8b 5d 08             	mov    0x8(%ebp),%ebx
    1142:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
    1144:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1147:	39 c8                	cmp    %ecx,%eax
    1149:	73 15                	jae    1160 <free+0x30>
    114b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    114f:	90                   	nop
    1150:	39 d1                	cmp    %edx,%ecx
    1152:	72 14                	jb     1168 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1154:	39 d0                	cmp    %edx,%eax
    1156:	73 10                	jae    1168 <free+0x38>
{
    1158:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    115a:	8b 10                	mov    (%eax),%edx
    115c:	39 c8                	cmp    %ecx,%eax
    115e:	72 f0                	jb     1150 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1160:	39 d0                	cmp    %edx,%eax
    1162:	72 f4                	jb     1158 <free+0x28>
    1164:	39 d1                	cmp    %edx,%ecx
    1166:	73 f0                	jae    1158 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1168:	8b 73 fc             	mov    -0x4(%ebx),%esi
    116b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    116e:	39 fa                	cmp    %edi,%edx
    1170:	74 1e                	je     1190 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    1172:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    1175:	8b 50 04             	mov    0x4(%eax),%edx
    1178:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    117b:	39 f1                	cmp    %esi,%ecx
    117d:	74 28                	je     11a7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    117f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
    1181:	5b                   	pop    %ebx
  freep = p;
    1182:	a3 04 1a 00 00       	mov    %eax,0x1a04
}
    1187:	5e                   	pop    %esi
    1188:	5f                   	pop    %edi
    1189:	5d                   	pop    %ebp
    118a:	c3                   	ret    
    118b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    118f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
    1190:	03 72 04             	add    0x4(%edx),%esi
    1193:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    1196:	8b 10                	mov    (%eax),%edx
    1198:	8b 12                	mov    (%edx),%edx
    119a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    119d:	8b 50 04             	mov    0x4(%eax),%edx
    11a0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    11a3:	39 f1                	cmp    %esi,%ecx
    11a5:	75 d8                	jne    117f <free+0x4f>
    p->s.size += bp->s.size;
    11a7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
    11aa:	a3 04 1a 00 00       	mov    %eax,0x1a04
    p->s.size += bp->s.size;
    11af:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    11b2:	8b 53 f8             	mov    -0x8(%ebx),%edx
    11b5:	89 10                	mov    %edx,(%eax)
}
    11b7:	5b                   	pop    %ebx
    11b8:	5e                   	pop    %esi
    11b9:	5f                   	pop    %edi
    11ba:	5d                   	pop    %ebp
    11bb:	c3                   	ret    
    11bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000011c0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    11c0:	f3 0f 1e fb          	endbr32 
    11c4:	55                   	push   %ebp
    11c5:	89 e5                	mov    %esp,%ebp
    11c7:	57                   	push   %edi
    11c8:	56                   	push   %esi
    11c9:	53                   	push   %ebx
    11ca:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    11cd:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    11d0:	8b 3d 04 1a 00 00    	mov    0x1a04,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    11d6:	8d 70 07             	lea    0x7(%eax),%esi
    11d9:	c1 ee 03             	shr    $0x3,%esi
    11dc:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
    11df:	85 ff                	test   %edi,%edi
    11e1:	0f 84 a9 00 00 00    	je     1290 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    11e7:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
    11e9:	8b 48 04             	mov    0x4(%eax),%ecx
    11ec:	39 f1                	cmp    %esi,%ecx
    11ee:	73 6d                	jae    125d <malloc+0x9d>
    11f0:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
    11f6:	bb 00 10 00 00       	mov    $0x1000,%ebx
    11fb:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
    11fe:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
    1205:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    1208:	eb 17                	jmp    1221 <malloc+0x61>
    120a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1210:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
    1212:	8b 4a 04             	mov    0x4(%edx),%ecx
    1215:	39 f1                	cmp    %esi,%ecx
    1217:	73 4f                	jae    1268 <malloc+0xa8>
    1219:	8b 3d 04 1a 00 00    	mov    0x1a04,%edi
    121f:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1221:	39 c7                	cmp    %eax,%edi
    1223:	75 eb                	jne    1210 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
    1225:	83 ec 0c             	sub    $0xc,%esp
    1228:	ff 75 e4             	pushl  -0x1c(%ebp)
    122b:	e8 3b fc ff ff       	call   e6b <sbrk>
  if(p == (char*)-1)
    1230:	83 c4 10             	add    $0x10,%esp
    1233:	83 f8 ff             	cmp    $0xffffffff,%eax
    1236:	74 1b                	je     1253 <malloc+0x93>
  hp->s.size = nu;
    1238:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    123b:	83 ec 0c             	sub    $0xc,%esp
    123e:	83 c0 08             	add    $0x8,%eax
    1241:	50                   	push   %eax
    1242:	e8 e9 fe ff ff       	call   1130 <free>
  return freep;
    1247:	a1 04 1a 00 00       	mov    0x1a04,%eax
      if((p = morecore(nunits)) == 0)
    124c:	83 c4 10             	add    $0x10,%esp
    124f:	85 c0                	test   %eax,%eax
    1251:	75 bd                	jne    1210 <malloc+0x50>
        return 0;
  }
}
    1253:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
    1256:	31 c0                	xor    %eax,%eax
}
    1258:	5b                   	pop    %ebx
    1259:	5e                   	pop    %esi
    125a:	5f                   	pop    %edi
    125b:	5d                   	pop    %ebp
    125c:	c3                   	ret    
    if(p->s.size >= nunits){
    125d:	89 c2                	mov    %eax,%edx
    125f:	89 f8                	mov    %edi,%eax
    1261:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
    1268:	39 ce                	cmp    %ecx,%esi
    126a:	74 54                	je     12c0 <malloc+0x100>
        p->s.size -= nunits;
    126c:	29 f1                	sub    %esi,%ecx
    126e:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
    1271:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
    1274:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
    1277:	a3 04 1a 00 00       	mov    %eax,0x1a04
}
    127c:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
    127f:	8d 42 08             	lea    0x8(%edx),%eax
}
    1282:	5b                   	pop    %ebx
    1283:	5e                   	pop    %esi
    1284:	5f                   	pop    %edi
    1285:	5d                   	pop    %ebp
    1286:	c3                   	ret    
    1287:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    128e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
    1290:	c7 05 04 1a 00 00 08 	movl   $0x1a08,0x1a04
    1297:	1a 00 00 
    base.s.size = 0;
    129a:	bf 08 1a 00 00       	mov    $0x1a08,%edi
    base.s.ptr = freep = prevp = &base;
    129f:	c7 05 08 1a 00 00 08 	movl   $0x1a08,0x1a08
    12a6:	1a 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    12a9:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
    12ab:	c7 05 0c 1a 00 00 00 	movl   $0x0,0x1a0c
    12b2:	00 00 00 
    if(p->s.size >= nunits){
    12b5:	e9 36 ff ff ff       	jmp    11f0 <malloc+0x30>
    12ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
    12c0:	8b 0a                	mov    (%edx),%ecx
    12c2:	89 08                	mov    %ecx,(%eax)
    12c4:	eb b1                	jmp    1277 <malloc+0xb7>
