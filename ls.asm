
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  close(fd);
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
  11:	56                   	push   %esi
  12:	53                   	push   %ebx
  13:	51                   	push   %ecx
  14:	83 ec 0c             	sub    $0xc,%esp
  17:	8b 01                	mov    (%ecx),%eax
  19:	8b 51 04             	mov    0x4(%ecx),%edx
  int i;

  if(argc < 2){
  1c:	83 f8 01             	cmp    $0x1,%eax
  1f:	7e 2d                	jle    4e <main+0x4e>
  21:	8d 5a 04             	lea    0x4(%edx),%ebx
  24:	8d 34 82             	lea    (%edx,%eax,4),%esi
  27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  2e:	66 90                	xchg   %ax,%ax
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
  30:	83 ec 0c             	sub    $0xc,%esp
  33:	ff 33                	pushl  (%ebx)
  35:	83 c3 04             	add    $0x4,%ebx
  38:	e8 d3 00 00 00       	call   110 <ls>
  for(i=1; i<argc; i++)
  3d:	83 c4 10             	add    $0x10,%esp
  40:	39 f3                	cmp    %esi,%ebx
  42:	75 ec                	jne    30 <main+0x30>
  exit(0);
  44:	83 ec 0c             	sub    $0xc,%esp
  47:	6a 00                	push   $0x0
  49:	e8 65 05 00 00       	call   5b3 <exit>
    ls(".");
  4e:	83 ec 0c             	sub    $0xc,%esp
  51:	68 c0 0a 00 00       	push   $0xac0
  56:	e8 b5 00 00 00       	call   110 <ls>
    exit(0);
  5b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  62:	e8 4c 05 00 00       	call   5b3 <exit>
  67:	66 90                	xchg   %ax,%ax
  69:	66 90                	xchg   %ax,%ax
  6b:	66 90                	xchg   %ax,%ax
  6d:	66 90                	xchg   %ax,%ax
  6f:	90                   	nop

00000070 <fmtname>:
{
  70:	f3 0f 1e fb          	endbr32 
  74:	55                   	push   %ebp
  75:	89 e5                	mov    %esp,%ebp
  77:	56                   	push   %esi
  78:	53                   	push   %ebx
  79:	8b 75 08             	mov    0x8(%ebp),%esi
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  7c:	83 ec 0c             	sub    $0xc,%esp
  7f:	56                   	push   %esi
  80:	e8 4b 03 00 00       	call   3d0 <strlen>
  85:	83 c4 10             	add    $0x10,%esp
  88:	01 f0                	add    %esi,%eax
  8a:	89 c3                	mov    %eax,%ebx
  8c:	73 0b                	jae    99 <fmtname+0x29>
  8e:	eb 0e                	jmp    9e <fmtname+0x2e>
  90:	8d 43 ff             	lea    -0x1(%ebx),%eax
  93:	39 c6                	cmp    %eax,%esi
  95:	77 0a                	ja     a1 <fmtname+0x31>
  97:	89 c3                	mov    %eax,%ebx
  99:	80 3b 2f             	cmpb   $0x2f,(%ebx)
  9c:	75 f2                	jne    90 <fmtname+0x20>
  9e:	83 c3 01             	add    $0x1,%ebx
  if(strlen(p) >= DIRSIZ)
  a1:	83 ec 0c             	sub    $0xc,%esp
  a4:	53                   	push   %ebx
  a5:	e8 26 03 00 00       	call   3d0 <strlen>
  aa:	83 c4 10             	add    $0x10,%esp
  ad:	83 f8 0d             	cmp    $0xd,%eax
  b0:	77 4a                	ja     fc <fmtname+0x8c>
  memmove(buf, p, strlen(p));
  b2:	83 ec 0c             	sub    $0xc,%esp
  b5:	53                   	push   %ebx
  b6:	e8 15 03 00 00       	call   3d0 <strlen>
  bb:	83 c4 0c             	add    $0xc,%esp
  be:	50                   	push   %eax
  bf:	53                   	push   %ebx
  c0:	68 f4 0d 00 00       	push   $0xdf4
  c5:	e8 b6 04 00 00       	call   580 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  ca:	89 1c 24             	mov    %ebx,(%esp)
  cd:	e8 fe 02 00 00       	call   3d0 <strlen>
  d2:	89 1c 24             	mov    %ebx,(%esp)
  return buf;
  d5:	bb f4 0d 00 00       	mov    $0xdf4,%ebx
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  da:	89 c6                	mov    %eax,%esi
  dc:	e8 ef 02 00 00       	call   3d0 <strlen>
  e1:	ba 0e 00 00 00       	mov    $0xe,%edx
  e6:	83 c4 0c             	add    $0xc,%esp
  e9:	29 f2                	sub    %esi,%edx
  eb:	05 f4 0d 00 00       	add    $0xdf4,%eax
  f0:	52                   	push   %edx
  f1:	6a 20                	push   $0x20
  f3:	50                   	push   %eax
  f4:	e8 17 03 00 00       	call   410 <memset>
  return buf;
  f9:	83 c4 10             	add    $0x10,%esp
}
  fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  ff:	89 d8                	mov    %ebx,%eax
 101:	5b                   	pop    %ebx
 102:	5e                   	pop    %esi
 103:	5d                   	pop    %ebp
 104:	c3                   	ret    
 105:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 10c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000110 <ls>:
{
 110:	f3 0f 1e fb          	endbr32 
 114:	55                   	push   %ebp
 115:	89 e5                	mov    %esp,%ebp
 117:	57                   	push   %edi
 118:	56                   	push   %esi
 119:	53                   	push   %ebx
 11a:	81 ec 64 02 00 00    	sub    $0x264,%esp
 120:	8b 7d 08             	mov    0x8(%ebp),%edi
  if((fd = open(path, 0)) < 0){
 123:	6a 00                	push   $0x0
 125:	57                   	push   %edi
 126:	e8 c8 04 00 00       	call   5f3 <open>
 12b:	83 c4 10             	add    $0x10,%esp
 12e:	85 c0                	test   %eax,%eax
 130:	0f 88 9a 01 00 00    	js     2d0 <ls+0x1c0>
  if(fstat(fd, &st) < 0){
 136:	83 ec 08             	sub    $0x8,%esp
 139:	8d b5 d4 fd ff ff    	lea    -0x22c(%ebp),%esi
 13f:	89 c3                	mov    %eax,%ebx
 141:	56                   	push   %esi
 142:	50                   	push   %eax
 143:	e8 c3 04 00 00       	call   60b <fstat>
 148:	83 c4 10             	add    $0x10,%esp
 14b:	85 c0                	test   %eax,%eax
 14d:	0f 88 bd 01 00 00    	js     310 <ls+0x200>
  switch(st.type){
 153:	0f b7 85 d4 fd ff ff 	movzwl -0x22c(%ebp),%eax
 15a:	66 83 f8 01          	cmp    $0x1,%ax
 15e:	74 60                	je     1c0 <ls+0xb0>
 160:	66 83 f8 02          	cmp    $0x2,%ax
 164:	74 1a                	je     180 <ls+0x70>
  close(fd);
 166:	83 ec 0c             	sub    $0xc,%esp
 169:	53                   	push   %ebx
 16a:	e8 6c 04 00 00       	call   5db <close>
 16f:	83 c4 10             	add    $0x10,%esp
}
 172:	8d 65 f4             	lea    -0xc(%ebp),%esp
 175:	5b                   	pop    %ebx
 176:	5e                   	pop    %esi
 177:	5f                   	pop    %edi
 178:	5d                   	pop    %ebp
 179:	c3                   	ret    
 17a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
 180:	83 ec 0c             	sub    $0xc,%esp
 183:	8b 95 e4 fd ff ff    	mov    -0x21c(%ebp),%edx
 189:	8b b5 dc fd ff ff    	mov    -0x224(%ebp),%esi
 18f:	57                   	push   %edi
 190:	89 95 b4 fd ff ff    	mov    %edx,-0x24c(%ebp)
 196:	e8 d5 fe ff ff       	call   70 <fmtname>
 19b:	8b 95 b4 fd ff ff    	mov    -0x24c(%ebp),%edx
 1a1:	59                   	pop    %ecx
 1a2:	5f                   	pop    %edi
 1a3:	52                   	push   %edx
 1a4:	56                   	push   %esi
 1a5:	6a 02                	push   $0x2
 1a7:	50                   	push   %eax
 1a8:	68 a0 0a 00 00       	push   $0xaa0
 1ad:	6a 01                	push   $0x1
 1af:	e8 5c 05 00 00       	call   710 <printf>
    break;
 1b4:	83 c4 20             	add    $0x20,%esp
 1b7:	eb ad                	jmp    166 <ls+0x56>
 1b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 1c0:	83 ec 0c             	sub    $0xc,%esp
 1c3:	57                   	push   %edi
 1c4:	e8 07 02 00 00       	call   3d0 <strlen>
 1c9:	83 c4 10             	add    $0x10,%esp
 1cc:	83 c0 10             	add    $0x10,%eax
 1cf:	3d 00 02 00 00       	cmp    $0x200,%eax
 1d4:	0f 87 16 01 00 00    	ja     2f0 <ls+0x1e0>
    strcpy(buf, path);
 1da:	83 ec 08             	sub    $0x8,%esp
 1dd:	57                   	push   %edi
 1de:	8d bd e8 fd ff ff    	lea    -0x218(%ebp),%edi
 1e4:	57                   	push   %edi
 1e5:	e8 66 01 00 00       	call   350 <strcpy>
    p = buf+strlen(buf);
 1ea:	89 3c 24             	mov    %edi,(%esp)
 1ed:	e8 de 01 00 00       	call   3d0 <strlen>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1f2:	83 c4 10             	add    $0x10,%esp
    p = buf+strlen(buf);
 1f5:	01 f8                	add    %edi,%eax
    *p++ = '/';
 1f7:	8d 48 01             	lea    0x1(%eax),%ecx
    p = buf+strlen(buf);
 1fa:	89 85 a8 fd ff ff    	mov    %eax,-0x258(%ebp)
    *p++ = '/';
 200:	89 8d a4 fd ff ff    	mov    %ecx,-0x25c(%ebp)
 206:	c6 00 2f             	movb   $0x2f,(%eax)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 210:	83 ec 04             	sub    $0x4,%esp
 213:	8d 85 c4 fd ff ff    	lea    -0x23c(%ebp),%eax
 219:	6a 10                	push   $0x10
 21b:	50                   	push   %eax
 21c:	53                   	push   %ebx
 21d:	e8 a9 03 00 00       	call   5cb <read>
 222:	83 c4 10             	add    $0x10,%esp
 225:	83 f8 10             	cmp    $0x10,%eax
 228:	0f 85 38 ff ff ff    	jne    166 <ls+0x56>
      if(de.inum == 0)
 22e:	66 83 bd c4 fd ff ff 	cmpw   $0x0,-0x23c(%ebp)
 235:	00 
 236:	74 d8                	je     210 <ls+0x100>
      memmove(p, de.name, DIRSIZ);
 238:	83 ec 04             	sub    $0x4,%esp
 23b:	8d 85 c6 fd ff ff    	lea    -0x23a(%ebp),%eax
 241:	6a 0e                	push   $0xe
 243:	50                   	push   %eax
 244:	ff b5 a4 fd ff ff    	pushl  -0x25c(%ebp)
 24a:	e8 31 03 00 00       	call   580 <memmove>
      p[DIRSIZ] = 0;
 24f:	8b 85 a8 fd ff ff    	mov    -0x258(%ebp),%eax
 255:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
      if(stat(buf, &st) < 0){
 259:	58                   	pop    %eax
 25a:	5a                   	pop    %edx
 25b:	56                   	push   %esi
 25c:	57                   	push   %edi
 25d:	e8 8e 02 00 00       	call   4f0 <stat>
 262:	83 c4 10             	add    $0x10,%esp
 265:	85 c0                	test   %eax,%eax
 267:	0f 88 cb 00 00 00    	js     338 <ls+0x228>
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 26d:	83 ec 0c             	sub    $0xc,%esp
 270:	8b 8d e4 fd ff ff    	mov    -0x21c(%ebp),%ecx
 276:	8b 95 dc fd ff ff    	mov    -0x224(%ebp),%edx
 27c:	57                   	push   %edi
 27d:	0f bf 85 d4 fd ff ff 	movswl -0x22c(%ebp),%eax
 284:	89 8d ac fd ff ff    	mov    %ecx,-0x254(%ebp)
 28a:	89 95 b0 fd ff ff    	mov    %edx,-0x250(%ebp)
 290:	89 85 b4 fd ff ff    	mov    %eax,-0x24c(%ebp)
 296:	e8 d5 fd ff ff       	call   70 <fmtname>
 29b:	5a                   	pop    %edx
 29c:	8b 95 b0 fd ff ff    	mov    -0x250(%ebp),%edx
 2a2:	59                   	pop    %ecx
 2a3:	8b 8d ac fd ff ff    	mov    -0x254(%ebp),%ecx
 2a9:	51                   	push   %ecx
 2aa:	52                   	push   %edx
 2ab:	ff b5 b4 fd ff ff    	pushl  -0x24c(%ebp)
 2b1:	50                   	push   %eax
 2b2:	68 a0 0a 00 00       	push   $0xaa0
 2b7:	6a 01                	push   $0x1
 2b9:	e8 52 04 00 00       	call   710 <printf>
 2be:	83 c4 20             	add    $0x20,%esp
 2c1:	e9 4a ff ff ff       	jmp    210 <ls+0x100>
 2c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2cd:	8d 76 00             	lea    0x0(%esi),%esi
    printf(2, "ls: cannot open %s\n", path);
 2d0:	83 ec 04             	sub    $0x4,%esp
 2d3:	57                   	push   %edi
 2d4:	68 78 0a 00 00       	push   $0xa78
 2d9:	6a 02                	push   $0x2
 2db:	e8 30 04 00 00       	call   710 <printf>
    return;
 2e0:	83 c4 10             	add    $0x10,%esp
}
 2e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2e6:	5b                   	pop    %ebx
 2e7:	5e                   	pop    %esi
 2e8:	5f                   	pop    %edi
 2e9:	5d                   	pop    %ebp
 2ea:	c3                   	ret    
 2eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2ef:	90                   	nop
      printf(1, "ls: path too long\n");
 2f0:	83 ec 08             	sub    $0x8,%esp
 2f3:	68 ad 0a 00 00       	push   $0xaad
 2f8:	6a 01                	push   $0x1
 2fa:	e8 11 04 00 00       	call   710 <printf>
      break;
 2ff:	83 c4 10             	add    $0x10,%esp
 302:	e9 5f fe ff ff       	jmp    166 <ls+0x56>
 307:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 30e:	66 90                	xchg   %ax,%ax
    printf(2, "ls: cannot stat %s\n", path);
 310:	83 ec 04             	sub    $0x4,%esp
 313:	57                   	push   %edi
 314:	68 8c 0a 00 00       	push   $0xa8c
 319:	6a 02                	push   $0x2
 31b:	e8 f0 03 00 00       	call   710 <printf>
    close(fd);
 320:	89 1c 24             	mov    %ebx,(%esp)
 323:	e8 b3 02 00 00       	call   5db <close>
    return;
 328:	83 c4 10             	add    $0x10,%esp
}
 32b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 32e:	5b                   	pop    %ebx
 32f:	5e                   	pop    %esi
 330:	5f                   	pop    %edi
 331:	5d                   	pop    %ebp
 332:	c3                   	ret    
 333:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 337:	90                   	nop
        printf(1, "ls: cannot stat %s\n", buf);
 338:	83 ec 04             	sub    $0x4,%esp
 33b:	57                   	push   %edi
 33c:	68 8c 0a 00 00       	push   $0xa8c
 341:	6a 01                	push   $0x1
 343:	e8 c8 03 00 00       	call   710 <printf>
        continue;
 348:	83 c4 10             	add    $0x10,%esp
 34b:	e9 c0 fe ff ff       	jmp    210 <ls+0x100>

00000350 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 350:	f3 0f 1e fb          	endbr32 
 354:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 355:	31 c0                	xor    %eax,%eax
{
 357:	89 e5                	mov    %esp,%ebp
 359:	53                   	push   %ebx
 35a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 35d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
 360:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 364:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 367:	83 c0 01             	add    $0x1,%eax
 36a:	84 d2                	test   %dl,%dl
 36c:	75 f2                	jne    360 <strcpy+0x10>
    ;
  return os;
}
 36e:	89 c8                	mov    %ecx,%eax
 370:	5b                   	pop    %ebx
 371:	5d                   	pop    %ebp
 372:	c3                   	ret    
 373:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 37a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000380 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 380:	f3 0f 1e fb          	endbr32 
 384:	55                   	push   %ebp
 385:	89 e5                	mov    %esp,%ebp
 387:	53                   	push   %ebx
 388:	8b 4d 08             	mov    0x8(%ebp),%ecx
 38b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 38e:	0f b6 01             	movzbl (%ecx),%eax
 391:	0f b6 1a             	movzbl (%edx),%ebx
 394:	84 c0                	test   %al,%al
 396:	75 19                	jne    3b1 <strcmp+0x31>
 398:	eb 26                	jmp    3c0 <strcmp+0x40>
 39a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 3a0:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 3a4:	83 c1 01             	add    $0x1,%ecx
 3a7:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 3aa:	0f b6 1a             	movzbl (%edx),%ebx
 3ad:	84 c0                	test   %al,%al
 3af:	74 0f                	je     3c0 <strcmp+0x40>
 3b1:	38 d8                	cmp    %bl,%al
 3b3:	74 eb                	je     3a0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 3b5:	29 d8                	sub    %ebx,%eax
}
 3b7:	5b                   	pop    %ebx
 3b8:	5d                   	pop    %ebp
 3b9:	c3                   	ret    
 3ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 3c0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 3c2:	29 d8                	sub    %ebx,%eax
}
 3c4:	5b                   	pop    %ebx
 3c5:	5d                   	pop    %ebp
 3c6:	c3                   	ret    
 3c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3ce:	66 90                	xchg   %ax,%ax

000003d0 <strlen>:

uint
strlen(const char *s)
{
 3d0:	f3 0f 1e fb          	endbr32 
 3d4:	55                   	push   %ebp
 3d5:	89 e5                	mov    %esp,%ebp
 3d7:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 3da:	80 3a 00             	cmpb   $0x0,(%edx)
 3dd:	74 21                	je     400 <strlen+0x30>
 3df:	31 c0                	xor    %eax,%eax
 3e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3e8:	83 c0 01             	add    $0x1,%eax
 3eb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 3ef:	89 c1                	mov    %eax,%ecx
 3f1:	75 f5                	jne    3e8 <strlen+0x18>
    ;
  return n;
}
 3f3:	89 c8                	mov    %ecx,%eax
 3f5:	5d                   	pop    %ebp
 3f6:	c3                   	ret    
 3f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3fe:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
 400:	31 c9                	xor    %ecx,%ecx
}
 402:	5d                   	pop    %ebp
 403:	89 c8                	mov    %ecx,%eax
 405:	c3                   	ret    
 406:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 40d:	8d 76 00             	lea    0x0(%esi),%esi

