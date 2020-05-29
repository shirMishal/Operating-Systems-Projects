
_test:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

void test_cfs();
void test_cfs_fork();


int main(int argc, char *argv[]){
       0:	f3 0f 1e fb          	endbr32 
       4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
       8:	83 e4 f0             	and    $0xfffffff0,%esp
       b:	ff 71 fc             	pushl  -0x4(%ecx)
       e:	55                   	push   %ebp
       f:	89 e5                	mov    %esp,%ebp
      11:	53                   	push   %ebx
      12:	51                   	push   %ecx
	int pid = fork();
      13:	e8 43 0d 00 00       	call   d5b <fork>
	if (pid == 0){
      18:	85 c0                	test   %eax,%eax
      1a:	75 02                	jne    1e <main+0x1e>
		while(1){}
      1c:	eb fe                	jmp    1c <main+0x1c>
	}
	else {
		sleep(100);
      1e:	83 ec 0c             	sub    $0xc,%esp
      21:	89 c3                	mov    %eax,%ebx
      23:	6a 64                	push   $0x64
      25:	e8 c9 0d 00 00       	call   df3 <sleep>
		kill(pid);
      2a:	89 1c 24             	mov    %ebx,(%esp)
      2d:	e8 61 0d 00 00       	call   d93 <kill>
		sleep(500);
      32:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
      39:	e8 b5 0d 00 00       	call   df3 <sleep>
		exit(1);
      3e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      45:	e8 19 0d 00 00       	call   d63 <exit>
      4a:	66 90                	xchg   %ax,%ax
      4c:	66 90                	xchg   %ax,%ax
      4e:	66 90                	xchg   %ax,%ax

00000050 <test_ps_sys_call>:
    }
    printf(1, "****************** Finished, please check yourself ******************\n \n");
}

