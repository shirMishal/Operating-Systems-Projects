
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  }
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
  11:	57                   	push   %edi
  12:	56                   	push   %esi
  13:	be 01 00 00 00       	mov    $0x1,%esi
  18:	53                   	push   %ebx
  19:	51                   	push   %ecx
  1a:	83 ec 18             	sub    $0x18,%esp
  1d:	8b 01                	mov    (%ecx),%eax
  1f:	8b 59 04             	mov    0x4(%ecx),%ebx
  22:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  25:	83 c3 04             	add    $0x4,%ebx
  int fd, i;

  if(argc <= 1){
  28:	83 f8 01             	cmp    $0x1,%eax
  2b:	7e 5c                	jle    89 <main+0x89>
  2d:	8d 76 00             	lea    0x0(%esi),%esi
    cat(0);
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
  30:	83 ec 08             	sub    $0x8,%esp
  33:	6a 00                	push   $0x0
  35:	ff 33                	pushl  (%ebx)
  37:	e8 97 03 00 00       	call   3d3 <open>
  3c:	83 c4 10             	add    $0x10,%esp
  3f:	89 c7                	mov    %eax,%edi
  41:	85 c0                	test   %eax,%eax
  43:	78 29                	js     6e <main+0x6e>
      printf(1, "cat: cannot open %s\n", argv[i]);
      exit(0);
    }
    cat(fd);
  45:	83 ec 0c             	sub    $0xc,%esp
  for(i = 1; i < argc; i++){
  48:	83 c6 01             	add    $0x1,%esi
  4b:	83 c3 04             	add    $0x4,%ebx
    cat(fd);
  4e:	50                   	push   %eax
  4f:	e8 4c 00 00 00       	call   a0 <cat>
    close(fd);
  54:	89 3c 24             	mov    %edi,(%esp)
  57:	e8 5f 03 00 00       	call   3bb <close>
  for(i = 1; i < argc; i++){
  5c:	83 c4 10             	add    $0x10,%esp
  5f:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  62:	75 cc                	jne    30 <main+0x30>
  }
  exit(0);
  64:	83 ec 0c             	sub    $0xc,%esp
  67:	6a 00                	push   $0x0
  69:	e8 25 03 00 00       	call   393 <exit>
      printf(1, "cat: cannot open %s\n", argv[i]);
  6e:	50                   	push   %eax
  6f:	ff 33                	pushl  (%ebx)
  71:	68 7b 08 00 00       	push   $0x87b
  76:	6a 01                	push   $0x1
  78:	e8 73 04 00 00       	call   4f0 <printf>
      exit(0);
  7d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  84:	e8 0a 03 00 00       	call   393 <exit>
    cat(0);
  89:	83 ec 0c             	sub    $0xc,%esp
  8c:	6a 00                	push   $0x0
  8e:	e8 0d 00 00 00       	call   a0 <cat>
    exit(0);
  93:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  9a:	e8 f4 02 00 00       	call   393 <exit>
  9f:	90                   	nop

000000a0 <cat>:
{
  a0:	f3 0f 1e fb          	endbr32 
  a4:	55                   	push   %ebp
  a5:	89 e5                	mov    %esp,%ebp
  a7:	56                   	push   %esi
  a8:	8b 75 08             	mov    0x8(%ebp),%esi
  ab:	53                   	push   %ebx
  while((n = read(fd, buf, sizeof(buf))) > 0) {
  ac:	eb 19                	jmp    c7 <cat+0x27>
  ae:	66 90                	xchg   %ax,%ax
    if (write(1, buf, n) != n) {
  b0:	83 ec 04             	sub    $0x4,%esp
  b3:	53                   	push   %ebx
  b4:	68 a0 0b 00 00       	push   $0xba0
  b9:	6a 01                	push   $0x1
  bb:	e8 f3 02 00 00       	call   3b3 <write>
  c0:	83 c4 10             	add    $0x10,%esp
  c3:	39 d8                	cmp    %ebx,%eax
  c5:	75 25                	jne    ec <cat+0x4c>
  while((n = read(fd, buf, sizeof(buf))) > 0) {
  c7:	83 ec 04             	sub    $0x4,%esp
  ca:	68 00 02 00 00       	push   $0x200
  cf:	68 a0 0b 00 00       	push   $0xba0
  d4:	56                   	push   %esi
  d5:	e8 d1 02 00 00       	call   3ab <read>
  da:	83 c4 10             	add    $0x10,%esp
  dd:	89 c3                	mov    %eax,%ebx
  df:	85 c0                	test   %eax,%eax
  e1:	7f cd                	jg     b0 <cat+0x10>
  if(n < 0){
  e3:	75 22                	jne    107 <cat+0x67>
}
  e5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  e8:	5b                   	pop    %ebx
  e9:	5e                   	pop    %esi
  ea:	5d                   	pop    %ebp
  eb:	c3                   	ret    
      printf(1, "cat: write error\n");
  ec:	83 ec 08             	sub    $0x8,%esp
  ef:	68 58 08 00 00       	push   $0x858
  f4:	6a 01                	push   $0x1
  f6:	e8 f5 03 00 00       	call   4f0 <printf>
      exit(0);
  fb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 102:	e8 8c 02 00 00       	call   393 <exit>
    printf(1, "cat: read error\n");
 107:	50                   	push   %eax
 108:	50                   	push   %eax
 109:	68 6a 08 00 00       	push   $0x86a
 10e:	6a 01                	push   $0x1
 110:	e8 db 03 00 00       	call   4f0 <printf>
    exit(0);
 115:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 11c:	e8 72 02 00 00       	call   393 <exit>
 121:	66 90                	xchg   %ax,%ax
 123:	66 90                	xchg   %ax,%ax
 125:	66 90                	xchg   %ax,%ax
 127:	66 90                	xchg   %ax,%ax
 129:	66 90                	xchg   %ax,%ax
 12b:	66 90                	xchg   %ax,%ax
 12d:	66 90                	xchg   %ax,%ax
 12f:	90                   	nop

00000130 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 130:	f3 0f 1e fb          	endbr32 
 134:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 135:	31 c0                	xor    %eax,%eax
{
 137:	89 e5                	mov    %esp,%ebp
 139:	53                   	push   %ebx
 13a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 13d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
 140:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 144:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 147:	83 c0 01             	add    $0x1,%eax
 14a:	84 d2                	test   %dl,%dl
 14c:	75 f2                	jne    140 <strcpy+0x10>
    ;
  return os;
}
 14e:	89 c8                	mov    %ecx,%eax
 150:	5b                   	pop    %ebx
 151:	5d                   	pop    %ebp
 152:	c3                   	ret    
 153:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 15a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000160 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 160:	f3 0f 1e fb          	endbr32 
 164:	55                   	push   %ebp
 165:	89 e5                	mov    %esp,%ebp
 167:	53                   	push   %ebx
 168:	8b 4d 08             	mov    0x8(%ebp),%ecx
 16b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 16e:	0f b6 01             	movzbl (%ecx),%eax
 171:	0f b6 1a             	movzbl (%edx),%ebx
 174:	84 c0                	test   %al,%al
 176:	75 19                	jne    191 <strcmp+0x31>
 178:	eb 26                	jmp    1a0 <strcmp+0x40>
 17a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 180:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 184:	83 c1 01             	add    $0x1,%ecx
 187:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 18a:	0f b6 1a             	movzbl (%edx),%ebx
 18d:	84 c0                	test   %al,%al
 18f:	74 0f                	je     1a0 <strcmp+0x40>
 191:	38 d8                	cmp    %bl,%al
 193:	74 eb                	je     180 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 195:	29 d8                	sub    %ebx,%eax
}
 197:	5b                   	pop    %ebx
 198:	5d                   	pop    %ebp
 199:	c3                   	ret    
 19a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1a0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 1a2:	29 d8                	sub    %ebx,%eax
}
 1a4:	5b                   	pop    %ebx
 1a5:	5d                   	pop    %ebp
 1a6:	c3                   	ret    
 1a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1ae:	66 90                	xchg   %ax,%ax

000001b0 <strlen>:

uint
strlen(const char *s)
{
 1b0:	f3 0f 1e fb          	endbr32 
 1b4:	55                   	push   %ebp
 1b5:	89 e5                	mov    %esp,%ebp
 1b7:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 1ba:	80 3a 00             	cmpb   $0x0,(%edx)
 1bd:	74 21                	je     1e0 <strlen+0x30>
 1bf:	31 c0                	xor    %eax,%eax
 1c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1c8:	83 c0 01             	add    $0x1,%eax
 1cb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 1cf:	89 c1                	mov    %eax,%ecx
 1d1:	75 f5                	jne    1c8 <strlen+0x18>
    ;
  return n;
}
 1d3:	89 c8                	mov    %ecx,%eax
 1d5:	5d                   	pop    %ebp
 1d6:	c3                   	ret    
 1d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1de:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
 1e0:	31 c9                	xor    %ecx,%ecx
}
 1e2:	5d                   	pop    %ebp
 1e3:	89 c8                	mov    %ecx,%eax
 1e5:	c3                   	ret    
 1e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1ed:	8d 76 00             	lea    0x0(%esi),%esi

000001f0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1f0:	f3 0f 1e fb          	endbr32 
 1f4:	55                   	push   %ebp
 1f5:	89 e5                	mov    %esp,%ebp
 1f7:	57                   	push   %edi
 1f8:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1fb:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1fe:	8b 45 0c             	mov    0xc(%ebp),%eax
 201:	89 d7                	mov    %edx,%edi
 203:	fc                   	cld    
 204:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 206:	89 d0                	mov    %edx,%eax
 208:	5f                   	pop    %edi
 209:	5d                   	pop    %ebp
 20a:	c3                   	ret    
 20b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 20f:	90                   	nop

00000210 <strchr>:

char*
strchr(const char *s, char c)
{
 210:	f3 0f 1e fb          	endbr32 
 214:	55                   	push   %ebp
 215:	89 e5                	mov    %esp,%ebp
 217:	8b 45 08             	mov    0x8(%ebp),%eax
 21a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 21e:	0f b6 10             	movzbl (%eax),%edx
 221:	84 d2                	test   %dl,%dl
 223:	75 16                	jne    23b <strchr+0x2b>
 225:	eb 21                	jmp    248 <strchr+0x38>
 227:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 22e:	66 90                	xchg   %ax,%ax
 230:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 234:	83 c0 01             	add    $0x1,%eax
 237:	84 d2                	test   %dl,%dl
 239:	74 0d                	je     248 <strchr+0x38>
    if(*s == c)
 23b:	38 d1                	cmp    %dl,%cl
 23d:	75 f1                	jne    230 <strchr+0x20>
      return (char*)s;
  return 0;
}
 23f:	5d                   	pop    %ebp
 240:	c3                   	ret    
 241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 248:	31 c0                	xor    %eax,%eax
}
 24a:	5d                   	pop    %ebp
 24b:	c3                   	ret    
 24c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000250 <gets>:

char*
gets(char *buf, int max)
{
 250:	f3 0f 1e fb          	endbr32 
 254:	55                   	push   %ebp
 255:	89 e5                	mov    %esp,%ebp
 257:	57                   	push   %edi
 258:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 259:	31 f6                	xor    %esi,%esi
{
 25b:	53                   	push   %ebx
 25c:	89 f3                	mov    %esi,%ebx
 25e:	83 ec 1c             	sub    $0x1c,%esp
 261:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 264:	eb 33                	jmp    299 <gets+0x49>
 266:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 26d:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 270:	83 ec 04             	sub    $0x4,%esp
 273:	8d 45 e7             	lea    -0x19(%ebp),%eax
 276:	6a 01                	push   $0x1
 278:	50                   	push   %eax
 279:	6a 00                	push   $0x0
 27b:	e8 2b 01 00 00       	call   3ab <read>
    if(cc < 1)
 280:	83 c4 10             	add    $0x10,%esp
 283:	85 c0                	test   %eax,%eax
 285:	7e 1c                	jle    2a3 <gets+0x53>
      break;
    buf[i++] = c;
 287:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 28b:	83 c7 01             	add    $0x1,%edi
 28e:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 291:	3c 0a                	cmp    $0xa,%al
 293:	74 23                	je     2b8 <gets+0x68>
 295:	3c 0d                	cmp    $0xd,%al
 297:	74 1f                	je     2b8 <gets+0x68>
  for(i=0; i+1 < max; ){
 299:	83 c3 01             	add    $0x1,%ebx
 29c:	89 fe                	mov    %edi,%esi
 29e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 2a1:	7c cd                	jl     270 <gets+0x20>
 2a3:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 2a5:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 2a8:	c6 03 00             	movb   $0x0,(%ebx)
}
 2ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2ae:	5b                   	pop    %ebx
 2af:	5e                   	pop    %esi
 2b0:	5f                   	pop    %edi
 2b1:	5d                   	pop    %ebp
 2b2:	c3                   	ret    
 2b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2b7:	90                   	nop
 2b8:	8b 75 08             	mov    0x8(%ebp),%esi
 2bb:	8b 45 08             	mov    0x8(%ebp),%eax
 2be:	01 de                	add    %ebx,%esi
 2c0:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 2c2:	c6 03 00             	movb   $0x0,(%ebx)
}
 2c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2c8:	5b                   	pop    %ebx
 2c9:	5e                   	pop    %esi
 2ca:	5f                   	pop    %edi
 2cb:	5d                   	pop    %ebp
 2cc:	c3                   	ret    
 2cd:	8d 76 00             	lea    0x0(%esi),%esi

000002d0 <stat>:

int
stat(const char *n, struct stat *st)
{
 2d0:	f3 0f 1e fb          	endbr32 
 2d4:	55                   	push   %ebp
 2d5:	89 e5                	mov    %esp,%ebp
 2d7:	56                   	push   %esi
 2d8:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2d9:	83 ec 08             	sub    $0x8,%esp
 2dc:	6a 00                	push   $0x0
 2de:	ff 75 08             	pushl  0x8(%ebp)
 2e1:	e8 ed 00 00 00       	call   3d3 <open>
  if(fd < 0)
 2e6:	83 c4 10             	add    $0x10,%esp
 2e9:	85 c0                	test   %eax,%eax
 2eb:	78 2b                	js     318 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 2ed:	83 ec 08             	sub    $0x8,%esp
 2f0:	ff 75 0c             	pushl  0xc(%ebp)
 2f3:	89 c3                	mov    %eax,%ebx
 2f5:	50                   	push   %eax
 2f6:	e8 f0 00 00 00       	call   3eb <fstat>
  close(fd);
 2fb:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 2fe:	89 c6                	mov    %eax,%esi
  close(fd);
 300:	e8 b6 00 00 00       	call   3bb <close>
  return r;
 305:	83 c4 10             	add    $0x10,%esp
}
 308:	8d 65 f8             	lea    -0x8(%ebp),%esp
 30b:	89 f0                	mov    %esi,%eax
 30d:	5b                   	pop    %ebx
 30e:	5e                   	pop    %esi
 30f:	5d                   	pop    %ebp
 310:	c3                   	ret    
 311:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 318:	be ff ff ff ff       	mov    $0xffffffff,%esi
 31d:	eb e9                	jmp    308 <stat+0x38>
 31f:	90                   	nop

00000320 <atoi>:

int
atoi(const char *s)
{
 320:	f3 0f 1e fb          	endbr32 
 324:	55                   	push   %ebp
 325:	89 e5                	mov    %esp,%ebp
 327:	53                   	push   %ebx
 328:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 32b:	0f be 02             	movsbl (%edx),%eax
 32e:	8d 48 d0             	lea    -0x30(%eax),%ecx
 331:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 334:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 339:	77 1a                	ja     355 <atoi+0x35>
 33b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 33f:	90                   	nop
    n = n*10 + *s++ - '0';
 340:	83 c2 01             	add    $0x1,%edx
 343:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 346:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 34a:	0f be 02             	movsbl (%edx),%eax
 34d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 350:	80 fb 09             	cmp    $0x9,%bl
 353:	76 eb                	jbe    340 <atoi+0x20>
  return n;
}
 355:	89 c8                	mov    %ecx,%eax
 357:	5b                   	pop    %ebx
 358:	5d                   	pop    %ebp
 359:	c3                   	ret    
 35a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000360 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 360:	f3 0f 1e fb          	endbr32 
 364:	55                   	push   %ebp
 365:	89 e5                	mov    %esp,%ebp
 367:	57                   	push   %edi
 368:	8b 45 10             	mov    0x10(%ebp),%eax
 36b:	8b 55 08             	mov    0x8(%ebp),%edx
 36e:	56                   	push   %esi
 36f:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 372:	85 c0                	test   %eax,%eax
 374:	7e 0f                	jle    385 <memmove+0x25>
 376:	01 d0                	add    %edx,%eax
  dst = vdst;
 378:	89 d7                	mov    %edx,%edi
 37a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
 380:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 381:	39 f8                	cmp    %edi,%eax
 383:	75 fb                	jne    380 <memmove+0x20>
  return vdst;
}
 385:	5e                   	pop    %esi
 386:	89 d0                	mov    %edx,%eax
 388:	5f                   	pop    %edi
 389:	5d                   	pop    %ebp
 38a:	c3                   	ret    

0000038b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 38b:	b8 01 00 00 00       	mov    $0x1,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret    

00000393 <exit>:
SYSCALL(exit)
 393:	b8 02 00 00 00       	mov    $0x2,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret    

0000039b <wait>:
SYSCALL(wait)
 39b:	b8 03 00 00 00       	mov    $0x3,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <pipe>:
SYSCALL(pipe)
 3a3:	b8 04 00 00 00       	mov    $0x4,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <read>:
SYSCALL(read)
 3ab:	b8 05 00 00 00       	mov    $0x5,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <write>:
SYSCALL(write)
 3b3:	b8 10 00 00 00       	mov    $0x10,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    

000003bb <close>:
SYSCALL(close)
 3bb:	b8 15 00 00 00       	mov    $0x15,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <kill>:
SYSCALL(kill)
 3c3:	b8 06 00 00 00       	mov    $0x6,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    

000003cb <exec>:
SYSCALL(exec)
 3cb:	b8 07 00 00 00       	mov    $0x7,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret    

000003d3 <open>:
SYSCALL(open)
 3d3:	b8 0f 00 00 00       	mov    $0xf,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret    

000003db <mknod>:
SYSCALL(mknod)
 3db:	b8 11 00 00 00       	mov    $0x11,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret    

000003e3 <unlink>:
SYSCALL(unlink)
 3e3:	b8 12 00 00 00       	mov    $0x12,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret    

000003eb <fstat>:
SYSCALL(fstat)
 3eb:	b8 08 00 00 00       	mov    $0x8,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret    

000003f3 <link>:
SYSCALL(link)
 3f3:	b8 13 00 00 00       	mov    $0x13,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret    

000003fb <mkdir>:
SYSCALL(mkdir)
 3fb:	b8 14 00 00 00       	mov    $0x14,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret    

00000403 <chdir>:
SYSCALL(chdir)
 403:	b8 09 00 00 00       	mov    $0x9,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret    

0000040b <dup>:
SYSCALL(dup)
 40b:	b8 0a 00 00 00       	mov    $0xa,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret    

00000413 <getpid>:
SYSCALL(getpid)
 413:	b8 0b 00 00 00       	mov    $0xb,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret    

0000041b <sbrk>:
SYSCALL(sbrk)
 41b:	b8 0c 00 00 00       	mov    $0xc,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret    

00000423 <sleep>:
SYSCALL(sleep)
 423:	b8 0d 00 00 00       	mov    $0xd,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret    

0000042b <uptime>:
SYSCALL(uptime)
 42b:	b8 0e 00 00 00       	mov    $0xe,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret    

00000433 <memsize>:
SYSCALL(memsize)
 433:	b8 16 00 00 00       	mov    $0x16,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret    
 43b:	66 90                	xchg   %ax,%ax
 43d:	66 90                	xchg   %ax,%ax
 43f:	90                   	nop

00000440 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 440:	55                   	push   %ebp
 441:	89 e5                	mov    %esp,%ebp
 443:	57                   	push   %edi
 444:	56                   	push   %esi
 445:	53                   	push   %ebx
 446:	83 ec 3c             	sub    $0x3c,%esp
 449:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 44c:	89 d1                	mov    %edx,%ecx
{
 44e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 451:	85 d2                	test   %edx,%edx
 453:	0f 89 7f 00 00 00    	jns    4d8 <printint+0x98>
 459:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 45d:	74 79                	je     4d8 <printint+0x98>
    neg = 1;
 45f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 466:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 468:	31 db                	xor    %ebx,%ebx
 46a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 46d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 470:	89 c8                	mov    %ecx,%eax
 472:	31 d2                	xor    %edx,%edx
 474:	89 cf                	mov    %ecx,%edi
 476:	f7 75 c4             	divl   -0x3c(%ebp)
 479:	0f b6 92 98 08 00 00 	movzbl 0x898(%edx),%edx
 480:	89 45 c0             	mov    %eax,-0x40(%ebp)
 483:	89 d8                	mov    %ebx,%eax
 485:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 488:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 48b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 48e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 491:	76 dd                	jbe    470 <printint+0x30>
  if(neg)
 493:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 496:	85 c9                	test   %ecx,%ecx
 498:	74 0c                	je     4a6 <printint+0x66>
    buf[i++] = '-';
 49a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 49f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 4a1:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 4a6:	8b 7d b8             	mov    -0x48(%ebp),%edi
 4a9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 4ad:	eb 07                	jmp    4b6 <printint+0x76>
 4af:	90                   	nop
 4b0:	0f b6 13             	movzbl (%ebx),%edx
 4b3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 4b6:	83 ec 04             	sub    $0x4,%esp
 4b9:	88 55 d7             	mov    %dl,-0x29(%ebp)
 4bc:	6a 01                	push   $0x1
 4be:	56                   	push   %esi
 4bf:	57                   	push   %edi
 4c0:	e8 ee fe ff ff       	call   3b3 <write>
  while(--i >= 0)
 4c5:	83 c4 10             	add    $0x10,%esp
 4c8:	39 de                	cmp    %ebx,%esi
 4ca:	75 e4                	jne    4b0 <printint+0x70>
    putc(fd, buf[i]);
}
 4cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4cf:	5b                   	pop    %ebx
 4d0:	5e                   	pop    %esi
 4d1:	5f                   	pop    %edi
 4d2:	5d                   	pop    %ebp
 4d3:	c3                   	ret    
 4d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 4d8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 4df:	eb 87                	jmp    468 <printint+0x28>
 4e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4ef:	90                   	nop

000004f0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 4f0:	f3 0f 1e fb          	endbr32 
 4f4:	55                   	push   %ebp
 4f5:	89 e5                	mov    %esp,%ebp
 4f7:	57                   	push   %edi
 4f8:	56                   	push   %esi
 4f9:	53                   	push   %ebx
 4fa:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4fd:	8b 75 0c             	mov    0xc(%ebp),%esi
 500:	0f b6 1e             	movzbl (%esi),%ebx
 503:	84 db                	test   %bl,%bl
 505:	0f 84 b4 00 00 00    	je     5bf <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
 50b:	8d 45 10             	lea    0x10(%ebp),%eax
 50e:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 511:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 514:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 516:	89 45 d0             	mov    %eax,-0x30(%ebp)
 519:	eb 33                	jmp    54e <printf+0x5e>
 51b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 51f:	90                   	nop
 520:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 523:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 528:	83 f8 25             	cmp    $0x25,%eax
 52b:	74 17                	je     544 <printf+0x54>
  write(fd, &c, 1);
 52d:	83 ec 04             	sub    $0x4,%esp
 530:	88 5d e7             	mov    %bl,-0x19(%ebp)
 533:	6a 01                	push   $0x1
 535:	57                   	push   %edi
 536:	ff 75 08             	pushl  0x8(%ebp)
 539:	e8 75 fe ff ff       	call   3b3 <write>
 53e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 541:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 544:	0f b6 1e             	movzbl (%esi),%ebx
 547:	83 c6 01             	add    $0x1,%esi
 54a:	84 db                	test   %bl,%bl
 54c:	74 71                	je     5bf <printf+0xcf>
    c = fmt[i] & 0xff;
 54e:	0f be cb             	movsbl %bl,%ecx
 551:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 554:	85 d2                	test   %edx,%edx
 556:	74 c8                	je     520 <printf+0x30>
      }
    } else if(state == '%'){
 558:	83 fa 25             	cmp    $0x25,%edx
 55b:	75 e7                	jne    544 <printf+0x54>
      if(c == 'd'){
 55d:	83 f8 64             	cmp    $0x64,%eax
 560:	0f 84 9a 00 00 00    	je     600 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 566:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 56c:	83 f9 70             	cmp    $0x70,%ecx
 56f:	74 5f                	je     5d0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 571:	83 f8 73             	cmp    $0x73,%eax
 574:	0f 84 d6 00 00 00    	je     650 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 57a:	83 f8 63             	cmp    $0x63,%eax
 57d:	0f 84 8d 00 00 00    	je     610 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 583:	83 f8 25             	cmp    $0x25,%eax
 586:	0f 84 b4 00 00 00    	je     640 <printf+0x150>
  write(fd, &c, 1);
 58c:	83 ec 04             	sub    $0x4,%esp
 58f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 593:	6a 01                	push   $0x1
 595:	57                   	push   %edi
 596:	ff 75 08             	pushl  0x8(%ebp)
 599:	e8 15 fe ff ff       	call   3b3 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 59e:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 5a1:	83 c4 0c             	add    $0xc,%esp
 5a4:	6a 01                	push   $0x1
 5a6:	83 c6 01             	add    $0x1,%esi
 5a9:	57                   	push   %edi
 5aa:	ff 75 08             	pushl  0x8(%ebp)
 5ad:	e8 01 fe ff ff       	call   3b3 <write>
  for(i = 0; fmt[i]; i++){
 5b2:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 5b6:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5b9:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 5bb:	84 db                	test   %bl,%bl
 5bd:	75 8f                	jne    54e <printf+0x5e>
    }
  }
}
 5bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5c2:	5b                   	pop    %ebx
 5c3:	5e                   	pop    %esi
 5c4:	5f                   	pop    %edi
 5c5:	5d                   	pop    %ebp
 5c6:	c3                   	ret    
 5c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5ce:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 5d0:	83 ec 0c             	sub    $0xc,%esp
 5d3:	b9 10 00 00 00       	mov    $0x10,%ecx
 5d8:	6a 00                	push   $0x0
 5da:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 5dd:	8b 45 08             	mov    0x8(%ebp),%eax
 5e0:	8b 13                	mov    (%ebx),%edx
 5e2:	e8 59 fe ff ff       	call   440 <printint>
        ap++;
 5e7:	89 d8                	mov    %ebx,%eax
 5e9:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5ec:	31 d2                	xor    %edx,%edx
        ap++;
 5ee:	83 c0 04             	add    $0x4,%eax
 5f1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 5f4:	e9 4b ff ff ff       	jmp    544 <printf+0x54>
 5f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 600:	83 ec 0c             	sub    $0xc,%esp
 603:	b9 0a 00 00 00       	mov    $0xa,%ecx
 608:	6a 01                	push   $0x1
 60a:	eb ce                	jmp    5da <printf+0xea>
 60c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 610:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 613:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 616:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 618:	6a 01                	push   $0x1
        ap++;
 61a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 61d:	57                   	push   %edi
 61e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 621:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 624:	e8 8a fd ff ff       	call   3b3 <write>
        ap++;
 629:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 62c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 62f:	31 d2                	xor    %edx,%edx
 631:	e9 0e ff ff ff       	jmp    544 <printf+0x54>
 636:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 63d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 640:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 643:	83 ec 04             	sub    $0x4,%esp
 646:	e9 59 ff ff ff       	jmp    5a4 <printf+0xb4>
 64b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 64f:	90                   	nop
        s = (char*)*ap;
 650:	8b 45 d0             	mov    -0x30(%ebp),%eax
 653:	8b 18                	mov    (%eax),%ebx
        ap++;
 655:	83 c0 04             	add    $0x4,%eax
 658:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 65b:	85 db                	test   %ebx,%ebx
 65d:	74 17                	je     676 <printf+0x186>
        while(*s != 0){
 65f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 662:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 664:	84 c0                	test   %al,%al
 666:	0f 84 d8 fe ff ff    	je     544 <printf+0x54>
 66c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 66f:	89 de                	mov    %ebx,%esi
 671:	8b 5d 08             	mov    0x8(%ebp),%ebx
 674:	eb 1a                	jmp    690 <printf+0x1a0>
          s = "(null)";
 676:	bb 90 08 00 00       	mov    $0x890,%ebx
        while(*s != 0){
 67b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 67e:	b8 28 00 00 00       	mov    $0x28,%eax
 683:	89 de                	mov    %ebx,%esi
 685:	8b 5d 08             	mov    0x8(%ebp),%ebx
 688:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 68f:	90                   	nop
  write(fd, &c, 1);
 690:	83 ec 04             	sub    $0x4,%esp
          s++;
 693:	83 c6 01             	add    $0x1,%esi
 696:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 699:	6a 01                	push   $0x1
 69b:	57                   	push   %edi
 69c:	53                   	push   %ebx
 69d:	e8 11 fd ff ff       	call   3b3 <write>
        while(*s != 0){
 6a2:	0f b6 06             	movzbl (%esi),%eax
 6a5:	83 c4 10             	add    $0x10,%esp
 6a8:	84 c0                	test   %al,%al
 6aa:	75 e4                	jne    690 <printf+0x1a0>
 6ac:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 6af:	31 d2                	xor    %edx,%edx
 6b1:	e9 8e fe ff ff       	jmp    544 <printf+0x54>
 6b6:	66 90                	xchg   %ax,%ax
 6b8:	66 90                	xchg   %ax,%ax
 6ba:	66 90                	xchg   %ax,%ax
 6bc:	66 90                	xchg   %ax,%ax
 6be:	66 90                	xchg   %ax,%ax

000006c0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6c0:	f3 0f 1e fb          	endbr32 
 6c4:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c5:	a1 80 0b 00 00       	mov    0xb80,%eax
{
 6ca:	89 e5                	mov    %esp,%ebp
 6cc:	57                   	push   %edi
 6cd:	56                   	push   %esi
 6ce:	53                   	push   %ebx
 6cf:	8b 5d 08             	mov    0x8(%ebp),%ebx
 6d2:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 6d4:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d7:	39 c8                	cmp    %ecx,%eax
 6d9:	73 15                	jae    6f0 <free+0x30>
 6db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6df:	90                   	nop
 6e0:	39 d1                	cmp    %edx,%ecx
 6e2:	72 14                	jb     6f8 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6e4:	39 d0                	cmp    %edx,%eax
 6e6:	73 10                	jae    6f8 <free+0x38>
{
 6e8:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ea:	8b 10                	mov    (%eax),%edx
 6ec:	39 c8                	cmp    %ecx,%eax
 6ee:	72 f0                	jb     6e0 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6f0:	39 d0                	cmp    %edx,%eax
 6f2:	72 f4                	jb     6e8 <free+0x28>
 6f4:	39 d1                	cmp    %edx,%ecx
 6f6:	73 f0                	jae    6e8 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6f8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6fb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6fe:	39 fa                	cmp    %edi,%edx
 700:	74 1e                	je     720 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 702:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 705:	8b 50 04             	mov    0x4(%eax),%edx
 708:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 70b:	39 f1                	cmp    %esi,%ecx
 70d:	74 28                	je     737 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 70f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 711:	5b                   	pop    %ebx
  freep = p;
 712:	a3 80 0b 00 00       	mov    %eax,0xb80
}
 717:	5e                   	pop    %esi
 718:	5f                   	pop    %edi
 719:	5d                   	pop    %ebp
 71a:	c3                   	ret    
 71b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 71f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 720:	03 72 04             	add    0x4(%edx),%esi
 723:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 726:	8b 10                	mov    (%eax),%edx
 728:	8b 12                	mov    (%edx),%edx
 72a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 72d:	8b 50 04             	mov    0x4(%eax),%edx
 730:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 733:	39 f1                	cmp    %esi,%ecx
 735:	75 d8                	jne    70f <free+0x4f>
    p->s.size += bp->s.size;
 737:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 73a:	a3 80 0b 00 00       	mov    %eax,0xb80
    p->s.size += bp->s.size;
 73f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 742:	8b 53 f8             	mov    -0x8(%ebx),%edx
 745:	89 10                	mov    %edx,(%eax)
}
 747:	5b                   	pop    %ebx
 748:	5e                   	pop    %esi
 749:	5f                   	pop    %edi
 74a:	5d                   	pop    %ebp
 74b:	c3                   	ret    
 74c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000750 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 750:	f3 0f 1e fb          	endbr32 
 754:	55                   	push   %ebp
 755:	89 e5                	mov    %esp,%ebp
 757:	57                   	push   %edi
 758:	56                   	push   %esi
 759:	53                   	push   %ebx
 75a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 75d:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 760:	8b 3d 80 0b 00 00    	mov    0xb80,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 766:	8d 70 07             	lea    0x7(%eax),%esi
 769:	c1 ee 03             	shr    $0x3,%esi
 76c:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 76f:	85 ff                	test   %edi,%edi
 771:	0f 84 a9 00 00 00    	je     820 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 777:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 779:	8b 48 04             	mov    0x4(%eax),%ecx
 77c:	39 f1                	cmp    %esi,%ecx
 77e:	73 6d                	jae    7ed <malloc+0x9d>
 780:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 786:	bb 00 10 00 00       	mov    $0x1000,%ebx
 78b:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 78e:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 795:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 798:	eb 17                	jmp    7b1 <malloc+0x61>
 79a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a0:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 7a2:	8b 4a 04             	mov    0x4(%edx),%ecx
 7a5:	39 f1                	cmp    %esi,%ecx
 7a7:	73 4f                	jae    7f8 <malloc+0xa8>
 7a9:	8b 3d 80 0b 00 00    	mov    0xb80,%edi
 7af:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7b1:	39 c7                	cmp    %eax,%edi
 7b3:	75 eb                	jne    7a0 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 7b5:	83 ec 0c             	sub    $0xc,%esp
 7b8:	ff 75 e4             	pushl  -0x1c(%ebp)
 7bb:	e8 5b fc ff ff       	call   41b <sbrk>
  if(p == (char*)-1)
 7c0:	83 c4 10             	add    $0x10,%esp
 7c3:	83 f8 ff             	cmp    $0xffffffff,%eax
 7c6:	74 1b                	je     7e3 <malloc+0x93>
  hp->s.size = nu;
 7c8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 7cb:	83 ec 0c             	sub    $0xc,%esp
 7ce:	83 c0 08             	add    $0x8,%eax
 7d1:	50                   	push   %eax
 7d2:	e8 e9 fe ff ff       	call   6c0 <free>
  return freep;
 7d7:	a1 80 0b 00 00       	mov    0xb80,%eax
      if((p = morecore(nunits)) == 0)
 7dc:	83 c4 10             	add    $0x10,%esp
 7df:	85 c0                	test   %eax,%eax
 7e1:	75 bd                	jne    7a0 <malloc+0x50>
        return 0;
  }
}
 7e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 7e6:	31 c0                	xor    %eax,%eax
}
 7e8:	5b                   	pop    %ebx
 7e9:	5e                   	pop    %esi
 7ea:	5f                   	pop    %edi
 7eb:	5d                   	pop    %ebp
 7ec:	c3                   	ret    
    if(p->s.size >= nunits){
 7ed:	89 c2                	mov    %eax,%edx
 7ef:	89 f8                	mov    %edi,%eax
 7f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 7f8:	39 ce                	cmp    %ecx,%esi
 7fa:	74 54                	je     850 <malloc+0x100>
        p->s.size -= nunits;
 7fc:	29 f1                	sub    %esi,%ecx
 7fe:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 801:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 804:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 807:	a3 80 0b 00 00       	mov    %eax,0xb80
}
 80c:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 80f:	8d 42 08             	lea    0x8(%edx),%eax
}
 812:	5b                   	pop    %ebx
 813:	5e                   	pop    %esi
 814:	5f                   	pop    %edi
 815:	5d                   	pop    %ebp
 816:	c3                   	ret    
 817:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 81e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 820:	c7 05 80 0b 00 00 84 	movl   $0xb84,0xb80
 827:	0b 00 00 
    base.s.size = 0;
 82a:	bf 84 0b 00 00       	mov    $0xb84,%edi
    base.s.ptr = freep = prevp = &base;
 82f:	c7 05 84 0b 00 00 84 	movl   $0xb84,0xb84
 836:	0b 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 839:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 83b:	c7 05 88 0b 00 00 00 	movl   $0x0,0xb88
 842:	00 00 00 
    if(p->s.size >= nunits){
 845:	e9 36 ff ff ff       	jmp    780 <malloc+0x30>
 84a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 850:	8b 0a                	mov    (%edx),%ecx
 852:	89 08                	mov    %ecx,(%eax)
 854:	eb b1                	jmp    807 <malloc+0xb7>