00000410 <memset>:

void*
memset(void *dst, int c, uint n)
{
 410:	f3 0f 1e fb          	endbr32 
 414:	55                   	push   %ebp
 415:	89 e5                	mov    %esp,%ebp
 417:	57                   	push   %edi
 418:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 41b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 41e:	8b 45 0c             	mov    0xc(%ebp),%eax
 421:	89 d7                	mov    %edx,%edi
 423:	fc                   	cld    
 424:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 426:	89 d0                	mov    %edx,%eax
 428:	5f                   	pop    %edi
 429:	5d                   	pop    %ebp
 42a:	c3                   	ret    
 42b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 42f:	90                   	nop

00000430 <strchr>:

char*
strchr(const char *s, char c)
{
 430:	f3 0f 1e fb          	endbr32 
 434:	55                   	push   %ebp
 435:	89 e5                	mov    %esp,%ebp
 437:	8b 45 08             	mov    0x8(%ebp),%eax
 43a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 43e:	0f b6 10             	movzbl (%eax),%edx
 441:	84 d2                	test   %dl,%dl
 443:	75 16                	jne    45b <strchr+0x2b>
 445:	eb 21                	jmp    468 <strchr+0x38>
 447:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 44e:	66 90                	xchg   %ax,%ax
 450:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 454:	83 c0 01             	add    $0x1,%eax
 457:	84 d2                	test   %dl,%dl
 459:	74 0d                	je     468 <strchr+0x38>
    if(*s == c)
 45b:	38 d1                	cmp    %dl,%cl
 45d:	75 f1                	jne    450 <strchr+0x20>
      return (char*)s;
  return 0;
}
 45f:	5d                   	pop    %ebp
 460:	c3                   	ret    
 461:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 468:	31 c0                	xor    %eax,%eax
}
 46a:	5d                   	pop    %ebp
 46b:	c3                   	ret    
 46c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000470 <gets>:

