
_test:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    printf(1, "%s\n", buffer);
    wait();
    exit();
}
int main(int argc, char *argv[])
{   
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	56                   	push   %esi
    Fmem[0] = malloc(n_of_allocations * PGSIZE);
    printf(1, "Allocation done\n");
    sleep(500);
    int i = 0;
    while (i <50) {
        *(Fmem[0] + PGSIZE * (i % n_of_allocations)) = 'c';
  12:	be cd cc cc cc       	mov    $0xcccccccd,%esi
{   
  17:	53                   	push   %ebx
  18:	51                   	push   %ecx
  19:	83 ec 18             	sub    $0x18,%esp
    Fmem[0] = malloc(n_of_allocations * PGSIZE);
  1c:	68 00 40 01 00       	push   $0x14000
  21:	e8 1a 09 00 00       	call   940 <malloc>
  26:	89 c3                	mov    %eax,%ebx
    printf(1, "Allocation done\n");
  28:	58                   	pop    %eax
  29:	5a                   	pop    %edx
  2a:	68 4c 0a 00 00       	push   $0xa4c
  2f:	6a 01                	push   $0x1
  31:	e8 aa 06 00 00       	call   6e0 <printf>
    sleep(500);
  36:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
  3d:	e8 d1 05 00 00       	call   613 <sleep>
  42:	83 c4 10             	add    $0x10,%esp
    int i = 0;
  45:	31 c9                	xor    %ecx,%ecx
  47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  4e:	66 90                	xchg   %ax,%ax
        *(Fmem[0] + PGSIZE * (i % n_of_allocations)) = 'c';
  50:	89 c8                	mov    %ecx,%eax
  52:	f7 e6                	mul    %esi
  54:	c1 ea 04             	shr    $0x4,%edx
  57:	8d 04 92             	lea    (%edx,%edx,4),%eax
  5a:	89 ca                	mov    %ecx,%edx
        i++;
  5c:	83 c1 01             	add    $0x1,%ecx
        *(Fmem[0] + PGSIZE * (i % n_of_allocations)) = 'c';
  5f:	c1 e0 02             	shl    $0x2,%eax
  62:	29 c2                	sub    %eax,%edx
  64:	89 d0                	mov    %edx,%eax
  66:	c1 e0 0c             	shl    $0xc,%eax
  69:	c6 04 03 63          	movb   $0x63,(%ebx,%eax,1)
    while (i <50) {
  6d:	83 f9 32             	cmp    $0x32,%ecx
  70:	75 de                	jne    50 <main+0x50>
    }
    printf(1, "Access done1\n");
  72:	83 ec 08             	sub    $0x8,%esp
  75:	68 5d 0a 00 00       	push   $0xa5d
  7a:	6a 01                	push   $0x1
  7c:	e8 5f 06 00 00       	call   6e0 <printf>
    
    exit();
  81:	e8 fd 04 00 00       	call   583 <exit>
  86:	66 90                	xchg   %ax,%ax
  88:	66 90                	xchg   %ax,%ax
  8a:	66 90                	xchg   %ax,%ax
  8c:	66 90                	xchg   %ax,%ax
  8e:	66 90                	xchg   %ax,%ax

00000090 <getNumberOfFreePages>:
int getNumberOfFreePages(){
  90:	f3 0f 1e fb          	endbr32 
    return get_number_of_free_pages();
  94:	e9 8a 05 00 00       	jmp    623 <get_number_of_free_pages>
  99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000000a0 <main23>:
int main23(int argc, char** argv){
  a0:	f3 0f 1e fb          	endbr32 
  a4:	55                   	push   %ebp
  a5:	89 e5                	mov    %esp,%ebp
  a7:	81 ec 00 10 00 00    	sub    $0x1000,%esp
  ad:	83 0c 24 00          	orl    $0x0,(%esp)
  b1:	83 ec 08             	sub    $0x8,%esp
    int pid = fork();
  b4:	e8 c2 04 00 00       	call   57b <fork>
    if (pid == 0){
  b9:	85 c0                	test   %eax,%eax
  bb:	75 29                	jne    e6 <main23+0x46>
        printf(1, "%s\n", buffer);
  bd:	50                   	push   %eax
  be:	8d 85 f8 ef ff ff    	lea    -0x1008(%ebp),%eax
  c4:	50                   	push   %eax
  c5:	68 48 0a 00 00       	push   $0xa48
  ca:	6a 01                	push   $0x1
        buffer[0] = 'H';
  cc:	66 c7 85 f8 ef ff ff 	movw   $0x4548,-0x1008(%ebp)
  d3:	48 45 
        buffer[2] = 0;
  d5:	c6 85 fa ef ff ff 00 	movb   $0x0,-0x1006(%ebp)
        printf(1, "%s\n", buffer);
  dc:	e8 ff 05 00 00       	call   6e0 <printf>
        exit();
  e1:	e8 9d 04 00 00       	call   583 <exit>
    sleep(100);
  e6:	83 ec 0c             	sub    $0xc,%esp
  e9:	6a 64                	push   $0x64
  eb:	e8 23 05 00 00       	call   613 <sleep>
    printf(1, "%s\n", buffer);
  f0:	83 c4 0c             	add    $0xc,%esp
  f3:	8d 85 f8 ef ff ff    	lea    -0x1008(%ebp),%eax
    buffer[0] = 'H';
  f9:	66 c7 85 f8 ef ff ff 	movw   $0x4548,-0x1008(%ebp)
 100:	48 45 
    printf(1, "%s\n", buffer);
 102:	50                   	push   %eax
 103:	68 48 0a 00 00       	push   $0xa48
 108:	6a 01                	push   $0x1
    buffer[2] = 0;
 10a:	c6 85 fa ef ff ff 00 	movb   $0x0,-0x1006(%ebp)
    printf(1, "%s\n", buffer);
 111:	e8 ca 05 00 00       	call   6e0 <printf>
    wait();
 116:	e8 70 04 00 00       	call   58b <wait>
    exit();
 11b:	e8 63 04 00 00       	call   583 <exit>

00000120 <main56>:
    return 0;
}
int
main56(void)
{
 120:	f3 0f 1e fb          	endbr32 
 124:	55                   	push   %ebp
 125:	89 e5                	mov    %esp,%ebp
 127:	56                   	push   %esi
 128:	53                   	push   %ebx
  uint c = 21;
  uint pointers[c];
   printf(1, "IN PARENT: BEFORE SBRK Number of occupied pages before fork %d\n" ,57344 - getNumberOfFreePages());
 
  // making sure I have more than 16 pages on RAM
  for (i = 0 ; i < c ; i++){
 129:	31 db                	xor    %ebx,%ebx
{
 12b:	83 ec 60             	sub    $0x60,%esp
    return get_number_of_free_pages();
 12e:	e8 f0 04 00 00       	call   623 <get_number_of_free_pages>
   printf(1, "IN PARENT: BEFORE SBRK Number of occupied pages before fork %d\n" ,57344 - getNumberOfFreePages());
 133:	83 ec 04             	sub    $0x4,%esp
    return get_number_of_free_pages();
 136:	89 c2                	mov    %eax,%edx
   printf(1, "IN PARENT: BEFORE SBRK Number of occupied pages before fork %d\n" ,57344 - getNumberOfFreePages());
 138:	b8 00 e0 00 00       	mov    $0xe000,%eax
 13d:	29 d0                	sub    %edx,%eax
 13f:	50                   	push   %eax
 140:	68 c4 0a 00 00       	push   $0xac4
 145:	6a 01                	push   $0x1
 147:	e8 94 05 00 00       	call   6e0 <printf>
 14c:	83 c4 10             	add    $0x10,%esp
 14f:	90                   	nop
        printf(1, "%d\n", i);
 150:	83 ec 04             	sub    $0x4,%esp
 153:	53                   	push   %ebx
 154:	68 6b 0a 00 00       	push   $0xa6b
 159:	6a 01                	push   $0x1
 15b:	e8 80 05 00 00       	call   6e0 <printf>
        pointers[i] = (uint)sbrk(4096);
 160:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
 167:	e8 9f 04 00 00       	call   60b <sbrk>
        * (char *) pointers[i] = (char) ('a' + i);
 16c:	8d 53 61             	lea    0x61(%ebx),%edx
  for (i = 0 ; i < c ; i++){
 16f:	83 c4 10             	add    $0x10,%esp
        pointers[i] = (uint)sbrk(4096);
 172:	89 44 9d a4          	mov    %eax,-0x5c(%ebp,%ebx,4)
  for (i = 0 ; i < c ; i++){
 176:	83 c3 01             	add    $0x1,%ebx
        * (char *) pointers[i] = (char) ('a' + i);
 179:	88 10                	mov    %dl,(%eax)
  for (i = 0 ; i < c ; i++){
 17b:	83 fb 15             	cmp    $0x15,%ebx
 17e:	75 d0                	jne    150 <main56+0x30>
 180:	8d 5d a4             	lea    -0x5c(%ebp),%ebx
 183:	8d 75 f8             	lea    -0x8(%ebp),%esi
 186:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 18d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    for (i = 0 ; i < c ; i++){  
        printf(1, "%c\n", *(char * )pointers[i]);
 190:	8b 03                	mov    (%ebx),%eax
 192:	83 ec 04             	sub    $0x4,%esp
 195:	83 c3 04             	add    $0x4,%ebx
 198:	0f be 00             	movsbl (%eax),%eax
 19b:	50                   	push   %eax
 19c:	68 84 0a 00 00       	push   $0xa84
 1a1:	6a 01                	push   $0x1
 1a3:	e8 38 05 00 00       	call   6e0 <printf>
    for (i = 0 ; i < c ; i++){  
 1a8:	83 c4 10             	add    $0x10,%esp
 1ab:	39 f3                	cmp    %esi,%ebx
 1ad:	75 e1                	jne    190 <main56+0x70>
    return get_number_of_free_pages();
 1af:	e8 6f 04 00 00       	call   623 <get_number_of_free_pages>
    }
  
  printf(1, "IN PARENT: Number of occupied pages before fork %d\n" ,57344 - getNumberOfFreePages());
 1b4:	bb 00 e0 00 00       	mov    $0xe000,%ebx
 1b9:	83 ec 04             	sub    $0x4,%esp
 1bc:	89 d9                	mov    %ebx,%ecx
 1be:	29 c1                	sub    %eax,%ecx
 1c0:	51                   	push   %ecx
 1c1:	68 04 0b 00 00       	push   $0xb04
 1c6:	6a 01                	push   $0x1
 1c8:	e8 13 05 00 00       	call   6e0 <printf>
  int pid;
  if( (pid = fork()) ==0){
 1cd:	e8 a9 03 00 00       	call   57b <fork>
 1d2:	8b 75 a4             	mov    -0x5c(%ebp),%esi
 1d5:	83 c4 10             	add    $0x10,%esp
 1d8:	85 c0                	test   %eax,%eax
 1da:	75 2e                	jne    20a <main56+0xea>
    return get_number_of_free_pages();
 1dc:	e8 42 04 00 00       	call   623 <get_number_of_free_pages>
      printf(1, "IN CHILD: Number of occupied pages after fork %d\n" ,57344 - getNumberOfFreePages());
 1e1:	29 c3                	sub    %eax,%ebx
 1e3:	51                   	push   %ecx
 1e4:	53                   	push   %ebx
 1e5:	68 38 0b 00 00       	push   $0xb38
 1ea:	6a 01                	push   $0x1
 1ec:	e8 ef 04 00 00       	call   6e0 <printf>
      * (char *) pointers[0] = (char) ('b');
       printf(1,"IN CHILD pointers[0] %c\n", *(char * )pointers[0]);
 1f1:	83 c4 0c             	add    $0xc,%esp
      * (char *) pointers[0] = (char) ('b');
 1f4:	c6 06 62             	movb   $0x62,(%esi)
       printf(1,"IN CHILD pointers[0] %c\n", *(char * )pointers[0]);
 1f7:	6a 62                	push   $0x62
 1f9:	68 6f 0a 00 00       	push   $0xa6f
 1fe:	6a 01                	push   $0x1
 200:	e8 db 04 00 00       	call   6e0 <printf>
      exit();
 205:	e8 79 03 00 00       	call   583 <exit>
  }
  else{
     wait();
 20a:	e8 7c 03 00 00       	call   58b <wait>
    return get_number_of_free_pages();
 20f:	e8 0f 04 00 00       	call   623 <get_number_of_free_pages>
    printf(1, "IN PARENT: Number of occupied pages after fork %d\n" ,57344 - getNumberOfFreePages());
 214:	29 c3                	sub    %eax,%ebx
 216:	52                   	push   %edx
 217:	53                   	push   %ebx
 218:	68 6c 0b 00 00       	push   $0xb6c
 21d:	6a 01                	push   $0x1
 21f:	e8 bc 04 00 00       	call   6e0 <printf>
    printf(1,"IN PARENT pointers[0] %c\n", *(char * )pointers[0]);
 224:	0f be 06             	movsbl (%esi),%eax
 227:	83 c4 0c             	add    $0xc,%esp
 22a:	50                   	push   %eax
 22b:	68 88 0a 00 00       	push   $0xa88
 230:	6a 01                	push   $0x1
 232:	e8 a9 04 00 00       	call   6e0 <printf>
  
  }
  exit();
 237:	e8 47 03 00 00       	call   583 <exit>
 23c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000240 <main10>:
}

int
main10(int argc, char *argv[])
{
 240:	f3 0f 1e fb          	endbr32 
 244:	55                   	push   %ebp
 245:	89 e5                	mov    %esp,%ebp
 247:	56                   	push   %esi
 248:	53                   	push   %ebx
    int i = 0;
    uint c = 21;
    uint pointers[c];
    int pid = 0;
    // making sure I have more than 16 pages on RAM
    for (i = 0 ; i < c ; i++){
 249:	31 db                	xor    %ebx,%ebx
{
 24b:	83 ec 60             	sub    $0x60,%esp
 24e:	66 90                	xchg   %ax,%ax
        printf(1, "%d\n", i);
 250:	83 ec 04             	sub    $0x4,%esp
 253:	53                   	push   %ebx
 254:	68 6b 0a 00 00       	push   $0xa6b
 259:	6a 01                	push   $0x1
 25b:	e8 80 04 00 00       	call   6e0 <printf>
        pointers[i] = (uint)sbrk(4096);
 260:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
 267:	e8 9f 03 00 00       	call   60b <sbrk>
        * (char *) pointers[i] = (char) ('a' + i);
 26c:	8d 53 61             	lea    0x61(%ebx),%edx
    for (i = 0 ; i < c ; i++){
 26f:	83 c4 10             	add    $0x10,%esp
        pointers[i] = (uint)sbrk(4096);
 272:	89 44 9d a4          	mov    %eax,-0x5c(%ebp,%ebx,4)
    for (i = 0 ; i < c ; i++){
 276:	83 c3 01             	add    $0x1,%ebx
        * (char *) pointers[i] = (char) ('a' + i);
 279:	88 10                	mov    %dl,(%eax)
    for (i = 0 ; i < c ; i++){
 27b:	83 fb 15             	cmp    $0x15,%ebx
 27e:	75 d0                	jne    250 <main10+0x10>
    }

    pid = fork();
 280:	e8 f6 02 00 00       	call   57b <fork>

    if(pid == 0){
 285:	85 c0                	test   %eax,%eax
 287:	74 52                	je     2db <main10+0x9b>

    }
    

    if(pid != 0){
        wait();
 289:	e8 fd 02 00 00       	call   58b <wait>
    }

    if(pid != 0){
    printf(1,"FATHER : \n");
 28e:	8d 5d a4             	lea    -0x5c(%ebp),%ebx
 291:	8d 75 f8             	lea    -0x8(%ebp),%esi
 294:	50                   	push   %eax
 295:	50                   	push   %eax
 296:	68 b7 0a 00 00       	push   $0xab7
 29b:	6a 01                	push   $0x1
 29d:	e8 3e 04 00 00       	call   6e0 <printf>
    for (i = 0 ; i < c ; i++){
 2a2:	83 c4 10             	add    $0x10,%esp
 2a5:	8d 76 00             	lea    0x0(%esi),%esi
    printf(1,"%c", *(char * )pointers[i]);
 2a8:	8b 03                	mov    (%ebx),%eax
 2aa:	83 ec 04             	sub    $0x4,%esp
 2ad:	83 c3 04             	add    $0x4,%ebx
 2b0:	0f be 00             	movsbl (%eax),%eax
 2b3:	50                   	push   %eax
 2b4:	68 aa 0a 00 00       	push   $0xaaa
 2b9:	6a 01                	push   $0x1
 2bb:	e8 20 04 00 00       	call   6e0 <printf>
    for (i = 0 ; i < c ; i++){
 2c0:	83 c4 10             	add    $0x10,%esp
 2c3:	39 de                	cmp    %ebx,%esi
 2c5:	75 e1                	jne    2a8 <main10+0x68>
    printf(1, " \n DONE \n");
 2c7:	83 ec 08             	sub    $0x8,%esp
 2ca:	68 ad 0a 00 00       	push   $0xaad
 2cf:	6a 01                	push   $0x1
 2d1:	e8 0a 04 00 00       	call   6e0 <printf>
    printf(1, " \n DONE \n");

    }


    exit();
 2d6:	e8 a8 02 00 00       	call   583 <exit>
    printf(1,"SON : \n");
 2db:	52                   	push   %edx
 2dc:	8d 5d a4             	lea    -0x5c(%ebp),%ebx
 2df:	8d 75 f8             	lea    -0x8(%ebp),%esi
 2e2:	52                   	push   %edx
 2e3:	68 a2 0a 00 00       	push   $0xaa2
 2e8:	6a 01                	push   $0x1
 2ea:	e8 f1 03 00 00       	call   6e0 <printf>
    for (i = 0 ; i < c ; i++){
 2ef:	83 c4 10             	add    $0x10,%esp
 2f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printf(1,"%c", *(char * )pointers[i]);
 2f8:	8b 03                	mov    (%ebx),%eax
 2fa:	83 ec 04             	sub    $0x4,%esp
 2fd:	83 c3 04             	add    $0x4,%ebx
 300:	0f be 00             	movsbl (%eax),%eax
 303:	50                   	push   %eax
 304:	68 aa 0a 00 00       	push   $0xaaa
 309:	6a 01                	push   $0x1
 30b:	e8 d0 03 00 00       	call   6e0 <printf>
    for (i = 0 ; i < c ; i++){
 310:	83 c4 10             	add    $0x10,%esp
 313:	39 de                	cmp    %ebx,%esi
 315:	75 e1                	jne    2f8 <main10+0xb8>
 317:	eb ae                	jmp    2c7 <main10+0x87>
 319:	66 90                	xchg   %ax,%ax
 31b:	66 90                	xchg   %ax,%ax
 31d:	66 90                	xchg   %ax,%ax
 31f:	90                   	nop

00000320 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 320:	f3 0f 1e fb          	endbr32 
 324:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 325:	31 c0                	xor    %eax,%eax
{
 327:	89 e5                	mov    %esp,%ebp
 329:	53                   	push   %ebx
 32a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 32d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
 330:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 334:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 337:	83 c0 01             	add    $0x1,%eax
 33a:	84 d2                	test   %dl,%dl
 33c:	75 f2                	jne    330 <strcpy+0x10>
    ;
  return os;
}
 33e:	89 c8                	mov    %ecx,%eax
 340:	5b                   	pop    %ebx
 341:	5d                   	pop    %ebp
 342:	c3                   	ret    
 343:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 34a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000350 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 350:	f3 0f 1e fb          	endbr32 
 354:	55                   	push   %ebp
 355:	89 e5                	mov    %esp,%ebp
 357:	53                   	push   %ebx
 358:	8b 4d 08             	mov    0x8(%ebp),%ecx
 35b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 35e:	0f b6 01             	movzbl (%ecx),%eax
 361:	0f b6 1a             	movzbl (%edx),%ebx
 364:	84 c0                	test   %al,%al
 366:	75 19                	jne    381 <strcmp+0x31>
 368:	eb 26                	jmp    390 <strcmp+0x40>
 36a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 370:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 374:	83 c1 01             	add    $0x1,%ecx
 377:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 37a:	0f b6 1a             	movzbl (%edx),%ebx
 37d:	84 c0                	test   %al,%al
 37f:	74 0f                	je     390 <strcmp+0x40>
 381:	38 d8                	cmp    %bl,%al
 383:	74 eb                	je     370 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 385:	29 d8                	sub    %ebx,%eax
}
 387:	5b                   	pop    %ebx
 388:	5d                   	pop    %ebp
 389:	c3                   	ret    
 38a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 390:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 392:	29 d8                	sub    %ebx,%eax
}
 394:	5b                   	pop    %ebx
 395:	5d                   	pop    %ebp
 396:	c3                   	ret    
 397:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 39e:	66 90                	xchg   %ax,%ax

000003a0 <strlen>:

uint
strlen(const char *s)
{
 3a0:	f3 0f 1e fb          	endbr32 
 3a4:	55                   	push   %ebp
 3a5:	89 e5                	mov    %esp,%ebp
 3a7:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 3aa:	80 3a 00             	cmpb   $0x0,(%edx)
 3ad:	74 21                	je     3d0 <strlen+0x30>
 3af:	31 c0                	xor    %eax,%eax
 3b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3b8:	83 c0 01             	add    $0x1,%eax
 3bb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 3bf:	89 c1                	mov    %eax,%ecx
 3c1:	75 f5                	jne    3b8 <strlen+0x18>
    ;
  return n;
}
 3c3:	89 c8                	mov    %ecx,%eax
 3c5:	5d                   	pop    %ebp
 3c6:	c3                   	ret    
 3c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3ce:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
 3d0:	31 c9                	xor    %ecx,%ecx
}
 3d2:	5d                   	pop    %ebp
 3d3:	89 c8                	mov    %ecx,%eax
 3d5:	c3                   	ret    
 3d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3dd:	8d 76 00             	lea    0x0(%esi),%esi

000003e0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3e0:	f3 0f 1e fb          	endbr32 
 3e4:	55                   	push   %ebp
 3e5:	89 e5                	mov    %esp,%ebp
 3e7:	57                   	push   %edi
 3e8:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 3eb:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3ee:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f1:	89 d7                	mov    %edx,%edi
 3f3:	fc                   	cld    
 3f4:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 3f6:	89 d0                	mov    %edx,%eax
 3f8:	5f                   	pop    %edi
 3f9:	5d                   	pop    %ebp
 3fa:	c3                   	ret    
 3fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3ff:	90                   	nop

00000400 <strchr>:

char*
strchr(const char *s, char c)
{
 400:	f3 0f 1e fb          	endbr32 
 404:	55                   	push   %ebp
 405:	89 e5                	mov    %esp,%ebp
 407:	8b 45 08             	mov    0x8(%ebp),%eax
 40a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 40e:	0f b6 10             	movzbl (%eax),%edx
 411:	84 d2                	test   %dl,%dl
 413:	75 16                	jne    42b <strchr+0x2b>
 415:	eb 21                	jmp    438 <strchr+0x38>
 417:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 41e:	66 90                	xchg   %ax,%ax
 420:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 424:	83 c0 01             	add    $0x1,%eax
 427:	84 d2                	test   %dl,%dl
 429:	74 0d                	je     438 <strchr+0x38>
    if(*s == c)
 42b:	38 d1                	cmp    %dl,%cl
 42d:	75 f1                	jne    420 <strchr+0x20>
      return (char*)s;
  return 0;
}
 42f:	5d                   	pop    %ebp
 430:	c3                   	ret    
 431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 438:	31 c0                	xor    %eax,%eax
}
 43a:	5d                   	pop    %ebp
 43b:	c3                   	ret    
 43c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000440 <gets>:

char*
gets(char *buf, int max)
{
 440:	f3 0f 1e fb          	endbr32 
 444:	55                   	push   %ebp
 445:	89 e5                	mov    %esp,%ebp
 447:	57                   	push   %edi
 448:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 449:	31 f6                	xor    %esi,%esi
{
 44b:	53                   	push   %ebx
 44c:	89 f3                	mov    %esi,%ebx
 44e:	83 ec 1c             	sub    $0x1c,%esp
 451:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 454:	eb 33                	jmp    489 <gets+0x49>
 456:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 45d:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 460:	83 ec 04             	sub    $0x4,%esp
 463:	8d 45 e7             	lea    -0x19(%ebp),%eax
 466:	6a 01                	push   $0x1
 468:	50                   	push   %eax
 469:	6a 00                	push   $0x0
 46b:	e8 2b 01 00 00       	call   59b <read>
    if(cc < 1)
 470:	83 c4 10             	add    $0x10,%esp
 473:	85 c0                	test   %eax,%eax
 475:	7e 1c                	jle    493 <gets+0x53>
      break;
    buf[i++] = c;
 477:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 47b:	83 c7 01             	add    $0x1,%edi
 47e:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 481:	3c 0a                	cmp    $0xa,%al
 483:	74 23                	je     4a8 <gets+0x68>
 485:	3c 0d                	cmp    $0xd,%al
 487:	74 1f                	je     4a8 <gets+0x68>
  for(i=0; i+1 < max; ){
 489:	83 c3 01             	add    $0x1,%ebx
 48c:	89 fe                	mov    %edi,%esi
 48e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 491:	7c cd                	jl     460 <gets+0x20>
 493:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 495:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 498:	c6 03 00             	movb   $0x0,(%ebx)
}
 49b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 49e:	5b                   	pop    %ebx
 49f:	5e                   	pop    %esi
 4a0:	5f                   	pop    %edi
 4a1:	5d                   	pop    %ebp
 4a2:	c3                   	ret    
 4a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4a7:	90                   	nop
 4a8:	8b 75 08             	mov    0x8(%ebp),%esi
 4ab:	8b 45 08             	mov    0x8(%ebp),%eax
 4ae:	01 de                	add    %ebx,%esi
 4b0:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 4b2:	c6 03 00             	movb   $0x0,(%ebx)
}
 4b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4b8:	5b                   	pop    %ebx
 4b9:	5e                   	pop    %esi
 4ba:	5f                   	pop    %edi
 4bb:	5d                   	pop    %ebp
 4bc:	c3                   	ret    
 4bd:	8d 76 00             	lea    0x0(%esi),%esi

000004c0 <stat>:

int
stat(const char *n, struct stat *st)
{
 4c0:	f3 0f 1e fb          	endbr32 
 4c4:	55                   	push   %ebp
 4c5:	89 e5                	mov    %esp,%ebp
 4c7:	56                   	push   %esi
 4c8:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4c9:	83 ec 08             	sub    $0x8,%esp
 4cc:	6a 00                	push   $0x0
 4ce:	ff 75 08             	pushl  0x8(%ebp)
 4d1:	e8 ed 00 00 00       	call   5c3 <open>
  if(fd < 0)
 4d6:	83 c4 10             	add    $0x10,%esp
 4d9:	85 c0                	test   %eax,%eax
 4db:	78 2b                	js     508 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 4dd:	83 ec 08             	sub    $0x8,%esp
 4e0:	ff 75 0c             	pushl  0xc(%ebp)
 4e3:	89 c3                	mov    %eax,%ebx
 4e5:	50                   	push   %eax
 4e6:	e8 f0 00 00 00       	call   5db <fstat>
  close(fd);
 4eb:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 4ee:	89 c6                	mov    %eax,%esi
  close(fd);
 4f0:	e8 b6 00 00 00       	call   5ab <close>
  return r;
 4f5:	83 c4 10             	add    $0x10,%esp
}
 4f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
 4fb:	89 f0                	mov    %esi,%eax
 4fd:	5b                   	pop    %ebx
 4fe:	5e                   	pop    %esi
 4ff:	5d                   	pop    %ebp
 500:	c3                   	ret    
 501:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 508:	be ff ff ff ff       	mov    $0xffffffff,%esi
 50d:	eb e9                	jmp    4f8 <stat+0x38>
 50f:	90                   	nop

00000510 <atoi>:

int
atoi(const char *s)
{
 510:	f3 0f 1e fb          	endbr32 
 514:	55                   	push   %ebp
 515:	89 e5                	mov    %esp,%ebp
 517:	53                   	push   %ebx
 518:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 51b:	0f be 02             	movsbl (%edx),%eax
 51e:	8d 48 d0             	lea    -0x30(%eax),%ecx
 521:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 524:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 529:	77 1a                	ja     545 <atoi+0x35>
 52b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 52f:	90                   	nop
    n = n*10 + *s++ - '0';
 530:	83 c2 01             	add    $0x1,%edx
 533:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 536:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 53a:	0f be 02             	movsbl (%edx),%eax
 53d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 540:	80 fb 09             	cmp    $0x9,%bl
 543:	76 eb                	jbe    530 <atoi+0x20>
  return n;
}
 545:	89 c8                	mov    %ecx,%eax
 547:	5b                   	pop    %ebx
 548:	5d                   	pop    %ebp
 549:	c3                   	ret    
 54a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000550 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 550:	f3 0f 1e fb          	endbr32 
 554:	55                   	push   %ebp
 555:	89 e5                	mov    %esp,%ebp
 557:	57                   	push   %edi
 558:	8b 45 10             	mov    0x10(%ebp),%eax
 55b:	8b 55 08             	mov    0x8(%ebp),%edx
 55e:	56                   	push   %esi
 55f:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 562:	85 c0                	test   %eax,%eax
 564:	7e 0f                	jle    575 <memmove+0x25>
 566:	01 d0                	add    %edx,%eax
  dst = vdst;
 568:	89 d7                	mov    %edx,%edi
 56a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
 570:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 571:	39 f8                	cmp    %edi,%eax
 573:	75 fb                	jne    570 <memmove+0x20>
  return vdst;
}
 575:	5e                   	pop    %esi
 576:	89 d0                	mov    %edx,%eax
 578:	5f                   	pop    %edi
 579:	5d                   	pop    %ebp
 57a:	c3                   	ret    

0000057b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 57b:	b8 01 00 00 00       	mov    $0x1,%eax
 580:	cd 40                	int    $0x40
 582:	c3                   	ret    

00000583 <exit>:
SYSCALL(exit)
 583:	b8 02 00 00 00       	mov    $0x2,%eax
 588:	cd 40                	int    $0x40
 58a:	c3                   	ret    

0000058b <wait>:
SYSCALL(wait)
 58b:	b8 03 00 00 00       	mov    $0x3,%eax
 590:	cd 40                	int    $0x40
 592:	c3                   	ret    

00000593 <pipe>:
SYSCALL(pipe)
 593:	b8 04 00 00 00       	mov    $0x4,%eax
 598:	cd 40                	int    $0x40
 59a:	c3                   	ret    

0000059b <read>:
SYSCALL(read)
 59b:	b8 05 00 00 00       	mov    $0x5,%eax
 5a0:	cd 40                	int    $0x40
 5a2:	c3                   	ret    

000005a3 <write>:
SYSCALL(write)
 5a3:	b8 10 00 00 00       	mov    $0x10,%eax
 5a8:	cd 40                	int    $0x40
 5aa:	c3                   	ret    

000005ab <close>:
SYSCALL(close)
 5ab:	b8 15 00 00 00       	mov    $0x15,%eax
 5b0:	cd 40                	int    $0x40
 5b2:	c3                   	ret    

000005b3 <kill>:
SYSCALL(kill)
 5b3:	b8 06 00 00 00       	mov    $0x6,%eax
 5b8:	cd 40                	int    $0x40
 5ba:	c3                   	ret    

000005bb <exec>:
SYSCALL(exec)
 5bb:	b8 07 00 00 00       	mov    $0x7,%eax
 5c0:	cd 40                	int    $0x40
 5c2:	c3                   	ret    

000005c3 <open>:
SYSCALL(open)
 5c3:	b8 0f 00 00 00       	mov    $0xf,%eax
 5c8:	cd 40                	int    $0x40
 5ca:	c3                   	ret    

000005cb <mknod>:
SYSCALL(mknod)
 5cb:	b8 11 00 00 00       	mov    $0x11,%eax
 5d0:	cd 40                	int    $0x40
 5d2:	c3                   	ret    

000005d3 <unlink>:
SYSCALL(unlink)
 5d3:	b8 12 00 00 00       	mov    $0x12,%eax
 5d8:	cd 40                	int    $0x40
 5da:	c3                   	ret    

000005db <fstat>:
SYSCALL(fstat)
 5db:	b8 08 00 00 00       	mov    $0x8,%eax
 5e0:	cd 40                	int    $0x40
 5e2:	c3                   	ret    

000005e3 <link>:
SYSCALL(link)
 5e3:	b8 13 00 00 00       	mov    $0x13,%eax
 5e8:	cd 40                	int    $0x40
 5ea:	c3                   	ret    

000005eb <mkdir>:
SYSCALL(mkdir)
 5eb:	b8 14 00 00 00       	mov    $0x14,%eax
 5f0:	cd 40                	int    $0x40
 5f2:	c3                   	ret    

000005f3 <chdir>:
SYSCALL(chdir)
 5f3:	b8 09 00 00 00       	mov    $0x9,%eax
 5f8:	cd 40                	int    $0x40
 5fa:	c3                   	ret    

000005fb <dup>:
SYSCALL(dup)
 5fb:	b8 0a 00 00 00       	mov    $0xa,%eax
 600:	cd 40                	int    $0x40
 602:	c3                   	ret    

00000603 <getpid>:
SYSCALL(getpid)
 603:	b8 0b 00 00 00       	mov    $0xb,%eax
 608:	cd 40                	int    $0x40
 60a:	c3                   	ret    

0000060b <sbrk>:
SYSCALL(sbrk)
 60b:	b8 0c 00 00 00       	mov    $0xc,%eax
 610:	cd 40                	int    $0x40
 612:	c3                   	ret    

00000613 <sleep>:
SYSCALL(sleep)
 613:	b8 0d 00 00 00       	mov    $0xd,%eax
 618:	cd 40                	int    $0x40
 61a:	c3                   	ret    

0000061b <uptime>:
SYSCALL(uptime)
 61b:	b8 0e 00 00 00       	mov    $0xe,%eax
 620:	cd 40                	int    $0x40
 622:	c3                   	ret    

00000623 <get_number_of_free_pages>:
 623:	b8 16 00 00 00       	mov    $0x16,%eax
 628:	cd 40                	int    $0x40
 62a:	c3                   	ret    
 62b:	66 90                	xchg   %ax,%ax
 62d:	66 90                	xchg   %ax,%ax
 62f:	90                   	nop

00000630 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 630:	55                   	push   %ebp
 631:	89 e5                	mov    %esp,%ebp
 633:	57                   	push   %edi
 634:	56                   	push   %esi
 635:	53                   	push   %ebx
 636:	83 ec 3c             	sub    $0x3c,%esp
 639:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 63c:	89 d1                	mov    %edx,%ecx
{
 63e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 641:	85 d2                	test   %edx,%edx
 643:	0f 89 7f 00 00 00    	jns    6c8 <printint+0x98>
 649:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 64d:	74 79                	je     6c8 <printint+0x98>
    neg = 1;
 64f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 656:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 658:	31 db                	xor    %ebx,%ebx
 65a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 65d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 660:	89 c8                	mov    %ecx,%eax
 662:	31 d2                	xor    %edx,%edx
 664:	89 cf                	mov    %ecx,%edi
 666:	f7 75 c4             	divl   -0x3c(%ebp)
 669:	0f b6 92 a8 0b 00 00 	movzbl 0xba8(%edx),%edx
 670:	89 45 c0             	mov    %eax,-0x40(%ebp)
 673:	89 d8                	mov    %ebx,%eax
 675:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 678:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 67b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 67e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 681:	76 dd                	jbe    660 <printint+0x30>
  if(neg)
 683:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 686:	85 c9                	test   %ecx,%ecx
 688:	74 0c                	je     696 <printint+0x66>
    buf[i++] = '-';
 68a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 68f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 691:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 696:	8b 7d b8             	mov    -0x48(%ebp),%edi
 699:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 69d:	eb 07                	jmp    6a6 <printint+0x76>
 69f:	90                   	nop
 6a0:	0f b6 13             	movzbl (%ebx),%edx
 6a3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 6a6:	83 ec 04             	sub    $0x4,%esp
 6a9:	88 55 d7             	mov    %dl,-0x29(%ebp)
 6ac:	6a 01                	push   $0x1
 6ae:	56                   	push   %esi
 6af:	57                   	push   %edi
 6b0:	e8 ee fe ff ff       	call   5a3 <write>
  while(--i >= 0)
 6b5:	83 c4 10             	add    $0x10,%esp
 6b8:	39 de                	cmp    %ebx,%esi
 6ba:	75 e4                	jne    6a0 <printint+0x70>
    putc(fd, buf[i]);
}
 6bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6bf:	5b                   	pop    %ebx
 6c0:	5e                   	pop    %esi
 6c1:	5f                   	pop    %edi
 6c2:	5d                   	pop    %ebp
 6c3:	c3                   	ret    
 6c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 6c8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 6cf:	eb 87                	jmp    658 <printint+0x28>
 6d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6df:	90                   	nop

000006e0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 6e0:	f3 0f 1e fb          	endbr32 
 6e4:	55                   	push   %ebp
 6e5:	89 e5                	mov    %esp,%ebp
 6e7:	57                   	push   %edi
 6e8:	56                   	push   %esi
 6e9:	53                   	push   %ebx
 6ea:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6ed:	8b 75 0c             	mov    0xc(%ebp),%esi
 6f0:	0f b6 1e             	movzbl (%esi),%ebx
 6f3:	84 db                	test   %bl,%bl
 6f5:	0f 84 b4 00 00 00    	je     7af <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
 6fb:	8d 45 10             	lea    0x10(%ebp),%eax
 6fe:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 701:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 704:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 706:	89 45 d0             	mov    %eax,-0x30(%ebp)
 709:	eb 33                	jmp    73e <printf+0x5e>
 70b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 70f:	90                   	nop
 710:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 713:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 718:	83 f8 25             	cmp    $0x25,%eax
 71b:	74 17                	je     734 <printf+0x54>
  write(fd, &c, 1);
 71d:	83 ec 04             	sub    $0x4,%esp
 720:	88 5d e7             	mov    %bl,-0x19(%ebp)
 723:	6a 01                	push   $0x1
 725:	57                   	push   %edi
 726:	ff 75 08             	pushl  0x8(%ebp)
 729:	e8 75 fe ff ff       	call   5a3 <write>
 72e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 731:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 734:	0f b6 1e             	movzbl (%esi),%ebx
 737:	83 c6 01             	add    $0x1,%esi
 73a:	84 db                	test   %bl,%bl
 73c:	74 71                	je     7af <printf+0xcf>
    c = fmt[i] & 0xff;
 73e:	0f be cb             	movsbl %bl,%ecx
 741:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 744:	85 d2                	test   %edx,%edx
 746:	74 c8                	je     710 <printf+0x30>
      }
    } else if(state == '%'){
 748:	83 fa 25             	cmp    $0x25,%edx
 74b:	75 e7                	jne    734 <printf+0x54>
      if(c == 'd'){
 74d:	83 f8 64             	cmp    $0x64,%eax
 750:	0f 84 9a 00 00 00    	je     7f0 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 756:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 75c:	83 f9 70             	cmp    $0x70,%ecx
 75f:	74 5f                	je     7c0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 761:	83 f8 73             	cmp    $0x73,%eax
 764:	0f 84 d6 00 00 00    	je     840 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 76a:	83 f8 63             	cmp    $0x63,%eax
 76d:	0f 84 8d 00 00 00    	je     800 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 773:	83 f8 25             	cmp    $0x25,%eax
 776:	0f 84 b4 00 00 00    	je     830 <printf+0x150>
  write(fd, &c, 1);
 77c:	83 ec 04             	sub    $0x4,%esp
 77f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 783:	6a 01                	push   $0x1
 785:	57                   	push   %edi
 786:	ff 75 08             	pushl  0x8(%ebp)
 789:	e8 15 fe ff ff       	call   5a3 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 78e:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 791:	83 c4 0c             	add    $0xc,%esp
 794:	6a 01                	push   $0x1
 796:	83 c6 01             	add    $0x1,%esi
 799:	57                   	push   %edi
 79a:	ff 75 08             	pushl  0x8(%ebp)
 79d:	e8 01 fe ff ff       	call   5a3 <write>
  for(i = 0; fmt[i]; i++){
 7a2:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 7a6:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 7a9:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 7ab:	84 db                	test   %bl,%bl
 7ad:	75 8f                	jne    73e <printf+0x5e>
    }
  }
}
 7af:	8d 65 f4             	lea    -0xc(%ebp),%esp
 7b2:	5b                   	pop    %ebx
 7b3:	5e                   	pop    %esi
 7b4:	5f                   	pop    %edi
 7b5:	5d                   	pop    %ebp
 7b6:	c3                   	ret    
 7b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7be:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 7c0:	83 ec 0c             	sub    $0xc,%esp
 7c3:	b9 10 00 00 00       	mov    $0x10,%ecx
 7c8:	6a 00                	push   $0x0
 7ca:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 7cd:	8b 45 08             	mov    0x8(%ebp),%eax
 7d0:	8b 13                	mov    (%ebx),%edx
 7d2:	e8 59 fe ff ff       	call   630 <printint>
        ap++;
 7d7:	89 d8                	mov    %ebx,%eax
 7d9:	83 c4 10             	add    $0x10,%esp
      state = 0;
 7dc:	31 d2                	xor    %edx,%edx
        ap++;
 7de:	83 c0 04             	add    $0x4,%eax
 7e1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 7e4:	e9 4b ff ff ff       	jmp    734 <printf+0x54>
 7e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 7f0:	83 ec 0c             	sub    $0xc,%esp
 7f3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 7f8:	6a 01                	push   $0x1
 7fa:	eb ce                	jmp    7ca <printf+0xea>
 7fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 800:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 803:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 806:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 808:	6a 01                	push   $0x1
        ap++;
 80a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 80d:	57                   	push   %edi
 80e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 811:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 814:	e8 8a fd ff ff       	call   5a3 <write>
        ap++;
 819:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 81c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 81f:	31 d2                	xor    %edx,%edx
 821:	e9 0e ff ff ff       	jmp    734 <printf+0x54>
 826:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 82d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 830:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 833:	83 ec 04             	sub    $0x4,%esp
 836:	e9 59 ff ff ff       	jmp    794 <printf+0xb4>
 83b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 83f:	90                   	nop
        s = (char*)*ap;
 840:	8b 45 d0             	mov    -0x30(%ebp),%eax
 843:	8b 18                	mov    (%eax),%ebx
        ap++;
 845:	83 c0 04             	add    $0x4,%eax
 848:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 84b:	85 db                	test   %ebx,%ebx
 84d:	74 17                	je     866 <printf+0x186>
        while(*s != 0){
 84f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 852:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 854:	84 c0                	test   %al,%al
 856:	0f 84 d8 fe ff ff    	je     734 <printf+0x54>
 85c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 85f:	89 de                	mov    %ebx,%esi
 861:	8b 5d 08             	mov    0x8(%ebp),%ebx
 864:	eb 1a                	jmp    880 <printf+0x1a0>
          s = "(null)";
 866:	bb 9f 0b 00 00       	mov    $0xb9f,%ebx
        while(*s != 0){
 86b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 86e:	b8 28 00 00 00       	mov    $0x28,%eax
 873:	89 de                	mov    %ebx,%esi
 875:	8b 5d 08             	mov    0x8(%ebp),%ebx
 878:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 87f:	90                   	nop
  write(fd, &c, 1);
 880:	83 ec 04             	sub    $0x4,%esp
          s++;
 883:	83 c6 01             	add    $0x1,%esi
 886:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 889:	6a 01                	push   $0x1
 88b:	57                   	push   %edi
 88c:	53                   	push   %ebx
 88d:	e8 11 fd ff ff       	call   5a3 <write>
        while(*s != 0){
 892:	0f b6 06             	movzbl (%esi),%eax
 895:	83 c4 10             	add    $0x10,%esp
 898:	84 c0                	test   %al,%al
 89a:	75 e4                	jne    880 <printf+0x1a0>
 89c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 89f:	31 d2                	xor    %edx,%edx
 8a1:	e9 8e fe ff ff       	jmp    734 <printf+0x54>
 8a6:	66 90                	xchg   %ax,%ax
 8a8:	66 90                	xchg   %ax,%ax
 8aa:	66 90                	xchg   %ax,%ax
 8ac:	66 90                	xchg   %ax,%ax
 8ae:	66 90                	xchg   %ax,%ax

000008b0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8b0:	f3 0f 1e fb          	endbr32 
 8b4:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8b5:	a1 c8 0e 00 00       	mov    0xec8,%eax
{
 8ba:	89 e5                	mov    %esp,%ebp
 8bc:	57                   	push   %edi
 8bd:	56                   	push   %esi
 8be:	53                   	push   %ebx
 8bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
 8c2:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 8c4:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8c7:	39 c8                	cmp    %ecx,%eax
 8c9:	73 15                	jae    8e0 <free+0x30>
 8cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 8cf:	90                   	nop
 8d0:	39 d1                	cmp    %edx,%ecx
 8d2:	72 14                	jb     8e8 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8d4:	39 d0                	cmp    %edx,%eax
 8d6:	73 10                	jae    8e8 <free+0x38>
{
 8d8:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8da:	8b 10                	mov    (%eax),%edx
 8dc:	39 c8                	cmp    %ecx,%eax
 8de:	72 f0                	jb     8d0 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8e0:	39 d0                	cmp    %edx,%eax
 8e2:	72 f4                	jb     8d8 <free+0x28>
 8e4:	39 d1                	cmp    %edx,%ecx
 8e6:	73 f0                	jae    8d8 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 8e8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 8eb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 8ee:	39 fa                	cmp    %edi,%edx
 8f0:	74 1e                	je     910 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 8f2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 8f5:	8b 50 04             	mov    0x4(%eax),%edx
 8f8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 8fb:	39 f1                	cmp    %esi,%ecx
 8fd:	74 28                	je     927 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 8ff:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 901:	5b                   	pop    %ebx
  freep = p;
 902:	a3 c8 0e 00 00       	mov    %eax,0xec8
}
 907:	5e                   	pop    %esi
 908:	5f                   	pop    %edi
 909:	5d                   	pop    %ebp
 90a:	c3                   	ret    
 90b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 90f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 910:	03 72 04             	add    0x4(%edx),%esi
 913:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 916:	8b 10                	mov    (%eax),%edx
 918:	8b 12                	mov    (%edx),%edx
 91a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 91d:	8b 50 04             	mov    0x4(%eax),%edx
 920:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 923:	39 f1                	cmp    %esi,%ecx
 925:	75 d8                	jne    8ff <free+0x4f>
    p->s.size += bp->s.size;
 927:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 92a:	a3 c8 0e 00 00       	mov    %eax,0xec8
    p->s.size += bp->s.size;
 92f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 932:	8b 53 f8             	mov    -0x8(%ebx),%edx
 935:	89 10                	mov    %edx,(%eax)
}
 937:	5b                   	pop    %ebx
 938:	5e                   	pop    %esi
 939:	5f                   	pop    %edi
 93a:	5d                   	pop    %ebp
 93b:	c3                   	ret    
 93c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000940 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 940:	f3 0f 1e fb          	endbr32 
 944:	55                   	push   %ebp
 945:	89 e5                	mov    %esp,%ebp
 947:	57                   	push   %edi
 948:	56                   	push   %esi
 949:	53                   	push   %ebx
 94a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 94d:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 950:	8b 3d c8 0e 00 00    	mov    0xec8,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 956:	8d 70 07             	lea    0x7(%eax),%esi
 959:	c1 ee 03             	shr    $0x3,%esi
 95c:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 95f:	85 ff                	test   %edi,%edi
 961:	0f 84 a9 00 00 00    	je     a10 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 967:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 969:	8b 48 04             	mov    0x4(%eax),%ecx
 96c:	39 f1                	cmp    %esi,%ecx
 96e:	73 6d                	jae    9dd <malloc+0x9d>
 970:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 976:	bb 00 10 00 00       	mov    $0x1000,%ebx
 97b:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 97e:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 985:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 988:	eb 17                	jmp    9a1 <malloc+0x61>
 98a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 990:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 992:	8b 4a 04             	mov    0x4(%edx),%ecx
 995:	39 f1                	cmp    %esi,%ecx
 997:	73 4f                	jae    9e8 <malloc+0xa8>
 999:	8b 3d c8 0e 00 00    	mov    0xec8,%edi
 99f:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9a1:	39 c7                	cmp    %eax,%edi
 9a3:	75 eb                	jne    990 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 9a5:	83 ec 0c             	sub    $0xc,%esp
 9a8:	ff 75 e4             	pushl  -0x1c(%ebp)
 9ab:	e8 5b fc ff ff       	call   60b <sbrk>
  if(p == (char*)-1)
 9b0:	83 c4 10             	add    $0x10,%esp
 9b3:	83 f8 ff             	cmp    $0xffffffff,%eax
 9b6:	74 1b                	je     9d3 <malloc+0x93>
  hp->s.size = nu;
 9b8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 9bb:	83 ec 0c             	sub    $0xc,%esp
 9be:	83 c0 08             	add    $0x8,%eax
 9c1:	50                   	push   %eax
 9c2:	e8 e9 fe ff ff       	call   8b0 <free>
  return freep;
 9c7:	a1 c8 0e 00 00       	mov    0xec8,%eax
      if((p = morecore(nunits)) == 0)
 9cc:	83 c4 10             	add    $0x10,%esp
 9cf:	85 c0                	test   %eax,%eax
 9d1:	75 bd                	jne    990 <malloc+0x50>
        return 0;
  }
}
 9d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 9d6:	31 c0                	xor    %eax,%eax
}
 9d8:	5b                   	pop    %ebx
 9d9:	5e                   	pop    %esi
 9da:	5f                   	pop    %edi
 9db:	5d                   	pop    %ebp
 9dc:	c3                   	ret    
    if(p->s.size >= nunits){
 9dd:	89 c2                	mov    %eax,%edx
 9df:	89 f8                	mov    %edi,%eax
 9e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 9e8:	39 ce                	cmp    %ecx,%esi
 9ea:	74 54                	je     a40 <malloc+0x100>
        p->s.size -= nunits;
 9ec:	29 f1                	sub    %esi,%ecx
 9ee:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 9f1:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 9f4:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 9f7:	a3 c8 0e 00 00       	mov    %eax,0xec8
}
 9fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 9ff:	8d 42 08             	lea    0x8(%edx),%eax
}
 a02:	5b                   	pop    %ebx
 a03:	5e                   	pop    %esi
 a04:	5f                   	pop    %edi
 a05:	5d                   	pop    %ebp
 a06:	c3                   	ret    
 a07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a0e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 a10:	c7 05 c8 0e 00 00 cc 	movl   $0xecc,0xec8
 a17:	0e 00 00 
    base.s.size = 0;
 a1a:	bf cc 0e 00 00       	mov    $0xecc,%edi
    base.s.ptr = freep = prevp = &base;
 a1f:	c7 05 cc 0e 00 00 cc 	movl   $0xecc,0xecc
 a26:	0e 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a29:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 a2b:	c7 05 d0 0e 00 00 00 	movl   $0x0,0xed0
 a32:	00 00 00 
    if(p->s.size >= nunits){
 a35:	e9 36 ff ff ff       	jmp    970 <malloc+0x30>
 a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 a40:	8b 0a                	mov    (%edx),%ecx
 a42:	89 08                	mov    %ecx,(%eax)
 a44:	eb b1                	jmp    9f7 <malloc+0xb7>
