
_sanity:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char** agrv){
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	57                   	push   %edi
  12:	56                   	push   %esi
  13:	53                   	push   %ebx
  14:	51                   	push   %ecx
  15:	83 ec 40             	sub    $0x40,%esp
    printf(1, "PID  PS_PRIORITY STIME   RETIME  RTIME\n");
  18:	68 f8 08 00 00       	push   $0x8f8
  1d:	6a 01                	push   $0x1
  1f:	e8 6c 05 00 00       	call   590 <printf>
    int first_pid = fork();
  24:	e8 e2 03 00 00       	call   40b <fork>
    if (first_pid == 0){
  29:	83 c4 10             	add    $0x10,%esp
  2c:	85 c0                	test   %eax,%eax
  2e:	0f 85 8f 00 00 00    	jne    c3 <main+0xc3>
        int second_pid = fork();
  34:	e8 d2 03 00 00       	call   40b <fork>
        if (second_pid == 0){
  39:	85 c0                	test   %eax,%eax
  3b:	0f 84 9a 00 00 00    	je     db <main+0xdb>
            int status;
            wait(&status);
            printf(1, "%d       %d      %d       %d         %d\n", getpid(), info.ps_priority, info.stime, info.retime, info.rtime);
            exit(0);
        }
        set_cfs_priority(3);
  41:	83 ec 0c             	sub    $0xc,%esp
        set_ps_priority(10);
  44:	bb 80 f0 fa 02       	mov    $0x2faf080,%ebx
        set_cfs_priority(3);
  49:	6a 03                	push   $0x3
  4b:	e8 7b 04 00 00       	call   4cb <set_cfs_priority>
        set_ps_priority(10);
  50:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  57:	e8 5f 04 00 00       	call   4bb <set_ps_priority>
  5c:	83 c4 10             	add    $0x10,%esp
  5f:	90                   	nop
        int i = 50000000;
        int dummy = 0;
        while(i--){
            dummy+=i;
            printf(1, "");
  60:	83 ec 08             	sub    $0x8,%esp
  63:	68 79 09 00 00       	push   $0x979
  68:	6a 01                	push   $0x1
  6a:	e8 21 05 00 00       	call   590 <printf>
        while(i--){
  6f:	83 c4 10             	add    $0x10,%esp
  72:	83 eb 01             	sub    $0x1,%ebx
  75:	75 e9                	jne    60 <main+0x60>
        }
        struct perf info;
        proc_info(&info);
  77:	83 ec 0c             	sub    $0xc,%esp
  7a:	8d 45 d8             	lea    -0x28(%ebp),%eax
  7d:	50                   	push   %eax
  7e:	e8 50 04 00 00       	call   4d3 <proc_info>
        int status;
        wait(&status);
  83:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  86:	89 04 24             	mov    %eax,(%esp)
  89:	e8 8d 03 00 00       	call   41b <wait>
        printf(1, "%d       %d      %d       %d       %d\n", getpid(), info.ps_priority, info.stime, info.retime, info.rtime);
  8e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  91:	8b 7d e0             	mov    -0x20(%ebp),%edi
  94:	8b 75 dc             	mov    -0x24(%ebp),%esi
  97:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  9a:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  9d:	e8 f1 03 00 00       	call   493 <getpid>
  a2:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  a5:	83 c4 0c             	add    $0xc,%esp
  a8:	52                   	push   %edx
  a9:	57                   	push   %edi
  aa:	56                   	push   %esi
  ab:	53                   	push   %ebx
  ac:	50                   	push   %eax
  ad:	68 4c 09 00 00       	push   $0x94c
            printf(1, "%d       %d      %d       %d         %d\n", getpid(), info.ps_priority, info.stime, info.retime, info.rtime);
  b2:	6a 01                	push   $0x1
  b4:	e8 d7 04 00 00       	call   590 <printf>
            exit(0);
  b9:	83 c4 14             	add    $0x14,%esp
  bc:	6a 00                	push   $0x0
  be:	e8 50 03 00 00       	call   413 <exit>
        exit(0);
    }
    
    int status;
    wait(&status);
  c3:	83 ec 0c             	sub    $0xc,%esp
  c6:	8d 45 d8             	lea    -0x28(%ebp),%eax
  c9:	50                   	push   %eax
  ca:	e8 4c 03 00 00       	call   41b <wait>
    exit(0);
  cf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  d6:	e8 38 03 00 00       	call   413 <exit>
            int third_pid = fork();
  db:	e8 2b 03 00 00       	call   40b <fork>
            if (third_pid == 0){
  e0:	85 c0                	test   %eax,%eax
  e2:	75 49                	jne    12d <main+0x12d>
                set_cfs_priority(1);
  e4:	83 ec 0c             	sub    $0xc,%esp
                set_ps_priority(1);
  e7:	bb 80 f0 fa 02       	mov    $0x2faf080,%ebx
                set_cfs_priority(1);
  ec:	6a 01                	push   $0x1
  ee:	e8 d8 03 00 00       	call   4cb <set_cfs_priority>
                set_ps_priority(1);
  f3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  fa:	e8 bc 03 00 00       	call   4bb <set_ps_priority>
  ff:	83 c4 10             	add    $0x10,%esp
 102:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                    printf(1, "");
 108:	83 ec 08             	sub    $0x8,%esp
 10b:	68 79 09 00 00       	push   $0x979
 110:	6a 01                	push   $0x1
 112:	e8 79 04 00 00       	call   590 <printf>
                while(i--){
 117:	83 c4 10             	add    $0x10,%esp
 11a:	83 eb 01             	sub    $0x1,%ebx
 11d:	75 e9                	jne    108 <main+0x108>
                proc_info(&info);
 11f:	83 ec 0c             	sub    $0xc,%esp
 122:	8d 45 d8             	lea    -0x28(%ebp),%eax
 125:	50                   	push   %eax
 126:	e8 a8 03 00 00       	call   4d3 <proc_info>
                printf(1, "%d       %d      %d       %d         %d\n", getpid(), info.ps_priority, info.stime, info.retime, info.rtime);
 12b:	eb 51                	jmp    17e <main+0x17e>
            set_cfs_priority(2);
 12d:	83 ec 0c             	sub    $0xc,%esp
            set_ps_priority(5);
 130:	bb 80 f0 fa 02       	mov    $0x2faf080,%ebx
            set_cfs_priority(2);
 135:	6a 02                	push   $0x2
 137:	e8 8f 03 00 00       	call   4cb <set_cfs_priority>
            set_ps_priority(5);
 13c:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 143:	e8 73 03 00 00       	call   4bb <set_ps_priority>
 148:	83 c4 10             	add    $0x10,%esp
 14b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 14f:	90                   	nop
                printf(1, "");
 150:	83 ec 08             	sub    $0x8,%esp
 153:	68 79 09 00 00       	push   $0x979
 158:	6a 01                	push   $0x1
 15a:	e8 31 04 00 00       	call   590 <printf>
            while(i--){
 15f:	83 c4 10             	add    $0x10,%esp
 162:	83 eb 01             	sub    $0x1,%ebx
 165:	75 e9                	jne    150 <main+0x150>
            proc_info(&info);
 167:	83 ec 0c             	sub    $0xc,%esp
 16a:	8d 45 d8             	lea    -0x28(%ebp),%eax
 16d:	50                   	push   %eax
 16e:	e8 60 03 00 00       	call   4d3 <proc_info>
            wait(&status);
 173:	8d 45 d4             	lea    -0x2c(%ebp),%eax
 176:	89 04 24             	mov    %eax,(%esp)
 179:	e8 9d 02 00 00       	call   41b <wait>
            printf(1, "%d       %d      %d       %d         %d\n", getpid(), info.ps_priority, info.stime, info.retime, info.rtime);
 17e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 181:	8b 7d e0             	mov    -0x20(%ebp),%edi
 184:	8b 75 dc             	mov    -0x24(%ebp),%esi
 187:	8b 5d d8             	mov    -0x28(%ebp),%ebx
 18a:	89 55 c4             	mov    %edx,-0x3c(%ebp)
 18d:	e8 01 03 00 00       	call   493 <getpid>
 192:	8b 55 c4             	mov    -0x3c(%ebp),%edx
 195:	83 c4 0c             	add    $0xc,%esp
 198:	52                   	push   %edx
 199:	57                   	push   %edi
 19a:	56                   	push   %esi
 19b:	53                   	push   %ebx
 19c:	50                   	push   %eax
 19d:	68 20 09 00 00       	push   $0x920
 1a2:	e9 0b ff ff ff       	jmp    b2 <main+0xb2>
 1a7:	66 90                	xchg   %ax,%ax
 1a9:	66 90                	xchg   %ax,%ax
 1ab:	66 90                	xchg   %ax,%ax
 1ad:	66 90                	xchg   %ax,%ax
 1af:	90                   	nop

000001b0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 1b0:	f3 0f 1e fb          	endbr32 
 1b4:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1b5:	31 c0                	xor    %eax,%eax
{
 1b7:	89 e5                	mov    %esp,%ebp
 1b9:	53                   	push   %ebx
 1ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1bd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
 1c0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 1c4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 1c7:	83 c0 01             	add    $0x1,%eax
 1ca:	84 d2                	test   %dl,%dl
 1cc:	75 f2                	jne    1c0 <strcpy+0x10>
    ;
  return os;
}
 1ce:	89 c8                	mov    %ecx,%eax
 1d0:	5b                   	pop    %ebx
 1d1:	5d                   	pop    %ebp
 1d2:	c3                   	ret    
 1d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000001e0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1e0:	f3 0f 1e fb          	endbr32 
 1e4:	55                   	push   %ebp
 1e5:	89 e5                	mov    %esp,%ebp
 1e7:	53                   	push   %ebx
 1e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 1ee:	0f b6 01             	movzbl (%ecx),%eax
 1f1:	0f b6 1a             	movzbl (%edx),%ebx
 1f4:	84 c0                	test   %al,%al
 1f6:	75 19                	jne    211 <strcmp+0x31>
 1f8:	eb 26                	jmp    220 <strcmp+0x40>
 1fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 200:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 204:	83 c1 01             	add    $0x1,%ecx
 207:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 20a:	0f b6 1a             	movzbl (%edx),%ebx
 20d:	84 c0                	test   %al,%al
 20f:	74 0f                	je     220 <strcmp+0x40>
 211:	38 d8                	cmp    %bl,%al
 213:	74 eb                	je     200 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 215:	29 d8                	sub    %ebx,%eax
}
 217:	5b                   	pop    %ebx
 218:	5d                   	pop    %ebp
 219:	c3                   	ret    
 21a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 220:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 222:	29 d8                	sub    %ebx,%eax
}
 224:	5b                   	pop    %ebx
 225:	5d                   	pop    %ebp
 226:	c3                   	ret    
 227:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 22e:	66 90                	xchg   %ax,%ax

00000230 <strlen>:

uint
strlen(const char *s)
{
 230:	f3 0f 1e fb          	endbr32 
 234:	55                   	push   %ebp
 235:	89 e5                	mov    %esp,%ebp
 237:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 23a:	80 3a 00             	cmpb   $0x0,(%edx)
 23d:	74 21                	je     260 <strlen+0x30>
 23f:	31 c0                	xor    %eax,%eax
 241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 248:	83 c0 01             	add    $0x1,%eax
 24b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 24f:	89 c1                	mov    %eax,%ecx
 251:	75 f5                	jne    248 <strlen+0x18>
    ;
  return n;
}
 253:	89 c8                	mov    %ecx,%eax
 255:	5d                   	pop    %ebp
 256:	c3                   	ret    
 257:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 25e:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
 260:	31 c9                	xor    %ecx,%ecx
}
 262:	5d                   	pop    %ebp
 263:	89 c8                	mov    %ecx,%eax
 265:	c3                   	ret    
 266:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 26d:	8d 76 00             	lea    0x0(%esi),%esi

00000270 <memset>:

void*
memset(void *dst, int c, uint n)
{
 270:	f3 0f 1e fb          	endbr32 
 274:	55                   	push   %ebp
 275:	89 e5                	mov    %esp,%ebp
 277:	57                   	push   %edi
 278:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 27b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 27e:	8b 45 0c             	mov    0xc(%ebp),%eax
 281:	89 d7                	mov    %edx,%edi
 283:	fc                   	cld    
 284:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 286:	89 d0                	mov    %edx,%eax
 288:	5f                   	pop    %edi
 289:	5d                   	pop    %ebp
 28a:	c3                   	ret    
 28b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 28f:	90                   	nop

00000290 <strchr>:

char*
strchr(const char *s, char c)
{
 290:	f3 0f 1e fb          	endbr32 
 294:	55                   	push   %ebp
 295:	89 e5                	mov    %esp,%ebp
 297:	8b 45 08             	mov    0x8(%ebp),%eax
 29a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 29e:	0f b6 10             	movzbl (%eax),%edx
 2a1:	84 d2                	test   %dl,%dl
 2a3:	75 16                	jne    2bb <strchr+0x2b>
 2a5:	eb 21                	jmp    2c8 <strchr+0x38>
 2a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2ae:	66 90                	xchg   %ax,%ax
 2b0:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 2b4:	83 c0 01             	add    $0x1,%eax
 2b7:	84 d2                	test   %dl,%dl
 2b9:	74 0d                	je     2c8 <strchr+0x38>
    if(*s == c)
 2bb:	38 d1                	cmp    %dl,%cl
 2bd:	75 f1                	jne    2b0 <strchr+0x20>
      return (char*)s;
  return 0;
}
 2bf:	5d                   	pop    %ebp
 2c0:	c3                   	ret    
 2c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 2c8:	31 c0                	xor    %eax,%eax
}
 2ca:	5d                   	pop    %ebp
 2cb:	c3                   	ret    
 2cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000002d0 <gets>:

char*
gets(char *buf, int max)
{
 2d0:	f3 0f 1e fb          	endbr32 
 2d4:	55                   	push   %ebp
 2d5:	89 e5                	mov    %esp,%ebp
 2d7:	57                   	push   %edi
 2d8:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2d9:	31 f6                	xor    %esi,%esi
{
 2db:	53                   	push   %ebx
 2dc:	89 f3                	mov    %esi,%ebx
 2de:	83 ec 1c             	sub    $0x1c,%esp
 2e1:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 2e4:	eb 33                	jmp    319 <gets+0x49>
 2e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2ed:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 2f0:	83 ec 04             	sub    $0x4,%esp
 2f3:	8d 45 e7             	lea    -0x19(%ebp),%eax
 2f6:	6a 01                	push   $0x1
 2f8:	50                   	push   %eax
 2f9:	6a 00                	push   $0x0
 2fb:	e8 2b 01 00 00       	call   42b <read>
    if(cc < 1)
 300:	83 c4 10             	add    $0x10,%esp
 303:	85 c0                	test   %eax,%eax
 305:	7e 1c                	jle    323 <gets+0x53>
      break;
    buf[i++] = c;
 307:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 30b:	83 c7 01             	add    $0x1,%edi
 30e:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 311:	3c 0a                	cmp    $0xa,%al
 313:	74 23                	je     338 <gets+0x68>
 315:	3c 0d                	cmp    $0xd,%al
 317:	74 1f                	je     338 <gets+0x68>
  for(i=0; i+1 < max; ){
 319:	83 c3 01             	add    $0x1,%ebx
 31c:	89 fe                	mov    %edi,%esi
 31e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 321:	7c cd                	jl     2f0 <gets+0x20>
 323:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 325:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 328:	c6 03 00             	movb   $0x0,(%ebx)
}
 32b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 32e:	5b                   	pop    %ebx
 32f:	5e                   	pop    %esi
 330:	5f                   	pop    %edi
 331:	5d                   	pop    %ebp
 332:	c3                   	ret    
 333:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 337:	90                   	nop
 338:	8b 75 08             	mov    0x8(%ebp),%esi
 33b:	8b 45 08             	mov    0x8(%ebp),%eax
 33e:	01 de                	add    %ebx,%esi
 340:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 342:	c6 03 00             	movb   $0x0,(%ebx)
}
 345:	8d 65 f4             	lea    -0xc(%ebp),%esp
 348:	5b                   	pop    %ebx
 349:	5e                   	pop    %esi
 34a:	5f                   	pop    %edi
 34b:	5d                   	pop    %ebp
 34c:	c3                   	ret    
 34d:	8d 76 00             	lea    0x0(%esi),%esi

00000350 <stat>:

int
stat(const char *n, struct stat *st)
{
 350:	f3 0f 1e fb          	endbr32 
 354:	55                   	push   %ebp
 355:	89 e5                	mov    %esp,%ebp
 357:	56                   	push   %esi
 358:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 359:	83 ec 08             	sub    $0x8,%esp
 35c:	6a 00                	push   $0x0
 35e:	ff 75 08             	pushl  0x8(%ebp)
 361:	e8 ed 00 00 00       	call   453 <open>
  if(fd < 0)
 366:	83 c4 10             	add    $0x10,%esp
 369:	85 c0                	test   %eax,%eax
 36b:	78 2b                	js     398 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 36d:	83 ec 08             	sub    $0x8,%esp
 370:	ff 75 0c             	pushl  0xc(%ebp)
 373:	89 c3                	mov    %eax,%ebx
 375:	50                   	push   %eax
 376:	e8 f0 00 00 00       	call   46b <fstat>
  close(fd);
 37b:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 37e:	89 c6                	mov    %eax,%esi
  close(fd);
 380:	e8 b6 00 00 00       	call   43b <close>
  return r;
 385:	83 c4 10             	add    $0x10,%esp
}
 388:	8d 65 f8             	lea    -0x8(%ebp),%esp
 38b:	89 f0                	mov    %esi,%eax
 38d:	5b                   	pop    %ebx
 38e:	5e                   	pop    %esi
 38f:	5d                   	pop    %ebp
 390:	c3                   	ret    
 391:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 398:	be ff ff ff ff       	mov    $0xffffffff,%esi
 39d:	eb e9                	jmp    388 <stat+0x38>
 39f:	90                   	nop

000003a0 <atoi>:

int
atoi(const char *s)
{
 3a0:	f3 0f 1e fb          	endbr32 
 3a4:	55                   	push   %ebp
 3a5:	89 e5                	mov    %esp,%ebp
 3a7:	53                   	push   %ebx
 3a8:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3ab:	0f be 02             	movsbl (%edx),%eax
 3ae:	8d 48 d0             	lea    -0x30(%eax),%ecx
 3b1:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 3b4:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 3b9:	77 1a                	ja     3d5 <atoi+0x35>
 3bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3bf:	90                   	nop
    n = n*10 + *s++ - '0';
 3c0:	83 c2 01             	add    $0x1,%edx
 3c3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 3c6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 3ca:	0f be 02             	movsbl (%edx),%eax
 3cd:	8d 58 d0             	lea    -0x30(%eax),%ebx
 3d0:	80 fb 09             	cmp    $0x9,%bl
 3d3:	76 eb                	jbe    3c0 <atoi+0x20>
  return n;
}
 3d5:	89 c8                	mov    %ecx,%eax
 3d7:	5b                   	pop    %ebx
 3d8:	5d                   	pop    %ebp
 3d9:	c3                   	ret    
 3da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000003e0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3e0:	f3 0f 1e fb          	endbr32 
 3e4:	55                   	push   %ebp
 3e5:	89 e5                	mov    %esp,%ebp
 3e7:	57                   	push   %edi
 3e8:	8b 45 10             	mov    0x10(%ebp),%eax
 3eb:	8b 55 08             	mov    0x8(%ebp),%edx
 3ee:	56                   	push   %esi
 3ef:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3f2:	85 c0                	test   %eax,%eax
 3f4:	7e 0f                	jle    405 <memmove+0x25>
 3f6:	01 d0                	add    %edx,%eax
  dst = vdst;
 3f8:	89 d7                	mov    %edx,%edi
 3fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
 400:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 401:	39 f8                	cmp    %edi,%eax
 403:	75 fb                	jne    400 <memmove+0x20>
  return vdst;
}
 405:	5e                   	pop    %esi
 406:	89 d0                	mov    %edx,%eax
 408:	5f                   	pop    %edi
 409:	5d                   	pop    %ebp
 40a:	c3                   	ret    

0000040b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 40b:	b8 01 00 00 00       	mov    $0x1,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret    

00000413 <exit>:
SYSCALL(exit)
 413:	b8 02 00 00 00       	mov    $0x2,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret    

0000041b <wait>:
SYSCALL(wait)
 41b:	b8 03 00 00 00       	mov    $0x3,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret    

00000423 <pipe>:
SYSCALL(pipe)
 423:	b8 04 00 00 00       	mov    $0x4,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret    

0000042b <read>:
SYSCALL(read)
 42b:	b8 05 00 00 00       	mov    $0x5,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret    

00000433 <write>:
SYSCALL(write)
 433:	b8 10 00 00 00       	mov    $0x10,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret    

0000043b <close>:
SYSCALL(close)
 43b:	b8 15 00 00 00       	mov    $0x15,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret    

00000443 <kill>:
SYSCALL(kill)
 443:	b8 06 00 00 00       	mov    $0x6,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret    

0000044b <exec>:
SYSCALL(exec)
 44b:	b8 07 00 00 00       	mov    $0x7,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret    

00000453 <open>:
SYSCALL(open)
 453:	b8 0f 00 00 00       	mov    $0xf,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret    

0000045b <mknod>:
SYSCALL(mknod)
 45b:	b8 11 00 00 00       	mov    $0x11,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret    

00000463 <unlink>:
SYSCALL(unlink)
 463:	b8 12 00 00 00       	mov    $0x12,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret    

0000046b <fstat>:
SYSCALL(fstat)
 46b:	b8 08 00 00 00       	mov    $0x8,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret    

00000473 <link>:
SYSCALL(link)
 473:	b8 13 00 00 00       	mov    $0x13,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret    

0000047b <mkdir>:
SYSCALL(mkdir)
 47b:	b8 14 00 00 00       	mov    $0x14,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret    

00000483 <chdir>:
SYSCALL(chdir)
 483:	b8 09 00 00 00       	mov    $0x9,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret    

0000048b <dup>:
SYSCALL(dup)
 48b:	b8 0a 00 00 00       	mov    $0xa,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret    

00000493 <getpid>:
SYSCALL(getpid)
 493:	b8 0b 00 00 00       	mov    $0xb,%eax
 498:	cd 40                	int    $0x40
 49a:	c3                   	ret    

0000049b <sbrk>:
SYSCALL(sbrk)
 49b:	b8 0c 00 00 00       	mov    $0xc,%eax
 4a0:	cd 40                	int    $0x40
 4a2:	c3                   	ret    

000004a3 <sleep>:
SYSCALL(sleep)
 4a3:	b8 0d 00 00 00       	mov    $0xd,%eax
 4a8:	cd 40                	int    $0x40
 4aa:	c3                   	ret    

000004ab <uptime>:
SYSCALL(uptime)
 4ab:	b8 0e 00 00 00       	mov    $0xe,%eax
 4b0:	cd 40                	int    $0x40
 4b2:	c3                   	ret    

000004b3 <memsize>:
SYSCALL(memsize)
 4b3:	b8 16 00 00 00       	mov    $0x16,%eax
 4b8:	cd 40                	int    $0x40
 4ba:	c3                   	ret    

000004bb <set_ps_priority>:
SYSCALL(set_ps_priority)
 4bb:	b8 17 00 00 00       	mov    $0x17,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret    

000004c3 <policy>:
SYSCALL(policy)
 4c3:	b8 18 00 00 00       	mov    $0x18,%eax
 4c8:	cd 40                	int    $0x40
 4ca:	c3                   	ret    

000004cb <set_cfs_priority>:
SYSCALL(set_cfs_priority)
 4cb:	b8 19 00 00 00       	mov    $0x19,%eax
 4d0:	cd 40                	int    $0x40
 4d2:	c3                   	ret    

000004d3 <proc_info>:
SYSCALL(proc_info)
 4d3:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4d8:	cd 40                	int    $0x40
 4da:	c3                   	ret    
 4db:	66 90                	xchg   %ax,%ax
 4dd:	66 90                	xchg   %ax,%ax
 4df:	90                   	nop

000004e0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 4e0:	55                   	push   %ebp
 4e1:	89 e5                	mov    %esp,%ebp
 4e3:	57                   	push   %edi
 4e4:	56                   	push   %esi
 4e5:	53                   	push   %ebx
 4e6:	83 ec 3c             	sub    $0x3c,%esp
 4e9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 4ec:	89 d1                	mov    %edx,%ecx
{
 4ee:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 4f1:	85 d2                	test   %edx,%edx
 4f3:	0f 89 7f 00 00 00    	jns    578 <printint+0x98>
 4f9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 4fd:	74 79                	je     578 <printint+0x98>
    neg = 1;
 4ff:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 506:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 508:	31 db                	xor    %ebx,%ebx
 50a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 50d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 510:	89 c8                	mov    %ecx,%eax
 512:	31 d2                	xor    %edx,%edx
 514:	89 cf                	mov    %ecx,%edi
 516:	f7 75 c4             	divl   -0x3c(%ebp)
 519:	0f b6 92 7c 09 00 00 	movzbl 0x97c(%edx),%edx
 520:	89 45 c0             	mov    %eax,-0x40(%ebp)
 523:	89 d8                	mov    %ebx,%eax
 525:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 528:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 52b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 52e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 531:	76 dd                	jbe    510 <printint+0x30>
  if(neg)
 533:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 536:	85 c9                	test   %ecx,%ecx
 538:	74 0c                	je     546 <printint+0x66>
    buf[i++] = '-';
 53a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 53f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 541:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 546:	8b 7d b8             	mov    -0x48(%ebp),%edi
 549:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 54d:	eb 07                	jmp    556 <printint+0x76>
 54f:	90                   	nop
 550:	0f b6 13             	movzbl (%ebx),%edx
 553:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 556:	83 ec 04             	sub    $0x4,%esp
 559:	88 55 d7             	mov    %dl,-0x29(%ebp)
 55c:	6a 01                	push   $0x1
 55e:	56                   	push   %esi
 55f:	57                   	push   %edi
 560:	e8 ce fe ff ff       	call   433 <write>
  while(--i >= 0)
 565:	83 c4 10             	add    $0x10,%esp
 568:	39 de                	cmp    %ebx,%esi
 56a:	75 e4                	jne    550 <printint+0x70>
    putc(fd, buf[i]);
}
 56c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 56f:	5b                   	pop    %ebx
 570:	5e                   	pop    %esi
 571:	5f                   	pop    %edi
 572:	5d                   	pop    %ebp
 573:	c3                   	ret    
 574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 578:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 57f:	eb 87                	jmp    508 <printint+0x28>
 581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 588:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 58f:	90                   	nop

00000590 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 590:	f3 0f 1e fb          	endbr32 
 594:	55                   	push   %ebp
 595:	89 e5                	mov    %esp,%ebp
 597:	57                   	push   %edi
 598:	56                   	push   %esi
 599:	53                   	push   %ebx
 59a:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 59d:	8b 75 0c             	mov    0xc(%ebp),%esi
 5a0:	0f b6 1e             	movzbl (%esi),%ebx
 5a3:	84 db                	test   %bl,%bl
 5a5:	0f 84 b4 00 00 00    	je     65f <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
 5ab:	8d 45 10             	lea    0x10(%ebp),%eax
 5ae:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 5b1:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 5b4:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 5b6:	89 45 d0             	mov    %eax,-0x30(%ebp)
 5b9:	eb 33                	jmp    5ee <printf+0x5e>
 5bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 5bf:	90                   	nop
 5c0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 5c3:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 5c8:	83 f8 25             	cmp    $0x25,%eax
 5cb:	74 17                	je     5e4 <printf+0x54>
  write(fd, &c, 1);
 5cd:	83 ec 04             	sub    $0x4,%esp
 5d0:	88 5d e7             	mov    %bl,-0x19(%ebp)
 5d3:	6a 01                	push   $0x1
 5d5:	57                   	push   %edi
 5d6:	ff 75 08             	pushl  0x8(%ebp)
 5d9:	e8 55 fe ff ff       	call   433 <write>
 5de:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 5e1:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 5e4:	0f b6 1e             	movzbl (%esi),%ebx
 5e7:	83 c6 01             	add    $0x1,%esi
 5ea:	84 db                	test   %bl,%bl
 5ec:	74 71                	je     65f <printf+0xcf>
    c = fmt[i] & 0xff;
 5ee:	0f be cb             	movsbl %bl,%ecx
 5f1:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 5f4:	85 d2                	test   %edx,%edx
 5f6:	74 c8                	je     5c0 <printf+0x30>
      }
    } else if(state == '%'){
 5f8:	83 fa 25             	cmp    $0x25,%edx
 5fb:	75 e7                	jne    5e4 <printf+0x54>
      if(c == 'd'){
 5fd:	83 f8 64             	cmp    $0x64,%eax
 600:	0f 84 9a 00 00 00    	je     6a0 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 606:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 60c:	83 f9 70             	cmp    $0x70,%ecx
 60f:	74 5f                	je     670 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 611:	83 f8 73             	cmp    $0x73,%eax
 614:	0f 84 d6 00 00 00    	je     6f0 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 61a:	83 f8 63             	cmp    $0x63,%eax
 61d:	0f 84 8d 00 00 00    	je     6b0 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 623:	83 f8 25             	cmp    $0x25,%eax
 626:	0f 84 b4 00 00 00    	je     6e0 <printf+0x150>
  write(fd, &c, 1);
 62c:	83 ec 04             	sub    $0x4,%esp
 62f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 633:	6a 01                	push   $0x1
 635:	57                   	push   %edi
 636:	ff 75 08             	pushl  0x8(%ebp)
 639:	e8 f5 fd ff ff       	call   433 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 63e:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 641:	83 c4 0c             	add    $0xc,%esp
 644:	6a 01                	push   $0x1
 646:	83 c6 01             	add    $0x1,%esi
 649:	57                   	push   %edi
 64a:	ff 75 08             	pushl  0x8(%ebp)
 64d:	e8 e1 fd ff ff       	call   433 <write>
  for(i = 0; fmt[i]; i++){
 652:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 656:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 659:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 65b:	84 db                	test   %bl,%bl
 65d:	75 8f                	jne    5ee <printf+0x5e>
    }
  }
}
 65f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 662:	5b                   	pop    %ebx
 663:	5e                   	pop    %esi
 664:	5f                   	pop    %edi
 665:	5d                   	pop    %ebp
 666:	c3                   	ret    
 667:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 66e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 670:	83 ec 0c             	sub    $0xc,%esp
 673:	b9 10 00 00 00       	mov    $0x10,%ecx
 678:	6a 00                	push   $0x0
 67a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 67d:	8b 45 08             	mov    0x8(%ebp),%eax
 680:	8b 13                	mov    (%ebx),%edx
 682:	e8 59 fe ff ff       	call   4e0 <printint>
        ap++;
 687:	89 d8                	mov    %ebx,%eax
 689:	83 c4 10             	add    $0x10,%esp
      state = 0;
 68c:	31 d2                	xor    %edx,%edx
        ap++;
 68e:	83 c0 04             	add    $0x4,%eax
 691:	89 45 d0             	mov    %eax,-0x30(%ebp)
 694:	e9 4b ff ff ff       	jmp    5e4 <printf+0x54>
 699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 6a0:	83 ec 0c             	sub    $0xc,%esp
 6a3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 6a8:	6a 01                	push   $0x1
 6aa:	eb ce                	jmp    67a <printf+0xea>
 6ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 6b0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 6b3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 6b6:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 6b8:	6a 01                	push   $0x1
        ap++;
 6ba:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 6bd:	57                   	push   %edi
 6be:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 6c1:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 6c4:	e8 6a fd ff ff       	call   433 <write>
        ap++;
 6c9:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 6cc:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6cf:	31 d2                	xor    %edx,%edx
 6d1:	e9 0e ff ff ff       	jmp    5e4 <printf+0x54>
 6d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6dd:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 6e0:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 6e3:	83 ec 04             	sub    $0x4,%esp
 6e6:	e9 59 ff ff ff       	jmp    644 <printf+0xb4>
 6eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6ef:	90                   	nop
        s = (char*)*ap;
 6f0:	8b 45 d0             	mov    -0x30(%ebp),%eax
 6f3:	8b 18                	mov    (%eax),%ebx
        ap++;
 6f5:	83 c0 04             	add    $0x4,%eax
 6f8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 6fb:	85 db                	test   %ebx,%ebx
 6fd:	74 17                	je     716 <printf+0x186>
        while(*s != 0){
 6ff:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 702:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 704:	84 c0                	test   %al,%al
 706:	0f 84 d8 fe ff ff    	je     5e4 <printf+0x54>
 70c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 70f:	89 de                	mov    %ebx,%esi
 711:	8b 5d 08             	mov    0x8(%ebp),%ebx
 714:	eb 1a                	jmp    730 <printf+0x1a0>
          s = "(null)";
 716:	bb 73 09 00 00       	mov    $0x973,%ebx
        while(*s != 0){
 71b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 71e:	b8 28 00 00 00       	mov    $0x28,%eax
 723:	89 de                	mov    %ebx,%esi
 725:	8b 5d 08             	mov    0x8(%ebp),%ebx
 728:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 72f:	90                   	nop
  write(fd, &c, 1);
 730:	83 ec 04             	sub    $0x4,%esp
          s++;
 733:	83 c6 01             	add    $0x1,%esi
 736:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 739:	6a 01                	push   $0x1
 73b:	57                   	push   %edi
 73c:	53                   	push   %ebx
 73d:	e8 f1 fc ff ff       	call   433 <write>
        while(*s != 0){
 742:	0f b6 06             	movzbl (%esi),%eax
 745:	83 c4 10             	add    $0x10,%esp
 748:	84 c0                	test   %al,%al
 74a:	75 e4                	jne    730 <printf+0x1a0>
 74c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 74f:	31 d2                	xor    %edx,%edx
 751:	e9 8e fe ff ff       	jmp    5e4 <printf+0x54>
 756:	66 90                	xchg   %ax,%ax
 758:	66 90                	xchg   %ax,%ax
 75a:	66 90                	xchg   %ax,%ax
 75c:	66 90                	xchg   %ax,%ax
 75e:	66 90                	xchg   %ax,%ax

00000760 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 760:	f3 0f 1e fb          	endbr32 
 764:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 765:	a1 30 0c 00 00       	mov    0xc30,%eax
{
 76a:	89 e5                	mov    %esp,%ebp
 76c:	57                   	push   %edi
 76d:	56                   	push   %esi
 76e:	53                   	push   %ebx
 76f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 772:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 774:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 777:	39 c8                	cmp    %ecx,%eax
 779:	73 15                	jae    790 <free+0x30>
 77b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 77f:	90                   	nop
 780:	39 d1                	cmp    %edx,%ecx
 782:	72 14                	jb     798 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 784:	39 d0                	cmp    %edx,%eax
 786:	73 10                	jae    798 <free+0x38>
{
 788:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 78a:	8b 10                	mov    (%eax),%edx
 78c:	39 c8                	cmp    %ecx,%eax
 78e:	72 f0                	jb     780 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 790:	39 d0                	cmp    %edx,%eax
 792:	72 f4                	jb     788 <free+0x28>
 794:	39 d1                	cmp    %edx,%ecx
 796:	73 f0                	jae    788 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 798:	8b 73 fc             	mov    -0x4(%ebx),%esi
 79b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 79e:	39 fa                	cmp    %edi,%edx
 7a0:	74 1e                	je     7c0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 7a2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 7a5:	8b 50 04             	mov    0x4(%eax),%edx
 7a8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7ab:	39 f1                	cmp    %esi,%ecx
 7ad:	74 28                	je     7d7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 7af:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 7b1:	5b                   	pop    %ebx
  freep = p;
 7b2:	a3 30 0c 00 00       	mov    %eax,0xc30
}
 7b7:	5e                   	pop    %esi
 7b8:	5f                   	pop    %edi
 7b9:	5d                   	pop    %ebp
 7ba:	c3                   	ret    
 7bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 7bf:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 7c0:	03 72 04             	add    0x4(%edx),%esi
 7c3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 7c6:	8b 10                	mov    (%eax),%edx
 7c8:	8b 12                	mov    (%edx),%edx
 7ca:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 7cd:	8b 50 04             	mov    0x4(%eax),%edx
 7d0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7d3:	39 f1                	cmp    %esi,%ecx
 7d5:	75 d8                	jne    7af <free+0x4f>
    p->s.size += bp->s.size;
 7d7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 7da:	a3 30 0c 00 00       	mov    %eax,0xc30
    p->s.size += bp->s.size;
 7df:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7e2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 7e5:	89 10                	mov    %edx,(%eax)
}
 7e7:	5b                   	pop    %ebx
 7e8:	5e                   	pop    %esi
 7e9:	5f                   	pop    %edi
 7ea:	5d                   	pop    %ebp
 7eb:	c3                   	ret    
 7ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000007f0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7f0:	f3 0f 1e fb          	endbr32 
 7f4:	55                   	push   %ebp
 7f5:	89 e5                	mov    %esp,%ebp
 7f7:	57                   	push   %edi
 7f8:	56                   	push   %esi
 7f9:	53                   	push   %ebx
 7fa:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7fd:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 800:	8b 3d 30 0c 00 00    	mov    0xc30,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 806:	8d 70 07             	lea    0x7(%eax),%esi
 809:	c1 ee 03             	shr    $0x3,%esi
 80c:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 80f:	85 ff                	test   %edi,%edi
 811:	0f 84 a9 00 00 00    	je     8c0 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 817:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 819:	8b 48 04             	mov    0x4(%eax),%ecx
 81c:	39 f1                	cmp    %esi,%ecx
 81e:	73 6d                	jae    88d <malloc+0x9d>
 820:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 826:	bb 00 10 00 00       	mov    $0x1000,%ebx
 82b:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 82e:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 835:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 838:	eb 17                	jmp    851 <malloc+0x61>
 83a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 840:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 842:	8b 4a 04             	mov    0x4(%edx),%ecx
 845:	39 f1                	cmp    %esi,%ecx
 847:	73 4f                	jae    898 <malloc+0xa8>
 849:	8b 3d 30 0c 00 00    	mov    0xc30,%edi
 84f:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 851:	39 c7                	cmp    %eax,%edi
 853:	75 eb                	jne    840 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 855:	83 ec 0c             	sub    $0xc,%esp
 858:	ff 75 e4             	pushl  -0x1c(%ebp)
 85b:	e8 3b fc ff ff       	call   49b <sbrk>
  if(p == (char*)-1)
 860:	83 c4 10             	add    $0x10,%esp
 863:	83 f8 ff             	cmp    $0xffffffff,%eax
 866:	74 1b                	je     883 <malloc+0x93>
  hp->s.size = nu;
 868:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 86b:	83 ec 0c             	sub    $0xc,%esp
 86e:	83 c0 08             	add    $0x8,%eax
 871:	50                   	push   %eax
 872:	e8 e9 fe ff ff       	call   760 <free>
  return freep;
 877:	a1 30 0c 00 00       	mov    0xc30,%eax
      if((p = morecore(nunits)) == 0)
 87c:	83 c4 10             	add    $0x10,%esp
 87f:	85 c0                	test   %eax,%eax
 881:	75 bd                	jne    840 <malloc+0x50>
        return 0;
  }
}
 883:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 886:	31 c0                	xor    %eax,%eax
}
 888:	5b                   	pop    %ebx
 889:	5e                   	pop    %esi
 88a:	5f                   	pop    %edi
 88b:	5d                   	pop    %ebp
 88c:	c3                   	ret    
    if(p->s.size >= nunits){
 88d:	89 c2                	mov    %eax,%edx
 88f:	89 f8                	mov    %edi,%eax
 891:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 898:	39 ce                	cmp    %ecx,%esi
 89a:	74 54                	je     8f0 <malloc+0x100>
        p->s.size -= nunits;
 89c:	29 f1                	sub    %esi,%ecx
 89e:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 8a1:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 8a4:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 8a7:	a3 30 0c 00 00       	mov    %eax,0xc30
}
 8ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 8af:	8d 42 08             	lea    0x8(%edx),%eax
}
 8b2:	5b                   	pop    %ebx
 8b3:	5e                   	pop    %esi
 8b4:	5f                   	pop    %edi
 8b5:	5d                   	pop    %ebp
 8b6:	c3                   	ret    
 8b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8be:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 8c0:	c7 05 30 0c 00 00 34 	movl   $0xc34,0xc30
 8c7:	0c 00 00 
    base.s.size = 0;
 8ca:	bf 34 0c 00 00       	mov    $0xc34,%edi
    base.s.ptr = freep = prevp = &base;
 8cf:	c7 05 34 0c 00 00 34 	movl   $0xc34,0xc34
 8d6:	0c 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d9:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 8db:	c7 05 38 0c 00 00 00 	movl   $0x0,0xc38
 8e2:	00 00 00 
    if(p->s.size >= nunits){
 8e5:	e9 36 ff ff ff       	jmp    820 <malloc+0x30>
 8ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 8f0:	8b 0a                	mov    (%edx),%ecx
 8f2:	89 08                	mov    %ecx,(%eax)
 8f4:	eb b1                	jmp    8a7 <malloc+0xb7>