char*
gets(char *buf, int max)
{
 470:	f3 0f 1e fb          	endbr32 
 474:	55                   	push   %ebp
 475:	89 e5                	mov    %esp,%ebp
 477:	57                   	push   %edi
 478:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 479:	31 f6                	xor    %esi,%esi
{
 47b:	53                   	push   %ebx
 47c:	89 f3                	mov    %esi,%ebx
 47e:	83 ec 1c             	sub    $0x1c,%esp
 481:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 484:	eb 33                	jmp    4b9 <gets+0x49>
 486:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 48d:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 490:	83 ec 04             	sub    $0x4,%esp
 493:	8d 45 e7             	lea    -0x19(%ebp),%eax
 496:	6a 01                	push   $0x1
 498:	50                   	push   %eax
 499:	6a 00                	push   $0x0
 49b:	e8 2b 01 00 00       	call   5cb <read>
    if(cc < 1)
 4a0:	83 c4 10             	add    $0x10,%esp
 4a3:	85 c0                	test   %eax,%eax
 4a5:	7e 1c                	jle    4c3 <gets+0x53>
      break;
    buf[i++] = c;
 4a7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 4ab:	83 c7 01             	add    $0x1,%edi
 4ae:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 4b1:	3c 0a                	cmp    $0xa,%al
 4b3:	74 23                	je     4d8 <gets+0x68>
 4b5:	3c 0d                	cmp    $0xd,%al
 4b7:	74 1f                	je     4d8 <gets+0x68>
  for(i=0; i+1 < max; ){
 4b9:	83 c3 01             	add    $0x1,%ebx
 4bc:	89 fe                	mov    %edi,%esi
 4be:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 4c1:	7c cd                	jl     490 <gets+0x20>
 4c3:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 4c5:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 4c8:	c6 03 00             	movb   $0x0,(%ebx)
}
 4cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4ce:	5b                   	pop    %ebx
 4cf:	5e                   	pop    %esi
 4d0:	5f                   	pop    %edi
 4d1:	5d                   	pop    %ebp
 4d2:	c3                   	ret    
 4d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4d7:	90                   	nop
 4d8:	8b 75 08             	mov    0x8(%ebp),%esi
 4db:	8b 45 08             	mov    0x8(%ebp),%eax
 4de:	01 de                	add    %ebx,%esi
 4e0:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 4e2:	c6 03 00             	movb   $0x0,(%ebx)
}
 4e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4e8:	5b                   	pop    %ebx
 4e9:	5e                   	pop    %esi
 4ea:	5f                   	pop    %edi
 4eb:	5d                   	pop    %ebp
 4ec:	c3                   	ret    
 4ed:	8d 76 00             	lea    0x0(%esi),%esi

000004f0 <stat>:

int
stat(const char *n, struct stat *st)
{
 4f0:	f3 0f 1e fb          	endbr32 
 4f4:	55                   	push   %ebp
 4f5:	89 e5                	mov    %esp,%ebp
 4f7:	56                   	push   %esi
 4f8:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4f9:	83 ec 08             	sub    $0x8,%esp
 4fc:	6a 00                	push   $0x0
 4fe:	ff 75 08             	pushl  0x8(%ebp)
 501:	e8 ed 00 00 00       	call   5f3 <open>
  if(fd < 0)
 506:	83 c4 10             	add    $0x10,%esp
 509:	85 c0                	test   %eax,%eax
 50b:	78 2b                	js     538 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 50d:	83 ec 08             	sub    $0x8,%esp
 510:	ff 75 0c             	pushl  0xc(%ebp)
 513:	89 c3                	mov    %eax,%ebx
 515:	50                   	push   %eax
 516:	e8 f0 00 00 00       	call   60b <fstat>
  close(fd);
 51b:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 51e:	89 c6                	mov    %eax,%esi
  close(fd);
 520:	e8 b6 00 00 00       	call   5db <close>
  return r;
 525:	83 c4 10             	add    $0x10,%esp
}
 528:	8d 65 f8             	lea    -0x8(%ebp),%esp
 52b:	89 f0                	mov    %esi,%eax
 52d:	5b                   	pop    %ebx
 52e:	5e                   	pop    %esi
 52f:	5d                   	pop    %ebp
 530:	c3                   	ret    
 531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 538:	be ff ff ff ff       	mov    $0xffffffff,%esi
 53d:	eb e9                	jmp    528 <stat+0x38>
 53f:	90                   	nop

00000540 <atoi>:

int
atoi(const char *s)
{
 540:	f3 0f 1e fb          	endbr32 
 544:	55                   	push   %ebp
 545:	89 e5                	mov    %esp,%ebp
 547:	53                   	push   %ebx
 548:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 54b:	0f be 02             	movsbl (%edx),%eax
 54e:	8d 48 d0             	lea    -0x30(%eax),%ecx
 551:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 554:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 559:	77 1a                	ja     575 <atoi+0x35>
 55b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 55f:	90                   	nop
    n = n*10 + *s++ - '0';
 560:	83 c2 01             	add    $0x1,%edx
 563:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 566:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 56a:	0f be 02             	movsbl (%edx),%eax
 56d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 570:	80 fb 09             	cmp    $0x9,%bl
 573:	76 eb                	jbe    560 <atoi+0x20>
  return n;
}
 575:	89 c8                	mov    %ecx,%eax
 577:	5b                   	pop    %ebx
 578:	5d                   	pop    %ebp
 579:	c3                   	ret    
 57a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000580 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 580:	f3 0f 1e fb          	endbr32 
 584:	55                   	push   %ebp
 585:	89 e5                	mov    %esp,%ebp
 587:	57                   	push   %edi
 588:	8b 45 10             	mov    0x10(%ebp),%eax
 58b:	8b 55 08             	mov    0x8(%ebp),%edx
 58e:	56                   	push   %esi
 58f:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 592:	85 c0                	test   %eax,%eax
 594:	7e 0f                	jle    5a5 <memmove+0x25>
 596:	01 d0                	add    %edx,%eax
  dst = vdst;
 598:	89 d7                	mov    %edx,%edi
 59a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
 5a0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 5a1:	39 f8                	cmp    %edi,%eax
 5a3:	75 fb                	jne    5a0 <memmove+0x20>
  return vdst;
}
 5a5:	5e                   	pop    %esi
 5a6:	89 d0                	mov    %edx,%eax
 5a8:	5f                   	pop    %edi
 5a9:	5d                   	pop    %ebp
 5aa:	c3                   	ret    

