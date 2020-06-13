
_ass3Tests:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
}


int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  test();
  11:	e8 0a 00 00 00       	call   20 <test>
  //   for (i = 0 ; i < size ; i++){
  //     printf(1,"%c", *(char * )pointers[i]);
  //   }
  //   printf(1, "\nfather is done\n");
  // }
   exit();
  16:	e8 a7 05 00 00       	call   5c2 <exit>
  1b:	66 90                	xchg   %ax,%ax
  1d:	66 90                	xchg   %ax,%ax
  1f:	90                   	nop

00000020 <test>:
test() {
  20:	55                   	push   %ebp
  21:	89 e5                	mov    %esp,%ebp
  23:	57                   	push   %edi
  24:	56                   	push   %esi
  25:	53                   	push   %ebx
  printf(1, "before fork1 - number of free pages before allocation: %d, number of allocated pages: %d\n", fp, MAXPAGES - fp);
  26:	bb 41 00 00 00       	mov    $0x41,%ebx
test() {
  2b:	83 ec 6c             	sub    $0x6c,%esp
  int fp = get_number_of_free_pages();
  2e:	e8 2f 06 00 00       	call   662 <get_number_of_free_pages>
  printf(1, "before fork1 - number of free pages before allocation: %d, number of allocated pages: %d\n", fp, MAXPAGES - fp);
  33:	ba f6 df 00 00       	mov    $0xdff6,%edx
  38:	29 c2                	sub    %eax,%edx
  3a:	52                   	push   %edx
  3b:	50                   	push   %eax
  3c:	68 68 0a 00 00       	push   $0xa68
  41:	6a 01                	push   $0x1
  43:	e8 c8 06 00 00       	call   710 <printf>
  48:	83 c4 10             	add    $0x10,%esp
  4b:	90                   	nop
  4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pointers[i] = (uint)sbrk(PGSIZE);
  50:	83 ec 0c             	sub    $0xc,%esp
  53:	68 00 10 00 00       	push   $0x1000
  58:	e8 ed 05 00 00       	call   64a <sbrk>
    * (char *) pointers[i] = (char) ('A' + i);
  5d:	88 18                	mov    %bl,(%eax)
    pointers[i] = (uint)sbrk(PGSIZE);
  5f:	89 84 9d 98 fe ff ff 	mov    %eax,-0x168(%ebp,%ebx,4)
    printf(1,"added %c at index %d\n", *(char * )pointers[i], i);
  66:	8d 43 bf             	lea    -0x41(%ebx),%eax
  69:	50                   	push   %eax
  6a:	53                   	push   %ebx
  6b:	83 c3 01             	add    $0x1,%ebx
  6e:	68 00 0d 00 00       	push   $0xd00
  73:	6a 01                	push   $0x1
  75:	e8 96 06 00 00       	call   710 <printf>
  for (i = 0; i < midway; i++){
  7a:	83 c4 20             	add    $0x20,%esp
  7d:	83 fb 4a             	cmp    $0x4a,%ebx
  80:	75 ce                	jne    50 <test+0x30>
  printf(1, "before fork1 - number of free pages after allocation: %d, number of allocated pages: %d\n", fp, MAXPAGES - fp);
  82:	be f6 df 00 00       	mov    $0xdff6,%esi
  fp = get_number_of_free_pages();
  87:	e8 d6 05 00 00       	call   662 <get_number_of_free_pages>
  printf(1, "before fork1 - number of free pages after allocation: %d, number of allocated pages: %d\n", fp, MAXPAGES - fp);
  8c:	89 f2                	mov    %esi,%edx
  8e:	29 c2                	sub    %eax,%edx
  90:	52                   	push   %edx
  91:	50                   	push   %eax
  92:	68 c4 0a 00 00       	push   $0xac4
  97:	6a 01                	push   $0x1
  99:	e8 72 06 00 00       	call   710 <printf>
  pid = fork();
  9e:	e8 17 05 00 00       	call   5ba <fork>
  if(pid == 0){
  a3:	83 c4 10             	add    $0x10,%esp
  a6:	85 c0                	test   %eax,%eax
  a8:	0f 84 6b 01 00 00    	je     219 <test+0x1f9>
  wait();
  ae:	e8 17 05 00 00       	call   5ca <wait>
  fp = get_number_of_free_pages();
  b3:	e8 aa 05 00 00       	call   662 <get_number_of_free_pages>
  printf(1, "after fork1, father - number of free pages: %d, number of allocated pages: %d\n", fp, MAXPAGES - fp);
  b8:	29 c6                	sub    %eax,%esi
  ba:	8d 7d c0             	lea    -0x40(%ebp),%edi
  bd:	56                   	push   %esi
  be:	50                   	push   %eax
  bf:	68 30 0c 00 00       	push   $0xc30
  c4:	6a 01                	push   $0x1
  c6:	e8 45 06 00 00       	call   710 <printf>
  cb:	8d 45 9c             	lea    -0x64(%ebp),%eax
  ce:	83 c4 10             	add    $0x10,%esp
  d1:	89 45 94             	mov    %eax,-0x6c(%ebp)
  d4:	89 c6                	mov    %eax,%esi
  d6:	8d 76 00             	lea    0x0(%esi),%esi
  d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    printf(1,"%c", *(char * )pointers[i]);
  e0:	8b 16                	mov    (%esi),%edx
  e2:	83 ec 04             	sub    $0x4,%esp
  e5:	83 c6 04             	add    $0x4,%esi
  e8:	0f be 12             	movsbl (%edx),%edx
  eb:	52                   	push   %edx
  ec:	68 16 0d 00 00       	push   $0xd16
  f1:	6a 01                	push   $0x1
  f3:	e8 18 06 00 00       	call   710 <printf>
  for (i = 0 ; i < midway ; i++){
  f8:	83 c4 10             	add    $0x10,%esp
  fb:	39 fe                	cmp    %edi,%esi
  fd:	75 e1                	jne    e0 <test+0xc0>
  printf(1, "\nfather is done\n");
  ff:	83 ec 08             	sub    $0x8,%esp
 102:	68 27 0d 00 00       	push   $0xd27
 107:	6a 01                	push   $0x1
 109:	e8 02 06 00 00       	call   710 <printf>
 10e:	83 c4 10             	add    $0x10,%esp
 111:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pointers[i] = (uint)sbrk(PGSIZE);
 118:	83 ec 0c             	sub    $0xc,%esp
 11b:	68 00 10 00 00       	push   $0x1000
 120:	e8 25 05 00 00       	call   64a <sbrk>
    * (char *) pointers[i] = (char) ('A' + i);
 125:	88 18                	mov    %bl,(%eax)
    pointers[i] = (uint)sbrk(PGSIZE);
 127:	89 84 9d 98 fe ff ff 	mov    %eax,-0x168(%ebp,%ebx,4)
    printf(1,"added %c at index %d\n", *(char * )pointers[i], i);
 12e:	8d 43 bf             	lea    -0x41(%ebx),%eax
 131:	50                   	push   %eax
 132:	53                   	push   %ebx
 133:	83 c3 01             	add    $0x1,%ebx
 136:	68 00 0d 00 00       	push   $0xd00
 13b:	6a 01                	push   $0x1
 13d:	e8 ce 05 00 00       	call   710 <printf>
  for (i = midway; i < size; i++){
 142:	83 c4 20             	add    $0x20,%esp
 145:	83 fb 54             	cmp    $0x54,%ebx
 148:	75 ce                	jne    118 <test+0xf8>
  fp = get_number_of_free_pages();
 14a:	e8 13 05 00 00       	call   662 <get_number_of_free_pages>
  printf(1, "before fork2 - number of free pages after allocation: %d, number of allocated pages: %d\n", fp, MAXPAGES - fp);
 14f:	ba f6 df 00 00       	mov    $0xdff6,%edx
 154:	8d 7d e8             	lea    -0x18(%ebp),%edi
 157:	29 c2                	sub    %eax,%edx
 159:	52                   	push   %edx
 15a:	50                   	push   %eax
 15b:	68 80 0c 00 00       	push   $0xc80
 160:	6a 01                	push   $0x1
 162:	e8 a9 05 00 00       	call   710 <printf>
 167:	8d 45 9c             	lea    -0x64(%ebp),%eax
 16a:	83 c4 10             	add    $0x10,%esp
 16d:	89 c3                	mov    %eax,%ebx
 16f:	90                   	nop
    printf(1,"%c", *(char * )pointers[i]);
 170:	8b 03                	mov    (%ebx),%eax
 172:	83 ec 04             	sub    $0x4,%esp
 175:	83 c3 04             	add    $0x4,%ebx
 178:	0f be 00             	movsbl (%eax),%eax
 17b:	50                   	push   %eax
 17c:	68 16 0d 00 00       	push   $0xd16
 181:	6a 01                	push   $0x1
 183:	e8 88 05 00 00       	call   710 <printf>
  for (i = 0 ; i < size ; i++){
 188:	83 c4 10             	add    $0x10,%esp
 18b:	39 df                	cmp    %ebx,%edi
 18d:	75 e1                	jne    170 <test+0x150>
  a = (char * )pointers[0];
 18f:	8b 75 9c             	mov    -0x64(%ebp),%esi
  printf(1, "before fork2 - put char %c in ram\n", a);
 192:	83 ec 04             	sub    $0x4,%esp
 195:	56                   	push   %esi
 196:	68 dc 0c 00 00       	push   $0xcdc
  a = (char * )pointers[0];
 19b:	89 f7                	mov    %esi,%edi
  printf(1, "before fork2 - put char %c in ram\n", a);
 19d:	6a 01                	push   $0x1
 19f:	e8 6c 05 00 00       	call   710 <printf>
  pid = fork();
 1a4:	e8 11 04 00 00       	call   5ba <fork>
  if(pid == 0){
 1a9:	83 c4 10             	add    $0x10,%esp
 1ac:	85 c0                	test   %eax,%eax
 1ae:	0f 84 10 01 00 00    	je     2c4 <test+0x2a4>
  wait();
 1b4:	e8 11 04 00 00       	call   5ca <wait>
  fp = get_number_of_free_pages();
 1b9:	e8 a4 04 00 00       	call   662 <get_number_of_free_pages>
  printf(1, "after fork1, father - number of free pages: %d, number of allocated pages: %d\n", fp, MAXPAGES - fp);
 1be:	ba f6 df 00 00       	mov    $0xdff6,%edx
 1c3:	8d 75 a0             	lea    -0x60(%ebp),%esi
 1c6:	29 c2                	sub    %eax,%edx
 1c8:	52                   	push   %edx
 1c9:	50                   	push   %eax
 1ca:	68 30 0c 00 00       	push   $0xc30
 1cf:	6a 01                	push   $0x1
 1d1:	e8 3a 05 00 00       	call   710 <printf>
 1d6:	83 c4 10             	add    $0x10,%esp
 1d9:	eb 0a                	jmp    1e5 <test+0x1c5>
 1db:	90                   	nop
 1dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1e0:	8b 3e                	mov    (%esi),%edi
 1e2:	83 c6 04             	add    $0x4,%esi
    printf(1,"%c", *(char * )pointers[i]);
 1e5:	0f be 07             	movsbl (%edi),%eax
 1e8:	83 ec 04             	sub    $0x4,%esp
 1eb:	50                   	push   %eax
 1ec:	68 16 0d 00 00       	push   $0xd16
 1f1:	6a 01                	push   $0x1
 1f3:	e8 18 05 00 00       	call   710 <printf>
  for (i = 0 ; i < size ; i++){
 1f8:	83 c4 10             	add    $0x10,%esp
 1fb:	39 de                	cmp    %ebx,%esi
 1fd:	75 e1                	jne    1e0 <test+0x1c0>
  printf(1, "\nfather is done\n");
 1ff:	83 ec 08             	sub    $0x8,%esp
 202:	68 27 0d 00 00       	push   $0xd27
 207:	6a 01                	push   $0x1
 209:	e8 02 05 00 00       	call   710 <printf>
}
 20e:	83 c4 10             	add    $0x10,%esp
 211:	8d 65 f4             	lea    -0xc(%ebp),%esp
 214:	5b                   	pop    %ebx
 215:	5e                   	pop    %esi
 216:	5f                   	pop    %edi
 217:	5d                   	pop    %ebp
 218:	c3                   	ret    
    fp = get_number_of_free_pages();
 219:	e8 44 04 00 00       	call   662 <get_number_of_free_pages>
    printf(1, "after fork1, son - number of free pages: %d, number of allocated pages: %d\n", fp, MAXPAGES - fp);
 21e:	29 c6                	sub    %eax,%esi
 220:	8d 5d 9c             	lea    -0x64(%ebp),%ebx
 223:	8d 7d c0             	lea    -0x40(%ebp),%edi
 226:	56                   	push   %esi
 227:	50                   	push   %eax
 228:	68 20 0b 00 00       	push   $0xb20
 22d:	6a 01                	push   $0x1
 22f:	89 de                	mov    %ebx,%esi
 231:	e8 da 04 00 00       	call   710 <printf>
 236:	83 c4 10             	add    $0x10,%esp
      printf(1,"%c", *(char * )pointers[i]);
 239:	8b 06                	mov    (%esi),%eax
 23b:	83 ec 04             	sub    $0x4,%esp
 23e:	83 c6 04             	add    $0x4,%esi
 241:	0f be 00             	movsbl (%eax),%eax
 244:	50                   	push   %eax
 245:	68 16 0d 00 00       	push   $0xd16
 24a:	6a 01                	push   $0x1
 24c:	e8 bf 04 00 00       	call   710 <printf>
    for (i = 0 ; i < midway ; i++){
 251:	83 c4 10             	add    $0x10,%esp
 254:	39 f7                	cmp    %esi,%edi
 256:	75 e1                	jne    239 <test+0x219>
    printf(1, "\nson - done printing, changing array-number of free pages: %d, number of allocated pages: %d\n", fp, MAXPAGES - fp);
 258:	bf f6 df 00 00       	mov    $0xdff6,%edi
    fp = get_number_of_free_pages();
 25d:	e8 00 04 00 00       	call   662 <get_number_of_free_pages>
    printf(1, "\nson - done printing, changing array-number of free pages: %d, number of allocated pages: %d\n", fp, MAXPAGES - fp);
 262:	89 fa                	mov    %edi,%edx
 264:	29 c2                	sub    %eax,%edx
 266:	52                   	push   %edx
 267:	50                   	push   %eax
 268:	68 6c 0b 00 00       	push   $0xb6c
 26d:	6a 01                	push   $0x1
 26f:	e8 9c 04 00 00       	call   710 <printf>
      * (char *) pointers[i] = (char) ('a' + i);
 274:	8b 45 9c             	mov    -0x64(%ebp),%eax
 277:	c6 00 61             	movb   $0x61,(%eax)
    fp = get_number_of_free_pages();
 27a:	e8 e3 03 00 00       	call   662 <get_number_of_free_pages>
    printf(1, "son - number of free pages after change: %d, number of allocated pages: %d, printing new array:\n", fp, MAXPAGES - fp);
 27f:	29 c7                	sub    %eax,%edi
 281:	57                   	push   %edi
 282:	50                   	push   %eax
 283:	68 cc 0b 00 00       	push   $0xbcc
 288:	6a 01                	push   $0x1
 28a:	e8 81 04 00 00       	call   710 <printf>
 28f:	83 c4 20             	add    $0x20,%esp
      printf(1,"%c", *(char * )pointers[i]);
 292:	8b 03                	mov    (%ebx),%eax
 294:	83 ec 04             	sub    $0x4,%esp
 297:	83 c3 04             	add    $0x4,%ebx
 29a:	0f be 00             	movsbl (%eax),%eax
 29d:	50                   	push   %eax
 29e:	68 16 0d 00 00       	push   $0xd16
 2a3:	6a 01                	push   $0x1
 2a5:	e8 66 04 00 00       	call   710 <printf>
    for (i = 0 ; i < midway ; i++){
 2aa:	83 c4 10             	add    $0x10,%esp
 2ad:	39 de                	cmp    %ebx,%esi
 2af:	75 e1                	jne    292 <test+0x272>
    printf(1, "\nson is done\n");
 2b1:	50                   	push   %eax
 2b2:	50                   	push   %eax
 2b3:	68 19 0d 00 00       	push   $0xd19
 2b8:	6a 01                	push   $0x1
 2ba:	e8 51 04 00 00       	call   710 <printf>
    exit();
 2bf:	e8 fe 02 00 00       	call   5c2 <exit>
    fp = get_number_of_free_pages();
 2c4:	e8 99 03 00 00       	call   662 <get_number_of_free_pages>
    printf(1, "after fork1, son - number of free pages: %d, number of allocated pages: %d\n", fp, MAXPAGES - fp);
 2c9:	b9 f6 df 00 00       	mov    $0xdff6,%ecx
 2ce:	8d 7d 9c             	lea    -0x64(%ebp),%edi
 2d1:	29 c1                	sub    %eax,%ecx
 2d3:	51                   	push   %ecx
 2d4:	50                   	push   %eax
 2d5:	68 20 0b 00 00       	push   $0xb20
 2da:	6a 01                	push   $0x1
 2dc:	e8 2f 04 00 00       	call   710 <printf>
 2e1:	83 c4 10             	add    $0x10,%esp
      printf(1,"%c", *(char * )pointers[i]);
 2e4:	8b 07                	mov    (%edi),%eax
 2e6:	83 ec 04             	sub    $0x4,%esp
 2e9:	83 c7 04             	add    $0x4,%edi
 2ec:	0f be 00             	movsbl (%eax),%eax
 2ef:	50                   	push   %eax
 2f0:	68 16 0d 00 00       	push   $0xd16
 2f5:	6a 01                	push   $0x1
 2f7:	e8 14 04 00 00       	call   710 <printf>
    for (i = 0 ; i < size ; i++){
 2fc:	83 c4 10             	add    $0x10,%esp
 2ff:	39 df                	cmp    %ebx,%edi
 301:	75 e1                	jne    2e4 <test+0x2c4>
    printf(1, "\nson - done printing, changing array-number of free pages: %d, number of allocated pages: %d\n", fp, MAXPAGES - fp);
 303:	bb f6 df 00 00       	mov    $0xdff6,%ebx
    fp = get_number_of_free_pages();
 308:	e8 55 03 00 00       	call   662 <get_number_of_free_pages>
    printf(1, "\nson - done printing, changing array-number of free pages: %d, number of allocated pages: %d\n", fp, MAXPAGES - fp);
 30d:	89 d9                	mov    %ebx,%ecx
 30f:	29 c1                	sub    %eax,%ecx
 311:	51                   	push   %ecx
 312:	50                   	push   %eax
 313:	68 6c 0b 00 00       	push   $0xb6c
 318:	6a 01                	push   $0x1
 31a:	e8 f1 03 00 00       	call   710 <printf>
      * (char *) pointers[i] = (char) ('a' + i);
 31f:	c6 06 61             	movb   $0x61,(%esi)
    fp = get_number_of_free_pages();
 322:	e8 3b 03 00 00       	call   662 <get_number_of_free_pages>
    printf(1, "son - number of free pages after change: %d, number of allocated pages: %d, printing new array:\n", fp, MAXPAGES - fp);
 327:	29 c3                	sub    %eax,%ebx
 329:	53                   	push   %ebx
 32a:	50                   	push   %eax
 32b:	68 cc 0b 00 00       	push   $0xbcc
 330:	6a 01                	push   $0x1
 332:	e8 d9 03 00 00       	call   710 <printf>
 337:	83 c4 20             	add    $0x20,%esp
      printf(1,"%c", *(char * )pointers[i]);
 33a:	8b 75 94             	mov    -0x6c(%ebp),%esi
 33d:	83 ec 04             	sub    $0x4,%esp
 340:	8b 06                	mov    (%esi),%eax
 342:	83 c6 04             	add    $0x4,%esi
 345:	0f be 00             	movsbl (%eax),%eax
 348:	50                   	push   %eax
 349:	68 16 0d 00 00       	push   $0xd16
 34e:	6a 01                	push   $0x1
 350:	e8 bb 03 00 00       	call   710 <printf>
    for (i = 0 ; i < size ; i++){
 355:	83 c4 10             	add    $0x10,%esp
 358:	39 f7                	cmp    %esi,%edi
 35a:	89 75 94             	mov    %esi,-0x6c(%ebp)
 35d:	75 db                	jne    33a <test+0x31a>
 35f:	e9 4d ff ff ff       	jmp    2b1 <test+0x291>
 364:	66 90                	xchg   %ax,%ax
 366:	66 90                	xchg   %ax,%ax
 368:	66 90                	xchg   %ax,%ax
 36a:	66 90                	xchg   %ax,%ax
 36c:	66 90                	xchg   %ax,%ax
 36e:	66 90                	xchg   %ax,%ax

00000370 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	53                   	push   %ebx
 374:	8b 45 08             	mov    0x8(%ebp),%eax
 377:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 37a:	89 c2                	mov    %eax,%edx
 37c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 380:	83 c1 01             	add    $0x1,%ecx
 383:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 387:	83 c2 01             	add    $0x1,%edx
 38a:	84 db                	test   %bl,%bl
 38c:	88 5a ff             	mov    %bl,-0x1(%edx)
 38f:	75 ef                	jne    380 <strcpy+0x10>
    ;
  return os;
}
 391:	5b                   	pop    %ebx
 392:	5d                   	pop    %ebp
 393:	c3                   	ret    
 394:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 39a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000003a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3a0:	55                   	push   %ebp
 3a1:	89 e5                	mov    %esp,%ebp
 3a3:	53                   	push   %ebx
 3a4:	8b 55 08             	mov    0x8(%ebp),%edx
 3a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 3aa:	0f b6 02             	movzbl (%edx),%eax
 3ad:	0f b6 19             	movzbl (%ecx),%ebx
 3b0:	84 c0                	test   %al,%al
 3b2:	75 1c                	jne    3d0 <strcmp+0x30>
 3b4:	eb 2a                	jmp    3e0 <strcmp+0x40>
 3b6:	8d 76 00             	lea    0x0(%esi),%esi
 3b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 3c0:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 3c3:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 3c6:	83 c1 01             	add    $0x1,%ecx
 3c9:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 3cc:	84 c0                	test   %al,%al
 3ce:	74 10                	je     3e0 <strcmp+0x40>
 3d0:	38 d8                	cmp    %bl,%al
 3d2:	74 ec                	je     3c0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 3d4:	29 d8                	sub    %ebx,%eax
}
 3d6:	5b                   	pop    %ebx
 3d7:	5d                   	pop    %ebp
 3d8:	c3                   	ret    
 3d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3e0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 3e2:	29 d8                	sub    %ebx,%eax
}
 3e4:	5b                   	pop    %ebx
 3e5:	5d                   	pop    %ebp
 3e6:	c3                   	ret    
 3e7:	89 f6                	mov    %esi,%esi
 3e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003f0 <strlen>:

uint
strlen(const char *s)
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 3f6:	80 39 00             	cmpb   $0x0,(%ecx)
 3f9:	74 15                	je     410 <strlen+0x20>
 3fb:	31 d2                	xor    %edx,%edx
 3fd:	8d 76 00             	lea    0x0(%esi),%esi
 400:	83 c2 01             	add    $0x1,%edx
 403:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 407:	89 d0                	mov    %edx,%eax
 409:	75 f5                	jne    400 <strlen+0x10>
    ;
  return n;
}
 40b:	5d                   	pop    %ebp
 40c:	c3                   	ret    
 40d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 410:	31 c0                	xor    %eax,%eax
}
 412:	5d                   	pop    %ebp
 413:	c3                   	ret    
 414:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 41a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000420 <memset>:

void*
memset(void *dst, int c, uint n)
{
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	57                   	push   %edi
 424:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 427:	8b 4d 10             	mov    0x10(%ebp),%ecx
 42a:	8b 45 0c             	mov    0xc(%ebp),%eax
 42d:	89 d7                	mov    %edx,%edi
 42f:	fc                   	cld    
 430:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 432:	89 d0                	mov    %edx,%eax
 434:	5f                   	pop    %edi
 435:	5d                   	pop    %ebp
 436:	c3                   	ret    
 437:	89 f6                	mov    %esi,%esi
 439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000440 <strchr>:

char*
strchr(const char *s, char c)
{
 440:	55                   	push   %ebp
 441:	89 e5                	mov    %esp,%ebp
 443:	53                   	push   %ebx
 444:	8b 45 08             	mov    0x8(%ebp),%eax
 447:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 44a:	0f b6 10             	movzbl (%eax),%edx
 44d:	84 d2                	test   %dl,%dl
 44f:	74 1d                	je     46e <strchr+0x2e>
    if(*s == c)
 451:	38 d3                	cmp    %dl,%bl
 453:	89 d9                	mov    %ebx,%ecx
 455:	75 0d                	jne    464 <strchr+0x24>
 457:	eb 17                	jmp    470 <strchr+0x30>
 459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 460:	38 ca                	cmp    %cl,%dl
 462:	74 0c                	je     470 <strchr+0x30>
  for(; *s; s++)
 464:	83 c0 01             	add    $0x1,%eax
 467:	0f b6 10             	movzbl (%eax),%edx
 46a:	84 d2                	test   %dl,%dl
 46c:	75 f2                	jne    460 <strchr+0x20>
      return (char*)s;
  return 0;
 46e:	31 c0                	xor    %eax,%eax
}
 470:	5b                   	pop    %ebx
 471:	5d                   	pop    %ebp
 472:	c3                   	ret    
 473:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000480 <gets>:

char*
gets(char *buf, int max)
{
 480:	55                   	push   %ebp
 481:	89 e5                	mov    %esp,%ebp
 483:	57                   	push   %edi
 484:	56                   	push   %esi
 485:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 486:	31 f6                	xor    %esi,%esi
 488:	89 f3                	mov    %esi,%ebx
{
 48a:	83 ec 1c             	sub    $0x1c,%esp
 48d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 490:	eb 2f                	jmp    4c1 <gets+0x41>
 492:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 498:	8d 45 e7             	lea    -0x19(%ebp),%eax
 49b:	83 ec 04             	sub    $0x4,%esp
 49e:	6a 01                	push   $0x1
 4a0:	50                   	push   %eax
 4a1:	6a 00                	push   $0x0
 4a3:	e8 32 01 00 00       	call   5da <read>
    if(cc < 1)
 4a8:	83 c4 10             	add    $0x10,%esp
 4ab:	85 c0                	test   %eax,%eax
 4ad:	7e 1c                	jle    4cb <gets+0x4b>
      break;
    buf[i++] = c;
 4af:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 4b3:	83 c7 01             	add    $0x1,%edi
 4b6:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 4b9:	3c 0a                	cmp    $0xa,%al
 4bb:	74 23                	je     4e0 <gets+0x60>
 4bd:	3c 0d                	cmp    $0xd,%al
 4bf:	74 1f                	je     4e0 <gets+0x60>
  for(i=0; i+1 < max; ){
 4c1:	83 c3 01             	add    $0x1,%ebx
 4c4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 4c7:	89 fe                	mov    %edi,%esi
 4c9:	7c cd                	jl     498 <gets+0x18>
 4cb:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 4cd:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 4d0:	c6 03 00             	movb   $0x0,(%ebx)
}
 4d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4d6:	5b                   	pop    %ebx
 4d7:	5e                   	pop    %esi
 4d8:	5f                   	pop    %edi
 4d9:	5d                   	pop    %ebp
 4da:	c3                   	ret    
 4db:	90                   	nop
 4dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4e0:	8b 75 08             	mov    0x8(%ebp),%esi
 4e3:	8b 45 08             	mov    0x8(%ebp),%eax
 4e6:	01 de                	add    %ebx,%esi
 4e8:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 4ea:	c6 03 00             	movb   $0x0,(%ebx)
}
 4ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4f0:	5b                   	pop    %ebx
 4f1:	5e                   	pop    %esi
 4f2:	5f                   	pop    %edi
 4f3:	5d                   	pop    %ebp
 4f4:	c3                   	ret    
 4f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000500 <stat>:

int
stat(const char *n, struct stat *st)
{
 500:	55                   	push   %ebp
 501:	89 e5                	mov    %esp,%ebp
 503:	56                   	push   %esi
 504:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 505:	83 ec 08             	sub    $0x8,%esp
 508:	6a 00                	push   $0x0
 50a:	ff 75 08             	pushl  0x8(%ebp)
 50d:	e8 f0 00 00 00       	call   602 <open>
  if(fd < 0)
 512:	83 c4 10             	add    $0x10,%esp
 515:	85 c0                	test   %eax,%eax
 517:	78 27                	js     540 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 519:	83 ec 08             	sub    $0x8,%esp
 51c:	ff 75 0c             	pushl  0xc(%ebp)
 51f:	89 c3                	mov    %eax,%ebx
 521:	50                   	push   %eax
 522:	e8 f3 00 00 00       	call   61a <fstat>
  close(fd);
 527:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 52a:	89 c6                	mov    %eax,%esi
  close(fd);
 52c:	e8 b9 00 00 00       	call   5ea <close>
  return r;
 531:	83 c4 10             	add    $0x10,%esp
}
 534:	8d 65 f8             	lea    -0x8(%ebp),%esp
 537:	89 f0                	mov    %esi,%eax
 539:	5b                   	pop    %ebx
 53a:	5e                   	pop    %esi
 53b:	5d                   	pop    %ebp
 53c:	c3                   	ret    
 53d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 540:	be ff ff ff ff       	mov    $0xffffffff,%esi
 545:	eb ed                	jmp    534 <stat+0x34>
 547:	89 f6                	mov    %esi,%esi
 549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000550 <atoi>:

int
atoi(const char *s)
{
 550:	55                   	push   %ebp
 551:	89 e5                	mov    %esp,%ebp
 553:	53                   	push   %ebx
 554:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 557:	0f be 11             	movsbl (%ecx),%edx
 55a:	8d 42 d0             	lea    -0x30(%edx),%eax
 55d:	3c 09                	cmp    $0x9,%al
  n = 0;
 55f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 564:	77 1f                	ja     585 <atoi+0x35>
 566:	8d 76 00             	lea    0x0(%esi),%esi
 569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 570:	8d 04 80             	lea    (%eax,%eax,4),%eax
 573:	83 c1 01             	add    $0x1,%ecx
 576:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 57a:	0f be 11             	movsbl (%ecx),%edx
 57d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 580:	80 fb 09             	cmp    $0x9,%bl
 583:	76 eb                	jbe    570 <atoi+0x20>
  return n;
}
 585:	5b                   	pop    %ebx
 586:	5d                   	pop    %ebp
 587:	c3                   	ret    
 588:	90                   	nop
 589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000590 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 590:	55                   	push   %ebp
 591:	89 e5                	mov    %esp,%ebp
 593:	56                   	push   %esi
 594:	53                   	push   %ebx
 595:	8b 5d 10             	mov    0x10(%ebp),%ebx
 598:	8b 45 08             	mov    0x8(%ebp),%eax
 59b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 59e:	85 db                	test   %ebx,%ebx
 5a0:	7e 14                	jle    5b6 <memmove+0x26>
 5a2:	31 d2                	xor    %edx,%edx
 5a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 5a8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 5ac:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 5af:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 5b2:	39 d3                	cmp    %edx,%ebx
 5b4:	75 f2                	jne    5a8 <memmove+0x18>
  return vdst;
}
 5b6:	5b                   	pop    %ebx
 5b7:	5e                   	pop    %esi
 5b8:	5d                   	pop    %ebp
 5b9:	c3                   	ret    

000005ba <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5ba:	b8 01 00 00 00       	mov    $0x1,%eax
 5bf:	cd 40                	int    $0x40
 5c1:	c3                   	ret    

000005c2 <exit>:
SYSCALL(exit)
 5c2:	b8 02 00 00 00       	mov    $0x2,%eax
 5c7:	cd 40                	int    $0x40
 5c9:	c3                   	ret    

000005ca <wait>:
SYSCALL(wait)
 5ca:	b8 03 00 00 00       	mov    $0x3,%eax
 5cf:	cd 40                	int    $0x40
 5d1:	c3                   	ret    

000005d2 <pipe>:
SYSCALL(pipe)
 5d2:	b8 04 00 00 00       	mov    $0x4,%eax
 5d7:	cd 40                	int    $0x40
 5d9:	c3                   	ret    

000005da <read>:
SYSCALL(read)
 5da:	b8 05 00 00 00       	mov    $0x5,%eax
 5df:	cd 40                	int    $0x40
 5e1:	c3                   	ret    

000005e2 <write>:
SYSCALL(write)
 5e2:	b8 10 00 00 00       	mov    $0x10,%eax
 5e7:	cd 40                	int    $0x40
 5e9:	c3                   	ret    

000005ea <close>:
SYSCALL(close)
 5ea:	b8 15 00 00 00       	mov    $0x15,%eax
 5ef:	cd 40                	int    $0x40
 5f1:	c3                   	ret    

000005f2 <kill>:
SYSCALL(kill)
 5f2:	b8 06 00 00 00       	mov    $0x6,%eax
 5f7:	cd 40                	int    $0x40
 5f9:	c3                   	ret    

000005fa <exec>:
SYSCALL(exec)
 5fa:	b8 07 00 00 00       	mov    $0x7,%eax
 5ff:	cd 40                	int    $0x40
 601:	c3                   	ret    

00000602 <open>:
SYSCALL(open)
 602:	b8 0f 00 00 00       	mov    $0xf,%eax
 607:	cd 40                	int    $0x40
 609:	c3                   	ret    

0000060a <mknod>:
SYSCALL(mknod)
 60a:	b8 11 00 00 00       	mov    $0x11,%eax
 60f:	cd 40                	int    $0x40
 611:	c3                   	ret    

00000612 <unlink>:
SYSCALL(unlink)
 612:	b8 12 00 00 00       	mov    $0x12,%eax
 617:	cd 40                	int    $0x40
 619:	c3                   	ret    

0000061a <fstat>:
SYSCALL(fstat)
 61a:	b8 08 00 00 00       	mov    $0x8,%eax
 61f:	cd 40                	int    $0x40
 621:	c3                   	ret    

00000622 <link>:
SYSCALL(link)
 622:	b8 13 00 00 00       	mov    $0x13,%eax
 627:	cd 40                	int    $0x40
 629:	c3                   	ret    

0000062a <mkdir>:
SYSCALL(mkdir)
 62a:	b8 14 00 00 00       	mov    $0x14,%eax
 62f:	cd 40                	int    $0x40
 631:	c3                   	ret    

00000632 <chdir>:
SYSCALL(chdir)
 632:	b8 09 00 00 00       	mov    $0x9,%eax
 637:	cd 40                	int    $0x40
 639:	c3                   	ret    

0000063a <dup>:
SYSCALL(dup)
 63a:	b8 0a 00 00 00       	mov    $0xa,%eax
 63f:	cd 40                	int    $0x40
 641:	c3                   	ret    

00000642 <getpid>:
SYSCALL(getpid)
 642:	b8 0b 00 00 00       	mov    $0xb,%eax
 647:	cd 40                	int    $0x40
 649:	c3                   	ret    

0000064a <sbrk>:
SYSCALL(sbrk)
 64a:	b8 0c 00 00 00       	mov    $0xc,%eax
 64f:	cd 40                	int    $0x40
 651:	c3                   	ret    

00000652 <sleep>:
SYSCALL(sleep)
 652:	b8 0d 00 00 00       	mov    $0xd,%eax
 657:	cd 40                	int    $0x40
 659:	c3                   	ret    

0000065a <uptime>:
SYSCALL(uptime)
 65a:	b8 0e 00 00 00       	mov    $0xe,%eax
 65f:	cd 40                	int    $0x40
 661:	c3                   	ret    

00000662 <get_number_of_free_pages>:
 662:	b8 16 00 00 00       	mov    $0x16,%eax
 667:	cd 40                	int    $0x40
 669:	c3                   	ret    
 66a:	66 90                	xchg   %ax,%ax
 66c:	66 90                	xchg   %ax,%ax
 66e:	66 90                	xchg   %ax,%ax

00000670 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 670:	55                   	push   %ebp
 671:	89 e5                	mov    %esp,%ebp
 673:	57                   	push   %edi
 674:	56                   	push   %esi
 675:	53                   	push   %ebx
 676:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 679:	85 d2                	test   %edx,%edx
{
 67b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 67e:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 680:	79 76                	jns    6f8 <printint+0x88>
 682:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 686:	74 70                	je     6f8 <printint+0x88>
    x = -xx;
 688:	f7 d8                	neg    %eax
    neg = 1;
 68a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 691:	31 f6                	xor    %esi,%esi
 693:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 696:	eb 0a                	jmp    6a2 <printint+0x32>
 698:	90                   	nop
 699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 6a0:	89 fe                	mov    %edi,%esi
 6a2:	31 d2                	xor    %edx,%edx
 6a4:	8d 7e 01             	lea    0x1(%esi),%edi
 6a7:	f7 f1                	div    %ecx
 6a9:	0f b6 92 40 0d 00 00 	movzbl 0xd40(%edx),%edx
  }while((x /= base) != 0);
 6b0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 6b2:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 6b5:	75 e9                	jne    6a0 <printint+0x30>
  if(neg)
 6b7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 6ba:	85 c0                	test   %eax,%eax
 6bc:	74 08                	je     6c6 <printint+0x56>
    buf[i++] = '-';
 6be:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 6c3:	8d 7e 02             	lea    0x2(%esi),%edi
 6c6:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 6ca:	8b 7d c0             	mov    -0x40(%ebp),%edi
 6cd:	8d 76 00             	lea    0x0(%esi),%esi
 6d0:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 6d3:	83 ec 04             	sub    $0x4,%esp
 6d6:	83 ee 01             	sub    $0x1,%esi
 6d9:	6a 01                	push   $0x1
 6db:	53                   	push   %ebx
 6dc:	57                   	push   %edi
 6dd:	88 45 d7             	mov    %al,-0x29(%ebp)
 6e0:	e8 fd fe ff ff       	call   5e2 <write>

  while(--i >= 0)
 6e5:	83 c4 10             	add    $0x10,%esp
 6e8:	39 de                	cmp    %ebx,%esi
 6ea:	75 e4                	jne    6d0 <printint+0x60>
    putc(fd, buf[i]);
}
 6ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6ef:	5b                   	pop    %ebx
 6f0:	5e                   	pop    %esi
 6f1:	5f                   	pop    %edi
 6f2:	5d                   	pop    %ebp
 6f3:	c3                   	ret    
 6f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 6f8:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 6ff:	eb 90                	jmp    691 <printint+0x21>
 701:	eb 0d                	jmp    710 <printf>
 703:	90                   	nop
 704:	90                   	nop
 705:	90                   	nop
 706:	90                   	nop
 707:	90                   	nop
 708:	90                   	nop
 709:	90                   	nop
 70a:	90                   	nop
 70b:	90                   	nop
 70c:	90                   	nop
 70d:	90                   	nop
 70e:	90                   	nop
 70f:	90                   	nop

00000710 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 710:	55                   	push   %ebp
 711:	89 e5                	mov    %esp,%ebp
 713:	57                   	push   %edi
 714:	56                   	push   %esi
 715:	53                   	push   %ebx
 716:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 719:	8b 75 0c             	mov    0xc(%ebp),%esi
 71c:	0f b6 1e             	movzbl (%esi),%ebx
 71f:	84 db                	test   %bl,%bl
 721:	0f 84 b3 00 00 00    	je     7da <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 727:	8d 45 10             	lea    0x10(%ebp),%eax
 72a:	83 c6 01             	add    $0x1,%esi
  state = 0;
 72d:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 72f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 732:	eb 2f                	jmp    763 <printf+0x53>
 734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 738:	83 f8 25             	cmp    $0x25,%eax
 73b:	0f 84 a7 00 00 00    	je     7e8 <printf+0xd8>
  write(fd, &c, 1);
 741:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 744:	83 ec 04             	sub    $0x4,%esp
 747:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 74a:	6a 01                	push   $0x1
 74c:	50                   	push   %eax
 74d:	ff 75 08             	pushl  0x8(%ebp)
 750:	e8 8d fe ff ff       	call   5e2 <write>
 755:	83 c4 10             	add    $0x10,%esp
 758:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 75b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 75f:	84 db                	test   %bl,%bl
 761:	74 77                	je     7da <printf+0xca>
    if(state == 0){
 763:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 765:	0f be cb             	movsbl %bl,%ecx
 768:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 76b:	74 cb                	je     738 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 76d:	83 ff 25             	cmp    $0x25,%edi
 770:	75 e6                	jne    758 <printf+0x48>
      if(c == 'd'){
 772:	83 f8 64             	cmp    $0x64,%eax
 775:	0f 84 05 01 00 00    	je     880 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 77b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 781:	83 f9 70             	cmp    $0x70,%ecx
 784:	74 72                	je     7f8 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 786:	83 f8 73             	cmp    $0x73,%eax
 789:	0f 84 99 00 00 00    	je     828 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 78f:	83 f8 63             	cmp    $0x63,%eax
 792:	0f 84 08 01 00 00    	je     8a0 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 798:	83 f8 25             	cmp    $0x25,%eax
 79b:	0f 84 ef 00 00 00    	je     890 <printf+0x180>
  write(fd, &c, 1);
 7a1:	8d 45 e7             	lea    -0x19(%ebp),%eax
 7a4:	83 ec 04             	sub    $0x4,%esp
 7a7:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 7ab:	6a 01                	push   $0x1
 7ad:	50                   	push   %eax
 7ae:	ff 75 08             	pushl  0x8(%ebp)
 7b1:	e8 2c fe ff ff       	call   5e2 <write>
 7b6:	83 c4 0c             	add    $0xc,%esp
 7b9:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 7bc:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 7bf:	6a 01                	push   $0x1
 7c1:	50                   	push   %eax
 7c2:	ff 75 08             	pushl  0x8(%ebp)
 7c5:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 7c8:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 7ca:	e8 13 fe ff ff       	call   5e2 <write>
  for(i = 0; fmt[i]; i++){
 7cf:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 7d3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 7d6:	84 db                	test   %bl,%bl
 7d8:	75 89                	jne    763 <printf+0x53>
    }
  }
}
 7da:	8d 65 f4             	lea    -0xc(%ebp),%esp
 7dd:	5b                   	pop    %ebx
 7de:	5e                   	pop    %esi
 7df:	5f                   	pop    %edi
 7e0:	5d                   	pop    %ebp
 7e1:	c3                   	ret    
 7e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 7e8:	bf 25 00 00 00       	mov    $0x25,%edi
 7ed:	e9 66 ff ff ff       	jmp    758 <printf+0x48>
 7f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 7f8:	83 ec 0c             	sub    $0xc,%esp
 7fb:	b9 10 00 00 00       	mov    $0x10,%ecx
 800:	6a 00                	push   $0x0
 802:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 805:	8b 45 08             	mov    0x8(%ebp),%eax
 808:	8b 17                	mov    (%edi),%edx
 80a:	e8 61 fe ff ff       	call   670 <printint>
        ap++;
 80f:	89 f8                	mov    %edi,%eax
 811:	83 c4 10             	add    $0x10,%esp
      state = 0;
 814:	31 ff                	xor    %edi,%edi
        ap++;
 816:	83 c0 04             	add    $0x4,%eax
 819:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 81c:	e9 37 ff ff ff       	jmp    758 <printf+0x48>
 821:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 828:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 82b:	8b 08                	mov    (%eax),%ecx
        ap++;
 82d:	83 c0 04             	add    $0x4,%eax
 830:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 833:	85 c9                	test   %ecx,%ecx
 835:	0f 84 8e 00 00 00    	je     8c9 <printf+0x1b9>
        while(*s != 0){
 83b:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 83e:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 840:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 842:	84 c0                	test   %al,%al
 844:	0f 84 0e ff ff ff    	je     758 <printf+0x48>
 84a:	89 75 d0             	mov    %esi,-0x30(%ebp)
 84d:	89 de                	mov    %ebx,%esi
 84f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 852:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 855:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 858:	83 ec 04             	sub    $0x4,%esp
          s++;
 85b:	83 c6 01             	add    $0x1,%esi
 85e:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 861:	6a 01                	push   $0x1
 863:	57                   	push   %edi
 864:	53                   	push   %ebx
 865:	e8 78 fd ff ff       	call   5e2 <write>
        while(*s != 0){
 86a:	0f b6 06             	movzbl (%esi),%eax
 86d:	83 c4 10             	add    $0x10,%esp
 870:	84 c0                	test   %al,%al
 872:	75 e4                	jne    858 <printf+0x148>
 874:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 877:	31 ff                	xor    %edi,%edi
 879:	e9 da fe ff ff       	jmp    758 <printf+0x48>
 87e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 880:	83 ec 0c             	sub    $0xc,%esp
 883:	b9 0a 00 00 00       	mov    $0xa,%ecx
 888:	6a 01                	push   $0x1
 88a:	e9 73 ff ff ff       	jmp    802 <printf+0xf2>
 88f:	90                   	nop
  write(fd, &c, 1);
 890:	83 ec 04             	sub    $0x4,%esp
 893:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 896:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 899:	6a 01                	push   $0x1
 89b:	e9 21 ff ff ff       	jmp    7c1 <printf+0xb1>
        putc(fd, *ap);
 8a0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 8a3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 8a6:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 8a8:	6a 01                	push   $0x1
        ap++;
 8aa:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 8ad:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 8b0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 8b3:	50                   	push   %eax
 8b4:	ff 75 08             	pushl  0x8(%ebp)
 8b7:	e8 26 fd ff ff       	call   5e2 <write>
        ap++;
 8bc:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 8bf:	83 c4 10             	add    $0x10,%esp
      state = 0;
 8c2:	31 ff                	xor    %edi,%edi
 8c4:	e9 8f fe ff ff       	jmp    758 <printf+0x48>
          s = "(null)";
 8c9:	bb 38 0d 00 00       	mov    $0xd38,%ebx
        while(*s != 0){
 8ce:	b8 28 00 00 00       	mov    $0x28,%eax
 8d3:	e9 72 ff ff ff       	jmp    84a <printf+0x13a>
 8d8:	66 90                	xchg   %ax,%ax
 8da:	66 90                	xchg   %ax,%ax
 8dc:	66 90                	xchg   %ax,%ax
 8de:	66 90                	xchg   %ax,%ax

000008e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8e0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8e1:	a1 14 10 00 00       	mov    0x1014,%eax
{
 8e6:	89 e5                	mov    %esp,%ebp
 8e8:	57                   	push   %edi
 8e9:	56                   	push   %esi
 8ea:	53                   	push   %ebx
 8eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 8ee:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 8f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8f8:	39 c8                	cmp    %ecx,%eax
 8fa:	8b 10                	mov    (%eax),%edx
 8fc:	73 32                	jae    930 <free+0x50>
 8fe:	39 d1                	cmp    %edx,%ecx
 900:	72 04                	jb     906 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 902:	39 d0                	cmp    %edx,%eax
 904:	72 32                	jb     938 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 906:	8b 73 fc             	mov    -0x4(%ebx),%esi
 909:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 90c:	39 fa                	cmp    %edi,%edx
 90e:	74 30                	je     940 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 910:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 913:	8b 50 04             	mov    0x4(%eax),%edx
 916:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 919:	39 f1                	cmp    %esi,%ecx
 91b:	74 3a                	je     957 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 91d:	89 08                	mov    %ecx,(%eax)
  freep = p;
 91f:	a3 14 10 00 00       	mov    %eax,0x1014
}
 924:	5b                   	pop    %ebx
 925:	5e                   	pop    %esi
 926:	5f                   	pop    %edi
 927:	5d                   	pop    %ebp
 928:	c3                   	ret    
 929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 930:	39 d0                	cmp    %edx,%eax
 932:	72 04                	jb     938 <free+0x58>
 934:	39 d1                	cmp    %edx,%ecx
 936:	72 ce                	jb     906 <free+0x26>
{
 938:	89 d0                	mov    %edx,%eax
 93a:	eb bc                	jmp    8f8 <free+0x18>
 93c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 940:	03 72 04             	add    0x4(%edx),%esi
 943:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 946:	8b 10                	mov    (%eax),%edx
 948:	8b 12                	mov    (%edx),%edx
 94a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 94d:	8b 50 04             	mov    0x4(%eax),%edx
 950:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 953:	39 f1                	cmp    %esi,%ecx
 955:	75 c6                	jne    91d <free+0x3d>
    p->s.size += bp->s.size;
 957:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 95a:	a3 14 10 00 00       	mov    %eax,0x1014
    p->s.size += bp->s.size;
 95f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 962:	8b 53 f8             	mov    -0x8(%ebx),%edx
 965:	89 10                	mov    %edx,(%eax)
}
 967:	5b                   	pop    %ebx
 968:	5e                   	pop    %esi
 969:	5f                   	pop    %edi
 96a:	5d                   	pop    %ebp
 96b:	c3                   	ret    
 96c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000970 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 970:	55                   	push   %ebp
 971:	89 e5                	mov    %esp,%ebp
 973:	57                   	push   %edi
 974:	56                   	push   %esi
 975:	53                   	push   %ebx
 976:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 979:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 97c:	8b 15 14 10 00 00    	mov    0x1014,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 982:	8d 78 07             	lea    0x7(%eax),%edi
 985:	c1 ef 03             	shr    $0x3,%edi
 988:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 98b:	85 d2                	test   %edx,%edx
 98d:	0f 84 9d 00 00 00    	je     a30 <malloc+0xc0>
 993:	8b 02                	mov    (%edx),%eax
 995:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 998:	39 cf                	cmp    %ecx,%edi
 99a:	76 6c                	jbe    a08 <malloc+0x98>
 99c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 9a2:	bb 00 10 00 00       	mov    $0x1000,%ebx
 9a7:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 9aa:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 9b1:	eb 0e                	jmp    9c1 <malloc+0x51>
 9b3:	90                   	nop
 9b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9b8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 9ba:	8b 48 04             	mov    0x4(%eax),%ecx
 9bd:	39 f9                	cmp    %edi,%ecx
 9bf:	73 47                	jae    a08 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9c1:	39 05 14 10 00 00    	cmp    %eax,0x1014
 9c7:	89 c2                	mov    %eax,%edx
 9c9:	75 ed                	jne    9b8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 9cb:	83 ec 0c             	sub    $0xc,%esp
 9ce:	56                   	push   %esi
 9cf:	e8 76 fc ff ff       	call   64a <sbrk>
  if(p == (char*)-1)
 9d4:	83 c4 10             	add    $0x10,%esp
 9d7:	83 f8 ff             	cmp    $0xffffffff,%eax
 9da:	74 1c                	je     9f8 <malloc+0x88>
  hp->s.size = nu;
 9dc:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 9df:	83 ec 0c             	sub    $0xc,%esp
 9e2:	83 c0 08             	add    $0x8,%eax
 9e5:	50                   	push   %eax
 9e6:	e8 f5 fe ff ff       	call   8e0 <free>
  return freep;
 9eb:	8b 15 14 10 00 00    	mov    0x1014,%edx
      if((p = morecore(nunits)) == 0)
 9f1:	83 c4 10             	add    $0x10,%esp
 9f4:	85 d2                	test   %edx,%edx
 9f6:	75 c0                	jne    9b8 <malloc+0x48>
        return 0;
  }
}
 9f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 9fb:	31 c0                	xor    %eax,%eax
}
 9fd:	5b                   	pop    %ebx
 9fe:	5e                   	pop    %esi
 9ff:	5f                   	pop    %edi
 a00:	5d                   	pop    %ebp
 a01:	c3                   	ret    
 a02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 a08:	39 cf                	cmp    %ecx,%edi
 a0a:	74 54                	je     a60 <malloc+0xf0>
        p->s.size -= nunits;
 a0c:	29 f9                	sub    %edi,%ecx
 a0e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 a11:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 a14:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 a17:	89 15 14 10 00 00    	mov    %edx,0x1014
}
 a1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 a20:	83 c0 08             	add    $0x8,%eax
}
 a23:	5b                   	pop    %ebx
 a24:	5e                   	pop    %esi
 a25:	5f                   	pop    %edi
 a26:	5d                   	pop    %ebp
 a27:	c3                   	ret    
 a28:	90                   	nop
 a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 a30:	c7 05 14 10 00 00 18 	movl   $0x1018,0x1014
 a37:	10 00 00 
 a3a:	c7 05 18 10 00 00 18 	movl   $0x1018,0x1018
 a41:	10 00 00 
    base.s.size = 0;
 a44:	b8 18 10 00 00       	mov    $0x1018,%eax
 a49:	c7 05 1c 10 00 00 00 	movl   $0x0,0x101c
 a50:	00 00 00 
 a53:	e9 44 ff ff ff       	jmp    99c <malloc+0x2c>
 a58:	90                   	nop
 a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 a60:	8b 08                	mov    (%eax),%ecx
 a62:	89 0a                	mov    %ecx,(%edx)
 a64:	eb b1                	jmp    a17 <malloc+0xa7>
