
_test:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    exit();
    return 0;
}
int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
   f:	51                   	push   %ecx
  uint c = 21;
  uint pointers[c];
   printf(1, "IN PARENT: BEFORE SBRK Number of occupied pages before fork %d\n" ,57344 - getNumberOfFreePages());
 
  // making sure I have more than 16 pages on RAM
  for (i = 0 ; i < c ; i++){
  10:	31 db                	xor    %ebx,%ebx
{
  12:	83 ec 6c             	sub    $0x6c,%esp
    return get_number_of_free_pages();
  15:	e8 78 05 00 00       	call   592 <get_number_of_free_pages>
   printf(1, "IN PARENT: BEFORE SBRK Number of occupied pages before fork %d\n" ,57344 - getNumberOfFreePages());
  1a:	ba 00 e0 00 00       	mov    $0xe000,%edx
  1f:	83 ec 04             	sub    $0x4,%esp
  22:	29 c2                	sub    %eax,%edx
  24:	52                   	push   %edx
  25:	68 10 0a 00 00       	push   $0xa10
  2a:	6a 01                	push   $0x1
  2c:	e8 0f 06 00 00       	call   640 <printf>
  31:	83 c4 10             	add    $0x10,%esp
  34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        printf(1, "%d\n", i);
  38:	83 ec 04             	sub    $0x4,%esp
  3b:	53                   	push   %ebx
  3c:	68 b7 09 00 00       	push   $0x9b7
  41:	6a 01                	push   $0x1
  43:	e8 f8 05 00 00       	call   640 <printf>
        pointers[i] = (uint)sbrk(4096);
  48:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  4f:	e8 26 05 00 00       	call   57a <sbrk>
        * (char *) pointers[i] = (char) ('a' + i);
  54:	8d 53 61             	lea    0x61(%ebx),%edx
        pointers[i] = (uint)sbrk(4096);
  57:	89 44 9d 94          	mov    %eax,-0x6c(%ebp,%ebx,4)
  for (i = 0 ; i < c ; i++){
  5b:	83 c3 01             	add    $0x1,%ebx
  5e:	83 c4 10             	add    $0x10,%esp
  61:	83 fb 15             	cmp    $0x15,%ebx
        * (char *) pointers[i] = (char) ('a' + i);
  64:	88 10                	mov    %dl,(%eax)
  for (i = 0 ; i < c ; i++){
  66:	75 d0                	jne    38 <main+0x38>
  68:	8d 5d 94             	lea    -0x6c(%ebp),%ebx
  6b:	8d 75 e8             	lea    -0x18(%ebp),%esi
  6e:	66 90                	xchg   %ax,%ax
    }
    for (i = 0 ; i < c ; i++){  
        printf(1, "%c\n", *(char * )pointers[i]);
  70:	8b 03                	mov    (%ebx),%eax
  72:	83 ec 04             	sub    $0x4,%esp
  75:	83 c3 04             	add    $0x4,%ebx
  78:	0f be 00             	movsbl (%eax),%eax
  7b:	50                   	push   %eax
  7c:	68 d0 09 00 00       	push   $0x9d0
  81:	6a 01                	push   $0x1
  83:	e8 b8 05 00 00       	call   640 <printf>
    for (i = 0 ; i < c ; i++){  
  88:	83 c4 10             	add    $0x10,%esp
  8b:	39 de                	cmp    %ebx,%esi
  8d:	75 e1                	jne    70 <main+0x70>
    }
  
  printf(1, "IN PARENT: Number of occupied pages before fork %d\n" ,57344 - getNumberOfFreePages());
  8f:	bb 00 e0 00 00       	mov    $0xe000,%ebx
    return get_number_of_free_pages();
  94:	e8 f9 04 00 00       	call   592 <get_number_of_free_pages>
  printf(1, "IN PARENT: Number of occupied pages before fork %d\n" ,57344 - getNumberOfFreePages());
  99:	89 d9                	mov    %ebx,%ecx
  9b:	83 ec 04             	sub    $0x4,%esp
  9e:	29 c1                	sub    %eax,%ecx
  a0:	51                   	push   %ecx
  a1:	68 50 0a 00 00       	push   $0xa50
  a6:	6a 01                	push   $0x1
  a8:	e8 93 05 00 00       	call   640 <printf>
  int pid;
  if( (pid = fork()) ==0){
  ad:	e8 38 04 00 00       	call   4ea <fork>
  b2:	83 c4 10             	add    $0x10,%esp
  b5:	85 c0                	test   %eax,%eax
  b7:	8b 75 94             	mov    -0x6c(%ebp),%esi
  ba:	75 2e                	jne    ea <main+0xea>
    return get_number_of_free_pages();
  bc:	e8 d1 04 00 00       	call   592 <get_number_of_free_pages>
      printf(1, "IN CHILD: Number of occupied pages after fork %d\n" ,57344 - getNumberOfFreePages());
  c1:	29 c3                	sub    %eax,%ebx
  c3:	51                   	push   %ecx
  c4:	53                   	push   %ebx
  c5:	68 84 0a 00 00       	push   $0xa84
  ca:	6a 01                	push   $0x1
  cc:	e8 6f 05 00 00       	call   640 <printf>
      * (char *) pointers[0] = (char) ('b');
       printf(1,"IN CHILD pointers[0] %c\n", *(char * )pointers[0]);
  d1:	83 c4 0c             	add    $0xc,%esp
      * (char *) pointers[0] = (char) ('b');
  d4:	c6 06 62             	movb   $0x62,(%esi)
       printf(1,"IN CHILD pointers[0] %c\n", *(char * )pointers[0]);
  d7:	6a 62                	push   $0x62
  d9:	68 bb 09 00 00       	push   $0x9bb
  de:	6a 01                	push   $0x1
  e0:	e8 5b 05 00 00       	call   640 <printf>
      exit();
  e5:	e8 08 04 00 00       	call   4f2 <exit>
  }
  else{
     wait();
  ea:	e8 0b 04 00 00       	call   4fa <wait>
    return get_number_of_free_pages();
  ef:	e8 9e 04 00 00       	call   592 <get_number_of_free_pages>
    printf(1, "IN PARENT: Number of occupied pages after fork %d\n" ,57344 - getNumberOfFreePages());
  f4:	29 c3                	sub    %eax,%ebx
  f6:	52                   	push   %edx
  f7:	53                   	push   %ebx
  f8:	68 b8 0a 00 00       	push   $0xab8
  fd:	6a 01                	push   $0x1
  ff:	e8 3c 05 00 00       	call   640 <printf>
    printf(1,"IN PARENT pointers[0] %c\n", *(char * )pointers[0]);
 104:	0f be 06             	movsbl (%esi),%eax
 107:	83 c4 0c             	add    $0xc,%esp
 10a:	50                   	push   %eax
 10b:	68 d4 09 00 00       	push   $0x9d4
 110:	6a 01                	push   $0x1
 112:	e8 29 05 00 00       	call   640 <printf>
  
  }
  exit();
 117:	e8 d6 03 00 00       	call   4f2 <exit>
 11c:	66 90                	xchg   %ax,%ax
 11e:	66 90                	xchg   %ax,%ax

00000120 <getNumberOfFreePages>:
int getNumberOfFreePages(){
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
}
 123:	5d                   	pop    %ebp
    return get_number_of_free_pages();
 124:	e9 69 04 00 00       	jmp    592 <get_number_of_free_pages>
 129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000130 <main2>:
{   
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	56                   	push   %esi
 134:	53                   	push   %ebx
        *(Fmem[0] + PGSIZE * (i % n_of_allocations) ) = 'c';
 135:	bb cd cc cc cc       	mov    $0xcccccccd,%ebx
    Fmem[0] = malloc(n_of_allocations * PGSIZE);
 13a:	83 ec 0c             	sub    $0xc,%esp
 13d:	68 00 40 01 00       	push   $0x14000
 142:	e8 59 07 00 00       	call   8a0 <malloc>
 147:	89 c6                	mov    %eax,%esi
    printf(1, "Allocation done\n");
 149:	58                   	pop    %eax
 14a:	5a                   	pop    %edx
 14b:	68 98 09 00 00       	push   $0x998
 150:	6a 01                	push   $0x1
 152:	e8 e9 04 00 00       	call   640 <printf>
    sleep(500);
 157:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
 15e:	e8 1f 04 00 00       	call   582 <sleep>
 163:	83 c4 10             	add    $0x10,%esp
    int i = 0;
 166:	31 c9                	xor    %ecx,%ecx
 168:	90                   	nop
 169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        *(Fmem[0] + PGSIZE * (i % n_of_allocations) ) = 'c';
 170:	89 c8                	mov    %ecx,%eax
 172:	f7 e3                	mul    %ebx
 174:	c1 ea 04             	shr    $0x4,%edx
 177:	8d 04 92             	lea    (%edx,%edx,4),%eax
 17a:	89 ca                	mov    %ecx,%edx
        i++;
 17c:	83 c1 01             	add    $0x1,%ecx
        *(Fmem[0] + PGSIZE * (i % n_of_allocations) ) = 'c';
 17f:	c1 e0 02             	shl    $0x2,%eax
 182:	29 c2                	sub    %eax,%edx
 184:	89 d0                	mov    %edx,%eax
 186:	c1 e0 0c             	shl    $0xc,%eax
    while (i <100) {
 189:	83 f9 64             	cmp    $0x64,%ecx
        *(Fmem[0] + PGSIZE * (i % n_of_allocations) ) = 'c';
 18c:	c6 04 06 63          	movb   $0x63,(%esi,%eax,1)
    while (i <100) {
 190:	75 de                	jne    170 <main2+0x40>
    printf(1, "Access done1\n");
 192:	83 ec 08             	sub    $0x8,%esp
 195:	68 a9 09 00 00       	push   $0x9a9
 19a:	6a 01                	push   $0x1
 19c:	e8 9f 04 00 00       	call   640 <printf>
    exit();
 1a1:	e8 4c 03 00 00       	call   4f2 <exit>
 1a6:	8d 76 00             	lea    0x0(%esi),%esi
 1a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001b0 <main1>:
}

int
main1(int argc, char *argv[])
{
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
 1b3:	56                   	push   %esi
 1b4:	53                   	push   %ebx
    int i = 0;
    uint c = 21;
    uint pointers[c];
    int pid = 0;
    // making sure I have more than 16 pages on RAM
    for (i = 0 ; i < c ; i++){
 1b5:	31 db                	xor    %ebx,%ebx
{
 1b7:	83 ec 60             	sub    $0x60,%esp
 1ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printf(1, "%d\n", i);
 1c0:	83 ec 04             	sub    $0x4,%esp
 1c3:	53                   	push   %ebx
 1c4:	68 b7 09 00 00       	push   $0x9b7
 1c9:	6a 01                	push   $0x1
 1cb:	e8 70 04 00 00       	call   640 <printf>
        pointers[i] = (uint)sbrk(4096);
 1d0:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
 1d7:	e8 9e 03 00 00       	call   57a <sbrk>
        * (char *) pointers[i] = (char) ('a' + i);
 1dc:	8d 53 61             	lea    0x61(%ebx),%edx
        pointers[i] = (uint)sbrk(4096);
 1df:	89 44 9d a4          	mov    %eax,-0x5c(%ebp,%ebx,4)
    for (i = 0 ; i < c ; i++){
 1e3:	83 c3 01             	add    $0x1,%ebx
 1e6:	83 c4 10             	add    $0x10,%esp
 1e9:	83 fb 15             	cmp    $0x15,%ebx
        * (char *) pointers[i] = (char) ('a' + i);
 1ec:	88 10                	mov    %dl,(%eax)
    for (i = 0 ; i < c ; i++){
 1ee:	75 d0                	jne    1c0 <main1+0x10>
    }

    pid = fork();
 1f0:	e8 f5 02 00 00       	call   4ea <fork>

    if(pid == 0){
 1f5:	85 c0                	test   %eax,%eax
 1f7:	74 5a                	je     253 <main1+0xa3>

    }
    

    if(pid != 0){
        wait();
 1f9:	e8 fc 02 00 00       	call   4fa <wait>
    }

    if(pid != 0){
    printf(1,"FATHER : \n");
 1fe:	83 ec 08             	sub    $0x8,%esp
 201:	8d 5d a4             	lea    -0x5c(%ebp),%ebx
 204:	8d 75 f8             	lea    -0x8(%ebp),%esi
 207:	68 03 0a 00 00       	push   $0xa03
 20c:	6a 01                	push   $0x1
 20e:	e8 2d 04 00 00       	call   640 <printf>
 213:	83 c4 10             	add    $0x10,%esp
 216:	8d 76 00             	lea    0x0(%esi),%esi
 219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    for (i = 0 ; i < c ; i++){
    printf(1,"%c", *(char * )pointers[i]);
 220:	8b 03                	mov    (%ebx),%eax
 222:	83 ec 04             	sub    $0x4,%esp
 225:	83 c3 04             	add    $0x4,%ebx
 228:	0f be 00             	movsbl (%eax),%eax
 22b:	50                   	push   %eax
 22c:	68 f6 09 00 00       	push   $0x9f6
 231:	6a 01                	push   $0x1
 233:	e8 08 04 00 00       	call   640 <printf>
    for (i = 0 ; i < c ; i++){
 238:	83 c4 10             	add    $0x10,%esp
 23b:	39 de                	cmp    %ebx,%esi
 23d:	75 e1                	jne    220 <main1+0x70>
    printf(1, " \n DONE \n");
 23f:	83 ec 08             	sub    $0x8,%esp
 242:	68 f9 09 00 00       	push   $0x9f9
 247:	6a 01                	push   $0x1
 249:	e8 f2 03 00 00       	call   640 <printf>
    printf(1, " \n DONE \n");

    }


    exit();
 24e:	e8 9f 02 00 00       	call   4f2 <exit>
    printf(1,"SON : \n");
 253:	50                   	push   %eax
 254:	50                   	push   %eax
 255:	8d 5d a4             	lea    -0x5c(%ebp),%ebx
 258:	68 ee 09 00 00       	push   $0x9ee
 25d:	6a 01                	push   $0x1
 25f:	8d 75 f8             	lea    -0x8(%ebp),%esi
 262:	e8 d9 03 00 00       	call   640 <printf>
 267:	83 c4 10             	add    $0x10,%esp
 26a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printf(1,"%c", *(char * )pointers[i]);
 270:	8b 03                	mov    (%ebx),%eax
 272:	83 ec 04             	sub    $0x4,%esp
 275:	83 c3 04             	add    $0x4,%ebx
 278:	0f be 00             	movsbl (%eax),%eax
 27b:	50                   	push   %eax
 27c:	68 f6 09 00 00       	push   $0x9f6
 281:	6a 01                	push   $0x1
 283:	e8 b8 03 00 00       	call   640 <printf>
    for (i = 0 ; i < c ; i++){
 288:	83 c4 10             	add    $0x10,%esp
 28b:	39 de                	cmp    %ebx,%esi
 28d:	75 e1                	jne    270 <main1+0xc0>
 28f:	eb ae                	jmp    23f <main1+0x8f>
 291:	66 90                	xchg   %ax,%ax
 293:	66 90                	xchg   %ax,%ax
 295:	66 90                	xchg   %ax,%ax
 297:	66 90                	xchg   %ax,%ax
 299:	66 90                	xchg   %ax,%ax
 29b:	66 90                	xchg   %ax,%ax
 29d:	66 90                	xchg   %ax,%ax
 29f:	90                   	nop

000002a0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	53                   	push   %ebx
 2a4:	8b 45 08             	mov    0x8(%ebp),%eax
 2a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2aa:	89 c2                	mov    %eax,%edx
 2ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2b0:	83 c1 01             	add    $0x1,%ecx
 2b3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 2b7:	83 c2 01             	add    $0x1,%edx
 2ba:	84 db                	test   %bl,%bl
 2bc:	88 5a ff             	mov    %bl,-0x1(%edx)
 2bf:	75 ef                	jne    2b0 <strcpy+0x10>
    ;
  return os;
}
 2c1:	5b                   	pop    %ebx
 2c2:	5d                   	pop    %ebp
 2c3:	c3                   	ret    
 2c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 2ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000002d0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	53                   	push   %ebx
 2d4:	8b 55 08             	mov    0x8(%ebp),%edx
 2d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 2da:	0f b6 02             	movzbl (%edx),%eax
 2dd:	0f b6 19             	movzbl (%ecx),%ebx
 2e0:	84 c0                	test   %al,%al
 2e2:	75 1c                	jne    300 <strcmp+0x30>
 2e4:	eb 2a                	jmp    310 <strcmp+0x40>
 2e6:	8d 76 00             	lea    0x0(%esi),%esi
 2e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 2f0:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 2f3:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 2f6:	83 c1 01             	add    $0x1,%ecx
 2f9:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 2fc:	84 c0                	test   %al,%al
 2fe:	74 10                	je     310 <strcmp+0x40>
 300:	38 d8                	cmp    %bl,%al
 302:	74 ec                	je     2f0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 304:	29 d8                	sub    %ebx,%eax
}
 306:	5b                   	pop    %ebx
 307:	5d                   	pop    %ebp
 308:	c3                   	ret    
 309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 310:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 312:	29 d8                	sub    %ebx,%eax
}
 314:	5b                   	pop    %ebx
 315:	5d                   	pop    %ebp
 316:	c3                   	ret    
 317:	89 f6                	mov    %esi,%esi
 319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000320 <strlen>:

uint
strlen(const char *s)
{
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 326:	80 39 00             	cmpb   $0x0,(%ecx)
 329:	74 15                	je     340 <strlen+0x20>
 32b:	31 d2                	xor    %edx,%edx
 32d:	8d 76 00             	lea    0x0(%esi),%esi
 330:	83 c2 01             	add    $0x1,%edx
 333:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 337:	89 d0                	mov    %edx,%eax
 339:	75 f5                	jne    330 <strlen+0x10>
    ;
  return n;
}
 33b:	5d                   	pop    %ebp
 33c:	c3                   	ret    
 33d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 340:	31 c0                	xor    %eax,%eax
}
 342:	5d                   	pop    %ebp
 343:	c3                   	ret    
 344:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 34a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000350 <memset>:

void*
memset(void *dst, int c, uint n)
{
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	57                   	push   %edi
 354:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 357:	8b 4d 10             	mov    0x10(%ebp),%ecx
 35a:	8b 45 0c             	mov    0xc(%ebp),%eax
 35d:	89 d7                	mov    %edx,%edi
 35f:	fc                   	cld    
 360:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 362:	89 d0                	mov    %edx,%eax
 364:	5f                   	pop    %edi
 365:	5d                   	pop    %ebp
 366:	c3                   	ret    
 367:	89 f6                	mov    %esi,%esi
 369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000370 <strchr>:

char*
strchr(const char *s, char c)
{
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	53                   	push   %ebx
 374:	8b 45 08             	mov    0x8(%ebp),%eax
 377:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 37a:	0f b6 10             	movzbl (%eax),%edx
 37d:	84 d2                	test   %dl,%dl
 37f:	74 1d                	je     39e <strchr+0x2e>
    if(*s == c)
 381:	38 d3                	cmp    %dl,%bl
 383:	89 d9                	mov    %ebx,%ecx
 385:	75 0d                	jne    394 <strchr+0x24>
 387:	eb 17                	jmp    3a0 <strchr+0x30>
 389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 390:	38 ca                	cmp    %cl,%dl
 392:	74 0c                	je     3a0 <strchr+0x30>
  for(; *s; s++)
 394:	83 c0 01             	add    $0x1,%eax
 397:	0f b6 10             	movzbl (%eax),%edx
 39a:	84 d2                	test   %dl,%dl
 39c:	75 f2                	jne    390 <strchr+0x20>
      return (char*)s;
  return 0;
 39e:	31 c0                	xor    %eax,%eax
}
 3a0:	5b                   	pop    %ebx
 3a1:	5d                   	pop    %ebp
 3a2:	c3                   	ret    
 3a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 3a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003b0 <gets>:

char*
gets(char *buf, int max)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	57                   	push   %edi
 3b4:	56                   	push   %esi
 3b5:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3b6:	31 f6                	xor    %esi,%esi
 3b8:	89 f3                	mov    %esi,%ebx
{
 3ba:	83 ec 1c             	sub    $0x1c,%esp
 3bd:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 3c0:	eb 2f                	jmp    3f1 <gets+0x41>
 3c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 3c8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 3cb:	83 ec 04             	sub    $0x4,%esp
 3ce:	6a 01                	push   $0x1
 3d0:	50                   	push   %eax
 3d1:	6a 00                	push   $0x0
 3d3:	e8 32 01 00 00       	call   50a <read>
    if(cc < 1)
 3d8:	83 c4 10             	add    $0x10,%esp
 3db:	85 c0                	test   %eax,%eax
 3dd:	7e 1c                	jle    3fb <gets+0x4b>
      break;
    buf[i++] = c;
 3df:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 3e3:	83 c7 01             	add    $0x1,%edi
 3e6:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 3e9:	3c 0a                	cmp    $0xa,%al
 3eb:	74 23                	je     410 <gets+0x60>
 3ed:	3c 0d                	cmp    $0xd,%al
 3ef:	74 1f                	je     410 <gets+0x60>
  for(i=0; i+1 < max; ){
 3f1:	83 c3 01             	add    $0x1,%ebx
 3f4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 3f7:	89 fe                	mov    %edi,%esi
 3f9:	7c cd                	jl     3c8 <gets+0x18>
 3fb:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 3fd:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 400:	c6 03 00             	movb   $0x0,(%ebx)
}
 403:	8d 65 f4             	lea    -0xc(%ebp),%esp
 406:	5b                   	pop    %ebx
 407:	5e                   	pop    %esi
 408:	5f                   	pop    %edi
 409:	5d                   	pop    %ebp
 40a:	c3                   	ret    
 40b:	90                   	nop
 40c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 410:	8b 75 08             	mov    0x8(%ebp),%esi
 413:	8b 45 08             	mov    0x8(%ebp),%eax
 416:	01 de                	add    %ebx,%esi
 418:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 41a:	c6 03 00             	movb   $0x0,(%ebx)
}
 41d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 420:	5b                   	pop    %ebx
 421:	5e                   	pop    %esi
 422:	5f                   	pop    %edi
 423:	5d                   	pop    %ebp
 424:	c3                   	ret    
 425:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000430 <stat>:

int
stat(const char *n, struct stat *st)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	56                   	push   %esi
 434:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 435:	83 ec 08             	sub    $0x8,%esp
 438:	6a 00                	push   $0x0
 43a:	ff 75 08             	pushl  0x8(%ebp)
 43d:	e8 f0 00 00 00       	call   532 <open>
  if(fd < 0)
 442:	83 c4 10             	add    $0x10,%esp
 445:	85 c0                	test   %eax,%eax
 447:	78 27                	js     470 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 449:	83 ec 08             	sub    $0x8,%esp
 44c:	ff 75 0c             	pushl  0xc(%ebp)
 44f:	89 c3                	mov    %eax,%ebx
 451:	50                   	push   %eax
 452:	e8 f3 00 00 00       	call   54a <fstat>
  close(fd);
 457:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 45a:	89 c6                	mov    %eax,%esi
  close(fd);
 45c:	e8 b9 00 00 00       	call   51a <close>
  return r;
 461:	83 c4 10             	add    $0x10,%esp
}
 464:	8d 65 f8             	lea    -0x8(%ebp),%esp
 467:	89 f0                	mov    %esi,%eax
 469:	5b                   	pop    %ebx
 46a:	5e                   	pop    %esi
 46b:	5d                   	pop    %ebp
 46c:	c3                   	ret    
 46d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 470:	be ff ff ff ff       	mov    $0xffffffff,%esi
 475:	eb ed                	jmp    464 <stat+0x34>
 477:	89 f6                	mov    %esi,%esi
 479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000480 <atoi>:

int
atoi(const char *s)
{
 480:	55                   	push   %ebp
 481:	89 e5                	mov    %esp,%ebp
 483:	53                   	push   %ebx
 484:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 487:	0f be 11             	movsbl (%ecx),%edx
 48a:	8d 42 d0             	lea    -0x30(%edx),%eax
 48d:	3c 09                	cmp    $0x9,%al
  n = 0;
 48f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 494:	77 1f                	ja     4b5 <atoi+0x35>
 496:	8d 76 00             	lea    0x0(%esi),%esi
 499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 4a0:	8d 04 80             	lea    (%eax,%eax,4),%eax
 4a3:	83 c1 01             	add    $0x1,%ecx
 4a6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 4aa:	0f be 11             	movsbl (%ecx),%edx
 4ad:	8d 5a d0             	lea    -0x30(%edx),%ebx
 4b0:	80 fb 09             	cmp    $0x9,%bl
 4b3:	76 eb                	jbe    4a0 <atoi+0x20>
  return n;
}
 4b5:	5b                   	pop    %ebx
 4b6:	5d                   	pop    %ebp
 4b7:	c3                   	ret    
 4b8:	90                   	nop
 4b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000004c0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4c0:	55                   	push   %ebp
 4c1:	89 e5                	mov    %esp,%ebp
 4c3:	56                   	push   %esi
 4c4:	53                   	push   %ebx
 4c5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4c8:	8b 45 08             	mov    0x8(%ebp),%eax
 4cb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4ce:	85 db                	test   %ebx,%ebx
 4d0:	7e 14                	jle    4e6 <memmove+0x26>
 4d2:	31 d2                	xor    %edx,%edx
 4d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 4d8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 4dc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 4df:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 4e2:	39 d3                	cmp    %edx,%ebx
 4e4:	75 f2                	jne    4d8 <memmove+0x18>
  return vdst;
}
 4e6:	5b                   	pop    %ebx
 4e7:	5e                   	pop    %esi
 4e8:	5d                   	pop    %ebp
 4e9:	c3                   	ret    

000004ea <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4ea:	b8 01 00 00 00       	mov    $0x1,%eax
 4ef:	cd 40                	int    $0x40
 4f1:	c3                   	ret    

000004f2 <exit>:
SYSCALL(exit)
 4f2:	b8 02 00 00 00       	mov    $0x2,%eax
 4f7:	cd 40                	int    $0x40
 4f9:	c3                   	ret    

000004fa <wait>:
SYSCALL(wait)
 4fa:	b8 03 00 00 00       	mov    $0x3,%eax
 4ff:	cd 40                	int    $0x40
 501:	c3                   	ret    

00000502 <pipe>:
SYSCALL(pipe)
 502:	b8 04 00 00 00       	mov    $0x4,%eax
 507:	cd 40                	int    $0x40
 509:	c3                   	ret    

0000050a <read>:
SYSCALL(read)
 50a:	b8 05 00 00 00       	mov    $0x5,%eax
 50f:	cd 40                	int    $0x40
 511:	c3                   	ret    

00000512 <write>:
SYSCALL(write)
 512:	b8 10 00 00 00       	mov    $0x10,%eax
 517:	cd 40                	int    $0x40
 519:	c3                   	ret    

0000051a <close>:
SYSCALL(close)
 51a:	b8 15 00 00 00       	mov    $0x15,%eax
 51f:	cd 40                	int    $0x40
 521:	c3                   	ret    

00000522 <kill>:
SYSCALL(kill)
 522:	b8 06 00 00 00       	mov    $0x6,%eax
 527:	cd 40                	int    $0x40
 529:	c3                   	ret    

0000052a <exec>:
SYSCALL(exec)
 52a:	b8 07 00 00 00       	mov    $0x7,%eax
 52f:	cd 40                	int    $0x40
 531:	c3                   	ret    

00000532 <open>:
SYSCALL(open)
 532:	b8 0f 00 00 00       	mov    $0xf,%eax
 537:	cd 40                	int    $0x40
 539:	c3                   	ret    

0000053a <mknod>:
SYSCALL(mknod)
 53a:	b8 11 00 00 00       	mov    $0x11,%eax
 53f:	cd 40                	int    $0x40
 541:	c3                   	ret    

00000542 <unlink>:
SYSCALL(unlink)
 542:	b8 12 00 00 00       	mov    $0x12,%eax
 547:	cd 40                	int    $0x40
 549:	c3                   	ret    

0000054a <fstat>:
SYSCALL(fstat)
 54a:	b8 08 00 00 00       	mov    $0x8,%eax
 54f:	cd 40                	int    $0x40
 551:	c3                   	ret    

00000552 <link>:
SYSCALL(link)
 552:	b8 13 00 00 00       	mov    $0x13,%eax
 557:	cd 40                	int    $0x40
 559:	c3                   	ret    

0000055a <mkdir>:
SYSCALL(mkdir)
 55a:	b8 14 00 00 00       	mov    $0x14,%eax
 55f:	cd 40                	int    $0x40
 561:	c3                   	ret    

00000562 <chdir>:
SYSCALL(chdir)
 562:	b8 09 00 00 00       	mov    $0x9,%eax
 567:	cd 40                	int    $0x40
 569:	c3                   	ret    

0000056a <dup>:
SYSCALL(dup)
 56a:	b8 0a 00 00 00       	mov    $0xa,%eax
 56f:	cd 40                	int    $0x40
 571:	c3                   	ret    

00000572 <getpid>:
SYSCALL(getpid)
 572:	b8 0b 00 00 00       	mov    $0xb,%eax
 577:	cd 40                	int    $0x40
 579:	c3                   	ret    

0000057a <sbrk>:
SYSCALL(sbrk)
 57a:	b8 0c 00 00 00       	mov    $0xc,%eax
 57f:	cd 40                	int    $0x40
 581:	c3                   	ret    

00000582 <sleep>:
SYSCALL(sleep)
 582:	b8 0d 00 00 00       	mov    $0xd,%eax
 587:	cd 40                	int    $0x40
 589:	c3                   	ret    

0000058a <uptime>:
SYSCALL(uptime)
 58a:	b8 0e 00 00 00       	mov    $0xe,%eax
 58f:	cd 40                	int    $0x40
 591:	c3                   	ret    

00000592 <get_number_of_free_pages>:
 592:	b8 16 00 00 00       	mov    $0x16,%eax
 597:	cd 40                	int    $0x40
 599:	c3                   	ret    
 59a:	66 90                	xchg   %ax,%ax
 59c:	66 90                	xchg   %ax,%ax
 59e:	66 90                	xchg   %ax,%ax

000005a0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 5a0:	55                   	push   %ebp
 5a1:	89 e5                	mov    %esp,%ebp
 5a3:	57                   	push   %edi
 5a4:	56                   	push   %esi
 5a5:	53                   	push   %ebx
 5a6:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5a9:	85 d2                	test   %edx,%edx
{
 5ab:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 5ae:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 5b0:	79 76                	jns    628 <printint+0x88>
 5b2:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 5b6:	74 70                	je     628 <printint+0x88>
    x = -xx;
 5b8:	f7 d8                	neg    %eax
    neg = 1;
 5ba:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 5c1:	31 f6                	xor    %esi,%esi
 5c3:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 5c6:	eb 0a                	jmp    5d2 <printint+0x32>
 5c8:	90                   	nop
 5c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 5d0:	89 fe                	mov    %edi,%esi
 5d2:	31 d2                	xor    %edx,%edx
 5d4:	8d 7e 01             	lea    0x1(%esi),%edi
 5d7:	f7 f1                	div    %ecx
 5d9:	0f b6 92 f4 0a 00 00 	movzbl 0xaf4(%edx),%edx
  }while((x /= base) != 0);
 5e0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 5e2:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 5e5:	75 e9                	jne    5d0 <printint+0x30>
  if(neg)
 5e7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 5ea:	85 c0                	test   %eax,%eax
 5ec:	74 08                	je     5f6 <printint+0x56>
    buf[i++] = '-';
 5ee:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 5f3:	8d 7e 02             	lea    0x2(%esi),%edi
 5f6:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 5fa:	8b 7d c0             	mov    -0x40(%ebp),%edi
 5fd:	8d 76 00             	lea    0x0(%esi),%esi
 600:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 603:	83 ec 04             	sub    $0x4,%esp
 606:	83 ee 01             	sub    $0x1,%esi
 609:	6a 01                	push   $0x1
 60b:	53                   	push   %ebx
 60c:	57                   	push   %edi
 60d:	88 45 d7             	mov    %al,-0x29(%ebp)
 610:	e8 fd fe ff ff       	call   512 <write>

  while(--i >= 0)
 615:	83 c4 10             	add    $0x10,%esp
 618:	39 de                	cmp    %ebx,%esi
 61a:	75 e4                	jne    600 <printint+0x60>
    putc(fd, buf[i]);
}
 61c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 61f:	5b                   	pop    %ebx
 620:	5e                   	pop    %esi
 621:	5f                   	pop    %edi
 622:	5d                   	pop    %ebp
 623:	c3                   	ret    
 624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 628:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 62f:	eb 90                	jmp    5c1 <printint+0x21>
 631:	eb 0d                	jmp    640 <printf>
 633:	90                   	nop
 634:	90                   	nop
 635:	90                   	nop
 636:	90                   	nop
 637:	90                   	nop
 638:	90                   	nop
 639:	90                   	nop
 63a:	90                   	nop
 63b:	90                   	nop
 63c:	90                   	nop
 63d:	90                   	nop
 63e:	90                   	nop
 63f:	90                   	nop

00000640 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 640:	55                   	push   %ebp
 641:	89 e5                	mov    %esp,%ebp
 643:	57                   	push   %edi
 644:	56                   	push   %esi
 645:	53                   	push   %ebx
 646:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 649:	8b 75 0c             	mov    0xc(%ebp),%esi
 64c:	0f b6 1e             	movzbl (%esi),%ebx
 64f:	84 db                	test   %bl,%bl
 651:	0f 84 b3 00 00 00    	je     70a <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 657:	8d 45 10             	lea    0x10(%ebp),%eax
 65a:	83 c6 01             	add    $0x1,%esi
  state = 0;
 65d:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 65f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 662:	eb 2f                	jmp    693 <printf+0x53>
 664:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 668:	83 f8 25             	cmp    $0x25,%eax
 66b:	0f 84 a7 00 00 00    	je     718 <printf+0xd8>
  write(fd, &c, 1);
 671:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 674:	83 ec 04             	sub    $0x4,%esp
 677:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 67a:	6a 01                	push   $0x1
 67c:	50                   	push   %eax
 67d:	ff 75 08             	pushl  0x8(%ebp)
 680:	e8 8d fe ff ff       	call   512 <write>
 685:	83 c4 10             	add    $0x10,%esp
 688:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 68b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 68f:	84 db                	test   %bl,%bl
 691:	74 77                	je     70a <printf+0xca>
    if(state == 0){
 693:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 695:	0f be cb             	movsbl %bl,%ecx
 698:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 69b:	74 cb                	je     668 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 69d:	83 ff 25             	cmp    $0x25,%edi
 6a0:	75 e6                	jne    688 <printf+0x48>
      if(c == 'd'){
 6a2:	83 f8 64             	cmp    $0x64,%eax
 6a5:	0f 84 05 01 00 00    	je     7b0 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 6ab:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 6b1:	83 f9 70             	cmp    $0x70,%ecx
 6b4:	74 72                	je     728 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 6b6:	83 f8 73             	cmp    $0x73,%eax
 6b9:	0f 84 99 00 00 00    	je     758 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6bf:	83 f8 63             	cmp    $0x63,%eax
 6c2:	0f 84 08 01 00 00    	je     7d0 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 6c8:	83 f8 25             	cmp    $0x25,%eax
 6cb:	0f 84 ef 00 00 00    	je     7c0 <printf+0x180>
  write(fd, &c, 1);
 6d1:	8d 45 e7             	lea    -0x19(%ebp),%eax
 6d4:	83 ec 04             	sub    $0x4,%esp
 6d7:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 6db:	6a 01                	push   $0x1
 6dd:	50                   	push   %eax
 6de:	ff 75 08             	pushl  0x8(%ebp)
 6e1:	e8 2c fe ff ff       	call   512 <write>
 6e6:	83 c4 0c             	add    $0xc,%esp
 6e9:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 6ec:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 6ef:	6a 01                	push   $0x1
 6f1:	50                   	push   %eax
 6f2:	ff 75 08             	pushl  0x8(%ebp)
 6f5:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6f8:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 6fa:	e8 13 fe ff ff       	call   512 <write>
  for(i = 0; fmt[i]; i++){
 6ff:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 703:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 706:	84 db                	test   %bl,%bl
 708:	75 89                	jne    693 <printf+0x53>
    }
  }
}
 70a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 70d:	5b                   	pop    %ebx
 70e:	5e                   	pop    %esi
 70f:	5f                   	pop    %edi
 710:	5d                   	pop    %ebp
 711:	c3                   	ret    
 712:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 718:	bf 25 00 00 00       	mov    $0x25,%edi
 71d:	e9 66 ff ff ff       	jmp    688 <printf+0x48>
 722:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 728:	83 ec 0c             	sub    $0xc,%esp
 72b:	b9 10 00 00 00       	mov    $0x10,%ecx
 730:	6a 00                	push   $0x0
 732:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 735:	8b 45 08             	mov    0x8(%ebp),%eax
 738:	8b 17                	mov    (%edi),%edx
 73a:	e8 61 fe ff ff       	call   5a0 <printint>
        ap++;
 73f:	89 f8                	mov    %edi,%eax
 741:	83 c4 10             	add    $0x10,%esp
      state = 0;
 744:	31 ff                	xor    %edi,%edi
        ap++;
 746:	83 c0 04             	add    $0x4,%eax
 749:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 74c:	e9 37 ff ff ff       	jmp    688 <printf+0x48>
 751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 758:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 75b:	8b 08                	mov    (%eax),%ecx
        ap++;
 75d:	83 c0 04             	add    $0x4,%eax
 760:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 763:	85 c9                	test   %ecx,%ecx
 765:	0f 84 8e 00 00 00    	je     7f9 <printf+0x1b9>
        while(*s != 0){
 76b:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 76e:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 770:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 772:	84 c0                	test   %al,%al
 774:	0f 84 0e ff ff ff    	je     688 <printf+0x48>
 77a:	89 75 d0             	mov    %esi,-0x30(%ebp)
 77d:	89 de                	mov    %ebx,%esi
 77f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 782:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 785:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 788:	83 ec 04             	sub    $0x4,%esp
          s++;
 78b:	83 c6 01             	add    $0x1,%esi
 78e:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 791:	6a 01                	push   $0x1
 793:	57                   	push   %edi
 794:	53                   	push   %ebx
 795:	e8 78 fd ff ff       	call   512 <write>
        while(*s != 0){
 79a:	0f b6 06             	movzbl (%esi),%eax
 79d:	83 c4 10             	add    $0x10,%esp
 7a0:	84 c0                	test   %al,%al
 7a2:	75 e4                	jne    788 <printf+0x148>
 7a4:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 7a7:	31 ff                	xor    %edi,%edi
 7a9:	e9 da fe ff ff       	jmp    688 <printf+0x48>
 7ae:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 7b0:	83 ec 0c             	sub    $0xc,%esp
 7b3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 7b8:	6a 01                	push   $0x1
 7ba:	e9 73 ff ff ff       	jmp    732 <printf+0xf2>
 7bf:	90                   	nop
  write(fd, &c, 1);
 7c0:	83 ec 04             	sub    $0x4,%esp
 7c3:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 7c6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 7c9:	6a 01                	push   $0x1
 7cb:	e9 21 ff ff ff       	jmp    6f1 <printf+0xb1>
        putc(fd, *ap);
 7d0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 7d3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 7d6:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 7d8:	6a 01                	push   $0x1
        ap++;
 7da:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 7dd:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 7e0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 7e3:	50                   	push   %eax
 7e4:	ff 75 08             	pushl  0x8(%ebp)
 7e7:	e8 26 fd ff ff       	call   512 <write>
        ap++;
 7ec:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 7ef:	83 c4 10             	add    $0x10,%esp
      state = 0;
 7f2:	31 ff                	xor    %edi,%edi
 7f4:	e9 8f fe ff ff       	jmp    688 <printf+0x48>
          s = "(null)";
 7f9:	bb ec 0a 00 00       	mov    $0xaec,%ebx
        while(*s != 0){
 7fe:	b8 28 00 00 00       	mov    $0x28,%eax
 803:	e9 72 ff ff ff       	jmp    77a <printf+0x13a>
 808:	66 90                	xchg   %ax,%ax
 80a:	66 90                	xchg   %ax,%ax
 80c:	66 90                	xchg   %ax,%ax
 80e:	66 90                	xchg   %ax,%ax

00000810 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 810:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 811:	a1 00 0e 00 00       	mov    0xe00,%eax
{
 816:	89 e5                	mov    %esp,%ebp
 818:	57                   	push   %edi
 819:	56                   	push   %esi
 81a:	53                   	push   %ebx
 81b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 81e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 821:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 828:	39 c8                	cmp    %ecx,%eax
 82a:	8b 10                	mov    (%eax),%edx
 82c:	73 32                	jae    860 <free+0x50>
 82e:	39 d1                	cmp    %edx,%ecx
 830:	72 04                	jb     836 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 832:	39 d0                	cmp    %edx,%eax
 834:	72 32                	jb     868 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 836:	8b 73 fc             	mov    -0x4(%ebx),%esi
 839:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 83c:	39 fa                	cmp    %edi,%edx
 83e:	74 30                	je     870 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 840:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 843:	8b 50 04             	mov    0x4(%eax),%edx
 846:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 849:	39 f1                	cmp    %esi,%ecx
 84b:	74 3a                	je     887 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 84d:	89 08                	mov    %ecx,(%eax)
  freep = p;
 84f:	a3 00 0e 00 00       	mov    %eax,0xe00
}
 854:	5b                   	pop    %ebx
 855:	5e                   	pop    %esi
 856:	5f                   	pop    %edi
 857:	5d                   	pop    %ebp
 858:	c3                   	ret    
 859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 860:	39 d0                	cmp    %edx,%eax
 862:	72 04                	jb     868 <free+0x58>
 864:	39 d1                	cmp    %edx,%ecx
 866:	72 ce                	jb     836 <free+0x26>
{
 868:	89 d0                	mov    %edx,%eax
 86a:	eb bc                	jmp    828 <free+0x18>
 86c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 870:	03 72 04             	add    0x4(%edx),%esi
 873:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 876:	8b 10                	mov    (%eax),%edx
 878:	8b 12                	mov    (%edx),%edx
 87a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 87d:	8b 50 04             	mov    0x4(%eax),%edx
 880:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 883:	39 f1                	cmp    %esi,%ecx
 885:	75 c6                	jne    84d <free+0x3d>
    p->s.size += bp->s.size;
 887:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 88a:	a3 00 0e 00 00       	mov    %eax,0xe00
    p->s.size += bp->s.size;
 88f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 892:	8b 53 f8             	mov    -0x8(%ebx),%edx
 895:	89 10                	mov    %edx,(%eax)
}
 897:	5b                   	pop    %ebx
 898:	5e                   	pop    %esi
 899:	5f                   	pop    %edi
 89a:	5d                   	pop    %ebp
 89b:	c3                   	ret    
 89c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000008a0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8a0:	55                   	push   %ebp
 8a1:	89 e5                	mov    %esp,%ebp
 8a3:	57                   	push   %edi
 8a4:	56                   	push   %esi
 8a5:	53                   	push   %ebx
 8a6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8a9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 8ac:	8b 15 00 0e 00 00    	mov    0xe00,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8b2:	8d 78 07             	lea    0x7(%eax),%edi
 8b5:	c1 ef 03             	shr    $0x3,%edi
 8b8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 8bb:	85 d2                	test   %edx,%edx
 8bd:	0f 84 9d 00 00 00    	je     960 <malloc+0xc0>
 8c3:	8b 02                	mov    (%edx),%eax
 8c5:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 8c8:	39 cf                	cmp    %ecx,%edi
 8ca:	76 6c                	jbe    938 <malloc+0x98>
 8cc:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 8d2:	bb 00 10 00 00       	mov    $0x1000,%ebx
 8d7:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 8da:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 8e1:	eb 0e                	jmp    8f1 <malloc+0x51>
 8e3:	90                   	nop
 8e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 8ea:	8b 48 04             	mov    0x4(%eax),%ecx
 8ed:	39 f9                	cmp    %edi,%ecx
 8ef:	73 47                	jae    938 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8f1:	39 05 00 0e 00 00    	cmp    %eax,0xe00
 8f7:	89 c2                	mov    %eax,%edx
 8f9:	75 ed                	jne    8e8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 8fb:	83 ec 0c             	sub    $0xc,%esp
 8fe:	56                   	push   %esi
 8ff:	e8 76 fc ff ff       	call   57a <sbrk>
  if(p == (char*)-1)
 904:	83 c4 10             	add    $0x10,%esp
 907:	83 f8 ff             	cmp    $0xffffffff,%eax
 90a:	74 1c                	je     928 <malloc+0x88>
  hp->s.size = nu;
 90c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 90f:	83 ec 0c             	sub    $0xc,%esp
 912:	83 c0 08             	add    $0x8,%eax
 915:	50                   	push   %eax
 916:	e8 f5 fe ff ff       	call   810 <free>
  return freep;
 91b:	8b 15 00 0e 00 00    	mov    0xe00,%edx
      if((p = morecore(nunits)) == 0)
 921:	83 c4 10             	add    $0x10,%esp
 924:	85 d2                	test   %edx,%edx
 926:	75 c0                	jne    8e8 <malloc+0x48>
        return 0;
  }
}
 928:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 92b:	31 c0                	xor    %eax,%eax
}
 92d:	5b                   	pop    %ebx
 92e:	5e                   	pop    %esi
 92f:	5f                   	pop    %edi
 930:	5d                   	pop    %ebp
 931:	c3                   	ret    
 932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 938:	39 cf                	cmp    %ecx,%edi
 93a:	74 54                	je     990 <malloc+0xf0>
        p->s.size -= nunits;
 93c:	29 f9                	sub    %edi,%ecx
 93e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 941:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 944:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 947:	89 15 00 0e 00 00    	mov    %edx,0xe00
}
 94d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 950:	83 c0 08             	add    $0x8,%eax
}
 953:	5b                   	pop    %ebx
 954:	5e                   	pop    %esi
 955:	5f                   	pop    %edi
 956:	5d                   	pop    %ebp
 957:	c3                   	ret    
 958:	90                   	nop
 959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 960:	c7 05 00 0e 00 00 04 	movl   $0xe04,0xe00
 967:	0e 00 00 
 96a:	c7 05 04 0e 00 00 04 	movl   $0xe04,0xe04
 971:	0e 00 00 
    base.s.size = 0;
 974:	b8 04 0e 00 00       	mov    $0xe04,%eax
 979:	c7 05 08 0e 00 00 00 	movl   $0x0,0xe08
 980:	00 00 00 
 983:	e9 44 ff ff ff       	jmp    8cc <malloc+0x2c>
 988:	90                   	nop
 989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 990:	8b 08                	mov    (%eax),%ecx
 992:	89 0a                	mov    %ecx,(%edx)
 994:	eb b1                	jmp    947 <malloc+0xa7>