000005ab <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5ab:	b8 01 00 00 00       	mov    $0x1,%eax
 5b0:	cd 40                	int    $0x40
 5b2:	c3                   	ret    

000005b3 <exit>:
SYSCALL(exit)
 5b3:	b8 02 00 00 00       	mov    $0x2,%eax
 5b8:	cd 40                	int    $0x40
 5ba:	c3                   	ret    

000005bb <wait>:
SYSCALL(wait)
 5bb:	b8 03 00 00 00       	mov    $0x3,%eax
 5c0:	cd 40                	int    $0x40
 5c2:	c3                   	ret    

000005c3 <pipe>:
SYSCALL(pipe)
 5c3:	b8 04 00 00 00       	mov    $0x4,%eax
 5c8:	cd 40                	int    $0x40
 5ca:	c3                   	ret    

000005cb <read>:
SYSCALL(read)
 5cb:	b8 05 00 00 00       	mov    $0x5,%eax
 5d0:	cd 40                	int    $0x40
 5d2:	c3                   	ret    

000005d3 <write>:
SYSCALL(write)
 5d3:	b8 10 00 00 00       	mov    $0x10,%eax
 5d8:	cd 40                	int    $0x40
 5da:	c3                   	ret    

000005db <close>:
SYSCALL(close)
 5db:	b8 15 00 00 00       	mov    $0x15,%eax
 5e0:	cd 40                	int    $0x40
 5e2:	c3                   	ret    

