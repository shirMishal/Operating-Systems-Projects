
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
  printf(1, "usertests starting\n");
      15:	68 26 54 00 00       	push   $0x5426
      1a:	6a 01                	push   $0x1
      1c:	e8 af 40 00 00       	call   40d0 <printf>

  if(open("usertests.ran", 0) >= 0){
      21:	59                   	pop    %ecx
      22:	58                   	pop    %eax
      23:	6a 00                	push   $0x0
      25:	68 3a 54 00 00       	push   $0x543a
      2a:	e8 64 3f 00 00       	call   3f93 <open>
      2f:	83 c4 10             	add    $0x10,%esp
      32:	85 c0                	test   %eax,%eax
      34:	78 1a                	js     50 <main+0x50>
    printf(1, "already ran user tests -- rebuild fs.img\n");
      36:	52                   	push   %edx
      37:	52                   	push   %edx
      38:	68 a4 5b 00 00       	push   $0x5ba4
      3d:	6a 01                	push   $0x1
      3f:	e8 8c 40 00 00       	call   40d0 <printf>
    exit(1);
      44:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      4b:	e8 03 3f 00 00       	call   3f53 <exit>
  }
  close(open("usertests.ran", O_CREATE));
      50:	50                   	push   %eax
      51:	50                   	push   %eax
      52:	68 00 02 00 00       	push   $0x200
      57:	68 3a 54 00 00       	push   $0x543a
      5c:	e8 32 3f 00 00       	call   3f93 <open>
      61:	89 04 24             	mov    %eax,(%esp)
      64:	e8 12 3f 00 00       	call   3f7b <close>

  argptest();
      69:	e8 e2 3b 00 00       	call   3c50 <argptest>
  createdelete();
      6e:	e8 ad 13 00 00       	call   1420 <createdelete>
  linkunlink();
      73:	e8 78 1d 00 00       	call   1df0 <linkunlink>
  concreate();
      78:	e8 43 1a 00 00       	call   1ac0 <concreate>
  fourfiles();
      7d:	e8 5e 11 00 00       	call   11e0 <fourfiles>
  sharedfd();
      82:	e8 99 0f 00 00       	call   1020 <sharedfd>

  bigargtest();
      87:	e8 34 38 00 00       	call   38c0 <bigargtest>
  bigwrite();
      8c:	e8 bf 27 00 00       	call   2850 <bigwrite>
  bigargtest();
      91:	e8 2a 38 00 00       	call   38c0 <bigargtest>
  bsstest();
      96:	e8 b5 37 00 00       	call   3850 <bsstest>
  sbrktest();
      9b:	e8 20 32 00 00       	call   32c0 <sbrktest>
  validatetest();
      a0:	e8 db 36 00 00       	call   3780 <validatetest>

  opentest();
      a5:	e8 e6 03 00 00       	call   490 <opentest>
  writetest();
      aa:	e8 91 04 00 00       	call   540 <writetest>
  writetest1();
      af:	e8 9c 06 00 00       	call   750 <writetest1>
  createtest();
      b4:	e8 97 08 00 00       	call   950 <createtest>

  openiputtest();
      b9:	e8 a2 02 00 00       	call   360 <openiputtest>
  exitiputtest();
      be:	e8 6d 01 00 00       	call   230 <exitiputtest>
  iputtest();
      c3:	e8 68 00 00 00       	call   130 <iputtest>

  mem();
      c8:	e8 63 0e 00 00       	call   f30 <mem>
  pipe1();
      cd:	e8 9e 0a 00 00       	call   b70 <pipe1>
  preempt();
      d2:	e8 59 0c 00 00       	call   d30 <preempt>
  exitwait();
      d7:	e8 c4 0d 00 00       	call   ea0 <exitwait>

  rmdot();
      dc:	e8 cf 2b 00 00       	call   2cb0 <rmdot>
  fourteen();
      e1:	e8 5a 2a 00 00       	call   2b40 <fourteen>
  bigfile();
      e6:	e8 55 28 00 00       	call   2940 <bigfile>
  subdir();
      eb:	e8 80 1f 00 00       	call   2070 <subdir>
  linktest();
      f0:	e8 6b 17 00 00       	call   1860 <linktest>
  unlinkread();
      f5:	e8 a6 15 00 00       	call   16a0 <unlinkread>
  dirfile();
      fa:	e8 71 2d 00 00       	call   2e70 <dirfile>
  iref();
      ff:	e8 ac 2f 00 00       	call   30b0 <iref>
  forktest();
     104:	e8 d7 30 00 00       	call   31e0 <forktest>
  bigdir(); // slow
     109:	e8 02 1e 00 00       	call   1f10 <bigdir>

  uio();
     10e:	e8 ad 3a 00 00       	call   3bc0 <uio>

  exectest();
     113:	e8 f8 09 00 00       	call   b10 <exectest>

  exit(0);
     118:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     11f:	e8 2f 3e 00 00       	call   3f53 <exit>
     124:	66 90                	xchg   %ax,%ax
     126:	66 90                	xchg   %ax,%ax
     128:	66 90                	xchg   %ax,%ax
     12a:	66 90                	xchg   %ax,%ax
     12c:	66 90                	xchg   %ax,%ax
     12e:	66 90                	xchg   %ax,%ax

00000130 <iputtest>:
{
     130:	f3 0f 1e fb          	endbr32 
     134:	55                   	push   %ebp
     135:	89 e5                	mov    %esp,%ebp
     137:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "iput test\n");
     13a:	68 cc 44 00 00       	push   $0x44cc
     13f:	ff 35 d0 64 00 00    	pushl  0x64d0
     145:	e8 86 3f 00 00       	call   40d0 <printf>
  if(mkdir("iputdir") < 0){
     14a:	c7 04 24 5f 44 00 00 	movl   $0x445f,(%esp)
     151:	e8 65 3e 00 00       	call   3fbb <mkdir>
     156:	83 c4 10             	add    $0x10,%esp
     159:	85 c0                	test   %eax,%eax
     15b:	78 58                	js     1b5 <iputtest+0x85>
  if(chdir("iputdir") < 0){
     15d:	83 ec 0c             	sub    $0xc,%esp
     160:	68 5f 44 00 00       	push   $0x445f
     165:	e8 59 3e 00 00       	call   3fc3 <chdir>
     16a:	83 c4 10             	add    $0x10,%esp
     16d:	85 c0                	test   %eax,%eax
     16f:	0f 88 9a 00 00 00    	js     20f <iputtest+0xdf>
  if(unlink("../iputdir") < 0){
     175:	83 ec 0c             	sub    $0xc,%esp
     178:	68 5c 44 00 00       	push   $0x445c
     17d:	e8 21 3e 00 00       	call   3fa3 <unlink>
     182:	83 c4 10             	add    $0x10,%esp
     185:	85 c0                	test   %eax,%eax
     187:	78 68                	js     1f1 <iputtest+0xc1>
  if(chdir("/") < 0){
     189:	83 ec 0c             	sub    $0xc,%esp
     18c:	68 81 44 00 00       	push   $0x4481
     191:	e8 2d 3e 00 00       	call   3fc3 <chdir>
     196:	83 c4 10             	add    $0x10,%esp
     199:	85 c0                	test   %eax,%eax
     19b:	78 36                	js     1d3 <iputtest+0xa3>
  printf(stdout, "iput test ok\n");
     19d:	83 ec 08             	sub    $0x8,%esp
     1a0:	68 04 45 00 00       	push   $0x4504
     1a5:	ff 35 d0 64 00 00    	pushl  0x64d0
     1ab:	e8 20 3f 00 00       	call   40d0 <printf>
}
     1b0:	83 c4 10             	add    $0x10,%esp
     1b3:	c9                   	leave  
     1b4:	c3                   	ret    
    printf(stdout, "mkdir failed\n");
     1b5:	50                   	push   %eax
     1b6:	50                   	push   %eax
     1b7:	68 38 44 00 00       	push   $0x4438
     1bc:	ff 35 d0 64 00 00    	pushl  0x64d0
     1c2:	e8 09 3f 00 00       	call   40d0 <printf>
    exit(1);
     1c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     1ce:	e8 80 3d 00 00       	call   3f53 <exit>
    printf(stdout, "chdir / failed\n");
     1d3:	50                   	push   %eax
     1d4:	50                   	push   %eax
     1d5:	68 83 44 00 00       	push   $0x4483
     1da:	ff 35 d0 64 00 00    	pushl  0x64d0
     1e0:	e8 eb 3e 00 00       	call   40d0 <printf>
    exit(1);
     1e5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     1ec:	e8 62 3d 00 00       	call   3f53 <exit>
    printf(stdout, "unlink ../iputdir failed\n");
     1f1:	52                   	push   %edx
     1f2:	52                   	push   %edx
     1f3:	68 67 44 00 00       	push   $0x4467
     1f8:	ff 35 d0 64 00 00    	pushl  0x64d0
     1fe:	e8 cd 3e 00 00       	call   40d0 <printf>
    exit(1);
     203:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     20a:	e8 44 3d 00 00       	call   3f53 <exit>
    printf(stdout, "chdir iputdir failed\n");
     20f:	51                   	push   %ecx
     210:	51                   	push   %ecx
     211:	68 46 44 00 00       	push   $0x4446
     216:	ff 35 d0 64 00 00    	pushl  0x64d0
     21c:	e8 af 3e 00 00       	call   40d0 <printf>
    exit(1);
     221:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     228:	e8 26 3d 00 00       	call   3f53 <exit>
     22d:	8d 76 00             	lea    0x0(%esi),%esi

00000230 <exitiputtest>:
{
     230:	f3 0f 1e fb          	endbr32 
     234:	55                   	push   %ebp
     235:	89 e5                	mov    %esp,%ebp
     237:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "exitiput test\n");
     23a:	68 93 44 00 00       	push   $0x4493
     23f:	ff 35 d0 64 00 00    	pushl  0x64d0
     245:	e8 86 3e 00 00       	call   40d0 <printf>
  pid = fork();
     24a:	e8 fc 3c 00 00       	call   3f4b <fork>
  if(pid < 0){
     24f:	83 c4 10             	add    $0x10,%esp
     252:	85 c0                	test   %eax,%eax
     254:	0f 88 9d 00 00 00    	js     2f7 <exitiputtest+0xc7>
  if(pid == 0){
     25a:	75 54                	jne    2b0 <exitiputtest+0x80>
    if(mkdir("iputdir") < 0){
     25c:	83 ec 0c             	sub    $0xc,%esp
     25f:	68 5f 44 00 00       	push   $0x445f
     264:	e8 52 3d 00 00       	call   3fbb <mkdir>
     269:	83 c4 10             	add    $0x10,%esp
     26c:	85 c0                	test   %eax,%eax
     26e:	0f 88 a1 00 00 00    	js     315 <exitiputtest+0xe5>
    if(chdir("iputdir") < 0){
     274:	83 ec 0c             	sub    $0xc,%esp
     277:	68 5f 44 00 00       	push   $0x445f
     27c:	e8 42 3d 00 00       	call   3fc3 <chdir>
     281:	83 c4 10             	add    $0x10,%esp
     284:	85 c0                	test   %eax,%eax
     286:	0f 88 a7 00 00 00    	js     333 <exitiputtest+0x103>
    if(unlink("../iputdir") < 0){
     28c:	83 ec 0c             	sub    $0xc,%esp
     28f:	68 5c 44 00 00       	push   $0x445c
     294:	e8 0a 3d 00 00       	call   3fa3 <unlink>
     299:	83 c4 10             	add    $0x10,%esp
     29c:	85 c0                	test   %eax,%eax
     29e:	78 38                	js     2d8 <exitiputtest+0xa8>
    exit(1);
     2a0:	83 ec 0c             	sub    $0xc,%esp
     2a3:	6a 01                	push   $0x1
     2a5:	e8 a9 3c 00 00       	call   3f53 <exit>
     2aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  wait(null);
     2b0:	83 ec 0c             	sub    $0xc,%esp
     2b3:	6a 00                	push   $0x0
     2b5:	e8 a1 3c 00 00       	call   3f5b <wait>
  printf(stdout, "exitiput test ok\n");
     2ba:	58                   	pop    %eax
     2bb:	5a                   	pop    %edx
     2bc:	68 b6 44 00 00       	push   $0x44b6
     2c1:	ff 35 d0 64 00 00    	pushl  0x64d0
     2c7:	e8 04 3e 00 00       	call   40d0 <printf>
}
     2cc:	83 c4 10             	add    $0x10,%esp
     2cf:	c9                   	leave  
     2d0:	c3                   	ret    
     2d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      printf(stdout, "unlink ../iputdir failed\n");
     2d8:	83 ec 08             	sub    $0x8,%esp
     2db:	68 67 44 00 00       	push   $0x4467
     2e0:	ff 35 d0 64 00 00    	pushl  0x64d0
     2e6:	e8 e5 3d 00 00       	call   40d0 <printf>
      exit(1);
     2eb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     2f2:	e8 5c 3c 00 00       	call   3f53 <exit>
    printf(stdout, "fork failed\n");
     2f7:	50                   	push   %eax
     2f8:	50                   	push   %eax
     2f9:	68 79 53 00 00       	push   $0x5379
     2fe:	ff 35 d0 64 00 00    	pushl  0x64d0
     304:	e8 c7 3d 00 00       	call   40d0 <printf>
    exit(1);
     309:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     310:	e8 3e 3c 00 00       	call   3f53 <exit>
      printf(stdout, "mkdir failed\n");
     315:	50                   	push   %eax
     316:	50                   	push   %eax
     317:	68 38 44 00 00       	push   $0x4438
     31c:	ff 35 d0 64 00 00    	pushl  0x64d0
     322:	e8 a9 3d 00 00       	call   40d0 <printf>
      exit(1);
     327:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     32e:	e8 20 3c 00 00       	call   3f53 <exit>
      printf(stdout, "child chdir failed\n");
     333:	51                   	push   %ecx
     334:	51                   	push   %ecx
     335:	68 a2 44 00 00       	push   $0x44a2
     33a:	ff 35 d0 64 00 00    	pushl  0x64d0
     340:	e8 8b 3d 00 00       	call   40d0 <printf>
      exit(1);
     345:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     34c:	e8 02 3c 00 00       	call   3f53 <exit>
     351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     358:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     35f:	90                   	nop

00000360 <openiputtest>:
{
     360:	f3 0f 1e fb          	endbr32 
     364:	55                   	push   %ebp
     365:	89 e5                	mov    %esp,%ebp
     367:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "openiput test\n");
     36a:	68 c8 44 00 00       	push   $0x44c8
     36f:	ff 35 d0 64 00 00    	pushl  0x64d0
     375:	e8 56 3d 00 00       	call   40d0 <printf>
  if(mkdir("oidir") < 0){
     37a:	c7 04 24 d7 44 00 00 	movl   $0x44d7,(%esp)
     381:	e8 35 3c 00 00       	call   3fbb <mkdir>
     386:	83 c4 10             	add    $0x10,%esp
     389:	85 c0                	test   %eax,%eax
     38b:	0f 88 b7 00 00 00    	js     448 <openiputtest+0xe8>
  pid = fork();
     391:	e8 b5 3b 00 00       	call   3f4b <fork>
  if(pid < 0){
     396:	85 c0                	test   %eax,%eax
     398:	0f 88 8c 00 00 00    	js     42a <openiputtest+0xca>
  if(pid == 0){
     39e:	75 38                	jne    3d8 <openiputtest+0x78>
    int fd = open("oidir", O_RDWR);
     3a0:	83 ec 08             	sub    $0x8,%esp
     3a3:	6a 02                	push   $0x2
     3a5:	68 d7 44 00 00       	push   $0x44d7
     3aa:	e8 e4 3b 00 00       	call   3f93 <open>
    if(fd >= 0){
     3af:	83 c4 10             	add    $0x10,%esp
     3b2:	85 c0                	test   %eax,%eax
     3b4:	78 6a                	js     420 <openiputtest+0xc0>
      printf(stdout, "open directory for write succeeded\n");
     3b6:	83 ec 08             	sub    $0x8,%esp
     3b9:	68 5c 54 00 00       	push   $0x545c
     3be:	ff 35 d0 64 00 00    	pushl  0x64d0
     3c4:	e8 07 3d 00 00       	call   40d0 <printf>
      exit(1);
     3c9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     3d0:	e8 7e 3b 00 00       	call   3f53 <exit>
     3d5:	8d 76 00             	lea    0x0(%esi),%esi
  sleep(1);
     3d8:	83 ec 0c             	sub    $0xc,%esp
     3db:	6a 01                	push   $0x1
     3dd:	e8 01 3c 00 00       	call   3fe3 <sleep>
  if(unlink("oidir") != 0){
     3e2:	c7 04 24 d7 44 00 00 	movl   $0x44d7,(%esp)
     3e9:	e8 b5 3b 00 00       	call   3fa3 <unlink>
     3ee:	83 c4 10             	add    $0x10,%esp
     3f1:	85 c0                	test   %eax,%eax
     3f3:	75 71                	jne    466 <openiputtest+0x106>
  wait(null);
     3f5:	83 ec 0c             	sub    $0xc,%esp
     3f8:	6a 00                	push   $0x0
     3fa:	e8 5c 3b 00 00       	call   3f5b <wait>
  printf(stdout, "openiput test ok\n");
     3ff:	58                   	pop    %eax
     400:	5a                   	pop    %edx
     401:	68 00 45 00 00       	push   $0x4500
     406:	ff 35 d0 64 00 00    	pushl  0x64d0
     40c:	e8 bf 3c 00 00       	call   40d0 <printf>
}
     411:	83 c4 10             	add    $0x10,%esp
     414:	c9                   	leave  
     415:	c3                   	ret    
     416:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     41d:	8d 76 00             	lea    0x0(%esi),%esi
    exit(1);
     420:	83 ec 0c             	sub    $0xc,%esp
     423:	6a 01                	push   $0x1
     425:	e8 29 3b 00 00       	call   3f53 <exit>
    printf(stdout, "fork failed\n");
     42a:	50                   	push   %eax
     42b:	50                   	push   %eax
     42c:	68 79 53 00 00       	push   $0x5379
     431:	ff 35 d0 64 00 00    	pushl  0x64d0
     437:	e8 94 3c 00 00       	call   40d0 <printf>
    exit(1);
     43c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     443:	e8 0b 3b 00 00       	call   3f53 <exit>
    printf(stdout, "mkdir oidir failed\n");
     448:	50                   	push   %eax
     449:	50                   	push   %eax
     44a:	68 dd 44 00 00       	push   $0x44dd
     44f:	ff 35 d0 64 00 00    	pushl  0x64d0
     455:	e8 76 3c 00 00       	call   40d0 <printf>
    exit(1);
     45a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     461:	e8 ed 3a 00 00       	call   3f53 <exit>
    printf(stdout, "unlink failed\n");
     466:	51                   	push   %ecx
     467:	51                   	push   %ecx
     468:	68 f1 44 00 00       	push   $0x44f1
     46d:	ff 35 d0 64 00 00    	pushl  0x64d0
     473:	e8 58 3c 00 00       	call   40d0 <printf>
    exit(1);
     478:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     47f:	e8 cf 3a 00 00       	call   3f53 <exit>
     484:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     48b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     48f:	90                   	nop

00000490 <opentest>:
{
     490:	f3 0f 1e fb          	endbr32 
     494:	55                   	push   %ebp
     495:	89 e5                	mov    %esp,%ebp
     497:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "open test\n");
     49a:	68 12 45 00 00       	push   $0x4512
     49f:	ff 35 d0 64 00 00    	pushl  0x64d0
     4a5:	e8 26 3c 00 00       	call   40d0 <printf>
  fd = open("echo", 0);
     4aa:	58                   	pop    %eax
     4ab:	5a                   	pop    %edx
     4ac:	6a 00                	push   $0x0
     4ae:	68 1d 45 00 00       	push   $0x451d
     4b3:	e8 db 3a 00 00       	call   3f93 <open>
  if(fd < 0){
     4b8:	83 c4 10             	add    $0x10,%esp
     4bb:	85 c0                	test   %eax,%eax
     4bd:	78 36                	js     4f5 <opentest+0x65>
  close(fd);
     4bf:	83 ec 0c             	sub    $0xc,%esp
     4c2:	50                   	push   %eax
     4c3:	e8 b3 3a 00 00       	call   3f7b <close>
  fd = open("doesnotexist", 0);
     4c8:	5a                   	pop    %edx
     4c9:	59                   	pop    %ecx
     4ca:	6a 00                	push   $0x0
     4cc:	68 35 45 00 00       	push   $0x4535
     4d1:	e8 bd 3a 00 00       	call   3f93 <open>
  if(fd >= 0){
     4d6:	83 c4 10             	add    $0x10,%esp
     4d9:	85 c0                	test   %eax,%eax
     4db:	79 36                	jns    513 <opentest+0x83>
  printf(stdout, "open test ok\n");
     4dd:	83 ec 08             	sub    $0x8,%esp
     4e0:	68 60 45 00 00       	push   $0x4560
     4e5:	ff 35 d0 64 00 00    	pushl  0x64d0
     4eb:	e8 e0 3b 00 00       	call   40d0 <printf>
}
     4f0:	83 c4 10             	add    $0x10,%esp
     4f3:	c9                   	leave  
     4f4:	c3                   	ret    
    printf(stdout, "open echo failed!\n");
     4f5:	50                   	push   %eax
     4f6:	50                   	push   %eax
     4f7:	68 22 45 00 00       	push   $0x4522
     4fc:	ff 35 d0 64 00 00    	pushl  0x64d0
     502:	e8 c9 3b 00 00       	call   40d0 <printf>
    exit(1);
     507:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     50e:	e8 40 3a 00 00       	call   3f53 <exit>
    printf(stdout, "open doesnotexist succeeded!\n");
     513:	50                   	push   %eax
     514:	50                   	push   %eax
     515:	68 42 45 00 00       	push   $0x4542
     51a:	ff 35 d0 64 00 00    	pushl  0x64d0
     520:	e8 ab 3b 00 00       	call   40d0 <printf>
    exit(1);
     525:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     52c:	e8 22 3a 00 00       	call   3f53 <exit>
     531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     538:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     53f:	90                   	nop

00000540 <writetest>:
{
     540:	f3 0f 1e fb          	endbr32 
     544:	55                   	push   %ebp
     545:	89 e5                	mov    %esp,%ebp
     547:	56                   	push   %esi
     548:	53                   	push   %ebx
  printf(stdout, "small file test\n");
     549:	83 ec 08             	sub    $0x8,%esp
     54c:	68 6e 45 00 00       	push   $0x456e
     551:	ff 35 d0 64 00 00    	pushl  0x64d0
     557:	e8 74 3b 00 00       	call   40d0 <printf>
  fd = open("small", O_CREATE|O_RDWR);
     55c:	58                   	pop    %eax
     55d:	5a                   	pop    %edx
     55e:	68 02 02 00 00       	push   $0x202
     563:	68 7f 45 00 00       	push   $0x457f
     568:	e8 26 3a 00 00       	call   3f93 <open>
  if(fd >= 0){
     56d:	83 c4 10             	add    $0x10,%esp
     570:	85 c0                	test   %eax,%eax
     572:	0f 88 b3 01 00 00    	js     72b <writetest+0x1eb>
    printf(stdout, "creat small succeeded; ok\n");
     578:	83 ec 08             	sub    $0x8,%esp
     57b:	89 c6                	mov    %eax,%esi
  for(i = 0; i < 100; i++){
     57d:	31 db                	xor    %ebx,%ebx
    printf(stdout, "creat small succeeded; ok\n");
     57f:	68 85 45 00 00       	push   $0x4585
     584:	ff 35 d0 64 00 00    	pushl  0x64d0
     58a:	e8 41 3b 00 00       	call   40d0 <printf>
     58f:	83 c4 10             	add    $0x10,%esp
     592:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(write(fd, "aaaaaaaaaa", 10) != 10){
     598:	83 ec 04             	sub    $0x4,%esp
     59b:	6a 0a                	push   $0xa
     59d:	68 bc 45 00 00       	push   $0x45bc
     5a2:	56                   	push   %esi
     5a3:	e8 cb 39 00 00       	call   3f73 <write>
     5a8:	83 c4 10             	add    $0x10,%esp
     5ab:	83 f8 0a             	cmp    $0xa,%eax
     5ae:	0f 85 dd 00 00 00    	jne    691 <writetest+0x151>
    if(write(fd, "bbbbbbbbbb", 10) != 10){
     5b4:	83 ec 04             	sub    $0x4,%esp
     5b7:	6a 0a                	push   $0xa
     5b9:	68 c7 45 00 00       	push   $0x45c7
     5be:	56                   	push   %esi
     5bf:	e8 af 39 00 00       	call   3f73 <write>
     5c4:	83 c4 10             	add    $0x10,%esp
     5c7:	83 f8 0a             	cmp    $0xa,%eax
     5ca:	0f 85 e1 00 00 00    	jne    6b1 <writetest+0x171>
  for(i = 0; i < 100; i++){
     5d0:	83 c3 01             	add    $0x1,%ebx
     5d3:	83 fb 64             	cmp    $0x64,%ebx
     5d6:	75 c0                	jne    598 <writetest+0x58>
  printf(stdout, "writes ok\n");
     5d8:	83 ec 08             	sub    $0x8,%esp
     5db:	68 d2 45 00 00       	push   $0x45d2
     5e0:	ff 35 d0 64 00 00    	pushl  0x64d0
     5e6:	e8 e5 3a 00 00       	call   40d0 <printf>
  close(fd);
     5eb:	89 34 24             	mov    %esi,(%esp)
     5ee:	e8 88 39 00 00       	call   3f7b <close>
  fd = open("small", O_RDONLY);
     5f3:	5b                   	pop    %ebx
     5f4:	5e                   	pop    %esi
     5f5:	6a 00                	push   $0x0
     5f7:	68 7f 45 00 00       	push   $0x457f
     5fc:	e8 92 39 00 00       	call   3f93 <open>
  if(fd >= 0){
     601:	83 c4 10             	add    $0x10,%esp
  fd = open("small", O_RDONLY);
     604:	89 c3                	mov    %eax,%ebx
  if(fd >= 0){
     606:	85 c0                	test   %eax,%eax
     608:	0f 88 c3 00 00 00    	js     6d1 <writetest+0x191>
    printf(stdout, "open small succeeded ok\n");
     60e:	83 ec 08             	sub    $0x8,%esp
     611:	68 dd 45 00 00       	push   $0x45dd
     616:	ff 35 d0 64 00 00    	pushl  0x64d0
     61c:	e8 af 3a 00 00       	call   40d0 <printf>
  i = read(fd, buf, 2000);
     621:	83 c4 0c             	add    $0xc,%esp
     624:	68 d0 07 00 00       	push   $0x7d0
     629:	68 c0 8c 00 00       	push   $0x8cc0
     62e:	53                   	push   %ebx
     62f:	e8 37 39 00 00       	call   3f6b <read>
  if(i == 2000){
     634:	83 c4 10             	add    $0x10,%esp
     637:	3d d0 07 00 00       	cmp    $0x7d0,%eax
     63c:	0f 85 ad 00 00 00    	jne    6ef <writetest+0x1af>
    printf(stdout, "read succeeded ok\n");
     642:	83 ec 08             	sub    $0x8,%esp
     645:	68 11 46 00 00       	push   $0x4611
     64a:	ff 35 d0 64 00 00    	pushl  0x64d0
     650:	e8 7b 3a 00 00       	call   40d0 <printf>
  close(fd);
     655:	89 1c 24             	mov    %ebx,(%esp)
     658:	e8 1e 39 00 00       	call   3f7b <close>
  if(unlink("small") < 0){
     65d:	c7 04 24 7f 45 00 00 	movl   $0x457f,(%esp)
     664:	e8 3a 39 00 00       	call   3fa3 <unlink>
     669:	83 c4 10             	add    $0x10,%esp
     66c:	85 c0                	test   %eax,%eax
     66e:	0f 88 99 00 00 00    	js     70d <writetest+0x1cd>
  printf(stdout, "small file test ok\n");
     674:	83 ec 08             	sub    $0x8,%esp
     677:	68 39 46 00 00       	push   $0x4639
     67c:	ff 35 d0 64 00 00    	pushl  0x64d0
     682:	e8 49 3a 00 00       	call   40d0 <printf>
}
     687:	83 c4 10             	add    $0x10,%esp
     68a:	8d 65 f8             	lea    -0x8(%ebp),%esp
     68d:	5b                   	pop    %ebx
     68e:	5e                   	pop    %esi
     68f:	5d                   	pop    %ebp
     690:	c3                   	ret    
      printf(stdout, "error: write aa %d new file failed\n", i);
     691:	83 ec 04             	sub    $0x4,%esp
     694:	53                   	push   %ebx
     695:	68 80 54 00 00       	push   $0x5480
     69a:	ff 35 d0 64 00 00    	pushl  0x64d0
     6a0:	e8 2b 3a 00 00       	call   40d0 <printf>
      exit(1);
     6a5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     6ac:	e8 a2 38 00 00       	call   3f53 <exit>
      printf(stdout, "error: write bb %d new file failed\n", i);
     6b1:	83 ec 04             	sub    $0x4,%esp
     6b4:	53                   	push   %ebx
     6b5:	68 a4 54 00 00       	push   $0x54a4
     6ba:	ff 35 d0 64 00 00    	pushl  0x64d0
     6c0:	e8 0b 3a 00 00       	call   40d0 <printf>
      exit(1);
     6c5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     6cc:	e8 82 38 00 00       	call   3f53 <exit>
    printf(stdout, "error: open small failed!\n");
     6d1:	51                   	push   %ecx
     6d2:	51                   	push   %ecx
     6d3:	68 f6 45 00 00       	push   $0x45f6
     6d8:	ff 35 d0 64 00 00    	pushl  0x64d0
     6de:	e8 ed 39 00 00       	call   40d0 <printf>
    exit(1);
     6e3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     6ea:	e8 64 38 00 00       	call   3f53 <exit>
    printf(stdout, "read failed\n");
     6ef:	52                   	push   %edx
     6f0:	52                   	push   %edx
     6f1:	68 3d 49 00 00       	push   $0x493d
     6f6:	ff 35 d0 64 00 00    	pushl  0x64d0
     6fc:	e8 cf 39 00 00       	call   40d0 <printf>
    exit(1);
     701:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     708:	e8 46 38 00 00       	call   3f53 <exit>
    printf(stdout, "unlink small failed\n");
     70d:	50                   	push   %eax
     70e:	50                   	push   %eax
     70f:	68 24 46 00 00       	push   $0x4624
     714:	ff 35 d0 64 00 00    	pushl  0x64d0
     71a:	e8 b1 39 00 00       	call   40d0 <printf>
    exit(1);
     71f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     726:	e8 28 38 00 00       	call   3f53 <exit>
    printf(stdout, "error: creat small failed!\n");
     72b:	50                   	push   %eax
     72c:	50                   	push   %eax
     72d:	68 a0 45 00 00       	push   $0x45a0
     732:	ff 35 d0 64 00 00    	pushl  0x64d0
     738:	e8 93 39 00 00       	call   40d0 <printf>
    exit(1);
     73d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     744:	e8 0a 38 00 00       	call   3f53 <exit>
     749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000750 <writetest1>:
{
     750:	f3 0f 1e fb          	endbr32 
     754:	55                   	push   %ebp
     755:	89 e5                	mov    %esp,%ebp
     757:	56                   	push   %esi
     758:	53                   	push   %ebx
  printf(stdout, "big files test\n");
     759:	83 ec 08             	sub    $0x8,%esp
     75c:	68 4d 46 00 00       	push   $0x464d
     761:	ff 35 d0 64 00 00    	pushl  0x64d0
     767:	e8 64 39 00 00       	call   40d0 <printf>
  fd = open("big", O_CREATE|O_RDWR);
     76c:	58                   	pop    %eax
     76d:	5a                   	pop    %edx
     76e:	68 02 02 00 00       	push   $0x202
     773:	68 c7 46 00 00       	push   $0x46c7
     778:	e8 16 38 00 00       	call   3f93 <open>
  if(fd < 0){
     77d:	83 c4 10             	add    $0x10,%esp
     780:	85 c0                	test   %eax,%eax
     782:	0f 88 84 01 00 00    	js     90c <writetest1+0x1bc>
     788:	89 c6                	mov    %eax,%esi
  for(i = 0; i < MAXFILE; i++){
     78a:	31 db                	xor    %ebx,%ebx
     78c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(write(fd, buf, 512) != 512){
     790:	83 ec 04             	sub    $0x4,%esp
    ((int*)buf)[0] = i;
     793:	89 1d c0 8c 00 00    	mov    %ebx,0x8cc0
    if(write(fd, buf, 512) != 512){
     799:	68 00 02 00 00       	push   $0x200
     79e:	68 c0 8c 00 00       	push   $0x8cc0
     7a3:	56                   	push   %esi
     7a4:	e8 ca 37 00 00       	call   3f73 <write>
     7a9:	83 c4 10             	add    $0x10,%esp
     7ac:	3d 00 02 00 00       	cmp    $0x200,%eax
     7b1:	0f 85 b7 00 00 00    	jne    86e <writetest1+0x11e>
  for(i = 0; i < MAXFILE; i++){
     7b7:	83 c3 01             	add    $0x1,%ebx
     7ba:	81 fb 8c 00 00 00    	cmp    $0x8c,%ebx
     7c0:	75 ce                	jne    790 <writetest1+0x40>
  close(fd);
     7c2:	83 ec 0c             	sub    $0xc,%esp
     7c5:	56                   	push   %esi
     7c6:	e8 b0 37 00 00       	call   3f7b <close>
  fd = open("big", O_RDONLY);
     7cb:	5b                   	pop    %ebx
     7cc:	5e                   	pop    %esi
     7cd:	6a 00                	push   $0x0
     7cf:	68 c7 46 00 00       	push   $0x46c7
     7d4:	e8 ba 37 00 00       	call   3f93 <open>
  if(fd < 0){
     7d9:	83 c4 10             	add    $0x10,%esp
  fd = open("big", O_RDONLY);
     7dc:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
     7de:	85 c0                	test   %eax,%eax
     7e0:	0f 88 08 01 00 00    	js     8ee <writetest1+0x19e>
  n = 0;
     7e6:	31 f6                	xor    %esi,%esi
     7e8:	eb 21                	jmp    80b <writetest1+0xbb>
     7ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(i != 512){
     7f0:	3d 00 02 00 00       	cmp    $0x200,%eax
     7f5:	0f 85 b1 00 00 00    	jne    8ac <writetest1+0x15c>
    if(((int*)buf)[0] != n){
     7fb:	a1 c0 8c 00 00       	mov    0x8cc0,%eax
     800:	39 f0                	cmp    %esi,%eax
     802:	0f 85 86 00 00 00    	jne    88e <writetest1+0x13e>
    n++;
     808:	83 c6 01             	add    $0x1,%esi
    i = read(fd, buf, 512);
     80b:	83 ec 04             	sub    $0x4,%esp
     80e:	68 00 02 00 00       	push   $0x200
     813:	68 c0 8c 00 00       	push   $0x8cc0
     818:	53                   	push   %ebx
     819:	e8 4d 37 00 00       	call   3f6b <read>
    if(i == 0){
     81e:	83 c4 10             	add    $0x10,%esp
     821:	85 c0                	test   %eax,%eax
     823:	75 cb                	jne    7f0 <writetest1+0xa0>
      if(n == MAXFILE - 1){
     825:	81 fe 8b 00 00 00    	cmp    $0x8b,%esi
     82b:	0f 84 9b 00 00 00    	je     8cc <writetest1+0x17c>
  close(fd);
     831:	83 ec 0c             	sub    $0xc,%esp
     834:	53                   	push   %ebx
     835:	e8 41 37 00 00       	call   3f7b <close>
  if(unlink("big") < 0){
     83a:	c7 04 24 c7 46 00 00 	movl   $0x46c7,(%esp)
     841:	e8 5d 37 00 00       	call   3fa3 <unlink>
     846:	83 c4 10             	add    $0x10,%esp
     849:	85 c0                	test   %eax,%eax
     84b:	0f 88 d9 00 00 00    	js     92a <writetest1+0x1da>
  printf(stdout, "big files ok\n");
     851:	83 ec 08             	sub    $0x8,%esp
     854:	68 ee 46 00 00       	push   $0x46ee
     859:	ff 35 d0 64 00 00    	pushl  0x64d0
     85f:	e8 6c 38 00 00       	call   40d0 <printf>
}
     864:	83 c4 10             	add    $0x10,%esp
     867:	8d 65 f8             	lea    -0x8(%ebp),%esp
     86a:	5b                   	pop    %ebx
     86b:	5e                   	pop    %esi
     86c:	5d                   	pop    %ebp
     86d:	c3                   	ret    
      printf(stdout, "error: write big file failed\n", i);
     86e:	83 ec 04             	sub    $0x4,%esp
     871:	53                   	push   %ebx
     872:	68 77 46 00 00       	push   $0x4677
     877:	ff 35 d0 64 00 00    	pushl  0x64d0
     87d:	e8 4e 38 00 00       	call   40d0 <printf>
      exit(1);
     882:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     889:	e8 c5 36 00 00       	call   3f53 <exit>
      printf(stdout, "read content of block %d is %d\n",
     88e:	50                   	push   %eax
     88f:	56                   	push   %esi
     890:	68 c8 54 00 00       	push   $0x54c8
     895:	ff 35 d0 64 00 00    	pushl  0x64d0
     89b:	e8 30 38 00 00       	call   40d0 <printf>
      exit(1);
     8a0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     8a7:	e8 a7 36 00 00       	call   3f53 <exit>
      printf(stdout, "read failed %d\n", i);
     8ac:	83 ec 04             	sub    $0x4,%esp
     8af:	50                   	push   %eax
     8b0:	68 cb 46 00 00       	push   $0x46cb
     8b5:	ff 35 d0 64 00 00    	pushl  0x64d0
     8bb:	e8 10 38 00 00       	call   40d0 <printf>
      exit(1);
     8c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     8c7:	e8 87 36 00 00       	call   3f53 <exit>
        printf(stdout, "read only %d blocks from big", n);
     8cc:	52                   	push   %edx
     8cd:	68 8b 00 00 00       	push   $0x8b
     8d2:	68 ae 46 00 00       	push   $0x46ae
     8d7:	ff 35 d0 64 00 00    	pushl  0x64d0
     8dd:	e8 ee 37 00 00       	call   40d0 <printf>
        exit(1);
     8e2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     8e9:	e8 65 36 00 00       	call   3f53 <exit>
    printf(stdout, "error: open big failed!\n");
     8ee:	51                   	push   %ecx
     8ef:	51                   	push   %ecx
     8f0:	68 95 46 00 00       	push   $0x4695
     8f5:	ff 35 d0 64 00 00    	pushl  0x64d0
     8fb:	e8 d0 37 00 00       	call   40d0 <printf>
    exit(1);
     900:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     907:	e8 47 36 00 00       	call   3f53 <exit>
    printf(stdout, "error: creat big failed!\n");
     90c:	50                   	push   %eax
     90d:	50                   	push   %eax
     90e:	68 5d 46 00 00       	push   $0x465d
     913:	ff 35 d0 64 00 00    	pushl  0x64d0
     919:	e8 b2 37 00 00       	call   40d0 <printf>
    exit(1);
     91e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     925:	e8 29 36 00 00       	call   3f53 <exit>
    printf(stdout, "unlink big failed\n");
     92a:	50                   	push   %eax
     92b:	50                   	push   %eax
     92c:	68 db 46 00 00       	push   $0x46db
     931:	ff 35 d0 64 00 00    	pushl  0x64d0
     937:	e8 94 37 00 00       	call   40d0 <printf>
    exit(1);
     93c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     943:	e8 0b 36 00 00       	call   3f53 <exit>
     948:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     94f:	90                   	nop

00000950 <createtest>:
{
     950:	f3 0f 1e fb          	endbr32 
     954:	55                   	push   %ebp
     955:	89 e5                	mov    %esp,%ebp
     957:	53                   	push   %ebx
  name[2] = '\0';
     958:	bb 30 00 00 00       	mov    $0x30,%ebx
{
     95d:	83 ec 0c             	sub    $0xc,%esp
  printf(stdout, "many creates, followed by unlink test\n");
     960:	68 e8 54 00 00       	push   $0x54e8
     965:	ff 35 d0 64 00 00    	pushl  0x64d0
     96b:	e8 60 37 00 00       	call   40d0 <printf>
  name[0] = 'a';
     970:	c6 05 c0 ac 00 00 61 	movb   $0x61,0xacc0
  name[2] = '\0';
     977:	83 c4 10             	add    $0x10,%esp
     97a:	c6 05 c2 ac 00 00 00 	movb   $0x0,0xacc2
  for(i = 0; i < 52; i++){
     981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    fd = open(name, O_CREATE|O_RDWR);
     988:	83 ec 08             	sub    $0x8,%esp
    name[1] = '0' + i;
     98b:	88 1d c1 ac 00 00    	mov    %bl,0xacc1
    fd = open(name, O_CREATE|O_RDWR);
     991:	83 c3 01             	add    $0x1,%ebx
     994:	68 02 02 00 00       	push   $0x202
     999:	68 c0 ac 00 00       	push   $0xacc0
     99e:	e8 f0 35 00 00       	call   3f93 <open>
    close(fd);
     9a3:	89 04 24             	mov    %eax,(%esp)
     9a6:	e8 d0 35 00 00       	call   3f7b <close>
  for(i = 0; i < 52; i++){
     9ab:	83 c4 10             	add    $0x10,%esp
     9ae:	80 fb 64             	cmp    $0x64,%bl
     9b1:	75 d5                	jne    988 <createtest+0x38>
  name[0] = 'a';
     9b3:	c6 05 c0 ac 00 00 61 	movb   $0x61,0xacc0
  name[2] = '\0';
     9ba:	bb 30 00 00 00       	mov    $0x30,%ebx
     9bf:	c6 05 c2 ac 00 00 00 	movb   $0x0,0xacc2
  for(i = 0; i < 52; i++){
     9c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     9cd:	8d 76 00             	lea    0x0(%esi),%esi
    unlink(name);
     9d0:	83 ec 0c             	sub    $0xc,%esp
    name[1] = '0' + i;
     9d3:	88 1d c1 ac 00 00    	mov    %bl,0xacc1
    unlink(name);
     9d9:	83 c3 01             	add    $0x1,%ebx
     9dc:	68 c0 ac 00 00       	push   $0xacc0
     9e1:	e8 bd 35 00 00       	call   3fa3 <unlink>
  for(i = 0; i < 52; i++){
     9e6:	83 c4 10             	add    $0x10,%esp
     9e9:	80 fb 64             	cmp    $0x64,%bl
     9ec:	75 e2                	jne    9d0 <createtest+0x80>
  printf(stdout, "many creates, followed by unlink; ok\n");
     9ee:	83 ec 08             	sub    $0x8,%esp
     9f1:	68 10 55 00 00       	push   $0x5510
     9f6:	ff 35 d0 64 00 00    	pushl  0x64d0
     9fc:	e8 cf 36 00 00       	call   40d0 <printf>
}
     a01:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     a04:	83 c4 10             	add    $0x10,%esp
     a07:	c9                   	leave  
     a08:	c3                   	ret    
     a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000a10 <dirtest>:
{
     a10:	f3 0f 1e fb          	endbr32 
     a14:	55                   	push   %ebp
     a15:	89 e5                	mov    %esp,%ebp
     a17:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "mkdir test\n");
     a1a:	68 fc 46 00 00       	push   $0x46fc
     a1f:	ff 35 d0 64 00 00    	pushl  0x64d0
     a25:	e8 a6 36 00 00       	call   40d0 <printf>
  if(mkdir("dir0") < 0){
     a2a:	c7 04 24 08 47 00 00 	movl   $0x4708,(%esp)
     a31:	e8 85 35 00 00       	call   3fbb <mkdir>
     a36:	83 c4 10             	add    $0x10,%esp
     a39:	85 c0                	test   %eax,%eax
     a3b:	78 58                	js     a95 <dirtest+0x85>
  if(chdir("dir0") < 0){
     a3d:	83 ec 0c             	sub    $0xc,%esp
     a40:	68 08 47 00 00       	push   $0x4708
     a45:	e8 79 35 00 00       	call   3fc3 <chdir>
     a4a:	83 c4 10             	add    $0x10,%esp
     a4d:	85 c0                	test   %eax,%eax
     a4f:	0f 88 9a 00 00 00    	js     aef <dirtest+0xdf>
  if(chdir("..") < 0){
     a55:	83 ec 0c             	sub    $0xc,%esp
     a58:	68 ad 4c 00 00       	push   $0x4cad
     a5d:	e8 61 35 00 00       	call   3fc3 <chdir>
     a62:	83 c4 10             	add    $0x10,%esp
     a65:	85 c0                	test   %eax,%eax
     a67:	78 68                	js     ad1 <dirtest+0xc1>
  if(unlink("dir0") < 0){
     a69:	83 ec 0c             	sub    $0xc,%esp
     a6c:	68 08 47 00 00       	push   $0x4708
     a71:	e8 2d 35 00 00       	call   3fa3 <unlink>
     a76:	83 c4 10             	add    $0x10,%esp
     a79:	85 c0                	test   %eax,%eax
     a7b:	78 36                	js     ab3 <dirtest+0xa3>
  printf(stdout, "mkdir test ok\n");
     a7d:	83 ec 08             	sub    $0x8,%esp
     a80:	68 45 47 00 00       	push   $0x4745
     a85:	ff 35 d0 64 00 00    	pushl  0x64d0
     a8b:	e8 40 36 00 00       	call   40d0 <printf>
}
     a90:	83 c4 10             	add    $0x10,%esp
     a93:	c9                   	leave  
     a94:	c3                   	ret    
    printf(stdout, "mkdir failed\n");
     a95:	50                   	push   %eax
     a96:	50                   	push   %eax
     a97:	68 38 44 00 00       	push   $0x4438
     a9c:	ff 35 d0 64 00 00    	pushl  0x64d0
     aa2:	e8 29 36 00 00       	call   40d0 <printf>
    exit(1);
     aa7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     aae:	e8 a0 34 00 00       	call   3f53 <exit>
    printf(stdout, "unlink dir0 failed\n");
     ab3:	50                   	push   %eax
     ab4:	50                   	push   %eax
     ab5:	68 31 47 00 00       	push   $0x4731
     aba:	ff 35 d0 64 00 00    	pushl  0x64d0
     ac0:	e8 0b 36 00 00       	call   40d0 <printf>
    exit(1);
     ac5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     acc:	e8 82 34 00 00       	call   3f53 <exit>
    printf(stdout, "chdir .. failed\n");
     ad1:	52                   	push   %edx
     ad2:	52                   	push   %edx
     ad3:	68 20 47 00 00       	push   $0x4720
     ad8:	ff 35 d0 64 00 00    	pushl  0x64d0
     ade:	e8 ed 35 00 00       	call   40d0 <printf>
    exit(1);
     ae3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     aea:	e8 64 34 00 00       	call   3f53 <exit>
    printf(stdout, "chdir dir0 failed\n");
     aef:	51                   	push   %ecx
     af0:	51                   	push   %ecx
     af1:	68 0d 47 00 00       	push   $0x470d
     af6:	ff 35 d0 64 00 00    	pushl  0x64d0
     afc:	e8 cf 35 00 00       	call   40d0 <printf>
    exit(1);
     b01:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b08:	e8 46 34 00 00       	call   3f53 <exit>
     b0d:	8d 76 00             	lea    0x0(%esi),%esi

00000b10 <exectest>:
{
     b10:	f3 0f 1e fb          	endbr32 
     b14:	55                   	push   %ebp
     b15:	89 e5                	mov    %esp,%ebp
     b17:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "exec test\n");
     b1a:	68 54 47 00 00       	push   $0x4754
     b1f:	ff 35 d0 64 00 00    	pushl  0x64d0
     b25:	e8 a6 35 00 00       	call   40d0 <printf>
  if(exec("echo", echoargv) < 0){
     b2a:	5a                   	pop    %edx
     b2b:	59                   	pop    %ecx
     b2c:	68 d4 64 00 00       	push   $0x64d4
     b31:	68 1d 45 00 00       	push   $0x451d
     b36:	e8 50 34 00 00       	call   3f8b <exec>
     b3b:	83 c4 10             	add    $0x10,%esp
     b3e:	85 c0                	test   %eax,%eax
     b40:	78 02                	js     b44 <exectest+0x34>
}
     b42:	c9                   	leave  
     b43:	c3                   	ret    
    printf(stdout, "exec echo failed\n");
     b44:	50                   	push   %eax
     b45:	50                   	push   %eax
     b46:	68 5f 47 00 00       	push   $0x475f
     b4b:	ff 35 d0 64 00 00    	pushl  0x64d0
     b51:	e8 7a 35 00 00       	call   40d0 <printf>
    exit(1);
     b56:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b5d:	e8 f1 33 00 00       	call   3f53 <exit>
     b62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000b70 <pipe1>:
{
     b70:	f3 0f 1e fb          	endbr32 
     b74:	55                   	push   %ebp
     b75:	89 e5                	mov    %esp,%ebp
     b77:	57                   	push   %edi
     b78:	56                   	push   %esi
  if(pipe(fds) != 0){
     b79:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
     b7c:	53                   	push   %ebx
     b7d:	83 ec 38             	sub    $0x38,%esp
  if(pipe(fds) != 0){
     b80:	50                   	push   %eax
     b81:	e8 dd 33 00 00       	call   3f63 <pipe>
     b86:	83 c4 10             	add    $0x10,%esp
     b89:	85 c0                	test   %eax,%eax
     b8b:	0f 85 4f 01 00 00    	jne    ce0 <pipe1+0x170>
  pid = fork();
     b91:	e8 b5 33 00 00       	call   3f4b <fork>
  if(pid == 0){
     b96:	85 c0                	test   %eax,%eax
     b98:	0f 84 8d 00 00 00    	je     c2b <pipe1+0xbb>
  } else if(pid > 0){
     b9e:	0f 8e 56 01 00 00    	jle    cfa <pipe1+0x18a>
    close(fds[1]);
     ba4:	83 ec 0c             	sub    $0xc,%esp
     ba7:	ff 75 e4             	pushl  -0x1c(%ebp)
  seq = 0;
     baa:	31 db                	xor    %ebx,%ebx
    cc = 1;
     bac:	be 01 00 00 00       	mov    $0x1,%esi
    close(fds[1]);
     bb1:	e8 c5 33 00 00       	call   3f7b <close>
    total = 0;
     bb6:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
    while((n = read(fds[0], buf, cc)) > 0){
     bbd:	83 c4 10             	add    $0x10,%esp
     bc0:	83 ec 04             	sub    $0x4,%esp
     bc3:	56                   	push   %esi
     bc4:	68 c0 8c 00 00       	push   $0x8cc0
     bc9:	ff 75 e0             	pushl  -0x20(%ebp)
     bcc:	e8 9a 33 00 00       	call   3f6b <read>
     bd1:	83 c4 10             	add    $0x10,%esp
     bd4:	89 c7                	mov    %eax,%edi
     bd6:	85 c0                	test   %eax,%eax
     bd8:	0f 8e b0 00 00 00    	jle    c8e <pipe1+0x11e>
     bde:	8d 0c 3b             	lea    (%ebx,%edi,1),%ecx
      for(i = 0; i < n; i++){
     be1:	31 c0                	xor    %eax,%eax
     be3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     be7:	90                   	nop
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     be8:	89 da                	mov    %ebx,%edx
     bea:	83 c3 01             	add    $0x1,%ebx
     bed:	38 90 c0 8c 00 00    	cmp    %dl,0x8cc0(%eax)
     bf3:	75 1c                	jne    c11 <pipe1+0xa1>
      for(i = 0; i < n; i++){
     bf5:	83 c0 01             	add    $0x1,%eax
     bf8:	39 d9                	cmp    %ebx,%ecx
     bfa:	75 ec                	jne    be8 <pipe1+0x78>
      cc = cc * 2;
     bfc:	01 f6                	add    %esi,%esi
      total += n;
     bfe:	01 7d d4             	add    %edi,-0x2c(%ebp)
     c01:	b8 00 20 00 00       	mov    $0x2000,%eax
     c06:	81 fe 00 20 00 00    	cmp    $0x2000,%esi
     c0c:	0f 4f f0             	cmovg  %eax,%esi
     c0f:	eb af                	jmp    bc0 <pipe1+0x50>
          printf(1, "pipe1 oops 2\n");
     c11:	83 ec 08             	sub    $0x8,%esp
     c14:	68 8e 47 00 00       	push   $0x478e
     c19:	6a 01                	push   $0x1
     c1b:	e8 b0 34 00 00       	call   40d0 <printf>
          return;
     c20:	83 c4 10             	add    $0x10,%esp
}
     c23:	8d 65 f4             	lea    -0xc(%ebp),%esp
     c26:	5b                   	pop    %ebx
     c27:	5e                   	pop    %esi
     c28:	5f                   	pop    %edi
     c29:	5d                   	pop    %ebp
     c2a:	c3                   	ret    
    close(fds[0]);
     c2b:	83 ec 0c             	sub    $0xc,%esp
     c2e:	ff 75 e0             	pushl  -0x20(%ebp)
  seq = 0;
     c31:	31 db                	xor    %ebx,%ebx
    close(fds[0]);
     c33:	e8 43 33 00 00       	call   3f7b <close>
     c38:	83 c4 10             	add    $0x10,%esp
      for(i = 0; i < 1033; i++)
     c3b:	31 c0                	xor    %eax,%eax
     c3d:	8d 76 00             	lea    0x0(%esi),%esi
        buf[i] = seq++;
     c40:	8d 14 18             	lea    (%eax,%ebx,1),%edx
      for(i = 0; i < 1033; i++)
     c43:	83 c0 01             	add    $0x1,%eax
        buf[i] = seq++;
     c46:	88 90 bf 8c 00 00    	mov    %dl,0x8cbf(%eax)
      for(i = 0; i < 1033; i++)
     c4c:	3d 09 04 00 00       	cmp    $0x409,%eax
     c51:	75 ed                	jne    c40 <pipe1+0xd0>
      if(write(fds[1], buf, 1033) != 1033){
     c53:	83 ec 04             	sub    $0x4,%esp
     c56:	81 c3 09 04 00 00    	add    $0x409,%ebx
     c5c:	68 09 04 00 00       	push   $0x409
     c61:	68 c0 8c 00 00       	push   $0x8cc0
     c66:	ff 75 e4             	pushl  -0x1c(%ebp)
     c69:	e8 05 33 00 00       	call   3f73 <write>
     c6e:	83 c4 10             	add    $0x10,%esp
     c71:	3d 09 04 00 00       	cmp    $0x409,%eax
     c76:	0f 85 98 00 00 00    	jne    d14 <pipe1+0x1a4>
    for(n = 0; n < 5; n++){
     c7c:	81 fb 2d 14 00 00    	cmp    $0x142d,%ebx
     c82:	75 b7                	jne    c3b <pipe1+0xcb>
    exit(1);
     c84:	83 ec 0c             	sub    $0xc,%esp
     c87:	6a 01                	push   $0x1
     c89:	e8 c5 32 00 00       	call   3f53 <exit>
    if(total != 5 * 1033){
     c8e:	81 7d d4 2d 14 00 00 	cmpl   $0x142d,-0x2c(%ebp)
     c95:	75 2d                	jne    cc4 <pipe1+0x154>
    close(fds[0]);
     c97:	83 ec 0c             	sub    $0xc,%esp
     c9a:	ff 75 e0             	pushl  -0x20(%ebp)
     c9d:	e8 d9 32 00 00       	call   3f7b <close>
    wait(null);
     ca2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     ca9:	e8 ad 32 00 00       	call   3f5b <wait>
  printf(1, "pipe1 ok\n");
     cae:	5a                   	pop    %edx
     caf:	59                   	pop    %ecx
     cb0:	68 b3 47 00 00       	push   $0x47b3
     cb5:	6a 01                	push   $0x1
     cb7:	e8 14 34 00 00       	call   40d0 <printf>
     cbc:	83 c4 10             	add    $0x10,%esp
     cbf:	e9 5f ff ff ff       	jmp    c23 <pipe1+0xb3>
      printf(1, "pipe1 oops 3 total %d\n", total);
     cc4:	53                   	push   %ebx
     cc5:	ff 75 d4             	pushl  -0x2c(%ebp)
     cc8:	68 9c 47 00 00       	push   $0x479c
     ccd:	6a 01                	push   $0x1
     ccf:	e8 fc 33 00 00       	call   40d0 <printf>
      exit(1);
     cd4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     cdb:	e8 73 32 00 00       	call   3f53 <exit>
    printf(1, "pipe() failed\n");
     ce0:	57                   	push   %edi
     ce1:	57                   	push   %edi
     ce2:	68 71 47 00 00       	push   $0x4771
     ce7:	6a 01                	push   $0x1
     ce9:	e8 e2 33 00 00       	call   40d0 <printf>
    exit(1);
     cee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     cf5:	e8 59 32 00 00       	call   3f53 <exit>
    printf(1, "fork() failed\n");
     cfa:	50                   	push   %eax
     cfb:	50                   	push   %eax
     cfc:	68 bd 47 00 00       	push   $0x47bd
     d01:	6a 01                	push   $0x1
     d03:	e8 c8 33 00 00       	call   40d0 <printf>
    exit(1);
     d08:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d0f:	e8 3f 32 00 00       	call   3f53 <exit>
        printf(1, "pipe1 oops 1\n");
     d14:	56                   	push   %esi
     d15:	56                   	push   %esi
     d16:	68 80 47 00 00       	push   $0x4780
     d1b:	6a 01                	push   $0x1
     d1d:	e8 ae 33 00 00       	call   40d0 <printf>
        exit(1);
     d22:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d29:	e8 25 32 00 00       	call   3f53 <exit>
     d2e:	66 90                	xchg   %ax,%ax

00000d30 <preempt>:
{
     d30:	f3 0f 1e fb          	endbr32 
     d34:	55                   	push   %ebp
     d35:	89 e5                	mov    %esp,%ebp
     d37:	57                   	push   %edi
     d38:	56                   	push   %esi
     d39:	53                   	push   %ebx
     d3a:	83 ec 24             	sub    $0x24,%esp
  printf(1, "preempt: ");
     d3d:	68 cc 47 00 00       	push   $0x47cc
     d42:	6a 01                	push   $0x1
     d44:	e8 87 33 00 00       	call   40d0 <printf>
  pid1 = fork();
     d49:	e8 fd 31 00 00       	call   3f4b <fork>
  if(pid1 == 0)
     d4e:	83 c4 10             	add    $0x10,%esp
     d51:	85 c0                	test   %eax,%eax
     d53:	75 0b                	jne    d60 <preempt+0x30>
    for(;;)
     d55:	eb fe                	jmp    d55 <preempt+0x25>
     d57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     d5e:	66 90                	xchg   %ax,%ax
     d60:	89 c7                	mov    %eax,%edi
  pid2 = fork();
     d62:	e8 e4 31 00 00       	call   3f4b <fork>
     d67:	89 c6                	mov    %eax,%esi
  if(pid2 == 0)
     d69:	85 c0                	test   %eax,%eax
     d6b:	75 03                	jne    d70 <preempt+0x40>
    for(;;)
     d6d:	eb fe                	jmp    d6d <preempt+0x3d>
     d6f:	90                   	nop
  pipe(pfds);
     d70:	83 ec 0c             	sub    $0xc,%esp
     d73:	8d 45 e0             	lea    -0x20(%ebp),%eax
     d76:	50                   	push   %eax
     d77:	e8 e7 31 00 00       	call   3f63 <pipe>
  pid3 = fork();
     d7c:	e8 ca 31 00 00       	call   3f4b <fork>
  if(pid3 == 0){
     d81:	83 c4 10             	add    $0x10,%esp
  pid3 = fork();
     d84:	89 c3                	mov    %eax,%ebx
  if(pid3 == 0){
     d86:	85 c0                	test   %eax,%eax
     d88:	75 3e                	jne    dc8 <preempt+0x98>
    close(pfds[0]);
     d8a:	83 ec 0c             	sub    $0xc,%esp
     d8d:	ff 75 e0             	pushl  -0x20(%ebp)
     d90:	e8 e6 31 00 00       	call   3f7b <close>
    if(write(pfds[1], "x", 1) != 1)
     d95:	83 c4 0c             	add    $0xc,%esp
     d98:	6a 01                	push   $0x1
     d9a:	68 91 4d 00 00       	push   $0x4d91
     d9f:	ff 75 e4             	pushl  -0x1c(%ebp)
     da2:	e8 cc 31 00 00       	call   3f73 <write>
     da7:	83 c4 10             	add    $0x10,%esp
     daa:	83 f8 01             	cmp    $0x1,%eax
     dad:	0f 85 bd 00 00 00    	jne    e70 <preempt+0x140>
    close(pfds[1]);
     db3:	83 ec 0c             	sub    $0xc,%esp
     db6:	ff 75 e4             	pushl  -0x1c(%ebp)
     db9:	e8 bd 31 00 00       	call   3f7b <close>
     dbe:	83 c4 10             	add    $0x10,%esp
    for(;;)
     dc1:	eb fe                	jmp    dc1 <preempt+0x91>
     dc3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     dc7:	90                   	nop
  close(pfds[1]);
     dc8:	83 ec 0c             	sub    $0xc,%esp
     dcb:	ff 75 e4             	pushl  -0x1c(%ebp)
     dce:	e8 a8 31 00 00       	call   3f7b <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
     dd3:	83 c4 0c             	add    $0xc,%esp
     dd6:	68 00 20 00 00       	push   $0x2000
     ddb:	68 c0 8c 00 00       	push   $0x8cc0
     de0:	ff 75 e0             	pushl  -0x20(%ebp)
     de3:	e8 83 31 00 00       	call   3f6b <read>
     de8:	83 c4 10             	add    $0x10,%esp
     deb:	83 f8 01             	cmp    $0x1,%eax
     dee:	0f 85 93 00 00 00    	jne    e87 <preempt+0x157>
  close(pfds[0]);
     df4:	83 ec 0c             	sub    $0xc,%esp
     df7:	ff 75 e0             	pushl  -0x20(%ebp)
     dfa:	e8 7c 31 00 00       	call   3f7b <close>
  printf(1, "kill... ");
     dff:	58                   	pop    %eax
     e00:	5a                   	pop    %edx
     e01:	68 fd 47 00 00       	push   $0x47fd
     e06:	6a 01                	push   $0x1
     e08:	e8 c3 32 00 00       	call   40d0 <printf>
  kill(pid1);
     e0d:	89 3c 24             	mov    %edi,(%esp)
     e10:	e8 6e 31 00 00       	call   3f83 <kill>
  kill(pid2);
     e15:	89 34 24             	mov    %esi,(%esp)
     e18:	e8 66 31 00 00       	call   3f83 <kill>
  kill(pid3);
     e1d:	89 1c 24             	mov    %ebx,(%esp)
     e20:	e8 5e 31 00 00       	call   3f83 <kill>
  printf(1, "wait... ");
     e25:	59                   	pop    %ecx
     e26:	5b                   	pop    %ebx
     e27:	68 06 48 00 00       	push   $0x4806
     e2c:	6a 01                	push   $0x1
     e2e:	e8 9d 32 00 00       	call   40d0 <printf>
  wait(null);
     e33:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     e3a:	e8 1c 31 00 00       	call   3f5b <wait>
  wait(null);
     e3f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     e46:	e8 10 31 00 00       	call   3f5b <wait>
  wait(null);
     e4b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     e52:	e8 04 31 00 00       	call   3f5b <wait>
  printf(1, "preempt ok\n");
     e57:	5e                   	pop    %esi
     e58:	5f                   	pop    %edi
     e59:	68 0f 48 00 00       	push   $0x480f
     e5e:	6a 01                	push   $0x1
     e60:	e8 6b 32 00 00       	call   40d0 <printf>
     e65:	83 c4 10             	add    $0x10,%esp
}
     e68:	8d 65 f4             	lea    -0xc(%ebp),%esp
     e6b:	5b                   	pop    %ebx
     e6c:	5e                   	pop    %esi
     e6d:	5f                   	pop    %edi
     e6e:	5d                   	pop    %ebp
     e6f:	c3                   	ret    
      printf(1, "preempt write error");
     e70:	83 ec 08             	sub    $0x8,%esp
     e73:	68 d6 47 00 00       	push   $0x47d6
     e78:	6a 01                	push   $0x1
     e7a:	e8 51 32 00 00       	call   40d0 <printf>
     e7f:	83 c4 10             	add    $0x10,%esp
     e82:	e9 2c ff ff ff       	jmp    db3 <preempt+0x83>
    printf(1, "preempt read error");
     e87:	83 ec 08             	sub    $0x8,%esp
     e8a:	68 ea 47 00 00       	push   $0x47ea
     e8f:	6a 01                	push   $0x1
     e91:	e8 3a 32 00 00       	call   40d0 <printf>
    return;
     e96:	83 c4 10             	add    $0x10,%esp
     e99:	eb cd                	jmp    e68 <preempt+0x138>
     e9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     e9f:	90                   	nop

00000ea0 <exitwait>:
{
     ea0:	f3 0f 1e fb          	endbr32 
     ea4:	55                   	push   %ebp
     ea5:	89 e5                	mov    %esp,%ebp
     ea7:	56                   	push   %esi
     ea8:	be 64 00 00 00       	mov    $0x64,%esi
     ead:	53                   	push   %ebx
     eae:	eb 18                	jmp    ec8 <exitwait+0x28>
    if(pid){
     eb0:	74 70                	je     f22 <exitwait+0x82>
      if(wait(null) != pid){
     eb2:	83 ec 0c             	sub    $0xc,%esp
     eb5:	6a 00                	push   $0x0
     eb7:	e8 9f 30 00 00       	call   3f5b <wait>
     ebc:	83 c4 10             	add    $0x10,%esp
     ebf:	39 d8                	cmp    %ebx,%eax
     ec1:	75 2d                	jne    ef0 <exitwait+0x50>
  for(i = 0; i < 100; i++){
     ec3:	83 ee 01             	sub    $0x1,%esi
     ec6:	74 41                	je     f09 <exitwait+0x69>
    pid = fork();
     ec8:	e8 7e 30 00 00       	call   3f4b <fork>
     ecd:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
     ecf:	85 c0                	test   %eax,%eax
     ed1:	79 dd                	jns    eb0 <exitwait+0x10>
      printf(1, "fork failed\n");
     ed3:	83 ec 08             	sub    $0x8,%esp
     ed6:	68 79 53 00 00       	push   $0x5379
     edb:	6a 01                	push   $0x1
     edd:	e8 ee 31 00 00       	call   40d0 <printf>
      return;
     ee2:	83 c4 10             	add    $0x10,%esp
}
     ee5:	8d 65 f8             	lea    -0x8(%ebp),%esp
     ee8:	5b                   	pop    %ebx
     ee9:	5e                   	pop    %esi
     eea:	5d                   	pop    %ebp
     eeb:	c3                   	ret    
     eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        printf(1, "wait wrong pid\n");
     ef0:	83 ec 08             	sub    $0x8,%esp
     ef3:	68 1b 48 00 00       	push   $0x481b
     ef8:	6a 01                	push   $0x1
     efa:	e8 d1 31 00 00       	call   40d0 <printf>
        return;
     eff:	83 c4 10             	add    $0x10,%esp
}
     f02:	8d 65 f8             	lea    -0x8(%ebp),%esp
     f05:	5b                   	pop    %ebx
     f06:	5e                   	pop    %esi
     f07:	5d                   	pop    %ebp
     f08:	c3                   	ret    
  printf(1, "exitwait ok\n");
     f09:	83 ec 08             	sub    $0x8,%esp
     f0c:	68 2b 48 00 00       	push   $0x482b
     f11:	6a 01                	push   $0x1
     f13:	e8 b8 31 00 00       	call   40d0 <printf>
     f18:	83 c4 10             	add    $0x10,%esp
}
     f1b:	8d 65 f8             	lea    -0x8(%ebp),%esp
     f1e:	5b                   	pop    %ebx
     f1f:	5e                   	pop    %esi
     f20:	5d                   	pop    %ebp
     f21:	c3                   	ret    
      exit(1);
     f22:	83 ec 0c             	sub    $0xc,%esp
     f25:	6a 01                	push   $0x1
     f27:	e8 27 30 00 00       	call   3f53 <exit>
     f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000f30 <mem>:
{
     f30:	f3 0f 1e fb          	endbr32 
     f34:	55                   	push   %ebp
     f35:	89 e5                	mov    %esp,%ebp
     f37:	56                   	push   %esi
     f38:	31 f6                	xor    %esi,%esi
     f3a:	53                   	push   %ebx
  printf(1, "mem test\n");
     f3b:	83 ec 08             	sub    $0x8,%esp
     f3e:	68 38 48 00 00       	push   $0x4838
     f43:	6a 01                	push   $0x1
     f45:	e8 86 31 00 00       	call   40d0 <printf>
  ppid = getpid();
     f4a:	e8 84 30 00 00       	call   3fd3 <getpid>
     f4f:	89 c3                	mov    %eax,%ebx
  if((pid = fork()) == 0){
     f51:	e8 f5 2f 00 00       	call   3f4b <fork>
     f56:	83 c4 10             	add    $0x10,%esp
     f59:	85 c0                	test   %eax,%eax
     f5b:	74 0f                	je     f6c <mem+0x3c>
     f5d:	e9 9e 00 00 00       	jmp    1000 <mem+0xd0>
     f62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      *(char**)m2 = m1;
     f68:	89 30                	mov    %esi,(%eax)
     f6a:	89 c6                	mov    %eax,%esi
    while((m2 = malloc(10001)) != 0){
     f6c:	83 ec 0c             	sub    $0xc,%esp
     f6f:	68 11 27 00 00       	push   $0x2711
     f74:	e8 b7 33 00 00       	call   4330 <malloc>
     f79:	83 c4 10             	add    $0x10,%esp
     f7c:	85 c0                	test   %eax,%eax
     f7e:	75 e8                	jne    f68 <mem+0x38>
    while(m1){
     f80:	85 f6                	test   %esi,%esi
     f82:	74 18                	je     f9c <mem+0x6c>
     f84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      m2 = *(char**)m1;
     f88:	89 f0                	mov    %esi,%eax
      free(m1);
     f8a:	83 ec 0c             	sub    $0xc,%esp
      m2 = *(char**)m1;
     f8d:	8b 36                	mov    (%esi),%esi
      free(m1);
     f8f:	50                   	push   %eax
     f90:	e8 0b 33 00 00       	call   42a0 <free>
    while(m1){
     f95:	83 c4 10             	add    $0x10,%esp
     f98:	85 f6                	test   %esi,%esi
     f9a:	75 ec                	jne    f88 <mem+0x58>
    m1 = malloc(1024*20);
     f9c:	83 ec 0c             	sub    $0xc,%esp
     f9f:	68 00 50 00 00       	push   $0x5000
     fa4:	e8 87 33 00 00       	call   4330 <malloc>
    if(m1 == 0){
     fa9:	83 c4 10             	add    $0x10,%esp
     fac:	85 c0                	test   %eax,%eax
     fae:	74 28                	je     fd8 <mem+0xa8>
    free(m1);
     fb0:	83 ec 0c             	sub    $0xc,%esp
     fb3:	50                   	push   %eax
     fb4:	e8 e7 32 00 00       	call   42a0 <free>
    printf(1, "mem ok\n");
     fb9:	58                   	pop    %eax
     fba:	5a                   	pop    %edx
     fbb:	68 5c 48 00 00       	push   $0x485c
     fc0:	6a 01                	push   $0x1
     fc2:	e8 09 31 00 00       	call   40d0 <printf>
    exit(1);
     fc7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     fce:	e8 80 2f 00 00       	call   3f53 <exit>
     fd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     fd7:	90                   	nop
      printf(1, "couldn't allocate mem?!!\n");
     fd8:	83 ec 08             	sub    $0x8,%esp
     fdb:	68 42 48 00 00       	push   $0x4842
     fe0:	6a 01                	push   $0x1
     fe2:	e8 e9 30 00 00       	call   40d0 <printf>
      kill(ppid);
     fe7:	89 1c 24             	mov    %ebx,(%esp)
     fea:	e8 94 2f 00 00       	call   3f83 <kill>
      exit(1);
     fef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     ff6:	e8 58 2f 00 00       	call   3f53 <exit>
     ffb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     fff:	90                   	nop
    wait(null);
    1000:	83 ec 0c             	sub    $0xc,%esp
    1003:	6a 00                	push   $0x0
    1005:	e8 51 2f 00 00       	call   3f5b <wait>
}
    100a:	83 c4 10             	add    $0x10,%esp
    100d:	8d 65 f8             	lea    -0x8(%ebp),%esp
    1010:	5b                   	pop    %ebx
    1011:	5e                   	pop    %esi
    1012:	5d                   	pop    %ebp
    1013:	c3                   	ret    
    1014:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    101b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    101f:	90                   	nop

00001020 <sharedfd>:
{
    1020:	f3 0f 1e fb          	endbr32 
    1024:	55                   	push   %ebp
    1025:	89 e5                	mov    %esp,%ebp
    1027:	57                   	push   %edi
    1028:	56                   	push   %esi
    1029:	53                   	push   %ebx
    102a:	83 ec 34             	sub    $0x34,%esp
  printf(1, "sharedfd test\n");
    102d:	68 64 48 00 00       	push   $0x4864
    1032:	6a 01                	push   $0x1
    1034:	e8 97 30 00 00       	call   40d0 <printf>
  unlink("sharedfd");
    1039:	c7 04 24 73 48 00 00 	movl   $0x4873,(%esp)
    1040:	e8 5e 2f 00 00       	call   3fa3 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    1045:	5b                   	pop    %ebx
    1046:	5e                   	pop    %esi
    1047:	68 02 02 00 00       	push   $0x202
    104c:	68 73 48 00 00       	push   $0x4873
    1051:	e8 3d 2f 00 00       	call   3f93 <open>
  if(fd < 0){
    1056:	83 c4 10             	add    $0x10,%esp
    1059:	85 c0                	test   %eax,%eax
    105b:	0f 88 26 01 00 00    	js     1187 <sharedfd+0x167>
    1061:	89 c7                	mov    %eax,%edi
  memset(buf, pid==0?'c':'p', sizeof(buf));
    1063:	8d 75 de             	lea    -0x22(%ebp),%esi
    1066:	bb e8 03 00 00       	mov    $0x3e8,%ebx
  pid = fork();
    106b:	e8 db 2e 00 00       	call   3f4b <fork>
  memset(buf, pid==0?'c':'p', sizeof(buf));
    1070:	83 f8 01             	cmp    $0x1,%eax
  pid = fork();
    1073:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  memset(buf, pid==0?'c':'p', sizeof(buf));
    1076:	19 c0                	sbb    %eax,%eax
    1078:	83 ec 04             	sub    $0x4,%esp
    107b:	83 e0 f3             	and    $0xfffffff3,%eax
    107e:	6a 0a                	push   $0xa
    1080:	83 c0 70             	add    $0x70,%eax
    1083:	50                   	push   %eax
    1084:	56                   	push   %esi
    1085:	e8 26 2d 00 00       	call   3db0 <memset>
    108a:	83 c4 10             	add    $0x10,%esp
    108d:	eb 06                	jmp    1095 <sharedfd+0x75>
    108f:	90                   	nop
  for(i = 0; i < 1000; i++){
    1090:	83 eb 01             	sub    $0x1,%ebx
    1093:	74 26                	je     10bb <sharedfd+0x9b>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    1095:	83 ec 04             	sub    $0x4,%esp
    1098:	6a 0a                	push   $0xa
    109a:	56                   	push   %esi
    109b:	57                   	push   %edi
    109c:	e8 d2 2e 00 00       	call   3f73 <write>
    10a1:	83 c4 10             	add    $0x10,%esp
    10a4:	83 f8 0a             	cmp    $0xa,%eax
    10a7:	74 e7                	je     1090 <sharedfd+0x70>
      printf(1, "fstests: write sharedfd failed\n");
    10a9:	83 ec 08             	sub    $0x8,%esp
    10ac:	68 64 55 00 00       	push   $0x5564
    10b1:	6a 01                	push   $0x1
    10b3:	e8 18 30 00 00       	call   40d0 <printf>
      break;
    10b8:	83 c4 10             	add    $0x10,%esp
  if(pid == 0)
    10bb:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
    10be:	85 c9                	test   %ecx,%ecx
    10c0:	0f 84 f5 00 00 00    	je     11bb <sharedfd+0x19b>
    wait(null);
    10c6:	83 ec 0c             	sub    $0xc,%esp
  nc = np = 0;
    10c9:	31 db                	xor    %ebx,%ebx
    wait(null);
    10cb:	6a 00                	push   $0x0
    10cd:	e8 89 2e 00 00       	call   3f5b <wait>
  close(fd);
    10d2:	89 3c 24             	mov    %edi,(%esp)
    10d5:	8d 7d e8             	lea    -0x18(%ebp),%edi
    10d8:	e8 9e 2e 00 00       	call   3f7b <close>
  fd = open("sharedfd", 0);
    10dd:	58                   	pop    %eax
    10de:	5a                   	pop    %edx
    10df:	6a 00                	push   $0x0
    10e1:	68 73 48 00 00       	push   $0x4873
    10e6:	e8 a8 2e 00 00       	call   3f93 <open>
  if(fd < 0){
    10eb:	83 c4 10             	add    $0x10,%esp
  nc = np = 0;
    10ee:	31 d2                	xor    %edx,%edx
  fd = open("sharedfd", 0);
    10f0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  if(fd < 0){
    10f3:	85 c0                	test   %eax,%eax
    10f5:	0f 88 a6 00 00 00    	js     11a1 <sharedfd+0x181>
    10fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    10ff:	90                   	nop
  while((n = read(fd, buf, sizeof(buf))) > 0){
    1100:	83 ec 04             	sub    $0x4,%esp
    1103:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    1106:	6a 0a                	push   $0xa
    1108:	56                   	push   %esi
    1109:	ff 75 d0             	pushl  -0x30(%ebp)
    110c:	e8 5a 2e 00 00       	call   3f6b <read>
    1111:	83 c4 10             	add    $0x10,%esp
    1114:	85 c0                	test   %eax,%eax
    1116:	7e 28                	jle    1140 <sharedfd+0x120>
    for(i = 0; i < sizeof(buf); i++){
    1118:	8b 55 d4             	mov    -0x2c(%ebp),%edx
    111b:	89 f0                	mov    %esi,%eax
    111d:	eb 13                	jmp    1132 <sharedfd+0x112>
    111f:	90                   	nop
        np++;
    1120:	80 f9 70             	cmp    $0x70,%cl
    1123:	0f 94 c1             	sete   %cl
    1126:	0f b6 c9             	movzbl %cl,%ecx
    1129:	01 cb                	add    %ecx,%ebx
    for(i = 0; i < sizeof(buf); i++){
    112b:	83 c0 01             	add    $0x1,%eax
    112e:	39 c7                	cmp    %eax,%edi
    1130:	74 ce                	je     1100 <sharedfd+0xe0>
      if(buf[i] == 'c')
    1132:	0f b6 08             	movzbl (%eax),%ecx
    1135:	80 f9 63             	cmp    $0x63,%cl
    1138:	75 e6                	jne    1120 <sharedfd+0x100>
        nc++;
    113a:	83 c2 01             	add    $0x1,%edx
      if(buf[i] == 'p')
    113d:	eb ec                	jmp    112b <sharedfd+0x10b>
    113f:	90                   	nop
  close(fd);
    1140:	83 ec 0c             	sub    $0xc,%esp
    1143:	ff 75 d0             	pushl  -0x30(%ebp)
    1146:	e8 30 2e 00 00       	call   3f7b <close>
  unlink("sharedfd");
    114b:	c7 04 24 73 48 00 00 	movl   $0x4873,(%esp)
    1152:	e8 4c 2e 00 00       	call   3fa3 <unlink>
  if(nc == 10000 && np == 10000){
    1157:	8b 55 d4             	mov    -0x2c(%ebp),%edx
    115a:	83 c4 10             	add    $0x10,%esp
    115d:	81 fa 10 27 00 00    	cmp    $0x2710,%edx
    1163:	75 60                	jne    11c5 <sharedfd+0x1a5>
    1165:	81 fb 10 27 00 00    	cmp    $0x2710,%ebx
    116b:	75 58                	jne    11c5 <sharedfd+0x1a5>
    printf(1, "sharedfd ok\n");
    116d:	83 ec 08             	sub    $0x8,%esp
    1170:	68 7c 48 00 00       	push   $0x487c
    1175:	6a 01                	push   $0x1
    1177:	e8 54 2f 00 00       	call   40d0 <printf>
    117c:	83 c4 10             	add    $0x10,%esp
}
    117f:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1182:	5b                   	pop    %ebx
    1183:	5e                   	pop    %esi
    1184:	5f                   	pop    %edi
    1185:	5d                   	pop    %ebp
    1186:	c3                   	ret    
    printf(1, "fstests: cannot open sharedfd for writing");
    1187:	83 ec 08             	sub    $0x8,%esp
    118a:	68 38 55 00 00       	push   $0x5538
    118f:	6a 01                	push   $0x1
    1191:	e8 3a 2f 00 00       	call   40d0 <printf>
    return;
    1196:	83 c4 10             	add    $0x10,%esp
}
    1199:	8d 65 f4             	lea    -0xc(%ebp),%esp
    119c:	5b                   	pop    %ebx
    119d:	5e                   	pop    %esi
    119e:	5f                   	pop    %edi
    119f:	5d                   	pop    %ebp
    11a0:	c3                   	ret    
    printf(1, "fstests: cannot open sharedfd for reading\n");
    11a1:	83 ec 08             	sub    $0x8,%esp
    11a4:	68 84 55 00 00       	push   $0x5584
    11a9:	6a 01                	push   $0x1
    11ab:	e8 20 2f 00 00       	call   40d0 <printf>
    return;
    11b0:	83 c4 10             	add    $0x10,%esp
}
    11b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
    11b6:	5b                   	pop    %ebx
    11b7:	5e                   	pop    %esi
    11b8:	5f                   	pop    %edi
    11b9:	5d                   	pop    %ebp
    11ba:	c3                   	ret    
    exit(1);
    11bb:	83 ec 0c             	sub    $0xc,%esp
    11be:	6a 01                	push   $0x1
    11c0:	e8 8e 2d 00 00       	call   3f53 <exit>
    printf(1, "sharedfd oops %d %d\n", nc, np);
    11c5:	53                   	push   %ebx
    11c6:	52                   	push   %edx
    11c7:	68 89 48 00 00       	push   $0x4889
    11cc:	6a 01                	push   $0x1
    11ce:	e8 fd 2e 00 00       	call   40d0 <printf>
    exit(1);
    11d3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11da:	e8 74 2d 00 00       	call   3f53 <exit>
    11df:	90                   	nop

000011e0 <fourfiles>:
{
    11e0:	f3 0f 1e fb          	endbr32 
    11e4:	55                   	push   %ebp
    11e5:	89 e5                	mov    %esp,%ebp
    11e7:	57                   	push   %edi
    11e8:	56                   	push   %esi
  printf(1, "fourfiles test\n");
    11e9:	be 9e 48 00 00       	mov    $0x489e,%esi
{
    11ee:	53                   	push   %ebx
  for(pi = 0; pi < 4; pi++){
    11ef:	31 db                	xor    %ebx,%ebx
{
    11f1:	83 ec 34             	sub    $0x34,%esp
  char *names[] = { "f0", "f1", "f2", "f3" };
    11f4:	c7 45 d8 9e 48 00 00 	movl   $0x489e,-0x28(%ebp)
  printf(1, "fourfiles test\n");
    11fb:	68 a4 48 00 00       	push   $0x48a4
    1200:	6a 01                	push   $0x1
  char *names[] = { "f0", "f1", "f2", "f3" };
    1202:	c7 45 dc e7 49 00 00 	movl   $0x49e7,-0x24(%ebp)
    1209:	c7 45 e0 eb 49 00 00 	movl   $0x49eb,-0x20(%ebp)
    1210:	c7 45 e4 a1 48 00 00 	movl   $0x48a1,-0x1c(%ebp)
  printf(1, "fourfiles test\n");
    1217:	e8 b4 2e 00 00       	call   40d0 <printf>
    121c:	83 c4 10             	add    $0x10,%esp
    unlink(fname);
    121f:	83 ec 0c             	sub    $0xc,%esp
    1222:	56                   	push   %esi
    1223:	e8 7b 2d 00 00       	call   3fa3 <unlink>
    pid = fork();
    1228:	e8 1e 2d 00 00       	call   3f4b <fork>
    if(pid < 0){
    122d:	83 c4 10             	add    $0x10,%esp
    1230:	85 c0                	test   %eax,%eax
    1232:	0f 88 90 01 00 00    	js     13c8 <fourfiles+0x1e8>
    if(pid == 0){
    1238:	0f 84 0c 01 00 00    	je     134a <fourfiles+0x16a>
  for(pi = 0; pi < 4; pi++){
    123e:	83 c3 01             	add    $0x1,%ebx
    1241:	83 fb 04             	cmp    $0x4,%ebx
    1244:	74 06                	je     124c <fourfiles+0x6c>
    1246:	8b 74 9d d8          	mov    -0x28(%ebp,%ebx,4),%esi
    124a:	eb d3                	jmp    121f <fourfiles+0x3f>
    wait(null);
    124c:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < 2; i++){
    124f:	31 f6                	xor    %esi,%esi
    wait(null);
    1251:	6a 00                	push   $0x0
    1253:	e8 03 2d 00 00       	call   3f5b <wait>
    1258:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    125f:	e8 f7 2c 00 00       	call   3f5b <wait>
    1264:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    126b:	e8 eb 2c 00 00       	call   3f5b <wait>
    1270:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1277:	e8 df 2c 00 00       	call   3f5b <wait>
    127c:	83 c4 10             	add    $0x10,%esp
    fname = names[i];
    127f:	8b 44 b5 d8          	mov    -0x28(%ebp,%esi,4),%eax
    fd = open(fname, 0);
    1283:	83 ec 08             	sub    $0x8,%esp
    total = 0;
    1286:	31 db                	xor    %ebx,%ebx
    fd = open(fname, 0);
    1288:	6a 00                	push   $0x0
    128a:	50                   	push   %eax
    fname = names[i];
    128b:	89 45 d0             	mov    %eax,-0x30(%ebp)
    fd = open(fname, 0);
    128e:	e8 00 2d 00 00       	call   3f93 <open>
    while((n = read(fd, buf, sizeof(buf))) > 0){
    1293:	83 c4 10             	add    $0x10,%esp
    fd = open(fname, 0);
    1296:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    1299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    12a0:	83 ec 04             	sub    $0x4,%esp
    12a3:	68 00 20 00 00       	push   $0x2000
    12a8:	68 c0 8c 00 00       	push   $0x8cc0
    12ad:	ff 75 d4             	pushl  -0x2c(%ebp)
    12b0:	e8 b6 2c 00 00       	call   3f6b <read>
    12b5:	83 c4 10             	add    $0x10,%esp
    12b8:	85 c0                	test   %eax,%eax
    12ba:	7e 22                	jle    12de <fourfiles+0xfe>
      for(j = 0; j < n; j++){
    12bc:	31 d2                	xor    %edx,%edx
    12be:	66 90                	xchg   %ax,%ax
        if(buf[j] != '0'+i){
    12c0:	83 fe 01             	cmp    $0x1,%esi
    12c3:	0f be ba c0 8c 00 00 	movsbl 0x8cc0(%edx),%edi
    12ca:	19 c9                	sbb    %ecx,%ecx
    12cc:	83 c1 31             	add    $0x31,%ecx
    12cf:	39 cf                	cmp    %ecx,%edi
    12d1:	75 5c                	jne    132f <fourfiles+0x14f>
      for(j = 0; j < n; j++){
    12d3:	83 c2 01             	add    $0x1,%edx
    12d6:	39 d0                	cmp    %edx,%eax
    12d8:	75 e6                	jne    12c0 <fourfiles+0xe0>
      total += n;
    12da:	01 c3                	add    %eax,%ebx
    12dc:	eb c2                	jmp    12a0 <fourfiles+0xc0>
    close(fd);
    12de:	83 ec 0c             	sub    $0xc,%esp
    12e1:	ff 75 d4             	pushl  -0x2c(%ebp)
    12e4:	e8 92 2c 00 00       	call   3f7b <close>
    if(total != 12*500){
    12e9:	83 c4 10             	add    $0x10,%esp
    12ec:	81 fb 70 17 00 00    	cmp    $0x1770,%ebx
    12f2:	0f 85 eb 00 00 00    	jne    13e3 <fourfiles+0x203>
    unlink(fname);
    12f8:	83 ec 0c             	sub    $0xc,%esp
    12fb:	ff 75 d0             	pushl  -0x30(%ebp)
    12fe:	e8 a0 2c 00 00       	call   3fa3 <unlink>
  for(i = 0; i < 2; i++){
    1303:	83 c4 10             	add    $0x10,%esp
    1306:	83 fe 01             	cmp    $0x1,%esi
    1309:	75 1a                	jne    1325 <fourfiles+0x145>
  printf(1, "fourfiles ok\n");
    130b:	83 ec 08             	sub    $0x8,%esp
    130e:	68 e2 48 00 00       	push   $0x48e2
    1313:	6a 01                	push   $0x1
    1315:	e8 b6 2d 00 00       	call   40d0 <printf>
}
    131a:	83 c4 10             	add    $0x10,%esp
    131d:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1320:	5b                   	pop    %ebx
    1321:	5e                   	pop    %esi
    1322:	5f                   	pop    %edi
    1323:	5d                   	pop    %ebp
    1324:	c3                   	ret    
    1325:	be 01 00 00 00       	mov    $0x1,%esi
    132a:	e9 50 ff ff ff       	jmp    127f <fourfiles+0x9f>
          printf(1, "wrong char\n");
    132f:	83 ec 08             	sub    $0x8,%esp
    1332:	68 c5 48 00 00       	push   $0x48c5
    1337:	6a 01                	push   $0x1
    1339:	e8 92 2d 00 00       	call   40d0 <printf>
          exit(1);
    133e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1345:	e8 09 2c 00 00       	call   3f53 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    134a:	83 ec 08             	sub    $0x8,%esp
    134d:	68 02 02 00 00       	push   $0x202
    1352:	56                   	push   %esi
    1353:	e8 3b 2c 00 00       	call   3f93 <open>
      if(fd < 0){
    1358:	83 c4 10             	add    $0x10,%esp
      fd = open(fname, O_CREATE | O_RDWR);
    135b:	89 c6                	mov    %eax,%esi
      if(fd < 0){
    135d:	85 c0                	test   %eax,%eax
    135f:	78 4a                	js     13ab <fourfiles+0x1cb>
      memset(buf, '0'+pi, 512);
    1361:	83 ec 04             	sub    $0x4,%esp
    1364:	83 c3 30             	add    $0x30,%ebx
    1367:	68 00 02 00 00       	push   $0x200
    136c:	53                   	push   %ebx
    136d:	bb 0c 00 00 00       	mov    $0xc,%ebx
    1372:	68 c0 8c 00 00       	push   $0x8cc0
    1377:	e8 34 2a 00 00       	call   3db0 <memset>
    137c:	83 c4 10             	add    $0x10,%esp
        if((n = write(fd, buf, 500)) != 500){
    137f:	83 ec 04             	sub    $0x4,%esp
    1382:	68 f4 01 00 00       	push   $0x1f4
    1387:	68 c0 8c 00 00       	push   $0x8cc0
    138c:	56                   	push   %esi
    138d:	e8 e1 2b 00 00       	call   3f73 <write>
    1392:	83 c4 10             	add    $0x10,%esp
    1395:	3d f4 01 00 00       	cmp    $0x1f4,%eax
    139a:	75 61                	jne    13fd <fourfiles+0x21d>
      for(i = 0; i < 12; i++){
    139c:	83 eb 01             	sub    $0x1,%ebx
    139f:	75 de                	jne    137f <fourfiles+0x19f>
      exit(1);
    13a1:	83 ec 0c             	sub    $0xc,%esp
    13a4:	6a 01                	push   $0x1
    13a6:	e8 a8 2b 00 00       	call   3f53 <exit>
        printf(1, "create failed\n");
    13ab:	51                   	push   %ecx
    13ac:	51                   	push   %ecx
    13ad:	68 3f 4b 00 00       	push   $0x4b3f
    13b2:	6a 01                	push   $0x1
    13b4:	e8 17 2d 00 00       	call   40d0 <printf>
        exit(1);
    13b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    13c0:	e8 8e 2b 00 00       	call   3f53 <exit>
    13c5:	8d 76 00             	lea    0x0(%esi),%esi
      printf(1, "fork failed\n");
    13c8:	83 ec 08             	sub    $0x8,%esp
    13cb:	68 79 53 00 00       	push   $0x5379
    13d0:	6a 01                	push   $0x1
    13d2:	e8 f9 2c 00 00       	call   40d0 <printf>
      exit(1);
    13d7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    13de:	e8 70 2b 00 00       	call   3f53 <exit>
      printf(1, "wrong length %d\n", total);
    13e3:	50                   	push   %eax
    13e4:	53                   	push   %ebx
    13e5:	68 d1 48 00 00       	push   $0x48d1
    13ea:	6a 01                	push   $0x1
    13ec:	e8 df 2c 00 00       	call   40d0 <printf>
      exit(1);
    13f1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    13f8:	e8 56 2b 00 00       	call   3f53 <exit>
          printf(1, "write failed %d\n", n);
    13fd:	52                   	push   %edx
    13fe:	50                   	push   %eax
    13ff:	68 b4 48 00 00       	push   $0x48b4
    1404:	6a 01                	push   $0x1
    1406:	e8 c5 2c 00 00       	call   40d0 <printf>
          exit(1);
    140b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1412:	e8 3c 2b 00 00       	call   3f53 <exit>
    1417:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    141e:	66 90                	xchg   %ax,%ax

00001420 <createdelete>:
{
    1420:	f3 0f 1e fb          	endbr32 
    1424:	55                   	push   %ebp
    1425:	89 e5                	mov    %esp,%ebp
    1427:	57                   	push   %edi
    1428:	56                   	push   %esi
    1429:	53                   	push   %ebx
  for(pi = 0; pi < 4; pi++){
    142a:	31 db                	xor    %ebx,%ebx
{
    142c:	83 ec 44             	sub    $0x44,%esp
  printf(1, "createdelete test\n");
    142f:	68 f0 48 00 00       	push   $0x48f0
    1434:	6a 01                	push   $0x1
    1436:	e8 95 2c 00 00       	call   40d0 <printf>
    143b:	83 c4 10             	add    $0x10,%esp
    pid = fork();
    143e:	e8 08 2b 00 00       	call   3f4b <fork>
    if(pid < 0){
    1443:	85 c0                	test   %eax,%eax
    1445:	0f 88 09 02 00 00    	js     1654 <createdelete+0x234>
    if(pid == 0){
    144b:	0f 84 37 01 00 00    	je     1588 <createdelete+0x168>
  for(pi = 0; pi < 4; pi++){
    1451:	83 c3 01             	add    $0x1,%ebx
    1454:	83 fb 04             	cmp    $0x4,%ebx
    1457:	75 e5                	jne    143e <createdelete+0x1e>
    wait(null);
    1459:	83 ec 0c             	sub    $0xc,%esp
    145c:	8d 7d c8             	lea    -0x38(%ebp),%edi
  name[0] = name[1] = name[2] = 0;
    145f:	be ff ff ff ff       	mov    $0xffffffff,%esi
    wait(null);
    1464:	6a 00                	push   $0x0
    1466:	e8 f0 2a 00 00       	call   3f5b <wait>
    146b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1472:	e8 e4 2a 00 00       	call   3f5b <wait>
    1477:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    147e:	e8 d8 2a 00 00       	call   3f5b <wait>
    1483:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    148a:	e8 cc 2a 00 00       	call   3f5b <wait>
  name[0] = name[1] = name[2] = 0;
    148f:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
    1493:	83 c4 10             	add    $0x10,%esp
    1496:	89 7d c0             	mov    %edi,-0x40(%ebp)
    1499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for(pi = 0; pi < 4; pi++){
    14a0:	8d 46 31             	lea    0x31(%esi),%eax
    14a3:	89 f7                	mov    %esi,%edi
    14a5:	83 c6 01             	add    $0x1,%esi
    14a8:	83 fe 09             	cmp    $0x9,%esi
    14ab:	88 45 c7             	mov    %al,-0x39(%ebp)
    14ae:	0f 9f c3             	setg   %bl
    14b1:	85 f6                	test   %esi,%esi
    14b3:	0f 94 c0             	sete   %al
    14b6:	09 c3                	or     %eax,%ebx
    14b8:	88 5d c6             	mov    %bl,-0x3a(%ebp)
      name[2] = '\0';
    14bb:	bb 70 00 00 00       	mov    $0x70,%ebx
      fd = open(name, 0);
    14c0:	83 ec 08             	sub    $0x8,%esp
      name[1] = '0' + i;
    14c3:	0f b6 45 c7          	movzbl -0x39(%ebp),%eax
      name[0] = 'p' + pi;
    14c7:	88 5d c8             	mov    %bl,-0x38(%ebp)
      fd = open(name, 0);
    14ca:	6a 00                	push   $0x0
    14cc:	ff 75 c0             	pushl  -0x40(%ebp)
      name[1] = '0' + i;
    14cf:	88 45 c9             	mov    %al,-0x37(%ebp)
      fd = open(name, 0);
    14d2:	e8 bc 2a 00 00       	call   3f93 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    14d7:	83 c4 10             	add    $0x10,%esp
    14da:	80 7d c6 00          	cmpb   $0x0,-0x3a(%ebp)
    14de:	0f 84 8c 00 00 00    	je     1570 <createdelete+0x150>
    14e4:	85 c0                	test   %eax,%eax
    14e6:	0f 88 2e 01 00 00    	js     161a <createdelete+0x1fa>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    14ec:	83 ff 08             	cmp    $0x8,%edi
    14ef:	0f 86 82 01 00 00    	jbe    1677 <createdelete+0x257>
        close(fd);
    14f5:	83 ec 0c             	sub    $0xc,%esp
    14f8:	50                   	push   %eax
    14f9:	e8 7d 2a 00 00       	call   3f7b <close>
    14fe:	83 c4 10             	add    $0x10,%esp
    for(pi = 0; pi < 4; pi++){
    1501:	83 c3 01             	add    $0x1,%ebx
    1504:	80 fb 74             	cmp    $0x74,%bl
    1507:	75 b7                	jne    14c0 <createdelete+0xa0>
  for(i = 0; i < N; i++){
    1509:	83 fe 13             	cmp    $0x13,%esi
    150c:	75 92                	jne    14a0 <createdelete+0x80>
    150e:	8b 7d c0             	mov    -0x40(%ebp),%edi
    1511:	be 70 00 00 00       	mov    $0x70,%esi
    1516:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    151d:	8d 76 00             	lea    0x0(%esi),%esi
    for(pi = 0; pi < 4; pi++){
    1520:	8d 46 c0             	lea    -0x40(%esi),%eax
  name[0] = name[1] = name[2] = 0;
    1523:	bb 04 00 00 00       	mov    $0x4,%ebx
    1528:	88 45 c7             	mov    %al,-0x39(%ebp)
      unlink(name);
    152b:	83 ec 0c             	sub    $0xc,%esp
      name[0] = 'p' + i;
    152e:	89 f0                	mov    %esi,%eax
      unlink(name);
    1530:	57                   	push   %edi
      name[0] = 'p' + i;
    1531:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[1] = '0' + i;
    1534:	0f b6 45 c7          	movzbl -0x39(%ebp),%eax
    1538:	88 45 c9             	mov    %al,-0x37(%ebp)
      unlink(name);
    153b:	e8 63 2a 00 00       	call   3fa3 <unlink>
    for(pi = 0; pi < 4; pi++){
    1540:	83 c4 10             	add    $0x10,%esp
    1543:	83 eb 01             	sub    $0x1,%ebx
    1546:	75 e3                	jne    152b <createdelete+0x10b>
  for(i = 0; i < N; i++){
    1548:	83 c6 01             	add    $0x1,%esi
    154b:	89 f0                	mov    %esi,%eax
    154d:	3c 84                	cmp    $0x84,%al
    154f:	75 cf                	jne    1520 <createdelete+0x100>
  printf(1, "createdelete ok\n");
    1551:	83 ec 08             	sub    $0x8,%esp
    1554:	68 03 49 00 00       	push   $0x4903
    1559:	6a 01                	push   $0x1
    155b:	e8 70 2b 00 00       	call   40d0 <printf>
}
    1560:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1563:	5b                   	pop    %ebx
    1564:	5e                   	pop    %esi
    1565:	5f                   	pop    %edi
    1566:	5d                   	pop    %ebp
    1567:	c3                   	ret    
    1568:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    156f:	90                   	nop
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1570:	83 ff 08             	cmp    $0x8,%edi
    1573:	0f 86 f6 00 00 00    	jbe    166f <createdelete+0x24f>
      if(fd >= 0)
    1579:	85 c0                	test   %eax,%eax
    157b:	78 84                	js     1501 <createdelete+0xe1>
    157d:	e9 73 ff ff ff       	jmp    14f5 <createdelete+0xd5>
    1582:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      name[0] = 'p' + pi;
    1588:	83 c3 70             	add    $0x70,%ebx
      name[2] = '\0';
    158b:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
    158f:	8d 7d c8             	lea    -0x38(%ebp),%edi
      name[0] = 'p' + pi;
    1592:	88 5d c8             	mov    %bl,-0x38(%ebp)
      name[2] = '\0';
    1595:	31 db                	xor    %ebx,%ebx
    1597:	eb 0f                	jmp    15a8 <createdelete+0x188>
    1599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      for(i = 0; i < N; i++){
    15a0:	83 fb 13             	cmp    $0x13,%ebx
    15a3:	74 6b                	je     1610 <createdelete+0x1f0>
    15a5:	83 c3 01             	add    $0x1,%ebx
        fd = open(name, O_CREATE | O_RDWR);
    15a8:	83 ec 08             	sub    $0x8,%esp
        name[1] = '0' + i;
    15ab:	8d 43 30             	lea    0x30(%ebx),%eax
        fd = open(name, O_CREATE | O_RDWR);
    15ae:	68 02 02 00 00       	push   $0x202
    15b3:	57                   	push   %edi
        name[1] = '0' + i;
    15b4:	88 45 c9             	mov    %al,-0x37(%ebp)
        fd = open(name, O_CREATE | O_RDWR);
    15b7:	e8 d7 29 00 00       	call   3f93 <open>
        if(fd < 0){
    15bc:	83 c4 10             	add    $0x10,%esp
    15bf:	85 c0                	test   %eax,%eax
    15c1:	78 76                	js     1639 <createdelete+0x219>
        close(fd);
    15c3:	83 ec 0c             	sub    $0xc,%esp
    15c6:	50                   	push   %eax
    15c7:	e8 af 29 00 00       	call   3f7b <close>
        if(i > 0 && (i % 2 ) == 0){
    15cc:	83 c4 10             	add    $0x10,%esp
    15cf:	85 db                	test   %ebx,%ebx
    15d1:	74 d2                	je     15a5 <createdelete+0x185>
    15d3:	f6 c3 01             	test   $0x1,%bl
    15d6:	75 c8                	jne    15a0 <createdelete+0x180>
          if(unlink(name) < 0){
    15d8:	83 ec 0c             	sub    $0xc,%esp
          name[1] = '0' + (i / 2);
    15db:	89 d8                	mov    %ebx,%eax
          if(unlink(name) < 0){
    15dd:	57                   	push   %edi
          name[1] = '0' + (i / 2);
    15de:	d1 f8                	sar    %eax
    15e0:	83 c0 30             	add    $0x30,%eax
    15e3:	88 45 c9             	mov    %al,-0x37(%ebp)
          if(unlink(name) < 0){
    15e6:	e8 b8 29 00 00       	call   3fa3 <unlink>
    15eb:	83 c4 10             	add    $0x10,%esp
    15ee:	85 c0                	test   %eax,%eax
    15f0:	79 ae                	jns    15a0 <createdelete+0x180>
            printf(1, "unlink failed\n");
    15f2:	52                   	push   %edx
    15f3:	52                   	push   %edx
    15f4:	68 f1 44 00 00       	push   $0x44f1
    15f9:	6a 01                	push   $0x1
    15fb:	e8 d0 2a 00 00       	call   40d0 <printf>
            exit(1);
    1600:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1607:	e8 47 29 00 00       	call   3f53 <exit>
    160c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      exit(1);
    1610:	83 ec 0c             	sub    $0xc,%esp
    1613:	6a 01                	push   $0x1
    1615:	e8 39 29 00 00       	call   3f53 <exit>
    161a:	8b 7d c0             	mov    -0x40(%ebp),%edi
        printf(1, "oops createdelete %s didn't exist\n", name);
    161d:	83 ec 04             	sub    $0x4,%esp
    1620:	57                   	push   %edi
    1621:	68 b0 55 00 00       	push   $0x55b0
    1626:	6a 01                	push   $0x1
    1628:	e8 a3 2a 00 00       	call   40d0 <printf>
        exit(1);
    162d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1634:	e8 1a 29 00 00       	call   3f53 <exit>
          printf(1, "create failed\n");
    1639:	83 ec 08             	sub    $0x8,%esp
    163c:	68 3f 4b 00 00       	push   $0x4b3f
    1641:	6a 01                	push   $0x1
    1643:	e8 88 2a 00 00       	call   40d0 <printf>
          exit(1);
    1648:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    164f:	e8 ff 28 00 00       	call   3f53 <exit>
      printf(1, "fork failed\n");
    1654:	83 ec 08             	sub    $0x8,%esp
    1657:	68 79 53 00 00       	push   $0x5379
    165c:	6a 01                	push   $0x1
    165e:	e8 6d 2a 00 00       	call   40d0 <printf>
      exit(1);
    1663:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    166a:	e8 e4 28 00 00       	call   3f53 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    166f:	85 c0                	test   %eax,%eax
    1671:	0f 88 8a fe ff ff    	js     1501 <createdelete+0xe1>
    1677:	8b 7d c0             	mov    -0x40(%ebp),%edi
        printf(1, "oops createdelete %s did exist\n", name);
    167a:	50                   	push   %eax
    167b:	57                   	push   %edi
    167c:	68 d4 55 00 00       	push   $0x55d4
    1681:	6a 01                	push   $0x1
    1683:	e8 48 2a 00 00       	call   40d0 <printf>
        exit(1);
    1688:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    168f:	e8 bf 28 00 00       	call   3f53 <exit>
    1694:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    169b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    169f:	90                   	nop

000016a0 <unlinkread>:
{
    16a0:	f3 0f 1e fb          	endbr32 
    16a4:	55                   	push   %ebp
    16a5:	89 e5                	mov    %esp,%ebp
    16a7:	56                   	push   %esi
    16a8:	53                   	push   %ebx
  printf(1, "unlinkread test\n");
    16a9:	83 ec 08             	sub    $0x8,%esp
    16ac:	68 14 49 00 00       	push   $0x4914
    16b1:	6a 01                	push   $0x1
    16b3:	e8 18 2a 00 00       	call   40d0 <printf>
  fd = open("unlinkread", O_CREATE | O_RDWR);
    16b8:	5b                   	pop    %ebx
    16b9:	5e                   	pop    %esi
    16ba:	68 02 02 00 00       	push   $0x202
    16bf:	68 25 49 00 00       	push   $0x4925
    16c4:	e8 ca 28 00 00       	call   3f93 <open>
  if(fd < 0){
    16c9:	83 c4 10             	add    $0x10,%esp
    16cc:	85 c0                	test   %eax,%eax
    16ce:	0f 88 e6 00 00 00    	js     17ba <unlinkread+0x11a>
  write(fd, "hello", 5);
    16d4:	83 ec 04             	sub    $0x4,%esp
    16d7:	89 c3                	mov    %eax,%ebx
    16d9:	6a 05                	push   $0x5
    16db:	68 4a 49 00 00       	push   $0x494a
    16e0:	50                   	push   %eax
    16e1:	e8 8d 28 00 00       	call   3f73 <write>
  close(fd);
    16e6:	89 1c 24             	mov    %ebx,(%esp)
    16e9:	e8 8d 28 00 00       	call   3f7b <close>
  fd = open("unlinkread", O_RDWR);
    16ee:	58                   	pop    %eax
    16ef:	5a                   	pop    %edx
    16f0:	6a 02                	push   $0x2
    16f2:	68 25 49 00 00       	push   $0x4925
    16f7:	e8 97 28 00 00       	call   3f93 <open>
  if(fd < 0){
    16fc:	83 c4 10             	add    $0x10,%esp
  fd = open("unlinkread", O_RDWR);
    16ff:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1701:	85 c0                	test   %eax,%eax
    1703:	0f 88 33 01 00 00    	js     183c <unlinkread+0x19c>
  if(unlink("unlinkread") != 0){
    1709:	83 ec 0c             	sub    $0xc,%esp
    170c:	68 25 49 00 00       	push   $0x4925
    1711:	e8 8d 28 00 00       	call   3fa3 <unlink>
    1716:	83 c4 10             	add    $0x10,%esp
    1719:	85 c0                	test   %eax,%eax
    171b:	0f 85 01 01 00 00    	jne    1822 <unlinkread+0x182>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    1721:	83 ec 08             	sub    $0x8,%esp
    1724:	68 02 02 00 00       	push   $0x202
    1729:	68 25 49 00 00       	push   $0x4925
    172e:	e8 60 28 00 00       	call   3f93 <open>
  write(fd1, "yyy", 3);
    1733:	83 c4 0c             	add    $0xc,%esp
    1736:	6a 03                	push   $0x3
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    1738:	89 c6                	mov    %eax,%esi
  write(fd1, "yyy", 3);
    173a:	68 82 49 00 00       	push   $0x4982
    173f:	50                   	push   %eax
    1740:	e8 2e 28 00 00       	call   3f73 <write>
  close(fd1);
    1745:	89 34 24             	mov    %esi,(%esp)
    1748:	e8 2e 28 00 00       	call   3f7b <close>
  if(read(fd, buf, sizeof(buf)) != 5){
    174d:	83 c4 0c             	add    $0xc,%esp
    1750:	68 00 20 00 00       	push   $0x2000
    1755:	68 c0 8c 00 00       	push   $0x8cc0
    175a:	53                   	push   %ebx
    175b:	e8 0b 28 00 00       	call   3f6b <read>
    1760:	83 c4 10             	add    $0x10,%esp
    1763:	83 f8 05             	cmp    $0x5,%eax
    1766:	0f 85 9c 00 00 00    	jne    1808 <unlinkread+0x168>
  if(buf[0] != 'h'){
    176c:	80 3d c0 8c 00 00 68 	cmpb   $0x68,0x8cc0
    1773:	75 79                	jne    17ee <unlinkread+0x14e>
  if(write(fd, buf, 10) != 10){
    1775:	83 ec 04             	sub    $0x4,%esp
    1778:	6a 0a                	push   $0xa
    177a:	68 c0 8c 00 00       	push   $0x8cc0
    177f:	53                   	push   %ebx
    1780:	e8 ee 27 00 00       	call   3f73 <write>
    1785:	83 c4 10             	add    $0x10,%esp
    1788:	83 f8 0a             	cmp    $0xa,%eax
    178b:	75 47                	jne    17d4 <unlinkread+0x134>
  close(fd);
    178d:	83 ec 0c             	sub    $0xc,%esp
    1790:	53                   	push   %ebx
    1791:	e8 e5 27 00 00       	call   3f7b <close>
  unlink("unlinkread");
    1796:	c7 04 24 25 49 00 00 	movl   $0x4925,(%esp)
    179d:	e8 01 28 00 00       	call   3fa3 <unlink>
  printf(1, "unlinkread ok\n");
    17a2:	58                   	pop    %eax
    17a3:	5a                   	pop    %edx
    17a4:	68 cd 49 00 00       	push   $0x49cd
    17a9:	6a 01                	push   $0x1
    17ab:	e8 20 29 00 00       	call   40d0 <printf>
}
    17b0:	83 c4 10             	add    $0x10,%esp
    17b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
    17b6:	5b                   	pop    %ebx
    17b7:	5e                   	pop    %esi
    17b8:	5d                   	pop    %ebp
    17b9:	c3                   	ret    
    printf(1, "create unlinkread failed\n");
    17ba:	51                   	push   %ecx
    17bb:	51                   	push   %ecx
    17bc:	68 30 49 00 00       	push   $0x4930
    17c1:	6a 01                	push   $0x1
    17c3:	e8 08 29 00 00       	call   40d0 <printf>
    exit(1);
    17c8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    17cf:	e8 7f 27 00 00       	call   3f53 <exit>
    printf(1, "unlinkread write failed\n");
    17d4:	51                   	push   %ecx
    17d5:	51                   	push   %ecx
    17d6:	68 b4 49 00 00       	push   $0x49b4
    17db:	6a 01                	push   $0x1
    17dd:	e8 ee 28 00 00       	call   40d0 <printf>
    exit(1);
    17e2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    17e9:	e8 65 27 00 00       	call   3f53 <exit>
    printf(1, "unlinkread wrong data\n");
    17ee:	53                   	push   %ebx
    17ef:	53                   	push   %ebx
    17f0:	68 9d 49 00 00       	push   $0x499d
    17f5:	6a 01                	push   $0x1
    17f7:	e8 d4 28 00 00       	call   40d0 <printf>
    exit(1);
    17fc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1803:	e8 4b 27 00 00       	call   3f53 <exit>
    printf(1, "unlinkread read failed");
    1808:	56                   	push   %esi
    1809:	56                   	push   %esi
    180a:	68 86 49 00 00       	push   $0x4986
    180f:	6a 01                	push   $0x1
    1811:	e8 ba 28 00 00       	call   40d0 <printf>
    exit(1);
    1816:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    181d:	e8 31 27 00 00       	call   3f53 <exit>
    printf(1, "unlink unlinkread failed\n");
    1822:	50                   	push   %eax
    1823:	50                   	push   %eax
    1824:	68 68 49 00 00       	push   $0x4968
    1829:	6a 01                	push   $0x1
    182b:	e8 a0 28 00 00       	call   40d0 <printf>
    exit(1);
    1830:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1837:	e8 17 27 00 00       	call   3f53 <exit>
    printf(1, "open unlinkread failed\n");
    183c:	50                   	push   %eax
    183d:	50                   	push   %eax
    183e:	68 50 49 00 00       	push   $0x4950
    1843:	6a 01                	push   $0x1
    1845:	e8 86 28 00 00       	call   40d0 <printf>
    exit(1);
    184a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1851:	e8 fd 26 00 00       	call   3f53 <exit>
    1856:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    185d:	8d 76 00             	lea    0x0(%esi),%esi

00001860 <linktest>:
{
    1860:	f3 0f 1e fb          	endbr32 
    1864:	55                   	push   %ebp
    1865:	89 e5                	mov    %esp,%ebp
    1867:	53                   	push   %ebx
    1868:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "linktest\n");
    186b:	68 dc 49 00 00       	push   $0x49dc
    1870:	6a 01                	push   $0x1
    1872:	e8 59 28 00 00       	call   40d0 <printf>
  unlink("lf1");
    1877:	c7 04 24 e6 49 00 00 	movl   $0x49e6,(%esp)
    187e:	e8 20 27 00 00       	call   3fa3 <unlink>
  unlink("lf2");
    1883:	c7 04 24 ea 49 00 00 	movl   $0x49ea,(%esp)
    188a:	e8 14 27 00 00       	call   3fa3 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
    188f:	58                   	pop    %eax
    1890:	5a                   	pop    %edx
    1891:	68 02 02 00 00       	push   $0x202
    1896:	68 e6 49 00 00       	push   $0x49e6
    189b:	e8 f3 26 00 00       	call   3f93 <open>
  if(fd < 0){
    18a0:	83 c4 10             	add    $0x10,%esp
    18a3:	85 c0                	test   %eax,%eax
    18a5:	0f 88 1e 01 00 00    	js     19c9 <linktest+0x169>
  if(write(fd, "hello", 5) != 5){
    18ab:	83 ec 04             	sub    $0x4,%esp
    18ae:	89 c3                	mov    %eax,%ebx
    18b0:	6a 05                	push   $0x5
    18b2:	68 4a 49 00 00       	push   $0x494a
    18b7:	50                   	push   %eax
    18b8:	e8 b6 26 00 00       	call   3f73 <write>
    18bd:	83 c4 10             	add    $0x10,%esp
    18c0:	83 f8 05             	cmp    $0x5,%eax
    18c3:	0f 85 d0 01 00 00    	jne    1a99 <linktest+0x239>
  close(fd);
    18c9:	83 ec 0c             	sub    $0xc,%esp
    18cc:	53                   	push   %ebx
    18cd:	e8 a9 26 00 00       	call   3f7b <close>
  if(link("lf1", "lf2") < 0){
    18d2:	5b                   	pop    %ebx
    18d3:	58                   	pop    %eax
    18d4:	68 ea 49 00 00       	push   $0x49ea
    18d9:	68 e6 49 00 00       	push   $0x49e6
    18de:	e8 d0 26 00 00       	call   3fb3 <link>
    18e3:	83 c4 10             	add    $0x10,%esp
    18e6:	85 c0                	test   %eax,%eax
    18e8:	0f 88 91 01 00 00    	js     1a7f <linktest+0x21f>
  unlink("lf1");
    18ee:	83 ec 0c             	sub    $0xc,%esp
    18f1:	68 e6 49 00 00       	push   $0x49e6
    18f6:	e8 a8 26 00 00       	call   3fa3 <unlink>
  if(open("lf1", 0) >= 0){
    18fb:	58                   	pop    %eax
    18fc:	5a                   	pop    %edx
    18fd:	6a 00                	push   $0x0
    18ff:	68 e6 49 00 00       	push   $0x49e6
    1904:	e8 8a 26 00 00       	call   3f93 <open>
    1909:	83 c4 10             	add    $0x10,%esp
    190c:	85 c0                	test   %eax,%eax
    190e:	0f 89 51 01 00 00    	jns    1a65 <linktest+0x205>
  fd = open("lf2", 0);
    1914:	83 ec 08             	sub    $0x8,%esp
    1917:	6a 00                	push   $0x0
    1919:	68 ea 49 00 00       	push   $0x49ea
    191e:	e8 70 26 00 00       	call   3f93 <open>
  if(fd < 0){
    1923:	83 c4 10             	add    $0x10,%esp
  fd = open("lf2", 0);
    1926:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1928:	85 c0                	test   %eax,%eax
    192a:	0f 88 1b 01 00 00    	js     1a4b <linktest+0x1eb>
  if(read(fd, buf, sizeof(buf)) != 5){
    1930:	83 ec 04             	sub    $0x4,%esp
    1933:	68 00 20 00 00       	push   $0x2000
    1938:	68 c0 8c 00 00       	push   $0x8cc0
    193d:	50                   	push   %eax
    193e:	e8 28 26 00 00       	call   3f6b <read>
    1943:	83 c4 10             	add    $0x10,%esp
    1946:	83 f8 05             	cmp    $0x5,%eax
    1949:	0f 85 e2 00 00 00    	jne    1a31 <linktest+0x1d1>
  close(fd);
    194f:	83 ec 0c             	sub    $0xc,%esp
    1952:	53                   	push   %ebx
    1953:	e8 23 26 00 00       	call   3f7b <close>
  if(link("lf2", "lf2") >= 0){
    1958:	58                   	pop    %eax
    1959:	5a                   	pop    %edx
    195a:	68 ea 49 00 00       	push   $0x49ea
    195f:	68 ea 49 00 00       	push   $0x49ea
    1964:	e8 4a 26 00 00       	call   3fb3 <link>
    1969:	83 c4 10             	add    $0x10,%esp
    196c:	85 c0                	test   %eax,%eax
    196e:	0f 89 a3 00 00 00    	jns    1a17 <linktest+0x1b7>
  unlink("lf2");
    1974:	83 ec 0c             	sub    $0xc,%esp
    1977:	68 ea 49 00 00       	push   $0x49ea
    197c:	e8 22 26 00 00       	call   3fa3 <unlink>
  if(link("lf2", "lf1") >= 0){
    1981:	59                   	pop    %ecx
    1982:	5b                   	pop    %ebx
    1983:	68 e6 49 00 00       	push   $0x49e6
    1988:	68 ea 49 00 00       	push   $0x49ea
    198d:	e8 21 26 00 00       	call   3fb3 <link>
    1992:	83 c4 10             	add    $0x10,%esp
    1995:	85 c0                	test   %eax,%eax
    1997:	79 64                	jns    19fd <linktest+0x19d>
  if(link(".", "lf1") >= 0){
    1999:	83 ec 08             	sub    $0x8,%esp
    199c:	68 e6 49 00 00       	push   $0x49e6
    19a1:	68 ae 4c 00 00       	push   $0x4cae
    19a6:	e8 08 26 00 00       	call   3fb3 <link>
    19ab:	83 c4 10             	add    $0x10,%esp
    19ae:	85 c0                	test   %eax,%eax
    19b0:	79 31                	jns    19e3 <linktest+0x183>
  printf(1, "linktest ok\n");
    19b2:	83 ec 08             	sub    $0x8,%esp
    19b5:	68 84 4a 00 00       	push   $0x4a84
    19ba:	6a 01                	push   $0x1
    19bc:	e8 0f 27 00 00       	call   40d0 <printf>
}
    19c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    19c4:	83 c4 10             	add    $0x10,%esp
    19c7:	c9                   	leave  
    19c8:	c3                   	ret    
    printf(1, "create lf1 failed\n");
    19c9:	50                   	push   %eax
    19ca:	50                   	push   %eax
    19cb:	68 ee 49 00 00       	push   $0x49ee
    19d0:	6a 01                	push   $0x1
    19d2:	e8 f9 26 00 00       	call   40d0 <printf>
    exit(1);
    19d7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    19de:	e8 70 25 00 00       	call   3f53 <exit>
    printf(1, "link . lf1 succeeded! oops\n");
    19e3:	50                   	push   %eax
    19e4:	50                   	push   %eax
    19e5:	68 68 4a 00 00       	push   $0x4a68
    19ea:	6a 01                	push   $0x1
    19ec:	e8 df 26 00 00       	call   40d0 <printf>
    exit(1);
    19f1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    19f8:	e8 56 25 00 00       	call   3f53 <exit>
    printf(1, "link non-existant succeeded! oops\n");
    19fd:	52                   	push   %edx
    19fe:	52                   	push   %edx
    19ff:	68 1c 56 00 00       	push   $0x561c
    1a04:	6a 01                	push   $0x1
    1a06:	e8 c5 26 00 00       	call   40d0 <printf>
    exit(1);
    1a0b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a12:	e8 3c 25 00 00       	call   3f53 <exit>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    1a17:	50                   	push   %eax
    1a18:	50                   	push   %eax
    1a19:	68 4a 4a 00 00       	push   $0x4a4a
    1a1e:	6a 01                	push   $0x1
    1a20:	e8 ab 26 00 00       	call   40d0 <printf>
    exit(1);
    1a25:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a2c:	e8 22 25 00 00       	call   3f53 <exit>
    printf(1, "read lf2 failed\n");
    1a31:	51                   	push   %ecx
    1a32:	51                   	push   %ecx
    1a33:	68 39 4a 00 00       	push   $0x4a39
    1a38:	6a 01                	push   $0x1
    1a3a:	e8 91 26 00 00       	call   40d0 <printf>
    exit(1);
    1a3f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a46:	e8 08 25 00 00       	call   3f53 <exit>
    printf(1, "open lf2 failed\n");
    1a4b:	53                   	push   %ebx
    1a4c:	53                   	push   %ebx
    1a4d:	68 28 4a 00 00       	push   $0x4a28
    1a52:	6a 01                	push   $0x1
    1a54:	e8 77 26 00 00       	call   40d0 <printf>
    exit(1);
    1a59:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a60:	e8 ee 24 00 00       	call   3f53 <exit>
    printf(1, "unlinked lf1 but it is still there!\n");
    1a65:	50                   	push   %eax
    1a66:	50                   	push   %eax
    1a67:	68 f4 55 00 00       	push   $0x55f4
    1a6c:	6a 01                	push   $0x1
    1a6e:	e8 5d 26 00 00       	call   40d0 <printf>
    exit(1);
    1a73:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a7a:	e8 d4 24 00 00       	call   3f53 <exit>
    printf(1, "link lf1 lf2 failed\n");
    1a7f:	51                   	push   %ecx
    1a80:	51                   	push   %ecx
    1a81:	68 13 4a 00 00       	push   $0x4a13
    1a86:	6a 01                	push   $0x1
    1a88:	e8 43 26 00 00       	call   40d0 <printf>
    exit(1);
    1a8d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a94:	e8 ba 24 00 00       	call   3f53 <exit>
    printf(1, "write lf1 failed\n");
    1a99:	50                   	push   %eax
    1a9a:	50                   	push   %eax
    1a9b:	68 01 4a 00 00       	push   $0x4a01
    1aa0:	6a 01                	push   $0x1
    1aa2:	e8 29 26 00 00       	call   40d0 <printf>
    exit(1);
    1aa7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1aae:	e8 a0 24 00 00       	call   3f53 <exit>
    1ab3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00001ac0 <concreate>:
{
    1ac0:	f3 0f 1e fb          	endbr32 
    1ac4:	55                   	push   %ebp
    1ac5:	89 e5                	mov    %esp,%ebp
    1ac7:	57                   	push   %edi
    1ac8:	56                   	push   %esi
  for(i = 0; i < 40; i++){
    1ac9:	31 f6                	xor    %esi,%esi
{
    1acb:	53                   	push   %ebx
    1acc:	8d 5d ad             	lea    -0x53(%ebp),%ebx
    1acf:	83 ec 64             	sub    $0x64,%esp
  printf(1, "concreate test\n");
    1ad2:	68 91 4a 00 00       	push   $0x4a91
    1ad7:	6a 01                	push   $0x1
    1ad9:	e8 f2 25 00 00       	call   40d0 <printf>
  file[0] = 'C';
    1ade:	c6 45 ad 43          	movb   $0x43,-0x53(%ebp)
  file[2] = '\0';
    1ae2:	83 c4 10             	add    $0x10,%esp
    1ae5:	c6 45 af 00          	movb   $0x0,-0x51(%ebp)
  for(i = 0; i < 40; i++){
    1ae9:	eb 50                	jmp    1b3b <concreate+0x7b>
    1aeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1aef:	90                   	nop
    1af0:	69 c6 ab aa aa aa    	imul   $0xaaaaaaab,%esi,%eax
    if(pid && (i % 3) == 1){
    1af6:	3d ab aa aa aa       	cmp    $0xaaaaaaab,%eax
    1afb:	0f 83 bf 00 00 00    	jae    1bc0 <concreate+0x100>
      fd = open(file, O_CREATE | O_RDWR);
    1b01:	83 ec 08             	sub    $0x8,%esp
    1b04:	68 02 02 00 00       	push   $0x202
    1b09:	53                   	push   %ebx
    1b0a:	e8 84 24 00 00       	call   3f93 <open>
      if(fd < 0){
    1b0f:	83 c4 10             	add    $0x10,%esp
    1b12:	85 c0                	test   %eax,%eax
    1b14:	78 67                	js     1b7d <concreate+0xbd>
      close(fd);
    1b16:	83 ec 0c             	sub    $0xc,%esp
    1b19:	50                   	push   %eax
    1b1a:	e8 5c 24 00 00       	call   3f7b <close>
    1b1f:	83 c4 10             	add    $0x10,%esp
      wait(null);
    1b22:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < 40; i++){
    1b25:	83 c6 01             	add    $0x1,%esi
      wait(null);
    1b28:	6a 00                	push   $0x0
    1b2a:	e8 2c 24 00 00       	call   3f5b <wait>
  for(i = 0; i < 40; i++){
    1b2f:	83 c4 10             	add    $0x10,%esp
    1b32:	83 fe 28             	cmp    $0x28,%esi
    1b35:	0f 84 a5 00 00 00    	je     1be0 <concreate+0x120>
    unlink(file);
    1b3b:	83 ec 0c             	sub    $0xc,%esp
    file[1] = '0' + i;
    1b3e:	8d 46 30             	lea    0x30(%esi),%eax
    unlink(file);
    1b41:	53                   	push   %ebx
    file[1] = '0' + i;
    1b42:	88 45 ae             	mov    %al,-0x52(%ebp)
    unlink(file);
    1b45:	e8 59 24 00 00       	call   3fa3 <unlink>
    pid = fork();
    1b4a:	e8 fc 23 00 00       	call   3f4b <fork>
    if(pid && (i % 3) == 1){
    1b4f:	83 c4 10             	add    $0x10,%esp
    1b52:	85 c0                	test   %eax,%eax
    1b54:	75 9a                	jne    1af0 <concreate+0x30>
      link("C0", file);
    1b56:	69 f6 cd cc cc cc    	imul   $0xcccccccd,%esi,%esi
    } else if(pid == 0 && (i % 5) == 1){
    1b5c:	81 fe cd cc cc cc    	cmp    $0xcccccccd,%esi
    1b62:	73 3c                	jae    1ba0 <concreate+0xe0>
      fd = open(file, O_CREATE | O_RDWR);
    1b64:	83 ec 08             	sub    $0x8,%esp
    1b67:	68 02 02 00 00       	push   $0x202
    1b6c:	53                   	push   %ebx
    1b6d:	e8 21 24 00 00       	call   3f93 <open>
      if(fd < 0){
    1b72:	83 c4 10             	add    $0x10,%esp
    1b75:	85 c0                	test   %eax,%eax
    1b77:	0f 89 5d 02 00 00    	jns    1dda <concreate+0x31a>
        printf(1, "concreate create %s failed\n", file);
    1b7d:	83 ec 04             	sub    $0x4,%esp
    1b80:	53                   	push   %ebx
    1b81:	68 a4 4a 00 00       	push   $0x4aa4
    1b86:	6a 01                	push   $0x1
    1b88:	e8 43 25 00 00       	call   40d0 <printf>
        exit(1);
    1b8d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b94:	e8 ba 23 00 00       	call   3f53 <exit>
    1b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      link("C0", file);
    1ba0:	83 ec 08             	sub    $0x8,%esp
    1ba3:	53                   	push   %ebx
    1ba4:	68 a1 4a 00 00       	push   $0x4aa1
    1ba9:	e8 05 24 00 00       	call   3fb3 <link>
    1bae:	83 c4 10             	add    $0x10,%esp
      exit(1);
    1bb1:	83 ec 0c             	sub    $0xc,%esp
    1bb4:	6a 01                	push   $0x1
    1bb6:	e8 98 23 00 00       	call   3f53 <exit>
    1bbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1bbf:	90                   	nop
      link("C0", file);
    1bc0:	83 ec 08             	sub    $0x8,%esp
    1bc3:	53                   	push   %ebx
    1bc4:	68 a1 4a 00 00       	push   $0x4aa1
    1bc9:	e8 e5 23 00 00       	call   3fb3 <link>
    1bce:	83 c4 10             	add    $0x10,%esp
    1bd1:	e9 4c ff ff ff       	jmp    1b22 <concreate+0x62>
    1bd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1bdd:	8d 76 00             	lea    0x0(%esi),%esi
  memset(fa, 0, sizeof(fa));
    1be0:	83 ec 04             	sub    $0x4,%esp
    1be3:	8d 45 c0             	lea    -0x40(%ebp),%eax
    1be6:	6a 28                	push   $0x28
    1be8:	6a 00                	push   $0x0
    1bea:	50                   	push   %eax
    1beb:	e8 c0 21 00 00       	call   3db0 <memset>
  fd = open(".", 0);
    1bf0:	5e                   	pop    %esi
    1bf1:	5f                   	pop    %edi
    1bf2:	6a 00                	push   $0x0
    1bf4:	68 ae 4c 00 00       	push   $0x4cae
    1bf9:	8d 7d b0             	lea    -0x50(%ebp),%edi
    1bfc:	e8 92 23 00 00       	call   3f93 <open>
  n = 0;
    1c01:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
  while(read(fd, &de, sizeof(de)) > 0){
    1c08:	83 c4 10             	add    $0x10,%esp
  fd = open(".", 0);
    1c0b:	89 c6                	mov    %eax,%esi
  while(read(fd, &de, sizeof(de)) > 0){
    1c0d:	8d 76 00             	lea    0x0(%esi),%esi
    1c10:	83 ec 04             	sub    $0x4,%esp
    1c13:	6a 10                	push   $0x10
    1c15:	57                   	push   %edi
    1c16:	56                   	push   %esi
    1c17:	e8 4f 23 00 00       	call   3f6b <read>
    1c1c:	83 c4 10             	add    $0x10,%esp
    1c1f:	85 c0                	test   %eax,%eax
    1c21:	7e 3d                	jle    1c60 <concreate+0x1a0>
    if(de.inum == 0)
    1c23:	66 83 7d b0 00       	cmpw   $0x0,-0x50(%ebp)
    1c28:	74 e6                	je     1c10 <concreate+0x150>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    1c2a:	80 7d b2 43          	cmpb   $0x43,-0x4e(%ebp)
    1c2e:	75 e0                	jne    1c10 <concreate+0x150>
    1c30:	80 7d b4 00          	cmpb   $0x0,-0x4c(%ebp)
    1c34:	75 da                	jne    1c10 <concreate+0x150>
      i = de.name[1] - '0';
    1c36:	0f be 45 b3          	movsbl -0x4d(%ebp),%eax
    1c3a:	83 e8 30             	sub    $0x30,%eax
      if(i < 0 || i >= sizeof(fa)){
    1c3d:	83 f8 27             	cmp    $0x27,%eax
    1c40:	0f 87 75 01 00 00    	ja     1dbb <concreate+0x2fb>
      if(fa[i]){
    1c46:	80 7c 05 c0 00       	cmpb   $0x0,-0x40(%ebp,%eax,1)
    1c4b:	0f 85 4b 01 00 00    	jne    1d9c <concreate+0x2dc>
      n++;
    1c51:	83 45 a4 01          	addl   $0x1,-0x5c(%ebp)
      fa[i] = 1;
    1c55:	c6 44 05 c0 01       	movb   $0x1,-0x40(%ebp,%eax,1)
      n++;
    1c5a:	eb b4                	jmp    1c10 <concreate+0x150>
    1c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  close(fd);
    1c60:	83 ec 0c             	sub    $0xc,%esp
    1c63:	56                   	push   %esi
    1c64:	e8 12 23 00 00       	call   3f7b <close>
  if(n != 40){
    1c69:	83 c4 10             	add    $0x10,%esp
    1c6c:	83 7d a4 28          	cmpl   $0x28,-0x5c(%ebp)
    1c70:	0f 85 0c 01 00 00    	jne    1d82 <concreate+0x2c2>
  for(i = 0; i < 40; i++){
    1c76:	31 f6                	xor    %esi,%esi
    1c78:	eb 54                	jmp    1cce <concreate+0x20e>
    1c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
       ((i % 3) == 1 && pid != 0)){
    1c80:	85 ff                	test   %edi,%edi
    1c82:	74 05                	je     1c89 <concreate+0x1c9>
    1c84:	83 f8 01             	cmp    $0x1,%eax
    1c87:	74 74                	je     1cfd <concreate+0x23d>
      unlink(file);
    1c89:	83 ec 0c             	sub    $0xc,%esp
    1c8c:	53                   	push   %ebx
    1c8d:	e8 11 23 00 00       	call   3fa3 <unlink>
      unlink(file);
    1c92:	89 1c 24             	mov    %ebx,(%esp)
    1c95:	e8 09 23 00 00       	call   3fa3 <unlink>
      unlink(file);
    1c9a:	89 1c 24             	mov    %ebx,(%esp)
    1c9d:	e8 01 23 00 00       	call   3fa3 <unlink>
      unlink(file);
    1ca2:	89 1c 24             	mov    %ebx,(%esp)
    1ca5:	e8 f9 22 00 00       	call   3fa3 <unlink>
    1caa:	83 c4 10             	add    $0x10,%esp
    if(pid == 0)
    1cad:	85 ff                	test   %edi,%edi
    1caf:	0f 84 fc fe ff ff    	je     1bb1 <concreate+0xf1>
      wait(null);
    1cb5:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < 40; i++){
    1cb8:	83 c6 01             	add    $0x1,%esi
      wait(null);
    1cbb:	6a 00                	push   $0x0
    1cbd:	e8 99 22 00 00       	call   3f5b <wait>
  for(i = 0; i < 40; i++){
    1cc2:	83 c4 10             	add    $0x10,%esp
    1cc5:	83 fe 28             	cmp    $0x28,%esi
    1cc8:	0f 84 82 00 00 00    	je     1d50 <concreate+0x290>
    file[1] = '0' + i;
    1cce:	8d 46 30             	lea    0x30(%esi),%eax
    1cd1:	88 45 ae             	mov    %al,-0x52(%ebp)
    pid = fork();
    1cd4:	e8 72 22 00 00       	call   3f4b <fork>
    1cd9:	89 c7                	mov    %eax,%edi
    if(pid < 0){
    1cdb:	85 c0                	test   %eax,%eax
    1cdd:	0f 88 84 00 00 00    	js     1d67 <concreate+0x2a7>
    if(((i % 3) == 0 && pid == 0) ||
    1ce3:	b8 ab aa aa aa       	mov    $0xaaaaaaab,%eax
    1ce8:	f7 e6                	mul    %esi
    1cea:	89 d0                	mov    %edx,%eax
    1cec:	83 e2 fe             	and    $0xfffffffe,%edx
    1cef:	d1 e8                	shr    %eax
    1cf1:	01 c2                	add    %eax,%edx
    1cf3:	89 f0                	mov    %esi,%eax
    1cf5:	29 d0                	sub    %edx,%eax
    1cf7:	89 c1                	mov    %eax,%ecx
    1cf9:	09 f9                	or     %edi,%ecx
    1cfb:	75 83                	jne    1c80 <concreate+0x1c0>
      close(open(file, 0));
    1cfd:	83 ec 08             	sub    $0x8,%esp
    1d00:	6a 00                	push   $0x0
    1d02:	53                   	push   %ebx
    1d03:	e8 8b 22 00 00       	call   3f93 <open>
    1d08:	89 04 24             	mov    %eax,(%esp)
    1d0b:	e8 6b 22 00 00       	call   3f7b <close>
      close(open(file, 0));
    1d10:	58                   	pop    %eax
    1d11:	5a                   	pop    %edx
    1d12:	6a 00                	push   $0x0
    1d14:	53                   	push   %ebx
    1d15:	e8 79 22 00 00       	call   3f93 <open>
    1d1a:	89 04 24             	mov    %eax,(%esp)
    1d1d:	e8 59 22 00 00       	call   3f7b <close>
      close(open(file, 0));
    1d22:	59                   	pop    %ecx
    1d23:	58                   	pop    %eax
    1d24:	6a 00                	push   $0x0
    1d26:	53                   	push   %ebx
    1d27:	e8 67 22 00 00       	call   3f93 <open>
    1d2c:	89 04 24             	mov    %eax,(%esp)
    1d2f:	e8 47 22 00 00       	call   3f7b <close>
      close(open(file, 0));
    1d34:	58                   	pop    %eax
    1d35:	5a                   	pop    %edx
    1d36:	6a 00                	push   $0x0
    1d38:	53                   	push   %ebx
    1d39:	e8 55 22 00 00       	call   3f93 <open>
    1d3e:	89 04 24             	mov    %eax,(%esp)
    1d41:	e8 35 22 00 00       	call   3f7b <close>
    1d46:	83 c4 10             	add    $0x10,%esp
    1d49:	e9 5f ff ff ff       	jmp    1cad <concreate+0x1ed>
    1d4e:	66 90                	xchg   %ax,%ax
  printf(1, "concreate ok\n");
    1d50:	83 ec 08             	sub    $0x8,%esp
    1d53:	68 f6 4a 00 00       	push   $0x4af6
    1d58:	6a 01                	push   $0x1
    1d5a:	e8 71 23 00 00       	call   40d0 <printf>
}
    1d5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1d62:	5b                   	pop    %ebx
    1d63:	5e                   	pop    %esi
    1d64:	5f                   	pop    %edi
    1d65:	5d                   	pop    %ebp
    1d66:	c3                   	ret    
      printf(1, "fork failed\n");
    1d67:	83 ec 08             	sub    $0x8,%esp
    1d6a:	68 79 53 00 00       	push   $0x5379
    1d6f:	6a 01                	push   $0x1
    1d71:	e8 5a 23 00 00       	call   40d0 <printf>
      exit(1);
    1d76:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1d7d:	e8 d1 21 00 00       	call   3f53 <exit>
    printf(1, "concreate not enough files in directory listing\n");
    1d82:	51                   	push   %ecx
    1d83:	51                   	push   %ecx
    1d84:	68 40 56 00 00       	push   $0x5640
    1d89:	6a 01                	push   $0x1
    1d8b:	e8 40 23 00 00       	call   40d0 <printf>
    exit(1);
    1d90:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1d97:	e8 b7 21 00 00       	call   3f53 <exit>
        printf(1, "concreate duplicate file %s\n", de.name);
    1d9c:	83 ec 04             	sub    $0x4,%esp
    1d9f:	8d 45 b2             	lea    -0x4e(%ebp),%eax
    1da2:	50                   	push   %eax
    1da3:	68 d9 4a 00 00       	push   $0x4ad9
    1da8:	6a 01                	push   $0x1
    1daa:	e8 21 23 00 00       	call   40d0 <printf>
        exit(1);
    1daf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1db6:	e8 98 21 00 00       	call   3f53 <exit>
        printf(1, "concreate weird file %s\n", de.name);
    1dbb:	83 ec 04             	sub    $0x4,%esp
    1dbe:	8d 45 b2             	lea    -0x4e(%ebp),%eax
    1dc1:	50                   	push   %eax
    1dc2:	68 c0 4a 00 00       	push   $0x4ac0
    1dc7:	6a 01                	push   $0x1
    1dc9:	e8 02 23 00 00       	call   40d0 <printf>
        exit(1);
    1dce:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1dd5:	e8 79 21 00 00       	call   3f53 <exit>
      close(fd);
    1dda:	83 ec 0c             	sub    $0xc,%esp
    1ddd:	50                   	push   %eax
    1dde:	e8 98 21 00 00       	call   3f7b <close>
    1de3:	83 c4 10             	add    $0x10,%esp
    1de6:	e9 c6 fd ff ff       	jmp    1bb1 <concreate+0xf1>
    1deb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1def:	90                   	nop

00001df0 <linkunlink>:
{
    1df0:	f3 0f 1e fb          	endbr32 
    1df4:	55                   	push   %ebp
    1df5:	89 e5                	mov    %esp,%ebp
    1df7:	57                   	push   %edi
    1df8:	56                   	push   %esi
    1df9:	53                   	push   %ebx
    1dfa:	83 ec 24             	sub    $0x24,%esp
  printf(1, "linkunlink test\n");
    1dfd:	68 04 4b 00 00       	push   $0x4b04
    1e02:	6a 01                	push   $0x1
    1e04:	e8 c7 22 00 00       	call   40d0 <printf>
  unlink("x");
    1e09:	c7 04 24 91 4d 00 00 	movl   $0x4d91,(%esp)
    1e10:	e8 8e 21 00 00       	call   3fa3 <unlink>
  pid = fork();
    1e15:	e8 31 21 00 00       	call   3f4b <fork>
  if(pid < 0){
    1e1a:	83 c4 10             	add    $0x10,%esp
  pid = fork();
    1e1d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(pid < 0){
    1e20:	85 c0                	test   %eax,%eax
    1e22:	0f 88 c2 00 00 00    	js     1eea <linkunlink+0xfa>
  unsigned int x = (pid ? 1 : 97);
    1e28:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
    1e2c:	bb 64 00 00 00       	mov    $0x64,%ebx
    if((x % 3) == 0){
    1e31:	be ab aa aa aa       	mov    $0xaaaaaaab,%esi
  unsigned int x = (pid ? 1 : 97);
    1e36:	19 ff                	sbb    %edi,%edi
    1e38:	83 e7 60             	and    $0x60,%edi
    1e3b:	83 c7 01             	add    $0x1,%edi
    1e3e:	eb 1e                	jmp    1e5e <linkunlink+0x6e>
    } else if((x % 3) == 1){
    1e40:	83 f8 01             	cmp    $0x1,%eax
    1e43:	0f 84 87 00 00 00    	je     1ed0 <linkunlink+0xe0>
      unlink("x");
    1e49:	83 ec 0c             	sub    $0xc,%esp
    1e4c:	68 91 4d 00 00       	push   $0x4d91
    1e51:	e8 4d 21 00 00       	call   3fa3 <unlink>
    1e56:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 100; i++){
    1e59:	83 eb 01             	sub    $0x1,%ebx
    1e5c:	74 41                	je     1e9f <linkunlink+0xaf>
    x = x * 1103515245 + 12345;
    1e5e:	69 cf 6d 4e c6 41    	imul   $0x41c64e6d,%edi,%ecx
    1e64:	8d b9 39 30 00 00    	lea    0x3039(%ecx),%edi
    if((x % 3) == 0){
    1e6a:	89 f8                	mov    %edi,%eax
    1e6c:	f7 e6                	mul    %esi
    1e6e:	89 d0                	mov    %edx,%eax
    1e70:	83 e2 fe             	and    $0xfffffffe,%edx
    1e73:	d1 e8                	shr    %eax
    1e75:	01 c2                	add    %eax,%edx
    1e77:	89 f8                	mov    %edi,%eax
    1e79:	29 d0                	sub    %edx,%eax
    1e7b:	75 c3                	jne    1e40 <linkunlink+0x50>
      close(open("x", O_RDWR | O_CREATE));
    1e7d:	83 ec 08             	sub    $0x8,%esp
    1e80:	68 02 02 00 00       	push   $0x202
    1e85:	68 91 4d 00 00       	push   $0x4d91
    1e8a:	e8 04 21 00 00       	call   3f93 <open>
    1e8f:	89 04 24             	mov    %eax,(%esp)
    1e92:	e8 e4 20 00 00       	call   3f7b <close>
    1e97:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 100; i++){
    1e9a:	83 eb 01             	sub    $0x1,%ebx
    1e9d:	75 bf                	jne    1e5e <linkunlink+0x6e>
  if(pid)
    1e9f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    1ea2:	85 c9                	test   %ecx,%ecx
    1ea4:	74 5e                	je     1f04 <linkunlink+0x114>
    wait(null);
    1ea6:	83 ec 0c             	sub    $0xc,%esp
    1ea9:	6a 00                	push   $0x0
    1eab:	e8 ab 20 00 00       	call   3f5b <wait>
  printf(1, "linkunlink ok\n");
    1eb0:	58                   	pop    %eax
    1eb1:	5a                   	pop    %edx
    1eb2:	68 19 4b 00 00       	push   $0x4b19
    1eb7:	6a 01                	push   $0x1
    1eb9:	e8 12 22 00 00       	call   40d0 <printf>
}
    1ebe:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1ec1:	5b                   	pop    %ebx
    1ec2:	5e                   	pop    %esi
    1ec3:	5f                   	pop    %edi
    1ec4:	5d                   	pop    %ebp
    1ec5:	c3                   	ret    
    1ec6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1ecd:	8d 76 00             	lea    0x0(%esi),%esi
      link("cat", "x");
    1ed0:	83 ec 08             	sub    $0x8,%esp
    1ed3:	68 91 4d 00 00       	push   $0x4d91
    1ed8:	68 15 4b 00 00       	push   $0x4b15
    1edd:	e8 d1 20 00 00       	call   3fb3 <link>
    1ee2:	83 c4 10             	add    $0x10,%esp
    1ee5:	e9 6f ff ff ff       	jmp    1e59 <linkunlink+0x69>
    printf(1, "fork failed\n");
    1eea:	53                   	push   %ebx
    1eeb:	53                   	push   %ebx
    1eec:	68 79 53 00 00       	push   $0x5379
    1ef1:	6a 01                	push   $0x1
    1ef3:	e8 d8 21 00 00       	call   40d0 <printf>
    exit(1);
    1ef8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1eff:	e8 4f 20 00 00       	call   3f53 <exit>
    exit(1);
    1f04:	83 ec 0c             	sub    $0xc,%esp
    1f07:	6a 01                	push   $0x1
    1f09:	e8 45 20 00 00       	call   3f53 <exit>
    1f0e:	66 90                	xchg   %ax,%ax

00001f10 <bigdir>:
{
    1f10:	f3 0f 1e fb          	endbr32 
    1f14:	55                   	push   %ebp
    1f15:	89 e5                	mov    %esp,%ebp
    1f17:	57                   	push   %edi
    1f18:	56                   	push   %esi
    1f19:	53                   	push   %ebx
    1f1a:	83 ec 24             	sub    $0x24,%esp
  printf(1, "bigdir test\n");
    1f1d:	68 28 4b 00 00       	push   $0x4b28
    1f22:	6a 01                	push   $0x1
    1f24:	e8 a7 21 00 00       	call   40d0 <printf>
  unlink("bd");
    1f29:	c7 04 24 35 4b 00 00 	movl   $0x4b35,(%esp)
    1f30:	e8 6e 20 00 00       	call   3fa3 <unlink>
  fd = open("bd", O_CREATE);
    1f35:	5a                   	pop    %edx
    1f36:	59                   	pop    %ecx
    1f37:	68 00 02 00 00       	push   $0x200
    1f3c:	68 35 4b 00 00       	push   $0x4b35
    1f41:	e8 4d 20 00 00       	call   3f93 <open>
  if(fd < 0){
    1f46:	83 c4 10             	add    $0x10,%esp
    1f49:	85 c0                	test   %eax,%eax
    1f4b:	0f 88 f8 00 00 00    	js     2049 <bigdir+0x139>
  close(fd);
    1f51:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < 500; i++){
    1f54:	31 f6                	xor    %esi,%esi
    1f56:	8d 7d de             	lea    -0x22(%ebp),%edi
  close(fd);
    1f59:	50                   	push   %eax
    1f5a:	e8 1c 20 00 00       	call   3f7b <close>
    1f5f:	83 c4 10             	add    $0x10,%esp
    1f62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    name[1] = '0' + (i / 64);
    1f68:	89 f0                	mov    %esi,%eax
    if(link("bd", name) != 0){
    1f6a:	83 ec 08             	sub    $0x8,%esp
    name[0] = 'x';
    1f6d:	c6 45 de 78          	movb   $0x78,-0x22(%ebp)
    name[1] = '0' + (i / 64);
    1f71:	c1 f8 06             	sar    $0x6,%eax
    if(link("bd", name) != 0){
    1f74:	57                   	push   %edi
    name[1] = '0' + (i / 64);
    1f75:	83 c0 30             	add    $0x30,%eax
    if(link("bd", name) != 0){
    1f78:	68 35 4b 00 00       	push   $0x4b35
    name[1] = '0' + (i / 64);
    1f7d:	88 45 df             	mov    %al,-0x21(%ebp)
    name[2] = '0' + (i % 64);
    1f80:	89 f0                	mov    %esi,%eax
    1f82:	83 e0 3f             	and    $0x3f,%eax
    name[3] = '\0';
    1f85:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
    name[2] = '0' + (i % 64);
    1f89:	83 c0 30             	add    $0x30,%eax
    1f8c:	88 45 e0             	mov    %al,-0x20(%ebp)
    if(link("bd", name) != 0){
    1f8f:	e8 1f 20 00 00       	call   3fb3 <link>
    1f94:	83 c4 10             	add    $0x10,%esp
    1f97:	89 c3                	mov    %eax,%ebx
    1f99:	85 c0                	test   %eax,%eax
    1f9b:	75 76                	jne    2013 <bigdir+0x103>
  for(i = 0; i < 500; i++){
    1f9d:	83 c6 01             	add    $0x1,%esi
    1fa0:	81 fe f4 01 00 00    	cmp    $0x1f4,%esi
    1fa6:	75 c0                	jne    1f68 <bigdir+0x58>
  unlink("bd");
    1fa8:	83 ec 0c             	sub    $0xc,%esp
    1fab:	68 35 4b 00 00       	push   $0x4b35
    1fb0:	e8 ee 1f 00 00       	call   3fa3 <unlink>
    1fb5:	83 c4 10             	add    $0x10,%esp
    1fb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1fbf:	90                   	nop
    name[1] = '0' + (i / 64);
    1fc0:	89 d8                	mov    %ebx,%eax
    if(unlink(name) != 0){
    1fc2:	83 ec 0c             	sub    $0xc,%esp
    name[0] = 'x';
    1fc5:	c6 45 de 78          	movb   $0x78,-0x22(%ebp)
    name[1] = '0' + (i / 64);
    1fc9:	c1 f8 06             	sar    $0x6,%eax
    if(unlink(name) != 0){
    1fcc:	57                   	push   %edi
    name[1] = '0' + (i / 64);
    1fcd:	83 c0 30             	add    $0x30,%eax
    name[3] = '\0';
    1fd0:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
    name[1] = '0' + (i / 64);
    1fd4:	88 45 df             	mov    %al,-0x21(%ebp)
    name[2] = '0' + (i % 64);
    1fd7:	89 d8                	mov    %ebx,%eax
    1fd9:	83 e0 3f             	and    $0x3f,%eax
    1fdc:	83 c0 30             	add    $0x30,%eax
    1fdf:	88 45 e0             	mov    %al,-0x20(%ebp)
    if(unlink(name) != 0){
    1fe2:	e8 bc 1f 00 00       	call   3fa3 <unlink>
    1fe7:	83 c4 10             	add    $0x10,%esp
    1fea:	85 c0                	test   %eax,%eax
    1fec:	75 40                	jne    202e <bigdir+0x11e>
  for(i = 0; i < 500; i++){
    1fee:	83 c3 01             	add    $0x1,%ebx
    1ff1:	81 fb f4 01 00 00    	cmp    $0x1f4,%ebx
    1ff7:	75 c7                	jne    1fc0 <bigdir+0xb0>
  printf(1, "bigdir ok\n");
    1ff9:	83 ec 08             	sub    $0x8,%esp
    1ffc:	68 77 4b 00 00       	push   $0x4b77
    2001:	6a 01                	push   $0x1
    2003:	e8 c8 20 00 00       	call   40d0 <printf>
    2008:	83 c4 10             	add    $0x10,%esp
}
    200b:	8d 65 f4             	lea    -0xc(%ebp),%esp
    200e:	5b                   	pop    %ebx
    200f:	5e                   	pop    %esi
    2010:	5f                   	pop    %edi
    2011:	5d                   	pop    %ebp
    2012:	c3                   	ret    
      printf(1, "bigdir link failed\n");
    2013:	83 ec 08             	sub    $0x8,%esp
    2016:	68 4e 4b 00 00       	push   $0x4b4e
    201b:	6a 01                	push   $0x1
    201d:	e8 ae 20 00 00       	call   40d0 <printf>
      exit(1);
    2022:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2029:	e8 25 1f 00 00       	call   3f53 <exit>
      printf(1, "bigdir unlink failed");
    202e:	83 ec 08             	sub    $0x8,%esp
    2031:	68 62 4b 00 00       	push   $0x4b62
    2036:	6a 01                	push   $0x1
    2038:	e8 93 20 00 00       	call   40d0 <printf>
      exit(1);
    203d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2044:	e8 0a 1f 00 00       	call   3f53 <exit>
    printf(1, "bigdir create failed\n");
    2049:	50                   	push   %eax
    204a:	50                   	push   %eax
    204b:	68 38 4b 00 00       	push   $0x4b38
    2050:	6a 01                	push   $0x1
    2052:	e8 79 20 00 00       	call   40d0 <printf>
    exit(1);
    2057:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    205e:	e8 f0 1e 00 00       	call   3f53 <exit>
    2063:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    206a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00002070 <subdir>:
{
    2070:	f3 0f 1e fb          	endbr32 
    2074:	55                   	push   %ebp
    2075:	89 e5                	mov    %esp,%ebp
    2077:	53                   	push   %ebx
    2078:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "subdir test\n");
    207b:	68 82 4b 00 00       	push   $0x4b82
    2080:	6a 01                	push   $0x1
    2082:	e8 49 20 00 00       	call   40d0 <printf>
  unlink("ff");
    2087:	c7 04 24 0b 4c 00 00 	movl   $0x4c0b,(%esp)
    208e:	e8 10 1f 00 00       	call   3fa3 <unlink>
  if(mkdir("dd") != 0){
    2093:	c7 04 24 a8 4c 00 00 	movl   $0x4ca8,(%esp)
    209a:	e8 1c 1f 00 00       	call   3fbb <mkdir>
    209f:	83 c4 10             	add    $0x10,%esp
    20a2:	85 c0                	test   %eax,%eax
    20a4:	0f 85 4d 06 00 00    	jne    26f7 <subdir+0x687>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    20aa:	83 ec 08             	sub    $0x8,%esp
    20ad:	68 02 02 00 00       	push   $0x202
    20b2:	68 e1 4b 00 00       	push   $0x4be1
    20b7:	e8 d7 1e 00 00       	call   3f93 <open>
  if(fd < 0){
    20bc:	83 c4 10             	add    $0x10,%esp
  fd = open("dd/ff", O_CREATE | O_RDWR);
    20bf:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    20c1:	85 c0                	test   %eax,%eax
    20c3:	0f 88 14 06 00 00    	js     26dd <subdir+0x66d>
  write(fd, "ff", 2);
    20c9:	83 ec 04             	sub    $0x4,%esp
    20cc:	6a 02                	push   $0x2
    20ce:	68 0b 4c 00 00       	push   $0x4c0b
    20d3:	50                   	push   %eax
    20d4:	e8 9a 1e 00 00       	call   3f73 <write>
  close(fd);
    20d9:	89 1c 24             	mov    %ebx,(%esp)
    20dc:	e8 9a 1e 00 00       	call   3f7b <close>
  if(unlink("dd") >= 0){
    20e1:	c7 04 24 a8 4c 00 00 	movl   $0x4ca8,(%esp)
    20e8:	e8 b6 1e 00 00       	call   3fa3 <unlink>
    20ed:	83 c4 10             	add    $0x10,%esp
    20f0:	85 c0                	test   %eax,%eax
    20f2:	0f 89 cb 05 00 00    	jns    26c3 <subdir+0x653>
  if(mkdir("/dd/dd") != 0){
    20f8:	83 ec 0c             	sub    $0xc,%esp
    20fb:	68 bc 4b 00 00       	push   $0x4bbc
    2100:	e8 b6 1e 00 00       	call   3fbb <mkdir>
    2105:	83 c4 10             	add    $0x10,%esp
    2108:	85 c0                	test   %eax,%eax
    210a:	0f 85 99 05 00 00    	jne    26a9 <subdir+0x639>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2110:	83 ec 08             	sub    $0x8,%esp
    2113:	68 02 02 00 00       	push   $0x202
    2118:	68 de 4b 00 00       	push   $0x4bde
    211d:	e8 71 1e 00 00       	call   3f93 <open>
  if(fd < 0){
    2122:	83 c4 10             	add    $0x10,%esp
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2125:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    2127:	85 c0                	test   %eax,%eax
    2129:	0f 88 5c 04 00 00    	js     258b <subdir+0x51b>
  write(fd, "FF", 2);
    212f:	83 ec 04             	sub    $0x4,%esp
    2132:	6a 02                	push   $0x2
    2134:	68 ff 4b 00 00       	push   $0x4bff
    2139:	50                   	push   %eax
    213a:	e8 34 1e 00 00       	call   3f73 <write>
  close(fd);
    213f:	89 1c 24             	mov    %ebx,(%esp)
    2142:	e8 34 1e 00 00       	call   3f7b <close>
  fd = open("dd/dd/../ff", 0);
    2147:	58                   	pop    %eax
    2148:	5a                   	pop    %edx
    2149:	6a 00                	push   $0x0
    214b:	68 02 4c 00 00       	push   $0x4c02
    2150:	e8 3e 1e 00 00       	call   3f93 <open>
  if(fd < 0){
    2155:	83 c4 10             	add    $0x10,%esp
  fd = open("dd/dd/../ff", 0);
    2158:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    215a:	85 c0                	test   %eax,%eax
    215c:	0f 88 0f 04 00 00    	js     2571 <subdir+0x501>
  cc = read(fd, buf, sizeof(buf));
    2162:	83 ec 04             	sub    $0x4,%esp
    2165:	68 00 20 00 00       	push   $0x2000
    216a:	68 c0 8c 00 00       	push   $0x8cc0
    216f:	50                   	push   %eax
    2170:	e8 f6 1d 00 00       	call   3f6b <read>
  if(cc != 2 || buf[0] != 'f'){
    2175:	83 c4 10             	add    $0x10,%esp
    2178:	83 f8 02             	cmp    $0x2,%eax
    217b:	0f 85 3a 03 00 00    	jne    24bb <subdir+0x44b>
    2181:	80 3d c0 8c 00 00 66 	cmpb   $0x66,0x8cc0
    2188:	0f 85 2d 03 00 00    	jne    24bb <subdir+0x44b>
  close(fd);
    218e:	83 ec 0c             	sub    $0xc,%esp
    2191:	53                   	push   %ebx
    2192:	e8 e4 1d 00 00       	call   3f7b <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    2197:	59                   	pop    %ecx
    2198:	5b                   	pop    %ebx
    2199:	68 42 4c 00 00       	push   $0x4c42
    219e:	68 de 4b 00 00       	push   $0x4bde
    21a3:	e8 0b 1e 00 00       	call   3fb3 <link>
    21a8:	83 c4 10             	add    $0x10,%esp
    21ab:	85 c0                	test   %eax,%eax
    21ad:	0f 85 0c 04 00 00    	jne    25bf <subdir+0x54f>
  if(unlink("dd/dd/ff") != 0){
    21b3:	83 ec 0c             	sub    $0xc,%esp
    21b6:	68 de 4b 00 00       	push   $0x4bde
    21bb:	e8 e3 1d 00 00       	call   3fa3 <unlink>
    21c0:	83 c4 10             	add    $0x10,%esp
    21c3:	85 c0                	test   %eax,%eax
    21c5:	0f 85 24 03 00 00    	jne    24ef <subdir+0x47f>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    21cb:	83 ec 08             	sub    $0x8,%esp
    21ce:	6a 00                	push   $0x0
    21d0:	68 de 4b 00 00       	push   $0x4bde
    21d5:	e8 b9 1d 00 00       	call   3f93 <open>
    21da:	83 c4 10             	add    $0x10,%esp
    21dd:	85 c0                	test   %eax,%eax
    21df:	0f 89 aa 04 00 00    	jns    268f <subdir+0x61f>
  if(chdir("dd") != 0){
    21e5:	83 ec 0c             	sub    $0xc,%esp
    21e8:	68 a8 4c 00 00       	push   $0x4ca8
    21ed:	e8 d1 1d 00 00       	call   3fc3 <chdir>
    21f2:	83 c4 10             	add    $0x10,%esp
    21f5:	85 c0                	test   %eax,%eax
    21f7:	0f 85 78 04 00 00    	jne    2675 <subdir+0x605>
  if(chdir("dd/../../dd") != 0){
    21fd:	83 ec 0c             	sub    $0xc,%esp
    2200:	68 76 4c 00 00       	push   $0x4c76
    2205:	e8 b9 1d 00 00       	call   3fc3 <chdir>
    220a:	83 c4 10             	add    $0x10,%esp
    220d:	85 c0                	test   %eax,%eax
    220f:	0f 85 c0 02 00 00    	jne    24d5 <subdir+0x465>
  if(chdir("dd/../../../dd") != 0){
    2215:	83 ec 0c             	sub    $0xc,%esp
    2218:	68 9c 4c 00 00       	push   $0x4c9c
    221d:	e8 a1 1d 00 00       	call   3fc3 <chdir>
    2222:	83 c4 10             	add    $0x10,%esp
    2225:	85 c0                	test   %eax,%eax
    2227:	0f 85 a8 02 00 00    	jne    24d5 <subdir+0x465>
  if(chdir("./..") != 0){
    222d:	83 ec 0c             	sub    $0xc,%esp
    2230:	68 ab 4c 00 00       	push   $0x4cab
    2235:	e8 89 1d 00 00       	call   3fc3 <chdir>
    223a:	83 c4 10             	add    $0x10,%esp
    223d:	85 c0                	test   %eax,%eax
    223f:	0f 85 60 03 00 00    	jne    25a5 <subdir+0x535>
  fd = open("dd/dd/ffff", 0);
    2245:	83 ec 08             	sub    $0x8,%esp
    2248:	6a 00                	push   $0x0
    224a:	68 42 4c 00 00       	push   $0x4c42
    224f:	e8 3f 1d 00 00       	call   3f93 <open>
  if(fd < 0){
    2254:	83 c4 10             	add    $0x10,%esp
  fd = open("dd/dd/ffff", 0);
    2257:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    2259:	85 c0                	test   %eax,%eax
    225b:	0f 88 ce 05 00 00    	js     282f <subdir+0x7bf>
  if(read(fd, buf, sizeof(buf)) != 2){
    2261:	83 ec 04             	sub    $0x4,%esp
    2264:	68 00 20 00 00       	push   $0x2000
    2269:	68 c0 8c 00 00       	push   $0x8cc0
    226e:	50                   	push   %eax
    226f:	e8 f7 1c 00 00       	call   3f6b <read>
    2274:	83 c4 10             	add    $0x10,%esp
    2277:	83 f8 02             	cmp    $0x2,%eax
    227a:	0f 85 95 05 00 00    	jne    2815 <subdir+0x7a5>
  close(fd);
    2280:	83 ec 0c             	sub    $0xc,%esp
    2283:	53                   	push   %ebx
    2284:	e8 f2 1c 00 00       	call   3f7b <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2289:	58                   	pop    %eax
    228a:	5a                   	pop    %edx
    228b:	6a 00                	push   $0x0
    228d:	68 de 4b 00 00       	push   $0x4bde
    2292:	e8 fc 1c 00 00       	call   3f93 <open>
    2297:	83 c4 10             	add    $0x10,%esp
    229a:	85 c0                	test   %eax,%eax
    229c:	0f 89 81 02 00 00    	jns    2523 <subdir+0x4b3>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    22a2:	83 ec 08             	sub    $0x8,%esp
    22a5:	68 02 02 00 00       	push   $0x202
    22aa:	68 f6 4c 00 00       	push   $0x4cf6
    22af:	e8 df 1c 00 00       	call   3f93 <open>
    22b4:	83 c4 10             	add    $0x10,%esp
    22b7:	85 c0                	test   %eax,%eax
    22b9:	0f 89 4a 02 00 00    	jns    2509 <subdir+0x499>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    22bf:	83 ec 08             	sub    $0x8,%esp
    22c2:	68 02 02 00 00       	push   $0x202
    22c7:	68 1b 4d 00 00       	push   $0x4d1b
    22cc:	e8 c2 1c 00 00       	call   3f93 <open>
    22d1:	83 c4 10             	add    $0x10,%esp
    22d4:	85 c0                	test   %eax,%eax
    22d6:	0f 89 7f 03 00 00    	jns    265b <subdir+0x5eb>
  if(open("dd", O_CREATE) >= 0){
    22dc:	83 ec 08             	sub    $0x8,%esp
    22df:	68 00 02 00 00       	push   $0x200
    22e4:	68 a8 4c 00 00       	push   $0x4ca8
    22e9:	e8 a5 1c 00 00       	call   3f93 <open>
    22ee:	83 c4 10             	add    $0x10,%esp
    22f1:	85 c0                	test   %eax,%eax
    22f3:	0f 89 48 03 00 00    	jns    2641 <subdir+0x5d1>
  if(open("dd", O_RDWR) >= 0){
    22f9:	83 ec 08             	sub    $0x8,%esp
    22fc:	6a 02                	push   $0x2
    22fe:	68 a8 4c 00 00       	push   $0x4ca8
    2303:	e8 8b 1c 00 00       	call   3f93 <open>
    2308:	83 c4 10             	add    $0x10,%esp
    230b:	85 c0                	test   %eax,%eax
    230d:	0f 89 14 03 00 00    	jns    2627 <subdir+0x5b7>
  if(open("dd", O_WRONLY) >= 0){
    2313:	83 ec 08             	sub    $0x8,%esp
    2316:	6a 01                	push   $0x1
    2318:	68 a8 4c 00 00       	push   $0x4ca8
    231d:	e8 71 1c 00 00       	call   3f93 <open>
    2322:	83 c4 10             	add    $0x10,%esp
    2325:	85 c0                	test   %eax,%eax
    2327:	0f 89 e0 02 00 00    	jns    260d <subdir+0x59d>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    232d:	83 ec 08             	sub    $0x8,%esp
    2330:	68 8a 4d 00 00       	push   $0x4d8a
    2335:	68 f6 4c 00 00       	push   $0x4cf6
    233a:	e8 74 1c 00 00       	call   3fb3 <link>
    233f:	83 c4 10             	add    $0x10,%esp
    2342:	85 c0                	test   %eax,%eax
    2344:	0f 84 a9 02 00 00    	je     25f3 <subdir+0x583>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    234a:	83 ec 08             	sub    $0x8,%esp
    234d:	68 8a 4d 00 00       	push   $0x4d8a
    2352:	68 1b 4d 00 00       	push   $0x4d1b
    2357:	e8 57 1c 00 00       	call   3fb3 <link>
    235c:	83 c4 10             	add    $0x10,%esp
    235f:	85 c0                	test   %eax,%eax
    2361:	0f 84 72 02 00 00    	je     25d9 <subdir+0x569>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2367:	83 ec 08             	sub    $0x8,%esp
    236a:	68 42 4c 00 00       	push   $0x4c42
    236f:	68 e1 4b 00 00       	push   $0x4be1
    2374:	e8 3a 1c 00 00       	call   3fb3 <link>
    2379:	83 c4 10             	add    $0x10,%esp
    237c:	85 c0                	test   %eax,%eax
    237e:	0f 84 d3 01 00 00    	je     2557 <subdir+0x4e7>
  if(mkdir("dd/ff/ff") == 0){
    2384:	83 ec 0c             	sub    $0xc,%esp
    2387:	68 f6 4c 00 00       	push   $0x4cf6
    238c:	e8 2a 1c 00 00       	call   3fbb <mkdir>
    2391:	83 c4 10             	add    $0x10,%esp
    2394:	85 c0                	test   %eax,%eax
    2396:	0f 84 a1 01 00 00    	je     253d <subdir+0x4cd>
  if(mkdir("dd/xx/ff") == 0){
    239c:	83 ec 0c             	sub    $0xc,%esp
    239f:	68 1b 4d 00 00       	push   $0x4d1b
    23a4:	e8 12 1c 00 00       	call   3fbb <mkdir>
    23a9:	83 c4 10             	add    $0x10,%esp
    23ac:	85 c0                	test   %eax,%eax
    23ae:	0f 84 47 04 00 00    	je     27fb <subdir+0x78b>
  if(mkdir("dd/dd/ffff") == 0){
    23b4:	83 ec 0c             	sub    $0xc,%esp
    23b7:	68 42 4c 00 00       	push   $0x4c42
    23bc:	e8 fa 1b 00 00       	call   3fbb <mkdir>
    23c1:	83 c4 10             	add    $0x10,%esp
    23c4:	85 c0                	test   %eax,%eax
    23c6:	0f 84 15 04 00 00    	je     27e1 <subdir+0x771>
  if(unlink("dd/xx/ff") == 0){
    23cc:	83 ec 0c             	sub    $0xc,%esp
    23cf:	68 1b 4d 00 00       	push   $0x4d1b
    23d4:	e8 ca 1b 00 00       	call   3fa3 <unlink>
    23d9:	83 c4 10             	add    $0x10,%esp
    23dc:	85 c0                	test   %eax,%eax
    23de:	0f 84 e3 03 00 00    	je     27c7 <subdir+0x757>
  if(unlink("dd/ff/ff") == 0){
    23e4:	83 ec 0c             	sub    $0xc,%esp
    23e7:	68 f6 4c 00 00       	push   $0x4cf6
    23ec:	e8 b2 1b 00 00       	call   3fa3 <unlink>
    23f1:	83 c4 10             	add    $0x10,%esp
    23f4:	85 c0                	test   %eax,%eax
    23f6:	0f 84 b1 03 00 00    	je     27ad <subdir+0x73d>
  if(chdir("dd/ff") == 0){
    23fc:	83 ec 0c             	sub    $0xc,%esp
    23ff:	68 e1 4b 00 00       	push   $0x4be1
    2404:	e8 ba 1b 00 00       	call   3fc3 <chdir>
    2409:	83 c4 10             	add    $0x10,%esp
    240c:	85 c0                	test   %eax,%eax
    240e:	0f 84 7f 03 00 00    	je     2793 <subdir+0x723>
  if(chdir("dd/xx") == 0){
    2414:	83 ec 0c             	sub    $0xc,%esp
    2417:	68 8d 4d 00 00       	push   $0x4d8d
    241c:	e8 a2 1b 00 00       	call   3fc3 <chdir>
    2421:	83 c4 10             	add    $0x10,%esp
    2424:	85 c0                	test   %eax,%eax
    2426:	0f 84 4d 03 00 00    	je     2779 <subdir+0x709>
  if(unlink("dd/dd/ffff") != 0){
    242c:	83 ec 0c             	sub    $0xc,%esp
    242f:	68 42 4c 00 00       	push   $0x4c42
    2434:	e8 6a 1b 00 00       	call   3fa3 <unlink>
    2439:	83 c4 10             	add    $0x10,%esp
    243c:	85 c0                	test   %eax,%eax
    243e:	0f 85 ab 00 00 00    	jne    24ef <subdir+0x47f>
  if(unlink("dd/ff") != 0){
    2444:	83 ec 0c             	sub    $0xc,%esp
    2447:	68 e1 4b 00 00       	push   $0x4be1
    244c:	e8 52 1b 00 00       	call   3fa3 <unlink>
    2451:	83 c4 10             	add    $0x10,%esp
    2454:	85 c0                	test   %eax,%eax
    2456:	0f 85 03 03 00 00    	jne    275f <subdir+0x6ef>
  if(unlink("dd") == 0){
    245c:	83 ec 0c             	sub    $0xc,%esp
    245f:	68 a8 4c 00 00       	push   $0x4ca8
    2464:	e8 3a 1b 00 00       	call   3fa3 <unlink>
    2469:	83 c4 10             	add    $0x10,%esp
    246c:	85 c0                	test   %eax,%eax
    246e:	0f 84 d1 02 00 00    	je     2745 <subdir+0x6d5>
  if(unlink("dd/dd") < 0){
    2474:	83 ec 0c             	sub    $0xc,%esp
    2477:	68 bd 4b 00 00       	push   $0x4bbd
    247c:	e8 22 1b 00 00       	call   3fa3 <unlink>
    2481:	83 c4 10             	add    $0x10,%esp
    2484:	85 c0                	test   %eax,%eax
    2486:	0f 88 9f 02 00 00    	js     272b <subdir+0x6bb>
  if(unlink("dd") < 0){
    248c:	83 ec 0c             	sub    $0xc,%esp
    248f:	68 a8 4c 00 00       	push   $0x4ca8
    2494:	e8 0a 1b 00 00       	call   3fa3 <unlink>
    2499:	83 c4 10             	add    $0x10,%esp
    249c:	85 c0                	test   %eax,%eax
    249e:	0f 88 6d 02 00 00    	js     2711 <subdir+0x6a1>
  printf(1, "subdir ok\n");
    24a4:	83 ec 08             	sub    $0x8,%esp
    24a7:	68 8a 4e 00 00       	push   $0x4e8a
    24ac:	6a 01                	push   $0x1
    24ae:	e8 1d 1c 00 00       	call   40d0 <printf>
}
    24b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    24b6:	83 c4 10             	add    $0x10,%esp
    24b9:	c9                   	leave  
    24ba:	c3                   	ret    
    printf(1, "dd/dd/../ff wrong content\n");
    24bb:	50                   	push   %eax
    24bc:	50                   	push   %eax
    24bd:	68 27 4c 00 00       	push   $0x4c27
    24c2:	6a 01                	push   $0x1
    24c4:	e8 07 1c 00 00       	call   40d0 <printf>
    exit(1);
    24c9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    24d0:	e8 7e 1a 00 00       	call   3f53 <exit>
    printf(1, "chdir dd/../../dd failed\n");
    24d5:	50                   	push   %eax
    24d6:	50                   	push   %eax
    24d7:	68 82 4c 00 00       	push   $0x4c82
    24dc:	6a 01                	push   $0x1
    24de:	e8 ed 1b 00 00       	call   40d0 <printf>
    exit(1);
    24e3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    24ea:	e8 64 1a 00 00       	call   3f53 <exit>
    printf(1, "unlink dd/dd/ff failed\n");
    24ef:	50                   	push   %eax
    24f0:	50                   	push   %eax
    24f1:	68 4d 4c 00 00       	push   $0x4c4d
    24f6:	6a 01                	push   $0x1
    24f8:	e8 d3 1b 00 00       	call   40d0 <printf>
    exit(1);
    24fd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2504:	e8 4a 1a 00 00       	call   3f53 <exit>
    printf(1, "create dd/ff/ff succeeded!\n");
    2509:	51                   	push   %ecx
    250a:	51                   	push   %ecx
    250b:	68 ff 4c 00 00       	push   $0x4cff
    2510:	6a 01                	push   $0x1
    2512:	e8 b9 1b 00 00       	call   40d0 <printf>
    exit(1);
    2517:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    251e:	e8 30 1a 00 00       	call   3f53 <exit>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    2523:	53                   	push   %ebx
    2524:	53                   	push   %ebx
    2525:	68 e4 56 00 00       	push   $0x56e4
    252a:	6a 01                	push   $0x1
    252c:	e8 9f 1b 00 00       	call   40d0 <printf>
    exit(1);
    2531:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2538:	e8 16 1a 00 00       	call   3f53 <exit>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    253d:	51                   	push   %ecx
    253e:	51                   	push   %ecx
    253f:	68 93 4d 00 00       	push   $0x4d93
    2544:	6a 01                	push   $0x1
    2546:	e8 85 1b 00 00       	call   40d0 <printf>
    exit(1);
    254b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2552:	e8 fc 19 00 00       	call   3f53 <exit>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    2557:	53                   	push   %ebx
    2558:	53                   	push   %ebx
    2559:	68 54 57 00 00       	push   $0x5754
    255e:	6a 01                	push   $0x1
    2560:	e8 6b 1b 00 00       	call   40d0 <printf>
    exit(1);
    2565:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    256c:	e8 e2 19 00 00       	call   3f53 <exit>
    printf(1, "open dd/dd/../ff failed\n");
    2571:	50                   	push   %eax
    2572:	50                   	push   %eax
    2573:	68 0e 4c 00 00       	push   $0x4c0e
    2578:	6a 01                	push   $0x1
    257a:	e8 51 1b 00 00       	call   40d0 <printf>
    exit(1);
    257f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2586:	e8 c8 19 00 00       	call   3f53 <exit>
    printf(1, "create dd/dd/ff failed\n");
    258b:	51                   	push   %ecx
    258c:	51                   	push   %ecx
    258d:	68 e7 4b 00 00       	push   $0x4be7
    2592:	6a 01                	push   $0x1
    2594:	e8 37 1b 00 00       	call   40d0 <printf>
    exit(1);
    2599:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    25a0:	e8 ae 19 00 00       	call   3f53 <exit>
    printf(1, "chdir ./.. failed\n");
    25a5:	50                   	push   %eax
    25a6:	50                   	push   %eax
    25a7:	68 b0 4c 00 00       	push   $0x4cb0
    25ac:	6a 01                	push   $0x1
    25ae:	e8 1d 1b 00 00       	call   40d0 <printf>
    exit(1);
    25b3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    25ba:	e8 94 19 00 00       	call   3f53 <exit>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    25bf:	52                   	push   %edx
    25c0:	52                   	push   %edx
    25c1:	68 9c 56 00 00       	push   $0x569c
    25c6:	6a 01                	push   $0x1
    25c8:	e8 03 1b 00 00       	call   40d0 <printf>
    exit(1);
    25cd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    25d4:	e8 7a 19 00 00       	call   3f53 <exit>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    25d9:	50                   	push   %eax
    25da:	50                   	push   %eax
    25db:	68 30 57 00 00       	push   $0x5730
    25e0:	6a 01                	push   $0x1
    25e2:	e8 e9 1a 00 00       	call   40d0 <printf>
    exit(1);
    25e7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    25ee:	e8 60 19 00 00       	call   3f53 <exit>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    25f3:	50                   	push   %eax
    25f4:	50                   	push   %eax
    25f5:	68 0c 57 00 00       	push   $0x570c
    25fa:	6a 01                	push   $0x1
    25fc:	e8 cf 1a 00 00       	call   40d0 <printf>
    exit(1);
    2601:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2608:	e8 46 19 00 00       	call   3f53 <exit>
    printf(1, "open dd wronly succeeded!\n");
    260d:	50                   	push   %eax
    260e:	50                   	push   %eax
    260f:	68 6f 4d 00 00       	push   $0x4d6f
    2614:	6a 01                	push   $0x1
    2616:	e8 b5 1a 00 00       	call   40d0 <printf>
    exit(1);
    261b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2622:	e8 2c 19 00 00       	call   3f53 <exit>
    printf(1, "open dd rdwr succeeded!\n");
    2627:	50                   	push   %eax
    2628:	50                   	push   %eax
    2629:	68 56 4d 00 00       	push   $0x4d56
    262e:	6a 01                	push   $0x1
    2630:	e8 9b 1a 00 00       	call   40d0 <printf>
    exit(1);
    2635:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    263c:	e8 12 19 00 00       	call   3f53 <exit>
    printf(1, "create dd succeeded!\n");
    2641:	50                   	push   %eax
    2642:	50                   	push   %eax
    2643:	68 40 4d 00 00       	push   $0x4d40
    2648:	6a 01                	push   $0x1
    264a:	e8 81 1a 00 00       	call   40d0 <printf>
    exit(1);
    264f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2656:	e8 f8 18 00 00       	call   3f53 <exit>
    printf(1, "create dd/xx/ff succeeded!\n");
    265b:	52                   	push   %edx
    265c:	52                   	push   %edx
    265d:	68 24 4d 00 00       	push   $0x4d24
    2662:	6a 01                	push   $0x1
    2664:	e8 67 1a 00 00       	call   40d0 <printf>
    exit(1);
    2669:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2670:	e8 de 18 00 00       	call   3f53 <exit>
    printf(1, "chdir dd failed\n");
    2675:	50                   	push   %eax
    2676:	50                   	push   %eax
    2677:	68 65 4c 00 00       	push   $0x4c65
    267c:	6a 01                	push   $0x1
    267e:	e8 4d 1a 00 00       	call   40d0 <printf>
    exit(1);
    2683:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    268a:	e8 c4 18 00 00       	call   3f53 <exit>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    268f:	50                   	push   %eax
    2690:	50                   	push   %eax
    2691:	68 c0 56 00 00       	push   $0x56c0
    2696:	6a 01                	push   $0x1
    2698:	e8 33 1a 00 00       	call   40d0 <printf>
    exit(1);
    269d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    26a4:	e8 aa 18 00 00       	call   3f53 <exit>
    printf(1, "subdir mkdir dd/dd failed\n");
    26a9:	53                   	push   %ebx
    26aa:	53                   	push   %ebx
    26ab:	68 c3 4b 00 00       	push   $0x4bc3
    26b0:	6a 01                	push   $0x1
    26b2:	e8 19 1a 00 00       	call   40d0 <printf>
    exit(1);
    26b7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    26be:	e8 90 18 00 00       	call   3f53 <exit>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    26c3:	50                   	push   %eax
    26c4:	50                   	push   %eax
    26c5:	68 74 56 00 00       	push   $0x5674
    26ca:	6a 01                	push   $0x1
    26cc:	e8 ff 19 00 00       	call   40d0 <printf>
    exit(1);
    26d1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    26d8:	e8 76 18 00 00       	call   3f53 <exit>
    printf(1, "create dd/ff failed\n");
    26dd:	50                   	push   %eax
    26de:	50                   	push   %eax
    26df:	68 a7 4b 00 00       	push   $0x4ba7
    26e4:	6a 01                	push   $0x1
    26e6:	e8 e5 19 00 00       	call   40d0 <printf>
    exit(1);
    26eb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    26f2:	e8 5c 18 00 00       	call   3f53 <exit>
    printf(1, "subdir mkdir dd failed\n");
    26f7:	50                   	push   %eax
    26f8:	50                   	push   %eax
    26f9:	68 8f 4b 00 00       	push   $0x4b8f
    26fe:	6a 01                	push   $0x1
    2700:	e8 cb 19 00 00       	call   40d0 <printf>
    exit(1);
    2705:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    270c:	e8 42 18 00 00       	call   3f53 <exit>
    printf(1, "unlink dd failed\n");
    2711:	50                   	push   %eax
    2712:	50                   	push   %eax
    2713:	68 78 4e 00 00       	push   $0x4e78
    2718:	6a 01                	push   $0x1
    271a:	e8 b1 19 00 00       	call   40d0 <printf>
    exit(1);
    271f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2726:	e8 28 18 00 00       	call   3f53 <exit>
    printf(1, "unlink dd/dd failed\n");
    272b:	52                   	push   %edx
    272c:	52                   	push   %edx
    272d:	68 63 4e 00 00       	push   $0x4e63
    2732:	6a 01                	push   $0x1
    2734:	e8 97 19 00 00       	call   40d0 <printf>
    exit(1);
    2739:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2740:	e8 0e 18 00 00       	call   3f53 <exit>
    printf(1, "unlink non-empty dd succeeded!\n");
    2745:	51                   	push   %ecx
    2746:	51                   	push   %ecx
    2747:	68 78 57 00 00       	push   $0x5778
    274c:	6a 01                	push   $0x1
    274e:	e8 7d 19 00 00       	call   40d0 <printf>
    exit(1);
    2753:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    275a:	e8 f4 17 00 00       	call   3f53 <exit>
    printf(1, "unlink dd/ff failed\n");
    275f:	53                   	push   %ebx
    2760:	53                   	push   %ebx
    2761:	68 4e 4e 00 00       	push   $0x4e4e
    2766:	6a 01                	push   $0x1
    2768:	e8 63 19 00 00       	call   40d0 <printf>
    exit(1);
    276d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2774:	e8 da 17 00 00       	call   3f53 <exit>
    printf(1, "chdir dd/xx succeeded!\n");
    2779:	50                   	push   %eax
    277a:	50                   	push   %eax
    277b:	68 36 4e 00 00       	push   $0x4e36
    2780:	6a 01                	push   $0x1
    2782:	e8 49 19 00 00       	call   40d0 <printf>
    exit(1);
    2787:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    278e:	e8 c0 17 00 00       	call   3f53 <exit>
    printf(1, "chdir dd/ff succeeded!\n");
    2793:	50                   	push   %eax
    2794:	50                   	push   %eax
    2795:	68 1e 4e 00 00       	push   $0x4e1e
    279a:	6a 01                	push   $0x1
    279c:	e8 2f 19 00 00       	call   40d0 <printf>
    exit(1);
    27a1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    27a8:	e8 a6 17 00 00       	call   3f53 <exit>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    27ad:	50                   	push   %eax
    27ae:	50                   	push   %eax
    27af:	68 02 4e 00 00       	push   $0x4e02
    27b4:	6a 01                	push   $0x1
    27b6:	e8 15 19 00 00       	call   40d0 <printf>
    exit(1);
    27bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    27c2:	e8 8c 17 00 00       	call   3f53 <exit>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    27c7:	50                   	push   %eax
    27c8:	50                   	push   %eax
    27c9:	68 e6 4d 00 00       	push   $0x4de6
    27ce:	6a 01                	push   $0x1
    27d0:	e8 fb 18 00 00       	call   40d0 <printf>
    exit(1);
    27d5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    27dc:	e8 72 17 00 00       	call   3f53 <exit>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    27e1:	50                   	push   %eax
    27e2:	50                   	push   %eax
    27e3:	68 c9 4d 00 00       	push   $0x4dc9
    27e8:	6a 01                	push   $0x1
    27ea:	e8 e1 18 00 00       	call   40d0 <printf>
    exit(1);
    27ef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    27f6:	e8 58 17 00 00       	call   3f53 <exit>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    27fb:	52                   	push   %edx
    27fc:	52                   	push   %edx
    27fd:	68 ae 4d 00 00       	push   $0x4dae
    2802:	6a 01                	push   $0x1
    2804:	e8 c7 18 00 00       	call   40d0 <printf>
    exit(1);
    2809:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2810:	e8 3e 17 00 00       	call   3f53 <exit>
    printf(1, "read dd/dd/ffff wrong len\n");
    2815:	51                   	push   %ecx
    2816:	51                   	push   %ecx
    2817:	68 db 4c 00 00       	push   $0x4cdb
    281c:	6a 01                	push   $0x1
    281e:	e8 ad 18 00 00       	call   40d0 <printf>
    exit(1);
    2823:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    282a:	e8 24 17 00 00       	call   3f53 <exit>
    printf(1, "open dd/dd/ffff failed\n");
    282f:	53                   	push   %ebx
    2830:	53                   	push   %ebx
    2831:	68 c3 4c 00 00       	push   $0x4cc3
    2836:	6a 01                	push   $0x1
    2838:	e8 93 18 00 00       	call   40d0 <printf>
    exit(1);
    283d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2844:	e8 0a 17 00 00       	call   3f53 <exit>
    2849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00002850 <bigwrite>:
{
    2850:	f3 0f 1e fb          	endbr32 
    2854:	55                   	push   %ebp
    2855:	89 e5                	mov    %esp,%ebp
    2857:	56                   	push   %esi
    2858:	53                   	push   %ebx
  for(sz = 499; sz < 12*512; sz += 471){
    2859:	bb f3 01 00 00       	mov    $0x1f3,%ebx
  printf(1, "bigwrite test\n");
    285e:	83 ec 08             	sub    $0x8,%esp
    2861:	68 95 4e 00 00       	push   $0x4e95
    2866:	6a 01                	push   $0x1
    2868:	e8 63 18 00 00       	call   40d0 <printf>
  unlink("bigwrite");
    286d:	c7 04 24 a4 4e 00 00 	movl   $0x4ea4,(%esp)
    2874:	e8 2a 17 00 00       	call   3fa3 <unlink>
    2879:	83 c4 10             	add    $0x10,%esp
    287c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    fd = open("bigwrite", O_CREATE | O_RDWR);
    2880:	83 ec 08             	sub    $0x8,%esp
    2883:	68 02 02 00 00       	push   $0x202
    2888:	68 a4 4e 00 00       	push   $0x4ea4
    288d:	e8 01 17 00 00       	call   3f93 <open>
    if(fd < 0){
    2892:	83 c4 10             	add    $0x10,%esp
    fd = open("bigwrite", O_CREATE | O_RDWR);
    2895:	89 c6                	mov    %eax,%esi
    if(fd < 0){
    2897:	85 c0                	test   %eax,%eax
    2899:	0f 88 85 00 00 00    	js     2924 <bigwrite+0xd4>
      int cc = write(fd, buf, sz);
    289f:	83 ec 04             	sub    $0x4,%esp
    28a2:	53                   	push   %ebx
    28a3:	68 c0 8c 00 00       	push   $0x8cc0
    28a8:	50                   	push   %eax
    28a9:	e8 c5 16 00 00       	call   3f73 <write>
      if(cc != sz){
    28ae:	83 c4 10             	add    $0x10,%esp
    28b1:	39 d8                	cmp    %ebx,%eax
    28b3:	75 55                	jne    290a <bigwrite+0xba>
      int cc = write(fd, buf, sz);
    28b5:	83 ec 04             	sub    $0x4,%esp
    28b8:	53                   	push   %ebx
    28b9:	68 c0 8c 00 00       	push   $0x8cc0
    28be:	56                   	push   %esi
    28bf:	e8 af 16 00 00       	call   3f73 <write>
      if(cc != sz){
    28c4:	83 c4 10             	add    $0x10,%esp
    28c7:	39 d8                	cmp    %ebx,%eax
    28c9:	75 3f                	jne    290a <bigwrite+0xba>
    close(fd);
    28cb:	83 ec 0c             	sub    $0xc,%esp
  for(sz = 499; sz < 12*512; sz += 471){
    28ce:	81 c3 d7 01 00 00    	add    $0x1d7,%ebx
    close(fd);
    28d4:	56                   	push   %esi
    28d5:	e8 a1 16 00 00       	call   3f7b <close>
    unlink("bigwrite");
    28da:	c7 04 24 a4 4e 00 00 	movl   $0x4ea4,(%esp)
    28e1:	e8 bd 16 00 00       	call   3fa3 <unlink>
  for(sz = 499; sz < 12*512; sz += 471){
    28e6:	83 c4 10             	add    $0x10,%esp
    28e9:	81 fb 07 18 00 00    	cmp    $0x1807,%ebx
    28ef:	75 8f                	jne    2880 <bigwrite+0x30>
  printf(1, "bigwrite ok\n");
    28f1:	83 ec 08             	sub    $0x8,%esp
    28f4:	68 d7 4e 00 00       	push   $0x4ed7
    28f9:	6a 01                	push   $0x1
    28fb:	e8 d0 17 00 00       	call   40d0 <printf>
}
    2900:	83 c4 10             	add    $0x10,%esp
    2903:	8d 65 f8             	lea    -0x8(%ebp),%esp
    2906:	5b                   	pop    %ebx
    2907:	5e                   	pop    %esi
    2908:	5d                   	pop    %ebp
    2909:	c3                   	ret    
        printf(1, "write(%d) ret %d\n", sz, cc);
    290a:	50                   	push   %eax
    290b:	53                   	push   %ebx
    290c:	68 c5 4e 00 00       	push   $0x4ec5
    2911:	6a 01                	push   $0x1
    2913:	e8 b8 17 00 00       	call   40d0 <printf>
        exit(1);
    2918:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    291f:	e8 2f 16 00 00       	call   3f53 <exit>
      printf(1, "cannot create bigwrite\n");
    2924:	83 ec 08             	sub    $0x8,%esp
    2927:	68 ad 4e 00 00       	push   $0x4ead
    292c:	6a 01                	push   $0x1
    292e:	e8 9d 17 00 00       	call   40d0 <printf>
      exit(1);
    2933:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    293a:	e8 14 16 00 00       	call   3f53 <exit>
    293f:	90                   	nop

00002940 <bigfile>:
{
    2940:	f3 0f 1e fb          	endbr32 
    2944:	55                   	push   %ebp
    2945:	89 e5                	mov    %esp,%ebp
    2947:	57                   	push   %edi
    2948:	56                   	push   %esi
    2949:	53                   	push   %ebx
    294a:	83 ec 14             	sub    $0x14,%esp
  printf(1, "bigfile test\n");
    294d:	68 e4 4e 00 00       	push   $0x4ee4
    2952:	6a 01                	push   $0x1
    2954:	e8 77 17 00 00       	call   40d0 <printf>
  unlink("bigfile");
    2959:	c7 04 24 00 4f 00 00 	movl   $0x4f00,(%esp)
    2960:	e8 3e 16 00 00       	call   3fa3 <unlink>
  fd = open("bigfile", O_CREATE | O_RDWR);
    2965:	58                   	pop    %eax
    2966:	5a                   	pop    %edx
    2967:	68 02 02 00 00       	push   $0x202
    296c:	68 00 4f 00 00       	push   $0x4f00
    2971:	e8 1d 16 00 00       	call   3f93 <open>
  if(fd < 0){
    2976:	83 c4 10             	add    $0x10,%esp
    2979:	85 c0                	test   %eax,%eax
    297b:	0f 88 7d 01 00 00    	js     2afe <bigfile+0x1be>
    2981:	89 c6                	mov    %eax,%esi
  for(i = 0; i < 20; i++){
    2983:	31 db                	xor    %ebx,%ebx
    2985:	8d 76 00             	lea    0x0(%esi),%esi
    memset(buf, i, 600);
    2988:	83 ec 04             	sub    $0x4,%esp
    298b:	68 58 02 00 00       	push   $0x258
    2990:	53                   	push   %ebx
    2991:	68 c0 8c 00 00       	push   $0x8cc0
    2996:	e8 15 14 00 00       	call   3db0 <memset>
    if(write(fd, buf, 600) != 600){
    299b:	83 c4 0c             	add    $0xc,%esp
    299e:	68 58 02 00 00       	push   $0x258
    29a3:	68 c0 8c 00 00       	push   $0x8cc0
    29a8:	56                   	push   %esi
    29a9:	e8 c5 15 00 00       	call   3f73 <write>
    29ae:	83 c4 10             	add    $0x10,%esp
    29b1:	3d 58 02 00 00       	cmp    $0x258,%eax
    29b6:	0f 85 0d 01 00 00    	jne    2ac9 <bigfile+0x189>
  for(i = 0; i < 20; i++){
    29bc:	83 c3 01             	add    $0x1,%ebx
    29bf:	83 fb 14             	cmp    $0x14,%ebx
    29c2:	75 c4                	jne    2988 <bigfile+0x48>
  close(fd);
    29c4:	83 ec 0c             	sub    $0xc,%esp
    29c7:	56                   	push   %esi
    29c8:	e8 ae 15 00 00       	call   3f7b <close>
  fd = open("bigfile", 0);
    29cd:	5e                   	pop    %esi
    29ce:	5f                   	pop    %edi
    29cf:	6a 00                	push   $0x0
    29d1:	68 00 4f 00 00       	push   $0x4f00
    29d6:	e8 b8 15 00 00       	call   3f93 <open>
  if(fd < 0){
    29db:	83 c4 10             	add    $0x10,%esp
  fd = open("bigfile", 0);
    29de:	89 c6                	mov    %eax,%esi
  if(fd < 0){
    29e0:	85 c0                	test   %eax,%eax
    29e2:	0f 88 fc 00 00 00    	js     2ae4 <bigfile+0x1a4>
  total = 0;
    29e8:	31 db                	xor    %ebx,%ebx
  for(i = 0; ; i++){
    29ea:	31 ff                	xor    %edi,%edi
    29ec:	eb 30                	jmp    2a1e <bigfile+0xde>
    29ee:	66 90                	xchg   %ax,%ax
    if(cc != 300){
    29f0:	3d 2c 01 00 00       	cmp    $0x12c,%eax
    29f5:	0f 85 98 00 00 00    	jne    2a93 <bigfile+0x153>
    if(buf[0] != i/2 || buf[299] != i/2){
    29fb:	89 fa                	mov    %edi,%edx
    29fd:	0f be 05 c0 8c 00 00 	movsbl 0x8cc0,%eax
    2a04:	d1 fa                	sar    %edx
    2a06:	39 d0                	cmp    %edx,%eax
    2a08:	75 6e                	jne    2a78 <bigfile+0x138>
    2a0a:	0f be 15 eb 8d 00 00 	movsbl 0x8deb,%edx
    2a11:	39 d0                	cmp    %edx,%eax
    2a13:	75 63                	jne    2a78 <bigfile+0x138>
    total += cc;
    2a15:	81 c3 2c 01 00 00    	add    $0x12c,%ebx
  for(i = 0; ; i++){
    2a1b:	83 c7 01             	add    $0x1,%edi
    cc = read(fd, buf, 300);
    2a1e:	83 ec 04             	sub    $0x4,%esp
    2a21:	68 2c 01 00 00       	push   $0x12c
    2a26:	68 c0 8c 00 00       	push   $0x8cc0
    2a2b:	56                   	push   %esi
    2a2c:	e8 3a 15 00 00       	call   3f6b <read>
    if(cc < 0){
    2a31:	83 c4 10             	add    $0x10,%esp
    2a34:	85 c0                	test   %eax,%eax
    2a36:	78 76                	js     2aae <bigfile+0x16e>
    if(cc == 0)
    2a38:	75 b6                	jne    29f0 <bigfile+0xb0>
  close(fd);
    2a3a:	83 ec 0c             	sub    $0xc,%esp
    2a3d:	56                   	push   %esi
    2a3e:	e8 38 15 00 00       	call   3f7b <close>
  if(total != 20*600){
    2a43:	83 c4 10             	add    $0x10,%esp
    2a46:	81 fb e0 2e 00 00    	cmp    $0x2ee0,%ebx
    2a4c:	0f 85 c6 00 00 00    	jne    2b18 <bigfile+0x1d8>
  unlink("bigfile");
    2a52:	83 ec 0c             	sub    $0xc,%esp
    2a55:	68 00 4f 00 00       	push   $0x4f00
    2a5a:	e8 44 15 00 00       	call   3fa3 <unlink>
  printf(1, "bigfile test ok\n");
    2a5f:	58                   	pop    %eax
    2a60:	5a                   	pop    %edx
    2a61:	68 8f 4f 00 00       	push   $0x4f8f
    2a66:	6a 01                	push   $0x1
    2a68:	e8 63 16 00 00       	call   40d0 <printf>
}
    2a6d:	83 c4 10             	add    $0x10,%esp
    2a70:	8d 65 f4             	lea    -0xc(%ebp),%esp
    2a73:	5b                   	pop    %ebx
    2a74:	5e                   	pop    %esi
    2a75:	5f                   	pop    %edi
    2a76:	5d                   	pop    %ebp
    2a77:	c3                   	ret    
      printf(1, "read bigfile wrong data\n");
    2a78:	83 ec 08             	sub    $0x8,%esp
    2a7b:	68 5c 4f 00 00       	push   $0x4f5c
    2a80:	6a 01                	push   $0x1
    2a82:	e8 49 16 00 00       	call   40d0 <printf>
      exit(1);
    2a87:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a8e:	e8 c0 14 00 00       	call   3f53 <exit>
      printf(1, "short read bigfile\n");
    2a93:	83 ec 08             	sub    $0x8,%esp
    2a96:	68 48 4f 00 00       	push   $0x4f48
    2a9b:	6a 01                	push   $0x1
    2a9d:	e8 2e 16 00 00       	call   40d0 <printf>
      exit(1);
    2aa2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2aa9:	e8 a5 14 00 00       	call   3f53 <exit>
      printf(1, "read bigfile failed\n");
    2aae:	83 ec 08             	sub    $0x8,%esp
    2ab1:	68 33 4f 00 00       	push   $0x4f33
    2ab6:	6a 01                	push   $0x1
    2ab8:	e8 13 16 00 00       	call   40d0 <printf>
      exit(1);
    2abd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2ac4:	e8 8a 14 00 00       	call   3f53 <exit>
      printf(1, "write bigfile failed\n");
    2ac9:	83 ec 08             	sub    $0x8,%esp
    2acc:	68 08 4f 00 00       	push   $0x4f08
    2ad1:	6a 01                	push   $0x1
    2ad3:	e8 f8 15 00 00       	call   40d0 <printf>
      exit(1);
    2ad8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2adf:	e8 6f 14 00 00       	call   3f53 <exit>
    printf(1, "cannot open bigfile\n");
    2ae4:	53                   	push   %ebx
    2ae5:	53                   	push   %ebx
    2ae6:	68 1e 4f 00 00       	push   $0x4f1e
    2aeb:	6a 01                	push   $0x1
    2aed:	e8 de 15 00 00       	call   40d0 <printf>
    exit(1);
    2af2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2af9:	e8 55 14 00 00       	call   3f53 <exit>
    printf(1, "cannot create bigfile");
    2afe:	50                   	push   %eax
    2aff:	50                   	push   %eax
    2b00:	68 f2 4e 00 00       	push   $0x4ef2
    2b05:	6a 01                	push   $0x1
    2b07:	e8 c4 15 00 00       	call   40d0 <printf>
    exit(1);
    2b0c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b13:	e8 3b 14 00 00       	call   3f53 <exit>
    printf(1, "read bigfile wrong total\n");
    2b18:	51                   	push   %ecx
    2b19:	51                   	push   %ecx
    2b1a:	68 75 4f 00 00       	push   $0x4f75
    2b1f:	6a 01                	push   $0x1
    2b21:	e8 aa 15 00 00       	call   40d0 <printf>
    exit(1);
    2b26:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b2d:	e8 21 14 00 00       	call   3f53 <exit>
    2b32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    2b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00002b40 <fourteen>:
{
    2b40:	f3 0f 1e fb          	endbr32 
    2b44:	55                   	push   %ebp
    2b45:	89 e5                	mov    %esp,%ebp
    2b47:	83 ec 10             	sub    $0x10,%esp
  printf(1, "fourteen test\n");
    2b4a:	68 a0 4f 00 00       	push   $0x4fa0
    2b4f:	6a 01                	push   $0x1
    2b51:	e8 7a 15 00 00       	call   40d0 <printf>
  if(mkdir("12345678901234") != 0){
    2b56:	c7 04 24 db 4f 00 00 	movl   $0x4fdb,(%esp)
    2b5d:	e8 59 14 00 00       	call   3fbb <mkdir>
    2b62:	83 c4 10             	add    $0x10,%esp
    2b65:	85 c0                	test   %eax,%eax
    2b67:	0f 85 9b 00 00 00    	jne    2c08 <fourteen+0xc8>
  if(mkdir("12345678901234/123456789012345") != 0){
    2b6d:	83 ec 0c             	sub    $0xc,%esp
    2b70:	68 98 57 00 00       	push   $0x5798
    2b75:	e8 41 14 00 00       	call   3fbb <mkdir>
    2b7a:	83 c4 10             	add    $0x10,%esp
    2b7d:	85 c0                	test   %eax,%eax
    2b7f:	0f 85 05 01 00 00    	jne    2c8a <fourteen+0x14a>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2b85:	83 ec 08             	sub    $0x8,%esp
    2b88:	68 00 02 00 00       	push   $0x200
    2b8d:	68 e8 57 00 00       	push   $0x57e8
    2b92:	e8 fc 13 00 00       	call   3f93 <open>
  if(fd < 0){
    2b97:	83 c4 10             	add    $0x10,%esp
    2b9a:	85 c0                	test   %eax,%eax
    2b9c:	0f 88 ce 00 00 00    	js     2c70 <fourteen+0x130>
  close(fd);
    2ba2:	83 ec 0c             	sub    $0xc,%esp
    2ba5:	50                   	push   %eax
    2ba6:	e8 d0 13 00 00       	call   3f7b <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2bab:	58                   	pop    %eax
    2bac:	5a                   	pop    %edx
    2bad:	6a 00                	push   $0x0
    2baf:	68 58 58 00 00       	push   $0x5858
    2bb4:	e8 da 13 00 00       	call   3f93 <open>
  if(fd < 0){
    2bb9:	83 c4 10             	add    $0x10,%esp
    2bbc:	85 c0                	test   %eax,%eax
    2bbe:	0f 88 92 00 00 00    	js     2c56 <fourteen+0x116>
  close(fd);
    2bc4:	83 ec 0c             	sub    $0xc,%esp
    2bc7:	50                   	push   %eax
    2bc8:	e8 ae 13 00 00       	call   3f7b <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    2bcd:	c7 04 24 cc 4f 00 00 	movl   $0x4fcc,(%esp)
    2bd4:	e8 e2 13 00 00       	call   3fbb <mkdir>
    2bd9:	83 c4 10             	add    $0x10,%esp
    2bdc:	85 c0                	test   %eax,%eax
    2bde:	74 5c                	je     2c3c <fourteen+0xfc>
  if(mkdir("123456789012345/12345678901234") == 0){
    2be0:	83 ec 0c             	sub    $0xc,%esp
    2be3:	68 f4 58 00 00       	push   $0x58f4
    2be8:	e8 ce 13 00 00       	call   3fbb <mkdir>
    2bed:	83 c4 10             	add    $0x10,%esp
    2bf0:	85 c0                	test   %eax,%eax
    2bf2:	74 2e                	je     2c22 <fourteen+0xe2>
  printf(1, "fourteen ok\n");
    2bf4:	83 ec 08             	sub    $0x8,%esp
    2bf7:	68 ea 4f 00 00       	push   $0x4fea
    2bfc:	6a 01                	push   $0x1
    2bfe:	e8 cd 14 00 00       	call   40d0 <printf>
}
    2c03:	83 c4 10             	add    $0x10,%esp
    2c06:	c9                   	leave  
    2c07:	c3                   	ret    
    printf(1, "mkdir 12345678901234 failed\n");
    2c08:	50                   	push   %eax
    2c09:	50                   	push   %eax
    2c0a:	68 af 4f 00 00       	push   $0x4faf
    2c0f:	6a 01                	push   $0x1
    2c11:	e8 ba 14 00 00       	call   40d0 <printf>
    exit(1);
    2c16:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c1d:	e8 31 13 00 00       	call   3f53 <exit>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    2c22:	50                   	push   %eax
    2c23:	50                   	push   %eax
    2c24:	68 14 59 00 00       	push   $0x5914
    2c29:	6a 01                	push   $0x1
    2c2b:	e8 a0 14 00 00       	call   40d0 <printf>
    exit(1);
    2c30:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c37:	e8 17 13 00 00       	call   3f53 <exit>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    2c3c:	52                   	push   %edx
    2c3d:	52                   	push   %edx
    2c3e:	68 c4 58 00 00       	push   $0x58c4
    2c43:	6a 01                	push   $0x1
    2c45:	e8 86 14 00 00       	call   40d0 <printf>
    exit(1);
    2c4a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c51:	e8 fd 12 00 00       	call   3f53 <exit>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    2c56:	51                   	push   %ecx
    2c57:	51                   	push   %ecx
    2c58:	68 88 58 00 00       	push   $0x5888
    2c5d:	6a 01                	push   $0x1
    2c5f:	e8 6c 14 00 00       	call   40d0 <printf>
    exit(1);
    2c64:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c6b:	e8 e3 12 00 00       	call   3f53 <exit>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    2c70:	51                   	push   %ecx
    2c71:	51                   	push   %ecx
    2c72:	68 18 58 00 00       	push   $0x5818
    2c77:	6a 01                	push   $0x1
    2c79:	e8 52 14 00 00       	call   40d0 <printf>
    exit(1);
    2c7e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c85:	e8 c9 12 00 00       	call   3f53 <exit>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    2c8a:	50                   	push   %eax
    2c8b:	50                   	push   %eax
    2c8c:	68 b8 57 00 00       	push   $0x57b8
    2c91:	6a 01                	push   $0x1
    2c93:	e8 38 14 00 00       	call   40d0 <printf>
    exit(1);
    2c98:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c9f:	e8 af 12 00 00       	call   3f53 <exit>
    2ca4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    2cab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    2caf:	90                   	nop

00002cb0 <rmdot>:
{
    2cb0:	f3 0f 1e fb          	endbr32 
    2cb4:	55                   	push   %ebp
    2cb5:	89 e5                	mov    %esp,%ebp
    2cb7:	83 ec 10             	sub    $0x10,%esp
  printf(1, "rmdot test\n");
    2cba:	68 f7 4f 00 00       	push   $0x4ff7
    2cbf:	6a 01                	push   $0x1
    2cc1:	e8 0a 14 00 00       	call   40d0 <printf>
  if(mkdir("dots") != 0){
    2cc6:	c7 04 24 03 50 00 00 	movl   $0x5003,(%esp)
    2ccd:	e8 e9 12 00 00       	call   3fbb <mkdir>
    2cd2:	83 c4 10             	add    $0x10,%esp
    2cd5:	85 c0                	test   %eax,%eax
    2cd7:	0f 85 b4 00 00 00    	jne    2d91 <rmdot+0xe1>
  if(chdir("dots") != 0){
    2cdd:	83 ec 0c             	sub    $0xc,%esp
    2ce0:	68 03 50 00 00       	push   $0x5003
    2ce5:	e8 d9 12 00 00       	call   3fc3 <chdir>
    2cea:	83 c4 10             	add    $0x10,%esp
    2ced:	85 c0                	test   %eax,%eax
    2cef:	0f 85 52 01 00 00    	jne    2e47 <rmdot+0x197>
  if(unlink(".") == 0){
    2cf5:	83 ec 0c             	sub    $0xc,%esp
    2cf8:	68 ae 4c 00 00       	push   $0x4cae
    2cfd:	e8 a1 12 00 00       	call   3fa3 <unlink>
    2d02:	83 c4 10             	add    $0x10,%esp
    2d05:	85 c0                	test   %eax,%eax
    2d07:	0f 84 20 01 00 00    	je     2e2d <rmdot+0x17d>
  if(unlink("..") == 0){
    2d0d:	83 ec 0c             	sub    $0xc,%esp
    2d10:	68 ad 4c 00 00       	push   $0x4cad
    2d15:	e8 89 12 00 00       	call   3fa3 <unlink>
    2d1a:	83 c4 10             	add    $0x10,%esp
    2d1d:	85 c0                	test   %eax,%eax
    2d1f:	0f 84 ee 00 00 00    	je     2e13 <rmdot+0x163>
  if(chdir("/") != 0){
    2d25:	83 ec 0c             	sub    $0xc,%esp
    2d28:	68 81 44 00 00       	push   $0x4481
    2d2d:	e8 91 12 00 00       	call   3fc3 <chdir>
    2d32:	83 c4 10             	add    $0x10,%esp
    2d35:	85 c0                	test   %eax,%eax
    2d37:	0f 85 bc 00 00 00    	jne    2df9 <rmdot+0x149>
  if(unlink("dots/.") == 0){
    2d3d:	83 ec 0c             	sub    $0xc,%esp
    2d40:	68 4b 50 00 00       	push   $0x504b
    2d45:	e8 59 12 00 00       	call   3fa3 <unlink>
    2d4a:	83 c4 10             	add    $0x10,%esp
    2d4d:	85 c0                	test   %eax,%eax
    2d4f:	0f 84 8a 00 00 00    	je     2ddf <rmdot+0x12f>
  if(unlink("dots/..") == 0){
    2d55:	83 ec 0c             	sub    $0xc,%esp
    2d58:	68 69 50 00 00       	push   $0x5069
    2d5d:	e8 41 12 00 00       	call   3fa3 <unlink>
    2d62:	83 c4 10             	add    $0x10,%esp
    2d65:	85 c0                	test   %eax,%eax
    2d67:	74 5c                	je     2dc5 <rmdot+0x115>
  if(unlink("dots") != 0){
    2d69:	83 ec 0c             	sub    $0xc,%esp
    2d6c:	68 03 50 00 00       	push   $0x5003
    2d71:	e8 2d 12 00 00       	call   3fa3 <unlink>
    2d76:	83 c4 10             	add    $0x10,%esp
    2d79:	85 c0                	test   %eax,%eax
    2d7b:	75 2e                	jne    2dab <rmdot+0xfb>
  printf(1, "rmdot ok\n");
    2d7d:	83 ec 08             	sub    $0x8,%esp
    2d80:	68 9e 50 00 00       	push   $0x509e
    2d85:	6a 01                	push   $0x1
    2d87:	e8 44 13 00 00       	call   40d0 <printf>
}
    2d8c:	83 c4 10             	add    $0x10,%esp
    2d8f:	c9                   	leave  
    2d90:	c3                   	ret    
    printf(1, "mkdir dots failed\n");
    2d91:	50                   	push   %eax
    2d92:	50                   	push   %eax
    2d93:	68 08 50 00 00       	push   $0x5008
    2d98:	6a 01                	push   $0x1
    2d9a:	e8 31 13 00 00       	call   40d0 <printf>
    exit(1);
    2d9f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2da6:	e8 a8 11 00 00       	call   3f53 <exit>
    printf(1, "unlink dots failed!\n");
    2dab:	50                   	push   %eax
    2dac:	50                   	push   %eax
    2dad:	68 89 50 00 00       	push   $0x5089
    2db2:	6a 01                	push   $0x1
    2db4:	e8 17 13 00 00       	call   40d0 <printf>
    exit(1);
    2db9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2dc0:	e8 8e 11 00 00       	call   3f53 <exit>
    printf(1, "unlink dots/.. worked!\n");
    2dc5:	52                   	push   %edx
    2dc6:	52                   	push   %edx
    2dc7:	68 71 50 00 00       	push   $0x5071
    2dcc:	6a 01                	push   $0x1
    2dce:	e8 fd 12 00 00       	call   40d0 <printf>
    exit(1);
    2dd3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2dda:	e8 74 11 00 00       	call   3f53 <exit>
    printf(1, "unlink dots/. worked!\n");
    2ddf:	51                   	push   %ecx
    2de0:	51                   	push   %ecx
    2de1:	68 52 50 00 00       	push   $0x5052
    2de6:	6a 01                	push   $0x1
    2de8:	e8 e3 12 00 00       	call   40d0 <printf>
    exit(1);
    2ded:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2df4:	e8 5a 11 00 00       	call   3f53 <exit>
    printf(1, "chdir / failed\n");
    2df9:	50                   	push   %eax
    2dfa:	50                   	push   %eax
    2dfb:	68 83 44 00 00       	push   $0x4483
    2e00:	6a 01                	push   $0x1
    2e02:	e8 c9 12 00 00       	call   40d0 <printf>
    exit(1);
    2e07:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2e0e:	e8 40 11 00 00       	call   3f53 <exit>
    printf(1, "rm .. worked!\n");
    2e13:	50                   	push   %eax
    2e14:	50                   	push   %eax
    2e15:	68 3c 50 00 00       	push   $0x503c
    2e1a:	6a 01                	push   $0x1
    2e1c:	e8 af 12 00 00       	call   40d0 <printf>
    exit(1);
    2e21:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2e28:	e8 26 11 00 00       	call   3f53 <exit>
    printf(1, "rm . worked!\n");
    2e2d:	50                   	push   %eax
    2e2e:	50                   	push   %eax
    2e2f:	68 2e 50 00 00       	push   $0x502e
    2e34:	6a 01                	push   $0x1
    2e36:	e8 95 12 00 00       	call   40d0 <printf>
    exit(1);
    2e3b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2e42:	e8 0c 11 00 00       	call   3f53 <exit>
    printf(1, "chdir dots failed\n");
    2e47:	50                   	push   %eax
    2e48:	50                   	push   %eax
    2e49:	68 1b 50 00 00       	push   $0x501b
    2e4e:	6a 01                	push   $0x1
    2e50:	e8 7b 12 00 00       	call   40d0 <printf>
    exit(1);
    2e55:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2e5c:	e8 f2 10 00 00       	call   3f53 <exit>
    2e61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    2e68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    2e6f:	90                   	nop

00002e70 <dirfile>:
{
    2e70:	f3 0f 1e fb          	endbr32 
    2e74:	55                   	push   %ebp
    2e75:	89 e5                	mov    %esp,%ebp
    2e77:	53                   	push   %ebx
    2e78:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "dir vs file\n");
    2e7b:	68 a8 50 00 00       	push   $0x50a8
    2e80:	6a 01                	push   $0x1
    2e82:	e8 49 12 00 00       	call   40d0 <printf>
  fd = open("dirfile", O_CREATE);
    2e87:	5b                   	pop    %ebx
    2e88:	58                   	pop    %eax
    2e89:	68 00 02 00 00       	push   $0x200
    2e8e:	68 b5 50 00 00       	push   $0x50b5
    2e93:	e8 fb 10 00 00       	call   3f93 <open>
  if(fd < 0){
    2e98:	83 c4 10             	add    $0x10,%esp
    2e9b:	85 c0                	test   %eax,%eax
    2e9d:	0f 88 51 01 00 00    	js     2ff4 <dirfile+0x184>
  close(fd);
    2ea3:	83 ec 0c             	sub    $0xc,%esp
    2ea6:	50                   	push   %eax
    2ea7:	e8 cf 10 00 00       	call   3f7b <close>
  if(chdir("dirfile") == 0){
    2eac:	c7 04 24 b5 50 00 00 	movl   $0x50b5,(%esp)
    2eb3:	e8 0b 11 00 00       	call   3fc3 <chdir>
    2eb8:	83 c4 10             	add    $0x10,%esp
    2ebb:	85 c0                	test   %eax,%eax
    2ebd:	0f 84 17 01 00 00    	je     2fda <dirfile+0x16a>
  fd = open("dirfile/xx", 0);
    2ec3:	83 ec 08             	sub    $0x8,%esp
    2ec6:	6a 00                	push   $0x0
    2ec8:	68 ee 50 00 00       	push   $0x50ee
    2ecd:	e8 c1 10 00 00       	call   3f93 <open>
  if(fd >= 0){
    2ed2:	83 c4 10             	add    $0x10,%esp
    2ed5:	85 c0                	test   %eax,%eax
    2ed7:	0f 89 e3 00 00 00    	jns    2fc0 <dirfile+0x150>
  fd = open("dirfile/xx", O_CREATE);
    2edd:	83 ec 08             	sub    $0x8,%esp
    2ee0:	68 00 02 00 00       	push   $0x200
    2ee5:	68 ee 50 00 00       	push   $0x50ee
    2eea:	e8 a4 10 00 00       	call   3f93 <open>
  if(fd >= 0){
    2eef:	83 c4 10             	add    $0x10,%esp
    2ef2:	85 c0                	test   %eax,%eax
    2ef4:	0f 89 c6 00 00 00    	jns    2fc0 <dirfile+0x150>
  if(mkdir("dirfile/xx") == 0){
    2efa:	83 ec 0c             	sub    $0xc,%esp
    2efd:	68 ee 50 00 00       	push   $0x50ee
    2f02:	e8 b4 10 00 00       	call   3fbb <mkdir>
    2f07:	83 c4 10             	add    $0x10,%esp
    2f0a:	85 c0                	test   %eax,%eax
    2f0c:	0f 84 7e 01 00 00    	je     3090 <dirfile+0x220>
  if(unlink("dirfile/xx") == 0){
    2f12:	83 ec 0c             	sub    $0xc,%esp
    2f15:	68 ee 50 00 00       	push   $0x50ee
    2f1a:	e8 84 10 00 00       	call   3fa3 <unlink>
    2f1f:	83 c4 10             	add    $0x10,%esp
    2f22:	85 c0                	test   %eax,%eax
    2f24:	0f 84 4c 01 00 00    	je     3076 <dirfile+0x206>
  if(link("README", "dirfile/xx") == 0){
    2f2a:	83 ec 08             	sub    $0x8,%esp
    2f2d:	68 ee 50 00 00       	push   $0x50ee
    2f32:	68 52 51 00 00       	push   $0x5152
    2f37:	e8 77 10 00 00       	call   3fb3 <link>
    2f3c:	83 c4 10             	add    $0x10,%esp
    2f3f:	85 c0                	test   %eax,%eax
    2f41:	0f 84 15 01 00 00    	je     305c <dirfile+0x1ec>
  if(unlink("dirfile") != 0){
    2f47:	83 ec 0c             	sub    $0xc,%esp
    2f4a:	68 b5 50 00 00       	push   $0x50b5
    2f4f:	e8 4f 10 00 00       	call   3fa3 <unlink>
    2f54:	83 c4 10             	add    $0x10,%esp
    2f57:	85 c0                	test   %eax,%eax
    2f59:	0f 85 e3 00 00 00    	jne    3042 <dirfile+0x1d2>
  fd = open(".", O_RDWR);
    2f5f:	83 ec 08             	sub    $0x8,%esp
    2f62:	6a 02                	push   $0x2
    2f64:	68 ae 4c 00 00       	push   $0x4cae
    2f69:	e8 25 10 00 00       	call   3f93 <open>
  if(fd >= 0){
    2f6e:	83 c4 10             	add    $0x10,%esp
    2f71:	85 c0                	test   %eax,%eax
    2f73:	0f 89 af 00 00 00    	jns    3028 <dirfile+0x1b8>
  fd = open(".", 0);
    2f79:	83 ec 08             	sub    $0x8,%esp
    2f7c:	6a 00                	push   $0x0
    2f7e:	68 ae 4c 00 00       	push   $0x4cae
    2f83:	e8 0b 10 00 00       	call   3f93 <open>
  if(write(fd, "x", 1) > 0){
    2f88:	83 c4 0c             	add    $0xc,%esp
    2f8b:	6a 01                	push   $0x1
  fd = open(".", 0);
    2f8d:	89 c3                	mov    %eax,%ebx
  if(write(fd, "x", 1) > 0){
    2f8f:	68 91 4d 00 00       	push   $0x4d91
    2f94:	50                   	push   %eax
    2f95:	e8 d9 0f 00 00       	call   3f73 <write>
    2f9a:	83 c4 10             	add    $0x10,%esp
    2f9d:	85 c0                	test   %eax,%eax
    2f9f:	7f 6d                	jg     300e <dirfile+0x19e>
  close(fd);
    2fa1:	83 ec 0c             	sub    $0xc,%esp
    2fa4:	53                   	push   %ebx
    2fa5:	e8 d1 0f 00 00       	call   3f7b <close>
  printf(1, "dir vs file OK\n");
    2faa:	58                   	pop    %eax
    2fab:	5a                   	pop    %edx
    2fac:	68 85 51 00 00       	push   $0x5185
    2fb1:	6a 01                	push   $0x1
    2fb3:	e8 18 11 00 00       	call   40d0 <printf>
}
    2fb8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    2fbb:	83 c4 10             	add    $0x10,%esp
    2fbe:	c9                   	leave  
    2fbf:	c3                   	ret    
    printf(1, "create dirfile/xx succeeded!\n");
    2fc0:	50                   	push   %eax
    2fc1:	50                   	push   %eax
    2fc2:	68 f9 50 00 00       	push   $0x50f9
    2fc7:	6a 01                	push   $0x1
    2fc9:	e8 02 11 00 00       	call   40d0 <printf>
    exit(1);
    2fce:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2fd5:	e8 79 0f 00 00       	call   3f53 <exit>
    printf(1, "chdir dirfile succeeded!\n");
    2fda:	52                   	push   %edx
    2fdb:	52                   	push   %edx
    2fdc:	68 d4 50 00 00       	push   $0x50d4
    2fe1:	6a 01                	push   $0x1
    2fe3:	e8 e8 10 00 00       	call   40d0 <printf>
    exit(1);
    2fe8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2fef:	e8 5f 0f 00 00       	call   3f53 <exit>
    printf(1, "create dirfile failed\n");
    2ff4:	51                   	push   %ecx
    2ff5:	51                   	push   %ecx
    2ff6:	68 bd 50 00 00       	push   $0x50bd
    2ffb:	6a 01                	push   $0x1
    2ffd:	e8 ce 10 00 00       	call   40d0 <printf>
    exit(1);
    3002:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3009:	e8 45 0f 00 00       	call   3f53 <exit>
    printf(1, "write . succeeded!\n");
    300e:	51                   	push   %ecx
    300f:	51                   	push   %ecx
    3010:	68 71 51 00 00       	push   $0x5171
    3015:	6a 01                	push   $0x1
    3017:	e8 b4 10 00 00       	call   40d0 <printf>
    exit(1);
    301c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3023:	e8 2b 0f 00 00       	call   3f53 <exit>
    printf(1, "open . for writing succeeded!\n");
    3028:	53                   	push   %ebx
    3029:	53                   	push   %ebx
    302a:	68 68 59 00 00       	push   $0x5968
    302f:	6a 01                	push   $0x1
    3031:	e8 9a 10 00 00       	call   40d0 <printf>
    exit(1);
    3036:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    303d:	e8 11 0f 00 00       	call   3f53 <exit>
    printf(1, "unlink dirfile failed!\n");
    3042:	50                   	push   %eax
    3043:	50                   	push   %eax
    3044:	68 59 51 00 00       	push   $0x5159
    3049:	6a 01                	push   $0x1
    304b:	e8 80 10 00 00       	call   40d0 <printf>
    exit(1);
    3050:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3057:	e8 f7 0e 00 00       	call   3f53 <exit>
    printf(1, "link to dirfile/xx succeeded!\n");
    305c:	50                   	push   %eax
    305d:	50                   	push   %eax
    305e:	68 48 59 00 00       	push   $0x5948
    3063:	6a 01                	push   $0x1
    3065:	e8 66 10 00 00       	call   40d0 <printf>
    exit(1);
    306a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3071:	e8 dd 0e 00 00       	call   3f53 <exit>
    printf(1, "unlink dirfile/xx succeeded!\n");
    3076:	50                   	push   %eax
    3077:	50                   	push   %eax
    3078:	68 34 51 00 00       	push   $0x5134
    307d:	6a 01                	push   $0x1
    307f:	e8 4c 10 00 00       	call   40d0 <printf>
    exit(1);
    3084:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    308b:	e8 c3 0e 00 00       	call   3f53 <exit>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    3090:	50                   	push   %eax
    3091:	50                   	push   %eax
    3092:	68 17 51 00 00       	push   $0x5117
    3097:	6a 01                	push   $0x1
    3099:	e8 32 10 00 00       	call   40d0 <printf>
    exit(1);
    309e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    30a5:	e8 a9 0e 00 00       	call   3f53 <exit>
    30aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000030b0 <iref>:
{
    30b0:	f3 0f 1e fb          	endbr32 
    30b4:	55                   	push   %ebp
    30b5:	89 e5                	mov    %esp,%ebp
    30b7:	53                   	push   %ebx
  printf(1, "empty file name\n");
    30b8:	bb 33 00 00 00       	mov    $0x33,%ebx
{
    30bd:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "empty file name\n");
    30c0:	68 95 51 00 00       	push   $0x5195
    30c5:	6a 01                	push   $0x1
    30c7:	e8 04 10 00 00       	call   40d0 <printf>
    30cc:	83 c4 10             	add    $0x10,%esp
    30cf:	90                   	nop
    if(mkdir("irefd") != 0){
    30d0:	83 ec 0c             	sub    $0xc,%esp
    30d3:	68 a6 51 00 00       	push   $0x51a6
    30d8:	e8 de 0e 00 00       	call   3fbb <mkdir>
    30dd:	83 c4 10             	add    $0x10,%esp
    30e0:	85 c0                	test   %eax,%eax
    30e2:	0f 85 bb 00 00 00    	jne    31a3 <iref+0xf3>
    if(chdir("irefd") != 0){
    30e8:	83 ec 0c             	sub    $0xc,%esp
    30eb:	68 a6 51 00 00       	push   $0x51a6
    30f0:	e8 ce 0e 00 00       	call   3fc3 <chdir>
    30f5:	83 c4 10             	add    $0x10,%esp
    30f8:	85 c0                	test   %eax,%eax
    30fa:	0f 85 be 00 00 00    	jne    31be <iref+0x10e>
    mkdir("");
    3100:	83 ec 0c             	sub    $0xc,%esp
    3103:	68 5b 48 00 00       	push   $0x485b
    3108:	e8 ae 0e 00 00       	call   3fbb <mkdir>
    link("README", "");
    310d:	59                   	pop    %ecx
    310e:	58                   	pop    %eax
    310f:	68 5b 48 00 00       	push   $0x485b
    3114:	68 52 51 00 00       	push   $0x5152
    3119:	e8 95 0e 00 00       	call   3fb3 <link>
    fd = open("", O_CREATE);
    311e:	58                   	pop    %eax
    311f:	5a                   	pop    %edx
    3120:	68 00 02 00 00       	push   $0x200
    3125:	68 5b 48 00 00       	push   $0x485b
    312a:	e8 64 0e 00 00       	call   3f93 <open>
    if(fd >= 0)
    312f:	83 c4 10             	add    $0x10,%esp
    3132:	85 c0                	test   %eax,%eax
    3134:	78 0c                	js     3142 <iref+0x92>
      close(fd);
    3136:	83 ec 0c             	sub    $0xc,%esp
    3139:	50                   	push   %eax
    313a:	e8 3c 0e 00 00       	call   3f7b <close>
    313f:	83 c4 10             	add    $0x10,%esp
    fd = open("xx", O_CREATE);
    3142:	83 ec 08             	sub    $0x8,%esp
    3145:	68 00 02 00 00       	push   $0x200
    314a:	68 90 4d 00 00       	push   $0x4d90
    314f:	e8 3f 0e 00 00       	call   3f93 <open>
    if(fd >= 0)
    3154:	83 c4 10             	add    $0x10,%esp
    3157:	85 c0                	test   %eax,%eax
    3159:	78 0c                	js     3167 <iref+0xb7>
      close(fd);
    315b:	83 ec 0c             	sub    $0xc,%esp
    315e:	50                   	push   %eax
    315f:	e8 17 0e 00 00       	call   3f7b <close>
    3164:	83 c4 10             	add    $0x10,%esp
    unlink("xx");
    3167:	83 ec 0c             	sub    $0xc,%esp
    316a:	68 90 4d 00 00       	push   $0x4d90
    316f:	e8 2f 0e 00 00       	call   3fa3 <unlink>
  for(i = 0; i < 50 + 1; i++){
    3174:	83 c4 10             	add    $0x10,%esp
    3177:	83 eb 01             	sub    $0x1,%ebx
    317a:	0f 85 50 ff ff ff    	jne    30d0 <iref+0x20>
  chdir("/");
    3180:	83 ec 0c             	sub    $0xc,%esp
    3183:	68 81 44 00 00       	push   $0x4481
    3188:	e8 36 0e 00 00       	call   3fc3 <chdir>
  printf(1, "empty file name OK\n");
    318d:	58                   	pop    %eax
    318e:	5a                   	pop    %edx
    318f:	68 d4 51 00 00       	push   $0x51d4
    3194:	6a 01                	push   $0x1
    3196:	e8 35 0f 00 00       	call   40d0 <printf>
}
    319b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    319e:	83 c4 10             	add    $0x10,%esp
    31a1:	c9                   	leave  
    31a2:	c3                   	ret    
      printf(1, "mkdir irefd failed\n");
    31a3:	83 ec 08             	sub    $0x8,%esp
    31a6:	68 ac 51 00 00       	push   $0x51ac
    31ab:	6a 01                	push   $0x1
    31ad:	e8 1e 0f 00 00       	call   40d0 <printf>
      exit(1);
    31b2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    31b9:	e8 95 0d 00 00       	call   3f53 <exit>
      printf(1, "chdir irefd failed\n");
    31be:	83 ec 08             	sub    $0x8,%esp
    31c1:	68 c0 51 00 00       	push   $0x51c0
    31c6:	6a 01                	push   $0x1
    31c8:	e8 03 0f 00 00       	call   40d0 <printf>
      exit(1);
    31cd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    31d4:	e8 7a 0d 00 00       	call   3f53 <exit>
    31d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000031e0 <forktest>:
{
    31e0:	f3 0f 1e fb          	endbr32 
    31e4:	55                   	push   %ebp
    31e5:	89 e5                	mov    %esp,%ebp
    31e7:	53                   	push   %ebx
  for(n=0; n<1000; n++){
    31e8:	31 db                	xor    %ebx,%ebx
{
    31ea:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "fork test\n");
    31ed:	68 e8 51 00 00       	push   $0x51e8
    31f2:	6a 01                	push   $0x1
    31f4:	e8 d7 0e 00 00       	call   40d0 <printf>
    31f9:	83 c4 10             	add    $0x10,%esp
    31fc:	eb 13                	jmp    3211 <forktest+0x31>
    31fe:	66 90                	xchg   %ax,%ax
    if(pid == 0)
    3200:	74 5a                	je     325c <forktest+0x7c>
  for(n=0; n<1000; n++){
    3202:	83 c3 01             	add    $0x1,%ebx
    3205:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
    320b:	0f 84 8a 00 00 00    	je     329b <forktest+0xbb>
    pid = fork();
    3211:	e8 35 0d 00 00       	call   3f4b <fork>
    if(pid < 0)
    3216:	85 c0                	test   %eax,%eax
    3218:	79 e6                	jns    3200 <forktest+0x20>
  for(; n > 0; n--){
    321a:	85 db                	test   %ebx,%ebx
    321c:	74 18                	je     3236 <forktest+0x56>
    321e:	66 90                	xchg   %ax,%ax
    if(wait(null) < 0){
    3220:	83 ec 0c             	sub    $0xc,%esp
    3223:	6a 00                	push   $0x0
    3225:	e8 31 0d 00 00       	call   3f5b <wait>
    322a:	83 c4 10             	add    $0x10,%esp
    322d:	85 c0                	test   %eax,%eax
    322f:	78 35                	js     3266 <forktest+0x86>
  for(; n > 0; n--){
    3231:	83 eb 01             	sub    $0x1,%ebx
    3234:	75 ea                	jne    3220 <forktest+0x40>
  if(wait(null) != -1){
    3236:	83 ec 0c             	sub    $0xc,%esp
    3239:	6a 00                	push   $0x0
    323b:	e8 1b 0d 00 00       	call   3f5b <wait>
    3240:	83 c4 10             	add    $0x10,%esp
    3243:	83 f8 ff             	cmp    $0xffffffff,%eax
    3246:	75 39                	jne    3281 <forktest+0xa1>
  printf(1, "fork test OK\n");
    3248:	83 ec 08             	sub    $0x8,%esp
    324b:	68 1a 52 00 00       	push   $0x521a
    3250:	6a 01                	push   $0x1
    3252:	e8 79 0e 00 00       	call   40d0 <printf>
}
    3257:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    325a:	c9                   	leave  
    325b:	c3                   	ret    
      exit(1);
    325c:	83 ec 0c             	sub    $0xc,%esp
    325f:	6a 01                	push   $0x1
    3261:	e8 ed 0c 00 00       	call   3f53 <exit>
      printf(1, "wait stopped early\n");
    3266:	83 ec 08             	sub    $0x8,%esp
    3269:	68 f3 51 00 00       	push   $0x51f3
    326e:	6a 01                	push   $0x1
    3270:	e8 5b 0e 00 00       	call   40d0 <printf>
      exit(1);
    3275:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    327c:	e8 d2 0c 00 00       	call   3f53 <exit>
    printf(1, "wait got too many\n");
    3281:	52                   	push   %edx
    3282:	52                   	push   %edx
    3283:	68 07 52 00 00       	push   $0x5207
    3288:	6a 01                	push   $0x1
    328a:	e8 41 0e 00 00       	call   40d0 <printf>
    exit(1);
    328f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3296:	e8 b8 0c 00 00       	call   3f53 <exit>
    printf(1, "fork claimed to work 1000 times!\n");
    329b:	50                   	push   %eax
    329c:	50                   	push   %eax
    329d:	68 88 59 00 00       	push   $0x5988
    32a2:	6a 01                	push   $0x1
    32a4:	e8 27 0e 00 00       	call   40d0 <printf>
    exit(1);
    32a9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    32b0:	e8 9e 0c 00 00       	call   3f53 <exit>
    32b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    32bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000032c0 <sbrktest>:
{
    32c0:	f3 0f 1e fb          	endbr32 
    32c4:	55                   	push   %ebp
    32c5:	89 e5                	mov    %esp,%ebp
    32c7:	57                   	push   %edi
  for(i = 0; i < 5000; i++){
    32c8:	31 ff                	xor    %edi,%edi
{
    32ca:	56                   	push   %esi
    32cb:	53                   	push   %ebx
    32cc:	83 ec 54             	sub    $0x54,%esp
  printf(stdout, "sbrk test\n");
    32cf:	68 28 52 00 00       	push   $0x5228
    32d4:	ff 35 d0 64 00 00    	pushl  0x64d0
    32da:	e8 f1 0d 00 00       	call   40d0 <printf>
  oldbrk = sbrk(0);
    32df:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    32e6:	e8 f0 0c 00 00       	call   3fdb <sbrk>
  a = sbrk(0);
    32eb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  oldbrk = sbrk(0);
    32f2:	89 c3                	mov    %eax,%ebx
  a = sbrk(0);
    32f4:	e8 e2 0c 00 00       	call   3fdb <sbrk>
    32f9:	83 c4 10             	add    $0x10,%esp
    32fc:	89 c6                	mov    %eax,%esi
  for(i = 0; i < 5000; i++){
    32fe:	eb 02                	jmp    3302 <sbrktest+0x42>
    a = b + 1;
    3300:	89 c6                	mov    %eax,%esi
    b = sbrk(1);
    3302:	83 ec 0c             	sub    $0xc,%esp
    3305:	6a 01                	push   $0x1
    3307:	e8 cf 0c 00 00       	call   3fdb <sbrk>
    if(b != a){
    330c:	83 c4 10             	add    $0x10,%esp
    330f:	39 f0                	cmp    %esi,%eax
    3311:	0f 85 a7 02 00 00    	jne    35be <sbrktest+0x2fe>
  for(i = 0; i < 5000; i++){
    3317:	83 c7 01             	add    $0x1,%edi
    *b = 1;
    331a:	c6 06 01             	movb   $0x1,(%esi)
    a = b + 1;
    331d:	8d 46 01             	lea    0x1(%esi),%eax
  for(i = 0; i < 5000; i++){
    3320:	81 ff 88 13 00 00    	cmp    $0x1388,%edi
    3326:	75 d8                	jne    3300 <sbrktest+0x40>
  pid = fork();
    3328:	e8 1e 0c 00 00       	call   3f4b <fork>
    332d:	89 c7                	mov    %eax,%edi
  if(pid < 0){
    332f:	85 c0                	test   %eax,%eax
    3331:	0f 88 0d 04 00 00    	js     3744 <sbrktest+0x484>
  c = sbrk(1);
    3337:	83 ec 0c             	sub    $0xc,%esp
  if(c != a + 1){
    333a:	83 c6 02             	add    $0x2,%esi
  c = sbrk(1);
    333d:	6a 01                	push   $0x1
    333f:	e8 97 0c 00 00       	call   3fdb <sbrk>
  c = sbrk(1);
    3344:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    334b:	e8 8b 0c 00 00       	call   3fdb <sbrk>
  if(c != a + 1){
    3350:	83 c4 10             	add    $0x10,%esp
    3353:	39 c6                	cmp    %eax,%esi
    3355:	0f 85 cb 03 00 00    	jne    3726 <sbrktest+0x466>
  if(pid == 0)
    335b:	85 ff                	test   %edi,%edi
    335d:	0f 84 b9 03 00 00    	je     371c <sbrktest+0x45c>
  wait(null);
    3363:	83 ec 0c             	sub    $0xc,%esp
    3366:	6a 00                	push   $0x0
    3368:	e8 ee 0b 00 00       	call   3f5b <wait>
  a = sbrk(0);
    336d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3374:	e8 62 0c 00 00       	call   3fdb <sbrk>
    3379:	89 c6                	mov    %eax,%esi
  amt = (BIG) - (uint)a;
    337b:	b8 00 00 40 06       	mov    $0x6400000,%eax
    3380:	29 f0                	sub    %esi,%eax
  p = sbrk(amt);
    3382:	89 04 24             	mov    %eax,(%esp)
    3385:	e8 51 0c 00 00       	call   3fdb <sbrk>
  if (p != a) {
    338a:	83 c4 10             	add    $0x10,%esp
    338d:	39 c6                	cmp    %eax,%esi
    338f:	0f 85 69 03 00 00    	jne    36fe <sbrktest+0x43e>
  a = sbrk(0);
    3395:	83 ec 0c             	sub    $0xc,%esp
  *lastaddr = 99;
    3398:	c6 05 ff ff 3f 06 63 	movb   $0x63,0x63fffff
  a = sbrk(0);
    339f:	6a 00                	push   $0x0
    33a1:	e8 35 0c 00 00       	call   3fdb <sbrk>
  c = sbrk(-4096);
    33a6:	c7 04 24 00 f0 ff ff 	movl   $0xfffff000,(%esp)
  a = sbrk(0);
    33ad:	89 c6                	mov    %eax,%esi
  c = sbrk(-4096);
    33af:	e8 27 0c 00 00       	call   3fdb <sbrk>
  if(c == (char*)0xffffffff){
    33b4:	83 c4 10             	add    $0x10,%esp
    33b7:	83 f8 ff             	cmp    $0xffffffff,%eax
    33ba:	0f 84 20 03 00 00    	je     36e0 <sbrktest+0x420>
  c = sbrk(0);
    33c0:	83 ec 0c             	sub    $0xc,%esp
    33c3:	6a 00                	push   $0x0
    33c5:	e8 11 0c 00 00       	call   3fdb <sbrk>
  if(c != a - 4096){
    33ca:	8d 96 00 f0 ff ff    	lea    -0x1000(%esi),%edx
    33d0:	83 c4 10             	add    $0x10,%esp
    33d3:	39 d0                	cmp    %edx,%eax
    33d5:	0f 85 e7 02 00 00    	jne    36c2 <sbrktest+0x402>
  a = sbrk(0);
    33db:	83 ec 0c             	sub    $0xc,%esp
    33de:	6a 00                	push   $0x0
    33e0:	e8 f6 0b 00 00       	call   3fdb <sbrk>
  c = sbrk(4096);
    33e5:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  a = sbrk(0);
    33ec:	89 c6                	mov    %eax,%esi
  c = sbrk(4096);
    33ee:	e8 e8 0b 00 00       	call   3fdb <sbrk>
  if(c != a || sbrk(0) != a + 4096){
    33f3:	83 c4 10             	add    $0x10,%esp
  c = sbrk(4096);
    33f6:	89 c7                	mov    %eax,%edi
  if(c != a || sbrk(0) != a + 4096){
    33f8:	39 c6                	cmp    %eax,%esi
    33fa:	0f 85 a4 02 00 00    	jne    36a4 <sbrktest+0x3e4>
    3400:	83 ec 0c             	sub    $0xc,%esp
    3403:	6a 00                	push   $0x0
    3405:	e8 d1 0b 00 00       	call   3fdb <sbrk>
    340a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    3410:	83 c4 10             	add    $0x10,%esp
    3413:	39 c2                	cmp    %eax,%edx
    3415:	0f 85 89 02 00 00    	jne    36a4 <sbrktest+0x3e4>
  if(*lastaddr == 99){
    341b:	80 3d ff ff 3f 06 63 	cmpb   $0x63,0x63fffff
    3422:	0f 84 5e 02 00 00    	je     3686 <sbrktest+0x3c6>
  a = sbrk(0);
    3428:	83 ec 0c             	sub    $0xc,%esp
    342b:	6a 00                	push   $0x0
    342d:	e8 a9 0b 00 00       	call   3fdb <sbrk>
  c = sbrk(-(sbrk(0) - oldbrk));
    3432:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  a = sbrk(0);
    3439:	89 c6                	mov    %eax,%esi
  c = sbrk(-(sbrk(0) - oldbrk));
    343b:	e8 9b 0b 00 00       	call   3fdb <sbrk>
    3440:	89 d9                	mov    %ebx,%ecx
    3442:	29 c1                	sub    %eax,%ecx
    3444:	89 0c 24             	mov    %ecx,(%esp)
    3447:	e8 8f 0b 00 00       	call   3fdb <sbrk>
  if(c != a){
    344c:	83 c4 10             	add    $0x10,%esp
    344f:	39 c6                	cmp    %eax,%esi
    3451:	0f 85 11 02 00 00    	jne    3668 <sbrktest+0x3a8>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    3457:	be 00 00 00 80       	mov    $0x80000000,%esi
    345c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ppid = getpid();
    3460:	e8 6e 0b 00 00       	call   3fd3 <getpid>
    3465:	89 c7                	mov    %eax,%edi
    pid = fork();
    3467:	e8 df 0a 00 00       	call   3f4b <fork>
    if(pid < 0){
    346c:	85 c0                	test   %eax,%eax
    346e:	0f 88 d5 01 00 00    	js     3649 <sbrktest+0x389>
    if(pid == 0){
    3474:	0f 84 a6 01 00 00    	je     3620 <sbrktest+0x360>
    wait(null);
    347a:	83 ec 0c             	sub    $0xc,%esp
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    347d:	81 c6 50 c3 00 00    	add    $0xc350,%esi
    wait(null);
    3483:	6a 00                	push   $0x0
    3485:	e8 d1 0a 00 00       	call   3f5b <wait>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    348a:	83 c4 10             	add    $0x10,%esp
    348d:	81 fe 80 84 1e 80    	cmp    $0x801e8480,%esi
    3493:	75 cb                	jne    3460 <sbrktest+0x1a0>
  if(pipe(fds) != 0){
    3495:	83 ec 0c             	sub    $0xc,%esp
    3498:	8d 45 b8             	lea    -0x48(%ebp),%eax
    349b:	50                   	push   %eax
    349c:	e8 c2 0a 00 00       	call   3f63 <pipe>
    34a1:	83 c4 10             	add    $0x10,%esp
    34a4:	85 c0                	test   %eax,%eax
    34a6:	0f 85 50 01 00 00    	jne    35fc <sbrktest+0x33c>
    34ac:	8d 75 c0             	lea    -0x40(%ebp),%esi
    34af:	89 f7                	mov    %esi,%edi
    if((pids[i] = fork()) == 0){
    34b1:	e8 95 0a 00 00       	call   3f4b <fork>
    34b6:	89 07                	mov    %eax,(%edi)
    34b8:	85 c0                	test   %eax,%eax
    34ba:	0f 84 96 00 00 00    	je     3556 <sbrktest+0x296>
    if(pids[i] != -1)
    34c0:	83 f8 ff             	cmp    $0xffffffff,%eax
    34c3:	74 14                	je     34d9 <sbrktest+0x219>
      read(fds[0], &scratch, 1);
    34c5:	83 ec 04             	sub    $0x4,%esp
    34c8:	8d 45 b7             	lea    -0x49(%ebp),%eax
    34cb:	6a 01                	push   $0x1
    34cd:	50                   	push   %eax
    34ce:	ff 75 b8             	pushl  -0x48(%ebp)
    34d1:	e8 95 0a 00 00       	call   3f6b <read>
    34d6:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    34d9:	83 c7 04             	add    $0x4,%edi
    34dc:	8d 45 e8             	lea    -0x18(%ebp),%eax
    34df:	39 c7                	cmp    %eax,%edi
    34e1:	75 ce                	jne    34b1 <sbrktest+0x1f1>
  c = sbrk(4096);
    34e3:	83 ec 0c             	sub    $0xc,%esp
    34e6:	68 00 10 00 00       	push   $0x1000
    34eb:	e8 eb 0a 00 00       	call   3fdb <sbrk>
    34f0:	83 c4 10             	add    $0x10,%esp
    34f3:	89 c7                	mov    %eax,%edi
    if(pids[i] == -1)
    34f5:	8b 06                	mov    (%esi),%eax
    34f7:	83 f8 ff             	cmp    $0xffffffff,%eax
    34fa:	74 18                	je     3514 <sbrktest+0x254>
    kill(pids[i]);
    34fc:	83 ec 0c             	sub    $0xc,%esp
    34ff:	50                   	push   %eax
    3500:	e8 7e 0a 00 00       	call   3f83 <kill>
    wait(null);
    3505:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    350c:	e8 4a 0a 00 00       	call   3f5b <wait>
    3511:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3514:	83 c6 04             	add    $0x4,%esi
    3517:	8d 45 e8             	lea    -0x18(%ebp),%eax
    351a:	39 f0                	cmp    %esi,%eax
    351c:	75 d7                	jne    34f5 <sbrktest+0x235>
  if(c == (char*)0xffffffff){
    351e:	83 ff ff             	cmp    $0xffffffff,%edi
    3521:	0f 84 b7 00 00 00    	je     35de <sbrktest+0x31e>
  if(sbrk(0) > oldbrk)
    3527:	83 ec 0c             	sub    $0xc,%esp
    352a:	6a 00                	push   $0x0
    352c:	e8 aa 0a 00 00       	call   3fdb <sbrk>
    3531:	83 c4 10             	add    $0x10,%esp
    3534:	39 c3                	cmp    %eax,%ebx
    3536:	72 6a                	jb     35a2 <sbrktest+0x2e2>
  printf(stdout, "sbrk test OK\n");
    3538:	83 ec 08             	sub    $0x8,%esp
    353b:	68 d0 52 00 00       	push   $0x52d0
    3540:	ff 35 d0 64 00 00    	pushl  0x64d0
    3546:	e8 85 0b 00 00       	call   40d0 <printf>
}
    354b:	83 c4 10             	add    $0x10,%esp
    354e:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3551:	5b                   	pop    %ebx
    3552:	5e                   	pop    %esi
    3553:	5f                   	pop    %edi
    3554:	5d                   	pop    %ebp
    3555:	c3                   	ret    
      sbrk(BIG - (uint)sbrk(0));
    3556:	83 ec 0c             	sub    $0xc,%esp
    3559:	6a 00                	push   $0x0
    355b:	e8 7b 0a 00 00       	call   3fdb <sbrk>
    3560:	89 c2                	mov    %eax,%edx
    3562:	b8 00 00 40 06       	mov    $0x6400000,%eax
    3567:	29 d0                	sub    %edx,%eax
    3569:	89 04 24             	mov    %eax,(%esp)
    356c:	e8 6a 0a 00 00       	call   3fdb <sbrk>
      write(fds[1], "x", 1);
    3571:	83 c4 0c             	add    $0xc,%esp
    3574:	6a 01                	push   $0x1
    3576:	68 91 4d 00 00       	push   $0x4d91
    357b:	ff 75 bc             	pushl  -0x44(%ebp)
    357e:	e8 f0 09 00 00       	call   3f73 <write>
    3583:	83 c4 10             	add    $0x10,%esp
    3586:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    358d:	8d 76 00             	lea    0x0(%esi),%esi
      for(;;) sleep(1000);
    3590:	83 ec 0c             	sub    $0xc,%esp
    3593:	68 e8 03 00 00       	push   $0x3e8
    3598:	e8 46 0a 00 00       	call   3fe3 <sleep>
    359d:	83 c4 10             	add    $0x10,%esp
    35a0:	eb ee                	jmp    3590 <sbrktest+0x2d0>
    sbrk(-(sbrk(0) - oldbrk));
    35a2:	83 ec 0c             	sub    $0xc,%esp
    35a5:	6a 00                	push   $0x0
    35a7:	e8 2f 0a 00 00       	call   3fdb <sbrk>
    35ac:	29 c3                	sub    %eax,%ebx
    35ae:	89 1c 24             	mov    %ebx,(%esp)
    35b1:	e8 25 0a 00 00       	call   3fdb <sbrk>
    35b6:	83 c4 10             	add    $0x10,%esp
    35b9:	e9 7a ff ff ff       	jmp    3538 <sbrktest+0x278>
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
    35be:	83 ec 0c             	sub    $0xc,%esp
    35c1:	50                   	push   %eax
    35c2:	56                   	push   %esi
    35c3:	57                   	push   %edi
    35c4:	68 33 52 00 00       	push   $0x5233
    35c9:	ff 35 d0 64 00 00    	pushl  0x64d0
    35cf:	e8 fc 0a 00 00       	call   40d0 <printf>
      exit(1);
    35d4:	83 c4 14             	add    $0x14,%esp
    35d7:	6a 01                	push   $0x1
    35d9:	e8 75 09 00 00       	call   3f53 <exit>
    printf(stdout, "failed sbrk leaked memory\n");
    35de:	50                   	push   %eax
    35df:	50                   	push   %eax
    35e0:	68 b5 52 00 00       	push   $0x52b5
    35e5:	ff 35 d0 64 00 00    	pushl  0x64d0
    35eb:	e8 e0 0a 00 00       	call   40d0 <printf>
    exit(1);
    35f0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    35f7:	e8 57 09 00 00       	call   3f53 <exit>
    printf(1, "pipe() failed\n");
    35fc:	52                   	push   %edx
    35fd:	52                   	push   %edx
    35fe:	68 71 47 00 00       	push   $0x4771
    3603:	6a 01                	push   $0x1
    3605:	e8 c6 0a 00 00       	call   40d0 <printf>
    exit(1);
    360a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3611:	e8 3d 09 00 00       	call   3f53 <exit>
    3616:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    361d:	8d 76 00             	lea    0x0(%esi),%esi
      printf(stdout, "oops could read %x = %x\n", a, *a);
    3620:	0f be 06             	movsbl (%esi),%eax
    3623:	50                   	push   %eax
    3624:	56                   	push   %esi
    3625:	68 9c 52 00 00       	push   $0x529c
    362a:	ff 35 d0 64 00 00    	pushl  0x64d0
    3630:	e8 9b 0a 00 00       	call   40d0 <printf>
      kill(ppid);
    3635:	89 3c 24             	mov    %edi,(%esp)
    3638:	e8 46 09 00 00       	call   3f83 <kill>
      exit(1);
    363d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3644:	e8 0a 09 00 00       	call   3f53 <exit>
      printf(stdout, "fork failed\n");
    3649:	83 ec 08             	sub    $0x8,%esp
    364c:	68 79 53 00 00       	push   $0x5379
    3651:	ff 35 d0 64 00 00    	pushl  0x64d0
    3657:	e8 74 0a 00 00       	call   40d0 <printf>
      exit(1);
    365c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3663:	e8 eb 08 00 00       	call   3f53 <exit>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    3668:	50                   	push   %eax
    3669:	56                   	push   %esi
    366a:	68 7c 5a 00 00       	push   $0x5a7c
    366f:	ff 35 d0 64 00 00    	pushl  0x64d0
    3675:	e8 56 0a 00 00       	call   40d0 <printf>
    exit(1);
    367a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3681:	e8 cd 08 00 00       	call   3f53 <exit>
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    3686:	51                   	push   %ecx
    3687:	51                   	push   %ecx
    3688:	68 4c 5a 00 00       	push   $0x5a4c
    368d:	ff 35 d0 64 00 00    	pushl  0x64d0
    3693:	e8 38 0a 00 00       	call   40d0 <printf>
    exit(1);
    3698:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    369f:	e8 af 08 00 00       	call   3f53 <exit>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    36a4:	57                   	push   %edi
    36a5:	56                   	push   %esi
    36a6:	68 24 5a 00 00       	push   $0x5a24
    36ab:	ff 35 d0 64 00 00    	pushl  0x64d0
    36b1:	e8 1a 0a 00 00       	call   40d0 <printf>
    exit(1);
    36b6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    36bd:	e8 91 08 00 00       	call   3f53 <exit>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    36c2:	50                   	push   %eax
    36c3:	56                   	push   %esi
    36c4:	68 ec 59 00 00       	push   $0x59ec
    36c9:	ff 35 d0 64 00 00    	pushl  0x64d0
    36cf:	e8 fc 09 00 00       	call   40d0 <printf>
    exit(1);
    36d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    36db:	e8 73 08 00 00       	call   3f53 <exit>
    printf(stdout, "sbrk could not deallocate\n");
    36e0:	53                   	push   %ebx
    36e1:	53                   	push   %ebx
    36e2:	68 81 52 00 00       	push   $0x5281
    36e7:	ff 35 d0 64 00 00    	pushl  0x64d0
    36ed:	e8 de 09 00 00       	call   40d0 <printf>
    exit(1);
    36f2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    36f9:	e8 55 08 00 00       	call   3f53 <exit>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    36fe:	56                   	push   %esi
    36ff:	56                   	push   %esi
    3700:	68 ac 59 00 00       	push   $0x59ac
    3705:	ff 35 d0 64 00 00    	pushl  0x64d0
    370b:	e8 c0 09 00 00       	call   40d0 <printf>
    exit(1);
    3710:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3717:	e8 37 08 00 00       	call   3f53 <exit>
    exit(1);
    371c:	83 ec 0c             	sub    $0xc,%esp
    371f:	6a 01                	push   $0x1
    3721:	e8 2d 08 00 00       	call   3f53 <exit>
    printf(stdout, "sbrk test failed post-fork\n");
    3726:	57                   	push   %edi
    3727:	57                   	push   %edi
    3728:	68 65 52 00 00       	push   $0x5265
    372d:	ff 35 d0 64 00 00    	pushl  0x64d0
    3733:	e8 98 09 00 00       	call   40d0 <printf>
    exit(1);
    3738:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    373f:	e8 0f 08 00 00       	call   3f53 <exit>
    printf(stdout, "sbrk test fork failed\n");
    3744:	50                   	push   %eax
    3745:	50                   	push   %eax
    3746:	68 4e 52 00 00       	push   $0x524e
    374b:	ff 35 d0 64 00 00    	pushl  0x64d0
    3751:	e8 7a 09 00 00       	call   40d0 <printf>
    exit(1);
    3756:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    375d:	e8 f1 07 00 00       	call   3f53 <exit>
    3762:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00003770 <validateint>:
{
    3770:	f3 0f 1e fb          	endbr32 
}
    3774:	c3                   	ret    
    3775:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    377c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00003780 <validatetest>:
{
    3780:	f3 0f 1e fb          	endbr32 
    3784:	55                   	push   %ebp
    3785:	89 e5                	mov    %esp,%ebp
    3787:	56                   	push   %esi
  for(p = 0; p <= (uint)hi; p += 4096){
    3788:	31 f6                	xor    %esi,%esi
{
    378a:	53                   	push   %ebx
  printf(stdout, "validate test\n");
    378b:	83 ec 08             	sub    $0x8,%esp
    378e:	68 de 52 00 00       	push   $0x52de
    3793:	ff 35 d0 64 00 00    	pushl  0x64d0
    3799:	e8 32 09 00 00       	call   40d0 <printf>
    379e:	83 c4 10             	add    $0x10,%esp
    37a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((pid = fork()) == 0){
    37a8:	e8 9e 07 00 00       	call   3f4b <fork>
    37ad:	89 c3                	mov    %eax,%ebx
    37af:	85 c0                	test   %eax,%eax
    37b1:	74 6a                	je     381d <validatetest+0x9d>
    sleep(0);
    37b3:	83 ec 0c             	sub    $0xc,%esp
    37b6:	6a 00                	push   $0x0
    37b8:	e8 26 08 00 00       	call   3fe3 <sleep>
    sleep(0);
    37bd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    37c4:	e8 1a 08 00 00       	call   3fe3 <sleep>
    kill(pid);
    37c9:	89 1c 24             	mov    %ebx,(%esp)
    37cc:	e8 b2 07 00 00       	call   3f83 <kill>
    wait(null);
    37d1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    37d8:	e8 7e 07 00 00       	call   3f5b <wait>
    if(link("nosuchfile", (char*)p) != -1){
    37dd:	58                   	pop    %eax
    37de:	5a                   	pop    %edx
    37df:	56                   	push   %esi
    37e0:	68 ed 52 00 00       	push   $0x52ed
    37e5:	e8 c9 07 00 00       	call   3fb3 <link>
    37ea:	83 c4 10             	add    $0x10,%esp
    37ed:	83 f8 ff             	cmp    $0xffffffff,%eax
    37f0:	75 35                	jne    3827 <validatetest+0xa7>
  for(p = 0; p <= (uint)hi; p += 4096){
    37f2:	81 c6 00 10 00 00    	add    $0x1000,%esi
    37f8:	81 fe 00 40 11 00    	cmp    $0x114000,%esi
    37fe:	75 a8                	jne    37a8 <validatetest+0x28>
  printf(stdout, "validate ok\n");
    3800:	83 ec 08             	sub    $0x8,%esp
    3803:	68 11 53 00 00       	push   $0x5311
    3808:	ff 35 d0 64 00 00    	pushl  0x64d0
    380e:	e8 bd 08 00 00       	call   40d0 <printf>
}
    3813:	83 c4 10             	add    $0x10,%esp
    3816:	8d 65 f8             	lea    -0x8(%ebp),%esp
    3819:	5b                   	pop    %ebx
    381a:	5e                   	pop    %esi
    381b:	5d                   	pop    %ebp
    381c:	c3                   	ret    
      exit(1);
    381d:	83 ec 0c             	sub    $0xc,%esp
    3820:	6a 01                	push   $0x1
    3822:	e8 2c 07 00 00       	call   3f53 <exit>
      printf(stdout, "link should not succeed\n");
    3827:	83 ec 08             	sub    $0x8,%esp
    382a:	68 f8 52 00 00       	push   $0x52f8
    382f:	ff 35 d0 64 00 00    	pushl  0x64d0
    3835:	e8 96 08 00 00       	call   40d0 <printf>
      exit(1);
    383a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3841:	e8 0d 07 00 00       	call   3f53 <exit>
    3846:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    384d:	8d 76 00             	lea    0x0(%esi),%esi

00003850 <bsstest>:
{
    3850:	f3 0f 1e fb          	endbr32 
    3854:	55                   	push   %ebp
    3855:	89 e5                	mov    %esp,%ebp
    3857:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "bss test\n");
    385a:	68 1e 53 00 00       	push   $0x531e
    385f:	ff 35 d0 64 00 00    	pushl  0x64d0
    3865:	e8 66 08 00 00       	call   40d0 <printf>
    386a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sizeof(uninit); i++){
    386d:	31 c0                	xor    %eax,%eax
    386f:	90                   	nop
    if(uninit[i] != '\0'){
    3870:	80 b8 a0 65 00 00 00 	cmpb   $0x0,0x65a0(%eax)
    3877:	75 22                	jne    389b <bsstest+0x4b>
  for(i = 0; i < sizeof(uninit); i++){
    3879:	83 c0 01             	add    $0x1,%eax
    387c:	3d 10 27 00 00       	cmp    $0x2710,%eax
    3881:	75 ed                	jne    3870 <bsstest+0x20>
  printf(stdout, "bss test ok\n");
    3883:	83 ec 08             	sub    $0x8,%esp
    3886:	68 39 53 00 00       	push   $0x5339
    388b:	ff 35 d0 64 00 00    	pushl  0x64d0
    3891:	e8 3a 08 00 00       	call   40d0 <printf>
}
    3896:	83 c4 10             	add    $0x10,%esp
    3899:	c9                   	leave  
    389a:	c3                   	ret    
      printf(stdout, "bss test failed\n");
    389b:	83 ec 08             	sub    $0x8,%esp
    389e:	68 28 53 00 00       	push   $0x5328
    38a3:	ff 35 d0 64 00 00    	pushl  0x64d0
    38a9:	e8 22 08 00 00       	call   40d0 <printf>
      exit(1);
    38ae:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    38b5:	e8 99 06 00 00       	call   3f53 <exit>
    38ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000038c0 <bigargtest>:
{
    38c0:	f3 0f 1e fb          	endbr32 
    38c4:	55                   	push   %ebp
    38c5:	89 e5                	mov    %esp,%ebp
    38c7:	83 ec 14             	sub    $0x14,%esp
  unlink("bigarg-ok");
    38ca:	68 46 53 00 00       	push   $0x5346
    38cf:	e8 cf 06 00 00       	call   3fa3 <unlink>
  pid = fork();
    38d4:	e8 72 06 00 00       	call   3f4b <fork>
  if(pid == 0){
    38d9:	83 c4 10             	add    $0x10,%esp
    38dc:	85 c0                	test   %eax,%eax
    38de:	74 48                	je     3928 <bigargtest+0x68>
  } else if(pid < 0){
    38e0:	0f 88 d7 00 00 00    	js     39bd <bigargtest+0xfd>
  wait(null);
    38e6:	83 ec 0c             	sub    $0xc,%esp
    38e9:	6a 00                	push   $0x0
    38eb:	e8 6b 06 00 00       	call   3f5b <wait>
  fd = open("bigarg-ok", 0);
    38f0:	5a                   	pop    %edx
    38f1:	59                   	pop    %ecx
    38f2:	6a 00                	push   $0x0
    38f4:	68 46 53 00 00       	push   $0x5346
    38f9:	e8 95 06 00 00       	call   3f93 <open>
  if(fd < 0){
    38fe:	83 c4 10             	add    $0x10,%esp
    3901:	85 c0                	test   %eax,%eax
    3903:	0f 88 96 00 00 00    	js     399f <bigargtest+0xdf>
  close(fd);
    3909:	83 ec 0c             	sub    $0xc,%esp
    390c:	50                   	push   %eax
    390d:	e8 69 06 00 00       	call   3f7b <close>
  unlink("bigarg-ok");
    3912:	c7 04 24 46 53 00 00 	movl   $0x5346,(%esp)
    3919:	e8 85 06 00 00       	call   3fa3 <unlink>
}
    391e:	83 c4 10             	add    $0x10,%esp
    3921:	c9                   	leave  
    3922:	c3                   	ret    
    3923:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    3927:	90                   	nop
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    3928:	c7 04 85 00 65 00 00 	movl   $0x5aa0,0x6500(,%eax,4)
    392f:	a0 5a 00 00 
    for(i = 0; i < MAXARG-1; i++)
    3933:	83 c0 01             	add    $0x1,%eax
    3936:	83 f8 1f             	cmp    $0x1f,%eax
    3939:	75 ed                	jne    3928 <bigargtest+0x68>
    printf(stdout, "bigarg test\n");
    393b:	50                   	push   %eax
    393c:	50                   	push   %eax
    393d:	68 50 53 00 00       	push   $0x5350
    3942:	ff 35 d0 64 00 00    	pushl  0x64d0
    args[MAXARG-1] = 0;
    3948:	c7 05 7c 65 00 00 00 	movl   $0x0,0x657c
    394f:	00 00 00 
    printf(stdout, "bigarg test\n");
    3952:	e8 79 07 00 00       	call   40d0 <printf>
    exec("echo", args);
    3957:	58                   	pop    %eax
    3958:	5a                   	pop    %edx
    3959:	68 00 65 00 00       	push   $0x6500
    395e:	68 1d 45 00 00       	push   $0x451d
    3963:	e8 23 06 00 00       	call   3f8b <exec>
    printf(stdout, "bigarg test ok\n");
    3968:	59                   	pop    %ecx
    3969:	58                   	pop    %eax
    396a:	68 5d 53 00 00       	push   $0x535d
    396f:	ff 35 d0 64 00 00    	pushl  0x64d0
    3975:	e8 56 07 00 00       	call   40d0 <printf>
    fd = open("bigarg-ok", O_CREATE);
    397a:	58                   	pop    %eax
    397b:	5a                   	pop    %edx
    397c:	68 00 02 00 00       	push   $0x200
    3981:	68 46 53 00 00       	push   $0x5346
    3986:	e8 08 06 00 00       	call   3f93 <open>
    close(fd);
    398b:	89 04 24             	mov    %eax,(%esp)
    398e:	e8 e8 05 00 00       	call   3f7b <close>
    exit(1);
    3993:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    399a:	e8 b4 05 00 00       	call   3f53 <exit>
    printf(stdout, "bigarg test failed!\n");
    399f:	50                   	push   %eax
    39a0:	50                   	push   %eax
    39a1:	68 86 53 00 00       	push   $0x5386
    39a6:	ff 35 d0 64 00 00    	pushl  0x64d0
    39ac:	e8 1f 07 00 00       	call   40d0 <printf>
    exit(1);
    39b1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    39b8:	e8 96 05 00 00       	call   3f53 <exit>
    printf(stdout, "bigargtest: fork failed\n");
    39bd:	50                   	push   %eax
    39be:	50                   	push   %eax
    39bf:	68 6d 53 00 00       	push   $0x536d
    39c4:	ff 35 d0 64 00 00    	pushl  0x64d0
    39ca:	e8 01 07 00 00       	call   40d0 <printf>
    exit(1);
    39cf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    39d6:	e8 78 05 00 00       	call   3f53 <exit>
    39db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    39df:	90                   	nop

000039e0 <fsfull>:
{
    39e0:	f3 0f 1e fb          	endbr32 
    39e4:	55                   	push   %ebp
    39e5:	89 e5                	mov    %esp,%ebp
    39e7:	57                   	push   %edi
    39e8:	56                   	push   %esi
  for(nfiles = 0; ; nfiles++){
    39e9:	31 f6                	xor    %esi,%esi
{
    39eb:	53                   	push   %ebx
    39ec:	83 ec 54             	sub    $0x54,%esp
  printf(1, "fsfull test\n");
    39ef:	68 9b 53 00 00       	push   $0x539b
    39f4:	6a 01                	push   $0x1
    39f6:	e8 d5 06 00 00       	call   40d0 <printf>
    39fb:	83 c4 10             	add    $0x10,%esp
    39fe:	66 90                	xchg   %ax,%ax
    name[1] = '0' + nfiles / 1000;
    3a00:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
    name[3] = '0' + (nfiles % 100) / 10;
    3a05:	b9 cd cc cc cc       	mov    $0xcccccccd,%ecx
    printf(1, "writing %s\n", name);
    3a0a:	83 ec 04             	sub    $0x4,%esp
    name[0] = 'f';
    3a0d:	c6 45 a8 66          	movb   $0x66,-0x58(%ebp)
    name[1] = '0' + nfiles / 1000;
    3a11:	f7 e6                	mul    %esi
    name[5] = '\0';
    3a13:	c6 45 ad 00          	movb   $0x0,-0x53(%ebp)
    name[1] = '0' + nfiles / 1000;
    3a17:	c1 ea 06             	shr    $0x6,%edx
    3a1a:	8d 42 30             	lea    0x30(%edx),%eax
    name[2] = '0' + (nfiles % 1000) / 100;
    3a1d:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
    name[1] = '0' + nfiles / 1000;
    3a23:	88 45 a9             	mov    %al,-0x57(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    3a26:	89 f0                	mov    %esi,%eax
    3a28:	29 d0                	sub    %edx,%eax
    3a2a:	89 c2                	mov    %eax,%edx
    3a2c:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    3a31:	f7 e2                	mul    %edx
    name[3] = '0' + (nfiles % 100) / 10;
    3a33:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    name[2] = '0' + (nfiles % 1000) / 100;
    3a38:	c1 ea 05             	shr    $0x5,%edx
    3a3b:	83 c2 30             	add    $0x30,%edx
    3a3e:	88 55 aa             	mov    %dl,-0x56(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    3a41:	f7 e6                	mul    %esi
    3a43:	89 f0                	mov    %esi,%eax
    3a45:	c1 ea 05             	shr    $0x5,%edx
    3a48:	6b d2 64             	imul   $0x64,%edx,%edx
    3a4b:	29 d0                	sub    %edx,%eax
    3a4d:	f7 e1                	mul    %ecx
    name[4] = '0' + (nfiles % 10);
    3a4f:	89 f0                	mov    %esi,%eax
    name[3] = '0' + (nfiles % 100) / 10;
    3a51:	c1 ea 03             	shr    $0x3,%edx
    3a54:	83 c2 30             	add    $0x30,%edx
    3a57:	88 55 ab             	mov    %dl,-0x55(%ebp)
    name[4] = '0' + (nfiles % 10);
    3a5a:	f7 e1                	mul    %ecx
    3a5c:	89 f1                	mov    %esi,%ecx
    3a5e:	c1 ea 03             	shr    $0x3,%edx
    3a61:	8d 04 92             	lea    (%edx,%edx,4),%eax
    3a64:	01 c0                	add    %eax,%eax
    3a66:	29 c1                	sub    %eax,%ecx
    3a68:	89 c8                	mov    %ecx,%eax
    3a6a:	83 c0 30             	add    $0x30,%eax
    3a6d:	88 45 ac             	mov    %al,-0x54(%ebp)
    printf(1, "writing %s\n", name);
    3a70:	8d 45 a8             	lea    -0x58(%ebp),%eax
    3a73:	50                   	push   %eax
    3a74:	68 a8 53 00 00       	push   $0x53a8
    3a79:	6a 01                	push   $0x1
    3a7b:	e8 50 06 00 00       	call   40d0 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    3a80:	58                   	pop    %eax
    3a81:	8d 45 a8             	lea    -0x58(%ebp),%eax
    3a84:	5a                   	pop    %edx
    3a85:	68 02 02 00 00       	push   $0x202
    3a8a:	50                   	push   %eax
    3a8b:	e8 03 05 00 00       	call   3f93 <open>
    if(fd < 0){
    3a90:	83 c4 10             	add    $0x10,%esp
    int fd = open(name, O_CREATE|O_RDWR);
    3a93:	89 c7                	mov    %eax,%edi
    if(fd < 0){
    3a95:	85 c0                	test   %eax,%eax
    3a97:	78 4d                	js     3ae6 <fsfull+0x106>
    int total = 0;
    3a99:	31 db                	xor    %ebx,%ebx
    3a9b:	eb 05                	jmp    3aa2 <fsfull+0xc2>
    3a9d:	8d 76 00             	lea    0x0(%esi),%esi
      total += cc;
    3aa0:	01 c3                	add    %eax,%ebx
      int cc = write(fd, buf, 512);
    3aa2:	83 ec 04             	sub    $0x4,%esp
    3aa5:	68 00 02 00 00       	push   $0x200
    3aaa:	68 c0 8c 00 00       	push   $0x8cc0
    3aaf:	57                   	push   %edi
    3ab0:	e8 be 04 00 00       	call   3f73 <write>
      if(cc < 512)
    3ab5:	83 c4 10             	add    $0x10,%esp
    3ab8:	3d ff 01 00 00       	cmp    $0x1ff,%eax
    3abd:	7f e1                	jg     3aa0 <fsfull+0xc0>
    printf(1, "wrote %d bytes\n", total);
    3abf:	83 ec 04             	sub    $0x4,%esp
    3ac2:	53                   	push   %ebx
    3ac3:	68 c4 53 00 00       	push   $0x53c4
    3ac8:	6a 01                	push   $0x1
    3aca:	e8 01 06 00 00       	call   40d0 <printf>
    close(fd);
    3acf:	89 3c 24             	mov    %edi,(%esp)
    3ad2:	e8 a4 04 00 00       	call   3f7b <close>
    if(total == 0)
    3ad7:	83 c4 10             	add    $0x10,%esp
    3ada:	85 db                	test   %ebx,%ebx
    3adc:	74 1e                	je     3afc <fsfull+0x11c>
  for(nfiles = 0; ; nfiles++){
    3ade:	83 c6 01             	add    $0x1,%esi
    3ae1:	e9 1a ff ff ff       	jmp    3a00 <fsfull+0x20>
      printf(1, "open %s failed\n", name);
    3ae6:	83 ec 04             	sub    $0x4,%esp
    3ae9:	8d 45 a8             	lea    -0x58(%ebp),%eax
    3aec:	50                   	push   %eax
    3aed:	68 b4 53 00 00       	push   $0x53b4
    3af2:	6a 01                	push   $0x1
    3af4:	e8 d7 05 00 00       	call   40d0 <printf>
      break;
    3af9:	83 c4 10             	add    $0x10,%esp
    name[1] = '0' + nfiles / 1000;
    3afc:	bf d3 4d 62 10       	mov    $0x10624dd3,%edi
    name[2] = '0' + (nfiles % 1000) / 100;
    3b01:	bb 1f 85 eb 51       	mov    $0x51eb851f,%ebx
    3b06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3b0d:	8d 76 00             	lea    0x0(%esi),%esi
    name[1] = '0' + nfiles / 1000;
    3b10:	89 f0                	mov    %esi,%eax
    3b12:	89 f1                	mov    %esi,%ecx
    unlink(name);
    3b14:	83 ec 0c             	sub    $0xc,%esp
    name[0] = 'f';
    3b17:	c6 45 a8 66          	movb   $0x66,-0x58(%ebp)
    name[1] = '0' + nfiles / 1000;
    3b1b:	f7 ef                	imul   %edi
    3b1d:	c1 f9 1f             	sar    $0x1f,%ecx
    name[5] = '\0';
    3b20:	c6 45 ad 00          	movb   $0x0,-0x53(%ebp)
    name[1] = '0' + nfiles / 1000;
    3b24:	c1 fa 06             	sar    $0x6,%edx
    3b27:	29 ca                	sub    %ecx,%edx
    3b29:	8d 42 30             	lea    0x30(%edx),%eax
    name[2] = '0' + (nfiles % 1000) / 100;
    3b2c:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
    name[1] = '0' + nfiles / 1000;
    3b32:	88 45 a9             	mov    %al,-0x57(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    3b35:	89 f0                	mov    %esi,%eax
    3b37:	29 d0                	sub    %edx,%eax
    3b39:	f7 e3                	mul    %ebx
    name[3] = '0' + (nfiles % 100) / 10;
    3b3b:	89 f0                	mov    %esi,%eax
    name[2] = '0' + (nfiles % 1000) / 100;
    3b3d:	c1 ea 05             	shr    $0x5,%edx
    3b40:	83 c2 30             	add    $0x30,%edx
    3b43:	88 55 aa             	mov    %dl,-0x56(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    3b46:	f7 eb                	imul   %ebx
    3b48:	89 f0                	mov    %esi,%eax
    3b4a:	c1 fa 05             	sar    $0x5,%edx
    3b4d:	29 ca                	sub    %ecx,%edx
    3b4f:	6b d2 64             	imul   $0x64,%edx,%edx
    3b52:	29 d0                	sub    %edx,%eax
    3b54:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
    3b59:	f7 e2                	mul    %edx
    name[4] = '0' + (nfiles % 10);
    3b5b:	89 f0                	mov    %esi,%eax
    name[3] = '0' + (nfiles % 100) / 10;
    3b5d:	c1 ea 03             	shr    $0x3,%edx
    3b60:	83 c2 30             	add    $0x30,%edx
    3b63:	88 55 ab             	mov    %dl,-0x55(%ebp)
    name[4] = '0' + (nfiles % 10);
    3b66:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3b6b:	f7 ea                	imul   %edx
    3b6d:	c1 fa 02             	sar    $0x2,%edx
    3b70:	29 ca                	sub    %ecx,%edx
    3b72:	89 f1                	mov    %esi,%ecx
    nfiles--;
    3b74:	83 ee 01             	sub    $0x1,%esi
    name[4] = '0' + (nfiles % 10);
    3b77:	8d 04 92             	lea    (%edx,%edx,4),%eax
    3b7a:	01 c0                	add    %eax,%eax
    3b7c:	29 c1                	sub    %eax,%ecx
    3b7e:	89 c8                	mov    %ecx,%eax
    3b80:	83 c0 30             	add    $0x30,%eax
    3b83:	88 45 ac             	mov    %al,-0x54(%ebp)
    unlink(name);
    3b86:	8d 45 a8             	lea    -0x58(%ebp),%eax
    3b89:	50                   	push   %eax
    3b8a:	e8 14 04 00 00       	call   3fa3 <unlink>
  while(nfiles >= 0){
    3b8f:	83 c4 10             	add    $0x10,%esp
    3b92:	83 fe ff             	cmp    $0xffffffff,%esi
    3b95:	0f 85 75 ff ff ff    	jne    3b10 <fsfull+0x130>
  printf(1, "fsfull test finished\n");
    3b9b:	83 ec 08             	sub    $0x8,%esp
    3b9e:	68 d4 53 00 00       	push   $0x53d4
    3ba3:	6a 01                	push   $0x1
    3ba5:	e8 26 05 00 00       	call   40d0 <printf>
}
    3baa:	83 c4 10             	add    $0x10,%esp
    3bad:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3bb0:	5b                   	pop    %ebx
    3bb1:	5e                   	pop    %esi
    3bb2:	5f                   	pop    %edi
    3bb3:	5d                   	pop    %ebp
    3bb4:	c3                   	ret    
    3bb5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00003bc0 <uio>:
{
    3bc0:	f3 0f 1e fb          	endbr32 
    3bc4:	55                   	push   %ebp
    3bc5:	89 e5                	mov    %esp,%ebp
    3bc7:	83 ec 10             	sub    $0x10,%esp
  printf(1, "uio test\n");
    3bca:	68 ea 53 00 00       	push   $0x53ea
    3bcf:	6a 01                	push   $0x1
    3bd1:	e8 fa 04 00 00       	call   40d0 <printf>
  pid = fork();
    3bd6:	e8 70 03 00 00       	call   3f4b <fork>
  if(pid == 0){
    3bdb:	83 c4 10             	add    $0x10,%esp
    3bde:	85 c0                	test   %eax,%eax
    3be0:	74 1f                	je     3c01 <uio+0x41>
  } else if(pid < 0){
    3be2:	78 48                	js     3c2c <uio+0x6c>
  wait(null);
    3be4:	83 ec 0c             	sub    $0xc,%esp
    3be7:	6a 00                	push   $0x0
    3be9:	e8 6d 03 00 00       	call   3f5b <wait>
  printf(1, "uio test done\n");
    3bee:	58                   	pop    %eax
    3bef:	5a                   	pop    %edx
    3bf0:	68 f4 53 00 00       	push   $0x53f4
    3bf5:	6a 01                	push   $0x1
    3bf7:	e8 d4 04 00 00       	call   40d0 <printf>
}
    3bfc:	83 c4 10             	add    $0x10,%esp
    3bff:	c9                   	leave  
    3c00:	c3                   	ret    
    asm volatile("outb %0,%1"::"a"(val), "d" (port));
    3c01:	b8 09 00 00 00       	mov    $0x9,%eax
    3c06:	ba 70 00 00 00       	mov    $0x70,%edx
    3c0b:	ee                   	out    %al,(%dx)
    asm volatile("inb %1,%0" : "=a" (val) : "d" (port));
    3c0c:	ba 71 00 00 00       	mov    $0x71,%edx
    3c11:	ec                   	in     (%dx),%al
    printf(1, "uio: uio succeeded; test FAILED\n");
    3c12:	50                   	push   %eax
    3c13:	50                   	push   %eax
    3c14:	68 80 5b 00 00       	push   $0x5b80
    3c19:	6a 01                	push   $0x1
    3c1b:	e8 b0 04 00 00       	call   40d0 <printf>
    exit(1);
    3c20:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3c27:	e8 27 03 00 00       	call   3f53 <exit>
    printf (1, "fork failed\n");
    3c2c:	51                   	push   %ecx
    3c2d:	51                   	push   %ecx
    3c2e:	68 79 53 00 00       	push   $0x5379
    3c33:	6a 01                	push   $0x1
    3c35:	e8 96 04 00 00       	call   40d0 <printf>
    exit(1);
    3c3a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3c41:	e8 0d 03 00 00       	call   3f53 <exit>
    3c46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3c4d:	8d 76 00             	lea    0x0(%esi),%esi

00003c50 <argptest>:
{
    3c50:	f3 0f 1e fb          	endbr32 
    3c54:	55                   	push   %ebp
    3c55:	89 e5                	mov    %esp,%ebp
    3c57:	53                   	push   %ebx
    3c58:	83 ec 0c             	sub    $0xc,%esp
  fd = open("init", O_RDONLY);
    3c5b:	6a 00                	push   $0x0
    3c5d:	68 03 54 00 00       	push   $0x5403
    3c62:	e8 2c 03 00 00       	call   3f93 <open>
  if (fd < 0) {
    3c67:	83 c4 10             	add    $0x10,%esp
    3c6a:	85 c0                	test   %eax,%eax
    3c6c:	78 39                	js     3ca7 <argptest+0x57>
  read(fd, sbrk(0) - 1, -1);
    3c6e:	83 ec 0c             	sub    $0xc,%esp
    3c71:	89 c3                	mov    %eax,%ebx
    3c73:	6a 00                	push   $0x0
    3c75:	e8 61 03 00 00       	call   3fdb <sbrk>
    3c7a:	83 c4 0c             	add    $0xc,%esp
    3c7d:	83 e8 01             	sub    $0x1,%eax
    3c80:	6a ff                	push   $0xffffffff
    3c82:	50                   	push   %eax
    3c83:	53                   	push   %ebx
    3c84:	e8 e2 02 00 00       	call   3f6b <read>
  close(fd);
    3c89:	89 1c 24             	mov    %ebx,(%esp)
    3c8c:	e8 ea 02 00 00       	call   3f7b <close>
  printf(1, "arg test passed\n");
    3c91:	58                   	pop    %eax
    3c92:	5a                   	pop    %edx
    3c93:	68 15 54 00 00       	push   $0x5415
    3c98:	6a 01                	push   $0x1
    3c9a:	e8 31 04 00 00       	call   40d0 <printf>
}
    3c9f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    3ca2:	83 c4 10             	add    $0x10,%esp
    3ca5:	c9                   	leave  
    3ca6:	c3                   	ret    
    printf(2, "open failed\n");
    3ca7:	51                   	push   %ecx
    3ca8:	51                   	push   %ecx
    3ca9:	68 08 54 00 00       	push   $0x5408
    3cae:	6a 02                	push   $0x2
    3cb0:	e8 1b 04 00 00       	call   40d0 <printf>
    exit(1);
    3cb5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3cbc:	e8 92 02 00 00       	call   3f53 <exit>
    3cc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3cc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3ccf:	90                   	nop

00003cd0 <rand>:
{
    3cd0:	f3 0f 1e fb          	endbr32 
  randstate = randstate * 1664525 + 1013904223;
    3cd4:	69 05 cc 64 00 00 0d 	imul   $0x19660d,0x64cc,%eax
    3cdb:	66 19 00 
    3cde:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
    3ce3:	a3 cc 64 00 00       	mov    %eax,0x64cc
}
    3ce8:	c3                   	ret    
    3ce9:	66 90                	xchg   %ax,%ax
    3ceb:	66 90                	xchg   %ax,%ax
    3ced:	66 90                	xchg   %ax,%ax
    3cef:	90                   	nop

00003cf0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    3cf0:	f3 0f 1e fb          	endbr32 
    3cf4:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    3cf5:	31 c0                	xor    %eax,%eax
{
    3cf7:	89 e5                	mov    %esp,%ebp
    3cf9:	53                   	push   %ebx
    3cfa:	8b 4d 08             	mov    0x8(%ebp),%ecx
    3cfd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
    3d00:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
    3d04:	88 14 01             	mov    %dl,(%ecx,%eax,1)
    3d07:	83 c0 01             	add    $0x1,%eax
    3d0a:	84 d2                	test   %dl,%dl
    3d0c:	75 f2                	jne    3d00 <strcpy+0x10>
    ;
  return os;
}
    3d0e:	89 c8                	mov    %ecx,%eax
    3d10:	5b                   	pop    %ebx
    3d11:	5d                   	pop    %ebp
    3d12:	c3                   	ret    
    3d13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00003d20 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    3d20:	f3 0f 1e fb          	endbr32 
    3d24:	55                   	push   %ebp
    3d25:	89 e5                	mov    %esp,%ebp
    3d27:	53                   	push   %ebx
    3d28:	8b 4d 08             	mov    0x8(%ebp),%ecx
    3d2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
    3d2e:	0f b6 01             	movzbl (%ecx),%eax
    3d31:	0f b6 1a             	movzbl (%edx),%ebx
    3d34:	84 c0                	test   %al,%al
    3d36:	75 19                	jne    3d51 <strcmp+0x31>
    3d38:	eb 26                	jmp    3d60 <strcmp+0x40>
    3d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    3d40:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
    3d44:	83 c1 01             	add    $0x1,%ecx
    3d47:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
    3d4a:	0f b6 1a             	movzbl (%edx),%ebx
    3d4d:	84 c0                	test   %al,%al
    3d4f:	74 0f                	je     3d60 <strcmp+0x40>
    3d51:	38 d8                	cmp    %bl,%al
    3d53:	74 eb                	je     3d40 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
    3d55:	29 d8                	sub    %ebx,%eax
}
    3d57:	5b                   	pop    %ebx
    3d58:	5d                   	pop    %ebp
    3d59:	c3                   	ret    
    3d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    3d60:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
    3d62:	29 d8                	sub    %ebx,%eax
}
    3d64:	5b                   	pop    %ebx
    3d65:	5d                   	pop    %ebp
    3d66:	c3                   	ret    
    3d67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3d6e:	66 90                	xchg   %ax,%ax

00003d70 <strlen>:

uint
strlen(const char *s)
{
    3d70:	f3 0f 1e fb          	endbr32 
    3d74:	55                   	push   %ebp
    3d75:	89 e5                	mov    %esp,%ebp
    3d77:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
    3d7a:	80 3a 00             	cmpb   $0x0,(%edx)
    3d7d:	74 21                	je     3da0 <strlen+0x30>
    3d7f:	31 c0                	xor    %eax,%eax
    3d81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3d88:	83 c0 01             	add    $0x1,%eax
    3d8b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
    3d8f:	89 c1                	mov    %eax,%ecx
    3d91:	75 f5                	jne    3d88 <strlen+0x18>
    ;
  return n;
}
    3d93:	89 c8                	mov    %ecx,%eax
    3d95:	5d                   	pop    %ebp
    3d96:	c3                   	ret    
    3d97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3d9e:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
    3da0:	31 c9                	xor    %ecx,%ecx
}
    3da2:	5d                   	pop    %ebp
    3da3:	89 c8                	mov    %ecx,%eax
    3da5:	c3                   	ret    
    3da6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3dad:	8d 76 00             	lea    0x0(%esi),%esi

00003db0 <memset>:

void*
memset(void *dst, int c, uint n)
{
    3db0:	f3 0f 1e fb          	endbr32 
    3db4:	55                   	push   %ebp
    3db5:	89 e5                	mov    %esp,%ebp
    3db7:	57                   	push   %edi
    3db8:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    3dbb:	8b 4d 10             	mov    0x10(%ebp),%ecx
    3dbe:	8b 45 0c             	mov    0xc(%ebp),%eax
    3dc1:	89 d7                	mov    %edx,%edi
    3dc3:	fc                   	cld    
    3dc4:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    3dc6:	89 d0                	mov    %edx,%eax
    3dc8:	5f                   	pop    %edi
    3dc9:	5d                   	pop    %ebp
    3dca:	c3                   	ret    
    3dcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    3dcf:	90                   	nop

00003dd0 <strchr>:

char*
strchr(const char *s, char c)
{
    3dd0:	f3 0f 1e fb          	endbr32 
    3dd4:	55                   	push   %ebp
    3dd5:	89 e5                	mov    %esp,%ebp
    3dd7:	8b 45 08             	mov    0x8(%ebp),%eax
    3dda:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
    3dde:	0f b6 10             	movzbl (%eax),%edx
    3de1:	84 d2                	test   %dl,%dl
    3de3:	75 16                	jne    3dfb <strchr+0x2b>
    3de5:	eb 21                	jmp    3e08 <strchr+0x38>
    3de7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3dee:	66 90                	xchg   %ax,%ax
    3df0:	0f b6 50 01          	movzbl 0x1(%eax),%edx
    3df4:	83 c0 01             	add    $0x1,%eax
    3df7:	84 d2                	test   %dl,%dl
    3df9:	74 0d                	je     3e08 <strchr+0x38>
    if(*s == c)
    3dfb:	38 d1                	cmp    %dl,%cl
    3dfd:	75 f1                	jne    3df0 <strchr+0x20>
      return (char*)s;
  return 0;
}
    3dff:	5d                   	pop    %ebp
    3e00:	c3                   	ret    
    3e01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
    3e08:	31 c0                	xor    %eax,%eax
}
    3e0a:	5d                   	pop    %ebp
    3e0b:	c3                   	ret    
    3e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00003e10 <gets>:

char*
gets(char *buf, int max)
{
    3e10:	f3 0f 1e fb          	endbr32 
    3e14:	55                   	push   %ebp
    3e15:	89 e5                	mov    %esp,%ebp
    3e17:	57                   	push   %edi
    3e18:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    3e19:	31 f6                	xor    %esi,%esi
{
    3e1b:	53                   	push   %ebx
    3e1c:	89 f3                	mov    %esi,%ebx
    3e1e:	83 ec 1c             	sub    $0x1c,%esp
    3e21:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
    3e24:	eb 33                	jmp    3e59 <gets+0x49>
    3e26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3e2d:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
    3e30:	83 ec 04             	sub    $0x4,%esp
    3e33:	8d 45 e7             	lea    -0x19(%ebp),%eax
    3e36:	6a 01                	push   $0x1
    3e38:	50                   	push   %eax
    3e39:	6a 00                	push   $0x0
    3e3b:	e8 2b 01 00 00       	call   3f6b <read>
    if(cc < 1)
    3e40:	83 c4 10             	add    $0x10,%esp
    3e43:	85 c0                	test   %eax,%eax
    3e45:	7e 1c                	jle    3e63 <gets+0x53>
      break;
    buf[i++] = c;
    3e47:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    3e4b:	83 c7 01             	add    $0x1,%edi
    3e4e:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
    3e51:	3c 0a                	cmp    $0xa,%al
    3e53:	74 23                	je     3e78 <gets+0x68>
    3e55:	3c 0d                	cmp    $0xd,%al
    3e57:	74 1f                	je     3e78 <gets+0x68>
  for(i=0; i+1 < max; ){
    3e59:	83 c3 01             	add    $0x1,%ebx
    3e5c:	89 fe                	mov    %edi,%esi
    3e5e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    3e61:	7c cd                	jl     3e30 <gets+0x20>
    3e63:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
    3e65:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
    3e68:	c6 03 00             	movb   $0x0,(%ebx)
}
    3e6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3e6e:	5b                   	pop    %ebx
    3e6f:	5e                   	pop    %esi
    3e70:	5f                   	pop    %edi
    3e71:	5d                   	pop    %ebp
    3e72:	c3                   	ret    
    3e73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    3e77:	90                   	nop
    3e78:	8b 75 08             	mov    0x8(%ebp),%esi
    3e7b:	8b 45 08             	mov    0x8(%ebp),%eax
    3e7e:	01 de                	add    %ebx,%esi
    3e80:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
    3e82:	c6 03 00             	movb   $0x0,(%ebx)
}
    3e85:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3e88:	5b                   	pop    %ebx
    3e89:	5e                   	pop    %esi
    3e8a:	5f                   	pop    %edi
    3e8b:	5d                   	pop    %ebp
    3e8c:	c3                   	ret    
    3e8d:	8d 76 00             	lea    0x0(%esi),%esi

00003e90 <stat>:

int
stat(const char *n, struct stat *st)
{
    3e90:	f3 0f 1e fb          	endbr32 
    3e94:	55                   	push   %ebp
    3e95:	89 e5                	mov    %esp,%ebp
    3e97:	56                   	push   %esi
    3e98:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    3e99:	83 ec 08             	sub    $0x8,%esp
    3e9c:	6a 00                	push   $0x0
    3e9e:	ff 75 08             	pushl  0x8(%ebp)
    3ea1:	e8 ed 00 00 00       	call   3f93 <open>
  if(fd < 0)
    3ea6:	83 c4 10             	add    $0x10,%esp
    3ea9:	85 c0                	test   %eax,%eax
    3eab:	78 2b                	js     3ed8 <stat+0x48>
    return -1;
  r = fstat(fd, st);
    3ead:	83 ec 08             	sub    $0x8,%esp
    3eb0:	ff 75 0c             	pushl  0xc(%ebp)
    3eb3:	89 c3                	mov    %eax,%ebx
    3eb5:	50                   	push   %eax
    3eb6:	e8 f0 00 00 00       	call   3fab <fstat>
  close(fd);
    3ebb:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
    3ebe:	89 c6                	mov    %eax,%esi
  close(fd);
    3ec0:	e8 b6 00 00 00       	call   3f7b <close>
  return r;
    3ec5:	83 c4 10             	add    $0x10,%esp
}
    3ec8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    3ecb:	89 f0                	mov    %esi,%eax
    3ecd:	5b                   	pop    %ebx
    3ece:	5e                   	pop    %esi
    3ecf:	5d                   	pop    %ebp
    3ed0:	c3                   	ret    
    3ed1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
    3ed8:	be ff ff ff ff       	mov    $0xffffffff,%esi
    3edd:	eb e9                	jmp    3ec8 <stat+0x38>
    3edf:	90                   	nop

00003ee0 <atoi>:

int
atoi(const char *s)
{
    3ee0:	f3 0f 1e fb          	endbr32 
    3ee4:	55                   	push   %ebp
    3ee5:	89 e5                	mov    %esp,%ebp
    3ee7:	53                   	push   %ebx
    3ee8:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    3eeb:	0f be 02             	movsbl (%edx),%eax
    3eee:	8d 48 d0             	lea    -0x30(%eax),%ecx
    3ef1:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
    3ef4:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
    3ef9:	77 1a                	ja     3f15 <atoi+0x35>
    3efb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    3eff:	90                   	nop
    n = n*10 + *s++ - '0';
    3f00:	83 c2 01             	add    $0x1,%edx
    3f03:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
    3f06:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
    3f0a:	0f be 02             	movsbl (%edx),%eax
    3f0d:	8d 58 d0             	lea    -0x30(%eax),%ebx
    3f10:	80 fb 09             	cmp    $0x9,%bl
    3f13:	76 eb                	jbe    3f00 <atoi+0x20>
  return n;
}
    3f15:	89 c8                	mov    %ecx,%eax
    3f17:	5b                   	pop    %ebx
    3f18:	5d                   	pop    %ebp
    3f19:	c3                   	ret    
    3f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00003f20 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    3f20:	f3 0f 1e fb          	endbr32 
    3f24:	55                   	push   %ebp
    3f25:	89 e5                	mov    %esp,%ebp
    3f27:	57                   	push   %edi
    3f28:	8b 45 10             	mov    0x10(%ebp),%eax
    3f2b:	8b 55 08             	mov    0x8(%ebp),%edx
    3f2e:	56                   	push   %esi
    3f2f:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    3f32:	85 c0                	test   %eax,%eax
    3f34:	7e 0f                	jle    3f45 <memmove+0x25>
    3f36:	01 d0                	add    %edx,%eax
  dst = vdst;
    3f38:	89 d7                	mov    %edx,%edi
    3f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
    3f40:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
    3f41:	39 f8                	cmp    %edi,%eax
    3f43:	75 fb                	jne    3f40 <memmove+0x20>
  return vdst;
}
    3f45:	5e                   	pop    %esi
    3f46:	89 d0                	mov    %edx,%eax
    3f48:	5f                   	pop    %edi
    3f49:	5d                   	pop    %ebp
    3f4a:	c3                   	ret    

00003f4b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    3f4b:	b8 01 00 00 00       	mov    $0x1,%eax
    3f50:	cd 40                	int    $0x40
    3f52:	c3                   	ret    

00003f53 <exit>:
SYSCALL(exit)
    3f53:	b8 02 00 00 00       	mov    $0x2,%eax
    3f58:	cd 40                	int    $0x40
    3f5a:	c3                   	ret    

00003f5b <wait>:
SYSCALL(wait)
    3f5b:	b8 03 00 00 00       	mov    $0x3,%eax
    3f60:	cd 40                	int    $0x40
    3f62:	c3                   	ret    

00003f63 <pipe>:
SYSCALL(pipe)
    3f63:	b8 04 00 00 00       	mov    $0x4,%eax
    3f68:	cd 40                	int    $0x40
    3f6a:	c3                   	ret    

00003f6b <read>:
SYSCALL(read)
    3f6b:	b8 05 00 00 00       	mov    $0x5,%eax
    3f70:	cd 40                	int    $0x40
    3f72:	c3                   	ret    

00003f73 <write>:
SYSCALL(write)
    3f73:	b8 10 00 00 00       	mov    $0x10,%eax
    3f78:	cd 40                	int    $0x40
    3f7a:	c3                   	ret    

00003f7b <close>:
SYSCALL(close)
    3f7b:	b8 15 00 00 00       	mov    $0x15,%eax
    3f80:	cd 40                	int    $0x40
    3f82:	c3                   	ret    

00003f83 <kill>:
SYSCALL(kill)
    3f83:	b8 06 00 00 00       	mov    $0x6,%eax
    3f88:	cd 40                	int    $0x40
    3f8a:	c3                   	ret    

00003f8b <exec>:
SYSCALL(exec)
    3f8b:	b8 07 00 00 00       	mov    $0x7,%eax
    3f90:	cd 40                	int    $0x40
    3f92:	c3                   	ret    

00003f93 <open>:
SYSCALL(open)
    3f93:	b8 0f 00 00 00       	mov    $0xf,%eax
    3f98:	cd 40                	int    $0x40
    3f9a:	c3                   	ret    

00003f9b <mknod>:
SYSCALL(mknod)
    3f9b:	b8 11 00 00 00       	mov    $0x11,%eax
    3fa0:	cd 40                	int    $0x40
    3fa2:	c3                   	ret    

00003fa3 <unlink>:
SYSCALL(unlink)
    3fa3:	b8 12 00 00 00       	mov    $0x12,%eax
    3fa8:	cd 40                	int    $0x40
    3faa:	c3                   	ret    

00003fab <fstat>:
SYSCALL(fstat)
    3fab:	b8 08 00 00 00       	mov    $0x8,%eax
    3fb0:	cd 40                	int    $0x40
    3fb2:	c3                   	ret    

00003fb3 <link>:
SYSCALL(link)
    3fb3:	b8 13 00 00 00       	mov    $0x13,%eax
    3fb8:	cd 40                	int    $0x40
    3fba:	c3                   	ret    

00003fbb <mkdir>:
SYSCALL(mkdir)
    3fbb:	b8 14 00 00 00       	mov    $0x14,%eax
    3fc0:	cd 40                	int    $0x40
    3fc2:	c3                   	ret    

00003fc3 <chdir>:
SYSCALL(chdir)
    3fc3:	b8 09 00 00 00       	mov    $0x9,%eax
    3fc8:	cd 40                	int    $0x40
    3fca:	c3                   	ret    

00003fcb <dup>:
SYSCALL(dup)
    3fcb:	b8 0a 00 00 00       	mov    $0xa,%eax
    3fd0:	cd 40                	int    $0x40
    3fd2:	c3                   	ret    

00003fd3 <getpid>:
SYSCALL(getpid)
    3fd3:	b8 0b 00 00 00       	mov    $0xb,%eax
    3fd8:	cd 40                	int    $0x40
    3fda:	c3                   	ret    

00003fdb <sbrk>:
SYSCALL(sbrk)
    3fdb:	b8 0c 00 00 00       	mov    $0xc,%eax
    3fe0:	cd 40                	int    $0x40
    3fe2:	c3                   	ret    

00003fe3 <sleep>:
SYSCALL(sleep)
    3fe3:	b8 0d 00 00 00       	mov    $0xd,%eax
    3fe8:	cd 40                	int    $0x40
    3fea:	c3                   	ret    

00003feb <uptime>:
SYSCALL(uptime)
    3feb:	b8 0e 00 00 00       	mov    $0xe,%eax
    3ff0:	cd 40                	int    $0x40
    3ff2:	c3                   	ret    

00003ff3 <memsize>:
SYSCALL(memsize)
    3ff3:	b8 16 00 00 00       	mov    $0x16,%eax
    3ff8:	cd 40                	int    $0x40
    3ffa:	c3                   	ret    

00003ffb <set_ps_priority>:
SYSCALL(set_ps_priority)
    3ffb:	b8 17 00 00 00       	mov    $0x17,%eax
    4000:	cd 40                	int    $0x40
    4002:	c3                   	ret    

00004003 <policy>:
SYSCALL(policy)
    4003:	b8 18 00 00 00       	mov    $0x18,%eax
    4008:	cd 40                	int    $0x40
    400a:	c3                   	ret    

0000400b <set_cfs_priority>:
SYSCALL(set_cfs_priority)
    400b:	b8 19 00 00 00       	mov    $0x19,%eax
    4010:	cd 40                	int    $0x40
    4012:	c3                   	ret    

00004013 <proc_info>:
SYSCALL(proc_info)
    4013:	b8 1a 00 00 00       	mov    $0x1a,%eax
    4018:	cd 40                	int    $0x40
    401a:	c3                   	ret    
    401b:	66 90                	xchg   %ax,%ax
    401d:	66 90                	xchg   %ax,%ax
    401f:	90                   	nop

00004020 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    4020:	55                   	push   %ebp
    4021:	89 e5                	mov    %esp,%ebp
    4023:	57                   	push   %edi
    4024:	56                   	push   %esi
    4025:	53                   	push   %ebx
    4026:	83 ec 3c             	sub    $0x3c,%esp
    4029:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
    402c:	89 d1                	mov    %edx,%ecx
{
    402e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
    4031:	85 d2                	test   %edx,%edx
    4033:	0f 89 7f 00 00 00    	jns    40b8 <printint+0x98>
    4039:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
    403d:	74 79                	je     40b8 <printint+0x98>
    neg = 1;
    403f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
    4046:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
    4048:	31 db                	xor    %ebx,%ebx
    404a:	8d 75 d7             	lea    -0x29(%ebp),%esi
    404d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
    4050:	89 c8                	mov    %ecx,%eax
    4052:	31 d2                	xor    %edx,%edx
    4054:	89 cf                	mov    %ecx,%edi
    4056:	f7 75 c4             	divl   -0x3c(%ebp)
    4059:	0f b6 92 d8 5b 00 00 	movzbl 0x5bd8(%edx),%edx
    4060:	89 45 c0             	mov    %eax,-0x40(%ebp)
    4063:	89 d8                	mov    %ebx,%eax
    4065:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
    4068:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
    406b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
    406e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
    4071:	76 dd                	jbe    4050 <printint+0x30>
  if(neg)
    4073:	8b 4d bc             	mov    -0x44(%ebp),%ecx
    4076:	85 c9                	test   %ecx,%ecx
    4078:	74 0c                	je     4086 <printint+0x66>
    buf[i++] = '-';
    407a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
    407f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
    4081:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
    4086:	8b 7d b8             	mov    -0x48(%ebp),%edi
    4089:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
    408d:	eb 07                	jmp    4096 <printint+0x76>
    408f:	90                   	nop
    4090:	0f b6 13             	movzbl (%ebx),%edx
    4093:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
    4096:	83 ec 04             	sub    $0x4,%esp
    4099:	88 55 d7             	mov    %dl,-0x29(%ebp)
    409c:	6a 01                	push   $0x1
    409e:	56                   	push   %esi
    409f:	57                   	push   %edi
    40a0:	e8 ce fe ff ff       	call   3f73 <write>
  while(--i >= 0)
    40a5:	83 c4 10             	add    $0x10,%esp
    40a8:	39 de                	cmp    %ebx,%esi
    40aa:	75 e4                	jne    4090 <printint+0x70>
    putc(fd, buf[i]);
}
    40ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
    40af:	5b                   	pop    %ebx
    40b0:	5e                   	pop    %esi
    40b1:	5f                   	pop    %edi
    40b2:	5d                   	pop    %ebp
    40b3:	c3                   	ret    
    40b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
    40b8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
    40bf:	eb 87                	jmp    4048 <printint+0x28>
    40c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    40c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    40cf:	90                   	nop

000040d0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    40d0:	f3 0f 1e fb          	endbr32 
    40d4:	55                   	push   %ebp
    40d5:	89 e5                	mov    %esp,%ebp
    40d7:	57                   	push   %edi
    40d8:	56                   	push   %esi
    40d9:	53                   	push   %ebx
    40da:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    40dd:	8b 75 0c             	mov    0xc(%ebp),%esi
    40e0:	0f b6 1e             	movzbl (%esi),%ebx
    40e3:	84 db                	test   %bl,%bl
    40e5:	0f 84 b4 00 00 00    	je     419f <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
    40eb:	8d 45 10             	lea    0x10(%ebp),%eax
    40ee:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
    40f1:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
    40f4:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
    40f6:	89 45 d0             	mov    %eax,-0x30(%ebp)
    40f9:	eb 33                	jmp    412e <printf+0x5e>
    40fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    40ff:	90                   	nop
    4100:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
    4103:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
    4108:	83 f8 25             	cmp    $0x25,%eax
    410b:	74 17                	je     4124 <printf+0x54>
  write(fd, &c, 1);
    410d:	83 ec 04             	sub    $0x4,%esp
    4110:	88 5d e7             	mov    %bl,-0x19(%ebp)
    4113:	6a 01                	push   $0x1
    4115:	57                   	push   %edi
    4116:	ff 75 08             	pushl  0x8(%ebp)
    4119:	e8 55 fe ff ff       	call   3f73 <write>
    411e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
    4121:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
    4124:	0f b6 1e             	movzbl (%esi),%ebx
    4127:	83 c6 01             	add    $0x1,%esi
    412a:	84 db                	test   %bl,%bl
    412c:	74 71                	je     419f <printf+0xcf>
    c = fmt[i] & 0xff;
    412e:	0f be cb             	movsbl %bl,%ecx
    4131:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
    4134:	85 d2                	test   %edx,%edx
    4136:	74 c8                	je     4100 <printf+0x30>
      }
    } else if(state == '%'){
    4138:	83 fa 25             	cmp    $0x25,%edx
    413b:	75 e7                	jne    4124 <printf+0x54>
      if(c == 'd'){
    413d:	83 f8 64             	cmp    $0x64,%eax
    4140:	0f 84 9a 00 00 00    	je     41e0 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    4146:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
    414c:	83 f9 70             	cmp    $0x70,%ecx
    414f:	74 5f                	je     41b0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    4151:	83 f8 73             	cmp    $0x73,%eax
    4154:	0f 84 d6 00 00 00    	je     4230 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    415a:	83 f8 63             	cmp    $0x63,%eax
    415d:	0f 84 8d 00 00 00    	je     41f0 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    4163:	83 f8 25             	cmp    $0x25,%eax
    4166:	0f 84 b4 00 00 00    	je     4220 <printf+0x150>
  write(fd, &c, 1);
    416c:	83 ec 04             	sub    $0x4,%esp
    416f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    4173:	6a 01                	push   $0x1
    4175:	57                   	push   %edi
    4176:	ff 75 08             	pushl  0x8(%ebp)
    4179:	e8 f5 fd ff ff       	call   3f73 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
    417e:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
    4181:	83 c4 0c             	add    $0xc,%esp
    4184:	6a 01                	push   $0x1
    4186:	83 c6 01             	add    $0x1,%esi
    4189:	57                   	push   %edi
    418a:	ff 75 08             	pushl  0x8(%ebp)
    418d:	e8 e1 fd ff ff       	call   3f73 <write>
  for(i = 0; fmt[i]; i++){
    4192:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
    4196:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    4199:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
    419b:	84 db                	test   %bl,%bl
    419d:	75 8f                	jne    412e <printf+0x5e>
    }
  }
}
    419f:	8d 65 f4             	lea    -0xc(%ebp),%esp
    41a2:	5b                   	pop    %ebx
    41a3:	5e                   	pop    %esi
    41a4:	5f                   	pop    %edi
    41a5:	5d                   	pop    %ebp
    41a6:	c3                   	ret    
    41a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    41ae:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
    41b0:	83 ec 0c             	sub    $0xc,%esp
    41b3:	b9 10 00 00 00       	mov    $0x10,%ecx
    41b8:	6a 00                	push   $0x0
    41ba:	8b 5d d0             	mov    -0x30(%ebp),%ebx
    41bd:	8b 45 08             	mov    0x8(%ebp),%eax
    41c0:	8b 13                	mov    (%ebx),%edx
    41c2:	e8 59 fe ff ff       	call   4020 <printint>
        ap++;
    41c7:	89 d8                	mov    %ebx,%eax
    41c9:	83 c4 10             	add    $0x10,%esp
      state = 0;
    41cc:	31 d2                	xor    %edx,%edx
        ap++;
    41ce:	83 c0 04             	add    $0x4,%eax
    41d1:	89 45 d0             	mov    %eax,-0x30(%ebp)
    41d4:	e9 4b ff ff ff       	jmp    4124 <printf+0x54>
    41d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
    41e0:	83 ec 0c             	sub    $0xc,%esp
    41e3:	b9 0a 00 00 00       	mov    $0xa,%ecx
    41e8:	6a 01                	push   $0x1
    41ea:	eb ce                	jmp    41ba <printf+0xea>
    41ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
    41f0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
    41f3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
    41f6:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
    41f8:	6a 01                	push   $0x1
        ap++;
    41fa:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
    41fd:	57                   	push   %edi
    41fe:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
    4201:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    4204:	e8 6a fd ff ff       	call   3f73 <write>
        ap++;
    4209:	89 5d d0             	mov    %ebx,-0x30(%ebp)
    420c:	83 c4 10             	add    $0x10,%esp
      state = 0;
    420f:	31 d2                	xor    %edx,%edx
    4211:	e9 0e ff ff ff       	jmp    4124 <printf+0x54>
    4216:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    421d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
    4220:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
    4223:	83 ec 04             	sub    $0x4,%esp
    4226:	e9 59 ff ff ff       	jmp    4184 <printf+0xb4>
    422b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    422f:	90                   	nop
        s = (char*)*ap;
    4230:	8b 45 d0             	mov    -0x30(%ebp),%eax
    4233:	8b 18                	mov    (%eax),%ebx
        ap++;
    4235:	83 c0 04             	add    $0x4,%eax
    4238:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
    423b:	85 db                	test   %ebx,%ebx
    423d:	74 17                	je     4256 <printf+0x186>
        while(*s != 0){
    423f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
    4242:	31 d2                	xor    %edx,%edx
        while(*s != 0){
    4244:	84 c0                	test   %al,%al
    4246:	0f 84 d8 fe ff ff    	je     4124 <printf+0x54>
    424c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    424f:	89 de                	mov    %ebx,%esi
    4251:	8b 5d 08             	mov    0x8(%ebp),%ebx
    4254:	eb 1a                	jmp    4270 <printf+0x1a0>
          s = "(null)";
    4256:	bb ce 5b 00 00       	mov    $0x5bce,%ebx
        while(*s != 0){
    425b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    425e:	b8 28 00 00 00       	mov    $0x28,%eax
    4263:	89 de                	mov    %ebx,%esi
    4265:	8b 5d 08             	mov    0x8(%ebp),%ebx
    4268:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    426f:	90                   	nop
  write(fd, &c, 1);
    4270:	83 ec 04             	sub    $0x4,%esp
          s++;
    4273:	83 c6 01             	add    $0x1,%esi
    4276:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    4279:	6a 01                	push   $0x1
    427b:	57                   	push   %edi
    427c:	53                   	push   %ebx
    427d:	e8 f1 fc ff ff       	call   3f73 <write>
        while(*s != 0){
    4282:	0f b6 06             	movzbl (%esi),%eax
    4285:	83 c4 10             	add    $0x10,%esp
    4288:	84 c0                	test   %al,%al
    428a:	75 e4                	jne    4270 <printf+0x1a0>
    428c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
    428f:	31 d2                	xor    %edx,%edx
    4291:	e9 8e fe ff ff       	jmp    4124 <printf+0x54>
    4296:	66 90                	xchg   %ax,%ax
    4298:	66 90                	xchg   %ax,%ax
    429a:	66 90                	xchg   %ax,%ax
    429c:	66 90                	xchg   %ax,%ax
    429e:	66 90                	xchg   %ax,%ax

000042a0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    42a0:	f3 0f 1e fb          	endbr32 
    42a4:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    42a5:	a1 80 65 00 00       	mov    0x6580,%eax
{
    42aa:	89 e5                	mov    %esp,%ebp
    42ac:	57                   	push   %edi
    42ad:	56                   	push   %esi
    42ae:	53                   	push   %ebx
    42af:	8b 5d 08             	mov    0x8(%ebp),%ebx
    42b2:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
    42b4:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    42b7:	39 c8                	cmp    %ecx,%eax
    42b9:	73 15                	jae    42d0 <free+0x30>
    42bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    42bf:	90                   	nop
    42c0:	39 d1                	cmp    %edx,%ecx
    42c2:	72 14                	jb     42d8 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    42c4:	39 d0                	cmp    %edx,%eax
    42c6:	73 10                	jae    42d8 <free+0x38>
{
    42c8:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    42ca:	8b 10                	mov    (%eax),%edx
    42cc:	39 c8                	cmp    %ecx,%eax
    42ce:	72 f0                	jb     42c0 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    42d0:	39 d0                	cmp    %edx,%eax
    42d2:	72 f4                	jb     42c8 <free+0x28>
    42d4:	39 d1                	cmp    %edx,%ecx
    42d6:	73 f0                	jae    42c8 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
    42d8:	8b 73 fc             	mov    -0x4(%ebx),%esi
    42db:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    42de:	39 fa                	cmp    %edi,%edx
    42e0:	74 1e                	je     4300 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    42e2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    42e5:	8b 50 04             	mov    0x4(%eax),%edx
    42e8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    42eb:	39 f1                	cmp    %esi,%ecx
    42ed:	74 28                	je     4317 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    42ef:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
    42f1:	5b                   	pop    %ebx
  freep = p;
    42f2:	a3 80 65 00 00       	mov    %eax,0x6580
}
    42f7:	5e                   	pop    %esi
    42f8:	5f                   	pop    %edi
    42f9:	5d                   	pop    %ebp
    42fa:	c3                   	ret    
    42fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    42ff:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
    4300:	03 72 04             	add    0x4(%edx),%esi
    4303:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    4306:	8b 10                	mov    (%eax),%edx
    4308:	8b 12                	mov    (%edx),%edx
    430a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    430d:	8b 50 04             	mov    0x4(%eax),%edx
    4310:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    4313:	39 f1                	cmp    %esi,%ecx
    4315:	75 d8                	jne    42ef <free+0x4f>
    p->s.size += bp->s.size;
    4317:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
    431a:	a3 80 65 00 00       	mov    %eax,0x6580
    p->s.size += bp->s.size;
    431f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    4322:	8b 53 f8             	mov    -0x8(%ebx),%edx
    4325:	89 10                	mov    %edx,(%eax)
}
    4327:	5b                   	pop    %ebx
    4328:	5e                   	pop    %esi
    4329:	5f                   	pop    %edi
    432a:	5d                   	pop    %ebp
    432b:	c3                   	ret    
    432c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00004330 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    4330:	f3 0f 1e fb          	endbr32 
    4334:	55                   	push   %ebp
    4335:	89 e5                	mov    %esp,%ebp
    4337:	57                   	push   %edi
    4338:	56                   	push   %esi
    4339:	53                   	push   %ebx
    433a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    433d:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    4340:	8b 3d 80 65 00 00    	mov    0x6580,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    4346:	8d 70 07             	lea    0x7(%eax),%esi
    4349:	c1 ee 03             	shr    $0x3,%esi
    434c:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
    434f:	85 ff                	test   %edi,%edi
    4351:	0f 84 a9 00 00 00    	je     4400 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    4357:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
    4359:	8b 48 04             	mov    0x4(%eax),%ecx
    435c:	39 f1                	cmp    %esi,%ecx
    435e:	73 6d                	jae    43cd <malloc+0x9d>
    4360:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
    4366:	bb 00 10 00 00       	mov    $0x1000,%ebx
    436b:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
    436e:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
    4375:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    4378:	eb 17                	jmp    4391 <malloc+0x61>
    437a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    4380:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
    4382:	8b 4a 04             	mov    0x4(%edx),%ecx
    4385:	39 f1                	cmp    %esi,%ecx
    4387:	73 4f                	jae    43d8 <malloc+0xa8>
    4389:	8b 3d 80 65 00 00    	mov    0x6580,%edi
    438f:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    4391:	39 c7                	cmp    %eax,%edi
    4393:	75 eb                	jne    4380 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
    4395:	83 ec 0c             	sub    $0xc,%esp
    4398:	ff 75 e4             	pushl  -0x1c(%ebp)
    439b:	e8 3b fc ff ff       	call   3fdb <sbrk>
  if(p == (char*)-1)
    43a0:	83 c4 10             	add    $0x10,%esp
    43a3:	83 f8 ff             	cmp    $0xffffffff,%eax
    43a6:	74 1b                	je     43c3 <malloc+0x93>
  hp->s.size = nu;
    43a8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    43ab:	83 ec 0c             	sub    $0xc,%esp
    43ae:	83 c0 08             	add    $0x8,%eax
    43b1:	50                   	push   %eax
    43b2:	e8 e9 fe ff ff       	call   42a0 <free>
  return freep;
    43b7:	a1 80 65 00 00       	mov    0x6580,%eax
      if((p = morecore(nunits)) == 0)
    43bc:	83 c4 10             	add    $0x10,%esp
    43bf:	85 c0                	test   %eax,%eax
    43c1:	75 bd                	jne    4380 <malloc+0x50>
        return 0;
  }
}
    43c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
    43c6:	31 c0                	xor    %eax,%eax
}
    43c8:	5b                   	pop    %ebx
    43c9:	5e                   	pop    %esi
    43ca:	5f                   	pop    %edi
    43cb:	5d                   	pop    %ebp
    43cc:	c3                   	ret    
    if(p->s.size >= nunits){
    43cd:	89 c2                	mov    %eax,%edx
    43cf:	89 f8                	mov    %edi,%eax
    43d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
    43d8:	39 ce                	cmp    %ecx,%esi
    43da:	74 54                	je     4430 <malloc+0x100>
        p->s.size -= nunits;
    43dc:	29 f1                	sub    %esi,%ecx
    43de:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
    43e1:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
    43e4:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
    43e7:	a3 80 65 00 00       	mov    %eax,0x6580
}
    43ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
    43ef:	8d 42 08             	lea    0x8(%edx),%eax
}
    43f2:	5b                   	pop    %ebx
    43f3:	5e                   	pop    %esi
    43f4:	5f                   	pop    %edi
    43f5:	5d                   	pop    %ebp
    43f6:	c3                   	ret    
    43f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    43fe:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
    4400:	c7 05 80 65 00 00 84 	movl   $0x6584,0x6580
    4407:	65 00 00 
    base.s.size = 0;
    440a:	bf 84 65 00 00       	mov    $0x6584,%edi
    base.s.ptr = freep = prevp = &base;
    440f:	c7 05 84 65 00 00 84 	movl   $0x6584,0x6584
    4416:	65 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    4419:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
    441b:	c7 05 88 65 00 00 00 	movl   $0x0,0x6588
    4422:	00 00 00 
    if(p->s.size >= nunits){
    4425:	e9 36 ff ff ff       	jmp    4360 <malloc+0x30>
    442a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
    4430:	8b 0a                	mov    (%edx),%ecx
    4432:	89 08                	mov    %ecx,(%eax)
    4434:	eb b1                	jmp    43e7 <malloc+0xb7>
