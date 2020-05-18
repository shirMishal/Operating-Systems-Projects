
_usertests:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  return randstate;
}

int
main(int argc, char *argv[])
{
       0:	f3 0f 1e fb          	endbr32 
       4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
       8:	83 e4 f0             	and    $0xfffffff0,%esp
       b:	ff 71 fc             	pushl  -0x4(%ecx)
       e:	55                   	push   %ebp
       f:	89 e5                	mov    %esp,%ebp
      11:	51                   	push   %ecx
      12:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "usertests starting!!!\n");
      15:	68 26 4e 00 00       	push   $0x4e26
      1a:	6a 01                	push   $0x1
      1c:	e8 af 3a 00 00       	call   3ad0 <printf>

  // if(open("usertests.ran", 0) >= 0){
  //   printf(1, "already ran user tests -- rebuild fs.img\n");
  //   exit();
  // }
  close(open("usertests.ran", O_CREATE));
      21:	58                   	pop    %eax
      22:	5a                   	pop    %edx
      23:	68 00 02 00 00       	push   $0x200
      28:	68 3d 4e 00 00       	push   $0x4e3d
      2d:	e8 71 39 00 00       	call   39a3 <open>
      32:	89 04 24             	mov    %eax,(%esp)
      35:	e8 51 39 00 00       	call   398b <close>

  argptest();
      3a:	e8 31 36 00 00       	call   3670 <argptest>
  createdelete();
      3f:	e8 fc 11 00 00       	call   1240 <createdelete>
  linkunlink();
      44:	e8 d7 1a 00 00       	call   1b20 <linkunlink>
  concreate();
      49:	e8 d2 17 00 00       	call   1820 <concreate>
  fourfiles();
      4e:	e8 ed 0f 00 00       	call   1040 <fourfiles>
  sharedfd();
      53:	e8 28 0e 00 00       	call   e80 <sharedfd>

  bigargtest();
      58:	e8 b3 32 00 00       	call   3310 <bigargtest>
  bigwrite();
      5d:	e8 fe 23 00 00       	call   2460 <bigwrite>
  bigargtest();
      62:	e8 a9 32 00 00       	call   3310 <bigargtest>
  bsstest();
      67:	e8 34 32 00 00       	call   32a0 <bsstest>
  sbrktest();
      6c:	e8 2f 2d 00 00       	call   2da0 <sbrktest>
  validatetest();
      71:	e8 6a 31 00 00       	call   31e0 <validatetest>
  opentest();
      76:	e8 65 03 00 00       	call   3e0 <opentest>
  writetest();
      7b:	e8 00 04 00 00       	call   480 <writetest>
  writetest1();
      80:	e8 db 05 00 00       	call   660 <writetest1>
  createtest();
      85:	e8 a6 07 00 00       	call   830 <createtest>

  openiputtest();
      8a:	e8 51 02 00 00       	call   2e0 <openiputtest>
  exitiputtest();
      8f:	e8 4c 01 00 00       	call   1e0 <exitiputtest>
  iputtest();
      94:	e8 57 00 00 00       	call   f0 <iputtest>

  mem();
      99:	e8 12 0d 00 00       	call   db0 <mem>
  pipe1();
      9e:	e8 8d 09 00 00       	call   a30 <pipe1>
  preempt();
      a3:	e8 28 0b 00 00       	call   bd0 <preempt>
  exitwait();
      a8:	e8 83 0c 00 00       	call   d30 <exitwait>

  rmdot();
      ad:	e8 9e 27 00 00       	call   2850 <rmdot>
  fourteen();
      b2:	e8 59 26 00 00       	call   2710 <fourteen>
  bigfile();
      b7:	e8 84 24 00 00       	call   2540 <bigfile>
  subdir();
      bc:	e8 af 1c 00 00       	call   1d70 <subdir>
  linktest();
      c1:	e8 3a 15 00 00       	call   1600 <linktest>
  unlinkread();
      c6:	e8 a5 13 00 00       	call   1470 <unlinkread>
  dirfile();
      cb:	e8 00 29 00 00       	call   29d0 <dirfile>
  iref();
      d0:	e8 fb 2a 00 00       	call   2bd0 <iref>
  forktest();
      d5:	e8 16 2c 00 00       	call   2cf0 <forktest>
  bigdir(); // slow
      da:	e8 51 1b 00 00       	call   1c30 <bigdir>

  uio();
      df:	e8 0c 35 00 00       	call   35f0 <uio>

  exectest();
      e4:	e8 f7 08 00 00       	call   9e0 <exectest>

  exit();
      e9:	e8 75 38 00 00       	call   3963 <exit>
      ee:	66 90                	xchg   %ax,%ax

000000f0 <iputtest>:
{
      f0:	f3 0f 1e fb          	endbr32 
      f4:	55                   	push   %ebp
      f5:	89 e5                	mov    %esp,%ebp
      f7:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "iput test\n");
      fa:	68 cc 3e 00 00       	push   $0x3ecc
      ff:	ff 35 a0 5e 00 00    	pushl  0x5ea0
     105:	e8 c6 39 00 00       	call   3ad0 <printf>
  if(mkdir("iputdir") < 0){
     10a:	c7 04 24 5f 3e 00 00 	movl   $0x3e5f,(%esp)
     111:	e8 b5 38 00 00       	call   39cb <mkdir>
     116:	83 c4 10             	add    $0x10,%esp
     119:	85 c0                	test   %eax,%eax
     11b:	78 58                	js     175 <iputtest+0x85>
  if(chdir("iputdir") < 0){
     11d:	83 ec 0c             	sub    $0xc,%esp
     120:	68 5f 3e 00 00       	push   $0x3e5f
     125:	e8 a9 38 00 00       	call   39d3 <chdir>
     12a:	83 c4 10             	add    $0x10,%esp
     12d:	85 c0                	test   %eax,%eax
     12f:	0f 88 85 00 00 00    	js     1ba <iputtest+0xca>
  if(unlink("../iputdir") < 0){
     135:	83 ec 0c             	sub    $0xc,%esp
     138:	68 5c 3e 00 00       	push   $0x3e5c
     13d:	e8 71 38 00 00       	call   39b3 <unlink>
     142:	83 c4 10             	add    $0x10,%esp
     145:	85 c0                	test   %eax,%eax
     147:	78 5a                	js     1a3 <iputtest+0xb3>
  if(chdir("/") < 0){
     149:	83 ec 0c             	sub    $0xc,%esp
     14c:	68 81 3e 00 00       	push   $0x3e81
     151:	e8 7d 38 00 00       	call   39d3 <chdir>
     156:	83 c4 10             	add    $0x10,%esp
     159:	85 c0                	test   %eax,%eax
     15b:	78 2f                	js     18c <iputtest+0x9c>
  printf(stdout, "iput test ok\n");
     15d:	83 ec 08             	sub    $0x8,%esp
     160:	68 04 3f 00 00       	push   $0x3f04
     165:	ff 35 a0 5e 00 00    	pushl  0x5ea0
     16b:	e8 60 39 00 00       	call   3ad0 <printf>
}
     170:	83 c4 10             	add    $0x10,%esp
     173:	c9                   	leave  
     174:	c3                   	ret    
    printf(stdout, "mkdir failed\n");
     175:	50                   	push   %eax
     176:	50                   	push   %eax
     177:	68 38 3e 00 00       	push   $0x3e38
     17c:	ff 35 a0 5e 00 00    	pushl  0x5ea0
     182:	e8 49 39 00 00       	call   3ad0 <printf>
    exit();
     187:	e8 d7 37 00 00       	call   3963 <exit>
    printf(stdout, "chdir / failed\n");
     18c:	50                   	push   %eax
     18d:	50                   	push   %eax
     18e:	68 83 3e 00 00       	push   $0x3e83
     193:	ff 35 a0 5e 00 00    	pushl  0x5ea0
     199:	e8 32 39 00 00       	call   3ad0 <printf>
    exit();
     19e:	e8 c0 37 00 00       	call   3963 <exit>
    printf(stdout, "unlink ../iputdir failed\n");
     1a3:	52                   	push   %edx
     1a4:	52                   	push   %edx
     1a5:	68 67 3e 00 00       	push   $0x3e67
     1aa:	ff 35 a0 5e 00 00    	pushl  0x5ea0
     1b0:	e8 1b 39 00 00       	call   3ad0 <printf>
    exit();
     1b5:	e8 a9 37 00 00       	call   3963 <exit>
    printf(stdout, "chdir iputdir failed\n");
     1ba:	51                   	push   %ecx
     1bb:	51                   	push   %ecx
     1bc:	68 46 3e 00 00       	push   $0x3e46
     1c1:	ff 35 a0 5e 00 00    	pushl  0x5ea0
     1c7:	e8 04 39 00 00       	call   3ad0 <printf>
    exit();
     1cc:	e8 92 37 00 00       	call   3963 <exit>
     1d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     1d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     1df:	90                   	nop

000001e0 <exitiputtest>:
{
     1e0:	f3 0f 1e fb          	endbr32 
     1e4:	55                   	push   %ebp
     1e5:	89 e5                	mov    %esp,%ebp
     1e7:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "exitiput test\n");
     1ea:	68 93 3e 00 00       	push   $0x3e93
     1ef:	ff 35 a0 5e 00 00    	pushl  0x5ea0
     1f5:	e8 d6 38 00 00       	call   3ad0 <printf>
  pid = fork();
     1fa:	e8 5c 37 00 00       	call   395b <fork>
  if(pid < 0){
     1ff:	83 c4 10             	add    $0x10,%esp
     202:	85 c0                	test   %eax,%eax
     204:	0f 88 86 00 00 00    	js     290 <exitiputtest+0xb0>
  if(pid == 0){
     20a:	75 4c                	jne    258 <exitiputtest+0x78>
    if(mkdir("iputdir") < 0){
     20c:	83 ec 0c             	sub    $0xc,%esp
     20f:	68 5f 3e 00 00       	push   $0x3e5f
     214:	e8 b2 37 00 00       	call   39cb <mkdir>
     219:	83 c4 10             	add    $0x10,%esp
     21c:	85 c0                	test   %eax,%eax
     21e:	0f 88 83 00 00 00    	js     2a7 <exitiputtest+0xc7>
    if(chdir("iputdir") < 0){
     224:	83 ec 0c             	sub    $0xc,%esp
     227:	68 5f 3e 00 00       	push   $0x3e5f
     22c:	e8 a2 37 00 00       	call   39d3 <chdir>
     231:	83 c4 10             	add    $0x10,%esp
     234:	85 c0                	test   %eax,%eax
     236:	0f 88 82 00 00 00    	js     2be <exitiputtest+0xde>
    if(unlink("../iputdir") < 0){
     23c:	83 ec 0c             	sub    $0xc,%esp
     23f:	68 5c 3e 00 00       	push   $0x3e5c
     244:	e8 6a 37 00 00       	call   39b3 <unlink>
     249:	83 c4 10             	add    $0x10,%esp
     24c:	85 c0                	test   %eax,%eax
     24e:	78 28                	js     278 <exitiputtest+0x98>
    exit();
     250:	e8 0e 37 00 00       	call   3963 <exit>
     255:	8d 76 00             	lea    0x0(%esi),%esi
  wait();
     258:	e8 0e 37 00 00       	call   396b <wait>
  printf(stdout, "exitiput test ok\n");
     25d:	83 ec 08             	sub    $0x8,%esp
     260:	68 b6 3e 00 00       	push   $0x3eb6
     265:	ff 35 a0 5e 00 00    	pushl  0x5ea0
     26b:	e8 60 38 00 00       	call   3ad0 <printf>
}
     270:	83 c4 10             	add    $0x10,%esp
     273:	c9                   	leave  
     274:	c3                   	ret    
     275:	8d 76 00             	lea    0x0(%esi),%esi
      printf(stdout, "unlink ../iputdir failed\n");
     278:	83 ec 08             	sub    $0x8,%esp
     27b:	68 67 3e 00 00       	push   $0x3e67
     280:	ff 35 a0 5e 00 00    	pushl  0x5ea0
     286:	e8 45 38 00 00       	call   3ad0 <printf>
      exit();
     28b:	e8 d3 36 00 00       	call   3963 <exit>
    printf(stdout, "fork failed\n");
     290:	51                   	push   %ecx
     291:	51                   	push   %ecx
     292:	68 79 4d 00 00       	push   $0x4d79
     297:	ff 35 a0 5e 00 00    	pushl  0x5ea0
     29d:	e8 2e 38 00 00       	call   3ad0 <printf>
    exit();
     2a2:	e8 bc 36 00 00       	call   3963 <exit>
      printf(stdout, "mkdir failed\n");
     2a7:	52                   	push   %edx
     2a8:	52                   	push   %edx
     2a9:	68 38 3e 00 00       	push   $0x3e38
     2ae:	ff 35 a0 5e 00 00    	pushl  0x5ea0
     2b4:	e8 17 38 00 00       	call   3ad0 <printf>
      exit();
     2b9:	e8 a5 36 00 00       	call   3963 <exit>
      printf(stdout, "child chdir failed\n");
     2be:	50                   	push   %eax
     2bf:	50                   	push   %eax
     2c0:	68 a2 3e 00 00       	push   $0x3ea2
     2c5:	ff 35 a0 5e 00 00    	pushl  0x5ea0
     2cb:	e8 00 38 00 00       	call   3ad0 <printf>
      exit();
     2d0:	e8 8e 36 00 00       	call   3963 <exit>
     2d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     2dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000002e0 <openiputtest>:
{
     2e0:	f3 0f 1e fb          	endbr32 
     2e4:	55                   	push   %ebp
     2e5:	89 e5                	mov    %esp,%ebp
     2e7:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "openiput test\n");
     2ea:	68 c8 3e 00 00       	push   $0x3ec8
     2ef:	ff 35 a0 5e 00 00    	pushl  0x5ea0
     2f5:	e8 d6 37 00 00       	call   3ad0 <printf>
  if(mkdir("oidir") < 0){
     2fa:	c7 04 24 d7 3e 00 00 	movl   $0x3ed7,(%esp)
     301:	e8 c5 36 00 00       	call   39cb <mkdir>
     306:	83 c4 10             	add    $0x10,%esp
     309:	85 c0                	test   %eax,%eax
     30b:	0f 88 9b 00 00 00    	js     3ac <openiputtest+0xcc>
  pid = fork();
     311:	e8 45 36 00 00       	call   395b <fork>
  if(pid < 0){
     316:	85 c0                	test   %eax,%eax
     318:	78 7b                	js     395 <openiputtest+0xb5>
  if(pid == 0){
     31a:	75 34                	jne    350 <openiputtest+0x70>
    int fd = open("oidir", O_RDWR);
     31c:	83 ec 08             	sub    $0x8,%esp
     31f:	6a 02                	push   $0x2
     321:	68 d7 3e 00 00       	push   $0x3ed7
     326:	e8 78 36 00 00       	call   39a3 <open>
    if(fd >= 0){
     32b:	83 c4 10             	add    $0x10,%esp
     32e:	85 c0                	test   %eax,%eax
     330:	78 5e                	js     390 <openiputtest+0xb0>
      printf(stdout, "open directory for write succeeded\n");
     332:	83 ec 08             	sub    $0x8,%esp
     335:	68 5c 4e 00 00       	push   $0x4e5c
     33a:	ff 35 a0 5e 00 00    	pushl  0x5ea0
     340:	e8 8b 37 00 00       	call   3ad0 <printf>
      exit();
     345:	e8 19 36 00 00       	call   3963 <exit>
     34a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  sleep(1);
     350:	83 ec 0c             	sub    $0xc,%esp
     353:	6a 01                	push   $0x1
     355:	e8 99 36 00 00       	call   39f3 <sleep>
  if(unlink("oidir") != 0){
     35a:	c7 04 24 d7 3e 00 00 	movl   $0x3ed7,(%esp)
     361:	e8 4d 36 00 00       	call   39b3 <unlink>
     366:	83 c4 10             	add    $0x10,%esp
     369:	85 c0                	test   %eax,%eax
     36b:	75 56                	jne    3c3 <openiputtest+0xe3>
  wait();
     36d:	e8 f9 35 00 00       	call   396b <wait>
  printf(stdout, "openiput test ok\n");
     372:	83 ec 08             	sub    $0x8,%esp
     375:	68 00 3f 00 00       	push   $0x3f00
     37a:	ff 35 a0 5e 00 00    	pushl  0x5ea0
     380:	e8 4b 37 00 00       	call   3ad0 <printf>
     385:	83 c4 10             	add    $0x10,%esp
}
     388:	c9                   	leave  
     389:	c3                   	ret    
     38a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
     390:	e8 ce 35 00 00       	call   3963 <exit>
    printf(stdout, "fork failed\n");
     395:	52                   	push   %edx
     396:	52                   	push   %edx
     397:	68 79 4d 00 00       	push   $0x4d79
     39c:	ff 35 a0 5e 00 00    	pushl  0x5ea0
     3a2:	e8 29 37 00 00       	call   3ad0 <printf>
    exit();
     3a7:	e8 b7 35 00 00       	call   3963 <exit>
    printf(stdout, "mkdir oidir failed\n");
     3ac:	51                   	push   %ecx
     3ad:	51                   	push   %ecx
     3ae:	68 dd 3e 00 00       	push   $0x3edd
     3b3:	ff 35 a0 5e 00 00    	pushl  0x5ea0
     3b9:	e8 12 37 00 00       	call   3ad0 <printf>
    exit();
     3be:	e8 a0 35 00 00       	call   3963 <exit>
    printf(stdout, "unlink failed\n");
     3c3:	50                   	push   %eax
     3c4:	50                   	push   %eax
     3c5:	68 f1 3e 00 00       	push   $0x3ef1
     3ca:	ff 35 a0 5e 00 00    	pushl  0x5ea0
     3d0:	e8 fb 36 00 00       	call   3ad0 <printf>
    exit();
     3d5:	e8 89 35 00 00       	call   3963 <exit>
     3da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000003e0 <opentest>:
{
     3e0:	f3 0f 1e fb          	endbr32 
     3e4:	55                   	push   %ebp
     3e5:	89 e5                	mov    %esp,%ebp
     3e7:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "open test\n");
     3ea:	68 12 3f 00 00       	push   $0x3f12
     3ef:	ff 35 a0 5e 00 00    	pushl  0x5ea0
     3f5:	e8 d6 36 00 00       	call   3ad0 <printf>
  fd = open("echo", 0);
     3fa:	58                   	pop    %eax
     3fb:	5a                   	pop    %edx
     3fc:	6a 00                	push   $0x0
     3fe:	68 1d 3f 00 00       	push   $0x3f1d
     403:	e8 9b 35 00 00       	call   39a3 <open>
  if(fd < 0){
     408:	83 c4 10             	add    $0x10,%esp
     40b:	85 c0                	test   %eax,%eax
     40d:	78 36                	js     445 <opentest+0x65>
  close(fd);
     40f:	83 ec 0c             	sub    $0xc,%esp
     412:	50                   	push   %eax
     413:	e8 73 35 00 00       	call   398b <close>
  fd = open("doesnotexist", 0);
     418:	5a                   	pop    %edx
     419:	59                   	pop    %ecx
     41a:	6a 00                	push   $0x0
     41c:	68 35 3f 00 00       	push   $0x3f35
     421:	e8 7d 35 00 00       	call   39a3 <open>
  if(fd >= 0){
     426:	83 c4 10             	add    $0x10,%esp
     429:	85 c0                	test   %eax,%eax
     42b:	79 2f                	jns    45c <opentest+0x7c>
  printf(stdout, "open test ok\n");
     42d:	83 ec 08             	sub    $0x8,%esp
     430:	68 60 3f 00 00       	push   $0x3f60
     435:	ff 35 a0 5e 00 00    	pushl  0x5ea0
     43b:	e8 90 36 00 00       	call   3ad0 <printf>
}
     440:	83 c4 10             	add    $0x10,%esp
     443:	c9                   	leave  
     444:	c3                   	ret    
    printf(stdout, "open echo failed!\n");
     445:	50                   	push   %eax
     446:	50                   	push   %eax
     447:	68 22 3f 00 00       	push   $0x3f22
     44c:	ff 35 a0 5e 00 00    	pushl  0x5ea0
     452:	e8 79 36 00 00       	call   3ad0 <printf>
    exit();
     457:	e8 07 35 00 00       	call   3963 <exit>
    printf(stdout, "open doesnotexist succeeded!\n");
     45c:	50                   	push   %eax
     45d:	50                   	push   %eax
     45e:	68 42 3f 00 00       	push   $0x3f42
     463:	ff 35 a0 5e 00 00    	pushl  0x5ea0
     469:	e8 62 36 00 00       	call   3ad0 <printf>
    exit();
     46e:	e8 f0 34 00 00       	call   3963 <exit>
     473:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     47a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000480 <writetest>:
{
     480:	f3 0f 1e fb          	endbr32 
     484:	55                   	push   %ebp
     485:	89 e5                	mov    %esp,%ebp
     487:	56                   	push   %esi
     488:	53                   	push   %ebx
  printf(stdout, "small file test\n");
     489:	83 ec 08             	sub    $0x8,%esp
     48c:	68 6e 3f 00 00       	push   $0x3f6e
     491:	ff 35 a0 5e 00 00    	pushl  0x5ea0
     497:	e8 34 36 00 00       	call   3ad0 <printf>
  fd = open("small", O_CREATE|O_RDWR);
     49c:	58                   	pop    %eax
     49d:	5a                   	pop    %edx
     49e:	68 02 02 00 00       	push   $0x202
     4a3:	68 7f 3f 00 00       	push   $0x3f7f
     4a8:	e8 f6 34 00 00       	call   39a3 <open>
  if(fd >= 0){
     4ad:	83 c4 10             	add    $0x10,%esp
     4b0:	85 c0                	test   %eax,%eax
     4b2:	0f 88 8c 01 00 00    	js     644 <writetest+0x1c4>
    printf(stdout, "creat small succeeded; ok\n");
     4b8:	83 ec 08             	sub    $0x8,%esp
     4bb:	89 c6                	mov    %eax,%esi
  for(i = 0; i < 100; i++){
     4bd:	31 db                	xor    %ebx,%ebx
    printf(stdout, "creat small succeeded; ok\n");
     4bf:	68 85 3f 00 00       	push   $0x3f85
     4c4:	ff 35 a0 5e 00 00    	pushl  0x5ea0
     4ca:	e8 01 36 00 00       	call   3ad0 <printf>
     4cf:	83 c4 10             	add    $0x10,%esp
     4d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(write(fd, "aaaaaaaaaa", 10) != 10){
     4d8:	83 ec 04             	sub    $0x4,%esp
     4db:	6a 0a                	push   $0xa
     4dd:	68 bc 3f 00 00       	push   $0x3fbc
     4e2:	56                   	push   %esi
     4e3:	e8 9b 34 00 00       	call   3983 <write>
     4e8:	83 c4 10             	add    $0x10,%esp
     4eb:	83 f8 0a             	cmp    $0xa,%eax
     4ee:	0f 85 d9 00 00 00    	jne    5cd <writetest+0x14d>
    if(write(fd, "bbbbbbbbbb", 10) != 10){
     4f4:	83 ec 04             	sub    $0x4,%esp
     4f7:	6a 0a                	push   $0xa
     4f9:	68 c7 3f 00 00       	push   $0x3fc7
     4fe:	56                   	push   %esi
     4ff:	e8 7f 34 00 00       	call   3983 <write>
     504:	83 c4 10             	add    $0x10,%esp
     507:	83 f8 0a             	cmp    $0xa,%eax
     50a:	0f 85 d6 00 00 00    	jne    5e6 <writetest+0x166>
  for(i = 0; i < 100; i++){
     510:	83 c3 01             	add    $0x1,%ebx
     513:	83 fb 64             	cmp    $0x64,%ebx
     516:	75 c0                	jne    4d8 <writetest+0x58>
  printf(stdout, "writes ok\n");
     518:	83 ec 08             	sub    $0x8,%esp
     51b:	68 d2 3f 00 00       	push   $0x3fd2
     520:	ff 35 a0 5e 00 00    	pushl  0x5ea0
     526:	e8 a5 35 00 00       	call   3ad0 <printf>
  close(fd);
     52b:	89 34 24             	mov    %esi,(%esp)
     52e:	e8 58 34 00 00       	call   398b <close>
  fd = open("small", O_RDONLY);
     533:	5b                   	pop    %ebx
     534:	5e                   	pop    %esi
     535:	6a 00                	push   $0x0
     537:	68 7f 3f 00 00       	push   $0x3f7f
     53c:	e8 62 34 00 00       	call   39a3 <open>
  if(fd >= 0){
     541:	83 c4 10             	add    $0x10,%esp
  fd = open("small", O_RDONLY);
     544:	89 c3                	mov    %eax,%ebx
  if(fd >= 0){
     546:	85 c0                	test   %eax,%eax
     548:	0f 88 b1 00 00 00    	js     5ff <writetest+0x17f>
    printf(stdout, "open small succeeded ok\n");
     54e:	83 ec 08             	sub    $0x8,%esp
     551:	68 dd 3f 00 00       	push   $0x3fdd
     556:	ff 35 a0 5e 00 00    	pushl  0x5ea0
     55c:	e8 6f 35 00 00       	call   3ad0 <printf>
  i = read(fd, buf, 2000);
     561:	83 c4 0c             	add    $0xc,%esp
     564:	68 d0 07 00 00       	push   $0x7d0
     569:	68 80 86 00 00       	push   $0x8680
     56e:	53                   	push   %ebx
     56f:	e8 07 34 00 00       	call   397b <read>
  if(i == 2000){
     574:	83 c4 10             	add    $0x10,%esp
     577:	3d d0 07 00 00       	cmp    $0x7d0,%eax
     57c:	0f 85 94 00 00 00    	jne    616 <writetest+0x196>
    printf(stdout, "read succeeded ok\n");
     582:	83 ec 08             	sub    $0x8,%esp
     585:	68 11 40 00 00       	push   $0x4011
     58a:	ff 35 a0 5e 00 00    	pushl  0x5ea0
     590:	e8 3b 35 00 00       	call   3ad0 <printf>
  close(fd);
     595:	89 1c 24             	mov    %ebx,(%esp)
     598:	e8 ee 33 00 00       	call   398b <close>
  if(unlink("small") < 0){
     59d:	c7 04 24 7f 3f 00 00 	movl   $0x3f7f,(%esp)
     5a4:	e8 0a 34 00 00       	call   39b3 <unlink>
     5a9:	83 c4 10             	add    $0x10,%esp
     5ac:	85 c0                	test   %eax,%eax
     5ae:	78 7d                	js     62d <writetest+0x1ad>
  printf(stdout, "small file test ok\n");
     5b0:	83 ec 08             	sub    $0x8,%esp
     5b3:	68 39 40 00 00       	push   $0x4039
     5b8:	ff 35 a0 5e 00 00    	pushl  0x5ea0
     5be:	e8 0d 35 00 00       	call   3ad0 <printf>
}
     5c3:	83 c4 10             	add    $0x10,%esp
     5c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
     5c9:	5b                   	pop    %ebx
     5ca:	5e                   	pop    %esi
     5cb:	5d                   	pop    %ebp
     5cc:	c3                   	ret    
      printf(stdout, "error: write aa %d new file failed\n", i);
     5cd:	83 ec 04             	sub    $0x4,%esp
     5d0:	53                   	push   %ebx
     5d1:	68 80 4e 00 00       	push   $0x4e80
     5d6:	ff 35 a0 5e 00 00    	pushl  0x5ea0
     5dc:	e8 ef 34 00 00       	call   3ad0 <printf>
      exit();
     5e1:	e8 7d 33 00 00       	call   3963 <exit>
      printf(stdout, "error: write bb %d new file failed\n", i);
     5e6:	83 ec 04             	sub    $0x4,%esp
     5e9:	53                   	push   %ebx
     5ea:	68 a4 4e 00 00       	push   $0x4ea4
     5ef:	ff 35 a0 5e 00 00    	pushl  0x5ea0
     5f5:	e8 d6 34 00 00       	call   3ad0 <printf>
      exit();
     5fa:	e8 64 33 00 00       	call   3963 <exit>
    printf(stdout, "error: open small failed!\n");
     5ff:	51                   	push   %ecx
     600:	51                   	push   %ecx
     601:	68 f6 3f 00 00       	push   $0x3ff6
     606:	ff 35 a0 5e 00 00    	pushl  0x5ea0
     60c:	e8 bf 34 00 00       	call   3ad0 <printf>
    exit();
     611:	e8 4d 33 00 00       	call   3963 <exit>
    printf(stdout, "read failed\n");
     616:	52                   	push   %edx
     617:	52                   	push   %edx
     618:	68 3d 43 00 00       	push   $0x433d
     61d:	ff 35 a0 5e 00 00    	pushl  0x5ea0
     623:	e8 a8 34 00 00       	call   3ad0 <printf>
    exit();
     628:	e8 36 33 00 00       	call   3963 <exit>
    printf(stdout, "unlink small failed\n");
     62d:	50                   	push   %eax
     62e:	50                   	push   %eax
     62f:	68 24 40 00 00       	push   $0x4024
     634:	ff 35 a0 5e 00 00    	pushl  0x5ea0
     63a:	e8 91 34 00 00       	call   3ad0 <printf>
    exit();
     63f:	e8 1f 33 00 00       	call   3963 <exit>
    printf(stdout, "error: creat small failed!\n");
     644:	50                   	push   %eax
     645:	50                   	push   %eax
     646:	68 a0 3f 00 00       	push   $0x3fa0
     64b:	ff 35 a0 5e 00 00    	pushl  0x5ea0
     651:	e8 7a 34 00 00       	call   3ad0 <printf>
    exit();
     656:	e8 08 33 00 00       	call   3963 <exit>
     65b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     65f:	90                   	nop

00000660 <writetest1>:
{
     660:	f3 0f 1e fb          	endbr32 
     664:	55                   	push   %ebp
     665:	89 e5                	mov    %esp,%ebp
     667:	56                   	push   %esi
     668:	53                   	push   %ebx
  printf(stdout, "big files test\n");
     669:	83 ec 08             	sub    $0x8,%esp
     66c:	68 4d 40 00 00       	push   $0x404d
     671:	ff 35 a0 5e 00 00    	pushl  0x5ea0
     677:	e8 54 34 00 00       	call   3ad0 <printf>
  fd = open("big", O_CREATE|O_RDWR);
     67c:	58                   	pop    %eax
     67d:	5a                   	pop    %edx
     67e:	68 02 02 00 00       	push   $0x202
     683:	68 c7 40 00 00       	push   $0x40c7
     688:	e8 16 33 00 00       	call   39a3 <open>
  if(fd < 0){
     68d:	83 c4 10             	add    $0x10,%esp
     690:	85 c0                	test   %eax,%eax
     692:	0f 88 5d 01 00 00    	js     7f5 <writetest1+0x195>
     698:	89 c6                	mov    %eax,%esi
  for(i = 0; i < MAXFILE; i++){
     69a:	31 db                	xor    %ebx,%ebx
     69c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(write(fd, buf, 512) != 512){
     6a0:	83 ec 04             	sub    $0x4,%esp
    ((int*)buf)[0] = i;
     6a3:	89 1d 80 86 00 00    	mov    %ebx,0x8680
    if(write(fd, buf, 512) != 512){
     6a9:	68 00 02 00 00       	push   $0x200
     6ae:	68 80 86 00 00       	push   $0x8680
     6b3:	56                   	push   %esi
     6b4:	e8 ca 32 00 00       	call   3983 <write>
     6b9:	83 c4 10             	add    $0x10,%esp
     6bc:	3d 00 02 00 00       	cmp    $0x200,%eax
     6c1:	0f 85 b3 00 00 00    	jne    77a <writetest1+0x11a>
  for(i = 0; i < MAXFILE; i++){
     6c7:	83 c3 01             	add    $0x1,%ebx
     6ca:	81 fb 8c 00 00 00    	cmp    $0x8c,%ebx
     6d0:	75 ce                	jne    6a0 <writetest1+0x40>
  close(fd);
     6d2:	83 ec 0c             	sub    $0xc,%esp
     6d5:	56                   	push   %esi
     6d6:	e8 b0 32 00 00       	call   398b <close>
  fd = open("big", O_RDONLY);
     6db:	5b                   	pop    %ebx
     6dc:	5e                   	pop    %esi
     6dd:	6a 00                	push   $0x0
     6df:	68 c7 40 00 00       	push   $0x40c7
     6e4:	e8 ba 32 00 00       	call   39a3 <open>
  if(fd < 0){
     6e9:	83 c4 10             	add    $0x10,%esp
  fd = open("big", O_RDONLY);
     6ec:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
     6ee:	85 c0                	test   %eax,%eax
     6f0:	0f 88 e8 00 00 00    	js     7de <writetest1+0x17e>
  n = 0;
     6f6:	31 f6                	xor    %esi,%esi
     6f8:	eb 1d                	jmp    717 <writetest1+0xb7>
     6fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(i != 512){
     700:	3d 00 02 00 00       	cmp    $0x200,%eax
     705:	0f 85 9f 00 00 00    	jne    7aa <writetest1+0x14a>
    if(((int*)buf)[0] != n){
     70b:	a1 80 86 00 00       	mov    0x8680,%eax
     710:	39 f0                	cmp    %esi,%eax
     712:	75 7f                	jne    793 <writetest1+0x133>
    n++;
     714:	83 c6 01             	add    $0x1,%esi
    i = read(fd, buf, 512);
     717:	83 ec 04             	sub    $0x4,%esp
     71a:	68 00 02 00 00       	push   $0x200
     71f:	68 80 86 00 00       	push   $0x8680
     724:	53                   	push   %ebx
     725:	e8 51 32 00 00       	call   397b <read>
    if(i == 0){
     72a:	83 c4 10             	add    $0x10,%esp
     72d:	85 c0                	test   %eax,%eax
     72f:	75 cf                	jne    700 <writetest1+0xa0>
      if(n == MAXFILE - 1){
     731:	81 fe 8b 00 00 00    	cmp    $0x8b,%esi
     737:	0f 84 86 00 00 00    	je     7c3 <writetest1+0x163>
  close(fd);
     73d:	83 ec 0c             	sub    $0xc,%esp
     740:	53                   	push   %ebx
     741:	e8 45 32 00 00       	call   398b <close>
  if(unlink("big") < 0){
     746:	c7 04 24 c7 40 00 00 	movl   $0x40c7,(%esp)
     74d:	e8 61 32 00 00       	call   39b3 <unlink>
     752:	83 c4 10             	add    $0x10,%esp
     755:	85 c0                	test   %eax,%eax
     757:	0f 88 af 00 00 00    	js     80c <writetest1+0x1ac>
  printf(stdout, "big files ok\n");
     75d:	83 ec 08             	sub    $0x8,%esp
     760:	68 ee 40 00 00       	push   $0x40ee
     765:	ff 35 a0 5e 00 00    	pushl  0x5ea0
     76b:	e8 60 33 00 00       	call   3ad0 <printf>
}
     770:	83 c4 10             	add    $0x10,%esp
     773:	8d 65 f8             	lea    -0x8(%ebp),%esp
     776:	5b                   	pop    %ebx
     777:	5e                   	pop    %esi
     778:	5d                   	pop    %ebp
     779:	c3                   	ret    
      printf(stdout, "error: write big file failed\n", i);
     77a:	83 ec 04             	sub    $0x4,%esp
     77d:	53                   	push   %ebx
     77e:	68 77 40 00 00       	push   $0x4077
     783:	ff 35 a0 5e 00 00    	pushl  0x5ea0
     789:	e8 42 33 00 00       	call   3ad0 <printf>
      exit();
     78e:	e8 d0 31 00 00       	call   3963 <exit>
      printf(stdout, "read content of block %d is %d\n",
     793:	50                   	push   %eax
     794:	56                   	push   %esi
     795:	68 c8 4e 00 00       	push   $0x4ec8
     79a:	ff 35 a0 5e 00 00    	pushl  0x5ea0
     7a0:	e8 2b 33 00 00       	call   3ad0 <printf>
      exit();
     7a5:	e8 b9 31 00 00       	call   3963 <exit>
      printf(stdout, "read failed %d\n", i);
     7aa:	83 ec 04             	sub    $0x4,%esp
     7ad:	50                   	push   %eax
     7ae:	68 cb 40 00 00       	push   $0x40cb
     7b3:	ff 35 a0 5e 00 00    	pushl  0x5ea0
     7b9:	e8 12 33 00 00       	call   3ad0 <printf>
      exit();
     7be:	e8 a0 31 00 00       	call   3963 <exit>
        printf(stdout, "read only %d blocks from big", n);
     7c3:	52                   	push   %edx
     7c4:	68 8b 00 00 00       	push   $0x8b
     7c9:	68 ae 40 00 00       	push   $0x40ae
     7ce:	ff 35 a0 5e 00 00    	pushl  0x5ea0
     7d4:	e8 f7 32 00 00       	call   3ad0 <printf>
        exit();
     7d9:	e8 85 31 00 00       	call   3963 <exit>
    printf(stdout, "error: open big failed!\n");
     7de:	51                   	push   %ecx
     7df:	51                   	push   %ecx
     7e0:	68 95 40 00 00       	push   $0x4095
     7e5:	ff 35 a0 5e 00 00    	pushl  0x5ea0
     7eb:	e8 e0 32 00 00       	call   3ad0 <printf>
    exit();
     7f0:	e8 6e 31 00 00       	call   3963 <exit>
    printf(stdout, "error: creat big failed!\n");
     7f5:	50                   	push   %eax
     7f6:	50                   	push   %eax
     7f7:	68 5d 40 00 00       	push   $0x405d
     7fc:	ff 35 a0 5e 00 00    	pushl  0x5ea0
     802:	e8 c9 32 00 00       	call   3ad0 <printf>
    exit();
     807:	e8 57 31 00 00       	call   3963 <exit>
    printf(stdout, "unlink big failed\n");
     80c:	50                   	push   %eax
     80d:	50                   	push   %eax
     80e:	68 db 40 00 00       	push   $0x40db
     813:	ff 35 a0 5e 00 00    	pushl  0x5ea0
     819:	e8 b2 32 00 00       	call   3ad0 <printf>
    exit();
     81e:	e8 40 31 00 00       	call   3963 <exit>
     823:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     82a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000830 <createtest>:
{
     830:	f3 0f 1e fb          	endbr32 
     834:	55                   	push   %ebp
     835:	89 e5                	mov    %esp,%ebp
     837:	53                   	push   %ebx
  name[2] = '\0';
     838:	bb 30 00 00 00       	mov    $0x30,%ebx
{
     83d:	83 ec 0c             	sub    $0xc,%esp
  printf(stdout, "many creates, followed by unlink test\n");
     840:	68 e8 4e 00 00       	push   $0x4ee8
     845:	ff 35 a0 5e 00 00    	pushl  0x5ea0
     84b:	e8 80 32 00 00       	call   3ad0 <printf>
  name[0] = 'a';
     850:	c6 05 80 a6 00 00 61 	movb   $0x61,0xa680
  name[2] = '\0';
     857:	83 c4 10             	add    $0x10,%esp
     85a:	c6 05 82 a6 00 00 00 	movb   $0x0,0xa682
  for(i = 0; i < 52; i++){
     861:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    fd = open(name, O_CREATE|O_RDWR);
     868:	83 ec 08             	sub    $0x8,%esp
    name[1] = '0' + i;
     86b:	88 1d 81 a6 00 00    	mov    %bl,0xa681
    fd = open(name, O_CREATE|O_RDWR);
     871:	83 c3 01             	add    $0x1,%ebx
     874:	68 02 02 00 00       	push   $0x202
     879:	68 80 a6 00 00       	push   $0xa680
     87e:	e8 20 31 00 00       	call   39a3 <open>
    close(fd);
     883:	89 04 24             	mov    %eax,(%esp)
     886:	e8 00 31 00 00       	call   398b <close>
  for(i = 0; i < 52; i++){
     88b:	83 c4 10             	add    $0x10,%esp
     88e:	80 fb 64             	cmp    $0x64,%bl
     891:	75 d5                	jne    868 <createtest+0x38>
  name[0] = 'a';
     893:	c6 05 80 a6 00 00 61 	movb   $0x61,0xa680
  name[2] = '\0';
     89a:	bb 30 00 00 00       	mov    $0x30,%ebx
     89f:	c6 05 82 a6 00 00 00 	movb   $0x0,0xa682
  for(i = 0; i < 52; i++){
     8a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     8ad:	8d 76 00             	lea    0x0(%esi),%esi
    unlink(name);
     8b0:	83 ec 0c             	sub    $0xc,%esp
    name[1] = '0' + i;
     8b3:	88 1d 81 a6 00 00    	mov    %bl,0xa681
    unlink(name);
     8b9:	83 c3 01             	add    $0x1,%ebx
     8bc:	68 80 a6 00 00       	push   $0xa680
     8c1:	e8 ed 30 00 00       	call   39b3 <unlink>
  for(i = 0; i < 52; i++){
     8c6:	83 c4 10             	add    $0x10,%esp
     8c9:	80 fb 64             	cmp    $0x64,%bl
     8cc:	75 e2                	jne    8b0 <createtest+0x80>
  printf(stdout, "many creates, followed by unlink; ok\n");
     8ce:	83 ec 08             	sub    $0x8,%esp
     8d1:	68 10 4f 00 00       	push   $0x4f10
     8d6:	ff 35 a0 5e 00 00    	pushl  0x5ea0
     8dc:	e8 ef 31 00 00       	call   3ad0 <printf>
}
     8e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     8e4:	83 c4 10             	add    $0x10,%esp
     8e7:	c9                   	leave  
     8e8:	c3                   	ret    
     8e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000008f0 <dirtest>:
{
     8f0:	f3 0f 1e fb          	endbr32 
     8f4:	55                   	push   %ebp
     8f5:	89 e5                	mov    %esp,%ebp
     8f7:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "mkdir test\n");
     8fa:	68 fc 40 00 00       	push   $0x40fc
     8ff:	ff 35 a0 5e 00 00    	pushl  0x5ea0
     905:	e8 c6 31 00 00       	call   3ad0 <printf>
  if(mkdir("dir0") < 0){
     90a:	c7 04 24 08 41 00 00 	movl   $0x4108,(%esp)
     911:	e8 b5 30 00 00       	call   39cb <mkdir>
     916:	83 c4 10             	add    $0x10,%esp
     919:	85 c0                	test   %eax,%eax
     91b:	78 58                	js     975 <dirtest+0x85>
  if(chdir("dir0") < 0){
     91d:	83 ec 0c             	sub    $0xc,%esp
     920:	68 08 41 00 00       	push   $0x4108
     925:	e8 a9 30 00 00       	call   39d3 <chdir>
     92a:	83 c4 10             	add    $0x10,%esp
     92d:	85 c0                	test   %eax,%eax
     92f:	0f 88 85 00 00 00    	js     9ba <dirtest+0xca>
  if(chdir("..") < 0){
     935:	83 ec 0c             	sub    $0xc,%esp
     938:	68 ad 46 00 00       	push   $0x46ad
     93d:	e8 91 30 00 00       	call   39d3 <chdir>
     942:	83 c4 10             	add    $0x10,%esp
     945:	85 c0                	test   %eax,%eax
     947:	78 5a                	js     9a3 <dirtest+0xb3>
  if(unlink("dir0") < 0){
     949:	83 ec 0c             	sub    $0xc,%esp
     94c:	68 08 41 00 00       	push   $0x4108
     951:	e8 5d 30 00 00       	call   39b3 <unlink>
     956:	83 c4 10             	add    $0x10,%esp
     959:	85 c0                	test   %eax,%eax
     95b:	78 2f                	js     98c <dirtest+0x9c>
  printf(stdout, "mkdir test ok\n");
     95d:	83 ec 08             	sub    $0x8,%esp
     960:	68 45 41 00 00       	push   $0x4145
     965:	ff 35 a0 5e 00 00    	pushl  0x5ea0
     96b:	e8 60 31 00 00       	call   3ad0 <printf>
}
     970:	83 c4 10             	add    $0x10,%esp
     973:	c9                   	leave  
     974:	c3                   	ret    
    printf(stdout, "mkdir failed\n");
     975:	50                   	push   %eax
     976:	50                   	push   %eax
     977:	68 38 3e 00 00       	push   $0x3e38
     97c:	ff 35 a0 5e 00 00    	pushl  0x5ea0
     982:	e8 49 31 00 00       	call   3ad0 <printf>
    exit();
     987:	e8 d7 2f 00 00       	call   3963 <exit>
    printf(stdout, "unlink dir0 failed\n");
     98c:	50                   	push   %eax
     98d:	50                   	push   %eax
     98e:	68 31 41 00 00       	push   $0x4131
     993:	ff 35 a0 5e 00 00    	pushl  0x5ea0
     999:	e8 32 31 00 00       	call   3ad0 <printf>
    exit();
     99e:	e8 c0 2f 00 00       	call   3963 <exit>
    printf(stdout, "chdir .. failed\n");
     9a3:	52                   	push   %edx
     9a4:	52                   	push   %edx
     9a5:	68 20 41 00 00       	push   $0x4120
     9aa:	ff 35 a0 5e 00 00    	pushl  0x5ea0
     9b0:	e8 1b 31 00 00       	call   3ad0 <printf>
    exit();
     9b5:	e8 a9 2f 00 00       	call   3963 <exit>
    printf(stdout, "chdir dir0 failed\n");
     9ba:	51                   	push   %ecx
     9bb:	51                   	push   %ecx
     9bc:	68 0d 41 00 00       	push   $0x410d
     9c1:	ff 35 a0 5e 00 00    	pushl  0x5ea0
     9c7:	e8 04 31 00 00       	call   3ad0 <printf>
    exit();
     9cc:	e8 92 2f 00 00       	call   3963 <exit>
     9d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     9d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     9df:	90                   	nop

000009e0 <exectest>:
{
     9e0:	f3 0f 1e fb          	endbr32 
     9e4:	55                   	push   %ebp
     9e5:	89 e5                	mov    %esp,%ebp
     9e7:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "exec test\n");
     9ea:	68 54 41 00 00       	push   $0x4154
     9ef:	ff 35 a0 5e 00 00    	pushl  0x5ea0
     9f5:	e8 d6 30 00 00       	call   3ad0 <printf>
  if(exec("echo", echoargv) < 0){
     9fa:	5a                   	pop    %edx
     9fb:	59                   	pop    %ecx
     9fc:	68 a4 5e 00 00       	push   $0x5ea4
     a01:	68 1d 3f 00 00       	push   $0x3f1d
     a06:	e8 90 2f 00 00       	call   399b <exec>
     a0b:	83 c4 10             	add    $0x10,%esp
     a0e:	85 c0                	test   %eax,%eax
     a10:	78 02                	js     a14 <exectest+0x34>
}
     a12:	c9                   	leave  
     a13:	c3                   	ret    
    printf(stdout, "exec echo failed\n");
     a14:	50                   	push   %eax
     a15:	50                   	push   %eax
     a16:	68 5f 41 00 00       	push   $0x415f
     a1b:	ff 35 a0 5e 00 00    	pushl  0x5ea0
     a21:	e8 aa 30 00 00       	call   3ad0 <printf>
    exit();
     a26:	e8 38 2f 00 00       	call   3963 <exit>
     a2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     a2f:	90                   	nop

00000a30 <pipe1>:
{
     a30:	f3 0f 1e fb          	endbr32 
     a34:	55                   	push   %ebp
     a35:	89 e5                	mov    %esp,%ebp
     a37:	57                   	push   %edi
     a38:	56                   	push   %esi
  if(pipe(fds) != 0){
     a39:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
     a3c:	53                   	push   %ebx
     a3d:	83 ec 38             	sub    $0x38,%esp
  if(pipe(fds) != 0){
     a40:	50                   	push   %eax
     a41:	e8 2d 2f 00 00       	call   3973 <pipe>
     a46:	83 c4 10             	add    $0x10,%esp
     a49:	85 c0                	test   %eax,%eax
     a4b:	0f 85 38 01 00 00    	jne    b89 <pipe1+0x159>
  pid = fork();
     a51:	e8 05 2f 00 00       	call   395b <fork>
  if(pid == 0){
     a56:	85 c0                	test   %eax,%eax
     a58:	0f 84 8d 00 00 00    	je     aeb <pipe1+0xbb>
  } else if(pid > 0){
     a5e:	0f 8e 38 01 00 00    	jle    b9c <pipe1+0x16c>
    close(fds[1]);
     a64:	83 ec 0c             	sub    $0xc,%esp
     a67:	ff 75 e4             	pushl  -0x1c(%ebp)
  seq = 0;
     a6a:	31 db                	xor    %ebx,%ebx
    cc = 1;
     a6c:	be 01 00 00 00       	mov    $0x1,%esi
    close(fds[1]);
     a71:	e8 15 2f 00 00       	call   398b <close>
    total = 0;
     a76:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
    while((n = read(fds[0], buf, cc)) > 0){
     a7d:	83 c4 10             	add    $0x10,%esp
     a80:	83 ec 04             	sub    $0x4,%esp
     a83:	56                   	push   %esi
     a84:	68 80 86 00 00       	push   $0x8680
     a89:	ff 75 e0             	pushl  -0x20(%ebp)
     a8c:	e8 ea 2e 00 00       	call   397b <read>
     a91:	83 c4 10             	add    $0x10,%esp
     a94:	89 c7                	mov    %eax,%edi
     a96:	85 c0                	test   %eax,%eax
     a98:	0f 8e a7 00 00 00    	jle    b45 <pipe1+0x115>
     a9e:	8d 0c 3b             	lea    (%ebx,%edi,1),%ecx
      for(i = 0; i < n; i++){
     aa1:	31 c0                	xor    %eax,%eax
     aa3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     aa7:	90                   	nop
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     aa8:	89 da                	mov    %ebx,%edx
     aaa:	83 c3 01             	add    $0x1,%ebx
     aad:	38 90 80 86 00 00    	cmp    %dl,0x8680(%eax)
     ab3:	75 1c                	jne    ad1 <pipe1+0xa1>
      for(i = 0; i < n; i++){
     ab5:	83 c0 01             	add    $0x1,%eax
     ab8:	39 d9                	cmp    %ebx,%ecx
     aba:	75 ec                	jne    aa8 <pipe1+0x78>
      cc = cc * 2;
     abc:	01 f6                	add    %esi,%esi
      total += n;
     abe:	01 7d d4             	add    %edi,-0x2c(%ebp)
     ac1:	b8 00 20 00 00       	mov    $0x2000,%eax
     ac6:	81 fe 00 20 00 00    	cmp    $0x2000,%esi
     acc:	0f 4f f0             	cmovg  %eax,%esi
     acf:	eb af                	jmp    a80 <pipe1+0x50>
          printf(1, "pipe1 oops 2\n");
     ad1:	83 ec 08             	sub    $0x8,%esp
     ad4:	68 8e 41 00 00       	push   $0x418e
     ad9:	6a 01                	push   $0x1
     adb:	e8 f0 2f 00 00       	call   3ad0 <printf>
          return;
     ae0:	83 c4 10             	add    $0x10,%esp
}
     ae3:	8d 65 f4             	lea    -0xc(%ebp),%esp
     ae6:	5b                   	pop    %ebx
     ae7:	5e                   	pop    %esi
     ae8:	5f                   	pop    %edi
     ae9:	5d                   	pop    %ebp
     aea:	c3                   	ret    
    close(fds[0]);
     aeb:	83 ec 0c             	sub    $0xc,%esp
     aee:	ff 75 e0             	pushl  -0x20(%ebp)
  seq = 0;
     af1:	31 db                	xor    %ebx,%ebx
    close(fds[0]);
     af3:	e8 93 2e 00 00       	call   398b <close>
     af8:	83 c4 10             	add    $0x10,%esp
      for(i = 0; i < 1033; i++)
     afb:	31 c0                	xor    %eax,%eax
     afd:	8d 76 00             	lea    0x0(%esi),%esi
        buf[i] = seq++;
     b00:	8d 14 18             	lea    (%eax,%ebx,1),%edx
      for(i = 0; i < 1033; i++)
     b03:	83 c0 01             	add    $0x1,%eax
        buf[i] = seq++;
     b06:	88 90 7f 86 00 00    	mov    %dl,0x867f(%eax)
      for(i = 0; i < 1033; i++)
     b0c:	3d 09 04 00 00       	cmp    $0x409,%eax
     b11:	75 ed                	jne    b00 <pipe1+0xd0>
      if(write(fds[1], buf, 1033) != 1033){
     b13:	83 ec 04             	sub    $0x4,%esp
     b16:	81 c3 09 04 00 00    	add    $0x409,%ebx
     b1c:	68 09 04 00 00       	push   $0x409
     b21:	68 80 86 00 00       	push   $0x8680
     b26:	ff 75 e4             	pushl  -0x1c(%ebp)
     b29:	e8 55 2e 00 00       	call   3983 <write>
     b2e:	83 c4 10             	add    $0x10,%esp
     b31:	3d 09 04 00 00       	cmp    $0x409,%eax
     b36:	75 77                	jne    baf <pipe1+0x17f>
    for(n = 0; n < 5; n++){
     b38:	81 fb 2d 14 00 00    	cmp    $0x142d,%ebx
     b3e:	75 bb                	jne    afb <pipe1+0xcb>
    exit();
     b40:	e8 1e 2e 00 00       	call   3963 <exit>
    if(total != 5 * 1033){
     b45:	81 7d d4 2d 14 00 00 	cmpl   $0x142d,-0x2c(%ebp)
     b4c:	75 26                	jne    b74 <pipe1+0x144>
    close(fds[0]);
     b4e:	83 ec 0c             	sub    $0xc,%esp
     b51:	ff 75 e0             	pushl  -0x20(%ebp)
     b54:	e8 32 2e 00 00       	call   398b <close>
    wait();
     b59:	e8 0d 2e 00 00       	call   396b <wait>
  printf(1, "pipe1 ok\n");
     b5e:	5a                   	pop    %edx
     b5f:	59                   	pop    %ecx
     b60:	68 b3 41 00 00       	push   $0x41b3
     b65:	6a 01                	push   $0x1
     b67:	e8 64 2f 00 00       	call   3ad0 <printf>
     b6c:	83 c4 10             	add    $0x10,%esp
     b6f:	e9 6f ff ff ff       	jmp    ae3 <pipe1+0xb3>
      printf(1, "pipe1 oops 3 total %d\n", total);
     b74:	53                   	push   %ebx
     b75:	ff 75 d4             	pushl  -0x2c(%ebp)
     b78:	68 9c 41 00 00       	push   $0x419c
     b7d:	6a 01                	push   $0x1
     b7f:	e8 4c 2f 00 00       	call   3ad0 <printf>
      exit();
     b84:	e8 da 2d 00 00       	call   3963 <exit>
    printf(1, "pipe() failed\n");
     b89:	57                   	push   %edi
     b8a:	57                   	push   %edi
     b8b:	68 71 41 00 00       	push   $0x4171
     b90:	6a 01                	push   $0x1
     b92:	e8 39 2f 00 00       	call   3ad0 <printf>
    exit();
     b97:	e8 c7 2d 00 00       	call   3963 <exit>
    printf(1, "fork() failed\n");
     b9c:	50                   	push   %eax
     b9d:	50                   	push   %eax
     b9e:	68 bd 41 00 00       	push   $0x41bd
     ba3:	6a 01                	push   $0x1
     ba5:	e8 26 2f 00 00       	call   3ad0 <printf>
    exit();
     baa:	e8 b4 2d 00 00       	call   3963 <exit>
        printf(1, "pipe1 oops 1\n");
     baf:	56                   	push   %esi
     bb0:	56                   	push   %esi
     bb1:	68 80 41 00 00       	push   $0x4180
     bb6:	6a 01                	push   $0x1
     bb8:	e8 13 2f 00 00       	call   3ad0 <printf>
        exit();
     bbd:	e8 a1 2d 00 00       	call   3963 <exit>
     bc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000bd0 <preempt>:
{
     bd0:	f3 0f 1e fb          	endbr32 
     bd4:	55                   	push   %ebp
     bd5:	89 e5                	mov    %esp,%ebp
     bd7:	57                   	push   %edi
     bd8:	56                   	push   %esi
     bd9:	53                   	push   %ebx
     bda:	83 ec 24             	sub    $0x24,%esp
  printf(1, "preempt: ");
     bdd:	68 cc 41 00 00       	push   $0x41cc
     be2:	6a 01                	push   $0x1
     be4:	e8 e7 2e 00 00       	call   3ad0 <printf>
  pid1 = fork();
     be9:	e8 6d 2d 00 00       	call   395b <fork>
  if(pid1 == 0)
     bee:	83 c4 10             	add    $0x10,%esp
     bf1:	85 c0                	test   %eax,%eax
     bf3:	75 0b                	jne    c00 <preempt+0x30>
    for(;;)
     bf5:	eb fe                	jmp    bf5 <preempt+0x25>
     bf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     bfe:	66 90                	xchg   %ax,%ax
     c00:	89 c7                	mov    %eax,%edi
  pid2 = fork();
     c02:	e8 54 2d 00 00       	call   395b <fork>
     c07:	89 c6                	mov    %eax,%esi
  if(pid2 == 0)
     c09:	85 c0                	test   %eax,%eax
     c0b:	75 03                	jne    c10 <preempt+0x40>
    for(;;)
     c0d:	eb fe                	jmp    c0d <preempt+0x3d>
     c0f:	90                   	nop
  pipe(pfds);
     c10:	83 ec 0c             	sub    $0xc,%esp
     c13:	8d 45 e0             	lea    -0x20(%ebp),%eax
     c16:	50                   	push   %eax
     c17:	e8 57 2d 00 00       	call   3973 <pipe>
  pid3 = fork();
     c1c:	e8 3a 2d 00 00       	call   395b <fork>
  if(pid3 == 0){
     c21:	83 c4 10             	add    $0x10,%esp
  pid3 = fork();
     c24:	89 c3                	mov    %eax,%ebx
  if(pid3 == 0){
     c26:	85 c0                	test   %eax,%eax
     c28:	75 3e                	jne    c68 <preempt+0x98>
    close(pfds[0]);
     c2a:	83 ec 0c             	sub    $0xc,%esp
     c2d:	ff 75 e0             	pushl  -0x20(%ebp)
     c30:	e8 56 2d 00 00       	call   398b <close>
    if(write(pfds[1], "x", 1) != 1)
     c35:	83 c4 0c             	add    $0xc,%esp
     c38:	6a 01                	push   $0x1
     c3a:	68 91 47 00 00       	push   $0x4791
     c3f:	ff 75 e4             	pushl  -0x1c(%ebp)
     c42:	e8 3c 2d 00 00       	call   3983 <write>
     c47:	83 c4 10             	add    $0x10,%esp
     c4a:	83 f8 01             	cmp    $0x1,%eax
     c4d:	0f 85 ae 00 00 00    	jne    d01 <preempt+0x131>
    close(pfds[1]);
     c53:	83 ec 0c             	sub    $0xc,%esp
     c56:	ff 75 e4             	pushl  -0x1c(%ebp)
     c59:	e8 2d 2d 00 00       	call   398b <close>
     c5e:	83 c4 10             	add    $0x10,%esp
    for(;;)
     c61:	eb fe                	jmp    c61 <preempt+0x91>
     c63:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     c67:	90                   	nop
  close(pfds[1]);
     c68:	83 ec 0c             	sub    $0xc,%esp
     c6b:	ff 75 e4             	pushl  -0x1c(%ebp)
     c6e:	e8 18 2d 00 00       	call   398b <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
     c73:	83 c4 0c             	add    $0xc,%esp
     c76:	68 00 20 00 00       	push   $0x2000
     c7b:	68 80 86 00 00       	push   $0x8680
     c80:	ff 75 e0             	pushl  -0x20(%ebp)
     c83:	e8 f3 2c 00 00       	call   397b <read>
     c88:	83 c4 10             	add    $0x10,%esp
     c8b:	83 f8 01             	cmp    $0x1,%eax
     c8e:	0f 85 84 00 00 00    	jne    d18 <preempt+0x148>
  close(pfds[0]);
     c94:	83 ec 0c             	sub    $0xc,%esp
     c97:	ff 75 e0             	pushl  -0x20(%ebp)
     c9a:	e8 ec 2c 00 00       	call   398b <close>
  printf(1, "kill... ");
     c9f:	58                   	pop    %eax
     ca0:	5a                   	pop    %edx
     ca1:	68 fd 41 00 00       	push   $0x41fd
     ca6:	6a 01                	push   $0x1
     ca8:	e8 23 2e 00 00       	call   3ad0 <printf>
  kill(pid1, SIGKILL);
     cad:	59                   	pop    %ecx
     cae:	58                   	pop    %eax
     caf:	6a 09                	push   $0x9
     cb1:	57                   	push   %edi
     cb2:	e8 dc 2c 00 00       	call   3993 <kill>
  kill(pid2, SIGKILL);
     cb7:	58                   	pop    %eax
     cb8:	5a                   	pop    %edx
     cb9:	6a 09                	push   $0x9
     cbb:	56                   	push   %esi
     cbc:	e8 d2 2c 00 00       	call   3993 <kill>
  kill(pid3, SIGKILL);
     cc1:	59                   	pop    %ecx
     cc2:	5e                   	pop    %esi
     cc3:	6a 09                	push   $0x9
     cc5:	53                   	push   %ebx
     cc6:	e8 c8 2c 00 00       	call   3993 <kill>
  printf(1, "wait... ");
     ccb:	5f                   	pop    %edi
     ccc:	58                   	pop    %eax
     ccd:	68 06 42 00 00       	push   $0x4206
     cd2:	6a 01                	push   $0x1
     cd4:	e8 f7 2d 00 00       	call   3ad0 <printf>
  wait();
     cd9:	e8 8d 2c 00 00       	call   396b <wait>
  wait();
     cde:	e8 88 2c 00 00       	call   396b <wait>
  wait();
     ce3:	e8 83 2c 00 00       	call   396b <wait>
  printf(1, "preempt ok\n");
     ce8:	58                   	pop    %eax
     ce9:	5a                   	pop    %edx
     cea:	68 0f 42 00 00       	push   $0x420f
     cef:	6a 01                	push   $0x1
     cf1:	e8 da 2d 00 00       	call   3ad0 <printf>
     cf6:	83 c4 10             	add    $0x10,%esp
}
     cf9:	8d 65 f4             	lea    -0xc(%ebp),%esp
     cfc:	5b                   	pop    %ebx
     cfd:	5e                   	pop    %esi
     cfe:	5f                   	pop    %edi
     cff:	5d                   	pop    %ebp
     d00:	c3                   	ret    
      printf(1, "preempt write error");
     d01:	83 ec 08             	sub    $0x8,%esp
     d04:	68 d6 41 00 00       	push   $0x41d6
     d09:	6a 01                	push   $0x1
     d0b:	e8 c0 2d 00 00       	call   3ad0 <printf>
     d10:	83 c4 10             	add    $0x10,%esp
     d13:	e9 3b ff ff ff       	jmp    c53 <preempt+0x83>
    printf(1, "preempt read error");
     d18:	83 ec 08             	sub    $0x8,%esp
     d1b:	68 ea 41 00 00       	push   $0x41ea
     d20:	6a 01                	push   $0x1
     d22:	e8 a9 2d 00 00       	call   3ad0 <printf>
    return;
     d27:	83 c4 10             	add    $0x10,%esp
     d2a:	eb cd                	jmp    cf9 <preempt+0x129>
     d2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000d30 <exitwait>:
{
     d30:	f3 0f 1e fb          	endbr32 
     d34:	55                   	push   %ebp
     d35:	89 e5                	mov    %esp,%ebp
     d37:	56                   	push   %esi
     d38:	be 64 00 00 00       	mov    $0x64,%esi
     d3d:	53                   	push   %ebx
     d3e:	eb 10                	jmp    d50 <exitwait+0x20>
    if(pid){
     d40:	74 68                	je     daa <exitwait+0x7a>
      if(wait() != pid){
     d42:	e8 24 2c 00 00       	call   396b <wait>
     d47:	39 d8                	cmp    %ebx,%eax
     d49:	75 2d                	jne    d78 <exitwait+0x48>
  for(i = 0; i < 100; i++){
     d4b:	83 ee 01             	sub    $0x1,%esi
     d4e:	74 41                	je     d91 <exitwait+0x61>
    pid = fork();
     d50:	e8 06 2c 00 00       	call   395b <fork>
     d55:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
     d57:	85 c0                	test   %eax,%eax
     d59:	79 e5                	jns    d40 <exitwait+0x10>
      printf(1, "fork failed\n");
     d5b:	83 ec 08             	sub    $0x8,%esp
     d5e:	68 79 4d 00 00       	push   $0x4d79
     d63:	6a 01                	push   $0x1
     d65:	e8 66 2d 00 00       	call   3ad0 <printf>
      return;
     d6a:	83 c4 10             	add    $0x10,%esp
}
     d6d:	8d 65 f8             	lea    -0x8(%ebp),%esp
     d70:	5b                   	pop    %ebx
     d71:	5e                   	pop    %esi
     d72:	5d                   	pop    %ebp
     d73:	c3                   	ret    
     d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        printf(1, "wait wrong pid\n");
     d78:	83 ec 08             	sub    $0x8,%esp
     d7b:	68 1b 42 00 00       	push   $0x421b
     d80:	6a 01                	push   $0x1
     d82:	e8 49 2d 00 00       	call   3ad0 <printf>
        return;
     d87:	83 c4 10             	add    $0x10,%esp
}
     d8a:	8d 65 f8             	lea    -0x8(%ebp),%esp
     d8d:	5b                   	pop    %ebx
     d8e:	5e                   	pop    %esi
     d8f:	5d                   	pop    %ebp
     d90:	c3                   	ret    
  printf(1, "exitwait ok\n");
     d91:	83 ec 08             	sub    $0x8,%esp
     d94:	68 2b 42 00 00       	push   $0x422b
     d99:	6a 01                	push   $0x1
     d9b:	e8 30 2d 00 00       	call   3ad0 <printf>
     da0:	83 c4 10             	add    $0x10,%esp
}
     da3:	8d 65 f8             	lea    -0x8(%ebp),%esp
     da6:	5b                   	pop    %ebx
     da7:	5e                   	pop    %esi
     da8:	5d                   	pop    %ebp
     da9:	c3                   	ret    
      exit();
     daa:	e8 b4 2b 00 00       	call   3963 <exit>
     daf:	90                   	nop

00000db0 <mem>:
{
     db0:	f3 0f 1e fb          	endbr32 
     db4:	55                   	push   %ebp
     db5:	89 e5                	mov    %esp,%ebp
     db7:	56                   	push   %esi
     db8:	31 f6                	xor    %esi,%esi
     dba:	53                   	push   %ebx
  printf(1, "mem test\n");
     dbb:	83 ec 08             	sub    $0x8,%esp
     dbe:	68 38 42 00 00       	push   $0x4238
     dc3:	6a 01                	push   $0x1
     dc5:	e8 06 2d 00 00       	call   3ad0 <printf>
  ppid = getpid();
     dca:	e8 14 2c 00 00       	call   39e3 <getpid>
     dcf:	89 c3                	mov    %eax,%ebx
  if((pid = fork()) == 0){
     dd1:	e8 85 2b 00 00       	call   395b <fork>
     dd6:	83 c4 10             	add    $0x10,%esp
     dd9:	85 c0                	test   %eax,%eax
     ddb:	74 0f                	je     dec <mem+0x3c>
     ddd:	e9 8e 00 00 00       	jmp    e70 <mem+0xc0>
     de2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      *(char**)m2 = m1;
     de8:	89 30                	mov    %esi,(%eax)
     dea:	89 c6                	mov    %eax,%esi
    while((m2 = malloc(10001)) != 0){
     dec:	83 ec 0c             	sub    $0xc,%esp
     def:	68 11 27 00 00       	push   $0x2711
     df4:	e8 37 2f 00 00       	call   3d30 <malloc>
     df9:	83 c4 10             	add    $0x10,%esp
     dfc:	85 c0                	test   %eax,%eax
     dfe:	75 e8                	jne    de8 <mem+0x38>
    while(m1){
     e00:	85 f6                	test   %esi,%esi
     e02:	74 18                	je     e1c <mem+0x6c>
     e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      m2 = *(char**)m1;
     e08:	89 f0                	mov    %esi,%eax
      free(m1);
     e0a:	83 ec 0c             	sub    $0xc,%esp
      m2 = *(char**)m1;
     e0d:	8b 36                	mov    (%esi),%esi
      free(m1);
     e0f:	50                   	push   %eax
     e10:	e8 8b 2e 00 00       	call   3ca0 <free>
    while(m1){
     e15:	83 c4 10             	add    $0x10,%esp
     e18:	85 f6                	test   %esi,%esi
     e1a:	75 ec                	jne    e08 <mem+0x58>
    m1 = malloc(1024*20);
     e1c:	83 ec 0c             	sub    $0xc,%esp
     e1f:	68 00 50 00 00       	push   $0x5000
     e24:	e8 07 2f 00 00       	call   3d30 <malloc>
    if(m1 == 0){
     e29:	83 c4 10             	add    $0x10,%esp
     e2c:	85 c0                	test   %eax,%eax
     e2e:	74 20                	je     e50 <mem+0xa0>
    free(m1);
     e30:	83 ec 0c             	sub    $0xc,%esp
     e33:	50                   	push   %eax
     e34:	e8 67 2e 00 00       	call   3ca0 <free>
    printf(1, "mem ok\n");
     e39:	58                   	pop    %eax
     e3a:	5a                   	pop    %edx
     e3b:	68 5c 42 00 00       	push   $0x425c
     e40:	6a 01                	push   $0x1
     e42:	e8 89 2c 00 00       	call   3ad0 <printf>
    exit();
     e47:	e8 17 2b 00 00       	call   3963 <exit>
     e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      printf(1, "couldn't allocate mem?!!\n");
     e50:	83 ec 08             	sub    $0x8,%esp
     e53:	68 42 42 00 00       	push   $0x4242
     e58:	6a 01                	push   $0x1
     e5a:	e8 71 2c 00 00       	call   3ad0 <printf>
      kill(ppid, SIGKILL);
     e5f:	59                   	pop    %ecx
     e60:	5e                   	pop    %esi
     e61:	6a 09                	push   $0x9
     e63:	53                   	push   %ebx
     e64:	e8 2a 2b 00 00       	call   3993 <kill>
      exit();
     e69:	e8 f5 2a 00 00       	call   3963 <exit>
     e6e:	66 90                	xchg   %ax,%ax
}
     e70:	8d 65 f8             	lea    -0x8(%ebp),%esp
     e73:	5b                   	pop    %ebx
     e74:	5e                   	pop    %esi
     e75:	5d                   	pop    %ebp
    wait();
     e76:	e9 f0 2a 00 00       	jmp    396b <wait>
     e7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     e7f:	90                   	nop

00000e80 <sharedfd>:
{
     e80:	f3 0f 1e fb          	endbr32 
     e84:	55                   	push   %ebp
     e85:	89 e5                	mov    %esp,%ebp
     e87:	57                   	push   %edi
     e88:	56                   	push   %esi
     e89:	53                   	push   %ebx
     e8a:	83 ec 34             	sub    $0x34,%esp
  printf(1, "sharedfd test\n");
     e8d:	68 64 42 00 00       	push   $0x4264
     e92:	6a 01                	push   $0x1
     e94:	e8 37 2c 00 00       	call   3ad0 <printf>
  unlink("sharedfd");
     e99:	c7 04 24 73 42 00 00 	movl   $0x4273,(%esp)
     ea0:	e8 0e 2b 00 00       	call   39b3 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
     ea5:	5b                   	pop    %ebx
     ea6:	5e                   	pop    %esi
     ea7:	68 02 02 00 00       	push   $0x202
     eac:	68 73 42 00 00       	push   $0x4273
     eb1:	e8 ed 2a 00 00       	call   39a3 <open>
  if(fd < 0){
     eb6:	83 c4 10             	add    $0x10,%esp
     eb9:	85 c0                	test   %eax,%eax
     ebb:	0f 88 26 01 00 00    	js     fe7 <sharedfd+0x167>
     ec1:	89 c7                	mov    %eax,%edi
  memset(buf, pid==0?'c':'p', sizeof(buf));
     ec3:	8d 75 de             	lea    -0x22(%ebp),%esi
     ec6:	bb e8 03 00 00       	mov    $0x3e8,%ebx
  pid = fork();
     ecb:	e8 8b 2a 00 00       	call   395b <fork>
  memset(buf, pid==0?'c':'p', sizeof(buf));
     ed0:	83 f8 01             	cmp    $0x1,%eax
  pid = fork();
     ed3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  memset(buf, pid==0?'c':'p', sizeof(buf));
     ed6:	19 c0                	sbb    %eax,%eax
     ed8:	83 ec 04             	sub    $0x4,%esp
     edb:	83 e0 f3             	and    $0xfffffff3,%eax
     ede:	6a 0a                	push   $0xa
     ee0:	83 c0 70             	add    $0x70,%eax
     ee3:	50                   	push   %eax
     ee4:	56                   	push   %esi
     ee5:	e8 d6 28 00 00       	call   37c0 <memset>
     eea:	83 c4 10             	add    $0x10,%esp
     eed:	eb 06                	jmp    ef5 <sharedfd+0x75>
     eef:	90                   	nop
  for(i = 0; i < 1000; i++){
     ef0:	83 eb 01             	sub    $0x1,%ebx
     ef3:	74 26                	je     f1b <sharedfd+0x9b>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
     ef5:	83 ec 04             	sub    $0x4,%esp
     ef8:	6a 0a                	push   $0xa
     efa:	56                   	push   %esi
     efb:	57                   	push   %edi
     efc:	e8 82 2a 00 00       	call   3983 <write>
     f01:	83 c4 10             	add    $0x10,%esp
     f04:	83 f8 0a             	cmp    $0xa,%eax
     f07:	74 e7                	je     ef0 <sharedfd+0x70>
      printf(1, "fstests: write sharedfd failed\n");
     f09:	83 ec 08             	sub    $0x8,%esp
     f0c:	68 64 4f 00 00       	push   $0x4f64
     f11:	6a 01                	push   $0x1
     f13:	e8 b8 2b 00 00       	call   3ad0 <printf>
      break;
     f18:	83 c4 10             	add    $0x10,%esp
  if(pid == 0)
     f1b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
     f1e:	85 c9                	test   %ecx,%ecx
     f20:	0f 84 f5 00 00 00    	je     101b <sharedfd+0x19b>
    wait();
     f26:	e8 40 2a 00 00       	call   396b <wait>
  close(fd);
     f2b:	83 ec 0c             	sub    $0xc,%esp
  nc = np = 0;
     f2e:	31 db                	xor    %ebx,%ebx
  close(fd);
     f30:	57                   	push   %edi
     f31:	8d 7d e8             	lea    -0x18(%ebp),%edi
     f34:	e8 52 2a 00 00       	call   398b <close>
  fd = open("sharedfd", 0);
     f39:	58                   	pop    %eax
     f3a:	5a                   	pop    %edx
     f3b:	6a 00                	push   $0x0
     f3d:	68 73 42 00 00       	push   $0x4273
     f42:	e8 5c 2a 00 00       	call   39a3 <open>
  if(fd < 0){
     f47:	83 c4 10             	add    $0x10,%esp
  nc = np = 0;
     f4a:	31 d2                	xor    %edx,%edx
  fd = open("sharedfd", 0);
     f4c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  if(fd < 0){
     f4f:	85 c0                	test   %eax,%eax
     f51:	0f 88 aa 00 00 00    	js     1001 <sharedfd+0x181>
     f57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     f5e:	66 90                	xchg   %ax,%ax
  while((n = read(fd, buf, sizeof(buf))) > 0){
     f60:	83 ec 04             	sub    $0x4,%esp
     f63:	89 55 d4             	mov    %edx,-0x2c(%ebp)
     f66:	6a 0a                	push   $0xa
     f68:	56                   	push   %esi
     f69:	ff 75 d0             	pushl  -0x30(%ebp)
     f6c:	e8 0a 2a 00 00       	call   397b <read>
     f71:	83 c4 10             	add    $0x10,%esp
     f74:	85 c0                	test   %eax,%eax
     f76:	7e 28                	jle    fa0 <sharedfd+0x120>
    for(i = 0; i < sizeof(buf); i++){
     f78:	8b 55 d4             	mov    -0x2c(%ebp),%edx
     f7b:	89 f0                	mov    %esi,%eax
     f7d:	eb 13                	jmp    f92 <sharedfd+0x112>
     f7f:	90                   	nop
        np++;
     f80:	80 f9 70             	cmp    $0x70,%cl
     f83:	0f 94 c1             	sete   %cl
     f86:	0f b6 c9             	movzbl %cl,%ecx
     f89:	01 cb                	add    %ecx,%ebx
    for(i = 0; i < sizeof(buf); i++){
     f8b:	83 c0 01             	add    $0x1,%eax
     f8e:	39 c7                	cmp    %eax,%edi
     f90:	74 ce                	je     f60 <sharedfd+0xe0>
      if(buf[i] == 'c')
     f92:	0f b6 08             	movzbl (%eax),%ecx
     f95:	80 f9 63             	cmp    $0x63,%cl
     f98:	75 e6                	jne    f80 <sharedfd+0x100>
        nc++;
     f9a:	83 c2 01             	add    $0x1,%edx
      if(buf[i] == 'p')
     f9d:	eb ec                	jmp    f8b <sharedfd+0x10b>
     f9f:	90                   	nop
  close(fd);
     fa0:	83 ec 0c             	sub    $0xc,%esp
     fa3:	ff 75 d0             	pushl  -0x30(%ebp)
     fa6:	e8 e0 29 00 00       	call   398b <close>
  unlink("sharedfd");
     fab:	c7 04 24 73 42 00 00 	movl   $0x4273,(%esp)
     fb2:	e8 fc 29 00 00       	call   39b3 <unlink>
  if(nc == 10000 && np == 10000){
     fb7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
     fba:	83 c4 10             	add    $0x10,%esp
     fbd:	81 fa 10 27 00 00    	cmp    $0x2710,%edx
     fc3:	75 5b                	jne    1020 <sharedfd+0x1a0>
     fc5:	81 fb 10 27 00 00    	cmp    $0x2710,%ebx
     fcb:	75 53                	jne    1020 <sharedfd+0x1a0>
    printf(1, "sharedfd ok\n");
     fcd:	83 ec 08             	sub    $0x8,%esp
     fd0:	68 7c 42 00 00       	push   $0x427c
     fd5:	6a 01                	push   $0x1
     fd7:	e8 f4 2a 00 00       	call   3ad0 <printf>
     fdc:	83 c4 10             	add    $0x10,%esp
}
     fdf:	8d 65 f4             	lea    -0xc(%ebp),%esp
     fe2:	5b                   	pop    %ebx
     fe3:	5e                   	pop    %esi
     fe4:	5f                   	pop    %edi
     fe5:	5d                   	pop    %ebp
     fe6:	c3                   	ret    
    printf(1, "fstests: cannot open sharedfd for writing");
     fe7:	83 ec 08             	sub    $0x8,%esp
     fea:	68 38 4f 00 00       	push   $0x4f38
     fef:	6a 01                	push   $0x1
     ff1:	e8 da 2a 00 00       	call   3ad0 <printf>
    return;
     ff6:	83 c4 10             	add    $0x10,%esp
}
     ff9:	8d 65 f4             	lea    -0xc(%ebp),%esp
     ffc:	5b                   	pop    %ebx
     ffd:	5e                   	pop    %esi
     ffe:	5f                   	pop    %edi
     fff:	5d                   	pop    %ebp
    1000:	c3                   	ret    
    printf(1, "fstests: cannot open sharedfd for reading\n");
    1001:	83 ec 08             	sub    $0x8,%esp
    1004:	68 84 4f 00 00       	push   $0x4f84
    1009:	6a 01                	push   $0x1
    100b:	e8 c0 2a 00 00       	call   3ad0 <printf>
    return;
    1010:	83 c4 10             	add    $0x10,%esp
}
    1013:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1016:	5b                   	pop    %ebx
    1017:	5e                   	pop    %esi
    1018:	5f                   	pop    %edi
    1019:	5d                   	pop    %ebp
    101a:	c3                   	ret    
    exit();
    101b:	e8 43 29 00 00       	call   3963 <exit>
    printf(1, "sharedfd oops %d %d\n", nc, np);
    1020:	53                   	push   %ebx
    1021:	52                   	push   %edx
    1022:	68 89 42 00 00       	push   $0x4289
    1027:	6a 01                	push   $0x1
    1029:	e8 a2 2a 00 00       	call   3ad0 <printf>
    exit();
    102e:	e8 30 29 00 00       	call   3963 <exit>
    1033:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    103a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00001040 <fourfiles>:
{
    1040:	f3 0f 1e fb          	endbr32 
    1044:	55                   	push   %ebp
    1045:	89 e5                	mov    %esp,%ebp
    1047:	57                   	push   %edi
    1048:	56                   	push   %esi
  printf(1, "fourfiles test\n");
    1049:	be 9e 42 00 00       	mov    $0x429e,%esi
{
    104e:	53                   	push   %ebx
  for(pi = 0; pi < 4; pi++){
    104f:	31 db                	xor    %ebx,%ebx
{
    1051:	83 ec 34             	sub    $0x34,%esp
  char *names[] = { "f0", "f1", "f2", "f3" };
    1054:	c7 45 d8 9e 42 00 00 	movl   $0x429e,-0x28(%ebp)
  printf(1, "fourfiles test\n");
    105b:	68 a4 42 00 00       	push   $0x42a4
    1060:	6a 01                	push   $0x1
  char *names[] = { "f0", "f1", "f2", "f3" };
    1062:	c7 45 dc e7 43 00 00 	movl   $0x43e7,-0x24(%ebp)
    1069:	c7 45 e0 eb 43 00 00 	movl   $0x43eb,-0x20(%ebp)
    1070:	c7 45 e4 a1 42 00 00 	movl   $0x42a1,-0x1c(%ebp)
  printf(1, "fourfiles test\n");
    1077:	e8 54 2a 00 00       	call   3ad0 <printf>
    107c:	83 c4 10             	add    $0x10,%esp
    unlink(fname);
    107f:	83 ec 0c             	sub    $0xc,%esp
    1082:	56                   	push   %esi
    1083:	e8 2b 29 00 00       	call   39b3 <unlink>
    pid = fork();
    1088:	e8 ce 28 00 00       	call   395b <fork>
    if(pid < 0){
    108d:	83 c4 10             	add    $0x10,%esp
    1090:	85 c0                	test   %eax,%eax
    1092:	0f 88 60 01 00 00    	js     11f8 <fourfiles+0x1b8>
    if(pid == 0){
    1098:	0f 84 e5 00 00 00    	je     1183 <fourfiles+0x143>
  for(pi = 0; pi < 4; pi++){
    109e:	83 c3 01             	add    $0x1,%ebx
    10a1:	83 fb 04             	cmp    $0x4,%ebx
    10a4:	74 06                	je     10ac <fourfiles+0x6c>
    10a6:	8b 74 9d d8          	mov    -0x28(%ebp,%ebx,4),%esi
    10aa:	eb d3                	jmp    107f <fourfiles+0x3f>
    wait();
    10ac:	e8 ba 28 00 00       	call   396b <wait>
  for(i = 0; i < 2; i++){
    10b1:	31 f6                	xor    %esi,%esi
    wait();
    10b3:	e8 b3 28 00 00       	call   396b <wait>
    10b8:	e8 ae 28 00 00       	call   396b <wait>
    10bd:	e8 a9 28 00 00       	call   396b <wait>
    fname = names[i];
    10c2:	8b 44 b5 d8          	mov    -0x28(%ebp,%esi,4),%eax
    fd = open(fname, 0);
    10c6:	83 ec 08             	sub    $0x8,%esp
    total = 0;
    10c9:	31 db                	xor    %ebx,%ebx
    fd = open(fname, 0);
    10cb:	6a 00                	push   $0x0
    10cd:	50                   	push   %eax
    fname = names[i];
    10ce:	89 45 d0             	mov    %eax,-0x30(%ebp)
    fd = open(fname, 0);
    10d1:	e8 cd 28 00 00       	call   39a3 <open>
    while((n = read(fd, buf, sizeof(buf))) > 0){
    10d6:	83 c4 10             	add    $0x10,%esp
    fd = open(fname, 0);
    10d9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    10dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    10e0:	83 ec 04             	sub    $0x4,%esp
    10e3:	68 00 20 00 00       	push   $0x2000
    10e8:	68 80 86 00 00       	push   $0x8680
    10ed:	ff 75 d4             	pushl  -0x2c(%ebp)
    10f0:	e8 86 28 00 00       	call   397b <read>
    10f5:	83 c4 10             	add    $0x10,%esp
    10f8:	85 c0                	test   %eax,%eax
    10fa:	7e 22                	jle    111e <fourfiles+0xde>
      for(j = 0; j < n; j++){
    10fc:	31 d2                	xor    %edx,%edx
    10fe:	66 90                	xchg   %ax,%ax
        if(buf[j] != '0'+i){
    1100:	83 fe 01             	cmp    $0x1,%esi
    1103:	0f be ba 80 86 00 00 	movsbl 0x8680(%edx),%edi
    110a:	19 c9                	sbb    %ecx,%ecx
    110c:	83 c1 31             	add    $0x31,%ecx
    110f:	39 cf                	cmp    %ecx,%edi
    1111:	75 5c                	jne    116f <fourfiles+0x12f>
      for(j = 0; j < n; j++){
    1113:	83 c2 01             	add    $0x1,%edx
    1116:	39 d0                	cmp    %edx,%eax
    1118:	75 e6                	jne    1100 <fourfiles+0xc0>
      total += n;
    111a:	01 c3                	add    %eax,%ebx
    111c:	eb c2                	jmp    10e0 <fourfiles+0xa0>
    close(fd);
    111e:	83 ec 0c             	sub    $0xc,%esp
    1121:	ff 75 d4             	pushl  -0x2c(%ebp)
    1124:	e8 62 28 00 00       	call   398b <close>
    if(total != 12*500){
    1129:	83 c4 10             	add    $0x10,%esp
    112c:	81 fb 70 17 00 00    	cmp    $0x1770,%ebx
    1132:	0f 85 d4 00 00 00    	jne    120c <fourfiles+0x1cc>
    unlink(fname);
    1138:	83 ec 0c             	sub    $0xc,%esp
    113b:	ff 75 d0             	pushl  -0x30(%ebp)
    113e:	e8 70 28 00 00       	call   39b3 <unlink>
  for(i = 0; i < 2; i++){
    1143:	83 c4 10             	add    $0x10,%esp
    1146:	83 fe 01             	cmp    $0x1,%esi
    1149:	75 1a                	jne    1165 <fourfiles+0x125>
  printf(1, "fourfiles ok\n");
    114b:	83 ec 08             	sub    $0x8,%esp
    114e:	68 e2 42 00 00       	push   $0x42e2
    1153:	6a 01                	push   $0x1
    1155:	e8 76 29 00 00       	call   3ad0 <printf>
}
    115a:	83 c4 10             	add    $0x10,%esp
    115d:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1160:	5b                   	pop    %ebx
    1161:	5e                   	pop    %esi
    1162:	5f                   	pop    %edi
    1163:	5d                   	pop    %ebp
    1164:	c3                   	ret    
    1165:	be 01 00 00 00       	mov    $0x1,%esi
    116a:	e9 53 ff ff ff       	jmp    10c2 <fourfiles+0x82>
          printf(1, "wrong char\n");
    116f:	83 ec 08             	sub    $0x8,%esp
    1172:	68 c5 42 00 00       	push   $0x42c5
    1177:	6a 01                	push   $0x1
    1179:	e8 52 29 00 00       	call   3ad0 <printf>
          exit();
    117e:	e8 e0 27 00 00       	call   3963 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    1183:	83 ec 08             	sub    $0x8,%esp
    1186:	68 02 02 00 00       	push   $0x202
    118b:	56                   	push   %esi
    118c:	e8 12 28 00 00       	call   39a3 <open>
      if(fd < 0){
    1191:	83 c4 10             	add    $0x10,%esp
      fd = open(fname, O_CREATE | O_RDWR);
    1194:	89 c6                	mov    %eax,%esi
      if(fd < 0){
    1196:	85 c0                	test   %eax,%eax
    1198:	78 45                	js     11df <fourfiles+0x19f>
      memset(buf, '0'+pi, 512);
    119a:	83 ec 04             	sub    $0x4,%esp
    119d:	83 c3 30             	add    $0x30,%ebx
    11a0:	68 00 02 00 00       	push   $0x200
    11a5:	53                   	push   %ebx
    11a6:	bb 0c 00 00 00       	mov    $0xc,%ebx
    11ab:	68 80 86 00 00       	push   $0x8680
    11b0:	e8 0b 26 00 00       	call   37c0 <memset>
    11b5:	83 c4 10             	add    $0x10,%esp
        if((n = write(fd, buf, 500)) != 500){
    11b8:	83 ec 04             	sub    $0x4,%esp
    11bb:	68 f4 01 00 00       	push   $0x1f4
    11c0:	68 80 86 00 00       	push   $0x8680
    11c5:	56                   	push   %esi
    11c6:	e8 b8 27 00 00       	call   3983 <write>
    11cb:	83 c4 10             	add    $0x10,%esp
    11ce:	3d f4 01 00 00       	cmp    $0x1f4,%eax
    11d3:	75 4a                	jne    121f <fourfiles+0x1df>
      for(i = 0; i < 12; i++){
    11d5:	83 eb 01             	sub    $0x1,%ebx
    11d8:	75 de                	jne    11b8 <fourfiles+0x178>
      exit();
    11da:	e8 84 27 00 00       	call   3963 <exit>
        printf(1, "create failed\n");
    11df:	51                   	push   %ecx
    11e0:	51                   	push   %ecx
    11e1:	68 3f 45 00 00       	push   $0x453f
    11e6:	6a 01                	push   $0x1
    11e8:	e8 e3 28 00 00       	call   3ad0 <printf>
        exit();
    11ed:	e8 71 27 00 00       	call   3963 <exit>
    11f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      printf(1, "fork failed\n");
    11f8:	83 ec 08             	sub    $0x8,%esp
    11fb:	68 79 4d 00 00       	push   $0x4d79
    1200:	6a 01                	push   $0x1
    1202:	e8 c9 28 00 00       	call   3ad0 <printf>
      exit();
    1207:	e8 57 27 00 00       	call   3963 <exit>
      printf(1, "wrong length %d\n", total);
    120c:	50                   	push   %eax
    120d:	53                   	push   %ebx
    120e:	68 d1 42 00 00       	push   $0x42d1
    1213:	6a 01                	push   $0x1
    1215:	e8 b6 28 00 00       	call   3ad0 <printf>
      exit();
    121a:	e8 44 27 00 00       	call   3963 <exit>
          printf(1, "write failed %d\n", n);
    121f:	52                   	push   %edx
    1220:	50                   	push   %eax
    1221:	68 b4 42 00 00       	push   $0x42b4
    1226:	6a 01                	push   $0x1
    1228:	e8 a3 28 00 00       	call   3ad0 <printf>
          exit();
    122d:	e8 31 27 00 00       	call   3963 <exit>
    1232:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00001240 <createdelete>:
{
    1240:	f3 0f 1e fb          	endbr32 
    1244:	55                   	push   %ebp
    1245:	89 e5                	mov    %esp,%ebp
    1247:	57                   	push   %edi
    1248:	56                   	push   %esi
    1249:	53                   	push   %ebx
  for(pi = 0; pi < 4; pi++){
    124a:	31 db                	xor    %ebx,%ebx
{
    124c:	83 ec 44             	sub    $0x44,%esp
  printf(1, "createdelete test\n");
    124f:	68 f0 42 00 00       	push   $0x42f0
    1254:	6a 01                	push   $0x1
    1256:	e8 75 28 00 00       	call   3ad0 <printf>
    125b:	83 c4 10             	add    $0x10,%esp
    pid = fork();
    125e:	e8 f8 26 00 00       	call   395b <fork>
    if(pid < 0){
    1263:	85 c0                	test   %eax,%eax
    1265:	0f 88 ce 01 00 00    	js     1439 <createdelete+0x1f9>
    if(pid == 0){
    126b:	0f 84 17 01 00 00    	je     1388 <createdelete+0x148>
  for(pi = 0; pi < 4; pi++){
    1271:	83 c3 01             	add    $0x1,%ebx
    1274:	83 fb 04             	cmp    $0x4,%ebx
    1277:	75 e5                	jne    125e <createdelete+0x1e>
    wait();
    1279:	e8 ed 26 00 00       	call   396b <wait>
    127e:	8d 7d c8             	lea    -0x38(%ebp),%edi
  name[0] = name[1] = name[2] = 0;
    1281:	be ff ff ff ff       	mov    $0xffffffff,%esi
    wait();
    1286:	e8 e0 26 00 00       	call   396b <wait>
    128b:	e8 db 26 00 00       	call   396b <wait>
    1290:	e8 d6 26 00 00       	call   396b <wait>
  name[0] = name[1] = name[2] = 0;
    1295:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
  for(i = 0; i < N; i++){
    1299:	89 7d c0             	mov    %edi,-0x40(%ebp)
    129c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(pi = 0; pi < 4; pi++){
    12a0:	8d 46 31             	lea    0x31(%esi),%eax
    12a3:	89 f7                	mov    %esi,%edi
    12a5:	83 c6 01             	add    $0x1,%esi
    12a8:	83 fe 09             	cmp    $0x9,%esi
    12ab:	88 45 c7             	mov    %al,-0x39(%ebp)
    12ae:	0f 9f c3             	setg   %bl
    12b1:	85 f6                	test   %esi,%esi
    12b3:	0f 94 c0             	sete   %al
    12b6:	09 c3                	or     %eax,%ebx
    12b8:	88 5d c6             	mov    %bl,-0x3a(%ebp)
      name[2] = '\0';
    12bb:	bb 70 00 00 00       	mov    $0x70,%ebx
      fd = open(name, 0);
    12c0:	83 ec 08             	sub    $0x8,%esp
      name[1] = '0' + i;
    12c3:	0f b6 45 c7          	movzbl -0x39(%ebp),%eax
      name[0] = 'p' + pi;
    12c7:	88 5d c8             	mov    %bl,-0x38(%ebp)
      fd = open(name, 0);
    12ca:	6a 00                	push   $0x0
    12cc:	ff 75 c0             	pushl  -0x40(%ebp)
      name[1] = '0' + i;
    12cf:	88 45 c9             	mov    %al,-0x37(%ebp)
      fd = open(name, 0);
    12d2:	e8 cc 26 00 00       	call   39a3 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    12d7:	83 c4 10             	add    $0x10,%esp
    12da:	80 7d c6 00          	cmpb   $0x0,-0x3a(%ebp)
    12de:	0f 84 8c 00 00 00    	je     1370 <createdelete+0x130>
    12e4:	85 c0                	test   %eax,%eax
    12e6:	0f 88 21 01 00 00    	js     140d <createdelete+0x1cd>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    12ec:	83 ff 08             	cmp    $0x8,%edi
    12ef:	0f 86 60 01 00 00    	jbe    1455 <createdelete+0x215>
        close(fd);
    12f5:	83 ec 0c             	sub    $0xc,%esp
    12f8:	50                   	push   %eax
    12f9:	e8 8d 26 00 00       	call   398b <close>
    12fe:	83 c4 10             	add    $0x10,%esp
    for(pi = 0; pi < 4; pi++){
    1301:	83 c3 01             	add    $0x1,%ebx
    1304:	80 fb 74             	cmp    $0x74,%bl
    1307:	75 b7                	jne    12c0 <createdelete+0x80>
  for(i = 0; i < N; i++){
    1309:	83 fe 13             	cmp    $0x13,%esi
    130c:	75 92                	jne    12a0 <createdelete+0x60>
    130e:	8b 7d c0             	mov    -0x40(%ebp),%edi
    1311:	be 70 00 00 00       	mov    $0x70,%esi
    1316:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    131d:	8d 76 00             	lea    0x0(%esi),%esi
    for(pi = 0; pi < 4; pi++){
    1320:	8d 46 c0             	lea    -0x40(%esi),%eax
  name[0] = name[1] = name[2] = 0;
    1323:	bb 04 00 00 00       	mov    $0x4,%ebx
    1328:	88 45 c7             	mov    %al,-0x39(%ebp)
      unlink(name);
    132b:	83 ec 0c             	sub    $0xc,%esp
      name[0] = 'p' + i;
    132e:	89 f0                	mov    %esi,%eax
      unlink(name);
    1330:	57                   	push   %edi
      name[0] = 'p' + i;
    1331:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[1] = '0' + i;
    1334:	0f b6 45 c7          	movzbl -0x39(%ebp),%eax
    1338:	88 45 c9             	mov    %al,-0x37(%ebp)
      unlink(name);
    133b:	e8 73 26 00 00       	call   39b3 <unlink>
    for(pi = 0; pi < 4; pi++){
    1340:	83 c4 10             	add    $0x10,%esp
    1343:	83 eb 01             	sub    $0x1,%ebx
    1346:	75 e3                	jne    132b <createdelete+0xeb>
  for(i = 0; i < N; i++){
    1348:	83 c6 01             	add    $0x1,%esi
    134b:	89 f0                	mov    %esi,%eax
    134d:	3c 84                	cmp    $0x84,%al
    134f:	75 cf                	jne    1320 <createdelete+0xe0>
  printf(1, "createdelete ok\n");
    1351:	83 ec 08             	sub    $0x8,%esp
    1354:	68 03 43 00 00       	push   $0x4303
    1359:	6a 01                	push   $0x1
    135b:	e8 70 27 00 00       	call   3ad0 <printf>
}
    1360:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1363:	5b                   	pop    %ebx
    1364:	5e                   	pop    %esi
    1365:	5f                   	pop    %edi
    1366:	5d                   	pop    %ebp
    1367:	c3                   	ret    
    1368:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    136f:	90                   	nop
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1370:	83 ff 08             	cmp    $0x8,%edi
    1373:	0f 86 d4 00 00 00    	jbe    144d <createdelete+0x20d>
      if(fd >= 0)
    1379:	85 c0                	test   %eax,%eax
    137b:	78 84                	js     1301 <createdelete+0xc1>
    137d:	e9 73 ff ff ff       	jmp    12f5 <createdelete+0xb5>
    1382:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      name[0] = 'p' + pi;
    1388:	83 c3 70             	add    $0x70,%ebx
      name[2] = '\0';
    138b:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
    138f:	8d 7d c8             	lea    -0x38(%ebp),%edi
      name[0] = 'p' + pi;
    1392:	88 5d c8             	mov    %bl,-0x38(%ebp)
      name[2] = '\0';
    1395:	31 db                	xor    %ebx,%ebx
    1397:	eb 0f                	jmp    13a8 <createdelete+0x168>
    1399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      for(i = 0; i < N; i++){
    13a0:	83 fb 13             	cmp    $0x13,%ebx
    13a3:	74 63                	je     1408 <createdelete+0x1c8>
    13a5:	83 c3 01             	add    $0x1,%ebx
        fd = open(name, O_CREATE | O_RDWR);
    13a8:	83 ec 08             	sub    $0x8,%esp
        name[1] = '0' + i;
    13ab:	8d 43 30             	lea    0x30(%ebx),%eax
        fd = open(name, O_CREATE | O_RDWR);
    13ae:	68 02 02 00 00       	push   $0x202
    13b3:	57                   	push   %edi
        name[1] = '0' + i;
    13b4:	88 45 c9             	mov    %al,-0x37(%ebp)
        fd = open(name, O_CREATE | O_RDWR);
    13b7:	e8 e7 25 00 00       	call   39a3 <open>
        if(fd < 0){
    13bc:	83 c4 10             	add    $0x10,%esp
    13bf:	85 c0                	test   %eax,%eax
    13c1:	78 62                	js     1425 <createdelete+0x1e5>
        close(fd);
    13c3:	83 ec 0c             	sub    $0xc,%esp
    13c6:	50                   	push   %eax
    13c7:	e8 bf 25 00 00       	call   398b <close>
        if(i > 0 && (i % 2 ) == 0){
    13cc:	83 c4 10             	add    $0x10,%esp
    13cf:	85 db                	test   %ebx,%ebx
    13d1:	74 d2                	je     13a5 <createdelete+0x165>
    13d3:	f6 c3 01             	test   $0x1,%bl
    13d6:	75 c8                	jne    13a0 <createdelete+0x160>
          if(unlink(name) < 0){
    13d8:	83 ec 0c             	sub    $0xc,%esp
          name[1] = '0' + (i / 2);
    13db:	89 d8                	mov    %ebx,%eax
          if(unlink(name) < 0){
    13dd:	57                   	push   %edi
          name[1] = '0' + (i / 2);
    13de:	d1 f8                	sar    %eax
    13e0:	83 c0 30             	add    $0x30,%eax
    13e3:	88 45 c9             	mov    %al,-0x37(%ebp)
          if(unlink(name) < 0){
    13e6:	e8 c8 25 00 00       	call   39b3 <unlink>
    13eb:	83 c4 10             	add    $0x10,%esp
    13ee:	85 c0                	test   %eax,%eax
    13f0:	79 ae                	jns    13a0 <createdelete+0x160>
            printf(1, "unlink failed\n");
    13f2:	52                   	push   %edx
    13f3:	52                   	push   %edx
    13f4:	68 f1 3e 00 00       	push   $0x3ef1
    13f9:	6a 01                	push   $0x1
    13fb:	e8 d0 26 00 00       	call   3ad0 <printf>
            exit();
    1400:	e8 5e 25 00 00       	call   3963 <exit>
    1405:	8d 76 00             	lea    0x0(%esi),%esi
      exit();
    1408:	e8 56 25 00 00       	call   3963 <exit>
    140d:	8b 7d c0             	mov    -0x40(%ebp),%edi
        printf(1, "oops createdelete %s didn't exist\n", name);
    1410:	83 ec 04             	sub    $0x4,%esp
    1413:	57                   	push   %edi
    1414:	68 b0 4f 00 00       	push   $0x4fb0
    1419:	6a 01                	push   $0x1
    141b:	e8 b0 26 00 00       	call   3ad0 <printf>
        exit();
    1420:	e8 3e 25 00 00       	call   3963 <exit>
          printf(1, "create failed\n");
    1425:	83 ec 08             	sub    $0x8,%esp
    1428:	68 3f 45 00 00       	push   $0x453f
    142d:	6a 01                	push   $0x1
    142f:	e8 9c 26 00 00       	call   3ad0 <printf>
          exit();
    1434:	e8 2a 25 00 00       	call   3963 <exit>
      printf(1, "fork failed\n");
    1439:	83 ec 08             	sub    $0x8,%esp
    143c:	68 79 4d 00 00       	push   $0x4d79
    1441:	6a 01                	push   $0x1
    1443:	e8 88 26 00 00       	call   3ad0 <printf>
      exit();
    1448:	e8 16 25 00 00       	call   3963 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    144d:	85 c0                	test   %eax,%eax
    144f:	0f 88 ac fe ff ff    	js     1301 <createdelete+0xc1>
    1455:	8b 7d c0             	mov    -0x40(%ebp),%edi
        printf(1, "oops createdelete %s did exist\n", name);
    1458:	50                   	push   %eax
    1459:	57                   	push   %edi
    145a:	68 d4 4f 00 00       	push   $0x4fd4
    145f:	6a 01                	push   $0x1
    1461:	e8 6a 26 00 00       	call   3ad0 <printf>
        exit();
    1466:	e8 f8 24 00 00       	call   3963 <exit>
    146b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    146f:	90                   	nop

00001470 <unlinkread>:
{
    1470:	f3 0f 1e fb          	endbr32 
    1474:	55                   	push   %ebp
    1475:	89 e5                	mov    %esp,%ebp
    1477:	56                   	push   %esi
    1478:	53                   	push   %ebx
  printf(1, "unlinkread test\n");
    1479:	83 ec 08             	sub    $0x8,%esp
    147c:	68 14 43 00 00       	push   $0x4314
    1481:	6a 01                	push   $0x1
    1483:	e8 48 26 00 00       	call   3ad0 <printf>
  fd = open("unlinkread", O_CREATE | O_RDWR);
    1488:	5b                   	pop    %ebx
    1489:	5e                   	pop    %esi
    148a:	68 02 02 00 00       	push   $0x202
    148f:	68 25 43 00 00       	push   $0x4325
    1494:	e8 0a 25 00 00       	call   39a3 <open>
  if(fd < 0){
    1499:	83 c4 10             	add    $0x10,%esp
    149c:	85 c0                	test   %eax,%eax
    149e:	0f 88 e6 00 00 00    	js     158a <unlinkread+0x11a>
  write(fd, "hello", 5);
    14a4:	83 ec 04             	sub    $0x4,%esp
    14a7:	89 c3                	mov    %eax,%ebx
    14a9:	6a 05                	push   $0x5
    14ab:	68 4a 43 00 00       	push   $0x434a
    14b0:	50                   	push   %eax
    14b1:	e8 cd 24 00 00       	call   3983 <write>
  close(fd);
    14b6:	89 1c 24             	mov    %ebx,(%esp)
    14b9:	e8 cd 24 00 00       	call   398b <close>
  fd = open("unlinkread", O_RDWR);
    14be:	58                   	pop    %eax
    14bf:	5a                   	pop    %edx
    14c0:	6a 02                	push   $0x2
    14c2:	68 25 43 00 00       	push   $0x4325
    14c7:	e8 d7 24 00 00       	call   39a3 <open>
  if(fd < 0){
    14cc:	83 c4 10             	add    $0x10,%esp
  fd = open("unlinkread", O_RDWR);
    14cf:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    14d1:	85 c0                	test   %eax,%eax
    14d3:	0f 88 10 01 00 00    	js     15e9 <unlinkread+0x179>
  if(unlink("unlinkread") != 0){
    14d9:	83 ec 0c             	sub    $0xc,%esp
    14dc:	68 25 43 00 00       	push   $0x4325
    14e1:	e8 cd 24 00 00       	call   39b3 <unlink>
    14e6:	83 c4 10             	add    $0x10,%esp
    14e9:	85 c0                	test   %eax,%eax
    14eb:	0f 85 e5 00 00 00    	jne    15d6 <unlinkread+0x166>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    14f1:	83 ec 08             	sub    $0x8,%esp
    14f4:	68 02 02 00 00       	push   $0x202
    14f9:	68 25 43 00 00       	push   $0x4325
    14fe:	e8 a0 24 00 00       	call   39a3 <open>
  write(fd1, "yyy", 3);
    1503:	83 c4 0c             	add    $0xc,%esp
    1506:	6a 03                	push   $0x3
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    1508:	89 c6                	mov    %eax,%esi
  write(fd1, "yyy", 3);
    150a:	68 82 43 00 00       	push   $0x4382
    150f:	50                   	push   %eax
    1510:	e8 6e 24 00 00       	call   3983 <write>
  close(fd1);
    1515:	89 34 24             	mov    %esi,(%esp)
    1518:	e8 6e 24 00 00       	call   398b <close>
  if(read(fd, buf, sizeof(buf)) != 5){
    151d:	83 c4 0c             	add    $0xc,%esp
    1520:	68 00 20 00 00       	push   $0x2000
    1525:	68 80 86 00 00       	push   $0x8680
    152a:	53                   	push   %ebx
    152b:	e8 4b 24 00 00       	call   397b <read>
    1530:	83 c4 10             	add    $0x10,%esp
    1533:	83 f8 05             	cmp    $0x5,%eax
    1536:	0f 85 87 00 00 00    	jne    15c3 <unlinkread+0x153>
  if(buf[0] != 'h'){
    153c:	80 3d 80 86 00 00 68 	cmpb   $0x68,0x8680
    1543:	75 6b                	jne    15b0 <unlinkread+0x140>
  if(write(fd, buf, 10) != 10){
    1545:	83 ec 04             	sub    $0x4,%esp
    1548:	6a 0a                	push   $0xa
    154a:	68 80 86 00 00       	push   $0x8680
    154f:	53                   	push   %ebx
    1550:	e8 2e 24 00 00       	call   3983 <write>
    1555:	83 c4 10             	add    $0x10,%esp
    1558:	83 f8 0a             	cmp    $0xa,%eax
    155b:	75 40                	jne    159d <unlinkread+0x12d>
  close(fd);
    155d:	83 ec 0c             	sub    $0xc,%esp
    1560:	53                   	push   %ebx
    1561:	e8 25 24 00 00       	call   398b <close>
  unlink("unlinkread");
    1566:	c7 04 24 25 43 00 00 	movl   $0x4325,(%esp)
    156d:	e8 41 24 00 00       	call   39b3 <unlink>
  printf(1, "unlinkread ok\n");
    1572:	58                   	pop    %eax
    1573:	5a                   	pop    %edx
    1574:	68 cd 43 00 00       	push   $0x43cd
    1579:	6a 01                	push   $0x1
    157b:	e8 50 25 00 00       	call   3ad0 <printf>
}
    1580:	83 c4 10             	add    $0x10,%esp
    1583:	8d 65 f8             	lea    -0x8(%ebp),%esp
    1586:	5b                   	pop    %ebx
    1587:	5e                   	pop    %esi
    1588:	5d                   	pop    %ebp
    1589:	c3                   	ret    
    printf(1, "create unlinkread failed\n");
    158a:	51                   	push   %ecx
    158b:	51                   	push   %ecx
    158c:	68 30 43 00 00       	push   $0x4330
    1591:	6a 01                	push   $0x1
    1593:	e8 38 25 00 00       	call   3ad0 <printf>
    exit();
    1598:	e8 c6 23 00 00       	call   3963 <exit>
    printf(1, "unlinkread write failed\n");
    159d:	51                   	push   %ecx
    159e:	51                   	push   %ecx
    159f:	68 b4 43 00 00       	push   $0x43b4
    15a4:	6a 01                	push   $0x1
    15a6:	e8 25 25 00 00       	call   3ad0 <printf>
    exit();
    15ab:	e8 b3 23 00 00       	call   3963 <exit>
    printf(1, "unlinkread wrong data\n");
    15b0:	53                   	push   %ebx
    15b1:	53                   	push   %ebx
    15b2:	68 9d 43 00 00       	push   $0x439d
    15b7:	6a 01                	push   $0x1
    15b9:	e8 12 25 00 00       	call   3ad0 <printf>
    exit();
    15be:	e8 a0 23 00 00       	call   3963 <exit>
    printf(1, "unlinkread read failed");
    15c3:	56                   	push   %esi
    15c4:	56                   	push   %esi
    15c5:	68 86 43 00 00       	push   $0x4386
    15ca:	6a 01                	push   $0x1
    15cc:	e8 ff 24 00 00       	call   3ad0 <printf>
    exit();
    15d1:	e8 8d 23 00 00       	call   3963 <exit>
    printf(1, "unlink unlinkread failed\n");
    15d6:	50                   	push   %eax
    15d7:	50                   	push   %eax
    15d8:	68 68 43 00 00       	push   $0x4368
    15dd:	6a 01                	push   $0x1
    15df:	e8 ec 24 00 00       	call   3ad0 <printf>
    exit();
    15e4:	e8 7a 23 00 00       	call   3963 <exit>
    printf(1, "open unlinkread failed\n");
    15e9:	50                   	push   %eax
    15ea:	50                   	push   %eax
    15eb:	68 50 43 00 00       	push   $0x4350
    15f0:	6a 01                	push   $0x1
    15f2:	e8 d9 24 00 00       	call   3ad0 <printf>
    exit();
    15f7:	e8 67 23 00 00       	call   3963 <exit>
    15fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001600 <linktest>:
{
    1600:	f3 0f 1e fb          	endbr32 
    1604:	55                   	push   %ebp
    1605:	89 e5                	mov    %esp,%ebp
    1607:	53                   	push   %ebx
    1608:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "linktest\n");
    160b:	68 dc 43 00 00       	push   $0x43dc
    1610:	6a 01                	push   $0x1
    1612:	e8 b9 24 00 00       	call   3ad0 <printf>
  unlink("lf1");
    1617:	c7 04 24 e6 43 00 00 	movl   $0x43e6,(%esp)
    161e:	e8 90 23 00 00       	call   39b3 <unlink>
  unlink("lf2");
    1623:	c7 04 24 ea 43 00 00 	movl   $0x43ea,(%esp)
    162a:	e8 84 23 00 00       	call   39b3 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
    162f:	58                   	pop    %eax
    1630:	5a                   	pop    %edx
    1631:	68 02 02 00 00       	push   $0x202
    1636:	68 e6 43 00 00       	push   $0x43e6
    163b:	e8 63 23 00 00       	call   39a3 <open>
  if(fd < 0){
    1640:	83 c4 10             	add    $0x10,%esp
    1643:	85 c0                	test   %eax,%eax
    1645:	0f 88 1e 01 00 00    	js     1769 <linktest+0x169>
  if(write(fd, "hello", 5) != 5){
    164b:	83 ec 04             	sub    $0x4,%esp
    164e:	89 c3                	mov    %eax,%ebx
    1650:	6a 05                	push   $0x5
    1652:	68 4a 43 00 00       	push   $0x434a
    1657:	50                   	push   %eax
    1658:	e8 26 23 00 00       	call   3983 <write>
    165d:	83 c4 10             	add    $0x10,%esp
    1660:	83 f8 05             	cmp    $0x5,%eax
    1663:	0f 85 98 01 00 00    	jne    1801 <linktest+0x201>
  close(fd);
    1669:	83 ec 0c             	sub    $0xc,%esp
    166c:	53                   	push   %ebx
    166d:	e8 19 23 00 00       	call   398b <close>
  if(link("lf1", "lf2") < 0){
    1672:	5b                   	pop    %ebx
    1673:	58                   	pop    %eax
    1674:	68 ea 43 00 00       	push   $0x43ea
    1679:	68 e6 43 00 00       	push   $0x43e6
    167e:	e8 40 23 00 00       	call   39c3 <link>
    1683:	83 c4 10             	add    $0x10,%esp
    1686:	85 c0                	test   %eax,%eax
    1688:	0f 88 60 01 00 00    	js     17ee <linktest+0x1ee>
  unlink("lf1");
    168e:	83 ec 0c             	sub    $0xc,%esp
    1691:	68 e6 43 00 00       	push   $0x43e6
    1696:	e8 18 23 00 00       	call   39b3 <unlink>
  if(open("lf1", 0) >= 0){
    169b:	58                   	pop    %eax
    169c:	5a                   	pop    %edx
    169d:	6a 00                	push   $0x0
    169f:	68 e6 43 00 00       	push   $0x43e6
    16a4:	e8 fa 22 00 00       	call   39a3 <open>
    16a9:	83 c4 10             	add    $0x10,%esp
    16ac:	85 c0                	test   %eax,%eax
    16ae:	0f 89 27 01 00 00    	jns    17db <linktest+0x1db>
  fd = open("lf2", 0);
    16b4:	83 ec 08             	sub    $0x8,%esp
    16b7:	6a 00                	push   $0x0
    16b9:	68 ea 43 00 00       	push   $0x43ea
    16be:	e8 e0 22 00 00       	call   39a3 <open>
  if(fd < 0){
    16c3:	83 c4 10             	add    $0x10,%esp
  fd = open("lf2", 0);
    16c6:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    16c8:	85 c0                	test   %eax,%eax
    16ca:	0f 88 f8 00 00 00    	js     17c8 <linktest+0x1c8>
  if(read(fd, buf, sizeof(buf)) != 5){
    16d0:	83 ec 04             	sub    $0x4,%esp
    16d3:	68 00 20 00 00       	push   $0x2000
    16d8:	68 80 86 00 00       	push   $0x8680
    16dd:	50                   	push   %eax
    16de:	e8 98 22 00 00       	call   397b <read>
    16e3:	83 c4 10             	add    $0x10,%esp
    16e6:	83 f8 05             	cmp    $0x5,%eax
    16e9:	0f 85 c6 00 00 00    	jne    17b5 <linktest+0x1b5>
  close(fd);
    16ef:	83 ec 0c             	sub    $0xc,%esp
    16f2:	53                   	push   %ebx
    16f3:	e8 93 22 00 00       	call   398b <close>
  if(link("lf2", "lf2") >= 0){
    16f8:	58                   	pop    %eax
    16f9:	5a                   	pop    %edx
    16fa:	68 ea 43 00 00       	push   $0x43ea
    16ff:	68 ea 43 00 00       	push   $0x43ea
    1704:	e8 ba 22 00 00       	call   39c3 <link>
    1709:	83 c4 10             	add    $0x10,%esp
    170c:	85 c0                	test   %eax,%eax
    170e:	0f 89 8e 00 00 00    	jns    17a2 <linktest+0x1a2>
  unlink("lf2");
    1714:	83 ec 0c             	sub    $0xc,%esp
    1717:	68 ea 43 00 00       	push   $0x43ea
    171c:	e8 92 22 00 00       	call   39b3 <unlink>
  if(link("lf2", "lf1") >= 0){
    1721:	59                   	pop    %ecx
    1722:	5b                   	pop    %ebx
    1723:	68 e6 43 00 00       	push   $0x43e6
    1728:	68 ea 43 00 00       	push   $0x43ea
    172d:	e8 91 22 00 00       	call   39c3 <link>
    1732:	83 c4 10             	add    $0x10,%esp
    1735:	85 c0                	test   %eax,%eax
    1737:	79 56                	jns    178f <linktest+0x18f>
  if(link(".", "lf1") >= 0){
    1739:	83 ec 08             	sub    $0x8,%esp
    173c:	68 e6 43 00 00       	push   $0x43e6
    1741:	68 ae 46 00 00       	push   $0x46ae
    1746:	e8 78 22 00 00       	call   39c3 <link>
    174b:	83 c4 10             	add    $0x10,%esp
    174e:	85 c0                	test   %eax,%eax
    1750:	79 2a                	jns    177c <linktest+0x17c>
  printf(1, "linktest ok\n");
    1752:	83 ec 08             	sub    $0x8,%esp
    1755:	68 84 44 00 00       	push   $0x4484
    175a:	6a 01                	push   $0x1
    175c:	e8 6f 23 00 00       	call   3ad0 <printf>
}
    1761:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1764:	83 c4 10             	add    $0x10,%esp
    1767:	c9                   	leave  
    1768:	c3                   	ret    
    printf(1, "create lf1 failed\n");
    1769:	50                   	push   %eax
    176a:	50                   	push   %eax
    176b:	68 ee 43 00 00       	push   $0x43ee
    1770:	6a 01                	push   $0x1
    1772:	e8 59 23 00 00       	call   3ad0 <printf>
    exit();
    1777:	e8 e7 21 00 00       	call   3963 <exit>
    printf(1, "link . lf1 succeeded! oops\n");
    177c:	50                   	push   %eax
    177d:	50                   	push   %eax
    177e:	68 68 44 00 00       	push   $0x4468
    1783:	6a 01                	push   $0x1
    1785:	e8 46 23 00 00       	call   3ad0 <printf>
    exit();
    178a:	e8 d4 21 00 00       	call   3963 <exit>
    printf(1, "link non-existant succeeded! oops\n");
    178f:	52                   	push   %edx
    1790:	52                   	push   %edx
    1791:	68 1c 50 00 00       	push   $0x501c
    1796:	6a 01                	push   $0x1
    1798:	e8 33 23 00 00       	call   3ad0 <printf>
    exit();
    179d:	e8 c1 21 00 00       	call   3963 <exit>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    17a2:	50                   	push   %eax
    17a3:	50                   	push   %eax
    17a4:	68 4a 44 00 00       	push   $0x444a
    17a9:	6a 01                	push   $0x1
    17ab:	e8 20 23 00 00       	call   3ad0 <printf>
    exit();
    17b0:	e8 ae 21 00 00       	call   3963 <exit>
    printf(1, "read lf2 failed\n");
    17b5:	51                   	push   %ecx
    17b6:	51                   	push   %ecx
    17b7:	68 39 44 00 00       	push   $0x4439
    17bc:	6a 01                	push   $0x1
    17be:	e8 0d 23 00 00       	call   3ad0 <printf>
    exit();
    17c3:	e8 9b 21 00 00       	call   3963 <exit>
    printf(1, "open lf2 failed\n");
    17c8:	53                   	push   %ebx
    17c9:	53                   	push   %ebx
    17ca:	68 28 44 00 00       	push   $0x4428
    17cf:	6a 01                	push   $0x1
    17d1:	e8 fa 22 00 00       	call   3ad0 <printf>
    exit();
    17d6:	e8 88 21 00 00       	call   3963 <exit>
    printf(1, "unlinked lf1 but it is still there!\n");
    17db:	50                   	push   %eax
    17dc:	50                   	push   %eax
    17dd:	68 f4 4f 00 00       	push   $0x4ff4
    17e2:	6a 01                	push   $0x1
    17e4:	e8 e7 22 00 00       	call   3ad0 <printf>
    exit();
    17e9:	e8 75 21 00 00       	call   3963 <exit>
    printf(1, "link lf1 lf2 failed\n");
    17ee:	51                   	push   %ecx
    17ef:	51                   	push   %ecx
    17f0:	68 13 44 00 00       	push   $0x4413
    17f5:	6a 01                	push   $0x1
    17f7:	e8 d4 22 00 00       	call   3ad0 <printf>
    exit();
    17fc:	e8 62 21 00 00       	call   3963 <exit>
    printf(1, "write lf1 failed\n");
    1801:	50                   	push   %eax
    1802:	50                   	push   %eax
    1803:	68 01 44 00 00       	push   $0x4401
    1808:	6a 01                	push   $0x1
    180a:	e8 c1 22 00 00       	call   3ad0 <printf>
    exit();
    180f:	e8 4f 21 00 00       	call   3963 <exit>
    1814:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    181b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    181f:	90                   	nop

00001820 <concreate>:
{
    1820:	f3 0f 1e fb          	endbr32 
    1824:	55                   	push   %ebp
    1825:	89 e5                	mov    %esp,%ebp
    1827:	57                   	push   %edi
    1828:	56                   	push   %esi
  for(i = 0; i < 40; i++){
    1829:	31 f6                	xor    %esi,%esi
{
    182b:	53                   	push   %ebx
    182c:	8d 5d ad             	lea    -0x53(%ebp),%ebx
    182f:	83 ec 64             	sub    $0x64,%esp
  printf(1, "concreate test\n");
    1832:	68 91 44 00 00       	push   $0x4491
    1837:	6a 01                	push   $0x1
    1839:	e8 92 22 00 00       	call   3ad0 <printf>
  file[0] = 'C';
    183e:	c6 45 ad 43          	movb   $0x43,-0x53(%ebp)
  file[2] = '\0';
    1842:	83 c4 10             	add    $0x10,%esp
    1845:	c6 45 af 00          	movb   $0x0,-0x51(%ebp)
  for(i = 0; i < 40; i++){
    1849:	eb 48                	jmp    1893 <concreate+0x73>
    184b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    184f:	90                   	nop
    1850:	69 c6 ab aa aa aa    	imul   $0xaaaaaaab,%esi,%eax
    if(pid && (i % 3) == 1){
    1856:	3d ab aa aa aa       	cmp    $0xaaaaaaab,%eax
    185b:	0f 83 af 00 00 00    	jae    1910 <concreate+0xf0>
      fd = open(file, O_CREATE | O_RDWR);
    1861:	83 ec 08             	sub    $0x8,%esp
    1864:	68 02 02 00 00       	push   $0x202
    1869:	53                   	push   %ebx
    186a:	e8 34 21 00 00       	call   39a3 <open>
      if(fd < 0){
    186f:	83 c4 10             	add    $0x10,%esp
    1872:	85 c0                	test   %eax,%eax
    1874:	78 5f                	js     18d5 <concreate+0xb5>
      close(fd);
    1876:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < 40; i++){
    1879:	83 c6 01             	add    $0x1,%esi
      close(fd);
    187c:	50                   	push   %eax
    187d:	e8 09 21 00 00       	call   398b <close>
    1882:	83 c4 10             	add    $0x10,%esp
      wait();
    1885:	e8 e1 20 00 00       	call   396b <wait>
  for(i = 0; i < 40; i++){
    188a:	83 fe 28             	cmp    $0x28,%esi
    188d:	0f 84 9f 00 00 00    	je     1932 <concreate+0x112>
    unlink(file);
    1893:	83 ec 0c             	sub    $0xc,%esp
    file[1] = '0' + i;
    1896:	8d 46 30             	lea    0x30(%esi),%eax
    unlink(file);
    1899:	53                   	push   %ebx
    file[1] = '0' + i;
    189a:	88 45 ae             	mov    %al,-0x52(%ebp)
    unlink(file);
    189d:	e8 11 21 00 00       	call   39b3 <unlink>
    pid = fork();
    18a2:	e8 b4 20 00 00       	call   395b <fork>
    if(pid && (i % 3) == 1){
    18a7:	83 c4 10             	add    $0x10,%esp
    18aa:	85 c0                	test   %eax,%eax
    18ac:	75 a2                	jne    1850 <concreate+0x30>
      link("C0", file);
    18ae:	69 f6 cd cc cc cc    	imul   $0xcccccccd,%esi,%esi
    } else if(pid == 0 && (i % 5) == 1){
    18b4:	81 fe cd cc cc cc    	cmp    $0xcccccccd,%esi
    18ba:	73 34                	jae    18f0 <concreate+0xd0>
      fd = open(file, O_CREATE | O_RDWR);
    18bc:	83 ec 08             	sub    $0x8,%esp
    18bf:	68 02 02 00 00       	push   $0x202
    18c4:	53                   	push   %ebx
    18c5:	e8 d9 20 00 00       	call   39a3 <open>
      if(fd < 0){
    18ca:	83 c4 10             	add    $0x10,%esp
    18cd:	85 c0                	test   %eax,%eax
    18cf:	0f 89 39 02 00 00    	jns    1b0e <concreate+0x2ee>
        printf(1, "concreate create %s failed\n", file);
    18d5:	83 ec 04             	sub    $0x4,%esp
    18d8:	53                   	push   %ebx
    18d9:	68 a4 44 00 00       	push   $0x44a4
    18de:	6a 01                	push   $0x1
    18e0:	e8 eb 21 00 00       	call   3ad0 <printf>
        exit();
    18e5:	e8 79 20 00 00       	call   3963 <exit>
    18ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      link("C0", file);
    18f0:	83 ec 08             	sub    $0x8,%esp
    18f3:	53                   	push   %ebx
    18f4:	68 a1 44 00 00       	push   $0x44a1
    18f9:	e8 c5 20 00 00       	call   39c3 <link>
    18fe:	83 c4 10             	add    $0x10,%esp
      exit();
    1901:	e8 5d 20 00 00       	call   3963 <exit>
    1906:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    190d:	8d 76 00             	lea    0x0(%esi),%esi
      link("C0", file);
    1910:	83 ec 08             	sub    $0x8,%esp
  for(i = 0; i < 40; i++){
    1913:	83 c6 01             	add    $0x1,%esi
      link("C0", file);
    1916:	53                   	push   %ebx
    1917:	68 a1 44 00 00       	push   $0x44a1
    191c:	e8 a2 20 00 00       	call   39c3 <link>
    1921:	83 c4 10             	add    $0x10,%esp
      wait();
    1924:	e8 42 20 00 00       	call   396b <wait>
  for(i = 0; i < 40; i++){
    1929:	83 fe 28             	cmp    $0x28,%esi
    192c:	0f 85 61 ff ff ff    	jne    1893 <concreate+0x73>
  memset(fa, 0, sizeof(fa));
    1932:	83 ec 04             	sub    $0x4,%esp
    1935:	8d 45 c0             	lea    -0x40(%ebp),%eax
    1938:	6a 28                	push   $0x28
    193a:	6a 00                	push   $0x0
    193c:	50                   	push   %eax
    193d:	e8 7e 1e 00 00       	call   37c0 <memset>
  fd = open(".", 0);
    1942:	5e                   	pop    %esi
    1943:	5f                   	pop    %edi
    1944:	6a 00                	push   $0x0
    1946:	68 ae 46 00 00       	push   $0x46ae
    194b:	8d 7d b0             	lea    -0x50(%ebp),%edi
    194e:	e8 50 20 00 00       	call   39a3 <open>
  n = 0;
    1953:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
  while(read(fd, &de, sizeof(de)) > 0){
    195a:	83 c4 10             	add    $0x10,%esp
  fd = open(".", 0);
    195d:	89 c6                	mov    %eax,%esi
  while(read(fd, &de, sizeof(de)) > 0){
    195f:	90                   	nop
    1960:	83 ec 04             	sub    $0x4,%esp
    1963:	6a 10                	push   $0x10
    1965:	57                   	push   %edi
    1966:	56                   	push   %esi
    1967:	e8 0f 20 00 00       	call   397b <read>
    196c:	83 c4 10             	add    $0x10,%esp
    196f:	85 c0                	test   %eax,%eax
    1971:	7e 3d                	jle    19b0 <concreate+0x190>
    if(de.inum == 0)
    1973:	66 83 7d b0 00       	cmpw   $0x0,-0x50(%ebp)
    1978:	74 e6                	je     1960 <concreate+0x140>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    197a:	80 7d b2 43          	cmpb   $0x43,-0x4e(%ebp)
    197e:	75 e0                	jne    1960 <concreate+0x140>
    1980:	80 7d b4 00          	cmpb   $0x0,-0x4c(%ebp)
    1984:	75 da                	jne    1960 <concreate+0x140>
      i = de.name[1] - '0';
    1986:	0f be 45 b3          	movsbl -0x4d(%ebp),%eax
    198a:	83 e8 30             	sub    $0x30,%eax
      if(i < 0 || i >= sizeof(fa)){
    198d:	83 f8 27             	cmp    $0x27,%eax
    1990:	0f 87 60 01 00 00    	ja     1af6 <concreate+0x2d6>
      if(fa[i]){
    1996:	80 7c 05 c0 00       	cmpb   $0x0,-0x40(%ebp,%eax,1)
    199b:	0f 85 3d 01 00 00    	jne    1ade <concreate+0x2be>
      n++;
    19a1:	83 45 a4 01          	addl   $0x1,-0x5c(%ebp)
      fa[i] = 1;
    19a5:	c6 44 05 c0 01       	movb   $0x1,-0x40(%ebp,%eax,1)
      n++;
    19aa:	eb b4                	jmp    1960 <concreate+0x140>
    19ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  close(fd);
    19b0:	83 ec 0c             	sub    $0xc,%esp
    19b3:	56                   	push   %esi
    19b4:	e8 d2 1f 00 00       	call   398b <close>
  if(n != 40){
    19b9:	83 c4 10             	add    $0x10,%esp
    19bc:	83 7d a4 28          	cmpl   $0x28,-0x5c(%ebp)
    19c0:	0f 85 05 01 00 00    	jne    1acb <concreate+0x2ab>
  for(i = 0; i < 40; i++){
    19c6:	31 f6                	xor    %esi,%esi
    19c8:	eb 4c                	jmp    1a16 <concreate+0x1f6>
    19ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
       ((i % 3) == 1 && pid != 0)){
    19d0:	85 ff                	test   %edi,%edi
    19d2:	74 05                	je     19d9 <concreate+0x1b9>
    19d4:	83 f8 01             	cmp    $0x1,%eax
    19d7:	74 6c                	je     1a45 <concreate+0x225>
      unlink(file);
    19d9:	83 ec 0c             	sub    $0xc,%esp
    19dc:	53                   	push   %ebx
    19dd:	e8 d1 1f 00 00       	call   39b3 <unlink>
      unlink(file);
    19e2:	89 1c 24             	mov    %ebx,(%esp)
    19e5:	e8 c9 1f 00 00       	call   39b3 <unlink>
      unlink(file);
    19ea:	89 1c 24             	mov    %ebx,(%esp)
    19ed:	e8 c1 1f 00 00       	call   39b3 <unlink>
      unlink(file);
    19f2:	89 1c 24             	mov    %ebx,(%esp)
    19f5:	e8 b9 1f 00 00       	call   39b3 <unlink>
    19fa:	83 c4 10             	add    $0x10,%esp
    if(pid == 0)
    19fd:	85 ff                	test   %edi,%edi
    19ff:	0f 84 fc fe ff ff    	je     1901 <concreate+0xe1>
      wait();
    1a05:	e8 61 1f 00 00       	call   396b <wait>
  for(i = 0; i < 40; i++){
    1a0a:	83 c6 01             	add    $0x1,%esi
    1a0d:	83 fe 28             	cmp    $0x28,%esi
    1a10:	0f 84 8a 00 00 00    	je     1aa0 <concreate+0x280>
    file[1] = '0' + i;
    1a16:	8d 46 30             	lea    0x30(%esi),%eax
    1a19:	88 45 ae             	mov    %al,-0x52(%ebp)
    pid = fork();
    1a1c:	e8 3a 1f 00 00       	call   395b <fork>
    1a21:	89 c7                	mov    %eax,%edi
    if(pid < 0){
    1a23:	85 c0                	test   %eax,%eax
    1a25:	0f 88 8c 00 00 00    	js     1ab7 <concreate+0x297>
    if(((i % 3) == 0 && pid == 0) ||
    1a2b:	b8 ab aa aa aa       	mov    $0xaaaaaaab,%eax
    1a30:	f7 e6                	mul    %esi
    1a32:	89 d0                	mov    %edx,%eax
    1a34:	83 e2 fe             	and    $0xfffffffe,%edx
    1a37:	d1 e8                	shr    %eax
    1a39:	01 c2                	add    %eax,%edx
    1a3b:	89 f0                	mov    %esi,%eax
    1a3d:	29 d0                	sub    %edx,%eax
    1a3f:	89 c1                	mov    %eax,%ecx
    1a41:	09 f9                	or     %edi,%ecx
    1a43:	75 8b                	jne    19d0 <concreate+0x1b0>
      close(open(file, 0));
    1a45:	83 ec 08             	sub    $0x8,%esp
    1a48:	6a 00                	push   $0x0
    1a4a:	53                   	push   %ebx
    1a4b:	e8 53 1f 00 00       	call   39a3 <open>
    1a50:	89 04 24             	mov    %eax,(%esp)
    1a53:	e8 33 1f 00 00       	call   398b <close>
      close(open(file, 0));
    1a58:	58                   	pop    %eax
    1a59:	5a                   	pop    %edx
    1a5a:	6a 00                	push   $0x0
    1a5c:	53                   	push   %ebx
    1a5d:	e8 41 1f 00 00       	call   39a3 <open>
    1a62:	89 04 24             	mov    %eax,(%esp)
    1a65:	e8 21 1f 00 00       	call   398b <close>
      close(open(file, 0));
    1a6a:	59                   	pop    %ecx
    1a6b:	58                   	pop    %eax
    1a6c:	6a 00                	push   $0x0
    1a6e:	53                   	push   %ebx
    1a6f:	e8 2f 1f 00 00       	call   39a3 <open>
    1a74:	89 04 24             	mov    %eax,(%esp)
    1a77:	e8 0f 1f 00 00       	call   398b <close>
      close(open(file, 0));
    1a7c:	58                   	pop    %eax
    1a7d:	5a                   	pop    %edx
    1a7e:	6a 00                	push   $0x0
    1a80:	53                   	push   %ebx
    1a81:	e8 1d 1f 00 00       	call   39a3 <open>
    1a86:	89 04 24             	mov    %eax,(%esp)
    1a89:	e8 fd 1e 00 00       	call   398b <close>
    1a8e:	83 c4 10             	add    $0x10,%esp
    1a91:	e9 67 ff ff ff       	jmp    19fd <concreate+0x1dd>
    1a96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1a9d:	8d 76 00             	lea    0x0(%esi),%esi
  printf(1, "concreate ok\n");
    1aa0:	83 ec 08             	sub    $0x8,%esp
    1aa3:	68 f6 44 00 00       	push   $0x44f6
    1aa8:	6a 01                	push   $0x1
    1aaa:	e8 21 20 00 00       	call   3ad0 <printf>
}
    1aaf:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1ab2:	5b                   	pop    %ebx
    1ab3:	5e                   	pop    %esi
    1ab4:	5f                   	pop    %edi
    1ab5:	5d                   	pop    %ebp
    1ab6:	c3                   	ret    
      printf(1, "fork failed\n");
    1ab7:	83 ec 08             	sub    $0x8,%esp
    1aba:	68 79 4d 00 00       	push   $0x4d79
    1abf:	6a 01                	push   $0x1
    1ac1:	e8 0a 20 00 00       	call   3ad0 <printf>
      exit();
    1ac6:	e8 98 1e 00 00       	call   3963 <exit>
    printf(1, "concreate not enough files in directory listing\n");
    1acb:	51                   	push   %ecx
    1acc:	51                   	push   %ecx
    1acd:	68 40 50 00 00       	push   $0x5040
    1ad2:	6a 01                	push   $0x1
    1ad4:	e8 f7 1f 00 00       	call   3ad0 <printf>
    exit();
    1ad9:	e8 85 1e 00 00       	call   3963 <exit>
        printf(1, "concreate duplicate file %s\n", de.name);
    1ade:	83 ec 04             	sub    $0x4,%esp
    1ae1:	8d 45 b2             	lea    -0x4e(%ebp),%eax
    1ae4:	50                   	push   %eax
    1ae5:	68 d9 44 00 00       	push   $0x44d9
    1aea:	6a 01                	push   $0x1
    1aec:	e8 df 1f 00 00       	call   3ad0 <printf>
        exit();
    1af1:	e8 6d 1e 00 00       	call   3963 <exit>
        printf(1, "concreate weird file %s\n", de.name);
    1af6:	83 ec 04             	sub    $0x4,%esp
    1af9:	8d 45 b2             	lea    -0x4e(%ebp),%eax
    1afc:	50                   	push   %eax
    1afd:	68 c0 44 00 00       	push   $0x44c0
    1b02:	6a 01                	push   $0x1
    1b04:	e8 c7 1f 00 00       	call   3ad0 <printf>
        exit();
    1b09:	e8 55 1e 00 00       	call   3963 <exit>
      close(fd);
    1b0e:	83 ec 0c             	sub    $0xc,%esp
    1b11:	50                   	push   %eax
    1b12:	e8 74 1e 00 00       	call   398b <close>
    1b17:	83 c4 10             	add    $0x10,%esp
    1b1a:	e9 e2 fd ff ff       	jmp    1901 <concreate+0xe1>
    1b1f:	90                   	nop

00001b20 <linkunlink>:
{
    1b20:	f3 0f 1e fb          	endbr32 
    1b24:	55                   	push   %ebp
    1b25:	89 e5                	mov    %esp,%ebp
    1b27:	57                   	push   %edi
    1b28:	56                   	push   %esi
    1b29:	53                   	push   %ebx
    1b2a:	83 ec 24             	sub    $0x24,%esp
  printf(1, "linkunlink test\n");
    1b2d:	68 04 45 00 00       	push   $0x4504
    1b32:	6a 01                	push   $0x1
    1b34:	e8 97 1f 00 00       	call   3ad0 <printf>
  unlink("x");
    1b39:	c7 04 24 91 47 00 00 	movl   $0x4791,(%esp)
    1b40:	e8 6e 1e 00 00       	call   39b3 <unlink>
  pid = fork();
    1b45:	e8 11 1e 00 00       	call   395b <fork>
  if(pid < 0){
    1b4a:	83 c4 10             	add    $0x10,%esp
  pid = fork();
    1b4d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(pid < 0){
    1b50:	85 c0                	test   %eax,%eax
    1b52:	0f 88 b2 00 00 00    	js     1c0a <linkunlink+0xea>
  unsigned int x = (pid ? 1 : 97);
    1b58:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
    1b5c:	bb 64 00 00 00       	mov    $0x64,%ebx
    if((x % 3) == 0){
    1b61:	be ab aa aa aa       	mov    $0xaaaaaaab,%esi
  unsigned int x = (pid ? 1 : 97);
    1b66:	19 ff                	sbb    %edi,%edi
    1b68:	83 e7 60             	and    $0x60,%edi
    1b6b:	83 c7 01             	add    $0x1,%edi
    1b6e:	eb 1a                	jmp    1b8a <linkunlink+0x6a>
    } else if((x % 3) == 1){
    1b70:	83 f8 01             	cmp    $0x1,%eax
    1b73:	74 7b                	je     1bf0 <linkunlink+0xd0>
      unlink("x");
    1b75:	83 ec 0c             	sub    $0xc,%esp
    1b78:	68 91 47 00 00       	push   $0x4791
    1b7d:	e8 31 1e 00 00       	call   39b3 <unlink>
    1b82:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 100; i++){
    1b85:	83 eb 01             	sub    $0x1,%ebx
    1b88:	74 41                	je     1bcb <linkunlink+0xab>
    x = x * 1103515245 + 12345;
    1b8a:	69 cf 6d 4e c6 41    	imul   $0x41c64e6d,%edi,%ecx
    1b90:	8d b9 39 30 00 00    	lea    0x3039(%ecx),%edi
    if((x % 3) == 0){
    1b96:	89 f8                	mov    %edi,%eax
    1b98:	f7 e6                	mul    %esi
    1b9a:	89 d0                	mov    %edx,%eax
    1b9c:	83 e2 fe             	and    $0xfffffffe,%edx
    1b9f:	d1 e8                	shr    %eax
    1ba1:	01 c2                	add    %eax,%edx
    1ba3:	89 f8                	mov    %edi,%eax
    1ba5:	29 d0                	sub    %edx,%eax
    1ba7:	75 c7                	jne    1b70 <linkunlink+0x50>
      close(open("x", O_RDWR | O_CREATE));
    1ba9:	83 ec 08             	sub    $0x8,%esp
    1bac:	68 02 02 00 00       	push   $0x202
    1bb1:	68 91 47 00 00       	push   $0x4791
    1bb6:	e8 e8 1d 00 00       	call   39a3 <open>
    1bbb:	89 04 24             	mov    %eax,(%esp)
    1bbe:	e8 c8 1d 00 00       	call   398b <close>
    1bc3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 100; i++){
    1bc6:	83 eb 01             	sub    $0x1,%ebx
    1bc9:	75 bf                	jne    1b8a <linkunlink+0x6a>
  if(pid)
    1bcb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1bce:	85 c0                	test   %eax,%eax
    1bd0:	74 4b                	je     1c1d <linkunlink+0xfd>
    wait();
    1bd2:	e8 94 1d 00 00       	call   396b <wait>
  printf(1, "linkunlink ok\n");
    1bd7:	83 ec 08             	sub    $0x8,%esp
    1bda:	68 19 45 00 00       	push   $0x4519
    1bdf:	6a 01                	push   $0x1
    1be1:	e8 ea 1e 00 00       	call   3ad0 <printf>
}
    1be6:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1be9:	5b                   	pop    %ebx
    1bea:	5e                   	pop    %esi
    1beb:	5f                   	pop    %edi
    1bec:	5d                   	pop    %ebp
    1bed:	c3                   	ret    
    1bee:	66 90                	xchg   %ax,%ax
      link("cat", "x");
    1bf0:	83 ec 08             	sub    $0x8,%esp
    1bf3:	68 91 47 00 00       	push   $0x4791
    1bf8:	68 15 45 00 00       	push   $0x4515
    1bfd:	e8 c1 1d 00 00       	call   39c3 <link>
    1c02:	83 c4 10             	add    $0x10,%esp
    1c05:	e9 7b ff ff ff       	jmp    1b85 <linkunlink+0x65>
    printf(1, "fork failed\n");
    1c0a:	52                   	push   %edx
    1c0b:	52                   	push   %edx
    1c0c:	68 79 4d 00 00       	push   $0x4d79
    1c11:	6a 01                	push   $0x1
    1c13:	e8 b8 1e 00 00       	call   3ad0 <printf>
    exit();
    1c18:	e8 46 1d 00 00       	call   3963 <exit>
    exit();
    1c1d:	e8 41 1d 00 00       	call   3963 <exit>
    1c22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00001c30 <bigdir>:
{
    1c30:	f3 0f 1e fb          	endbr32 
    1c34:	55                   	push   %ebp
    1c35:	89 e5                	mov    %esp,%ebp
    1c37:	57                   	push   %edi
    1c38:	56                   	push   %esi
    1c39:	53                   	push   %ebx
    1c3a:	83 ec 24             	sub    $0x24,%esp
  printf(1, "bigdir test\n");
    1c3d:	68 28 45 00 00       	push   $0x4528
    1c42:	6a 01                	push   $0x1
    1c44:	e8 87 1e 00 00       	call   3ad0 <printf>
  unlink("bd");
    1c49:	c7 04 24 35 45 00 00 	movl   $0x4535,(%esp)
    1c50:	e8 5e 1d 00 00       	call   39b3 <unlink>
  fd = open("bd", O_CREATE);
    1c55:	5a                   	pop    %edx
    1c56:	59                   	pop    %ecx
    1c57:	68 00 02 00 00       	push   $0x200
    1c5c:	68 35 45 00 00       	push   $0x4535
    1c61:	e8 3d 1d 00 00       	call   39a3 <open>
  if(fd < 0){
    1c66:	83 c4 10             	add    $0x10,%esp
    1c69:	85 c0                	test   %eax,%eax
    1c6b:	0f 88 ea 00 00 00    	js     1d5b <bigdir+0x12b>
  close(fd);
    1c71:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < 500; i++){
    1c74:	31 f6                	xor    %esi,%esi
    1c76:	8d 7d de             	lea    -0x22(%ebp),%edi
  close(fd);
    1c79:	50                   	push   %eax
    1c7a:	e8 0c 1d 00 00       	call   398b <close>
    1c7f:	83 c4 10             	add    $0x10,%esp
    1c82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    name[1] = '0' + (i / 64);
    1c88:	89 f0                	mov    %esi,%eax
    if(link("bd", name) != 0){
    1c8a:	83 ec 08             	sub    $0x8,%esp
    name[0] = 'x';
    1c8d:	c6 45 de 78          	movb   $0x78,-0x22(%ebp)
    name[1] = '0' + (i / 64);
    1c91:	c1 f8 06             	sar    $0x6,%eax
    if(link("bd", name) != 0){
    1c94:	57                   	push   %edi
    name[1] = '0' + (i / 64);
    1c95:	83 c0 30             	add    $0x30,%eax
    if(link("bd", name) != 0){
    1c98:	68 35 45 00 00       	push   $0x4535
    name[1] = '0' + (i / 64);
    1c9d:	88 45 df             	mov    %al,-0x21(%ebp)
    name[2] = '0' + (i % 64);
    1ca0:	89 f0                	mov    %esi,%eax
    1ca2:	83 e0 3f             	and    $0x3f,%eax
    name[3] = '\0';
    1ca5:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
    name[2] = '0' + (i % 64);
    1ca9:	83 c0 30             	add    $0x30,%eax
    1cac:	88 45 e0             	mov    %al,-0x20(%ebp)
    if(link("bd", name) != 0){
    1caf:	e8 0f 1d 00 00       	call   39c3 <link>
    1cb4:	83 c4 10             	add    $0x10,%esp
    1cb7:	89 c3                	mov    %eax,%ebx
    1cb9:	85 c0                	test   %eax,%eax
    1cbb:	75 76                	jne    1d33 <bigdir+0x103>
  for(i = 0; i < 500; i++){
    1cbd:	83 c6 01             	add    $0x1,%esi
    1cc0:	81 fe f4 01 00 00    	cmp    $0x1f4,%esi
    1cc6:	75 c0                	jne    1c88 <bigdir+0x58>
  unlink("bd");
    1cc8:	83 ec 0c             	sub    $0xc,%esp
    1ccb:	68 35 45 00 00       	push   $0x4535
    1cd0:	e8 de 1c 00 00       	call   39b3 <unlink>
    1cd5:	83 c4 10             	add    $0x10,%esp
    1cd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1cdf:	90                   	nop
    name[1] = '0' + (i / 64);
    1ce0:	89 d8                	mov    %ebx,%eax
    if(unlink(name) != 0){
    1ce2:	83 ec 0c             	sub    $0xc,%esp
    name[0] = 'x';
    1ce5:	c6 45 de 78          	movb   $0x78,-0x22(%ebp)
    name[1] = '0' + (i / 64);
    1ce9:	c1 f8 06             	sar    $0x6,%eax
    if(unlink(name) != 0){
    1cec:	57                   	push   %edi
    name[1] = '0' + (i / 64);
    1ced:	83 c0 30             	add    $0x30,%eax
    name[3] = '\0';
    1cf0:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
    name[1] = '0' + (i / 64);
    1cf4:	88 45 df             	mov    %al,-0x21(%ebp)
    name[2] = '0' + (i % 64);
    1cf7:	89 d8                	mov    %ebx,%eax
    1cf9:	83 e0 3f             	and    $0x3f,%eax
    1cfc:	83 c0 30             	add    $0x30,%eax
    1cff:	88 45 e0             	mov    %al,-0x20(%ebp)
    if(unlink(name) != 0){
    1d02:	e8 ac 1c 00 00       	call   39b3 <unlink>
    1d07:	83 c4 10             	add    $0x10,%esp
    1d0a:	85 c0                	test   %eax,%eax
    1d0c:	75 39                	jne    1d47 <bigdir+0x117>
  for(i = 0; i < 500; i++){
    1d0e:	83 c3 01             	add    $0x1,%ebx
    1d11:	81 fb f4 01 00 00    	cmp    $0x1f4,%ebx
    1d17:	75 c7                	jne    1ce0 <bigdir+0xb0>
  printf(1, "bigdir ok\n");
    1d19:	83 ec 08             	sub    $0x8,%esp
    1d1c:	68 77 45 00 00       	push   $0x4577
    1d21:	6a 01                	push   $0x1
    1d23:	e8 a8 1d 00 00       	call   3ad0 <printf>
    1d28:	83 c4 10             	add    $0x10,%esp
}
    1d2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1d2e:	5b                   	pop    %ebx
    1d2f:	5e                   	pop    %esi
    1d30:	5f                   	pop    %edi
    1d31:	5d                   	pop    %ebp
    1d32:	c3                   	ret    
      printf(1, "bigdir link failed\n");
    1d33:	83 ec 08             	sub    $0x8,%esp
    1d36:	68 4e 45 00 00       	push   $0x454e
    1d3b:	6a 01                	push   $0x1
    1d3d:	e8 8e 1d 00 00       	call   3ad0 <printf>
      exit();
    1d42:	e8 1c 1c 00 00       	call   3963 <exit>
      printf(1, "bigdir unlink failed");
    1d47:	83 ec 08             	sub    $0x8,%esp
    1d4a:	68 62 45 00 00       	push   $0x4562
    1d4f:	6a 01                	push   $0x1
    1d51:	e8 7a 1d 00 00       	call   3ad0 <printf>
      exit();
    1d56:	e8 08 1c 00 00       	call   3963 <exit>
    printf(1, "bigdir create failed\n");
    1d5b:	50                   	push   %eax
    1d5c:	50                   	push   %eax
    1d5d:	68 38 45 00 00       	push   $0x4538
    1d62:	6a 01                	push   $0x1
    1d64:	e8 67 1d 00 00       	call   3ad0 <printf>
    exit();
    1d69:	e8 f5 1b 00 00       	call   3963 <exit>
    1d6e:	66 90                	xchg   %ax,%ax

00001d70 <subdir>:
{
    1d70:	f3 0f 1e fb          	endbr32 
    1d74:	55                   	push   %ebp
    1d75:	89 e5                	mov    %esp,%ebp
    1d77:	53                   	push   %ebx
    1d78:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "subdir test\n");
    1d7b:	68 82 45 00 00       	push   $0x4582
    1d80:	6a 01                	push   $0x1
    1d82:	e8 49 1d 00 00       	call   3ad0 <printf>
  unlink("ff");
    1d87:	c7 04 24 0b 46 00 00 	movl   $0x460b,(%esp)
    1d8e:	e8 20 1c 00 00       	call   39b3 <unlink>
  if(mkdir("dd") != 0){
    1d93:	c7 04 24 a8 46 00 00 	movl   $0x46a8,(%esp)
    1d9a:	e8 2c 1c 00 00       	call   39cb <mkdir>
    1d9f:	83 c4 10             	add    $0x10,%esp
    1da2:	85 c0                	test   %eax,%eax
    1da4:	0f 85 b3 05 00 00    	jne    235d <subdir+0x5ed>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    1daa:	83 ec 08             	sub    $0x8,%esp
    1dad:	68 02 02 00 00       	push   $0x202
    1db2:	68 e1 45 00 00       	push   $0x45e1
    1db7:	e8 e7 1b 00 00       	call   39a3 <open>
  if(fd < 0){
    1dbc:	83 c4 10             	add    $0x10,%esp
  fd = open("dd/ff", O_CREATE | O_RDWR);
    1dbf:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1dc1:	85 c0                	test   %eax,%eax
    1dc3:	0f 88 81 05 00 00    	js     234a <subdir+0x5da>
  write(fd, "ff", 2);
    1dc9:	83 ec 04             	sub    $0x4,%esp
    1dcc:	6a 02                	push   $0x2
    1dce:	68 0b 46 00 00       	push   $0x460b
    1dd3:	50                   	push   %eax
    1dd4:	e8 aa 1b 00 00       	call   3983 <write>
  close(fd);
    1dd9:	89 1c 24             	mov    %ebx,(%esp)
    1ddc:	e8 aa 1b 00 00       	call   398b <close>
  if(unlink("dd") >= 0){
    1de1:	c7 04 24 a8 46 00 00 	movl   $0x46a8,(%esp)
    1de8:	e8 c6 1b 00 00       	call   39b3 <unlink>
    1ded:	83 c4 10             	add    $0x10,%esp
    1df0:	85 c0                	test   %eax,%eax
    1df2:	0f 89 3f 05 00 00    	jns    2337 <subdir+0x5c7>
  if(mkdir("/dd/dd") != 0){
    1df8:	83 ec 0c             	sub    $0xc,%esp
    1dfb:	68 bc 45 00 00       	push   $0x45bc
    1e00:	e8 c6 1b 00 00       	call   39cb <mkdir>
    1e05:	83 c4 10             	add    $0x10,%esp
    1e08:	85 c0                	test   %eax,%eax
    1e0a:	0f 85 14 05 00 00    	jne    2324 <subdir+0x5b4>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    1e10:	83 ec 08             	sub    $0x8,%esp
    1e13:	68 02 02 00 00       	push   $0x202
    1e18:	68 de 45 00 00       	push   $0x45de
    1e1d:	e8 81 1b 00 00       	call   39a3 <open>
  if(fd < 0){
    1e22:	83 c4 10             	add    $0x10,%esp
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    1e25:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1e27:	85 c0                	test   %eax,%eax
    1e29:	0f 88 24 04 00 00    	js     2253 <subdir+0x4e3>
  write(fd, "FF", 2);
    1e2f:	83 ec 04             	sub    $0x4,%esp
    1e32:	6a 02                	push   $0x2
    1e34:	68 ff 45 00 00       	push   $0x45ff
    1e39:	50                   	push   %eax
    1e3a:	e8 44 1b 00 00       	call   3983 <write>
  close(fd);
    1e3f:	89 1c 24             	mov    %ebx,(%esp)
    1e42:	e8 44 1b 00 00       	call   398b <close>
  fd = open("dd/dd/../ff", 0);
    1e47:	58                   	pop    %eax
    1e48:	5a                   	pop    %edx
    1e49:	6a 00                	push   $0x0
    1e4b:	68 02 46 00 00       	push   $0x4602
    1e50:	e8 4e 1b 00 00       	call   39a3 <open>
  if(fd < 0){
    1e55:	83 c4 10             	add    $0x10,%esp
  fd = open("dd/dd/../ff", 0);
    1e58:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1e5a:	85 c0                	test   %eax,%eax
    1e5c:	0f 88 de 03 00 00    	js     2240 <subdir+0x4d0>
  cc = read(fd, buf, sizeof(buf));
    1e62:	83 ec 04             	sub    $0x4,%esp
    1e65:	68 00 20 00 00       	push   $0x2000
    1e6a:	68 80 86 00 00       	push   $0x8680
    1e6f:	50                   	push   %eax
    1e70:	e8 06 1b 00 00       	call   397b <read>
  if(cc != 2 || buf[0] != 'f'){
    1e75:	83 c4 10             	add    $0x10,%esp
    1e78:	83 f8 02             	cmp    $0x2,%eax
    1e7b:	0f 85 3a 03 00 00    	jne    21bb <subdir+0x44b>
    1e81:	80 3d 80 86 00 00 66 	cmpb   $0x66,0x8680
    1e88:	0f 85 2d 03 00 00    	jne    21bb <subdir+0x44b>
  close(fd);
    1e8e:	83 ec 0c             	sub    $0xc,%esp
    1e91:	53                   	push   %ebx
    1e92:	e8 f4 1a 00 00       	call   398b <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    1e97:	59                   	pop    %ecx
    1e98:	5b                   	pop    %ebx
    1e99:	68 42 46 00 00       	push   $0x4642
    1e9e:	68 de 45 00 00       	push   $0x45de
    1ea3:	e8 1b 1b 00 00       	call   39c3 <link>
    1ea8:	83 c4 10             	add    $0x10,%esp
    1eab:	85 c0                	test   %eax,%eax
    1ead:	0f 85 c6 03 00 00    	jne    2279 <subdir+0x509>
  if(unlink("dd/dd/ff") != 0){
    1eb3:	83 ec 0c             	sub    $0xc,%esp
    1eb6:	68 de 45 00 00       	push   $0x45de
    1ebb:	e8 f3 1a 00 00       	call   39b3 <unlink>
    1ec0:	83 c4 10             	add    $0x10,%esp
    1ec3:	85 c0                	test   %eax,%eax
    1ec5:	0f 85 16 03 00 00    	jne    21e1 <subdir+0x471>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    1ecb:	83 ec 08             	sub    $0x8,%esp
    1ece:	6a 00                	push   $0x0
    1ed0:	68 de 45 00 00       	push   $0x45de
    1ed5:	e8 c9 1a 00 00       	call   39a3 <open>
    1eda:	83 c4 10             	add    $0x10,%esp
    1edd:	85 c0                	test   %eax,%eax
    1edf:	0f 89 2c 04 00 00    	jns    2311 <subdir+0x5a1>
  if(chdir("dd") != 0){
    1ee5:	83 ec 0c             	sub    $0xc,%esp
    1ee8:	68 a8 46 00 00       	push   $0x46a8
    1eed:	e8 e1 1a 00 00       	call   39d3 <chdir>
    1ef2:	83 c4 10             	add    $0x10,%esp
    1ef5:	85 c0                	test   %eax,%eax
    1ef7:	0f 85 01 04 00 00    	jne    22fe <subdir+0x58e>
  if(chdir("dd/../../dd") != 0){
    1efd:	83 ec 0c             	sub    $0xc,%esp
    1f00:	68 76 46 00 00       	push   $0x4676
    1f05:	e8 c9 1a 00 00       	call   39d3 <chdir>
    1f0a:	83 c4 10             	add    $0x10,%esp
    1f0d:	85 c0                	test   %eax,%eax
    1f0f:	0f 85 b9 02 00 00    	jne    21ce <subdir+0x45e>
  if(chdir("dd/../../../dd") != 0){
    1f15:	83 ec 0c             	sub    $0xc,%esp
    1f18:	68 9c 46 00 00       	push   $0x469c
    1f1d:	e8 b1 1a 00 00       	call   39d3 <chdir>
    1f22:	83 c4 10             	add    $0x10,%esp
    1f25:	85 c0                	test   %eax,%eax
    1f27:	0f 85 a1 02 00 00    	jne    21ce <subdir+0x45e>
  if(chdir("./..") != 0){
    1f2d:	83 ec 0c             	sub    $0xc,%esp
    1f30:	68 ab 46 00 00       	push   $0x46ab
    1f35:	e8 99 1a 00 00       	call   39d3 <chdir>
    1f3a:	83 c4 10             	add    $0x10,%esp
    1f3d:	85 c0                	test   %eax,%eax
    1f3f:	0f 85 21 03 00 00    	jne    2266 <subdir+0x4f6>
  fd = open("dd/dd/ffff", 0);
    1f45:	83 ec 08             	sub    $0x8,%esp
    1f48:	6a 00                	push   $0x0
    1f4a:	68 42 46 00 00       	push   $0x4642
    1f4f:	e8 4f 1a 00 00       	call   39a3 <open>
  if(fd < 0){
    1f54:	83 c4 10             	add    $0x10,%esp
  fd = open("dd/dd/ffff", 0);
    1f57:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1f59:	85 c0                	test   %eax,%eax
    1f5b:	0f 88 e0 04 00 00    	js     2441 <subdir+0x6d1>
  if(read(fd, buf, sizeof(buf)) != 2){
    1f61:	83 ec 04             	sub    $0x4,%esp
    1f64:	68 00 20 00 00       	push   $0x2000
    1f69:	68 80 86 00 00       	push   $0x8680
    1f6e:	50                   	push   %eax
    1f6f:	e8 07 1a 00 00       	call   397b <read>
    1f74:	83 c4 10             	add    $0x10,%esp
    1f77:	83 f8 02             	cmp    $0x2,%eax
    1f7a:	0f 85 ae 04 00 00    	jne    242e <subdir+0x6be>
  close(fd);
    1f80:	83 ec 0c             	sub    $0xc,%esp
    1f83:	53                   	push   %ebx
    1f84:	e8 02 1a 00 00       	call   398b <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    1f89:	58                   	pop    %eax
    1f8a:	5a                   	pop    %edx
    1f8b:	6a 00                	push   $0x0
    1f8d:	68 de 45 00 00       	push   $0x45de
    1f92:	e8 0c 1a 00 00       	call   39a3 <open>
    1f97:	83 c4 10             	add    $0x10,%esp
    1f9a:	85 c0                	test   %eax,%eax
    1f9c:	0f 89 65 02 00 00    	jns    2207 <subdir+0x497>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    1fa2:	83 ec 08             	sub    $0x8,%esp
    1fa5:	68 02 02 00 00       	push   $0x202
    1faa:	68 f6 46 00 00       	push   $0x46f6
    1faf:	e8 ef 19 00 00       	call   39a3 <open>
    1fb4:	83 c4 10             	add    $0x10,%esp
    1fb7:	85 c0                	test   %eax,%eax
    1fb9:	0f 89 35 02 00 00    	jns    21f4 <subdir+0x484>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    1fbf:	83 ec 08             	sub    $0x8,%esp
    1fc2:	68 02 02 00 00       	push   $0x202
    1fc7:	68 1b 47 00 00       	push   $0x471b
    1fcc:	e8 d2 19 00 00       	call   39a3 <open>
    1fd1:	83 c4 10             	add    $0x10,%esp
    1fd4:	85 c0                	test   %eax,%eax
    1fd6:	0f 89 0f 03 00 00    	jns    22eb <subdir+0x57b>
  if(open("dd", O_CREATE) >= 0){
    1fdc:	83 ec 08             	sub    $0x8,%esp
    1fdf:	68 00 02 00 00       	push   $0x200
    1fe4:	68 a8 46 00 00       	push   $0x46a8
    1fe9:	e8 b5 19 00 00       	call   39a3 <open>
    1fee:	83 c4 10             	add    $0x10,%esp
    1ff1:	85 c0                	test   %eax,%eax
    1ff3:	0f 89 df 02 00 00    	jns    22d8 <subdir+0x568>
  if(open("dd", O_RDWR) >= 0){
    1ff9:	83 ec 08             	sub    $0x8,%esp
    1ffc:	6a 02                	push   $0x2
    1ffe:	68 a8 46 00 00       	push   $0x46a8
    2003:	e8 9b 19 00 00       	call   39a3 <open>
    2008:	83 c4 10             	add    $0x10,%esp
    200b:	85 c0                	test   %eax,%eax
    200d:	0f 89 b2 02 00 00    	jns    22c5 <subdir+0x555>
  if(open("dd", O_WRONLY) >= 0){
    2013:	83 ec 08             	sub    $0x8,%esp
    2016:	6a 01                	push   $0x1
    2018:	68 a8 46 00 00       	push   $0x46a8
    201d:	e8 81 19 00 00       	call   39a3 <open>
    2022:	83 c4 10             	add    $0x10,%esp
    2025:	85 c0                	test   %eax,%eax
    2027:	0f 89 85 02 00 00    	jns    22b2 <subdir+0x542>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    202d:	83 ec 08             	sub    $0x8,%esp
    2030:	68 8a 47 00 00       	push   $0x478a
    2035:	68 f6 46 00 00       	push   $0x46f6
    203a:	e8 84 19 00 00       	call   39c3 <link>
    203f:	83 c4 10             	add    $0x10,%esp
    2042:	85 c0                	test   %eax,%eax
    2044:	0f 84 55 02 00 00    	je     229f <subdir+0x52f>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    204a:	83 ec 08             	sub    $0x8,%esp
    204d:	68 8a 47 00 00       	push   $0x478a
    2052:	68 1b 47 00 00       	push   $0x471b
    2057:	e8 67 19 00 00       	call   39c3 <link>
    205c:	83 c4 10             	add    $0x10,%esp
    205f:	85 c0                	test   %eax,%eax
    2061:	0f 84 25 02 00 00    	je     228c <subdir+0x51c>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2067:	83 ec 08             	sub    $0x8,%esp
    206a:	68 42 46 00 00       	push   $0x4642
    206f:	68 e1 45 00 00       	push   $0x45e1
    2074:	e8 4a 19 00 00       	call   39c3 <link>
    2079:	83 c4 10             	add    $0x10,%esp
    207c:	85 c0                	test   %eax,%eax
    207e:	0f 84 a9 01 00 00    	je     222d <subdir+0x4bd>
  if(mkdir("dd/ff/ff") == 0){
    2084:	83 ec 0c             	sub    $0xc,%esp
    2087:	68 f6 46 00 00       	push   $0x46f6
    208c:	e8 3a 19 00 00       	call   39cb <mkdir>
    2091:	83 c4 10             	add    $0x10,%esp
    2094:	85 c0                	test   %eax,%eax
    2096:	0f 84 7e 01 00 00    	je     221a <subdir+0x4aa>
  if(mkdir("dd/xx/ff") == 0){
    209c:	83 ec 0c             	sub    $0xc,%esp
    209f:	68 1b 47 00 00       	push   $0x471b
    20a4:	e8 22 19 00 00       	call   39cb <mkdir>
    20a9:	83 c4 10             	add    $0x10,%esp
    20ac:	85 c0                	test   %eax,%eax
    20ae:	0f 84 67 03 00 00    	je     241b <subdir+0x6ab>
  if(mkdir("dd/dd/ffff") == 0){
    20b4:	83 ec 0c             	sub    $0xc,%esp
    20b7:	68 42 46 00 00       	push   $0x4642
    20bc:	e8 0a 19 00 00       	call   39cb <mkdir>
    20c1:	83 c4 10             	add    $0x10,%esp
    20c4:	85 c0                	test   %eax,%eax
    20c6:	0f 84 3c 03 00 00    	je     2408 <subdir+0x698>
  if(unlink("dd/xx/ff") == 0){
    20cc:	83 ec 0c             	sub    $0xc,%esp
    20cf:	68 1b 47 00 00       	push   $0x471b
    20d4:	e8 da 18 00 00       	call   39b3 <unlink>
    20d9:	83 c4 10             	add    $0x10,%esp
    20dc:	85 c0                	test   %eax,%eax
    20de:	0f 84 11 03 00 00    	je     23f5 <subdir+0x685>
  if(unlink("dd/ff/ff") == 0){
    20e4:	83 ec 0c             	sub    $0xc,%esp
    20e7:	68 f6 46 00 00       	push   $0x46f6
    20ec:	e8 c2 18 00 00       	call   39b3 <unlink>
    20f1:	83 c4 10             	add    $0x10,%esp
    20f4:	85 c0                	test   %eax,%eax
    20f6:	0f 84 e6 02 00 00    	je     23e2 <subdir+0x672>
  if(chdir("dd/ff") == 0){
    20fc:	83 ec 0c             	sub    $0xc,%esp
    20ff:	68 e1 45 00 00       	push   $0x45e1
    2104:	e8 ca 18 00 00       	call   39d3 <chdir>
    2109:	83 c4 10             	add    $0x10,%esp
    210c:	85 c0                	test   %eax,%eax
    210e:	0f 84 bb 02 00 00    	je     23cf <subdir+0x65f>
  if(chdir("dd/xx") == 0){
    2114:	83 ec 0c             	sub    $0xc,%esp
    2117:	68 8d 47 00 00       	push   $0x478d
    211c:	e8 b2 18 00 00       	call   39d3 <chdir>
    2121:	83 c4 10             	add    $0x10,%esp
    2124:	85 c0                	test   %eax,%eax
    2126:	0f 84 90 02 00 00    	je     23bc <subdir+0x64c>
  if(unlink("dd/dd/ffff") != 0){
    212c:	83 ec 0c             	sub    $0xc,%esp
    212f:	68 42 46 00 00       	push   $0x4642
    2134:	e8 7a 18 00 00       	call   39b3 <unlink>
    2139:	83 c4 10             	add    $0x10,%esp
    213c:	85 c0                	test   %eax,%eax
    213e:	0f 85 9d 00 00 00    	jne    21e1 <subdir+0x471>
  if(unlink("dd/ff") != 0){
    2144:	83 ec 0c             	sub    $0xc,%esp
    2147:	68 e1 45 00 00       	push   $0x45e1
    214c:	e8 62 18 00 00       	call   39b3 <unlink>
    2151:	83 c4 10             	add    $0x10,%esp
    2154:	85 c0                	test   %eax,%eax
    2156:	0f 85 4d 02 00 00    	jne    23a9 <subdir+0x639>
  if(unlink("dd") == 0){
    215c:	83 ec 0c             	sub    $0xc,%esp
    215f:	68 a8 46 00 00       	push   $0x46a8
    2164:	e8 4a 18 00 00       	call   39b3 <unlink>
    2169:	83 c4 10             	add    $0x10,%esp
    216c:	85 c0                	test   %eax,%eax
    216e:	0f 84 22 02 00 00    	je     2396 <subdir+0x626>
  if(unlink("dd/dd") < 0){
    2174:	83 ec 0c             	sub    $0xc,%esp
    2177:	68 bd 45 00 00       	push   $0x45bd
    217c:	e8 32 18 00 00       	call   39b3 <unlink>
    2181:	83 c4 10             	add    $0x10,%esp
    2184:	85 c0                	test   %eax,%eax
    2186:	0f 88 f7 01 00 00    	js     2383 <subdir+0x613>
  if(unlink("dd") < 0){
    218c:	83 ec 0c             	sub    $0xc,%esp
    218f:	68 a8 46 00 00       	push   $0x46a8
    2194:	e8 1a 18 00 00       	call   39b3 <unlink>
    2199:	83 c4 10             	add    $0x10,%esp
    219c:	85 c0                	test   %eax,%eax
    219e:	0f 88 cc 01 00 00    	js     2370 <subdir+0x600>
  printf(1, "subdir ok\n");
    21a4:	83 ec 08             	sub    $0x8,%esp
    21a7:	68 8a 48 00 00       	push   $0x488a
    21ac:	6a 01                	push   $0x1
    21ae:	e8 1d 19 00 00       	call   3ad0 <printf>
}
    21b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    21b6:	83 c4 10             	add    $0x10,%esp
    21b9:	c9                   	leave  
    21ba:	c3                   	ret    
    printf(1, "dd/dd/../ff wrong content\n");
    21bb:	50                   	push   %eax
    21bc:	50                   	push   %eax
    21bd:	68 27 46 00 00       	push   $0x4627
    21c2:	6a 01                	push   $0x1
    21c4:	e8 07 19 00 00       	call   3ad0 <printf>
    exit();
    21c9:	e8 95 17 00 00       	call   3963 <exit>
    printf(1, "chdir dd/../../dd failed\n");
    21ce:	50                   	push   %eax
    21cf:	50                   	push   %eax
    21d0:	68 82 46 00 00       	push   $0x4682
    21d5:	6a 01                	push   $0x1
    21d7:	e8 f4 18 00 00       	call   3ad0 <printf>
    exit();
    21dc:	e8 82 17 00 00       	call   3963 <exit>
    printf(1, "unlink dd/dd/ff failed\n");
    21e1:	50                   	push   %eax
    21e2:	50                   	push   %eax
    21e3:	68 4d 46 00 00       	push   $0x464d
    21e8:	6a 01                	push   $0x1
    21ea:	e8 e1 18 00 00       	call   3ad0 <printf>
    exit();
    21ef:	e8 6f 17 00 00       	call   3963 <exit>
    printf(1, "create dd/ff/ff succeeded!\n");
    21f4:	51                   	push   %ecx
    21f5:	51                   	push   %ecx
    21f6:	68 ff 46 00 00       	push   $0x46ff
    21fb:	6a 01                	push   $0x1
    21fd:	e8 ce 18 00 00       	call   3ad0 <printf>
    exit();
    2202:	e8 5c 17 00 00       	call   3963 <exit>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    2207:	53                   	push   %ebx
    2208:	53                   	push   %ebx
    2209:	68 e4 50 00 00       	push   $0x50e4
    220e:	6a 01                	push   $0x1
    2210:	e8 bb 18 00 00       	call   3ad0 <printf>
    exit();
    2215:	e8 49 17 00 00       	call   3963 <exit>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    221a:	51                   	push   %ecx
    221b:	51                   	push   %ecx
    221c:	68 93 47 00 00       	push   $0x4793
    2221:	6a 01                	push   $0x1
    2223:	e8 a8 18 00 00       	call   3ad0 <printf>
    exit();
    2228:	e8 36 17 00 00       	call   3963 <exit>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    222d:	53                   	push   %ebx
    222e:	53                   	push   %ebx
    222f:	68 54 51 00 00       	push   $0x5154
    2234:	6a 01                	push   $0x1
    2236:	e8 95 18 00 00       	call   3ad0 <printf>
    exit();
    223b:	e8 23 17 00 00       	call   3963 <exit>
    printf(1, "open dd/dd/../ff failed\n");
    2240:	50                   	push   %eax
    2241:	50                   	push   %eax
    2242:	68 0e 46 00 00       	push   $0x460e
    2247:	6a 01                	push   $0x1
    2249:	e8 82 18 00 00       	call   3ad0 <printf>
    exit();
    224e:	e8 10 17 00 00       	call   3963 <exit>
    printf(1, "create dd/dd/ff failed\n");
    2253:	51                   	push   %ecx
    2254:	51                   	push   %ecx
    2255:	68 e7 45 00 00       	push   $0x45e7
    225a:	6a 01                	push   $0x1
    225c:	e8 6f 18 00 00       	call   3ad0 <printf>
    exit();
    2261:	e8 fd 16 00 00       	call   3963 <exit>
    printf(1, "chdir ./.. failed\n");
    2266:	50                   	push   %eax
    2267:	50                   	push   %eax
    2268:	68 b0 46 00 00       	push   $0x46b0
    226d:	6a 01                	push   $0x1
    226f:	e8 5c 18 00 00       	call   3ad0 <printf>
    exit();
    2274:	e8 ea 16 00 00       	call   3963 <exit>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    2279:	52                   	push   %edx
    227a:	52                   	push   %edx
    227b:	68 9c 50 00 00       	push   $0x509c
    2280:	6a 01                	push   $0x1
    2282:	e8 49 18 00 00       	call   3ad0 <printf>
    exit();
    2287:	e8 d7 16 00 00       	call   3963 <exit>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    228c:	50                   	push   %eax
    228d:	50                   	push   %eax
    228e:	68 30 51 00 00       	push   $0x5130
    2293:	6a 01                	push   $0x1
    2295:	e8 36 18 00 00       	call   3ad0 <printf>
    exit();
    229a:	e8 c4 16 00 00       	call   3963 <exit>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    229f:	50                   	push   %eax
    22a0:	50                   	push   %eax
    22a1:	68 0c 51 00 00       	push   $0x510c
    22a6:	6a 01                	push   $0x1
    22a8:	e8 23 18 00 00       	call   3ad0 <printf>
    exit();
    22ad:	e8 b1 16 00 00       	call   3963 <exit>
    printf(1, "open dd wronly succeeded!\n");
    22b2:	50                   	push   %eax
    22b3:	50                   	push   %eax
    22b4:	68 6f 47 00 00       	push   $0x476f
    22b9:	6a 01                	push   $0x1
    22bb:	e8 10 18 00 00       	call   3ad0 <printf>
    exit();
    22c0:	e8 9e 16 00 00       	call   3963 <exit>
    printf(1, "open dd rdwr succeeded!\n");
    22c5:	50                   	push   %eax
    22c6:	50                   	push   %eax
    22c7:	68 56 47 00 00       	push   $0x4756
    22cc:	6a 01                	push   $0x1
    22ce:	e8 fd 17 00 00       	call   3ad0 <printf>
    exit();
    22d3:	e8 8b 16 00 00       	call   3963 <exit>
    printf(1, "create dd succeeded!\n");
    22d8:	50                   	push   %eax
    22d9:	50                   	push   %eax
    22da:	68 40 47 00 00       	push   $0x4740
    22df:	6a 01                	push   $0x1
    22e1:	e8 ea 17 00 00       	call   3ad0 <printf>
    exit();
    22e6:	e8 78 16 00 00       	call   3963 <exit>
    printf(1, "create dd/xx/ff succeeded!\n");
    22eb:	52                   	push   %edx
    22ec:	52                   	push   %edx
    22ed:	68 24 47 00 00       	push   $0x4724
    22f2:	6a 01                	push   $0x1
    22f4:	e8 d7 17 00 00       	call   3ad0 <printf>
    exit();
    22f9:	e8 65 16 00 00       	call   3963 <exit>
    printf(1, "chdir dd failed\n");
    22fe:	50                   	push   %eax
    22ff:	50                   	push   %eax
    2300:	68 65 46 00 00       	push   $0x4665
    2305:	6a 01                	push   $0x1
    2307:	e8 c4 17 00 00       	call   3ad0 <printf>
    exit();
    230c:	e8 52 16 00 00       	call   3963 <exit>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    2311:	50                   	push   %eax
    2312:	50                   	push   %eax
    2313:	68 c0 50 00 00       	push   $0x50c0
    2318:	6a 01                	push   $0x1
    231a:	e8 b1 17 00 00       	call   3ad0 <printf>
    exit();
    231f:	e8 3f 16 00 00       	call   3963 <exit>
    printf(1, "subdir mkdir dd/dd failed\n");
    2324:	53                   	push   %ebx
    2325:	53                   	push   %ebx
    2326:	68 c3 45 00 00       	push   $0x45c3
    232b:	6a 01                	push   $0x1
    232d:	e8 9e 17 00 00       	call   3ad0 <printf>
    exit();
    2332:	e8 2c 16 00 00       	call   3963 <exit>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    2337:	50                   	push   %eax
    2338:	50                   	push   %eax
    2339:	68 74 50 00 00       	push   $0x5074
    233e:	6a 01                	push   $0x1
    2340:	e8 8b 17 00 00       	call   3ad0 <printf>
    exit();
    2345:	e8 19 16 00 00       	call   3963 <exit>
    printf(1, "create dd/ff failed\n");
    234a:	50                   	push   %eax
    234b:	50                   	push   %eax
    234c:	68 a7 45 00 00       	push   $0x45a7
    2351:	6a 01                	push   $0x1
    2353:	e8 78 17 00 00       	call   3ad0 <printf>
    exit();
    2358:	e8 06 16 00 00       	call   3963 <exit>
    printf(1, "subdir mkdir dd failed\n");
    235d:	50                   	push   %eax
    235e:	50                   	push   %eax
    235f:	68 8f 45 00 00       	push   $0x458f
    2364:	6a 01                	push   $0x1
    2366:	e8 65 17 00 00       	call   3ad0 <printf>
    exit();
    236b:	e8 f3 15 00 00       	call   3963 <exit>
    printf(1, "unlink dd failed\n");
    2370:	50                   	push   %eax
    2371:	50                   	push   %eax
    2372:	68 78 48 00 00       	push   $0x4878
    2377:	6a 01                	push   $0x1
    2379:	e8 52 17 00 00       	call   3ad0 <printf>
    exit();
    237e:	e8 e0 15 00 00       	call   3963 <exit>
    printf(1, "unlink dd/dd failed\n");
    2383:	52                   	push   %edx
    2384:	52                   	push   %edx
    2385:	68 63 48 00 00       	push   $0x4863
    238a:	6a 01                	push   $0x1
    238c:	e8 3f 17 00 00       	call   3ad0 <printf>
    exit();
    2391:	e8 cd 15 00 00       	call   3963 <exit>
    printf(1, "unlink non-empty dd succeeded!\n");
    2396:	51                   	push   %ecx
    2397:	51                   	push   %ecx
    2398:	68 78 51 00 00       	push   $0x5178
    239d:	6a 01                	push   $0x1
    239f:	e8 2c 17 00 00       	call   3ad0 <printf>
    exit();
    23a4:	e8 ba 15 00 00       	call   3963 <exit>
    printf(1, "unlink dd/ff failed\n");
    23a9:	53                   	push   %ebx
    23aa:	53                   	push   %ebx
    23ab:	68 4e 48 00 00       	push   $0x484e
    23b0:	6a 01                	push   $0x1
    23b2:	e8 19 17 00 00       	call   3ad0 <printf>
    exit();
    23b7:	e8 a7 15 00 00       	call   3963 <exit>
    printf(1, "chdir dd/xx succeeded!\n");
    23bc:	50                   	push   %eax
    23bd:	50                   	push   %eax
    23be:	68 36 48 00 00       	push   $0x4836
    23c3:	6a 01                	push   $0x1
    23c5:	e8 06 17 00 00       	call   3ad0 <printf>
    exit();
    23ca:	e8 94 15 00 00       	call   3963 <exit>
    printf(1, "chdir dd/ff succeeded!\n");
    23cf:	50                   	push   %eax
    23d0:	50                   	push   %eax
    23d1:	68 1e 48 00 00       	push   $0x481e
    23d6:	6a 01                	push   $0x1
    23d8:	e8 f3 16 00 00       	call   3ad0 <printf>
    exit();
    23dd:	e8 81 15 00 00       	call   3963 <exit>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    23e2:	50                   	push   %eax
    23e3:	50                   	push   %eax
    23e4:	68 02 48 00 00       	push   $0x4802
    23e9:	6a 01                	push   $0x1
    23eb:	e8 e0 16 00 00       	call   3ad0 <printf>
    exit();
    23f0:	e8 6e 15 00 00       	call   3963 <exit>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    23f5:	50                   	push   %eax
    23f6:	50                   	push   %eax
    23f7:	68 e6 47 00 00       	push   $0x47e6
    23fc:	6a 01                	push   $0x1
    23fe:	e8 cd 16 00 00       	call   3ad0 <printf>
    exit();
    2403:	e8 5b 15 00 00       	call   3963 <exit>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    2408:	50                   	push   %eax
    2409:	50                   	push   %eax
    240a:	68 c9 47 00 00       	push   $0x47c9
    240f:	6a 01                	push   $0x1
    2411:	e8 ba 16 00 00       	call   3ad0 <printf>
    exit();
    2416:	e8 48 15 00 00       	call   3963 <exit>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    241b:	52                   	push   %edx
    241c:	52                   	push   %edx
    241d:	68 ae 47 00 00       	push   $0x47ae
    2422:	6a 01                	push   $0x1
    2424:	e8 a7 16 00 00       	call   3ad0 <printf>
    exit();
    2429:	e8 35 15 00 00       	call   3963 <exit>
    printf(1, "read dd/dd/ffff wrong len\n");
    242e:	51                   	push   %ecx
    242f:	51                   	push   %ecx
    2430:	68 db 46 00 00       	push   $0x46db
    2435:	6a 01                	push   $0x1
    2437:	e8 94 16 00 00       	call   3ad0 <printf>
    exit();
    243c:	e8 22 15 00 00       	call   3963 <exit>
    printf(1, "open dd/dd/ffff failed\n");
    2441:	53                   	push   %ebx
    2442:	53                   	push   %ebx
    2443:	68 c3 46 00 00       	push   $0x46c3
    2448:	6a 01                	push   $0x1
    244a:	e8 81 16 00 00       	call   3ad0 <printf>
    exit();
    244f:	e8 0f 15 00 00       	call   3963 <exit>
    2454:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    245b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    245f:	90                   	nop

00002460 <bigwrite>:
{
    2460:	f3 0f 1e fb          	endbr32 
    2464:	55                   	push   %ebp
    2465:	89 e5                	mov    %esp,%ebp
    2467:	56                   	push   %esi
    2468:	53                   	push   %ebx
  for(sz = 499; sz < 12*512; sz += 471){
    2469:	bb f3 01 00 00       	mov    $0x1f3,%ebx
  printf(1, "bigwrite test\n");
    246e:	83 ec 08             	sub    $0x8,%esp
    2471:	68 95 48 00 00       	push   $0x4895
    2476:	6a 01                	push   $0x1
    2478:	e8 53 16 00 00       	call   3ad0 <printf>
  unlink("bigwrite");
    247d:	c7 04 24 a4 48 00 00 	movl   $0x48a4,(%esp)
    2484:	e8 2a 15 00 00       	call   39b3 <unlink>
    2489:	83 c4 10             	add    $0x10,%esp
    248c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    fd = open("bigwrite", O_CREATE | O_RDWR);
    2490:	83 ec 08             	sub    $0x8,%esp
    2493:	68 02 02 00 00       	push   $0x202
    2498:	68 a4 48 00 00       	push   $0x48a4
    249d:	e8 01 15 00 00       	call   39a3 <open>
    if(fd < 0){
    24a2:	83 c4 10             	add    $0x10,%esp
    fd = open("bigwrite", O_CREATE | O_RDWR);
    24a5:	89 c6                	mov    %eax,%esi
    if(fd < 0){
    24a7:	85 c0                	test   %eax,%eax
    24a9:	78 7e                	js     2529 <bigwrite+0xc9>
      int cc = write(fd, buf, sz);
    24ab:	83 ec 04             	sub    $0x4,%esp
    24ae:	53                   	push   %ebx
    24af:	68 80 86 00 00       	push   $0x8680
    24b4:	50                   	push   %eax
    24b5:	e8 c9 14 00 00       	call   3983 <write>
      if(cc != sz){
    24ba:	83 c4 10             	add    $0x10,%esp
    24bd:	39 d8                	cmp    %ebx,%eax
    24bf:	75 55                	jne    2516 <bigwrite+0xb6>
      int cc = write(fd, buf, sz);
    24c1:	83 ec 04             	sub    $0x4,%esp
    24c4:	53                   	push   %ebx
    24c5:	68 80 86 00 00       	push   $0x8680
    24ca:	56                   	push   %esi
    24cb:	e8 b3 14 00 00       	call   3983 <write>
      if(cc != sz){
    24d0:	83 c4 10             	add    $0x10,%esp
    24d3:	39 d8                	cmp    %ebx,%eax
    24d5:	75 3f                	jne    2516 <bigwrite+0xb6>
    close(fd);
    24d7:	83 ec 0c             	sub    $0xc,%esp
  for(sz = 499; sz < 12*512; sz += 471){
    24da:	81 c3 d7 01 00 00    	add    $0x1d7,%ebx
    close(fd);
    24e0:	56                   	push   %esi
    24e1:	e8 a5 14 00 00       	call   398b <close>
    unlink("bigwrite");
    24e6:	c7 04 24 a4 48 00 00 	movl   $0x48a4,(%esp)
    24ed:	e8 c1 14 00 00       	call   39b3 <unlink>
  for(sz = 499; sz < 12*512; sz += 471){
    24f2:	83 c4 10             	add    $0x10,%esp
    24f5:	81 fb 07 18 00 00    	cmp    $0x1807,%ebx
    24fb:	75 93                	jne    2490 <bigwrite+0x30>
  printf(1, "bigwrite ok\n");
    24fd:	83 ec 08             	sub    $0x8,%esp
    2500:	68 d7 48 00 00       	push   $0x48d7
    2505:	6a 01                	push   $0x1
    2507:	e8 c4 15 00 00       	call   3ad0 <printf>
}
    250c:	83 c4 10             	add    $0x10,%esp
    250f:	8d 65 f8             	lea    -0x8(%ebp),%esp
    2512:	5b                   	pop    %ebx
    2513:	5e                   	pop    %esi
    2514:	5d                   	pop    %ebp
    2515:	c3                   	ret    
        printf(1, "write(%d) ret %d\n", sz, cc);
    2516:	50                   	push   %eax
    2517:	53                   	push   %ebx
    2518:	68 c5 48 00 00       	push   $0x48c5
    251d:	6a 01                	push   $0x1
    251f:	e8 ac 15 00 00       	call   3ad0 <printf>
        exit();
    2524:	e8 3a 14 00 00       	call   3963 <exit>
      printf(1, "cannot create bigwrite\n");
    2529:	83 ec 08             	sub    $0x8,%esp
    252c:	68 ad 48 00 00       	push   $0x48ad
    2531:	6a 01                	push   $0x1
    2533:	e8 98 15 00 00       	call   3ad0 <printf>
      exit();
    2538:	e8 26 14 00 00       	call   3963 <exit>
    253d:	8d 76 00             	lea    0x0(%esi),%esi

00002540 <bigfile>:
{
    2540:	f3 0f 1e fb          	endbr32 
    2544:	55                   	push   %ebp
    2545:	89 e5                	mov    %esp,%ebp
    2547:	57                   	push   %edi
    2548:	56                   	push   %esi
    2549:	53                   	push   %ebx
    254a:	83 ec 14             	sub    $0x14,%esp
  printf(1, "bigfile test\n");
    254d:	68 e4 48 00 00       	push   $0x48e4
    2552:	6a 01                	push   $0x1
    2554:	e8 77 15 00 00       	call   3ad0 <printf>
  unlink("bigfile");
    2559:	c7 04 24 00 49 00 00 	movl   $0x4900,(%esp)
    2560:	e8 4e 14 00 00       	call   39b3 <unlink>
  fd = open("bigfile", O_CREATE | O_RDWR);
    2565:	58                   	pop    %eax
    2566:	5a                   	pop    %edx
    2567:	68 02 02 00 00       	push   $0x202
    256c:	68 00 49 00 00       	push   $0x4900
    2571:	e8 2d 14 00 00       	call   39a3 <open>
  if(fd < 0){
    2576:	83 c4 10             	add    $0x10,%esp
    2579:	85 c0                	test   %eax,%eax
    257b:	0f 88 5a 01 00 00    	js     26db <bigfile+0x19b>
    2581:	89 c6                	mov    %eax,%esi
  for(i = 0; i < 20; i++){
    2583:	31 db                	xor    %ebx,%ebx
    2585:	8d 76 00             	lea    0x0(%esi),%esi
    memset(buf, i, 600);
    2588:	83 ec 04             	sub    $0x4,%esp
    258b:	68 58 02 00 00       	push   $0x258
    2590:	53                   	push   %ebx
    2591:	68 80 86 00 00       	push   $0x8680
    2596:	e8 25 12 00 00       	call   37c0 <memset>
    if(write(fd, buf, 600) != 600){
    259b:	83 c4 0c             	add    $0xc,%esp
    259e:	68 58 02 00 00       	push   $0x258
    25a3:	68 80 86 00 00       	push   $0x8680
    25a8:	56                   	push   %esi
    25a9:	e8 d5 13 00 00       	call   3983 <write>
    25ae:	83 c4 10             	add    $0x10,%esp
    25b1:	3d 58 02 00 00       	cmp    $0x258,%eax
    25b6:	0f 85 f8 00 00 00    	jne    26b4 <bigfile+0x174>
  for(i = 0; i < 20; i++){
    25bc:	83 c3 01             	add    $0x1,%ebx
    25bf:	83 fb 14             	cmp    $0x14,%ebx
    25c2:	75 c4                	jne    2588 <bigfile+0x48>
  close(fd);
    25c4:	83 ec 0c             	sub    $0xc,%esp
    25c7:	56                   	push   %esi
    25c8:	e8 be 13 00 00       	call   398b <close>
  fd = open("bigfile", 0);
    25cd:	5e                   	pop    %esi
    25ce:	5f                   	pop    %edi
    25cf:	6a 00                	push   $0x0
    25d1:	68 00 49 00 00       	push   $0x4900
    25d6:	e8 c8 13 00 00       	call   39a3 <open>
  if(fd < 0){
    25db:	83 c4 10             	add    $0x10,%esp
  fd = open("bigfile", 0);
    25de:	89 c6                	mov    %eax,%esi
  if(fd < 0){
    25e0:	85 c0                	test   %eax,%eax
    25e2:	0f 88 e0 00 00 00    	js     26c8 <bigfile+0x188>
  total = 0;
    25e8:	31 db                	xor    %ebx,%ebx
  for(i = 0; ; i++){
    25ea:	31 ff                	xor    %edi,%edi
    25ec:	eb 30                	jmp    261e <bigfile+0xde>
    25ee:	66 90                	xchg   %ax,%ax
    if(cc != 300){
    25f0:	3d 2c 01 00 00       	cmp    $0x12c,%eax
    25f5:	0f 85 91 00 00 00    	jne    268c <bigfile+0x14c>
    if(buf[0] != i/2 || buf[299] != i/2){
    25fb:	89 fa                	mov    %edi,%edx
    25fd:	0f be 05 80 86 00 00 	movsbl 0x8680,%eax
    2604:	d1 fa                	sar    %edx
    2606:	39 d0                	cmp    %edx,%eax
    2608:	75 6e                	jne    2678 <bigfile+0x138>
    260a:	0f be 15 ab 87 00 00 	movsbl 0x87ab,%edx
    2611:	39 d0                	cmp    %edx,%eax
    2613:	75 63                	jne    2678 <bigfile+0x138>
    total += cc;
    2615:	81 c3 2c 01 00 00    	add    $0x12c,%ebx
  for(i = 0; ; i++){
    261b:	83 c7 01             	add    $0x1,%edi
    cc = read(fd, buf, 300);
    261e:	83 ec 04             	sub    $0x4,%esp
    2621:	68 2c 01 00 00       	push   $0x12c
    2626:	68 80 86 00 00       	push   $0x8680
    262b:	56                   	push   %esi
    262c:	e8 4a 13 00 00       	call   397b <read>
    if(cc < 0){
    2631:	83 c4 10             	add    $0x10,%esp
    2634:	85 c0                	test   %eax,%eax
    2636:	78 68                	js     26a0 <bigfile+0x160>
    if(cc == 0)
    2638:	75 b6                	jne    25f0 <bigfile+0xb0>
  close(fd);
    263a:	83 ec 0c             	sub    $0xc,%esp
    263d:	56                   	push   %esi
    263e:	e8 48 13 00 00       	call   398b <close>
  if(total != 20*600){
    2643:	83 c4 10             	add    $0x10,%esp
    2646:	81 fb e0 2e 00 00    	cmp    $0x2ee0,%ebx
    264c:	0f 85 9c 00 00 00    	jne    26ee <bigfile+0x1ae>
  unlink("bigfile");
    2652:	83 ec 0c             	sub    $0xc,%esp
    2655:	68 00 49 00 00       	push   $0x4900
    265a:	e8 54 13 00 00       	call   39b3 <unlink>
  printf(1, "bigfile test ok\n");
    265f:	58                   	pop    %eax
    2660:	5a                   	pop    %edx
    2661:	68 8f 49 00 00       	push   $0x498f
    2666:	6a 01                	push   $0x1
    2668:	e8 63 14 00 00       	call   3ad0 <printf>
}
    266d:	83 c4 10             	add    $0x10,%esp
    2670:	8d 65 f4             	lea    -0xc(%ebp),%esp
    2673:	5b                   	pop    %ebx
    2674:	5e                   	pop    %esi
    2675:	5f                   	pop    %edi
    2676:	5d                   	pop    %ebp
    2677:	c3                   	ret    
      printf(1, "read bigfile wrong data\n");
    2678:	83 ec 08             	sub    $0x8,%esp
    267b:	68 5c 49 00 00       	push   $0x495c
    2680:	6a 01                	push   $0x1
    2682:	e8 49 14 00 00       	call   3ad0 <printf>
      exit();
    2687:	e8 d7 12 00 00       	call   3963 <exit>
      printf(1, "short read bigfile\n");
    268c:	83 ec 08             	sub    $0x8,%esp
    268f:	68 48 49 00 00       	push   $0x4948
    2694:	6a 01                	push   $0x1
    2696:	e8 35 14 00 00       	call   3ad0 <printf>
      exit();
    269b:	e8 c3 12 00 00       	call   3963 <exit>
      printf(1, "read bigfile failed\n");
    26a0:	83 ec 08             	sub    $0x8,%esp
    26a3:	68 33 49 00 00       	push   $0x4933
    26a8:	6a 01                	push   $0x1
    26aa:	e8 21 14 00 00       	call   3ad0 <printf>
      exit();
    26af:	e8 af 12 00 00       	call   3963 <exit>
      printf(1, "write bigfile failed\n");
    26b4:	83 ec 08             	sub    $0x8,%esp
    26b7:	68 08 49 00 00       	push   $0x4908
    26bc:	6a 01                	push   $0x1
    26be:	e8 0d 14 00 00       	call   3ad0 <printf>
      exit();
    26c3:	e8 9b 12 00 00       	call   3963 <exit>
    printf(1, "cannot open bigfile\n");
    26c8:	53                   	push   %ebx
    26c9:	53                   	push   %ebx
    26ca:	68 1e 49 00 00       	push   $0x491e
    26cf:	6a 01                	push   $0x1
    26d1:	e8 fa 13 00 00       	call   3ad0 <printf>
    exit();
    26d6:	e8 88 12 00 00       	call   3963 <exit>
    printf(1, "cannot create bigfile");
    26db:	50                   	push   %eax
    26dc:	50                   	push   %eax
    26dd:	68 f2 48 00 00       	push   $0x48f2
    26e2:	6a 01                	push   $0x1
    26e4:	e8 e7 13 00 00       	call   3ad0 <printf>
    exit();
    26e9:	e8 75 12 00 00       	call   3963 <exit>
    printf(1, "read bigfile wrong total\n");
    26ee:	51                   	push   %ecx
    26ef:	51                   	push   %ecx
    26f0:	68 75 49 00 00       	push   $0x4975
    26f5:	6a 01                	push   $0x1
    26f7:	e8 d4 13 00 00       	call   3ad0 <printf>
    exit();
    26fc:	e8 62 12 00 00       	call   3963 <exit>
    2701:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    2708:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    270f:	90                   	nop

00002710 <fourteen>:
{
    2710:	f3 0f 1e fb          	endbr32 
    2714:	55                   	push   %ebp
    2715:	89 e5                	mov    %esp,%ebp
    2717:	83 ec 10             	sub    $0x10,%esp
  printf(1, "fourteen test\n");
    271a:	68 a0 49 00 00       	push   $0x49a0
    271f:	6a 01                	push   $0x1
    2721:	e8 aa 13 00 00       	call   3ad0 <printf>
  if(mkdir("12345678901234") != 0){
    2726:	c7 04 24 db 49 00 00 	movl   $0x49db,(%esp)
    272d:	e8 99 12 00 00       	call   39cb <mkdir>
    2732:	83 c4 10             	add    $0x10,%esp
    2735:	85 c0                	test   %eax,%eax
    2737:	0f 85 97 00 00 00    	jne    27d4 <fourteen+0xc4>
  if(mkdir("12345678901234/123456789012345") != 0){
    273d:	83 ec 0c             	sub    $0xc,%esp
    2740:	68 98 51 00 00       	push   $0x5198
    2745:	e8 81 12 00 00       	call   39cb <mkdir>
    274a:	83 c4 10             	add    $0x10,%esp
    274d:	85 c0                	test   %eax,%eax
    274f:	0f 85 de 00 00 00    	jne    2833 <fourteen+0x123>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2755:	83 ec 08             	sub    $0x8,%esp
    2758:	68 00 02 00 00       	push   $0x200
    275d:	68 e8 51 00 00       	push   $0x51e8
    2762:	e8 3c 12 00 00       	call   39a3 <open>
  if(fd < 0){
    2767:	83 c4 10             	add    $0x10,%esp
    276a:	85 c0                	test   %eax,%eax
    276c:	0f 88 ae 00 00 00    	js     2820 <fourteen+0x110>
  close(fd);
    2772:	83 ec 0c             	sub    $0xc,%esp
    2775:	50                   	push   %eax
    2776:	e8 10 12 00 00       	call   398b <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    277b:	58                   	pop    %eax
    277c:	5a                   	pop    %edx
    277d:	6a 00                	push   $0x0
    277f:	68 58 52 00 00       	push   $0x5258
    2784:	e8 1a 12 00 00       	call   39a3 <open>
  if(fd < 0){
    2789:	83 c4 10             	add    $0x10,%esp
    278c:	85 c0                	test   %eax,%eax
    278e:	78 7d                	js     280d <fourteen+0xfd>
  close(fd);
    2790:	83 ec 0c             	sub    $0xc,%esp
    2793:	50                   	push   %eax
    2794:	e8 f2 11 00 00       	call   398b <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    2799:	c7 04 24 cc 49 00 00 	movl   $0x49cc,(%esp)
    27a0:	e8 26 12 00 00       	call   39cb <mkdir>
    27a5:	83 c4 10             	add    $0x10,%esp
    27a8:	85 c0                	test   %eax,%eax
    27aa:	74 4e                	je     27fa <fourteen+0xea>
  if(mkdir("123456789012345/12345678901234") == 0){
    27ac:	83 ec 0c             	sub    $0xc,%esp
    27af:	68 f4 52 00 00       	push   $0x52f4
    27b4:	e8 12 12 00 00       	call   39cb <mkdir>
    27b9:	83 c4 10             	add    $0x10,%esp
    27bc:	85 c0                	test   %eax,%eax
    27be:	74 27                	je     27e7 <fourteen+0xd7>
  printf(1, "fourteen ok\n");
    27c0:	83 ec 08             	sub    $0x8,%esp
    27c3:	68 ea 49 00 00       	push   $0x49ea
    27c8:	6a 01                	push   $0x1
    27ca:	e8 01 13 00 00       	call   3ad0 <printf>
}
    27cf:	83 c4 10             	add    $0x10,%esp
    27d2:	c9                   	leave  
    27d3:	c3                   	ret    
    printf(1, "mkdir 12345678901234 failed\n");
    27d4:	50                   	push   %eax
    27d5:	50                   	push   %eax
    27d6:	68 af 49 00 00       	push   $0x49af
    27db:	6a 01                	push   $0x1
    27dd:	e8 ee 12 00 00       	call   3ad0 <printf>
    exit();
    27e2:	e8 7c 11 00 00       	call   3963 <exit>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    27e7:	50                   	push   %eax
    27e8:	50                   	push   %eax
    27e9:	68 14 53 00 00       	push   $0x5314
    27ee:	6a 01                	push   $0x1
    27f0:	e8 db 12 00 00       	call   3ad0 <printf>
    exit();
    27f5:	e8 69 11 00 00       	call   3963 <exit>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    27fa:	52                   	push   %edx
    27fb:	52                   	push   %edx
    27fc:	68 c4 52 00 00       	push   $0x52c4
    2801:	6a 01                	push   $0x1
    2803:	e8 c8 12 00 00       	call   3ad0 <printf>
    exit();
    2808:	e8 56 11 00 00       	call   3963 <exit>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    280d:	51                   	push   %ecx
    280e:	51                   	push   %ecx
    280f:	68 88 52 00 00       	push   $0x5288
    2814:	6a 01                	push   $0x1
    2816:	e8 b5 12 00 00       	call   3ad0 <printf>
    exit();
    281b:	e8 43 11 00 00       	call   3963 <exit>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    2820:	51                   	push   %ecx
    2821:	51                   	push   %ecx
    2822:	68 18 52 00 00       	push   $0x5218
    2827:	6a 01                	push   $0x1
    2829:	e8 a2 12 00 00       	call   3ad0 <printf>
    exit();
    282e:	e8 30 11 00 00       	call   3963 <exit>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    2833:	50                   	push   %eax
    2834:	50                   	push   %eax
    2835:	68 b8 51 00 00       	push   $0x51b8
    283a:	6a 01                	push   $0x1
    283c:	e8 8f 12 00 00       	call   3ad0 <printf>
    exit();
    2841:	e8 1d 11 00 00       	call   3963 <exit>
    2846:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    284d:	8d 76 00             	lea    0x0(%esi),%esi

00002850 <rmdot>:
{
    2850:	f3 0f 1e fb          	endbr32 
    2854:	55                   	push   %ebp
    2855:	89 e5                	mov    %esp,%ebp
    2857:	83 ec 10             	sub    $0x10,%esp
  printf(1, "rmdot test\n");
    285a:	68 f7 49 00 00       	push   $0x49f7
    285f:	6a 01                	push   $0x1
    2861:	e8 6a 12 00 00       	call   3ad0 <printf>
  if(mkdir("dots") != 0){
    2866:	c7 04 24 03 4a 00 00 	movl   $0x4a03,(%esp)
    286d:	e8 59 11 00 00       	call   39cb <mkdir>
    2872:	83 c4 10             	add    $0x10,%esp
    2875:	85 c0                	test   %eax,%eax
    2877:	0f 85 b0 00 00 00    	jne    292d <rmdot+0xdd>
  if(chdir("dots") != 0){
    287d:	83 ec 0c             	sub    $0xc,%esp
    2880:	68 03 4a 00 00       	push   $0x4a03
    2885:	e8 49 11 00 00       	call   39d3 <chdir>
    288a:	83 c4 10             	add    $0x10,%esp
    288d:	85 c0                	test   %eax,%eax
    288f:	0f 85 1d 01 00 00    	jne    29b2 <rmdot+0x162>
  if(unlink(".") == 0){
    2895:	83 ec 0c             	sub    $0xc,%esp
    2898:	68 ae 46 00 00       	push   $0x46ae
    289d:	e8 11 11 00 00       	call   39b3 <unlink>
    28a2:	83 c4 10             	add    $0x10,%esp
    28a5:	85 c0                	test   %eax,%eax
    28a7:	0f 84 f2 00 00 00    	je     299f <rmdot+0x14f>
  if(unlink("..") == 0){
    28ad:	83 ec 0c             	sub    $0xc,%esp
    28b0:	68 ad 46 00 00       	push   $0x46ad
    28b5:	e8 f9 10 00 00       	call   39b3 <unlink>
    28ba:	83 c4 10             	add    $0x10,%esp
    28bd:	85 c0                	test   %eax,%eax
    28bf:	0f 84 c7 00 00 00    	je     298c <rmdot+0x13c>
  if(chdir("/") != 0){
    28c5:	83 ec 0c             	sub    $0xc,%esp
    28c8:	68 81 3e 00 00       	push   $0x3e81
    28cd:	e8 01 11 00 00       	call   39d3 <chdir>
    28d2:	83 c4 10             	add    $0x10,%esp
    28d5:	85 c0                	test   %eax,%eax
    28d7:	0f 85 9c 00 00 00    	jne    2979 <rmdot+0x129>
  if(unlink("dots/.") == 0){
    28dd:	83 ec 0c             	sub    $0xc,%esp
    28e0:	68 4b 4a 00 00       	push   $0x4a4b
    28e5:	e8 c9 10 00 00       	call   39b3 <unlink>
    28ea:	83 c4 10             	add    $0x10,%esp
    28ed:	85 c0                	test   %eax,%eax
    28ef:	74 75                	je     2966 <rmdot+0x116>
  if(unlink("dots/..") == 0){
    28f1:	83 ec 0c             	sub    $0xc,%esp
    28f4:	68 69 4a 00 00       	push   $0x4a69
    28f9:	e8 b5 10 00 00       	call   39b3 <unlink>
    28fe:	83 c4 10             	add    $0x10,%esp
    2901:	85 c0                	test   %eax,%eax
    2903:	74 4e                	je     2953 <rmdot+0x103>
  if(unlink("dots") != 0){
    2905:	83 ec 0c             	sub    $0xc,%esp
    2908:	68 03 4a 00 00       	push   $0x4a03
    290d:	e8 a1 10 00 00       	call   39b3 <unlink>
    2912:	83 c4 10             	add    $0x10,%esp
    2915:	85 c0                	test   %eax,%eax
    2917:	75 27                	jne    2940 <rmdot+0xf0>
  printf(1, "rmdot ok\n");
    2919:	83 ec 08             	sub    $0x8,%esp
    291c:	68 9e 4a 00 00       	push   $0x4a9e
    2921:	6a 01                	push   $0x1
    2923:	e8 a8 11 00 00       	call   3ad0 <printf>
}
    2928:	83 c4 10             	add    $0x10,%esp
    292b:	c9                   	leave  
    292c:	c3                   	ret    
    printf(1, "mkdir dots failed\n");
    292d:	50                   	push   %eax
    292e:	50                   	push   %eax
    292f:	68 08 4a 00 00       	push   $0x4a08
    2934:	6a 01                	push   $0x1
    2936:	e8 95 11 00 00       	call   3ad0 <printf>
    exit();
    293b:	e8 23 10 00 00       	call   3963 <exit>
    printf(1, "unlink dots failed!\n");
    2940:	50                   	push   %eax
    2941:	50                   	push   %eax
    2942:	68 89 4a 00 00       	push   $0x4a89
    2947:	6a 01                	push   $0x1
    2949:	e8 82 11 00 00       	call   3ad0 <printf>
    exit();
    294e:	e8 10 10 00 00       	call   3963 <exit>
    printf(1, "unlink dots/.. worked!\n");
    2953:	52                   	push   %edx
    2954:	52                   	push   %edx
    2955:	68 71 4a 00 00       	push   $0x4a71
    295a:	6a 01                	push   $0x1
    295c:	e8 6f 11 00 00       	call   3ad0 <printf>
    exit();
    2961:	e8 fd 0f 00 00       	call   3963 <exit>
    printf(1, "unlink dots/. worked!\n");
    2966:	51                   	push   %ecx
    2967:	51                   	push   %ecx
    2968:	68 52 4a 00 00       	push   $0x4a52
    296d:	6a 01                	push   $0x1
    296f:	e8 5c 11 00 00       	call   3ad0 <printf>
    exit();
    2974:	e8 ea 0f 00 00       	call   3963 <exit>
    printf(1, "chdir / failed\n");
    2979:	50                   	push   %eax
    297a:	50                   	push   %eax
    297b:	68 83 3e 00 00       	push   $0x3e83
    2980:	6a 01                	push   $0x1
    2982:	e8 49 11 00 00       	call   3ad0 <printf>
    exit();
    2987:	e8 d7 0f 00 00       	call   3963 <exit>
    printf(1, "rm .. worked!\n");
    298c:	50                   	push   %eax
    298d:	50                   	push   %eax
    298e:	68 3c 4a 00 00       	push   $0x4a3c
    2993:	6a 01                	push   $0x1
    2995:	e8 36 11 00 00       	call   3ad0 <printf>
    exit();
    299a:	e8 c4 0f 00 00       	call   3963 <exit>
    printf(1, "rm . worked!\n");
    299f:	50                   	push   %eax
    29a0:	50                   	push   %eax
    29a1:	68 2e 4a 00 00       	push   $0x4a2e
    29a6:	6a 01                	push   $0x1
    29a8:	e8 23 11 00 00       	call   3ad0 <printf>
    exit();
    29ad:	e8 b1 0f 00 00       	call   3963 <exit>
    printf(1, "chdir dots failed\n");
    29b2:	50                   	push   %eax
    29b3:	50                   	push   %eax
    29b4:	68 1b 4a 00 00       	push   $0x4a1b
    29b9:	6a 01                	push   $0x1
    29bb:	e8 10 11 00 00       	call   3ad0 <printf>
    exit();
    29c0:	e8 9e 0f 00 00       	call   3963 <exit>
    29c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    29cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000029d0 <dirfile>:
{
    29d0:	f3 0f 1e fb          	endbr32 
    29d4:	55                   	push   %ebp
    29d5:	89 e5                	mov    %esp,%ebp
    29d7:	53                   	push   %ebx
    29d8:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "dir vs file\n");
    29db:	68 a8 4a 00 00       	push   $0x4aa8
    29e0:	6a 01                	push   $0x1
    29e2:	e8 e9 10 00 00       	call   3ad0 <printf>
  fd = open("dirfile", O_CREATE);
    29e7:	5b                   	pop    %ebx
    29e8:	58                   	pop    %eax
    29e9:	68 00 02 00 00       	push   $0x200
    29ee:	68 b5 4a 00 00       	push   $0x4ab5
    29f3:	e8 ab 0f 00 00       	call   39a3 <open>
  if(fd < 0){
    29f8:	83 c4 10             	add    $0x10,%esp
    29fb:	85 c0                	test   %eax,%eax
    29fd:	0f 88 43 01 00 00    	js     2b46 <dirfile+0x176>
  close(fd);
    2a03:	83 ec 0c             	sub    $0xc,%esp
    2a06:	50                   	push   %eax
    2a07:	e8 7f 0f 00 00       	call   398b <close>
  if(chdir("dirfile") == 0){
    2a0c:	c7 04 24 b5 4a 00 00 	movl   $0x4ab5,(%esp)
    2a13:	e8 bb 0f 00 00       	call   39d3 <chdir>
    2a18:	83 c4 10             	add    $0x10,%esp
    2a1b:	85 c0                	test   %eax,%eax
    2a1d:	0f 84 10 01 00 00    	je     2b33 <dirfile+0x163>
  fd = open("dirfile/xx", 0);
    2a23:	83 ec 08             	sub    $0x8,%esp
    2a26:	6a 00                	push   $0x0
    2a28:	68 ee 4a 00 00       	push   $0x4aee
    2a2d:	e8 71 0f 00 00       	call   39a3 <open>
  if(fd >= 0){
    2a32:	83 c4 10             	add    $0x10,%esp
    2a35:	85 c0                	test   %eax,%eax
    2a37:	0f 89 e3 00 00 00    	jns    2b20 <dirfile+0x150>
  fd = open("dirfile/xx", O_CREATE);
    2a3d:	83 ec 08             	sub    $0x8,%esp
    2a40:	68 00 02 00 00       	push   $0x200
    2a45:	68 ee 4a 00 00       	push   $0x4aee
    2a4a:	e8 54 0f 00 00       	call   39a3 <open>
  if(fd >= 0){
    2a4f:	83 c4 10             	add    $0x10,%esp
    2a52:	85 c0                	test   %eax,%eax
    2a54:	0f 89 c6 00 00 00    	jns    2b20 <dirfile+0x150>
  if(mkdir("dirfile/xx") == 0){
    2a5a:	83 ec 0c             	sub    $0xc,%esp
    2a5d:	68 ee 4a 00 00       	push   $0x4aee
    2a62:	e8 64 0f 00 00       	call   39cb <mkdir>
    2a67:	83 c4 10             	add    $0x10,%esp
    2a6a:	85 c0                	test   %eax,%eax
    2a6c:	0f 84 46 01 00 00    	je     2bb8 <dirfile+0x1e8>
  if(unlink("dirfile/xx") == 0){
    2a72:	83 ec 0c             	sub    $0xc,%esp
    2a75:	68 ee 4a 00 00       	push   $0x4aee
    2a7a:	e8 34 0f 00 00       	call   39b3 <unlink>
    2a7f:	83 c4 10             	add    $0x10,%esp
    2a82:	85 c0                	test   %eax,%eax
    2a84:	0f 84 1b 01 00 00    	je     2ba5 <dirfile+0x1d5>
  if(link("README", "dirfile/xx") == 0){
    2a8a:	83 ec 08             	sub    $0x8,%esp
    2a8d:	68 ee 4a 00 00       	push   $0x4aee
    2a92:	68 52 4b 00 00       	push   $0x4b52
    2a97:	e8 27 0f 00 00       	call   39c3 <link>
    2a9c:	83 c4 10             	add    $0x10,%esp
    2a9f:	85 c0                	test   %eax,%eax
    2aa1:	0f 84 eb 00 00 00    	je     2b92 <dirfile+0x1c2>
  if(unlink("dirfile") != 0){
    2aa7:	83 ec 0c             	sub    $0xc,%esp
    2aaa:	68 b5 4a 00 00       	push   $0x4ab5
    2aaf:	e8 ff 0e 00 00       	call   39b3 <unlink>
    2ab4:	83 c4 10             	add    $0x10,%esp
    2ab7:	85 c0                	test   %eax,%eax
    2ab9:	0f 85 c0 00 00 00    	jne    2b7f <dirfile+0x1af>
  fd = open(".", O_RDWR);
    2abf:	83 ec 08             	sub    $0x8,%esp
    2ac2:	6a 02                	push   $0x2
    2ac4:	68 ae 46 00 00       	push   $0x46ae
    2ac9:	e8 d5 0e 00 00       	call   39a3 <open>
  if(fd >= 0){
    2ace:	83 c4 10             	add    $0x10,%esp
    2ad1:	85 c0                	test   %eax,%eax
    2ad3:	0f 89 93 00 00 00    	jns    2b6c <dirfile+0x19c>
  fd = open(".", 0);
    2ad9:	83 ec 08             	sub    $0x8,%esp
    2adc:	6a 00                	push   $0x0
    2ade:	68 ae 46 00 00       	push   $0x46ae
    2ae3:	e8 bb 0e 00 00       	call   39a3 <open>
  if(write(fd, "x", 1) > 0){
    2ae8:	83 c4 0c             	add    $0xc,%esp
    2aeb:	6a 01                	push   $0x1
  fd = open(".", 0);
    2aed:	89 c3                	mov    %eax,%ebx
  if(write(fd, "x", 1) > 0){
    2aef:	68 91 47 00 00       	push   $0x4791
    2af4:	50                   	push   %eax
    2af5:	e8 89 0e 00 00       	call   3983 <write>
    2afa:	83 c4 10             	add    $0x10,%esp
    2afd:	85 c0                	test   %eax,%eax
    2aff:	7f 58                	jg     2b59 <dirfile+0x189>
  close(fd);
    2b01:	83 ec 0c             	sub    $0xc,%esp
    2b04:	53                   	push   %ebx
    2b05:	e8 81 0e 00 00       	call   398b <close>
  printf(1, "dir vs file OK\n");
    2b0a:	58                   	pop    %eax
    2b0b:	5a                   	pop    %edx
    2b0c:	68 85 4b 00 00       	push   $0x4b85
    2b11:	6a 01                	push   $0x1
    2b13:	e8 b8 0f 00 00       	call   3ad0 <printf>
}
    2b18:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    2b1b:	83 c4 10             	add    $0x10,%esp
    2b1e:	c9                   	leave  
    2b1f:	c3                   	ret    
    printf(1, "create dirfile/xx succeeded!\n");
    2b20:	50                   	push   %eax
    2b21:	50                   	push   %eax
    2b22:	68 f9 4a 00 00       	push   $0x4af9
    2b27:	6a 01                	push   $0x1
    2b29:	e8 a2 0f 00 00       	call   3ad0 <printf>
    exit();
    2b2e:	e8 30 0e 00 00       	call   3963 <exit>
    printf(1, "chdir dirfile succeeded!\n");
    2b33:	52                   	push   %edx
    2b34:	52                   	push   %edx
    2b35:	68 d4 4a 00 00       	push   $0x4ad4
    2b3a:	6a 01                	push   $0x1
    2b3c:	e8 8f 0f 00 00       	call   3ad0 <printf>
    exit();
    2b41:	e8 1d 0e 00 00       	call   3963 <exit>
    printf(1, "create dirfile failed\n");
    2b46:	51                   	push   %ecx
    2b47:	51                   	push   %ecx
    2b48:	68 bd 4a 00 00       	push   $0x4abd
    2b4d:	6a 01                	push   $0x1
    2b4f:	e8 7c 0f 00 00       	call   3ad0 <printf>
    exit();
    2b54:	e8 0a 0e 00 00       	call   3963 <exit>
    printf(1, "write . succeeded!\n");
    2b59:	51                   	push   %ecx
    2b5a:	51                   	push   %ecx
    2b5b:	68 71 4b 00 00       	push   $0x4b71
    2b60:	6a 01                	push   $0x1
    2b62:	e8 69 0f 00 00       	call   3ad0 <printf>
    exit();
    2b67:	e8 f7 0d 00 00       	call   3963 <exit>
    printf(1, "open . for writing succeeded!\n");
    2b6c:	53                   	push   %ebx
    2b6d:	53                   	push   %ebx
    2b6e:	68 68 53 00 00       	push   $0x5368
    2b73:	6a 01                	push   $0x1
    2b75:	e8 56 0f 00 00       	call   3ad0 <printf>
    exit();
    2b7a:	e8 e4 0d 00 00       	call   3963 <exit>
    printf(1, "unlink dirfile failed!\n");
    2b7f:	50                   	push   %eax
    2b80:	50                   	push   %eax
    2b81:	68 59 4b 00 00       	push   $0x4b59
    2b86:	6a 01                	push   $0x1
    2b88:	e8 43 0f 00 00       	call   3ad0 <printf>
    exit();
    2b8d:	e8 d1 0d 00 00       	call   3963 <exit>
    printf(1, "link to dirfile/xx succeeded!\n");
    2b92:	50                   	push   %eax
    2b93:	50                   	push   %eax
    2b94:	68 48 53 00 00       	push   $0x5348
    2b99:	6a 01                	push   $0x1
    2b9b:	e8 30 0f 00 00       	call   3ad0 <printf>
    exit();
    2ba0:	e8 be 0d 00 00       	call   3963 <exit>
    printf(1, "unlink dirfile/xx succeeded!\n");
    2ba5:	50                   	push   %eax
    2ba6:	50                   	push   %eax
    2ba7:	68 34 4b 00 00       	push   $0x4b34
    2bac:	6a 01                	push   $0x1
    2bae:	e8 1d 0f 00 00       	call   3ad0 <printf>
    exit();
    2bb3:	e8 ab 0d 00 00       	call   3963 <exit>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    2bb8:	50                   	push   %eax
    2bb9:	50                   	push   %eax
    2bba:	68 17 4b 00 00       	push   $0x4b17
    2bbf:	6a 01                	push   $0x1
    2bc1:	e8 0a 0f 00 00       	call   3ad0 <printf>
    exit();
    2bc6:	e8 98 0d 00 00       	call   3963 <exit>
    2bcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    2bcf:	90                   	nop

00002bd0 <iref>:
{
    2bd0:	f3 0f 1e fb          	endbr32 
    2bd4:	55                   	push   %ebp
    2bd5:	89 e5                	mov    %esp,%ebp
    2bd7:	53                   	push   %ebx
  printf(1, "empty file name\n");
    2bd8:	bb 33 00 00 00       	mov    $0x33,%ebx
{
    2bdd:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "empty file name\n");
    2be0:	68 95 4b 00 00       	push   $0x4b95
    2be5:	6a 01                	push   $0x1
    2be7:	e8 e4 0e 00 00       	call   3ad0 <printf>
    2bec:	83 c4 10             	add    $0x10,%esp
    2bef:	90                   	nop
    if(mkdir("irefd") != 0){
    2bf0:	83 ec 0c             	sub    $0xc,%esp
    2bf3:	68 a6 4b 00 00       	push   $0x4ba6
    2bf8:	e8 ce 0d 00 00       	call   39cb <mkdir>
    2bfd:	83 c4 10             	add    $0x10,%esp
    2c00:	85 c0                	test   %eax,%eax
    2c02:	0f 85 bb 00 00 00    	jne    2cc3 <iref+0xf3>
    if(chdir("irefd") != 0){
    2c08:	83 ec 0c             	sub    $0xc,%esp
    2c0b:	68 a6 4b 00 00       	push   $0x4ba6
    2c10:	e8 be 0d 00 00       	call   39d3 <chdir>
    2c15:	83 c4 10             	add    $0x10,%esp
    2c18:	85 c0                	test   %eax,%eax
    2c1a:	0f 85 b7 00 00 00    	jne    2cd7 <iref+0x107>
    mkdir("");
    2c20:	83 ec 0c             	sub    $0xc,%esp
    2c23:	68 3c 4e 00 00       	push   $0x4e3c
    2c28:	e8 9e 0d 00 00       	call   39cb <mkdir>
    link("README", "");
    2c2d:	59                   	pop    %ecx
    2c2e:	58                   	pop    %eax
    2c2f:	68 3c 4e 00 00       	push   $0x4e3c
    2c34:	68 52 4b 00 00       	push   $0x4b52
    2c39:	e8 85 0d 00 00       	call   39c3 <link>
    fd = open("", O_CREATE);
    2c3e:	58                   	pop    %eax
    2c3f:	5a                   	pop    %edx
    2c40:	68 00 02 00 00       	push   $0x200
    2c45:	68 3c 4e 00 00       	push   $0x4e3c
    2c4a:	e8 54 0d 00 00       	call   39a3 <open>
    if(fd >= 0)
    2c4f:	83 c4 10             	add    $0x10,%esp
    2c52:	85 c0                	test   %eax,%eax
    2c54:	78 0c                	js     2c62 <iref+0x92>
      close(fd);
    2c56:	83 ec 0c             	sub    $0xc,%esp
    2c59:	50                   	push   %eax
    2c5a:	e8 2c 0d 00 00       	call   398b <close>
    2c5f:	83 c4 10             	add    $0x10,%esp
    fd = open("xx", O_CREATE);
    2c62:	83 ec 08             	sub    $0x8,%esp
    2c65:	68 00 02 00 00       	push   $0x200
    2c6a:	68 90 47 00 00       	push   $0x4790
    2c6f:	e8 2f 0d 00 00       	call   39a3 <open>
    if(fd >= 0)
    2c74:	83 c4 10             	add    $0x10,%esp
    2c77:	85 c0                	test   %eax,%eax
    2c79:	78 0c                	js     2c87 <iref+0xb7>
      close(fd);
    2c7b:	83 ec 0c             	sub    $0xc,%esp
    2c7e:	50                   	push   %eax
    2c7f:	e8 07 0d 00 00       	call   398b <close>
    2c84:	83 c4 10             	add    $0x10,%esp
    unlink("xx");
    2c87:	83 ec 0c             	sub    $0xc,%esp
    2c8a:	68 90 47 00 00       	push   $0x4790
    2c8f:	e8 1f 0d 00 00       	call   39b3 <unlink>
  for(i = 0; i < 50 + 1; i++){
    2c94:	83 c4 10             	add    $0x10,%esp
    2c97:	83 eb 01             	sub    $0x1,%ebx
    2c9a:	0f 85 50 ff ff ff    	jne    2bf0 <iref+0x20>
  chdir("/");
    2ca0:	83 ec 0c             	sub    $0xc,%esp
    2ca3:	68 81 3e 00 00       	push   $0x3e81
    2ca8:	e8 26 0d 00 00       	call   39d3 <chdir>
  printf(1, "empty file name OK\n");
    2cad:	58                   	pop    %eax
    2cae:	5a                   	pop    %edx
    2caf:	68 d4 4b 00 00       	push   $0x4bd4
    2cb4:	6a 01                	push   $0x1
    2cb6:	e8 15 0e 00 00       	call   3ad0 <printf>
}
    2cbb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    2cbe:	83 c4 10             	add    $0x10,%esp
    2cc1:	c9                   	leave  
    2cc2:	c3                   	ret    
      printf(1, "mkdir irefd failed\n");
    2cc3:	83 ec 08             	sub    $0x8,%esp
    2cc6:	68 ac 4b 00 00       	push   $0x4bac
    2ccb:	6a 01                	push   $0x1
    2ccd:	e8 fe 0d 00 00       	call   3ad0 <printf>
      exit();
    2cd2:	e8 8c 0c 00 00       	call   3963 <exit>
      printf(1, "chdir irefd failed\n");
    2cd7:	83 ec 08             	sub    $0x8,%esp
    2cda:	68 c0 4b 00 00       	push   $0x4bc0
    2cdf:	6a 01                	push   $0x1
    2ce1:	e8 ea 0d 00 00       	call   3ad0 <printf>
      exit();
    2ce6:	e8 78 0c 00 00       	call   3963 <exit>
    2ceb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    2cef:	90                   	nop

00002cf0 <forktest>:
{
    2cf0:	f3 0f 1e fb          	endbr32 
    2cf4:	55                   	push   %ebp
    2cf5:	89 e5                	mov    %esp,%ebp
    2cf7:	53                   	push   %ebx
  for(n=0; n<1000; n++){
    2cf8:	31 db                	xor    %ebx,%ebx
{
    2cfa:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "fork test\n");
    2cfd:	68 e8 4b 00 00       	push   $0x4be8
    2d02:	6a 01                	push   $0x1
    2d04:	e8 c7 0d 00 00       	call   3ad0 <printf>
    2d09:	83 c4 10             	add    $0x10,%esp
    2d0c:	eb 0f                	jmp    2d1d <forktest+0x2d>
    2d0e:	66 90                	xchg   %ax,%ax
    if(pid == 0)
    2d10:	74 4a                	je     2d5c <forktest+0x6c>
  for(n=0; n<1000; n++){
    2d12:	83 c3 01             	add    $0x1,%ebx
    2d15:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
    2d1b:	74 6b                	je     2d88 <forktest+0x98>
    pid = fork();
    2d1d:	e8 39 0c 00 00       	call   395b <fork>
    if(pid < 0)
    2d22:	85 c0                	test   %eax,%eax
    2d24:	79 ea                	jns    2d10 <forktest+0x20>
  for(; n > 0; n--){
    2d26:	85 db                	test   %ebx,%ebx
    2d28:	74 14                	je     2d3e <forktest+0x4e>
    2d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(wait() < 0){
    2d30:	e8 36 0c 00 00       	call   396b <wait>
    2d35:	85 c0                	test   %eax,%eax
    2d37:	78 28                	js     2d61 <forktest+0x71>
  for(; n > 0; n--){
    2d39:	83 eb 01             	sub    $0x1,%ebx
    2d3c:	75 f2                	jne    2d30 <forktest+0x40>
  if(wait() != -1){
    2d3e:	e8 28 0c 00 00       	call   396b <wait>
    2d43:	83 f8 ff             	cmp    $0xffffffff,%eax
    2d46:	75 2d                	jne    2d75 <forktest+0x85>
  printf(1, "fork test OK\n");
    2d48:	83 ec 08             	sub    $0x8,%esp
    2d4b:	68 1a 4c 00 00       	push   $0x4c1a
    2d50:	6a 01                	push   $0x1
    2d52:	e8 79 0d 00 00       	call   3ad0 <printf>
}
    2d57:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    2d5a:	c9                   	leave  
    2d5b:	c3                   	ret    
      exit();
    2d5c:	e8 02 0c 00 00       	call   3963 <exit>
      printf(1, "wait stopped early\n");
    2d61:	83 ec 08             	sub    $0x8,%esp
    2d64:	68 f3 4b 00 00       	push   $0x4bf3
    2d69:	6a 01                	push   $0x1
    2d6b:	e8 60 0d 00 00       	call   3ad0 <printf>
      exit();
    2d70:	e8 ee 0b 00 00       	call   3963 <exit>
    printf(1, "wait got too many\n");
    2d75:	52                   	push   %edx
    2d76:	52                   	push   %edx
    2d77:	68 07 4c 00 00       	push   $0x4c07
    2d7c:	6a 01                	push   $0x1
    2d7e:	e8 4d 0d 00 00       	call   3ad0 <printf>
    exit();
    2d83:	e8 db 0b 00 00       	call   3963 <exit>
    printf(1, "fork claimed to work 1000 times!\n");
    2d88:	50                   	push   %eax
    2d89:	50                   	push   %eax
    2d8a:	68 88 53 00 00       	push   $0x5388
    2d8f:	6a 01                	push   $0x1
    2d91:	e8 3a 0d 00 00       	call   3ad0 <printf>
    exit();
    2d96:	e8 c8 0b 00 00       	call   3963 <exit>
    2d9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    2d9f:	90                   	nop

00002da0 <sbrktest>:
{
    2da0:	f3 0f 1e fb          	endbr32 
    2da4:	55                   	push   %ebp
    2da5:	89 e5                	mov    %esp,%ebp
    2da7:	57                   	push   %edi
  for(i = 0; i < 5000; i++){
    2da8:	31 ff                	xor    %edi,%edi
{
    2daa:	56                   	push   %esi
    2dab:	53                   	push   %ebx
    2dac:	83 ec 54             	sub    $0x54,%esp
  printf(stdout, "sbrk test\n");
    2daf:	68 28 4c 00 00       	push   $0x4c28
    2db4:	ff 35 a0 5e 00 00    	pushl  0x5ea0
    2dba:	e8 11 0d 00 00       	call   3ad0 <printf>
  oldbrk = sbrk(0);
    2dbf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2dc6:	e8 20 0c 00 00       	call   39eb <sbrk>
  a = sbrk(0);
    2dcb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  oldbrk = sbrk(0);
    2dd2:	89 c3                	mov    %eax,%ebx
  a = sbrk(0);
    2dd4:	e8 12 0c 00 00       	call   39eb <sbrk>
    2dd9:	83 c4 10             	add    $0x10,%esp
    2ddc:	89 c6                	mov    %eax,%esi
  for(i = 0; i < 5000; i++){
    2dde:	eb 02                	jmp    2de2 <sbrktest+0x42>
    a = b + 1;
    2de0:	89 c6                	mov    %eax,%esi
    b = sbrk(1);
    2de2:	83 ec 0c             	sub    $0xc,%esp
    2de5:	6a 01                	push   $0x1
    2de7:	e8 ff 0b 00 00       	call   39eb <sbrk>
    if(b != a){
    2dec:	83 c4 10             	add    $0x10,%esp
    2def:	39 f0                	cmp    %esi,%eax
    2df1:	0f 85 8c 02 00 00    	jne    3083 <sbrktest+0x2e3>
  for(i = 0; i < 5000; i++){
    2df7:	83 c7 01             	add    $0x1,%edi
    *b = 1;
    2dfa:	c6 06 01             	movb   $0x1,(%esi)
    a = b + 1;
    2dfd:	8d 46 01             	lea    0x1(%esi),%eax
  for(i = 0; i < 5000; i++){
    2e00:	81 ff 88 13 00 00    	cmp    $0x1388,%edi
    2e06:	75 d8                	jne    2de0 <sbrktest+0x40>
  pid = fork();
    2e08:	e8 4e 0b 00 00       	call   395b <fork>
    2e0d:	89 c7                	mov    %eax,%edi
  if(pid < 0){
    2e0f:	85 c0                	test   %eax,%eax
    2e11:	0f 88 9b 03 00 00    	js     31b2 <sbrktest+0x412>
  c = sbrk(1);
    2e17:	83 ec 0c             	sub    $0xc,%esp
  if(c != a + 1){
    2e1a:	83 c6 02             	add    $0x2,%esi
  c = sbrk(1);
    2e1d:	6a 01                	push   $0x1
    2e1f:	e8 c7 0b 00 00       	call   39eb <sbrk>
  c = sbrk(1);
    2e24:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2e2b:	e8 bb 0b 00 00       	call   39eb <sbrk>
  if(c != a + 1){
    2e30:	83 c4 10             	add    $0x10,%esp
    2e33:	39 c6                	cmp    %eax,%esi
    2e35:	0f 85 60 03 00 00    	jne    319b <sbrktest+0x3fb>
  if(pid == 0)
    2e3b:	85 ff                	test   %edi,%edi
    2e3d:	0f 84 53 03 00 00    	je     3196 <sbrktest+0x3f6>
  wait();
    2e43:	e8 23 0b 00 00       	call   396b <wait>
  a = sbrk(0);
    2e48:	83 ec 0c             	sub    $0xc,%esp
    2e4b:	6a 00                	push   $0x0
    2e4d:	e8 99 0b 00 00       	call   39eb <sbrk>
    2e52:	89 c6                	mov    %eax,%esi
  amt = (BIG) - (uint)a;
    2e54:	b8 00 00 40 06       	mov    $0x6400000,%eax
    2e59:	29 f0                	sub    %esi,%eax
  p = sbrk(amt);
    2e5b:	89 04 24             	mov    %eax,(%esp)
    2e5e:	e8 88 0b 00 00       	call   39eb <sbrk>
  if (p != a) {
    2e63:	83 c4 10             	add    $0x10,%esp
    2e66:	39 c6                	cmp    %eax,%esi
    2e68:	0f 85 11 03 00 00    	jne    317f <sbrktest+0x3df>
  a = sbrk(0);
    2e6e:	83 ec 0c             	sub    $0xc,%esp
  *lastaddr = 99;
    2e71:	c6 05 ff ff 3f 06 63 	movb   $0x63,0x63fffff
  a = sbrk(0);
    2e78:	6a 00                	push   $0x0
    2e7a:	e8 6c 0b 00 00       	call   39eb <sbrk>
  c = sbrk(-4096);
    2e7f:	c7 04 24 00 f0 ff ff 	movl   $0xfffff000,(%esp)
  a = sbrk(0);
    2e86:	89 c6                	mov    %eax,%esi
  c = sbrk(-4096);
    2e88:	e8 5e 0b 00 00       	call   39eb <sbrk>
  if(c == (char*)0xffffffff){
    2e8d:	83 c4 10             	add    $0x10,%esp
    2e90:	83 f8 ff             	cmp    $0xffffffff,%eax
    2e93:	0f 84 cf 02 00 00    	je     3168 <sbrktest+0x3c8>
  c = sbrk(0);
    2e99:	83 ec 0c             	sub    $0xc,%esp
    2e9c:	6a 00                	push   $0x0
    2e9e:	e8 48 0b 00 00       	call   39eb <sbrk>
  if(c != a - 4096){
    2ea3:	8d 96 00 f0 ff ff    	lea    -0x1000(%esi),%edx
    2ea9:	83 c4 10             	add    $0x10,%esp
    2eac:	39 d0                	cmp    %edx,%eax
    2eae:	0f 85 9d 02 00 00    	jne    3151 <sbrktest+0x3b1>
  a = sbrk(0);
    2eb4:	83 ec 0c             	sub    $0xc,%esp
    2eb7:	6a 00                	push   $0x0
    2eb9:	e8 2d 0b 00 00       	call   39eb <sbrk>
  c = sbrk(4096);
    2ebe:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  a = sbrk(0);
    2ec5:	89 c6                	mov    %eax,%esi
  c = sbrk(4096);
    2ec7:	e8 1f 0b 00 00       	call   39eb <sbrk>
  if(c != a || sbrk(0) != a + 4096){
    2ecc:	83 c4 10             	add    $0x10,%esp
  c = sbrk(4096);
    2ecf:	89 c7                	mov    %eax,%edi
  if(c != a || sbrk(0) != a + 4096){
    2ed1:	39 c6                	cmp    %eax,%esi
    2ed3:	0f 85 61 02 00 00    	jne    313a <sbrktest+0x39a>
    2ed9:	83 ec 0c             	sub    $0xc,%esp
    2edc:	6a 00                	push   $0x0
    2ede:	e8 08 0b 00 00       	call   39eb <sbrk>
    2ee3:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    2ee9:	83 c4 10             	add    $0x10,%esp
    2eec:	39 c2                	cmp    %eax,%edx
    2eee:	0f 85 46 02 00 00    	jne    313a <sbrktest+0x39a>
  if(*lastaddr == 99){
    2ef4:	80 3d ff ff 3f 06 63 	cmpb   $0x63,0x63fffff
    2efb:	0f 84 22 02 00 00    	je     3123 <sbrktest+0x383>
  a = sbrk(0);
    2f01:	83 ec 0c             	sub    $0xc,%esp
    2f04:	6a 00                	push   $0x0
    2f06:	e8 e0 0a 00 00       	call   39eb <sbrk>
  c = sbrk(-(sbrk(0) - oldbrk));
    2f0b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  a = sbrk(0);
    2f12:	89 c6                	mov    %eax,%esi
  c = sbrk(-(sbrk(0) - oldbrk));
    2f14:	e8 d2 0a 00 00       	call   39eb <sbrk>
    2f19:	89 d9                	mov    %ebx,%ecx
    2f1b:	29 c1                	sub    %eax,%ecx
    2f1d:	89 0c 24             	mov    %ecx,(%esp)
    2f20:	e8 c6 0a 00 00       	call   39eb <sbrk>
  if(c != a){
    2f25:	83 c4 10             	add    $0x10,%esp
    2f28:	39 c6                	cmp    %eax,%esi
    2f2a:	0f 85 dc 01 00 00    	jne    310c <sbrktest+0x36c>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2f30:	be 00 00 00 80       	mov    $0x80000000,%esi
    2f35:	8d 76 00             	lea    0x0(%esi),%esi
    ppid = getpid();
    2f38:	e8 a6 0a 00 00       	call   39e3 <getpid>
    2f3d:	89 c7                	mov    %eax,%edi
    pid = fork();
    2f3f:	e8 17 0a 00 00       	call   395b <fork>
    if(pid < 0){
    2f44:	85 c0                	test   %eax,%eax
    2f46:	0f 88 a8 01 00 00    	js     30f4 <sbrktest+0x354>
    if(pid == 0){
    2f4c:	0f 84 7e 01 00 00    	je     30d0 <sbrktest+0x330>
    wait();
    2f52:	e8 14 0a 00 00       	call   396b <wait>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2f57:	81 c6 50 c3 00 00    	add    $0xc350,%esi
    2f5d:	81 fe 80 84 1e 80    	cmp    $0x801e8480,%esi
    2f63:	75 d3                	jne    2f38 <sbrktest+0x198>
  if(pipe(fds) != 0){
    2f65:	83 ec 0c             	sub    $0xc,%esp
    2f68:	8d 45 b8             	lea    -0x48(%ebp),%eax
    2f6b:	50                   	push   %eax
    2f6c:	e8 02 0a 00 00       	call   3973 <pipe>
    2f71:	83 c4 10             	add    $0x10,%esp
    2f74:	85 c0                	test   %eax,%eax
    2f76:	0f 85 3c 01 00 00    	jne    30b8 <sbrktest+0x318>
    2f7c:	8d 75 c0             	lea    -0x40(%ebp),%esi
    2f7f:	89 f7                	mov    %esi,%edi
    if((pids[i] = fork()) == 0){
    2f81:	e8 d5 09 00 00       	call   395b <fork>
    2f86:	89 07                	mov    %eax,(%edi)
    2f88:	85 c0                	test   %eax,%eax
    2f8a:	0f 84 91 00 00 00    	je     3021 <sbrktest+0x281>
    if(pids[i] != -1)
    2f90:	83 f8 ff             	cmp    $0xffffffff,%eax
    2f93:	74 14                	je     2fa9 <sbrktest+0x209>
      read(fds[0], &scratch, 1);
    2f95:	83 ec 04             	sub    $0x4,%esp
    2f98:	8d 45 b7             	lea    -0x49(%ebp),%eax
    2f9b:	6a 01                	push   $0x1
    2f9d:	50                   	push   %eax
    2f9e:	ff 75 b8             	pushl  -0x48(%ebp)
    2fa1:	e8 d5 09 00 00       	call   397b <read>
    2fa6:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    2fa9:	83 c7 04             	add    $0x4,%edi
    2fac:	8d 45 e8             	lea    -0x18(%ebp),%eax
    2faf:	39 c7                	cmp    %eax,%edi
    2fb1:	75 ce                	jne    2f81 <sbrktest+0x1e1>
  c = sbrk(4096);
    2fb3:	83 ec 0c             	sub    $0xc,%esp
    2fb6:	68 00 10 00 00       	push   $0x1000
    2fbb:	e8 2b 0a 00 00       	call   39eb <sbrk>
    2fc0:	83 c4 10             	add    $0x10,%esp
    2fc3:	89 c7                	mov    %eax,%edi
    if(pids[i] == -1)
    2fc5:	8b 06                	mov    (%esi),%eax
    2fc7:	83 f8 ff             	cmp    $0xffffffff,%eax
    2fca:	74 13                	je     2fdf <sbrktest+0x23f>
    kill(pids[i], SIGKILL);
    2fcc:	83 ec 08             	sub    $0x8,%esp
    2fcf:	6a 09                	push   $0x9
    2fd1:	50                   	push   %eax
    2fd2:	e8 bc 09 00 00       	call   3993 <kill>
    wait();
    2fd7:	e8 8f 09 00 00       	call   396b <wait>
    2fdc:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    2fdf:	83 c6 04             	add    $0x4,%esi
    2fe2:	8d 45 e8             	lea    -0x18(%ebp),%eax
    2fe5:	39 f0                	cmp    %esi,%eax
    2fe7:	75 dc                	jne    2fc5 <sbrktest+0x225>
  if(c == (char*)0xffffffff){
    2fe9:	83 ff ff             	cmp    $0xffffffff,%edi
    2fec:	0f 84 af 00 00 00    	je     30a1 <sbrktest+0x301>
  if(sbrk(0) > oldbrk)
    2ff2:	83 ec 0c             	sub    $0xc,%esp
    2ff5:	6a 00                	push   $0x0
    2ff7:	e8 ef 09 00 00       	call   39eb <sbrk>
    2ffc:	83 c4 10             	add    $0x10,%esp
    2fff:	39 c3                	cmp    %eax,%ebx
    3001:	72 67                	jb     306a <sbrktest+0x2ca>
  printf(stdout, "sbrk test OK\n");
    3003:	83 ec 08             	sub    $0x8,%esp
    3006:	68 d0 4c 00 00       	push   $0x4cd0
    300b:	ff 35 a0 5e 00 00    	pushl  0x5ea0
    3011:	e8 ba 0a 00 00       	call   3ad0 <printf>
}
    3016:	83 c4 10             	add    $0x10,%esp
    3019:	8d 65 f4             	lea    -0xc(%ebp),%esp
    301c:	5b                   	pop    %ebx
    301d:	5e                   	pop    %esi
    301e:	5f                   	pop    %edi
    301f:	5d                   	pop    %ebp
    3020:	c3                   	ret    
      sbrk(BIG - (uint)sbrk(0));
    3021:	83 ec 0c             	sub    $0xc,%esp
    3024:	6a 00                	push   $0x0
    3026:	e8 c0 09 00 00       	call   39eb <sbrk>
    302b:	89 c2                	mov    %eax,%edx
    302d:	b8 00 00 40 06       	mov    $0x6400000,%eax
    3032:	29 d0                	sub    %edx,%eax
    3034:	89 04 24             	mov    %eax,(%esp)
    3037:	e8 af 09 00 00       	call   39eb <sbrk>
      write(fds[1], "x", 1);
    303c:	83 c4 0c             	add    $0xc,%esp
    303f:	6a 01                	push   $0x1
    3041:	68 91 47 00 00       	push   $0x4791
    3046:	ff 75 bc             	pushl  -0x44(%ebp)
    3049:	e8 35 09 00 00       	call   3983 <write>
    304e:	83 c4 10             	add    $0x10,%esp
    3051:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      for(;;) sleep(1000);
    3058:	83 ec 0c             	sub    $0xc,%esp
    305b:	68 e8 03 00 00       	push   $0x3e8
    3060:	e8 8e 09 00 00       	call   39f3 <sleep>
    3065:	83 c4 10             	add    $0x10,%esp
    3068:	eb ee                	jmp    3058 <sbrktest+0x2b8>
    sbrk(-(sbrk(0) - oldbrk));
    306a:	83 ec 0c             	sub    $0xc,%esp
    306d:	6a 00                	push   $0x0
    306f:	e8 77 09 00 00       	call   39eb <sbrk>
    3074:	29 c3                	sub    %eax,%ebx
    3076:	89 1c 24             	mov    %ebx,(%esp)
    3079:	e8 6d 09 00 00       	call   39eb <sbrk>
    307e:	83 c4 10             	add    $0x10,%esp
    3081:	eb 80                	jmp    3003 <sbrktest+0x263>
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
    3083:	83 ec 0c             	sub    $0xc,%esp
    3086:	50                   	push   %eax
    3087:	56                   	push   %esi
    3088:	57                   	push   %edi
    3089:	68 33 4c 00 00       	push   $0x4c33
    308e:	ff 35 a0 5e 00 00    	pushl  0x5ea0
    3094:	e8 37 0a 00 00       	call   3ad0 <printf>
      exit();
    3099:	83 c4 20             	add    $0x20,%esp
    309c:	e8 c2 08 00 00       	call   3963 <exit>
    printf(stdout, "failed sbrk leaked memory\n");
    30a1:	50                   	push   %eax
    30a2:	50                   	push   %eax
    30a3:	68 b5 4c 00 00       	push   $0x4cb5
    30a8:	ff 35 a0 5e 00 00    	pushl  0x5ea0
    30ae:	e8 1d 0a 00 00       	call   3ad0 <printf>
    exit();
    30b3:	e8 ab 08 00 00       	call   3963 <exit>
    printf(1, "pipe() failed\n");
    30b8:	52                   	push   %edx
    30b9:	52                   	push   %edx
    30ba:	68 71 41 00 00       	push   $0x4171
    30bf:	6a 01                	push   $0x1
    30c1:	e8 0a 0a 00 00       	call   3ad0 <printf>
    exit();
    30c6:	e8 98 08 00 00       	call   3963 <exit>
    30cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    30cf:	90                   	nop
      printf(stdout, "oops could read %x = %x\n", a, *a);
    30d0:	0f be 06             	movsbl (%esi),%eax
    30d3:	50                   	push   %eax
    30d4:	56                   	push   %esi
    30d5:	68 9c 4c 00 00       	push   $0x4c9c
    30da:	ff 35 a0 5e 00 00    	pushl  0x5ea0
    30e0:	e8 eb 09 00 00       	call   3ad0 <printf>
      kill(ppid, SIGKILL);
    30e5:	59                   	pop    %ecx
    30e6:	5b                   	pop    %ebx
    30e7:	6a 09                	push   $0x9
    30e9:	57                   	push   %edi
    30ea:	e8 a4 08 00 00       	call   3993 <kill>
      exit();
    30ef:	e8 6f 08 00 00       	call   3963 <exit>
      printf(stdout, "fork failed\n");
    30f4:	83 ec 08             	sub    $0x8,%esp
    30f7:	68 79 4d 00 00       	push   $0x4d79
    30fc:	ff 35 a0 5e 00 00    	pushl  0x5ea0
    3102:	e8 c9 09 00 00       	call   3ad0 <printf>
      exit();
    3107:	e8 57 08 00 00       	call   3963 <exit>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    310c:	50                   	push   %eax
    310d:	56                   	push   %esi
    310e:	68 7c 54 00 00       	push   $0x547c
    3113:	ff 35 a0 5e 00 00    	pushl  0x5ea0
    3119:	e8 b2 09 00 00       	call   3ad0 <printf>
    exit();
    311e:	e8 40 08 00 00       	call   3963 <exit>
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    3123:	56                   	push   %esi
    3124:	56                   	push   %esi
    3125:	68 4c 54 00 00       	push   $0x544c
    312a:	ff 35 a0 5e 00 00    	pushl  0x5ea0
    3130:	e8 9b 09 00 00       	call   3ad0 <printf>
    exit();
    3135:	e8 29 08 00 00       	call   3963 <exit>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    313a:	57                   	push   %edi
    313b:	56                   	push   %esi
    313c:	68 24 54 00 00       	push   $0x5424
    3141:	ff 35 a0 5e 00 00    	pushl  0x5ea0
    3147:	e8 84 09 00 00       	call   3ad0 <printf>
    exit();
    314c:	e8 12 08 00 00       	call   3963 <exit>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    3151:	50                   	push   %eax
    3152:	56                   	push   %esi
    3153:	68 ec 53 00 00       	push   $0x53ec
    3158:	ff 35 a0 5e 00 00    	pushl  0x5ea0
    315e:	e8 6d 09 00 00       	call   3ad0 <printf>
    exit();
    3163:	e8 fb 07 00 00       	call   3963 <exit>
    printf(stdout, "sbrk could not deallocate\n");
    3168:	57                   	push   %edi
    3169:	57                   	push   %edi
    316a:	68 81 4c 00 00       	push   $0x4c81
    316f:	ff 35 a0 5e 00 00    	pushl  0x5ea0
    3175:	e8 56 09 00 00       	call   3ad0 <printf>
    exit();
    317a:	e8 e4 07 00 00       	call   3963 <exit>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    317f:	50                   	push   %eax
    3180:	50                   	push   %eax
    3181:	68 ac 53 00 00       	push   $0x53ac
    3186:	ff 35 a0 5e 00 00    	pushl  0x5ea0
    318c:	e8 3f 09 00 00       	call   3ad0 <printf>
    exit();
    3191:	e8 cd 07 00 00       	call   3963 <exit>
    exit();
    3196:	e8 c8 07 00 00       	call   3963 <exit>
    printf(stdout, "sbrk test failed post-fork\n");
    319b:	50                   	push   %eax
    319c:	50                   	push   %eax
    319d:	68 65 4c 00 00       	push   $0x4c65
    31a2:	ff 35 a0 5e 00 00    	pushl  0x5ea0
    31a8:	e8 23 09 00 00       	call   3ad0 <printf>
    exit();
    31ad:	e8 b1 07 00 00       	call   3963 <exit>
    printf(stdout, "sbrk test fork failed\n");
    31b2:	50                   	push   %eax
    31b3:	50                   	push   %eax
    31b4:	68 4e 4c 00 00       	push   $0x4c4e
    31b9:	ff 35 a0 5e 00 00    	pushl  0x5ea0
    31bf:	e8 0c 09 00 00       	call   3ad0 <printf>
    exit();
    31c4:	e8 9a 07 00 00       	call   3963 <exit>
    31c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000031d0 <validateint>:
{
    31d0:	f3 0f 1e fb          	endbr32 
}
    31d4:	c3                   	ret    
    31d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    31dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000031e0 <validatetest>:
{
    31e0:	f3 0f 1e fb          	endbr32 
    31e4:	55                   	push   %ebp
    31e5:	89 e5                	mov    %esp,%ebp
    31e7:	56                   	push   %esi
  for(p = 0; p <= (uint)hi; p += 4096){ 
    31e8:	31 f6                	xor    %esi,%esi
{
    31ea:	53                   	push   %ebx
  printf(stdout, "validate test\n");
    31eb:	83 ec 08             	sub    $0x8,%esp
    31ee:	68 de 4c 00 00       	push   $0x4cde
    31f3:	ff 35 a0 5e 00 00    	pushl  0x5ea0
    31f9:	e8 d2 08 00 00       	call   3ad0 <printf>
    31fe:	83 c4 10             	add    $0x10,%esp
    3201:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((pid = fork()) == 0){
    3208:	e8 4e 07 00 00       	call   395b <fork>
    320d:	89 c3                	mov    %eax,%ebx
    320f:	85 c0                	test   %eax,%eax
    3211:	74 65                	je     3278 <validatetest+0x98>
    sleep(0);
    3213:	83 ec 0c             	sub    $0xc,%esp
    3216:	6a 00                	push   $0x0
    3218:	e8 d6 07 00 00       	call   39f3 <sleep>
    sleep(0);
    321d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3224:	e8 ca 07 00 00       	call   39f3 <sleep>
    kill(pid, SIGKILL);
    3229:	58                   	pop    %eax
    322a:	5a                   	pop    %edx
    322b:	6a 09                	push   $0x9
    322d:	53                   	push   %ebx
    322e:	e8 60 07 00 00       	call   3993 <kill>
    wait();
    3233:	e8 33 07 00 00       	call   396b <wait>
    if(link("nosuchfile", (char*)p) != -1){
    3238:	59                   	pop    %ecx
    3239:	5b                   	pop    %ebx
    323a:	56                   	push   %esi
    323b:	68 ed 4c 00 00       	push   $0x4ced
    3240:	e8 7e 07 00 00       	call   39c3 <link>
    3245:	83 c4 10             	add    $0x10,%esp
    3248:	83 f8 ff             	cmp    $0xffffffff,%eax
    324b:	75 30                	jne    327d <validatetest+0x9d>
  for(p = 0; p <= (uint)hi; p += 4096){ 
    324d:	81 c6 00 10 00 00    	add    $0x1000,%esi
    3253:	81 fe 00 40 11 00    	cmp    $0x114000,%esi
    3259:	75 ad                	jne    3208 <validatetest+0x28>
  printf(stdout, "validate ok\n");
    325b:	83 ec 08             	sub    $0x8,%esp
    325e:	68 11 4d 00 00       	push   $0x4d11
    3263:	ff 35 a0 5e 00 00    	pushl  0x5ea0
    3269:	e8 62 08 00 00       	call   3ad0 <printf>
}
    326e:	83 c4 10             	add    $0x10,%esp
    3271:	8d 65 f8             	lea    -0x8(%ebp),%esp
    3274:	5b                   	pop    %ebx
    3275:	5e                   	pop    %esi
    3276:	5d                   	pop    %ebp
    3277:	c3                   	ret    
      exit();
    3278:	e8 e6 06 00 00       	call   3963 <exit>
      printf(stdout, "link should not succeed\n");
    327d:	83 ec 08             	sub    $0x8,%esp
    3280:	68 f8 4c 00 00       	push   $0x4cf8
    3285:	ff 35 a0 5e 00 00    	pushl  0x5ea0
    328b:	e8 40 08 00 00       	call   3ad0 <printf>
      exit();
    3290:	e8 ce 06 00 00       	call   3963 <exit>
    3295:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    329c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000032a0 <bsstest>:
{
    32a0:	f3 0f 1e fb          	endbr32 
    32a4:	55                   	push   %ebp
    32a5:	89 e5                	mov    %esp,%ebp
    32a7:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "bss test\n");
    32aa:	68 1e 4d 00 00       	push   $0x4d1e
    32af:	ff 35 a0 5e 00 00    	pushl  0x5ea0
    32b5:	e8 16 08 00 00       	call   3ad0 <printf>
    32ba:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sizeof(uninit); i++){
    32bd:	31 c0                	xor    %eax,%eax
    32bf:	90                   	nop
    if(uninit[i] != '\0'){
    32c0:	80 b8 60 5f 00 00 00 	cmpb   $0x0,0x5f60(%eax)
    32c7:	75 22                	jne    32eb <bsstest+0x4b>
  for(i = 0; i < sizeof(uninit); i++){
    32c9:	83 c0 01             	add    $0x1,%eax
    32cc:	3d 10 27 00 00       	cmp    $0x2710,%eax
    32d1:	75 ed                	jne    32c0 <bsstest+0x20>
  printf(stdout, "bss test ok\n");
    32d3:	83 ec 08             	sub    $0x8,%esp
    32d6:	68 39 4d 00 00       	push   $0x4d39
    32db:	ff 35 a0 5e 00 00    	pushl  0x5ea0
    32e1:	e8 ea 07 00 00       	call   3ad0 <printf>
}
    32e6:	83 c4 10             	add    $0x10,%esp
    32e9:	c9                   	leave  
    32ea:	c3                   	ret    
      printf(stdout, "bss test failed\n");
    32eb:	83 ec 08             	sub    $0x8,%esp
    32ee:	68 28 4d 00 00       	push   $0x4d28
    32f3:	ff 35 a0 5e 00 00    	pushl  0x5ea0
    32f9:	e8 d2 07 00 00       	call   3ad0 <printf>
      exit();
    32fe:	e8 60 06 00 00       	call   3963 <exit>
    3303:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    330a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00003310 <bigargtest>:
{
    3310:	f3 0f 1e fb          	endbr32 
    3314:	55                   	push   %ebp
    3315:	89 e5                	mov    %esp,%ebp
    3317:	83 ec 14             	sub    $0x14,%esp
  unlink("bigarg-ok");
    331a:	68 46 4d 00 00       	push   $0x4d46
    331f:	e8 8f 06 00 00       	call   39b3 <unlink>
  pid = fork();
    3324:	e8 32 06 00 00       	call   395b <fork>
  if(pid == 0){
    3329:	83 c4 10             	add    $0x10,%esp
    332c:	85 c0                	test   %eax,%eax
    332e:	74 40                	je     3370 <bigargtest+0x60>
  } else if(pid < 0){
    3330:	0f 88 c1 00 00 00    	js     33f7 <bigargtest+0xe7>
  wait();
    3336:	e8 30 06 00 00       	call   396b <wait>
  fd = open("bigarg-ok", 0);
    333b:	83 ec 08             	sub    $0x8,%esp
    333e:	6a 00                	push   $0x0
    3340:	68 46 4d 00 00       	push   $0x4d46
    3345:	e8 59 06 00 00       	call   39a3 <open>
  if(fd < 0){
    334a:	83 c4 10             	add    $0x10,%esp
    334d:	85 c0                	test   %eax,%eax
    334f:	0f 88 8b 00 00 00    	js     33e0 <bigargtest+0xd0>
  close(fd);
    3355:	83 ec 0c             	sub    $0xc,%esp
    3358:	50                   	push   %eax
    3359:	e8 2d 06 00 00       	call   398b <close>
  unlink("bigarg-ok");
    335e:	c7 04 24 46 4d 00 00 	movl   $0x4d46,(%esp)
    3365:	e8 49 06 00 00       	call   39b3 <unlink>
}
    336a:	83 c4 10             	add    $0x10,%esp
    336d:	c9                   	leave  
    336e:	c3                   	ret    
    336f:	90                   	nop
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    3370:	c7 04 85 c0 5e 00 00 	movl   $0x54a0,0x5ec0(,%eax,4)
    3377:	a0 54 00 00 
    for(i = 0; i < MAXARG-1; i++)
    337b:	83 c0 01             	add    $0x1,%eax
    337e:	83 f8 1f             	cmp    $0x1f,%eax
    3381:	75 ed                	jne    3370 <bigargtest+0x60>
    printf(stdout, "bigarg test\n");
    3383:	51                   	push   %ecx
    3384:	51                   	push   %ecx
    3385:	68 50 4d 00 00       	push   $0x4d50
    338a:	ff 35 a0 5e 00 00    	pushl  0x5ea0
    args[MAXARG-1] = 0;
    3390:	c7 05 3c 5f 00 00 00 	movl   $0x0,0x5f3c
    3397:	00 00 00 
    printf(stdout, "bigarg test\n");
    339a:	e8 31 07 00 00       	call   3ad0 <printf>
    exec("echo", args);
    339f:	58                   	pop    %eax
    33a0:	5a                   	pop    %edx
    33a1:	68 c0 5e 00 00       	push   $0x5ec0
    33a6:	68 1d 3f 00 00       	push   $0x3f1d
    33ab:	e8 eb 05 00 00       	call   399b <exec>
    printf(stdout, "bigarg test ok\n");
    33b0:	59                   	pop    %ecx
    33b1:	58                   	pop    %eax
    33b2:	68 5d 4d 00 00       	push   $0x4d5d
    33b7:	ff 35 a0 5e 00 00    	pushl  0x5ea0
    33bd:	e8 0e 07 00 00       	call   3ad0 <printf>
    fd = open("bigarg-ok", O_CREATE);
    33c2:	58                   	pop    %eax
    33c3:	5a                   	pop    %edx
    33c4:	68 00 02 00 00       	push   $0x200
    33c9:	68 46 4d 00 00       	push   $0x4d46
    33ce:	e8 d0 05 00 00       	call   39a3 <open>
    close(fd);
    33d3:	89 04 24             	mov    %eax,(%esp)
    33d6:	e8 b0 05 00 00       	call   398b <close>
    exit();
    33db:	e8 83 05 00 00       	call   3963 <exit>
    printf(stdout, "bigarg test failed!\n");
    33e0:	50                   	push   %eax
    33e1:	50                   	push   %eax
    33e2:	68 86 4d 00 00       	push   $0x4d86
    33e7:	ff 35 a0 5e 00 00    	pushl  0x5ea0
    33ed:	e8 de 06 00 00       	call   3ad0 <printf>
    exit();
    33f2:	e8 6c 05 00 00       	call   3963 <exit>
    printf(stdout, "bigargtest: fork failed\n");
    33f7:	52                   	push   %edx
    33f8:	52                   	push   %edx
    33f9:	68 6d 4d 00 00       	push   $0x4d6d
    33fe:	ff 35 a0 5e 00 00    	pushl  0x5ea0
    3404:	e8 c7 06 00 00       	call   3ad0 <printf>
    exit();
    3409:	e8 55 05 00 00       	call   3963 <exit>
    340e:	66 90                	xchg   %ax,%ax

00003410 <fsfull>:
{
    3410:	f3 0f 1e fb          	endbr32 
    3414:	55                   	push   %ebp
    3415:	89 e5                	mov    %esp,%ebp
    3417:	57                   	push   %edi
    3418:	56                   	push   %esi
  for(nfiles = 0; ; nfiles++){
    3419:	31 f6                	xor    %esi,%esi
{
    341b:	53                   	push   %ebx
    341c:	83 ec 54             	sub    $0x54,%esp
  printf(1, "fsfull test\n");
    341f:	68 9b 4d 00 00       	push   $0x4d9b
    3424:	6a 01                	push   $0x1
    3426:	e8 a5 06 00 00       	call   3ad0 <printf>
    342b:	83 c4 10             	add    $0x10,%esp
    342e:	66 90                	xchg   %ax,%ax
    name[1] = '0' + nfiles / 1000;
    3430:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
    name[3] = '0' + (nfiles % 100) / 10;
    3435:	b9 cd cc cc cc       	mov    $0xcccccccd,%ecx
    printf(1, "writing %s\n", name);
    343a:	83 ec 04             	sub    $0x4,%esp
    name[0] = 'f';
    343d:	c6 45 a8 66          	movb   $0x66,-0x58(%ebp)
    name[1] = '0' + nfiles / 1000;
    3441:	f7 e6                	mul    %esi
    name[5] = '\0';
    3443:	c6 45 ad 00          	movb   $0x0,-0x53(%ebp)
    name[1] = '0' + nfiles / 1000;
    3447:	c1 ea 06             	shr    $0x6,%edx
    344a:	8d 42 30             	lea    0x30(%edx),%eax
    name[2] = '0' + (nfiles % 1000) / 100;
    344d:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
    name[1] = '0' + nfiles / 1000;
    3453:	88 45 a9             	mov    %al,-0x57(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    3456:	89 f0                	mov    %esi,%eax
    3458:	29 d0                	sub    %edx,%eax
    345a:	89 c2                	mov    %eax,%edx
    345c:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    3461:	f7 e2                	mul    %edx
    name[3] = '0' + (nfiles % 100) / 10;
    3463:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    name[2] = '0' + (nfiles % 1000) / 100;
    3468:	c1 ea 05             	shr    $0x5,%edx
    346b:	83 c2 30             	add    $0x30,%edx
    346e:	88 55 aa             	mov    %dl,-0x56(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    3471:	f7 e6                	mul    %esi
    3473:	89 f0                	mov    %esi,%eax
    3475:	c1 ea 05             	shr    $0x5,%edx
    3478:	6b d2 64             	imul   $0x64,%edx,%edx
    347b:	29 d0                	sub    %edx,%eax
    347d:	f7 e1                	mul    %ecx
    name[4] = '0' + (nfiles % 10);
    347f:	89 f0                	mov    %esi,%eax
    name[3] = '0' + (nfiles % 100) / 10;
    3481:	c1 ea 03             	shr    $0x3,%edx
    3484:	83 c2 30             	add    $0x30,%edx
    3487:	88 55 ab             	mov    %dl,-0x55(%ebp)
    name[4] = '0' + (nfiles % 10);
    348a:	f7 e1                	mul    %ecx
    348c:	89 f1                	mov    %esi,%ecx
    348e:	c1 ea 03             	shr    $0x3,%edx
    3491:	8d 04 92             	lea    (%edx,%edx,4),%eax
    3494:	01 c0                	add    %eax,%eax
    3496:	29 c1                	sub    %eax,%ecx
    3498:	89 c8                	mov    %ecx,%eax
    349a:	83 c0 30             	add    $0x30,%eax
    349d:	88 45 ac             	mov    %al,-0x54(%ebp)
    printf(1, "writing %s\n", name);
    34a0:	8d 45 a8             	lea    -0x58(%ebp),%eax
    34a3:	50                   	push   %eax
    34a4:	68 a8 4d 00 00       	push   $0x4da8
    34a9:	6a 01                	push   $0x1
    34ab:	e8 20 06 00 00       	call   3ad0 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    34b0:	58                   	pop    %eax
    34b1:	8d 45 a8             	lea    -0x58(%ebp),%eax
    34b4:	5a                   	pop    %edx
    34b5:	68 02 02 00 00       	push   $0x202
    34ba:	50                   	push   %eax
    34bb:	e8 e3 04 00 00       	call   39a3 <open>
    if(fd < 0){
    34c0:	83 c4 10             	add    $0x10,%esp
    int fd = open(name, O_CREATE|O_RDWR);
    34c3:	89 c7                	mov    %eax,%edi
    if(fd < 0){
    34c5:	85 c0                	test   %eax,%eax
    34c7:	78 4d                	js     3516 <fsfull+0x106>
    int total = 0;
    34c9:	31 db                	xor    %ebx,%ebx
    34cb:	eb 05                	jmp    34d2 <fsfull+0xc2>
    34cd:	8d 76 00             	lea    0x0(%esi),%esi
      total += cc;
    34d0:	01 c3                	add    %eax,%ebx
      int cc = write(fd, buf, 512);
    34d2:	83 ec 04             	sub    $0x4,%esp
    34d5:	68 00 02 00 00       	push   $0x200
    34da:	68 80 86 00 00       	push   $0x8680
    34df:	57                   	push   %edi
    34e0:	e8 9e 04 00 00       	call   3983 <write>
      if(cc < 512)
    34e5:	83 c4 10             	add    $0x10,%esp
    34e8:	3d ff 01 00 00       	cmp    $0x1ff,%eax
    34ed:	7f e1                	jg     34d0 <fsfull+0xc0>
    printf(1, "wrote %d bytes\n", total);
    34ef:	83 ec 04             	sub    $0x4,%esp
    34f2:	53                   	push   %ebx
    34f3:	68 c4 4d 00 00       	push   $0x4dc4
    34f8:	6a 01                	push   $0x1
    34fa:	e8 d1 05 00 00       	call   3ad0 <printf>
    close(fd);
    34ff:	89 3c 24             	mov    %edi,(%esp)
    3502:	e8 84 04 00 00       	call   398b <close>
    if(total == 0)
    3507:	83 c4 10             	add    $0x10,%esp
    350a:	85 db                	test   %ebx,%ebx
    350c:	74 1e                	je     352c <fsfull+0x11c>
  for(nfiles = 0; ; nfiles++){
    350e:	83 c6 01             	add    $0x1,%esi
    3511:	e9 1a ff ff ff       	jmp    3430 <fsfull+0x20>
      printf(1, "open %s failed\n", name);
    3516:	83 ec 04             	sub    $0x4,%esp
    3519:	8d 45 a8             	lea    -0x58(%ebp),%eax
    351c:	50                   	push   %eax
    351d:	68 b4 4d 00 00       	push   $0x4db4
    3522:	6a 01                	push   $0x1
    3524:	e8 a7 05 00 00       	call   3ad0 <printf>
      break;
    3529:	83 c4 10             	add    $0x10,%esp
    name[1] = '0' + nfiles / 1000;
    352c:	bf d3 4d 62 10       	mov    $0x10624dd3,%edi
    name[2] = '0' + (nfiles % 1000) / 100;
    3531:	bb 1f 85 eb 51       	mov    $0x51eb851f,%ebx
    3536:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    353d:	8d 76 00             	lea    0x0(%esi),%esi
    name[1] = '0' + nfiles / 1000;
    3540:	89 f0                	mov    %esi,%eax
    3542:	89 f1                	mov    %esi,%ecx
    unlink(name);
    3544:	83 ec 0c             	sub    $0xc,%esp
    name[0] = 'f';
    3547:	c6 45 a8 66          	movb   $0x66,-0x58(%ebp)
    name[1] = '0' + nfiles / 1000;
    354b:	f7 ef                	imul   %edi
    354d:	c1 f9 1f             	sar    $0x1f,%ecx
    name[5] = '\0';
    3550:	c6 45 ad 00          	movb   $0x0,-0x53(%ebp)
    name[1] = '0' + nfiles / 1000;
    3554:	c1 fa 06             	sar    $0x6,%edx
    3557:	29 ca                	sub    %ecx,%edx
    3559:	8d 42 30             	lea    0x30(%edx),%eax
    name[2] = '0' + (nfiles % 1000) / 100;
    355c:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
    name[1] = '0' + nfiles / 1000;
    3562:	88 45 a9             	mov    %al,-0x57(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    3565:	89 f0                	mov    %esi,%eax
    3567:	29 d0                	sub    %edx,%eax
    3569:	f7 e3                	mul    %ebx
    name[3] = '0' + (nfiles % 100) / 10;
    356b:	89 f0                	mov    %esi,%eax
    name[2] = '0' + (nfiles % 1000) / 100;
    356d:	c1 ea 05             	shr    $0x5,%edx
    3570:	83 c2 30             	add    $0x30,%edx
    3573:	88 55 aa             	mov    %dl,-0x56(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    3576:	f7 eb                	imul   %ebx
    3578:	89 f0                	mov    %esi,%eax
    357a:	c1 fa 05             	sar    $0x5,%edx
    357d:	29 ca                	sub    %ecx,%edx
    357f:	6b d2 64             	imul   $0x64,%edx,%edx
    3582:	29 d0                	sub    %edx,%eax
    3584:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
    3589:	f7 e2                	mul    %edx
    name[4] = '0' + (nfiles % 10);
    358b:	89 f0                	mov    %esi,%eax
    name[3] = '0' + (nfiles % 100) / 10;
    358d:	c1 ea 03             	shr    $0x3,%edx
    3590:	83 c2 30             	add    $0x30,%edx
    3593:	88 55 ab             	mov    %dl,-0x55(%ebp)
    name[4] = '0' + (nfiles % 10);
    3596:	ba 67 66 66 66       	mov    $0x66666667,%edx
    359b:	f7 ea                	imul   %edx
    359d:	c1 fa 02             	sar    $0x2,%edx
    35a0:	29 ca                	sub    %ecx,%edx
    35a2:	89 f1                	mov    %esi,%ecx
    nfiles--;
    35a4:	83 ee 01             	sub    $0x1,%esi
    name[4] = '0' + (nfiles % 10);
    35a7:	8d 04 92             	lea    (%edx,%edx,4),%eax
    35aa:	01 c0                	add    %eax,%eax
    35ac:	29 c1                	sub    %eax,%ecx
    35ae:	89 c8                	mov    %ecx,%eax
    35b0:	83 c0 30             	add    $0x30,%eax
    35b3:	88 45 ac             	mov    %al,-0x54(%ebp)
    unlink(name);
    35b6:	8d 45 a8             	lea    -0x58(%ebp),%eax
    35b9:	50                   	push   %eax
    35ba:	e8 f4 03 00 00       	call   39b3 <unlink>
  while(nfiles >= 0){
    35bf:	83 c4 10             	add    $0x10,%esp
    35c2:	83 fe ff             	cmp    $0xffffffff,%esi
    35c5:	0f 85 75 ff ff ff    	jne    3540 <fsfull+0x130>
  printf(1, "fsfull test finished\n");
    35cb:	83 ec 08             	sub    $0x8,%esp
    35ce:	68 d4 4d 00 00       	push   $0x4dd4
    35d3:	6a 01                	push   $0x1
    35d5:	e8 f6 04 00 00       	call   3ad0 <printf>
}
    35da:	83 c4 10             	add    $0x10,%esp
    35dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
    35e0:	5b                   	pop    %ebx
    35e1:	5e                   	pop    %esi
    35e2:	5f                   	pop    %edi
    35e3:	5d                   	pop    %ebp
    35e4:	c3                   	ret    
    35e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    35ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000035f0 <uio>:
{
    35f0:	f3 0f 1e fb          	endbr32 
    35f4:	55                   	push   %ebp
    35f5:	89 e5                	mov    %esp,%ebp
    35f7:	83 ec 10             	sub    $0x10,%esp
  printf(1, "uio test\n");
    35fa:	68 ea 4d 00 00       	push   $0x4dea
    35ff:	6a 01                	push   $0x1
    3601:	e8 ca 04 00 00       	call   3ad0 <printf>
  pid = fork();
    3606:	e8 50 03 00 00       	call   395b <fork>
  if(pid == 0){
    360b:	83 c4 10             	add    $0x10,%esp
    360e:	85 c0                	test   %eax,%eax
    3610:	74 1b                	je     362d <uio+0x3d>
  } else if(pid < 0){
    3612:	78 3d                	js     3651 <uio+0x61>
  wait();
    3614:	e8 52 03 00 00       	call   396b <wait>
  printf(1, "uio test done\n");
    3619:	83 ec 08             	sub    $0x8,%esp
    361c:	68 f4 4d 00 00       	push   $0x4df4
    3621:	6a 01                	push   $0x1
    3623:	e8 a8 04 00 00       	call   3ad0 <printf>
}
    3628:	83 c4 10             	add    $0x10,%esp
    362b:	c9                   	leave  
    362c:	c3                   	ret    
    asm volatile("outb %0,%1"::"a"(val), "d" (port));
    362d:	b8 09 00 00 00       	mov    $0x9,%eax
    3632:	ba 70 00 00 00       	mov    $0x70,%edx
    3637:	ee                   	out    %al,(%dx)
    asm volatile("inb %1,%0" : "=a" (val) : "d" (port));
    3638:	ba 71 00 00 00       	mov    $0x71,%edx
    363d:	ec                   	in     (%dx),%al
    printf(1, "uio: uio succeeded; test FAILED\n");
    363e:	52                   	push   %edx
    363f:	52                   	push   %edx
    3640:	68 80 55 00 00       	push   $0x5580
    3645:	6a 01                	push   $0x1
    3647:	e8 84 04 00 00       	call   3ad0 <printf>
    exit();
    364c:	e8 12 03 00 00       	call   3963 <exit>
    printf (1, "fork failed\n");
    3651:	50                   	push   %eax
    3652:	50                   	push   %eax
    3653:	68 79 4d 00 00       	push   $0x4d79
    3658:	6a 01                	push   $0x1
    365a:	e8 71 04 00 00       	call   3ad0 <printf>
    exit();
    365f:	e8 ff 02 00 00       	call   3963 <exit>
    3664:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    366b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    366f:	90                   	nop

00003670 <argptest>:
{
    3670:	f3 0f 1e fb          	endbr32 
    3674:	55                   	push   %ebp
    3675:	89 e5                	mov    %esp,%ebp
    3677:	53                   	push   %ebx
    3678:	83 ec 0c             	sub    $0xc,%esp
  fd = open("init", O_RDONLY);
    367b:	6a 00                	push   $0x0
    367d:	68 03 4e 00 00       	push   $0x4e03
    3682:	e8 1c 03 00 00       	call   39a3 <open>
  if (fd < 0) {
    3687:	83 c4 10             	add    $0x10,%esp
    368a:	85 c0                	test   %eax,%eax
    368c:	78 39                	js     36c7 <argptest+0x57>
  read(fd, sbrk(0) - 1, -1);
    368e:	83 ec 0c             	sub    $0xc,%esp
    3691:	89 c3                	mov    %eax,%ebx
    3693:	6a 00                	push   $0x0
    3695:	e8 51 03 00 00       	call   39eb <sbrk>
    369a:	83 c4 0c             	add    $0xc,%esp
    369d:	83 e8 01             	sub    $0x1,%eax
    36a0:	6a ff                	push   $0xffffffff
    36a2:	50                   	push   %eax
    36a3:	53                   	push   %ebx
    36a4:	e8 d2 02 00 00       	call   397b <read>
  close(fd);
    36a9:	89 1c 24             	mov    %ebx,(%esp)
    36ac:	e8 da 02 00 00       	call   398b <close>
  printf(1, "arg test passed\n");
    36b1:	58                   	pop    %eax
    36b2:	5a                   	pop    %edx
    36b3:	68 15 4e 00 00       	push   $0x4e15
    36b8:	6a 01                	push   $0x1
    36ba:	e8 11 04 00 00       	call   3ad0 <printf>
}
    36bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    36c2:	83 c4 10             	add    $0x10,%esp
    36c5:	c9                   	leave  
    36c6:	c3                   	ret    
    printf(2, "open failed\n");
    36c7:	51                   	push   %ecx
    36c8:	51                   	push   %ecx
    36c9:	68 08 4e 00 00       	push   $0x4e08
    36ce:	6a 02                	push   $0x2
    36d0:	e8 fb 03 00 00       	call   3ad0 <printf>
    exit();
    36d5:	e8 89 02 00 00       	call   3963 <exit>
    36da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000036e0 <rand>:
{
    36e0:	f3 0f 1e fb          	endbr32 
  randstate = randstate * 1664525 + 1013904223;
    36e4:	69 05 9c 5e 00 00 0d 	imul   $0x19660d,0x5e9c,%eax
    36eb:	66 19 00 
    36ee:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
    36f3:	a3 9c 5e 00 00       	mov    %eax,0x5e9c
}
    36f8:	c3                   	ret    
    36f9:	66 90                	xchg   %ax,%ax
    36fb:	66 90                	xchg   %ax,%ax
    36fd:	66 90                	xchg   %ax,%ax
    36ff:	90                   	nop

00003700 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    3700:	f3 0f 1e fb          	endbr32 
    3704:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    3705:	31 c0                	xor    %eax,%eax
{
    3707:	89 e5                	mov    %esp,%ebp
    3709:	53                   	push   %ebx
    370a:	8b 4d 08             	mov    0x8(%ebp),%ecx
    370d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
    3710:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
    3714:	88 14 01             	mov    %dl,(%ecx,%eax,1)
    3717:	83 c0 01             	add    $0x1,%eax
    371a:	84 d2                	test   %dl,%dl
    371c:	75 f2                	jne    3710 <strcpy+0x10>
    ;
  return os;
}
    371e:	89 c8                	mov    %ecx,%eax
    3720:	5b                   	pop    %ebx
    3721:	5d                   	pop    %ebp
    3722:	c3                   	ret    
    3723:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    372a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00003730 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    3730:	f3 0f 1e fb          	endbr32 
    3734:	55                   	push   %ebp
    3735:	89 e5                	mov    %esp,%ebp
    3737:	53                   	push   %ebx
    3738:	8b 4d 08             	mov    0x8(%ebp),%ecx
    373b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
    373e:	0f b6 01             	movzbl (%ecx),%eax
    3741:	0f b6 1a             	movzbl (%edx),%ebx
    3744:	84 c0                	test   %al,%al
    3746:	75 19                	jne    3761 <strcmp+0x31>
    3748:	eb 26                	jmp    3770 <strcmp+0x40>
    374a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    3750:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
    3754:	83 c1 01             	add    $0x1,%ecx
    3757:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
    375a:	0f b6 1a             	movzbl (%edx),%ebx
    375d:	84 c0                	test   %al,%al
    375f:	74 0f                	je     3770 <strcmp+0x40>
    3761:	38 d8                	cmp    %bl,%al
    3763:	74 eb                	je     3750 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
    3765:	29 d8                	sub    %ebx,%eax
}
    3767:	5b                   	pop    %ebx
    3768:	5d                   	pop    %ebp
    3769:	c3                   	ret    
    376a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    3770:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
    3772:	29 d8                	sub    %ebx,%eax
}
    3774:	5b                   	pop    %ebx
    3775:	5d                   	pop    %ebp
    3776:	c3                   	ret    
    3777:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    377e:	66 90                	xchg   %ax,%ax

00003780 <strlen>:

uint
strlen(const char *s)
{
    3780:	f3 0f 1e fb          	endbr32 
    3784:	55                   	push   %ebp
    3785:	89 e5                	mov    %esp,%ebp
    3787:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
    378a:	80 3a 00             	cmpb   $0x0,(%edx)
    378d:	74 21                	je     37b0 <strlen+0x30>
    378f:	31 c0                	xor    %eax,%eax
    3791:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3798:	83 c0 01             	add    $0x1,%eax
    379b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
    379f:	89 c1                	mov    %eax,%ecx
    37a1:	75 f5                	jne    3798 <strlen+0x18>
    ;
  return n;
}
    37a3:	89 c8                	mov    %ecx,%eax
    37a5:	5d                   	pop    %ebp
    37a6:	c3                   	ret    
    37a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    37ae:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
    37b0:	31 c9                	xor    %ecx,%ecx
}
    37b2:	5d                   	pop    %ebp
    37b3:	89 c8                	mov    %ecx,%eax
    37b5:	c3                   	ret    
    37b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    37bd:	8d 76 00             	lea    0x0(%esi),%esi

000037c0 <memset>:

void*
memset(void *dst, int c, uint n)
{
    37c0:	f3 0f 1e fb          	endbr32 
    37c4:	55                   	push   %ebp
    37c5:	89 e5                	mov    %esp,%ebp
    37c7:	57                   	push   %edi
    37c8:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    37cb:	8b 4d 10             	mov    0x10(%ebp),%ecx
    37ce:	8b 45 0c             	mov    0xc(%ebp),%eax
    37d1:	89 d7                	mov    %edx,%edi
    37d3:	fc                   	cld    
    37d4:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    37d6:	89 d0                	mov    %edx,%eax
    37d8:	5f                   	pop    %edi
    37d9:	5d                   	pop    %ebp
    37da:	c3                   	ret    
    37db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    37df:	90                   	nop

000037e0 <strchr>:

char*
strchr(const char *s, char c)
{
    37e0:	f3 0f 1e fb          	endbr32 
    37e4:	55                   	push   %ebp
    37e5:	89 e5                	mov    %esp,%ebp
    37e7:	8b 45 08             	mov    0x8(%ebp),%eax
    37ea:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
    37ee:	0f b6 10             	movzbl (%eax),%edx
    37f1:	84 d2                	test   %dl,%dl
    37f3:	75 16                	jne    380b <strchr+0x2b>
    37f5:	eb 21                	jmp    3818 <strchr+0x38>
    37f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    37fe:	66 90                	xchg   %ax,%ax
    3800:	0f b6 50 01          	movzbl 0x1(%eax),%edx
    3804:	83 c0 01             	add    $0x1,%eax
    3807:	84 d2                	test   %dl,%dl
    3809:	74 0d                	je     3818 <strchr+0x38>
    if(*s == c)
    380b:	38 d1                	cmp    %dl,%cl
    380d:	75 f1                	jne    3800 <strchr+0x20>
      return (char*)s;
  return 0;
}
    380f:	5d                   	pop    %ebp
    3810:	c3                   	ret    
    3811:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
    3818:	31 c0                	xor    %eax,%eax
}
    381a:	5d                   	pop    %ebp
    381b:	c3                   	ret    
    381c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00003820 <gets>:

char*
gets(char *buf, int max)
{
    3820:	f3 0f 1e fb          	endbr32 
    3824:	55                   	push   %ebp
    3825:	89 e5                	mov    %esp,%ebp
    3827:	57                   	push   %edi
    3828:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    3829:	31 f6                	xor    %esi,%esi
{
    382b:	53                   	push   %ebx
    382c:	89 f3                	mov    %esi,%ebx
    382e:	83 ec 1c             	sub    $0x1c,%esp
    3831:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
    3834:	eb 33                	jmp    3869 <gets+0x49>
    3836:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    383d:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
    3840:	83 ec 04             	sub    $0x4,%esp
    3843:	8d 45 e7             	lea    -0x19(%ebp),%eax
    3846:	6a 01                	push   $0x1
    3848:	50                   	push   %eax
    3849:	6a 00                	push   $0x0
    384b:	e8 2b 01 00 00       	call   397b <read>
    if(cc < 1)
    3850:	83 c4 10             	add    $0x10,%esp
    3853:	85 c0                	test   %eax,%eax
    3855:	7e 1c                	jle    3873 <gets+0x53>
      break;
    buf[i++] = c;
    3857:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    385b:	83 c7 01             	add    $0x1,%edi
    385e:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
    3861:	3c 0a                	cmp    $0xa,%al
    3863:	74 23                	je     3888 <gets+0x68>
    3865:	3c 0d                	cmp    $0xd,%al
    3867:	74 1f                	je     3888 <gets+0x68>
  for(i=0; i+1 < max; ){
    3869:	83 c3 01             	add    $0x1,%ebx
    386c:	89 fe                	mov    %edi,%esi
    386e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    3871:	7c cd                	jl     3840 <gets+0x20>
    3873:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
    3875:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
    3878:	c6 03 00             	movb   $0x0,(%ebx)
}
    387b:	8d 65 f4             	lea    -0xc(%ebp),%esp
    387e:	5b                   	pop    %ebx
    387f:	5e                   	pop    %esi
    3880:	5f                   	pop    %edi
    3881:	5d                   	pop    %ebp
    3882:	c3                   	ret    
    3883:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    3887:	90                   	nop
    3888:	8b 75 08             	mov    0x8(%ebp),%esi
    388b:	8b 45 08             	mov    0x8(%ebp),%eax
    388e:	01 de                	add    %ebx,%esi
    3890:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
    3892:	c6 03 00             	movb   $0x0,(%ebx)
}
    3895:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3898:	5b                   	pop    %ebx
    3899:	5e                   	pop    %esi
    389a:	5f                   	pop    %edi
    389b:	5d                   	pop    %ebp
    389c:	c3                   	ret    
    389d:	8d 76 00             	lea    0x0(%esi),%esi

000038a0 <stat>:

int
stat(const char *n, struct stat *st)
{
    38a0:	f3 0f 1e fb          	endbr32 
    38a4:	55                   	push   %ebp
    38a5:	89 e5                	mov    %esp,%ebp
    38a7:	56                   	push   %esi
    38a8:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    38a9:	83 ec 08             	sub    $0x8,%esp
    38ac:	6a 00                	push   $0x0
    38ae:	ff 75 08             	pushl  0x8(%ebp)
    38b1:	e8 ed 00 00 00       	call   39a3 <open>
  if(fd < 0)
    38b6:	83 c4 10             	add    $0x10,%esp
    38b9:	85 c0                	test   %eax,%eax
    38bb:	78 2b                	js     38e8 <stat+0x48>
    return -1;
  r = fstat(fd, st);
    38bd:	83 ec 08             	sub    $0x8,%esp
    38c0:	ff 75 0c             	pushl  0xc(%ebp)
    38c3:	89 c3                	mov    %eax,%ebx
    38c5:	50                   	push   %eax
    38c6:	e8 f0 00 00 00       	call   39bb <fstat>
  close(fd);
    38cb:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
    38ce:	89 c6                	mov    %eax,%esi
  close(fd);
    38d0:	e8 b6 00 00 00       	call   398b <close>
  return r;
    38d5:	83 c4 10             	add    $0x10,%esp
}
    38d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    38db:	89 f0                	mov    %esi,%eax
    38dd:	5b                   	pop    %ebx
    38de:	5e                   	pop    %esi
    38df:	5d                   	pop    %ebp
    38e0:	c3                   	ret    
    38e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
    38e8:	be ff ff ff ff       	mov    $0xffffffff,%esi
    38ed:	eb e9                	jmp    38d8 <stat+0x38>
    38ef:	90                   	nop

000038f0 <atoi>:

int
atoi(const char *s)
{
    38f0:	f3 0f 1e fb          	endbr32 
    38f4:	55                   	push   %ebp
    38f5:	89 e5                	mov    %esp,%ebp
    38f7:	53                   	push   %ebx
    38f8:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    38fb:	0f be 02             	movsbl (%edx),%eax
    38fe:	8d 48 d0             	lea    -0x30(%eax),%ecx
    3901:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
    3904:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
    3909:	77 1a                	ja     3925 <atoi+0x35>
    390b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    390f:	90                   	nop
    n = n*10 + *s++ - '0';
    3910:	83 c2 01             	add    $0x1,%edx
    3913:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
    3916:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
    391a:	0f be 02             	movsbl (%edx),%eax
    391d:	8d 58 d0             	lea    -0x30(%eax),%ebx
    3920:	80 fb 09             	cmp    $0x9,%bl
    3923:	76 eb                	jbe    3910 <atoi+0x20>
  return n;
}
    3925:	89 c8                	mov    %ecx,%eax
    3927:	5b                   	pop    %ebx
    3928:	5d                   	pop    %ebp
    3929:	c3                   	ret    
    392a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00003930 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    3930:	f3 0f 1e fb          	endbr32 
    3934:	55                   	push   %ebp
    3935:	89 e5                	mov    %esp,%ebp
    3937:	57                   	push   %edi
    3938:	8b 45 10             	mov    0x10(%ebp),%eax
    393b:	8b 55 08             	mov    0x8(%ebp),%edx
    393e:	56                   	push   %esi
    393f:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    3942:	85 c0                	test   %eax,%eax
    3944:	7e 0f                	jle    3955 <memmove+0x25>
    3946:	01 d0                	add    %edx,%eax
  dst = vdst;
    3948:	89 d7                	mov    %edx,%edi
    394a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
    3950:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
    3951:	39 f8                	cmp    %edi,%eax
    3953:	75 fb                	jne    3950 <memmove+0x20>
  return vdst;
}
    3955:	5e                   	pop    %esi
    3956:	89 d0                	mov    %edx,%eax
    3958:	5f                   	pop    %edi
    3959:	5d                   	pop    %ebp
    395a:	c3                   	ret    

0000395b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    395b:	b8 01 00 00 00       	mov    $0x1,%eax
    3960:	cd 40                	int    $0x40
    3962:	c3                   	ret    

00003963 <exit>:
SYSCALL(exit)
    3963:	b8 02 00 00 00       	mov    $0x2,%eax
    3968:	cd 40                	int    $0x40
    396a:	c3                   	ret    

0000396b <wait>:
SYSCALL(wait)
    396b:	b8 03 00 00 00       	mov    $0x3,%eax
    3970:	cd 40                	int    $0x40
    3972:	c3                   	ret    

00003973 <pipe>:
SYSCALL(pipe)
    3973:	b8 04 00 00 00       	mov    $0x4,%eax
    3978:	cd 40                	int    $0x40
    397a:	c3                   	ret    

0000397b <read>:
SYSCALL(read)
    397b:	b8 05 00 00 00       	mov    $0x5,%eax
    3980:	cd 40                	int    $0x40
    3982:	c3                   	ret    

00003983 <write>:
SYSCALL(write)
    3983:	b8 10 00 00 00       	mov    $0x10,%eax
    3988:	cd 40                	int    $0x40
    398a:	c3                   	ret    

0000398b <close>:
SYSCALL(close)
    398b:	b8 15 00 00 00       	mov    $0x15,%eax
    3990:	cd 40                	int    $0x40
    3992:	c3                   	ret    

00003993 <kill>:
SYSCALL(kill)
    3993:	b8 06 00 00 00       	mov    $0x6,%eax
    3998:	cd 40                	int    $0x40
    399a:	c3                   	ret    

0000399b <exec>:
SYSCALL(exec)
    399b:	b8 07 00 00 00       	mov    $0x7,%eax
    39a0:	cd 40                	int    $0x40
    39a2:	c3                   	ret    

000039a3 <open>:
SYSCALL(open)
    39a3:	b8 0f 00 00 00       	mov    $0xf,%eax
    39a8:	cd 40                	int    $0x40
    39aa:	c3                   	ret    

000039ab <mknod>:
SYSCALL(mknod)
    39ab:	b8 11 00 00 00       	mov    $0x11,%eax
    39b0:	cd 40                	int    $0x40
    39b2:	c3                   	ret    

000039b3 <unlink>:
SYSCALL(unlink)
    39b3:	b8 12 00 00 00       	mov    $0x12,%eax
    39b8:	cd 40                	int    $0x40
    39ba:	c3                   	ret    

000039bb <fstat>:
SYSCALL(fstat)
    39bb:	b8 08 00 00 00       	mov    $0x8,%eax
    39c0:	cd 40                	int    $0x40
    39c2:	c3                   	ret    

000039c3 <link>:
SYSCALL(link)
    39c3:	b8 13 00 00 00       	mov    $0x13,%eax
    39c8:	cd 40                	int    $0x40
    39ca:	c3                   	ret    

000039cb <mkdir>:
SYSCALL(mkdir)
    39cb:	b8 14 00 00 00       	mov    $0x14,%eax
    39d0:	cd 40                	int    $0x40
    39d2:	c3                   	ret    

000039d3 <chdir>:
SYSCALL(chdir)
    39d3:	b8 09 00 00 00       	mov    $0x9,%eax
    39d8:	cd 40                	int    $0x40
    39da:	c3                   	ret    

000039db <dup>:
SYSCALL(dup)
    39db:	b8 0a 00 00 00       	mov    $0xa,%eax
    39e0:	cd 40                	int    $0x40
    39e2:	c3                   	ret    

000039e3 <getpid>:
SYSCALL(getpid)
    39e3:	b8 0b 00 00 00       	mov    $0xb,%eax
    39e8:	cd 40                	int    $0x40
    39ea:	c3                   	ret    

000039eb <sbrk>:
SYSCALL(sbrk)
    39eb:	b8 0c 00 00 00       	mov    $0xc,%eax
    39f0:	cd 40                	int    $0x40
    39f2:	c3                   	ret    

000039f3 <sleep>:
SYSCALL(sleep)
    39f3:	b8 0d 00 00 00       	mov    $0xd,%eax
    39f8:	cd 40                	int    $0x40
    39fa:	c3                   	ret    

000039fb <uptime>:
SYSCALL(uptime)
    39fb:	b8 0e 00 00 00       	mov    $0xe,%eax
    3a00:	cd 40                	int    $0x40
    3a02:	c3                   	ret    

00003a03 <sigprocmask>:
SYSCALL(sigprocmask)
    3a03:	b8 16 00 00 00       	mov    $0x16,%eax
    3a08:	cd 40                	int    $0x40
    3a0a:	c3                   	ret    

00003a0b <sigaction>:
SYSCALL(sigaction)
    3a0b:	b8 17 00 00 00       	mov    $0x17,%eax
    3a10:	cd 40                	int    $0x40
    3a12:	c3                   	ret    

00003a13 <sigret>:
SYSCALL(sigret)
    3a13:	b8 18 00 00 00       	mov    $0x18,%eax
    3a18:	cd 40                	int    $0x40
    3a1a:	c3                   	ret    
    3a1b:	66 90                	xchg   %ax,%ax
    3a1d:	66 90                	xchg   %ax,%ax
    3a1f:	90                   	nop

00003a20 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    3a20:	55                   	push   %ebp
    3a21:	89 e5                	mov    %esp,%ebp
    3a23:	57                   	push   %edi
    3a24:	56                   	push   %esi
    3a25:	53                   	push   %ebx
    3a26:	83 ec 3c             	sub    $0x3c,%esp
    3a29:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
    3a2c:	89 d1                	mov    %edx,%ecx
{
    3a2e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
    3a31:	85 d2                	test   %edx,%edx
    3a33:	0f 89 7f 00 00 00    	jns    3ab8 <printint+0x98>
    3a39:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
    3a3d:	74 79                	je     3ab8 <printint+0x98>
    neg = 1;
    3a3f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
    3a46:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
    3a48:	31 db                	xor    %ebx,%ebx
    3a4a:	8d 75 d7             	lea    -0x29(%ebp),%esi
    3a4d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
    3a50:	89 c8                	mov    %ecx,%eax
    3a52:	31 d2                	xor    %edx,%edx
    3a54:	89 cf                	mov    %ecx,%edi
    3a56:	f7 75 c4             	divl   -0x3c(%ebp)
    3a59:	0f b6 92 a8 55 00 00 	movzbl 0x55a8(%edx),%edx
    3a60:	89 45 c0             	mov    %eax,-0x40(%ebp)
    3a63:	89 d8                	mov    %ebx,%eax
    3a65:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
    3a68:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
    3a6b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
    3a6e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
    3a71:	76 dd                	jbe    3a50 <printint+0x30>
  if(neg)
    3a73:	8b 4d bc             	mov    -0x44(%ebp),%ecx
    3a76:	85 c9                	test   %ecx,%ecx
    3a78:	74 0c                	je     3a86 <printint+0x66>
    buf[i++] = '-';
    3a7a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
    3a7f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
    3a81:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
    3a86:	8b 7d b8             	mov    -0x48(%ebp),%edi
    3a89:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
    3a8d:	eb 07                	jmp    3a96 <printint+0x76>
    3a8f:	90                   	nop
    3a90:	0f b6 13             	movzbl (%ebx),%edx
    3a93:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
    3a96:	83 ec 04             	sub    $0x4,%esp
    3a99:	88 55 d7             	mov    %dl,-0x29(%ebp)
    3a9c:	6a 01                	push   $0x1
    3a9e:	56                   	push   %esi
    3a9f:	57                   	push   %edi
    3aa0:	e8 de fe ff ff       	call   3983 <write>
  while(--i >= 0)
    3aa5:	83 c4 10             	add    $0x10,%esp
    3aa8:	39 de                	cmp    %ebx,%esi
    3aaa:	75 e4                	jne    3a90 <printint+0x70>
    putc(fd, buf[i]);
}
    3aac:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3aaf:	5b                   	pop    %ebx
    3ab0:	5e                   	pop    %esi
    3ab1:	5f                   	pop    %edi
    3ab2:	5d                   	pop    %ebp
    3ab3:	c3                   	ret    
    3ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
    3ab8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
    3abf:	eb 87                	jmp    3a48 <printint+0x28>
    3ac1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3ac8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3acf:	90                   	nop

00003ad0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    3ad0:	f3 0f 1e fb          	endbr32 
    3ad4:	55                   	push   %ebp
    3ad5:	89 e5                	mov    %esp,%ebp
    3ad7:	57                   	push   %edi
    3ad8:	56                   	push   %esi
    3ad9:	53                   	push   %ebx
    3ada:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    3add:	8b 75 0c             	mov    0xc(%ebp),%esi
    3ae0:	0f b6 1e             	movzbl (%esi),%ebx
    3ae3:	84 db                	test   %bl,%bl
    3ae5:	0f 84 b4 00 00 00    	je     3b9f <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
    3aeb:	8d 45 10             	lea    0x10(%ebp),%eax
    3aee:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
    3af1:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
    3af4:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
    3af6:	89 45 d0             	mov    %eax,-0x30(%ebp)
    3af9:	eb 33                	jmp    3b2e <printf+0x5e>
    3afb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    3aff:	90                   	nop
    3b00:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
    3b03:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
    3b08:	83 f8 25             	cmp    $0x25,%eax
    3b0b:	74 17                	je     3b24 <printf+0x54>
  write(fd, &c, 1);
    3b0d:	83 ec 04             	sub    $0x4,%esp
    3b10:	88 5d e7             	mov    %bl,-0x19(%ebp)
    3b13:	6a 01                	push   $0x1
    3b15:	57                   	push   %edi
    3b16:	ff 75 08             	pushl  0x8(%ebp)
    3b19:	e8 65 fe ff ff       	call   3983 <write>
    3b1e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
    3b21:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
    3b24:	0f b6 1e             	movzbl (%esi),%ebx
    3b27:	83 c6 01             	add    $0x1,%esi
    3b2a:	84 db                	test   %bl,%bl
    3b2c:	74 71                	je     3b9f <printf+0xcf>
    c = fmt[i] & 0xff;
    3b2e:	0f be cb             	movsbl %bl,%ecx
    3b31:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
    3b34:	85 d2                	test   %edx,%edx
    3b36:	74 c8                	je     3b00 <printf+0x30>
      }
    } else if(state == '%'){
    3b38:	83 fa 25             	cmp    $0x25,%edx
    3b3b:	75 e7                	jne    3b24 <printf+0x54>
      if(c == 'd'){
    3b3d:	83 f8 64             	cmp    $0x64,%eax
    3b40:	0f 84 9a 00 00 00    	je     3be0 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    3b46:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
    3b4c:	83 f9 70             	cmp    $0x70,%ecx
    3b4f:	74 5f                	je     3bb0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    3b51:	83 f8 73             	cmp    $0x73,%eax
    3b54:	0f 84 d6 00 00 00    	je     3c30 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    3b5a:	83 f8 63             	cmp    $0x63,%eax
    3b5d:	0f 84 8d 00 00 00    	je     3bf0 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    3b63:	83 f8 25             	cmp    $0x25,%eax
    3b66:	0f 84 b4 00 00 00    	je     3c20 <printf+0x150>
  write(fd, &c, 1);
    3b6c:	83 ec 04             	sub    $0x4,%esp
    3b6f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    3b73:	6a 01                	push   $0x1
    3b75:	57                   	push   %edi
    3b76:	ff 75 08             	pushl  0x8(%ebp)
    3b79:	e8 05 fe ff ff       	call   3983 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
    3b7e:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
    3b81:	83 c4 0c             	add    $0xc,%esp
    3b84:	6a 01                	push   $0x1
    3b86:	83 c6 01             	add    $0x1,%esi
    3b89:	57                   	push   %edi
    3b8a:	ff 75 08             	pushl  0x8(%ebp)
    3b8d:	e8 f1 fd ff ff       	call   3983 <write>
  for(i = 0; fmt[i]; i++){
    3b92:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
    3b96:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    3b99:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
    3b9b:	84 db                	test   %bl,%bl
    3b9d:	75 8f                	jne    3b2e <printf+0x5e>
    }
  }
}
    3b9f:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3ba2:	5b                   	pop    %ebx
    3ba3:	5e                   	pop    %esi
    3ba4:	5f                   	pop    %edi
    3ba5:	5d                   	pop    %ebp
    3ba6:	c3                   	ret    
    3ba7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3bae:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
    3bb0:	83 ec 0c             	sub    $0xc,%esp
    3bb3:	b9 10 00 00 00       	mov    $0x10,%ecx
    3bb8:	6a 00                	push   $0x0
    3bba:	8b 5d d0             	mov    -0x30(%ebp),%ebx
    3bbd:	8b 45 08             	mov    0x8(%ebp),%eax
    3bc0:	8b 13                	mov    (%ebx),%edx
    3bc2:	e8 59 fe ff ff       	call   3a20 <printint>
        ap++;
    3bc7:	89 d8                	mov    %ebx,%eax
    3bc9:	83 c4 10             	add    $0x10,%esp
      state = 0;
    3bcc:	31 d2                	xor    %edx,%edx
        ap++;
    3bce:	83 c0 04             	add    $0x4,%eax
    3bd1:	89 45 d0             	mov    %eax,-0x30(%ebp)
    3bd4:	e9 4b ff ff ff       	jmp    3b24 <printf+0x54>
    3bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
    3be0:	83 ec 0c             	sub    $0xc,%esp
    3be3:	b9 0a 00 00 00       	mov    $0xa,%ecx
    3be8:	6a 01                	push   $0x1
    3bea:	eb ce                	jmp    3bba <printf+0xea>
    3bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
    3bf0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
    3bf3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
    3bf6:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
    3bf8:	6a 01                	push   $0x1
        ap++;
    3bfa:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
    3bfd:	57                   	push   %edi
    3bfe:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
    3c01:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    3c04:	e8 7a fd ff ff       	call   3983 <write>
        ap++;
    3c09:	89 5d d0             	mov    %ebx,-0x30(%ebp)
    3c0c:	83 c4 10             	add    $0x10,%esp
      state = 0;
    3c0f:	31 d2                	xor    %edx,%edx
    3c11:	e9 0e ff ff ff       	jmp    3b24 <printf+0x54>
    3c16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3c1d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
    3c20:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
    3c23:	83 ec 04             	sub    $0x4,%esp
    3c26:	e9 59 ff ff ff       	jmp    3b84 <printf+0xb4>
    3c2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    3c2f:	90                   	nop
        s = (char*)*ap;
    3c30:	8b 45 d0             	mov    -0x30(%ebp),%eax
    3c33:	8b 18                	mov    (%eax),%ebx
        ap++;
    3c35:	83 c0 04             	add    $0x4,%eax
    3c38:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
    3c3b:	85 db                	test   %ebx,%ebx
    3c3d:	74 17                	je     3c56 <printf+0x186>
        while(*s != 0){
    3c3f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
    3c42:	31 d2                	xor    %edx,%edx
        while(*s != 0){
    3c44:	84 c0                	test   %al,%al
    3c46:	0f 84 d8 fe ff ff    	je     3b24 <printf+0x54>
    3c4c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    3c4f:	89 de                	mov    %ebx,%esi
    3c51:	8b 5d 08             	mov    0x8(%ebp),%ebx
    3c54:	eb 1a                	jmp    3c70 <printf+0x1a0>
          s = "(null)";
    3c56:	bb a1 55 00 00       	mov    $0x55a1,%ebx
        while(*s != 0){
    3c5b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    3c5e:	b8 28 00 00 00       	mov    $0x28,%eax
    3c63:	89 de                	mov    %ebx,%esi
    3c65:	8b 5d 08             	mov    0x8(%ebp),%ebx
    3c68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3c6f:	90                   	nop
  write(fd, &c, 1);
    3c70:	83 ec 04             	sub    $0x4,%esp
          s++;
    3c73:	83 c6 01             	add    $0x1,%esi
    3c76:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    3c79:	6a 01                	push   $0x1
    3c7b:	57                   	push   %edi
    3c7c:	53                   	push   %ebx
    3c7d:	e8 01 fd ff ff       	call   3983 <write>
        while(*s != 0){
    3c82:	0f b6 06             	movzbl (%esi),%eax
    3c85:	83 c4 10             	add    $0x10,%esp
    3c88:	84 c0                	test   %al,%al
    3c8a:	75 e4                	jne    3c70 <printf+0x1a0>
    3c8c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
    3c8f:	31 d2                	xor    %edx,%edx
    3c91:	e9 8e fe ff ff       	jmp    3b24 <printf+0x54>
    3c96:	66 90                	xchg   %ax,%ax
    3c98:	66 90                	xchg   %ax,%ax
    3c9a:	66 90                	xchg   %ax,%ax
    3c9c:	66 90                	xchg   %ax,%ax
    3c9e:	66 90                	xchg   %ax,%ax

00003ca0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    3ca0:	f3 0f 1e fb          	endbr32 
    3ca4:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3ca5:	a1 40 5f 00 00       	mov    0x5f40,%eax
{
    3caa:	89 e5                	mov    %esp,%ebp
    3cac:	57                   	push   %edi
    3cad:	56                   	push   %esi
    3cae:	53                   	push   %ebx
    3caf:	8b 5d 08             	mov    0x8(%ebp),%ebx
    3cb2:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
    3cb4:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3cb7:	39 c8                	cmp    %ecx,%eax
    3cb9:	73 15                	jae    3cd0 <free+0x30>
    3cbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    3cbf:	90                   	nop
    3cc0:	39 d1                	cmp    %edx,%ecx
    3cc2:	72 14                	jb     3cd8 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    3cc4:	39 d0                	cmp    %edx,%eax
    3cc6:	73 10                	jae    3cd8 <free+0x38>
{
    3cc8:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3cca:	8b 10                	mov    (%eax),%edx
    3ccc:	39 c8                	cmp    %ecx,%eax
    3cce:	72 f0                	jb     3cc0 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    3cd0:	39 d0                	cmp    %edx,%eax
    3cd2:	72 f4                	jb     3cc8 <free+0x28>
    3cd4:	39 d1                	cmp    %edx,%ecx
    3cd6:	73 f0                	jae    3cc8 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
    3cd8:	8b 73 fc             	mov    -0x4(%ebx),%esi
    3cdb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    3cde:	39 fa                	cmp    %edi,%edx
    3ce0:	74 1e                	je     3d00 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    3ce2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    3ce5:	8b 50 04             	mov    0x4(%eax),%edx
    3ce8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    3ceb:	39 f1                	cmp    %esi,%ecx
    3ced:	74 28                	je     3d17 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    3cef:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
    3cf1:	5b                   	pop    %ebx
  freep = p;
    3cf2:	a3 40 5f 00 00       	mov    %eax,0x5f40
}
    3cf7:	5e                   	pop    %esi
    3cf8:	5f                   	pop    %edi
    3cf9:	5d                   	pop    %ebp
    3cfa:	c3                   	ret    
    3cfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    3cff:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
    3d00:	03 72 04             	add    0x4(%edx),%esi
    3d03:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    3d06:	8b 10                	mov    (%eax),%edx
    3d08:	8b 12                	mov    (%edx),%edx
    3d0a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    3d0d:	8b 50 04             	mov    0x4(%eax),%edx
    3d10:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    3d13:	39 f1                	cmp    %esi,%ecx
    3d15:	75 d8                	jne    3cef <free+0x4f>
    p->s.size += bp->s.size;
    3d17:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
    3d1a:	a3 40 5f 00 00       	mov    %eax,0x5f40
    p->s.size += bp->s.size;
    3d1f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    3d22:	8b 53 f8             	mov    -0x8(%ebx),%edx
    3d25:	89 10                	mov    %edx,(%eax)
}
    3d27:	5b                   	pop    %ebx
    3d28:	5e                   	pop    %esi
    3d29:	5f                   	pop    %edi
    3d2a:	5d                   	pop    %ebp
    3d2b:	c3                   	ret    
    3d2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00003d30 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    3d30:	f3 0f 1e fb          	endbr32 
    3d34:	55                   	push   %ebp
    3d35:	89 e5                	mov    %esp,%ebp
    3d37:	57                   	push   %edi
    3d38:	56                   	push   %esi
    3d39:	53                   	push   %ebx
    3d3a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    3d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    3d40:	8b 3d 40 5f 00 00    	mov    0x5f40,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    3d46:	8d 70 07             	lea    0x7(%eax),%esi
    3d49:	c1 ee 03             	shr    $0x3,%esi
    3d4c:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
    3d4f:	85 ff                	test   %edi,%edi
    3d51:	0f 84 a9 00 00 00    	je     3e00 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    3d57:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
    3d59:	8b 48 04             	mov    0x4(%eax),%ecx
    3d5c:	39 f1                	cmp    %esi,%ecx
    3d5e:	73 6d                	jae    3dcd <malloc+0x9d>
    3d60:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
    3d66:	bb 00 10 00 00       	mov    $0x1000,%ebx
    3d6b:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
    3d6e:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
    3d75:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    3d78:	eb 17                	jmp    3d91 <malloc+0x61>
    3d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    3d80:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
    3d82:	8b 4a 04             	mov    0x4(%edx),%ecx
    3d85:	39 f1                	cmp    %esi,%ecx
    3d87:	73 4f                	jae    3dd8 <malloc+0xa8>
    3d89:	8b 3d 40 5f 00 00    	mov    0x5f40,%edi
    3d8f:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    3d91:	39 c7                	cmp    %eax,%edi
    3d93:	75 eb                	jne    3d80 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
    3d95:	83 ec 0c             	sub    $0xc,%esp
    3d98:	ff 75 e4             	pushl  -0x1c(%ebp)
    3d9b:	e8 4b fc ff ff       	call   39eb <sbrk>
  if(p == (char*)-1)
    3da0:	83 c4 10             	add    $0x10,%esp
    3da3:	83 f8 ff             	cmp    $0xffffffff,%eax
    3da6:	74 1b                	je     3dc3 <malloc+0x93>
  hp->s.size = nu;
    3da8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    3dab:	83 ec 0c             	sub    $0xc,%esp
    3dae:	83 c0 08             	add    $0x8,%eax
    3db1:	50                   	push   %eax
    3db2:	e8 e9 fe ff ff       	call   3ca0 <free>
  return freep;
    3db7:	a1 40 5f 00 00       	mov    0x5f40,%eax
      if((p = morecore(nunits)) == 0)
    3dbc:	83 c4 10             	add    $0x10,%esp
    3dbf:	85 c0                	test   %eax,%eax
    3dc1:	75 bd                	jne    3d80 <malloc+0x50>
        return 0;
  }
}
    3dc3:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
    3dc6:	31 c0                	xor    %eax,%eax
}
    3dc8:	5b                   	pop    %ebx
    3dc9:	5e                   	pop    %esi
    3dca:	5f                   	pop    %edi
    3dcb:	5d                   	pop    %ebp
    3dcc:	c3                   	ret    
    if(p->s.size >= nunits){
    3dcd:	89 c2                	mov    %eax,%edx
    3dcf:	89 f8                	mov    %edi,%eax
    3dd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
    3dd8:	39 ce                	cmp    %ecx,%esi
    3dda:	74 54                	je     3e30 <malloc+0x100>
        p->s.size -= nunits;
    3ddc:	29 f1                	sub    %esi,%ecx
    3dde:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
    3de1:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
    3de4:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
    3de7:	a3 40 5f 00 00       	mov    %eax,0x5f40
}
    3dec:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
    3def:	8d 42 08             	lea    0x8(%edx),%eax
}
    3df2:	5b                   	pop    %ebx
    3df3:	5e                   	pop    %esi
    3df4:	5f                   	pop    %edi
    3df5:	5d                   	pop    %ebp
    3df6:	c3                   	ret    
    3df7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3dfe:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
    3e00:	c7 05 40 5f 00 00 44 	movl   $0x5f44,0x5f40
    3e07:	5f 00 00 
    base.s.size = 0;
    3e0a:	bf 44 5f 00 00       	mov    $0x5f44,%edi
    base.s.ptr = freep = prevp = &base;
    3e0f:	c7 05 44 5f 00 00 44 	movl   $0x5f44,0x5f44
    3e16:	5f 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    3e19:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
    3e1b:	c7 05 48 5f 00 00 00 	movl   $0x0,0x5f48
    3e22:	00 00 00 
    if(p->s.size >= nunits){
    3e25:	e9 36 ff ff ff       	jmp    3d60 <malloc+0x30>
    3e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
    3e30:	8b 0a                	mov    (%edx),%ecx
    3e32:	89 08                	mov    %ecx,(%eax)
    3e34:	eb b1                	jmp    3de7 <malloc+0xb7>