000005e3 <kill>:
SYSCALL(kill)
 5e3:	b8 06 00 00 00       	mov    $0x6,%eax
 5e8:	cd 40                	int    $0x40
 5ea:	c3                   	ret    

000005eb <exec>:
SYSCALL(exec)
 5eb:	b8 07 00 00 00       	mov    $0x7,%eax
 5f0:	cd 40                	int    $0x40
 5f2:	c3                   	ret    

000005f3 <open>:
SYSCALL(open)
 5f3:	b8 0f 00 00 00       	mov    $0xf,%eax
 5f8:	cd 40                	int    $0x40
 5fa:	c3                   	ret    

000005fb <mknod>:
SYSCALL(mknod)
 5fb:	b8 11 00 00 00       	mov    $0x11,%eax
 600:	cd 40                	int    $0x40
 602:	c3                   	ret    

00000603 <unlink>:
SYSCALL(unlink)
 603:	b8 12 00 00 00       	mov    $0x12,%eax
 608:	cd 40                	int    $0x40
 60a:	c3                   	ret    

0000060b <fstat>:
SYSCALL(fstat)
 60b:	b8 08 00 00 00       	mov    $0x8,%eax
 610:	cd 40                	int    $0x40
 612:	c3                   	ret    

00000613 <link>:
SYSCALL(link)
 613:	b8 13 00 00 00       	mov    $0x13,%eax
 618:	cd 40                	int    $0x40
 61a:	c3                   	ret    

