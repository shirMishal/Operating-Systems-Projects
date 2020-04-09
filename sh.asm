
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
      2e:	68 59 13 00 00       	push   $0x1359
      33:	e8 db 0d 00 00       	call   e13 <open>
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
      58:	e8 6e 0d 00 00       	call   dcb <fork>
  if(pid == -1)
      5d:	83 f8 ff             	cmp    $0xffffffff,%eax
      60:	0f 84 aa 00 00 00    	je     110 <main+0x110>
    if(fork1() == 0)
      66:	85 c0                	test   %eax,%eax
      68:	0f 84 8d 00 00 00    	je     fb <main+0xfb>
    wait(null);
      6e:	83 ec 0c             	sub    $0xc,%esp
      71:	6a 00                	push   $0x0
      73:	e8 63 0d 00 00       	call   ddb <wait>
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
      aa:	e8 24 0d 00 00       	call   dd3 <exit>
      buf[strlen(buf)-1] = 0;  // chop \n
      af:	83 ec 0c             	sub    $0xc,%esp
      b2:	68 a0 19 00 00       	push   $0x19a0
      b7:	e8 34 0b 00 00       	call   bf0 <strlen>
      if(chdir(buf+3) < 0)
      bc:	c7 04 24 a3 19 00 00 	movl   $0x19a3,(%esp)
      buf[strlen(buf)-1] = 0;  // chop \n
      c3:	c6 80 9f 19 00 00 00 	movb   $0x0,0x199f(%eax)
      if(chdir(buf+3) < 0)
      ca:	e8 74 0d 00 00       	call   e43 <chdir>
      cf:	83 c4 10             	add    $0x10,%esp
      d2:	85 c0                	test   %eax,%eax
      d4:	79 a5                	jns    7b <main+0x7b>
        printf(2, "cannot cd %s\n", buf+3);
      d6:	50                   	push   %eax
      d7:	68 a3 19 00 00       	push   $0x19a3
      dc:	68 61 13 00 00       	push   $0x1361
      e1:	6a 02                	push   $0x2
      e3:	e8 68 0e 00 00       	call   f50 <printf>
      e8:	83 c4 10             	add    $0x10,%esp
      eb:	eb 8e                	jmp    7b <main+0x7b>
      close(fd);
      ed:	83 ec 0c             	sub    $0xc,%esp
      f0:	50                   	push   %eax
      f1:	e8 05 0d 00 00       	call   dfb <close>
      break;
      f6:	83 c4 10             	add    $0x10,%esp
      f9:	eb 80                	jmp    7b <main+0x7b>
      runcmd(parsecmd(buf));
      fb:	83 ec 0c             	sub    $0xc,%esp
      fe:	68 a0 19 00 00       	push   $0x19a0
     103:	e8 f8 09 00 00       	call   b00 <parsecmd>
     108:	89 04 24             	mov    %eax,(%esp)
     10b:	e8 90 00 00 00       	call   1a0 <runcmd>
    panic("fork");
     110:	83 ec 0c             	sub    $0xc,%esp
     113:	68 e2 12 00 00       	push   $0x12e2
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
     132:	68 b8 12 00 00       	push   $0x12b8
     137:	6a 02                	push   $0x2
     139:	e8 12 0e 00 00       	call   f50 <printf>
  memset(buf, 0, nbuf);
     13e:	83 c4 0c             	add    $0xc,%esp
     141:	56                   	push   %esi
     142:	6a 00                	push   $0x0
     144:	53                   	push   %ebx
     145:	e8 e6 0a 00 00       	call   c30 <memset>
  gets(buf, nbuf);
     14a:	58                   	pop    %eax
     14b:	5a                   	pop    %edx
     14c:	56                   	push   %esi
     14d:	53                   	push   %ebx
     14e:	e8 3d 0b 00 00       	call   c90 <gets>
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
     17d:	68 55 13 00 00       	push   $0x1355
     182:	6a 02                	push   $0x2
     184:	e8 c7 0d 00 00       	call   f50 <printf>
  exit(0);
     189:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     190:	e8 3e 0c 00 00       	call   dd3 <exit>
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
     1b0:	0f 84 8a 00 00 00    	je     240 <runcmd+0xa0>
  switch(cmd->type){
     1b6:	83 3b 05             	cmpl   $0x5,(%ebx)
     1b9:	0f 87 18 01 00 00    	ja     2d7 <runcmd+0x137>
     1bf:	8b 03                	mov    (%ebx),%eax
     1c1:	3e ff 24 85 70 13 00 	notrack jmp *0x1370(,%eax,4)
     1c8:	00 
    if(pipe(p) < 0)
     1c9:	83 ec 0c             	sub    $0xc,%esp
     1cc:	8d 45 f0             	lea    -0x10(%ebp),%eax
     1cf:	50                   	push   %eax
     1d0:	e8 0e 0c 00 00       	call   de3 <pipe>
     1d5:	83 c4 10             	add    $0x10,%esp
     1d8:	85 c0                	test   %eax,%eax
     1da:	0f 88 20 01 00 00    	js     300 <runcmd+0x160>
  pid = fork();
     1e0:	e8 e6 0b 00 00       	call   dcb <fork>
  if(pid == -1)
     1e5:	83 f8 ff             	cmp    $0xffffffff,%eax
     1e8:	0f 84 7b 01 00 00    	je     369 <runcmd+0x1c9>
    if(fork1() == 0){
     1ee:	85 c0                	test   %eax,%eax
     1f0:	0f 84 17 01 00 00    	je     30d <runcmd+0x16d>
  pid = fork();
     1f6:	e8 d0 0b 00 00       	call   dcb <fork>
  if(pid == -1)
     1fb:	83 f8 ff             	cmp    $0xffffffff,%eax
     1fe:	0f 84 65 01 00 00    	je     369 <runcmd+0x1c9>
    if(fork1() == 0){
     204:	85 c0                	test   %eax,%eax
     206:	0f 84 2f 01 00 00    	je     33b <runcmd+0x19b>
    close(p[0]);
     20c:	83 ec 0c             	sub    $0xc,%esp
     20f:	ff 75 f0             	pushl  -0x10(%ebp)
     212:	e8 e4 0b 00 00       	call   dfb <close>
    close(p[1]);
     217:	58                   	pop    %eax
     218:	ff 75 f4             	pushl  -0xc(%ebp)
     21b:	e8 db 0b 00 00       	call   dfb <close>
    wait(null);
     220:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     227:	e8 af 0b 00 00       	call   ddb <wait>
    wait(null);
     22c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     233:	e8 a3 0b 00 00       	call   ddb <wait>
    break;
     238:	83 c4 10             	add    $0x10,%esp
     23b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     23f:	90                   	nop
    exit(0);
     240:	83 ec 0c             	sub    $0xc,%esp
     243:	6a 00                	push   $0x0
     245:	e8 89 0b 00 00       	call   dd3 <exit>
  pid = fork();
     24a:	e8 7c 0b 00 00       	call   dcb <fork>
  if(pid == -1)
     24f:	83 f8 ff             	cmp    $0xffffffff,%eax
     252:	0f 84 11 01 00 00    	je     369 <runcmd+0x1c9>
    if(fork1() == 0)
     258:	85 c0                	test   %eax,%eax
     25a:	75 e4                	jne    240 <runcmd+0xa0>
     25c:	eb 6e                	jmp    2cc <runcmd+0x12c>
    if(ecmd->argv[0] == 0)
     25e:	8b 43 04             	mov    0x4(%ebx),%eax
     261:	85 c0                	test   %eax,%eax
     263:	74 db                	je     240 <runcmd+0xa0>
    exec(ecmd->argv[0], ecmd->argv);
     265:	8d 53 04             	lea    0x4(%ebx),%edx
     268:	51                   	push   %ecx
     269:	51                   	push   %ecx
     26a:	52                   	push   %edx
     26b:	50                   	push   %eax
     26c:	e8 9a 0b 00 00       	call   e0b <exec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
     271:	83 c4 0c             	add    $0xc,%esp
     274:	ff 73 04             	pushl  0x4(%ebx)
     277:	68 c2 12 00 00       	push   $0x12c2
     27c:	6a 02                	push   $0x2
     27e:	e8 cd 0c 00 00       	call   f50 <printf>
    break;
     283:	83 c4 10             	add    $0x10,%esp
     286:	eb b8                	jmp    240 <runcmd+0xa0>
  pid = fork();
     288:	e8 3e 0b 00 00       	call   dcb <fork>
  if(pid == -1)
     28d:	83 f8 ff             	cmp    $0xffffffff,%eax
     290:	0f 84 d3 00 00 00    	je     369 <runcmd+0x1c9>
    if(fork1() == 0)
     296:	85 c0                	test   %eax,%eax
     298:	74 32                	je     2cc <runcmd+0x12c>
    wait(null);
     29a:	83 ec 0c             	sub    $0xc,%esp
     29d:	6a 00                	push   $0x0
     29f:	e8 37 0b 00 00       	call   ddb <wait>
    runcmd(lcmd->right);
     2a4:	59                   	pop    %ecx
     2a5:	ff 73 08             	pushl  0x8(%ebx)
     2a8:	e8 f3 fe ff ff       	call   1a0 <runcmd>
    close(rcmd->fd);
     2ad:	83 ec 0c             	sub    $0xc,%esp
     2b0:	ff 73 14             	pushl  0x14(%ebx)
     2b3:	e8 43 0b 00 00       	call   dfb <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     2b8:	58                   	pop    %eax
     2b9:	5a                   	pop    %edx
     2ba:	ff 73 10             	pushl  0x10(%ebx)
     2bd:	ff 73 08             	pushl  0x8(%ebx)
     2c0:	e8 4e 0b 00 00       	call   e13 <open>
     2c5:	83 c4 10             	add    $0x10,%esp
     2c8:	85 c0                	test   %eax,%eax
     2ca:	78 18                	js     2e4 <runcmd+0x144>
      runcmd(bcmd->cmd);
     2cc:	83 ec 0c             	sub    $0xc,%esp
     2cf:	ff 73 04             	pushl  0x4(%ebx)
     2d2:	e8 c9 fe ff ff       	call   1a0 <runcmd>
    panic("runcmd");
     2d7:	83 ec 0c             	sub    $0xc,%esp
     2da:	68 bb 12 00 00       	push   $0x12bb
     2df:	e8 8c fe ff ff       	call   170 <panic>
      printf(2, "open %s failed\n", rcmd->file);
     2e4:	50                   	push   %eax
     2e5:	ff 73 08             	pushl  0x8(%ebx)
     2e8:	68 d2 12 00 00       	push   $0x12d2
     2ed:	6a 02                	push   $0x2
     2ef:	e8 5c 0c 00 00       	call   f50 <printf>
      exit(0);
     2f4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     2fb:	e8 d3 0a 00 00       	call   dd3 <exit>
      panic("pipe");
     300:	83 ec 0c             	sub    $0xc,%esp
     303:	68 e7 12 00 00       	push   $0x12e7
     308:	e8 63 fe ff ff       	call   170 <panic>
      close(1);
     30d:	83 ec 0c             	sub    $0xc,%esp
     310:	6a 01                	push   $0x1
     312:	e8 e4 0a 00 00       	call   dfb <close>
      dup(p[1]);
     317:	58                   	pop    %eax
     318:	ff 75 f4             	pushl  -0xc(%ebp)
     31b:	e8 2b 0b 00 00       	call   e4b <dup>
      close(p[0]);
     320:	58                   	pop    %eax
     321:	ff 75 f0             	pushl  -0x10(%ebp)
     324:	e8 d2 0a 00 00       	call   dfb <close>
      close(p[1]);
     329:	58                   	pop    %eax
     32a:	ff 75 f4             	pushl  -0xc(%ebp)
     32d:	e8 c9 0a 00 00       	call   dfb <close>
      runcmd(pcmd->left);
     332:	5a                   	pop    %edx
     333:	ff 73 04             	pushl  0x4(%ebx)
     336:	e8 65 fe ff ff       	call   1a0 <runcmd>
      close(0);
     33b:	83 ec 0c             	sub    $0xc,%esp
     33e:	6a 00                	push   $0x0
     340:	e8 b6 0a 00 00       	call   dfb <close>
      dup(p[0]);
     345:	5a                   	pop    %edx
     346:	ff 75 f0             	pushl  -0x10(%ebp)
     349:	e8 fd 0a 00 00       	call   e4b <dup>
      close(p[0]);
     34e:	59                   	pop    %ecx
     34f:	ff 75 f0             	pushl  -0x10(%ebp)
     352:	e8 a4 0a 00 00       	call   dfb <close>
      close(p[1]);
     357:	58                   	pop    %eax
     358:	ff 75 f4             	pushl  -0xc(%ebp)
     35b:	e8 9b 0a 00 00       	call   dfb <close>
      runcmd(pcmd->right);
     360:	58                   	pop    %eax
     361:	ff 73 08             	pushl  0x8(%ebx)
     364:	e8 37 fe ff ff       	call   1a0 <runcmd>
    panic("fork");
     369:	83 ec 0c             	sub    $0xc,%esp
     36c:	68 e2 12 00 00       	push   $0x12e2
     371:	e8 fa fd ff ff       	call   170 <panic>
     376:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     37d:	8d 76 00             	lea    0x0(%esi),%esi

00000380 <fork1>:
{
     380:	f3 0f 1e fb          	endbr32 
     384:	55                   	push   %ebp
     385:	89 e5                	mov    %esp,%ebp
     387:	83 ec 08             	sub    $0x8,%esp
  pid = fork();
     38a:	e8 3c 0a 00 00       	call   dcb <fork>
  if(pid == -1)
     38f:	83 f8 ff             	cmp    $0xffffffff,%eax
     392:	74 02                	je     396 <fork1+0x16>
  return pid;
}
     394:	c9                   	leave  
     395:	c3                   	ret    
    panic("fork");
     396:	83 ec 0c             	sub    $0xc,%esp
     399:	68 e2 12 00 00       	push   $0x12e2
     39e:	e8 cd fd ff ff       	call   170 <panic>
     3a3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     3aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000003b0 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     3b0:	f3 0f 1e fb          	endbr32 
     3b4:	55                   	push   %ebp
     3b5:	89 e5                	mov    %esp,%ebp
     3b7:	53                   	push   %ebx
     3b8:	83 ec 10             	sub    $0x10,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3bb:	6a 54                	push   $0x54
     3bd:	e8 ee 0d 00 00       	call   11b0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     3c2:	83 c4 0c             	add    $0xc,%esp
     3c5:	6a 54                	push   $0x54
  cmd = malloc(sizeof(*cmd));
     3c7:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     3c9:	6a 00                	push   $0x0
     3cb:	50                   	push   %eax
     3cc:	e8 5f 08 00 00       	call   c30 <memset>
  cmd->type = EXEC;
     3d1:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  return (struct cmd*)cmd;
}
     3d7:	89 d8                	mov    %ebx,%eax
     3d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     3dc:	c9                   	leave  
     3dd:	c3                   	ret    
     3de:	66 90                	xchg   %ax,%ax

000003e0 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     3e0:	f3 0f 1e fb          	endbr32 
     3e4:	55                   	push   %ebp
     3e5:	89 e5                	mov    %esp,%ebp
     3e7:	53                   	push   %ebx
     3e8:	83 ec 10             	sub    $0x10,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3eb:	6a 18                	push   $0x18
     3ed:	e8 be 0d 00 00       	call   11b0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     3f2:	83 c4 0c             	add    $0xc,%esp
     3f5:	6a 18                	push   $0x18
  cmd = malloc(sizeof(*cmd));
     3f7:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     3f9:	6a 00                	push   $0x0
     3fb:	50                   	push   %eax
     3fc:	e8 2f 08 00 00       	call   c30 <memset>
  cmd->type = REDIR;
  cmd->cmd = subcmd;
     401:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = REDIR;
     404:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  cmd->cmd = subcmd;
     40a:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->file = file;
     40d:	8b 45 0c             	mov    0xc(%ebp),%eax
     410:	89 43 08             	mov    %eax,0x8(%ebx)
  cmd->efile = efile;
     413:	8b 45 10             	mov    0x10(%ebp),%eax
     416:	89 43 0c             	mov    %eax,0xc(%ebx)
  cmd->mode = mode;
     419:	8b 45 14             	mov    0x14(%ebp),%eax
     41c:	89 43 10             	mov    %eax,0x10(%ebx)
  cmd->fd = fd;
     41f:	8b 45 18             	mov    0x18(%ebp),%eax
     422:	89 43 14             	mov    %eax,0x14(%ebx)
  return (struct cmd*)cmd;
}
     425:	89 d8                	mov    %ebx,%eax
     427:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     42a:	c9                   	leave  
     42b:	c3                   	ret    
     42c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000430 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     430:	f3 0f 1e fb          	endbr32 
     434:	55                   	push   %ebp
     435:	89 e5                	mov    %esp,%ebp
     437:	53                   	push   %ebx
     438:	83 ec 10             	sub    $0x10,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     43b:	6a 0c                	push   $0xc
     43d:	e8 6e 0d 00 00       	call   11b0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     442:	83 c4 0c             	add    $0xc,%esp
     445:	6a 0c                	push   $0xc
  cmd = malloc(sizeof(*cmd));
     447:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     449:	6a 00                	push   $0x0
     44b:	50                   	push   %eax
     44c:	e8 df 07 00 00       	call   c30 <memset>
  cmd->type = PIPE;
  cmd->left = left;
     451:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = PIPE;
     454:	c7 03 03 00 00 00    	movl   $0x3,(%ebx)
  cmd->left = left;
     45a:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     45d:	8b 45 0c             	mov    0xc(%ebp),%eax
     460:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     463:	89 d8                	mov    %ebx,%eax
     465:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     468:	c9                   	leave  
     469:	c3                   	ret    
     46a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000470 <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     470:	f3 0f 1e fb          	endbr32 
     474:	55                   	push   %ebp
     475:	89 e5                	mov    %esp,%ebp
     477:	53                   	push   %ebx
     478:	83 ec 10             	sub    $0x10,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     47b:	6a 0c                	push   $0xc
     47d:	e8 2e 0d 00 00       	call   11b0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     482:	83 c4 0c             	add    $0xc,%esp
     485:	6a 0c                	push   $0xc
  cmd = malloc(sizeof(*cmd));
     487:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     489:	6a 00                	push   $0x0
     48b:	50                   	push   %eax
     48c:	e8 9f 07 00 00       	call   c30 <memset>
  cmd->type = LIST;
  cmd->left = left;
     491:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = LIST;
     494:	c7 03 04 00 00 00    	movl   $0x4,(%ebx)
  cmd->left = left;
     49a:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     49d:	8b 45 0c             	mov    0xc(%ebp),%eax
     4a0:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     4a3:	89 d8                	mov    %ebx,%eax
     4a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     4a8:	c9                   	leave  
     4a9:	c3                   	ret    
     4aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000004b0 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     4b0:	f3 0f 1e fb          	endbr32 
     4b4:	55                   	push   %ebp
     4b5:	89 e5                	mov    %esp,%ebp
     4b7:	53                   	push   %ebx
     4b8:	83 ec 10             	sub    $0x10,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     4bb:	6a 08                	push   $0x8
     4bd:	e8 ee 0c 00 00       	call   11b0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     4c2:	83 c4 0c             	add    $0xc,%esp
     4c5:	6a 08                	push   $0x8
  cmd = malloc(sizeof(*cmd));
     4c7:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     4c9:	6a 00                	push   $0x0
     4cb:	50                   	push   %eax
     4cc:	e8 5f 07 00 00       	call   c30 <memset>
  cmd->type = BACK;
  cmd->cmd = subcmd;
     4d1:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = BACK;
     4d4:	c7 03 05 00 00 00    	movl   $0x5,(%ebx)
  cmd->cmd = subcmd;
     4da:	89 43 04             	mov    %eax,0x4(%ebx)
  return (struct cmd*)cmd;
}
     4dd:	89 d8                	mov    %ebx,%eax
     4df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     4e2:	c9                   	leave  
     4e3:	c3                   	ret    
     4e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     4eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     4ef:	90                   	nop