// checks set_ps_priority
void test_ps_sys_call() {
      50:	f3 0f 1e fb          	endbr32 
      54:	55                   	push   %ebp
      55:	89 e5                	mov    %esp,%ebp
      57:	56                   	push   %esi
    int success = 1;
      58:	be 01 00 00 00       	mov    $0x1,%esi
void test_ps_sys_call() {
      5d:	53                   	push   %ebx
    for (int i=1; i<=10; i++) {
      5e:	bb 01 00 00 00       	mov    $0x1,%ebx
      63:	eb 0b                	jmp    70 <test_ps_sys_call+0x20>
      65:	8d 76 00             	lea    0x0(%esi),%esi
      68:	83 c3 01             	add    $0x1,%ebx
      6b:	83 fb 0b             	cmp    $0xb,%ebx
      6e:	74 2c                	je     9c <test_ps_sys_call+0x4c>
        if (set_ps_priority(i) != 0) {
      70:	83 ec 0c             	sub    $0xc,%esp
      73:	53                   	push   %ebx
      74:	e8 92 0d 00 00       	call   e0b <set_ps_priority>
      79:	83 c4 10             	add    $0x10,%esp
      7c:	85 c0                	test   %eax,%eax
      7e:	74 e8                	je     68 <test_ps_sys_call+0x18>
            printf(1, "BUG: set_ps_priority\n");
      80:	83 ec 08             	sub    $0x8,%esp
    for (int i=1; i<=10; i++) {
      83:	83 c3 01             	add    $0x1,%ebx
            success=0;
      86:	31 f6                	xor    %esi,%esi
            printf(1, "BUG: set_ps_priority\n");
      88:	68 48 12 00 00       	push   $0x1248
      8d:	6a 01                	push   $0x1
      8f:	e8 4c 0e 00 00       	call   ee0 <printf>
      94:	83 c4 10             	add    $0x10,%esp
    for (int i=1; i<=10; i++) {
      97:	83 fb 0b             	cmp    $0xb,%ebx
      9a:	75 d4                	jne    70 <test_ps_sys_call+0x20>
        }
    }

    if (set_ps_priority(-1) != -1) {
      9c:	83 ec 0c             	sub    $0xc,%esp
      9f:	6a ff                	push   $0xffffffff
      a1:	e8 65 0d 00 00       	call   e0b <set_ps_priority>
      a6:	83 c4 10             	add    $0x10,%esp
      a9:	83 f8 ff             	cmp    $0xffffffff,%eax
      ac:	75 32                	jne    e0 <test_ps_sys_call+0x90>
        printf(1, "BUG: set_ps_priority- not returning error\n");
        success=0;
    }

    if (set_ps_priority(11) != -1) {
      ae:	83 ec 0c             	sub    $0xc,%esp
      b1:	6a 0b                	push   $0xb
      b3:	e8 53 0d 00 00       	call   e0b <set_ps_priority>
      b8:	83 c4 10             	add    $0x10,%esp
      bb:	83 f8 ff             	cmp    $0xffffffff,%eax
      be:	75 43                	jne    103 <test_ps_sys_call+0xb3>
        printf(1, "BUG: set_ps_priority- not returning error\n");
        success=0;
    }

    if (success == 1) {
      c0:	83 fe 01             	cmp    $0x1,%esi
      c3:	75 50                	jne    115 <test_ps_sys_call+0xc5>
        printf(1, "test of set_ps_priority - SUCCESS\n");
      c5:	83 ec 08             	sub    $0x8,%esp
      c8:	68 94 13 00 00       	push   $0x1394
      cd:	6a 01                	push   $0x1
      cf:	e8 0c 0e 00 00       	call   ee0 <printf>
    }
}
      d4:	83 c4 10             	add    $0x10,%esp
      d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
      da:	5b                   	pop    %ebx
      db:	5e                   	pop    %esi
      dc:	5d                   	pop    %ebp
      dd:	c3                   	ret    
      de:	66 90                	xchg   %ax,%ax
        printf(1, "BUG: set_ps_priority- not returning error\n");
      e0:	83 ec 08             	sub    $0x8,%esp
      e3:	68 68 13 00 00       	push   $0x1368
      e8:	6a 01                	push   $0x1
      ea:	e8 f1 0d 00 00       	call   ee0 <printf>
    if (set_ps_priority(11) != -1) {
      ef:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
      f6:	e8 10 0d 00 00       	call   e0b <set_ps_priority>
      fb:	83 c4 10             	add    $0x10,%esp
      fe:	83 f8 ff             	cmp    $0xffffffff,%eax
     101:	74 12                	je     115 <test_ps_sys_call+0xc5>
        printf(1, "BUG: set_ps_priority- not returning error\n");
     103:	83 ec 08             	sub    $0x8,%esp
     106:	68 68 13 00 00       	push   $0x1368
     10b:	6a 01                	push   $0x1
     10d:	e8 ce 0d 00 00       	call   ee0 <printf>
     112:	83 c4 10             	add    $0x10,%esp
}
     115:	8d 65 f8             	lea    -0x8(%ebp),%esp
     118:	5b                   	pop    %ebx
     119:	5e                   	pop    %esi
     11a:	5d                   	pop    %ebp
     11b:	c3                   	ret    
     11c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000120 <test_cfs_sys_call>:

// checks set_cfs_priority
void test_cfs_sys_call() {
     120:	f3 0f 1e fb          	endbr32 
     124:	55                   	push   %ebp
     125:	89 e5                	mov    %esp,%ebp
     127:	56                   	push   %esi
    int success = 1;
     128:	be 01 00 00 00       	mov    $0x1,%esi
void test_cfs_sys_call() {
     12d:	53                   	push   %ebx
    for (int i=1; i<=3; i++) {
     12e:	bb 01 00 00 00       	mov    $0x1,%ebx
        if (set_cfs_priority(i) != 0) {
     133:	83 ec 0c             	sub    $0xc,%esp
     136:	53                   	push   %ebx
     137:	e8 df 0c 00 00       	call   e1b <set_cfs_priority>
     13c:	83 c4 10             	add    $0x10,%esp
     13f:	85 c0                	test   %eax,%eax
     141:	75 4d                	jne    190 <test_cfs_sys_call+0x70>
    for (int i=1; i<=3; i++) {
     143:	83 c3 01             	add    $0x1,%ebx
     146:	83 fb 04             	cmp    $0x4,%ebx
     149:	75 e8                	jne    133 <test_cfs_sys_call+0x13>
            printf(1, "BUG: set_cfs_priority %d\n", i);
            success=0;
        }
    }

    if (set_cfs_priority(4) != -1) {
     14b:	83 ec 0c             	sub    $0xc,%esp
     14e:	6a 04                	push   $0x4
     150:	e8 c6 0c 00 00       	call   e1b <set_cfs_priority>
     155:	83 c4 10             	add    $0x10,%esp
     158:	83 f8 ff             	cmp    $0xffffffff,%eax
     15b:	75 53                	jne    1b0 <test_cfs_sys_call+0x90>
        printf(1, "BUG: set_cfs_priority- not returning error\n");
        success=0;
    }

    if (set_cfs_priority(-1) != -1) {
     15d:	83 ec 0c             	sub    $0xc,%esp
     160:	6a ff                	push   $0xffffffff
     162:	e8 b4 0c 00 00       	call   e1b <set_cfs_priority>
     167:	83 c4 10             	add    $0x10,%esp
     16a:	83 f8 ff             	cmp    $0xffffffff,%eax
     16d:	75 64                	jne    1d3 <test_cfs_sys_call+0xb3>
        printf(1, "BUG: set_cfs_priority- not returning error\n");
        success=0;
    }

    if (success == 1) {
     16f:	83 fe 01             	cmp    $0x1,%esi
     172:	75 71                	jne    1e5 <test_cfs_sys_call+0xc5>
        printf(1, "test of set_cfs_priority - SUCCESS\n");
     174:	83 ec 08             	sub    $0x8,%esp
     177:	68 e4 13 00 00       	push   $0x13e4
     17c:	6a 01                	push   $0x1
     17e:	e8 5d 0d 00 00       	call   ee0 <printf>
    }
}
     183:	83 c4 10             	add    $0x10,%esp
     186:	8d 65 f8             	lea    -0x8(%ebp),%esp
     189:	5b                   	pop    %ebx
     18a:	5e                   	pop    %esi
     18b:	5d                   	pop    %ebp
     18c:	c3                   	ret    
     18d:	8d 76 00             	lea    0x0(%esi),%esi
            printf(1, "BUG: set_cfs_priority %d\n", i);
     190:	83 ec 04             	sub    $0x4,%esp
            success=0;
     193:	31 f6                	xor    %esi,%esi
            printf(1, "BUG: set_cfs_priority %d\n", i);
     195:	53                   	push   %ebx
     196:	68 5e 12 00 00       	push   $0x125e
     19b:	6a 01                	push   $0x1
     19d:	e8 3e 0d 00 00       	call   ee0 <printf>
     1a2:	83 c4 10             	add    $0x10,%esp
     1a5:	eb 9c                	jmp    143 <test_cfs_sys_call+0x23>
     1a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     1ae:	66 90                	xchg   %ax,%ax
        printf(1, "BUG: set_cfs_priority- not returning error\n");
     1b0:	83 ec 08             	sub    $0x8,%esp
     1b3:	68 b8 13 00 00       	push   $0x13b8
     1b8:	6a 01                	push   $0x1
     1ba:	e8 21 0d 00 00       	call   ee0 <printf>
    if (set_cfs_priority(-1) != -1) {
     1bf:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
     1c6:	e8 50 0c 00 00       	call   e1b <set_cfs_priority>
     1cb:	83 c4 10             	add    $0x10,%esp
     1ce:	83 f8 ff             	cmp    $0xffffffff,%eax
     1d1:	74 12                	je     1e5 <test_cfs_sys_call+0xc5>
        printf(1, "BUG: set_cfs_priority- not returning error\n");
     1d3:	83 ec 08             	sub    $0x8,%esp
     1d6:	68 b8 13 00 00       	push   $0x13b8
     1db:	6a 01                	push   $0x1
     1dd:	e8 fe 0c 00 00       	call   ee0 <printf>
     1e2:	83 c4 10             	add    $0x10,%esp
}
     1e5:	8d 65 f8             	lea    -0x8(%ebp),%esp
     1e8:	5b                   	pop    %ebx
     1e9:	5e                   	pop    %esi
     1ea:	5d                   	pop    %ebp
     1eb:	c3                   	ret    
     1ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000001f0 <fib>:
        wait(null);
    }
}

int fib(int n) 
{
     1f0:	f3 0f 1e fb          	endbr32 
     1f4:	55                   	push   %ebp
    if (n==1 || n==0) {
     1f5:	b8 01 00 00 00       	mov    $0x1,%eax
{
     1fa:	89 e5                	mov    %esp,%ebp
     1fc:	56                   	push   %esi
     1fd:	53                   	push   %ebx
     1fe:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (n==1 || n==0) {
     201:	83 fb 01             	cmp    $0x1,%ebx
     204:	76 1e                	jbe    224 <fib+0x34>
     206:	31 f6                	xor    %esi,%esi
        return 1;
    }

    return fib(n-1) + fib(n-2);
     208:	83 ec 0c             	sub    $0xc,%esp
     20b:	8d 43 ff             	lea    -0x1(%ebx),%eax
     20e:	83 eb 02             	sub    $0x2,%ebx
     211:	50                   	push   %eax
     212:	e8 d9 ff ff ff       	call   1f0 <fib>
     217:	83 c4 10             	add    $0x10,%esp
     21a:	01 c6                	add    %eax,%esi
    if (n==1 || n==0) {
     21c:	83 fb 01             	cmp    $0x1,%ebx
     21f:	77 e7                	ja     208 <fib+0x18>
     221:	8d 46 01             	lea    0x1(%esi),%eax
}
     224:	8d 65 f8             	lea    -0x8(%ebp),%esp
     227:	5b                   	pop    %ebx
     228:	5e                   	pop    %esi
     229:	5d                   	pop    %ebp
     22a:	c3                   	ret    
     22b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     22f:	90                   	nop

00000230 <fib_with_sleep>:

void fib_with_sleep() {
     230:	f3 0f 1e fb          	endbr32 
     234:	55                   	push   %ebp
     235:	89 e5                	mov    %esp,%ebp
     237:	53                   	push   %ebx
     238:	bb 03 00 00 00       	mov    $0x3,%ebx
     23d:	83 ec 04             	sub    $0x4,%esp
     240:	ba 27 00 00 00       	mov    $0x27,%edx
    return fib(n-1) + fib(n-2);
     245:	83 ec 0c             	sub    $0xc,%esp
     248:	52                   	push   %edx
     249:	e8 a2 ff ff ff       	call   1f0 <fib>
     24e:	83 c4 10             	add    $0x10,%esp
    if (n==1 || n==0) {
     251:	83 ea 02             	sub    $0x2,%edx
     254:	83 fa ff             	cmp    $0xffffffff,%edx
     257:	75 ec                	jne    245 <fib_with_sleep+0x15>
    for (int i=0; i<3; i++) {
            fib(40);
            sleep(10);
     259:	83 ec 0c             	sub    $0xc,%esp
     25c:	6a 0a                	push   $0xa
     25e:	e8 90 0b 00 00       	call   df3 <sleep>
    for (int i=0; i<3; i++) {
     263:	83 c4 10             	add    $0x10,%esp
     266:	83 eb 01             	sub    $0x1,%ebx
     269:	75 d5                	jne    240 <fib_with_sleep+0x10>
        }
}
     26b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     26e:	c9                   	leave  
     26f:	c3                   	ret    

00000270 <fib_no_sleep>:

void fib_no_sleep() {
     270:	f3 0f 1e fb          	endbr32 
     274:	55                   	push   %ebp
     275:	b9 03 00 00 00       	mov    $0x3,%ecx
     27a:	89 e5                	mov    %esp,%ebp
     27c:	83 ec 08             	sub    $0x8,%esp
     27f:	ba 27 00 00 00       	mov    $0x27,%edx
    return fib(n-1) + fib(n-2);
     284:	83 ec 0c             	sub    $0xc,%esp
     287:	52                   	push   %edx
     288:	e8 63 ff ff ff       	call   1f0 <fib>
     28d:	83 c4 10             	add    $0x10,%esp
    if (n==1 || n==0) {
     290:	83 ea 02             	sub    $0x2,%edx
     293:	83 fa ff             	cmp    $0xffffffff,%edx
     296:	75 ec                	jne    284 <fib_no_sleep+0x14>
    for (int i=0; i<3; i++) {
     298:	83 e9 01             	sub    $0x1,%ecx
     29b:	75 e2                	jne    27f <fib_no_sleep+0xf>
            fib(40);
        }
}
     29d:	c9                   	leave  
     29e:	c3                   	ret    
     29f:	90                   	nop

000002a0 <print_proc_info>:

void print_proc_info(){
     2a0:	f3 0f 1e fb          	endbr32 
     2a4:	55                   	push   %ebp
     2a5:	89 e5                	mov    %esp,%ebp
     2a7:	53                   	push   %ebx
     2a8:	83 ec 14             	sub    $0x14,%esp
    int pid = getpid();
     2ab:	e8 33 0b 00 00       	call   de3 <getpid>
    struct perf proc_perf;
        // get statistics and print
        proc_info(&proc_perf);
     2b0:	83 ec 0c             	sub    $0xc,%esp
    int pid = getpid();
     2b3:	89 c3                	mov    %eax,%ebx
        proc_info(&proc_perf);
     2b5:	8d 45 e8             	lea    -0x18(%ebp),%eax
     2b8:	50                   	push   %eax
     2b9:	e8 65 0b 00 00       	call   e23 <proc_info>

        printf(1, "pid: %d, ps_priority: %d, stime: %d, retime: %d, rtime: %d\n", 
     2be:	83 c4 0c             	add    $0xc,%esp
     2c1:	ff 75 f4             	pushl  -0xc(%ebp)
     2c4:	ff 75 f0             	pushl  -0x10(%ebp)
     2c7:	ff 75 ec             	pushl  -0x14(%ebp)
     2ca:	ff 75 e8             	pushl  -0x18(%ebp)
     2cd:	53                   	push   %ebx
     2ce:	68 08 14 00 00       	push   $0x1408
     2d3:	6a 01                	push   $0x1
     2d5:	e8 06 0c 00 00       	call   ee0 <printf>
                    pid, proc_perf.ps_priority, proc_perf.stime, proc_perf.retime, proc_perf.rtime);
}
     2da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     2dd:	83 c4 20             	add    $0x20,%esp
     2e0:	c9                   	leave  
     2e1:	c3                   	ret    
     2e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     2e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000002f0 <ps_proc_task>:
void ps_proc_task(int priority, int fib_type) {
     2f0:	f3 0f 1e fb          	endbr32 
     2f4:	55                   	push   %ebp
     2f5:	89 e5                	mov    %esp,%ebp
     2f7:	53                   	push   %ebx
     2f8:	83 ec 04             	sub    $0x4,%esp
     2fb:	8b 45 08             	mov    0x8(%ebp),%eax
     2fe:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    if (priority>0) {
     301:	85 c0                	test   %eax,%eax
     303:	7e 0c                	jle    311 <ps_proc_task+0x21>
        set_ps_priority(priority);
     305:	83 ec 0c             	sub    $0xc,%esp
     308:	50                   	push   %eax
     309:	e8 fd 0a 00 00       	call   e0b <set_ps_priority>
     30e:	83 c4 10             	add    $0x10,%esp
    switch (fib_type) {
     311:	83 fb 01             	cmp    $0x1,%ebx
     314:	74 19                	je     32f <ps_proc_task+0x3f>
     316:	83 fb 02             	cmp    $0x2,%ebx
     319:	75 05                	jne    320 <ps_proc_task+0x30>
            fib_no_sleep();
     31b:	e8 50 ff ff ff       	call   270 <fib_no_sleep>
    print_proc_info();
     320:	e8 7b ff ff ff       	call   2a0 <print_proc_info>
    exit(0);
     325:	83 ec 0c             	sub    $0xc,%esp
     328:	6a 00                	push   $0x0
     32a:	e8 34 0a 00 00       	call   d63 <exit>
            fib_with_sleep();
     32f:	e8 fc fe ff ff       	call   230 <fib_with_sleep>
            break;
     334:	eb ea                	jmp    320 <ps_proc_task+0x30>
     336:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     33d:	8d 76 00             	lea    0x0(%esi),%esi

00000340 <test_ps>:
void test_ps () {
     340:	f3 0f 1e fb          	endbr32 
     344:	55                   	push   %ebp
     345:	89 e5                	mov    %esp,%ebp
     347:	53                   	push   %ebx
     348:	83 ec 04             	sub    $0x4,%esp
    if (fork() == 0) {
     34b:	e8 0b 0a 00 00       	call   d5b <fork>
     350:	85 c0                	test   %eax,%eax
     352:	74 5b                	je     3af <test_ps+0x6f>
    if (fork() == 0) {
     354:	e8 02 0a 00 00       	call   d5b <fork>
     359:	85 c0                	test   %eax,%eax
     35b:	0f 84 e4 00 00 00    	je     445 <test_ps+0x105>
    if (fork() == 0) {
     361:	e8 f5 09 00 00       	call   d5b <fork>
     366:	85 c0                	test   %eax,%eax
     368:	0f 84 b9 00 00 00    	je     427 <test_ps+0xe7>
    if (fork() == 0) {
     36e:	e8 e8 09 00 00       	call   d5b <fork>
     373:	85 c0                	test   %eax,%eax
     375:	0f 84 8e 00 00 00    	je     409 <test_ps+0xc9>
    if (fork() == 0) {
     37b:	e8 db 09 00 00       	call   d5b <fork>
     380:	85 c0                	test   %eax,%eax
     382:	74 67                	je     3eb <test_ps+0xab>
    if (fork() == 0) {
     384:	e8 d2 09 00 00       	call   d5b <fork>
     389:	85 c0                	test   %eax,%eax
     38b:	74 40                	je     3cd <test_ps+0x8d>
     38d:	bb 06 00 00 00       	mov    $0x6,%ebx
     392:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        wait(null);
     398:	83 ec 0c             	sub    $0xc,%esp
     39b:	6a 00                	push   $0x0
     39d:	e8 c9 09 00 00       	call   d6b <wait>
    for (int i=1; i<=6; i++) {
     3a2:	83 c4 10             	add    $0x10,%esp
     3a5:	83 eb 01             	sub    $0x1,%ebx
     3a8:	75 ee                	jne    398 <test_ps+0x58>
}
     3aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     3ad:	c9                   	leave  
     3ae:	c3                   	ret    
        int pid = getpid();
     3af:	e8 2f 0a 00 00       	call   de3 <getpid>
        printf(1, "proc num: %d -> high+sleeping\n", pid);
     3b4:	52                   	push   %edx
     3b5:	50                   	push   %eax
     3b6:	68 44 14 00 00       	push   $0x1444
     3bb:	6a 01                	push   $0x1
     3bd:	e8 1e 0b 00 00       	call   ee0 <printf>
        ps_proc_task(1, FIB_SLEEP);
     3c2:	59                   	pop    %ecx
     3c3:	5b                   	pop    %ebx
     3c4:	6a 01                	push   $0x1
     3c6:	6a 01                	push   $0x1
     3c8:	e8 23 ff ff ff       	call   2f0 <ps_proc_task>
        int pid = getpid();
     3cd:	e8 11 0a 00 00       	call   de3 <getpid>
        printf(1, "proc num: %d -> low+not sleeping\n", pid);
     3d2:	52                   	push   %edx
     3d3:	50                   	push   %eax
     3d4:	68 ac 14 00 00       	push   $0x14ac
     3d9:	6a 01                	push   $0x1
     3db:	e8 00 0b 00 00       	call   ee0 <printf>
        ps_proc_task(10, FIB_NO_SLEEP);
     3e0:	59                   	pop    %ecx
     3e1:	5b                   	pop    %ebx
     3e2:	6a 02                	push   $0x2
     3e4:	6a 0a                	push   $0xa
     3e6:	e8 05 ff ff ff       	call   2f0 <ps_proc_task>
        int pid = getpid();
     3eb:	e8 f3 09 00 00       	call   de3 <getpid>
        printf(1, "proc num: %d -> low+sleeping\n", pid);
     3f0:	52                   	push   %edx
     3f1:	50                   	push   %eax
     3f2:	68 96 12 00 00       	push   $0x1296
     3f7:	6a 01                	push   $0x1
     3f9:	e8 e2 0a 00 00       	call   ee0 <printf>
        ps_proc_task(10, FIB_SLEEP);
     3fe:	59                   	pop    %ecx
     3ff:	5b                   	pop    %ebx
     400:	6a 01                	push   $0x1
     402:	6a 0a                	push   $0xa
     404:	e8 e7 fe ff ff       	call   2f0 <ps_proc_task>
        int pid = getpid();
     409:	e8 d5 09 00 00       	call   de3 <getpid>
        printf(1, "proc num: %d -> mid+not sleeping\n", pid);
     40e:	52                   	push   %edx
     40f:	50                   	push   %eax
     410:	68 88 14 00 00       	push   $0x1488
     415:	6a 01                	push   $0x1
     417:	e8 c4 0a 00 00       	call   ee0 <printf>
        ps_proc_task(5, FIB_NO_SLEEP);
     41c:	59                   	pop    %ecx
     41d:	5b                   	pop    %ebx
     41e:	6a 02                	push   $0x2
     420:	6a 05                	push   $0x5
     422:	e8 c9 fe ff ff       	call   2f0 <ps_proc_task>
        int pid = getpid();
     427:	e8 b7 09 00 00       	call   de3 <getpid>
        printf(1, "proc num: %d -> mid+sleeping\n", pid);
     42c:	52                   	push   %edx
     42d:	50                   	push   %eax
     42e:	68 78 12 00 00       	push   $0x1278
     433:	6a 01                	push   $0x1
     435:	e8 a6 0a 00 00       	call   ee0 <printf>
        ps_proc_task(5, FIB_SLEEP);
     43a:	59                   	pop    %ecx
     43b:	5b                   	pop    %ebx
     43c:	6a 01                	push   $0x1
     43e:	6a 05                	push   $0x5
     440:	e8 ab fe ff ff       	call   2f0 <ps_proc_task>
        int pid = getpid();
     445:	e8 99 09 00 00       	call   de3 <getpid>
        printf(1, "proc num: %d -> high+not sleeping\n", pid);
     44a:	52                   	push   %edx
     44b:	50                   	push   %eax
     44c:	68 64 14 00 00       	push   $0x1464
     451:	6a 01                	push   $0x1
     453:	e8 88 0a 00 00       	call   ee0 <printf>
        ps_proc_task(1, FIB_NO_SLEEP);
     458:	59                   	pop    %ecx
     459:	5b                   	pop    %ebx
     45a:	6a 02                	push   $0x2
     45c:	6a 01                	push   $0x1
     45e:	e8 8d fe ff ff       	call   2f0 <ps_proc_task>
     463:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     46a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000470 <ps_parent_task>:
void ps_parent_task(int fib_type) {
     470:	f3 0f 1e fb          	endbr32 
     474:	55                   	push   %ebp
     475:	89 e5                	mov    %esp,%ebp
     477:	83 ec 08             	sub    $0x8,%esp
     47a:	8b 45 08             	mov    0x8(%ebp),%eax
    switch (fib_type) {
     47d:	83 f8 01             	cmp    $0x1,%eax
     480:	74 25                	je     4a7 <ps_parent_task+0x37>
     482:	83 f8 02             	cmp    $0x2,%eax
     485:	75 05                	jne    48c <ps_parent_task+0x1c>
            fib_no_sleep();
     487:	e8 e4 fd ff ff       	call   270 <fib_no_sleep>
    print_proc_info();
     48c:	e8 0f fe ff ff       	call   2a0 <print_proc_info>
    wait(null);
     491:	83 ec 0c             	sub    $0xc,%esp
     494:	6a 00                	push   $0x0
     496:	e8 d0 08 00 00       	call   d6b <wait>
    exit(0);
     49b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     4a2:	e8 bc 08 00 00       	call   d63 <exit>
            fib_with_sleep();
     4a7:	e8 84 fd ff ff       	call   230 <fib_with_sleep>
            break;
     4ac:	eb de                	jmp    48c <ps_parent_task+0x1c>
     4ae:	66 90                	xchg   %ax,%ax

000004b0 <test_ps_fork1>:
void test_ps_fork1() {
     4b0:	f3 0f 1e fb          	endbr32 
     4b4:	55                   	push   %ebp
     4b5:	89 e5                	mov    %esp,%ebp
     4b7:	83 ec 08             	sub    $0x8,%esp
    if (fork() == 0) {
     4ba:	e8 9c 08 00 00       	call   d5b <fork>
     4bf:	85 c0                	test   %eax,%eax
     4c1:	75 4d                	jne    510 <test_ps_fork1+0x60>
        set_ps_priority(1);
     4c3:	83 ec 0c             	sub    $0xc,%esp
     4c6:	6a 01                	push   $0x1
     4c8:	e8 3e 09 00 00       	call   e0b <set_ps_priority>
        int pid = getpid();
     4cd:	e8 11 09 00 00       	call   de3 <getpid>
        printf(1, "PARENT: %d -> high\n", pid);
     4d2:	83 c4 0c             	add    $0xc,%esp
     4d5:	50                   	push   %eax
     4d6:	68 b4 12 00 00       	push   $0x12b4
        printf(1, "PARENT: %d -> low\n", pid);
     4db:	6a 01                	push   $0x1
     4dd:	e8 fe 09 00 00       	call   ee0 <printf>
        if (fork()==0) {
     4e2:	e8 74 08 00 00       	call   d5b <fork>
     4e7:	83 c4 10             	add    $0x10,%esp
     4ea:	85 c0                	test   %eax,%eax
     4ec:	75 4a                	jne    538 <test_ps_fork1+0x88>
            int pid = getpid();
     4ee:	e8 f0 08 00 00       	call   de3 <getpid>
            printf(1, "CHILD: %d -> mid\n", pid);
     4f3:	83 ec 04             	sub    $0x4,%esp
     4f6:	50                   	push   %eax
     4f7:	68 c8 12 00 00       	push   $0x12c8
     4fc:	6a 01                	push   $0x1
     4fe:	e8 dd 09 00 00       	call   ee0 <printf>
            ps_proc_task(-1, FIB_NO_SLEEP);
     503:	58                   	pop    %eax
     504:	5a                   	pop    %edx
     505:	6a 02                	push   $0x2
     507:	6a ff                	push   $0xffffffff
     509:	e8 e2 fd ff ff       	call   2f0 <ps_proc_task>
     50e:	66 90                	xchg   %ax,%ax
    if (fork() == 0) {
     510:	e8 46 08 00 00       	call   d5b <fork>
     515:	85 c0                	test   %eax,%eax
     517:	75 2f                	jne    548 <test_ps_fork1+0x98>
        set_ps_priority(10);
     519:	83 ec 0c             	sub    $0xc,%esp
     51c:	6a 0a                	push   $0xa
     51e:	e8 e8 08 00 00       	call   e0b <set_ps_priority>
        int pid = getpid();
     523:	e8 bb 08 00 00       	call   de3 <getpid>
        printf(1, "PARENT: %d -> low\n", pid);
     528:	83 c4 0c             	add    $0xc,%esp
     52b:	50                   	push   %eax
     52c:	68 da 12 00 00       	push   $0x12da
     531:	eb a8                	jmp    4db <test_ps_fork1+0x2b>
     533:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     537:	90                   	nop
        ps_parent_task(FIB_NO_SLEEP);
     538:	83 ec 0c             	sub    $0xc,%esp
     53b:	6a 02                	push   $0x2
     53d:	e8 2e ff ff ff       	call   470 <ps_parent_task>
     542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wait(null);
     548:	83 ec 0c             	sub    $0xc,%esp
     54b:	6a 00                	push   $0x0
     54d:	e8 19 08 00 00       	call   d6b <wait>
    wait(null);
     552:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     559:	e8 0d 08 00 00       	call   d6b <wait>
}
     55e:	83 c4 10             	add    $0x10,%esp
     561:	c9                   	leave  
     562:	c3                   	ret    
     563:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     56a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000570 <test_ps_fork2>:
void test_ps_fork2() {
     570:	f3 0f 1e fb          	endbr32 
     574:	55                   	push   %ebp
     575:	89 e5                	mov    %esp,%ebp
     577:	83 ec 08             	sub    $0x8,%esp
    if (fork() == 0) {
     57a:	e8 dc 07 00 00       	call   d5b <fork>
     57f:	85 c0                	test   %eax,%eax
     581:	75 4d                	jne    5d0 <test_ps_fork2+0x60>
        set_ps_priority(1);
     583:	83 ec 0c             	sub    $0xc,%esp
     586:	6a 01                	push   $0x1
     588:	e8 7e 08 00 00       	call   e0b <set_ps_priority>
        int pid = getpid();
     58d:	e8 51 08 00 00       	call   de3 <getpid>
        printf(1, "PARENT: %d -> high\n", pid);
     592:	83 c4 0c             	add    $0xc,%esp
     595:	50                   	push   %eax
     596:	68 b4 12 00 00       	push   $0x12b4
     59b:	6a 01                	push   $0x1
     59d:	e8 3e 09 00 00       	call   ee0 <printf>
        if (fork()==0) {
     5a2:	e8 b4 07 00 00       	call   d5b <fork>
     5a7:	83 c4 10             	add    $0x10,%esp
     5aa:	85 c0                	test   %eax,%eax
     5ac:	75 7a                	jne    628 <test_ps_fork2+0xb8>
            int pid = getpid();
     5ae:	e8 30 08 00 00       	call   de3 <getpid>
            printf(1, "CHILD: %d -> high\n", pid);
     5b3:	83 ec 04             	sub    $0x4,%esp
     5b6:	50                   	push   %eax
     5b7:	68 ed 12 00 00       	push   $0x12ed
     5bc:	6a 01                	push   $0x1
     5be:	e8 1d 09 00 00       	call   ee0 <printf>
            ps_proc_task(1, FIB_NO_SLEEP);
     5c3:	59                   	pop    %ecx
     5c4:	58                   	pop    %eax
     5c5:	6a 02                	push   $0x2
     5c7:	6a 01                	push   $0x1
     5c9:	e8 22 fd ff ff       	call   2f0 <ps_proc_task>
     5ce:	66 90                	xchg   %ax,%ax
    if (fork() == 0) {
     5d0:	e8 86 07 00 00       	call   d5b <fork>
     5d5:	85 c0                	test   %eax,%eax
     5d7:	75 5f                	jne    638 <test_ps_fork2+0xc8>
        set_ps_priority(10);
     5d9:	83 ec 0c             	sub    $0xc,%esp
     5dc:	6a 0a                	push   $0xa
     5de:	e8 28 08 00 00       	call   e0b <set_ps_priority>
        int pid = getpid();
     5e3:	e8 fb 07 00 00       	call   de3 <getpid>
        printf(1, "PARENT: %d -> low\n", pid);
     5e8:	83 c4 0c             	add    $0xc,%esp
     5eb:	50                   	push   %eax
     5ec:	68 da 12 00 00       	push   $0x12da
     5f1:	6a 01                	push   $0x1
     5f3:	e8 e8 08 00 00       	call   ee0 <printf>
        if (fork()==0) {
     5f8:	e8 5e 07 00 00       	call   d5b <fork>
     5fd:	83 c4 10             	add    $0x10,%esp
     600:	85 c0                	test   %eax,%eax
     602:	75 24                	jne    628 <test_ps_fork2+0xb8>
            int pid = getpid();
     604:	e8 da 07 00 00       	call   de3 <getpid>
            printf(1, "CHILD: %d -> low\n", pid);
     609:	83 ec 04             	sub    $0x4,%esp
     60c:	50                   	push   %eax
     60d:	68 00 13 00 00       	push   $0x1300
     612:	6a 01                	push   $0x1
     614:	e8 c7 08 00 00       	call   ee0 <printf>
            ps_proc_task(10, FIB_NO_SLEEP);
     619:	58                   	pop    %eax
     61a:	5a                   	pop    %edx
     61b:	6a 02                	push   $0x2
     61d:	6a 0a                	push   $0xa
     61f:	e8 cc fc ff ff       	call   2f0 <ps_proc_task>
     624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        ps_parent_task(FIB_NO_SLEEP);
     628:	83 ec 0c             	sub    $0xc,%esp
     62b:	6a 02                	push   $0x2
     62d:	e8 3e fe ff ff       	call   470 <ps_parent_task>
     632:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wait(null);
     638:	83 ec 0c             	sub    $0xc,%esp
     63b:	6a 00                	push   $0x0
     63d:	e8 29 07 00 00       	call   d6b <wait>
    wait(null);
     642:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     649:	e8 1d 07 00 00       	call   d6b <wait>
}
     64e:	83 c4 10             	add    $0x10,%esp
     651:	c9                   	leave  
     652:	c3                   	ret    
     653:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     65a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000660 <cfs_parent_task>:
     660:	f3 0f 1e fb          	endbr32 
     664:	55                   	push   %ebp
     665:	89 e5                	mov    %esp,%ebp
     667:	83 ec 14             	sub    $0x14,%esp
     66a:	ff 75 08             	pushl  0x8(%ebp)
     66d:	e8 fe fd ff ff       	call   470 <ps_parent_task>
     672:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000680 <cfs_proc_task>:
void cfs_proc_task (int priority, int fib_type) {
     680:	f3 0f 1e fb          	endbr32 
     684:	55                   	push   %ebp
     685:	89 e5                	mov    %esp,%ebp
     687:	53                   	push   %ebx
     688:	83 ec 04             	sub    $0x4,%esp
     68b:	8b 45 08             	mov    0x8(%ebp),%eax
     68e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    if (priority>0) {
     691:	85 c0                	test   %eax,%eax
     693:	7e 0c                	jle    6a1 <cfs_proc_task+0x21>
        set_cfs_priority(priority);
     695:	83 ec 0c             	sub    $0xc,%esp
     698:	50                   	push   %eax
     699:	e8 7d 07 00 00       	call   e1b <set_cfs_priority>
     69e:	83 c4 10             	add    $0x10,%esp
    switch (fib_type) {
     6a1:	83 fb 01             	cmp    $0x1,%ebx
     6a4:	74 19                	je     6bf <cfs_proc_task+0x3f>
     6a6:	83 fb 02             	cmp    $0x2,%ebx
     6a9:	75 05                	jne    6b0 <cfs_proc_task+0x30>
            fib_no_sleep();
     6ab:	e8 c0 fb ff ff       	call   270 <fib_no_sleep>
    print_proc_info();
     6b0:	e8 eb fb ff ff       	call   2a0 <print_proc_info>
    exit(0);
     6b5:	83 ec 0c             	sub    $0xc,%esp
     6b8:	6a 00                	push   $0x0
     6ba:	e8 a4 06 00 00       	call   d63 <exit>
            fib_with_sleep();
     6bf:	e8 6c fb ff ff       	call   230 <fib_with_sleep>
            break;
     6c4:	eb ea                	jmp    6b0 <cfs_proc_task+0x30>
     6c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     6cd:	8d 76 00             	lea    0x0(%esi),%esi

000006d0 <test_cfs>:
void test_cfs() {
     6d0:	f3 0f 1e fb          	endbr32 
     6d4:	55                   	push   %ebp
     6d5:	89 e5                	mov    %esp,%ebp
     6d7:	53                   	push   %ebx
     6d8:	83 ec 04             	sub    $0x4,%esp
    if (fork() == 0) {
     6db:	e8 7b 06 00 00       	call   d5b <fork>
     6e0:	85 c0                	test   %eax,%eax
     6e2:	74 5b                	je     73f <test_cfs+0x6f>
    if (fork() == 0) {
     6e4:	e8 72 06 00 00       	call   d5b <fork>
     6e9:	85 c0                	test   %eax,%eax
     6eb:	0f 84 e4 00 00 00    	je     7d5 <test_cfs+0x105>
    if (fork() == 0) {
     6f1:	e8 65 06 00 00       	call   d5b <fork>
     6f6:	85 c0                	test   %eax,%eax
     6f8:	0f 84 b9 00 00 00    	je     7b7 <test_cfs+0xe7>
    if (fork() == 0) {
     6fe:	e8 58 06 00 00       	call   d5b <fork>
     703:	85 c0                	test   %eax,%eax
     705:	0f 84 8e 00 00 00    	je     799 <test_cfs+0xc9>
    if (fork() == 0) {
     70b:	e8 4b 06 00 00       	call   d5b <fork>
     710:	85 c0                	test   %eax,%eax
     712:	74 67                	je     77b <test_cfs+0xab>
    if (fork() == 0) {
     714:	e8 42 06 00 00       	call   d5b <fork>
     719:	85 c0                	test   %eax,%eax
     71b:	74 40                	je     75d <test_cfs+0x8d>
     71d:	bb 06 00 00 00       	mov    $0x6,%ebx
     722:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        wait(null);
     728:	83 ec 0c             	sub    $0xc,%esp
     72b:	6a 00                	push   $0x0
     72d:	e8 39 06 00 00       	call   d6b <wait>
    for (int i=1; i<=6; i++) {
     732:	83 c4 10             	add    $0x10,%esp
     735:	83 eb 01             	sub    $0x1,%ebx
     738:	75 ee                	jne    728 <test_cfs+0x58>
}
     73a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     73d:	c9                   	leave  
     73e:	c3                   	ret    
        int pid = getpid();
     73f:	e8 9f 06 00 00       	call   de3 <getpid>
        printf(1, "proc num: %d -> high+sleeping\n", pid);
     744:	52                   	push   %edx
     745:	50                   	push   %eax
     746:	68 44 14 00 00       	push   $0x1444
     74b:	6a 01                	push   $0x1
     74d:	e8 8e 07 00 00       	call   ee0 <printf>
        cfs_proc_task(1, FIB_SLEEP);
     752:	59                   	pop    %ecx
     753:	5b                   	pop    %ebx
     754:	6a 01                	push   $0x1
     756:	6a 01                	push   $0x1
     758:	e8 23 ff ff ff       	call   680 <cfs_proc_task>
        int pid = getpid();
     75d:	e8 81 06 00 00       	call   de3 <getpid>
        printf(1, "proc num: %d -> low+not sleeping\n", pid);
     762:	52                   	push   %edx
     763:	50                   	push   %eax
     764:	68 ac 14 00 00       	push   $0x14ac
     769:	6a 01                	push   $0x1
     76b:	e8 70 07 00 00       	call   ee0 <printf>
        cfs_proc_task(3, FIB_NO_SLEEP);
     770:	59                   	pop    %ecx
     771:	5b                   	pop    %ebx
     772:	6a 02                	push   $0x2
     774:	6a 03                	push   $0x3
     776:	e8 05 ff ff ff       	call   680 <cfs_proc_task>
        int pid = getpid();
     77b:	e8 63 06 00 00       	call   de3 <getpid>
        printf(1, "proc num: %d -> low+sleeping\n", pid);
     780:	52                   	push   %edx
     781:	50                   	push   %eax
     782:	68 96 12 00 00       	push   $0x1296
     787:	6a 01                	push   $0x1
     789:	e8 52 07 00 00       	call   ee0 <printf>
        cfs_proc_task(3, FIB_SLEEP);
     78e:	59                   	pop    %ecx
     78f:	5b                   	pop    %ebx
     790:	6a 01                	push   $0x1
     792:	6a 03                	push   $0x3
     794:	e8 e7 fe ff ff       	call   680 <cfs_proc_task>
        int pid = getpid();
     799:	e8 45 06 00 00       	call   de3 <getpid>
        printf(1, "proc num: %d -> normal+not sleeping\n", pid);
     79e:	52                   	push   %edx
     79f:	50                   	push   %eax
     7a0:	68 f4 14 00 00       	push   $0x14f4
     7a5:	6a 01                	push   $0x1
     7a7:	e8 34 07 00 00       	call   ee0 <printf>
        cfs_proc_task(2, FIB_NO_SLEEP);
     7ac:	59                   	pop    %ecx
     7ad:	5b                   	pop    %ebx
     7ae:	6a 02                	push   $0x2
     7b0:	6a 02                	push   $0x2
     7b2:	e8 c9 fe ff ff       	call   680 <cfs_proc_task>
        int pid = getpid();
     7b7:	e8 27 06 00 00       	call   de3 <getpid>
        printf(1, "proc num: %d -> normal+sleeping\n", pid);
     7bc:	52                   	push   %edx
     7bd:	50                   	push   %eax
     7be:	68 d0 14 00 00       	push   $0x14d0
     7c3:	6a 01                	push   $0x1
     7c5:	e8 16 07 00 00       	call   ee0 <printf>
        cfs_proc_task(2, FIB_SLEEP);
     7ca:	59                   	pop    %ecx
     7cb:	5b                   	pop    %ebx
     7cc:	6a 01                	push   $0x1
     7ce:	6a 02                	push   $0x2
     7d0:	e8 ab fe ff ff       	call   680 <cfs_proc_task>
        int pid = getpid();
     7d5:	e8 09 06 00 00       	call   de3 <getpid>
        printf(1, "proc num: %d -> high+not sleeping\n", pid);
     7da:	52                   	push   %edx
     7db:	50                   	push   %eax
     7dc:	68 64 14 00 00       	push   $0x1464
     7e1:	6a 01                	push   $0x1
     7e3:	e8 f8 06 00 00       	call   ee0 <printf>
        cfs_proc_task(1, FIB_NO_SLEEP);
     7e8:	59                   	pop    %ecx
     7e9:	5b                   	pop    %ebx
     7ea:	6a 02                	push   $0x2
     7ec:	6a 01                	push   $0x1
     7ee:	e8 8d fe ff ff       	call   680 <cfs_proc_task>
     7f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     7fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000800 <test_cfs_fork>:
void test_cfs_fork() {
     800:	f3 0f 1e fb          	endbr32 
     804:	55                   	push   %ebp
     805:	89 e5                	mov    %esp,%ebp
     807:	83 ec 08             	sub    $0x8,%esp
    if (fork() == 0) {
     80a:	e8 4c 05 00 00       	call   d5b <fork>
     80f:	85 c0                	test   %eax,%eax
     811:	75 4d                	jne    860 <test_cfs_fork+0x60>
        set_cfs_priority(1);
     813:	83 ec 0c             	sub    $0xc,%esp
     816:	6a 01                	push   $0x1
     818:	e8 fe 05 00 00       	call   e1b <set_cfs_priority>
        int pid = getpid();
     81d:	e8 c1 05 00 00       	call   de3 <getpid>
        printf(1, "PARENT: %d -> high+sleeping\n", pid);
     822:	83 c4 0c             	add    $0xc,%esp
     825:	50                   	push   %eax
     826:	68 12 13 00 00       	push   $0x1312
     82b:	6a 01                	push   $0x1
     82d:	e8 ae 06 00 00       	call   ee0 <printf>
            if (fork()==0) {
     832:	e8 24 05 00 00       	call   d5b <fork>
     837:	83 c4 10             	add    $0x10,%esp
     83a:	85 c0                	test   %eax,%eax
     83c:	75 7a                	jne    8b8 <test_cfs_fork+0xb8>
                int pid = getpid();
     83e:	e8 a0 05 00 00       	call   de3 <getpid>
                printf(1, "CHILD: %d -> high+sleeping\n", pid);
     843:	83 ec 04             	sub    $0x4,%esp
     846:	50                   	push   %eax
     847:	68 2f 13 00 00       	push   $0x132f
                printf(1, "CHILD: %d -> low+sleeping\n", pid);
     84c:	6a 01                	push   $0x1
     84e:	e8 8d 06 00 00       	call   ee0 <printf>
                cfs_proc_task(-1, FIB_SLEEP);
     853:	59                   	pop    %ecx
     854:	58                   	pop    %eax
     855:	6a 01                	push   $0x1
     857:	6a ff                	push   $0xffffffff
     859:	e8 22 fe ff ff       	call   680 <cfs_proc_task>
     85e:	66 90                	xchg   %ax,%ax
    if (fork() == 0) {
     860:	e8 f6 04 00 00       	call   d5b <fork>
     865:	85 c0                	test   %eax,%eax
     867:	75 5f                	jne    8c8 <test_cfs_fork+0xc8>
        set_cfs_priority(1);
     869:	83 ec 0c             	sub    $0xc,%esp
     86c:	6a 01                	push   $0x1
     86e:	e8 a8 05 00 00       	call   e1b <set_cfs_priority>
        int pid = getpid();
     873:	e8 6b 05 00 00       	call   de3 <getpid>
        printf(1, "PARENT: %d -> high+not sleeping\n", pid);
     878:	83 c4 0c             	add    $0xc,%esp
     87b:	50                   	push   %eax
     87c:	68 1c 15 00 00       	push   $0x151c
     881:	6a 01                	push   $0x1
     883:	e8 58 06 00 00       	call   ee0 <printf>
        if (fork()==0) {
     888:	e8 ce 04 00 00       	call   d5b <fork>
     88d:	83 c4 10             	add    $0x10,%esp
     890:	85 c0                	test   %eax,%eax
     892:	75 7c                	jne    910 <test_cfs_fork+0x110>
                int pid = getpid();
     894:	e8 4a 05 00 00       	call   de3 <getpid>
                printf(1, "CHILD: %d -> high+not sleeping\n", pid);
     899:	83 ec 04             	sub    $0x4,%esp
     89c:	50                   	push   %eax
     89d:	68 40 15 00 00       	push   $0x1540
                printf(1, "CHILD: %d -> low+not sleeping\n", pid);
     8a2:	6a 01                	push   $0x1
     8a4:	e8 37 06 00 00       	call   ee0 <printf>
                cfs_proc_task(-1, FIB_NO_SLEEP);
     8a9:	58                   	pop    %eax
     8aa:	5a                   	pop    %edx
     8ab:	6a 02                	push   $0x2
     8ad:	6a ff                	push   $0xffffffff
     8af:	e8 cc fd ff ff       	call   680 <cfs_proc_task>
     8b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cfs_parent_task(FIB_SLEEP);
     8b8:	83 ec 0c             	sub    $0xc,%esp
     8bb:	6a 01                	push   $0x1
     8bd:	e8 ae fb ff ff       	call   470 <ps_parent_task>
     8c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (fork() == 0) {
     8c8:	e8 8e 04 00 00       	call   d5b <fork>
     8cd:	85 c0                	test   %eax,%eax
     8cf:	75 4f                	jne    920 <test_cfs_fork+0x120>
        set_cfs_priority(3);
     8d1:	83 ec 0c             	sub    $0xc,%esp
     8d4:	6a 03                	push   $0x3
     8d6:	e8 40 05 00 00       	call   e1b <set_cfs_priority>
        int pid = getpid();
     8db:	e8 03 05 00 00       	call   de3 <getpid>
        printf(1, "PARENT: %d -> low+not sleeping\n", pid);
     8e0:	83 c4 0c             	add    $0xc,%esp
     8e3:	50                   	push   %eax
     8e4:	68 60 15 00 00       	push   $0x1560
     8e9:	6a 01                	push   $0x1
     8eb:	e8 f0 05 00 00       	call   ee0 <printf>
        if (fork()==0) {
     8f0:	e8 66 04 00 00       	call   d5b <fork>
     8f5:	83 c4 10             	add    $0x10,%esp
     8f8:	85 c0                	test   %eax,%eax
     8fa:	75 bc                	jne    8b8 <test_cfs_fork+0xb8>
                int pid = getpid();
     8fc:	e8 e2 04 00 00       	call   de3 <getpid>
                printf(1, "CHILD: %d -> low+sleeping\n", pid);
     901:	83 ec 04             	sub    $0x4,%esp
     904:	50                   	push   %eax
     905:	68 4b 13 00 00       	push   $0x134b
     90a:	e9 3d ff ff ff       	jmp    84c <test_cfs_fork+0x4c>
     90f:	90                   	nop
        cfs_parent_task(FIB_NO_SLEEP);
     910:	83 ec 0c             	sub    $0xc,%esp
     913:	6a 02                	push   $0x2
     915:	e8 56 fb ff ff       	call   470 <ps_parent_task>
     91a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (fork() == 0) {
     920:	e8 36 04 00 00       	call   d5b <fork>
     925:	85 c0                	test   %eax,%eax
     927:	74 37                	je     960 <test_cfs_fork+0x160>
        wait(null);
     929:	83 ec 0c             	sub    $0xc,%esp
     92c:	6a 00                	push   $0x0
     92e:	e8 38 04 00 00       	call   d6b <wait>
     933:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     93a:	e8 2c 04 00 00       	call   d6b <wait>
     93f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     946:	e8 20 04 00 00       	call   d6b <wait>
     94b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     952:	e8 14 04 00 00       	call   d6b <wait>
}
     957:	c9                   	leave  
     958:	c3                   	ret    
     959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        set_cfs_priority(3);
     960:	83 ec 0c             	sub    $0xc,%esp
     963:	6a 03                	push   $0x3
     965:	e8 b1 04 00 00       	call   e1b <set_cfs_priority>
        int pid = getpid();
     96a:	e8 74 04 00 00       	call   de3 <getpid>
        printf(1, "proc num: %d -> low+not sleeping\n", pid);
     96f:	83 c4 0c             	add    $0xc,%esp
     972:	50                   	push   %eax
     973:	68 ac 14 00 00       	push   $0x14ac
     978:	6a 01                	push   $0x1
     97a:	e8 61 05 00 00       	call   ee0 <printf>
        if (fork()==0) {
     97f:	e8 d7 03 00 00       	call   d5b <fork>
     984:	83 c4 10             	add    $0x10,%esp
     987:	85 c0                	test   %eax,%eax
     989:	75 85                	jne    910 <test_cfs_fork+0x110>
                int pid = getpid();
     98b:	e8 53 04 00 00       	call   de3 <getpid>
                printf(1, "CHILD: %d -> low+not sleeping\n", pid);
     990:	83 ec 04             	sub    $0x4,%esp
     993:	50                   	push   %eax
     994:	68 80 15 00 00       	push   $0x1580
     999:	e9 04 ff ff ff       	jmp    8a2 <test_cfs_fork+0xa2>
     99e:	66 90                	xchg   %ax,%ax

000009a0 <run_test>:
void run_test (int test_num) {
     9a0:	f3 0f 1e fb          	endbr32 
     9a4:	55                   	push   %ebp
     9a5:	89 e5                	mov    %esp,%ebp
     9a7:	53                   	push   %ebx
     9a8:	83 ec 08             	sub    $0x8,%esp
     9ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
    printf(1, "****************** Test Num: %d ******************\n", test_num);
     9ae:	53                   	push   %ebx
     9af:	68 a0 15 00 00       	push   $0x15a0
     9b4:	6a 01                	push   $0x1
     9b6:	e8 25 05 00 00       	call   ee0 <printf>
    switch (test_num) {
     9bb:	83 c4 10             	add    $0x10,%esp
     9be:	83 fb 07             	cmp    $0x7,%ebx
     9c1:	77 1f                	ja     9e2 <run_test+0x42>
     9c3:	3e ff 24 9d 20 16 00 	notrack jmp *0x1620(,%ebx,4)
     9ca:	00 
     9cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     9cf:	90                   	nop
            policy(2);
     9d0:	83 ec 0c             	sub    $0xc,%esp
     9d3:	6a 02                	push   $0x2
     9d5:	e8 39 04 00 00       	call   e13 <policy>
            test_cfs_fork();
     9da:	e8 21 fe ff ff       	call   800 <test_cfs_fork>
            break;
     9df:	83 c4 10             	add    $0x10,%esp
    printf(1, "****************** Finished, please check yourself ******************\n \n");
     9e2:	83 ec 08             	sub    $0x8,%esp
     9e5:	68 d4 15 00 00       	push   $0x15d4
     9ea:	6a 01                	push   $0x1
     9ec:	e8 ef 04 00 00       	call   ee0 <printf>
}
     9f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     9f4:	83 c4 10             	add    $0x10,%esp
     9f7:	c9                   	leave  
     9f8:	c3                   	ret    
     9f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            test_ps_sys_call();
     a00:	e8 4b f6 ff ff       	call   50 <test_ps_sys_call>
            break;
     a05:	eb db                	jmp    9e2 <run_test+0x42>
     a07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     a0e:	66 90                	xchg   %ax,%ax
            test_cfs_sys_call();
     a10:	e8 0b f7 ff ff       	call   120 <test_cfs_sys_call>
            break;
     a15:	eb cb                	jmp    9e2 <run_test+0x42>
     a17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     a1e:	66 90                	xchg   %ax,%ax
            policy(1);
     a20:	83 ec 0c             	sub    $0xc,%esp
     a23:	6a 01                	push   $0x1
     a25:	e8 e9 03 00 00       	call   e13 <policy>
            test_ps();
     a2a:	e8 11 f9 ff ff       	call   340 <test_ps>
            break;
     a2f:	83 c4 10             	add    $0x10,%esp
     a32:	eb ae                	jmp    9e2 <run_test+0x42>
     a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            policy(1);
     a38:	83 ec 0c             	sub    $0xc,%esp
     a3b:	6a 01                	push   $0x1
     a3d:	e8 d1 03 00 00       	call   e13 <policy>
            test_ps_fork1();
     a42:	e8 69 fa ff ff       	call   4b0 <test_ps_fork1>
            break;
     a47:	83 c4 10             	add    $0x10,%esp
     a4a:	eb 96                	jmp    9e2 <run_test+0x42>
     a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            policy(1);
     a50:	83 ec 0c             	sub    $0xc,%esp
     a53:	6a 01                	push   $0x1
     a55:	e8 b9 03 00 00       	call   e13 <policy>
            test_ps_fork2();
     a5a:	e8 11 fb ff ff       	call   570 <test_ps_fork2>
            break;
     a5f:	83 c4 10             	add    $0x10,%esp
     a62:	e9 7b ff ff ff       	jmp    9e2 <run_test+0x42>
     a67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     a6e:	66 90                	xchg   %ax,%ax
            policy(2);
     a70:	83 ec 0c             	sub    $0xc,%esp
     a73:	6a 02                	push   $0x2
     a75:	e8 99 03 00 00       	call   e13 <policy>
            test_cfs();
     a7a:	e8 51 fc ff ff       	call   6d0 <test_cfs>
            break;
     a7f:	83 c4 10             	add    $0x10,%esp
     a82:	e9 5b ff ff ff       	jmp    9e2 <run_test+0x42>
     a87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     a8e:	66 90                	xchg   %ax,%ax

00000a90 <main1>:
{   
     a90:	f3 0f 1e fb          	endbr32 
     a94:	55                   	push   %ebp
     a95:	89 e5                	mov    %esp,%ebp
     a97:	83 ec 14             	sub    $0x14,%esp
    run_test(1);
     a9a:	6a 01                	push   $0x1
     a9c:	e8 ff fe ff ff       	call   9a0 <run_test>
    run_test(2);
     aa1:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     aa8:	e8 f3 fe ff ff       	call   9a0 <run_test>
    run_test(3);
     aad:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
     ab4:	e8 e7 fe ff ff       	call   9a0 <run_test>
    run_test(4);
     ab9:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
     ac0:	e8 db fe ff ff       	call   9a0 <run_test>
    run_test(5);
     ac5:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     acc:	e8 cf fe ff ff       	call   9a0 <run_test>
    run_test(6);
     ad1:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
     ad8:	e8 c3 fe ff ff       	call   9a0 <run_test>
    run_test(7);
     add:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
     ae4:	e8 b7 fe ff ff       	call   9a0 <run_test>
    exit(0);
     ae9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     af0:	e8 6e 02 00 00       	call   d63 <exit>
     af5:	66 90                	xchg   %ax,%ax
     af7:	66 90                	xchg   %ax,%ax
     af9:	66 90                	xchg   %ax,%ax
     afb:	66 90                	xchg   %ax,%ax
     afd:	66 90                	xchg   %ax,%ax
     aff:	90                   	nop

00000b00 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
     b00:	f3 0f 1e fb          	endbr32 
     b04:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     b05:	31 c0                	xor    %eax,%eax
{
     b07:	89 e5                	mov    %esp,%ebp
     b09:	53                   	push   %ebx
     b0a:	8b 4d 08             	mov    0x8(%ebp),%ecx
     b0d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
     b10:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
     b14:	88 14 01             	mov    %dl,(%ecx,%eax,1)
     b17:	83 c0 01             	add    $0x1,%eax
     b1a:	84 d2                	test   %dl,%dl
     b1c:	75 f2                	jne    b10 <strcpy+0x10>
    ;
  return os;
}
     b1e:	89 c8                	mov    %ecx,%eax
     b20:	5b                   	pop    %ebx
     b21:	5d                   	pop    %ebp
     b22:	c3                   	ret    
     b23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000b30 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     b30:	f3 0f 1e fb          	endbr32 
     b34:	55                   	push   %ebp
     b35:	89 e5                	mov    %esp,%ebp
     b37:	53                   	push   %ebx
     b38:	8b 4d 08             	mov    0x8(%ebp),%ecx
     b3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
     b3e:	0f b6 01             	movzbl (%ecx),%eax
     b41:	0f b6 1a             	movzbl (%edx),%ebx
     b44:	84 c0                	test   %al,%al
     b46:	75 19                	jne    b61 <strcmp+0x31>
     b48:	eb 26                	jmp    b70 <strcmp+0x40>
     b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     b50:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
     b54:	83 c1 01             	add    $0x1,%ecx
     b57:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
     b5a:	0f b6 1a             	movzbl (%edx),%ebx
     b5d:	84 c0                	test   %al,%al
     b5f:	74 0f                	je     b70 <strcmp+0x40>
     b61:	38 d8                	cmp    %bl,%al
     b63:	74 eb                	je     b50 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
     b65:	29 d8                	sub    %ebx,%eax
}
     b67:	5b                   	pop    %ebx
     b68:	5d                   	pop    %ebp
     b69:	c3                   	ret    
     b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     b70:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
     b72:	29 d8                	sub    %ebx,%eax
}
     b74:	5b                   	pop    %ebx
     b75:	5d                   	pop    %ebp
     b76:	c3                   	ret    
     b77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     b7e:	66 90                	xchg   %ax,%ax

00000b80 <strlen>:

uint
strlen(const char *s)
{
     b80:	f3 0f 1e fb          	endbr32 
     b84:	55                   	push   %ebp
     b85:	89 e5                	mov    %esp,%ebp
     b87:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
     b8a:	80 3a 00             	cmpb   $0x0,(%edx)
     b8d:	74 21                	je     bb0 <strlen+0x30>
     b8f:	31 c0                	xor    %eax,%eax
     b91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     b98:	83 c0 01             	add    $0x1,%eax
     b9b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
     b9f:	89 c1                	mov    %eax,%ecx
     ba1:	75 f5                	jne    b98 <strlen+0x18>
    ;
  return n;
}
     ba3:	89 c8                	mov    %ecx,%eax
     ba5:	5d                   	pop    %ebp
     ba6:	c3                   	ret    
     ba7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     bae:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
     bb0:	31 c9                	xor    %ecx,%ecx
}
     bb2:	5d                   	pop    %ebp
     bb3:	89 c8                	mov    %ecx,%eax
     bb5:	c3                   	ret    
     bb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     bbd:	8d 76 00             	lea    0x0(%esi),%esi

00000bc0 <memset>:

void*
memset(void *dst, int c, uint n)
{
     bc0:	f3 0f 1e fb          	endbr32 
     bc4:	55                   	push   %ebp
     bc5:	89 e5                	mov    %esp,%ebp
     bc7:	57                   	push   %edi
     bc8:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
     bcb:	8b 4d 10             	mov    0x10(%ebp),%ecx
     bce:	8b 45 0c             	mov    0xc(%ebp),%eax
     bd1:	89 d7                	mov    %edx,%edi
     bd3:	fc                   	cld    
     bd4:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
     bd6:	89 d0                	mov    %edx,%eax
     bd8:	5f                   	pop    %edi
     bd9:	5d                   	pop    %ebp
     bda:	c3                   	ret    
     bdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     bdf:	90                   	nop

00000be0 <strchr>:

char*
strchr(const char *s, char c)
{
     be0:	f3 0f 1e fb          	endbr32 
     be4:	55                   	push   %ebp
     be5:	89 e5                	mov    %esp,%ebp
     be7:	8b 45 08             	mov    0x8(%ebp),%eax
     bea:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
     bee:	0f b6 10             	movzbl (%eax),%edx
     bf1:	84 d2                	test   %dl,%dl
     bf3:	75 16                	jne    c0b <strchr+0x2b>
     bf5:	eb 21                	jmp    c18 <strchr+0x38>
     bf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     bfe:	66 90                	xchg   %ax,%ax
     c00:	0f b6 50 01          	movzbl 0x1(%eax),%edx
     c04:	83 c0 01             	add    $0x1,%eax
     c07:	84 d2                	test   %dl,%dl
     c09:	74 0d                	je     c18 <strchr+0x38>
    if(*s == c)
     c0b:	38 d1                	cmp    %dl,%cl
     c0d:	75 f1                	jne    c00 <strchr+0x20>
      return (char*)s;
  return 0;
}
     c0f:	5d                   	pop    %ebp
     c10:	c3                   	ret    
     c11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
     c18:	31 c0                	xor    %eax,%eax
}
     c1a:	5d                   	pop    %ebp
     c1b:	c3                   	ret    
     c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000c20 <gets>:

char*
gets(char *buf, int max)
{
     c20:	f3 0f 1e fb          	endbr32 
     c24:	55                   	push   %ebp
     c25:	89 e5                	mov    %esp,%ebp
     c27:	57                   	push   %edi
     c28:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c29:	31 f6                	xor    %esi,%esi
{
     c2b:	53                   	push   %ebx
     c2c:	89 f3                	mov    %esi,%ebx
     c2e:	83 ec 1c             	sub    $0x1c,%esp
     c31:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
     c34:	eb 33                	jmp    c69 <gets+0x49>
     c36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     c3d:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
     c40:	83 ec 04             	sub    $0x4,%esp
     c43:	8d 45 e7             	lea    -0x19(%ebp),%eax
     c46:	6a 01                	push   $0x1
     c48:	50                   	push   %eax
     c49:	6a 00                	push   $0x0
     c4b:	e8 2b 01 00 00       	call   d7b <read>
    if(cc < 1)
     c50:	83 c4 10             	add    $0x10,%esp
     c53:	85 c0                	test   %eax,%eax
     c55:	7e 1c                	jle    c73 <gets+0x53>
      break;
    buf[i++] = c;
     c57:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
     c5b:	83 c7 01             	add    $0x1,%edi
     c5e:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
     c61:	3c 0a                	cmp    $0xa,%al
     c63:	74 23                	je     c88 <gets+0x68>
     c65:	3c 0d                	cmp    $0xd,%al
     c67:	74 1f                	je     c88 <gets+0x68>
  for(i=0; i+1 < max; ){
     c69:	83 c3 01             	add    $0x1,%ebx
     c6c:	89 fe                	mov    %edi,%esi
     c6e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
     c71:	7c cd                	jl     c40 <gets+0x20>
     c73:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
     c75:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
     c78:	c6 03 00             	movb   $0x0,(%ebx)
}
     c7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
     c7e:	5b                   	pop    %ebx
     c7f:	5e                   	pop    %esi
     c80:	5f                   	pop    %edi
     c81:	5d                   	pop    %ebp
     c82:	c3                   	ret    
     c83:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     c87:	90                   	nop
     c88:	8b 75 08             	mov    0x8(%ebp),%esi
     c8b:	8b 45 08             	mov    0x8(%ebp),%eax
     c8e:	01 de                	add    %ebx,%esi
     c90:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
     c92:	c6 03 00             	movb   $0x0,(%ebx)
}
     c95:	8d 65 f4             	lea    -0xc(%ebp),%esp
     c98:	5b                   	pop    %ebx
     c99:	5e                   	pop    %esi
     c9a:	5f                   	pop    %edi
     c9b:	5d                   	pop    %ebp
     c9c:	c3                   	ret    
     c9d:	8d 76 00             	lea    0x0(%esi),%esi

00000ca0 <stat>:

int
stat(const char *n, struct stat *st)
{
     ca0:	f3 0f 1e fb          	endbr32 
     ca4:	55                   	push   %ebp
     ca5:	89 e5                	mov    %esp,%ebp
     ca7:	56                   	push   %esi
     ca8:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     ca9:	83 ec 08             	sub    $0x8,%esp
     cac:	6a 00                	push   $0x0
     cae:	ff 75 08             	pushl  0x8(%ebp)
     cb1:	e8 ed 00 00 00       	call   da3 <open>
  if(fd < 0)
     cb6:	83 c4 10             	add    $0x10,%esp
     cb9:	85 c0                	test   %eax,%eax
     cbb:	78 2b                	js     ce8 <stat+0x48>
    return -1;
  r = fstat(fd, st);
     cbd:	83 ec 08             	sub    $0x8,%esp
     cc0:	ff 75 0c             	pushl  0xc(%ebp)
     cc3:	89 c3                	mov    %eax,%ebx
     cc5:	50                   	push   %eax
     cc6:	e8 f0 00 00 00       	call   dbb <fstat>
  close(fd);
     ccb:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
     cce:	89 c6                	mov    %eax,%esi
  close(fd);
     cd0:	e8 b6 00 00 00       	call   d8b <close>
  return r;
     cd5:	83 c4 10             	add    $0x10,%esp
}
     cd8:	8d 65 f8             	lea    -0x8(%ebp),%esp
     cdb:	89 f0                	mov    %esi,%eax
     cdd:	5b                   	pop    %ebx
     cde:	5e                   	pop    %esi
     cdf:	5d                   	pop    %ebp
     ce0:	c3                   	ret    
     ce1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
     ce8:	be ff ff ff ff       	mov    $0xffffffff,%esi
     ced:	eb e9                	jmp    cd8 <stat+0x38>
     cef:	90                   	nop

00000cf0 <atoi>:

int
atoi(const char *s)
{
     cf0:	f3 0f 1e fb          	endbr32 
     cf4:	55                   	push   %ebp
     cf5:	89 e5                	mov    %esp,%ebp
     cf7:	53                   	push   %ebx
     cf8:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     cfb:	0f be 02             	movsbl (%edx),%eax
     cfe:	8d 48 d0             	lea    -0x30(%eax),%ecx
     d01:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
     d04:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
     d09:	77 1a                	ja     d25 <atoi+0x35>
     d0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     d0f:	90                   	nop
    n = n*10 + *s++ - '0';
     d10:	83 c2 01             	add    $0x1,%edx
     d13:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
     d16:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
     d1a:	0f be 02             	movsbl (%edx),%eax
     d1d:	8d 58 d0             	lea    -0x30(%eax),%ebx
     d20:	80 fb 09             	cmp    $0x9,%bl
     d23:	76 eb                	jbe    d10 <atoi+0x20>
  return n;
}
     d25:	89 c8                	mov    %ecx,%eax
     d27:	5b                   	pop    %ebx
     d28:	5d                   	pop    %ebp
     d29:	c3                   	ret    
     d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000d30 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     d30:	f3 0f 1e fb          	endbr32 
     d34:	55                   	push   %ebp
     d35:	89 e5                	mov    %esp,%ebp
     d37:	57                   	push   %edi
     d38:	8b 45 10             	mov    0x10(%ebp),%eax
     d3b:	8b 55 08             	mov    0x8(%ebp),%edx
     d3e:	56                   	push   %esi
     d3f:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     d42:	85 c0                	test   %eax,%eax
     d44:	7e 0f                	jle    d55 <memmove+0x25>
     d46:	01 d0                	add    %edx,%eax
  dst = vdst;
     d48:	89 d7                	mov    %edx,%edi
     d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
     d50:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
     d51:	39 f8                	cmp    %edi,%eax
     d53:	75 fb                	jne    d50 <memmove+0x20>
  return vdst;
}
     d55:	5e                   	pop    %esi
     d56:	89 d0                	mov    %edx,%eax
     d58:	5f                   	pop    %edi
     d59:	5d                   	pop    %ebp
     d5a:	c3                   	ret    

00000d5b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     d5b:	b8 01 00 00 00       	mov    $0x1,%eax
     d60:	cd 40                	int    $0x40
     d62:	c3                   	ret    

00000d63 <exit>:
SYSCALL(exit)
     d63:	b8 02 00 00 00       	mov    $0x2,%eax
     d68:	cd 40                	int    $0x40
     d6a:	c3                   	ret    

00000d6b <wait>:
SYSCALL(wait)
     d6b:	b8 03 00 00 00       	mov    $0x3,%eax
     d70:	cd 40                	int    $0x40
     d72:	c3                   	ret    

00000d73 <pipe>:
SYSCALL(pipe)
     d73:	b8 04 00 00 00       	mov    $0x4,%eax
     d78:	cd 40                	int    $0x40
     d7a:	c3                   	ret    

00000d7b <read>:
SYSCALL(read)
     d7b:	b8 05 00 00 00       	mov    $0x5,%eax
     d80:	cd 40                	int    $0x40
     d82:	c3                   	ret    

00000d83 <write>:
SYSCALL(write)
     d83:	b8 10 00 00 00       	mov    $0x10,%eax
     d88:	cd 40                	int    $0x40
     d8a:	c3                   	ret    

00000d8b <close>:
SYSCALL(close)
     d8b:	b8 15 00 00 00       	mov    $0x15,%eax
     d90:	cd 40                	int    $0x40
     d92:	c3                   	ret    

00000d93 <kill>:
SYSCALL(kill)
     d93:	b8 06 00 00 00       	mov    $0x6,%eax
     d98:	cd 40                	int    $0x40
     d9a:	c3                   	ret    

00000d9b <exec>:
SYSCALL(exec)
     d9b:	b8 07 00 00 00       	mov    $0x7,%eax
     da0:	cd 40                	int    $0x40
     da2:	c3                   	ret    

00000da3 <open>:
SYSCALL(open)
     da3:	b8 0f 00 00 00       	mov    $0xf,%eax
     da8:	cd 40                	int    $0x40
     daa:	c3                   	ret    

00000dab <mknod>:
SYSCALL(mknod)
     dab:	b8 11 00 00 00       	mov    $0x11,%eax
     db0:	cd 40                	int    $0x40
     db2:	c3                   	ret    

00000db3 <unlink>:
SYSCALL(unlink)
     db3:	b8 12 00 00 00       	mov    $0x12,%eax
     db8:	cd 40                	int    $0x40
     dba:	c3                   	ret    

00000dbb <fstat>:
SYSCALL(fstat)
     dbb:	b8 08 00 00 00       	mov    $0x8,%eax
     dc0:	cd 40                	int    $0x40
     dc2:	c3                   	ret    

00000dc3 <link>:
SYSCALL(link)
     dc3:	b8 13 00 00 00       	mov    $0x13,%eax
     dc8:	cd 40                	int    $0x40
     dca:	c3                   	ret    

00000dcb <mkdir>:
SYSCALL(mkdir)
     dcb:	b8 14 00 00 00       	mov    $0x14,%eax
     dd0:	cd 40                	int    $0x40
     dd2:	c3                   	ret    

00000dd3 <chdir>:
SYSCALL(chdir)
     dd3:	b8 09 00 00 00       	mov    $0x9,%eax
     dd8:	cd 40                	int    $0x40
     dda:	c3                   	ret    

00000ddb <dup>:
SYSCALL(dup)
     ddb:	b8 0a 00 00 00       	mov    $0xa,%eax
     de0:	cd 40                	int    $0x40
     de2:	c3                   	ret    

00000de3 <getpid>:
SYSCALL(getpid)
     de3:	b8 0b 00 00 00       	mov    $0xb,%eax
     de8:	cd 40                	int    $0x40
     dea:	c3                   	ret    

00000deb <sbrk>:
SYSCALL(sbrk)
     deb:	b8 0c 00 00 00       	mov    $0xc,%eax
     df0:	cd 40                	int    $0x40
     df2:	c3                   	ret    

00000df3 <sleep>:
SYSCALL(sleep)
     df3:	b8 0d 00 00 00       	mov    $0xd,%eax
     df8:	cd 40                	int    $0x40
     dfa:	c3                   	ret    

00000dfb <uptime>:
SYSCALL(uptime)
     dfb:	b8 0e 00 00 00       	mov    $0xe,%eax
     e00:	cd 40                	int    $0x40
     e02:	c3                   	ret    

00000e03 <memsize>:
SYSCALL(memsize)
     e03:	b8 16 00 00 00       	mov    $0x16,%eax
     e08:	cd 40                	int    $0x40
     e0a:	c3                   	ret    

00000e0b <set_ps_priority>:
SYSCALL(set_ps_priority)
     e0b:	b8 17 00 00 00       	mov    $0x17,%eax
     e10:	cd 40                	int    $0x40
     e12:	c3                   	ret    

00000e13 <policy>:
SYSCALL(policy)
     e13:	b8 18 00 00 00       	mov    $0x18,%eax
     e18:	cd 40                	int    $0x40
     e1a:	c3                   	ret    

00000e1b <set_cfs_priority>:
SYSCALL(set_cfs_priority)
     e1b:	b8 19 00 00 00       	mov    $0x19,%eax
     e20:	cd 40                	int    $0x40
     e22:	c3                   	ret    

00000e23 <proc_info>:
SYSCALL(proc_info)
     e23:	b8 1a 00 00 00       	mov    $0x1a,%eax
     e28:	cd 40                	int    $0x40
     e2a:	c3                   	ret    
     e2b:	66 90                	xchg   %ax,%ax
     e2d:	66 90                	xchg   %ax,%ax
     e2f:	90                   	nop

00000e30 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
     e30:	55                   	push   %ebp
     e31:	89 e5                	mov    %esp,%ebp
     e33:	57                   	push   %edi
     e34:	56                   	push   %esi
     e35:	53                   	push   %ebx
     e36:	83 ec 3c             	sub    $0x3c,%esp
     e39:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
     e3c:	89 d1                	mov    %edx,%ecx
{
     e3e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
     e41:	85 d2                	test   %edx,%edx
     e43:	0f 89 7f 00 00 00    	jns    ec8 <printint+0x98>
     e49:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
     e4d:	74 79                	je     ec8 <printint+0x98>
    neg = 1;
     e4f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
     e56:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
     e58:	31 db                	xor    %ebx,%ebx
     e5a:	8d 75 d7             	lea    -0x29(%ebp),%esi
     e5d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
     e60:	89 c8                	mov    %ecx,%eax
     e62:	31 d2                	xor    %edx,%edx
     e64:	89 cf                	mov    %ecx,%edi
     e66:	f7 75 c4             	divl   -0x3c(%ebp)
     e69:	0f b6 92 48 16 00 00 	movzbl 0x1648(%edx),%edx
     e70:	89 45 c0             	mov    %eax,-0x40(%ebp)
     e73:	89 d8                	mov    %ebx,%eax
     e75:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
     e78:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
     e7b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
     e7e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
     e81:	76 dd                	jbe    e60 <printint+0x30>
  if(neg)
     e83:	8b 4d bc             	mov    -0x44(%ebp),%ecx
     e86:	85 c9                	test   %ecx,%ecx
     e88:	74 0c                	je     e96 <printint+0x66>
    buf[i++] = '-';
     e8a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
     e8f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
     e91:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
     e96:	8b 7d b8             	mov    -0x48(%ebp),%edi
     e99:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
     e9d:	eb 07                	jmp    ea6 <printint+0x76>
     e9f:	90                   	nop
     ea0:	0f b6 13             	movzbl (%ebx),%edx
     ea3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
     ea6:	83 ec 04             	sub    $0x4,%esp
     ea9:	88 55 d7             	mov    %dl,-0x29(%ebp)
     eac:	6a 01                	push   $0x1
     eae:	56                   	push   %esi
     eaf:	57                   	push   %edi
     eb0:	e8 ce fe ff ff       	call   d83 <write>
  while(--i >= 0)
     eb5:	83 c4 10             	add    $0x10,%esp
     eb8:	39 de                	cmp    %ebx,%esi
     eba:	75 e4                	jne    ea0 <printint+0x70>
    putc(fd, buf[i]);
}
     ebc:	8d 65 f4             	lea    -0xc(%ebp),%esp
     ebf:	5b                   	pop    %ebx
     ec0:	5e                   	pop    %esi
     ec1:	5f                   	pop    %edi
     ec2:	5d                   	pop    %ebp
     ec3:	c3                   	ret    
     ec4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
     ec8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
     ecf:	eb 87                	jmp    e58 <printint+0x28>
     ed1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     ed8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     edf:	90                   	nop

00000ee0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
     ee0:	f3 0f 1e fb          	endbr32 
     ee4:	55                   	push   %ebp
     ee5:	89 e5                	mov    %esp,%ebp
     ee7:	57                   	push   %edi
     ee8:	56                   	push   %esi
     ee9:	53                   	push   %ebx
     eea:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     eed:	8b 75 0c             	mov    0xc(%ebp),%esi
     ef0:	0f b6 1e             	movzbl (%esi),%ebx
     ef3:	84 db                	test   %bl,%bl
     ef5:	0f 84 b4 00 00 00    	je     faf <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
     efb:	8d 45 10             	lea    0x10(%ebp),%eax
     efe:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
     f01:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
     f04:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
     f06:	89 45 d0             	mov    %eax,-0x30(%ebp)
     f09:	eb 33                	jmp    f3e <printf+0x5e>
     f0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     f0f:	90                   	nop
     f10:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
     f13:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
     f18:	83 f8 25             	cmp    $0x25,%eax
     f1b:	74 17                	je     f34 <printf+0x54>
  write(fd, &c, 1);
     f1d:	83 ec 04             	sub    $0x4,%esp
     f20:	88 5d e7             	mov    %bl,-0x19(%ebp)
     f23:	6a 01                	push   $0x1
     f25:	57                   	push   %edi
     f26:	ff 75 08             	pushl  0x8(%ebp)
     f29:	e8 55 fe ff ff       	call   d83 <write>
     f2e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
     f31:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
     f34:	0f b6 1e             	movzbl (%esi),%ebx
     f37:	83 c6 01             	add    $0x1,%esi
     f3a:	84 db                	test   %bl,%bl
     f3c:	74 71                	je     faf <printf+0xcf>
    c = fmt[i] & 0xff;
     f3e:	0f be cb             	movsbl %bl,%ecx
     f41:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
     f44:	85 d2                	test   %edx,%edx
     f46:	74 c8                	je     f10 <printf+0x30>
      }
    } else if(state == '%'){
     f48:	83 fa 25             	cmp    $0x25,%edx
     f4b:	75 e7                	jne    f34 <printf+0x54>
      if(c == 'd'){
     f4d:	83 f8 64             	cmp    $0x64,%eax
     f50:	0f 84 9a 00 00 00    	je     ff0 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
     f56:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
     f5c:	83 f9 70             	cmp    $0x70,%ecx
     f5f:	74 5f                	je     fc0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
     f61:	83 f8 73             	cmp    $0x73,%eax
     f64:	0f 84 d6 00 00 00    	je     1040 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     f6a:	83 f8 63             	cmp    $0x63,%eax
     f6d:	0f 84 8d 00 00 00    	je     1000 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
     f73:	83 f8 25             	cmp    $0x25,%eax
     f76:	0f 84 b4 00 00 00    	je     1030 <printf+0x150>
  write(fd, &c, 1);
     f7c:	83 ec 04             	sub    $0x4,%esp
     f7f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
     f83:	6a 01                	push   $0x1
     f85:	57                   	push   %edi
     f86:	ff 75 08             	pushl  0x8(%ebp)
     f89:	e8 f5 fd ff ff       	call   d83 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
     f8e:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
     f91:	83 c4 0c             	add    $0xc,%esp
     f94:	6a 01                	push   $0x1
     f96:	83 c6 01             	add    $0x1,%esi
     f99:	57                   	push   %edi
     f9a:	ff 75 08             	pushl  0x8(%ebp)
     f9d:	e8 e1 fd ff ff       	call   d83 <write>
  for(i = 0; fmt[i]; i++){
     fa2:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
     fa6:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
     fa9:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
     fab:	84 db                	test   %bl,%bl
     fad:	75 8f                	jne    f3e <printf+0x5e>
    }
  }
}
     faf:	8d 65 f4             	lea    -0xc(%ebp),%esp
     fb2:	5b                   	pop    %ebx
     fb3:	5e                   	pop    %esi
     fb4:	5f                   	pop    %edi
     fb5:	5d                   	pop    %ebp
     fb6:	c3                   	ret    
     fb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     fbe:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
     fc0:	83 ec 0c             	sub    $0xc,%esp
     fc3:	b9 10 00 00 00       	mov    $0x10,%ecx
     fc8:	6a 00                	push   $0x0
     fca:	8b 5d d0             	mov    -0x30(%ebp),%ebx
     fcd:	8b 45 08             	mov    0x8(%ebp),%eax
     fd0:	8b 13                	mov    (%ebx),%edx
     fd2:	e8 59 fe ff ff       	call   e30 <printint>
        ap++;
     fd7:	89 d8                	mov    %ebx,%eax
     fd9:	83 c4 10             	add    $0x10,%esp
      state = 0;
     fdc:	31 d2                	xor    %edx,%edx
        ap++;
     fde:	83 c0 04             	add    $0x4,%eax
     fe1:	89 45 d0             	mov    %eax,-0x30(%ebp)
     fe4:	e9 4b ff ff ff       	jmp    f34 <printf+0x54>
     fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
     ff0:	83 ec 0c             	sub    $0xc,%esp
     ff3:	b9 0a 00 00 00       	mov    $0xa,%ecx
     ff8:	6a 01                	push   $0x1
     ffa:	eb ce                	jmp    fca <printf+0xea>
     ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
    1000:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
    1003:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
    1006:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
    1008:	6a 01                	push   $0x1
        ap++;
    100a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
    100d:	57                   	push   %edi
    100e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
    1011:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    1014:	e8 6a fd ff ff       	call   d83 <write>
        ap++;
    1019:	89 5d d0             	mov    %ebx,-0x30(%ebp)
    101c:	83 c4 10             	add    $0x10,%esp
      state = 0;
    101f:	31 d2                	xor    %edx,%edx
    1021:	e9 0e ff ff ff       	jmp    f34 <printf+0x54>
    1026:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    102d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
    1030:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
    1033:	83 ec 04             	sub    $0x4,%esp
    1036:	e9 59 ff ff ff       	jmp    f94 <printf+0xb4>
    103b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    103f:	90                   	nop
        s = (char*)*ap;
    1040:	8b 45 d0             	mov    -0x30(%ebp),%eax
    1043:	8b 18                	mov    (%eax),%ebx
        ap++;
    1045:	83 c0 04             	add    $0x4,%eax
    1048:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
    104b:	85 db                	test   %ebx,%ebx
    104d:	74 17                	je     1066 <printf+0x186>
        while(*s != 0){
    104f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
    1052:	31 d2                	xor    %edx,%edx
        while(*s != 0){
    1054:	84 c0                	test   %al,%al
    1056:	0f 84 d8 fe ff ff    	je     f34 <printf+0x54>
    105c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    105f:	89 de                	mov    %ebx,%esi
    1061:	8b 5d 08             	mov    0x8(%ebp),%ebx
    1064:	eb 1a                	jmp    1080 <printf+0x1a0>
          s = "(null)";
    1066:	bb 40 16 00 00       	mov    $0x1640,%ebx
        while(*s != 0){
    106b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    106e:	b8 28 00 00 00       	mov    $0x28,%eax
    1073:	89 de                	mov    %ebx,%esi
    1075:	8b 5d 08             	mov    0x8(%ebp),%ebx
    1078:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    107f:	90                   	nop
  write(fd, &c, 1);
    1080:	83 ec 04             	sub    $0x4,%esp
          s++;
    1083:	83 c6 01             	add    $0x1,%esi
    1086:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    1089:	6a 01                	push   $0x1
    108b:	57                   	push   %edi
    108c:	53                   	push   %ebx
    108d:	e8 f1 fc ff ff       	call   d83 <write>
        while(*s != 0){
    1092:	0f b6 06             	movzbl (%esi),%eax
    1095:	83 c4 10             	add    $0x10,%esp
    1098:	84 c0                	test   %al,%al
    109a:	75 e4                	jne    1080 <printf+0x1a0>
    109c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
    109f:	31 d2                	xor    %edx,%edx
    10a1:	e9 8e fe ff ff       	jmp    f34 <printf+0x54>
    10a6:	66 90                	xchg   %ax,%ax
    10a8:	66 90                	xchg   %ax,%ax
    10aa:	66 90                	xchg   %ax,%ax
    10ac:	66 90                	xchg   %ax,%ax
    10ae:	66 90                	xchg   %ax,%ax

000010b0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    10b0:	f3 0f 1e fb          	endbr32 
    10b4:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    10b5:	a1 5c 1b 00 00       	mov    0x1b5c,%eax
{
    10ba:	89 e5                	mov    %esp,%ebp
    10bc:	57                   	push   %edi
    10bd:	56                   	push   %esi
    10be:	53                   	push   %ebx
    10bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
    10c2:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
    10c4:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    10c7:	39 c8                	cmp    %ecx,%eax
    10c9:	73 15                	jae    10e0 <free+0x30>
    10cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    10cf:	90                   	nop
    10d0:	39 d1                	cmp    %edx,%ecx
    10d2:	72 14                	jb     10e8 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    10d4:	39 d0                	cmp    %edx,%eax
    10d6:	73 10                	jae    10e8 <free+0x38>
{
    10d8:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    10da:	8b 10                	mov    (%eax),%edx
    10dc:	39 c8                	cmp    %ecx,%eax
    10de:	72 f0                	jb     10d0 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    10e0:	39 d0                	cmp    %edx,%eax
    10e2:	72 f4                	jb     10d8 <free+0x28>
    10e4:	39 d1                	cmp    %edx,%ecx
    10e6:	73 f0                	jae    10d8 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
    10e8:	8b 73 fc             	mov    -0x4(%ebx),%esi
    10eb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    10ee:	39 fa                	cmp    %edi,%edx
    10f0:	74 1e                	je     1110 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    10f2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    10f5:	8b 50 04             	mov    0x4(%eax),%edx
    10f8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    10fb:	39 f1                	cmp    %esi,%ecx
    10fd:	74 28                	je     1127 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    10ff:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
    1101:	5b                   	pop    %ebx
  freep = p;
    1102:	a3 5c 1b 00 00       	mov    %eax,0x1b5c
}
    1107:	5e                   	pop    %esi
    1108:	5f                   	pop    %edi
    1109:	5d                   	pop    %ebp
    110a:	c3                   	ret    
    110b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    110f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
    1110:	03 72 04             	add    0x4(%edx),%esi
    1113:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    1116:	8b 10                	mov    (%eax),%edx
    1118:	8b 12                	mov    (%edx),%edx
    111a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    111d:	8b 50 04             	mov    0x4(%eax),%edx
    1120:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    1123:	39 f1                	cmp    %esi,%ecx
    1125:	75 d8                	jne    10ff <free+0x4f>
    p->s.size += bp->s.size;
    1127:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
    112a:	a3 5c 1b 00 00       	mov    %eax,0x1b5c
    p->s.size += bp->s.size;
    112f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1132:	8b 53 f8             	mov    -0x8(%ebx),%edx
    1135:	89 10                	mov    %edx,(%eax)
}
    1137:	5b                   	pop    %ebx
    1138:	5e                   	pop    %esi
    1139:	5f                   	pop    %edi
    113a:	5d                   	pop    %ebp
    113b:	c3                   	ret    
    113c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001140 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1140:	f3 0f 1e fb          	endbr32 
    1144:	55                   	push   %ebp
    1145:	89 e5                	mov    %esp,%ebp
    1147:	57                   	push   %edi
    1148:	56                   	push   %esi
    1149:	53                   	push   %ebx
    114a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    114d:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    1150:	8b 3d 5c 1b 00 00    	mov    0x1b5c,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1156:	8d 70 07             	lea    0x7(%eax),%esi
    1159:	c1 ee 03             	shr    $0x3,%esi
    115c:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
    115f:	85 ff                	test   %edi,%edi
    1161:	0f 84 a9 00 00 00    	je     1210 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1167:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
    1169:	8b 48 04             	mov    0x4(%eax),%ecx
    116c:	39 f1                	cmp    %esi,%ecx
    116e:	73 6d                	jae    11dd <malloc+0x9d>
    1170:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
    1176:	bb 00 10 00 00       	mov    $0x1000,%ebx
    117b:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
    117e:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
    1185:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    1188:	eb 17                	jmp    11a1 <malloc+0x61>
    118a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1190:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
    1192:	8b 4a 04             	mov    0x4(%edx),%ecx
    1195:	39 f1                	cmp    %esi,%ecx
    1197:	73 4f                	jae    11e8 <malloc+0xa8>
    1199:	8b 3d 5c 1b 00 00    	mov    0x1b5c,%edi
    119f:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    11a1:	39 c7                	cmp    %eax,%edi
    11a3:	75 eb                	jne    1190 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
    11a5:	83 ec 0c             	sub    $0xc,%esp
    11a8:	ff 75 e4             	pushl  -0x1c(%ebp)
    11ab:	e8 3b fc ff ff       	call   deb <sbrk>
  if(p == (char*)-1)
    11b0:	83 c4 10             	add    $0x10,%esp
    11b3:	83 f8 ff             	cmp    $0xffffffff,%eax
    11b6:	74 1b                	je     11d3 <malloc+0x93>
  hp->s.size = nu;
    11b8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    11bb:	83 ec 0c             	sub    $0xc,%esp
    11be:	83 c0 08             	add    $0x8,%eax
    11c1:	50                   	push   %eax
    11c2:	e8 e9 fe ff ff       	call   10b0 <free>
  return freep;
    11c7:	a1 5c 1b 00 00       	mov    0x1b5c,%eax
      if((p = morecore(nunits)) == 0)
    11cc:	83 c4 10             	add    $0x10,%esp
    11cf:	85 c0                	test   %eax,%eax
    11d1:	75 bd                	jne    1190 <malloc+0x50>
        return 0;
  }
}
    11d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
    11d6:	31 c0                	xor    %eax,%eax
}
    11d8:	5b                   	pop    %ebx
    11d9:	5e                   	pop    %esi
    11da:	5f                   	pop    %edi
    11db:	5d                   	pop    %ebp
    11dc:	c3                   	ret    
    if(p->s.size >= nunits){
    11dd:	89 c2                	mov    %eax,%edx
    11df:	89 f8                	mov    %edi,%eax
    11e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
    11e8:	39 ce                	cmp    %ecx,%esi
    11ea:	74 54                	je     1240 <malloc+0x100>
        p->s.size -= nunits;
    11ec:	29 f1                	sub    %esi,%ecx
    11ee:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
    11f1:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
    11f4:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
    11f7:	a3 5c 1b 00 00       	mov    %eax,0x1b5c
}
    11fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
    11ff:	8d 42 08             	lea    0x8(%edx),%eax
}
    1202:	5b                   	pop    %ebx
    1203:	5e                   	pop    %esi
    1204:	5f                   	pop    %edi
    1205:	5d                   	pop    %ebp
    1206:	c3                   	ret    
    1207:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    120e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
    1210:	c7 05 5c 1b 00 00 60 	movl   $0x1b60,0x1b5c
    1217:	1b 00 00 
    base.s.size = 0;
    121a:	bf 60 1b 00 00       	mov    $0x1b60,%edi
    base.s.ptr = freep = prevp = &base;
    121f:	c7 05 60 1b 00 00 60 	movl   $0x1b60,0x1b60
    1226:	1b 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1229:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
    122b:	c7 05 64 1b 00 00 00 	movl   $0x0,0x1b64
    1232:	00 00 00 
    if(p->s.size >= nunits){
    1235:	e9 36 ff ff ff       	jmp    1170 <malloc+0x30>
    123a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
    1240:	8b 0a                	mov    (%edx),%ecx
    1242:	89 08                	mov    %ecx,(%eax)
    1244:	eb b1                	jmp    11f7 <malloc+0xb7>
