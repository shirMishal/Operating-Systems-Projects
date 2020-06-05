
_test:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    return 1;
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
  11:	56                   	push   %esi
  12:	53                   	push   %ebx
  uint c = 21;
  uint pointers[c];
   printf(1, "IN PARENT: BEFORE SBRK Number of free pages before fork %d\n" ,getNumberOfFreePages());
 
  // making sure I have more than 16 pages on RAM
  for (i = 0 ; i < c ; i++){
  13:	31 db                	xor    %ebx,%ebx
{
  15:	51                   	push   %ecx
  16:	83 ec 70             	sub    $0x70,%esp
   printf(1, "IN PARENT: BEFORE SBRK Number of free pages before fork %d\n" ,getNumberOfFreePages());
  19:	6a 01                	push   $0x1
  1b:	68 28 09 00 00       	push   $0x928
  20:	6a 01                	push   $0x1
  22:	e8 99 05 00 00       	call   5c0 <printf>
  27:	83 c4 10             	add    $0x10,%esp
  2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printf(1, "%d\n", i);
  30:	83 ec 04             	sub    $0x4,%esp
  33:	53                   	push   %ebx
  34:	68 c2 09 00 00       	push   $0x9c2
  39:	6a 01                	push   $0x1
  3b:	e8 80 05 00 00       	call   5c0 <printf>
        pointers[i] = (uint)sbrk(4096);
  40:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  47:	e8 9f 04 00 00       	call   4eb <sbrk>
        * (char *) pointers[i] = (char) ('a' + i);
  4c:	8d 53 61             	lea    0x61(%ebx),%edx
  for (i = 0 ; i < c ; i++){
  4f:	83 c4 10             	add    $0x10,%esp
        pointers[i] = (uint)sbrk(4096);
  52:	89 44 9d 94          	mov    %eax,-0x6c(%ebp,%ebx,4)
  for (i = 0 ; i < c ; i++){
  56:	83 c3 01             	add    $0x1,%ebx
        * (char *) pointers[i] = (char) ('a' + i);
  59:	88 10                	mov    %dl,(%eax)
  for (i = 0 ; i < c ; i++){
  5b:	83 fb 15             	cmp    $0x15,%ebx
  5e:	75 d0                	jne    30 <main+0x30>
  60:	8d 5d 94             	lea    -0x6c(%ebp),%ebx
  63:	8d 75 e8             	lea    -0x18(%ebp),%esi
  66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  6d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    for (i = 0 ; i < c ; i++){  
        printf(1, "%c\n", *(char * )pointers[i]);
  70:	8b 03                	mov    (%ebx),%eax
  72:	83 ec 04             	sub    $0x4,%esp
  75:	83 c3 04             	add    $0x4,%ebx
  78:	0f be 00             	movsbl (%eax),%eax
  7b:	50                   	push   %eax
  7c:	68 db 09 00 00       	push   $0x9db
  81:	6a 01                	push   $0x1
  83:	e8 38 05 00 00       	call   5c0 <printf>
    for (i = 0 ; i < c ; i++){  
  88:	83 c4 10             	add    $0x10,%esp
  8b:	39 f3                	cmp    %esi,%ebx
  8d:	75 e1                	jne    70 <main+0x70>
    }
  
  printf(1, "IN PARENT: Number of free pages before fork %d\n" ,getNumberOfFreePages());
  8f:	83 ec 04             	sub    $0x4,%esp
  92:	6a 01                	push   $0x1
  94:	68 64 09 00 00       	push   $0x964
  99:	6a 01                	push   $0x1
  9b:	e8 20 05 00 00       	call   5c0 <printf>
  int pid;
  if( (pid = fork()) ==0){
  a0:	e8 b6 03 00 00       	call   45b <fork>
  a5:	8b 5d 94             	mov    -0x6c(%ebp),%ebx
  a8:	83 c4 10             	add    $0x10,%esp
  ab:	85 c0                	test   %eax,%eax
  ad:	75 28                	jne    d7 <main+0xd7>
      printf(1, "IN CHILD: Number of free pages after fork %d\n" ,getNumberOfFreePages());
  af:	52                   	push   %edx
  b0:	6a 01                	push   $0x1
  b2:	68 94 09 00 00       	push   $0x994
  b7:	6a 01                	push   $0x1
  b9:	e8 02 05 00 00       	call   5c0 <printf>
      * (char *) pointers[0] = (char) ('b');
       printf(1,"IN CHILD pointers[0] %c\n", *(char * )pointers[0]);
  be:	83 c4 0c             	add    $0xc,%esp
      * (char *) pointers[0] = (char) ('b');
  c1:	c6 03 62             	movb   $0x62,(%ebx)
       printf(1,"IN CHILD pointers[0] %c\n", *(char * )pointers[0]);
  c4:	6a 62                	push   $0x62
  c6:	68 c6 09 00 00       	push   $0x9c6
  cb:	6a 01                	push   $0x1
  cd:	e8 ee 04 00 00       	call   5c0 <printf>
      exit();
  d2:	e8 8c 03 00 00       	call   463 <exit>
  }
  else{
     wait();
  d7:	e8 8f 03 00 00       	call   46b <wait>
    printf(1, "IN PARENT: Number of free pages before fork %d\n" ,getNumberOfFreePages());
  dc:	50                   	push   %eax
  dd:	6a 01                	push   $0x1
  df:	68 64 09 00 00       	push   $0x964
  e4:	6a 01                	push   $0x1
  e6:	e8 d5 04 00 00       	call   5c0 <printf>
    printf(1,"IN PARENT pointers[0] %c\n", *(char * )pointers[0]);
  eb:	0f be 03             	movsbl (%ebx),%eax
  ee:	83 c4 0c             	add    $0xc,%esp
  f1:	50                   	push   %eax
  f2:	68 df 09 00 00       	push   $0x9df
  f7:	6a 01                	push   $0x1
  f9:	e8 c2 04 00 00       	call   5c0 <printf>
  
  }
  exit();
  fe:	e8 60 03 00 00       	call   463 <exit>
 103:	66 90                	xchg   %ax,%ax
 105:	66 90                	xchg   %ax,%ax
 107:	66 90                	xchg   %ax,%ax
 109:	66 90                	xchg   %ax,%ax
 10b:	66 90                	xchg   %ax,%ax
 10d:	66 90                	xchg   %ax,%ax
 10f:	90                   	nop

00000110 <getNumberOfFreePages>:
int getNumberOfFreePages(){
 110:	f3 0f 1e fb          	endbr32 
}
 114:	b8 01 00 00 00       	mov    $0x1,%eax
 119:	c3                   	ret    
 11a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000120 <main1>:
}

int
main1(int argc, char *argv[])
{
 120:	f3 0f 1e fb          	endbr32 
 124:	55                   	push   %ebp
 125:	89 e5                	mov    %esp,%ebp
 127:	56                   	push   %esi
 128:	53                   	push   %ebx
    int i = 0;
    uint c = 21;
    uint pointers[c];
    int pid = 0;
    // making sure I have more than 16 pages on RAM
    for (i = 0 ; i < c ; i++){
 129:	31 db                	xor    %ebx,%ebx
{
 12b:	83 ec 60             	sub    $0x60,%esp
 12e:	66 90                	xchg   %ax,%ax
        printf(1, "%d\n", i);
 130:	83 ec 04             	sub    $0x4,%esp
 133:	53                   	push   %ebx
 134:	68 c2 09 00 00       	push   $0x9c2
 139:	6a 01                	push   $0x1
 13b:	e8 80 04 00 00       	call   5c0 <printf>
        pointers[i] = (uint)sbrk(4096);
 140:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
 147:	e8 9f 03 00 00       	call   4eb <sbrk>
        * (char *) pointers[i] = (char) ('a' + i);
 14c:	8d 53 61             	lea    0x61(%ebx),%edx
    for (i = 0 ; i < c ; i++){
 14f:	83 c4 10             	add    $0x10,%esp
        pointers[i] = (uint)sbrk(4096);
 152:	89 44 9d a4          	mov    %eax,-0x5c(%ebp,%ebx,4)
    for (i = 0 ; i < c ; i++){
 156:	83 c3 01             	add    $0x1,%ebx
        * (char *) pointers[i] = (char) ('a' + i);
 159:	88 10                	mov    %dl,(%eax)
    for (i = 0 ; i < c ; i++){
 15b:	83 fb 15             	cmp    $0x15,%ebx
 15e:	75 d0                	jne    130 <main1+0x10>
    }

    pid = fork();
 160:	e8 f6 02 00 00       	call   45b <fork>

    if(pid == 0){
 165:	85 c0                	test   %eax,%eax
 167:	74 52                	je     1bb <main1+0x9b>

    }
    

    if(pid != 0){
        wait();
 169:	e8 fd 02 00 00       	call   46b <wait>
    }

    if(pid != 0){
    printf(1,"FATHER : \n");
 16e:	8d 5d a4             	lea    -0x5c(%ebp),%ebx
 171:	8d 75 f8             	lea    -0x8(%ebp),%esi
 174:	50                   	push   %eax
 175:	50                   	push   %eax
 176:	68 0e 0a 00 00       	push   $0xa0e
 17b:	6a 01                	push   $0x1
 17d:	e8 3e 04 00 00       	call   5c0 <printf>
    for (i = 0 ; i < c ; i++){
 182:	83 c4 10             	add    $0x10,%esp
 185:	8d 76 00             	lea    0x0(%esi),%esi
    printf(1,"%c", *(char * )pointers[i]);
 188:	8b 03                	mov    (%ebx),%eax
 18a:	83 ec 04             	sub    $0x4,%esp
 18d:	83 c3 04             	add    $0x4,%ebx
 190:	0f be 00             	movsbl (%eax),%eax
 193:	50                   	push   %eax
 194:	68 01 0a 00 00       	push   $0xa01
 199:	6a 01                	push   $0x1
 19b:	e8 20 04 00 00       	call   5c0 <printf>
    for (i = 0 ; i < c ; i++){
 1a0:	83 c4 10             	add    $0x10,%esp
 1a3:	39 de                	cmp    %ebx,%esi
 1a5:	75 e1                	jne    188 <main1+0x68>
    printf(1, " \n DONE \n");
 1a7:	83 ec 08             	sub    $0x8,%esp
 1aa:	68 04 0a 00 00       	push   $0xa04
 1af:	6a 01                	push   $0x1
 1b1:	e8 0a 04 00 00       	call   5c0 <printf>
    printf(1, " \n DONE \n");

    }


    exit();
 1b6:	e8 a8 02 00 00       	call   463 <exit>
    printf(1,"SON : \n");
 1bb:	52                   	push   %edx
 1bc:	8d 5d a4             	lea    -0x5c(%ebp),%ebx
 1bf:	8d 75 f8             	lea    -0x8(%ebp),%esi
 1c2:	52                   	push   %edx
 1c3:	68 f9 09 00 00       	push   $0x9f9
 1c8:	6a 01                	push   $0x1
 1ca:	e8 f1 03 00 00       	call   5c0 <printf>
    for (i = 0 ; i < c ; i++){
 1cf:	83 c4 10             	add    $0x10,%esp
 1d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printf(1,"%c", *(char * )pointers[i]);
 1d8:	8b 03                	mov    (%ebx),%eax
 1da:	83 ec 04             	sub    $0x4,%esp
 1dd:	83 c3 04             	add    $0x4,%ebx
 1e0:	0f be 00             	movsbl (%eax),%eax
 1e3:	50                   	push   %eax
 1e4:	68 01 0a 00 00       	push   $0xa01
 1e9:	6a 01                	push   $0x1
 1eb:	e8 d0 03 00 00       	call   5c0 <printf>
    for (i = 0 ; i < c ; i++){
 1f0:	83 c4 10             	add    $0x10,%esp
 1f3:	39 de                	cmp    %ebx,%esi
 1f5:	75 e1                	jne    1d8 <main1+0xb8>
 1f7:	eb ae                	jmp    1a7 <main1+0x87>
 1f9:	66 90                	xchg   %ax,%ax
 1fb:	66 90                	xchg   %ax,%ax
 1fd:	66 90                	xchg   %ax,%ax
 1ff:	90                   	nop

00000200 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 200:	f3 0f 1e fb          	endbr32 
 204:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 205:	31 c0                	xor    %eax,%eax
{
 207:	89 e5                	mov    %esp,%ebp
 209:	53                   	push   %ebx
 20a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 20d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
 210:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 214:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 217:	83 c0 01             	add    $0x1,%eax
 21a:	84 d2                	test   %dl,%dl
 21c:	75 f2                	jne    210 <strcpy+0x10>
    ;
  return os;
}
 21e:	89 c8                	mov    %ecx,%eax
 220:	5b                   	pop    %ebx
 221:	5d                   	pop    %ebp
 222:	c3                   	ret    
 223:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 22a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000230 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 230:	f3 0f 1e fb          	endbr32 
 234:	55                   	push   %ebp
 235:	89 e5                	mov    %esp,%ebp
 237:	53                   	push   %ebx
 238:	8b 4d 08             	mov    0x8(%ebp),%ecx
 23b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 23e:	0f b6 01             	movzbl (%ecx),%eax
 241:	0f b6 1a             	movzbl (%edx),%ebx
 244:	84 c0                	test   %al,%al
 246:	75 19                	jne    261 <strcmp+0x31>
 248:	eb 26                	jmp    270 <strcmp+0x40>
 24a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 250:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 254:	83 c1 01             	add    $0x1,%ecx
 257:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 25a:	0f b6 1a             	movzbl (%edx),%ebx
 25d:	84 c0                	test   %al,%al
 25f:	74 0f                	je     270 <strcmp+0x40>
 261:	38 d8                	cmp    %bl,%al
 263:	74 eb                	je     250 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 265:	29 d8                	sub    %ebx,%eax
}
 267:	5b                   	pop    %ebx
 268:	5d                   	pop    %ebp
 269:	c3                   	ret    
 26a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 270:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 272:	29 d8                	sub    %ebx,%eax
}
 274:	5b                   	pop    %ebx
 275:	5d                   	pop    %ebp
 276:	c3                   	ret    
 277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 27e:	66 90                	xchg   %ax,%ax

00000280 <strlen>:

uint
strlen(const char *s)
{
 280:	f3 0f 1e fb          	endbr32 
 284:	55                   	push   %ebp
 285:	89 e5                	mov    %esp,%ebp
 287:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 28a:	80 3a 00             	cmpb   $0x0,(%edx)
 28d:	74 21                	je     2b0 <strlen+0x30>
 28f:	31 c0                	xor    %eax,%eax
 291:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 298:	83 c0 01             	add    $0x1,%eax
 29b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 29f:	89 c1                	mov    %eax,%ecx
 2a1:	75 f5                	jne    298 <strlen+0x18>
    ;
  return n;
}
 2a3:	89 c8                	mov    %ecx,%eax
 2a5:	5d                   	pop    %ebp
 2a6:	c3                   	ret    
 2a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2ae:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
 2b0:	31 c9                	xor    %ecx,%ecx
}
 2b2:	5d                   	pop    %ebp
 2b3:	89 c8                	mov    %ecx,%eax
 2b5:	c3                   	ret    
 2b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2bd:	8d 76 00             	lea    0x0(%esi),%esi

000002c0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2c0:	f3 0f 1e fb          	endbr32 
 2c4:	55                   	push   %ebp
 2c5:	89 e5                	mov    %esp,%ebp
 2c7:	57                   	push   %edi
 2c8:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 2cb:	8b 4d 10             	mov    0x10(%ebp),%ecx
 2ce:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d1:	89 d7                	mov    %edx,%edi
 2d3:	fc                   	cld    
 2d4:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 2d6:	89 d0                	mov    %edx,%eax
 2d8:	5f                   	pop    %edi
 2d9:	5d                   	pop    %ebp
 2da:	c3                   	ret    
 2db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2df:	90                   	nop

000002e0 <strchr>:

char*
strchr(const char *s, char c)
{
 2e0:	f3 0f 1e fb          	endbr32 
 2e4:	55                   	push   %ebp
 2e5:	89 e5                	mov    %esp,%ebp
 2e7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ea:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 2ee:	0f b6 10             	movzbl (%eax),%edx
 2f1:	84 d2                	test   %dl,%dl
 2f3:	75 16                	jne    30b <strchr+0x2b>
 2f5:	eb 21                	jmp    318 <strchr+0x38>
 2f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2fe:	66 90                	xchg   %ax,%ax
 300:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 304:	83 c0 01             	add    $0x1,%eax
 307:	84 d2                	test   %dl,%dl
 309:	74 0d                	je     318 <strchr+0x38>
    if(*s == c)
 30b:	38 d1                	cmp    %dl,%cl
 30d:	75 f1                	jne    300 <strchr+0x20>
      return (char*)s;
  return 0;
}
 30f:	5d                   	pop    %ebp
 310:	c3                   	ret    
 311:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 318:	31 c0                	xor    %eax,%eax
}
 31a:	5d                   	pop    %ebp
 31b:	c3                   	ret    
 31c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000320 <gets>:

char*
gets(char *buf, int max)
{
 320:	f3 0f 1e fb          	endbr32 
 324:	55                   	push   %ebp
 325:	89 e5                	mov    %esp,%ebp
 327:	57                   	push   %edi
 328:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 329:	31 f6                	xor    %esi,%esi
{
 32b:	53                   	push   %ebx
 32c:	89 f3                	mov    %esi,%ebx
 32e:	83 ec 1c             	sub    $0x1c,%esp
 331:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 334:	eb 33                	jmp    369 <gets+0x49>
 336:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 33d:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 340:	83 ec 04             	sub    $0x4,%esp
 343:	8d 45 e7             	lea    -0x19(%ebp),%eax
 346:	6a 01                	push   $0x1
 348:	50                   	push   %eax
 349:	6a 00                	push   $0x0
 34b:	e8 2b 01 00 00       	call   47b <read>
    if(cc < 1)
 350:	83 c4 10             	add    $0x10,%esp
 353:	85 c0                	test   %eax,%eax
 355:	7e 1c                	jle    373 <gets+0x53>
      break;
    buf[i++] = c;
 357:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 35b:	83 c7 01             	add    $0x1,%edi
 35e:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 361:	3c 0a                	cmp    $0xa,%al
 363:	74 23                	je     388 <gets+0x68>
 365:	3c 0d                	cmp    $0xd,%al
 367:	74 1f                	je     388 <gets+0x68>
  for(i=0; i+1 < max; ){
 369:	83 c3 01             	add    $0x1,%ebx
 36c:	89 fe                	mov    %edi,%esi
 36e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 371:	7c cd                	jl     340 <gets+0x20>
 373:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 375:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 378:	c6 03 00             	movb   $0x0,(%ebx)
}
 37b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 37e:	5b                   	pop    %ebx
 37f:	5e                   	pop    %esi
 380:	5f                   	pop    %edi
 381:	5d                   	pop    %ebp
 382:	c3                   	ret    
 383:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 387:	90                   	nop
 388:	8b 75 08             	mov    0x8(%ebp),%esi
 38b:	8b 45 08             	mov    0x8(%ebp),%eax
 38e:	01 de                	add    %ebx,%esi
 390:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 392:	c6 03 00             	movb   $0x0,(%ebx)
}
 395:	8d 65 f4             	lea    -0xc(%ebp),%esp
 398:	5b                   	pop    %ebx
 399:	5e                   	pop    %esi
 39a:	5f                   	pop    %edi
 39b:	5d                   	pop    %ebp
 39c:	c3                   	ret    
 39d:	8d 76 00             	lea    0x0(%esi),%esi

000003a0 <stat>:

int
stat(const char *n, struct stat *st)
{
 3a0:	f3 0f 1e fb          	endbr32 
 3a4:	55                   	push   %ebp
 3a5:	89 e5                	mov    %esp,%ebp
 3a7:	56                   	push   %esi
 3a8:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3a9:	83 ec 08             	sub    $0x8,%esp
 3ac:	6a 00                	push   $0x0
 3ae:	ff 75 08             	pushl  0x8(%ebp)
 3b1:	e8 ed 00 00 00       	call   4a3 <open>
  if(fd < 0)
 3b6:	83 c4 10             	add    $0x10,%esp
 3b9:	85 c0                	test   %eax,%eax
 3bb:	78 2b                	js     3e8 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 3bd:	83 ec 08             	sub    $0x8,%esp
 3c0:	ff 75 0c             	pushl  0xc(%ebp)
 3c3:	89 c3                	mov    %eax,%ebx
 3c5:	50                   	push   %eax
 3c6:	e8 f0 00 00 00       	call   4bb <fstat>
  close(fd);
 3cb:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 3ce:	89 c6                	mov    %eax,%esi
  close(fd);
 3d0:	e8 b6 00 00 00       	call   48b <close>
  return r;
 3d5:	83 c4 10             	add    $0x10,%esp
}
 3d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
 3db:	89 f0                	mov    %esi,%eax
 3dd:	5b                   	pop    %ebx
 3de:	5e                   	pop    %esi
 3df:	5d                   	pop    %ebp
 3e0:	c3                   	ret    
 3e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 3e8:	be ff ff ff ff       	mov    $0xffffffff,%esi
 3ed:	eb e9                	jmp    3d8 <stat+0x38>
 3ef:	90                   	nop

000003f0 <atoi>:

int
atoi(const char *s)
{
 3f0:	f3 0f 1e fb          	endbr32 
 3f4:	55                   	push   %ebp
 3f5:	89 e5                	mov    %esp,%ebp
 3f7:	53                   	push   %ebx
 3f8:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3fb:	0f be 02             	movsbl (%edx),%eax
 3fe:	8d 48 d0             	lea    -0x30(%eax),%ecx
 401:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 404:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 409:	77 1a                	ja     425 <atoi+0x35>
 40b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 40f:	90                   	nop
    n = n*10 + *s++ - '0';
 410:	83 c2 01             	add    $0x1,%edx
 413:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 416:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 41a:	0f be 02             	movsbl (%edx),%eax
 41d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 420:	80 fb 09             	cmp    $0x9,%bl
 423:	76 eb                	jbe    410 <atoi+0x20>
  return n;
}
 425:	89 c8                	mov    %ecx,%eax
 427:	5b                   	pop    %ebx
 428:	5d                   	pop    %ebp
 429:	c3                   	ret    
 42a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000430 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 430:	f3 0f 1e fb          	endbr32 
 434:	55                   	push   %ebp
 435:	89 e5                	mov    %esp,%ebp
 437:	57                   	push   %edi
 438:	8b 45 10             	mov    0x10(%ebp),%eax
 43b:	8b 55 08             	mov    0x8(%ebp),%edx
 43e:	56                   	push   %esi
 43f:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 442:	85 c0                	test   %eax,%eax
 444:	7e 0f                	jle    455 <memmove+0x25>
 446:	01 d0                	add    %edx,%eax
  dst = vdst;
 448:	89 d7                	mov    %edx,%edi
 44a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
 450:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 451:	39 f8                	cmp    %edi,%eax
 453:	75 fb                	jne    450 <memmove+0x20>
  return vdst;
}
 455:	5e                   	pop    %esi
 456:	89 d0                	mov    %edx,%eax
 458:	5f                   	pop    %edi
 459:	5d                   	pop    %ebp
 45a:	c3                   	ret    

0000045b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 45b:	b8 01 00 00 00       	mov    $0x1,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret    

00000463 <exit>:
SYSCALL(exit)
 463:	b8 02 00 00 00       	mov    $0x2,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret    

0000046b <wait>:
SYSCALL(wait)
 46b:	b8 03 00 00 00       	mov    $0x3,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret    

00000473 <pipe>:
SYSCALL(pipe)
 473:	b8 04 00 00 00       	mov    $0x4,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret    

0000047b <read>:
SYSCALL(read)
 47b:	b8 05 00 00 00       	mov    $0x5,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret    

00000483 <write>:
SYSCALL(write)
 483:	b8 10 00 00 00       	mov    $0x10,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret    

0000048b <close>:
SYSCALL(close)
 48b:	b8 15 00 00 00       	mov    $0x15,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret    

00000493 <kill>:
SYSCALL(kill)
 493:	b8 06 00 00 00       	mov    $0x6,%eax
 498:	cd 40                	int    $0x40
 49a:	c3                   	ret    

0000049b <exec>:
SYSCALL(exec)
 49b:	b8 07 00 00 00       	mov    $0x7,%eax
 4a0:	cd 40                	int    $0x40
 4a2:	c3                   	ret    

000004a3 <open>:
SYSCALL(open)
 4a3:	b8 0f 00 00 00       	mov    $0xf,%eax
 4a8:	cd 40                	int    $0x40
 4aa:	c3                   	ret    

000004ab <mknod>:
SYSCALL(mknod)
 4ab:	b8 11 00 00 00       	mov    $0x11,%eax
 4b0:	cd 40                	int    $0x40
 4b2:	c3                   	ret    

000004b3 <unlink>:
SYSCALL(unlink)
 4b3:	b8 12 00 00 00       	mov    $0x12,%eax
 4b8:	cd 40                	int    $0x40
 4ba:	c3                   	ret    

000004bb <fstat>:
SYSCALL(fstat)
 4bb:	b8 08 00 00 00       	mov    $0x8,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret    

000004c3 <link>:
SYSCALL(link)
 4c3:	b8 13 00 00 00       	mov    $0x13,%eax
 4c8:	cd 40                	int    $0x40
 4ca:	c3                   	ret    

000004cb <mkdir>:
SYSCALL(mkdir)
 4cb:	b8 14 00 00 00       	mov    $0x14,%eax
 4d0:	cd 40                	int    $0x40
 4d2:	c3                   	ret    

000004d3 <chdir>:
SYSCALL(chdir)
 4d3:	b8 09 00 00 00       	mov    $0x9,%eax
 4d8:	cd 40                	int    $0x40
 4da:	c3                   	ret    

000004db <dup>:
SYSCALL(dup)
 4db:	b8 0a 00 00 00       	mov    $0xa,%eax
 4e0:	cd 40                	int    $0x40
 4e2:	c3                   	ret    

000004e3 <getpid>:
SYSCALL(getpid)
 4e3:	b8 0b 00 00 00       	mov    $0xb,%eax
 4e8:	cd 40                	int    $0x40
 4ea:	c3                   	ret    

000004eb <sbrk>:
SYSCALL(sbrk)
 4eb:	b8 0c 00 00 00       	mov    $0xc,%eax
 4f0:	cd 40                	int    $0x40
 4f2:	c3                   	ret    

000004f3 <sleep>:
SYSCALL(sleep)
 4f3:	b8 0d 00 00 00       	mov    $0xd,%eax
 4f8:	cd 40                	int    $0x40
 4fa:	c3                   	ret    

000004fb <uptime>:
SYSCALL(uptime)
 4fb:	b8 0e 00 00 00       	mov    $0xe,%eax
 500:	cd 40                	int    $0x40
 502:	c3                   	ret    
 503:	66 90                	xchg   %ax,%ax
 505:	66 90                	xchg   %ax,%ax
 507:	66 90                	xchg   %ax,%ax
 509:	66 90                	xchg   %ax,%ax
 50b:	66 90                	xchg   %ax,%ax
 50d:	66 90                	xchg   %ax,%ax
 50f:	90                   	nop

00000510 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 510:	55                   	push   %ebp
 511:	89 e5                	mov    %esp,%ebp
 513:	57                   	push   %edi
 514:	56                   	push   %esi
 515:	53                   	push   %ebx
 516:	83 ec 3c             	sub    $0x3c,%esp
 519:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 51c:	89 d1                	mov    %edx,%ecx
{
 51e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 521:	85 d2                	test   %edx,%edx
 523:	0f 89 7f 00 00 00    	jns    5a8 <printint+0x98>
 529:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 52d:	74 79                	je     5a8 <printint+0x98>
    neg = 1;
 52f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 536:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 538:	31 db                	xor    %ebx,%ebx
 53a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 53d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 540:	89 c8                	mov    %ecx,%eax
 542:	31 d2                	xor    %edx,%edx
 544:	89 cf                	mov    %ecx,%edi
 546:	f7 75 c4             	divl   -0x3c(%ebp)
 549:	0f b6 92 20 0a 00 00 	movzbl 0xa20(%edx),%edx
 550:	89 45 c0             	mov    %eax,-0x40(%ebp)
 553:	89 d8                	mov    %ebx,%eax
 555:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 558:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 55b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 55e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 561:	76 dd                	jbe    540 <printint+0x30>
  if(neg)
 563:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 566:	85 c9                	test   %ecx,%ecx
 568:	74 0c                	je     576 <printint+0x66>
    buf[i++] = '-';
 56a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 56f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 571:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 576:	8b 7d b8             	mov    -0x48(%ebp),%edi
 579:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 57d:	eb 07                	jmp    586 <printint+0x76>
 57f:	90                   	nop
 580:	0f b6 13             	movzbl (%ebx),%edx
 583:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 586:	83 ec 04             	sub    $0x4,%esp
 589:	88 55 d7             	mov    %dl,-0x29(%ebp)
 58c:	6a 01                	push   $0x1
 58e:	56                   	push   %esi
 58f:	57                   	push   %edi
 590:	e8 ee fe ff ff       	call   483 <write>
  while(--i >= 0)
 595:	83 c4 10             	add    $0x10,%esp
 598:	39 de                	cmp    %ebx,%esi
 59a:	75 e4                	jne    580 <printint+0x70>
    putc(fd, buf[i]);
}
 59c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 59f:	5b                   	pop    %ebx
 5a0:	5e                   	pop    %esi
 5a1:	5f                   	pop    %edi
 5a2:	5d                   	pop    %ebp
 5a3:	c3                   	ret    
 5a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 5a8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 5af:	eb 87                	jmp    538 <printint+0x28>
 5b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5bf:	90                   	nop

000005c0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5c0:	f3 0f 1e fb          	endbr32 
 5c4:	55                   	push   %ebp
 5c5:	89 e5                	mov    %esp,%ebp
 5c7:	57                   	push   %edi
 5c8:	56                   	push   %esi
 5c9:	53                   	push   %ebx
 5ca:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5cd:	8b 75 0c             	mov    0xc(%ebp),%esi
 5d0:	0f b6 1e             	movzbl (%esi),%ebx
 5d3:	84 db                	test   %bl,%bl
 5d5:	0f 84 b4 00 00 00    	je     68f <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
 5db:	8d 45 10             	lea    0x10(%ebp),%eax
 5de:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 5e1:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 5e4:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 5e6:	89 45 d0             	mov    %eax,-0x30(%ebp)
 5e9:	eb 33                	jmp    61e <printf+0x5e>
 5eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 5ef:	90                   	nop
 5f0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 5f3:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 5f8:	83 f8 25             	cmp    $0x25,%eax
 5fb:	74 17                	je     614 <printf+0x54>
  write(fd, &c, 1);
 5fd:	83 ec 04             	sub    $0x4,%esp
 600:	88 5d e7             	mov    %bl,-0x19(%ebp)
 603:	6a 01                	push   $0x1
 605:	57                   	push   %edi
 606:	ff 75 08             	pushl  0x8(%ebp)
 609:	e8 75 fe ff ff       	call   483 <write>
 60e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 611:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 614:	0f b6 1e             	movzbl (%esi),%ebx
 617:	83 c6 01             	add    $0x1,%esi
 61a:	84 db                	test   %bl,%bl
 61c:	74 71                	je     68f <printf+0xcf>
    c = fmt[i] & 0xff;
 61e:	0f be cb             	movsbl %bl,%ecx
 621:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 624:	85 d2                	test   %edx,%edx
 626:	74 c8                	je     5f0 <printf+0x30>
      }
    } else if(state == '%'){
 628:	83 fa 25             	cmp    $0x25,%edx
 62b:	75 e7                	jne    614 <printf+0x54>
      if(c == 'd'){
 62d:	83 f8 64             	cmp    $0x64,%eax
 630:	0f 84 9a 00 00 00    	je     6d0 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 636:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 63c:	83 f9 70             	cmp    $0x70,%ecx
 63f:	74 5f                	je     6a0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 641:	83 f8 73             	cmp    $0x73,%eax
 644:	0f 84 d6 00 00 00    	je     720 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 64a:	83 f8 63             	cmp    $0x63,%eax
 64d:	0f 84 8d 00 00 00    	je     6e0 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 653:	83 f8 25             	cmp    $0x25,%eax
 656:	0f 84 b4 00 00 00    	je     710 <printf+0x150>
  write(fd, &c, 1);
 65c:	83 ec 04             	sub    $0x4,%esp
 65f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 663:	6a 01                	push   $0x1
 665:	57                   	push   %edi
 666:	ff 75 08             	pushl  0x8(%ebp)
 669:	e8 15 fe ff ff       	call   483 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 66e:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 671:	83 c4 0c             	add    $0xc,%esp
 674:	6a 01                	push   $0x1
 676:	83 c6 01             	add    $0x1,%esi
 679:	57                   	push   %edi
 67a:	ff 75 08             	pushl  0x8(%ebp)
 67d:	e8 01 fe ff ff       	call   483 <write>
  for(i = 0; fmt[i]; i++){
 682:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 686:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 689:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 68b:	84 db                	test   %bl,%bl
 68d:	75 8f                	jne    61e <printf+0x5e>
    }
  }
}
 68f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 692:	5b                   	pop    %ebx
 693:	5e                   	pop    %esi
 694:	5f                   	pop    %edi
 695:	5d                   	pop    %ebp
 696:	c3                   	ret    
 697:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 69e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 6a0:	83 ec 0c             	sub    $0xc,%esp
 6a3:	b9 10 00 00 00       	mov    $0x10,%ecx
 6a8:	6a 00                	push   $0x0
 6aa:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 6ad:	8b 45 08             	mov    0x8(%ebp),%eax
 6b0:	8b 13                	mov    (%ebx),%edx
 6b2:	e8 59 fe ff ff       	call   510 <printint>
        ap++;
 6b7:	89 d8                	mov    %ebx,%eax
 6b9:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6bc:	31 d2                	xor    %edx,%edx
        ap++;
 6be:	83 c0 04             	add    $0x4,%eax
 6c1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 6c4:	e9 4b ff ff ff       	jmp    614 <printf+0x54>
 6c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 6d0:	83 ec 0c             	sub    $0xc,%esp
 6d3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 6d8:	6a 01                	push   $0x1
 6da:	eb ce                	jmp    6aa <printf+0xea>
 6dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 6e0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 6e3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 6e6:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 6e8:	6a 01                	push   $0x1
        ap++;
 6ea:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 6ed:	57                   	push   %edi
 6ee:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 6f1:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 6f4:	e8 8a fd ff ff       	call   483 <write>
        ap++;
 6f9:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 6fc:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6ff:	31 d2                	xor    %edx,%edx
 701:	e9 0e ff ff ff       	jmp    614 <printf+0x54>
 706:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 70d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 710:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 713:	83 ec 04             	sub    $0x4,%esp
 716:	e9 59 ff ff ff       	jmp    674 <printf+0xb4>
 71b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 71f:	90                   	nop
        s = (char*)*ap;
 720:	8b 45 d0             	mov    -0x30(%ebp),%eax
 723:	8b 18                	mov    (%eax),%ebx
        ap++;
 725:	83 c0 04             	add    $0x4,%eax
 728:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 72b:	85 db                	test   %ebx,%ebx
 72d:	74 17                	je     746 <printf+0x186>
        while(*s != 0){
 72f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 732:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 734:	84 c0                	test   %al,%al
 736:	0f 84 d8 fe ff ff    	je     614 <printf+0x54>
 73c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 73f:	89 de                	mov    %ebx,%esi
 741:	8b 5d 08             	mov    0x8(%ebp),%ebx
 744:	eb 1a                	jmp    760 <printf+0x1a0>
          s = "(null)";
 746:	bb 19 0a 00 00       	mov    $0xa19,%ebx
        while(*s != 0){
 74b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 74e:	b8 28 00 00 00       	mov    $0x28,%eax
 753:	89 de                	mov    %ebx,%esi
 755:	8b 5d 08             	mov    0x8(%ebp),%ebx
 758:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 75f:	90                   	nop
  write(fd, &c, 1);
 760:	83 ec 04             	sub    $0x4,%esp
          s++;
 763:	83 c6 01             	add    $0x1,%esi
 766:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 769:	6a 01                	push   $0x1
 76b:	57                   	push   %edi
 76c:	53                   	push   %ebx
 76d:	e8 11 fd ff ff       	call   483 <write>
        while(*s != 0){
 772:	0f b6 06             	movzbl (%esi),%eax
 775:	83 c4 10             	add    $0x10,%esp
 778:	84 c0                	test   %al,%al
 77a:	75 e4                	jne    760 <printf+0x1a0>
 77c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 77f:	31 d2                	xor    %edx,%edx
 781:	e9 8e fe ff ff       	jmp    614 <printf+0x54>
 786:	66 90                	xchg   %ax,%ax
 788:	66 90                	xchg   %ax,%ax
 78a:	66 90                	xchg   %ax,%ax
 78c:	66 90                	xchg   %ax,%ax
 78e:	66 90                	xchg   %ax,%ax

00000790 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 790:	f3 0f 1e fb          	endbr32 
 794:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 795:	a1 04 0d 00 00       	mov    0xd04,%eax
{
 79a:	89 e5                	mov    %esp,%ebp
 79c:	57                   	push   %edi
 79d:	56                   	push   %esi
 79e:	53                   	push   %ebx
 79f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 7a2:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 7a4:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a7:	39 c8                	cmp    %ecx,%eax
 7a9:	73 15                	jae    7c0 <free+0x30>
 7ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 7af:	90                   	nop
 7b0:	39 d1                	cmp    %edx,%ecx
 7b2:	72 14                	jb     7c8 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b4:	39 d0                	cmp    %edx,%eax
 7b6:	73 10                	jae    7c8 <free+0x38>
{
 7b8:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ba:	8b 10                	mov    (%eax),%edx
 7bc:	39 c8                	cmp    %ecx,%eax
 7be:	72 f0                	jb     7b0 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7c0:	39 d0                	cmp    %edx,%eax
 7c2:	72 f4                	jb     7b8 <free+0x28>
 7c4:	39 d1                	cmp    %edx,%ecx
 7c6:	73 f0                	jae    7b8 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7c8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 7cb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 7ce:	39 fa                	cmp    %edi,%edx
 7d0:	74 1e                	je     7f0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 7d2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 7d5:	8b 50 04             	mov    0x4(%eax),%edx
 7d8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7db:	39 f1                	cmp    %esi,%ecx
 7dd:	74 28                	je     807 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 7df:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 7e1:	5b                   	pop    %ebx
  freep = p;
 7e2:	a3 04 0d 00 00       	mov    %eax,0xd04
}
 7e7:	5e                   	pop    %esi
 7e8:	5f                   	pop    %edi
 7e9:	5d                   	pop    %ebp
 7ea:	c3                   	ret    
 7eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 7ef:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 7f0:	03 72 04             	add    0x4(%edx),%esi
 7f3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 7f6:	8b 10                	mov    (%eax),%edx
 7f8:	8b 12                	mov    (%edx),%edx
 7fa:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 7fd:	8b 50 04             	mov    0x4(%eax),%edx
 800:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 803:	39 f1                	cmp    %esi,%ecx
 805:	75 d8                	jne    7df <free+0x4f>
    p->s.size += bp->s.size;
 807:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 80a:	a3 04 0d 00 00       	mov    %eax,0xd04
    p->s.size += bp->s.size;
 80f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 812:	8b 53 f8             	mov    -0x8(%ebx),%edx
 815:	89 10                	mov    %edx,(%eax)
}
 817:	5b                   	pop    %ebx
 818:	5e                   	pop    %esi
 819:	5f                   	pop    %edi
 81a:	5d                   	pop    %ebp
 81b:	c3                   	ret    
 81c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000820 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 820:	f3 0f 1e fb          	endbr32 
 824:	55                   	push   %ebp
 825:	89 e5                	mov    %esp,%ebp
 827:	57                   	push   %edi
 828:	56                   	push   %esi
 829:	53                   	push   %ebx
 82a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 82d:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 830:	8b 3d 04 0d 00 00    	mov    0xd04,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 836:	8d 70 07             	lea    0x7(%eax),%esi
 839:	c1 ee 03             	shr    $0x3,%esi
 83c:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 83f:	85 ff                	test   %edi,%edi
 841:	0f 84 a9 00 00 00    	je     8f0 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 847:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 849:	8b 48 04             	mov    0x4(%eax),%ecx
 84c:	39 f1                	cmp    %esi,%ecx
 84e:	73 6d                	jae    8bd <malloc+0x9d>
 850:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 856:	bb 00 10 00 00       	mov    $0x1000,%ebx
 85b:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 85e:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 865:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 868:	eb 17                	jmp    881 <malloc+0x61>
 86a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 870:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 872:	8b 4a 04             	mov    0x4(%edx),%ecx
 875:	39 f1                	cmp    %esi,%ecx
 877:	73 4f                	jae    8c8 <malloc+0xa8>
 879:	8b 3d 04 0d 00 00    	mov    0xd04,%edi
 87f:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 881:	39 c7                	cmp    %eax,%edi
 883:	75 eb                	jne    870 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 885:	83 ec 0c             	sub    $0xc,%esp
 888:	ff 75 e4             	pushl  -0x1c(%ebp)
 88b:	e8 5b fc ff ff       	call   4eb <sbrk>
  if(p == (char*)-1)
 890:	83 c4 10             	add    $0x10,%esp
 893:	83 f8 ff             	cmp    $0xffffffff,%eax
 896:	74 1b                	je     8b3 <malloc+0x93>
  hp->s.size = nu;
 898:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 89b:	83 ec 0c             	sub    $0xc,%esp
 89e:	83 c0 08             	add    $0x8,%eax
 8a1:	50                   	push   %eax
 8a2:	e8 e9 fe ff ff       	call   790 <free>
  return freep;
 8a7:	a1 04 0d 00 00       	mov    0xd04,%eax
      if((p = morecore(nunits)) == 0)
 8ac:	83 c4 10             	add    $0x10,%esp
 8af:	85 c0                	test   %eax,%eax
 8b1:	75 bd                	jne    870 <malloc+0x50>
        return 0;
  }
}
 8b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 8b6:	31 c0                	xor    %eax,%eax
}
 8b8:	5b                   	pop    %ebx
 8b9:	5e                   	pop    %esi
 8ba:	5f                   	pop    %edi
 8bb:	5d                   	pop    %ebp
 8bc:	c3                   	ret    
    if(p->s.size >= nunits){
 8bd:	89 c2                	mov    %eax,%edx
 8bf:	89 f8                	mov    %edi,%eax
 8c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 8c8:	39 ce                	cmp    %ecx,%esi
 8ca:	74 54                	je     920 <malloc+0x100>
        p->s.size -= nunits;
 8cc:	29 f1                	sub    %esi,%ecx
 8ce:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 8d1:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 8d4:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 8d7:	a3 04 0d 00 00       	mov    %eax,0xd04
}
 8dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 8df:	8d 42 08             	lea    0x8(%edx),%eax
}
 8e2:	5b                   	pop    %ebx
 8e3:	5e                   	pop    %esi
 8e4:	5f                   	pop    %edi
 8e5:	5d                   	pop    %ebp
 8e6:	c3                   	ret    
 8e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8ee:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 8f0:	c7 05 04 0d 00 00 08 	movl   $0xd08,0xd04
 8f7:	0d 00 00 
    base.s.size = 0;
 8fa:	bf 08 0d 00 00       	mov    $0xd08,%edi
    base.s.ptr = freep = prevp = &base;
 8ff:	c7 05 08 0d 00 00 08 	movl   $0xd08,0xd08
 906:	0d 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 909:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 90b:	c7 05 0c 0d 00 00 00 	movl   $0x0,0xd0c
 912:	00 00 00 
    if(p->s.size >= nunits){
 915:	e9 36 ff ff ff       	jmp    850 <malloc+0x30>
 91a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 920:	8b 0a                	mov    (%edx),%ecx
 922:	89 08                	mov    %ecx,(%eax)
 924:	eb b1                	jmp    8d7 <malloc+0xb7>