0000061b <mkdir>:
SYSCALL(mkdir)
 61b:	b8 14 00 00 00       	mov    $0x14,%eax
 620:	cd 40                	int    $0x40
 622:	c3                   	ret    

00000623 <chdir>:
SYSCALL(chdir)
 623:	b8 09 00 00 00       	mov    $0x9,%eax
 628:	cd 40                	int    $0x40
 62a:	c3                   	ret    

0000062b <dup>:
SYSCALL(dup)
 62b:	b8 0a 00 00 00       	mov    $0xa,%eax
 630:	cd 40                	int    $0x40
 632:	c3                   	ret    

00000633 <getpid>:
SYSCALL(getpid)
 633:	b8 0b 00 00 00       	mov    $0xb,%eax
 638:	cd 40                	int    $0x40
 63a:	c3                   	ret    

0000063b <sbrk>:
SYSCALL(sbrk)
 63b:	b8 0c 00 00 00       	mov    $0xc,%eax
 640:	cd 40                	int    $0x40
 642:	c3                   	ret    

00000643 <sleep>:
SYSCALL(sleep)
 643:	b8 0d 00 00 00       	mov    $0xd,%eax
 648:	cd 40                	int    $0x40
 64a:	c3                   	ret    

0000064b <uptime>:
SYSCALL(uptime)
 64b:	b8 0e 00 00 00       	mov    $0xe,%eax
 650:	cd 40                	int    $0x40
 652:	c3                   	ret    

00000653 <memsize>:
SYSCALL(memsize)
 653:	b8 16 00 00 00       	mov    $0x16,%eax
 658:	cd 40                	int    $0x40
 65a:	c3                   	ret    
 65b:	66 90                	xchg   %ax,%ax
 65d:	66 90                	xchg   %ax,%ax
 65f:	90                   	nop