000004f0 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     4f0:	f3 0f 1e fb          	endbr32 
     4f4:	55                   	push   %ebp
     4f5:	89 e5                	mov    %esp,%ebp
     4f7:	57                   	push   %edi
     4f8:	56                   	push   %esi
     4f9:	53                   	push   %ebx
     4fa:	83 ec 0c             	sub    $0xc,%esp
  char *s;
  int ret;

  s = *ps;
     4fd:	8b 45 08             	mov    0x8(%ebp),%eax
{
     500:	8b 5d 0c             	mov    0xc(%ebp),%ebx
     503:	8b 75 10             	mov    0x10(%ebp),%esi
  s = *ps;
     506:	8b 38                	mov    (%eax),%edi
  while(s < es && strchr(whitespace, *s))
     508:	39 df                	cmp    %ebx,%edi
     50a:	72 0b                	jb     517 <gettoken+0x27>
     50c:	eb 21                	jmp    52f <gettoken+0x3f>
     50e:	66 90                	xchg   %ax,%ax
    s++;
     510:	83 c7 01             	add    $0x1,%edi
  while(s < es && strchr(whitespace, *s))
     513:	39 fb                	cmp    %edi,%ebx
     515:	74 18                	je     52f <gettoken+0x3f>
     517:	0f be 07             	movsbl (%edi),%eax
     51a:	83 ec 08             	sub    $0x8,%esp
     51d:	50                   	push   %eax
     51e:	68 80 19 00 00       	push   $0x1980
     523:	e8 28 07 00 00       	call   c50 <strchr>
     528:	83 c4 10             	add    $0x10,%esp
     52b:	85 c0                	test   %eax,%eax
     52d:	75 e1                	jne    510 <gettoken+0x20>
  if(q)
     52f:	85 f6                	test   %esi,%esi
     531:	74 02                	je     535 <gettoken+0x45>
    *q = s;
     533:	89 3e                	mov    %edi,(%esi)
  ret = *s;
     535:	0f b6 07             	movzbl (%edi),%eax
  switch(*s){
     538:	3c 3c                	cmp    $0x3c,%al
     53a:	0f 8f d0 00 00 00    	jg     610 <gettoken+0x120>
     540:	3c 3a                	cmp    $0x3a,%al
     542:	0f 8f b4 00 00 00    	jg     5fc <gettoken+0x10c>
     548:	84 c0                	test   %al,%al
     54a:	75 44                	jne    590 <gettoken+0xa0>
     54c:	31 f6                	xor    %esi,%esi
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     54e:	8b 55 14             	mov    0x14(%ebp),%edx
     551:	85 d2                	test   %edx,%edx
     553:	74 05                	je     55a <gettoken+0x6a>
    *eq = s;
     555:	8b 45 14             	mov    0x14(%ebp),%eax
     558:	89 38                	mov    %edi,(%eax)

  while(s < es && strchr(whitespace, *s))
     55a:	39 df                	cmp    %ebx,%edi
     55c:	72 09                	jb     567 <gettoken+0x77>
     55e:	eb 1f                	jmp    57f <gettoken+0x8f>
    s++;
     560:	83 c7 01             	add    $0x1,%edi
  while(s < es && strchr(whitespace, *s))
     563:	39 fb                	cmp    %edi,%ebx
     565:	74 18                	je     57f <gettoken+0x8f>
     567:	0f be 07             	movsbl (%edi),%eax
     56a:	83 ec 08             	sub    $0x8,%esp
     56d:	50                   	push   %eax
     56e:	68 80 19 00 00       	push   $0x1980
     573:	e8 d8 06 00 00       	call   c50 <strchr>
     578:	83 c4 10             	add    $0x10,%esp
     57b:	85 c0                	test   %eax,%eax
     57d:	75 e1                	jne    560 <gettoken+0x70>
  *ps = s;
     57f:	8b 45 08             	mov    0x8(%ebp),%eax
     582:	89 38                	mov    %edi,(%eax)
  return ret;
}
     584:	8d 65 f4             	lea    -0xc(%ebp),%esp
     587:	89 f0                	mov    %esi,%eax
     589:	5b                   	pop    %ebx
     58a:	5e                   	pop    %esi
     58b:	5f                   	pop    %edi
     58c:	5d                   	pop    %ebp
     58d:	c3                   	ret    
     58e:	66 90                	xchg   %ax,%ax
  switch(*s){
     590:	79 5e                	jns    5f0 <gettoken+0x100>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     592:	39 fb                	cmp    %edi,%ebx
     594:	77 34                	ja     5ca <gettoken+0xda>
  if(eq)
     596:	8b 45 14             	mov    0x14(%ebp),%eax
     599:	be 61 00 00 00       	mov    $0x61,%esi
     59e:	85 c0                	test   %eax,%eax
     5a0:	75 b3                	jne    555 <gettoken+0x65>
     5a2:	eb db                	jmp    57f <gettoken+0x8f>
     5a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     5a8:	0f be 07             	movsbl (%edi),%eax
     5ab:	83 ec 08             	sub    $0x8,%esp
     5ae:	50                   	push   %eax
     5af:	68 78 19 00 00       	push   $0x1978
     5b4:	e8 97 06 00 00       	call   c50 <strchr>
     5b9:	83 c4 10             	add    $0x10,%esp
     5bc:	85 c0                	test   %eax,%eax
     5be:	75 22                	jne    5e2 <gettoken+0xf2>
      s++;
     5c0:	83 c7 01             	add    $0x1,%edi
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     5c3:	39 fb                	cmp    %edi,%ebx
     5c5:	74 cf                	je     596 <gettoken+0xa6>
     5c7:	0f b6 07             	movzbl (%edi),%eax
     5ca:	83 ec 08             	sub    $0x8,%esp
     5cd:	0f be f0             	movsbl %al,%esi
     5d0:	56                   	push   %esi
     5d1:	68 80 19 00 00       	push   $0x1980
     5d6:	e8 75 06 00 00       	call   c50 <strchr>
     5db:	83 c4 10             	add    $0x10,%esp
     5de:	85 c0                	test   %eax,%eax
     5e0:	74 c6                	je     5a8 <gettoken+0xb8>
    ret = 'a';
     5e2:	be 61 00 00 00       	mov    $0x61,%esi
     5e7:	e9 62 ff ff ff       	jmp    54e <gettoken+0x5e>
     5ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  switch(*s){
     5f0:	3c 26                	cmp    $0x26,%al
     5f2:	74 08                	je     5fc <gettoken+0x10c>
     5f4:	8d 48 d8             	lea    -0x28(%eax),%ecx
     5f7:	80 f9 01             	cmp    $0x1,%cl
     5fa:	77 96                	ja     592 <gettoken+0xa2>
  ret = *s;
     5fc:	0f be f0             	movsbl %al,%esi
    s++;
     5ff:	83 c7 01             	add    $0x1,%edi
    break;
     602:	e9 47 ff ff ff       	jmp    54e <gettoken+0x5e>
     607:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     60e:	66 90                	xchg   %ax,%ax
  switch(*s){
     610:	3c 3e                	cmp    $0x3e,%al
     612:	75 1c                	jne    630 <gettoken+0x140>
    if(*s == '>'){
     614:	80 7f 01 3e          	cmpb   $0x3e,0x1(%edi)
    s++;
     618:	8d 47 01             	lea    0x1(%edi),%eax
    if(*s == '>'){
     61b:	74 1c                	je     639 <gettoken+0x149>
    s++;
     61d:	89 c7                	mov    %eax,%edi
     61f:	be 3e 00 00 00       	mov    $0x3e,%esi
     624:	e9 25 ff ff ff       	jmp    54e <gettoken+0x5e>
     629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  switch(*s){
     630:	3c 7c                	cmp    $0x7c,%al
     632:	74 c8                	je     5fc <gettoken+0x10c>
     634:	e9 59 ff ff ff       	jmp    592 <gettoken+0xa2>
      s++;
     639:	83 c7 02             	add    $0x2,%edi
      ret = '+';
     63c:	be 2b 00 00 00       	mov    $0x2b,%esi
     641:	e9 08 ff ff ff       	jmp    54e <gettoken+0x5e>
     646:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     64d:	8d 76 00             	lea    0x0(%esi),%esi

00000650 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     650:	f3 0f 1e fb          	endbr32 
     654:	55                   	push   %ebp
     655:	89 e5                	mov    %esp,%ebp
     657:	57                   	push   %edi
     658:	56                   	push   %esi
     659:	53                   	push   %ebx
     65a:	83 ec 0c             	sub    $0xc,%esp
     65d:	8b 7d 08             	mov    0x8(%ebp),%edi
     660:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *s;

  s = *ps;
     663:	8b 1f                	mov    (%edi),%ebx
  while(s < es && strchr(whitespace, *s))
     665:	39 f3                	cmp    %esi,%ebx
     667:	72 0e                	jb     677 <peek+0x27>
     669:	eb 24                	jmp    68f <peek+0x3f>
     66b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     66f:	90                   	nop
    s++;
     670:	83 c3 01             	add    $0x1,%ebx
  while(s < es && strchr(whitespace, *s))
     673:	39 de                	cmp    %ebx,%esi
     675:	74 18                	je     68f <peek+0x3f>
     677:	0f be 03             	movsbl (%ebx),%eax
     67a:	83 ec 08             	sub    $0x8,%esp
     67d:	50                   	push   %eax
     67e:	68 80 19 00 00       	push   $0x1980
     683:	e8 c8 05 00 00       	call   c50 <strchr>
     688:	83 c4 10             	add    $0x10,%esp
     68b:	85 c0                	test   %eax,%eax
     68d:	75 e1                	jne    670 <peek+0x20>
  *ps = s;
     68f:	89 1f                	mov    %ebx,(%edi)
  return *s && strchr(toks, *s);
     691:	0f be 03             	movsbl (%ebx),%eax
     694:	31 d2                	xor    %edx,%edx
     696:	84 c0                	test   %al,%al
     698:	75 0e                	jne    6a8 <peek+0x58>
}
     69a:	8d 65 f4             	lea    -0xc(%ebp),%esp
     69d:	89 d0                	mov    %edx,%eax
     69f:	5b                   	pop    %ebx
     6a0:	5e                   	pop    %esi
     6a1:	5f                   	pop    %edi
     6a2:	5d                   	pop    %ebp
     6a3:	c3                   	ret    
     6a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return *s && strchr(toks, *s);
     6a8:	83 ec 08             	sub    $0x8,%esp
     6ab:	50                   	push   %eax
     6ac:	ff 75 10             	pushl  0x10(%ebp)
     6af:	e8 9c 05 00 00       	call   c50 <strchr>
     6b4:	83 c4 10             	add    $0x10,%esp
     6b7:	31 d2                	xor    %edx,%edx
     6b9:	85 c0                	test   %eax,%eax
     6bb:	0f 95 c2             	setne  %dl
}
     6be:	8d 65 f4             	lea    -0xc(%ebp),%esp
     6c1:	5b                   	pop    %ebx
     6c2:	89 d0                	mov    %edx,%eax
     6c4:	5e                   	pop    %esi
     6c5:	5f                   	pop    %edi
     6c6:	5d                   	pop    %ebp
     6c7:	c3                   	ret    
     6c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     6cf:	90                   	nop

000006d0 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     6d0:	f3 0f 1e fb          	endbr32 
     6d4:	55                   	push   %ebp
     6d5:	89 e5                	mov    %esp,%ebp
     6d7:	57                   	push   %edi
     6d8:	56                   	push   %esi
     6d9:	53                   	push   %ebx
     6da:	83 ec 1c             	sub    $0x1c,%esp
     6dd:	8b 75 0c             	mov    0xc(%ebp),%esi
     6e0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     6e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     6e7:	90                   	nop
     6e8:	83 ec 04             	sub    $0x4,%esp
     6eb:	68 09 13 00 00       	push   $0x1309
     6f0:	53                   	push   %ebx
     6f1:	56                   	push   %esi
     6f2:	e8 59 ff ff ff       	call   650 <peek>
     6f7:	83 c4 10             	add    $0x10,%esp
     6fa:	85 c0                	test   %eax,%eax
     6fc:	74 6a                	je     768 <parseredirs+0x98>
    tok = gettoken(ps, es, 0, 0);
     6fe:	6a 00                	push   $0x0
     700:	6a 00                	push   $0x0
     702:	53                   	push   %ebx
     703:	56                   	push   %esi
     704:	e8 e7 fd ff ff       	call   4f0 <gettoken>
     709:	89 c7                	mov    %eax,%edi
    if(gettoken(ps, es, &q, &eq) != 'a')
     70b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     70e:	50                   	push   %eax
     70f:	8d 45 e0             	lea    -0x20(%ebp),%eax
     712:	50                   	push   %eax
     713:	53                   	push   %ebx
     714:	56                   	push   %esi
     715:	e8 d6 fd ff ff       	call   4f0 <gettoken>
     71a:	83 c4 20             	add    $0x20,%esp
     71d:	83 f8 61             	cmp    $0x61,%eax
     720:	75 51                	jne    773 <parseredirs+0xa3>
      panic("missing file for redirection");
    switch(tok){
     722:	83 ff 3c             	cmp    $0x3c,%edi
     725:	74 31                	je     758 <parseredirs+0x88>
     727:	83 ff 3e             	cmp    $0x3e,%edi
     72a:	74 05                	je     731 <parseredirs+0x61>
     72c:	83 ff 2b             	cmp    $0x2b,%edi
     72f:	75 b7                	jne    6e8 <parseredirs+0x18>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     731:	83 ec 0c             	sub    $0xc,%esp
     734:	6a 01                	push   $0x1
     736:	68 01 02 00 00       	push   $0x201
     73b:	ff 75 e4             	pushl  -0x1c(%ebp)
     73e:	ff 75 e0             	pushl  -0x20(%ebp)
     741:	ff 75 08             	pushl  0x8(%ebp)
     744:	e8 97 fc ff ff       	call   3e0 <redircmd>
      break;
     749:	83 c4 20             	add    $0x20,%esp
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     74c:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     74f:	eb 97                	jmp    6e8 <parseredirs+0x18>
     751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     758:	83 ec 0c             	sub    $0xc,%esp
     75b:	6a 00                	push   $0x0
     75d:	6a 00                	push   $0x0
     75f:	eb da                	jmp    73b <parseredirs+0x6b>
     761:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
  }
  return cmd;
}
     768:	8b 45 08             	mov    0x8(%ebp),%eax
     76b:	8d 65 f4             	lea    -0xc(%ebp),%esp
     76e:	5b                   	pop    %ebx
     76f:	5e                   	pop    %esi
     770:	5f                   	pop    %edi
     771:	5d                   	pop    %ebp
     772:	c3                   	ret    
      panic("missing file for redirection");
     773:	83 ec 0c             	sub    $0xc,%esp
     776:	68 ec 12 00 00       	push   $0x12ec
     77b:	e8 f0 f9 ff ff       	call   170 <panic>

00000780 <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     780:	f3 0f 1e fb          	endbr32 
     784:	55                   	push   %ebp
     785:	89 e5                	mov    %esp,%ebp
     787:	57                   	push   %edi
     788:	56                   	push   %esi
     789:	53                   	push   %ebx
     78a:	83 ec 30             	sub    $0x30,%esp
     78d:	8b 75 08             	mov    0x8(%ebp),%esi
     790:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     793:	68 0c 13 00 00       	push   $0x130c
     798:	57                   	push   %edi
     799:	56                   	push   %esi
     79a:	e8 b1 fe ff ff       	call   650 <peek>
     79f:	83 c4 10             	add    $0x10,%esp
     7a2:	85 c0                	test   %eax,%eax
     7a4:	0f 85 96 00 00 00    	jne    840 <parseexec+0xc0>
     7aa:	89 c3                	mov    %eax,%ebx
    return parseblock(ps, es);

  ret = execcmd();
     7ac:	e8 ff fb ff ff       	call   3b0 <execcmd>
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     7b1:	83 ec 04             	sub    $0x4,%esp
     7b4:	57                   	push   %edi
     7b5:	56                   	push   %esi
     7b6:	50                   	push   %eax
  ret = execcmd();
     7b7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  ret = parseredirs(ret, ps, es);
     7ba:	e8 11 ff ff ff       	call   6d0 <parseredirs>
  while(!peek(ps, es, "|)&;")){
     7bf:	83 c4 10             	add    $0x10,%esp
  ret = parseredirs(ret, ps, es);
     7c2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  while(!peek(ps, es, "|)&;")){
     7c5:	eb 1c                	jmp    7e3 <parseexec+0x63>
     7c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     7ce:	66 90                	xchg   %ax,%ax
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
     7d0:	83 ec 04             	sub    $0x4,%esp
     7d3:	57                   	push   %edi
     7d4:	56                   	push   %esi
     7d5:	ff 75 d4             	pushl  -0x2c(%ebp)
     7d8:	e8 f3 fe ff ff       	call   6d0 <parseredirs>
     7dd:	83 c4 10             	add    $0x10,%esp
     7e0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  while(!peek(ps, es, "|)&;")){
     7e3:	83 ec 04             	sub    $0x4,%esp
     7e6:	68 23 13 00 00       	push   $0x1323
     7eb:	57                   	push   %edi
     7ec:	56                   	push   %esi
     7ed:	e8 5e fe ff ff       	call   650 <peek>
     7f2:	83 c4 10             	add    $0x10,%esp
     7f5:	85 c0                	test   %eax,%eax
     7f7:	75 67                	jne    860 <parseexec+0xe0>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     7f9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     7fc:	50                   	push   %eax
     7fd:	8d 45 e0             	lea    -0x20(%ebp),%eax
     800:	50                   	push   %eax
     801:	57                   	push   %edi
     802:	56                   	push   %esi
     803:	e8 e8 fc ff ff       	call   4f0 <gettoken>
     808:	83 c4 10             	add    $0x10,%esp
     80b:	85 c0                	test   %eax,%eax
     80d:	74 51                	je     860 <parseexec+0xe0>
    if(tok != 'a')
     80f:	83 f8 61             	cmp    $0x61,%eax
     812:	75 6b                	jne    87f <parseexec+0xff>
    cmd->argv[argc] = q;
     814:	8b 45 e0             	mov    -0x20(%ebp),%eax
     817:	8b 55 d0             	mov    -0x30(%ebp),%edx
     81a:	89 44 9a 04          	mov    %eax,0x4(%edx,%ebx,4)
    cmd->eargv[argc] = eq;
     81e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     821:	89 44 9a 2c          	mov    %eax,0x2c(%edx,%ebx,4)
    argc++;
     825:	83 c3 01             	add    $0x1,%ebx
    if(argc >= MAXARGS)
     828:	83 fb 0a             	cmp    $0xa,%ebx
     82b:	75 a3                	jne    7d0 <parseexec+0x50>
      panic("too many args");
     82d:	83 ec 0c             	sub    $0xc,%esp
     830:	68 15 13 00 00       	push   $0x1315
     835:	e8 36 f9 ff ff       	call   170 <panic>
     83a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return parseblock(ps, es);
     840:	83 ec 08             	sub    $0x8,%esp
     843:	57                   	push   %edi
     844:	56                   	push   %esi
     845:	e8 66 01 00 00       	call   9b0 <parseblock>
     84a:	83 c4 10             	add    $0x10,%esp
     84d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     850:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     853:	8d 65 f4             	lea    -0xc(%ebp),%esp
     856:	5b                   	pop    %ebx
     857:	5e                   	pop    %esi
     858:	5f                   	pop    %edi
     859:	5d                   	pop    %ebp
     85a:	c3                   	ret    
     85b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     85f:	90                   	nop
  cmd->argv[argc] = 0;
     860:	8b 45 d0             	mov    -0x30(%ebp),%eax
     863:	8d 04 98             	lea    (%eax,%ebx,4),%eax
     866:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  cmd->eargv[argc] = 0;
     86d:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
}
     874:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     877:	8d 65 f4             	lea    -0xc(%ebp),%esp
     87a:	5b                   	pop    %ebx
     87b:	5e                   	pop    %esi
     87c:	5f                   	pop    %edi
     87d:	5d                   	pop    %ebp
     87e:	c3                   	ret    
      panic("syntax");
     87f:	83 ec 0c             	sub    $0xc,%esp
     882:	68 0e 13 00 00       	push   $0x130e
     887:	e8 e4 f8 ff ff       	call   170 <panic>
     88c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000890 <parsepipe>:
{
     890:	f3 0f 1e fb          	endbr32 
     894:	55                   	push   %ebp
     895:	89 e5                	mov    %esp,%ebp
     897:	57                   	push   %edi
     898:	56                   	push   %esi
     899:	53                   	push   %ebx
     89a:	83 ec 14             	sub    $0x14,%esp
     89d:	8b 75 08             	mov    0x8(%ebp),%esi
     8a0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  cmd = parseexec(ps, es);
     8a3:	57                   	push   %edi
     8a4:	56                   	push   %esi
     8a5:	e8 d6 fe ff ff       	call   780 <parseexec>
  if(peek(ps, es, "|")){
     8aa:	83 c4 0c             	add    $0xc,%esp
     8ad:	68 28 13 00 00       	push   $0x1328
  cmd = parseexec(ps, es);
     8b2:	89 c3                	mov    %eax,%ebx
  if(peek(ps, es, "|")){
     8b4:	57                   	push   %edi
     8b5:	56                   	push   %esi
     8b6:	e8 95 fd ff ff       	call   650 <peek>
     8bb:	83 c4 10             	add    $0x10,%esp
     8be:	85 c0                	test   %eax,%eax
     8c0:	75 0e                	jne    8d0 <parsepipe+0x40>
}
     8c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
     8c5:	89 d8                	mov    %ebx,%eax
     8c7:	5b                   	pop    %ebx
     8c8:	5e                   	pop    %esi
     8c9:	5f                   	pop    %edi
     8ca:	5d                   	pop    %ebp
     8cb:	c3                   	ret    
     8cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    gettoken(ps, es, 0, 0);
     8d0:	6a 00                	push   $0x0
     8d2:	6a 00                	push   $0x0
     8d4:	57                   	push   %edi
     8d5:	56                   	push   %esi
     8d6:	e8 15 fc ff ff       	call   4f0 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     8db:	58                   	pop    %eax
     8dc:	5a                   	pop    %edx
     8dd:	57                   	push   %edi
     8de:	56                   	push   %esi
     8df:	e8 ac ff ff ff       	call   890 <parsepipe>
     8e4:	89 5d 08             	mov    %ebx,0x8(%ebp)
     8e7:	83 c4 10             	add    $0x10,%esp
     8ea:	89 45 0c             	mov    %eax,0xc(%ebp)
}
     8ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
     8f0:	5b                   	pop    %ebx
     8f1:	5e                   	pop    %esi
     8f2:	5f                   	pop    %edi
     8f3:	5d                   	pop    %ebp
    cmd = pipecmd(cmd, parsepipe(ps, es));
     8f4:	e9 37 fb ff ff       	jmp    430 <pipecmd>
     8f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000900 <parseline>:
{
     900:	f3 0f 1e fb          	endbr32 
     904:	55                   	push   %ebp
     905:	89 e5                	mov    %esp,%ebp
     907:	57                   	push   %edi
     908:	56                   	push   %esi
     909:	53                   	push   %ebx
     90a:	83 ec 14             	sub    $0x14,%esp
     90d:	8b 75 08             	mov    0x8(%ebp),%esi
     910:	8b 7d 0c             	mov    0xc(%ebp),%edi
  cmd = parsepipe(ps, es);
     913:	57                   	push   %edi
     914:	56                   	push   %esi
     915:	e8 76 ff ff ff       	call   890 <parsepipe>
  while(peek(ps, es, "&")){
     91a:	83 c4 10             	add    $0x10,%esp
  cmd = parsepipe(ps, es);
     91d:	89 c3                	mov    %eax,%ebx
  while(peek(ps, es, "&")){
     91f:	eb 1f                	jmp    940 <parseline+0x40>
     921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    gettoken(ps, es, 0, 0);
     928:	6a 00                	push   $0x0
     92a:	6a 00                	push   $0x0
     92c:	57                   	push   %edi
     92d:	56                   	push   %esi
     92e:	e8 bd fb ff ff       	call   4f0 <gettoken>
    cmd = backcmd(cmd);
     933:	89 1c 24             	mov    %ebx,(%esp)
     936:	e8 75 fb ff ff       	call   4b0 <backcmd>
     93b:	83 c4 10             	add    $0x10,%esp
     93e:	89 c3                	mov    %eax,%ebx
  while(peek(ps, es, "&")){
     940:	83 ec 04             	sub    $0x4,%esp
     943:	68 2a 13 00 00       	push   $0x132a
     948:	57                   	push   %edi
     949:	56                   	push   %esi
     94a:	e8 01 fd ff ff       	call   650 <peek>
     94f:	83 c4 10             	add    $0x10,%esp
     952:	85 c0                	test   %eax,%eax
     954:	75 d2                	jne    928 <parseline+0x28>
  if(peek(ps, es, ";")){
     956:	83 ec 04             	sub    $0x4,%esp
     959:	68 26 13 00 00       	push   $0x1326
     95e:	57                   	push   %edi
     95f:	56                   	push   %esi
     960:	e8 eb fc ff ff       	call   650 <peek>
     965:	83 c4 10             	add    $0x10,%esp
     968:	85 c0                	test   %eax,%eax
     96a:	75 14                	jne    980 <parseline+0x80>
}
     96c:	8d 65 f4             	lea    -0xc(%ebp),%esp
     96f:	89 d8                	mov    %ebx,%eax
     971:	5b                   	pop    %ebx
     972:	5e                   	pop    %esi
     973:	5f                   	pop    %edi
     974:	5d                   	pop    %ebp
     975:	c3                   	ret    
     976:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     97d:	8d 76 00             	lea    0x0(%esi),%esi
    gettoken(ps, es, 0, 0);
     980:	6a 00                	push   $0x0
     982:	6a 00                	push   $0x0
     984:	57                   	push   %edi
     985:	56                   	push   %esi
     986:	e8 65 fb ff ff       	call   4f0 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     98b:	58                   	pop    %eax
     98c:	5a                   	pop    %edx
     98d:	57                   	push   %edi
     98e:	56                   	push   %esi
     98f:	e8 6c ff ff ff       	call   900 <parseline>
     994:	89 5d 08             	mov    %ebx,0x8(%ebp)
     997:	83 c4 10             	add    $0x10,%esp
     99a:	89 45 0c             	mov    %eax,0xc(%ebp)
}
     99d:	8d 65 f4             	lea    -0xc(%ebp),%esp
     9a0:	5b                   	pop    %ebx
     9a1:	5e                   	pop    %esi
     9a2:	5f                   	pop    %edi
     9a3:	5d                   	pop    %ebp
    cmd = listcmd(cmd, parseline(ps, es));
     9a4:	e9 c7 fa ff ff       	jmp    470 <listcmd>
     9a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000009b0 <parseblock>:
{
     9b0:	f3 0f 1e fb          	endbr32 
     9b4:	55                   	push   %ebp
     9b5:	89 e5                	mov    %esp,%ebp
     9b7:	57                   	push   %edi
     9b8:	56                   	push   %esi
     9b9:	53                   	push   %ebx
     9ba:	83 ec 10             	sub    $0x10,%esp
     9bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
     9c0:	8b 75 0c             	mov    0xc(%ebp),%esi
  if(!peek(ps, es, "("))
     9c3:	68 0c 13 00 00       	push   $0x130c
     9c8:	56                   	push   %esi
     9c9:	53                   	push   %ebx
     9ca:	e8 81 fc ff ff       	call   650 <peek>
     9cf:	83 c4 10             	add    $0x10,%esp
     9d2:	85 c0                	test   %eax,%eax
     9d4:	74 4a                	je     a20 <parseblock+0x70>
  gettoken(ps, es, 0, 0);
     9d6:	6a 00                	push   $0x0
     9d8:	6a 00                	push   $0x0
     9da:	56                   	push   %esi
     9db:	53                   	push   %ebx
     9dc:	e8 0f fb ff ff       	call   4f0 <gettoken>
  cmd = parseline(ps, es);
     9e1:	58                   	pop    %eax
     9e2:	5a                   	pop    %edx
     9e3:	56                   	push   %esi
     9e4:	53                   	push   %ebx
     9e5:	e8 16 ff ff ff       	call   900 <parseline>
  if(!peek(ps, es, ")"))
     9ea:	83 c4 0c             	add    $0xc,%esp
     9ed:	68 48 13 00 00       	push   $0x1348
  cmd = parseline(ps, es);
     9f2:	89 c7                	mov    %eax,%edi
  if(!peek(ps, es, ")"))
     9f4:	56                   	push   %esi
     9f5:	53                   	push   %ebx
     9f6:	e8 55 fc ff ff       	call   650 <peek>
     9fb:	83 c4 10             	add    $0x10,%esp
     9fe:	85 c0                	test   %eax,%eax
     a00:	74 2b                	je     a2d <parseblock+0x7d>
  gettoken(ps, es, 0, 0);
     a02:	6a 00                	push   $0x0
     a04:	6a 00                	push   $0x0
     a06:	56                   	push   %esi
     a07:	53                   	push   %ebx
     a08:	e8 e3 fa ff ff       	call   4f0 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     a0d:	83 c4 0c             	add    $0xc,%esp
     a10:	56                   	push   %esi
     a11:	53                   	push   %ebx
     a12:	57                   	push   %edi
     a13:	e8 b8 fc ff ff       	call   6d0 <parseredirs>
}
     a18:	8d 65 f4             	lea    -0xc(%ebp),%esp
     a1b:	5b                   	pop    %ebx
     a1c:	5e                   	pop    %esi
     a1d:	5f                   	pop    %edi
     a1e:	5d                   	pop    %ebp
     a1f:	c3                   	ret    
    panic("parseblock");
     a20:	83 ec 0c             	sub    $0xc,%esp
     a23:	68 2c 13 00 00       	push   $0x132c
     a28:	e8 43 f7 ff ff       	call   170 <panic>
    panic("syntax - missing )");
     a2d:	83 ec 0c             	sub    $0xc,%esp
     a30:	68 37 13 00 00       	push   $0x1337
     a35:	e8 36 f7 ff ff       	call   170 <panic>
     a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000a40 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     a40:	f3 0f 1e fb          	endbr32 
     a44:	55                   	push   %ebp
     a45:	89 e5                	mov    %esp,%ebp
     a47:	53                   	push   %ebx
     a48:	83 ec 04             	sub    $0x4,%esp
     a4b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     a4e:	85 db                	test   %ebx,%ebx
     a50:	0f 84 9a 00 00 00    	je     af0 <nulterminate+0xb0>
    return 0;

  switch(cmd->type){
     a56:	83 3b 05             	cmpl   $0x5,(%ebx)
     a59:	77 6d                	ja     ac8 <nulterminate+0x88>
     a5b:	8b 03                	mov    (%ebx),%eax
     a5d:	3e ff 24 85 88 13 00 	notrack jmp *0x1388(,%eax,4)
     a64:	00 
     a65:	8d 76 00             	lea    0x0(%esi),%esi
    nulterminate(pcmd->right);
    break;

  case LIST:
    lcmd = (struct listcmd*)cmd;
    nulterminate(lcmd->left);
     a68:	83 ec 0c             	sub    $0xc,%esp
     a6b:	ff 73 04             	pushl  0x4(%ebx)
     a6e:	e8 cd ff ff ff       	call   a40 <nulterminate>
    nulterminate(lcmd->right);
     a73:	58                   	pop    %eax
     a74:	ff 73 08             	pushl  0x8(%ebx)
     a77:	e8 c4 ff ff ff       	call   a40 <nulterminate>
    break;
     a7c:	83 c4 10             	add    $0x10,%esp
     a7f:	89 d8                	mov    %ebx,%eax
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     a81:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     a84:	c9                   	leave  
     a85:	c3                   	ret    
     a86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     a8d:	8d 76 00             	lea    0x0(%esi),%esi
    nulterminate(bcmd->cmd);
     a90:	83 ec 0c             	sub    $0xc,%esp
     a93:	ff 73 04             	pushl  0x4(%ebx)
     a96:	e8 a5 ff ff ff       	call   a40 <nulterminate>
    break;
     a9b:	89 d8                	mov    %ebx,%eax
     a9d:	83 c4 10             	add    $0x10,%esp
}
     aa0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     aa3:	c9                   	leave  
     aa4:	c3                   	ret    
     aa5:	8d 76 00             	lea    0x0(%esi),%esi
    for(i=0; ecmd->argv[i]; i++)
     aa8:	8b 4b 04             	mov    0x4(%ebx),%ecx
     aab:	8d 43 08             	lea    0x8(%ebx),%eax
     aae:	85 c9                	test   %ecx,%ecx
     ab0:	74 16                	je     ac8 <nulterminate+0x88>
     ab2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      *ecmd->eargv[i] = 0;
     ab8:	8b 50 24             	mov    0x24(%eax),%edx
     abb:	83 c0 04             	add    $0x4,%eax
     abe:	c6 02 00             	movb   $0x0,(%edx)
    for(i=0; ecmd->argv[i]; i++)
     ac1:	8b 50 fc             	mov    -0x4(%eax),%edx
     ac4:	85 d2                	test   %edx,%edx
     ac6:	75 f0                	jne    ab8 <nulterminate+0x78>
  switch(cmd->type){
     ac8:	89 d8                	mov    %ebx,%eax
}
     aca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     acd:	c9                   	leave  
     ace:	c3                   	ret    
     acf:	90                   	nop
    nulterminate(rcmd->cmd);
     ad0:	83 ec 0c             	sub    $0xc,%esp
     ad3:	ff 73 04             	pushl  0x4(%ebx)
     ad6:	e8 65 ff ff ff       	call   a40 <nulterminate>
    *rcmd->efile = 0;
     adb:	8b 43 0c             	mov    0xc(%ebx),%eax
    break;
     ade:	83 c4 10             	add    $0x10,%esp
    *rcmd->efile = 0;
     ae1:	c6 00 00             	movb   $0x0,(%eax)
    break;
     ae4:	89 d8                	mov    %ebx,%eax
}
     ae6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     ae9:	c9                   	leave  
     aea:	c3                   	ret    
     aeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     aef:	90                   	nop
    return 0;
     af0:	31 c0                	xor    %eax,%eax
     af2:	eb 8d                	jmp    a81 <nulterminate+0x41>
     af4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     afb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     aff:	90                   	nop

00000b00 <parsecmd>:
{
     b00:	f3 0f 1e fb          	endbr32 
     b04:	55                   	push   %ebp
     b05:	89 e5                	mov    %esp,%ebp
     b07:	56                   	push   %esi
     b08:	53                   	push   %ebx
  es = s + strlen(s);
     b09:	8b 5d 08             	mov    0x8(%ebp),%ebx
     b0c:	83 ec 0c             	sub    $0xc,%esp
     b0f:	53                   	push   %ebx
     b10:	e8 db 00 00 00       	call   bf0 <strlen>
  cmd = parseline(&s, es);
     b15:	59                   	pop    %ecx
     b16:	5e                   	pop    %esi
  es = s + strlen(s);
     b17:	01 c3                	add    %eax,%ebx
  cmd = parseline(&s, es);
     b19:	8d 45 08             	lea    0x8(%ebp),%eax
     b1c:	53                   	push   %ebx
     b1d:	50                   	push   %eax
     b1e:	e8 dd fd ff ff       	call   900 <parseline>
  peek(&s, es, "");
     b23:	83 c4 0c             	add    $0xc,%esp
  cmd = parseline(&s, es);
     b26:	89 c6                	mov    %eax,%esi
  peek(&s, es, "");
     b28:	8d 45 08             	lea    0x8(%ebp),%eax
     b2b:	68 d1 12 00 00       	push   $0x12d1
     b30:	53                   	push   %ebx
     b31:	50                   	push   %eax
     b32:	e8 19 fb ff ff       	call   650 <peek>
  if(s != es){
     b37:	8b 45 08             	mov    0x8(%ebp),%eax
     b3a:	83 c4 10             	add    $0x10,%esp
     b3d:	39 d8                	cmp    %ebx,%eax
     b3f:	75 12                	jne    b53 <parsecmd+0x53>
  nulterminate(cmd);
     b41:	83 ec 0c             	sub    $0xc,%esp
     b44:	56                   	push   %esi
     b45:	e8 f6 fe ff ff       	call   a40 <nulterminate>
}
     b4a:	8d 65 f8             	lea    -0x8(%ebp),%esp
     b4d:	89 f0                	mov    %esi,%eax
     b4f:	5b                   	pop    %ebx
     b50:	5e                   	pop    %esi
     b51:	5d                   	pop    %ebp
     b52:	c3                   	ret    
    printf(2, "leftovers: %s\n", s);
     b53:	52                   	push   %edx
     b54:	50                   	push   %eax
     b55:	68 4a 13 00 00       	push   $0x134a
     b5a:	6a 02                	push   $0x2
     b5c:	e8 ef 03 00 00       	call   f50 <printf>
    panic("syntax");
     b61:	c7 04 24 0e 13 00 00 	movl   $0x130e,(%esp)
     b68:	e8 03 f6 ff ff       	call   170 <panic>
     b6d:	66 90                	xchg   %ax,%ax
     b6f:	90                   	nop

00000b70 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
     b70:	f3 0f 1e fb          	endbr32 
     b74:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     b75:	31 c0                	xor    %eax,%eax
{
     b77:	89 e5                	mov    %esp,%ebp
     b79:	53                   	push   %ebx
     b7a:	8b 4d 08             	mov    0x8(%ebp),%ecx
     b7d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
     b80:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
     b84:	88 14 01             	mov    %dl,(%ecx,%eax,1)
     b87:	83 c0 01             	add    $0x1,%eax
     b8a:	84 d2                	test   %dl,%dl
     b8c:	75 f2                	jne    b80 <strcpy+0x10>
    ;
  return os;
}
     b8e:	89 c8                	mov    %ecx,%eax
     b90:	5b                   	pop    %ebx
     b91:	5d                   	pop    %ebp
     b92:	c3                   	ret    
     b93:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000ba0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     ba0:	f3 0f 1e fb          	endbr32 
     ba4:	55                   	push   %ebp
     ba5:	89 e5                	mov    %esp,%ebp
     ba7:	53                   	push   %ebx
     ba8:	8b 4d 08             	mov    0x8(%ebp),%ecx
     bab:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
     bae:	0f b6 01             	movzbl (%ecx),%eax
     bb1:	0f b6 1a             	movzbl (%edx),%ebx
     bb4:	84 c0                	test   %al,%al
     bb6:	75 19                	jne    bd1 <strcmp+0x31>
     bb8:	eb 26                	jmp    be0 <strcmp+0x40>
     bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     bc0:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
     bc4:	83 c1 01             	add    $0x1,%ecx
     bc7:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
     bca:	0f b6 1a             	movzbl (%edx),%ebx
     bcd:	84 c0                	test   %al,%al
     bcf:	74 0f                	je     be0 <strcmp+0x40>
     bd1:	38 d8                	cmp    %bl,%al
     bd3:	74 eb                	je     bc0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
     bd5:	29 d8                	sub    %ebx,%eax
}
     bd7:	5b                   	pop    %ebx
     bd8:	5d                   	pop    %ebp
     bd9:	c3                   	ret    
     bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     be0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
     be2:	29 d8                	sub    %ebx,%eax
}
     be4:	5b                   	pop    %ebx
     be5:	5d                   	pop    %ebp
     be6:	c3                   	ret    
     be7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     bee:	66 90                	xchg   %ax,%ax

00000bf0 <strlen>:

uint
strlen(const char *s)
{
     bf0:	f3 0f 1e fb          	endbr32 
     bf4:	55                   	push   %ebp
     bf5:	89 e5                	mov    %esp,%ebp
     bf7:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
     bfa:	80 3a 00             	cmpb   $0x0,(%edx)
     bfd:	74 21                	je     c20 <strlen+0x30>
     bff:	31 c0                	xor    %eax,%eax
     c01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     c08:	83 c0 01             	add    $0x1,%eax
     c0b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
     c0f:	89 c1                	mov    %eax,%ecx
     c11:	75 f5                	jne    c08 <strlen+0x18>
    ;
  return n;
}
     c13:	89 c8                	mov    %ecx,%eax
     c15:	5d                   	pop    %ebp
     c16:	c3                   	ret    
     c17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     c1e:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
     c20:	31 c9                	xor    %ecx,%ecx
}
     c22:	5d                   	pop    %ebp
     c23:	89 c8                	mov    %ecx,%eax
     c25:	c3                   	ret    
     c26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     c2d:	8d 76 00             	lea    0x0(%esi),%esi

00000c30 <memset>:

void*
memset(void *dst, int c, uint n)
{
     c30:	f3 0f 1e fb          	endbr32 
     c34:	55                   	push   %ebp
     c35:	89 e5                	mov    %esp,%ebp
     c37:	57                   	push   %edi
     c38:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
     c3b:	8b 4d 10             	mov    0x10(%ebp),%ecx
     c3e:	8b 45 0c             	mov    0xc(%ebp),%eax
     c41:	89 d7                	mov    %edx,%edi
     c43:	fc                   	cld    
     c44:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
     c46:	89 d0                	mov    %edx,%eax
     c48:	5f                   	pop    %edi
     c49:	5d                   	pop    %ebp
     c4a:	c3                   	ret    
     c4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     c4f:	90                   	nop

00000c50 <strchr>:

char*
strchr(const char *s, char c)
{
     c50:	f3 0f 1e fb          	endbr32 
     c54:	55                   	push   %ebp
     c55:	89 e5                	mov    %esp,%ebp
     c57:	8b 45 08             	mov    0x8(%ebp),%eax
     c5a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
     c5e:	0f b6 10             	movzbl (%eax),%edx
     c61:	84 d2                	test   %dl,%dl
     c63:	75 16                	jne    c7b <strchr+0x2b>
     c65:	eb 21                	jmp    c88 <strchr+0x38>
     c67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     c6e:	66 90                	xchg   %ax,%ax
     c70:	0f b6 50 01          	movzbl 0x1(%eax),%edx
     c74:	83 c0 01             	add    $0x1,%eax
     c77:	84 d2                	test   %dl,%dl
     c79:	74 0d                	je     c88 <strchr+0x38>
    if(*s == c)
     c7b:	38 d1                	cmp    %dl,%cl
     c7d:	75 f1                	jne    c70 <strchr+0x20>
      return (char*)s;
  return 0;
}
     c7f:	5d                   	pop    %ebp
     c80:	c3                   	ret    
     c81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
     c88:	31 c0                	xor    %eax,%eax
}
     c8a:	5d                   	pop    %ebp
     c8b:	c3                   	ret    
     c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000c90 <gets>:

char*
gets(char *buf, int max)
{
     c90:	f3 0f 1e fb          	endbr32 
     c94:	55                   	push   %ebp
     c95:	89 e5                	mov    %esp,%ebp
     c97:	57                   	push   %edi
     c98:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c99:	31 f6                	xor    %esi,%esi
{
     c9b:	53                   	push   %ebx
     c9c:	89 f3                	mov    %esi,%ebx
     c9e:	83 ec 1c             	sub    $0x1c,%esp
     ca1:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
     ca4:	eb 33                	jmp    cd9 <gets+0x49>
     ca6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     cad:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
     cb0:	83 ec 04             	sub    $0x4,%esp
     cb3:	8d 45 e7             	lea    -0x19(%ebp),%eax
     cb6:	6a 01                	push   $0x1
     cb8:	50                   	push   %eax
     cb9:	6a 00                	push   $0x0
     cbb:	e8 2b 01 00 00       	call   deb <read>
    if(cc < 1)
     cc0:	83 c4 10             	add    $0x10,%esp
     cc3:	85 c0                	test   %eax,%eax
     cc5:	7e 1c                	jle    ce3 <gets+0x53>
      break;
    buf[i++] = c;
     cc7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
     ccb:	83 c7 01             	add    $0x1,%edi
     cce:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
     cd1:	3c 0a                	cmp    $0xa,%al
     cd3:	74 23                	je     cf8 <gets+0x68>
     cd5:	3c 0d                	cmp    $0xd,%al
     cd7:	74 1f                	je     cf8 <gets+0x68>
  for(i=0; i+1 < max; ){
     cd9:	83 c3 01             	add    $0x1,%ebx
     cdc:	89 fe                	mov    %edi,%esi
     cde:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
     ce1:	7c cd                	jl     cb0 <gets+0x20>
     ce3:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
     ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
     ce8:	c6 03 00             	movb   $0x0,(%ebx)
}
     ceb:	8d 65 f4             	lea    -0xc(%ebp),%esp
     cee:	5b                   	pop    %ebx
     cef:	5e                   	pop    %esi
     cf0:	5f                   	pop    %edi
     cf1:	5d                   	pop    %ebp
     cf2:	c3                   	ret    
     cf3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     cf7:	90                   	nop
     cf8:	8b 75 08             	mov    0x8(%ebp),%esi
     cfb:	8b 45 08             	mov    0x8(%ebp),%eax
     cfe:	01 de                	add    %ebx,%esi
     d00:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
     d02:	c6 03 00             	movb   $0x0,(%ebx)
}
     d05:	8d 65 f4             	lea    -0xc(%ebp),%esp
     d08:	5b                   	pop    %ebx
     d09:	5e                   	pop    %esi
     d0a:	5f                   	pop    %edi
     d0b:	5d                   	pop    %ebp
     d0c:	c3                   	ret    
     d0d:	8d 76 00             	lea    0x0(%esi),%esi

00000d10 <stat>:

int
stat(const char *n, struct stat *st)
{
     d10:	f3 0f 1e fb          	endbr32 
     d14:	55                   	push   %ebp
     d15:	89 e5                	mov    %esp,%ebp
     d17:	56                   	push   %esi
     d18:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     d19:	83 ec 08             	sub    $0x8,%esp
     d1c:	6a 00                	push   $0x0
     d1e:	ff 75 08             	pushl  0x8(%ebp)
     d21:	e8 ed 00 00 00       	call   e13 <open>
  if(fd < 0)
     d26:	83 c4 10             	add    $0x10,%esp
     d29:	85 c0                	test   %eax,%eax
     d2b:	78 2b                	js     d58 <stat+0x48>
    return -1;
  r = fstat(fd, st);
     d2d:	83 ec 08             	sub    $0x8,%esp
     d30:	ff 75 0c             	pushl  0xc(%ebp)
     d33:	89 c3                	mov    %eax,%ebx
     d35:	50                   	push   %eax
     d36:	e8 f0 00 00 00       	call   e2b <fstat>
  close(fd);
     d3b:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
     d3e:	89 c6                	mov    %eax,%esi
  close(fd);
     d40:	e8 b6 00 00 00       	call   dfb <close>
  return r;
     d45:	83 c4 10             	add    $0x10,%esp
}
     d48:	8d 65 f8             	lea    -0x8(%ebp),%esp
     d4b:	89 f0                	mov    %esi,%eax
     d4d:	5b                   	pop    %ebx
     d4e:	5e                   	pop    %esi
     d4f:	5d                   	pop    %ebp
     d50:	c3                   	ret    
     d51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
     d58:	be ff ff ff ff       	mov    $0xffffffff,%esi
     d5d:	eb e9                	jmp    d48 <stat+0x38>
     d5f:	90                   	nop

00000d60 <atoi>:

int
atoi(const char *s)
{
     d60:	f3 0f 1e fb          	endbr32 
     d64:	55                   	push   %ebp
     d65:	89 e5                	mov    %esp,%ebp
     d67:	53                   	push   %ebx
     d68:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     d6b:	0f be 02             	movsbl (%edx),%eax
     d6e:	8d 48 d0             	lea    -0x30(%eax),%ecx
     d71:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
     d74:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
     d79:	77 1a                	ja     d95 <atoi+0x35>
     d7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     d7f:	90                   	nop
    n = n*10 + *s++ - '0';
     d80:	83 c2 01             	add    $0x1,%edx
     d83:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
     d86:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
     d8a:	0f be 02             	movsbl (%edx),%eax
     d8d:	8d 58 d0             	lea    -0x30(%eax),%ebx
     d90:	80 fb 09             	cmp    $0x9,%bl
     d93:	76 eb                	jbe    d80 <atoi+0x20>
  return n;
}
     d95:	89 c8                	mov    %ecx,%eax
     d97:	5b                   	pop    %ebx
     d98:	5d                   	pop    %ebp
     d99:	c3                   	ret    
     d9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000da0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     da0:	f3 0f 1e fb          	endbr32 
     da4:	55                   	push   %ebp
     da5:	89 e5                	mov    %esp,%ebp
     da7:	57                   	push   %edi
     da8:	8b 45 10             	mov    0x10(%ebp),%eax
     dab:	8b 55 08             	mov    0x8(%ebp),%edx
     dae:	56                   	push   %esi
     daf:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     db2:	85 c0                	test   %eax,%eax
     db4:	7e 0f                	jle    dc5 <memmove+0x25>
     db6:	01 d0                	add    %edx,%eax
  dst = vdst;
     db8:	89 d7                	mov    %edx,%edi
     dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
     dc0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
     dc1:	39 f8                	cmp    %edi,%eax
     dc3:	75 fb                	jne    dc0 <memmove+0x20>
  return vdst;
}
     dc5:	5e                   	pop    %esi
     dc6:	89 d0                	mov    %edx,%eax
     dc8:	5f                   	pop    %edi
     dc9:	5d                   	pop    %ebp
     dca:	c3                   	ret    

00000dcb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     dcb:	b8 01 00 00 00       	mov    $0x1,%eax
     dd0:	cd 40                	int    $0x40
     dd2:	c3                   	ret    

00000dd3 <exit>:
SYSCALL(exit)
     dd3:	b8 02 00 00 00       	mov    $0x2,%eax
     dd8:	cd 40                	int    $0x40
     dda:	c3                   	ret    

00000ddb <wait>:
SYSCALL(wait)
     ddb:	b8 03 00 00 00       	mov    $0x3,%eax
     de0:	cd 40                	int    $0x40
     de2:	c3                   	ret    

00000de3 <pipe>:
SYSCALL(pipe)
     de3:	b8 04 00 00 00       	mov    $0x4,%eax
     de8:	cd 40                	int    $0x40
     dea:	c3                   	ret    

00000deb <read>:
SYSCALL(read)
     deb:	b8 05 00 00 00       	mov    $0x5,%eax
     df0:	cd 40                	int    $0x40
     df2:	c3                   	ret    

00000df3 <write>:
SYSCALL(write)
     df3:	b8 10 00 00 00       	mov    $0x10,%eax
     df8:	cd 40                	int    $0x40
     dfa:	c3                   	ret    

00000dfb <close>:
SYSCALL(close)
     dfb:	b8 15 00 00 00       	mov    $0x15,%eax
     e00:	cd 40                	int    $0x40
     e02:	c3                   	ret    

00000e03 <kill>:
SYSCALL(kill)
     e03:	b8 06 00 00 00       	mov    $0x6,%eax
     e08:	cd 40                	int    $0x40
     e0a:	c3                   	ret    

00000e0b <exec>:
SYSCALL(exec)
     e0b:	b8 07 00 00 00       	mov    $0x7,%eax
     e10:	cd 40                	int    $0x40
     e12:	c3                   	ret    

00000e13 <open>:
SYSCALL(open)
     e13:	b8 0f 00 00 00       	mov    $0xf,%eax
     e18:	cd 40                	int    $0x40
     e1a:	c3                   	ret    

00000e1b <mknod>:
SYSCALL(mknod)
     e1b:	b8 11 00 00 00       	mov    $0x11,%eax
     e20:	cd 40                	int    $0x40
     e22:	c3                   	ret    

00000e23 <unlink>:
SYSCALL(unlink)
     e23:	b8 12 00 00 00       	mov    $0x12,%eax
     e28:	cd 40                	int    $0x40
     e2a:	c3                   	ret    

00000e2b <fstat>:
SYSCALL(fstat)
     e2b:	b8 08 00 00 00       	mov    $0x8,%eax
     e30:	cd 40                	int    $0x40
     e32:	c3                   	ret    

00000e33 <link>:
SYSCALL(link)
     e33:	b8 13 00 00 00       	mov    $0x13,%eax
     e38:	cd 40                	int    $0x40
     e3a:	c3                   	ret    

00000e3b <mkdir>:
SYSCALL(mkdir)
     e3b:	b8 14 00 00 00       	mov    $0x14,%eax
     e40:	cd 40                	int    $0x40
     e42:	c3                   	ret    

00000e43 <chdir>:
SYSCALL(chdir)
     e43:	b8 09 00 00 00       	mov    $0x9,%eax
     e48:	cd 40                	int    $0x40
     e4a:	c3                   	ret    

00000e4b <dup>:
SYSCALL(dup)
     e4b:	b8 0a 00 00 00       	mov    $0xa,%eax
     e50:	cd 40                	int    $0x40
     e52:	c3                   	ret    

00000e53 <getpid>:
SYSCALL(getpid)
     e53:	b8 0b 00 00 00       	mov    $0xb,%eax
     e58:	cd 40                	int    $0x40
     e5a:	c3                   	ret    

00000e5b <sbrk>:
SYSCALL(sbrk)
     e5b:	b8 0c 00 00 00       	mov    $0xc,%eax
     e60:	cd 40                	int    $0x40
     e62:	c3                   	ret    

00000e63 <sleep>:
SYSCALL(sleep)
     e63:	b8 0d 00 00 00       	mov    $0xd,%eax
     e68:	cd 40                	int    $0x40
     e6a:	c3                   	ret    

00000e6b <uptime>:
SYSCALL(uptime)
     e6b:	b8 0e 00 00 00       	mov    $0xe,%eax
     e70:	cd 40                	int    $0x40
     e72:	c3                   	ret    

00000e73 <memsize>:
SYSCALL(memsize)
     e73:	b8 16 00 00 00       	mov    $0x16,%eax
     e78:	cd 40                	int    $0x40
     e7a:	c3                   	ret    

00000e7b <set_ps_priority>:
SYSCALL(set_ps_priority)
     e7b:	b8 17 00 00 00       	mov    $0x17,%eax
     e80:	cd 40                	int    $0x40
     e82:	c3                   	ret    

00000e83 <policy>:
SYSCALL(policy)
     e83:	b8 18 00 00 00       	mov    $0x18,%eax
     e88:	cd 40                	int    $0x40
     e8a:	c3                   	ret    

00000e8b <set_cfs_priority>:
SYSCALL(set_cfs_priority)
     e8b:	b8 19 00 00 00       	mov    $0x19,%eax
     e90:	cd 40                	int    $0x40
     e92:	c3                   	ret    

00000e93 <proc_info>:
SYSCALL(proc_info)
     e93:	b8 1a 00 00 00       	mov    $0x1a,%eax
     e98:	cd 40                	int    $0x40
     e9a:	c3                   	ret    
     e9b:	66 90                	xchg   %ax,%ax
     e9d:	66 90                	xchg   %ax,%ax
     e9f:	90                   	nop

00000ea0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
     ea0:	55                   	push   %ebp
     ea1:	89 e5                	mov    %esp,%ebp
     ea3:	57                   	push   %edi
     ea4:	56                   	push   %esi
     ea5:	53                   	push   %ebx
     ea6:	83 ec 3c             	sub    $0x3c,%esp
     ea9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
     eac:	89 d1                	mov    %edx,%ecx
{
     eae:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
     eb1:	85 d2                	test   %edx,%edx
     eb3:	0f 89 7f 00 00 00    	jns    f38 <printint+0x98>
     eb9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
     ebd:	74 79                	je     f38 <printint+0x98>
    neg = 1;
     ebf:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
     ec6:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
     ec8:	31 db                	xor    %ebx,%ebx
     eca:	8d 75 d7             	lea    -0x29(%ebp),%esi
     ecd:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
     ed0:	89 c8                	mov    %ecx,%eax
     ed2:	31 d2                	xor    %edx,%edx
     ed4:	89 cf                	mov    %ecx,%edi
     ed6:	f7 75 c4             	divl   -0x3c(%ebp)
     ed9:	0f b6 92 a8 13 00 00 	movzbl 0x13a8(%edx),%edx
     ee0:	89 45 c0             	mov    %eax,-0x40(%ebp)
     ee3:	89 d8                	mov    %ebx,%eax
     ee5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
     ee8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
     eeb:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
     eee:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
     ef1:	76 dd                	jbe    ed0 <printint+0x30>
  if(neg)
     ef3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
     ef6:	85 c9                	test   %ecx,%ecx
     ef8:	74 0c                	je     f06 <printint+0x66>
    buf[i++] = '-';
     efa:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
     eff:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
     f01:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
     f06:	8b 7d b8             	mov    -0x48(%ebp),%edi
     f09:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
     f0d:	eb 07                	jmp    f16 <printint+0x76>
     f0f:	90                   	nop
     f10:	0f b6 13             	movzbl (%ebx),%edx
     f13:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
     f16:	83 ec 04             	sub    $0x4,%esp
     f19:	88 55 d7             	mov    %dl,-0x29(%ebp)
     f1c:	6a 01                	push   $0x1
     f1e:	56                   	push   %esi
     f1f:	57                   	push   %edi
     f20:	e8 ce fe ff ff       	call   df3 <write>
  while(--i >= 0)
     f25:	83 c4 10             	add    $0x10,%esp
     f28:	39 de                	cmp    %ebx,%esi
     f2a:	75 e4                	jne    f10 <printint+0x70>
    putc(fd, buf[i]);
}
     f2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
     f2f:	5b                   	pop    %ebx
     f30:	5e                   	pop    %esi
     f31:	5f                   	pop    %edi
     f32:	5d                   	pop    %ebp
     f33:	c3                   	ret    
     f34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
     f38:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
     f3f:	eb 87                	jmp    ec8 <printint+0x28>
     f41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     f48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     f4f:	90                   	nop

00000f50 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
     f50:	f3 0f 1e fb          	endbr32 
     f54:	55                   	push   %ebp
     f55:	89 e5                	mov    %esp,%ebp
     f57:	57                   	push   %edi
     f58:	56                   	push   %esi
     f59:	53                   	push   %ebx
     f5a:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     f5d:	8b 75 0c             	mov    0xc(%ebp),%esi
     f60:	0f b6 1e             	movzbl (%esi),%ebx
     f63:	84 db                	test   %bl,%bl
     f65:	0f 84 b4 00 00 00    	je     101f <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
     f6b:	8d 45 10             	lea    0x10(%ebp),%eax
     f6e:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
     f71:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
     f74:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
     f76:	89 45 d0             	mov    %eax,-0x30(%ebp)
     f79:	eb 33                	jmp    fae <printf+0x5e>
     f7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     f7f:	90                   	nop
     f80:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
     f83:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
     f88:	83 f8 25             	cmp    $0x25,%eax
     f8b:	74 17                	je     fa4 <printf+0x54>
  write(fd, &c, 1);
     f8d:	83 ec 04             	sub    $0x4,%esp
     f90:	88 5d e7             	mov    %bl,-0x19(%ebp)
     f93:	6a 01                	push   $0x1
     f95:	57                   	push   %edi
     f96:	ff 75 08             	pushl  0x8(%ebp)
     f99:	e8 55 fe ff ff       	call   df3 <write>
     f9e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
     fa1:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
     fa4:	0f b6 1e             	movzbl (%esi),%ebx
     fa7:	83 c6 01             	add    $0x1,%esi
     faa:	84 db                	test   %bl,%bl
     fac:	74 71                	je     101f <printf+0xcf>
    c = fmt[i] & 0xff;
     fae:	0f be cb             	movsbl %bl,%ecx
     fb1:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
     fb4:	85 d2                	test   %edx,%edx
     fb6:	74 c8                	je     f80 <printf+0x30>
      }
    } else if(state == '%'){
     fb8:	83 fa 25             	cmp    $0x25,%edx
     fbb:	75 e7                	jne    fa4 <printf+0x54>
      if(c == 'd'){
     fbd:	83 f8 64             	cmp    $0x64,%eax
     fc0:	0f 84 9a 00 00 00    	je     1060 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
     fc6:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
     fcc:	83 f9 70             	cmp    $0x70,%ecx
     fcf:	74 5f                	je     1030 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
     fd1:	83 f8 73             	cmp    $0x73,%eax
     fd4:	0f 84 d6 00 00 00    	je     10b0 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     fda:	83 f8 63             	cmp    $0x63,%eax
     fdd:	0f 84 8d 00 00 00    	je     1070 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
     fe3:	83 f8 25             	cmp    $0x25,%eax
     fe6:	0f 84 b4 00 00 00    	je     10a0 <printf+0x150>
  write(fd, &c, 1);
     fec:	83 ec 04             	sub    $0x4,%esp
     fef:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
     ff3:	6a 01                	push   $0x1
     ff5:	57                   	push   %edi
     ff6:	ff 75 08             	pushl  0x8(%ebp)
     ff9:	e8 f5 fd ff ff       	call   df3 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
     ffe:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
    1001:	83 c4 0c             	add    $0xc,%esp
    1004:	6a 01                	push   $0x1
    1006:	83 c6 01             	add    $0x1,%esi
    1009:	57                   	push   %edi
    100a:	ff 75 08             	pushl  0x8(%ebp)
    100d:	e8 e1 fd ff ff       	call   df3 <write>
  for(i = 0; fmt[i]; i++){
    1012:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
    1016:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    1019:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
    101b:	84 db                	test   %bl,%bl
    101d:	75 8f                	jne    fae <printf+0x5e>
    }
  }
}
    101f:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1022:	5b                   	pop    %ebx
    1023:	5e                   	pop    %esi
    1024:	5f                   	pop    %edi
    1025:	5d                   	pop    %ebp
    1026:	c3                   	ret    
    1027:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    102e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
    1030:	83 ec 0c             	sub    $0xc,%esp
    1033:	b9 10 00 00 00       	mov    $0x10,%ecx
    1038:	6a 00                	push   $0x0
    103a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
    103d:	8b 45 08             	mov    0x8(%ebp),%eax
    1040:	8b 13                	mov    (%ebx),%edx
    1042:	e8 59 fe ff ff       	call   ea0 <printint>
        ap++;
    1047:	89 d8                	mov    %ebx,%eax
    1049:	83 c4 10             	add    $0x10,%esp
      state = 0;
    104c:	31 d2                	xor    %edx,%edx
        ap++;
    104e:	83 c0 04             	add    $0x4,%eax
    1051:	89 45 d0             	mov    %eax,-0x30(%ebp)
    1054:	e9 4b ff ff ff       	jmp    fa4 <printf+0x54>
    1059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
    1060:	83 ec 0c             	sub    $0xc,%esp
    1063:	b9 0a 00 00 00       	mov    $0xa,%ecx
    1068:	6a 01                	push   $0x1
    106a:	eb ce                	jmp    103a <printf+0xea>
    106c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
    1070:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
    1073:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
    1076:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
    1078:	6a 01                	push   $0x1
        ap++;
    107a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
    107d:	57                   	push   %edi
    107e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
    1081:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    1084:	e8 6a fd ff ff       	call   df3 <write>
        ap++;
    1089:	89 5d d0             	mov    %ebx,-0x30(%ebp)
    108c:	83 c4 10             	add    $0x10,%esp
      state = 0;
    108f:	31 d2                	xor    %edx,%edx
    1091:	e9 0e ff ff ff       	jmp    fa4 <printf+0x54>
    1096:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    109d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
    10a0:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
    10a3:	83 ec 04             	sub    $0x4,%esp
    10a6:	e9 59 ff ff ff       	jmp    1004 <printf+0xb4>
    10ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    10af:	90                   	nop
        s = (char*)*ap;
    10b0:	8b 45 d0             	mov    -0x30(%ebp),%eax
    10b3:	8b 18                	mov    (%eax),%ebx
        ap++;
    10b5:	83 c0 04             	add    $0x4,%eax
    10b8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
    10bb:	85 db                	test   %ebx,%ebx
    10bd:	74 17                	je     10d6 <printf+0x186>
        while(*s != 0){
    10bf:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
    10c2:	31 d2                	xor    %edx,%edx
        while(*s != 0){
    10c4:	84 c0                	test   %al,%al
    10c6:	0f 84 d8 fe ff ff    	je     fa4 <printf+0x54>
    10cc:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    10cf:	89 de                	mov    %ebx,%esi
    10d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
    10d4:	eb 1a                	jmp    10f0 <printf+0x1a0>
          s = "(null)";
    10d6:	bb a0 13 00 00       	mov    $0x13a0,%ebx
        while(*s != 0){
    10db:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    10de:	b8 28 00 00 00       	mov    $0x28,%eax
    10e3:	89 de                	mov    %ebx,%esi
    10e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
    10e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    10ef:	90                   	nop
  write(fd, &c, 1);
    10f0:	83 ec 04             	sub    $0x4,%esp
          s++;
    10f3:	83 c6 01             	add    $0x1,%esi
    10f6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    10f9:	6a 01                	push   $0x1
    10fb:	57                   	push   %edi
    10fc:	53                   	push   %ebx
    10fd:	e8 f1 fc ff ff       	call   df3 <write>
        while(*s != 0){
    1102:	0f b6 06             	movzbl (%esi),%eax
    1105:	83 c4 10             	add    $0x10,%esp
    1108:	84 c0                	test   %al,%al
    110a:	75 e4                	jne    10f0 <printf+0x1a0>
    110c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
    110f:	31 d2                	xor    %edx,%edx
    1111:	e9 8e fe ff ff       	jmp    fa4 <printf+0x54>
    1116:	66 90                	xchg   %ax,%ax
    1118:	66 90                	xchg   %ax,%ax
    111a:	66 90                	xchg   %ax,%ax
    111c:	66 90                	xchg   %ax,%ax
    111e:	66 90                	xchg   %ax,%ax

00001120 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1120:	f3 0f 1e fb          	endbr32 
    1124:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1125:	a1 04 1a 00 00       	mov    0x1a04,%eax
{
    112a:	89 e5                	mov    %esp,%ebp
    112c:	57                   	push   %edi
    112d:	56                   	push   %esi
    112e:	53                   	push   %ebx
    112f:	8b 5d 08             	mov    0x8(%ebp),%ebx
    1132:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
    1134:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1137:	39 c8                	cmp    %ecx,%eax
    1139:	73 15                	jae    1150 <free+0x30>
    113b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    113f:	90                   	nop
    1140:	39 d1                	cmp    %edx,%ecx
    1142:	72 14                	jb     1158 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1144:	39 d0                	cmp    %edx,%eax
    1146:	73 10                	jae    1158 <free+0x38>
{
    1148:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    114a:	8b 10                	mov    (%eax),%edx
    114c:	39 c8                	cmp    %ecx,%eax
    114e:	72 f0                	jb     1140 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1150:	39 d0                	cmp    %edx,%eax
    1152:	72 f4                	jb     1148 <free+0x28>
    1154:	39 d1                	cmp    %edx,%ecx
    1156:	73 f0                	jae    1148 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1158:	8b 73 fc             	mov    -0x4(%ebx),%esi
    115b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    115e:	39 fa                	cmp    %edi,%edx
    1160:	74 1e                	je     1180 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    1162:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    1165:	8b 50 04             	mov    0x4(%eax),%edx
    1168:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    116b:	39 f1                	cmp    %esi,%ecx
    116d:	74 28                	je     1197 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    116f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
    1171:	5b                   	pop    %ebx
  freep = p;
    1172:	a3 04 1a 00 00       	mov    %eax,0x1a04
}
    1177:	5e                   	pop    %esi
    1178:	5f                   	pop    %edi
    1179:	5d                   	pop    %ebp
    117a:	c3                   	ret    
    117b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    117f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
    1180:	03 72 04             	add    0x4(%edx),%esi
    1183:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    1186:	8b 10                	mov    (%eax),%edx
    1188:	8b 12                	mov    (%edx),%edx
    118a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    118d:	8b 50 04             	mov    0x4(%eax),%edx
    1190:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    1193:	39 f1                	cmp    %esi,%ecx
    1195:	75 d8                	jne    116f <free+0x4f>
    p->s.size += bp->s.size;
    1197:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
    119a:	a3 04 1a 00 00       	mov    %eax,0x1a04
    p->s.size += bp->s.size;
    119f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    11a2:	8b 53 f8             	mov    -0x8(%ebx),%edx
    11a5:	89 10                	mov    %edx,(%eax)
}
    11a7:	5b                   	pop    %ebx
    11a8:	5e                   	pop    %esi
    11a9:	5f                   	pop    %edi
    11aa:	5d                   	pop    %ebp
    11ab:	c3                   	ret    
    11ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000011b0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    11b0:	f3 0f 1e fb          	endbr32 
    11b4:	55                   	push   %ebp
    11b5:	89 e5                	mov    %esp,%ebp
    11b7:	57                   	push   %edi
    11b8:	56                   	push   %esi
    11b9:	53                   	push   %ebx
    11ba:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    11bd:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    11c0:	8b 3d 04 1a 00 00    	mov    0x1a04,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    11c6:	8d 70 07             	lea    0x7(%eax),%esi
    11c9:	c1 ee 03             	shr    $0x3,%esi
    11cc:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
    11cf:	85 ff                	test   %edi,%edi
    11d1:	0f 84 a9 00 00 00    	je     1280 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    11d7:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
    11d9:	8b 48 04             	mov    0x4(%eax),%ecx
    11dc:	39 f1                	cmp    %esi,%ecx
    11de:	73 6d                	jae    124d <malloc+0x9d>
    11e0:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
    11e6:	bb 00 10 00 00       	mov    $0x1000,%ebx
    11eb:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
    11ee:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
    11f5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    11f8:	eb 17                	jmp    1211 <malloc+0x61>
    11fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1200:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
    1202:	8b 4a 04             	mov    0x4(%edx),%ecx
    1205:	39 f1                	cmp    %esi,%ecx
    1207:	73 4f                	jae    1258 <malloc+0xa8>
    1209:	8b 3d 04 1a 00 00    	mov    0x1a04,%edi
    120f:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1211:	39 c7                	cmp    %eax,%edi
    1213:	75 eb                	jne    1200 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
    1215:	83 ec 0c             	sub    $0xc,%esp
    1218:	ff 75 e4             	pushl  -0x1c(%ebp)
    121b:	e8 3b fc ff ff       	call   e5b <sbrk>
  if(p == (char*)-1)
    1220:	83 c4 10             	add    $0x10,%esp
    1223:	83 f8 ff             	cmp    $0xffffffff,%eax
    1226:	74 1b                	je     1243 <malloc+0x93>
  hp->s.size = nu;
    1228:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    122b:	83 ec 0c             	sub    $0xc,%esp
    122e:	83 c0 08             	add    $0x8,%eax
    1231:	50                   	push   %eax
    1232:	e8 e9 fe ff ff       	call   1120 <free>
  return freep;
    1237:	a1 04 1a 00 00       	mov    0x1a04,%eax
      if((p = morecore(nunits)) == 0)
    123c:	83 c4 10             	add    $0x10,%esp
    123f:	85 c0                	test   %eax,%eax
    1241:	75 bd                	jne    1200 <malloc+0x50>
        return 0;
  }
}
    1243:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
    1246:	31 c0                	xor    %eax,%eax
}
    1248:	5b                   	pop    %ebx
    1249:	5e                   	pop    %esi
    124a:	5f                   	pop    %edi
    124b:	5d                   	pop    %ebp
    124c:	c3                   	ret    
    if(p->s.size >= nunits){
    124d:	89 c2                	mov    %eax,%edx
    124f:	89 f8                	mov    %edi,%eax
    1251:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
    1258:	39 ce                	cmp    %ecx,%esi
    125a:	74 54                	je     12b0 <malloc+0x100>
        p->s.size -= nunits;
    125c:	29 f1                	sub    %esi,%ecx
    125e:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
    1261:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
    1264:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
    1267:	a3 04 1a 00 00       	mov    %eax,0x1a04
}
    126c:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
    126f:	8d 42 08             	lea    0x8(%edx),%eax
}
    1272:	5b                   	pop    %ebx
    1273:	5e                   	pop    %esi
    1274:	5f                   	pop    %edi
    1275:	5d                   	pop    %ebp
    1276:	c3                   	ret    
    1277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    127e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
    1280:	c7 05 04 1a 00 00 08 	movl   $0x1a08,0x1a04
    1287:	1a 00 00 
    base.s.size = 0;
    128a:	bf 08 1a 00 00       	mov    $0x1a08,%edi
    base.s.ptr = freep = prevp = &base;
    128f:	c7 05 08 1a 00 00 08 	movl   $0x1a08,0x1a08
    1296:	1a 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1299:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
    129b:	c7 05 0c 1a 00 00 00 	movl   $0x0,0x1a0c
    12a2:	00 00 00 
    if(p->s.size >= nunits){
    12a5:	e9 36 ff ff ff       	jmp    11e0 <malloc+0x30>
    12aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
    12b0:	8b 0a                	mov    (%edx),%ecx
    12b2:	89 08                	mov    %ecx,(%eax)
    12b4:	eb b1                	jmp    1267 <malloc+0xb7>