00000660 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 660:	55                   	push   %ebp
 661:	89 e5                	mov    %esp,%ebp
 663:	57                   	push   %edi
 664:	56                   	push   %esi
 665:	53                   	push   %ebx
 666:	83 ec 3c             	sub    $0x3c,%esp
 669:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 66c:	89 d1                	mov    %edx,%ecx
{
 66e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 671:	85 d2                	test   %edx,%edx
 673:	0f 89 7f 00 00 00    	jns    6f8 <printint+0x98>
 679:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 67d:	74 79                	je     6f8 <printint+0x98>
    neg = 1;
 67f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 686:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 688:	31 db                	xor    %ebx,%ebx
 68a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 68d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 690:	89 c8                	mov    %ecx,%eax
 692:	31 d2                	xor    %edx,%edx
 694:	89 cf                	mov    %ecx,%edi
 696:	f7 75 c4             	divl   -0x3c(%ebp)
 699:	0f b6 92 cc 0a 00 00 	movzbl 0xacc(%edx),%edx
 6a0:	89 45 c0             	mov    %eax,-0x40(%ebp)
 6a3:	89 d8                	mov    %ebx,%eax
 6a5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 6a8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 6ab:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 6ae:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 6b1:	76 dd                	jbe    690 <printint+0x30>
  if(neg)
 6b3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 6b6:	85 c9                	test   %ecx,%ecx
 6b8:	74 0c                	je     6c6 <printint+0x66>
    buf[i++] = '-';
 6ba:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 6bf:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 6c1:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 6c6:	8b 7d b8             	mov    -0x48(%ebp),%edi
 6c9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 6cd:	eb 07                	jmp    6d6 <printint+0x76>
 6cf:	90                   	nop
 6d0:	0f b6 13             	movzbl (%ebx),%edx
 6d3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 6d6:	83 ec 04             	sub    $0x4,%esp
 6d9:	88 55 d7             	mov    %dl,-0x29(%ebp)
 6dc:	6a 01                	push   $0x1
 6de:	56                   	push   %esi
 6df:	57                   	push   %edi
 6e0:	e8 ee fe ff ff       	call   5d3 <write>
  while(--i >= 0)
 6e5:	83 c4 10             	add    $0x10,%esp
 6e8:	39 de                	cmp    %ebx,%esi
 6ea:	75 e4                	jne    6d0 <printint+0x70>
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
 6f8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 6ff:	eb 87                	jmp    688 <printint+0x28>
 701:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 708:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 70f:	90                   	nop

00000710 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 710:	f3 0f 1e fb          	endbr32 
 714:	55                   	push   %ebp
 715:	89 e5                	mov    %esp,%ebp
 717:	57                   	push   %edi
 718:	56                   	push   %esi
 719:	53                   	push   %ebx
 71a:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 71d:	8b 75 0c             	mov    0xc(%ebp),%esi
 720:	0f b6 1e             	movzbl (%esi),%ebx
 723:	84 db                	test   %bl,%bl
 725:	0f 84 b4 00 00 00    	je     7df <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
 72b:	8d 45 10             	lea    0x10(%ebp),%eax
 72e:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 731:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 734:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 736:	89 45 d0             	mov    %eax,-0x30(%ebp)
 739:	eb 33                	jmp    76e <printf+0x5e>
 73b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 73f:	90                   	nop
 740:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 743:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 748:	83 f8 25             	cmp    $0x25,%eax
 74b:	74 17                	je     764 <printf+0x54>
  write(fd, &c, 1);
 74d:	83 ec 04             	sub    $0x4,%esp
 750:	88 5d e7             	mov    %bl,-0x19(%ebp)
 753:	6a 01                	push   $0x1
 755:	57                   	push   %edi
 756:	ff 75 08             	pushl  0x8(%ebp)
 759:	e8 75 fe ff ff       	call   5d3 <write>
 75e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 761:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 764:	0f b6 1e             	movzbl (%esi),%ebx
 767:	83 c6 01             	add    $0x1,%esi
 76a:	84 db                	test   %bl,%bl
 76c:	74 71                	je     7df <printf+0xcf>
    c = fmt[i] & 0xff;
 76e:	0f be cb             	movsbl %bl,%ecx
 771:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 774:	85 d2                	test   %edx,%edx
 776:	74 c8                	je     740 <printf+0x30>
      }
    } else if(state == '%'){
 778:	83 fa 25             	cmp    $0x25,%edx
 77b:	75 e7                	jne    764 <printf+0x54>
      if(c == 'd'){
 77d:	83 f8 64             	cmp    $0x64,%eax
 780:	0f 84 9a 00 00 00    	je     820 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 786:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 78c:	83 f9 70             	cmp    $0x70,%ecx
 78f:	74 5f                	je     7f0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 791:	83 f8 73             	cmp    $0x73,%eax
 794:	0f 84 d6 00 00 00    	je     870 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 79a:	83 f8 63             	cmp    $0x63,%eax
 79d:	0f 84 8d 00 00 00    	je     830 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 7a3:	83 f8 25             	cmp    $0x25,%eax
 7a6:	0f 84 b4 00 00 00    	je     860 <printf+0x150>
  write(fd, &c, 1);
 7ac:	83 ec 04             	sub    $0x4,%esp
 7af:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 7b3:	6a 01                	push   $0x1
 7b5:	57                   	push   %edi
 7b6:	ff 75 08             	pushl  0x8(%ebp)
 7b9:	e8 15 fe ff ff       	call   5d3 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 7be:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 7c1:	83 c4 0c             	add    $0xc,%esp
 7c4:	6a 01                	push   $0x1
 7c6:	83 c6 01             	add    $0x1,%esi
 7c9:	57                   	push   %edi
 7ca:	ff 75 08             	pushl  0x8(%ebp)
 7cd:	e8 01 fe ff ff       	call   5d3 <write>
  for(i = 0; fmt[i]; i++){
 7d2:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 7d6:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 7d9:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 7db:	84 db                	test   %bl,%bl
 7dd:	75 8f                	jne    76e <printf+0x5e>
    }
  }
}
 7df:	8d 65 f4             	lea    -0xc(%ebp),%esp
 7e2:	5b                   	pop    %ebx
 7e3:	5e                   	pop    %esi
 7e4:	5f                   	pop    %edi
 7e5:	5d                   	pop    %ebp
 7e6:	c3                   	ret    
 7e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7ee:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 7f0:	83 ec 0c             	sub    $0xc,%esp
 7f3:	b9 10 00 00 00       	mov    $0x10,%ecx
 7f8:	6a 00                	push   $0x0
 7fa:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 7fd:	8b 45 08             	mov    0x8(%ebp),%eax
 800:	8b 13                	mov    (%ebx),%edx
 802:	e8 59 fe ff ff       	call   660 <printint>
        ap++;
 807:	89 d8                	mov    %ebx,%eax
 809:	83 c4 10             	add    $0x10,%esp
      state = 0;
 80c:	31 d2                	xor    %edx,%edx
        ap++;
 80e:	83 c0 04             	add    $0x4,%eax
 811:	89 45 d0             	mov    %eax,-0x30(%ebp)
 814:	e9 4b ff ff ff       	jmp    764 <printf+0x54>
 819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 820:	83 ec 0c             	sub    $0xc,%esp
 823:	b9 0a 00 00 00       	mov    $0xa,%ecx
 828:	6a 01                	push   $0x1
 82a:	eb ce                	jmp    7fa <printf+0xea>
 82c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 830:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 833:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 836:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 838:	6a 01                	push   $0x1
        ap++;
 83a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 83d:	57                   	push   %edi
 83e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 841:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 844:	e8 8a fd ff ff       	call   5d3 <write>
        ap++;
 849:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 84c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 84f:	31 d2                	xor    %edx,%edx
 851:	e9 0e ff ff ff       	jmp    764 <printf+0x54>
 856:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 85d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 860:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 863:	83 ec 04             	sub    $0x4,%esp
 866:	e9 59 ff ff ff       	jmp    7c4 <printf+0xb4>
 86b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 86f:	90                   	nop
        s = (char*)*ap;
 870:	8b 45 d0             	mov    -0x30(%ebp),%eax
 873:	8b 18                	mov    (%eax),%ebx
        ap++;
 875:	83 c0 04             	add    $0x4,%eax
 878:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 87b:	85 db                	test   %ebx,%ebx
 87d:	74 17                	je     896 <printf+0x186>
        while(*s != 0){
 87f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 882:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 884:	84 c0                	test   %al,%al
 886:	0f 84 d8 fe ff ff    	je     764 <printf+0x54>
 88c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 88f:	89 de                	mov    %ebx,%esi
 891:	8b 5d 08             	mov    0x8(%ebp),%ebx
 894:	eb 1a                	jmp    8b0 <printf+0x1a0>
          s = "(null)";
 896:	bb c2 0a 00 00       	mov    $0xac2,%ebx
        while(*s != 0){
 89b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 89e:	b8 28 00 00 00       	mov    $0x28,%eax
 8a3:	89 de                	mov    %ebx,%esi
 8a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
 8a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8af:	90                   	nop
  write(fd, &c, 1);
 8b0:	83 ec 04             	sub    $0x4,%esp
          s++;
 8b3:	83 c6 01             	add    $0x1,%esi
 8b6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 8b9:	6a 01                	push   $0x1
 8bb:	57                   	push   %edi
 8bc:	53                   	push   %ebx
 8bd:	e8 11 fd ff ff       	call   5d3 <write>
        while(*s != 0){
 8c2:	0f b6 06             	movzbl (%esi),%eax
 8c5:	83 c4 10             	add    $0x10,%esp
 8c8:	84 c0                	test   %al,%al
 8ca:	75 e4                	jne    8b0 <printf+0x1a0>
 8cc:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 8cf:	31 d2                	xor    %edx,%edx
 8d1:	e9 8e fe ff ff       	jmp    764 <printf+0x54>
 8d6:	66 90                	xchg   %ax,%ax
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
 8e0:	f3 0f 1e fb          	endbr32 
 8e4:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8e5:	a1 04 0e 00 00       	mov    0xe04,%eax
{
 8ea:	89 e5                	mov    %esp,%ebp
 8ec:	57                   	push   %edi
 8ed:	56                   	push   %esi
 8ee:	53                   	push   %ebx
 8ef:	8b 5d 08             	mov    0x8(%ebp),%ebx
 8f2:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 8f4:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8f7:	39 c8                	cmp    %ecx,%eax
 8f9:	73 15                	jae    910 <free+0x30>
 8fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 8ff:	90                   	nop
 900:	39 d1                	cmp    %edx,%ecx
 902:	72 14                	jb     918 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 904:	39 d0                	cmp    %edx,%eax
 906:	73 10                	jae    918 <free+0x38>
{
 908:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 90a:	8b 10                	mov    (%eax),%edx
 90c:	39 c8                	cmp    %ecx,%eax
 90e:	72 f0                	jb     900 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 910:	39 d0                	cmp    %edx,%eax
 912:	72 f4                	jb     908 <free+0x28>
 914:	39 d1                	cmp    %edx,%ecx
 916:	73 f0                	jae    908 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 918:	8b 73 fc             	mov    -0x4(%ebx),%esi
 91b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 91e:	39 fa                	cmp    %edi,%edx
 920:	74 1e                	je     940 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 922:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 925:	8b 50 04             	mov    0x4(%eax),%edx
 928:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 92b:	39 f1                	cmp    %esi,%ecx
 92d:	74 28                	je     957 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 92f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 931:	5b                   	pop    %ebx
  freep = p;
 932:	a3 04 0e 00 00       	mov    %eax,0xe04
}
 937:	5e                   	pop    %esi
 938:	5f                   	pop    %edi
 939:	5d                   	pop    %ebp
 93a:	c3                   	ret    
 93b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 93f:	90                   	nop
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
 955:	75 d8                	jne    92f <free+0x4f>
    p->s.size += bp->s.size;
 957:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 95a:	a3 04 0e 00 00       	mov    %eax,0xe04
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
 970:	f3 0f 1e fb          	endbr32 
 974:	55                   	push   %ebp
 975:	89 e5                	mov    %esp,%ebp
 977:	57                   	push   %edi
 978:	56                   	push   %esi
 979:	53                   	push   %ebx
 97a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 97d:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 980:	8b 3d 04 0e 00 00    	mov    0xe04,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 986:	8d 70 07             	lea    0x7(%eax),%esi
 989:	c1 ee 03             	shr    $0x3,%esi
 98c:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 98f:	85 ff                	test   %edi,%edi
 991:	0f 84 a9 00 00 00    	je     a40 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 997:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 999:	8b 48 04             	mov    0x4(%eax),%ecx
 99c:	39 f1                	cmp    %esi,%ecx
 99e:	73 6d                	jae    a0d <malloc+0x9d>
 9a0:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 9a6:	bb 00 10 00 00       	mov    $0x1000,%ebx
 9ab:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 9ae:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 9b5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 9b8:	eb 17                	jmp    9d1 <malloc+0x61>
 9ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9c0:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 9c2:	8b 4a 04             	mov    0x4(%edx),%ecx
 9c5:	39 f1                	cmp    %esi,%ecx
 9c7:	73 4f                	jae    a18 <malloc+0xa8>
 9c9:	8b 3d 04 0e 00 00    	mov    0xe04,%edi
 9cf:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9d1:	39 c7                	cmp    %eax,%edi
 9d3:	75 eb                	jne    9c0 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 9d5:	83 ec 0c             	sub    $0xc,%esp
 9d8:	ff 75 e4             	pushl  -0x1c(%ebp)
 9db:	e8 5b fc ff ff       	call   63b <sbrk>
  if(p == (char*)-1)
 9e0:	83 c4 10             	add    $0x10,%esp
 9e3:	83 f8 ff             	cmp    $0xffffffff,%eax
 9e6:	74 1b                	je     a03 <malloc+0x93>
  hp->s.size = nu;
 9e8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 9eb:	83 ec 0c             	sub    $0xc,%esp
 9ee:	83 c0 08             	add    $0x8,%eax
 9f1:	50                   	push   %eax
 9f2:	e8 e9 fe ff ff       	call   8e0 <free>
  return freep;
 9f7:	a1 04 0e 00 00       	mov    0xe04,%eax
      if((p = morecore(nunits)) == 0)
 9fc:	83 c4 10             	add    $0x10,%esp
 9ff:	85 c0                	test   %eax,%eax
 a01:	75 bd                	jne    9c0 <malloc+0x50>
        return 0;
  }
}
 a03:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 a06:	31 c0                	xor    %eax,%eax
}
 a08:	5b                   	pop    %ebx
 a09:	5e                   	pop    %esi
 a0a:	5f                   	pop    %edi
 a0b:	5d                   	pop    %ebp
 a0c:	c3                   	ret    
    if(p->s.size >= nunits){
 a0d:	89 c2                	mov    %eax,%edx
 a0f:	89 f8                	mov    %edi,%eax
 a11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 a18:	39 ce                	cmp    %ecx,%esi
 a1a:	74 54                	je     a70 <malloc+0x100>
        p->s.size -= nunits;
 a1c:	29 f1                	sub    %esi,%ecx
 a1e:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 a21:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 a24:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 a27:	a3 04 0e 00 00       	mov    %eax,0xe04
}
 a2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 a2f:	8d 42 08             	lea    0x8(%edx),%eax
}
 a32:	5b                   	pop    %ebx
 a33:	5e                   	pop    %esi
 a34:	5f                   	pop    %edi
 a35:	5d                   	pop    %ebp
 a36:	c3                   	ret    
 a37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a3e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 a40:	c7 05 04 0e 00 00 08 	movl   $0xe08,0xe04
 a47:	0e 00 00 
    base.s.size = 0;
 a4a:	bf 08 0e 00 00       	mov    $0xe08,%edi
    base.s.ptr = freep = prevp = &base;
 a4f:	c7 05 08 0e 00 00 08 	movl   $0xe08,0xe08
 a56:	0e 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a59:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 a5b:	c7 05 0c 0e 00 00 00 	movl   $0x0,0xe0c
 a62:	00 00 00 
    if(p->s.size >= nunits){
 a65:	e9 36 ff ff ff       	jmp    9a0 <malloc+0x30>
 a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 a70:	8b 0a                	mov    (%edx),%ecx
 a72:	89 08                	mov    %ecx,(%eax)
 a74:	eb b1                	jmp    a27 <malloc+0xb7>
