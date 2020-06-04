
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 c5 10 80       	mov    $0x8010c5d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 80 37 10 80       	mov    $0x80103780,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	f3 0f 1e fb          	endbr32 
80100044:	55                   	push   %ebp
80100045:	89 e5                	mov    %esp,%ebp
80100047:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100048:	bb 14 c6 10 80       	mov    $0x8010c614,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 60 80 10 80       	push   $0x80108060
80100055:	68 e0 c5 10 80       	push   $0x8010c5e0
8010005a:	e8 51 4d 00 00       	call   80104db0 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 dc 0c 11 80       	mov    $0x80110cdc,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 2c 0d 11 80 dc 	movl   $0x80110cdc,0x80110d2c
8010006e:	0c 11 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 30 0d 11 80 dc 	movl   $0x80110cdc,0x80110d30
80100078:	0c 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010007b:	eb 05                	jmp    80100082 <binit+0x42>
8010007d:	8d 76 00             	lea    0x0(%esi),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 dc 0c 11 80 	movl   $0x80110cdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 67 80 10 80       	push   $0x80108067
80100097:	50                   	push   %eax
80100098:	e8 d3 4b 00 00       	call   80104c70 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 30 0d 11 80       	mov    0x80110d30,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 30 0d 11 80    	mov    %ebx,0x80110d30
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb 80 0a 11 80    	cmp    $0x80110a80,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	f3 0f 1e fb          	endbr32 
801000d4:	55                   	push   %ebp
801000d5:	89 e5                	mov    %esp,%ebp
801000d7:	57                   	push   %edi
801000d8:	56                   	push   %esi
801000d9:	53                   	push   %ebx
801000da:	83 ec 18             	sub    $0x18,%esp
801000dd:	8b 7d 08             	mov    0x8(%ebp),%edi
801000e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&bcache.lock);
801000e3:	68 e0 c5 10 80       	push   $0x8010c5e0
801000e8:	e8 43 4e 00 00       	call   80104f30 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 30 0d 11 80    	mov    0x80110d30,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 7b 04             	cmp    0x4(%ebx),%edi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 73 08             	cmp    0x8(%ebx),%esi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 2c 0d 11 80    	mov    0x80110d2c,%ebx
80100126:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
80100139:	74 65                	je     801001a0 <bread+0xd0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 7b 04             	mov    %edi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 73 08             	mov    %esi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 e0 c5 10 80       	push   $0x8010c5e0
80100162:	e8 89 4e 00 00       	call   80104ff0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 3e 4b 00 00       	call   80104cb0 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 2f 28 00 00       	call   801029c0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
8010019e:	66 90                	xchg   %ax,%ax
  panic("bget: no buffers");
801001a0:	83 ec 0c             	sub    $0xc,%esp
801001a3:	68 6e 80 10 80       	push   $0x8010806e
801001a8:	e8 e3 01 00 00       	call   80100390 <panic>
801001ad:	8d 76 00             	lea    0x0(%esi),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	f3 0f 1e fb          	endbr32 
801001b4:	55                   	push   %ebp
801001b5:	89 e5                	mov    %esp,%ebp
801001b7:	53                   	push   %ebx
801001b8:	83 ec 10             	sub    $0x10,%esp
801001bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001be:	8d 43 0c             	lea    0xc(%ebx),%eax
801001c1:	50                   	push   %eax
801001c2:	e8 89 4b 00 00       	call   80104d50 <holdingsleep>
801001c7:	83 c4 10             	add    $0x10,%esp
801001ca:	85 c0                	test   %eax,%eax
801001cc:	74 0f                	je     801001dd <bwrite+0x2d>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ce:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001d1:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d7:	c9                   	leave  
  iderw(b);
801001d8:	e9 e3 27 00 00       	jmp    801029c0 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 7f 80 10 80       	push   $0x8010807f
801001e5:	e8 a6 01 00 00       	call   80100390 <panic>
801001ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	f3 0f 1e fb          	endbr32 
801001f4:	55                   	push   %ebp
801001f5:	89 e5                	mov    %esp,%ebp
801001f7:	56                   	push   %esi
801001f8:	53                   	push   %ebx
801001f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001fc:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ff:	83 ec 0c             	sub    $0xc,%esp
80100202:	56                   	push   %esi
80100203:	e8 48 4b 00 00       	call   80104d50 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 f8 4a 00 00       	call   80104d10 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
8010021f:	e8 0c 4d 00 00       	call   80104f30 <acquire>
  b->refcnt--;
80100224:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100227:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
8010022a:	83 e8 01             	sub    $0x1,%eax
8010022d:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
80100230:	85 c0                	test   %eax,%eax
80100232:	75 2f                	jne    80100263 <brelse+0x73>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100234:	8b 43 54             	mov    0x54(%ebx),%eax
80100237:	8b 53 50             	mov    0x50(%ebx),%edx
8010023a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010023d:	8b 43 50             	mov    0x50(%ebx),%eax
80100240:	8b 53 54             	mov    0x54(%ebx),%edx
80100243:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100246:	a1 30 0d 11 80       	mov    0x80110d30,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 dc 0c 11 80 	movl   $0x80110cdc,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 30 0d 11 80       	mov    0x80110d30,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 30 0d 11 80    	mov    %ebx,0x80110d30
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 e0 c5 10 80 	movl   $0x8010c5e0,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 7b 4d 00 00       	jmp    80104ff0 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 86 80 10 80       	push   $0x80108086
8010027d:	e8 0e 01 00 00       	call   80100390 <panic>
80100282:	66 90                	xchg   %ax,%ax
80100284:	66 90                	xchg   %ax,%ax
80100286:	66 90                	xchg   %ax,%ax
80100288:	66 90                	xchg   %ax,%ax
8010028a:	66 90                	xchg   %ax,%ax
8010028c:	66 90                	xchg   %ax,%ax
8010028e:	66 90                	xchg   %ax,%ax

80100290 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100290:	f3 0f 1e fb          	endbr32 
80100294:	55                   	push   %ebp
80100295:	89 e5                	mov    %esp,%ebp
80100297:	57                   	push   %edi
80100298:	56                   	push   %esi
80100299:	53                   	push   %ebx
8010029a:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
8010029d:	ff 75 08             	pushl  0x8(%ebp)
{
801002a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  target = n;
801002a3:	89 de                	mov    %ebx,%esi
  iunlock(ip);
801002a5:	e8 56 19 00 00       	call   80101c00 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
801002b1:	e8 7a 4c 00 00       	call   80104f30 <acquire>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002b6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  while(n > 0){
801002b9:	83 c4 10             	add    $0x10,%esp
    *dst++ = c;
801002bc:	01 df                	add    %ebx,%edi
  while(n > 0){
801002be:	85 db                	test   %ebx,%ebx
801002c0:	0f 8e 97 00 00 00    	jle    8010035d <consoleread+0xcd>
    while(input.r == input.w){
801002c6:	a1 c0 0f 11 80       	mov    0x80110fc0,%eax
801002cb:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 20 b5 10 80       	push   $0x8010b520
801002e0:	68 c0 0f 11 80       	push   $0x80110fc0
801002e5:	e8 46 45 00 00       	call   80104830 <sleep>
    while(input.r == input.w){
801002ea:	a1 c0 0f 11 80       	mov    0x80110fc0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 11 3e 00 00       	call   80104110 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 b5 10 80       	push   $0x8010b520
8010030e:	e8 dd 4c 00 00       	call   80104ff0 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 04 18 00 00       	call   80101b20 <ilock>
        return -1;
8010031c:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
8010031f:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100322:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100327:	5b                   	pop    %ebx
80100328:	5e                   	pop    %esi
80100329:	5f                   	pop    %edi
8010032a:	5d                   	pop    %ebp
8010032b:	c3                   	ret    
8010032c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100330:	8d 50 01             	lea    0x1(%eax),%edx
80100333:	89 15 c0 0f 11 80    	mov    %edx,0x80110fc0
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 40 0f 11 80 	movsbl -0x7feef0c0(%edx),%ecx
    if(c == C('D')){  // EOF
80100345:	80 f9 04             	cmp    $0x4,%cl
80100348:	74 38                	je     80100382 <consoleread+0xf2>
    *dst++ = c;
8010034a:	89 d8                	mov    %ebx,%eax
    --n;
8010034c:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
8010034f:	f7 d8                	neg    %eax
80100351:	88 0c 07             	mov    %cl,(%edi,%eax,1)
    if(c == '\n')
80100354:	83 f9 0a             	cmp    $0xa,%ecx
80100357:	0f 85 61 ff ff ff    	jne    801002be <consoleread+0x2e>
  release(&cons.lock);
8010035d:	83 ec 0c             	sub    $0xc,%esp
80100360:	68 20 b5 10 80       	push   $0x8010b520
80100365:	e8 86 4c 00 00       	call   80104ff0 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 ad 17 00 00       	call   80101b20 <ilock>
  return target - n;
80100373:	89 f0                	mov    %esi,%eax
80100375:	83 c4 10             	add    $0x10,%esp
}
80100378:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
8010037b:	29 d8                	sub    %ebx,%eax
}
8010037d:	5b                   	pop    %ebx
8010037e:	5e                   	pop    %esi
8010037f:	5f                   	pop    %edi
80100380:	5d                   	pop    %ebp
80100381:	c3                   	ret    
      if(n < target){
80100382:	39 f3                	cmp    %esi,%ebx
80100384:	73 d7                	jae    8010035d <consoleread+0xcd>
        input.r--;
80100386:	a3 c0 0f 11 80       	mov    %eax,0x80110fc0
8010038b:	eb d0                	jmp    8010035d <consoleread+0xcd>
8010038d:	8d 76 00             	lea    0x0(%esi),%esi

80100390 <panic>:
{
80100390:	f3 0f 1e fb          	endbr32 
80100394:	55                   	push   %ebp
80100395:	89 e5                	mov    %esp,%ebp
80100397:	56                   	push   %esi
80100398:	53                   	push   %ebx
80100399:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
8010039c:	fa                   	cli    
  cons.locking = 0;
8010039d:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
801003a4:	00 00 00 
  getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 2e 2c 00 00       	call   80102fe0 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 8d 80 10 80       	push   $0x8010808d
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 83 8a 10 80 	movl   $0x80108a83,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 ef 49 00 00       	call   80104dd0 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 a1 80 10 80       	push   $0x801080a1
801003f1:	e8 ba 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003f6:	83 c4 10             	add    $0x10,%esp
801003f9:	39 f3                	cmp    %esi,%ebx
801003fb:	75 e7                	jne    801003e4 <panic+0x54>
  panicked = 1; // freeze other CPU
801003fd:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
80100404:	00 00 00 
  for(;;)
80100407:	eb fe                	jmp    80100407 <panic+0x77>
80100409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100410 <consputc.part.0>:
consputc(int c)
80100410:	55                   	push   %ebp
80100411:	89 e5                	mov    %esp,%ebp
80100413:	57                   	push   %edi
80100414:	56                   	push   %esi
80100415:	53                   	push   %ebx
80100416:	89 c3                	mov    %eax,%ebx
80100418:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010041b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100420:	0f 84 ea 00 00 00    	je     80100510 <consputc.part.0+0x100>
    uartputc(c);
80100426:	83 ec 0c             	sub    $0xc,%esp
80100429:	50                   	push   %eax
8010042a:	e8 41 63 00 00       	call   80106770 <uartputc>
8010042f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100432:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100437:	b8 0e 00 00 00       	mov    $0xe,%eax
8010043c:	89 fa                	mov    %edi,%edx
8010043e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010043f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100444:	89 ca                	mov    %ecx,%edx
80100446:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100447:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010044a:	89 fa                	mov    %edi,%edx
8010044c:	c1 e0 08             	shl    $0x8,%eax
8010044f:	89 c6                	mov    %eax,%esi
80100451:	b8 0f 00 00 00       	mov    $0xf,%eax
80100456:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100457:	89 ca                	mov    %ecx,%edx
80100459:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010045a:	0f b6 c0             	movzbl %al,%eax
8010045d:	09 f0                	or     %esi,%eax
  if(c == '\n')
8010045f:	83 fb 0a             	cmp    $0xa,%ebx
80100462:	0f 84 90 00 00 00    	je     801004f8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100468:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010046e:	74 70                	je     801004e0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100470:	0f b6 db             	movzbl %bl,%ebx
80100473:	8d 70 01             	lea    0x1(%eax),%esi
80100476:	80 cf 07             	or     $0x7,%bh
80100479:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
80100480:	80 
  if(pos < 0 || pos > 25*80)
80100481:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100487:	0f 8f f9 00 00 00    	jg     80100586 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010048d:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100493:	0f 8f a7 00 00 00    	jg     80100540 <consputc.part.0+0x130>
80100499:	89 f0                	mov    %esi,%eax
8010049b:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
801004a2:	88 45 e7             	mov    %al,-0x19(%ebp)
801004a5:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004a8:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801004ad:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004ba:	89 f8                	mov    %edi,%eax
801004bc:	89 ca                	mov    %ecx,%edx
801004be:	ee                   	out    %al,(%dx)
801004bf:	b8 0f 00 00 00       	mov    $0xf,%eax
801004c4:	89 da                	mov    %ebx,%edx
801004c6:	ee                   	out    %al,(%dx)
801004c7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004cb:	89 ca                	mov    %ecx,%edx
801004cd:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004ce:	b8 20 07 00 00       	mov    $0x720,%eax
801004d3:	66 89 06             	mov    %ax,(%esi)
}
801004d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004d9:	5b                   	pop    %ebx
801004da:	5e                   	pop    %esi
801004db:	5f                   	pop    %edi
801004dc:	5d                   	pop    %ebp
801004dd:	c3                   	ret    
801004de:	66 90                	xchg   %ax,%ax
    if(pos > 0) --pos;
801004e0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004e3:	85 c0                	test   %eax,%eax
801004e5:	75 9a                	jne    80100481 <consputc.part.0+0x71>
801004e7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004eb:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004f0:	31 ff                	xor    %edi,%edi
801004f2:	eb b4                	jmp    801004a8 <consputc.part.0+0x98>
801004f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004f8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004fd:	f7 e2                	mul    %edx
801004ff:	c1 ea 06             	shr    $0x6,%edx
80100502:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100505:	c1 e0 04             	shl    $0x4,%eax
80100508:	8d 70 50             	lea    0x50(%eax),%esi
8010050b:	e9 71 ff ff ff       	jmp    80100481 <consputc.part.0+0x71>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100510:	83 ec 0c             	sub    $0xc,%esp
80100513:	6a 08                	push   $0x8
80100515:	e8 56 62 00 00       	call   80106770 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 4a 62 00 00       	call   80106770 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 3e 62 00 00       	call   80106770 <uartputc>
80100532:	83 c4 10             	add    $0x10,%esp
80100535:	e9 f8 fe ff ff       	jmp    80100432 <consputc.part.0+0x22>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 7a 4b 00 00       	call   801050e0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 c5 4a 00 00       	call   80105040 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 a5 80 10 80       	push   $0x801080a5
8010058e:	e8 fd fd ff ff       	call   80100390 <panic>
80100593:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010059a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801005a0 <printint>:
{
801005a0:	55                   	push   %ebp
801005a1:	89 e5                	mov    %esp,%ebp
801005a3:	57                   	push   %edi
801005a4:	56                   	push   %esi
801005a5:	53                   	push   %ebx
801005a6:	83 ec 2c             	sub    $0x2c,%esp
801005a9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
801005ac:	85 c9                	test   %ecx,%ecx
801005ae:	74 04                	je     801005b4 <printint+0x14>
801005b0:	85 c0                	test   %eax,%eax
801005b2:	78 6d                	js     80100621 <printint+0x81>
    x = xx;
801005b4:	89 c1                	mov    %eax,%ecx
801005b6:	31 f6                	xor    %esi,%esi
  i = 0;
801005b8:	89 75 cc             	mov    %esi,-0x34(%ebp)
801005bb:	31 db                	xor    %ebx,%ebx
801005bd:	8d 7d d7             	lea    -0x29(%ebp),%edi
    buf[i++] = digits[x % base];
801005c0:	89 c8                	mov    %ecx,%eax
801005c2:	31 d2                	xor    %edx,%edx
801005c4:	89 ce                	mov    %ecx,%esi
801005c6:	f7 75 d4             	divl   -0x2c(%ebp)
801005c9:	0f b6 92 d0 80 10 80 	movzbl -0x7fef7f30(%edx),%edx
801005d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
801005d3:	89 d8                	mov    %ebx,%eax
801005d5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
801005d8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
801005db:	89 75 d0             	mov    %esi,-0x30(%ebp)
    buf[i++] = digits[x % base];
801005de:	88 14 1f             	mov    %dl,(%edi,%ebx,1)
  }while((x /= base) != 0);
801005e1:	8b 75 d4             	mov    -0x2c(%ebp),%esi
801005e4:	39 75 d0             	cmp    %esi,-0x30(%ebp)
801005e7:	73 d7                	jae    801005c0 <printint+0x20>
801005e9:	8b 75 cc             	mov    -0x34(%ebp),%esi
  if(sign)
801005ec:	85 f6                	test   %esi,%esi
801005ee:	74 0c                	je     801005fc <printint+0x5c>
    buf[i++] = '-';
801005f0:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
801005f5:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
801005f7:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
801005fc:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
80100600:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100603:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100609:	85 d2                	test   %edx,%edx
8010060b:	74 03                	je     80100610 <printint+0x70>
  asm volatile("cli");
8010060d:	fa                   	cli    
    for(;;)
8010060e:	eb fe                	jmp    8010060e <printint+0x6e>
80100610:	e8 fb fd ff ff       	call   80100410 <consputc.part.0>
  while(--i >= 0)
80100615:	39 fb                	cmp    %edi,%ebx
80100617:	74 10                	je     80100629 <printint+0x89>
80100619:	0f be 03             	movsbl (%ebx),%eax
8010061c:	83 eb 01             	sub    $0x1,%ebx
8010061f:	eb e2                	jmp    80100603 <printint+0x63>
    x = -xx;
80100621:	f7 d8                	neg    %eax
80100623:	89 ce                	mov    %ecx,%esi
80100625:	89 c1                	mov    %eax,%ecx
80100627:	eb 8f                	jmp    801005b8 <printint+0x18>
}
80100629:	83 c4 2c             	add    $0x2c,%esp
8010062c:	5b                   	pop    %ebx
8010062d:	5e                   	pop    %esi
8010062e:	5f                   	pop    %edi
8010062f:	5d                   	pop    %ebp
80100630:	c3                   	ret    
80100631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100638:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010063f:	90                   	nop

80100640 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100640:	f3 0f 1e fb          	endbr32 
80100644:	55                   	push   %ebp
80100645:	89 e5                	mov    %esp,%ebp
80100647:	57                   	push   %edi
80100648:	56                   	push   %esi
80100649:	53                   	push   %ebx
8010064a:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
8010064d:	ff 75 08             	pushl  0x8(%ebp)
{
80100650:	8b 5d 10             	mov    0x10(%ebp),%ebx
  iunlock(ip);
80100653:	e8 a8 15 00 00       	call   80101c00 <iunlock>
  acquire(&cons.lock);
80100658:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010065f:	e8 cc 48 00 00       	call   80104f30 <acquire>
  for(i = 0; i < n; i++)
80100664:	83 c4 10             	add    $0x10,%esp
80100667:	85 db                	test   %ebx,%ebx
80100669:	7e 24                	jle    8010068f <consolewrite+0x4f>
8010066b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010066e:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
80100671:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100677:	85 d2                	test   %edx,%edx
80100679:	74 05                	je     80100680 <consolewrite+0x40>
8010067b:	fa                   	cli    
    for(;;)
8010067c:	eb fe                	jmp    8010067c <consolewrite+0x3c>
8010067e:	66 90                	xchg   %ax,%ax
    consputc(buf[i] & 0xff);
80100680:	0f b6 07             	movzbl (%edi),%eax
80100683:	83 c7 01             	add    $0x1,%edi
80100686:	e8 85 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; i < n; i++)
8010068b:	39 fe                	cmp    %edi,%esi
8010068d:	75 e2                	jne    80100671 <consolewrite+0x31>
  release(&cons.lock);
8010068f:	83 ec 0c             	sub    $0xc,%esp
80100692:	68 20 b5 10 80       	push   $0x8010b520
80100697:	e8 54 49 00 00       	call   80104ff0 <release>
  ilock(ip);
8010069c:	58                   	pop    %eax
8010069d:	ff 75 08             	pushl  0x8(%ebp)
801006a0:	e8 7b 14 00 00       	call   80101b20 <ilock>

  return n;
}
801006a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006a8:	89 d8                	mov    %ebx,%eax
801006aa:	5b                   	pop    %ebx
801006ab:	5e                   	pop    %esi
801006ac:	5f                   	pop    %edi
801006ad:	5d                   	pop    %ebp
801006ae:	c3                   	ret    
801006af:	90                   	nop

801006b0 <cprintf>:
{
801006b0:	f3 0f 1e fb          	endbr32 
801006b4:	55                   	push   %ebp
801006b5:	89 e5                	mov    %esp,%ebp
801006b7:	57                   	push   %edi
801006b8:	56                   	push   %esi
801006b9:	53                   	push   %ebx
801006ba:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006bd:	a1 54 b5 10 80       	mov    0x8010b554,%eax
801006c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801006c5:	85 c0                	test   %eax,%eax
801006c7:	0f 85 e8 00 00 00    	jne    801007b5 <cprintf+0x105>
  if (fmt == 0)
801006cd:	8b 45 08             	mov    0x8(%ebp),%eax
801006d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d3:	85 c0                	test   %eax,%eax
801006d5:	0f 84 5a 01 00 00    	je     80100835 <cprintf+0x185>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006db:	0f b6 00             	movzbl (%eax),%eax
801006de:	85 c0                	test   %eax,%eax
801006e0:	74 36                	je     80100718 <cprintf+0x68>
  argp = (uint*)(void*)(&fmt + 1);
801006e2:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e5:	31 f6                	xor    %esi,%esi
    if(c != '%'){
801006e7:	83 f8 25             	cmp    $0x25,%eax
801006ea:	74 44                	je     80100730 <cprintf+0x80>
  if(panicked){
801006ec:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
801006f2:	85 c9                	test   %ecx,%ecx
801006f4:	74 0f                	je     80100705 <cprintf+0x55>
801006f6:	fa                   	cli    
    for(;;)
801006f7:	eb fe                	jmp    801006f7 <cprintf+0x47>
801006f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100700:	b8 25 00 00 00       	mov    $0x25,%eax
80100705:	e8 06 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010070a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010070d:	83 c6 01             	add    $0x1,%esi
80100710:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
80100714:	85 c0                	test   %eax,%eax
80100716:	75 cf                	jne    801006e7 <cprintf+0x37>
  if(locking)
80100718:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010071b:	85 c0                	test   %eax,%eax
8010071d:	0f 85 fd 00 00 00    	jne    80100820 <cprintf+0x170>
}
80100723:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100726:	5b                   	pop    %ebx
80100727:	5e                   	pop    %esi
80100728:	5f                   	pop    %edi
80100729:	5d                   	pop    %ebp
8010072a:	c3                   	ret    
8010072b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010072f:	90                   	nop
    c = fmt[++i] & 0xff;
80100730:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100733:	83 c6 01             	add    $0x1,%esi
80100736:	0f b6 3c 30          	movzbl (%eax,%esi,1),%edi
    if(c == 0)
8010073a:	85 ff                	test   %edi,%edi
8010073c:	74 da                	je     80100718 <cprintf+0x68>
    switch(c){
8010073e:	83 ff 70             	cmp    $0x70,%edi
80100741:	74 5a                	je     8010079d <cprintf+0xed>
80100743:	7f 2a                	jg     8010076f <cprintf+0xbf>
80100745:	83 ff 25             	cmp    $0x25,%edi
80100748:	0f 84 92 00 00 00    	je     801007e0 <cprintf+0x130>
8010074e:	83 ff 64             	cmp    $0x64,%edi
80100751:	0f 85 a1 00 00 00    	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 10, 1);
80100757:	8b 03                	mov    (%ebx),%eax
80100759:	8d 7b 04             	lea    0x4(%ebx),%edi
8010075c:	b9 01 00 00 00       	mov    $0x1,%ecx
80100761:	ba 0a 00 00 00       	mov    $0xa,%edx
80100766:	89 fb                	mov    %edi,%ebx
80100768:	e8 33 fe ff ff       	call   801005a0 <printint>
      break;
8010076d:	eb 9b                	jmp    8010070a <cprintf+0x5a>
    switch(c){
8010076f:	83 ff 73             	cmp    $0x73,%edi
80100772:	75 24                	jne    80100798 <cprintf+0xe8>
      if((s = (char*)*argp++) == 0)
80100774:	8d 7b 04             	lea    0x4(%ebx),%edi
80100777:	8b 1b                	mov    (%ebx),%ebx
80100779:	85 db                	test   %ebx,%ebx
8010077b:	75 55                	jne    801007d2 <cprintf+0x122>
        s = "(null)";
8010077d:	bb b8 80 10 80       	mov    $0x801080b8,%ebx
      for(; *s; s++)
80100782:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
80100787:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
8010078d:	85 d2                	test   %edx,%edx
8010078f:	74 39                	je     801007ca <cprintf+0x11a>
80100791:	fa                   	cli    
    for(;;)
80100792:	eb fe                	jmp    80100792 <cprintf+0xe2>
80100794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100798:	83 ff 78             	cmp    $0x78,%edi
8010079b:	75 5b                	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 16, 0);
8010079d:	8b 03                	mov    (%ebx),%eax
8010079f:	8d 7b 04             	lea    0x4(%ebx),%edi
801007a2:	31 c9                	xor    %ecx,%ecx
801007a4:	ba 10 00 00 00       	mov    $0x10,%edx
801007a9:	89 fb                	mov    %edi,%ebx
801007ab:	e8 f0 fd ff ff       	call   801005a0 <printint>
      break;
801007b0:	e9 55 ff ff ff       	jmp    8010070a <cprintf+0x5a>
    acquire(&cons.lock);
801007b5:	83 ec 0c             	sub    $0xc,%esp
801007b8:	68 20 b5 10 80       	push   $0x8010b520
801007bd:	e8 6e 47 00 00       	call   80104f30 <acquire>
801007c2:	83 c4 10             	add    $0x10,%esp
801007c5:	e9 03 ff ff ff       	jmp    801006cd <cprintf+0x1d>
801007ca:	e8 41 fc ff ff       	call   80100410 <consputc.part.0>
      for(; *s; s++)
801007cf:	83 c3 01             	add    $0x1,%ebx
801007d2:	0f be 03             	movsbl (%ebx),%eax
801007d5:	84 c0                	test   %al,%al
801007d7:	75 ae                	jne    80100787 <cprintf+0xd7>
      if((s = (char*)*argp++) == 0)
801007d9:	89 fb                	mov    %edi,%ebx
801007db:	e9 2a ff ff ff       	jmp    8010070a <cprintf+0x5a>
  if(panicked){
801007e0:	8b 3d 58 b5 10 80    	mov    0x8010b558,%edi
801007e6:	85 ff                	test   %edi,%edi
801007e8:	0f 84 12 ff ff ff    	je     80100700 <cprintf+0x50>
801007ee:	fa                   	cli    
    for(;;)
801007ef:	eb fe                	jmp    801007ef <cprintf+0x13f>
801007f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801007f8:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
801007fe:	85 c9                	test   %ecx,%ecx
80100800:	74 06                	je     80100808 <cprintf+0x158>
80100802:	fa                   	cli    
    for(;;)
80100803:	eb fe                	jmp    80100803 <cprintf+0x153>
80100805:	8d 76 00             	lea    0x0(%esi),%esi
80100808:	b8 25 00 00 00       	mov    $0x25,%eax
8010080d:	e8 fe fb ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100812:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100818:	85 d2                	test   %edx,%edx
8010081a:	74 2c                	je     80100848 <cprintf+0x198>
8010081c:	fa                   	cli    
    for(;;)
8010081d:	eb fe                	jmp    8010081d <cprintf+0x16d>
8010081f:	90                   	nop
    release(&cons.lock);
80100820:	83 ec 0c             	sub    $0xc,%esp
80100823:	68 20 b5 10 80       	push   $0x8010b520
80100828:	e8 c3 47 00 00       	call   80104ff0 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 bf 80 10 80       	push   $0x801080bf
8010083d:	e8 4e fb ff ff       	call   80100390 <panic>
80100842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100848:	89 f8                	mov    %edi,%eax
8010084a:	e8 c1 fb ff ff       	call   80100410 <consputc.part.0>
8010084f:	e9 b6 fe ff ff       	jmp    8010070a <cprintf+0x5a>
80100854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010085b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010085f:	90                   	nop

80100860 <consoleintr>:
{
80100860:	f3 0f 1e fb          	endbr32 
80100864:	55                   	push   %ebp
80100865:	89 e5                	mov    %esp,%ebp
80100867:	57                   	push   %edi
80100868:	56                   	push   %esi
  int c, doprocdump = 0;
80100869:	31 f6                	xor    %esi,%esi
{
8010086b:	53                   	push   %ebx
8010086c:	83 ec 18             	sub    $0x18,%esp
8010086f:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
80100872:	68 20 b5 10 80       	push   $0x8010b520
80100877:	e8 b4 46 00 00       	call   80104f30 <acquire>
  while((c = getc()) >= 0){
8010087c:	83 c4 10             	add    $0x10,%esp
8010087f:	eb 17                	jmp    80100898 <consoleintr+0x38>
    switch(c){
80100881:	83 fb 08             	cmp    $0x8,%ebx
80100884:	0f 84 f6 00 00 00    	je     80100980 <consoleintr+0x120>
8010088a:	83 fb 10             	cmp    $0x10,%ebx
8010088d:	0f 85 15 01 00 00    	jne    801009a8 <consoleintr+0x148>
80100893:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
80100898:	ff d7                	call   *%edi
8010089a:	89 c3                	mov    %eax,%ebx
8010089c:	85 c0                	test   %eax,%eax
8010089e:	0f 88 23 01 00 00    	js     801009c7 <consoleintr+0x167>
    switch(c){
801008a4:	83 fb 15             	cmp    $0x15,%ebx
801008a7:	74 77                	je     80100920 <consoleintr+0xc0>
801008a9:	7e d6                	jle    80100881 <consoleintr+0x21>
801008ab:	83 fb 7f             	cmp    $0x7f,%ebx
801008ae:	0f 84 cc 00 00 00    	je     80100980 <consoleintr+0x120>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008b4:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
801008b9:	89 c2                	mov    %eax,%edx
801008bb:	2b 15 c0 0f 11 80    	sub    0x80110fc0,%edx
801008c1:	83 fa 7f             	cmp    $0x7f,%edx
801008c4:	77 d2                	ja     80100898 <consoleintr+0x38>
        c = (c == '\r') ? '\n' : c;
801008c6:	8d 48 01             	lea    0x1(%eax),%ecx
801008c9:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
801008cf:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
801008d2:	89 0d c8 0f 11 80    	mov    %ecx,0x80110fc8
        c = (c == '\r') ? '\n' : c;
801008d8:	83 fb 0d             	cmp    $0xd,%ebx
801008db:	0f 84 02 01 00 00    	je     801009e3 <consoleintr+0x183>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e1:	88 98 40 0f 11 80    	mov    %bl,-0x7feef0c0(%eax)
  if(panicked){
801008e7:	85 d2                	test   %edx,%edx
801008e9:	0f 85 ff 00 00 00    	jne    801009ee <consoleintr+0x18e>
801008ef:	89 d8                	mov    %ebx,%eax
801008f1:	e8 1a fb ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008f6:	83 fb 0a             	cmp    $0xa,%ebx
801008f9:	0f 84 0f 01 00 00    	je     80100a0e <consoleintr+0x1ae>
801008ff:	83 fb 04             	cmp    $0x4,%ebx
80100902:	0f 84 06 01 00 00    	je     80100a0e <consoleintr+0x1ae>
80100908:	a1 c0 0f 11 80       	mov    0x80110fc0,%eax
8010090d:	83 e8 80             	sub    $0xffffff80,%eax
80100910:	39 05 c8 0f 11 80    	cmp    %eax,0x80110fc8
80100916:	75 80                	jne    80100898 <consoleintr+0x38>
80100918:	e9 f6 00 00 00       	jmp    80100a13 <consoleintr+0x1b3>
8010091d:	8d 76 00             	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100920:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
80100925:	39 05 c4 0f 11 80    	cmp    %eax,0x80110fc4
8010092b:	0f 84 67 ff ff ff    	je     80100898 <consoleintr+0x38>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100931:	83 e8 01             	sub    $0x1,%eax
80100934:	89 c2                	mov    %eax,%edx
80100936:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100939:	80 ba 40 0f 11 80 0a 	cmpb   $0xa,-0x7feef0c0(%edx)
80100940:	0f 84 52 ff ff ff    	je     80100898 <consoleintr+0x38>
  if(panicked){
80100946:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
        input.e--;
8010094c:	a3 c8 0f 11 80       	mov    %eax,0x80110fc8
  if(panicked){
80100951:	85 d2                	test   %edx,%edx
80100953:	74 0b                	je     80100960 <consoleintr+0x100>
80100955:	fa                   	cli    
    for(;;)
80100956:	eb fe                	jmp    80100956 <consoleintr+0xf6>
80100958:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010095f:	90                   	nop
80100960:	b8 00 01 00 00       	mov    $0x100,%eax
80100965:	e8 a6 fa ff ff       	call   80100410 <consputc.part.0>
      while(input.e != input.w &&
8010096a:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
8010096f:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
80100975:	75 ba                	jne    80100931 <consoleintr+0xd1>
80100977:	e9 1c ff ff ff       	jmp    80100898 <consoleintr+0x38>
8010097c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(input.e != input.w){
80100980:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
80100985:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
8010098b:	0f 84 07 ff ff ff    	je     80100898 <consoleintr+0x38>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 c8 0f 11 80       	mov    %eax,0x80110fc8
  if(panicked){
80100999:	a1 58 b5 10 80       	mov    0x8010b558,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 16                	je     801009b8 <consoleintr+0x158>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x143>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009a8:	85 db                	test   %ebx,%ebx
801009aa:	0f 84 e8 fe ff ff    	je     80100898 <consoleintr+0x38>
801009b0:	e9 ff fe ff ff       	jmp    801008b4 <consoleintr+0x54>
801009b5:	8d 76 00             	lea    0x0(%esi),%esi
801009b8:	b8 00 01 00 00       	mov    $0x100,%eax
801009bd:	e8 4e fa ff ff       	call   80100410 <consputc.part.0>
801009c2:	e9 d1 fe ff ff       	jmp    80100898 <consoleintr+0x38>
  release(&cons.lock);
801009c7:	83 ec 0c             	sub    $0xc,%esp
801009ca:	68 20 b5 10 80       	push   $0x8010b520
801009cf:	e8 1c 46 00 00       	call   80104ff0 <release>
  if(doprocdump) {
801009d4:	83 c4 10             	add    $0x10,%esp
801009d7:	85 f6                	test   %esi,%esi
801009d9:	75 1d                	jne    801009f8 <consoleintr+0x198>
}
801009db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009de:	5b                   	pop    %ebx
801009df:	5e                   	pop    %esi
801009e0:	5f                   	pop    %edi
801009e1:	5d                   	pop    %ebp
801009e2:	c3                   	ret    
        input.buf[input.e++ % INPUT_BUF] = c;
801009e3:	c6 80 40 0f 11 80 0a 	movb   $0xa,-0x7feef0c0(%eax)
  if(panicked){
801009ea:	85 d2                	test   %edx,%edx
801009ec:	74 16                	je     80100a04 <consoleintr+0x1a4>
801009ee:	fa                   	cli    
    for(;;)
801009ef:	eb fe                	jmp    801009ef <consoleintr+0x18f>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
801009f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009fb:	5b                   	pop    %ebx
801009fc:	5e                   	pop    %esi
801009fd:	5f                   	pop    %edi
801009fe:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
801009ff:	e9 8c 41 00 00       	jmp    80104b90 <procdump>
80100a04:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a09:	e8 02 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100a0e:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
          wakeup(&input.r);
80100a13:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a16:	a3 c4 0f 11 80       	mov    %eax,0x80110fc4
          wakeup(&input.r);
80100a1b:	68 c0 0f 11 80       	push   $0x80110fc0
80100a20:	e8 6b 40 00 00       	call   80104a90 <wakeup>
80100a25:	83 c4 10             	add    $0x10,%esp
80100a28:	e9 6b fe ff ff       	jmp    80100898 <consoleintr+0x38>
80100a2d:	8d 76 00             	lea    0x0(%esi),%esi

80100a30 <consoleinit>:

void
consoleinit(void)
{
80100a30:	f3 0f 1e fb          	endbr32 
80100a34:	55                   	push   %ebp
80100a35:	89 e5                	mov    %esp,%ebp
80100a37:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a3a:	68 c8 80 10 80       	push   $0x801080c8
80100a3f:	68 20 b5 10 80       	push   $0x8010b520
80100a44:	e8 67 43 00 00       	call   80104db0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a49:	58                   	pop    %eax
80100a4a:	5a                   	pop    %edx
80100a4b:	6a 00                	push   $0x0
80100a4d:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a4f:	c7 05 8c 19 11 80 40 	movl   $0x80100640,0x8011198c
80100a56:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a59:	c7 05 88 19 11 80 90 	movl   $0x80100290,0x80111988
80100a60:	02 10 80 
  cons.locking = 1;
80100a63:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
80100a6a:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a6d:	e8 fe 20 00 00       	call   80102b70 <ioapicenable>
}
80100a72:	83 c4 10             	add    $0x10,%esp
80100a75:	c9                   	leave  
80100a76:	c3                   	ret    
80100a77:	66 90                	xchg   %ax,%ax
80100a79:	66 90                	xchg   %ax,%ax
80100a7b:	66 90                	xchg   %ax,%ax
80100a7d:	66 90                	xchg   %ax,%ax
80100a7f:	90                   	nop

80100a80 <intiate_pg_info>:
#include "proc.h"
#include "defs.h"
#include "x86.h"
#include "elf.h"

void intiate_pg_info(struct proc* p){
80100a80:	f3 0f 1e fb          	endbr32 
80100a84:	55                   	push   %ebp
80100a85:	89 e5                	mov    %esp,%ebp
80100a87:	8b 55 08             	mov    0x8(%ebp),%edx
  p->num_of_pageOut_occured = 0;
80100a8a:	c7 82 8c 03 00 00 00 	movl   $0x0,0x38c(%edx)
80100a91:	00 00 00 
  p->num_of_pagefaults_occurs = 0;
80100a94:	8d 82 80 00 00 00    	lea    0x80(%edx),%eax
80100a9a:	81 c2 00 02 00 00    	add    $0x200,%edx
80100aa0:	c7 82 88 01 00 00 00 	movl   $0x0,0x188(%edx)
80100aa7:	00 00 00 
  p->num_of_actual_pages_in_mem = 0;
80100aaa:	c7 82 84 01 00 00 00 	movl   $0x0,0x184(%edx)
80100ab1:	00 00 00 
  p->num_of_pages_in_swap_file = 0;
80100ab4:	c7 82 80 01 00 00 00 	movl   $0x0,0x180(%edx)
80100abb:	00 00 00 
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
80100abe:	66 90                	xchg   %ax,%ax
    p->ram_pages[i].is_free = p->swapped_out_pages[i].is_free = 1;
80100ac0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
80100ac6:	83 c0 18             	add    $0x18,%eax
80100ac9:	c7 80 68 01 00 00 01 	movl   $0x1,0x168(%eax)
80100ad0:	00 00 00 
    p->ram_pages[i].aging_counter = p->swapped_out_pages[i].aging_counter = 0;
80100ad3:	c7 40 f0 00 00 00 00 	movl   $0x0,-0x10(%eax)
80100ada:	c7 80 70 01 00 00 00 	movl   $0x0,0x170(%eax)
80100ae1:	00 00 00 
    p->ram_pages[i].swap_file_offset = p->swapped_out_pages[i].swap_file_offset = 0;
80100ae4:	c7 40 ec 00 00 00 00 	movl   $0x0,-0x14(%eax)
80100aeb:	c7 80 6c 01 00 00 00 	movl   $0x0,0x16c(%eax)
80100af2:	00 00 00 
    p->ram_pages[i].va = p->swapped_out_pages[i].va = 0;
80100af5:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
80100afc:	c7 80 78 01 00 00 00 	movl   $0x0,0x178(%eax)
80100b03:	00 00 00 
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
80100b06:	39 d0                	cmp    %edx,%eax
80100b08:	75 b6                	jne    80100ac0 <intiate_pg_info+0x40>
  }
}
80100b0a:	5d                   	pop    %ebp
80100b0b:	c3                   	ret    
80100b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100b10 <exec>:


int
exec(char *path, char **argv)
{
80100b10:	f3 0f 1e fb          	endbr32 
80100b14:	55                   	push   %ebp
80100b15:	89 e5                	mov    %esp,%ebp
80100b17:	57                   	push   %edi
80100b18:	56                   	push   %esi
80100b19:	53                   	push   %ebx
80100b1a:	81 ec 1c 04 00 00    	sub    $0x41c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100b20:	e8 eb 35 00 00       	call   80104110 <myproc>
80100b25:	89 c7                	mov    %eax,%edi
  struct pageinfo mem_pginfo_bu[MAX_PYSC_PAGES];
  struct pageinfo swp_pginfo_bu[MAX_PYSC_PAGES];
  struct file* swap_file_bu = 0;
  struct file* temp_swap_file = 0;

  begin_op();
80100b27:	e8 44 29 00 00       	call   80103470 <begin_op>

  if((ip = namei(path)) == 0){
80100b2c:	83 ec 0c             	sub    $0xc,%esp
80100b2f:	ff 75 08             	pushl  0x8(%ebp)
80100b32:	e8 b9 18 00 00       	call   801023f0 <namei>
80100b37:	83 c4 10             	add    $0x10,%esp
80100b3a:	85 c0                	test   %eax,%eax
80100b3c:	0f 84 16 05 00 00    	je     80101058 <exec+0x548>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100b42:	83 ec 0c             	sub    $0xc,%esp
80100b45:	89 c6                	mov    %eax,%esi
80100b47:	50                   	push   %eax
80100b48:	e8 d3 0f 00 00       	call   80101b20 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100b4d:	8d 85 24 fc ff ff    	lea    -0x3dc(%ebp),%eax
80100b53:	6a 34                	push   $0x34
80100b55:	6a 00                	push   $0x0
80100b57:	50                   	push   %eax
80100b58:	56                   	push   %esi
80100b59:	e8 c2 12 00 00       	call   80101e20 <readi>
80100b5e:	83 c4 20             	add    $0x20,%esp
80100b61:	83 f8 34             	cmp    $0x34,%eax
80100b64:	74 22                	je     80100b88 <exec+0x78>
      curproc->swapFile = swap_file_bu;
    }
    freevm(pgdir);
  }
  if(ip){
    iunlockput(ip);
80100b66:	83 ec 0c             	sub    $0xc,%esp
80100b69:	56                   	push   %esi
80100b6a:	e8 51 12 00 00       	call   80101dc0 <iunlockput>
    end_op();
80100b6f:	e8 6c 29 00 00       	call   801034e0 <end_op>
80100b74:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100b77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b7f:	5b                   	pop    %ebx
80100b80:	5e                   	pop    %esi
80100b81:	5f                   	pop    %edi
80100b82:	5d                   	pop    %ebp
80100b83:	c3                   	ret    
80100b84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100b88:	81 bd 24 fc ff ff 7f 	cmpl   $0x464c457f,-0x3dc(%ebp)
80100b8f:	45 4c 46 
80100b92:	75 d2                	jne    80100b66 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100b94:	e8 27 6d 00 00       	call   801078c0 <setupkvm>
80100b99:	89 85 f4 fb ff ff    	mov    %eax,-0x40c(%ebp)
80100b9f:	85 c0                	test   %eax,%eax
80100ba1:	74 c3                	je     80100b66 <exec+0x56>
  if (curproc->pid > 2){
80100ba3:	83 7f 10 02          	cmpl   $0x2,0x10(%edi)
80100ba7:	0f 8e 63 03 00 00    	jle    80100f10 <exec+0x400>
    pg_flt_bu = curproc->num_of_pagefaults_occurs;
80100bad:	8b 87 88 03 00 00    	mov    0x388(%edi),%eax
80100bb3:	8d 9d e8 fc ff ff    	lea    -0x318(%ebp),%ebx
80100bb9:	8d 8d 68 fe ff ff    	lea    -0x198(%ebp),%ecx
80100bbf:	89 85 e4 fb ff ff    	mov    %eax,-0x41c(%ebp)
    pg_mem_bu = curproc->num_of_actual_pages_in_mem;
80100bc5:	8b 87 84 03 00 00    	mov    0x384(%edi),%eax
80100bcb:	89 85 e0 fb ff ff    	mov    %eax,-0x420(%ebp)
    pg_swp_bu = curproc->num_of_pages_in_swap_file;
80100bd1:	8b 87 80 03 00 00    	mov    0x380(%edi),%eax
80100bd7:	89 85 dc fb ff ff    	mov    %eax,-0x424(%ebp)
    pg_out_bu = curproc->num_of_pageOut_occured;
80100bdd:	8b 87 8c 03 00 00    	mov    0x38c(%edi),%eax
80100be3:	89 85 e8 fb ff ff    	mov    %eax,-0x418(%ebp)
80100be9:	31 c0                	xor    %eax,%eax
80100beb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100bef:	90                   	nop
      mem_pginfo_bu[i] = curproc->ram_pages[i];
80100bf0:	8b 94 07 00 02 00 00 	mov    0x200(%edi,%eax,1),%edx
80100bf7:	89 14 03             	mov    %edx,(%ebx,%eax,1)
80100bfa:	8b 94 07 04 02 00 00 	mov    0x204(%edi,%eax,1),%edx
80100c01:	89 54 03 04          	mov    %edx,0x4(%ebx,%eax,1)
80100c05:	8b 94 07 08 02 00 00 	mov    0x208(%edi,%eax,1),%edx
80100c0c:	89 54 03 08          	mov    %edx,0x8(%ebx,%eax,1)
80100c10:	8b 94 07 0c 02 00 00 	mov    0x20c(%edi,%eax,1),%edx
80100c17:	89 54 03 0c          	mov    %edx,0xc(%ebx,%eax,1)
80100c1b:	8b 94 07 10 02 00 00 	mov    0x210(%edi,%eax,1),%edx
80100c22:	89 54 03 10          	mov    %edx,0x10(%ebx,%eax,1)
80100c26:	8b 94 07 14 02 00 00 	mov    0x214(%edi,%eax,1),%edx
80100c2d:	89 54 03 14          	mov    %edx,0x14(%ebx,%eax,1)
      swp_pginfo_bu[i] = curproc->swapped_out_pages[i];
80100c31:	8b 94 07 80 00 00 00 	mov    0x80(%edi,%eax,1),%edx
80100c38:	89 14 01             	mov    %edx,(%ecx,%eax,1)
80100c3b:	8b 94 07 84 00 00 00 	mov    0x84(%edi,%eax,1),%edx
80100c42:	89 54 01 04          	mov    %edx,0x4(%ecx,%eax,1)
80100c46:	8b 94 07 88 00 00 00 	mov    0x88(%edi,%eax,1),%edx
80100c4d:	89 54 01 08          	mov    %edx,0x8(%ecx,%eax,1)
80100c51:	8b 94 07 8c 00 00 00 	mov    0x8c(%edi,%eax,1),%edx
80100c58:	89 54 01 0c          	mov    %edx,0xc(%ecx,%eax,1)
80100c5c:	8b 94 07 90 00 00 00 	mov    0x90(%edi,%eax,1),%edx
80100c63:	89 54 01 10          	mov    %edx,0x10(%ecx,%eax,1)
80100c67:	8b 94 07 94 00 00 00 	mov    0x94(%edi,%eax,1),%edx
80100c6e:	89 54 01 14          	mov    %edx,0x14(%ecx,%eax,1)
    for (int i = 0; i < MAX_PYSC_PAGES; i++){
80100c72:	83 c0 18             	add    $0x18,%eax
80100c75:	3d 80 01 00 00       	cmp    $0x180,%eax
80100c7a:	0f 85 70 ff ff ff    	jne    80100bf0 <exec+0xe0>
  p->num_of_pageOut_occured = 0;
80100c80:	c7 87 8c 03 00 00 00 	movl   $0x0,0x38c(%edi)
80100c87:	00 00 00 
  p->num_of_pagefaults_occurs = 0;
80100c8a:	8d 87 80 00 00 00    	lea    0x80(%edi),%eax
80100c90:	8d 8f 00 02 00 00    	lea    0x200(%edi),%ecx
80100c96:	c7 87 88 03 00 00 00 	movl   $0x0,0x388(%edi)
80100c9d:	00 00 00 
  p->num_of_actual_pages_in_mem = 0;
80100ca0:	c7 87 84 03 00 00 00 	movl   $0x0,0x384(%edi)
80100ca7:	00 00 00 
  p->num_of_pages_in_swap_file = 0;
80100caa:	c7 87 80 03 00 00 00 	movl   $0x0,0x380(%edi)
80100cb1:	00 00 00 
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
80100cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->ram_pages[i].is_free = p->swapped_out_pages[i].is_free = 1;
80100cb8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
80100cbe:	83 c0 18             	add    $0x18,%eax
80100cc1:	c7 80 68 01 00 00 01 	movl   $0x1,0x168(%eax)
80100cc8:	00 00 00 
    p->ram_pages[i].aging_counter = p->swapped_out_pages[i].aging_counter = 0;
80100ccb:	c7 40 f0 00 00 00 00 	movl   $0x0,-0x10(%eax)
80100cd2:	c7 80 70 01 00 00 00 	movl   $0x0,0x170(%eax)
80100cd9:	00 00 00 
    p->ram_pages[i].swap_file_offset = p->swapped_out_pages[i].swap_file_offset = 0;
80100cdc:	c7 40 ec 00 00 00 00 	movl   $0x0,-0x14(%eax)
80100ce3:	c7 80 6c 01 00 00 00 	movl   $0x0,0x16c(%eax)
80100cea:	00 00 00 
    p->ram_pages[i].va = p->swapped_out_pages[i].va = 0;
80100ced:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
80100cf4:	c7 80 78 01 00 00 00 	movl   $0x0,0x178(%eax)
80100cfb:	00 00 00 
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
80100cfe:	39 c8                	cmp    %ecx,%eax
80100d00:	75 b6                	jne    80100cb8 <exec+0x1a8>
    createSwapFile(curproc);
80100d02:	83 ec 0c             	sub    $0xc,%esp
    swap_file_bu = curproc->swapFile;
80100d05:	8b 47 7c             	mov    0x7c(%edi),%eax
    createSwapFile(curproc);
80100d08:	57                   	push   %edi
    swap_file_bu = curproc->swapFile;
80100d09:	89 85 ec fb ff ff    	mov    %eax,-0x414(%ebp)
    createSwapFile(curproc);
80100d0f:	e8 9c 19 00 00       	call   801026b0 <createSwapFile>
80100d14:	83 c4 10             	add    $0x10,%esp
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d17:	66 83 bd 50 fc ff ff 	cmpw   $0x0,-0x3b0(%ebp)
80100d1e:	00 
80100d1f:	8b 9d 40 fc ff ff    	mov    -0x3c0(%ebp),%ebx
80100d25:	0f 84 17 04 00 00    	je     80101142 <exec+0x632>
80100d2b:	31 c0                	xor    %eax,%eax
80100d2d:	89 bd d8 fb ff ff    	mov    %edi,-0x428(%ebp)
  sz = 0;
80100d33:	c7 85 f0 fb ff ff 00 	movl   $0x0,-0x410(%ebp)
80100d3a:	00 00 00 
80100d3d:	89 c7                	mov    %eax,%edi
80100d3f:	e9 92 00 00 00       	jmp    80100dd6 <exec+0x2c6>
80100d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100d48:	83 bd 04 fc ff ff 01 	cmpl   $0x1,-0x3fc(%ebp)
80100d4f:	75 70                	jne    80100dc1 <exec+0x2b1>
    if(ph.memsz < ph.filesz)
80100d51:	8b 85 18 fc ff ff    	mov    -0x3e8(%ebp),%eax
80100d57:	3b 85 14 fc ff ff    	cmp    -0x3ec(%ebp),%eax
80100d5d:	0f 82 8f 00 00 00    	jb     80100df2 <exec+0x2e2>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100d63:	03 85 0c fc ff ff    	add    -0x3f4(%ebp),%eax
80100d69:	0f 82 83 00 00 00    	jb     80100df2 <exec+0x2e2>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100d6f:	83 ec 04             	sub    $0x4,%esp
80100d72:	50                   	push   %eax
80100d73:	ff b5 f0 fb ff ff    	pushl  -0x410(%ebp)
80100d79:	ff b5 f4 fb ff ff    	pushl  -0x40c(%ebp)
80100d7f:	e8 dc 6e 00 00       	call   80107c60 <allocuvm>
80100d84:	83 c4 10             	add    $0x10,%esp
80100d87:	89 85 f0 fb ff ff    	mov    %eax,-0x410(%ebp)
80100d8d:	85 c0                	test   %eax,%eax
80100d8f:	74 61                	je     80100df2 <exec+0x2e2>
    if(ph.vaddr % PGSIZE != 0)
80100d91:	8b 85 0c fc ff ff    	mov    -0x3f4(%ebp),%eax
80100d97:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100d9c:	75 54                	jne    80100df2 <exec+0x2e2>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100d9e:	83 ec 0c             	sub    $0xc,%esp
80100da1:	ff b5 14 fc ff ff    	pushl  -0x3ec(%ebp)
80100da7:	ff b5 08 fc ff ff    	pushl  -0x3f8(%ebp)
80100dad:	56                   	push   %esi
80100dae:	50                   	push   %eax
80100daf:	ff b5 f4 fb ff ff    	pushl  -0x40c(%ebp)
80100db5:	e8 66 68 00 00       	call   80107620 <loaduvm>
80100dba:	83 c4 20             	add    $0x20,%esp
80100dbd:	85 c0                	test   %eax,%eax
80100dbf:	78 31                	js     80100df2 <exec+0x2e2>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100dc1:	0f b7 85 50 fc ff ff 	movzwl -0x3b0(%ebp),%eax
80100dc8:	83 c7 01             	add    $0x1,%edi
80100dcb:	83 c3 20             	add    $0x20,%ebx
80100dce:	39 f8                	cmp    %edi,%eax
80100dd0:	0f 8e 71 01 00 00    	jle    80100f47 <exec+0x437>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100dd6:	8d 85 04 fc ff ff    	lea    -0x3fc(%ebp),%eax
80100ddc:	6a 20                	push   $0x20
80100dde:	53                   	push   %ebx
80100ddf:	50                   	push   %eax
80100de0:	56                   	push   %esi
80100de1:	e8 3a 10 00 00       	call   80101e20 <readi>
80100de6:	83 c4 10             	add    $0x10,%esp
80100de9:	83 f8 20             	cmp    $0x20,%eax
80100dec:	0f 84 56 ff ff ff    	je     80100d48 <exec+0x238>
80100df2:	8b bd d8 fb ff ff    	mov    -0x428(%ebp),%edi
    if (curproc->pid > 2){
80100df8:	83 7f 10 02          	cmpl   $0x2,0x10(%edi)
80100dfc:	0f 8e 7a 03 00 00    	jle    8010117c <exec+0x66c>
      curproc->num_of_pagefaults_occurs = pg_flt_bu;
80100e02:	8b 85 e4 fb ff ff    	mov    -0x41c(%ebp),%eax
80100e08:	8d 9d e8 fc ff ff    	lea    -0x318(%ebp),%ebx
80100e0e:	8d 8d 68 fe ff ff    	lea    -0x198(%ebp),%ecx
80100e14:	89 87 88 03 00 00    	mov    %eax,0x388(%edi)
      curproc->num_of_actual_pages_in_mem = pg_mem_bu;
80100e1a:	8b 85 e0 fb ff ff    	mov    -0x420(%ebp),%eax
80100e20:	89 87 84 03 00 00    	mov    %eax,0x384(%edi)
      curproc->num_of_pages_in_swap_file = pg_swp_bu;
80100e26:	8b 85 dc fb ff ff    	mov    -0x424(%ebp),%eax
80100e2c:	89 87 80 03 00 00    	mov    %eax,0x380(%edi)
      curproc->num_of_pageOut_occured = pg_out_bu;
80100e32:	8b 85 e8 fb ff ff    	mov    -0x418(%ebp),%eax
80100e38:	89 87 8c 03 00 00    	mov    %eax,0x38c(%edi)
80100e3e:	31 c0                	xor    %eax,%eax
        curproc->ram_pages[i] = mem_pginfo_bu[i];
80100e40:	8b 14 03             	mov    (%ebx,%eax,1),%edx
80100e43:	89 94 07 00 02 00 00 	mov    %edx,0x200(%edi,%eax,1)
80100e4a:	8b 54 03 04          	mov    0x4(%ebx,%eax,1),%edx
80100e4e:	89 94 07 04 02 00 00 	mov    %edx,0x204(%edi,%eax,1)
80100e55:	8b 54 03 08          	mov    0x8(%ebx,%eax,1),%edx
80100e59:	89 94 07 08 02 00 00 	mov    %edx,0x208(%edi,%eax,1)
80100e60:	8b 54 03 0c          	mov    0xc(%ebx,%eax,1),%edx
80100e64:	89 94 07 0c 02 00 00 	mov    %edx,0x20c(%edi,%eax,1)
80100e6b:	8b 54 03 10          	mov    0x10(%ebx,%eax,1),%edx
80100e6f:	89 94 07 10 02 00 00 	mov    %edx,0x210(%edi,%eax,1)
80100e76:	8b 54 03 14          	mov    0x14(%ebx,%eax,1),%edx
80100e7a:	89 94 07 14 02 00 00 	mov    %edx,0x214(%edi,%eax,1)
        curproc->swapped_out_pages[i] = swp_pginfo_bu[i];
80100e81:	8b 14 01             	mov    (%ecx,%eax,1),%edx
80100e84:	89 94 07 80 00 00 00 	mov    %edx,0x80(%edi,%eax,1)
80100e8b:	8b 54 01 04          	mov    0x4(%ecx,%eax,1),%edx
80100e8f:	89 94 07 84 00 00 00 	mov    %edx,0x84(%edi,%eax,1)
80100e96:	8b 54 01 08          	mov    0x8(%ecx,%eax,1),%edx
80100e9a:	89 94 07 88 00 00 00 	mov    %edx,0x88(%edi,%eax,1)
80100ea1:	8b 54 01 0c          	mov    0xc(%ecx,%eax,1),%edx
80100ea5:	89 94 07 8c 00 00 00 	mov    %edx,0x8c(%edi,%eax,1)
80100eac:	8b 54 01 10          	mov    0x10(%ecx,%eax,1),%edx
80100eb0:	89 94 07 90 00 00 00 	mov    %edx,0x90(%edi,%eax,1)
80100eb7:	8b 54 01 14          	mov    0x14(%ecx,%eax,1),%edx
80100ebb:	89 94 07 94 00 00 00 	mov    %edx,0x94(%edi,%eax,1)
      for (int i = 0; i < MAX_PYSC_PAGES; i++){
80100ec2:	83 c0 18             	add    $0x18,%eax
80100ec5:	3d 80 01 00 00       	cmp    $0x180,%eax
80100eca:	0f 85 70 ff ff ff    	jne    80100e40 <exec+0x330>
      removeSwapFile(curproc);
80100ed0:	83 ec 0c             	sub    $0xc,%esp
80100ed3:	57                   	push   %edi
80100ed4:	e8 e7 15 00 00       	call   801024c0 <removeSwapFile>
      curproc->swapFile = swap_file_bu;
80100ed9:	8b 85 ec fb ff ff    	mov    -0x414(%ebp),%eax
80100edf:	89 47 7c             	mov    %eax,0x7c(%edi)
    freevm(pgdir);
80100ee2:	58                   	pop    %eax
80100ee3:	ff b5 f4 fb ff ff    	pushl  -0x40c(%ebp)
80100ee9:	e8 52 69 00 00       	call   80107840 <freevm>
  if(ip){
80100eee:	83 c4 10             	add    $0x10,%esp
80100ef1:	85 f6                	test   %esi,%esi
80100ef3:	0f 85 6d fc ff ff    	jne    80100b66 <exec+0x56>
}
80100ef9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80100efc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f01:	5b                   	pop    %ebx
80100f02:	5e                   	pop    %esi
80100f03:	5f                   	pop    %edi
80100f04:	5d                   	pop    %ebp
80100f05:	c3                   	ret    
80100f06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f0d:	8d 76 00             	lea    0x0(%esi),%esi
  struct file* swap_file_bu = 0;
80100f10:	c7 85 ec fb ff ff 00 	movl   $0x0,-0x414(%ebp)
80100f17:	00 00 00 
  uint pg_out_bu = 0, pg_flt_bu = 0, pg_mem_bu = 0, pg_swp_bu = 0;
80100f1a:	c7 85 dc fb ff ff 00 	movl   $0x0,-0x424(%ebp)
80100f21:	00 00 00 
80100f24:	c7 85 e0 fb ff ff 00 	movl   $0x0,-0x420(%ebp)
80100f2b:	00 00 00 
80100f2e:	c7 85 e4 fb ff ff 00 	movl   $0x0,-0x41c(%ebp)
80100f35:	00 00 00 
80100f38:	c7 85 e8 fb ff ff 00 	movl   $0x0,-0x418(%ebp)
80100f3f:	00 00 00 
80100f42:	e9 d0 fd ff ff       	jmp    80100d17 <exec+0x207>
80100f47:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
80100f4d:	8b bd d8 fb ff ff    	mov    -0x428(%ebp),%edi
80100f53:	05 ff 0f 00 00       	add    $0xfff,%eax
80100f58:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100f5d:	8d 98 00 20 00 00    	lea    0x2000(%eax),%ebx
  iunlockput(ip);
80100f63:	83 ec 0c             	sub    $0xc,%esp
80100f66:	89 85 f0 fb ff ff    	mov    %eax,-0x410(%ebp)
80100f6c:	56                   	push   %esi
80100f6d:	e8 4e 0e 00 00       	call   80101dc0 <iunlockput>
  end_op();
80100f72:	e8 69 25 00 00       	call   801034e0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100f77:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
80100f7d:	8b b5 f4 fb ff ff    	mov    -0x40c(%ebp),%esi
80100f83:	83 c4 0c             	add    $0xc,%esp
80100f86:	53                   	push   %ebx
80100f87:	50                   	push   %eax
80100f88:	56                   	push   %esi
80100f89:	e8 d2 6c 00 00       	call   80107c60 <allocuvm>
80100f8e:	83 c4 10             	add    $0x10,%esp
80100f91:	89 85 f0 fb ff ff    	mov    %eax,-0x410(%ebp)
80100f97:	89 c3                	mov    %eax,%ebx
80100f99:	85 c0                	test   %eax,%eax
80100f9b:	0f 84 94 00 00 00    	je     80101035 <exec+0x525>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100fa1:	83 ec 08             	sub    $0x8,%esp
80100fa4:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100faa:	50                   	push   %eax
80100fab:	56                   	push   %esi
  for(argc = 0; argv[argc]; argc++) {
80100fac:	31 f6                	xor    %esi,%esi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100fae:	e8 ad 69 00 00       	call   80107960 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100fb3:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fb6:	83 c4 10             	add    $0x10,%esp
80100fb9:	8b 00                	mov    (%eax),%eax
80100fbb:	85 c0                	test   %eax,%eax
80100fbd:	0f 84 a8 01 00 00    	je     8010116b <exec+0x65b>
80100fc3:	89 bd d8 fb ff ff    	mov    %edi,-0x428(%ebp)
80100fc9:	89 f7                	mov    %esi,%edi
80100fcb:	8b b5 f4 fb ff ff    	mov    -0x40c(%ebp),%esi
80100fd1:	eb 28                	jmp    80100ffb <exec+0x4eb>
80100fd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100fd7:	90                   	nop
80100fd8:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100fdb:	89 9c bd 64 fc ff ff 	mov    %ebx,-0x39c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100fe2:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100fe5:	8d 8d 58 fc ff ff    	lea    -0x3a8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80100feb:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100fee:	85 c0                	test   %eax,%eax
80100ff0:	0f 84 81 00 00 00    	je     80101077 <exec+0x567>
    if(argc >= MAXARG)
80100ff6:	83 ff 20             	cmp    $0x20,%edi
80100ff9:	74 34                	je     8010102f <exec+0x51f>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ffb:	83 ec 0c             	sub    $0xc,%esp
80100ffe:	50                   	push   %eax
80100fff:	e8 3c 42 00 00       	call   80105240 <strlen>
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101004:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101005:	f7 d0                	not    %eax
80101007:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101009:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
8010100c:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
8010100f:	ff 34 b8             	pushl  (%eax,%edi,4)
80101012:	e8 29 42 00 00       	call   80105240 <strlen>
80101017:	83 c0 01             	add    $0x1,%eax
8010101a:	50                   	push   %eax
8010101b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010101e:	ff 34 b8             	pushl  (%eax,%edi,4)
80101021:	53                   	push   %ebx
80101022:	56                   	push   %esi
80101023:	e8 98 6a 00 00       	call   80107ac0 <copyout>
80101028:	83 c4 20             	add    $0x20,%esp
8010102b:	85 c0                	test   %eax,%eax
8010102d:	79 a9                	jns    80100fd8 <exec+0x4c8>
8010102f:	8b bd d8 fb ff ff    	mov    -0x428(%ebp),%edi
    if (curproc->pid > 2){
80101035:	83 7f 10 02          	cmpl   $0x2,0x10(%edi)
80101039:	7f 16                	jg     80101051 <exec+0x541>
    freevm(pgdir);
8010103b:	83 ec 0c             	sub    $0xc,%esp
8010103e:	ff b5 f4 fb ff ff    	pushl  -0x40c(%ebp)
80101044:	e8 f7 67 00 00       	call   80107840 <freevm>
80101049:	83 c4 10             	add    $0x10,%esp
8010104c:	e9 a8 fe ff ff       	jmp    80100ef9 <exec+0x3e9>
  ip = 0;
80101051:	31 f6                	xor    %esi,%esi
80101053:	e9 aa fd ff ff       	jmp    80100e02 <exec+0x2f2>
    end_op();
80101058:	e8 83 24 00 00       	call   801034e0 <end_op>
    cprintf("exec: fail\n");
8010105d:	83 ec 0c             	sub    $0xc,%esp
80101060:	68 e1 80 10 80       	push   $0x801080e1
80101065:	e8 46 f6 ff ff       	call   801006b0 <cprintf>
    return -1;
8010106a:	83 c4 10             	add    $0x10,%esp
8010106d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101072:	e9 05 fb ff ff       	jmp    80100b7c <exec+0x6c>
80101077:	89 fe                	mov    %edi,%esi
80101079:	8b bd d8 fb ff ff    	mov    -0x428(%ebp),%edi
  ustack[3+argc] = 0;
8010107f:	c7 84 b5 64 fc ff ff 	movl   $0x0,-0x39c(%ebp,%esi,4)
80101086:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010108a:	8d 04 b5 04 00 00 00 	lea    0x4(,%esi,4),%eax
  ustack[1] = argc;
80101091:	89 b5 5c fc ff ff    	mov    %esi,-0x3a4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80101097:	89 de                	mov    %ebx,%esi
  ustack[0] = 0xffffffff;  // fake return PC
80101099:	c7 85 58 fc ff ff ff 	movl   $0xffffffff,-0x3a8(%ebp)
801010a0:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801010a3:	29 c6                	sub    %eax,%esi
  sp -= (3+argc+1) * 4;
801010a5:	83 c0 0c             	add    $0xc,%eax
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801010a8:	89 b5 60 fc ff ff    	mov    %esi,-0x3a0(%ebp)
  sp -= (3+argc+1) * 4;
801010ae:	89 de                	mov    %ebx,%esi
801010b0:	29 c6                	sub    %eax,%esi
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
801010b2:	50                   	push   %eax
801010b3:	51                   	push   %ecx
801010b4:	56                   	push   %esi
801010b5:	ff b5 f4 fb ff ff    	pushl  -0x40c(%ebp)
801010bb:	e8 00 6a 00 00       	call   80107ac0 <copyout>
801010c0:	83 c4 10             	add    $0x10,%esp
801010c3:	85 c0                	test   %eax,%eax
801010c5:	0f 88 6a ff ff ff    	js     80101035 <exec+0x525>
  for(last=s=path; *s; s++)
801010cb:	8b 45 08             	mov    0x8(%ebp),%eax
801010ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
801010d1:	0f b6 00             	movzbl (%eax),%eax
801010d4:	84 c0                	test   %al,%al
801010d6:	74 11                	je     801010e9 <exec+0x5d9>
801010d8:	89 ca                	mov    %ecx,%edx
    if(*s == '/')
801010da:	83 c2 01             	add    $0x1,%edx
801010dd:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
801010df:	0f b6 02             	movzbl (%edx),%eax
    if(*s == '/')
801010e2:	0f 44 ca             	cmove  %edx,%ecx
  for(last=s=path; *s; s++)
801010e5:	84 c0                	test   %al,%al
801010e7:	75 f1                	jne    801010da <exec+0x5ca>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
801010e9:	83 ec 04             	sub    $0x4,%esp
801010ec:	8d 47 6c             	lea    0x6c(%edi),%eax
801010ef:	6a 10                	push   $0x10
801010f1:	51                   	push   %ecx
801010f2:	50                   	push   %eax
801010f3:	e8 08 41 00 00       	call   80105200 <safestrcpy>
  curproc->pgdir = pgdir;
801010f8:	8b 85 f4 fb ff ff    	mov    -0x40c(%ebp),%eax
  oldpgdir = curproc->pgdir;
801010fe:	8b 5f 04             	mov    0x4(%edi),%ebx
  if (curproc->pid > 2){
80101101:	83 c4 10             	add    $0x10,%esp
  curproc->pgdir = pgdir;
80101104:	89 47 04             	mov    %eax,0x4(%edi)
  curproc->sz = sz;
80101107:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
8010110d:	89 07                	mov    %eax,(%edi)
  curproc->tf->eip = elf.entry;  // main
8010110f:	8b 47 18             	mov    0x18(%edi),%eax
80101112:	8b 8d 3c fc ff ff    	mov    -0x3c4(%ebp),%ecx
80101118:	89 48 38             	mov    %ecx,0x38(%eax)
  curproc->tf->esp = sp;
8010111b:	8b 47 18             	mov    0x18(%edi),%eax
8010111e:	89 70 44             	mov    %esi,0x44(%eax)
  if (curproc->pid > 2){
80101121:	83 7f 10 02          	cmpl   $0x2,0x10(%edi)
80101125:	7f 27                	jg     8010114e <exec+0x63e>
  switchuvm(curproc);
80101127:	83 ec 0c             	sub    $0xc,%esp
8010112a:	57                   	push   %edi
8010112b:	e8 60 63 00 00       	call   80107490 <switchuvm>
  freevm(oldpgdir);
80101130:	89 1c 24             	mov    %ebx,(%esp)
80101133:	e8 08 67 00 00       	call   80107840 <freevm>
  return 0;
80101138:	83 c4 10             	add    $0x10,%esp
8010113b:	31 c0                	xor    %eax,%eax
8010113d:	e9 3a fa ff ff       	jmp    80100b7c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101142:	31 c0                	xor    %eax,%eax
80101144:	bb 00 20 00 00       	mov    $0x2000,%ebx
80101149:	e9 15 fe ff ff       	jmp    80100f63 <exec+0x453>
    curproc->swapFile = swap_file_bu;
8010114e:	8b 85 ec fb ff ff    	mov    -0x414(%ebp),%eax
    removeSwapFile(curproc);
80101154:	83 ec 0c             	sub    $0xc,%esp
    temp_swap_file = curproc->swapFile;
80101157:	8b 77 7c             	mov    0x7c(%edi),%esi
    curproc->swapFile = swap_file_bu;
8010115a:	89 47 7c             	mov    %eax,0x7c(%edi)
    removeSwapFile(curproc);
8010115d:	57                   	push   %edi
8010115e:	e8 5d 13 00 00       	call   801024c0 <removeSwapFile>
    curproc->swapFile = temp_swap_file;
80101163:	89 77 7c             	mov    %esi,0x7c(%edi)
80101166:	83 c4 10             	add    $0x10,%esp
80101169:	eb bc                	jmp    80101127 <exec+0x617>
  for(argc = 0; argv[argc]; argc++) {
8010116b:	8b 9d f0 fb ff ff    	mov    -0x410(%ebp),%ebx
80101171:	8d 8d 58 fc ff ff    	lea    -0x3a8(%ebp),%ecx
80101177:	e9 03 ff ff ff       	jmp    8010107f <exec+0x56f>
    freevm(pgdir);
8010117c:	83 ec 0c             	sub    $0xc,%esp
8010117f:	ff b5 f4 fb ff ff    	pushl  -0x40c(%ebp)
80101185:	e8 b6 66 00 00       	call   80107840 <freevm>
8010118a:	83 c4 10             	add    $0x10,%esp
8010118d:	e9 d4 f9 ff ff       	jmp    80100b66 <exec+0x56>
80101192:	66 90                	xchg   %ax,%ax
80101194:	66 90                	xchg   %ax,%ax
80101196:	66 90                	xchg   %ax,%ax
80101198:	66 90                	xchg   %ax,%ax
8010119a:	66 90                	xchg   %ax,%ax
8010119c:	66 90                	xchg   %ax,%ax
8010119e:	66 90                	xchg   %ax,%ax

801011a0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
801011a0:	f3 0f 1e fb          	endbr32 
801011a4:	55                   	push   %ebp
801011a5:	89 e5                	mov    %esp,%ebp
801011a7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
801011aa:	68 ed 80 10 80       	push   $0x801080ed
801011af:	68 e0 0f 11 80       	push   $0x80110fe0
801011b4:	e8 f7 3b 00 00       	call   80104db0 <initlock>
}
801011b9:	83 c4 10             	add    $0x10,%esp
801011bc:	c9                   	leave  
801011bd:	c3                   	ret    
801011be:	66 90                	xchg   %ax,%ax

801011c0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
801011c0:	f3 0f 1e fb          	endbr32 
801011c4:	55                   	push   %ebp
801011c5:	89 e5                	mov    %esp,%ebp
801011c7:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801011c8:	bb 14 10 11 80       	mov    $0x80111014,%ebx
{
801011cd:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
801011d0:	68 e0 0f 11 80       	push   $0x80110fe0
801011d5:	e8 56 3d 00 00       	call   80104f30 <acquire>
801011da:	83 c4 10             	add    $0x10,%esp
801011dd:	eb 0c                	jmp    801011eb <filealloc+0x2b>
801011df:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801011e0:	83 c3 18             	add    $0x18,%ebx
801011e3:	81 fb 74 19 11 80    	cmp    $0x80111974,%ebx
801011e9:	74 25                	je     80101210 <filealloc+0x50>
    if(f->ref == 0){
801011eb:	8b 43 04             	mov    0x4(%ebx),%eax
801011ee:	85 c0                	test   %eax,%eax
801011f0:	75 ee                	jne    801011e0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
801011f2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
801011f5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
801011fc:	68 e0 0f 11 80       	push   $0x80110fe0
80101201:	e8 ea 3d 00 00       	call   80104ff0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80101206:	89 d8                	mov    %ebx,%eax
      return f;
80101208:	83 c4 10             	add    $0x10,%esp
}
8010120b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010120e:	c9                   	leave  
8010120f:	c3                   	ret    
  release(&ftable.lock);
80101210:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80101213:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80101215:	68 e0 0f 11 80       	push   $0x80110fe0
8010121a:	e8 d1 3d 00 00       	call   80104ff0 <release>
}
8010121f:	89 d8                	mov    %ebx,%eax
  return 0;
80101221:	83 c4 10             	add    $0x10,%esp
}
80101224:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101227:	c9                   	leave  
80101228:	c3                   	ret    
80101229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101230 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101230:	f3 0f 1e fb          	endbr32 
80101234:	55                   	push   %ebp
80101235:	89 e5                	mov    %esp,%ebp
80101237:	53                   	push   %ebx
80101238:	83 ec 10             	sub    $0x10,%esp
8010123b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
8010123e:	68 e0 0f 11 80       	push   $0x80110fe0
80101243:	e8 e8 3c 00 00       	call   80104f30 <acquire>
  if(f->ref < 1)
80101248:	8b 43 04             	mov    0x4(%ebx),%eax
8010124b:	83 c4 10             	add    $0x10,%esp
8010124e:	85 c0                	test   %eax,%eax
80101250:	7e 1a                	jle    8010126c <filedup+0x3c>
    panic("filedup");
  f->ref++;
80101252:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80101255:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80101258:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
8010125b:	68 e0 0f 11 80       	push   $0x80110fe0
80101260:	e8 8b 3d 00 00       	call   80104ff0 <release>
  return f;
}
80101265:	89 d8                	mov    %ebx,%eax
80101267:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010126a:	c9                   	leave  
8010126b:	c3                   	ret    
    panic("filedup");
8010126c:	83 ec 0c             	sub    $0xc,%esp
8010126f:	68 f4 80 10 80       	push   $0x801080f4
80101274:	e8 17 f1 ff ff       	call   80100390 <panic>
80101279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101280 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101280:	f3 0f 1e fb          	endbr32 
80101284:	55                   	push   %ebp
80101285:	89 e5                	mov    %esp,%ebp
80101287:	57                   	push   %edi
80101288:	56                   	push   %esi
80101289:	53                   	push   %ebx
8010128a:	83 ec 28             	sub    $0x28,%esp
8010128d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80101290:	68 e0 0f 11 80       	push   $0x80110fe0
80101295:	e8 96 3c 00 00       	call   80104f30 <acquire>
  if(f->ref < 1)
8010129a:	8b 53 04             	mov    0x4(%ebx),%edx
8010129d:	83 c4 10             	add    $0x10,%esp
801012a0:	85 d2                	test   %edx,%edx
801012a2:	0f 8e a1 00 00 00    	jle    80101349 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
801012a8:	83 ea 01             	sub    $0x1,%edx
801012ab:	89 53 04             	mov    %edx,0x4(%ebx)
801012ae:	75 40                	jne    801012f0 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
801012b0:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
801012b4:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
801012b7:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
801012b9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
801012bf:	8b 73 0c             	mov    0xc(%ebx),%esi
801012c2:	88 45 e7             	mov    %al,-0x19(%ebp)
801012c5:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
801012c8:	68 e0 0f 11 80       	push   $0x80110fe0
  ff = *f;
801012cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
801012d0:	e8 1b 3d 00 00       	call   80104ff0 <release>

  if(ff.type == FD_PIPE)
801012d5:	83 c4 10             	add    $0x10,%esp
801012d8:	83 ff 01             	cmp    $0x1,%edi
801012db:	74 53                	je     80101330 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
801012dd:	83 ff 02             	cmp    $0x2,%edi
801012e0:	74 26                	je     80101308 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
801012e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012e5:	5b                   	pop    %ebx
801012e6:	5e                   	pop    %esi
801012e7:	5f                   	pop    %edi
801012e8:	5d                   	pop    %ebp
801012e9:	c3                   	ret    
801012ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
801012f0:	c7 45 08 e0 0f 11 80 	movl   $0x80110fe0,0x8(%ebp)
}
801012f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012fa:	5b                   	pop    %ebx
801012fb:	5e                   	pop    %esi
801012fc:	5f                   	pop    %edi
801012fd:	5d                   	pop    %ebp
    release(&ftable.lock);
801012fe:	e9 ed 3c 00 00       	jmp    80104ff0 <release>
80101303:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101307:	90                   	nop
    begin_op();
80101308:	e8 63 21 00 00       	call   80103470 <begin_op>
    iput(ff.ip);
8010130d:	83 ec 0c             	sub    $0xc,%esp
80101310:	ff 75 e0             	pushl  -0x20(%ebp)
80101313:	e8 38 09 00 00       	call   80101c50 <iput>
    end_op();
80101318:	83 c4 10             	add    $0x10,%esp
}
8010131b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010131e:	5b                   	pop    %ebx
8010131f:	5e                   	pop    %esi
80101320:	5f                   	pop    %edi
80101321:	5d                   	pop    %ebp
    end_op();
80101322:	e9 b9 21 00 00       	jmp    801034e0 <end_op>
80101327:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010132e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80101330:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80101334:	83 ec 08             	sub    $0x8,%esp
80101337:	53                   	push   %ebx
80101338:	56                   	push   %esi
80101339:	e8 02 29 00 00       	call   80103c40 <pipeclose>
8010133e:	83 c4 10             	add    $0x10,%esp
}
80101341:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101344:	5b                   	pop    %ebx
80101345:	5e                   	pop    %esi
80101346:	5f                   	pop    %edi
80101347:	5d                   	pop    %ebp
80101348:	c3                   	ret    
    panic("fileclose");
80101349:	83 ec 0c             	sub    $0xc,%esp
8010134c:	68 fc 80 10 80       	push   $0x801080fc
80101351:	e8 3a f0 ff ff       	call   80100390 <panic>
80101356:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010135d:	8d 76 00             	lea    0x0(%esi),%esi

80101360 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101360:	f3 0f 1e fb          	endbr32 
80101364:	55                   	push   %ebp
80101365:	89 e5                	mov    %esp,%ebp
80101367:	53                   	push   %ebx
80101368:	83 ec 04             	sub    $0x4,%esp
8010136b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010136e:	83 3b 02             	cmpl   $0x2,(%ebx)
80101371:	75 2d                	jne    801013a0 <filestat+0x40>
    ilock(f->ip);
80101373:	83 ec 0c             	sub    $0xc,%esp
80101376:	ff 73 10             	pushl  0x10(%ebx)
80101379:	e8 a2 07 00 00       	call   80101b20 <ilock>
    stati(f->ip, st);
8010137e:	58                   	pop    %eax
8010137f:	5a                   	pop    %edx
80101380:	ff 75 0c             	pushl  0xc(%ebp)
80101383:	ff 73 10             	pushl  0x10(%ebx)
80101386:	e8 65 0a 00 00       	call   80101df0 <stati>
    iunlock(f->ip);
8010138b:	59                   	pop    %ecx
8010138c:	ff 73 10             	pushl  0x10(%ebx)
8010138f:	e8 6c 08 00 00       	call   80101c00 <iunlock>
    return 0;
  }
  return -1;
}
80101394:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101397:	83 c4 10             	add    $0x10,%esp
8010139a:	31 c0                	xor    %eax,%eax
}
8010139c:	c9                   	leave  
8010139d:	c3                   	ret    
8010139e:	66 90                	xchg   %ax,%ax
801013a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801013a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801013a8:	c9                   	leave  
801013a9:	c3                   	ret    
801013aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801013b0 <fileread>:

// Read from file f.
int
fileread(struct file* f, char *addr, int n)
{
801013b0:	f3 0f 1e fb          	endbr32 
801013b4:	55                   	push   %ebp
801013b5:	89 e5                	mov    %esp,%ebp
801013b7:	57                   	push   %edi
801013b8:	56                   	push   %esi
801013b9:	53                   	push   %ebx
801013ba:	83 ec 0c             	sub    $0xc,%esp
801013bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
801013c0:	8b 75 0c             	mov    0xc(%ebp),%esi
801013c3:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
801013c6:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
801013ca:	74 64                	je     80101430 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
801013cc:	8b 03                	mov    (%ebx),%eax
801013ce:	83 f8 01             	cmp    $0x1,%eax
801013d1:	74 45                	je     80101418 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
801013d3:	83 f8 02             	cmp    $0x2,%eax
801013d6:	75 5f                	jne    80101437 <fileread+0x87>
    ilock(f->ip);
801013d8:	83 ec 0c             	sub    $0xc,%esp
801013db:	ff 73 10             	pushl  0x10(%ebx)
801013de:	e8 3d 07 00 00       	call   80101b20 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801013e3:	57                   	push   %edi
801013e4:	ff 73 14             	pushl  0x14(%ebx)
801013e7:	56                   	push   %esi
801013e8:	ff 73 10             	pushl  0x10(%ebx)
801013eb:	e8 30 0a 00 00       	call   80101e20 <readi>
801013f0:	83 c4 20             	add    $0x20,%esp
801013f3:	89 c6                	mov    %eax,%esi
801013f5:	85 c0                	test   %eax,%eax
801013f7:	7e 03                	jle    801013fc <fileread+0x4c>
      f->off += r;
801013f9:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801013fc:	83 ec 0c             	sub    $0xc,%esp
801013ff:	ff 73 10             	pushl  0x10(%ebx)
80101402:	e8 f9 07 00 00       	call   80101c00 <iunlock>
    return r;
80101407:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
8010140a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010140d:	89 f0                	mov    %esi,%eax
8010140f:	5b                   	pop    %ebx
80101410:	5e                   	pop    %esi
80101411:	5f                   	pop    %edi
80101412:	5d                   	pop    %ebp
80101413:	c3                   	ret    
80101414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
80101418:	8b 43 0c             	mov    0xc(%ebx),%eax
8010141b:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010141e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101421:	5b                   	pop    %ebx
80101422:	5e                   	pop    %esi
80101423:	5f                   	pop    %edi
80101424:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80101425:	e9 b6 29 00 00       	jmp    80103de0 <piperead>
8010142a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101430:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101435:	eb d3                	jmp    8010140a <fileread+0x5a>
  panic("fileread");
80101437:	83 ec 0c             	sub    $0xc,%esp
8010143a:	68 06 81 10 80       	push   $0x80108106
8010143f:	e8 4c ef ff ff       	call   80100390 <panic>
80101444:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010144b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010144f:	90                   	nop

80101450 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101450:	f3 0f 1e fb          	endbr32 
80101454:	55                   	push   %ebp
80101455:	89 e5                	mov    %esp,%ebp
80101457:	57                   	push   %edi
80101458:	56                   	push   %esi
80101459:	53                   	push   %ebx
8010145a:	83 ec 1c             	sub    $0x1c,%esp
8010145d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101460:	8b 75 08             	mov    0x8(%ebp),%esi
80101463:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101466:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101469:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
8010146d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
80101470:	0f 84 c1 00 00 00    	je     80101537 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
80101476:	8b 06                	mov    (%esi),%eax
80101478:	83 f8 01             	cmp    $0x1,%eax
8010147b:	0f 84 c3 00 00 00    	je     80101544 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101481:	83 f8 02             	cmp    $0x2,%eax
80101484:	0f 85 cc 00 00 00    	jne    80101556 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010148a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
8010148d:	31 ff                	xor    %edi,%edi
    while(i < n){
8010148f:	85 c0                	test   %eax,%eax
80101491:	7f 34                	jg     801014c7 <filewrite+0x77>
80101493:	e9 98 00 00 00       	jmp    80101530 <filewrite+0xe0>
80101498:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010149f:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801014a0:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801014a3:	83 ec 0c             	sub    $0xc,%esp
801014a6:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801014a9:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801014ac:	e8 4f 07 00 00       	call   80101c00 <iunlock>
      end_op();
801014b1:	e8 2a 20 00 00       	call   801034e0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801014b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801014b9:	83 c4 10             	add    $0x10,%esp
801014bc:	39 c3                	cmp    %eax,%ebx
801014be:	75 60                	jne    80101520 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
801014c0:	01 df                	add    %ebx,%edi
    while(i < n){
801014c2:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801014c5:	7e 69                	jle    80101530 <filewrite+0xe0>
      int n1 = n - i;
801014c7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801014ca:	b8 00 06 00 00       	mov    $0x600,%eax
801014cf:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
801014d1:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
801014d7:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
801014da:	e8 91 1f 00 00       	call   80103470 <begin_op>
      ilock(f->ip);
801014df:	83 ec 0c             	sub    $0xc,%esp
801014e2:	ff 76 10             	pushl  0x10(%esi)
801014e5:	e8 36 06 00 00       	call   80101b20 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801014ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
801014ed:	53                   	push   %ebx
801014ee:	ff 76 14             	pushl  0x14(%esi)
801014f1:	01 f8                	add    %edi,%eax
801014f3:	50                   	push   %eax
801014f4:	ff 76 10             	pushl  0x10(%esi)
801014f7:	e8 24 0a 00 00       	call   80101f20 <writei>
801014fc:	83 c4 20             	add    $0x20,%esp
801014ff:	85 c0                	test   %eax,%eax
80101501:	7f 9d                	jg     801014a0 <filewrite+0x50>
      iunlock(f->ip);
80101503:	83 ec 0c             	sub    $0xc,%esp
80101506:	ff 76 10             	pushl  0x10(%esi)
80101509:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010150c:	e8 ef 06 00 00       	call   80101c00 <iunlock>
      end_op();
80101511:	e8 ca 1f 00 00       	call   801034e0 <end_op>
      if(r < 0)
80101516:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101519:	83 c4 10             	add    $0x10,%esp
8010151c:	85 c0                	test   %eax,%eax
8010151e:	75 17                	jne    80101537 <filewrite+0xe7>
        panic("short filewrite");
80101520:	83 ec 0c             	sub    $0xc,%esp
80101523:	68 0f 81 10 80       	push   $0x8010810f
80101528:	e8 63 ee ff ff       	call   80100390 <panic>
8010152d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101530:	89 f8                	mov    %edi,%eax
80101532:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101535:	74 05                	je     8010153c <filewrite+0xec>
80101537:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
8010153c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010153f:	5b                   	pop    %ebx
80101540:	5e                   	pop    %esi
80101541:	5f                   	pop    %edi
80101542:	5d                   	pop    %ebp
80101543:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
80101544:	8b 46 0c             	mov    0xc(%esi),%eax
80101547:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010154a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010154d:	5b                   	pop    %ebx
8010154e:	5e                   	pop    %esi
8010154f:	5f                   	pop    %edi
80101550:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101551:	e9 8a 27 00 00       	jmp    80103ce0 <pipewrite>
  panic("filewrite");
80101556:	83 ec 0c             	sub    $0xc,%esp
80101559:	68 15 81 10 80       	push   $0x80108115
8010155e:	e8 2d ee ff ff       	call   80100390 <panic>
80101563:	66 90                	xchg   %ax,%ax
80101565:	66 90                	xchg   %ax,%ax
80101567:	66 90                	xchg   %ax,%ax
80101569:	66 90                	xchg   %ax,%ax
8010156b:	66 90                	xchg   %ax,%ax
8010156d:	66 90                	xchg   %ax,%ax
8010156f:	90                   	nop

80101570 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101570:	55                   	push   %ebp
80101571:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101573:	89 d0                	mov    %edx,%eax
80101575:	c1 e8 0c             	shr    $0xc,%eax
80101578:	03 05 f8 19 11 80    	add    0x801119f8,%eax
{
8010157e:	89 e5                	mov    %esp,%ebp
80101580:	56                   	push   %esi
80101581:	53                   	push   %ebx
80101582:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101584:	83 ec 08             	sub    $0x8,%esp
80101587:	50                   	push   %eax
80101588:	51                   	push   %ecx
80101589:	e8 42 eb ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010158e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101590:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101593:	ba 01 00 00 00       	mov    $0x1,%edx
80101598:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
8010159b:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801015a1:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801015a4:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801015a6:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801015ab:	85 d1                	test   %edx,%ecx
801015ad:	74 25                	je     801015d4 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801015af:	f7 d2                	not    %edx
  log_write(bp);
801015b1:	83 ec 0c             	sub    $0xc,%esp
801015b4:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
801015b6:	21 ca                	and    %ecx,%edx
801015b8:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
801015bc:	50                   	push   %eax
801015bd:	e8 8e 20 00 00       	call   80103650 <log_write>
  brelse(bp);
801015c2:	89 34 24             	mov    %esi,(%esp)
801015c5:	e8 26 ec ff ff       	call   801001f0 <brelse>
}
801015ca:	83 c4 10             	add    $0x10,%esp
801015cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015d0:	5b                   	pop    %ebx
801015d1:	5e                   	pop    %esi
801015d2:	5d                   	pop    %ebp
801015d3:	c3                   	ret    
    panic("freeing free block");
801015d4:	83 ec 0c             	sub    $0xc,%esp
801015d7:	68 1f 81 10 80       	push   $0x8010811f
801015dc:	e8 af ed ff ff       	call   80100390 <panic>
801015e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015ef:	90                   	nop

801015f0 <balloc>:
{
801015f0:	55                   	push   %ebp
801015f1:	89 e5                	mov    %esp,%ebp
801015f3:	57                   	push   %edi
801015f4:	56                   	push   %esi
801015f5:	53                   	push   %ebx
801015f6:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
801015f9:	8b 0d e0 19 11 80    	mov    0x801119e0,%ecx
{
801015ff:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101602:	85 c9                	test   %ecx,%ecx
80101604:	0f 84 87 00 00 00    	je     80101691 <balloc+0xa1>
8010160a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101611:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101614:	83 ec 08             	sub    $0x8,%esp
80101617:	89 f0                	mov    %esi,%eax
80101619:	c1 f8 0c             	sar    $0xc,%eax
8010161c:	03 05 f8 19 11 80    	add    0x801119f8,%eax
80101622:	50                   	push   %eax
80101623:	ff 75 d8             	pushl  -0x28(%ebp)
80101626:	e8 a5 ea ff ff       	call   801000d0 <bread>
8010162b:	83 c4 10             	add    $0x10,%esp
8010162e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101631:	a1 e0 19 11 80       	mov    0x801119e0,%eax
80101636:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101639:	31 c0                	xor    %eax,%eax
8010163b:	eb 2f                	jmp    8010166c <balloc+0x7c>
8010163d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101640:	89 c1                	mov    %eax,%ecx
80101642:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101647:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010164a:	83 e1 07             	and    $0x7,%ecx
8010164d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010164f:	89 c1                	mov    %eax,%ecx
80101651:	c1 f9 03             	sar    $0x3,%ecx
80101654:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101659:	89 fa                	mov    %edi,%edx
8010165b:	85 df                	test   %ebx,%edi
8010165d:	74 41                	je     801016a0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010165f:	83 c0 01             	add    $0x1,%eax
80101662:	83 c6 01             	add    $0x1,%esi
80101665:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010166a:	74 05                	je     80101671 <balloc+0x81>
8010166c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010166f:	77 cf                	ja     80101640 <balloc+0x50>
    brelse(bp);
80101671:	83 ec 0c             	sub    $0xc,%esp
80101674:	ff 75 e4             	pushl  -0x1c(%ebp)
80101677:	e8 74 eb ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010167c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101683:	83 c4 10             	add    $0x10,%esp
80101686:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101689:	39 05 e0 19 11 80    	cmp    %eax,0x801119e0
8010168f:	77 80                	ja     80101611 <balloc+0x21>
  panic("balloc: out of blocks");
80101691:	83 ec 0c             	sub    $0xc,%esp
80101694:	68 32 81 10 80       	push   $0x80108132
80101699:	e8 f2 ec ff ff       	call   80100390 <panic>
8010169e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801016a0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801016a3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801016a6:	09 da                	or     %ebx,%edx
801016a8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801016ac:	57                   	push   %edi
801016ad:	e8 9e 1f 00 00       	call   80103650 <log_write>
        brelse(bp);
801016b2:	89 3c 24             	mov    %edi,(%esp)
801016b5:	e8 36 eb ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801016ba:	58                   	pop    %eax
801016bb:	5a                   	pop    %edx
801016bc:	56                   	push   %esi
801016bd:	ff 75 d8             	pushl  -0x28(%ebp)
801016c0:	e8 0b ea ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801016c5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
801016c8:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801016ca:	8d 40 5c             	lea    0x5c(%eax),%eax
801016cd:	68 00 02 00 00       	push   $0x200
801016d2:	6a 00                	push   $0x0
801016d4:	50                   	push   %eax
801016d5:	e8 66 39 00 00       	call   80105040 <memset>
  log_write(bp);
801016da:	89 1c 24             	mov    %ebx,(%esp)
801016dd:	e8 6e 1f 00 00       	call   80103650 <log_write>
  brelse(bp);
801016e2:	89 1c 24             	mov    %ebx,(%esp)
801016e5:	e8 06 eb ff ff       	call   801001f0 <brelse>
}
801016ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016ed:	89 f0                	mov    %esi,%eax
801016ef:	5b                   	pop    %ebx
801016f0:	5e                   	pop    %esi
801016f1:	5f                   	pop    %edi
801016f2:	5d                   	pop    %ebp
801016f3:	c3                   	ret    
801016f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801016fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801016ff:	90                   	nop

80101700 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101700:	55                   	push   %ebp
80101701:	89 e5                	mov    %esp,%ebp
80101703:	57                   	push   %edi
80101704:	89 c7                	mov    %eax,%edi
80101706:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101707:	31 f6                	xor    %esi,%esi
{
80101709:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010170a:	bb 34 1a 11 80       	mov    $0x80111a34,%ebx
{
8010170f:	83 ec 28             	sub    $0x28,%esp
80101712:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101715:	68 00 1a 11 80       	push   $0x80111a00
8010171a:	e8 11 38 00 00       	call   80104f30 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010171f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101722:	83 c4 10             	add    $0x10,%esp
80101725:	eb 1b                	jmp    80101742 <iget+0x42>
80101727:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010172e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101730:	39 3b                	cmp    %edi,(%ebx)
80101732:	74 6c                	je     801017a0 <iget+0xa0>
80101734:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010173a:	81 fb 54 36 11 80    	cmp    $0x80113654,%ebx
80101740:	73 26                	jae    80101768 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101742:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101745:	85 c9                	test   %ecx,%ecx
80101747:	7f e7                	jg     80101730 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101749:	85 f6                	test   %esi,%esi
8010174b:	75 e7                	jne    80101734 <iget+0x34>
8010174d:	89 d8                	mov    %ebx,%eax
8010174f:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101755:	85 c9                	test   %ecx,%ecx
80101757:	75 6e                	jne    801017c7 <iget+0xc7>
80101759:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010175b:	81 fb 54 36 11 80    	cmp    $0x80113654,%ebx
80101761:	72 df                	jb     80101742 <iget+0x42>
80101763:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101767:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101768:	85 f6                	test   %esi,%esi
8010176a:	74 73                	je     801017df <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010176c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010176f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101771:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101774:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010177b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101782:	68 00 1a 11 80       	push   $0x80111a00
80101787:	e8 64 38 00 00       	call   80104ff0 <release>

  return ip;
8010178c:	83 c4 10             	add    $0x10,%esp
}
8010178f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101792:	89 f0                	mov    %esi,%eax
80101794:	5b                   	pop    %ebx
80101795:	5e                   	pop    %esi
80101796:	5f                   	pop    %edi
80101797:	5d                   	pop    %ebp
80101798:	c3                   	ret    
80101799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801017a0:	39 53 04             	cmp    %edx,0x4(%ebx)
801017a3:	75 8f                	jne    80101734 <iget+0x34>
      release(&icache.lock);
801017a5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801017a8:	83 c1 01             	add    $0x1,%ecx
      return ip;
801017ab:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801017ad:	68 00 1a 11 80       	push   $0x80111a00
      ip->ref++;
801017b2:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801017b5:	e8 36 38 00 00       	call   80104ff0 <release>
      return ip;
801017ba:	83 c4 10             	add    $0x10,%esp
}
801017bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017c0:	89 f0                	mov    %esi,%eax
801017c2:	5b                   	pop    %ebx
801017c3:	5e                   	pop    %esi
801017c4:	5f                   	pop    %edi
801017c5:	5d                   	pop    %ebp
801017c6:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801017c7:	81 fb 54 36 11 80    	cmp    $0x80113654,%ebx
801017cd:	73 10                	jae    801017df <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801017cf:	8b 4b 08             	mov    0x8(%ebx),%ecx
801017d2:	85 c9                	test   %ecx,%ecx
801017d4:	0f 8f 56 ff ff ff    	jg     80101730 <iget+0x30>
801017da:	e9 6e ff ff ff       	jmp    8010174d <iget+0x4d>
    panic("iget: no inodes");
801017df:	83 ec 0c             	sub    $0xc,%esp
801017e2:	68 48 81 10 80       	push   $0x80108148
801017e7:	e8 a4 eb ff ff       	call   80100390 <panic>
801017ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801017f0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801017f0:	55                   	push   %ebp
801017f1:	89 e5                	mov    %esp,%ebp
801017f3:	57                   	push   %edi
801017f4:	56                   	push   %esi
801017f5:	89 c6                	mov    %eax,%esi
801017f7:	53                   	push   %ebx
801017f8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801017fb:	83 fa 0b             	cmp    $0xb,%edx
801017fe:	0f 86 84 00 00 00    	jbe    80101888 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101804:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101807:	83 fb 7f             	cmp    $0x7f,%ebx
8010180a:	0f 87 98 00 00 00    	ja     801018a8 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101810:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101816:	8b 16                	mov    (%esi),%edx
80101818:	85 c0                	test   %eax,%eax
8010181a:	74 54                	je     80101870 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010181c:	83 ec 08             	sub    $0x8,%esp
8010181f:	50                   	push   %eax
80101820:	52                   	push   %edx
80101821:	e8 aa e8 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101826:	83 c4 10             	add    $0x10,%esp
80101829:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
8010182d:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010182f:	8b 1a                	mov    (%edx),%ebx
80101831:	85 db                	test   %ebx,%ebx
80101833:	74 1b                	je     80101850 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101835:	83 ec 0c             	sub    $0xc,%esp
80101838:	57                   	push   %edi
80101839:	e8 b2 e9 ff ff       	call   801001f0 <brelse>
    return addr;
8010183e:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
80101841:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101844:	89 d8                	mov    %ebx,%eax
80101846:	5b                   	pop    %ebx
80101847:	5e                   	pop    %esi
80101848:	5f                   	pop    %edi
80101849:	5d                   	pop    %ebp
8010184a:	c3                   	ret    
8010184b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010184f:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
80101850:	8b 06                	mov    (%esi),%eax
80101852:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101855:	e8 96 fd ff ff       	call   801015f0 <balloc>
8010185a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
8010185d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101860:	89 c3                	mov    %eax,%ebx
80101862:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101864:	57                   	push   %edi
80101865:	e8 e6 1d 00 00       	call   80103650 <log_write>
8010186a:	83 c4 10             	add    $0x10,%esp
8010186d:	eb c6                	jmp    80101835 <bmap+0x45>
8010186f:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101870:	89 d0                	mov    %edx,%eax
80101872:	e8 79 fd ff ff       	call   801015f0 <balloc>
80101877:	8b 16                	mov    (%esi),%edx
80101879:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010187f:	eb 9b                	jmp    8010181c <bmap+0x2c>
80101881:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
80101888:	8d 3c 90             	lea    (%eax,%edx,4),%edi
8010188b:	8b 5f 5c             	mov    0x5c(%edi),%ebx
8010188e:	85 db                	test   %ebx,%ebx
80101890:	75 af                	jne    80101841 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101892:	8b 00                	mov    (%eax),%eax
80101894:	e8 57 fd ff ff       	call   801015f0 <balloc>
80101899:	89 47 5c             	mov    %eax,0x5c(%edi)
8010189c:	89 c3                	mov    %eax,%ebx
}
8010189e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018a1:	89 d8                	mov    %ebx,%eax
801018a3:	5b                   	pop    %ebx
801018a4:	5e                   	pop    %esi
801018a5:	5f                   	pop    %edi
801018a6:	5d                   	pop    %ebp
801018a7:	c3                   	ret    
  panic("bmap: out of range");
801018a8:	83 ec 0c             	sub    $0xc,%esp
801018ab:	68 58 81 10 80       	push   $0x80108158
801018b0:	e8 db ea ff ff       	call   80100390 <panic>
801018b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018c0 <readsb>:
{
801018c0:	f3 0f 1e fb          	endbr32 
801018c4:	55                   	push   %ebp
801018c5:	89 e5                	mov    %esp,%ebp
801018c7:	56                   	push   %esi
801018c8:	53                   	push   %ebx
801018c9:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801018cc:	83 ec 08             	sub    $0x8,%esp
801018cf:	6a 01                	push   $0x1
801018d1:	ff 75 08             	pushl  0x8(%ebp)
801018d4:	e8 f7 e7 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801018d9:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801018dc:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801018de:	8d 40 5c             	lea    0x5c(%eax),%eax
801018e1:	6a 1c                	push   $0x1c
801018e3:	50                   	push   %eax
801018e4:	56                   	push   %esi
801018e5:	e8 f6 37 00 00       	call   801050e0 <memmove>
  brelse(bp);
801018ea:	89 5d 08             	mov    %ebx,0x8(%ebp)
801018ed:	83 c4 10             	add    $0x10,%esp
}
801018f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018f3:	5b                   	pop    %ebx
801018f4:	5e                   	pop    %esi
801018f5:	5d                   	pop    %ebp
  brelse(bp);
801018f6:	e9 f5 e8 ff ff       	jmp    801001f0 <brelse>
801018fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801018ff:	90                   	nop

80101900 <iinit>:
{
80101900:	f3 0f 1e fb          	endbr32 
80101904:	55                   	push   %ebp
80101905:	89 e5                	mov    %esp,%ebp
80101907:	53                   	push   %ebx
80101908:	bb 40 1a 11 80       	mov    $0x80111a40,%ebx
8010190d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101910:	68 6b 81 10 80       	push   $0x8010816b
80101915:	68 00 1a 11 80       	push   $0x80111a00
8010191a:	e8 91 34 00 00       	call   80104db0 <initlock>
  for(i = 0; i < NINODE; i++) {
8010191f:	83 c4 10             	add    $0x10,%esp
80101922:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101928:	83 ec 08             	sub    $0x8,%esp
8010192b:	68 72 81 10 80       	push   $0x80108172
80101930:	53                   	push   %ebx
80101931:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101937:	e8 34 33 00 00       	call   80104c70 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
8010193c:	83 c4 10             	add    $0x10,%esp
8010193f:	81 fb 60 36 11 80    	cmp    $0x80113660,%ebx
80101945:	75 e1                	jne    80101928 <iinit+0x28>
  readsb(dev, &sb);
80101947:	83 ec 08             	sub    $0x8,%esp
8010194a:	68 e0 19 11 80       	push   $0x801119e0
8010194f:	ff 75 08             	pushl  0x8(%ebp)
80101952:	e8 69 ff ff ff       	call   801018c0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101957:	ff 35 f8 19 11 80    	pushl  0x801119f8
8010195d:	ff 35 f4 19 11 80    	pushl  0x801119f4
80101963:	ff 35 f0 19 11 80    	pushl  0x801119f0
80101969:	ff 35 ec 19 11 80    	pushl  0x801119ec
8010196f:	ff 35 e8 19 11 80    	pushl  0x801119e8
80101975:	ff 35 e4 19 11 80    	pushl  0x801119e4
8010197b:	ff 35 e0 19 11 80    	pushl  0x801119e0
80101981:	68 1c 82 10 80       	push   $0x8010821c
80101986:	e8 25 ed ff ff       	call   801006b0 <cprintf>
}
8010198b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010198e:	83 c4 30             	add    $0x30,%esp
80101991:	c9                   	leave  
80101992:	c3                   	ret    
80101993:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010199a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801019a0 <ialloc>:
{
801019a0:	f3 0f 1e fb          	endbr32 
801019a4:	55                   	push   %ebp
801019a5:	89 e5                	mov    %esp,%ebp
801019a7:	57                   	push   %edi
801019a8:	56                   	push   %esi
801019a9:	53                   	push   %ebx
801019aa:	83 ec 1c             	sub    $0x1c,%esp
801019ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
801019b0:	83 3d e8 19 11 80 01 	cmpl   $0x1,0x801119e8
{
801019b7:	8b 75 08             	mov    0x8(%ebp),%esi
801019ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801019bd:	0f 86 8d 00 00 00    	jbe    80101a50 <ialloc+0xb0>
801019c3:	bf 01 00 00 00       	mov    $0x1,%edi
801019c8:	eb 1d                	jmp    801019e7 <ialloc+0x47>
801019ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
801019d0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801019d3:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
801019d6:	53                   	push   %ebx
801019d7:	e8 14 e8 ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801019dc:	83 c4 10             	add    $0x10,%esp
801019df:	3b 3d e8 19 11 80    	cmp    0x801119e8,%edi
801019e5:	73 69                	jae    80101a50 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801019e7:	89 f8                	mov    %edi,%eax
801019e9:	83 ec 08             	sub    $0x8,%esp
801019ec:	c1 e8 03             	shr    $0x3,%eax
801019ef:	03 05 f4 19 11 80    	add    0x801119f4,%eax
801019f5:	50                   	push   %eax
801019f6:	56                   	push   %esi
801019f7:	e8 d4 e6 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
801019fc:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
801019ff:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101a01:	89 f8                	mov    %edi,%eax
80101a03:	83 e0 07             	and    $0x7,%eax
80101a06:	c1 e0 06             	shl    $0x6,%eax
80101a09:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
80101a0d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101a11:	75 bd                	jne    801019d0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101a13:	83 ec 04             	sub    $0x4,%esp
80101a16:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101a19:	6a 40                	push   $0x40
80101a1b:	6a 00                	push   $0x0
80101a1d:	51                   	push   %ecx
80101a1e:	e8 1d 36 00 00       	call   80105040 <memset>
      dip->type = type;
80101a23:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101a27:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101a2a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
80101a2d:	89 1c 24             	mov    %ebx,(%esp)
80101a30:	e8 1b 1c 00 00       	call   80103650 <log_write>
      brelse(bp);
80101a35:	89 1c 24             	mov    %ebx,(%esp)
80101a38:	e8 b3 e7 ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
80101a3d:	83 c4 10             	add    $0x10,%esp
}
80101a40:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101a43:	89 fa                	mov    %edi,%edx
}
80101a45:	5b                   	pop    %ebx
      return iget(dev, inum);
80101a46:	89 f0                	mov    %esi,%eax
}
80101a48:	5e                   	pop    %esi
80101a49:	5f                   	pop    %edi
80101a4a:	5d                   	pop    %ebp
      return iget(dev, inum);
80101a4b:	e9 b0 fc ff ff       	jmp    80101700 <iget>
  panic("ialloc: no inodes");
80101a50:	83 ec 0c             	sub    $0xc,%esp
80101a53:	68 78 81 10 80       	push   $0x80108178
80101a58:	e8 33 e9 ff ff       	call   80100390 <panic>
80101a5d:	8d 76 00             	lea    0x0(%esi),%esi

80101a60 <iupdate>:
{
80101a60:	f3 0f 1e fb          	endbr32 
80101a64:	55                   	push   %ebp
80101a65:	89 e5                	mov    %esp,%ebp
80101a67:	56                   	push   %esi
80101a68:	53                   	push   %ebx
80101a69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a6c:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101a6f:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a72:	83 ec 08             	sub    $0x8,%esp
80101a75:	c1 e8 03             	shr    $0x3,%eax
80101a78:	03 05 f4 19 11 80    	add    0x801119f4,%eax
80101a7e:	50                   	push   %eax
80101a7f:	ff 73 a4             	pushl  -0x5c(%ebx)
80101a82:	e8 49 e6 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101a87:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101a8b:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a8e:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a90:	8b 43 a8             	mov    -0x58(%ebx),%eax
80101a93:	83 e0 07             	and    $0x7,%eax
80101a96:	c1 e0 06             	shl    $0x6,%eax
80101a99:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101a9d:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101aa0:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101aa4:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101aa7:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101aab:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
80101aaf:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101ab3:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101ab7:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101abb:	8b 53 fc             	mov    -0x4(%ebx),%edx
80101abe:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101ac1:	6a 34                	push   $0x34
80101ac3:	53                   	push   %ebx
80101ac4:	50                   	push   %eax
80101ac5:	e8 16 36 00 00       	call   801050e0 <memmove>
  log_write(bp);
80101aca:	89 34 24             	mov    %esi,(%esp)
80101acd:	e8 7e 1b 00 00       	call   80103650 <log_write>
  brelse(bp);
80101ad2:	89 75 08             	mov    %esi,0x8(%ebp)
80101ad5:	83 c4 10             	add    $0x10,%esp
}
80101ad8:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101adb:	5b                   	pop    %ebx
80101adc:	5e                   	pop    %esi
80101add:	5d                   	pop    %ebp
  brelse(bp);
80101ade:	e9 0d e7 ff ff       	jmp    801001f0 <brelse>
80101ae3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101af0 <idup>:
{
80101af0:	f3 0f 1e fb          	endbr32 
80101af4:	55                   	push   %ebp
80101af5:	89 e5                	mov    %esp,%ebp
80101af7:	53                   	push   %ebx
80101af8:	83 ec 10             	sub    $0x10,%esp
80101afb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101afe:	68 00 1a 11 80       	push   $0x80111a00
80101b03:	e8 28 34 00 00       	call   80104f30 <acquire>
  ip->ref++;
80101b08:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101b0c:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101b13:	e8 d8 34 00 00       	call   80104ff0 <release>
}
80101b18:	89 d8                	mov    %ebx,%eax
80101b1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101b1d:	c9                   	leave  
80101b1e:	c3                   	ret    
80101b1f:	90                   	nop

80101b20 <ilock>:
{
80101b20:	f3 0f 1e fb          	endbr32 
80101b24:	55                   	push   %ebp
80101b25:	89 e5                	mov    %esp,%ebp
80101b27:	56                   	push   %esi
80101b28:	53                   	push   %ebx
80101b29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101b2c:	85 db                	test   %ebx,%ebx
80101b2e:	0f 84 b3 00 00 00    	je     80101be7 <ilock+0xc7>
80101b34:	8b 53 08             	mov    0x8(%ebx),%edx
80101b37:	85 d2                	test   %edx,%edx
80101b39:	0f 8e a8 00 00 00    	jle    80101be7 <ilock+0xc7>
  acquiresleep(&ip->lock);
80101b3f:	83 ec 0c             	sub    $0xc,%esp
80101b42:	8d 43 0c             	lea    0xc(%ebx),%eax
80101b45:	50                   	push   %eax
80101b46:	e8 65 31 00 00       	call   80104cb0 <acquiresleep>
  if(ip->valid == 0){
80101b4b:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101b4e:	83 c4 10             	add    $0x10,%esp
80101b51:	85 c0                	test   %eax,%eax
80101b53:	74 0b                	je     80101b60 <ilock+0x40>
}
80101b55:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101b58:	5b                   	pop    %ebx
80101b59:	5e                   	pop    %esi
80101b5a:	5d                   	pop    %ebp
80101b5b:	c3                   	ret    
80101b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101b60:	8b 43 04             	mov    0x4(%ebx),%eax
80101b63:	83 ec 08             	sub    $0x8,%esp
80101b66:	c1 e8 03             	shr    $0x3,%eax
80101b69:	03 05 f4 19 11 80    	add    0x801119f4,%eax
80101b6f:	50                   	push   %eax
80101b70:	ff 33                	pushl  (%ebx)
80101b72:	e8 59 e5 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101b77:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101b7a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101b7c:	8b 43 04             	mov    0x4(%ebx),%eax
80101b7f:	83 e0 07             	and    $0x7,%eax
80101b82:	c1 e0 06             	shl    $0x6,%eax
80101b85:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101b89:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101b8c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80101b8f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101b93:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101b97:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101b9b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101b9f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101ba3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101ba7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101bab:	8b 50 fc             	mov    -0x4(%eax),%edx
80101bae:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101bb1:	6a 34                	push   $0x34
80101bb3:	50                   	push   %eax
80101bb4:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101bb7:	50                   	push   %eax
80101bb8:	e8 23 35 00 00       	call   801050e0 <memmove>
    brelse(bp);
80101bbd:	89 34 24             	mov    %esi,(%esp)
80101bc0:	e8 2b e6 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101bc5:	83 c4 10             	add    $0x10,%esp
80101bc8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80101bcd:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101bd4:	0f 85 7b ff ff ff    	jne    80101b55 <ilock+0x35>
      panic("ilock: no type");
80101bda:	83 ec 0c             	sub    $0xc,%esp
80101bdd:	68 90 81 10 80       	push   $0x80108190
80101be2:	e8 a9 e7 ff ff       	call   80100390 <panic>
    panic("ilock");
80101be7:	83 ec 0c             	sub    $0xc,%esp
80101bea:	68 8a 81 10 80       	push   $0x8010818a
80101bef:	e8 9c e7 ff ff       	call   80100390 <panic>
80101bf4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bff:	90                   	nop

80101c00 <iunlock>:
{
80101c00:	f3 0f 1e fb          	endbr32 
80101c04:	55                   	push   %ebp
80101c05:	89 e5                	mov    %esp,%ebp
80101c07:	56                   	push   %esi
80101c08:	53                   	push   %ebx
80101c09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101c0c:	85 db                	test   %ebx,%ebx
80101c0e:	74 28                	je     80101c38 <iunlock+0x38>
80101c10:	83 ec 0c             	sub    $0xc,%esp
80101c13:	8d 73 0c             	lea    0xc(%ebx),%esi
80101c16:	56                   	push   %esi
80101c17:	e8 34 31 00 00       	call   80104d50 <holdingsleep>
80101c1c:	83 c4 10             	add    $0x10,%esp
80101c1f:	85 c0                	test   %eax,%eax
80101c21:	74 15                	je     80101c38 <iunlock+0x38>
80101c23:	8b 43 08             	mov    0x8(%ebx),%eax
80101c26:	85 c0                	test   %eax,%eax
80101c28:	7e 0e                	jle    80101c38 <iunlock+0x38>
  releasesleep(&ip->lock);
80101c2a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101c2d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101c30:	5b                   	pop    %ebx
80101c31:	5e                   	pop    %esi
80101c32:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101c33:	e9 d8 30 00 00       	jmp    80104d10 <releasesleep>
    panic("iunlock");
80101c38:	83 ec 0c             	sub    $0xc,%esp
80101c3b:	68 9f 81 10 80       	push   $0x8010819f
80101c40:	e8 4b e7 ff ff       	call   80100390 <panic>
80101c45:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101c50 <iput>:
{
80101c50:	f3 0f 1e fb          	endbr32 
80101c54:	55                   	push   %ebp
80101c55:	89 e5                	mov    %esp,%ebp
80101c57:	57                   	push   %edi
80101c58:	56                   	push   %esi
80101c59:	53                   	push   %ebx
80101c5a:	83 ec 28             	sub    $0x28,%esp
80101c5d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101c60:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101c63:	57                   	push   %edi
80101c64:	e8 47 30 00 00       	call   80104cb0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101c69:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101c6c:	83 c4 10             	add    $0x10,%esp
80101c6f:	85 d2                	test   %edx,%edx
80101c71:	74 07                	je     80101c7a <iput+0x2a>
80101c73:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101c78:	74 36                	je     80101cb0 <iput+0x60>
  releasesleep(&ip->lock);
80101c7a:	83 ec 0c             	sub    $0xc,%esp
80101c7d:	57                   	push   %edi
80101c7e:	e8 8d 30 00 00       	call   80104d10 <releasesleep>
  acquire(&icache.lock);
80101c83:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101c8a:	e8 a1 32 00 00       	call   80104f30 <acquire>
  ip->ref--;
80101c8f:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101c93:	83 c4 10             	add    $0x10,%esp
80101c96:	c7 45 08 00 1a 11 80 	movl   $0x80111a00,0x8(%ebp)
}
80101c9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ca0:	5b                   	pop    %ebx
80101ca1:	5e                   	pop    %esi
80101ca2:	5f                   	pop    %edi
80101ca3:	5d                   	pop    %ebp
  release(&icache.lock);
80101ca4:	e9 47 33 00 00       	jmp    80104ff0 <release>
80101ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
80101cb0:	83 ec 0c             	sub    $0xc,%esp
80101cb3:	68 00 1a 11 80       	push   $0x80111a00
80101cb8:	e8 73 32 00 00       	call   80104f30 <acquire>
    int r = ip->ref;
80101cbd:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101cc0:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101cc7:	e8 24 33 00 00       	call   80104ff0 <release>
    if(r == 1){
80101ccc:	83 c4 10             	add    $0x10,%esp
80101ccf:	83 fe 01             	cmp    $0x1,%esi
80101cd2:	75 a6                	jne    80101c7a <iput+0x2a>
80101cd4:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101cda:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101cdd:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101ce0:	89 cf                	mov    %ecx,%edi
80101ce2:	eb 0b                	jmp    80101cef <iput+0x9f>
80101ce4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101ce8:	83 c6 04             	add    $0x4,%esi
80101ceb:	39 fe                	cmp    %edi,%esi
80101ced:	74 19                	je     80101d08 <iput+0xb8>
    if(ip->addrs[i]){
80101cef:	8b 16                	mov    (%esi),%edx
80101cf1:	85 d2                	test   %edx,%edx
80101cf3:	74 f3                	je     80101ce8 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
80101cf5:	8b 03                	mov    (%ebx),%eax
80101cf7:	e8 74 f8 ff ff       	call   80101570 <bfree>
      ip->addrs[i] = 0;
80101cfc:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101d02:	eb e4                	jmp    80101ce8 <iput+0x98>
80101d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101d08:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101d0e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101d11:	85 c0                	test   %eax,%eax
80101d13:	75 33                	jne    80101d48 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101d15:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101d18:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101d1f:	53                   	push   %ebx
80101d20:	e8 3b fd ff ff       	call   80101a60 <iupdate>
      ip->type = 0;
80101d25:	31 c0                	xor    %eax,%eax
80101d27:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101d2b:	89 1c 24             	mov    %ebx,(%esp)
80101d2e:	e8 2d fd ff ff       	call   80101a60 <iupdate>
      ip->valid = 0;
80101d33:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101d3a:	83 c4 10             	add    $0x10,%esp
80101d3d:	e9 38 ff ff ff       	jmp    80101c7a <iput+0x2a>
80101d42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101d48:	83 ec 08             	sub    $0x8,%esp
80101d4b:	50                   	push   %eax
80101d4c:	ff 33                	pushl  (%ebx)
80101d4e:	e8 7d e3 ff ff       	call   801000d0 <bread>
80101d53:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101d56:	83 c4 10             	add    $0x10,%esp
80101d59:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101d5f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101d62:	8d 70 5c             	lea    0x5c(%eax),%esi
80101d65:	89 cf                	mov    %ecx,%edi
80101d67:	eb 0e                	jmp    80101d77 <iput+0x127>
80101d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d70:	83 c6 04             	add    $0x4,%esi
80101d73:	39 f7                	cmp    %esi,%edi
80101d75:	74 19                	je     80101d90 <iput+0x140>
      if(a[j])
80101d77:	8b 16                	mov    (%esi),%edx
80101d79:	85 d2                	test   %edx,%edx
80101d7b:	74 f3                	je     80101d70 <iput+0x120>
        bfree(ip->dev, a[j]);
80101d7d:	8b 03                	mov    (%ebx),%eax
80101d7f:	e8 ec f7 ff ff       	call   80101570 <bfree>
80101d84:	eb ea                	jmp    80101d70 <iput+0x120>
80101d86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d8d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101d90:	83 ec 0c             	sub    $0xc,%esp
80101d93:	ff 75 e4             	pushl  -0x1c(%ebp)
80101d96:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101d99:	e8 52 e4 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101d9e:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101da4:	8b 03                	mov    (%ebx),%eax
80101da6:	e8 c5 f7 ff ff       	call   80101570 <bfree>
    ip->addrs[NDIRECT] = 0;
80101dab:	83 c4 10             	add    $0x10,%esp
80101dae:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101db5:	00 00 00 
80101db8:	e9 58 ff ff ff       	jmp    80101d15 <iput+0xc5>
80101dbd:	8d 76 00             	lea    0x0(%esi),%esi

80101dc0 <iunlockput>:
{
80101dc0:	f3 0f 1e fb          	endbr32 
80101dc4:	55                   	push   %ebp
80101dc5:	89 e5                	mov    %esp,%ebp
80101dc7:	53                   	push   %ebx
80101dc8:	83 ec 10             	sub    $0x10,%esp
80101dcb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101dce:	53                   	push   %ebx
80101dcf:	e8 2c fe ff ff       	call   80101c00 <iunlock>
  iput(ip);
80101dd4:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101dd7:	83 c4 10             	add    $0x10,%esp
}
80101dda:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101ddd:	c9                   	leave  
  iput(ip);
80101dde:	e9 6d fe ff ff       	jmp    80101c50 <iput>
80101de3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101df0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101df0:	f3 0f 1e fb          	endbr32 
80101df4:	55                   	push   %ebp
80101df5:	89 e5                	mov    %esp,%ebp
80101df7:	8b 55 08             	mov    0x8(%ebp),%edx
80101dfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101dfd:	8b 0a                	mov    (%edx),%ecx
80101dff:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101e02:	8b 4a 04             	mov    0x4(%edx),%ecx
80101e05:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101e08:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101e0c:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101e0f:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101e13:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101e17:	8b 52 58             	mov    0x58(%edx),%edx
80101e1a:	89 50 10             	mov    %edx,0x10(%eax)
}
80101e1d:	5d                   	pop    %ebp
80101e1e:	c3                   	ret    
80101e1f:	90                   	nop

80101e20 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101e20:	f3 0f 1e fb          	endbr32 
80101e24:	55                   	push   %ebp
80101e25:	89 e5                	mov    %esp,%ebp
80101e27:	57                   	push   %edi
80101e28:	56                   	push   %esi
80101e29:	53                   	push   %ebx
80101e2a:	83 ec 1c             	sub    $0x1c,%esp
80101e2d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101e30:	8b 45 08             	mov    0x8(%ebp),%eax
80101e33:	8b 75 10             	mov    0x10(%ebp),%esi
80101e36:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101e39:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101e3c:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101e41:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101e44:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101e47:	0f 84 a3 00 00 00    	je     80101ef0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101e4d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101e50:	8b 40 58             	mov    0x58(%eax),%eax
80101e53:	39 c6                	cmp    %eax,%esi
80101e55:	0f 87 b6 00 00 00    	ja     80101f11 <readi+0xf1>
80101e5b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101e5e:	31 c9                	xor    %ecx,%ecx
80101e60:	89 da                	mov    %ebx,%edx
80101e62:	01 f2                	add    %esi,%edx
80101e64:	0f 92 c1             	setb   %cl
80101e67:	89 cf                	mov    %ecx,%edi
80101e69:	0f 82 a2 00 00 00    	jb     80101f11 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101e6f:	89 c1                	mov    %eax,%ecx
80101e71:	29 f1                	sub    %esi,%ecx
80101e73:	39 d0                	cmp    %edx,%eax
80101e75:	0f 43 cb             	cmovae %ebx,%ecx
80101e78:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e7b:	85 c9                	test   %ecx,%ecx
80101e7d:	74 63                	je     80101ee2 <readi+0xc2>
80101e7f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e80:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101e83:	89 f2                	mov    %esi,%edx
80101e85:	c1 ea 09             	shr    $0x9,%edx
80101e88:	89 d8                	mov    %ebx,%eax
80101e8a:	e8 61 f9 ff ff       	call   801017f0 <bmap>
80101e8f:	83 ec 08             	sub    $0x8,%esp
80101e92:	50                   	push   %eax
80101e93:	ff 33                	pushl  (%ebx)
80101e95:	e8 36 e2 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101e9a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101e9d:	b9 00 02 00 00       	mov    $0x200,%ecx
80101ea2:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ea5:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101ea7:	89 f0                	mov    %esi,%eax
80101ea9:	25 ff 01 00 00       	and    $0x1ff,%eax
80101eae:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101eb0:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101eb3:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101eb5:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101eb9:	39 d9                	cmp    %ebx,%ecx
80101ebb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101ebe:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ebf:	01 df                	add    %ebx,%edi
80101ec1:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101ec3:	50                   	push   %eax
80101ec4:	ff 75 e0             	pushl  -0x20(%ebp)
80101ec7:	e8 14 32 00 00       	call   801050e0 <memmove>
    brelse(bp);
80101ecc:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101ecf:	89 14 24             	mov    %edx,(%esp)
80101ed2:	e8 19 e3 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ed7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101eda:	83 c4 10             	add    $0x10,%esp
80101edd:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101ee0:	77 9e                	ja     80101e80 <readi+0x60>
  }
  return n;
80101ee2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101ee5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ee8:	5b                   	pop    %ebx
80101ee9:	5e                   	pop    %esi
80101eea:	5f                   	pop    %edi
80101eeb:	5d                   	pop    %ebp
80101eec:	c3                   	ret    
80101eed:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101ef0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101ef4:	66 83 f8 09          	cmp    $0x9,%ax
80101ef8:	77 17                	ja     80101f11 <readi+0xf1>
80101efa:	8b 04 c5 80 19 11 80 	mov    -0x7feee680(,%eax,8),%eax
80101f01:	85 c0                	test   %eax,%eax
80101f03:	74 0c                	je     80101f11 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101f05:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101f08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f0b:	5b                   	pop    %ebx
80101f0c:	5e                   	pop    %esi
80101f0d:	5f                   	pop    %edi
80101f0e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101f0f:	ff e0                	jmp    *%eax
      return -1;
80101f11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f16:	eb cd                	jmp    80101ee5 <readi+0xc5>
80101f18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f1f:	90                   	nop

80101f20 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101f20:	f3 0f 1e fb          	endbr32 
80101f24:	55                   	push   %ebp
80101f25:	89 e5                	mov    %esp,%ebp
80101f27:	57                   	push   %edi
80101f28:	56                   	push   %esi
80101f29:	53                   	push   %ebx
80101f2a:	83 ec 1c             	sub    $0x1c,%esp
80101f2d:	8b 45 08             	mov    0x8(%ebp),%eax
80101f30:	8b 75 0c             	mov    0xc(%ebp),%esi
80101f33:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101f36:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101f3b:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101f3e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101f41:	8b 75 10             	mov    0x10(%ebp),%esi
80101f44:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101f47:	0f 84 b3 00 00 00    	je     80102000 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101f4d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101f50:	39 70 58             	cmp    %esi,0x58(%eax)
80101f53:	0f 82 e3 00 00 00    	jb     8010203c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101f59:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101f5c:	89 f8                	mov    %edi,%eax
80101f5e:	01 f0                	add    %esi,%eax
80101f60:	0f 82 d6 00 00 00    	jb     8010203c <writei+0x11c>
80101f66:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101f6b:	0f 87 cb 00 00 00    	ja     8010203c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101f71:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101f78:	85 ff                	test   %edi,%edi
80101f7a:	74 75                	je     80101ff1 <writei+0xd1>
80101f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f80:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101f83:	89 f2                	mov    %esi,%edx
80101f85:	c1 ea 09             	shr    $0x9,%edx
80101f88:	89 f8                	mov    %edi,%eax
80101f8a:	e8 61 f8 ff ff       	call   801017f0 <bmap>
80101f8f:	83 ec 08             	sub    $0x8,%esp
80101f92:	50                   	push   %eax
80101f93:	ff 37                	pushl  (%edi)
80101f95:	e8 36 e1 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101f9a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101f9f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101fa2:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101fa5:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101fa7:	89 f0                	mov    %esi,%eax
80101fa9:	83 c4 0c             	add    $0xc,%esp
80101fac:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fb1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101fb3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101fb7:	39 d9                	cmp    %ebx,%ecx
80101fb9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101fbc:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101fbd:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101fbf:	ff 75 dc             	pushl  -0x24(%ebp)
80101fc2:	50                   	push   %eax
80101fc3:	e8 18 31 00 00       	call   801050e0 <memmove>
    log_write(bp);
80101fc8:	89 3c 24             	mov    %edi,(%esp)
80101fcb:	e8 80 16 00 00       	call   80103650 <log_write>
    brelse(bp);
80101fd0:	89 3c 24             	mov    %edi,(%esp)
80101fd3:	e8 18 e2 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101fd8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101fdb:	83 c4 10             	add    $0x10,%esp
80101fde:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101fe1:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101fe4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101fe7:	77 97                	ja     80101f80 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101fe9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101fec:	3b 70 58             	cmp    0x58(%eax),%esi
80101fef:	77 37                	ja     80102028 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101ff1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101ff4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ff7:	5b                   	pop    %ebx
80101ff8:	5e                   	pop    %esi
80101ff9:	5f                   	pop    %edi
80101ffa:	5d                   	pop    %ebp
80101ffb:	c3                   	ret    
80101ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102000:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102004:	66 83 f8 09          	cmp    $0x9,%ax
80102008:	77 32                	ja     8010203c <writei+0x11c>
8010200a:	8b 04 c5 84 19 11 80 	mov    -0x7feee67c(,%eax,8),%eax
80102011:	85 c0                	test   %eax,%eax
80102013:	74 27                	je     8010203c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80102015:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80102018:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010201b:	5b                   	pop    %ebx
8010201c:	5e                   	pop    %esi
8010201d:	5f                   	pop    %edi
8010201e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
8010201f:	ff e0                	jmp    *%eax
80102021:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80102028:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
8010202b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
8010202e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80102031:	50                   	push   %eax
80102032:	e8 29 fa ff ff       	call   80101a60 <iupdate>
80102037:	83 c4 10             	add    $0x10,%esp
8010203a:	eb b5                	jmp    80101ff1 <writei+0xd1>
      return -1;
8010203c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102041:	eb b1                	jmp    80101ff4 <writei+0xd4>
80102043:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010204a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102050 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102050:	f3 0f 1e fb          	endbr32 
80102054:	55                   	push   %ebp
80102055:	89 e5                	mov    %esp,%ebp
80102057:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
8010205a:	6a 0e                	push   $0xe
8010205c:	ff 75 0c             	pushl  0xc(%ebp)
8010205f:	ff 75 08             	pushl  0x8(%ebp)
80102062:	e8 e9 30 00 00       	call   80105150 <strncmp>
}
80102067:	c9                   	leave  
80102068:	c3                   	ret    
80102069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102070 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102070:	f3 0f 1e fb          	endbr32 
80102074:	55                   	push   %ebp
80102075:	89 e5                	mov    %esp,%ebp
80102077:	57                   	push   %edi
80102078:	56                   	push   %esi
80102079:	53                   	push   %ebx
8010207a:	83 ec 1c             	sub    $0x1c,%esp
8010207d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102080:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80102085:	0f 85 89 00 00 00    	jne    80102114 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
8010208b:	8b 53 58             	mov    0x58(%ebx),%edx
8010208e:	31 ff                	xor    %edi,%edi
80102090:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102093:	85 d2                	test   %edx,%edx
80102095:	74 42                	je     801020d9 <dirlookup+0x69>
80102097:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010209e:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020a0:	6a 10                	push   $0x10
801020a2:	57                   	push   %edi
801020a3:	56                   	push   %esi
801020a4:	53                   	push   %ebx
801020a5:	e8 76 fd ff ff       	call   80101e20 <readi>
801020aa:	83 c4 10             	add    $0x10,%esp
801020ad:	83 f8 10             	cmp    $0x10,%eax
801020b0:	75 55                	jne    80102107 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
801020b2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801020b7:	74 18                	je     801020d1 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
801020b9:	83 ec 04             	sub    $0x4,%esp
801020bc:	8d 45 da             	lea    -0x26(%ebp),%eax
801020bf:	6a 0e                	push   $0xe
801020c1:	50                   	push   %eax
801020c2:	ff 75 0c             	pushl  0xc(%ebp)
801020c5:	e8 86 30 00 00       	call   80105150 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
801020ca:	83 c4 10             	add    $0x10,%esp
801020cd:	85 c0                	test   %eax,%eax
801020cf:	74 17                	je     801020e8 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
801020d1:	83 c7 10             	add    $0x10,%edi
801020d4:	3b 7b 58             	cmp    0x58(%ebx),%edi
801020d7:	72 c7                	jb     801020a0 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
801020d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801020dc:	31 c0                	xor    %eax,%eax
}
801020de:	5b                   	pop    %ebx
801020df:	5e                   	pop    %esi
801020e0:	5f                   	pop    %edi
801020e1:	5d                   	pop    %ebp
801020e2:	c3                   	ret    
801020e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801020e7:	90                   	nop
      if(poff)
801020e8:	8b 45 10             	mov    0x10(%ebp),%eax
801020eb:	85 c0                	test   %eax,%eax
801020ed:	74 05                	je     801020f4 <dirlookup+0x84>
        *poff = off;
801020ef:	8b 45 10             	mov    0x10(%ebp),%eax
801020f2:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
801020f4:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
801020f8:	8b 03                	mov    (%ebx),%eax
801020fa:	e8 01 f6 ff ff       	call   80101700 <iget>
}
801020ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102102:	5b                   	pop    %ebx
80102103:	5e                   	pop    %esi
80102104:	5f                   	pop    %edi
80102105:	5d                   	pop    %ebp
80102106:	c3                   	ret    
      panic("dirlookup read");
80102107:	83 ec 0c             	sub    $0xc,%esp
8010210a:	68 b9 81 10 80       	push   $0x801081b9
8010210f:	e8 7c e2 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80102114:	83 ec 0c             	sub    $0xc,%esp
80102117:	68 a7 81 10 80       	push   $0x801081a7
8010211c:	e8 6f e2 ff ff       	call   80100390 <panic>
80102121:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102128:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010212f:	90                   	nop

80102130 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102130:	55                   	push   %ebp
80102131:	89 e5                	mov    %esp,%ebp
80102133:	57                   	push   %edi
80102134:	56                   	push   %esi
80102135:	53                   	push   %ebx
80102136:	89 c3                	mov    %eax,%ebx
80102138:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010213b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
8010213e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80102141:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80102144:	0f 84 86 01 00 00    	je     801022d0 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
8010214a:	e8 c1 1f 00 00       	call   80104110 <myproc>
  acquire(&icache.lock);
8010214f:	83 ec 0c             	sub    $0xc,%esp
80102152:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80102154:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80102157:	68 00 1a 11 80       	push   $0x80111a00
8010215c:	e8 cf 2d 00 00       	call   80104f30 <acquire>
  ip->ref++;
80102161:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102165:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
8010216c:	e8 7f 2e 00 00       	call   80104ff0 <release>
80102171:	83 c4 10             	add    $0x10,%esp
80102174:	eb 0d                	jmp    80102183 <namex+0x53>
80102176:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010217d:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80102180:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80102183:	0f b6 07             	movzbl (%edi),%eax
80102186:	3c 2f                	cmp    $0x2f,%al
80102188:	74 f6                	je     80102180 <namex+0x50>
  if(*path == 0)
8010218a:	84 c0                	test   %al,%al
8010218c:	0f 84 ee 00 00 00    	je     80102280 <namex+0x150>
  while(*path != '/' && *path != 0)
80102192:	0f b6 07             	movzbl (%edi),%eax
80102195:	84 c0                	test   %al,%al
80102197:	0f 84 fb 00 00 00    	je     80102298 <namex+0x168>
8010219d:	89 fb                	mov    %edi,%ebx
8010219f:	3c 2f                	cmp    $0x2f,%al
801021a1:	0f 84 f1 00 00 00    	je     80102298 <namex+0x168>
801021a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021ae:	66 90                	xchg   %ax,%ax
801021b0:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
801021b4:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
801021b7:	3c 2f                	cmp    $0x2f,%al
801021b9:	74 04                	je     801021bf <namex+0x8f>
801021bb:	84 c0                	test   %al,%al
801021bd:	75 f1                	jne    801021b0 <namex+0x80>
  len = path - s;
801021bf:	89 d8                	mov    %ebx,%eax
801021c1:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
801021c3:	83 f8 0d             	cmp    $0xd,%eax
801021c6:	0f 8e 84 00 00 00    	jle    80102250 <namex+0x120>
    memmove(name, s, DIRSIZ);
801021cc:	83 ec 04             	sub    $0x4,%esp
801021cf:	6a 0e                	push   $0xe
801021d1:	57                   	push   %edi
    path++;
801021d2:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
801021d4:	ff 75 e4             	pushl  -0x1c(%ebp)
801021d7:	e8 04 2f 00 00       	call   801050e0 <memmove>
801021dc:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
801021df:	80 3b 2f             	cmpb   $0x2f,(%ebx)
801021e2:	75 0c                	jne    801021f0 <namex+0xc0>
801021e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
801021e8:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
801021eb:	80 3f 2f             	cmpb   $0x2f,(%edi)
801021ee:	74 f8                	je     801021e8 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
801021f0:	83 ec 0c             	sub    $0xc,%esp
801021f3:	56                   	push   %esi
801021f4:	e8 27 f9 ff ff       	call   80101b20 <ilock>
    if(ip->type != T_DIR){
801021f9:	83 c4 10             	add    $0x10,%esp
801021fc:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80102201:	0f 85 a1 00 00 00    	jne    801022a8 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80102207:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010220a:	85 d2                	test   %edx,%edx
8010220c:	74 09                	je     80102217 <namex+0xe7>
8010220e:	80 3f 00             	cmpb   $0x0,(%edi)
80102211:	0f 84 d9 00 00 00    	je     801022f0 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102217:	83 ec 04             	sub    $0x4,%esp
8010221a:	6a 00                	push   $0x0
8010221c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010221f:	56                   	push   %esi
80102220:	e8 4b fe ff ff       	call   80102070 <dirlookup>
80102225:	83 c4 10             	add    $0x10,%esp
80102228:	89 c3                	mov    %eax,%ebx
8010222a:	85 c0                	test   %eax,%eax
8010222c:	74 7a                	je     801022a8 <namex+0x178>
  iunlock(ip);
8010222e:	83 ec 0c             	sub    $0xc,%esp
80102231:	56                   	push   %esi
80102232:	e8 c9 f9 ff ff       	call   80101c00 <iunlock>
  iput(ip);
80102237:	89 34 24             	mov    %esi,(%esp)
8010223a:	89 de                	mov    %ebx,%esi
8010223c:	e8 0f fa ff ff       	call   80101c50 <iput>
80102241:	83 c4 10             	add    $0x10,%esp
80102244:	e9 3a ff ff ff       	jmp    80102183 <namex+0x53>
80102249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102250:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102253:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80102256:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80102259:	83 ec 04             	sub    $0x4,%esp
8010225c:	50                   	push   %eax
8010225d:	57                   	push   %edi
    name[len] = 0;
8010225e:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80102260:	ff 75 e4             	pushl  -0x1c(%ebp)
80102263:	e8 78 2e 00 00       	call   801050e0 <memmove>
    name[len] = 0;
80102268:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010226b:	83 c4 10             	add    $0x10,%esp
8010226e:	c6 00 00             	movb   $0x0,(%eax)
80102271:	e9 69 ff ff ff       	jmp    801021df <namex+0xaf>
80102276:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010227d:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102280:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102283:	85 c0                	test   %eax,%eax
80102285:	0f 85 85 00 00 00    	jne    80102310 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
8010228b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010228e:	89 f0                	mov    %esi,%eax
80102290:	5b                   	pop    %ebx
80102291:	5e                   	pop    %esi
80102292:	5f                   	pop    %edi
80102293:	5d                   	pop    %ebp
80102294:	c3                   	ret    
80102295:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80102298:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010229b:	89 fb                	mov    %edi,%ebx
8010229d:	89 45 dc             	mov    %eax,-0x24(%ebp)
801022a0:	31 c0                	xor    %eax,%eax
801022a2:	eb b5                	jmp    80102259 <namex+0x129>
801022a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
801022a8:	83 ec 0c             	sub    $0xc,%esp
801022ab:	56                   	push   %esi
801022ac:	e8 4f f9 ff ff       	call   80101c00 <iunlock>
  iput(ip);
801022b1:	89 34 24             	mov    %esi,(%esp)
      return 0;
801022b4:	31 f6                	xor    %esi,%esi
  iput(ip);
801022b6:	e8 95 f9 ff ff       	call   80101c50 <iput>
      return 0;
801022bb:	83 c4 10             	add    $0x10,%esp
}
801022be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022c1:	89 f0                	mov    %esi,%eax
801022c3:	5b                   	pop    %ebx
801022c4:	5e                   	pop    %esi
801022c5:	5f                   	pop    %edi
801022c6:	5d                   	pop    %ebp
801022c7:	c3                   	ret    
801022c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022cf:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
801022d0:	ba 01 00 00 00       	mov    $0x1,%edx
801022d5:	b8 01 00 00 00       	mov    $0x1,%eax
801022da:	89 df                	mov    %ebx,%edi
801022dc:	e8 1f f4 ff ff       	call   80101700 <iget>
801022e1:	89 c6                	mov    %eax,%esi
801022e3:	e9 9b fe ff ff       	jmp    80102183 <namex+0x53>
801022e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022ef:	90                   	nop
      iunlock(ip);
801022f0:	83 ec 0c             	sub    $0xc,%esp
801022f3:	56                   	push   %esi
801022f4:	e8 07 f9 ff ff       	call   80101c00 <iunlock>
      return ip;
801022f9:	83 c4 10             	add    $0x10,%esp
}
801022fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022ff:	89 f0                	mov    %esi,%eax
80102301:	5b                   	pop    %ebx
80102302:	5e                   	pop    %esi
80102303:	5f                   	pop    %edi
80102304:	5d                   	pop    %ebp
80102305:	c3                   	ret    
80102306:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010230d:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80102310:	83 ec 0c             	sub    $0xc,%esp
80102313:	56                   	push   %esi
    return 0;
80102314:	31 f6                	xor    %esi,%esi
    iput(ip);
80102316:	e8 35 f9 ff ff       	call   80101c50 <iput>
    return 0;
8010231b:	83 c4 10             	add    $0x10,%esp
8010231e:	e9 68 ff ff ff       	jmp    8010228b <namex+0x15b>
80102323:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010232a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102330 <dirlink>:
{
80102330:	f3 0f 1e fb          	endbr32 
80102334:	55                   	push   %ebp
80102335:	89 e5                	mov    %esp,%ebp
80102337:	57                   	push   %edi
80102338:	56                   	push   %esi
80102339:	53                   	push   %ebx
8010233a:	83 ec 20             	sub    $0x20,%esp
8010233d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80102340:	6a 00                	push   $0x0
80102342:	ff 75 0c             	pushl  0xc(%ebp)
80102345:	53                   	push   %ebx
80102346:	e8 25 fd ff ff       	call   80102070 <dirlookup>
8010234b:	83 c4 10             	add    $0x10,%esp
8010234e:	85 c0                	test   %eax,%eax
80102350:	75 6b                	jne    801023bd <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102352:	8b 7b 58             	mov    0x58(%ebx),%edi
80102355:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102358:	85 ff                	test   %edi,%edi
8010235a:	74 2d                	je     80102389 <dirlink+0x59>
8010235c:	31 ff                	xor    %edi,%edi
8010235e:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102361:	eb 0d                	jmp    80102370 <dirlink+0x40>
80102363:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102367:	90                   	nop
80102368:	83 c7 10             	add    $0x10,%edi
8010236b:	3b 7b 58             	cmp    0x58(%ebx),%edi
8010236e:	73 19                	jae    80102389 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102370:	6a 10                	push   $0x10
80102372:	57                   	push   %edi
80102373:	56                   	push   %esi
80102374:	53                   	push   %ebx
80102375:	e8 a6 fa ff ff       	call   80101e20 <readi>
8010237a:	83 c4 10             	add    $0x10,%esp
8010237d:	83 f8 10             	cmp    $0x10,%eax
80102380:	75 4e                	jne    801023d0 <dirlink+0xa0>
    if(de.inum == 0)
80102382:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80102387:	75 df                	jne    80102368 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80102389:	83 ec 04             	sub    $0x4,%esp
8010238c:	8d 45 da             	lea    -0x26(%ebp),%eax
8010238f:	6a 0e                	push   $0xe
80102391:	ff 75 0c             	pushl  0xc(%ebp)
80102394:	50                   	push   %eax
80102395:	e8 06 2e 00 00       	call   801051a0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010239a:	6a 10                	push   $0x10
  de.inum = inum;
8010239c:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010239f:	57                   	push   %edi
801023a0:	56                   	push   %esi
801023a1:	53                   	push   %ebx
  de.inum = inum;
801023a2:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801023a6:	e8 75 fb ff ff       	call   80101f20 <writei>
801023ab:	83 c4 20             	add    $0x20,%esp
801023ae:	83 f8 10             	cmp    $0x10,%eax
801023b1:	75 2a                	jne    801023dd <dirlink+0xad>
  return 0;
801023b3:	31 c0                	xor    %eax,%eax
}
801023b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023b8:	5b                   	pop    %ebx
801023b9:	5e                   	pop    %esi
801023ba:	5f                   	pop    %edi
801023bb:	5d                   	pop    %ebp
801023bc:	c3                   	ret    
    iput(ip);
801023bd:	83 ec 0c             	sub    $0xc,%esp
801023c0:	50                   	push   %eax
801023c1:	e8 8a f8 ff ff       	call   80101c50 <iput>
    return -1;
801023c6:	83 c4 10             	add    $0x10,%esp
801023c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801023ce:	eb e5                	jmp    801023b5 <dirlink+0x85>
      panic("dirlink read");
801023d0:	83 ec 0c             	sub    $0xc,%esp
801023d3:	68 c8 81 10 80       	push   $0x801081c8
801023d8:	e8 b3 df ff ff       	call   80100390 <panic>
    panic("dirlink");
801023dd:	83 ec 0c             	sub    $0xc,%esp
801023e0:	68 ed 87 10 80       	push   $0x801087ed
801023e5:	e8 a6 df ff ff       	call   80100390 <panic>
801023ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801023f0 <namei>:

struct inode*
namei(char *path)
{
801023f0:	f3 0f 1e fb          	endbr32 
801023f4:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801023f5:	31 d2                	xor    %edx,%edx
{
801023f7:	89 e5                	mov    %esp,%ebp
801023f9:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801023fc:	8b 45 08             	mov    0x8(%ebp),%eax
801023ff:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80102402:	e8 29 fd ff ff       	call   80102130 <namex>
}
80102407:	c9                   	leave  
80102408:	c3                   	ret    
80102409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102410 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102410:	f3 0f 1e fb          	endbr32 
80102414:	55                   	push   %ebp
  return namex(path, 1, name);
80102415:	ba 01 00 00 00       	mov    $0x1,%edx
{
8010241a:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
8010241c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010241f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102422:	5d                   	pop    %ebp
  return namex(path, 1, name);
80102423:	e9 08 fd ff ff       	jmp    80102130 <namex>
80102428:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010242f:	90                   	nop

80102430 <itoa>:

#include "fcntl.h"
#define DIGITS 14

char* itoa(int i, char b[]){
80102430:	f3 0f 1e fb          	endbr32 
80102434:	55                   	push   %ebp
    char const digit[] = "0123456789";
80102435:	b8 38 39 00 00       	mov    $0x3938,%eax
char* itoa(int i, char b[]){
8010243a:	89 e5                	mov    %esp,%ebp
8010243c:	57                   	push   %edi
8010243d:	56                   	push   %esi
8010243e:	53                   	push   %ebx
8010243f:	83 ec 10             	sub    $0x10,%esp
80102442:	8b 7d 0c             	mov    0xc(%ebp),%edi
80102445:	8b 4d 08             	mov    0x8(%ebp),%ecx
    char const digit[] = "0123456789";
80102448:	c7 45 e9 30 31 32 33 	movl   $0x33323130,-0x17(%ebp)
8010244f:	c7 45 ed 34 35 36 37 	movl   $0x37363534,-0x13(%ebp)
80102456:	66 89 45 f1          	mov    %ax,-0xf(%ebp)
8010245a:	89 fb                	mov    %edi,%ebx
8010245c:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
    char* p = b;
    if(i<0){
80102460:	85 c9                	test   %ecx,%ecx
80102462:	79 08                	jns    8010246c <itoa+0x3c>
        *p++ = '-';
80102464:	c6 07 2d             	movb   $0x2d,(%edi)
80102467:	8d 5f 01             	lea    0x1(%edi),%ebx
        i *= -1;
8010246a:	f7 d9                	neg    %ecx
    }
    int shifter = i;
8010246c:	89 ca                	mov    %ecx,%edx
    do{ //Move to where representation ends
        ++p;
        shifter = shifter/10;
8010246e:	be cd cc cc cc       	mov    $0xcccccccd,%esi
80102473:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102477:	90                   	nop
80102478:	89 d0                	mov    %edx,%eax
        ++p;
8010247a:	83 c3 01             	add    $0x1,%ebx
        shifter = shifter/10;
8010247d:	f7 e6                	mul    %esi
    }while(shifter);
8010247f:	c1 ea 03             	shr    $0x3,%edx
80102482:	75 f4                	jne    80102478 <itoa+0x48>
    *p = '\0';
80102484:	c6 03 00             	movb   $0x0,(%ebx)
    do{ //Move back, inserting digits as u go
        *--p = digit[i%10];
80102487:	be cd cc cc cc       	mov    $0xcccccccd,%esi
8010248c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102490:	89 c8                	mov    %ecx,%eax
80102492:	83 eb 01             	sub    $0x1,%ebx
80102495:	f7 e6                	mul    %esi
80102497:	c1 ea 03             	shr    $0x3,%edx
8010249a:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010249d:	01 c0                	add    %eax,%eax
8010249f:	29 c1                	sub    %eax,%ecx
801024a1:	0f b6 44 0d e9       	movzbl -0x17(%ebp,%ecx,1),%eax
        i = i/10;
801024a6:	89 d1                	mov    %edx,%ecx
        *--p = digit[i%10];
801024a8:	88 03                	mov    %al,(%ebx)
    }while(i);
801024aa:	85 d2                	test   %edx,%edx
801024ac:	75 e2                	jne    80102490 <itoa+0x60>
    return b;
}
801024ae:	83 c4 10             	add    $0x10,%esp
801024b1:	89 f8                	mov    %edi,%eax
801024b3:	5b                   	pop    %ebx
801024b4:	5e                   	pop    %esi
801024b5:	5f                   	pop    %edi
801024b6:	5d                   	pop    %ebp
801024b7:	c3                   	ret    
801024b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801024bf:	90                   	nop

801024c0 <removeSwapFile>:
//remove swap file of proc p;
int
removeSwapFile(struct proc* p)
{
801024c0:	f3 0f 1e fb          	endbr32 
801024c4:	55                   	push   %ebp
801024c5:	89 e5                	mov    %esp,%ebp
801024c7:	57                   	push   %edi
801024c8:	56                   	push   %esi
  //path of proccess
  char path[DIGITS];
  memmove(path,"/.swap", 6);
801024c9:	8d 75 bc             	lea    -0x44(%ebp),%esi
{
801024cc:	53                   	push   %ebx
801024cd:	83 ec 40             	sub    $0x40,%esp
801024d0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
801024d3:	6a 06                	push   $0x6
801024d5:	68 d5 81 10 80       	push   $0x801081d5
801024da:	56                   	push   %esi
801024db:	e8 00 2c 00 00       	call   801050e0 <memmove>
  itoa(p->pid, path+ 6);
801024e0:	58                   	pop    %eax
801024e1:	8d 45 c2             	lea    -0x3e(%ebp),%eax
801024e4:	5a                   	pop    %edx
801024e5:	50                   	push   %eax
801024e6:	ff 73 10             	pushl  0x10(%ebx)
801024e9:	e8 42 ff ff ff       	call   80102430 <itoa>
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ];
  uint off;

  if(0 == p->swapFile)
801024ee:	8b 43 7c             	mov    0x7c(%ebx),%eax
801024f1:	83 c4 10             	add    $0x10,%esp
801024f4:	85 c0                	test   %eax,%eax
801024f6:	0f 84 7a 01 00 00    	je     80102676 <removeSwapFile+0x1b6>
  {
    return -1;
  }
  fileclose(p->swapFile);
801024fc:	83 ec 0c             	sub    $0xc,%esp
  return namex(path, 1, name);
801024ff:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  fileclose(p->swapFile);
80102502:	50                   	push   %eax
80102503:	e8 78 ed ff ff       	call   80101280 <fileclose>

  begin_op();
80102508:	e8 63 0f 00 00       	call   80103470 <begin_op>
  return namex(path, 1, name);
8010250d:	89 f0                	mov    %esi,%eax
8010250f:	89 d9                	mov    %ebx,%ecx
80102511:	ba 01 00 00 00       	mov    $0x1,%edx
80102516:	e8 15 fc ff ff       	call   80102130 <namex>
  if((dp = nameiparent(path, name)) == 0)
8010251b:	83 c4 10             	add    $0x10,%esp
  return namex(path, 1, name);
8010251e:	89 c6                	mov    %eax,%esi
  if((dp = nameiparent(path, name)) == 0)
80102520:	85 c0                	test   %eax,%eax
80102522:	0f 84 55 01 00 00    	je     8010267d <removeSwapFile+0x1bd>
  {
    end_op();
    return -1;
  }

  ilock(dp);
80102528:	83 ec 0c             	sub    $0xc,%esp
8010252b:	50                   	push   %eax
8010252c:	e8 ef f5 ff ff       	call   80101b20 <ilock>
  return strncmp(s, t, DIRSIZ);
80102531:	83 c4 0c             	add    $0xc,%esp
80102534:	6a 0e                	push   $0xe
80102536:	68 dd 81 10 80       	push   $0x801081dd
8010253b:	53                   	push   %ebx
8010253c:	e8 0f 2c 00 00       	call   80105150 <strncmp>

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80102541:	83 c4 10             	add    $0x10,%esp
80102544:	85 c0                	test   %eax,%eax
80102546:	0f 84 f4 00 00 00    	je     80102640 <removeSwapFile+0x180>
  return strncmp(s, t, DIRSIZ);
8010254c:	83 ec 04             	sub    $0x4,%esp
8010254f:	6a 0e                	push   $0xe
80102551:	68 dc 81 10 80       	push   $0x801081dc
80102556:	53                   	push   %ebx
80102557:	e8 f4 2b 00 00       	call   80105150 <strncmp>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010255c:	83 c4 10             	add    $0x10,%esp
8010255f:	85 c0                	test   %eax,%eax
80102561:	0f 84 d9 00 00 00    	je     80102640 <removeSwapFile+0x180>
     goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80102567:	83 ec 04             	sub    $0x4,%esp
8010256a:	8d 45 b8             	lea    -0x48(%ebp),%eax
8010256d:	50                   	push   %eax
8010256e:	53                   	push   %ebx
8010256f:	56                   	push   %esi
80102570:	e8 fb fa ff ff       	call   80102070 <dirlookup>
80102575:	83 c4 10             	add    $0x10,%esp
80102578:	89 c3                	mov    %eax,%ebx
8010257a:	85 c0                	test   %eax,%eax
8010257c:	0f 84 be 00 00 00    	je     80102640 <removeSwapFile+0x180>
    goto bad;
  ilock(ip);
80102582:	83 ec 0c             	sub    $0xc,%esp
80102585:	50                   	push   %eax
80102586:	e8 95 f5 ff ff       	call   80101b20 <ilock>

  if(ip->nlink < 1)
8010258b:	83 c4 10             	add    $0x10,%esp
8010258e:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80102593:	0f 8e 00 01 00 00    	jle    80102699 <removeSwapFile+0x1d9>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80102599:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010259e:	74 78                	je     80102618 <removeSwapFile+0x158>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
801025a0:	83 ec 04             	sub    $0x4,%esp
801025a3:	8d 7d d8             	lea    -0x28(%ebp),%edi
801025a6:	6a 10                	push   $0x10
801025a8:	6a 00                	push   $0x0
801025aa:	57                   	push   %edi
801025ab:	e8 90 2a 00 00       	call   80105040 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801025b0:	6a 10                	push   $0x10
801025b2:	ff 75 b8             	pushl  -0x48(%ebp)
801025b5:	57                   	push   %edi
801025b6:	56                   	push   %esi
801025b7:	e8 64 f9 ff ff       	call   80101f20 <writei>
801025bc:	83 c4 20             	add    $0x20,%esp
801025bf:	83 f8 10             	cmp    $0x10,%eax
801025c2:	0f 85 c4 00 00 00    	jne    8010268c <removeSwapFile+0x1cc>
    panic("unlink: writei");
  if(ip->type == T_DIR){
801025c8:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801025cd:	0f 84 8d 00 00 00    	je     80102660 <removeSwapFile+0x1a0>
  iunlock(ip);
801025d3:	83 ec 0c             	sub    $0xc,%esp
801025d6:	56                   	push   %esi
801025d7:	e8 24 f6 ff ff       	call   80101c00 <iunlock>
  iput(ip);
801025dc:	89 34 24             	mov    %esi,(%esp)
801025df:	e8 6c f6 ff ff       	call   80101c50 <iput>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);

  ip->nlink--;
801025e4:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801025e9:	89 1c 24             	mov    %ebx,(%esp)
801025ec:	e8 6f f4 ff ff       	call   80101a60 <iupdate>
  iunlock(ip);
801025f1:	89 1c 24             	mov    %ebx,(%esp)
801025f4:	e8 07 f6 ff ff       	call   80101c00 <iunlock>
  iput(ip);
801025f9:	89 1c 24             	mov    %ebx,(%esp)
801025fc:	e8 4f f6 ff ff       	call   80101c50 <iput>
  iunlockput(ip);

  end_op();
80102601:	e8 da 0e 00 00       	call   801034e0 <end_op>

  return 0;
80102606:	83 c4 10             	add    $0x10,%esp
80102609:	31 c0                	xor    %eax,%eax
  bad:
    iunlockput(dp);
    end_op();
    return -1;

}
8010260b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010260e:	5b                   	pop    %ebx
8010260f:	5e                   	pop    %esi
80102610:	5f                   	pop    %edi
80102611:	5d                   	pop    %ebp
80102612:	c3                   	ret    
80102613:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102617:	90                   	nop
  if(ip->type == T_DIR && !isdirempty(ip)){
80102618:	83 ec 0c             	sub    $0xc,%esp
8010261b:	53                   	push   %ebx
8010261c:	e8 ef 31 00 00       	call   80105810 <isdirempty>
80102621:	83 c4 10             	add    $0x10,%esp
80102624:	85 c0                	test   %eax,%eax
80102626:	0f 85 74 ff ff ff    	jne    801025a0 <removeSwapFile+0xe0>
  iunlock(ip);
8010262c:	83 ec 0c             	sub    $0xc,%esp
8010262f:	53                   	push   %ebx
80102630:	e8 cb f5 ff ff       	call   80101c00 <iunlock>
  iput(ip);
80102635:	89 1c 24             	mov    %ebx,(%esp)
80102638:	e8 13 f6 ff ff       	call   80101c50 <iput>
    goto bad;
8010263d:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80102640:	83 ec 0c             	sub    $0xc,%esp
80102643:	56                   	push   %esi
80102644:	e8 b7 f5 ff ff       	call   80101c00 <iunlock>
  iput(ip);
80102649:	89 34 24             	mov    %esi,(%esp)
8010264c:	e8 ff f5 ff ff       	call   80101c50 <iput>
    end_op();
80102651:	e8 8a 0e 00 00       	call   801034e0 <end_op>
    return -1;
80102656:	83 c4 10             	add    $0x10,%esp
80102659:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010265e:	eb ab                	jmp    8010260b <removeSwapFile+0x14b>
    iupdate(dp);
80102660:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80102663:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80102668:	56                   	push   %esi
80102669:	e8 f2 f3 ff ff       	call   80101a60 <iupdate>
8010266e:	83 c4 10             	add    $0x10,%esp
80102671:	e9 5d ff ff ff       	jmp    801025d3 <removeSwapFile+0x113>
    return -1;
80102676:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010267b:	eb 8e                	jmp    8010260b <removeSwapFile+0x14b>
    end_op();
8010267d:	e8 5e 0e 00 00       	call   801034e0 <end_op>
    return -1;
80102682:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102687:	e9 7f ff ff ff       	jmp    8010260b <removeSwapFile+0x14b>
    panic("unlink: writei");
8010268c:	83 ec 0c             	sub    $0xc,%esp
8010268f:	68 f1 81 10 80       	push   $0x801081f1
80102694:	e8 f7 dc ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80102699:	83 ec 0c             	sub    $0xc,%esp
8010269c:	68 df 81 10 80       	push   $0x801081df
801026a1:	e8 ea dc ff ff       	call   80100390 <panic>
801026a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026ad:	8d 76 00             	lea    0x0(%esi),%esi

801026b0 <createSwapFile>:


//return 0 on success
int
createSwapFile(struct proc* p)
{
801026b0:	f3 0f 1e fb          	endbr32 
801026b4:	55                   	push   %ebp
801026b5:	89 e5                	mov    %esp,%ebp
801026b7:	56                   	push   %esi
801026b8:	53                   	push   %ebx

  char path[DIGITS];
  memmove(path,"/.swap", 6);
801026b9:	8d 75 ea             	lea    -0x16(%ebp),%esi
{
801026bc:	83 ec 14             	sub    $0x14,%esp
801026bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
801026c2:	6a 06                	push   $0x6
801026c4:	68 d5 81 10 80       	push   $0x801081d5
801026c9:	56                   	push   %esi
801026ca:	e8 11 2a 00 00       	call   801050e0 <memmove>
  itoa(p->pid, path+ 6);
801026cf:	58                   	pop    %eax
801026d0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801026d3:	5a                   	pop    %edx
801026d4:	50                   	push   %eax
801026d5:	ff 73 10             	pushl  0x10(%ebx)
801026d8:	e8 53 fd ff ff       	call   80102430 <itoa>

    begin_op();
801026dd:	e8 8e 0d 00 00       	call   80103470 <begin_op>
    struct inode * in = create(path, T_FILE, 0, 0);
801026e2:	6a 00                	push   $0x0
801026e4:	6a 00                	push   $0x0
801026e6:	6a 02                	push   $0x2
801026e8:	56                   	push   %esi
801026e9:	e8 42 33 00 00       	call   80105a30 <create>
  iunlock(in);
801026ee:	83 c4 14             	add    $0x14,%esp
801026f1:	50                   	push   %eax
    struct inode * in = create(path, T_FILE, 0, 0);
801026f2:	89 c6                	mov    %eax,%esi
  iunlock(in);
801026f4:	e8 07 f5 ff ff       	call   80101c00 <iunlock>

  p->swapFile = filealloc();
801026f9:	e8 c2 ea ff ff       	call   801011c0 <filealloc>
  if (p->swapFile == 0)
801026fe:	83 c4 10             	add    $0x10,%esp
  p->swapFile = filealloc();
80102701:	89 43 7c             	mov    %eax,0x7c(%ebx)
  if (p->swapFile == 0)
80102704:	85 c0                	test   %eax,%eax
80102706:	74 32                	je     8010273a <createSwapFile+0x8a>
    panic("no slot for files on /store");

  p->swapFile->ip = in;
80102708:	89 70 10             	mov    %esi,0x10(%eax)
  p->swapFile->type = FD_INODE;
8010270b:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010270e:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  p->swapFile->off = 0;
80102714:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102717:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  p->swapFile->readable = O_WRONLY;
8010271e:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102721:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  p->swapFile->writable = O_RDWR;
80102725:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102728:	c6 40 09 02          	movb   $0x2,0x9(%eax)
    end_op();
8010272c:	e8 af 0d 00 00       	call   801034e0 <end_op>

    return 0;
}
80102731:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102734:	31 c0                	xor    %eax,%eax
80102736:	5b                   	pop    %ebx
80102737:	5e                   	pop    %esi
80102738:	5d                   	pop    %ebp
80102739:	c3                   	ret    
    panic("no slot for files on /store");
8010273a:	83 ec 0c             	sub    $0xc,%esp
8010273d:	68 00 82 10 80       	push   $0x80108200
80102742:	e8 49 dc ff ff       	call   80100390 <panic>
80102747:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010274e:	66 90                	xchg   %ax,%ax

80102750 <writeToSwapFile>:

//return as sys_write (-1 when error)
int
writeToSwapFile(struct proc* p, char* buffer, uint placeOnFile, uint size)
{
80102750:	f3 0f 1e fb          	endbr32 
80102754:	55                   	push   %ebp
80102755:	89 e5                	mov    %esp,%ebp
80102757:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
8010275a:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010275d:	8b 50 7c             	mov    0x7c(%eax),%edx
80102760:	89 4a 14             	mov    %ecx,0x14(%edx)

  return filewrite(p->swapFile, buffer, size);
80102763:	8b 55 14             	mov    0x14(%ebp),%edx
80102766:	89 55 10             	mov    %edx,0x10(%ebp)
80102769:	8b 40 7c             	mov    0x7c(%eax),%eax
8010276c:	89 45 08             	mov    %eax,0x8(%ebp)

}
8010276f:	5d                   	pop    %ebp
  return filewrite(p->swapFile, buffer, size);
80102770:	e9 db ec ff ff       	jmp    80101450 <filewrite>
80102775:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010277c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102780 <readFromSwapFile>:

//return as sys_read (-1 when error)
int
readFromSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
80102780:	f3 0f 1e fb          	endbr32 
80102784:	55                   	push   %ebp
80102785:	89 e5                	mov    %esp,%ebp
80102787:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
8010278a:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010278d:	8b 50 7c             	mov    0x7c(%eax),%edx
80102790:	89 4a 14             	mov    %ecx,0x14(%edx)

  return fileread(p->swapFile, buffer,  size);
80102793:	8b 55 14             	mov    0x14(%ebp),%edx
80102796:	89 55 10             	mov    %edx,0x10(%ebp)
80102799:	8b 40 7c             	mov    0x7c(%eax),%eax
8010279c:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010279f:	5d                   	pop    %ebp
  return fileread(p->swapFile, buffer,  size);
801027a0:	e9 0b ec ff ff       	jmp    801013b0 <fileread>
801027a5:	66 90                	xchg   %ax,%ax
801027a7:	66 90                	xchg   %ax,%ax
801027a9:	66 90                	xchg   %ax,%ax
801027ab:	66 90                	xchg   %ax,%ax
801027ad:	66 90                	xchg   %ax,%ax
801027af:	90                   	nop

801027b0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801027b0:	55                   	push   %ebp
801027b1:	89 e5                	mov    %esp,%ebp
801027b3:	57                   	push   %edi
801027b4:	56                   	push   %esi
801027b5:	53                   	push   %ebx
801027b6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801027b9:	85 c0                	test   %eax,%eax
801027bb:	0f 84 b4 00 00 00    	je     80102875 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801027c1:	8b 70 08             	mov    0x8(%eax),%esi
801027c4:	89 c3                	mov    %eax,%ebx
801027c6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801027cc:	0f 87 96 00 00 00    	ja     80102868 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027d2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801027d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027de:	66 90                	xchg   %ax,%ax
801027e0:	89 ca                	mov    %ecx,%edx
801027e2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801027e3:	83 e0 c0             	and    $0xffffffc0,%eax
801027e6:	3c 40                	cmp    $0x40,%al
801027e8:	75 f6                	jne    801027e0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027ea:	31 ff                	xor    %edi,%edi
801027ec:	ba f6 03 00 00       	mov    $0x3f6,%edx
801027f1:	89 f8                	mov    %edi,%eax
801027f3:	ee                   	out    %al,(%dx)
801027f4:	b8 01 00 00 00       	mov    $0x1,%eax
801027f9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801027fe:	ee                   	out    %al,(%dx)
801027ff:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102804:	89 f0                	mov    %esi,%eax
80102806:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102807:	89 f0                	mov    %esi,%eax
80102809:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010280e:	c1 f8 08             	sar    $0x8,%eax
80102811:	ee                   	out    %al,(%dx)
80102812:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102817:	89 f8                	mov    %edi,%eax
80102819:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010281a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010281e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102823:	c1 e0 04             	shl    $0x4,%eax
80102826:	83 e0 10             	and    $0x10,%eax
80102829:	83 c8 e0             	or     $0xffffffe0,%eax
8010282c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010282d:	f6 03 04             	testb  $0x4,(%ebx)
80102830:	75 16                	jne    80102848 <idestart+0x98>
80102832:	b8 20 00 00 00       	mov    $0x20,%eax
80102837:	89 ca                	mov    %ecx,%edx
80102839:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010283a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010283d:	5b                   	pop    %ebx
8010283e:	5e                   	pop    %esi
8010283f:	5f                   	pop    %edi
80102840:	5d                   	pop    %ebp
80102841:	c3                   	ret    
80102842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102848:	b8 30 00 00 00       	mov    $0x30,%eax
8010284d:	89 ca                	mov    %ecx,%edx
8010284f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102850:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102855:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102858:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010285d:	fc                   	cld    
8010285e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102860:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102863:	5b                   	pop    %ebx
80102864:	5e                   	pop    %esi
80102865:	5f                   	pop    %edi
80102866:	5d                   	pop    %ebp
80102867:	c3                   	ret    
    panic("incorrect blockno");
80102868:	83 ec 0c             	sub    $0xc,%esp
8010286b:	68 78 82 10 80       	push   $0x80108278
80102870:	e8 1b db ff ff       	call   80100390 <panic>
    panic("idestart");
80102875:	83 ec 0c             	sub    $0xc,%esp
80102878:	68 6f 82 10 80       	push   $0x8010826f
8010287d:	e8 0e db ff ff       	call   80100390 <panic>
80102882:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102890 <ideinit>:
{
80102890:	f3 0f 1e fb          	endbr32 
80102894:	55                   	push   %ebp
80102895:	89 e5                	mov    %esp,%ebp
80102897:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
8010289a:	68 8a 82 10 80       	push   $0x8010828a
8010289f:	68 80 b5 10 80       	push   $0x8010b580
801028a4:	e8 07 25 00 00       	call   80104db0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801028a9:	58                   	pop    %eax
801028aa:	a1 20 3d 11 80       	mov    0x80113d20,%eax
801028af:	5a                   	pop    %edx
801028b0:	83 e8 01             	sub    $0x1,%eax
801028b3:	50                   	push   %eax
801028b4:	6a 0e                	push   $0xe
801028b6:	e8 b5 02 00 00       	call   80102b70 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801028bb:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028be:	ba f7 01 00 00       	mov    $0x1f7,%edx
801028c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028c7:	90                   	nop
801028c8:	ec                   	in     (%dx),%al
801028c9:	83 e0 c0             	and    $0xffffffc0,%eax
801028cc:	3c 40                	cmp    $0x40,%al
801028ce:	75 f8                	jne    801028c8 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028d0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801028d5:	ba f6 01 00 00       	mov    $0x1f6,%edx
801028da:	ee                   	out    %al,(%dx)
801028db:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028e0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801028e5:	eb 0e                	jmp    801028f5 <ideinit+0x65>
801028e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028ee:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
801028f0:	83 e9 01             	sub    $0x1,%ecx
801028f3:	74 0f                	je     80102904 <ideinit+0x74>
801028f5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801028f6:	84 c0                	test   %al,%al
801028f8:	74 f6                	je     801028f0 <ideinit+0x60>
      havedisk1 = 1;
801028fa:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102901:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102904:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102909:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010290e:	ee                   	out    %al,(%dx)
}
8010290f:	c9                   	leave  
80102910:	c3                   	ret    
80102911:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102918:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010291f:	90                   	nop

80102920 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102920:	f3 0f 1e fb          	endbr32 
80102924:	55                   	push   %ebp
80102925:	89 e5                	mov    %esp,%ebp
80102927:	57                   	push   %edi
80102928:	56                   	push   %esi
80102929:	53                   	push   %ebx
8010292a:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
8010292d:	68 80 b5 10 80       	push   $0x8010b580
80102932:	e8 f9 25 00 00       	call   80104f30 <acquire>

  if((b = idequeue) == 0){
80102937:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
8010293d:	83 c4 10             	add    $0x10,%esp
80102940:	85 db                	test   %ebx,%ebx
80102942:	74 5f                	je     801029a3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102944:	8b 43 58             	mov    0x58(%ebx),%eax
80102947:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010294c:	8b 33                	mov    (%ebx),%esi
8010294e:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102954:	75 2b                	jne    80102981 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102956:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010295b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010295f:	90                   	nop
80102960:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102961:	89 c1                	mov    %eax,%ecx
80102963:	83 e1 c0             	and    $0xffffffc0,%ecx
80102966:	80 f9 40             	cmp    $0x40,%cl
80102969:	75 f5                	jne    80102960 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010296b:	a8 21                	test   $0x21,%al
8010296d:	75 12                	jne    80102981 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010296f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102972:	b9 80 00 00 00       	mov    $0x80,%ecx
80102977:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010297c:	fc                   	cld    
8010297d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010297f:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102981:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102984:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102987:	83 ce 02             	or     $0x2,%esi
8010298a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010298c:	53                   	push   %ebx
8010298d:	e8 fe 20 00 00       	call   80104a90 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102992:	a1 64 b5 10 80       	mov    0x8010b564,%eax
80102997:	83 c4 10             	add    $0x10,%esp
8010299a:	85 c0                	test   %eax,%eax
8010299c:	74 05                	je     801029a3 <ideintr+0x83>
    idestart(idequeue);
8010299e:	e8 0d fe ff ff       	call   801027b0 <idestart>
    release(&idelock);
801029a3:	83 ec 0c             	sub    $0xc,%esp
801029a6:	68 80 b5 10 80       	push   $0x8010b580
801029ab:	e8 40 26 00 00       	call   80104ff0 <release>

  release(&idelock);
}
801029b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801029b3:	5b                   	pop    %ebx
801029b4:	5e                   	pop    %esi
801029b5:	5f                   	pop    %edi
801029b6:	5d                   	pop    %ebp
801029b7:	c3                   	ret    
801029b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029bf:	90                   	nop

801029c0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801029c0:	f3 0f 1e fb          	endbr32 
801029c4:	55                   	push   %ebp
801029c5:	89 e5                	mov    %esp,%ebp
801029c7:	53                   	push   %ebx
801029c8:	83 ec 10             	sub    $0x10,%esp
801029cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801029ce:	8d 43 0c             	lea    0xc(%ebx),%eax
801029d1:	50                   	push   %eax
801029d2:	e8 79 23 00 00       	call   80104d50 <holdingsleep>
801029d7:	83 c4 10             	add    $0x10,%esp
801029da:	85 c0                	test   %eax,%eax
801029dc:	0f 84 cf 00 00 00    	je     80102ab1 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801029e2:	8b 03                	mov    (%ebx),%eax
801029e4:	83 e0 06             	and    $0x6,%eax
801029e7:	83 f8 02             	cmp    $0x2,%eax
801029ea:	0f 84 b4 00 00 00    	je     80102aa4 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801029f0:	8b 53 04             	mov    0x4(%ebx),%edx
801029f3:	85 d2                	test   %edx,%edx
801029f5:	74 0d                	je     80102a04 <iderw+0x44>
801029f7:	a1 60 b5 10 80       	mov    0x8010b560,%eax
801029fc:	85 c0                	test   %eax,%eax
801029fe:	0f 84 93 00 00 00    	je     80102a97 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102a04:	83 ec 0c             	sub    $0xc,%esp
80102a07:	68 80 b5 10 80       	push   $0x8010b580
80102a0c:	e8 1f 25 00 00       	call   80104f30 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102a11:	a1 64 b5 10 80       	mov    0x8010b564,%eax
  b->qnext = 0;
80102a16:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102a1d:	83 c4 10             	add    $0x10,%esp
80102a20:	85 c0                	test   %eax,%eax
80102a22:	74 6c                	je     80102a90 <iderw+0xd0>
80102a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a28:	89 c2                	mov    %eax,%edx
80102a2a:	8b 40 58             	mov    0x58(%eax),%eax
80102a2d:	85 c0                	test   %eax,%eax
80102a2f:	75 f7                	jne    80102a28 <iderw+0x68>
80102a31:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102a34:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102a36:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
80102a3c:	74 42                	je     80102a80 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102a3e:	8b 03                	mov    (%ebx),%eax
80102a40:	83 e0 06             	and    $0x6,%eax
80102a43:	83 f8 02             	cmp    $0x2,%eax
80102a46:	74 23                	je     80102a6b <iderw+0xab>
80102a48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a4f:	90                   	nop
    sleep(b, &idelock);
80102a50:	83 ec 08             	sub    $0x8,%esp
80102a53:	68 80 b5 10 80       	push   $0x8010b580
80102a58:	53                   	push   %ebx
80102a59:	e8 d2 1d 00 00       	call   80104830 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102a5e:	8b 03                	mov    (%ebx),%eax
80102a60:	83 c4 10             	add    $0x10,%esp
80102a63:	83 e0 06             	and    $0x6,%eax
80102a66:	83 f8 02             	cmp    $0x2,%eax
80102a69:	75 e5                	jne    80102a50 <iderw+0x90>
  }


  release(&idelock);
80102a6b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102a72:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a75:	c9                   	leave  
  release(&idelock);
80102a76:	e9 75 25 00 00       	jmp    80104ff0 <release>
80102a7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a7f:	90                   	nop
    idestart(b);
80102a80:	89 d8                	mov    %ebx,%eax
80102a82:	e8 29 fd ff ff       	call   801027b0 <idestart>
80102a87:	eb b5                	jmp    80102a3e <iderw+0x7e>
80102a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102a90:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102a95:	eb 9d                	jmp    80102a34 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102a97:	83 ec 0c             	sub    $0xc,%esp
80102a9a:	68 b9 82 10 80       	push   $0x801082b9
80102a9f:	e8 ec d8 ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102aa4:	83 ec 0c             	sub    $0xc,%esp
80102aa7:	68 a4 82 10 80       	push   $0x801082a4
80102aac:	e8 df d8 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102ab1:	83 ec 0c             	sub    $0xc,%esp
80102ab4:	68 8e 82 10 80       	push   $0x8010828e
80102ab9:	e8 d2 d8 ff ff       	call   80100390 <panic>
80102abe:	66 90                	xchg   %ax,%ax

80102ac0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102ac0:	f3 0f 1e fb          	endbr32 
80102ac4:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102ac5:	c7 05 54 36 11 80 00 	movl   $0xfec00000,0x80113654
80102acc:	00 c0 fe 
{
80102acf:	89 e5                	mov    %esp,%ebp
80102ad1:	56                   	push   %esi
80102ad2:	53                   	push   %ebx
  ioapic->reg = reg;
80102ad3:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102ada:	00 00 00 
  return ioapic->data;
80102add:	8b 15 54 36 11 80    	mov    0x80113654,%edx
80102ae3:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102ae6:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102aec:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102af2:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102af9:	c1 ee 10             	shr    $0x10,%esi
80102afc:	89 f0                	mov    %esi,%eax
80102afe:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
80102b01:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102b04:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102b07:	39 c2                	cmp    %eax,%edx
80102b09:	74 16                	je     80102b21 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102b0b:	83 ec 0c             	sub    $0xc,%esp
80102b0e:	68 d8 82 10 80       	push   $0x801082d8
80102b13:	e8 98 db ff ff       	call   801006b0 <cprintf>
80102b18:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
80102b1e:	83 c4 10             	add    $0x10,%esp
80102b21:	83 c6 21             	add    $0x21,%esi
{
80102b24:	ba 10 00 00 00       	mov    $0x10,%edx
80102b29:	b8 20 00 00 00       	mov    $0x20,%eax
80102b2e:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
80102b30:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102b32:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102b34:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
80102b3a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102b3d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102b43:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102b46:	8d 5a 01             	lea    0x1(%edx),%ebx
80102b49:	83 c2 02             	add    $0x2,%edx
80102b4c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102b4e:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
80102b54:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
80102b5b:	39 f0                	cmp    %esi,%eax
80102b5d:	75 d1                	jne    80102b30 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102b5f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b62:	5b                   	pop    %ebx
80102b63:	5e                   	pop    %esi
80102b64:	5d                   	pop    %ebp
80102b65:	c3                   	ret    
80102b66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b6d:	8d 76 00             	lea    0x0(%esi),%esi

80102b70 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102b70:	f3 0f 1e fb          	endbr32 
80102b74:	55                   	push   %ebp
  ioapic->reg = reg;
80102b75:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
{
80102b7b:	89 e5                	mov    %esp,%ebp
80102b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102b80:	8d 50 20             	lea    0x20(%eax),%edx
80102b83:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102b87:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102b89:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102b8f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102b92:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102b95:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102b98:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102b9a:	a1 54 36 11 80       	mov    0x80113654,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102b9f:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102ba2:	89 50 10             	mov    %edx,0x10(%eax)
}
80102ba5:	5d                   	pop    %ebp
80102ba6:	c3                   	ret    
80102ba7:	66 90                	xchg   %ax,%ax
80102ba9:	66 90                	xchg   %ax,%ax
80102bab:	66 90                	xchg   %ax,%ax
80102bad:	66 90                	xchg   %ax,%ax
80102baf:	90                   	nop

80102bb0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102bb0:	f3 0f 1e fb          	endbr32 
80102bb4:	55                   	push   %ebp
80102bb5:	89 e5                	mov    %esp,%ebp
80102bb7:	53                   	push   %ebx
80102bb8:	83 ec 04             	sub    $0x4,%esp
80102bbb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102bbe:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102bc4:	75 7a                	jne    80102c40 <kfree+0x90>
80102bc6:	81 fb c8 29 12 80    	cmp    $0x801229c8,%ebx
80102bcc:	72 72                	jb     80102c40 <kfree+0x90>
80102bce:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102bd4:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102bd9:	77 65                	ja     80102c40 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102bdb:	83 ec 04             	sub    $0x4,%esp
80102bde:	68 00 10 00 00       	push   $0x1000
80102be3:	6a 01                	push   $0x1
80102be5:	53                   	push   %ebx
80102be6:	e8 55 24 00 00       	call   80105040 <memset>

  if(kmem.use_lock)
80102beb:	8b 15 94 36 11 80    	mov    0x80113694,%edx
80102bf1:	83 c4 10             	add    $0x10,%esp
80102bf4:	85 d2                	test   %edx,%edx
80102bf6:	75 20                	jne    80102c18 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102bf8:	a1 98 36 11 80       	mov    0x80113698,%eax
80102bfd:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102bff:	a1 94 36 11 80       	mov    0x80113694,%eax
  kmem.freelist = r;
80102c04:	89 1d 98 36 11 80    	mov    %ebx,0x80113698
  if(kmem.use_lock)
80102c0a:	85 c0                	test   %eax,%eax
80102c0c:	75 22                	jne    80102c30 <kfree+0x80>
    release(&kmem.lock);
}
80102c0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c11:	c9                   	leave  
80102c12:	c3                   	ret    
80102c13:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c17:	90                   	nop
    acquire(&kmem.lock);
80102c18:	83 ec 0c             	sub    $0xc,%esp
80102c1b:	68 60 36 11 80       	push   $0x80113660
80102c20:	e8 0b 23 00 00       	call   80104f30 <acquire>
80102c25:	83 c4 10             	add    $0x10,%esp
80102c28:	eb ce                	jmp    80102bf8 <kfree+0x48>
80102c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102c30:	c7 45 08 60 36 11 80 	movl   $0x80113660,0x8(%ebp)
}
80102c37:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c3a:	c9                   	leave  
    release(&kmem.lock);
80102c3b:	e9 b0 23 00 00       	jmp    80104ff0 <release>
    panic("kfree");
80102c40:	83 ec 0c             	sub    $0xc,%esp
80102c43:	68 0a 83 10 80       	push   $0x8010830a
80102c48:	e8 43 d7 ff ff       	call   80100390 <panic>
80102c4d:	8d 76 00             	lea    0x0(%esi),%esi

80102c50 <freerange>:
{
80102c50:	f3 0f 1e fb          	endbr32 
80102c54:	55                   	push   %ebp
80102c55:	89 e5                	mov    %esp,%ebp
80102c57:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102c58:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102c5b:	8b 75 0c             	mov    0xc(%ebp),%esi
80102c5e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102c5f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102c65:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c6b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102c71:	39 de                	cmp    %ebx,%esi
80102c73:	72 1f                	jb     80102c94 <freerange+0x44>
80102c75:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102c78:	83 ec 0c             	sub    $0xc,%esp
80102c7b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c81:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102c87:	50                   	push   %eax
80102c88:	e8 23 ff ff ff       	call   80102bb0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c8d:	83 c4 10             	add    $0x10,%esp
80102c90:	39 f3                	cmp    %esi,%ebx
80102c92:	76 e4                	jbe    80102c78 <freerange+0x28>
}
80102c94:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102c97:	5b                   	pop    %ebx
80102c98:	5e                   	pop    %esi
80102c99:	5d                   	pop    %ebp
80102c9a:	c3                   	ret    
80102c9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c9f:	90                   	nop

80102ca0 <kinit1>:
{
80102ca0:	f3 0f 1e fb          	endbr32 
80102ca4:	55                   	push   %ebp
80102ca5:	89 e5                	mov    %esp,%ebp
80102ca7:	56                   	push   %esi
80102ca8:	53                   	push   %ebx
80102ca9:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102cac:	83 ec 08             	sub    $0x8,%esp
80102caf:	68 10 83 10 80       	push   $0x80108310
80102cb4:	68 60 36 11 80       	push   $0x80113660
80102cb9:	e8 f2 20 00 00       	call   80104db0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102cc1:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102cc4:	c7 05 94 36 11 80 00 	movl   $0x0,0x80113694
80102ccb:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80102cce:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102cd4:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102cda:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102ce0:	39 de                	cmp    %ebx,%esi
80102ce2:	72 20                	jb     80102d04 <kinit1+0x64>
80102ce4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102ce8:	83 ec 0c             	sub    $0xc,%esp
80102ceb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102cf1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102cf7:	50                   	push   %eax
80102cf8:	e8 b3 fe ff ff       	call   80102bb0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102cfd:	83 c4 10             	add    $0x10,%esp
80102d00:	39 de                	cmp    %ebx,%esi
80102d02:	73 e4                	jae    80102ce8 <kinit1+0x48>
}
80102d04:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102d07:	5b                   	pop    %ebx
80102d08:	5e                   	pop    %esi
80102d09:	5d                   	pop    %ebp
80102d0a:	c3                   	ret    
80102d0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d0f:	90                   	nop

80102d10 <kinit2>:
{
80102d10:	f3 0f 1e fb          	endbr32 
80102d14:	55                   	push   %ebp
80102d15:	89 e5                	mov    %esp,%ebp
80102d17:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102d18:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102d1b:	8b 75 0c             	mov    0xc(%ebp),%esi
80102d1e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102d1f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102d25:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102d2b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102d31:	39 de                	cmp    %ebx,%esi
80102d33:	72 1f                	jb     80102d54 <kinit2+0x44>
80102d35:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102d38:	83 ec 0c             	sub    $0xc,%esp
80102d3b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102d41:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102d47:	50                   	push   %eax
80102d48:	e8 63 fe ff ff       	call   80102bb0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102d4d:	83 c4 10             	add    $0x10,%esp
80102d50:	39 de                	cmp    %ebx,%esi
80102d52:	73 e4                	jae    80102d38 <kinit2+0x28>
  kmem.use_lock = 1;
80102d54:	c7 05 94 36 11 80 01 	movl   $0x1,0x80113694
80102d5b:	00 00 00 
}
80102d5e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102d61:	5b                   	pop    %ebx
80102d62:	5e                   	pop    %esi
80102d63:	5d                   	pop    %ebp
80102d64:	c3                   	ret    
80102d65:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102d70 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102d70:	f3 0f 1e fb          	endbr32 
  struct run *r;

  if(kmem.use_lock)
80102d74:	a1 94 36 11 80       	mov    0x80113694,%eax
80102d79:	85 c0                	test   %eax,%eax
80102d7b:	75 1b                	jne    80102d98 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102d7d:	a1 98 36 11 80       	mov    0x80113698,%eax
  if(r)
80102d82:	85 c0                	test   %eax,%eax
80102d84:	74 0a                	je     80102d90 <kalloc+0x20>
    kmem.freelist = r->next;
80102d86:	8b 10                	mov    (%eax),%edx
80102d88:	89 15 98 36 11 80    	mov    %edx,0x80113698
  if(kmem.use_lock)
80102d8e:	c3                   	ret    
80102d8f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102d90:	c3                   	ret    
80102d91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102d98:	55                   	push   %ebp
80102d99:	89 e5                	mov    %esp,%ebp
80102d9b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
80102d9e:	68 60 36 11 80       	push   $0x80113660
80102da3:	e8 88 21 00 00       	call   80104f30 <acquire>
  r = kmem.freelist;
80102da8:	a1 98 36 11 80       	mov    0x80113698,%eax
  if(r)
80102dad:	8b 15 94 36 11 80    	mov    0x80113694,%edx
80102db3:	83 c4 10             	add    $0x10,%esp
80102db6:	85 c0                	test   %eax,%eax
80102db8:	74 08                	je     80102dc2 <kalloc+0x52>
    kmem.freelist = r->next;
80102dba:	8b 08                	mov    (%eax),%ecx
80102dbc:	89 0d 98 36 11 80    	mov    %ecx,0x80113698
  if(kmem.use_lock)
80102dc2:	85 d2                	test   %edx,%edx
80102dc4:	74 16                	je     80102ddc <kalloc+0x6c>
    release(&kmem.lock);
80102dc6:	83 ec 0c             	sub    $0xc,%esp
80102dc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102dcc:	68 60 36 11 80       	push   $0x80113660
80102dd1:	e8 1a 22 00 00       	call   80104ff0 <release>
  return (char*)r;
80102dd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102dd9:	83 c4 10             	add    $0x10,%esp
}
80102ddc:	c9                   	leave  
80102ddd:	c3                   	ret    
80102dde:	66 90                	xchg   %ax,%ax

80102de0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102de0:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102de4:	ba 64 00 00 00       	mov    $0x64,%edx
80102de9:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102dea:	a8 01                	test   $0x1,%al
80102dec:	0f 84 be 00 00 00    	je     80102eb0 <kbdgetc+0xd0>
{
80102df2:	55                   	push   %ebp
80102df3:	ba 60 00 00 00       	mov    $0x60,%edx
80102df8:	89 e5                	mov    %esp,%ebp
80102dfa:	53                   	push   %ebx
80102dfb:	ec                   	in     (%dx),%al
  return data;
80102dfc:	8b 1d b4 b5 10 80    	mov    0x8010b5b4,%ebx
    return -1;
  data = inb(KBDATAP);
80102e02:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80102e05:	3c e0                	cmp    $0xe0,%al
80102e07:	74 57                	je     80102e60 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102e09:	89 d9                	mov    %ebx,%ecx
80102e0b:	83 e1 40             	and    $0x40,%ecx
80102e0e:	84 c0                	test   %al,%al
80102e10:	78 5e                	js     80102e70 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102e12:	85 c9                	test   %ecx,%ecx
80102e14:	74 09                	je     80102e1f <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102e16:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102e19:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102e1c:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102e1f:	0f b6 8a 40 84 10 80 	movzbl -0x7fef7bc0(%edx),%ecx
  shift ^= togglecode[data];
80102e26:	0f b6 82 40 83 10 80 	movzbl -0x7fef7cc0(%edx),%eax
  shift |= shiftcode[data];
80102e2d:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
80102e2f:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102e31:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102e33:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102e39:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102e3c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102e3f:	8b 04 85 20 83 10 80 	mov    -0x7fef7ce0(,%eax,4),%eax
80102e46:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102e4a:	74 0b                	je     80102e57 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
80102e4c:	8d 50 9f             	lea    -0x61(%eax),%edx
80102e4f:	83 fa 19             	cmp    $0x19,%edx
80102e52:	77 44                	ja     80102e98 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102e54:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102e57:	5b                   	pop    %ebx
80102e58:	5d                   	pop    %ebp
80102e59:	c3                   	ret    
80102e5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102e60:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102e63:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102e65:	89 1d b4 b5 10 80    	mov    %ebx,0x8010b5b4
}
80102e6b:	5b                   	pop    %ebx
80102e6c:	5d                   	pop    %ebp
80102e6d:	c3                   	ret    
80102e6e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102e70:	83 e0 7f             	and    $0x7f,%eax
80102e73:	85 c9                	test   %ecx,%ecx
80102e75:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102e78:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102e7a:	0f b6 8a 40 84 10 80 	movzbl -0x7fef7bc0(%edx),%ecx
80102e81:	83 c9 40             	or     $0x40,%ecx
80102e84:	0f b6 c9             	movzbl %cl,%ecx
80102e87:	f7 d1                	not    %ecx
80102e89:	21 d9                	and    %ebx,%ecx
}
80102e8b:	5b                   	pop    %ebx
80102e8c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
80102e8d:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
80102e93:	c3                   	ret    
80102e94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102e98:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102e9b:	8d 50 20             	lea    0x20(%eax),%edx
}
80102e9e:	5b                   	pop    %ebx
80102e9f:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102ea0:	83 f9 1a             	cmp    $0x1a,%ecx
80102ea3:	0f 42 c2             	cmovb  %edx,%eax
}
80102ea6:	c3                   	ret    
80102ea7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102eae:	66 90                	xchg   %ax,%ax
    return -1;
80102eb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102eb5:	c3                   	ret    
80102eb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ebd:	8d 76 00             	lea    0x0(%esi),%esi

80102ec0 <kbdintr>:

void
kbdintr(void)
{
80102ec0:	f3 0f 1e fb          	endbr32 
80102ec4:	55                   	push   %ebp
80102ec5:	89 e5                	mov    %esp,%ebp
80102ec7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102eca:	68 e0 2d 10 80       	push   $0x80102de0
80102ecf:	e8 8c d9 ff ff       	call   80100860 <consoleintr>
}
80102ed4:	83 c4 10             	add    $0x10,%esp
80102ed7:	c9                   	leave  
80102ed8:	c3                   	ret    
80102ed9:	66 90                	xchg   %ax,%ax
80102edb:	66 90                	xchg   %ax,%ax
80102edd:	66 90                	xchg   %ax,%ax
80102edf:	90                   	nop

80102ee0 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102ee0:	f3 0f 1e fb          	endbr32 
  if(!lapic)
80102ee4:	a1 9c 36 11 80       	mov    0x8011369c,%eax
80102ee9:	85 c0                	test   %eax,%eax
80102eeb:	0f 84 c7 00 00 00    	je     80102fb8 <lapicinit+0xd8>
  lapic[index] = value;
80102ef1:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102ef8:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102efb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102efe:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102f05:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f08:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f0b:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102f12:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102f15:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f18:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102f1f:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102f22:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f25:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102f2c:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102f2f:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f32:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102f39:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102f3c:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102f3f:	8b 50 30             	mov    0x30(%eax),%edx
80102f42:	c1 ea 10             	shr    $0x10,%edx
80102f45:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102f4b:	75 73                	jne    80102fc0 <lapicinit+0xe0>
  lapic[index] = value;
80102f4d:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102f54:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f57:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f5a:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102f61:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f64:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f67:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102f6e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f71:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f74:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102f7b:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f7e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f81:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102f88:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f8b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f8e:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102f95:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102f98:	8b 50 20             	mov    0x20(%eax),%edx
80102f9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f9f:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102fa0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102fa6:	80 e6 10             	and    $0x10,%dh
80102fa9:	75 f5                	jne    80102fa0 <lapicinit+0xc0>
  lapic[index] = value;
80102fab:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102fb2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102fb5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102fb8:	c3                   	ret    
80102fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102fc0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102fc7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102fca:	8b 50 20             	mov    0x20(%eax),%edx
}
80102fcd:	e9 7b ff ff ff       	jmp    80102f4d <lapicinit+0x6d>
80102fd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102fe0 <lapicid>:

int
lapicid(void)
{
80102fe0:	f3 0f 1e fb          	endbr32 
  if (!lapic)
80102fe4:	a1 9c 36 11 80       	mov    0x8011369c,%eax
80102fe9:	85 c0                	test   %eax,%eax
80102feb:	74 0b                	je     80102ff8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
80102fed:	8b 40 20             	mov    0x20(%eax),%eax
80102ff0:	c1 e8 18             	shr    $0x18,%eax
80102ff3:	c3                   	ret    
80102ff4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80102ff8:	31 c0                	xor    %eax,%eax
}
80102ffa:	c3                   	ret    
80102ffb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102fff:	90                   	nop

80103000 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80103000:	f3 0f 1e fb          	endbr32 
  if(lapic)
80103004:	a1 9c 36 11 80       	mov    0x8011369c,%eax
80103009:	85 c0                	test   %eax,%eax
8010300b:	74 0d                	je     8010301a <lapiceoi+0x1a>
  lapic[index] = value;
8010300d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80103014:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103017:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
8010301a:	c3                   	ret    
8010301b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010301f:	90                   	nop

80103020 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80103020:	f3 0f 1e fb          	endbr32 
}
80103024:	c3                   	ret    
80103025:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010302c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103030 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80103030:	f3 0f 1e fb          	endbr32 
80103034:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103035:	b8 0f 00 00 00       	mov    $0xf,%eax
8010303a:	ba 70 00 00 00       	mov    $0x70,%edx
8010303f:	89 e5                	mov    %esp,%ebp
80103041:	53                   	push   %ebx
80103042:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103045:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103048:	ee                   	out    %al,(%dx)
80103049:	b8 0a 00 00 00       	mov    $0xa,%eax
8010304e:	ba 71 00 00 00       	mov    $0x71,%edx
80103053:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80103054:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80103056:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80103059:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010305f:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80103061:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80103064:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80103066:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80103069:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
8010306c:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80103072:	a1 9c 36 11 80       	mov    0x8011369c,%eax
80103077:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010307d:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103080:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80103087:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010308a:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010308d:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80103094:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103097:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010309a:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801030a0:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801030a3:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801030a9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801030ac:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801030b2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801030b5:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
801030bb:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
801030bc:	8b 40 20             	mov    0x20(%eax),%eax
}
801030bf:	5d                   	pop    %ebp
801030c0:	c3                   	ret    
801030c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030cf:	90                   	nop

801030d0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801030d0:	f3 0f 1e fb          	endbr32 
801030d4:	55                   	push   %ebp
801030d5:	b8 0b 00 00 00       	mov    $0xb,%eax
801030da:	ba 70 00 00 00       	mov    $0x70,%edx
801030df:	89 e5                	mov    %esp,%ebp
801030e1:	57                   	push   %edi
801030e2:	56                   	push   %esi
801030e3:	53                   	push   %ebx
801030e4:	83 ec 4c             	sub    $0x4c,%esp
801030e7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030e8:	ba 71 00 00 00       	mov    $0x71,%edx
801030ed:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801030ee:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030f1:	bb 70 00 00 00       	mov    $0x70,%ebx
801030f6:	88 45 b3             	mov    %al,-0x4d(%ebp)
801030f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103100:	31 c0                	xor    %eax,%eax
80103102:	89 da                	mov    %ebx,%edx
80103104:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103105:	b9 71 00 00 00       	mov    $0x71,%ecx
8010310a:	89 ca                	mov    %ecx,%edx
8010310c:	ec                   	in     (%dx),%al
8010310d:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103110:	89 da                	mov    %ebx,%edx
80103112:	b8 02 00 00 00       	mov    $0x2,%eax
80103117:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103118:	89 ca                	mov    %ecx,%edx
8010311a:	ec                   	in     (%dx),%al
8010311b:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010311e:	89 da                	mov    %ebx,%edx
80103120:	b8 04 00 00 00       	mov    $0x4,%eax
80103125:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103126:	89 ca                	mov    %ecx,%edx
80103128:	ec                   	in     (%dx),%al
80103129:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010312c:	89 da                	mov    %ebx,%edx
8010312e:	b8 07 00 00 00       	mov    $0x7,%eax
80103133:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103134:	89 ca                	mov    %ecx,%edx
80103136:	ec                   	in     (%dx),%al
80103137:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010313a:	89 da                	mov    %ebx,%edx
8010313c:	b8 08 00 00 00       	mov    $0x8,%eax
80103141:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103142:	89 ca                	mov    %ecx,%edx
80103144:	ec                   	in     (%dx),%al
80103145:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103147:	89 da                	mov    %ebx,%edx
80103149:	b8 09 00 00 00       	mov    $0x9,%eax
8010314e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010314f:	89 ca                	mov    %ecx,%edx
80103151:	ec                   	in     (%dx),%al
80103152:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103154:	89 da                	mov    %ebx,%edx
80103156:	b8 0a 00 00 00       	mov    $0xa,%eax
8010315b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010315c:	89 ca                	mov    %ecx,%edx
8010315e:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
8010315f:	84 c0                	test   %al,%al
80103161:	78 9d                	js     80103100 <cmostime+0x30>
  return inb(CMOS_RETURN);
80103163:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80103167:	89 fa                	mov    %edi,%edx
80103169:	0f b6 fa             	movzbl %dl,%edi
8010316c:	89 f2                	mov    %esi,%edx
8010316e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80103171:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80103175:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103178:	89 da                	mov    %ebx,%edx
8010317a:	89 7d c8             	mov    %edi,-0x38(%ebp)
8010317d:	89 45 bc             	mov    %eax,-0x44(%ebp)
80103180:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80103184:	89 75 cc             	mov    %esi,-0x34(%ebp)
80103187:	89 45 c0             	mov    %eax,-0x40(%ebp)
8010318a:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
8010318e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80103191:	31 c0                	xor    %eax,%eax
80103193:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103194:	89 ca                	mov    %ecx,%edx
80103196:	ec                   	in     (%dx),%al
80103197:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010319a:	89 da                	mov    %ebx,%edx
8010319c:	89 45 d0             	mov    %eax,-0x30(%ebp)
8010319f:	b8 02 00 00 00       	mov    $0x2,%eax
801031a4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031a5:	89 ca                	mov    %ecx,%edx
801031a7:	ec                   	in     (%dx),%al
801031a8:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031ab:	89 da                	mov    %ebx,%edx
801031ad:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801031b0:	b8 04 00 00 00       	mov    $0x4,%eax
801031b5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031b6:	89 ca                	mov    %ecx,%edx
801031b8:	ec                   	in     (%dx),%al
801031b9:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031bc:	89 da                	mov    %ebx,%edx
801031be:	89 45 d8             	mov    %eax,-0x28(%ebp)
801031c1:	b8 07 00 00 00       	mov    $0x7,%eax
801031c6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031c7:	89 ca                	mov    %ecx,%edx
801031c9:	ec                   	in     (%dx),%al
801031ca:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031cd:	89 da                	mov    %ebx,%edx
801031cf:	89 45 dc             	mov    %eax,-0x24(%ebp)
801031d2:	b8 08 00 00 00       	mov    $0x8,%eax
801031d7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031d8:	89 ca                	mov    %ecx,%edx
801031da:	ec                   	in     (%dx),%al
801031db:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031de:	89 da                	mov    %ebx,%edx
801031e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801031e3:	b8 09 00 00 00       	mov    $0x9,%eax
801031e8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031e9:	89 ca                	mov    %ecx,%edx
801031eb:	ec                   	in     (%dx),%al
801031ec:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801031ef:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
801031f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801031f5:	8d 45 d0             	lea    -0x30(%ebp),%eax
801031f8:	6a 18                	push   $0x18
801031fa:	50                   	push   %eax
801031fb:	8d 45 b8             	lea    -0x48(%ebp),%eax
801031fe:	50                   	push   %eax
801031ff:	e8 8c 1e 00 00       	call   80105090 <memcmp>
80103204:	83 c4 10             	add    $0x10,%esp
80103207:	85 c0                	test   %eax,%eax
80103209:	0f 85 f1 fe ff ff    	jne    80103100 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
8010320f:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80103213:	75 78                	jne    8010328d <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103215:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103218:	89 c2                	mov    %eax,%edx
8010321a:	83 e0 0f             	and    $0xf,%eax
8010321d:	c1 ea 04             	shr    $0x4,%edx
80103220:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103223:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103226:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80103229:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010322c:	89 c2                	mov    %eax,%edx
8010322e:	83 e0 0f             	and    $0xf,%eax
80103231:	c1 ea 04             	shr    $0x4,%edx
80103234:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103237:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010323a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
8010323d:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103240:	89 c2                	mov    %eax,%edx
80103242:	83 e0 0f             	and    $0xf,%eax
80103245:	c1 ea 04             	shr    $0x4,%edx
80103248:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010324b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010324e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80103251:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103254:	89 c2                	mov    %eax,%edx
80103256:	83 e0 0f             	and    $0xf,%eax
80103259:	c1 ea 04             	shr    $0x4,%edx
8010325c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010325f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103262:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80103265:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103268:	89 c2                	mov    %eax,%edx
8010326a:	83 e0 0f             	and    $0xf,%eax
8010326d:	c1 ea 04             	shr    $0x4,%edx
80103270:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103273:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103276:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80103279:	8b 45 cc             	mov    -0x34(%ebp),%eax
8010327c:	89 c2                	mov    %eax,%edx
8010327e:	83 e0 0f             	and    $0xf,%eax
80103281:	c1 ea 04             	shr    $0x4,%edx
80103284:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103287:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010328a:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
8010328d:	8b 75 08             	mov    0x8(%ebp),%esi
80103290:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103293:	89 06                	mov    %eax,(%esi)
80103295:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103298:	89 46 04             	mov    %eax,0x4(%esi)
8010329b:	8b 45 c0             	mov    -0x40(%ebp),%eax
8010329e:	89 46 08             	mov    %eax,0x8(%esi)
801032a1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801032a4:	89 46 0c             	mov    %eax,0xc(%esi)
801032a7:	8b 45 c8             	mov    -0x38(%ebp),%eax
801032aa:	89 46 10             	mov    %eax,0x10(%esi)
801032ad:	8b 45 cc             	mov    -0x34(%ebp),%eax
801032b0:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
801032b3:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
801032ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032bd:	5b                   	pop    %ebx
801032be:	5e                   	pop    %esi
801032bf:	5f                   	pop    %edi
801032c0:	5d                   	pop    %ebp
801032c1:	c3                   	ret    
801032c2:	66 90                	xchg   %ax,%ax
801032c4:	66 90                	xchg   %ax,%ax
801032c6:	66 90                	xchg   %ax,%ax
801032c8:	66 90                	xchg   %ax,%ax
801032ca:	66 90                	xchg   %ax,%ax
801032cc:	66 90                	xchg   %ax,%ax
801032ce:	66 90                	xchg   %ax,%ax

801032d0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801032d0:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
801032d6:	85 c9                	test   %ecx,%ecx
801032d8:	0f 8e 8a 00 00 00    	jle    80103368 <install_trans+0x98>
{
801032de:	55                   	push   %ebp
801032df:	89 e5                	mov    %esp,%ebp
801032e1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
801032e2:	31 ff                	xor    %edi,%edi
{
801032e4:	56                   	push   %esi
801032e5:	53                   	push   %ebx
801032e6:	83 ec 0c             	sub    $0xc,%esp
801032e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801032f0:	a1 d4 36 11 80       	mov    0x801136d4,%eax
801032f5:	83 ec 08             	sub    $0x8,%esp
801032f8:	01 f8                	add    %edi,%eax
801032fa:	83 c0 01             	add    $0x1,%eax
801032fd:	50                   	push   %eax
801032fe:	ff 35 e4 36 11 80    	pushl  0x801136e4
80103304:	e8 c7 cd ff ff       	call   801000d0 <bread>
80103309:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010330b:	58                   	pop    %eax
8010330c:	5a                   	pop    %edx
8010330d:	ff 34 bd ec 36 11 80 	pushl  -0x7feec914(,%edi,4)
80103314:	ff 35 e4 36 11 80    	pushl  0x801136e4
  for (tail = 0; tail < log.lh.n; tail++) {
8010331a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010331d:	e8 ae cd ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103322:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103325:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103327:	8d 46 5c             	lea    0x5c(%esi),%eax
8010332a:	68 00 02 00 00       	push   $0x200
8010332f:	50                   	push   %eax
80103330:	8d 43 5c             	lea    0x5c(%ebx),%eax
80103333:	50                   	push   %eax
80103334:	e8 a7 1d 00 00       	call   801050e0 <memmove>
    bwrite(dbuf);  // write dst to disk
80103339:	89 1c 24             	mov    %ebx,(%esp)
8010333c:	e8 6f ce ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80103341:	89 34 24             	mov    %esi,(%esp)
80103344:	e8 a7 ce ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80103349:	89 1c 24             	mov    %ebx,(%esp)
8010334c:	e8 9f ce ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103351:	83 c4 10             	add    $0x10,%esp
80103354:	39 3d e8 36 11 80    	cmp    %edi,0x801136e8
8010335a:	7f 94                	jg     801032f0 <install_trans+0x20>
  }
}
8010335c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010335f:	5b                   	pop    %ebx
80103360:	5e                   	pop    %esi
80103361:	5f                   	pop    %edi
80103362:	5d                   	pop    %ebp
80103363:	c3                   	ret    
80103364:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103368:	c3                   	ret    
80103369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103370 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103370:	55                   	push   %ebp
80103371:	89 e5                	mov    %esp,%ebp
80103373:	53                   	push   %ebx
80103374:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80103377:	ff 35 d4 36 11 80    	pushl  0x801136d4
8010337d:	ff 35 e4 36 11 80    	pushl  0x801136e4
80103383:	e8 48 cd ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103388:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
8010338b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
8010338d:	a1 e8 36 11 80       	mov    0x801136e8,%eax
80103392:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80103395:	85 c0                	test   %eax,%eax
80103397:	7e 19                	jle    801033b2 <write_head+0x42>
80103399:	31 d2                	xor    %edx,%edx
8010339b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010339f:	90                   	nop
    hb->block[i] = log.lh.block[i];
801033a0:	8b 0c 95 ec 36 11 80 	mov    -0x7feec914(,%edx,4),%ecx
801033a7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801033ab:	83 c2 01             	add    $0x1,%edx
801033ae:	39 d0                	cmp    %edx,%eax
801033b0:	75 ee                	jne    801033a0 <write_head+0x30>
  }
  bwrite(buf);
801033b2:	83 ec 0c             	sub    $0xc,%esp
801033b5:	53                   	push   %ebx
801033b6:	e8 f5 cd ff ff       	call   801001b0 <bwrite>
  brelse(buf);
801033bb:	89 1c 24             	mov    %ebx,(%esp)
801033be:	e8 2d ce ff ff       	call   801001f0 <brelse>
}
801033c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801033c6:	83 c4 10             	add    $0x10,%esp
801033c9:	c9                   	leave  
801033ca:	c3                   	ret    
801033cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801033cf:	90                   	nop

801033d0 <initlog>:
{
801033d0:	f3 0f 1e fb          	endbr32 
801033d4:	55                   	push   %ebp
801033d5:	89 e5                	mov    %esp,%ebp
801033d7:	53                   	push   %ebx
801033d8:	83 ec 2c             	sub    $0x2c,%esp
801033db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
801033de:	68 40 85 10 80       	push   $0x80108540
801033e3:	68 a0 36 11 80       	push   $0x801136a0
801033e8:	e8 c3 19 00 00       	call   80104db0 <initlock>
  readsb(dev, &sb);
801033ed:	58                   	pop    %eax
801033ee:	8d 45 dc             	lea    -0x24(%ebp),%eax
801033f1:	5a                   	pop    %edx
801033f2:	50                   	push   %eax
801033f3:	53                   	push   %ebx
801033f4:	e8 c7 e4 ff ff       	call   801018c0 <readsb>
  log.start = sb.logstart;
801033f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
801033fc:	59                   	pop    %ecx
  log.dev = dev;
801033fd:	89 1d e4 36 11 80    	mov    %ebx,0x801136e4
  log.size = sb.nlog;
80103403:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103406:	a3 d4 36 11 80       	mov    %eax,0x801136d4
  log.size = sb.nlog;
8010340b:	89 15 d8 36 11 80    	mov    %edx,0x801136d8
  struct buf *buf = bread(log.dev, log.start);
80103411:	5a                   	pop    %edx
80103412:	50                   	push   %eax
80103413:	53                   	push   %ebx
80103414:	e8 b7 cc ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80103419:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
8010341c:	8b 48 5c             	mov    0x5c(%eax),%ecx
8010341f:	89 0d e8 36 11 80    	mov    %ecx,0x801136e8
  for (i = 0; i < log.lh.n; i++) {
80103425:	85 c9                	test   %ecx,%ecx
80103427:	7e 19                	jle    80103442 <initlog+0x72>
80103429:	31 d2                	xor    %edx,%edx
8010342b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010342f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80103430:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80103434:	89 1c 95 ec 36 11 80 	mov    %ebx,-0x7feec914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010343b:	83 c2 01             	add    $0x1,%edx
8010343e:	39 d1                	cmp    %edx,%ecx
80103440:	75 ee                	jne    80103430 <initlog+0x60>
  brelse(buf);
80103442:	83 ec 0c             	sub    $0xc,%esp
80103445:	50                   	push   %eax
80103446:	e8 a5 cd ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010344b:	e8 80 fe ff ff       	call   801032d0 <install_trans>
  log.lh.n = 0;
80103450:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
80103457:	00 00 00 
  write_head(); // clear the log
8010345a:	e8 11 ff ff ff       	call   80103370 <write_head>
}
8010345f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103462:	83 c4 10             	add    $0x10,%esp
80103465:	c9                   	leave  
80103466:	c3                   	ret    
80103467:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010346e:	66 90                	xchg   %ax,%ax

80103470 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103470:	f3 0f 1e fb          	endbr32 
80103474:	55                   	push   %ebp
80103475:	89 e5                	mov    %esp,%ebp
80103477:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
8010347a:	68 a0 36 11 80       	push   $0x801136a0
8010347f:	e8 ac 1a 00 00       	call   80104f30 <acquire>
80103484:	83 c4 10             	add    $0x10,%esp
80103487:	eb 1c                	jmp    801034a5 <begin_op+0x35>
80103489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103490:	83 ec 08             	sub    $0x8,%esp
80103493:	68 a0 36 11 80       	push   $0x801136a0
80103498:	68 a0 36 11 80       	push   $0x801136a0
8010349d:	e8 8e 13 00 00       	call   80104830 <sleep>
801034a2:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
801034a5:	a1 e0 36 11 80       	mov    0x801136e0,%eax
801034aa:	85 c0                	test   %eax,%eax
801034ac:	75 e2                	jne    80103490 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801034ae:	a1 dc 36 11 80       	mov    0x801136dc,%eax
801034b3:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
801034b9:	83 c0 01             	add    $0x1,%eax
801034bc:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
801034bf:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
801034c2:	83 fa 1e             	cmp    $0x1e,%edx
801034c5:	7f c9                	jg     80103490 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
801034c7:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
801034ca:	a3 dc 36 11 80       	mov    %eax,0x801136dc
      release(&log.lock);
801034cf:	68 a0 36 11 80       	push   $0x801136a0
801034d4:	e8 17 1b 00 00       	call   80104ff0 <release>
      break;
    }
  }
}
801034d9:	83 c4 10             	add    $0x10,%esp
801034dc:	c9                   	leave  
801034dd:	c3                   	ret    
801034de:	66 90                	xchg   %ax,%ax

801034e0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801034e0:	f3 0f 1e fb          	endbr32 
801034e4:	55                   	push   %ebp
801034e5:	89 e5                	mov    %esp,%ebp
801034e7:	57                   	push   %edi
801034e8:	56                   	push   %esi
801034e9:	53                   	push   %ebx
801034ea:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
801034ed:	68 a0 36 11 80       	push   $0x801136a0
801034f2:	e8 39 1a 00 00       	call   80104f30 <acquire>
  log.outstanding -= 1;
801034f7:	a1 dc 36 11 80       	mov    0x801136dc,%eax
  if(log.committing)
801034fc:	8b 35 e0 36 11 80    	mov    0x801136e0,%esi
80103502:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103505:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103508:	89 1d dc 36 11 80    	mov    %ebx,0x801136dc
  if(log.committing)
8010350e:	85 f6                	test   %esi,%esi
80103510:	0f 85 1e 01 00 00    	jne    80103634 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80103516:	85 db                	test   %ebx,%ebx
80103518:	0f 85 f2 00 00 00    	jne    80103610 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
8010351e:	c7 05 e0 36 11 80 01 	movl   $0x1,0x801136e0
80103525:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103528:	83 ec 0c             	sub    $0xc,%esp
8010352b:	68 a0 36 11 80       	push   $0x801136a0
80103530:	e8 bb 1a 00 00       	call   80104ff0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103535:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
8010353b:	83 c4 10             	add    $0x10,%esp
8010353e:	85 c9                	test   %ecx,%ecx
80103540:	7f 3e                	jg     80103580 <end_op+0xa0>
    acquire(&log.lock);
80103542:	83 ec 0c             	sub    $0xc,%esp
80103545:	68 a0 36 11 80       	push   $0x801136a0
8010354a:	e8 e1 19 00 00       	call   80104f30 <acquire>
    wakeup(&log);
8010354f:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
    log.committing = 0;
80103556:	c7 05 e0 36 11 80 00 	movl   $0x0,0x801136e0
8010355d:	00 00 00 
    wakeup(&log);
80103560:	e8 2b 15 00 00       	call   80104a90 <wakeup>
    release(&log.lock);
80103565:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
8010356c:	e8 7f 1a 00 00       	call   80104ff0 <release>
80103571:	83 c4 10             	add    $0x10,%esp
}
80103574:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103577:	5b                   	pop    %ebx
80103578:	5e                   	pop    %esi
80103579:	5f                   	pop    %edi
8010357a:	5d                   	pop    %ebp
8010357b:	c3                   	ret    
8010357c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103580:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80103585:	83 ec 08             	sub    $0x8,%esp
80103588:	01 d8                	add    %ebx,%eax
8010358a:	83 c0 01             	add    $0x1,%eax
8010358d:	50                   	push   %eax
8010358e:	ff 35 e4 36 11 80    	pushl  0x801136e4
80103594:	e8 37 cb ff ff       	call   801000d0 <bread>
80103599:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010359b:	58                   	pop    %eax
8010359c:	5a                   	pop    %edx
8010359d:	ff 34 9d ec 36 11 80 	pushl  -0x7feec914(,%ebx,4)
801035a4:	ff 35 e4 36 11 80    	pushl  0x801136e4
  for (tail = 0; tail < log.lh.n; tail++) {
801035aa:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801035ad:	e8 1e cb ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
801035b2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801035b5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801035b7:	8d 40 5c             	lea    0x5c(%eax),%eax
801035ba:	68 00 02 00 00       	push   $0x200
801035bf:	50                   	push   %eax
801035c0:	8d 46 5c             	lea    0x5c(%esi),%eax
801035c3:	50                   	push   %eax
801035c4:	e8 17 1b 00 00       	call   801050e0 <memmove>
    bwrite(to);  // write the log
801035c9:	89 34 24             	mov    %esi,(%esp)
801035cc:	e8 df cb ff ff       	call   801001b0 <bwrite>
    brelse(from);
801035d1:	89 3c 24             	mov    %edi,(%esp)
801035d4:	e8 17 cc ff ff       	call   801001f0 <brelse>
    brelse(to);
801035d9:	89 34 24             	mov    %esi,(%esp)
801035dc:	e8 0f cc ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801035e1:	83 c4 10             	add    $0x10,%esp
801035e4:	3b 1d e8 36 11 80    	cmp    0x801136e8,%ebx
801035ea:	7c 94                	jl     80103580 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
801035ec:	e8 7f fd ff ff       	call   80103370 <write_head>
    install_trans(); // Now install writes to home locations
801035f1:	e8 da fc ff ff       	call   801032d0 <install_trans>
    log.lh.n = 0;
801035f6:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
801035fd:	00 00 00 
    write_head();    // Erase the transaction from the log
80103600:	e8 6b fd ff ff       	call   80103370 <write_head>
80103605:	e9 38 ff ff ff       	jmp    80103542 <end_op+0x62>
8010360a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103610:	83 ec 0c             	sub    $0xc,%esp
80103613:	68 a0 36 11 80       	push   $0x801136a0
80103618:	e8 73 14 00 00       	call   80104a90 <wakeup>
  release(&log.lock);
8010361d:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80103624:	e8 c7 19 00 00       	call   80104ff0 <release>
80103629:	83 c4 10             	add    $0x10,%esp
}
8010362c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010362f:	5b                   	pop    %ebx
80103630:	5e                   	pop    %esi
80103631:	5f                   	pop    %edi
80103632:	5d                   	pop    %ebp
80103633:	c3                   	ret    
    panic("log.committing");
80103634:	83 ec 0c             	sub    $0xc,%esp
80103637:	68 44 85 10 80       	push   $0x80108544
8010363c:	e8 4f cd ff ff       	call   80100390 <panic>
80103641:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103648:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010364f:	90                   	nop

80103650 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103650:	f3 0f 1e fb          	endbr32 
80103654:	55                   	push   %ebp
80103655:	89 e5                	mov    %esp,%ebp
80103657:	53                   	push   %ebx
80103658:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
8010365b:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
{
80103661:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103664:	83 fa 1d             	cmp    $0x1d,%edx
80103667:	0f 8f 91 00 00 00    	jg     801036fe <log_write+0xae>
8010366d:	a1 d8 36 11 80       	mov    0x801136d8,%eax
80103672:	83 e8 01             	sub    $0x1,%eax
80103675:	39 c2                	cmp    %eax,%edx
80103677:	0f 8d 81 00 00 00    	jge    801036fe <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
8010367d:	a1 dc 36 11 80       	mov    0x801136dc,%eax
80103682:	85 c0                	test   %eax,%eax
80103684:	0f 8e 81 00 00 00    	jle    8010370b <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010368a:	83 ec 0c             	sub    $0xc,%esp
8010368d:	68 a0 36 11 80       	push   $0x801136a0
80103692:	e8 99 18 00 00       	call   80104f30 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103697:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
8010369d:	83 c4 10             	add    $0x10,%esp
801036a0:	85 d2                	test   %edx,%edx
801036a2:	7e 4e                	jle    801036f2 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801036a4:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
801036a7:	31 c0                	xor    %eax,%eax
801036a9:	eb 0c                	jmp    801036b7 <log_write+0x67>
801036ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801036af:	90                   	nop
801036b0:	83 c0 01             	add    $0x1,%eax
801036b3:	39 c2                	cmp    %eax,%edx
801036b5:	74 29                	je     801036e0 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801036b7:	39 0c 85 ec 36 11 80 	cmp    %ecx,-0x7feec914(,%eax,4)
801036be:	75 f0                	jne    801036b0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
801036c0:	89 0c 85 ec 36 11 80 	mov    %ecx,-0x7feec914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
801036c7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
801036ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
801036cd:	c7 45 08 a0 36 11 80 	movl   $0x801136a0,0x8(%ebp)
}
801036d4:	c9                   	leave  
  release(&log.lock);
801036d5:	e9 16 19 00 00       	jmp    80104ff0 <release>
801036da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801036e0:	89 0c 95 ec 36 11 80 	mov    %ecx,-0x7feec914(,%edx,4)
    log.lh.n++;
801036e7:	83 c2 01             	add    $0x1,%edx
801036ea:	89 15 e8 36 11 80    	mov    %edx,0x801136e8
801036f0:	eb d5                	jmp    801036c7 <log_write+0x77>
  log.lh.block[i] = b->blockno;
801036f2:	8b 43 08             	mov    0x8(%ebx),%eax
801036f5:	a3 ec 36 11 80       	mov    %eax,0x801136ec
  if (i == log.lh.n)
801036fa:	75 cb                	jne    801036c7 <log_write+0x77>
801036fc:	eb e9                	jmp    801036e7 <log_write+0x97>
    panic("too big a transaction");
801036fe:	83 ec 0c             	sub    $0xc,%esp
80103701:	68 53 85 10 80       	push   $0x80108553
80103706:	e8 85 cc ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
8010370b:	83 ec 0c             	sub    $0xc,%esp
8010370e:	68 69 85 10 80       	push   $0x80108569
80103713:	e8 78 cc ff ff       	call   80100390 <panic>
80103718:	66 90                	xchg   %ax,%ax
8010371a:	66 90                	xchg   %ax,%ax
8010371c:	66 90                	xchg   %ax,%ax
8010371e:	66 90                	xchg   %ax,%ax

80103720 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103720:	55                   	push   %ebp
80103721:	89 e5                	mov    %esp,%ebp
80103723:	53                   	push   %ebx
80103724:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103727:	e8 c4 09 00 00       	call   801040f0 <cpuid>
8010372c:	89 c3                	mov    %eax,%ebx
8010372e:	e8 bd 09 00 00       	call   801040f0 <cpuid>
80103733:	83 ec 04             	sub    $0x4,%esp
80103736:	53                   	push   %ebx
80103737:	50                   	push   %eax
80103738:	68 84 85 10 80       	push   $0x80108584
8010373d:	e8 6e cf ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103742:	e8 c9 2b 00 00       	call   80106310 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103747:	e8 34 09 00 00       	call   80104080 <mycpu>
8010374c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010374e:	b8 01 00 00 00       	mov    $0x1,%eax
80103753:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010375a:	e8 e1 0d 00 00       	call   80104540 <scheduler>
8010375f:	90                   	nop

80103760 <mpenter>:
{
80103760:	f3 0f 1e fb          	endbr32 
80103764:	55                   	push   %ebp
80103765:	89 e5                	mov    %esp,%ebp
80103767:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010376a:	e8 01 3d 00 00       	call   80107470 <switchkvm>
  seginit();
8010376f:	e8 4c 3c 00 00       	call   801073c0 <seginit>
  lapicinit();
80103774:	e8 67 f7 ff ff       	call   80102ee0 <lapicinit>
  mpmain();
80103779:	e8 a2 ff ff ff       	call   80103720 <mpmain>
8010377e:	66 90                	xchg   %ax,%ax

80103780 <main>:
{
80103780:	f3 0f 1e fb          	endbr32 
80103784:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103788:	83 e4 f0             	and    $0xfffffff0,%esp
8010378b:	ff 71 fc             	pushl  -0x4(%ecx)
8010378e:	55                   	push   %ebp
8010378f:	89 e5                	mov    %esp,%ebp
80103791:	53                   	push   %ebx
80103792:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103793:	83 ec 08             	sub    $0x8,%esp
80103796:	68 00 00 40 80       	push   $0x80400000
8010379b:	68 c8 29 12 80       	push   $0x801229c8
801037a0:	e8 fb f4 ff ff       	call   80102ca0 <kinit1>
  kvmalloc();      // kernel page table
801037a5:	e8 96 41 00 00       	call   80107940 <kvmalloc>
  mpinit();        // detect other processors
801037aa:	e8 81 01 00 00       	call   80103930 <mpinit>
  lapicinit();     // interrupt controller
801037af:	e8 2c f7 ff ff       	call   80102ee0 <lapicinit>
  seginit();       // segment descriptors
801037b4:	e8 07 3c 00 00       	call   801073c0 <seginit>
  picinit();       // disable pic
801037b9:	e8 52 03 00 00       	call   80103b10 <picinit>
  ioapicinit();    // another interrupt controller
801037be:	e8 fd f2 ff ff       	call   80102ac0 <ioapicinit>
  consoleinit();   // console hardware
801037c3:	e8 68 d2 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
801037c8:	e8 e3 2e 00 00       	call   801066b0 <uartinit>
  pinit();         // process table
801037cd:	e8 8e 08 00 00       	call   80104060 <pinit>
  tvinit();        // trap vectors
801037d2:	e8 b9 2a 00 00       	call   80106290 <tvinit>
  binit();         // buffer cache
801037d7:	e8 64 c8 ff ff       	call   80100040 <binit>
  fileinit();      // file table
801037dc:	e8 bf d9 ff ff       	call   801011a0 <fileinit>
  ideinit();       // disk 
801037e1:	e8 aa f0 ff ff       	call   80102890 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801037e6:	83 c4 0c             	add    $0xc,%esp
801037e9:	68 8a 00 00 00       	push   $0x8a
801037ee:	68 8c b4 10 80       	push   $0x8010b48c
801037f3:	68 00 70 00 80       	push   $0x80007000
801037f8:	e8 e3 18 00 00       	call   801050e0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801037fd:	83 c4 10             	add    $0x10,%esp
80103800:	69 05 20 3d 11 80 b0 	imul   $0xb0,0x80113d20,%eax
80103807:	00 00 00 
8010380a:	05 a0 37 11 80       	add    $0x801137a0,%eax
8010380f:	3d a0 37 11 80       	cmp    $0x801137a0,%eax
80103814:	76 7a                	jbe    80103890 <main+0x110>
80103816:	bb a0 37 11 80       	mov    $0x801137a0,%ebx
8010381b:	eb 1c                	jmp    80103839 <main+0xb9>
8010381d:	8d 76 00             	lea    0x0(%esi),%esi
80103820:	69 05 20 3d 11 80 b0 	imul   $0xb0,0x80113d20,%eax
80103827:	00 00 00 
8010382a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103830:	05 a0 37 11 80       	add    $0x801137a0,%eax
80103835:	39 c3                	cmp    %eax,%ebx
80103837:	73 57                	jae    80103890 <main+0x110>
    if(c == mycpu())  // We've started already.
80103839:	e8 42 08 00 00       	call   80104080 <mycpu>
8010383e:	39 c3                	cmp    %eax,%ebx
80103840:	74 de                	je     80103820 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103842:	e8 29 f5 ff ff       	call   80102d70 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103847:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010384a:	c7 05 f8 6f 00 80 60 	movl   $0x80103760,0x80006ff8
80103851:	37 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103854:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010385b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010385e:	05 00 10 00 00       	add    $0x1000,%eax
80103863:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103868:	0f b6 03             	movzbl (%ebx),%eax
8010386b:	68 00 70 00 00       	push   $0x7000
80103870:	50                   	push   %eax
80103871:	e8 ba f7 ff ff       	call   80103030 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103876:	83 c4 10             	add    $0x10,%esp
80103879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103880:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103886:	85 c0                	test   %eax,%eax
80103888:	74 f6                	je     80103880 <main+0x100>
8010388a:	eb 94                	jmp    80103820 <main+0xa0>
8010388c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103890:	83 ec 08             	sub    $0x8,%esp
80103893:	68 00 00 00 8e       	push   $0x8e000000
80103898:	68 00 00 40 80       	push   $0x80400000
8010389d:	e8 6e f4 ff ff       	call   80102d10 <kinit2>
  userinit();      // first user process
801038a2:	e8 99 08 00 00       	call   80104140 <userinit>
  mpmain();        // finish this processor's setup
801038a7:	e8 74 fe ff ff       	call   80103720 <mpmain>
801038ac:	66 90                	xchg   %ax,%ax
801038ae:	66 90                	xchg   %ax,%ax

801038b0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801038b0:	55                   	push   %ebp
801038b1:	89 e5                	mov    %esp,%ebp
801038b3:	57                   	push   %edi
801038b4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801038b5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801038bb:	53                   	push   %ebx
  e = addr+len;
801038bc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801038bf:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801038c2:	39 de                	cmp    %ebx,%esi
801038c4:	72 10                	jb     801038d6 <mpsearch1+0x26>
801038c6:	eb 50                	jmp    80103918 <mpsearch1+0x68>
801038c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038cf:	90                   	nop
801038d0:	89 fe                	mov    %edi,%esi
801038d2:	39 fb                	cmp    %edi,%ebx
801038d4:	76 42                	jbe    80103918 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801038d6:	83 ec 04             	sub    $0x4,%esp
801038d9:	8d 7e 10             	lea    0x10(%esi),%edi
801038dc:	6a 04                	push   $0x4
801038de:	68 98 85 10 80       	push   $0x80108598
801038e3:	56                   	push   %esi
801038e4:	e8 a7 17 00 00       	call   80105090 <memcmp>
801038e9:	83 c4 10             	add    $0x10,%esp
801038ec:	85 c0                	test   %eax,%eax
801038ee:	75 e0                	jne    801038d0 <mpsearch1+0x20>
801038f0:	89 f2                	mov    %esi,%edx
801038f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801038f8:	0f b6 0a             	movzbl (%edx),%ecx
801038fb:	83 c2 01             	add    $0x1,%edx
801038fe:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103900:	39 fa                	cmp    %edi,%edx
80103902:	75 f4                	jne    801038f8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103904:	84 c0                	test   %al,%al
80103906:	75 c8                	jne    801038d0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103908:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010390b:	89 f0                	mov    %esi,%eax
8010390d:	5b                   	pop    %ebx
8010390e:	5e                   	pop    %esi
8010390f:	5f                   	pop    %edi
80103910:	5d                   	pop    %ebp
80103911:	c3                   	ret    
80103912:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103918:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010391b:	31 f6                	xor    %esi,%esi
}
8010391d:	5b                   	pop    %ebx
8010391e:	89 f0                	mov    %esi,%eax
80103920:	5e                   	pop    %esi
80103921:	5f                   	pop    %edi
80103922:	5d                   	pop    %ebp
80103923:	c3                   	ret    
80103924:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010392b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010392f:	90                   	nop

80103930 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103930:	f3 0f 1e fb          	endbr32 
80103934:	55                   	push   %ebp
80103935:	89 e5                	mov    %esp,%ebp
80103937:	57                   	push   %edi
80103938:	56                   	push   %esi
80103939:	53                   	push   %ebx
8010393a:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
8010393d:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103944:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
8010394b:	c1 e0 08             	shl    $0x8,%eax
8010394e:	09 d0                	or     %edx,%eax
80103950:	c1 e0 04             	shl    $0x4,%eax
80103953:	75 1b                	jne    80103970 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103955:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010395c:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103963:	c1 e0 08             	shl    $0x8,%eax
80103966:	09 d0                	or     %edx,%eax
80103968:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
8010396b:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103970:	ba 00 04 00 00       	mov    $0x400,%edx
80103975:	e8 36 ff ff ff       	call   801038b0 <mpsearch1>
8010397a:	89 c6                	mov    %eax,%esi
8010397c:	85 c0                	test   %eax,%eax
8010397e:	0f 84 4c 01 00 00    	je     80103ad0 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103984:	8b 5e 04             	mov    0x4(%esi),%ebx
80103987:	85 db                	test   %ebx,%ebx
80103989:	0f 84 61 01 00 00    	je     80103af0 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
8010398f:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103992:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103998:	6a 04                	push   $0x4
8010399a:	68 9d 85 10 80       	push   $0x8010859d
8010399f:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801039a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801039a3:	e8 e8 16 00 00       	call   80105090 <memcmp>
801039a8:	83 c4 10             	add    $0x10,%esp
801039ab:	85 c0                	test   %eax,%eax
801039ad:	0f 85 3d 01 00 00    	jne    80103af0 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
801039b3:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801039ba:	3c 01                	cmp    $0x1,%al
801039bc:	74 08                	je     801039c6 <mpinit+0x96>
801039be:	3c 04                	cmp    $0x4,%al
801039c0:	0f 85 2a 01 00 00    	jne    80103af0 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
801039c6:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
801039cd:	66 85 d2             	test   %dx,%dx
801039d0:	74 26                	je     801039f8 <mpinit+0xc8>
801039d2:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
801039d5:	89 d8                	mov    %ebx,%eax
  sum = 0;
801039d7:	31 d2                	xor    %edx,%edx
801039d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801039e0:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
801039e7:	83 c0 01             	add    $0x1,%eax
801039ea:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801039ec:	39 f8                	cmp    %edi,%eax
801039ee:	75 f0                	jne    801039e0 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
801039f0:	84 d2                	test   %dl,%dl
801039f2:	0f 85 f8 00 00 00    	jne    80103af0 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801039f8:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801039fe:	a3 9c 36 11 80       	mov    %eax,0x8011369c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103a03:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80103a09:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
80103a10:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103a15:	03 55 e4             	add    -0x1c(%ebp),%edx
80103a18:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103a1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a1f:	90                   	nop
80103a20:	39 c2                	cmp    %eax,%edx
80103a22:	76 15                	jbe    80103a39 <mpinit+0x109>
    switch(*p){
80103a24:	0f b6 08             	movzbl (%eax),%ecx
80103a27:	80 f9 02             	cmp    $0x2,%cl
80103a2a:	74 5c                	je     80103a88 <mpinit+0x158>
80103a2c:	77 42                	ja     80103a70 <mpinit+0x140>
80103a2e:	84 c9                	test   %cl,%cl
80103a30:	74 6e                	je     80103aa0 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103a32:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103a35:	39 c2                	cmp    %eax,%edx
80103a37:	77 eb                	ja     80103a24 <mpinit+0xf4>
80103a39:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103a3c:	85 db                	test   %ebx,%ebx
80103a3e:	0f 84 b9 00 00 00    	je     80103afd <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103a44:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103a48:	74 15                	je     80103a5f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103a4a:	b8 70 00 00 00       	mov    $0x70,%eax
80103a4f:	ba 22 00 00 00       	mov    $0x22,%edx
80103a54:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103a55:	ba 23 00 00 00       	mov    $0x23,%edx
80103a5a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103a5b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103a5e:	ee                   	out    %al,(%dx)
  }
}
80103a5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a62:	5b                   	pop    %ebx
80103a63:	5e                   	pop    %esi
80103a64:	5f                   	pop    %edi
80103a65:	5d                   	pop    %ebp
80103a66:	c3                   	ret    
80103a67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a6e:	66 90                	xchg   %ax,%ax
    switch(*p){
80103a70:	83 e9 03             	sub    $0x3,%ecx
80103a73:	80 f9 01             	cmp    $0x1,%cl
80103a76:	76 ba                	jbe    80103a32 <mpinit+0x102>
80103a78:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80103a7f:	eb 9f                	jmp    80103a20 <mpinit+0xf0>
80103a81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103a88:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103a8c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103a8f:	88 0d 80 37 11 80    	mov    %cl,0x80113780
      continue;
80103a95:	eb 89                	jmp    80103a20 <mpinit+0xf0>
80103a97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a9e:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103aa0:	8b 0d 20 3d 11 80    	mov    0x80113d20,%ecx
80103aa6:	83 f9 07             	cmp    $0x7,%ecx
80103aa9:	7f 19                	jg     80103ac4 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103aab:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103ab1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103ab5:	83 c1 01             	add    $0x1,%ecx
80103ab8:	89 0d 20 3d 11 80    	mov    %ecx,0x80113d20
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103abe:	88 9f a0 37 11 80    	mov    %bl,-0x7feec860(%edi)
      p += sizeof(struct mpproc);
80103ac4:	83 c0 14             	add    $0x14,%eax
      continue;
80103ac7:	e9 54 ff ff ff       	jmp    80103a20 <mpinit+0xf0>
80103acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
80103ad0:	ba 00 00 01 00       	mov    $0x10000,%edx
80103ad5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103ada:	e8 d1 fd ff ff       	call   801038b0 <mpsearch1>
80103adf:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103ae1:	85 c0                	test   %eax,%eax
80103ae3:	0f 85 9b fe ff ff    	jne    80103984 <mpinit+0x54>
80103ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103af0:	83 ec 0c             	sub    $0xc,%esp
80103af3:	68 a2 85 10 80       	push   $0x801085a2
80103af8:	e8 93 c8 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
80103afd:	83 ec 0c             	sub    $0xc,%esp
80103b00:	68 bc 85 10 80       	push   $0x801085bc
80103b05:	e8 86 c8 ff ff       	call   80100390 <panic>
80103b0a:	66 90                	xchg   %ax,%ax
80103b0c:	66 90                	xchg   %ax,%ax
80103b0e:	66 90                	xchg   %ax,%ax

80103b10 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103b10:	f3 0f 1e fb          	endbr32 
80103b14:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b19:	ba 21 00 00 00       	mov    $0x21,%edx
80103b1e:	ee                   	out    %al,(%dx)
80103b1f:	ba a1 00 00 00       	mov    $0xa1,%edx
80103b24:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103b25:	c3                   	ret    
80103b26:	66 90                	xchg   %ax,%ax
80103b28:	66 90                	xchg   %ax,%ax
80103b2a:	66 90                	xchg   %ax,%ax
80103b2c:	66 90                	xchg   %ax,%ax
80103b2e:	66 90                	xchg   %ax,%ax

80103b30 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103b30:	f3 0f 1e fb          	endbr32 
80103b34:	55                   	push   %ebp
80103b35:	89 e5                	mov    %esp,%ebp
80103b37:	57                   	push   %edi
80103b38:	56                   	push   %esi
80103b39:	53                   	push   %ebx
80103b3a:	83 ec 0c             	sub    $0xc,%esp
80103b3d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103b40:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103b43:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103b49:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103b4f:	e8 6c d6 ff ff       	call   801011c0 <filealloc>
80103b54:	89 03                	mov    %eax,(%ebx)
80103b56:	85 c0                	test   %eax,%eax
80103b58:	0f 84 ac 00 00 00    	je     80103c0a <pipealloc+0xda>
80103b5e:	e8 5d d6 ff ff       	call   801011c0 <filealloc>
80103b63:	89 06                	mov    %eax,(%esi)
80103b65:	85 c0                	test   %eax,%eax
80103b67:	0f 84 8b 00 00 00    	je     80103bf8 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103b6d:	e8 fe f1 ff ff       	call   80102d70 <kalloc>
80103b72:	89 c7                	mov    %eax,%edi
80103b74:	85 c0                	test   %eax,%eax
80103b76:	0f 84 b4 00 00 00    	je     80103c30 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
80103b7c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103b83:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103b86:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103b89:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103b90:	00 00 00 
  p->nwrite = 0;
80103b93:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103b9a:	00 00 00 
  p->nread = 0;
80103b9d:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103ba4:	00 00 00 
  initlock(&p->lock, "pipe");
80103ba7:	68 db 85 10 80       	push   $0x801085db
80103bac:	50                   	push   %eax
80103bad:	e8 fe 11 00 00       	call   80104db0 <initlock>
  (*f0)->type = FD_PIPE;
80103bb2:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103bb4:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103bb7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103bbd:	8b 03                	mov    (%ebx),%eax
80103bbf:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103bc3:	8b 03                	mov    (%ebx),%eax
80103bc5:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103bc9:	8b 03                	mov    (%ebx),%eax
80103bcb:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103bce:	8b 06                	mov    (%esi),%eax
80103bd0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103bd6:	8b 06                	mov    (%esi),%eax
80103bd8:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103bdc:	8b 06                	mov    (%esi),%eax
80103bde:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103be2:	8b 06                	mov    (%esi),%eax
80103be4:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103be7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103bea:	31 c0                	xor    %eax,%eax
}
80103bec:	5b                   	pop    %ebx
80103bed:	5e                   	pop    %esi
80103bee:	5f                   	pop    %edi
80103bef:	5d                   	pop    %ebp
80103bf0:	c3                   	ret    
80103bf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103bf8:	8b 03                	mov    (%ebx),%eax
80103bfa:	85 c0                	test   %eax,%eax
80103bfc:	74 1e                	je     80103c1c <pipealloc+0xec>
    fileclose(*f0);
80103bfe:	83 ec 0c             	sub    $0xc,%esp
80103c01:	50                   	push   %eax
80103c02:	e8 79 d6 ff ff       	call   80101280 <fileclose>
80103c07:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103c0a:	8b 06                	mov    (%esi),%eax
80103c0c:	85 c0                	test   %eax,%eax
80103c0e:	74 0c                	je     80103c1c <pipealloc+0xec>
    fileclose(*f1);
80103c10:	83 ec 0c             	sub    $0xc,%esp
80103c13:	50                   	push   %eax
80103c14:	e8 67 d6 ff ff       	call   80101280 <fileclose>
80103c19:	83 c4 10             	add    $0x10,%esp
}
80103c1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103c1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103c24:	5b                   	pop    %ebx
80103c25:	5e                   	pop    %esi
80103c26:	5f                   	pop    %edi
80103c27:	5d                   	pop    %ebp
80103c28:	c3                   	ret    
80103c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103c30:	8b 03                	mov    (%ebx),%eax
80103c32:	85 c0                	test   %eax,%eax
80103c34:	75 c8                	jne    80103bfe <pipealloc+0xce>
80103c36:	eb d2                	jmp    80103c0a <pipealloc+0xda>
80103c38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c3f:	90                   	nop

80103c40 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103c40:	f3 0f 1e fb          	endbr32 
80103c44:	55                   	push   %ebp
80103c45:	89 e5                	mov    %esp,%ebp
80103c47:	56                   	push   %esi
80103c48:	53                   	push   %ebx
80103c49:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103c4c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80103c4f:	83 ec 0c             	sub    $0xc,%esp
80103c52:	53                   	push   %ebx
80103c53:	e8 d8 12 00 00       	call   80104f30 <acquire>
  if(writable){
80103c58:	83 c4 10             	add    $0x10,%esp
80103c5b:	85 f6                	test   %esi,%esi
80103c5d:	74 41                	je     80103ca0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
80103c5f:	83 ec 0c             	sub    $0xc,%esp
80103c62:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103c68:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103c6f:	00 00 00 
    wakeup(&p->nread);
80103c72:	50                   	push   %eax
80103c73:	e8 18 0e 00 00       	call   80104a90 <wakeup>
80103c78:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103c7b:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103c81:	85 d2                	test   %edx,%edx
80103c83:	75 0a                	jne    80103c8f <pipeclose+0x4f>
80103c85:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103c8b:	85 c0                	test   %eax,%eax
80103c8d:	74 31                	je     80103cc0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103c8f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103c92:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c95:	5b                   	pop    %ebx
80103c96:	5e                   	pop    %esi
80103c97:	5d                   	pop    %ebp
    release(&p->lock);
80103c98:	e9 53 13 00 00       	jmp    80104ff0 <release>
80103c9d:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103ca0:	83 ec 0c             	sub    $0xc,%esp
80103ca3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103ca9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103cb0:	00 00 00 
    wakeup(&p->nwrite);
80103cb3:	50                   	push   %eax
80103cb4:	e8 d7 0d 00 00       	call   80104a90 <wakeup>
80103cb9:	83 c4 10             	add    $0x10,%esp
80103cbc:	eb bd                	jmp    80103c7b <pipeclose+0x3b>
80103cbe:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103cc0:	83 ec 0c             	sub    $0xc,%esp
80103cc3:	53                   	push   %ebx
80103cc4:	e8 27 13 00 00       	call   80104ff0 <release>
    kfree((char*)p);
80103cc9:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103ccc:	83 c4 10             	add    $0x10,%esp
}
80103ccf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103cd2:	5b                   	pop    %ebx
80103cd3:	5e                   	pop    %esi
80103cd4:	5d                   	pop    %ebp
    kfree((char*)p);
80103cd5:	e9 d6 ee ff ff       	jmp    80102bb0 <kfree>
80103cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ce0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103ce0:	f3 0f 1e fb          	endbr32 
80103ce4:	55                   	push   %ebp
80103ce5:	89 e5                	mov    %esp,%ebp
80103ce7:	57                   	push   %edi
80103ce8:	56                   	push   %esi
80103ce9:	53                   	push   %ebx
80103cea:	83 ec 28             	sub    $0x28,%esp
80103ced:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103cf0:	53                   	push   %ebx
80103cf1:	e8 3a 12 00 00       	call   80104f30 <acquire>
  for(i = 0; i < n; i++){
80103cf6:	8b 45 10             	mov    0x10(%ebp),%eax
80103cf9:	83 c4 10             	add    $0x10,%esp
80103cfc:	85 c0                	test   %eax,%eax
80103cfe:	0f 8e bc 00 00 00    	jle    80103dc0 <pipewrite+0xe0>
80103d04:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d07:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103d0d:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103d13:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103d16:	03 45 10             	add    0x10(%ebp),%eax
80103d19:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103d1c:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103d22:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103d28:	89 ca                	mov    %ecx,%edx
80103d2a:	05 00 02 00 00       	add    $0x200,%eax
80103d2f:	39 c1                	cmp    %eax,%ecx
80103d31:	74 3b                	je     80103d6e <pipewrite+0x8e>
80103d33:	eb 63                	jmp    80103d98 <pipewrite+0xb8>
80103d35:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103d38:	e8 d3 03 00 00       	call   80104110 <myproc>
80103d3d:	8b 48 24             	mov    0x24(%eax),%ecx
80103d40:	85 c9                	test   %ecx,%ecx
80103d42:	75 34                	jne    80103d78 <pipewrite+0x98>
      wakeup(&p->nread);
80103d44:	83 ec 0c             	sub    $0xc,%esp
80103d47:	57                   	push   %edi
80103d48:	e8 43 0d 00 00       	call   80104a90 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103d4d:	58                   	pop    %eax
80103d4e:	5a                   	pop    %edx
80103d4f:	53                   	push   %ebx
80103d50:	56                   	push   %esi
80103d51:	e8 da 0a 00 00       	call   80104830 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103d56:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103d5c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103d62:	83 c4 10             	add    $0x10,%esp
80103d65:	05 00 02 00 00       	add    $0x200,%eax
80103d6a:	39 c2                	cmp    %eax,%edx
80103d6c:	75 2a                	jne    80103d98 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
80103d6e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103d74:	85 c0                	test   %eax,%eax
80103d76:	75 c0                	jne    80103d38 <pipewrite+0x58>
        release(&p->lock);
80103d78:	83 ec 0c             	sub    $0xc,%esp
80103d7b:	53                   	push   %ebx
80103d7c:	e8 6f 12 00 00       	call   80104ff0 <release>
        return -1;
80103d81:	83 c4 10             	add    $0x10,%esp
80103d84:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103d89:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d8c:	5b                   	pop    %ebx
80103d8d:	5e                   	pop    %esi
80103d8e:	5f                   	pop    %edi
80103d8f:	5d                   	pop    %ebp
80103d90:	c3                   	ret    
80103d91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103d98:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103d9b:	8d 4a 01             	lea    0x1(%edx),%ecx
80103d9e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103da4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
80103daa:	0f b6 06             	movzbl (%esi),%eax
80103dad:	83 c6 01             	add    $0x1,%esi
80103db0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103db3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103db7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103dba:	0f 85 5c ff ff ff    	jne    80103d1c <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103dc0:	83 ec 0c             	sub    $0xc,%esp
80103dc3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103dc9:	50                   	push   %eax
80103dca:	e8 c1 0c 00 00       	call   80104a90 <wakeup>
  release(&p->lock);
80103dcf:	89 1c 24             	mov    %ebx,(%esp)
80103dd2:	e8 19 12 00 00       	call   80104ff0 <release>
  return n;
80103dd7:	8b 45 10             	mov    0x10(%ebp),%eax
80103dda:	83 c4 10             	add    $0x10,%esp
80103ddd:	eb aa                	jmp    80103d89 <pipewrite+0xa9>
80103ddf:	90                   	nop

80103de0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103de0:	f3 0f 1e fb          	endbr32 
80103de4:	55                   	push   %ebp
80103de5:	89 e5                	mov    %esp,%ebp
80103de7:	57                   	push   %edi
80103de8:	56                   	push   %esi
80103de9:	53                   	push   %ebx
80103dea:	83 ec 18             	sub    $0x18,%esp
80103ded:	8b 75 08             	mov    0x8(%ebp),%esi
80103df0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103df3:	56                   	push   %esi
80103df4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103dfa:	e8 31 11 00 00       	call   80104f30 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103dff:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103e05:	83 c4 10             	add    $0x10,%esp
80103e08:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
80103e0e:	74 33                	je     80103e43 <piperead+0x63>
80103e10:	eb 3b                	jmp    80103e4d <piperead+0x6d>
80103e12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
80103e18:	e8 f3 02 00 00       	call   80104110 <myproc>
80103e1d:	8b 48 24             	mov    0x24(%eax),%ecx
80103e20:	85 c9                	test   %ecx,%ecx
80103e22:	0f 85 88 00 00 00    	jne    80103eb0 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103e28:	83 ec 08             	sub    $0x8,%esp
80103e2b:	56                   	push   %esi
80103e2c:	53                   	push   %ebx
80103e2d:	e8 fe 09 00 00       	call   80104830 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103e32:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103e38:	83 c4 10             	add    $0x10,%esp
80103e3b:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103e41:	75 0a                	jne    80103e4d <piperead+0x6d>
80103e43:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103e49:	85 c0                	test   %eax,%eax
80103e4b:	75 cb                	jne    80103e18 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103e4d:	8b 55 10             	mov    0x10(%ebp),%edx
80103e50:	31 db                	xor    %ebx,%ebx
80103e52:	85 d2                	test   %edx,%edx
80103e54:	7f 28                	jg     80103e7e <piperead+0x9e>
80103e56:	eb 34                	jmp    80103e8c <piperead+0xac>
80103e58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e5f:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103e60:	8d 48 01             	lea    0x1(%eax),%ecx
80103e63:	25 ff 01 00 00       	and    $0x1ff,%eax
80103e68:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80103e6e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103e73:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103e76:	83 c3 01             	add    $0x1,%ebx
80103e79:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103e7c:	74 0e                	je     80103e8c <piperead+0xac>
    if(p->nread == p->nwrite)
80103e7e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103e84:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103e8a:	75 d4                	jne    80103e60 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103e8c:	83 ec 0c             	sub    $0xc,%esp
80103e8f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103e95:	50                   	push   %eax
80103e96:	e8 f5 0b 00 00       	call   80104a90 <wakeup>
  release(&p->lock);
80103e9b:	89 34 24             	mov    %esi,(%esp)
80103e9e:	e8 4d 11 00 00       	call   80104ff0 <release>
  return i;
80103ea3:	83 c4 10             	add    $0x10,%esp
}
80103ea6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ea9:	89 d8                	mov    %ebx,%eax
80103eab:	5b                   	pop    %ebx
80103eac:	5e                   	pop    %esi
80103ead:	5f                   	pop    %edi
80103eae:	5d                   	pop    %ebp
80103eaf:	c3                   	ret    
      release(&p->lock);
80103eb0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103eb3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103eb8:	56                   	push   %esi
80103eb9:	e8 32 11 00 00       	call   80104ff0 <release>
      return -1;
80103ebe:	83 c4 10             	add    $0x10,%esp
}
80103ec1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ec4:	89 d8                	mov    %ebx,%eax
80103ec6:	5b                   	pop    %ebx
80103ec7:	5e                   	pop    %esi
80103ec8:	5f                   	pop    %edi
80103ec9:	5d                   	pop    %ebp
80103eca:	c3                   	ret    
80103ecb:	66 90                	xchg   %ax,%ax
80103ecd:	66 90                	xchg   %ax,%ax
80103ecf:	90                   	nop

80103ed0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103ed0:	55                   	push   %ebp
80103ed1:	89 e5                	mov    %esp,%ebp
80103ed3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ed4:	bb 74 3d 11 80       	mov    $0x80113d74,%ebx
{
80103ed9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103edc:	68 40 3d 11 80       	push   $0x80113d40
80103ee1:	e8 4a 10 00 00       	call   80104f30 <acquire>
80103ee6:	83 c4 10             	add    $0x10,%esp
80103ee9:	eb 17                	jmp    80103f02 <allocproc+0x32>
80103eeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103eef:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ef0:	81 c3 90 03 00 00    	add    $0x390,%ebx
80103ef6:	81 fb 74 21 12 80    	cmp    $0x80122174,%ebx
80103efc:	0f 84 de 00 00 00    	je     80103fe0 <allocproc+0x110>
    if(p->state == UNUSED)
80103f02:	8b 43 0c             	mov    0xc(%ebx),%eax
80103f05:	85 c0                	test   %eax,%eax
80103f07:	75 e7                	jne    80103ef0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103f09:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80103f0e:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103f11:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103f18:	89 43 10             	mov    %eax,0x10(%ebx)
80103f1b:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103f1e:	68 40 3d 11 80       	push   $0x80113d40
  p->pid = nextpid++;
80103f23:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103f29:	e8 c2 10 00 00       	call   80104ff0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103f2e:	e8 3d ee ff ff       	call   80102d70 <kalloc>
80103f33:	83 c4 10             	add    $0x10,%esp
80103f36:	89 43 08             	mov    %eax,0x8(%ebx)
80103f39:	85 c0                	test   %eax,%eax
80103f3b:	0f 84 b8 00 00 00    	je     80103ff9 <allocproc+0x129>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103f41:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103f47:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103f4a:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103f4f:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103f52:	c7 40 14 76 62 10 80 	movl   $0x80106276,0x14(%eax)
  p->context = (struct context*)sp;
80103f59:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103f5c:	6a 14                	push   $0x14
80103f5e:	6a 00                	push   $0x0
80103f60:	50                   	push   %eax
80103f61:	e8 da 10 00 00       	call   80105040 <memset>
  p->context->eip = (uint)forkret;
80103f66:	8b 43 1c             	mov    0x1c(%ebx),%eax

 if (p->pid > 2){
80103f69:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103f6c:	c7 40 10 10 40 10 80 	movl   $0x80104010,0x10(%eax)
 if (p->pid > 2){
80103f73:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
80103f77:	7f 07                	jg     80103f80 <allocproc+0xb0>
    for (int i = 0; i < 16; i++){
      p->ram_pages[i].is_free = p->swapped_out_pages[i].is_free = 1;
  }
 }
  return p;
}
80103f79:	89 d8                	mov    %ebx,%eax
80103f7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f7e:	c9                   	leave  
80103f7f:	c3                   	ret    
    p->num_of_actual_pages_in_mem = 0;
80103f80:	c7 83 84 03 00 00 00 	movl   $0x0,0x384(%ebx)
80103f87:	00 00 00 
    createSwapFile(p);
80103f8a:	83 ec 0c             	sub    $0xc,%esp
    p->num_of_pagefaults_occurs = 0;
80103f8d:	c7 83 88 03 00 00 00 	movl   $0x0,0x388(%ebx)
80103f94:	00 00 00 
    p->num_of_pageOut_occured = 0;
80103f97:	c7 83 8c 03 00 00 00 	movl   $0x0,0x38c(%ebx)
80103f9e:	00 00 00 
    p->num_of_pages_in_swap_file = 0;
80103fa1:	c7 83 80 03 00 00 00 	movl   $0x0,0x380(%ebx)
80103fa8:	00 00 00 
    createSwapFile(p);
80103fab:	53                   	push   %ebx
80103fac:	e8 ff e6 ff ff       	call   801026b0 <createSwapFile>
    for (int i = 0; i < 16; i++){
80103fb1:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
80103fb7:	8d 93 00 02 00 00    	lea    0x200(%ebx),%edx
80103fbd:	83 c4 10             	add    $0x10,%esp
      p->ram_pages[i].is_free = p->swapped_out_pages[i].is_free = 1;
80103fc0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
80103fc6:	83 c0 18             	add    $0x18,%eax
80103fc9:	c7 80 68 01 00 00 01 	movl   $0x1,0x168(%eax)
80103fd0:	00 00 00 
    for (int i = 0; i < 16; i++){
80103fd3:	39 c2                	cmp    %eax,%edx
80103fd5:	75 e9                	jne    80103fc0 <allocproc+0xf0>
}
80103fd7:	89 d8                	mov    %ebx,%eax
80103fd9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103fdc:	c9                   	leave  
80103fdd:	c3                   	ret    
80103fde:	66 90                	xchg   %ax,%ax
  release(&ptable.lock);
80103fe0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103fe3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103fe5:	68 40 3d 11 80       	push   $0x80113d40
80103fea:	e8 01 10 00 00       	call   80104ff0 <release>
}
80103fef:	89 d8                	mov    %ebx,%eax
  return 0;
80103ff1:	83 c4 10             	add    $0x10,%esp
}
80103ff4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ff7:	c9                   	leave  
80103ff8:	c3                   	ret    
    p->state = UNUSED;
80103ff9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80104000:	31 db                	xor    %ebx,%ebx
}
80104002:	89 d8                	mov    %ebx,%eax
80104004:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104007:	c9                   	leave  
80104008:	c3                   	ret    
80104009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104010 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104010:	f3 0f 1e fb          	endbr32 
80104014:	55                   	push   %ebp
80104015:	89 e5                	mov    %esp,%ebp
80104017:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
8010401a:	68 40 3d 11 80       	push   $0x80113d40
8010401f:	e8 cc 0f 00 00       	call   80104ff0 <release>

  if (first) {
80104024:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80104029:	83 c4 10             	add    $0x10,%esp
8010402c:	85 c0                	test   %eax,%eax
8010402e:	75 08                	jne    80104038 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104030:	c9                   	leave  
80104031:	c3                   	ret    
80104032:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
80104038:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
8010403f:	00 00 00 
    iinit(ROOTDEV);
80104042:	83 ec 0c             	sub    $0xc,%esp
80104045:	6a 01                	push   $0x1
80104047:	e8 b4 d8 ff ff       	call   80101900 <iinit>
    initlog(ROOTDEV);
8010404c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104053:	e8 78 f3 ff ff       	call   801033d0 <initlog>
}
80104058:	83 c4 10             	add    $0x10,%esp
8010405b:	c9                   	leave  
8010405c:	c3                   	ret    
8010405d:	8d 76 00             	lea    0x0(%esi),%esi

80104060 <pinit>:
{
80104060:	f3 0f 1e fb          	endbr32 
80104064:	55                   	push   %ebp
80104065:	89 e5                	mov    %esp,%ebp
80104067:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
8010406a:	68 e0 85 10 80       	push   $0x801085e0
8010406f:	68 40 3d 11 80       	push   $0x80113d40
80104074:	e8 37 0d 00 00       	call   80104db0 <initlock>
}
80104079:	83 c4 10             	add    $0x10,%esp
8010407c:	c9                   	leave  
8010407d:	c3                   	ret    
8010407e:	66 90                	xchg   %ax,%ax

80104080 <mycpu>:
{
80104080:	f3 0f 1e fb          	endbr32 
80104084:	55                   	push   %ebp
80104085:	89 e5                	mov    %esp,%ebp
80104087:	56                   	push   %esi
80104088:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104089:	9c                   	pushf  
8010408a:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010408b:	f6 c4 02             	test   $0x2,%ah
8010408e:	75 4a                	jne    801040da <mycpu+0x5a>
  apicid = lapicid();
80104090:	e8 4b ef ff ff       	call   80102fe0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80104095:	8b 35 20 3d 11 80    	mov    0x80113d20,%esi
  apicid = lapicid();
8010409b:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
8010409d:	85 f6                	test   %esi,%esi
8010409f:	7e 2c                	jle    801040cd <mycpu+0x4d>
801040a1:	31 d2                	xor    %edx,%edx
801040a3:	eb 0a                	jmp    801040af <mycpu+0x2f>
801040a5:	8d 76 00             	lea    0x0(%esi),%esi
801040a8:	83 c2 01             	add    $0x1,%edx
801040ab:	39 f2                	cmp    %esi,%edx
801040ad:	74 1e                	je     801040cd <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
801040af:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
801040b5:	0f b6 81 a0 37 11 80 	movzbl -0x7feec860(%ecx),%eax
801040bc:	39 d8                	cmp    %ebx,%eax
801040be:	75 e8                	jne    801040a8 <mycpu+0x28>
}
801040c0:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
801040c3:	8d 81 a0 37 11 80    	lea    -0x7feec860(%ecx),%eax
}
801040c9:	5b                   	pop    %ebx
801040ca:	5e                   	pop    %esi
801040cb:	5d                   	pop    %ebp
801040cc:	c3                   	ret    
  panic("unknown apicid\n");
801040cd:	83 ec 0c             	sub    $0xc,%esp
801040d0:	68 e7 85 10 80       	push   $0x801085e7
801040d5:	e8 b6 c2 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
801040da:	83 ec 0c             	sub    $0xc,%esp
801040dd:	68 c4 86 10 80       	push   $0x801086c4
801040e2:	e8 a9 c2 ff ff       	call   80100390 <panic>
801040e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040ee:	66 90                	xchg   %ax,%ax

801040f0 <cpuid>:
cpuid() {
801040f0:	f3 0f 1e fb          	endbr32 
801040f4:	55                   	push   %ebp
801040f5:	89 e5                	mov    %esp,%ebp
801040f7:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801040fa:	e8 81 ff ff ff       	call   80104080 <mycpu>
}
801040ff:	c9                   	leave  
  return mycpu()-cpus;
80104100:	2d a0 37 11 80       	sub    $0x801137a0,%eax
80104105:	c1 f8 04             	sar    $0x4,%eax
80104108:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010410e:	c3                   	ret    
8010410f:	90                   	nop

80104110 <myproc>:
myproc(void) {
80104110:	f3 0f 1e fb          	endbr32 
80104114:	55                   	push   %ebp
80104115:	89 e5                	mov    %esp,%ebp
80104117:	53                   	push   %ebx
80104118:	83 ec 04             	sub    $0x4,%esp
  pushcli();
8010411b:	e8 10 0d 00 00       	call   80104e30 <pushcli>
  c = mycpu();
80104120:	e8 5b ff ff ff       	call   80104080 <mycpu>
  p = c->proc;
80104125:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010412b:	e8 50 0d 00 00       	call   80104e80 <popcli>
}
80104130:	83 c4 04             	add    $0x4,%esp
80104133:	89 d8                	mov    %ebx,%eax
80104135:	5b                   	pop    %ebx
80104136:	5d                   	pop    %ebp
80104137:	c3                   	ret    
80104138:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010413f:	90                   	nop

80104140 <userinit>:
{
80104140:	f3 0f 1e fb          	endbr32 
80104144:	55                   	push   %ebp
80104145:	89 e5                	mov    %esp,%ebp
80104147:	53                   	push   %ebx
80104148:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
8010414b:	e8 80 fd ff ff       	call   80103ed0 <allocproc>
80104150:	89 c3                	mov    %eax,%ebx
  initproc = p;
80104152:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80104157:	e8 64 37 00 00       	call   801078c0 <setupkvm>
8010415c:	89 43 04             	mov    %eax,0x4(%ebx)
8010415f:	85 c0                	test   %eax,%eax
80104161:	0f 84 bd 00 00 00    	je     80104224 <userinit+0xe4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104167:	83 ec 04             	sub    $0x4,%esp
8010416a:	68 2c 00 00 00       	push   $0x2c
8010416f:	68 60 b4 10 80       	push   $0x8010b460
80104174:	50                   	push   %eax
80104175:	e8 26 34 00 00       	call   801075a0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
8010417a:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
8010417d:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80104183:	6a 4c                	push   $0x4c
80104185:	6a 00                	push   $0x0
80104187:	ff 73 18             	pushl  0x18(%ebx)
8010418a:	e8 b1 0e 00 00       	call   80105040 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010418f:	8b 43 18             	mov    0x18(%ebx),%eax
80104192:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104197:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010419a:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010419f:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801041a3:	8b 43 18             	mov    0x18(%ebx),%eax
801041a6:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801041aa:	8b 43 18             	mov    0x18(%ebx),%eax
801041ad:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801041b1:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801041b5:	8b 43 18             	mov    0x18(%ebx),%eax
801041b8:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801041bc:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801041c0:	8b 43 18             	mov    0x18(%ebx),%eax
801041c3:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801041ca:	8b 43 18             	mov    0x18(%ebx),%eax
801041cd:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801041d4:	8b 43 18             	mov    0x18(%ebx),%eax
801041d7:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801041de:	8d 43 6c             	lea    0x6c(%ebx),%eax
801041e1:	6a 10                	push   $0x10
801041e3:	68 10 86 10 80       	push   $0x80108610
801041e8:	50                   	push   %eax
801041e9:	e8 12 10 00 00       	call   80105200 <safestrcpy>
  p->cwd = namei("/");
801041ee:	c7 04 24 19 86 10 80 	movl   $0x80108619,(%esp)
801041f5:	e8 f6 e1 ff ff       	call   801023f0 <namei>
801041fa:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801041fd:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80104204:	e8 27 0d 00 00       	call   80104f30 <acquire>
  p->state = RUNNABLE;
80104209:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80104210:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80104217:	e8 d4 0d 00 00       	call   80104ff0 <release>
}
8010421c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010421f:	83 c4 10             	add    $0x10,%esp
80104222:	c9                   	leave  
80104223:	c3                   	ret    
    panic("userinit: out of memory?");
80104224:	83 ec 0c             	sub    $0xc,%esp
80104227:	68 f7 85 10 80       	push   $0x801085f7
8010422c:	e8 5f c1 ff ff       	call   80100390 <panic>
80104231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010423f:	90                   	nop

80104240 <growproc>:
{
80104240:	f3 0f 1e fb          	endbr32 
80104244:	55                   	push   %ebp
80104245:	89 e5                	mov    %esp,%ebp
80104247:	56                   	push   %esi
80104248:	53                   	push   %ebx
80104249:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
8010424c:	e8 df 0b 00 00       	call   80104e30 <pushcli>
  c = mycpu();
80104251:	e8 2a fe ff ff       	call   80104080 <mycpu>
  p = c->proc;
80104256:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010425c:	e8 1f 0c 00 00       	call   80104e80 <popcli>
  sz = curproc->sz;
80104261:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80104263:	85 f6                	test   %esi,%esi
80104265:	7f 19                	jg     80104280 <growproc+0x40>
  } else if(n < 0){
80104267:	75 37                	jne    801042a0 <growproc+0x60>
  switchuvm(curproc);
80104269:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
8010426c:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010426e:	53                   	push   %ebx
8010426f:	e8 1c 32 00 00       	call   80107490 <switchuvm>
  return 0;
80104274:	83 c4 10             	add    $0x10,%esp
80104277:	31 c0                	xor    %eax,%eax
}
80104279:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010427c:	5b                   	pop    %ebx
8010427d:	5e                   	pop    %esi
8010427e:	5d                   	pop    %ebp
8010427f:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104280:	83 ec 04             	sub    $0x4,%esp
80104283:	01 c6                	add    %eax,%esi
80104285:	56                   	push   %esi
80104286:	50                   	push   %eax
80104287:	ff 73 04             	pushl  0x4(%ebx)
8010428a:	e8 d1 39 00 00       	call   80107c60 <allocuvm>
8010428f:	83 c4 10             	add    $0x10,%esp
80104292:	85 c0                	test   %eax,%eax
80104294:	75 d3                	jne    80104269 <growproc+0x29>
      return -1;
80104296:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010429b:	eb dc                	jmp    80104279 <growproc+0x39>
8010429d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801042a0:	83 ec 04             	sub    $0x4,%esp
801042a3:	01 c6                	add    %eax,%esi
801042a5:	56                   	push   %esi
801042a6:	50                   	push   %eax
801042a7:	ff 73 04             	pushl  0x4(%ebx)
801042aa:	e8 41 34 00 00       	call   801076f0 <deallocuvm>
801042af:	83 c4 10             	add    $0x10,%esp
801042b2:	85 c0                	test   %eax,%eax
801042b4:	75 b3                	jne    80104269 <growproc+0x29>
801042b6:	eb de                	jmp    80104296 <growproc+0x56>
801042b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042bf:	90                   	nop

801042c0 <fork>:
{
801042c0:	f3 0f 1e fb          	endbr32 
801042c4:	55                   	push   %ebp
801042c5:	89 e5                	mov    %esp,%ebp
801042c7:	57                   	push   %edi
801042c8:	56                   	push   %esi
801042c9:	53                   	push   %ebx
801042ca:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
801042cd:	e8 5e 0b 00 00       	call   80104e30 <pushcli>
  c = mycpu();
801042d2:	e8 a9 fd ff ff       	call   80104080 <mycpu>
  p = c->proc;
801042d7:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042dd:	e8 9e 0b 00 00       	call   80104e80 <popcli>
  if((np = allocproc()) == 0){
801042e2:	e8 e9 fb ff ff       	call   80103ed0 <allocproc>
801042e7:	85 c0                	test   %eax,%eax
801042e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801042ec:	0f 84 13 02 00 00    	je     80104505 <fork+0x245>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801042f2:	83 ec 08             	sub    $0x8,%esp
801042f5:	ff 33                	pushl  (%ebx)
801042f7:	ff 73 04             	pushl  0x4(%ebx)
801042fa:	e8 91 36 00 00       	call   80107990 <copyuvm>
801042ff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104302:	83 c4 10             	add    $0x10,%esp
80104305:	89 42 04             	mov    %eax,0x4(%edx)
80104308:	85 c0                	test   %eax,%eax
8010430a:	0f 84 01 02 00 00    	je     80104511 <fork+0x251>
  np->sz = curproc->sz;
80104310:	8b 03                	mov    (%ebx),%eax
  *np->tf = *curproc->tf;
80104312:	8b 7a 18             	mov    0x18(%edx),%edi
  np->parent = curproc;
80104315:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
80104318:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->sz = curproc->sz;
8010431d:	89 02                	mov    %eax,(%edx)
  *np->tf = *curproc->tf;
8010431f:	8b 73 18             	mov    0x18(%ebx),%esi
80104322:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80104324:	31 f6                	xor    %esi,%esi
80104326:	89 d7                	mov    %edx,%edi
  np->tf->eax = 0;
80104328:	8b 42 18             	mov    0x18(%edx),%eax
8010432b:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80104332:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[i])
80104338:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
8010433c:	85 c0                	test   %eax,%eax
8010433e:	74 10                	je     80104350 <fork+0x90>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104340:	83 ec 0c             	sub    $0xc,%esp
80104343:	50                   	push   %eax
80104344:	e8 e7 ce ff ff       	call   80101230 <filedup>
80104349:	83 c4 10             	add    $0x10,%esp
8010434c:	89 44 b7 28          	mov    %eax,0x28(%edi,%esi,4)
  for(i = 0; i < NOFILE; i++)
80104350:	83 c6 01             	add    $0x1,%esi
80104353:	83 fe 10             	cmp    $0x10,%esi
80104356:	75 e0                	jne    80104338 <fork+0x78>
  np->cwd = idup(curproc->cwd);
80104358:	83 ec 0c             	sub    $0xc,%esp
8010435b:	ff 73 68             	pushl  0x68(%ebx)
8010435e:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80104361:	e8 8a d7 ff ff       	call   80101af0 <idup>
80104366:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104369:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
8010436c:	89 42 68             	mov    %eax,0x68(%edx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010436f:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104372:	6a 10                	push   $0x10
80104374:	50                   	push   %eax
80104375:	8d 42 6c             	lea    0x6c(%edx),%eax
80104378:	50                   	push   %eax
80104379:	e8 82 0e 00 00       	call   80105200 <safestrcpy>
  pid = np->pid;
8010437e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  if (curproc->pid > 2 && np->pid > 2){
80104381:	83 c4 10             	add    $0x10,%esp
80104384:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
  pid = np->pid;
80104388:	8b 42 10             	mov    0x10(%edx),%eax
8010438b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if (curproc->pid > 2 && np->pid > 2){
8010438e:	7e 05                	jle    80104395 <fork+0xd5>
80104390:	83 f8 02             	cmp    $0x2,%eax
80104393:	7f 3b                	jg     801043d0 <fork+0x110>
  acquire(&ptable.lock);
80104395:	83 ec 0c             	sub    $0xc,%esp
80104398:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010439b:	68 40 3d 11 80       	push   $0x80113d40
801043a0:	e8 8b 0b 00 00       	call   80104f30 <acquire>
  np->state = RUNNABLE;
801043a5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801043a8:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  release(&ptable.lock);
801043af:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
801043b6:	e8 35 0c 00 00       	call   80104ff0 <release>
  return pid;
801043bb:	83 c4 10             	add    $0x10,%esp
}
801043be:	8b 45 dc             	mov    -0x24(%ebp),%eax
801043c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043c4:	5b                   	pop    %ebx
801043c5:	5e                   	pop    %esi
801043c6:	5f                   	pop    %edi
801043c7:	5d                   	pop    %ebp
801043c8:	c3                   	ret    
801043c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043d0:	8d 83 e8 01 00 00    	lea    0x1e8(%ebx),%eax
    int last_not_free_in_file = MAX_PYSC_PAGES - 1;
801043d6:	b9 0f 00 00 00       	mov    $0xf,%ecx
801043db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043df:	90                   	nop
    while (last_not_free_in_file >= 0 && curproc->swapped_out_pages[last_not_free_in_file].is_free){ last_not_free_in_file--; }
801043e0:	8b 30                	mov    (%eax),%esi
801043e2:	85 f6                	test   %esi,%esi
801043e4:	74 1a                	je     80104400 <fork+0x140>
801043e6:	83 e9 01             	sub    $0x1,%ecx
801043e9:	83 e8 18             	sub    $0x18,%eax
801043ec:	83 f9 ff             	cmp    $0xffffffff,%ecx
801043ef:	75 ef                	jne    801043e0 <fork+0x120>
801043f1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    void* pg_buffer = kalloc();
801043f4:	e8 77 e9 ff ff       	call   80102d70 <kalloc>
801043f9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801043fc:	89 c7                	mov    %eax,%edi
    for (int i = 0; i < last_not_free_in_file * PGSIZE; i += PGSIZE){
801043fe:	eb 57                	jmp    80104457 <fork+0x197>
80104400:	89 55 d8             	mov    %edx,-0x28(%ebp)
80104403:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    void* pg_buffer = kalloc();
80104406:	e8 65 e9 ff ff       	call   80102d70 <kalloc>
    last_not_free_in_file++;
8010440b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    for (int i = 0; i < last_not_free_in_file * PGSIZE; i += PGSIZE){
8010440e:	8b 55 d8             	mov    -0x28(%ebp),%edx
80104411:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
    void* pg_buffer = kalloc();
80104414:	89 c7                	mov    %eax,%edi
    for (int i = 0; i < last_not_free_in_file * PGSIZE; i += PGSIZE){
80104416:	89 f3                	mov    %esi,%ebx
    last_not_free_in_file++;
80104418:	83 c1 01             	add    $0x1,%ecx
    for (int i = 0; i < last_not_free_in_file * PGSIZE; i += PGSIZE){
8010441b:	89 d6                	mov    %edx,%esi
8010441d:	c1 e1 0c             	shl    $0xc,%ecx
80104420:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80104423:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104427:	90                   	nop
      readFromSwapFile(curproc, pg_buffer, i, PGSIZE);
80104428:	68 00 10 00 00       	push   $0x1000
8010442d:	53                   	push   %ebx
8010442e:	57                   	push   %edi
8010442f:	ff 75 e4             	pushl  -0x1c(%ebp)
80104432:	e8 49 e3 ff ff       	call   80102780 <readFromSwapFile>
      writeToSwapFile(np, pg_buffer, i, PGSIZE);
80104437:	68 00 10 00 00       	push   $0x1000
8010443c:	53                   	push   %ebx
    for (int i = 0; i < last_not_free_in_file * PGSIZE; i += PGSIZE){
8010443d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      writeToSwapFile(np, pg_buffer, i, PGSIZE);
80104443:	57                   	push   %edi
80104444:	56                   	push   %esi
80104445:	e8 06 e3 ff ff       	call   80102750 <writeToSwapFile>
    for (int i = 0; i < last_not_free_in_file * PGSIZE; i += PGSIZE){
8010444a:	83 c4 20             	add    $0x20,%esp
8010444d:	39 5d e0             	cmp    %ebx,-0x20(%ebp)
80104450:	7f d6                	jg     80104428 <fork+0x168>
80104452:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80104455:	89 f2                	mov    %esi,%edx
    kfree(pg_buffer);
80104457:	83 ec 0c             	sub    $0xc,%esp
8010445a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010445d:	57                   	push   %edi
8010445e:	e8 4d e7 ff ff       	call   80102bb0 <kfree>
80104463:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104466:	83 c4 10             	add    $0x10,%esp
80104469:	b8 80 00 00 00       	mov    $0x80,%eax
8010446e:	66 90                	xchg   %ax,%ax
      np->ram_pages[i] = curproc->ram_pages[i];
80104470:	8b 8c 03 80 01 00 00 	mov    0x180(%ebx,%eax,1),%ecx
80104477:	89 8c 02 80 01 00 00 	mov    %ecx,0x180(%edx,%eax,1)
8010447e:	8b 8c 03 84 01 00 00 	mov    0x184(%ebx,%eax,1),%ecx
80104485:	89 8c 02 84 01 00 00 	mov    %ecx,0x184(%edx,%eax,1)
8010448c:	8b 8c 03 88 01 00 00 	mov    0x188(%ebx,%eax,1),%ecx
80104493:	89 8c 02 88 01 00 00 	mov    %ecx,0x188(%edx,%eax,1)
8010449a:	8b 8c 03 8c 01 00 00 	mov    0x18c(%ebx,%eax,1),%ecx
801044a1:	89 8c 02 8c 01 00 00 	mov    %ecx,0x18c(%edx,%eax,1)
801044a8:	8b 8c 03 90 01 00 00 	mov    0x190(%ebx,%eax,1),%ecx
801044af:	89 8c 02 90 01 00 00 	mov    %ecx,0x190(%edx,%eax,1)
801044b6:	8b 8c 03 94 01 00 00 	mov    0x194(%ebx,%eax,1),%ecx
801044bd:	89 8c 02 94 01 00 00 	mov    %ecx,0x194(%edx,%eax,1)
      np->swapped_out_pages[i] = curproc->swapped_out_pages[i];
801044c4:	8b 0c 03             	mov    (%ebx,%eax,1),%ecx
801044c7:	89 0c 02             	mov    %ecx,(%edx,%eax,1)
801044ca:	8b 4c 03 04          	mov    0x4(%ebx,%eax,1),%ecx
801044ce:	89 4c 02 04          	mov    %ecx,0x4(%edx,%eax,1)
801044d2:	8b 4c 03 08          	mov    0x8(%ebx,%eax,1),%ecx
801044d6:	89 4c 02 08          	mov    %ecx,0x8(%edx,%eax,1)
801044da:	8b 4c 03 0c          	mov    0xc(%ebx,%eax,1),%ecx
801044de:	89 4c 02 0c          	mov    %ecx,0xc(%edx,%eax,1)
801044e2:	8b 4c 03 10          	mov    0x10(%ebx,%eax,1),%ecx
801044e6:	89 4c 02 10          	mov    %ecx,0x10(%edx,%eax,1)
801044ea:	8b 4c 03 14          	mov    0x14(%ebx,%eax,1),%ecx
801044ee:	89 4c 02 14          	mov    %ecx,0x14(%edx,%eax,1)
    for (int i = 0; i < MAX_PYSC_PAGES; i++){
801044f2:	83 c0 18             	add    $0x18,%eax
801044f5:	3d 00 02 00 00       	cmp    $0x200,%eax
801044fa:	0f 85 70 ff ff ff    	jne    80104470 <fork+0x1b0>
80104500:	e9 90 fe ff ff       	jmp    80104395 <fork+0xd5>
    return -1;
80104505:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
8010450c:	e9 ad fe ff ff       	jmp    801043be <fork+0xfe>
    kfree(np->kstack);
80104511:	83 ec 0c             	sub    $0xc,%esp
80104514:	ff 72 08             	pushl  0x8(%edx)
80104517:	e8 94 e6 ff ff       	call   80102bb0 <kfree>
    np->kstack = 0;
8010451c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    return -1;
8010451f:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
80104526:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80104529:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
    np->state = UNUSED;
80104530:	c7 42 0c 00 00 00 00 	movl   $0x0,0xc(%edx)
    return -1;
80104537:	e9 82 fe ff ff       	jmp    801043be <fork+0xfe>
8010453c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104540 <scheduler>:
{
80104540:	f3 0f 1e fb          	endbr32 
80104544:	55                   	push   %ebp
80104545:	89 e5                	mov    %esp,%ebp
80104547:	57                   	push   %edi
80104548:	56                   	push   %esi
80104549:	53                   	push   %ebx
8010454a:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
8010454d:	e8 2e fb ff ff       	call   80104080 <mycpu>
  c->proc = 0;
80104552:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104559:	00 00 00 
  struct cpu *c = mycpu();
8010455c:	89 c6                	mov    %eax,%esi
  c->proc = 0;
8010455e:	8d 78 04             	lea    0x4(%eax),%edi
80104561:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80104568:	fb                   	sti    
    acquire(&ptable.lock);
80104569:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010456c:	bb 74 3d 11 80       	mov    $0x80113d74,%ebx
    acquire(&ptable.lock);
80104571:	68 40 3d 11 80       	push   $0x80113d40
80104576:	e8 b5 09 00 00       	call   80104f30 <acquire>
8010457b:	83 c4 10             	add    $0x10,%esp
8010457e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80104580:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104584:	75 33                	jne    801045b9 <scheduler+0x79>
      switchuvm(p);
80104586:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104589:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010458f:	53                   	push   %ebx
80104590:	e8 fb 2e 00 00       	call   80107490 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104595:	58                   	pop    %eax
80104596:	5a                   	pop    %edx
80104597:	ff 73 1c             	pushl  0x1c(%ebx)
8010459a:	57                   	push   %edi
      p->state = RUNNING;
8010459b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
801045a2:	e8 bc 0c 00 00       	call   80105263 <swtch>
      switchkvm();
801045a7:	e8 c4 2e 00 00       	call   80107470 <switchkvm>
      c->proc = 0;
801045ac:	83 c4 10             	add    $0x10,%esp
801045af:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801045b6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045b9:	81 c3 90 03 00 00    	add    $0x390,%ebx
801045bf:	81 fb 74 21 12 80    	cmp    $0x80122174,%ebx
801045c5:	75 b9                	jne    80104580 <scheduler+0x40>
    release(&ptable.lock);
801045c7:	83 ec 0c             	sub    $0xc,%esp
801045ca:	68 40 3d 11 80       	push   $0x80113d40
801045cf:	e8 1c 0a 00 00       	call   80104ff0 <release>
    sti();
801045d4:	83 c4 10             	add    $0x10,%esp
801045d7:	eb 8f                	jmp    80104568 <scheduler+0x28>
801045d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801045e0 <sched>:
{
801045e0:	f3 0f 1e fb          	endbr32 
801045e4:	55                   	push   %ebp
801045e5:	89 e5                	mov    %esp,%ebp
801045e7:	56                   	push   %esi
801045e8:	53                   	push   %ebx
  pushcli();
801045e9:	e8 42 08 00 00       	call   80104e30 <pushcli>
  c = mycpu();
801045ee:	e8 8d fa ff ff       	call   80104080 <mycpu>
  p = c->proc;
801045f3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801045f9:	e8 82 08 00 00       	call   80104e80 <popcli>
  if(!holding(&ptable.lock))
801045fe:	83 ec 0c             	sub    $0xc,%esp
80104601:	68 40 3d 11 80       	push   $0x80113d40
80104606:	e8 d5 08 00 00       	call   80104ee0 <holding>
8010460b:	83 c4 10             	add    $0x10,%esp
8010460e:	85 c0                	test   %eax,%eax
80104610:	74 4f                	je     80104661 <sched+0x81>
  if(mycpu()->ncli != 1)
80104612:	e8 69 fa ff ff       	call   80104080 <mycpu>
80104617:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010461e:	75 68                	jne    80104688 <sched+0xa8>
  if(p->state == RUNNING)
80104620:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104624:	74 55                	je     8010467b <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104626:	9c                   	pushf  
80104627:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104628:	f6 c4 02             	test   $0x2,%ah
8010462b:	75 41                	jne    8010466e <sched+0x8e>
  intena = mycpu()->intena;
8010462d:	e8 4e fa ff ff       	call   80104080 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80104632:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104635:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
8010463b:	e8 40 fa ff ff       	call   80104080 <mycpu>
80104640:	83 ec 08             	sub    $0x8,%esp
80104643:	ff 70 04             	pushl  0x4(%eax)
80104646:	53                   	push   %ebx
80104647:	e8 17 0c 00 00       	call   80105263 <swtch>
  mycpu()->intena = intena;
8010464c:	e8 2f fa ff ff       	call   80104080 <mycpu>
}
80104651:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104654:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
8010465a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010465d:	5b                   	pop    %ebx
8010465e:	5e                   	pop    %esi
8010465f:	5d                   	pop    %ebp
80104660:	c3                   	ret    
    panic("sched ptable.lock");
80104661:	83 ec 0c             	sub    $0xc,%esp
80104664:	68 1b 86 10 80       	push   $0x8010861b
80104669:	e8 22 bd ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010466e:	83 ec 0c             	sub    $0xc,%esp
80104671:	68 47 86 10 80       	push   $0x80108647
80104676:	e8 15 bd ff ff       	call   80100390 <panic>
    panic("sched running");
8010467b:	83 ec 0c             	sub    $0xc,%esp
8010467e:	68 39 86 10 80       	push   $0x80108639
80104683:	e8 08 bd ff ff       	call   80100390 <panic>
    panic("sched locks");
80104688:	83 ec 0c             	sub    $0xc,%esp
8010468b:	68 2d 86 10 80       	push   $0x8010862d
80104690:	e8 fb bc ff ff       	call   80100390 <panic>
80104695:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010469c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046a0 <exit>:
{
801046a0:	f3 0f 1e fb          	endbr32 
801046a4:	55                   	push   %ebp
801046a5:	89 e5                	mov    %esp,%ebp
801046a7:	57                   	push   %edi
801046a8:	56                   	push   %esi
801046a9:	53                   	push   %ebx
801046aa:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
801046ad:	e8 7e 07 00 00       	call   80104e30 <pushcli>
  c = mycpu();
801046b2:	e8 c9 f9 ff ff       	call   80104080 <mycpu>
  p = c->proc;
801046b7:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801046bd:	e8 be 07 00 00       	call   80104e80 <popcli>
  if(curproc == initproc)
801046c2:	8d 73 28             	lea    0x28(%ebx),%esi
801046c5:	8d 7b 68             	lea    0x68(%ebx),%edi
801046c8:	39 1d b8 b5 10 80    	cmp    %ebx,0x8010b5b8
801046ce:	0f 84 fd 00 00 00    	je     801047d1 <exit+0x131>
801046d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
801046d8:	8b 06                	mov    (%esi),%eax
801046da:	85 c0                	test   %eax,%eax
801046dc:	74 12                	je     801046f0 <exit+0x50>
      fileclose(curproc->ofile[fd]);
801046de:	83 ec 0c             	sub    $0xc,%esp
801046e1:	50                   	push   %eax
801046e2:	e8 99 cb ff ff       	call   80101280 <fileclose>
      curproc->ofile[fd] = 0;
801046e7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801046ed:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
801046f0:	83 c6 04             	add    $0x4,%esi
801046f3:	39 f7                	cmp    %esi,%edi
801046f5:	75 e1                	jne    801046d8 <exit+0x38>
  begin_op();
801046f7:	e8 74 ed ff ff       	call   80103470 <begin_op>
  iput(curproc->cwd);
801046fc:	83 ec 0c             	sub    $0xc,%esp
801046ff:	ff 73 68             	pushl  0x68(%ebx)
80104702:	e8 49 d5 ff ff       	call   80101c50 <iput>
  end_op();
80104707:	e8 d4 ed ff ff       	call   801034e0 <end_op>
  curproc->cwd = 0;
8010470c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  removeSwapFile(curproc);
80104713:	89 1c 24             	mov    %ebx,(%esp)
80104716:	e8 a5 dd ff ff       	call   801024c0 <removeSwapFile>
  acquire(&ptable.lock);
8010471b:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80104722:	e8 09 08 00 00       	call   80104f30 <acquire>
  wakeup1(curproc->parent);
80104727:	8b 53 14             	mov    0x14(%ebx),%edx
8010472a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010472d:	b8 74 3d 11 80       	mov    $0x80113d74,%eax
80104732:	eb 10                	jmp    80104744 <exit+0xa4>
80104734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104738:	05 90 03 00 00       	add    $0x390,%eax
8010473d:	3d 74 21 12 80       	cmp    $0x80122174,%eax
80104742:	74 1e                	je     80104762 <exit+0xc2>
    if(p->state == SLEEPING && p->chan == chan)
80104744:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104748:	75 ee                	jne    80104738 <exit+0x98>
8010474a:	3b 50 20             	cmp    0x20(%eax),%edx
8010474d:	75 e9                	jne    80104738 <exit+0x98>
      p->state = RUNNABLE;
8010474f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104756:	05 90 03 00 00       	add    $0x390,%eax
8010475b:	3d 74 21 12 80       	cmp    $0x80122174,%eax
80104760:	75 e2                	jne    80104744 <exit+0xa4>
      p->parent = initproc;
80104762:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104768:	ba 74 3d 11 80       	mov    $0x80113d74,%edx
8010476d:	eb 0f                	jmp    8010477e <exit+0xde>
8010476f:	90                   	nop
80104770:	81 c2 90 03 00 00    	add    $0x390,%edx
80104776:	81 fa 74 21 12 80    	cmp    $0x80122174,%edx
8010477c:	74 3a                	je     801047b8 <exit+0x118>
    if(p->parent == curproc){
8010477e:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104781:	75 ed                	jne    80104770 <exit+0xd0>
      if(p->state == ZOMBIE)
80104783:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104787:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010478a:	75 e4                	jne    80104770 <exit+0xd0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010478c:	b8 74 3d 11 80       	mov    $0x80113d74,%eax
80104791:	eb 11                	jmp    801047a4 <exit+0x104>
80104793:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104797:	90                   	nop
80104798:	05 90 03 00 00       	add    $0x390,%eax
8010479d:	3d 74 21 12 80       	cmp    $0x80122174,%eax
801047a2:	74 cc                	je     80104770 <exit+0xd0>
    if(p->state == SLEEPING && p->chan == chan)
801047a4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801047a8:	75 ee                	jne    80104798 <exit+0xf8>
801047aa:	3b 48 20             	cmp    0x20(%eax),%ecx
801047ad:	75 e9                	jne    80104798 <exit+0xf8>
      p->state = RUNNABLE;
801047af:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801047b6:	eb e0                	jmp    80104798 <exit+0xf8>
  curproc->state = ZOMBIE;
801047b8:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
801047bf:	e8 1c fe ff ff       	call   801045e0 <sched>
  panic("zombie exit");
801047c4:	83 ec 0c             	sub    $0xc,%esp
801047c7:	68 68 86 10 80       	push   $0x80108668
801047cc:	e8 bf bb ff ff       	call   80100390 <panic>
    panic("init exiting");
801047d1:	83 ec 0c             	sub    $0xc,%esp
801047d4:	68 5b 86 10 80       	push   $0x8010865b
801047d9:	e8 b2 bb ff ff       	call   80100390 <panic>
801047de:	66 90                	xchg   %ax,%ax

801047e0 <yield>:
{
801047e0:	f3 0f 1e fb          	endbr32 
801047e4:	55                   	push   %ebp
801047e5:	89 e5                	mov    %esp,%ebp
801047e7:	53                   	push   %ebx
801047e8:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801047eb:	68 40 3d 11 80       	push   $0x80113d40
801047f0:	e8 3b 07 00 00       	call   80104f30 <acquire>
  pushcli();
801047f5:	e8 36 06 00 00       	call   80104e30 <pushcli>
  c = mycpu();
801047fa:	e8 81 f8 ff ff       	call   80104080 <mycpu>
  p = c->proc;
801047ff:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104805:	e8 76 06 00 00       	call   80104e80 <popcli>
  myproc()->state = RUNNABLE;
8010480a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80104811:	e8 ca fd ff ff       	call   801045e0 <sched>
  release(&ptable.lock);
80104816:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
8010481d:	e8 ce 07 00 00       	call   80104ff0 <release>
}
80104822:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104825:	83 c4 10             	add    $0x10,%esp
80104828:	c9                   	leave  
80104829:	c3                   	ret    
8010482a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104830 <sleep>:
{
80104830:	f3 0f 1e fb          	endbr32 
80104834:	55                   	push   %ebp
80104835:	89 e5                	mov    %esp,%ebp
80104837:	57                   	push   %edi
80104838:	56                   	push   %esi
80104839:	53                   	push   %ebx
8010483a:	83 ec 0c             	sub    $0xc,%esp
8010483d:	8b 7d 08             	mov    0x8(%ebp),%edi
80104840:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104843:	e8 e8 05 00 00       	call   80104e30 <pushcli>
  c = mycpu();
80104848:	e8 33 f8 ff ff       	call   80104080 <mycpu>
  p = c->proc;
8010484d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104853:	e8 28 06 00 00       	call   80104e80 <popcli>
  if(p == 0)
80104858:	85 db                	test   %ebx,%ebx
8010485a:	0f 84 83 00 00 00    	je     801048e3 <sleep+0xb3>
  if(lk == 0)
80104860:	85 f6                	test   %esi,%esi
80104862:	74 72                	je     801048d6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104864:	81 fe 40 3d 11 80    	cmp    $0x80113d40,%esi
8010486a:	74 4c                	je     801048b8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
8010486c:	83 ec 0c             	sub    $0xc,%esp
8010486f:	68 40 3d 11 80       	push   $0x80113d40
80104874:	e8 b7 06 00 00       	call   80104f30 <acquire>
    release(lk);
80104879:	89 34 24             	mov    %esi,(%esp)
8010487c:	e8 6f 07 00 00       	call   80104ff0 <release>
  p->chan = chan;
80104881:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104884:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010488b:	e8 50 fd ff ff       	call   801045e0 <sched>
  p->chan = 0;
80104890:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104897:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
8010489e:	e8 4d 07 00 00       	call   80104ff0 <release>
    acquire(lk);
801048a3:	89 75 08             	mov    %esi,0x8(%ebp)
801048a6:	83 c4 10             	add    $0x10,%esp
}
801048a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048ac:	5b                   	pop    %ebx
801048ad:	5e                   	pop    %esi
801048ae:	5f                   	pop    %edi
801048af:	5d                   	pop    %ebp
    acquire(lk);
801048b0:	e9 7b 06 00 00       	jmp    80104f30 <acquire>
801048b5:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
801048b8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801048bb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801048c2:	e8 19 fd ff ff       	call   801045e0 <sched>
  p->chan = 0;
801048c7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801048ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048d1:	5b                   	pop    %ebx
801048d2:	5e                   	pop    %esi
801048d3:	5f                   	pop    %edi
801048d4:	5d                   	pop    %ebp
801048d5:	c3                   	ret    
    panic("sleep without lk");
801048d6:	83 ec 0c             	sub    $0xc,%esp
801048d9:	68 7a 86 10 80       	push   $0x8010867a
801048de:	e8 ad ba ff ff       	call   80100390 <panic>
    panic("sleep");
801048e3:	83 ec 0c             	sub    $0xc,%esp
801048e6:	68 74 86 10 80       	push   $0x80108674
801048eb:	e8 a0 ba ff ff       	call   80100390 <panic>

801048f0 <wait>:
{
801048f0:	f3 0f 1e fb          	endbr32 
801048f4:	55                   	push   %ebp
801048f5:	89 e5                	mov    %esp,%ebp
801048f7:	56                   	push   %esi
801048f8:	53                   	push   %ebx
  pushcli();
801048f9:	e8 32 05 00 00       	call   80104e30 <pushcli>
  c = mycpu();
801048fe:	e8 7d f7 ff ff       	call   80104080 <mycpu>
  p = c->proc;
80104903:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104909:	e8 72 05 00 00       	call   80104e80 <popcli>
  acquire(&ptable.lock);
8010490e:	83 ec 0c             	sub    $0xc,%esp
80104911:	68 40 3d 11 80       	push   $0x80113d40
80104916:	e8 15 06 00 00       	call   80104f30 <acquire>
8010491b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010491e:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104920:	bb 74 3d 11 80       	mov    $0x80113d74,%ebx
80104925:	eb 17                	jmp    8010493e <wait+0x4e>
80104927:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010492e:	66 90                	xchg   %ax,%ax
80104930:	81 c3 90 03 00 00    	add    $0x390,%ebx
80104936:	81 fb 74 21 12 80    	cmp    $0x80122174,%ebx
8010493c:	74 1e                	je     8010495c <wait+0x6c>
      if(p->parent != curproc)
8010493e:	39 73 14             	cmp    %esi,0x14(%ebx)
80104941:	75 ed                	jne    80104930 <wait+0x40>
      if(p->state == ZOMBIE){
80104943:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104947:	74 3f                	je     80104988 <wait+0x98>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104949:	81 c3 90 03 00 00    	add    $0x390,%ebx
      havekids = 1;
8010494f:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104954:	81 fb 74 21 12 80    	cmp    $0x80122174,%ebx
8010495a:	75 e2                	jne    8010493e <wait+0x4e>
    if(!havekids || curproc->killed){
8010495c:	85 c0                	test   %eax,%eax
8010495e:	0f 84 09 01 00 00    	je     80104a6d <wait+0x17d>
80104964:	8b 46 24             	mov    0x24(%esi),%eax
80104967:	85 c0                	test   %eax,%eax
80104969:	0f 85 fe 00 00 00    	jne    80104a6d <wait+0x17d>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
8010496f:	83 ec 08             	sub    $0x8,%esp
80104972:	68 40 3d 11 80       	push   $0x80113d40
80104977:	56                   	push   %esi
80104978:	e8 b3 fe ff ff       	call   80104830 <sleep>
    havekids = 0;
8010497d:	83 c4 10             	add    $0x10,%esp
80104980:	eb 9c                	jmp    8010491e <wait+0x2e>
80104982:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (p->pid > 2){
80104988:	8b 73 10             	mov    0x10(%ebx),%esi
8010498b:	83 fe 02             	cmp    $0x2,%esi
8010498e:	0f 8e 86 00 00 00    	jle    80104a1a <wait+0x12a>
          p->num_of_pagefaults_occurs = 0;
80104994:	c7 83 88 03 00 00 00 	movl   $0x0,0x388(%ebx)
8010499b:	00 00 00 
          p->num_of_actual_pages_in_mem = 0;
8010499e:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
801049a4:	8d 93 00 02 00 00    	lea    0x200(%ebx),%edx
801049aa:	c7 83 84 03 00 00 00 	movl   $0x0,0x384(%ebx)
801049b1:	00 00 00 
          p->num_of_pageOut_occured = 0;
801049b4:	c7 83 8c 03 00 00 00 	movl   $0x0,0x38c(%ebx)
801049bb:	00 00 00 
          p->num_of_pages_in_swap_file = 0;
801049be:	c7 83 80 03 00 00 00 	movl   $0x0,0x380(%ebx)
801049c5:	00 00 00 
          for (int i = 0; i < MAX_PYSC_PAGES; i++){
801049c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049cf:	90                   	nop
            p->ram_pages[i].is_free = p->swapped_out_pages[i].is_free = 1;
801049d0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
801049d6:	83 c0 18             	add    $0x18,%eax
801049d9:	c7 80 68 01 00 00 01 	movl   $0x1,0x168(%eax)
801049e0:	00 00 00 
            p->ram_pages[i].aging_counter = p->swapped_out_pages[i].aging_counter = 0;
801049e3:	c7 40 f0 00 00 00 00 	movl   $0x0,-0x10(%eax)
801049ea:	c7 80 70 01 00 00 00 	movl   $0x0,0x170(%eax)
801049f1:	00 00 00 
            p->ram_pages[i].swap_file_offset = p->swapped_out_pages[i].swap_file_offset = 0;
801049f4:	c7 40 ec 00 00 00 00 	movl   $0x0,-0x14(%eax)
801049fb:	c7 80 6c 01 00 00 00 	movl   $0x0,0x16c(%eax)
80104a02:	00 00 00 
            p->ram_pages[i].va = p->swapped_out_pages[i].va = 0;
80104a05:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
80104a0c:	c7 80 78 01 00 00 00 	movl   $0x0,0x178(%eax)
80104a13:	00 00 00 
          for (int i = 0; i < MAX_PYSC_PAGES; i++){
80104a16:	39 d0                	cmp    %edx,%eax
80104a18:	75 b6                	jne    801049d0 <wait+0xe0>
        kfree(p->kstack);
80104a1a:	83 ec 0c             	sub    $0xc,%esp
80104a1d:	ff 73 08             	pushl  0x8(%ebx)
80104a20:	e8 8b e1 ff ff       	call   80102bb0 <kfree>
        freevm(p->pgdir);
80104a25:	5a                   	pop    %edx
80104a26:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104a29:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104a30:	e8 0b 2e 00 00       	call   80107840 <freevm>
        release(&ptable.lock);
80104a35:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
        p->pid = 0;
80104a3c:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104a43:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104a4a:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104a4e:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104a55:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104a5c:	e8 8f 05 00 00       	call   80104ff0 <release>
        return pid;
80104a61:	83 c4 10             	add    $0x10,%esp
}
80104a64:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a67:	89 f0                	mov    %esi,%eax
80104a69:	5b                   	pop    %ebx
80104a6a:	5e                   	pop    %esi
80104a6b:	5d                   	pop    %ebp
80104a6c:	c3                   	ret    
      release(&ptable.lock);
80104a6d:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104a70:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104a75:	68 40 3d 11 80       	push   $0x80113d40
80104a7a:	e8 71 05 00 00       	call   80104ff0 <release>
      return -1;
80104a7f:	83 c4 10             	add    $0x10,%esp
80104a82:	eb e0                	jmp    80104a64 <wait+0x174>
80104a84:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a8f:	90                   	nop

80104a90 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104a90:	f3 0f 1e fb          	endbr32 
80104a94:	55                   	push   %ebp
80104a95:	89 e5                	mov    %esp,%ebp
80104a97:	53                   	push   %ebx
80104a98:	83 ec 10             	sub    $0x10,%esp
80104a9b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80104a9e:	68 40 3d 11 80       	push   $0x80113d40
80104aa3:	e8 88 04 00 00       	call   80104f30 <acquire>
80104aa8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104aab:	b8 74 3d 11 80       	mov    $0x80113d74,%eax
80104ab0:	eb 12                	jmp    80104ac4 <wakeup+0x34>
80104ab2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ab8:	05 90 03 00 00       	add    $0x390,%eax
80104abd:	3d 74 21 12 80       	cmp    $0x80122174,%eax
80104ac2:	74 1e                	je     80104ae2 <wakeup+0x52>
    if(p->state == SLEEPING && p->chan == chan)
80104ac4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104ac8:	75 ee                	jne    80104ab8 <wakeup+0x28>
80104aca:	3b 58 20             	cmp    0x20(%eax),%ebx
80104acd:	75 e9                	jne    80104ab8 <wakeup+0x28>
      p->state = RUNNABLE;
80104acf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ad6:	05 90 03 00 00       	add    $0x390,%eax
80104adb:	3d 74 21 12 80       	cmp    $0x80122174,%eax
80104ae0:	75 e2                	jne    80104ac4 <wakeup+0x34>
  wakeup1(chan);
  release(&ptable.lock);
80104ae2:	c7 45 08 40 3d 11 80 	movl   $0x80113d40,0x8(%ebp)
}
80104ae9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104aec:	c9                   	leave  
  release(&ptable.lock);
80104aed:	e9 fe 04 00 00       	jmp    80104ff0 <release>
80104af2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104b00 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104b00:	f3 0f 1e fb          	endbr32 
80104b04:	55                   	push   %ebp
80104b05:	89 e5                	mov    %esp,%ebp
80104b07:	53                   	push   %ebx
80104b08:	83 ec 10             	sub    $0x10,%esp
80104b0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80104b0e:	68 40 3d 11 80       	push   $0x80113d40
80104b13:	e8 18 04 00 00       	call   80104f30 <acquire>
80104b18:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b1b:	b8 74 3d 11 80       	mov    $0x80113d74,%eax
80104b20:	eb 12                	jmp    80104b34 <kill+0x34>
80104b22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b28:	05 90 03 00 00       	add    $0x390,%eax
80104b2d:	3d 74 21 12 80       	cmp    $0x80122174,%eax
80104b32:	74 34                	je     80104b68 <kill+0x68>
    if(p->pid == pid){
80104b34:	39 58 10             	cmp    %ebx,0x10(%eax)
80104b37:	75 ef                	jne    80104b28 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104b39:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104b3d:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80104b44:	75 07                	jne    80104b4d <kill+0x4d>
        p->state = RUNNABLE;
80104b46:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104b4d:	83 ec 0c             	sub    $0xc,%esp
80104b50:	68 40 3d 11 80       	push   $0x80113d40
80104b55:	e8 96 04 00 00       	call   80104ff0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104b5a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104b5d:	83 c4 10             	add    $0x10,%esp
80104b60:	31 c0                	xor    %eax,%eax
}
80104b62:	c9                   	leave  
80104b63:	c3                   	ret    
80104b64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104b68:	83 ec 0c             	sub    $0xc,%esp
80104b6b:	68 40 3d 11 80       	push   $0x80113d40
80104b70:	e8 7b 04 00 00       	call   80104ff0 <release>
}
80104b75:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104b78:	83 c4 10             	add    $0x10,%esp
80104b7b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b80:	c9                   	leave  
80104b81:	c3                   	ret    
80104b82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104b90 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104b90:	f3 0f 1e fb          	endbr32 
80104b94:	55                   	push   %ebp
80104b95:	89 e5                	mov    %esp,%ebp
80104b97:	57                   	push   %edi
80104b98:	56                   	push   %esi
80104b99:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104b9c:	53                   	push   %ebx
80104b9d:	bb e0 3d 11 80       	mov    $0x80113de0,%ebx
80104ba2:	83 ec 3c             	sub    $0x3c,%esp
80104ba5:	eb 2b                	jmp    80104bd2 <procdump+0x42>
80104ba7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bae:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104bb0:	83 ec 0c             	sub    $0xc,%esp
80104bb3:	68 83 8a 10 80       	push   $0x80108a83
80104bb8:	e8 f3 ba ff ff       	call   801006b0 <cprintf>
80104bbd:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bc0:	81 c3 90 03 00 00    	add    $0x390,%ebx
80104bc6:	81 fb e0 21 12 80    	cmp    $0x801221e0,%ebx
80104bcc:	0f 84 8e 00 00 00    	je     80104c60 <procdump+0xd0>
    if(p->state == UNUSED)
80104bd2:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104bd5:	85 c0                	test   %eax,%eax
80104bd7:	74 e7                	je     80104bc0 <procdump+0x30>
      state = "???";
80104bd9:	ba 8b 86 10 80       	mov    $0x8010868b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104bde:	83 f8 05             	cmp    $0x5,%eax
80104be1:	77 11                	ja     80104bf4 <procdump+0x64>
80104be3:	8b 14 85 ec 86 10 80 	mov    -0x7fef7914(,%eax,4),%edx
      state = "???";
80104bea:	b8 8b 86 10 80       	mov    $0x8010868b,%eax
80104bef:	85 d2                	test   %edx,%edx
80104bf1:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104bf4:	53                   	push   %ebx
80104bf5:	52                   	push   %edx
80104bf6:	ff 73 a4             	pushl  -0x5c(%ebx)
80104bf9:	68 8f 86 10 80       	push   $0x8010868f
80104bfe:	e8 ad ba ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
80104c03:	83 c4 10             	add    $0x10,%esp
80104c06:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104c0a:	75 a4                	jne    80104bb0 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104c0c:	83 ec 08             	sub    $0x8,%esp
80104c0f:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104c12:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104c15:	50                   	push   %eax
80104c16:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104c19:	8b 40 0c             	mov    0xc(%eax),%eax
80104c1c:	83 c0 08             	add    $0x8,%eax
80104c1f:	50                   	push   %eax
80104c20:	e8 ab 01 00 00       	call   80104dd0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104c25:	83 c4 10             	add    $0x10,%esp
80104c28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c2f:	90                   	nop
80104c30:	8b 17                	mov    (%edi),%edx
80104c32:	85 d2                	test   %edx,%edx
80104c34:	0f 84 76 ff ff ff    	je     80104bb0 <procdump+0x20>
        cprintf(" %p", pc[i]);
80104c3a:	83 ec 08             	sub    $0x8,%esp
80104c3d:	83 c7 04             	add    $0x4,%edi
80104c40:	52                   	push   %edx
80104c41:	68 a1 80 10 80       	push   $0x801080a1
80104c46:	e8 65 ba ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104c4b:	83 c4 10             	add    $0x10,%esp
80104c4e:	39 fe                	cmp    %edi,%esi
80104c50:	75 de                	jne    80104c30 <procdump+0xa0>
80104c52:	e9 59 ff ff ff       	jmp    80104bb0 <procdump+0x20>
80104c57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c5e:	66 90                	xchg   %ax,%ax
  }
}
80104c60:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c63:	5b                   	pop    %ebx
80104c64:	5e                   	pop    %esi
80104c65:	5f                   	pop    %edi
80104c66:	5d                   	pop    %ebp
80104c67:	c3                   	ret    
80104c68:	66 90                	xchg   %ax,%ax
80104c6a:	66 90                	xchg   %ax,%ax
80104c6c:	66 90                	xchg   %ax,%ax
80104c6e:	66 90                	xchg   %ax,%ax

80104c70 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104c70:	f3 0f 1e fb          	endbr32 
80104c74:	55                   	push   %ebp
80104c75:	89 e5                	mov    %esp,%ebp
80104c77:	53                   	push   %ebx
80104c78:	83 ec 0c             	sub    $0xc,%esp
80104c7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104c7e:	68 04 87 10 80       	push   $0x80108704
80104c83:	8d 43 04             	lea    0x4(%ebx),%eax
80104c86:	50                   	push   %eax
80104c87:	e8 24 01 00 00       	call   80104db0 <initlock>
  lk->name = name;
80104c8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104c8f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104c95:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104c98:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104c9f:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104ca2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ca5:	c9                   	leave  
80104ca6:	c3                   	ret    
80104ca7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cae:	66 90                	xchg   %ax,%ax

80104cb0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104cb0:	f3 0f 1e fb          	endbr32 
80104cb4:	55                   	push   %ebp
80104cb5:	89 e5                	mov    %esp,%ebp
80104cb7:	56                   	push   %esi
80104cb8:	53                   	push   %ebx
80104cb9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104cbc:	8d 73 04             	lea    0x4(%ebx),%esi
80104cbf:	83 ec 0c             	sub    $0xc,%esp
80104cc2:	56                   	push   %esi
80104cc3:	e8 68 02 00 00       	call   80104f30 <acquire>
  while (lk->locked) {
80104cc8:	8b 13                	mov    (%ebx),%edx
80104cca:	83 c4 10             	add    $0x10,%esp
80104ccd:	85 d2                	test   %edx,%edx
80104ccf:	74 1a                	je     80104ceb <acquiresleep+0x3b>
80104cd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104cd8:	83 ec 08             	sub    $0x8,%esp
80104cdb:	56                   	push   %esi
80104cdc:	53                   	push   %ebx
80104cdd:	e8 4e fb ff ff       	call   80104830 <sleep>
  while (lk->locked) {
80104ce2:	8b 03                	mov    (%ebx),%eax
80104ce4:	83 c4 10             	add    $0x10,%esp
80104ce7:	85 c0                	test   %eax,%eax
80104ce9:	75 ed                	jne    80104cd8 <acquiresleep+0x28>
  }
  lk->locked = 1;
80104ceb:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104cf1:	e8 1a f4 ff ff       	call   80104110 <myproc>
80104cf6:	8b 40 10             	mov    0x10(%eax),%eax
80104cf9:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104cfc:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104cff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d02:	5b                   	pop    %ebx
80104d03:	5e                   	pop    %esi
80104d04:	5d                   	pop    %ebp
  release(&lk->lk);
80104d05:	e9 e6 02 00 00       	jmp    80104ff0 <release>
80104d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104d10 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104d10:	f3 0f 1e fb          	endbr32 
80104d14:	55                   	push   %ebp
80104d15:	89 e5                	mov    %esp,%ebp
80104d17:	56                   	push   %esi
80104d18:	53                   	push   %ebx
80104d19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104d1c:	8d 73 04             	lea    0x4(%ebx),%esi
80104d1f:	83 ec 0c             	sub    $0xc,%esp
80104d22:	56                   	push   %esi
80104d23:	e8 08 02 00 00       	call   80104f30 <acquire>
  lk->locked = 0;
80104d28:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104d2e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104d35:	89 1c 24             	mov    %ebx,(%esp)
80104d38:	e8 53 fd ff ff       	call   80104a90 <wakeup>
  release(&lk->lk);
80104d3d:	89 75 08             	mov    %esi,0x8(%ebp)
80104d40:	83 c4 10             	add    $0x10,%esp
}
80104d43:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d46:	5b                   	pop    %ebx
80104d47:	5e                   	pop    %esi
80104d48:	5d                   	pop    %ebp
  release(&lk->lk);
80104d49:	e9 a2 02 00 00       	jmp    80104ff0 <release>
80104d4e:	66 90                	xchg   %ax,%ax

80104d50 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104d50:	f3 0f 1e fb          	endbr32 
80104d54:	55                   	push   %ebp
80104d55:	89 e5                	mov    %esp,%ebp
80104d57:	57                   	push   %edi
80104d58:	31 ff                	xor    %edi,%edi
80104d5a:	56                   	push   %esi
80104d5b:	53                   	push   %ebx
80104d5c:	83 ec 18             	sub    $0x18,%esp
80104d5f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104d62:	8d 73 04             	lea    0x4(%ebx),%esi
80104d65:	56                   	push   %esi
80104d66:	e8 c5 01 00 00       	call   80104f30 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104d6b:	8b 03                	mov    (%ebx),%eax
80104d6d:	83 c4 10             	add    $0x10,%esp
80104d70:	85 c0                	test   %eax,%eax
80104d72:	75 1c                	jne    80104d90 <holdingsleep+0x40>
  release(&lk->lk);
80104d74:	83 ec 0c             	sub    $0xc,%esp
80104d77:	56                   	push   %esi
80104d78:	e8 73 02 00 00       	call   80104ff0 <release>
  return r;
}
80104d7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d80:	89 f8                	mov    %edi,%eax
80104d82:	5b                   	pop    %ebx
80104d83:	5e                   	pop    %esi
80104d84:	5f                   	pop    %edi
80104d85:	5d                   	pop    %ebp
80104d86:	c3                   	ret    
80104d87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d8e:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104d90:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104d93:	e8 78 f3 ff ff       	call   80104110 <myproc>
80104d98:	39 58 10             	cmp    %ebx,0x10(%eax)
80104d9b:	0f 94 c0             	sete   %al
80104d9e:	0f b6 c0             	movzbl %al,%eax
80104da1:	89 c7                	mov    %eax,%edi
80104da3:	eb cf                	jmp    80104d74 <holdingsleep+0x24>
80104da5:	66 90                	xchg   %ax,%ax
80104da7:	66 90                	xchg   %ax,%ax
80104da9:	66 90                	xchg   %ax,%ax
80104dab:	66 90                	xchg   %ax,%ax
80104dad:	66 90                	xchg   %ax,%ax
80104daf:	90                   	nop

80104db0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104db0:	f3 0f 1e fb          	endbr32 
80104db4:	55                   	push   %ebp
80104db5:	89 e5                	mov    %esp,%ebp
80104db7:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104dba:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104dbd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104dc3:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104dc6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104dcd:	5d                   	pop    %ebp
80104dce:	c3                   	ret    
80104dcf:	90                   	nop

80104dd0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104dd0:	f3 0f 1e fb          	endbr32 
80104dd4:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104dd5:	31 d2                	xor    %edx,%edx
{
80104dd7:	89 e5                	mov    %esp,%ebp
80104dd9:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104dda:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104ddd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104de0:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104de3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104de7:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104de8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104dee:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104df4:	77 1a                	ja     80104e10 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104df6:	8b 58 04             	mov    0x4(%eax),%ebx
80104df9:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104dfc:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104dff:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104e01:	83 fa 0a             	cmp    $0xa,%edx
80104e04:	75 e2                	jne    80104de8 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104e06:	5b                   	pop    %ebx
80104e07:	5d                   	pop    %ebp
80104e08:	c3                   	ret    
80104e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104e10:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104e13:	8d 51 28             	lea    0x28(%ecx),%edx
80104e16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e1d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104e20:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104e26:	83 c0 04             	add    $0x4,%eax
80104e29:	39 d0                	cmp    %edx,%eax
80104e2b:	75 f3                	jne    80104e20 <getcallerpcs+0x50>
}
80104e2d:	5b                   	pop    %ebx
80104e2e:	5d                   	pop    %ebp
80104e2f:	c3                   	ret    

80104e30 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104e30:	f3 0f 1e fb          	endbr32 
80104e34:	55                   	push   %ebp
80104e35:	89 e5                	mov    %esp,%ebp
80104e37:	53                   	push   %ebx
80104e38:	83 ec 04             	sub    $0x4,%esp
80104e3b:	9c                   	pushf  
80104e3c:	5b                   	pop    %ebx
  asm volatile("cli");
80104e3d:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104e3e:	e8 3d f2 ff ff       	call   80104080 <mycpu>
80104e43:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104e49:	85 c0                	test   %eax,%eax
80104e4b:	74 13                	je     80104e60 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104e4d:	e8 2e f2 ff ff       	call   80104080 <mycpu>
80104e52:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104e59:	83 c4 04             	add    $0x4,%esp
80104e5c:	5b                   	pop    %ebx
80104e5d:	5d                   	pop    %ebp
80104e5e:	c3                   	ret    
80104e5f:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104e60:	e8 1b f2 ff ff       	call   80104080 <mycpu>
80104e65:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104e6b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104e71:	eb da                	jmp    80104e4d <pushcli+0x1d>
80104e73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104e80 <popcli>:

void
popcli(void)
{
80104e80:	f3 0f 1e fb          	endbr32 
80104e84:	55                   	push   %ebp
80104e85:	89 e5                	mov    %esp,%ebp
80104e87:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104e8a:	9c                   	pushf  
80104e8b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104e8c:	f6 c4 02             	test   $0x2,%ah
80104e8f:	75 31                	jne    80104ec2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104e91:	e8 ea f1 ff ff       	call   80104080 <mycpu>
80104e96:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104e9d:	78 30                	js     80104ecf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104e9f:	e8 dc f1 ff ff       	call   80104080 <mycpu>
80104ea4:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104eaa:	85 d2                	test   %edx,%edx
80104eac:	74 02                	je     80104eb0 <popcli+0x30>
    sti();
}
80104eae:	c9                   	leave  
80104eaf:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104eb0:	e8 cb f1 ff ff       	call   80104080 <mycpu>
80104eb5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104ebb:	85 c0                	test   %eax,%eax
80104ebd:	74 ef                	je     80104eae <popcli+0x2e>
  asm volatile("sti");
80104ebf:	fb                   	sti    
}
80104ec0:	c9                   	leave  
80104ec1:	c3                   	ret    
    panic("popcli - interruptible");
80104ec2:	83 ec 0c             	sub    $0xc,%esp
80104ec5:	68 0f 87 10 80       	push   $0x8010870f
80104eca:	e8 c1 b4 ff ff       	call   80100390 <panic>
    panic("popcli");
80104ecf:	83 ec 0c             	sub    $0xc,%esp
80104ed2:	68 26 87 10 80       	push   $0x80108726
80104ed7:	e8 b4 b4 ff ff       	call   80100390 <panic>
80104edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ee0 <holding>:
{
80104ee0:	f3 0f 1e fb          	endbr32 
80104ee4:	55                   	push   %ebp
80104ee5:	89 e5                	mov    %esp,%ebp
80104ee7:	56                   	push   %esi
80104ee8:	53                   	push   %ebx
80104ee9:	8b 75 08             	mov    0x8(%ebp),%esi
80104eec:	31 db                	xor    %ebx,%ebx
  pushcli();
80104eee:	e8 3d ff ff ff       	call   80104e30 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104ef3:	8b 06                	mov    (%esi),%eax
80104ef5:	85 c0                	test   %eax,%eax
80104ef7:	75 0f                	jne    80104f08 <holding+0x28>
  popcli();
80104ef9:	e8 82 ff ff ff       	call   80104e80 <popcli>
}
80104efe:	89 d8                	mov    %ebx,%eax
80104f00:	5b                   	pop    %ebx
80104f01:	5e                   	pop    %esi
80104f02:	5d                   	pop    %ebp
80104f03:	c3                   	ret    
80104f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104f08:	8b 5e 08             	mov    0x8(%esi),%ebx
80104f0b:	e8 70 f1 ff ff       	call   80104080 <mycpu>
80104f10:	39 c3                	cmp    %eax,%ebx
80104f12:	0f 94 c3             	sete   %bl
  popcli();
80104f15:	e8 66 ff ff ff       	call   80104e80 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104f1a:	0f b6 db             	movzbl %bl,%ebx
}
80104f1d:	89 d8                	mov    %ebx,%eax
80104f1f:	5b                   	pop    %ebx
80104f20:	5e                   	pop    %esi
80104f21:	5d                   	pop    %ebp
80104f22:	c3                   	ret    
80104f23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104f30 <acquire>:
{
80104f30:	f3 0f 1e fb          	endbr32 
80104f34:	55                   	push   %ebp
80104f35:	89 e5                	mov    %esp,%ebp
80104f37:	56                   	push   %esi
80104f38:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104f39:	e8 f2 fe ff ff       	call   80104e30 <pushcli>
  if(holding(lk))
80104f3e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104f41:	83 ec 0c             	sub    $0xc,%esp
80104f44:	53                   	push   %ebx
80104f45:	e8 96 ff ff ff       	call   80104ee0 <holding>
80104f4a:	83 c4 10             	add    $0x10,%esp
80104f4d:	85 c0                	test   %eax,%eax
80104f4f:	0f 85 7f 00 00 00    	jne    80104fd4 <acquire+0xa4>
80104f55:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104f57:	ba 01 00 00 00       	mov    $0x1,%edx
80104f5c:	eb 05                	jmp    80104f63 <acquire+0x33>
80104f5e:	66 90                	xchg   %ax,%ax
80104f60:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104f63:	89 d0                	mov    %edx,%eax
80104f65:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104f68:	85 c0                	test   %eax,%eax
80104f6a:	75 f4                	jne    80104f60 <acquire+0x30>
  __sync_synchronize();
80104f6c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104f71:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104f74:	e8 07 f1 ff ff       	call   80104080 <mycpu>
80104f79:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104f7c:	89 e8                	mov    %ebp,%eax
80104f7e:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104f80:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104f86:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
80104f8c:	77 22                	ja     80104fb0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104f8e:	8b 50 04             	mov    0x4(%eax),%edx
80104f91:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80104f95:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104f98:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104f9a:	83 fe 0a             	cmp    $0xa,%esi
80104f9d:	75 e1                	jne    80104f80 <acquire+0x50>
}
80104f9f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fa2:	5b                   	pop    %ebx
80104fa3:	5e                   	pop    %esi
80104fa4:	5d                   	pop    %ebp
80104fa5:	c3                   	ret    
80104fa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fad:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104fb0:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104fb4:	83 c3 34             	add    $0x34,%ebx
80104fb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fbe:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104fc0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104fc6:	83 c0 04             	add    $0x4,%eax
80104fc9:	39 d8                	cmp    %ebx,%eax
80104fcb:	75 f3                	jne    80104fc0 <acquire+0x90>
}
80104fcd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fd0:	5b                   	pop    %ebx
80104fd1:	5e                   	pop    %esi
80104fd2:	5d                   	pop    %ebp
80104fd3:	c3                   	ret    
    panic("acquire");
80104fd4:	83 ec 0c             	sub    $0xc,%esp
80104fd7:	68 2d 87 10 80       	push   $0x8010872d
80104fdc:	e8 af b3 ff ff       	call   80100390 <panic>
80104fe1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fe8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fef:	90                   	nop

80104ff0 <release>:
{
80104ff0:	f3 0f 1e fb          	endbr32 
80104ff4:	55                   	push   %ebp
80104ff5:	89 e5                	mov    %esp,%ebp
80104ff7:	53                   	push   %ebx
80104ff8:	83 ec 10             	sub    $0x10,%esp
80104ffb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104ffe:	53                   	push   %ebx
80104fff:	e8 dc fe ff ff       	call   80104ee0 <holding>
80105004:	83 c4 10             	add    $0x10,%esp
80105007:	85 c0                	test   %eax,%eax
80105009:	74 22                	je     8010502d <release+0x3d>
  lk->pcs[0] = 0;
8010500b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80105012:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80105019:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010501e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80105024:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105027:	c9                   	leave  
  popcli();
80105028:	e9 53 fe ff ff       	jmp    80104e80 <popcli>
    panic("release");
8010502d:	83 ec 0c             	sub    $0xc,%esp
80105030:	68 35 87 10 80       	push   $0x80108735
80105035:	e8 56 b3 ff ff       	call   80100390 <panic>
8010503a:	66 90                	xchg   %ax,%ax
8010503c:	66 90                	xchg   %ax,%ax
8010503e:	66 90                	xchg   %ax,%ax

80105040 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105040:	f3 0f 1e fb          	endbr32 
80105044:	55                   	push   %ebp
80105045:	89 e5                	mov    %esp,%ebp
80105047:	57                   	push   %edi
80105048:	8b 55 08             	mov    0x8(%ebp),%edx
8010504b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010504e:	53                   	push   %ebx
8010504f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80105052:	89 d7                	mov    %edx,%edi
80105054:	09 cf                	or     %ecx,%edi
80105056:	83 e7 03             	and    $0x3,%edi
80105059:	75 25                	jne    80105080 <memset+0x40>
    c &= 0xFF;
8010505b:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010505e:	c1 e0 18             	shl    $0x18,%eax
80105061:	89 fb                	mov    %edi,%ebx
80105063:	c1 e9 02             	shr    $0x2,%ecx
80105066:	c1 e3 10             	shl    $0x10,%ebx
80105069:	09 d8                	or     %ebx,%eax
8010506b:	09 f8                	or     %edi,%eax
8010506d:	c1 e7 08             	shl    $0x8,%edi
80105070:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80105072:	89 d7                	mov    %edx,%edi
80105074:	fc                   	cld    
80105075:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80105077:	5b                   	pop    %ebx
80105078:	89 d0                	mov    %edx,%eax
8010507a:	5f                   	pop    %edi
8010507b:	5d                   	pop    %ebp
8010507c:	c3                   	ret    
8010507d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80105080:	89 d7                	mov    %edx,%edi
80105082:	fc                   	cld    
80105083:	f3 aa                	rep stos %al,%es:(%edi)
80105085:	5b                   	pop    %ebx
80105086:	89 d0                	mov    %edx,%eax
80105088:	5f                   	pop    %edi
80105089:	5d                   	pop    %ebp
8010508a:	c3                   	ret    
8010508b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010508f:	90                   	nop

80105090 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105090:	f3 0f 1e fb          	endbr32 
80105094:	55                   	push   %ebp
80105095:	89 e5                	mov    %esp,%ebp
80105097:	56                   	push   %esi
80105098:	8b 75 10             	mov    0x10(%ebp),%esi
8010509b:	8b 55 08             	mov    0x8(%ebp),%edx
8010509e:	53                   	push   %ebx
8010509f:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801050a2:	85 f6                	test   %esi,%esi
801050a4:	74 2a                	je     801050d0 <memcmp+0x40>
801050a6:	01 c6                	add    %eax,%esi
801050a8:	eb 10                	jmp    801050ba <memcmp+0x2a>
801050aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
801050b0:	83 c0 01             	add    $0x1,%eax
801050b3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801050b6:	39 f0                	cmp    %esi,%eax
801050b8:	74 16                	je     801050d0 <memcmp+0x40>
    if(*s1 != *s2)
801050ba:	0f b6 0a             	movzbl (%edx),%ecx
801050bd:	0f b6 18             	movzbl (%eax),%ebx
801050c0:	38 d9                	cmp    %bl,%cl
801050c2:	74 ec                	je     801050b0 <memcmp+0x20>
      return *s1 - *s2;
801050c4:	0f b6 c1             	movzbl %cl,%eax
801050c7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801050c9:	5b                   	pop    %ebx
801050ca:	5e                   	pop    %esi
801050cb:	5d                   	pop    %ebp
801050cc:	c3                   	ret    
801050cd:	8d 76 00             	lea    0x0(%esi),%esi
801050d0:	5b                   	pop    %ebx
  return 0;
801050d1:	31 c0                	xor    %eax,%eax
}
801050d3:	5e                   	pop    %esi
801050d4:	5d                   	pop    %ebp
801050d5:	c3                   	ret    
801050d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050dd:	8d 76 00             	lea    0x0(%esi),%esi

801050e0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801050e0:	f3 0f 1e fb          	endbr32 
801050e4:	55                   	push   %ebp
801050e5:	89 e5                	mov    %esp,%ebp
801050e7:	57                   	push   %edi
801050e8:	8b 55 08             	mov    0x8(%ebp),%edx
801050eb:	8b 4d 10             	mov    0x10(%ebp),%ecx
801050ee:	56                   	push   %esi
801050ef:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801050f2:	39 d6                	cmp    %edx,%esi
801050f4:	73 2a                	jae    80105120 <memmove+0x40>
801050f6:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
801050f9:	39 fa                	cmp    %edi,%edx
801050fb:	73 23                	jae    80105120 <memmove+0x40>
801050fd:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80105100:	85 c9                	test   %ecx,%ecx
80105102:	74 13                	je     80105117 <memmove+0x37>
80105104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80105108:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
8010510c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
8010510f:	83 e8 01             	sub    $0x1,%eax
80105112:	83 f8 ff             	cmp    $0xffffffff,%eax
80105115:	75 f1                	jne    80105108 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80105117:	5e                   	pop    %esi
80105118:	89 d0                	mov    %edx,%eax
8010511a:	5f                   	pop    %edi
8010511b:	5d                   	pop    %ebp
8010511c:	c3                   	ret    
8010511d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80105120:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80105123:	89 d7                	mov    %edx,%edi
80105125:	85 c9                	test   %ecx,%ecx
80105127:	74 ee                	je     80105117 <memmove+0x37>
80105129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80105130:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80105131:	39 f0                	cmp    %esi,%eax
80105133:	75 fb                	jne    80105130 <memmove+0x50>
}
80105135:	5e                   	pop    %esi
80105136:	89 d0                	mov    %edx,%eax
80105138:	5f                   	pop    %edi
80105139:	5d                   	pop    %ebp
8010513a:	c3                   	ret    
8010513b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010513f:	90                   	nop

80105140 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105140:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80105144:	eb 9a                	jmp    801050e0 <memmove>
80105146:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010514d:	8d 76 00             	lea    0x0(%esi),%esi

80105150 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80105150:	f3 0f 1e fb          	endbr32 
80105154:	55                   	push   %ebp
80105155:	89 e5                	mov    %esp,%ebp
80105157:	56                   	push   %esi
80105158:	8b 75 10             	mov    0x10(%ebp),%esi
8010515b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010515e:	53                   	push   %ebx
8010515f:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80105162:	85 f6                	test   %esi,%esi
80105164:	74 32                	je     80105198 <strncmp+0x48>
80105166:	01 c6                	add    %eax,%esi
80105168:	eb 14                	jmp    8010517e <strncmp+0x2e>
8010516a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105170:	38 da                	cmp    %bl,%dl
80105172:	75 14                	jne    80105188 <strncmp+0x38>
    n--, p++, q++;
80105174:	83 c0 01             	add    $0x1,%eax
80105177:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010517a:	39 f0                	cmp    %esi,%eax
8010517c:	74 1a                	je     80105198 <strncmp+0x48>
8010517e:	0f b6 11             	movzbl (%ecx),%edx
80105181:	0f b6 18             	movzbl (%eax),%ebx
80105184:	84 d2                	test   %dl,%dl
80105186:	75 e8                	jne    80105170 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80105188:	0f b6 c2             	movzbl %dl,%eax
8010518b:	29 d8                	sub    %ebx,%eax
}
8010518d:	5b                   	pop    %ebx
8010518e:	5e                   	pop    %esi
8010518f:	5d                   	pop    %ebp
80105190:	c3                   	ret    
80105191:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105198:	5b                   	pop    %ebx
    return 0;
80105199:	31 c0                	xor    %eax,%eax
}
8010519b:	5e                   	pop    %esi
8010519c:	5d                   	pop    %ebp
8010519d:	c3                   	ret    
8010519e:	66 90                	xchg   %ax,%ax

801051a0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801051a0:	f3 0f 1e fb          	endbr32 
801051a4:	55                   	push   %ebp
801051a5:	89 e5                	mov    %esp,%ebp
801051a7:	57                   	push   %edi
801051a8:	56                   	push   %esi
801051a9:	8b 75 08             	mov    0x8(%ebp),%esi
801051ac:	53                   	push   %ebx
801051ad:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801051b0:	89 f2                	mov    %esi,%edx
801051b2:	eb 1b                	jmp    801051cf <strncpy+0x2f>
801051b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051b8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801051bc:	8b 7d 0c             	mov    0xc(%ebp),%edi
801051bf:	83 c2 01             	add    $0x1,%edx
801051c2:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
801051c6:	89 f9                	mov    %edi,%ecx
801051c8:	88 4a ff             	mov    %cl,-0x1(%edx)
801051cb:	84 c9                	test   %cl,%cl
801051cd:	74 09                	je     801051d8 <strncpy+0x38>
801051cf:	89 c3                	mov    %eax,%ebx
801051d1:	83 e8 01             	sub    $0x1,%eax
801051d4:	85 db                	test   %ebx,%ebx
801051d6:	7f e0                	jg     801051b8 <strncpy+0x18>
    ;
  while(n-- > 0)
801051d8:	89 d1                	mov    %edx,%ecx
801051da:	85 c0                	test   %eax,%eax
801051dc:	7e 15                	jle    801051f3 <strncpy+0x53>
801051de:	66 90                	xchg   %ax,%ax
    *s++ = 0;
801051e0:	83 c1 01             	add    $0x1,%ecx
801051e3:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
801051e7:	89 c8                	mov    %ecx,%eax
801051e9:	f7 d0                	not    %eax
801051eb:	01 d0                	add    %edx,%eax
801051ed:	01 d8                	add    %ebx,%eax
801051ef:	85 c0                	test   %eax,%eax
801051f1:	7f ed                	jg     801051e0 <strncpy+0x40>
  return os;
}
801051f3:	5b                   	pop    %ebx
801051f4:	89 f0                	mov    %esi,%eax
801051f6:	5e                   	pop    %esi
801051f7:	5f                   	pop    %edi
801051f8:	5d                   	pop    %ebp
801051f9:	c3                   	ret    
801051fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105200 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105200:	f3 0f 1e fb          	endbr32 
80105204:	55                   	push   %ebp
80105205:	89 e5                	mov    %esp,%ebp
80105207:	56                   	push   %esi
80105208:	8b 55 10             	mov    0x10(%ebp),%edx
8010520b:	8b 75 08             	mov    0x8(%ebp),%esi
8010520e:	53                   	push   %ebx
8010520f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80105212:	85 d2                	test   %edx,%edx
80105214:	7e 21                	jle    80105237 <safestrcpy+0x37>
80105216:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
8010521a:	89 f2                	mov    %esi,%edx
8010521c:	eb 12                	jmp    80105230 <safestrcpy+0x30>
8010521e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105220:	0f b6 08             	movzbl (%eax),%ecx
80105223:	83 c0 01             	add    $0x1,%eax
80105226:	83 c2 01             	add    $0x1,%edx
80105229:	88 4a ff             	mov    %cl,-0x1(%edx)
8010522c:	84 c9                	test   %cl,%cl
8010522e:	74 04                	je     80105234 <safestrcpy+0x34>
80105230:	39 d8                	cmp    %ebx,%eax
80105232:	75 ec                	jne    80105220 <safestrcpy+0x20>
    ;
  *s = 0;
80105234:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80105237:	89 f0                	mov    %esi,%eax
80105239:	5b                   	pop    %ebx
8010523a:	5e                   	pop    %esi
8010523b:	5d                   	pop    %ebp
8010523c:	c3                   	ret    
8010523d:	8d 76 00             	lea    0x0(%esi),%esi

80105240 <strlen>:

int
strlen(const char *s)
{
80105240:	f3 0f 1e fb          	endbr32 
80105244:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105245:	31 c0                	xor    %eax,%eax
{
80105247:	89 e5                	mov    %esp,%ebp
80105249:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
8010524c:	80 3a 00             	cmpb   $0x0,(%edx)
8010524f:	74 10                	je     80105261 <strlen+0x21>
80105251:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105258:	83 c0 01             	add    $0x1,%eax
8010525b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
8010525f:	75 f7                	jne    80105258 <strlen+0x18>
    ;
  return n;
}
80105261:	5d                   	pop    %ebp
80105262:	c3                   	ret    

80105263 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105263:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105267:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
8010526b:	55                   	push   %ebp
  pushl %ebx
8010526c:	53                   	push   %ebx
  pushl %esi
8010526d:	56                   	push   %esi
  pushl %edi
8010526e:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
8010526f:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105271:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80105273:	5f                   	pop    %edi
  popl %esi
80105274:	5e                   	pop    %esi
  popl %ebx
80105275:	5b                   	pop    %ebx
  popl %ebp
80105276:	5d                   	pop    %ebp
  ret
80105277:	c3                   	ret    
80105278:	66 90                	xchg   %ax,%ax
8010527a:	66 90                	xchg   %ax,%ax
8010527c:	66 90                	xchg   %ax,%ax
8010527e:	66 90                	xchg   %ax,%ax

80105280 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105280:	f3 0f 1e fb          	endbr32 
80105284:	55                   	push   %ebp
80105285:	89 e5                	mov    %esp,%ebp
80105287:	53                   	push   %ebx
80105288:	83 ec 04             	sub    $0x4,%esp
8010528b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010528e:	e8 7d ee ff ff       	call   80104110 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105293:	8b 00                	mov    (%eax),%eax
80105295:	39 d8                	cmp    %ebx,%eax
80105297:	76 17                	jbe    801052b0 <fetchint+0x30>
80105299:	8d 53 04             	lea    0x4(%ebx),%edx
8010529c:	39 d0                	cmp    %edx,%eax
8010529e:	72 10                	jb     801052b0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801052a0:	8b 45 0c             	mov    0xc(%ebp),%eax
801052a3:	8b 13                	mov    (%ebx),%edx
801052a5:	89 10                	mov    %edx,(%eax)
  return 0;
801052a7:	31 c0                	xor    %eax,%eax
}
801052a9:	83 c4 04             	add    $0x4,%esp
801052ac:	5b                   	pop    %ebx
801052ad:	5d                   	pop    %ebp
801052ae:	c3                   	ret    
801052af:	90                   	nop
    return -1;
801052b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052b5:	eb f2                	jmp    801052a9 <fetchint+0x29>
801052b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052be:	66 90                	xchg   %ax,%ax

801052c0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801052c0:	f3 0f 1e fb          	endbr32 
801052c4:	55                   	push   %ebp
801052c5:	89 e5                	mov    %esp,%ebp
801052c7:	53                   	push   %ebx
801052c8:	83 ec 04             	sub    $0x4,%esp
801052cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801052ce:	e8 3d ee ff ff       	call   80104110 <myproc>

  if(addr >= curproc->sz)
801052d3:	39 18                	cmp    %ebx,(%eax)
801052d5:	76 31                	jbe    80105308 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
801052d7:	8b 55 0c             	mov    0xc(%ebp),%edx
801052da:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801052dc:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801052de:	39 d3                	cmp    %edx,%ebx
801052e0:	73 26                	jae    80105308 <fetchstr+0x48>
801052e2:	89 d8                	mov    %ebx,%eax
801052e4:	eb 11                	jmp    801052f7 <fetchstr+0x37>
801052e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052ed:	8d 76 00             	lea    0x0(%esi),%esi
801052f0:	83 c0 01             	add    $0x1,%eax
801052f3:	39 c2                	cmp    %eax,%edx
801052f5:	76 11                	jbe    80105308 <fetchstr+0x48>
    if(*s == 0)
801052f7:	80 38 00             	cmpb   $0x0,(%eax)
801052fa:	75 f4                	jne    801052f0 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
801052fc:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
801052ff:	29 d8                	sub    %ebx,%eax
}
80105301:	5b                   	pop    %ebx
80105302:	5d                   	pop    %ebp
80105303:	c3                   	ret    
80105304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105308:	83 c4 04             	add    $0x4,%esp
    return -1;
8010530b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105310:	5b                   	pop    %ebx
80105311:	5d                   	pop    %ebp
80105312:	c3                   	ret    
80105313:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010531a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105320 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105320:	f3 0f 1e fb          	endbr32 
80105324:	55                   	push   %ebp
80105325:	89 e5                	mov    %esp,%ebp
80105327:	56                   	push   %esi
80105328:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105329:	e8 e2 ed ff ff       	call   80104110 <myproc>
8010532e:	8b 55 08             	mov    0x8(%ebp),%edx
80105331:	8b 40 18             	mov    0x18(%eax),%eax
80105334:	8b 40 44             	mov    0x44(%eax),%eax
80105337:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
8010533a:	e8 d1 ed ff ff       	call   80104110 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010533f:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105342:	8b 00                	mov    (%eax),%eax
80105344:	39 c6                	cmp    %eax,%esi
80105346:	73 18                	jae    80105360 <argint+0x40>
80105348:	8d 53 08             	lea    0x8(%ebx),%edx
8010534b:	39 d0                	cmp    %edx,%eax
8010534d:	72 11                	jb     80105360 <argint+0x40>
  *ip = *(int*)(addr);
8010534f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105352:	8b 53 04             	mov    0x4(%ebx),%edx
80105355:	89 10                	mov    %edx,(%eax)
  return 0;
80105357:	31 c0                	xor    %eax,%eax
}
80105359:	5b                   	pop    %ebx
8010535a:	5e                   	pop    %esi
8010535b:	5d                   	pop    %ebp
8010535c:	c3                   	ret    
8010535d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105360:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105365:	eb f2                	jmp    80105359 <argint+0x39>
80105367:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010536e:	66 90                	xchg   %ax,%ax

80105370 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105370:	f3 0f 1e fb          	endbr32 
80105374:	55                   	push   %ebp
80105375:	89 e5                	mov    %esp,%ebp
80105377:	56                   	push   %esi
80105378:	53                   	push   %ebx
80105379:	83 ec 10             	sub    $0x10,%esp
8010537c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010537f:	e8 8c ed ff ff       	call   80104110 <myproc>
 
  if(argint(n, &i) < 0)
80105384:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80105387:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80105389:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010538c:	50                   	push   %eax
8010538d:	ff 75 08             	pushl  0x8(%ebp)
80105390:	e8 8b ff ff ff       	call   80105320 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105395:	83 c4 10             	add    $0x10,%esp
80105398:	85 c0                	test   %eax,%eax
8010539a:	78 24                	js     801053c0 <argptr+0x50>
8010539c:	85 db                	test   %ebx,%ebx
8010539e:	78 20                	js     801053c0 <argptr+0x50>
801053a0:	8b 16                	mov    (%esi),%edx
801053a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053a5:	39 c2                	cmp    %eax,%edx
801053a7:	76 17                	jbe    801053c0 <argptr+0x50>
801053a9:	01 c3                	add    %eax,%ebx
801053ab:	39 da                	cmp    %ebx,%edx
801053ad:	72 11                	jb     801053c0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
801053af:	8b 55 0c             	mov    0xc(%ebp),%edx
801053b2:	89 02                	mov    %eax,(%edx)
  return 0;
801053b4:	31 c0                	xor    %eax,%eax
}
801053b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801053b9:	5b                   	pop    %ebx
801053ba:	5e                   	pop    %esi
801053bb:	5d                   	pop    %ebp
801053bc:	c3                   	ret    
801053bd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801053c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053c5:	eb ef                	jmp    801053b6 <argptr+0x46>
801053c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053ce:	66 90                	xchg   %ax,%ax

801053d0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801053d0:	f3 0f 1e fb          	endbr32 
801053d4:	55                   	push   %ebp
801053d5:	89 e5                	mov    %esp,%ebp
801053d7:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801053da:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053dd:	50                   	push   %eax
801053de:	ff 75 08             	pushl  0x8(%ebp)
801053e1:	e8 3a ff ff ff       	call   80105320 <argint>
801053e6:	83 c4 10             	add    $0x10,%esp
801053e9:	85 c0                	test   %eax,%eax
801053eb:	78 13                	js     80105400 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801053ed:	83 ec 08             	sub    $0x8,%esp
801053f0:	ff 75 0c             	pushl  0xc(%ebp)
801053f3:	ff 75 f4             	pushl  -0xc(%ebp)
801053f6:	e8 c5 fe ff ff       	call   801052c0 <fetchstr>
801053fb:	83 c4 10             	add    $0x10,%esp
}
801053fe:	c9                   	leave  
801053ff:	c3                   	ret    
80105400:	c9                   	leave  
    return -1;
80105401:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105406:	c3                   	ret    
80105407:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010540e:	66 90                	xchg   %ax,%ax

80105410 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80105410:	f3 0f 1e fb          	endbr32 
80105414:	55                   	push   %ebp
80105415:	89 e5                	mov    %esp,%ebp
80105417:	53                   	push   %ebx
80105418:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
8010541b:	e8 f0 ec ff ff       	call   80104110 <myproc>
80105420:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80105422:	8b 40 18             	mov    0x18(%eax),%eax
80105425:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105428:	8d 50 ff             	lea    -0x1(%eax),%edx
8010542b:	83 fa 14             	cmp    $0x14,%edx
8010542e:	77 20                	ja     80105450 <syscall+0x40>
80105430:	8b 14 85 60 87 10 80 	mov    -0x7fef78a0(,%eax,4),%edx
80105437:	85 d2                	test   %edx,%edx
80105439:	74 15                	je     80105450 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
8010543b:	ff d2                	call   *%edx
8010543d:	89 c2                	mov    %eax,%edx
8010543f:	8b 43 18             	mov    0x18(%ebx),%eax
80105442:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105445:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105448:	c9                   	leave  
80105449:	c3                   	ret    
8010544a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105450:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105451:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105454:	50                   	push   %eax
80105455:	ff 73 10             	pushl  0x10(%ebx)
80105458:	68 3d 87 10 80       	push   $0x8010873d
8010545d:	e8 4e b2 ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80105462:	8b 43 18             	mov    0x18(%ebx),%eax
80105465:	83 c4 10             	add    $0x10,%esp
80105468:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
8010546f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105472:	c9                   	leave  
80105473:	c3                   	ret    
80105474:	66 90                	xchg   %ax,%ax
80105476:	66 90                	xchg   %ax,%ax
80105478:	66 90                	xchg   %ax,%ax
8010547a:	66 90                	xchg   %ax,%ax
8010547c:	66 90                	xchg   %ax,%ax
8010547e:	66 90                	xchg   %ax,%ax

80105480 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80105480:	55                   	push   %ebp
80105481:	89 e5                	mov    %esp,%ebp
80105483:	56                   	push   %esi
80105484:	89 d6                	mov    %edx,%esi
80105486:	53                   	push   %ebx
80105487:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105489:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010548c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010548f:	50                   	push   %eax
80105490:	6a 00                	push   $0x0
80105492:	e8 89 fe ff ff       	call   80105320 <argint>
80105497:	83 c4 10             	add    $0x10,%esp
8010549a:	85 c0                	test   %eax,%eax
8010549c:	78 2a                	js     801054c8 <argfd.constprop.0+0x48>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010549e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801054a2:	77 24                	ja     801054c8 <argfd.constprop.0+0x48>
801054a4:	e8 67 ec ff ff       	call   80104110 <myproc>
801054a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801054ac:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801054b0:	85 c0                	test   %eax,%eax
801054b2:	74 14                	je     801054c8 <argfd.constprop.0+0x48>
    return -1;
  if(pfd)
801054b4:	85 db                	test   %ebx,%ebx
801054b6:	74 02                	je     801054ba <argfd.constprop.0+0x3a>
    *pfd = fd;
801054b8:	89 13                	mov    %edx,(%ebx)
  if(pf)
    *pf = f;
801054ba:	89 06                	mov    %eax,(%esi)
  return 0;
801054bc:	31 c0                	xor    %eax,%eax
}
801054be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054c1:	5b                   	pop    %ebx
801054c2:	5e                   	pop    %esi
801054c3:	5d                   	pop    %ebp
801054c4:	c3                   	ret    
801054c5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801054c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054cd:	eb ef                	jmp    801054be <argfd.constprop.0+0x3e>
801054cf:	90                   	nop

801054d0 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
801054d0:	f3 0f 1e fb          	endbr32 
801054d4:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801054d5:	31 c0                	xor    %eax,%eax
{
801054d7:	89 e5                	mov    %esp,%ebp
801054d9:	56                   	push   %esi
801054da:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
801054db:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
801054de:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
801054e1:	e8 9a ff ff ff       	call   80105480 <argfd.constprop.0>
801054e6:	85 c0                	test   %eax,%eax
801054e8:	78 1e                	js     80105508 <sys_dup+0x38>
    return -1;
  if((fd=fdalloc(f)) < 0)
801054ea:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
801054ed:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801054ef:	e8 1c ec ff ff       	call   80104110 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801054f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801054f8:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801054fc:	85 d2                	test   %edx,%edx
801054fe:	74 20                	je     80105520 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80105500:	83 c3 01             	add    $0x1,%ebx
80105503:	83 fb 10             	cmp    $0x10,%ebx
80105506:	75 f0                	jne    801054f8 <sys_dup+0x28>
    return -1;
  filedup(f);
  return fd;
}
80105508:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010550b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105510:	89 d8                	mov    %ebx,%eax
80105512:	5b                   	pop    %ebx
80105513:	5e                   	pop    %esi
80105514:	5d                   	pop    %ebp
80105515:	c3                   	ret    
80105516:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010551d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105520:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105524:	83 ec 0c             	sub    $0xc,%esp
80105527:	ff 75 f4             	pushl  -0xc(%ebp)
8010552a:	e8 01 bd ff ff       	call   80101230 <filedup>
  return fd;
8010552f:	83 c4 10             	add    $0x10,%esp
}
80105532:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105535:	89 d8                	mov    %ebx,%eax
80105537:	5b                   	pop    %ebx
80105538:	5e                   	pop    %esi
80105539:	5d                   	pop    %ebp
8010553a:	c3                   	ret    
8010553b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010553f:	90                   	nop

80105540 <sys_read>:

int
sys_read(void)
{
80105540:	f3 0f 1e fb          	endbr32 
80105544:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105545:	31 c0                	xor    %eax,%eax
{
80105547:	89 e5                	mov    %esp,%ebp
80105549:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010554c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010554f:	e8 2c ff ff ff       	call   80105480 <argfd.constprop.0>
80105554:	85 c0                	test   %eax,%eax
80105556:	78 48                	js     801055a0 <sys_read+0x60>
80105558:	83 ec 08             	sub    $0x8,%esp
8010555b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010555e:	50                   	push   %eax
8010555f:	6a 02                	push   $0x2
80105561:	e8 ba fd ff ff       	call   80105320 <argint>
80105566:	83 c4 10             	add    $0x10,%esp
80105569:	85 c0                	test   %eax,%eax
8010556b:	78 33                	js     801055a0 <sys_read+0x60>
8010556d:	83 ec 04             	sub    $0x4,%esp
80105570:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105573:	ff 75 f0             	pushl  -0x10(%ebp)
80105576:	50                   	push   %eax
80105577:	6a 01                	push   $0x1
80105579:	e8 f2 fd ff ff       	call   80105370 <argptr>
8010557e:	83 c4 10             	add    $0x10,%esp
80105581:	85 c0                	test   %eax,%eax
80105583:	78 1b                	js     801055a0 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80105585:	83 ec 04             	sub    $0x4,%esp
80105588:	ff 75 f0             	pushl  -0x10(%ebp)
8010558b:	ff 75 f4             	pushl  -0xc(%ebp)
8010558e:	ff 75 ec             	pushl  -0x14(%ebp)
80105591:	e8 1a be ff ff       	call   801013b0 <fileread>
80105596:	83 c4 10             	add    $0x10,%esp
}
80105599:	c9                   	leave  
8010559a:	c3                   	ret    
8010559b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010559f:	90                   	nop
801055a0:	c9                   	leave  
    return -1;
801055a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055a6:	c3                   	ret    
801055a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055ae:	66 90                	xchg   %ax,%ax

801055b0 <sys_write>:

int
sys_write(void)
{
801055b0:	f3 0f 1e fb          	endbr32 
801055b4:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801055b5:	31 c0                	xor    %eax,%eax
{
801055b7:	89 e5                	mov    %esp,%ebp
801055b9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801055bc:	8d 55 ec             	lea    -0x14(%ebp),%edx
801055bf:	e8 bc fe ff ff       	call   80105480 <argfd.constprop.0>
801055c4:	85 c0                	test   %eax,%eax
801055c6:	78 48                	js     80105610 <sys_write+0x60>
801055c8:	83 ec 08             	sub    $0x8,%esp
801055cb:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055ce:	50                   	push   %eax
801055cf:	6a 02                	push   $0x2
801055d1:	e8 4a fd ff ff       	call   80105320 <argint>
801055d6:	83 c4 10             	add    $0x10,%esp
801055d9:	85 c0                	test   %eax,%eax
801055db:	78 33                	js     80105610 <sys_write+0x60>
801055dd:	83 ec 04             	sub    $0x4,%esp
801055e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055e3:	ff 75 f0             	pushl  -0x10(%ebp)
801055e6:	50                   	push   %eax
801055e7:	6a 01                	push   $0x1
801055e9:	e8 82 fd ff ff       	call   80105370 <argptr>
801055ee:	83 c4 10             	add    $0x10,%esp
801055f1:	85 c0                	test   %eax,%eax
801055f3:	78 1b                	js     80105610 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
801055f5:	83 ec 04             	sub    $0x4,%esp
801055f8:	ff 75 f0             	pushl  -0x10(%ebp)
801055fb:	ff 75 f4             	pushl  -0xc(%ebp)
801055fe:	ff 75 ec             	pushl  -0x14(%ebp)
80105601:	e8 4a be ff ff       	call   80101450 <filewrite>
80105606:	83 c4 10             	add    $0x10,%esp
}
80105609:	c9                   	leave  
8010560a:	c3                   	ret    
8010560b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010560f:	90                   	nop
80105610:	c9                   	leave  
    return -1;
80105611:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105616:	c3                   	ret    
80105617:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010561e:	66 90                	xchg   %ax,%ax

80105620 <sys_close>:

int
sys_close(void)
{
80105620:	f3 0f 1e fb          	endbr32 
80105624:	55                   	push   %ebp
80105625:	89 e5                	mov    %esp,%ebp
80105627:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
8010562a:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010562d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105630:	e8 4b fe ff ff       	call   80105480 <argfd.constprop.0>
80105635:	85 c0                	test   %eax,%eax
80105637:	78 27                	js     80105660 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80105639:	e8 d2 ea ff ff       	call   80104110 <myproc>
8010563e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80105641:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105644:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
8010564b:	00 
  fileclose(f);
8010564c:	ff 75 f4             	pushl  -0xc(%ebp)
8010564f:	e8 2c bc ff ff       	call   80101280 <fileclose>
  return 0;
80105654:	83 c4 10             	add    $0x10,%esp
80105657:	31 c0                	xor    %eax,%eax
}
80105659:	c9                   	leave  
8010565a:	c3                   	ret    
8010565b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010565f:	90                   	nop
80105660:	c9                   	leave  
    return -1;
80105661:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105666:	c3                   	ret    
80105667:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010566e:	66 90                	xchg   %ax,%ax

80105670 <sys_fstat>:

int
sys_fstat(void)
{
80105670:	f3 0f 1e fb          	endbr32 
80105674:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105675:	31 c0                	xor    %eax,%eax
{
80105677:	89 e5                	mov    %esp,%ebp
80105679:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010567c:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010567f:	e8 fc fd ff ff       	call   80105480 <argfd.constprop.0>
80105684:	85 c0                	test   %eax,%eax
80105686:	78 30                	js     801056b8 <sys_fstat+0x48>
80105688:	83 ec 04             	sub    $0x4,%esp
8010568b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010568e:	6a 14                	push   $0x14
80105690:	50                   	push   %eax
80105691:	6a 01                	push   $0x1
80105693:	e8 d8 fc ff ff       	call   80105370 <argptr>
80105698:	83 c4 10             	add    $0x10,%esp
8010569b:	85 c0                	test   %eax,%eax
8010569d:	78 19                	js     801056b8 <sys_fstat+0x48>
    return -1;
  return filestat(f, st);
8010569f:	83 ec 08             	sub    $0x8,%esp
801056a2:	ff 75 f4             	pushl  -0xc(%ebp)
801056a5:	ff 75 f0             	pushl  -0x10(%ebp)
801056a8:	e8 b3 bc ff ff       	call   80101360 <filestat>
801056ad:	83 c4 10             	add    $0x10,%esp
}
801056b0:	c9                   	leave  
801056b1:	c3                   	ret    
801056b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801056b8:	c9                   	leave  
    return -1;
801056b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056be:	c3                   	ret    
801056bf:	90                   	nop

801056c0 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801056c0:	f3 0f 1e fb          	endbr32 
801056c4:	55                   	push   %ebp
801056c5:	89 e5                	mov    %esp,%ebp
801056c7:	57                   	push   %edi
801056c8:	56                   	push   %esi
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801056c9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801056cc:	53                   	push   %ebx
801056cd:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801056d0:	50                   	push   %eax
801056d1:	6a 00                	push   $0x0
801056d3:	e8 f8 fc ff ff       	call   801053d0 <argstr>
801056d8:	83 c4 10             	add    $0x10,%esp
801056db:	85 c0                	test   %eax,%eax
801056dd:	0f 88 ff 00 00 00    	js     801057e2 <sys_link+0x122>
801056e3:	83 ec 08             	sub    $0x8,%esp
801056e6:	8d 45 d0             	lea    -0x30(%ebp),%eax
801056e9:	50                   	push   %eax
801056ea:	6a 01                	push   $0x1
801056ec:	e8 df fc ff ff       	call   801053d0 <argstr>
801056f1:	83 c4 10             	add    $0x10,%esp
801056f4:	85 c0                	test   %eax,%eax
801056f6:	0f 88 e6 00 00 00    	js     801057e2 <sys_link+0x122>
    return -1;

  begin_op();
801056fc:	e8 6f dd ff ff       	call   80103470 <begin_op>
  if((ip = namei(old)) == 0){
80105701:	83 ec 0c             	sub    $0xc,%esp
80105704:	ff 75 d4             	pushl  -0x2c(%ebp)
80105707:	e8 e4 cc ff ff       	call   801023f0 <namei>
8010570c:	83 c4 10             	add    $0x10,%esp
8010570f:	89 c3                	mov    %eax,%ebx
80105711:	85 c0                	test   %eax,%eax
80105713:	0f 84 e8 00 00 00    	je     80105801 <sys_link+0x141>
    end_op();
    return -1;
  }

  ilock(ip);
80105719:	83 ec 0c             	sub    $0xc,%esp
8010571c:	50                   	push   %eax
8010571d:	e8 fe c3 ff ff       	call   80101b20 <ilock>
  if(ip->type == T_DIR){
80105722:	83 c4 10             	add    $0x10,%esp
80105725:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010572a:	0f 84 b9 00 00 00    	je     801057e9 <sys_link+0x129>
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80105730:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105733:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80105738:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
8010573b:	53                   	push   %ebx
8010573c:	e8 1f c3 ff ff       	call   80101a60 <iupdate>
  iunlock(ip);
80105741:	89 1c 24             	mov    %ebx,(%esp)
80105744:	e8 b7 c4 ff ff       	call   80101c00 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105749:	58                   	pop    %eax
8010574a:	5a                   	pop    %edx
8010574b:	57                   	push   %edi
8010574c:	ff 75 d0             	pushl  -0x30(%ebp)
8010574f:	e8 bc cc ff ff       	call   80102410 <nameiparent>
80105754:	83 c4 10             	add    $0x10,%esp
80105757:	89 c6                	mov    %eax,%esi
80105759:	85 c0                	test   %eax,%eax
8010575b:	74 5f                	je     801057bc <sys_link+0xfc>
    goto bad;
  ilock(dp);
8010575d:	83 ec 0c             	sub    $0xc,%esp
80105760:	50                   	push   %eax
80105761:	e8 ba c3 ff ff       	call   80101b20 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105766:	8b 03                	mov    (%ebx),%eax
80105768:	83 c4 10             	add    $0x10,%esp
8010576b:	39 06                	cmp    %eax,(%esi)
8010576d:	75 41                	jne    801057b0 <sys_link+0xf0>
8010576f:	83 ec 04             	sub    $0x4,%esp
80105772:	ff 73 04             	pushl  0x4(%ebx)
80105775:	57                   	push   %edi
80105776:	56                   	push   %esi
80105777:	e8 b4 cb ff ff       	call   80102330 <dirlink>
8010577c:	83 c4 10             	add    $0x10,%esp
8010577f:	85 c0                	test   %eax,%eax
80105781:	78 2d                	js     801057b0 <sys_link+0xf0>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80105783:	83 ec 0c             	sub    $0xc,%esp
80105786:	56                   	push   %esi
80105787:	e8 34 c6 ff ff       	call   80101dc0 <iunlockput>
  iput(ip);
8010578c:	89 1c 24             	mov    %ebx,(%esp)
8010578f:	e8 bc c4 ff ff       	call   80101c50 <iput>

  end_op();
80105794:	e8 47 dd ff ff       	call   801034e0 <end_op>

  return 0;
80105799:	83 c4 10             	add    $0x10,%esp
8010579c:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
8010579e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057a1:	5b                   	pop    %ebx
801057a2:	5e                   	pop    %esi
801057a3:	5f                   	pop    %edi
801057a4:	5d                   	pop    %ebp
801057a5:	c3                   	ret    
801057a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057ad:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
801057b0:	83 ec 0c             	sub    $0xc,%esp
801057b3:	56                   	push   %esi
801057b4:	e8 07 c6 ff ff       	call   80101dc0 <iunlockput>
    goto bad;
801057b9:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801057bc:	83 ec 0c             	sub    $0xc,%esp
801057bf:	53                   	push   %ebx
801057c0:	e8 5b c3 ff ff       	call   80101b20 <ilock>
  ip->nlink--;
801057c5:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801057ca:	89 1c 24             	mov    %ebx,(%esp)
801057cd:	e8 8e c2 ff ff       	call   80101a60 <iupdate>
  iunlockput(ip);
801057d2:	89 1c 24             	mov    %ebx,(%esp)
801057d5:	e8 e6 c5 ff ff       	call   80101dc0 <iunlockput>
  end_op();
801057da:	e8 01 dd ff ff       	call   801034e0 <end_op>
  return -1;
801057df:	83 c4 10             	add    $0x10,%esp
801057e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057e7:	eb b5                	jmp    8010579e <sys_link+0xde>
    iunlockput(ip);
801057e9:	83 ec 0c             	sub    $0xc,%esp
801057ec:	53                   	push   %ebx
801057ed:	e8 ce c5 ff ff       	call   80101dc0 <iunlockput>
    end_op();
801057f2:	e8 e9 dc ff ff       	call   801034e0 <end_op>
    return -1;
801057f7:	83 c4 10             	add    $0x10,%esp
801057fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057ff:	eb 9d                	jmp    8010579e <sys_link+0xde>
    end_op();
80105801:	e8 da dc ff ff       	call   801034e0 <end_op>
    return -1;
80105806:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010580b:	eb 91                	jmp    8010579e <sys_link+0xde>
8010580d:	8d 76 00             	lea    0x0(%esi),%esi

80105810 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
80105810:	f3 0f 1e fb          	endbr32 
80105814:	55                   	push   %ebp
80105815:	89 e5                	mov    %esp,%ebp
80105817:	57                   	push   %edi
80105818:	56                   	push   %esi
80105819:	8d 7d d8             	lea    -0x28(%ebp),%edi
8010581c:	53                   	push   %ebx
8010581d:	bb 20 00 00 00       	mov    $0x20,%ebx
80105822:	83 ec 1c             	sub    $0x1c,%esp
80105825:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105828:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
8010582c:	77 0a                	ja     80105838 <isdirempty+0x28>
8010582e:	eb 30                	jmp    80105860 <isdirempty+0x50>
80105830:	83 c3 10             	add    $0x10,%ebx
80105833:	39 5e 58             	cmp    %ebx,0x58(%esi)
80105836:	76 28                	jbe    80105860 <isdirempty+0x50>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105838:	6a 10                	push   $0x10
8010583a:	53                   	push   %ebx
8010583b:	57                   	push   %edi
8010583c:	56                   	push   %esi
8010583d:	e8 de c5 ff ff       	call   80101e20 <readi>
80105842:	83 c4 10             	add    $0x10,%esp
80105845:	83 f8 10             	cmp    $0x10,%eax
80105848:	75 23                	jne    8010586d <isdirempty+0x5d>
      panic("isdirempty: readi");
    if(de.inum != 0)
8010584a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010584f:	74 df                	je     80105830 <isdirempty+0x20>
      return 0;
  }
  return 1;
}
80105851:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80105854:	31 c0                	xor    %eax,%eax
}
80105856:	5b                   	pop    %ebx
80105857:	5e                   	pop    %esi
80105858:	5f                   	pop    %edi
80105859:	5d                   	pop    %ebp
8010585a:	c3                   	ret    
8010585b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010585f:	90                   	nop
80105860:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 1;
80105863:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105868:	5b                   	pop    %ebx
80105869:	5e                   	pop    %esi
8010586a:	5f                   	pop    %edi
8010586b:	5d                   	pop    %ebp
8010586c:	c3                   	ret    
      panic("isdirempty: readi");
8010586d:	83 ec 0c             	sub    $0xc,%esp
80105870:	68 b8 87 10 80       	push   $0x801087b8
80105875:	e8 16 ab ff ff       	call   80100390 <panic>
8010587a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105880 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105880:	f3 0f 1e fb          	endbr32 
80105884:	55                   	push   %ebp
80105885:	89 e5                	mov    %esp,%ebp
80105887:	57                   	push   %edi
80105888:	56                   	push   %esi
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105889:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
8010588c:	53                   	push   %ebx
8010588d:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
80105890:	50                   	push   %eax
80105891:	6a 00                	push   $0x0
80105893:	e8 38 fb ff ff       	call   801053d0 <argstr>
80105898:	83 c4 10             	add    $0x10,%esp
8010589b:	85 c0                	test   %eax,%eax
8010589d:	0f 88 5d 01 00 00    	js     80105a00 <sys_unlink+0x180>
    return -1;

  begin_op();
801058a3:	e8 c8 db ff ff       	call   80103470 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801058a8:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801058ab:	83 ec 08             	sub    $0x8,%esp
801058ae:	53                   	push   %ebx
801058af:	ff 75 c0             	pushl  -0x40(%ebp)
801058b2:	e8 59 cb ff ff       	call   80102410 <nameiparent>
801058b7:	83 c4 10             	add    $0x10,%esp
801058ba:	89 c6                	mov    %eax,%esi
801058bc:	85 c0                	test   %eax,%eax
801058be:	0f 84 43 01 00 00    	je     80105a07 <sys_unlink+0x187>
    end_op();
    return -1;
  }

  ilock(dp);
801058c4:	83 ec 0c             	sub    $0xc,%esp
801058c7:	50                   	push   %eax
801058c8:	e8 53 c2 ff ff       	call   80101b20 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801058cd:	58                   	pop    %eax
801058ce:	5a                   	pop    %edx
801058cf:	68 dd 81 10 80       	push   $0x801081dd
801058d4:	53                   	push   %ebx
801058d5:	e8 76 c7 ff ff       	call   80102050 <namecmp>
801058da:	83 c4 10             	add    $0x10,%esp
801058dd:	85 c0                	test   %eax,%eax
801058df:	0f 84 db 00 00 00    	je     801059c0 <sys_unlink+0x140>
801058e5:	83 ec 08             	sub    $0x8,%esp
801058e8:	68 dc 81 10 80       	push   $0x801081dc
801058ed:	53                   	push   %ebx
801058ee:	e8 5d c7 ff ff       	call   80102050 <namecmp>
801058f3:	83 c4 10             	add    $0x10,%esp
801058f6:	85 c0                	test   %eax,%eax
801058f8:	0f 84 c2 00 00 00    	je     801059c0 <sys_unlink+0x140>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801058fe:	83 ec 04             	sub    $0x4,%esp
80105901:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105904:	50                   	push   %eax
80105905:	53                   	push   %ebx
80105906:	56                   	push   %esi
80105907:	e8 64 c7 ff ff       	call   80102070 <dirlookup>
8010590c:	83 c4 10             	add    $0x10,%esp
8010590f:	89 c3                	mov    %eax,%ebx
80105911:	85 c0                	test   %eax,%eax
80105913:	0f 84 a7 00 00 00    	je     801059c0 <sys_unlink+0x140>
    goto bad;
  ilock(ip);
80105919:	83 ec 0c             	sub    $0xc,%esp
8010591c:	50                   	push   %eax
8010591d:	e8 fe c1 ff ff       	call   80101b20 <ilock>

  if(ip->nlink < 1)
80105922:	83 c4 10             	add    $0x10,%esp
80105925:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010592a:	0f 8e f3 00 00 00    	jle    80105a23 <sys_unlink+0x1a3>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80105930:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105935:	74 69                	je     801059a0 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80105937:	83 ec 04             	sub    $0x4,%esp
8010593a:	8d 7d d8             	lea    -0x28(%ebp),%edi
8010593d:	6a 10                	push   $0x10
8010593f:	6a 00                	push   $0x0
80105941:	57                   	push   %edi
80105942:	e8 f9 f6 ff ff       	call   80105040 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105947:	6a 10                	push   $0x10
80105949:	ff 75 c4             	pushl  -0x3c(%ebp)
8010594c:	57                   	push   %edi
8010594d:	56                   	push   %esi
8010594e:	e8 cd c5 ff ff       	call   80101f20 <writei>
80105953:	83 c4 20             	add    $0x20,%esp
80105956:	83 f8 10             	cmp    $0x10,%eax
80105959:	0f 85 b7 00 00 00    	jne    80105a16 <sys_unlink+0x196>
    panic("unlink: writei");
  if(ip->type == T_DIR){
8010595f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105964:	74 7a                	je     801059e0 <sys_unlink+0x160>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80105966:	83 ec 0c             	sub    $0xc,%esp
80105969:	56                   	push   %esi
8010596a:	e8 51 c4 ff ff       	call   80101dc0 <iunlockput>

  ip->nlink--;
8010596f:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105974:	89 1c 24             	mov    %ebx,(%esp)
80105977:	e8 e4 c0 ff ff       	call   80101a60 <iupdate>
  iunlockput(ip);
8010597c:	89 1c 24             	mov    %ebx,(%esp)
8010597f:	e8 3c c4 ff ff       	call   80101dc0 <iunlockput>

  end_op();
80105984:	e8 57 db ff ff       	call   801034e0 <end_op>

  return 0;
80105989:	83 c4 10             	add    $0x10,%esp
8010598c:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
8010598e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105991:	5b                   	pop    %ebx
80105992:	5e                   	pop    %esi
80105993:	5f                   	pop    %edi
80105994:	5d                   	pop    %ebp
80105995:	c3                   	ret    
80105996:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010599d:	8d 76 00             	lea    0x0(%esi),%esi
  if(ip->type == T_DIR && !isdirempty(ip)){
801059a0:	83 ec 0c             	sub    $0xc,%esp
801059a3:	53                   	push   %ebx
801059a4:	e8 67 fe ff ff       	call   80105810 <isdirempty>
801059a9:	83 c4 10             	add    $0x10,%esp
801059ac:	85 c0                	test   %eax,%eax
801059ae:	75 87                	jne    80105937 <sys_unlink+0xb7>
    iunlockput(ip);
801059b0:	83 ec 0c             	sub    $0xc,%esp
801059b3:	53                   	push   %ebx
801059b4:	e8 07 c4 ff ff       	call   80101dc0 <iunlockput>
    goto bad;
801059b9:	83 c4 10             	add    $0x10,%esp
801059bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
801059c0:	83 ec 0c             	sub    $0xc,%esp
801059c3:	56                   	push   %esi
801059c4:	e8 f7 c3 ff ff       	call   80101dc0 <iunlockput>
  end_op();
801059c9:	e8 12 db ff ff       	call   801034e0 <end_op>
  return -1;
801059ce:	83 c4 10             	add    $0x10,%esp
801059d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059d6:	eb b6                	jmp    8010598e <sys_unlink+0x10e>
801059d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059df:	90                   	nop
    iupdate(dp);
801059e0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801059e3:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801059e8:	56                   	push   %esi
801059e9:	e8 72 c0 ff ff       	call   80101a60 <iupdate>
801059ee:	83 c4 10             	add    $0x10,%esp
801059f1:	e9 70 ff ff ff       	jmp    80105966 <sys_unlink+0xe6>
801059f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059fd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105a00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a05:	eb 87                	jmp    8010598e <sys_unlink+0x10e>
    end_op();
80105a07:	e8 d4 da ff ff       	call   801034e0 <end_op>
    return -1;
80105a0c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a11:	e9 78 ff ff ff       	jmp    8010598e <sys_unlink+0x10e>
    panic("unlink: writei");
80105a16:	83 ec 0c             	sub    $0xc,%esp
80105a19:	68 f1 81 10 80       	push   $0x801081f1
80105a1e:	e8 6d a9 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105a23:	83 ec 0c             	sub    $0xc,%esp
80105a26:	68 df 81 10 80       	push   $0x801081df
80105a2b:	e8 60 a9 ff ff       	call   80100390 <panic>

80105a30 <create>:

struct inode*
create(char *path, short type, short major, short minor)
{
80105a30:	f3 0f 1e fb          	endbr32 
80105a34:	55                   	push   %ebp
80105a35:	89 e5                	mov    %esp,%ebp
80105a37:	57                   	push   %edi
80105a38:	56                   	push   %esi
80105a39:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105a3a:	8d 5d da             	lea    -0x26(%ebp),%ebx
{
80105a3d:	83 ec 34             	sub    $0x34,%esp
80105a40:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a43:	8b 55 10             	mov    0x10(%ebp),%edx
  if((dp = nameiparent(path, name)) == 0)
80105a46:	53                   	push   %ebx
{
80105a47:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105a4a:	ff 75 08             	pushl  0x8(%ebp)
{
80105a4d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80105a50:	89 55 d0             	mov    %edx,-0x30(%ebp)
80105a53:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105a56:	e8 b5 c9 ff ff       	call   80102410 <nameiparent>
80105a5b:	83 c4 10             	add    $0x10,%esp
80105a5e:	85 c0                	test   %eax,%eax
80105a60:	0f 84 3a 01 00 00    	je     80105ba0 <create+0x170>
    return 0;
  ilock(dp);
80105a66:	83 ec 0c             	sub    $0xc,%esp
80105a69:	89 c6                	mov    %eax,%esi
80105a6b:	50                   	push   %eax
80105a6c:	e8 af c0 ff ff       	call   80101b20 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105a71:	83 c4 0c             	add    $0xc,%esp
80105a74:	6a 00                	push   $0x0
80105a76:	53                   	push   %ebx
80105a77:	56                   	push   %esi
80105a78:	e8 f3 c5 ff ff       	call   80102070 <dirlookup>
80105a7d:	83 c4 10             	add    $0x10,%esp
80105a80:	89 c7                	mov    %eax,%edi
80105a82:	85 c0                	test   %eax,%eax
80105a84:	74 4a                	je     80105ad0 <create+0xa0>
    iunlockput(dp);
80105a86:	83 ec 0c             	sub    $0xc,%esp
80105a89:	56                   	push   %esi
80105a8a:	e8 31 c3 ff ff       	call   80101dc0 <iunlockput>
    ilock(ip);
80105a8f:	89 3c 24             	mov    %edi,(%esp)
80105a92:	e8 89 c0 ff ff       	call   80101b20 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105a97:	83 c4 10             	add    $0x10,%esp
80105a9a:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105a9f:	75 17                	jne    80105ab8 <create+0x88>
80105aa1:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80105aa6:	75 10                	jne    80105ab8 <create+0x88>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105aa8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105aab:	89 f8                	mov    %edi,%eax
80105aad:	5b                   	pop    %ebx
80105aae:	5e                   	pop    %esi
80105aaf:	5f                   	pop    %edi
80105ab0:	5d                   	pop    %ebp
80105ab1:	c3                   	ret    
80105ab2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105ab8:	83 ec 0c             	sub    $0xc,%esp
80105abb:	57                   	push   %edi
    return 0;
80105abc:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105abe:	e8 fd c2 ff ff       	call   80101dc0 <iunlockput>
    return 0;
80105ac3:	83 c4 10             	add    $0x10,%esp
}
80105ac6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ac9:	89 f8                	mov    %edi,%eax
80105acb:	5b                   	pop    %ebx
80105acc:	5e                   	pop    %esi
80105acd:	5f                   	pop    %edi
80105ace:	5d                   	pop    %ebp
80105acf:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80105ad0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105ad4:	83 ec 08             	sub    $0x8,%esp
80105ad7:	50                   	push   %eax
80105ad8:	ff 36                	pushl  (%esi)
80105ada:	e8 c1 be ff ff       	call   801019a0 <ialloc>
80105adf:	83 c4 10             	add    $0x10,%esp
80105ae2:	89 c7                	mov    %eax,%edi
80105ae4:	85 c0                	test   %eax,%eax
80105ae6:	0f 84 cd 00 00 00    	je     80105bb9 <create+0x189>
  ilock(ip);
80105aec:	83 ec 0c             	sub    $0xc,%esp
80105aef:	50                   	push   %eax
80105af0:	e8 2b c0 ff ff       	call   80101b20 <ilock>
  ip->major = major;
80105af5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105af9:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80105afd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105b01:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105b05:	b8 01 00 00 00       	mov    $0x1,%eax
80105b0a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80105b0e:	89 3c 24             	mov    %edi,(%esp)
80105b11:	e8 4a bf ff ff       	call   80101a60 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105b16:	83 c4 10             	add    $0x10,%esp
80105b19:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105b1e:	74 30                	je     80105b50 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105b20:	83 ec 04             	sub    $0x4,%esp
80105b23:	ff 77 04             	pushl  0x4(%edi)
80105b26:	53                   	push   %ebx
80105b27:	56                   	push   %esi
80105b28:	e8 03 c8 ff ff       	call   80102330 <dirlink>
80105b2d:	83 c4 10             	add    $0x10,%esp
80105b30:	85 c0                	test   %eax,%eax
80105b32:	78 78                	js     80105bac <create+0x17c>
  iunlockput(dp);
80105b34:	83 ec 0c             	sub    $0xc,%esp
80105b37:	56                   	push   %esi
80105b38:	e8 83 c2 ff ff       	call   80101dc0 <iunlockput>
  return ip;
80105b3d:	83 c4 10             	add    $0x10,%esp
}
80105b40:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b43:	89 f8                	mov    %edi,%eax
80105b45:	5b                   	pop    %ebx
80105b46:	5e                   	pop    %esi
80105b47:	5f                   	pop    %edi
80105b48:	5d                   	pop    %ebp
80105b49:	c3                   	ret    
80105b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105b50:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105b53:	66 83 46 56 01       	addw   $0x1,0x56(%esi)
    iupdate(dp);
80105b58:	56                   	push   %esi
80105b59:	e8 02 bf ff ff       	call   80101a60 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105b5e:	83 c4 0c             	add    $0xc,%esp
80105b61:	ff 77 04             	pushl  0x4(%edi)
80105b64:	68 dd 81 10 80       	push   $0x801081dd
80105b69:	57                   	push   %edi
80105b6a:	e8 c1 c7 ff ff       	call   80102330 <dirlink>
80105b6f:	83 c4 10             	add    $0x10,%esp
80105b72:	85 c0                	test   %eax,%eax
80105b74:	78 18                	js     80105b8e <create+0x15e>
80105b76:	83 ec 04             	sub    $0x4,%esp
80105b79:	ff 76 04             	pushl  0x4(%esi)
80105b7c:	68 dc 81 10 80       	push   $0x801081dc
80105b81:	57                   	push   %edi
80105b82:	e8 a9 c7 ff ff       	call   80102330 <dirlink>
80105b87:	83 c4 10             	add    $0x10,%esp
80105b8a:	85 c0                	test   %eax,%eax
80105b8c:	79 92                	jns    80105b20 <create+0xf0>
      panic("create dots");
80105b8e:	83 ec 0c             	sub    $0xc,%esp
80105b91:	68 d9 87 10 80       	push   $0x801087d9
80105b96:	e8 f5 a7 ff ff       	call   80100390 <panic>
80105b9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b9f:	90                   	nop
}
80105ba0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105ba3:	31 ff                	xor    %edi,%edi
}
80105ba5:	5b                   	pop    %ebx
80105ba6:	89 f8                	mov    %edi,%eax
80105ba8:	5e                   	pop    %esi
80105ba9:	5f                   	pop    %edi
80105baa:	5d                   	pop    %ebp
80105bab:	c3                   	ret    
    panic("create: dirlink");
80105bac:	83 ec 0c             	sub    $0xc,%esp
80105baf:	68 e5 87 10 80       	push   $0x801087e5
80105bb4:	e8 d7 a7 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105bb9:	83 ec 0c             	sub    $0xc,%esp
80105bbc:	68 ca 87 10 80       	push   $0x801087ca
80105bc1:	e8 ca a7 ff ff       	call   80100390 <panic>
80105bc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bcd:	8d 76 00             	lea    0x0(%esi),%esi

80105bd0 <sys_open>:

int
sys_open(void)
{
80105bd0:	f3 0f 1e fb          	endbr32 
80105bd4:	55                   	push   %ebp
80105bd5:	89 e5                	mov    %esp,%ebp
80105bd7:	57                   	push   %edi
80105bd8:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105bd9:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105bdc:	53                   	push   %ebx
80105bdd:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105be0:	50                   	push   %eax
80105be1:	6a 00                	push   $0x0
80105be3:	e8 e8 f7 ff ff       	call   801053d0 <argstr>
80105be8:	83 c4 10             	add    $0x10,%esp
80105beb:	85 c0                	test   %eax,%eax
80105bed:	0f 88 8a 00 00 00    	js     80105c7d <sys_open+0xad>
80105bf3:	83 ec 08             	sub    $0x8,%esp
80105bf6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105bf9:	50                   	push   %eax
80105bfa:	6a 01                	push   $0x1
80105bfc:	e8 1f f7 ff ff       	call   80105320 <argint>
80105c01:	83 c4 10             	add    $0x10,%esp
80105c04:	85 c0                	test   %eax,%eax
80105c06:	78 75                	js     80105c7d <sys_open+0xad>
    return -1;

  begin_op();
80105c08:	e8 63 d8 ff ff       	call   80103470 <begin_op>

  if(omode & O_CREATE){
80105c0d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105c11:	75 75                	jne    80105c88 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105c13:	83 ec 0c             	sub    $0xc,%esp
80105c16:	ff 75 e0             	pushl  -0x20(%ebp)
80105c19:	e8 d2 c7 ff ff       	call   801023f0 <namei>
80105c1e:	83 c4 10             	add    $0x10,%esp
80105c21:	89 c6                	mov    %eax,%esi
80105c23:	85 c0                	test   %eax,%eax
80105c25:	74 78                	je     80105c9f <sys_open+0xcf>
      end_op();
      return -1;
    }
    ilock(ip);
80105c27:	83 ec 0c             	sub    $0xc,%esp
80105c2a:	50                   	push   %eax
80105c2b:	e8 f0 be ff ff       	call   80101b20 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105c30:	83 c4 10             	add    $0x10,%esp
80105c33:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105c38:	0f 84 ba 00 00 00    	je     80105cf8 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105c3e:	e8 7d b5 ff ff       	call   801011c0 <filealloc>
80105c43:	89 c7                	mov    %eax,%edi
80105c45:	85 c0                	test   %eax,%eax
80105c47:	74 23                	je     80105c6c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105c49:	e8 c2 e4 ff ff       	call   80104110 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105c4e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105c50:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105c54:	85 d2                	test   %edx,%edx
80105c56:	74 58                	je     80105cb0 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
80105c58:	83 c3 01             	add    $0x1,%ebx
80105c5b:	83 fb 10             	cmp    $0x10,%ebx
80105c5e:	75 f0                	jne    80105c50 <sys_open+0x80>
    if(f)
      fileclose(f);
80105c60:	83 ec 0c             	sub    $0xc,%esp
80105c63:	57                   	push   %edi
80105c64:	e8 17 b6 ff ff       	call   80101280 <fileclose>
80105c69:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105c6c:	83 ec 0c             	sub    $0xc,%esp
80105c6f:	56                   	push   %esi
80105c70:	e8 4b c1 ff ff       	call   80101dc0 <iunlockput>
    end_op();
80105c75:	e8 66 d8 ff ff       	call   801034e0 <end_op>
    return -1;
80105c7a:	83 c4 10             	add    $0x10,%esp
80105c7d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105c82:	eb 65                	jmp    80105ce9 <sys_open+0x119>
80105c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105c88:	6a 00                	push   $0x0
80105c8a:	6a 00                	push   $0x0
80105c8c:	6a 02                	push   $0x2
80105c8e:	ff 75 e0             	pushl  -0x20(%ebp)
80105c91:	e8 9a fd ff ff       	call   80105a30 <create>
    if(ip == 0){
80105c96:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105c99:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105c9b:	85 c0                	test   %eax,%eax
80105c9d:	75 9f                	jne    80105c3e <sys_open+0x6e>
      end_op();
80105c9f:	e8 3c d8 ff ff       	call   801034e0 <end_op>
      return -1;
80105ca4:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105ca9:	eb 3e                	jmp    80105ce9 <sys_open+0x119>
80105cab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105caf:	90                   	nop
  }
  iunlock(ip);
80105cb0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105cb3:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105cb7:	56                   	push   %esi
80105cb8:	e8 43 bf ff ff       	call   80101c00 <iunlock>
  end_op();
80105cbd:	e8 1e d8 ff ff       	call   801034e0 <end_op>

  f->type = FD_INODE;
80105cc2:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105cc8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105ccb:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105cce:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105cd1:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105cd3:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105cda:	f7 d0                	not    %eax
80105cdc:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105cdf:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105ce2:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105ce5:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105ce9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cec:	89 d8                	mov    %ebx,%eax
80105cee:	5b                   	pop    %ebx
80105cef:	5e                   	pop    %esi
80105cf0:	5f                   	pop    %edi
80105cf1:	5d                   	pop    %ebp
80105cf2:	c3                   	ret    
80105cf3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105cf7:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105cf8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105cfb:	85 c9                	test   %ecx,%ecx
80105cfd:	0f 84 3b ff ff ff    	je     80105c3e <sys_open+0x6e>
80105d03:	e9 64 ff ff ff       	jmp    80105c6c <sys_open+0x9c>
80105d08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d0f:	90                   	nop

80105d10 <sys_mkdir>:

int
sys_mkdir(void)
{
80105d10:	f3 0f 1e fb          	endbr32 
80105d14:	55                   	push   %ebp
80105d15:	89 e5                	mov    %esp,%ebp
80105d17:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105d1a:	e8 51 d7 ff ff       	call   80103470 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105d1f:	83 ec 08             	sub    $0x8,%esp
80105d22:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d25:	50                   	push   %eax
80105d26:	6a 00                	push   $0x0
80105d28:	e8 a3 f6 ff ff       	call   801053d0 <argstr>
80105d2d:	83 c4 10             	add    $0x10,%esp
80105d30:	85 c0                	test   %eax,%eax
80105d32:	78 2c                	js     80105d60 <sys_mkdir+0x50>
80105d34:	6a 00                	push   $0x0
80105d36:	6a 00                	push   $0x0
80105d38:	6a 01                	push   $0x1
80105d3a:	ff 75 f4             	pushl  -0xc(%ebp)
80105d3d:	e8 ee fc ff ff       	call   80105a30 <create>
80105d42:	83 c4 10             	add    $0x10,%esp
80105d45:	85 c0                	test   %eax,%eax
80105d47:	74 17                	je     80105d60 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105d49:	83 ec 0c             	sub    $0xc,%esp
80105d4c:	50                   	push   %eax
80105d4d:	e8 6e c0 ff ff       	call   80101dc0 <iunlockput>
  end_op();
80105d52:	e8 89 d7 ff ff       	call   801034e0 <end_op>
  return 0;
80105d57:	83 c4 10             	add    $0x10,%esp
80105d5a:	31 c0                	xor    %eax,%eax
}
80105d5c:	c9                   	leave  
80105d5d:	c3                   	ret    
80105d5e:	66 90                	xchg   %ax,%ax
    end_op();
80105d60:	e8 7b d7 ff ff       	call   801034e0 <end_op>
    return -1;
80105d65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d6a:	c9                   	leave  
80105d6b:	c3                   	ret    
80105d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d70 <sys_mknod>:

int
sys_mknod(void)
{
80105d70:	f3 0f 1e fb          	endbr32 
80105d74:	55                   	push   %ebp
80105d75:	89 e5                	mov    %esp,%ebp
80105d77:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105d7a:	e8 f1 d6 ff ff       	call   80103470 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105d7f:	83 ec 08             	sub    $0x8,%esp
80105d82:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105d85:	50                   	push   %eax
80105d86:	6a 00                	push   $0x0
80105d88:	e8 43 f6 ff ff       	call   801053d0 <argstr>
80105d8d:	83 c4 10             	add    $0x10,%esp
80105d90:	85 c0                	test   %eax,%eax
80105d92:	78 5c                	js     80105df0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105d94:	83 ec 08             	sub    $0x8,%esp
80105d97:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d9a:	50                   	push   %eax
80105d9b:	6a 01                	push   $0x1
80105d9d:	e8 7e f5 ff ff       	call   80105320 <argint>
  if((argstr(0, &path)) < 0 ||
80105da2:	83 c4 10             	add    $0x10,%esp
80105da5:	85 c0                	test   %eax,%eax
80105da7:	78 47                	js     80105df0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105da9:	83 ec 08             	sub    $0x8,%esp
80105dac:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105daf:	50                   	push   %eax
80105db0:	6a 02                	push   $0x2
80105db2:	e8 69 f5 ff ff       	call   80105320 <argint>
     argint(1, &major) < 0 ||
80105db7:	83 c4 10             	add    $0x10,%esp
80105dba:	85 c0                	test   %eax,%eax
80105dbc:	78 32                	js     80105df0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105dbe:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105dc2:	50                   	push   %eax
80105dc3:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
80105dc7:	50                   	push   %eax
80105dc8:	6a 03                	push   $0x3
80105dca:	ff 75 ec             	pushl  -0x14(%ebp)
80105dcd:	e8 5e fc ff ff       	call   80105a30 <create>
     argint(2, &minor) < 0 ||
80105dd2:	83 c4 10             	add    $0x10,%esp
80105dd5:	85 c0                	test   %eax,%eax
80105dd7:	74 17                	je     80105df0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105dd9:	83 ec 0c             	sub    $0xc,%esp
80105ddc:	50                   	push   %eax
80105ddd:	e8 de bf ff ff       	call   80101dc0 <iunlockput>
  end_op();
80105de2:	e8 f9 d6 ff ff       	call   801034e0 <end_op>
  return 0;
80105de7:	83 c4 10             	add    $0x10,%esp
80105dea:	31 c0                	xor    %eax,%eax
}
80105dec:	c9                   	leave  
80105ded:	c3                   	ret    
80105dee:	66 90                	xchg   %ax,%ax
    end_op();
80105df0:	e8 eb d6 ff ff       	call   801034e0 <end_op>
    return -1;
80105df5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105dfa:	c9                   	leave  
80105dfb:	c3                   	ret    
80105dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e00 <sys_chdir>:

int
sys_chdir(void)
{
80105e00:	f3 0f 1e fb          	endbr32 
80105e04:	55                   	push   %ebp
80105e05:	89 e5                	mov    %esp,%ebp
80105e07:	56                   	push   %esi
80105e08:	53                   	push   %ebx
80105e09:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105e0c:	e8 ff e2 ff ff       	call   80104110 <myproc>
80105e11:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105e13:	e8 58 d6 ff ff       	call   80103470 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105e18:	83 ec 08             	sub    $0x8,%esp
80105e1b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e1e:	50                   	push   %eax
80105e1f:	6a 00                	push   $0x0
80105e21:	e8 aa f5 ff ff       	call   801053d0 <argstr>
80105e26:	83 c4 10             	add    $0x10,%esp
80105e29:	85 c0                	test   %eax,%eax
80105e2b:	78 73                	js     80105ea0 <sys_chdir+0xa0>
80105e2d:	83 ec 0c             	sub    $0xc,%esp
80105e30:	ff 75 f4             	pushl  -0xc(%ebp)
80105e33:	e8 b8 c5 ff ff       	call   801023f0 <namei>
80105e38:	83 c4 10             	add    $0x10,%esp
80105e3b:	89 c3                	mov    %eax,%ebx
80105e3d:	85 c0                	test   %eax,%eax
80105e3f:	74 5f                	je     80105ea0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105e41:	83 ec 0c             	sub    $0xc,%esp
80105e44:	50                   	push   %eax
80105e45:	e8 d6 bc ff ff       	call   80101b20 <ilock>
  if(ip->type != T_DIR){
80105e4a:	83 c4 10             	add    $0x10,%esp
80105e4d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105e52:	75 2c                	jne    80105e80 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105e54:	83 ec 0c             	sub    $0xc,%esp
80105e57:	53                   	push   %ebx
80105e58:	e8 a3 bd ff ff       	call   80101c00 <iunlock>
  iput(curproc->cwd);
80105e5d:	58                   	pop    %eax
80105e5e:	ff 76 68             	pushl  0x68(%esi)
80105e61:	e8 ea bd ff ff       	call   80101c50 <iput>
  end_op();
80105e66:	e8 75 d6 ff ff       	call   801034e0 <end_op>
  curproc->cwd = ip;
80105e6b:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105e6e:	83 c4 10             	add    $0x10,%esp
80105e71:	31 c0                	xor    %eax,%eax
}
80105e73:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105e76:	5b                   	pop    %ebx
80105e77:	5e                   	pop    %esi
80105e78:	5d                   	pop    %ebp
80105e79:	c3                   	ret    
80105e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105e80:	83 ec 0c             	sub    $0xc,%esp
80105e83:	53                   	push   %ebx
80105e84:	e8 37 bf ff ff       	call   80101dc0 <iunlockput>
    end_op();
80105e89:	e8 52 d6 ff ff       	call   801034e0 <end_op>
    return -1;
80105e8e:	83 c4 10             	add    $0x10,%esp
80105e91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e96:	eb db                	jmp    80105e73 <sys_chdir+0x73>
80105e98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e9f:	90                   	nop
    end_op();
80105ea0:	e8 3b d6 ff ff       	call   801034e0 <end_op>
    return -1;
80105ea5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105eaa:	eb c7                	jmp    80105e73 <sys_chdir+0x73>
80105eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105eb0 <sys_exec>:

int
sys_exec(void)
{
80105eb0:	f3 0f 1e fb          	endbr32 
80105eb4:	55                   	push   %ebp
80105eb5:	89 e5                	mov    %esp,%ebp
80105eb7:	57                   	push   %edi
80105eb8:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105eb9:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105ebf:	53                   	push   %ebx
80105ec0:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105ec6:	50                   	push   %eax
80105ec7:	6a 00                	push   $0x0
80105ec9:	e8 02 f5 ff ff       	call   801053d0 <argstr>
80105ece:	83 c4 10             	add    $0x10,%esp
80105ed1:	85 c0                	test   %eax,%eax
80105ed3:	0f 88 8b 00 00 00    	js     80105f64 <sys_exec+0xb4>
80105ed9:	83 ec 08             	sub    $0x8,%esp
80105edc:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105ee2:	50                   	push   %eax
80105ee3:	6a 01                	push   $0x1
80105ee5:	e8 36 f4 ff ff       	call   80105320 <argint>
80105eea:	83 c4 10             	add    $0x10,%esp
80105eed:	85 c0                	test   %eax,%eax
80105eef:	78 73                	js     80105f64 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105ef1:	83 ec 04             	sub    $0x4,%esp
80105ef4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
80105efa:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105efc:	68 80 00 00 00       	push   $0x80
80105f01:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105f07:	6a 00                	push   $0x0
80105f09:	50                   	push   %eax
80105f0a:	e8 31 f1 ff ff       	call   80105040 <memset>
80105f0f:	83 c4 10             	add    $0x10,%esp
80105f12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105f18:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105f1e:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105f25:	83 ec 08             	sub    $0x8,%esp
80105f28:	57                   	push   %edi
80105f29:	01 f0                	add    %esi,%eax
80105f2b:	50                   	push   %eax
80105f2c:	e8 4f f3 ff ff       	call   80105280 <fetchint>
80105f31:	83 c4 10             	add    $0x10,%esp
80105f34:	85 c0                	test   %eax,%eax
80105f36:	78 2c                	js     80105f64 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80105f38:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105f3e:	85 c0                	test   %eax,%eax
80105f40:	74 36                	je     80105f78 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105f42:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105f48:	83 ec 08             	sub    $0x8,%esp
80105f4b:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105f4e:	52                   	push   %edx
80105f4f:	50                   	push   %eax
80105f50:	e8 6b f3 ff ff       	call   801052c0 <fetchstr>
80105f55:	83 c4 10             	add    $0x10,%esp
80105f58:	85 c0                	test   %eax,%eax
80105f5a:	78 08                	js     80105f64 <sys_exec+0xb4>
  for(i=0;; i++){
80105f5c:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105f5f:	83 fb 20             	cmp    $0x20,%ebx
80105f62:	75 b4                	jne    80105f18 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80105f64:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105f67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f6c:	5b                   	pop    %ebx
80105f6d:	5e                   	pop    %esi
80105f6e:	5f                   	pop    %edi
80105f6f:	5d                   	pop    %ebp
80105f70:	c3                   	ret    
80105f71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105f78:	83 ec 08             	sub    $0x8,%esp
80105f7b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105f81:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105f88:	00 00 00 00 
  return exec(path, argv);
80105f8c:	50                   	push   %eax
80105f8d:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105f93:	e8 78 ab ff ff       	call   80100b10 <exec>
80105f98:	83 c4 10             	add    $0x10,%esp
}
80105f9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f9e:	5b                   	pop    %ebx
80105f9f:	5e                   	pop    %esi
80105fa0:	5f                   	pop    %edi
80105fa1:	5d                   	pop    %ebp
80105fa2:	c3                   	ret    
80105fa3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105fb0 <sys_pipe>:

int
sys_pipe(void)
{
80105fb0:	f3 0f 1e fb          	endbr32 
80105fb4:	55                   	push   %ebp
80105fb5:	89 e5                	mov    %esp,%ebp
80105fb7:	57                   	push   %edi
80105fb8:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105fb9:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105fbc:	53                   	push   %ebx
80105fbd:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105fc0:	6a 08                	push   $0x8
80105fc2:	50                   	push   %eax
80105fc3:	6a 00                	push   $0x0
80105fc5:	e8 a6 f3 ff ff       	call   80105370 <argptr>
80105fca:	83 c4 10             	add    $0x10,%esp
80105fcd:	85 c0                	test   %eax,%eax
80105fcf:	78 4e                	js     8010601f <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105fd1:	83 ec 08             	sub    $0x8,%esp
80105fd4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105fd7:	50                   	push   %eax
80105fd8:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105fdb:	50                   	push   %eax
80105fdc:	e8 4f db ff ff       	call   80103b30 <pipealloc>
80105fe1:	83 c4 10             	add    $0x10,%esp
80105fe4:	85 c0                	test   %eax,%eax
80105fe6:	78 37                	js     8010601f <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105fe8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105feb:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105fed:	e8 1e e1 ff ff       	call   80104110 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105ff2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105ff8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105ffc:	85 f6                	test   %esi,%esi
80105ffe:	74 30                	je     80106030 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80106000:	83 c3 01             	add    $0x1,%ebx
80106003:	83 fb 10             	cmp    $0x10,%ebx
80106006:	75 f0                	jne    80105ff8 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80106008:	83 ec 0c             	sub    $0xc,%esp
8010600b:	ff 75 e0             	pushl  -0x20(%ebp)
8010600e:	e8 6d b2 ff ff       	call   80101280 <fileclose>
    fileclose(wf);
80106013:	58                   	pop    %eax
80106014:	ff 75 e4             	pushl  -0x1c(%ebp)
80106017:	e8 64 b2 ff ff       	call   80101280 <fileclose>
    return -1;
8010601c:	83 c4 10             	add    $0x10,%esp
8010601f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106024:	eb 5b                	jmp    80106081 <sys_pipe+0xd1>
80106026:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010602d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80106030:	8d 73 08             	lea    0x8(%ebx),%esi
80106033:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106037:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010603a:	e8 d1 e0 ff ff       	call   80104110 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010603f:	31 d2                	xor    %edx,%edx
80106041:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80106048:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010604c:	85 c9                	test   %ecx,%ecx
8010604e:	74 20                	je     80106070 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80106050:	83 c2 01             	add    $0x1,%edx
80106053:	83 fa 10             	cmp    $0x10,%edx
80106056:	75 f0                	jne    80106048 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80106058:	e8 b3 e0 ff ff       	call   80104110 <myproc>
8010605d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80106064:	00 
80106065:	eb a1                	jmp    80106008 <sys_pipe+0x58>
80106067:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010606e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80106070:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80106074:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106077:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106079:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010607c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010607f:	31 c0                	xor    %eax,%eax
}
80106081:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106084:	5b                   	pop    %ebx
80106085:	5e                   	pop    %esi
80106086:	5f                   	pop    %edi
80106087:	5d                   	pop    %ebp
80106088:	c3                   	ret    
80106089:	66 90                	xchg   %ax,%ax
8010608b:	66 90                	xchg   %ax,%ax
8010608d:	66 90                	xchg   %ax,%ax
8010608f:	90                   	nop

80106090 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80106090:	f3 0f 1e fb          	endbr32 
  return fork();
80106094:	e9 27 e2 ff ff       	jmp    801042c0 <fork>
80106099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801060a0 <sys_exit>:
}

int
sys_exit(void)
{
801060a0:	f3 0f 1e fb          	endbr32 
801060a4:	55                   	push   %ebp
801060a5:	89 e5                	mov    %esp,%ebp
801060a7:	83 ec 08             	sub    $0x8,%esp
  exit();
801060aa:	e8 f1 e5 ff ff       	call   801046a0 <exit>
  return 0;  // not reached
}
801060af:	31 c0                	xor    %eax,%eax
801060b1:	c9                   	leave  
801060b2:	c3                   	ret    
801060b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801060c0 <sys_wait>:

int
sys_wait(void)
{
801060c0:	f3 0f 1e fb          	endbr32 
  return wait();
801060c4:	e9 27 e8 ff ff       	jmp    801048f0 <wait>
801060c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801060d0 <sys_kill>:
}

int
sys_kill(void)
{
801060d0:	f3 0f 1e fb          	endbr32 
801060d4:	55                   	push   %ebp
801060d5:	89 e5                	mov    %esp,%ebp
801060d7:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801060da:	8d 45 f4             	lea    -0xc(%ebp),%eax
801060dd:	50                   	push   %eax
801060de:	6a 00                	push   $0x0
801060e0:	e8 3b f2 ff ff       	call   80105320 <argint>
801060e5:	83 c4 10             	add    $0x10,%esp
801060e8:	85 c0                	test   %eax,%eax
801060ea:	78 14                	js     80106100 <sys_kill+0x30>
    return -1;
  return kill(pid);
801060ec:	83 ec 0c             	sub    $0xc,%esp
801060ef:	ff 75 f4             	pushl  -0xc(%ebp)
801060f2:	e8 09 ea ff ff       	call   80104b00 <kill>
801060f7:	83 c4 10             	add    $0x10,%esp
}
801060fa:	c9                   	leave  
801060fb:	c3                   	ret    
801060fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106100:	c9                   	leave  
    return -1;
80106101:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106106:	c3                   	ret    
80106107:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010610e:	66 90                	xchg   %ax,%ax

80106110 <sys_getpid>:

int
sys_getpid(void)
{
80106110:	f3 0f 1e fb          	endbr32 
80106114:	55                   	push   %ebp
80106115:	89 e5                	mov    %esp,%ebp
80106117:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
8010611a:	e8 f1 df ff ff       	call   80104110 <myproc>
8010611f:	8b 40 10             	mov    0x10(%eax),%eax
}
80106122:	c9                   	leave  
80106123:	c3                   	ret    
80106124:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010612b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010612f:	90                   	nop

80106130 <sys_sbrk>:

int
sys_sbrk(void)
{
80106130:	f3 0f 1e fb          	endbr32 
80106134:	55                   	push   %ebp
80106135:	89 e5                	mov    %esp,%ebp
80106137:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106138:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010613b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010613e:	50                   	push   %eax
8010613f:	6a 00                	push   $0x0
80106141:	e8 da f1 ff ff       	call   80105320 <argint>
80106146:	83 c4 10             	add    $0x10,%esp
80106149:	85 c0                	test   %eax,%eax
8010614b:	78 23                	js     80106170 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
8010614d:	e8 be df ff ff       	call   80104110 <myproc>
  if(growproc(n) < 0)
80106152:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106155:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106157:	ff 75 f4             	pushl  -0xc(%ebp)
8010615a:	e8 e1 e0 ff ff       	call   80104240 <growproc>
8010615f:	83 c4 10             	add    $0x10,%esp
80106162:	85 c0                	test   %eax,%eax
80106164:	78 0a                	js     80106170 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106166:	89 d8                	mov    %ebx,%eax
80106168:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010616b:	c9                   	leave  
8010616c:	c3                   	ret    
8010616d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106170:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106175:	eb ef                	jmp    80106166 <sys_sbrk+0x36>
80106177:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010617e:	66 90                	xchg   %ax,%ax

80106180 <sys_sleep>:

int
sys_sleep(void)
{
80106180:	f3 0f 1e fb          	endbr32 
80106184:	55                   	push   %ebp
80106185:	89 e5                	mov    %esp,%ebp
80106187:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106188:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010618b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010618e:	50                   	push   %eax
8010618f:	6a 00                	push   $0x0
80106191:	e8 8a f1 ff ff       	call   80105320 <argint>
80106196:	83 c4 10             	add    $0x10,%esp
80106199:	85 c0                	test   %eax,%eax
8010619b:	0f 88 86 00 00 00    	js     80106227 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801061a1:	83 ec 0c             	sub    $0xc,%esp
801061a4:	68 80 21 12 80       	push   $0x80122180
801061a9:	e8 82 ed ff ff       	call   80104f30 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801061ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801061b1:	8b 1d c0 29 12 80    	mov    0x801229c0,%ebx
  while(ticks - ticks0 < n){
801061b7:	83 c4 10             	add    $0x10,%esp
801061ba:	85 d2                	test   %edx,%edx
801061bc:	75 23                	jne    801061e1 <sys_sleep+0x61>
801061be:	eb 50                	jmp    80106210 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801061c0:	83 ec 08             	sub    $0x8,%esp
801061c3:	68 80 21 12 80       	push   $0x80122180
801061c8:	68 c0 29 12 80       	push   $0x801229c0
801061cd:	e8 5e e6 ff ff       	call   80104830 <sleep>
  while(ticks - ticks0 < n){
801061d2:	a1 c0 29 12 80       	mov    0x801229c0,%eax
801061d7:	83 c4 10             	add    $0x10,%esp
801061da:	29 d8                	sub    %ebx,%eax
801061dc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801061df:	73 2f                	jae    80106210 <sys_sleep+0x90>
    if(myproc()->killed){
801061e1:	e8 2a df ff ff       	call   80104110 <myproc>
801061e6:	8b 40 24             	mov    0x24(%eax),%eax
801061e9:	85 c0                	test   %eax,%eax
801061eb:	74 d3                	je     801061c0 <sys_sleep+0x40>
      release(&tickslock);
801061ed:	83 ec 0c             	sub    $0xc,%esp
801061f0:	68 80 21 12 80       	push   $0x80122180
801061f5:	e8 f6 ed ff ff       	call   80104ff0 <release>
  }
  release(&tickslock);
  return 0;
}
801061fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
801061fd:	83 c4 10             	add    $0x10,%esp
80106200:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106205:	c9                   	leave  
80106206:	c3                   	ret    
80106207:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010620e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80106210:	83 ec 0c             	sub    $0xc,%esp
80106213:	68 80 21 12 80       	push   $0x80122180
80106218:	e8 d3 ed ff ff       	call   80104ff0 <release>
  return 0;
8010621d:	83 c4 10             	add    $0x10,%esp
80106220:	31 c0                	xor    %eax,%eax
}
80106222:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106225:	c9                   	leave  
80106226:	c3                   	ret    
    return -1;
80106227:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010622c:	eb f4                	jmp    80106222 <sys_sleep+0xa2>
8010622e:	66 90                	xchg   %ax,%ax

80106230 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106230:	f3 0f 1e fb          	endbr32 
80106234:	55                   	push   %ebp
80106235:	89 e5                	mov    %esp,%ebp
80106237:	53                   	push   %ebx
80106238:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
8010623b:	68 80 21 12 80       	push   $0x80122180
80106240:	e8 eb ec ff ff       	call   80104f30 <acquire>
  xticks = ticks;
80106245:	8b 1d c0 29 12 80    	mov    0x801229c0,%ebx
  release(&tickslock);
8010624b:	c7 04 24 80 21 12 80 	movl   $0x80122180,(%esp)
80106252:	e8 99 ed ff ff       	call   80104ff0 <release>
  return xticks;
}
80106257:	89 d8                	mov    %ebx,%eax
80106259:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010625c:	c9                   	leave  
8010625d:	c3                   	ret    

8010625e <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010625e:	1e                   	push   %ds
  pushl %es
8010625f:	06                   	push   %es
  pushl %fs
80106260:	0f a0                	push   %fs
  pushl %gs
80106262:	0f a8                	push   %gs
  pushal
80106264:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106265:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106269:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010626b:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010626d:	54                   	push   %esp
  call trap
8010626e:	e8 cd 00 00 00       	call   80106340 <trap>
  addl $4, %esp
80106273:	83 c4 04             	add    $0x4,%esp

80106276 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106276:	61                   	popa   
  popl %gs
80106277:	0f a9                	pop    %gs
  popl %fs
80106279:	0f a1                	pop    %fs
  popl %es
8010627b:	07                   	pop    %es
  popl %ds
8010627c:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010627d:	83 c4 08             	add    $0x8,%esp
  iret
80106280:	cf                   	iret   
80106281:	66 90                	xchg   %ax,%ax
80106283:	66 90                	xchg   %ax,%ax
80106285:	66 90                	xchg   %ax,%ax
80106287:	66 90                	xchg   %ax,%ax
80106289:	66 90                	xchg   %ax,%ax
8010628b:	66 90                	xchg   %ax,%ax
8010628d:	66 90                	xchg   %ax,%ax
8010628f:	90                   	nop

80106290 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106290:	f3 0f 1e fb          	endbr32 
80106294:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106295:	31 c0                	xor    %eax,%eax
{
80106297:	89 e5                	mov    %esp,%ebp
80106299:	83 ec 08             	sub    $0x8,%esp
8010629c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801062a0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
801062a7:	c7 04 c5 c2 21 12 80 	movl   $0x8e000008,-0x7fedde3e(,%eax,8)
801062ae:	08 00 00 8e 
801062b2:	66 89 14 c5 c0 21 12 	mov    %dx,-0x7fedde40(,%eax,8)
801062b9:	80 
801062ba:	c1 ea 10             	shr    $0x10,%edx
801062bd:	66 89 14 c5 c6 21 12 	mov    %dx,-0x7fedde3a(,%eax,8)
801062c4:	80 
  for(i = 0; i < 256; i++)
801062c5:	83 c0 01             	add    $0x1,%eax
801062c8:	3d 00 01 00 00       	cmp    $0x100,%eax
801062cd:	75 d1                	jne    801062a0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
801062cf:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801062d2:	a1 08 b1 10 80       	mov    0x8010b108,%eax
801062d7:	c7 05 c2 23 12 80 08 	movl   $0xef000008,0x801223c2
801062de:	00 00 ef 
  initlock(&tickslock, "time");
801062e1:	68 f5 87 10 80       	push   $0x801087f5
801062e6:	68 80 21 12 80       	push   $0x80122180
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801062eb:	66 a3 c0 23 12 80    	mov    %ax,0x801223c0
801062f1:	c1 e8 10             	shr    $0x10,%eax
801062f4:	66 a3 c6 23 12 80    	mov    %ax,0x801223c6
  initlock(&tickslock, "time");
801062fa:	e8 b1 ea ff ff       	call   80104db0 <initlock>
}
801062ff:	83 c4 10             	add    $0x10,%esp
80106302:	c9                   	leave  
80106303:	c3                   	ret    
80106304:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010630b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010630f:	90                   	nop

80106310 <idtinit>:

void
idtinit(void)
{
80106310:	f3 0f 1e fb          	endbr32 
80106314:	55                   	push   %ebp
  pd[0] = size-1;
80106315:	b8 ff 07 00 00       	mov    $0x7ff,%eax
8010631a:	89 e5                	mov    %esp,%ebp
8010631c:	83 ec 10             	sub    $0x10,%esp
8010631f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106323:	b8 c0 21 12 80       	mov    $0x801221c0,%eax
80106328:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010632c:	c1 e8 10             	shr    $0x10,%eax
8010632f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106333:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106336:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106339:	c9                   	leave  
8010633a:	c3                   	ret    
8010633b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010633f:	90                   	nop

80106340 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106340:	f3 0f 1e fb          	endbr32 
80106344:	55                   	push   %ebp
80106345:	89 e5                	mov    %esp,%ebp
80106347:	57                   	push   %edi
80106348:	56                   	push   %esi
80106349:	53                   	push   %ebx
8010634a:	83 ec 1c             	sub    $0x1c,%esp
8010634d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80106350:	8b 43 30             	mov    0x30(%ebx),%eax
80106353:	83 f8 40             	cmp    $0x40,%eax
80106356:	0f 84 cc 01 00 00    	je     80106528 <trap+0x1e8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
8010635c:	83 e8 0e             	sub    $0xe,%eax
8010635f:	83 f8 31             	cmp    $0x31,%eax
80106362:	77 46                	ja     801063aa <trap+0x6a>
80106364:	3e ff 24 85 a4 88 10 	notrack jmp *-0x7fef775c(,%eax,4)
8010636b:	80 
    lapiceoi();
    break;

  case T_PGFLT:
  ;
    cprintf("pgfault");
8010636c:	83 ec 0c             	sub    $0xc,%esp
8010636f:	68 fa 87 10 80       	push   $0x801087fa
80106374:	e8 37 a3 ff ff       	call   801006b0 <cprintf>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106379:	0f 20 d7             	mov    %cr2,%edi
    uint faulting_addr = rcr2();
    struct proc* p = myproc();
8010637c:	e8 8f dd ff ff       	call   80104110 <myproc>
    // p->tf->eip
    pte_t* pte_ptr = public_walkpgdir(p->pgdir, (void *)faulting_addr, 0);
80106381:	83 c4 0c             	add    $0xc,%esp
80106384:	6a 00                	push   $0x0
    struct proc* p = myproc();
80106386:	89 c6                	mov    %eax,%esi
    pte_t* pte_ptr = public_walkpgdir(p->pgdir, (void *)faulting_addr, 0);
80106388:	57                   	push   %edi
80106389:	ff 70 04             	pushl  0x4(%eax)
8010638c:	e8 bf 10 00 00       	call   80107450 <public_walkpgdir>
    if (!(pte_ptr == 0) && (*pte_ptr & PTE_U) && (*pte_ptr & PTE_PG)){
80106391:	83 c4 10             	add    $0x10,%esp
80106394:	85 c0                	test   %eax,%eax
80106396:	74 12                	je     801063aa <trap+0x6a>
80106398:	8b 00                	mov    (%eax),%eax
8010639a:	25 04 02 00 00       	and    $0x204,%eax
8010639f:	3d 04 02 00 00       	cmp    $0x204,%eax
801063a4:	0f 84 c6 01 00 00    	je     80106570 <trap+0x230>
      break;
    }

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801063aa:	e8 61 dd ff ff       	call   80104110 <myproc>
801063af:	8b 7b 38             	mov    0x38(%ebx),%edi
801063b2:	85 c0                	test   %eax,%eax
801063b4:	0f 84 47 02 00 00    	je     80106601 <trap+0x2c1>
801063ba:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801063be:	0f 84 3d 02 00 00    	je     80106601 <trap+0x2c1>
801063c4:	0f 20 d1             	mov    %cr2,%ecx
801063c7:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801063ca:	e8 21 dd ff ff       	call   801040f0 <cpuid>
801063cf:	8b 73 30             	mov    0x30(%ebx),%esi
801063d2:	89 45 dc             	mov    %eax,-0x24(%ebp)
801063d5:	8b 43 34             	mov    0x34(%ebx),%eax
801063d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801063db:	e8 30 dd ff ff       	call   80104110 <myproc>
801063e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801063e3:	e8 28 dd ff ff       	call   80104110 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801063e8:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801063eb:	8b 55 dc             	mov    -0x24(%ebp),%edx
801063ee:	51                   	push   %ecx
801063ef:	57                   	push   %edi
801063f0:	52                   	push   %edx
801063f1:	ff 75 e4             	pushl  -0x1c(%ebp)
801063f4:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801063f5:	8b 75 e0             	mov    -0x20(%ebp),%esi
801063f8:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801063fb:	56                   	push   %esi
801063fc:	ff 70 10             	pushl  0x10(%eax)
801063ff:	68 60 88 10 80       	push   $0x80108860
80106404:	e8 a7 a2 ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80106409:	83 c4 20             	add    $0x20,%esp
8010640c:	e8 ff dc ff ff       	call   80104110 <myproc>
80106411:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106418:	e8 f3 dc ff ff       	call   80104110 <myproc>
8010641d:	85 c0                	test   %eax,%eax
8010641f:	74 1d                	je     8010643e <trap+0xfe>
80106421:	e8 ea dc ff ff       	call   80104110 <myproc>
80106426:	8b 50 24             	mov    0x24(%eax),%edx
80106429:	85 d2                	test   %edx,%edx
8010642b:	74 11                	je     8010643e <trap+0xfe>
8010642d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106431:	83 e0 03             	and    $0x3,%eax
80106434:	66 83 f8 03          	cmp    $0x3,%ax
80106438:	0f 84 22 01 00 00    	je     80106560 <trap+0x220>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
8010643e:	e8 cd dc ff ff       	call   80104110 <myproc>
80106443:	85 c0                	test   %eax,%eax
80106445:	74 0f                	je     80106456 <trap+0x116>
80106447:	e8 c4 dc ff ff       	call   80104110 <myproc>
8010644c:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106450:	0f 84 ba 00 00 00    	je     80106510 <trap+0x1d0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106456:	e8 b5 dc ff ff       	call   80104110 <myproc>
8010645b:	85 c0                	test   %eax,%eax
8010645d:	74 1d                	je     8010647c <trap+0x13c>
8010645f:	e8 ac dc ff ff       	call   80104110 <myproc>
80106464:	8b 40 24             	mov    0x24(%eax),%eax
80106467:	85 c0                	test   %eax,%eax
80106469:	74 11                	je     8010647c <trap+0x13c>
8010646b:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
8010646f:	83 e0 03             	and    $0x3,%eax
80106472:	66 83 f8 03          	cmp    $0x3,%ax
80106476:	0f 84 d5 00 00 00    	je     80106551 <trap+0x211>
    exit();
}
8010647c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010647f:	5b                   	pop    %ebx
80106480:	5e                   	pop    %esi
80106481:	5f                   	pop    %edi
80106482:	5d                   	pop    %ebp
80106483:	c3                   	ret    
    if(cpuid() == 0){
80106484:	e8 67 dc ff ff       	call   801040f0 <cpuid>
80106489:	85 c0                	test   %eax,%eax
8010648b:	0f 84 1f 01 00 00    	je     801065b0 <trap+0x270>
    lapiceoi();
80106491:	e8 6a cb ff ff       	call   80103000 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106496:	e8 75 dc ff ff       	call   80104110 <myproc>
8010649b:	85 c0                	test   %eax,%eax
8010649d:	75 82                	jne    80106421 <trap+0xe1>
8010649f:	eb 9d                	jmp    8010643e <trap+0xfe>
    kbdintr();
801064a1:	e8 1a ca ff ff       	call   80102ec0 <kbdintr>
    lapiceoi();
801064a6:	e8 55 cb ff ff       	call   80103000 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801064ab:	e8 60 dc ff ff       	call   80104110 <myproc>
801064b0:	85 c0                	test   %eax,%eax
801064b2:	0f 85 69 ff ff ff    	jne    80106421 <trap+0xe1>
801064b8:	eb 84                	jmp    8010643e <trap+0xfe>
    uartintr();
801064ba:	e8 e1 02 00 00       	call   801067a0 <uartintr>
    lapiceoi();
801064bf:	e8 3c cb ff ff       	call   80103000 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801064c4:	e8 47 dc ff ff       	call   80104110 <myproc>
801064c9:	85 c0                	test   %eax,%eax
801064cb:	0f 85 50 ff ff ff    	jne    80106421 <trap+0xe1>
801064d1:	e9 68 ff ff ff       	jmp    8010643e <trap+0xfe>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801064d6:	8b 7b 38             	mov    0x38(%ebx),%edi
801064d9:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801064dd:	e8 0e dc ff ff       	call   801040f0 <cpuid>
801064e2:	57                   	push   %edi
801064e3:	56                   	push   %esi
801064e4:	50                   	push   %eax
801064e5:	68 08 88 10 80       	push   $0x80108808
801064ea:	e8 c1 a1 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
801064ef:	e8 0c cb ff ff       	call   80103000 <lapiceoi>
    break;
801064f4:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801064f7:	e8 14 dc ff ff       	call   80104110 <myproc>
801064fc:	85 c0                	test   %eax,%eax
801064fe:	0f 85 1d ff ff ff    	jne    80106421 <trap+0xe1>
80106504:	e9 35 ff ff ff       	jmp    8010643e <trap+0xfe>
    ideintr();
80106509:	e8 12 c4 ff ff       	call   80102920 <ideintr>
8010650e:	eb 81                	jmp    80106491 <trap+0x151>
  if(myproc() && myproc()->state == RUNNING &&
80106510:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106514:	0f 85 3c ff ff ff    	jne    80106456 <trap+0x116>
    yield();
8010651a:	e8 c1 e2 ff ff       	call   801047e0 <yield>
8010651f:	e9 32 ff ff ff       	jmp    80106456 <trap+0x116>
80106524:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80106528:	e8 e3 db ff ff       	call   80104110 <myproc>
8010652d:	8b 70 24             	mov    0x24(%eax),%esi
80106530:	85 f6                	test   %esi,%esi
80106532:	75 6c                	jne    801065a0 <trap+0x260>
    myproc()->tf = tf;
80106534:	e8 d7 db ff ff       	call   80104110 <myproc>
80106539:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
8010653c:	e8 cf ee ff ff       	call   80105410 <syscall>
    if(myproc()->killed)
80106541:	e8 ca db ff ff       	call   80104110 <myproc>
80106546:	8b 48 24             	mov    0x24(%eax),%ecx
80106549:	85 c9                	test   %ecx,%ecx
8010654b:	0f 84 2b ff ff ff    	je     8010647c <trap+0x13c>
}
80106551:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106554:	5b                   	pop    %ebx
80106555:	5e                   	pop    %esi
80106556:	5f                   	pop    %edi
80106557:	5d                   	pop    %ebp
      exit();
80106558:	e9 43 e1 ff ff       	jmp    801046a0 <exit>
8010655d:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80106560:	e8 3b e1 ff ff       	call   801046a0 <exit>
80106565:	e9 d4 fe ff ff       	jmp    8010643e <trap+0xfe>
8010656a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106570:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80106576:	8d 96 90 00 00 00    	lea    0x90(%esi),%edx
      for (int i = 0; i < MAX_PYSC_PAGES; i++){
8010657c:	31 c0                	xor    %eax,%eax
8010657e:	66 90                	xchg   %ax,%ax
        if ((uint)(p->swapped_out_pages[i].va) == PGROUNDDOWN(faulting_addr)){
80106580:	39 3a                	cmp    %edi,(%edx)
80106582:	74 64                	je     801065e8 <trap+0x2a8>
      for (int i = 0; i < MAX_PYSC_PAGES; i++){
80106584:	83 c0 01             	add    $0x1,%eax
80106587:	83 c2 18             	add    $0x18,%edx
8010658a:	83 f8 10             	cmp    $0x10,%eax
8010658d:	75 f1                	jne    80106580 <trap+0x240>
      p->num_of_pagefaults_occurs++;
8010658f:	83 86 88 03 00 00 01 	addl   $0x1,0x388(%esi)
      break;
80106596:	e9 7d fe ff ff       	jmp    80106418 <trap+0xd8>
8010659b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010659f:	90                   	nop
      exit();
801065a0:	e8 fb e0 ff ff       	call   801046a0 <exit>
801065a5:	eb 8d                	jmp    80106534 <trap+0x1f4>
801065a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065ae:	66 90                	xchg   %ax,%ax
      acquire(&tickslock);
801065b0:	83 ec 0c             	sub    $0xc,%esp
801065b3:	68 80 21 12 80       	push   $0x80122180
801065b8:	e8 73 e9 ff ff       	call   80104f30 <acquire>
      wakeup(&ticks);
801065bd:	c7 04 24 c0 29 12 80 	movl   $0x801229c0,(%esp)
      ticks++;
801065c4:	83 05 c0 29 12 80 01 	addl   $0x1,0x801229c0
      wakeup(&ticks);
801065cb:	e8 c0 e4 ff ff       	call   80104a90 <wakeup>
      release(&tickslock);
801065d0:	c7 04 24 80 21 12 80 	movl   $0x80122180,(%esp)
801065d7:	e8 14 ea ff ff       	call   80104ff0 <release>
801065dc:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
801065df:	e9 ad fe ff ff       	jmp    80106491 <trap+0x151>
801065e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
          swap_page_back(p, &(p->swapped_out_pages[i]));
801065e8:	8d 04 40             	lea    (%eax,%eax,2),%eax
801065eb:	83 ec 08             	sub    $0x8,%esp
801065ee:	8d 84 c6 80 00 00 00 	lea    0x80(%esi,%eax,8),%eax
801065f5:	50                   	push   %eax
801065f6:	56                   	push   %esi
801065f7:	e8 84 19 00 00       	call   80107f80 <swap_page_back>
          break;
801065fc:	83 c4 10             	add    $0x10,%esp
801065ff:	eb 8e                	jmp    8010658f <trap+0x24f>
80106601:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106604:	e8 e7 da ff ff       	call   801040f0 <cpuid>
80106609:	83 ec 0c             	sub    $0xc,%esp
8010660c:	56                   	push   %esi
8010660d:	57                   	push   %edi
8010660e:	50                   	push   %eax
8010660f:	ff 73 30             	pushl  0x30(%ebx)
80106612:	68 2c 88 10 80       	push   $0x8010882c
80106617:	e8 94 a0 ff ff       	call   801006b0 <cprintf>
      panic("trap");
8010661c:	83 c4 14             	add    $0x14,%esp
8010661f:	68 02 88 10 80       	push   $0x80108802
80106624:	e8 67 9d ff ff       	call   80100390 <panic>
80106629:	66 90                	xchg   %ax,%ax
8010662b:	66 90                	xchg   %ax,%ax
8010662d:	66 90                	xchg   %ax,%ax
8010662f:	90                   	nop

80106630 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106630:	f3 0f 1e fb          	endbr32 
  if(!uart)
80106634:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
80106639:	85 c0                	test   %eax,%eax
8010663b:	74 1b                	je     80106658 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010663d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106642:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106643:	a8 01                	test   $0x1,%al
80106645:	74 11                	je     80106658 <uartgetc+0x28>
80106647:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010664c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010664d:	0f b6 c0             	movzbl %al,%eax
80106650:	c3                   	ret    
80106651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106658:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010665d:	c3                   	ret    
8010665e:	66 90                	xchg   %ax,%ax

80106660 <uartputc.part.0>:
uartputc(int c)
80106660:	55                   	push   %ebp
80106661:	89 e5                	mov    %esp,%ebp
80106663:	57                   	push   %edi
80106664:	89 c7                	mov    %eax,%edi
80106666:	56                   	push   %esi
80106667:	be fd 03 00 00       	mov    $0x3fd,%esi
8010666c:	53                   	push   %ebx
8010666d:	bb 80 00 00 00       	mov    $0x80,%ebx
80106672:	83 ec 0c             	sub    $0xc,%esp
80106675:	eb 1b                	jmp    80106692 <uartputc.part.0+0x32>
80106677:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010667e:	66 90                	xchg   %ax,%ax
    microdelay(10);
80106680:	83 ec 0c             	sub    $0xc,%esp
80106683:	6a 0a                	push   $0xa
80106685:	e8 96 c9 ff ff       	call   80103020 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010668a:	83 c4 10             	add    $0x10,%esp
8010668d:	83 eb 01             	sub    $0x1,%ebx
80106690:	74 07                	je     80106699 <uartputc.part.0+0x39>
80106692:	89 f2                	mov    %esi,%edx
80106694:	ec                   	in     (%dx),%al
80106695:	a8 20                	test   $0x20,%al
80106697:	74 e7                	je     80106680 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106699:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010669e:	89 f8                	mov    %edi,%eax
801066a0:	ee                   	out    %al,(%dx)
}
801066a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801066a4:	5b                   	pop    %ebx
801066a5:	5e                   	pop    %esi
801066a6:	5f                   	pop    %edi
801066a7:	5d                   	pop    %ebp
801066a8:	c3                   	ret    
801066a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801066b0 <uartinit>:
{
801066b0:	f3 0f 1e fb          	endbr32 
801066b4:	55                   	push   %ebp
801066b5:	31 c9                	xor    %ecx,%ecx
801066b7:	89 c8                	mov    %ecx,%eax
801066b9:	89 e5                	mov    %esp,%ebp
801066bb:	57                   	push   %edi
801066bc:	56                   	push   %esi
801066bd:	53                   	push   %ebx
801066be:	bb fa 03 00 00       	mov    $0x3fa,%ebx
801066c3:	89 da                	mov    %ebx,%edx
801066c5:	83 ec 0c             	sub    $0xc,%esp
801066c8:	ee                   	out    %al,(%dx)
801066c9:	bf fb 03 00 00       	mov    $0x3fb,%edi
801066ce:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801066d3:	89 fa                	mov    %edi,%edx
801066d5:	ee                   	out    %al,(%dx)
801066d6:	b8 0c 00 00 00       	mov    $0xc,%eax
801066db:	ba f8 03 00 00       	mov    $0x3f8,%edx
801066e0:	ee                   	out    %al,(%dx)
801066e1:	be f9 03 00 00       	mov    $0x3f9,%esi
801066e6:	89 c8                	mov    %ecx,%eax
801066e8:	89 f2                	mov    %esi,%edx
801066ea:	ee                   	out    %al,(%dx)
801066eb:	b8 03 00 00 00       	mov    $0x3,%eax
801066f0:	89 fa                	mov    %edi,%edx
801066f2:	ee                   	out    %al,(%dx)
801066f3:	ba fc 03 00 00       	mov    $0x3fc,%edx
801066f8:	89 c8                	mov    %ecx,%eax
801066fa:	ee                   	out    %al,(%dx)
801066fb:	b8 01 00 00 00       	mov    $0x1,%eax
80106700:	89 f2                	mov    %esi,%edx
80106702:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106703:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106708:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106709:	3c ff                	cmp    $0xff,%al
8010670b:	74 52                	je     8010675f <uartinit+0xaf>
  uart = 1;
8010670d:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80106714:	00 00 00 
80106717:	89 da                	mov    %ebx,%edx
80106719:	ec                   	in     (%dx),%al
8010671a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010671f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106720:	83 ec 08             	sub    $0x8,%esp
80106723:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80106728:	bb 6c 89 10 80       	mov    $0x8010896c,%ebx
  ioapicenable(IRQ_COM1, 0);
8010672d:	6a 00                	push   $0x0
8010672f:	6a 04                	push   $0x4
80106731:	e8 3a c4 ff ff       	call   80102b70 <ioapicenable>
80106736:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106739:	b8 78 00 00 00       	mov    $0x78,%eax
8010673e:	eb 04                	jmp    80106744 <uartinit+0x94>
80106740:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80106744:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
8010674a:	85 d2                	test   %edx,%edx
8010674c:	74 08                	je     80106756 <uartinit+0xa6>
    uartputc(*p);
8010674e:	0f be c0             	movsbl %al,%eax
80106751:	e8 0a ff ff ff       	call   80106660 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80106756:	89 f0                	mov    %esi,%eax
80106758:	83 c3 01             	add    $0x1,%ebx
8010675b:	84 c0                	test   %al,%al
8010675d:	75 e1                	jne    80106740 <uartinit+0x90>
}
8010675f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106762:	5b                   	pop    %ebx
80106763:	5e                   	pop    %esi
80106764:	5f                   	pop    %edi
80106765:	5d                   	pop    %ebp
80106766:	c3                   	ret    
80106767:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010676e:	66 90                	xchg   %ax,%ax

80106770 <uartputc>:
{
80106770:	f3 0f 1e fb          	endbr32 
80106774:	55                   	push   %ebp
  if(!uart)
80106775:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
8010677b:	89 e5                	mov    %esp,%ebp
8010677d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106780:	85 d2                	test   %edx,%edx
80106782:	74 0c                	je     80106790 <uartputc+0x20>
}
80106784:	5d                   	pop    %ebp
80106785:	e9 d6 fe ff ff       	jmp    80106660 <uartputc.part.0>
8010678a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106790:	5d                   	pop    %ebp
80106791:	c3                   	ret    
80106792:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801067a0 <uartintr>:

void
uartintr(void)
{
801067a0:	f3 0f 1e fb          	endbr32 
801067a4:	55                   	push   %ebp
801067a5:	89 e5                	mov    %esp,%ebp
801067a7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801067aa:	68 30 66 10 80       	push   $0x80106630
801067af:	e8 ac a0 ff ff       	call   80100860 <consoleintr>
}
801067b4:	83 c4 10             	add    $0x10,%esp
801067b7:	c9                   	leave  
801067b8:	c3                   	ret    

801067b9 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801067b9:	6a 00                	push   $0x0
  pushl $0
801067bb:	6a 00                	push   $0x0
  jmp alltraps
801067bd:	e9 9c fa ff ff       	jmp    8010625e <alltraps>

801067c2 <vector1>:
.globl vector1
vector1:
  pushl $0
801067c2:	6a 00                	push   $0x0
  pushl $1
801067c4:	6a 01                	push   $0x1
  jmp alltraps
801067c6:	e9 93 fa ff ff       	jmp    8010625e <alltraps>

801067cb <vector2>:
.globl vector2
vector2:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $2
801067cd:	6a 02                	push   $0x2
  jmp alltraps
801067cf:	e9 8a fa ff ff       	jmp    8010625e <alltraps>

801067d4 <vector3>:
.globl vector3
vector3:
  pushl $0
801067d4:	6a 00                	push   $0x0
  pushl $3
801067d6:	6a 03                	push   $0x3
  jmp alltraps
801067d8:	e9 81 fa ff ff       	jmp    8010625e <alltraps>

801067dd <vector4>:
.globl vector4
vector4:
  pushl $0
801067dd:	6a 00                	push   $0x0
  pushl $4
801067df:	6a 04                	push   $0x4
  jmp alltraps
801067e1:	e9 78 fa ff ff       	jmp    8010625e <alltraps>

801067e6 <vector5>:
.globl vector5
vector5:
  pushl $0
801067e6:	6a 00                	push   $0x0
  pushl $5
801067e8:	6a 05                	push   $0x5
  jmp alltraps
801067ea:	e9 6f fa ff ff       	jmp    8010625e <alltraps>

801067ef <vector6>:
.globl vector6
vector6:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $6
801067f1:	6a 06                	push   $0x6
  jmp alltraps
801067f3:	e9 66 fa ff ff       	jmp    8010625e <alltraps>

801067f8 <vector7>:
.globl vector7
vector7:
  pushl $0
801067f8:	6a 00                	push   $0x0
  pushl $7
801067fa:	6a 07                	push   $0x7
  jmp alltraps
801067fc:	e9 5d fa ff ff       	jmp    8010625e <alltraps>

80106801 <vector8>:
.globl vector8
vector8:
  pushl $8
80106801:	6a 08                	push   $0x8
  jmp alltraps
80106803:	e9 56 fa ff ff       	jmp    8010625e <alltraps>

80106808 <vector9>:
.globl vector9
vector9:
  pushl $0
80106808:	6a 00                	push   $0x0
  pushl $9
8010680a:	6a 09                	push   $0x9
  jmp alltraps
8010680c:	e9 4d fa ff ff       	jmp    8010625e <alltraps>

80106811 <vector10>:
.globl vector10
vector10:
  pushl $10
80106811:	6a 0a                	push   $0xa
  jmp alltraps
80106813:	e9 46 fa ff ff       	jmp    8010625e <alltraps>

80106818 <vector11>:
.globl vector11
vector11:
  pushl $11
80106818:	6a 0b                	push   $0xb
  jmp alltraps
8010681a:	e9 3f fa ff ff       	jmp    8010625e <alltraps>

8010681f <vector12>:
.globl vector12
vector12:
  pushl $12
8010681f:	6a 0c                	push   $0xc
  jmp alltraps
80106821:	e9 38 fa ff ff       	jmp    8010625e <alltraps>

80106826 <vector13>:
.globl vector13
vector13:
  pushl $13
80106826:	6a 0d                	push   $0xd
  jmp alltraps
80106828:	e9 31 fa ff ff       	jmp    8010625e <alltraps>

8010682d <vector14>:
.globl vector14
vector14:
  pushl $14
8010682d:	6a 0e                	push   $0xe
  jmp alltraps
8010682f:	e9 2a fa ff ff       	jmp    8010625e <alltraps>

80106834 <vector15>:
.globl vector15
vector15:
  pushl $0
80106834:	6a 00                	push   $0x0
  pushl $15
80106836:	6a 0f                	push   $0xf
  jmp alltraps
80106838:	e9 21 fa ff ff       	jmp    8010625e <alltraps>

8010683d <vector16>:
.globl vector16
vector16:
  pushl $0
8010683d:	6a 00                	push   $0x0
  pushl $16
8010683f:	6a 10                	push   $0x10
  jmp alltraps
80106841:	e9 18 fa ff ff       	jmp    8010625e <alltraps>

80106846 <vector17>:
.globl vector17
vector17:
  pushl $17
80106846:	6a 11                	push   $0x11
  jmp alltraps
80106848:	e9 11 fa ff ff       	jmp    8010625e <alltraps>

8010684d <vector18>:
.globl vector18
vector18:
  pushl $0
8010684d:	6a 00                	push   $0x0
  pushl $18
8010684f:	6a 12                	push   $0x12
  jmp alltraps
80106851:	e9 08 fa ff ff       	jmp    8010625e <alltraps>

80106856 <vector19>:
.globl vector19
vector19:
  pushl $0
80106856:	6a 00                	push   $0x0
  pushl $19
80106858:	6a 13                	push   $0x13
  jmp alltraps
8010685a:	e9 ff f9 ff ff       	jmp    8010625e <alltraps>

8010685f <vector20>:
.globl vector20
vector20:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $20
80106861:	6a 14                	push   $0x14
  jmp alltraps
80106863:	e9 f6 f9 ff ff       	jmp    8010625e <alltraps>

80106868 <vector21>:
.globl vector21
vector21:
  pushl $0
80106868:	6a 00                	push   $0x0
  pushl $21
8010686a:	6a 15                	push   $0x15
  jmp alltraps
8010686c:	e9 ed f9 ff ff       	jmp    8010625e <alltraps>

80106871 <vector22>:
.globl vector22
vector22:
  pushl $0
80106871:	6a 00                	push   $0x0
  pushl $22
80106873:	6a 16                	push   $0x16
  jmp alltraps
80106875:	e9 e4 f9 ff ff       	jmp    8010625e <alltraps>

8010687a <vector23>:
.globl vector23
vector23:
  pushl $0
8010687a:	6a 00                	push   $0x0
  pushl $23
8010687c:	6a 17                	push   $0x17
  jmp alltraps
8010687e:	e9 db f9 ff ff       	jmp    8010625e <alltraps>

80106883 <vector24>:
.globl vector24
vector24:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $24
80106885:	6a 18                	push   $0x18
  jmp alltraps
80106887:	e9 d2 f9 ff ff       	jmp    8010625e <alltraps>

8010688c <vector25>:
.globl vector25
vector25:
  pushl $0
8010688c:	6a 00                	push   $0x0
  pushl $25
8010688e:	6a 19                	push   $0x19
  jmp alltraps
80106890:	e9 c9 f9 ff ff       	jmp    8010625e <alltraps>

80106895 <vector26>:
.globl vector26
vector26:
  pushl $0
80106895:	6a 00                	push   $0x0
  pushl $26
80106897:	6a 1a                	push   $0x1a
  jmp alltraps
80106899:	e9 c0 f9 ff ff       	jmp    8010625e <alltraps>

8010689e <vector27>:
.globl vector27
vector27:
  pushl $0
8010689e:	6a 00                	push   $0x0
  pushl $27
801068a0:	6a 1b                	push   $0x1b
  jmp alltraps
801068a2:	e9 b7 f9 ff ff       	jmp    8010625e <alltraps>

801068a7 <vector28>:
.globl vector28
vector28:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $28
801068a9:	6a 1c                	push   $0x1c
  jmp alltraps
801068ab:	e9 ae f9 ff ff       	jmp    8010625e <alltraps>

801068b0 <vector29>:
.globl vector29
vector29:
  pushl $0
801068b0:	6a 00                	push   $0x0
  pushl $29
801068b2:	6a 1d                	push   $0x1d
  jmp alltraps
801068b4:	e9 a5 f9 ff ff       	jmp    8010625e <alltraps>

801068b9 <vector30>:
.globl vector30
vector30:
  pushl $0
801068b9:	6a 00                	push   $0x0
  pushl $30
801068bb:	6a 1e                	push   $0x1e
  jmp alltraps
801068bd:	e9 9c f9 ff ff       	jmp    8010625e <alltraps>

801068c2 <vector31>:
.globl vector31
vector31:
  pushl $0
801068c2:	6a 00                	push   $0x0
  pushl $31
801068c4:	6a 1f                	push   $0x1f
  jmp alltraps
801068c6:	e9 93 f9 ff ff       	jmp    8010625e <alltraps>

801068cb <vector32>:
.globl vector32
vector32:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $32
801068cd:	6a 20                	push   $0x20
  jmp alltraps
801068cf:	e9 8a f9 ff ff       	jmp    8010625e <alltraps>

801068d4 <vector33>:
.globl vector33
vector33:
  pushl $0
801068d4:	6a 00                	push   $0x0
  pushl $33
801068d6:	6a 21                	push   $0x21
  jmp alltraps
801068d8:	e9 81 f9 ff ff       	jmp    8010625e <alltraps>

801068dd <vector34>:
.globl vector34
vector34:
  pushl $0
801068dd:	6a 00                	push   $0x0
  pushl $34
801068df:	6a 22                	push   $0x22
  jmp alltraps
801068e1:	e9 78 f9 ff ff       	jmp    8010625e <alltraps>

801068e6 <vector35>:
.globl vector35
vector35:
  pushl $0
801068e6:	6a 00                	push   $0x0
  pushl $35
801068e8:	6a 23                	push   $0x23
  jmp alltraps
801068ea:	e9 6f f9 ff ff       	jmp    8010625e <alltraps>

801068ef <vector36>:
.globl vector36
vector36:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $36
801068f1:	6a 24                	push   $0x24
  jmp alltraps
801068f3:	e9 66 f9 ff ff       	jmp    8010625e <alltraps>

801068f8 <vector37>:
.globl vector37
vector37:
  pushl $0
801068f8:	6a 00                	push   $0x0
  pushl $37
801068fa:	6a 25                	push   $0x25
  jmp alltraps
801068fc:	e9 5d f9 ff ff       	jmp    8010625e <alltraps>

80106901 <vector38>:
.globl vector38
vector38:
  pushl $0
80106901:	6a 00                	push   $0x0
  pushl $38
80106903:	6a 26                	push   $0x26
  jmp alltraps
80106905:	e9 54 f9 ff ff       	jmp    8010625e <alltraps>

8010690a <vector39>:
.globl vector39
vector39:
  pushl $0
8010690a:	6a 00                	push   $0x0
  pushl $39
8010690c:	6a 27                	push   $0x27
  jmp alltraps
8010690e:	e9 4b f9 ff ff       	jmp    8010625e <alltraps>

80106913 <vector40>:
.globl vector40
vector40:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $40
80106915:	6a 28                	push   $0x28
  jmp alltraps
80106917:	e9 42 f9 ff ff       	jmp    8010625e <alltraps>

8010691c <vector41>:
.globl vector41
vector41:
  pushl $0
8010691c:	6a 00                	push   $0x0
  pushl $41
8010691e:	6a 29                	push   $0x29
  jmp alltraps
80106920:	e9 39 f9 ff ff       	jmp    8010625e <alltraps>

80106925 <vector42>:
.globl vector42
vector42:
  pushl $0
80106925:	6a 00                	push   $0x0
  pushl $42
80106927:	6a 2a                	push   $0x2a
  jmp alltraps
80106929:	e9 30 f9 ff ff       	jmp    8010625e <alltraps>

8010692e <vector43>:
.globl vector43
vector43:
  pushl $0
8010692e:	6a 00                	push   $0x0
  pushl $43
80106930:	6a 2b                	push   $0x2b
  jmp alltraps
80106932:	e9 27 f9 ff ff       	jmp    8010625e <alltraps>

80106937 <vector44>:
.globl vector44
vector44:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $44
80106939:	6a 2c                	push   $0x2c
  jmp alltraps
8010693b:	e9 1e f9 ff ff       	jmp    8010625e <alltraps>

80106940 <vector45>:
.globl vector45
vector45:
  pushl $0
80106940:	6a 00                	push   $0x0
  pushl $45
80106942:	6a 2d                	push   $0x2d
  jmp alltraps
80106944:	e9 15 f9 ff ff       	jmp    8010625e <alltraps>

80106949 <vector46>:
.globl vector46
vector46:
  pushl $0
80106949:	6a 00                	push   $0x0
  pushl $46
8010694b:	6a 2e                	push   $0x2e
  jmp alltraps
8010694d:	e9 0c f9 ff ff       	jmp    8010625e <alltraps>

80106952 <vector47>:
.globl vector47
vector47:
  pushl $0
80106952:	6a 00                	push   $0x0
  pushl $47
80106954:	6a 2f                	push   $0x2f
  jmp alltraps
80106956:	e9 03 f9 ff ff       	jmp    8010625e <alltraps>

8010695b <vector48>:
.globl vector48
vector48:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $48
8010695d:	6a 30                	push   $0x30
  jmp alltraps
8010695f:	e9 fa f8 ff ff       	jmp    8010625e <alltraps>

80106964 <vector49>:
.globl vector49
vector49:
  pushl $0
80106964:	6a 00                	push   $0x0
  pushl $49
80106966:	6a 31                	push   $0x31
  jmp alltraps
80106968:	e9 f1 f8 ff ff       	jmp    8010625e <alltraps>

8010696d <vector50>:
.globl vector50
vector50:
  pushl $0
8010696d:	6a 00                	push   $0x0
  pushl $50
8010696f:	6a 32                	push   $0x32
  jmp alltraps
80106971:	e9 e8 f8 ff ff       	jmp    8010625e <alltraps>

80106976 <vector51>:
.globl vector51
vector51:
  pushl $0
80106976:	6a 00                	push   $0x0
  pushl $51
80106978:	6a 33                	push   $0x33
  jmp alltraps
8010697a:	e9 df f8 ff ff       	jmp    8010625e <alltraps>

8010697f <vector52>:
.globl vector52
vector52:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $52
80106981:	6a 34                	push   $0x34
  jmp alltraps
80106983:	e9 d6 f8 ff ff       	jmp    8010625e <alltraps>

80106988 <vector53>:
.globl vector53
vector53:
  pushl $0
80106988:	6a 00                	push   $0x0
  pushl $53
8010698a:	6a 35                	push   $0x35
  jmp alltraps
8010698c:	e9 cd f8 ff ff       	jmp    8010625e <alltraps>

80106991 <vector54>:
.globl vector54
vector54:
  pushl $0
80106991:	6a 00                	push   $0x0
  pushl $54
80106993:	6a 36                	push   $0x36
  jmp alltraps
80106995:	e9 c4 f8 ff ff       	jmp    8010625e <alltraps>

8010699a <vector55>:
.globl vector55
vector55:
  pushl $0
8010699a:	6a 00                	push   $0x0
  pushl $55
8010699c:	6a 37                	push   $0x37
  jmp alltraps
8010699e:	e9 bb f8 ff ff       	jmp    8010625e <alltraps>

801069a3 <vector56>:
.globl vector56
vector56:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $56
801069a5:	6a 38                	push   $0x38
  jmp alltraps
801069a7:	e9 b2 f8 ff ff       	jmp    8010625e <alltraps>

801069ac <vector57>:
.globl vector57
vector57:
  pushl $0
801069ac:	6a 00                	push   $0x0
  pushl $57
801069ae:	6a 39                	push   $0x39
  jmp alltraps
801069b0:	e9 a9 f8 ff ff       	jmp    8010625e <alltraps>

801069b5 <vector58>:
.globl vector58
vector58:
  pushl $0
801069b5:	6a 00                	push   $0x0
  pushl $58
801069b7:	6a 3a                	push   $0x3a
  jmp alltraps
801069b9:	e9 a0 f8 ff ff       	jmp    8010625e <alltraps>

801069be <vector59>:
.globl vector59
vector59:
  pushl $0
801069be:	6a 00                	push   $0x0
  pushl $59
801069c0:	6a 3b                	push   $0x3b
  jmp alltraps
801069c2:	e9 97 f8 ff ff       	jmp    8010625e <alltraps>

801069c7 <vector60>:
.globl vector60
vector60:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $60
801069c9:	6a 3c                	push   $0x3c
  jmp alltraps
801069cb:	e9 8e f8 ff ff       	jmp    8010625e <alltraps>

801069d0 <vector61>:
.globl vector61
vector61:
  pushl $0
801069d0:	6a 00                	push   $0x0
  pushl $61
801069d2:	6a 3d                	push   $0x3d
  jmp alltraps
801069d4:	e9 85 f8 ff ff       	jmp    8010625e <alltraps>

801069d9 <vector62>:
.globl vector62
vector62:
  pushl $0
801069d9:	6a 00                	push   $0x0
  pushl $62
801069db:	6a 3e                	push   $0x3e
  jmp alltraps
801069dd:	e9 7c f8 ff ff       	jmp    8010625e <alltraps>

801069e2 <vector63>:
.globl vector63
vector63:
  pushl $0
801069e2:	6a 00                	push   $0x0
  pushl $63
801069e4:	6a 3f                	push   $0x3f
  jmp alltraps
801069e6:	e9 73 f8 ff ff       	jmp    8010625e <alltraps>

801069eb <vector64>:
.globl vector64
vector64:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $64
801069ed:	6a 40                	push   $0x40
  jmp alltraps
801069ef:	e9 6a f8 ff ff       	jmp    8010625e <alltraps>

801069f4 <vector65>:
.globl vector65
vector65:
  pushl $0
801069f4:	6a 00                	push   $0x0
  pushl $65
801069f6:	6a 41                	push   $0x41
  jmp alltraps
801069f8:	e9 61 f8 ff ff       	jmp    8010625e <alltraps>

801069fd <vector66>:
.globl vector66
vector66:
  pushl $0
801069fd:	6a 00                	push   $0x0
  pushl $66
801069ff:	6a 42                	push   $0x42
  jmp alltraps
80106a01:	e9 58 f8 ff ff       	jmp    8010625e <alltraps>

80106a06 <vector67>:
.globl vector67
vector67:
  pushl $0
80106a06:	6a 00                	push   $0x0
  pushl $67
80106a08:	6a 43                	push   $0x43
  jmp alltraps
80106a0a:	e9 4f f8 ff ff       	jmp    8010625e <alltraps>

80106a0f <vector68>:
.globl vector68
vector68:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $68
80106a11:	6a 44                	push   $0x44
  jmp alltraps
80106a13:	e9 46 f8 ff ff       	jmp    8010625e <alltraps>

80106a18 <vector69>:
.globl vector69
vector69:
  pushl $0
80106a18:	6a 00                	push   $0x0
  pushl $69
80106a1a:	6a 45                	push   $0x45
  jmp alltraps
80106a1c:	e9 3d f8 ff ff       	jmp    8010625e <alltraps>

80106a21 <vector70>:
.globl vector70
vector70:
  pushl $0
80106a21:	6a 00                	push   $0x0
  pushl $70
80106a23:	6a 46                	push   $0x46
  jmp alltraps
80106a25:	e9 34 f8 ff ff       	jmp    8010625e <alltraps>

80106a2a <vector71>:
.globl vector71
vector71:
  pushl $0
80106a2a:	6a 00                	push   $0x0
  pushl $71
80106a2c:	6a 47                	push   $0x47
  jmp alltraps
80106a2e:	e9 2b f8 ff ff       	jmp    8010625e <alltraps>

80106a33 <vector72>:
.globl vector72
vector72:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $72
80106a35:	6a 48                	push   $0x48
  jmp alltraps
80106a37:	e9 22 f8 ff ff       	jmp    8010625e <alltraps>

80106a3c <vector73>:
.globl vector73
vector73:
  pushl $0
80106a3c:	6a 00                	push   $0x0
  pushl $73
80106a3e:	6a 49                	push   $0x49
  jmp alltraps
80106a40:	e9 19 f8 ff ff       	jmp    8010625e <alltraps>

80106a45 <vector74>:
.globl vector74
vector74:
  pushl $0
80106a45:	6a 00                	push   $0x0
  pushl $74
80106a47:	6a 4a                	push   $0x4a
  jmp alltraps
80106a49:	e9 10 f8 ff ff       	jmp    8010625e <alltraps>

80106a4e <vector75>:
.globl vector75
vector75:
  pushl $0
80106a4e:	6a 00                	push   $0x0
  pushl $75
80106a50:	6a 4b                	push   $0x4b
  jmp alltraps
80106a52:	e9 07 f8 ff ff       	jmp    8010625e <alltraps>

80106a57 <vector76>:
.globl vector76
vector76:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $76
80106a59:	6a 4c                	push   $0x4c
  jmp alltraps
80106a5b:	e9 fe f7 ff ff       	jmp    8010625e <alltraps>

80106a60 <vector77>:
.globl vector77
vector77:
  pushl $0
80106a60:	6a 00                	push   $0x0
  pushl $77
80106a62:	6a 4d                	push   $0x4d
  jmp alltraps
80106a64:	e9 f5 f7 ff ff       	jmp    8010625e <alltraps>

80106a69 <vector78>:
.globl vector78
vector78:
  pushl $0
80106a69:	6a 00                	push   $0x0
  pushl $78
80106a6b:	6a 4e                	push   $0x4e
  jmp alltraps
80106a6d:	e9 ec f7 ff ff       	jmp    8010625e <alltraps>

80106a72 <vector79>:
.globl vector79
vector79:
  pushl $0
80106a72:	6a 00                	push   $0x0
  pushl $79
80106a74:	6a 4f                	push   $0x4f
  jmp alltraps
80106a76:	e9 e3 f7 ff ff       	jmp    8010625e <alltraps>

80106a7b <vector80>:
.globl vector80
vector80:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $80
80106a7d:	6a 50                	push   $0x50
  jmp alltraps
80106a7f:	e9 da f7 ff ff       	jmp    8010625e <alltraps>

80106a84 <vector81>:
.globl vector81
vector81:
  pushl $0
80106a84:	6a 00                	push   $0x0
  pushl $81
80106a86:	6a 51                	push   $0x51
  jmp alltraps
80106a88:	e9 d1 f7 ff ff       	jmp    8010625e <alltraps>

80106a8d <vector82>:
.globl vector82
vector82:
  pushl $0
80106a8d:	6a 00                	push   $0x0
  pushl $82
80106a8f:	6a 52                	push   $0x52
  jmp alltraps
80106a91:	e9 c8 f7 ff ff       	jmp    8010625e <alltraps>

80106a96 <vector83>:
.globl vector83
vector83:
  pushl $0
80106a96:	6a 00                	push   $0x0
  pushl $83
80106a98:	6a 53                	push   $0x53
  jmp alltraps
80106a9a:	e9 bf f7 ff ff       	jmp    8010625e <alltraps>

80106a9f <vector84>:
.globl vector84
vector84:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $84
80106aa1:	6a 54                	push   $0x54
  jmp alltraps
80106aa3:	e9 b6 f7 ff ff       	jmp    8010625e <alltraps>

80106aa8 <vector85>:
.globl vector85
vector85:
  pushl $0
80106aa8:	6a 00                	push   $0x0
  pushl $85
80106aaa:	6a 55                	push   $0x55
  jmp alltraps
80106aac:	e9 ad f7 ff ff       	jmp    8010625e <alltraps>

80106ab1 <vector86>:
.globl vector86
vector86:
  pushl $0
80106ab1:	6a 00                	push   $0x0
  pushl $86
80106ab3:	6a 56                	push   $0x56
  jmp alltraps
80106ab5:	e9 a4 f7 ff ff       	jmp    8010625e <alltraps>

80106aba <vector87>:
.globl vector87
vector87:
  pushl $0
80106aba:	6a 00                	push   $0x0
  pushl $87
80106abc:	6a 57                	push   $0x57
  jmp alltraps
80106abe:	e9 9b f7 ff ff       	jmp    8010625e <alltraps>

80106ac3 <vector88>:
.globl vector88
vector88:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $88
80106ac5:	6a 58                	push   $0x58
  jmp alltraps
80106ac7:	e9 92 f7 ff ff       	jmp    8010625e <alltraps>

80106acc <vector89>:
.globl vector89
vector89:
  pushl $0
80106acc:	6a 00                	push   $0x0
  pushl $89
80106ace:	6a 59                	push   $0x59
  jmp alltraps
80106ad0:	e9 89 f7 ff ff       	jmp    8010625e <alltraps>

80106ad5 <vector90>:
.globl vector90
vector90:
  pushl $0
80106ad5:	6a 00                	push   $0x0
  pushl $90
80106ad7:	6a 5a                	push   $0x5a
  jmp alltraps
80106ad9:	e9 80 f7 ff ff       	jmp    8010625e <alltraps>

80106ade <vector91>:
.globl vector91
vector91:
  pushl $0
80106ade:	6a 00                	push   $0x0
  pushl $91
80106ae0:	6a 5b                	push   $0x5b
  jmp alltraps
80106ae2:	e9 77 f7 ff ff       	jmp    8010625e <alltraps>

80106ae7 <vector92>:
.globl vector92
vector92:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $92
80106ae9:	6a 5c                	push   $0x5c
  jmp alltraps
80106aeb:	e9 6e f7 ff ff       	jmp    8010625e <alltraps>

80106af0 <vector93>:
.globl vector93
vector93:
  pushl $0
80106af0:	6a 00                	push   $0x0
  pushl $93
80106af2:	6a 5d                	push   $0x5d
  jmp alltraps
80106af4:	e9 65 f7 ff ff       	jmp    8010625e <alltraps>

80106af9 <vector94>:
.globl vector94
vector94:
  pushl $0
80106af9:	6a 00                	push   $0x0
  pushl $94
80106afb:	6a 5e                	push   $0x5e
  jmp alltraps
80106afd:	e9 5c f7 ff ff       	jmp    8010625e <alltraps>

80106b02 <vector95>:
.globl vector95
vector95:
  pushl $0
80106b02:	6a 00                	push   $0x0
  pushl $95
80106b04:	6a 5f                	push   $0x5f
  jmp alltraps
80106b06:	e9 53 f7 ff ff       	jmp    8010625e <alltraps>

80106b0b <vector96>:
.globl vector96
vector96:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $96
80106b0d:	6a 60                	push   $0x60
  jmp alltraps
80106b0f:	e9 4a f7 ff ff       	jmp    8010625e <alltraps>

80106b14 <vector97>:
.globl vector97
vector97:
  pushl $0
80106b14:	6a 00                	push   $0x0
  pushl $97
80106b16:	6a 61                	push   $0x61
  jmp alltraps
80106b18:	e9 41 f7 ff ff       	jmp    8010625e <alltraps>

80106b1d <vector98>:
.globl vector98
vector98:
  pushl $0
80106b1d:	6a 00                	push   $0x0
  pushl $98
80106b1f:	6a 62                	push   $0x62
  jmp alltraps
80106b21:	e9 38 f7 ff ff       	jmp    8010625e <alltraps>

80106b26 <vector99>:
.globl vector99
vector99:
  pushl $0
80106b26:	6a 00                	push   $0x0
  pushl $99
80106b28:	6a 63                	push   $0x63
  jmp alltraps
80106b2a:	e9 2f f7 ff ff       	jmp    8010625e <alltraps>

80106b2f <vector100>:
.globl vector100
vector100:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $100
80106b31:	6a 64                	push   $0x64
  jmp alltraps
80106b33:	e9 26 f7 ff ff       	jmp    8010625e <alltraps>

80106b38 <vector101>:
.globl vector101
vector101:
  pushl $0
80106b38:	6a 00                	push   $0x0
  pushl $101
80106b3a:	6a 65                	push   $0x65
  jmp alltraps
80106b3c:	e9 1d f7 ff ff       	jmp    8010625e <alltraps>

80106b41 <vector102>:
.globl vector102
vector102:
  pushl $0
80106b41:	6a 00                	push   $0x0
  pushl $102
80106b43:	6a 66                	push   $0x66
  jmp alltraps
80106b45:	e9 14 f7 ff ff       	jmp    8010625e <alltraps>

80106b4a <vector103>:
.globl vector103
vector103:
  pushl $0
80106b4a:	6a 00                	push   $0x0
  pushl $103
80106b4c:	6a 67                	push   $0x67
  jmp alltraps
80106b4e:	e9 0b f7 ff ff       	jmp    8010625e <alltraps>

80106b53 <vector104>:
.globl vector104
vector104:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $104
80106b55:	6a 68                	push   $0x68
  jmp alltraps
80106b57:	e9 02 f7 ff ff       	jmp    8010625e <alltraps>

80106b5c <vector105>:
.globl vector105
vector105:
  pushl $0
80106b5c:	6a 00                	push   $0x0
  pushl $105
80106b5e:	6a 69                	push   $0x69
  jmp alltraps
80106b60:	e9 f9 f6 ff ff       	jmp    8010625e <alltraps>

80106b65 <vector106>:
.globl vector106
vector106:
  pushl $0
80106b65:	6a 00                	push   $0x0
  pushl $106
80106b67:	6a 6a                	push   $0x6a
  jmp alltraps
80106b69:	e9 f0 f6 ff ff       	jmp    8010625e <alltraps>

80106b6e <vector107>:
.globl vector107
vector107:
  pushl $0
80106b6e:	6a 00                	push   $0x0
  pushl $107
80106b70:	6a 6b                	push   $0x6b
  jmp alltraps
80106b72:	e9 e7 f6 ff ff       	jmp    8010625e <alltraps>

80106b77 <vector108>:
.globl vector108
vector108:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $108
80106b79:	6a 6c                	push   $0x6c
  jmp alltraps
80106b7b:	e9 de f6 ff ff       	jmp    8010625e <alltraps>

80106b80 <vector109>:
.globl vector109
vector109:
  pushl $0
80106b80:	6a 00                	push   $0x0
  pushl $109
80106b82:	6a 6d                	push   $0x6d
  jmp alltraps
80106b84:	e9 d5 f6 ff ff       	jmp    8010625e <alltraps>

80106b89 <vector110>:
.globl vector110
vector110:
  pushl $0
80106b89:	6a 00                	push   $0x0
  pushl $110
80106b8b:	6a 6e                	push   $0x6e
  jmp alltraps
80106b8d:	e9 cc f6 ff ff       	jmp    8010625e <alltraps>

80106b92 <vector111>:
.globl vector111
vector111:
  pushl $0
80106b92:	6a 00                	push   $0x0
  pushl $111
80106b94:	6a 6f                	push   $0x6f
  jmp alltraps
80106b96:	e9 c3 f6 ff ff       	jmp    8010625e <alltraps>

80106b9b <vector112>:
.globl vector112
vector112:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $112
80106b9d:	6a 70                	push   $0x70
  jmp alltraps
80106b9f:	e9 ba f6 ff ff       	jmp    8010625e <alltraps>

80106ba4 <vector113>:
.globl vector113
vector113:
  pushl $0
80106ba4:	6a 00                	push   $0x0
  pushl $113
80106ba6:	6a 71                	push   $0x71
  jmp alltraps
80106ba8:	e9 b1 f6 ff ff       	jmp    8010625e <alltraps>

80106bad <vector114>:
.globl vector114
vector114:
  pushl $0
80106bad:	6a 00                	push   $0x0
  pushl $114
80106baf:	6a 72                	push   $0x72
  jmp alltraps
80106bb1:	e9 a8 f6 ff ff       	jmp    8010625e <alltraps>

80106bb6 <vector115>:
.globl vector115
vector115:
  pushl $0
80106bb6:	6a 00                	push   $0x0
  pushl $115
80106bb8:	6a 73                	push   $0x73
  jmp alltraps
80106bba:	e9 9f f6 ff ff       	jmp    8010625e <alltraps>

80106bbf <vector116>:
.globl vector116
vector116:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $116
80106bc1:	6a 74                	push   $0x74
  jmp alltraps
80106bc3:	e9 96 f6 ff ff       	jmp    8010625e <alltraps>

80106bc8 <vector117>:
.globl vector117
vector117:
  pushl $0
80106bc8:	6a 00                	push   $0x0
  pushl $117
80106bca:	6a 75                	push   $0x75
  jmp alltraps
80106bcc:	e9 8d f6 ff ff       	jmp    8010625e <alltraps>

80106bd1 <vector118>:
.globl vector118
vector118:
  pushl $0
80106bd1:	6a 00                	push   $0x0
  pushl $118
80106bd3:	6a 76                	push   $0x76
  jmp alltraps
80106bd5:	e9 84 f6 ff ff       	jmp    8010625e <alltraps>

80106bda <vector119>:
.globl vector119
vector119:
  pushl $0
80106bda:	6a 00                	push   $0x0
  pushl $119
80106bdc:	6a 77                	push   $0x77
  jmp alltraps
80106bde:	e9 7b f6 ff ff       	jmp    8010625e <alltraps>

80106be3 <vector120>:
.globl vector120
vector120:
  pushl $0
80106be3:	6a 00                	push   $0x0
  pushl $120
80106be5:	6a 78                	push   $0x78
  jmp alltraps
80106be7:	e9 72 f6 ff ff       	jmp    8010625e <alltraps>

80106bec <vector121>:
.globl vector121
vector121:
  pushl $0
80106bec:	6a 00                	push   $0x0
  pushl $121
80106bee:	6a 79                	push   $0x79
  jmp alltraps
80106bf0:	e9 69 f6 ff ff       	jmp    8010625e <alltraps>

80106bf5 <vector122>:
.globl vector122
vector122:
  pushl $0
80106bf5:	6a 00                	push   $0x0
  pushl $122
80106bf7:	6a 7a                	push   $0x7a
  jmp alltraps
80106bf9:	e9 60 f6 ff ff       	jmp    8010625e <alltraps>

80106bfe <vector123>:
.globl vector123
vector123:
  pushl $0
80106bfe:	6a 00                	push   $0x0
  pushl $123
80106c00:	6a 7b                	push   $0x7b
  jmp alltraps
80106c02:	e9 57 f6 ff ff       	jmp    8010625e <alltraps>

80106c07 <vector124>:
.globl vector124
vector124:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $124
80106c09:	6a 7c                	push   $0x7c
  jmp alltraps
80106c0b:	e9 4e f6 ff ff       	jmp    8010625e <alltraps>

80106c10 <vector125>:
.globl vector125
vector125:
  pushl $0
80106c10:	6a 00                	push   $0x0
  pushl $125
80106c12:	6a 7d                	push   $0x7d
  jmp alltraps
80106c14:	e9 45 f6 ff ff       	jmp    8010625e <alltraps>

80106c19 <vector126>:
.globl vector126
vector126:
  pushl $0
80106c19:	6a 00                	push   $0x0
  pushl $126
80106c1b:	6a 7e                	push   $0x7e
  jmp alltraps
80106c1d:	e9 3c f6 ff ff       	jmp    8010625e <alltraps>

80106c22 <vector127>:
.globl vector127
vector127:
  pushl $0
80106c22:	6a 00                	push   $0x0
  pushl $127
80106c24:	6a 7f                	push   $0x7f
  jmp alltraps
80106c26:	e9 33 f6 ff ff       	jmp    8010625e <alltraps>

80106c2b <vector128>:
.globl vector128
vector128:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $128
80106c2d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106c32:	e9 27 f6 ff ff       	jmp    8010625e <alltraps>

80106c37 <vector129>:
.globl vector129
vector129:
  pushl $0
80106c37:	6a 00                	push   $0x0
  pushl $129
80106c39:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106c3e:	e9 1b f6 ff ff       	jmp    8010625e <alltraps>

80106c43 <vector130>:
.globl vector130
vector130:
  pushl $0
80106c43:	6a 00                	push   $0x0
  pushl $130
80106c45:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106c4a:	e9 0f f6 ff ff       	jmp    8010625e <alltraps>

80106c4f <vector131>:
.globl vector131
vector131:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $131
80106c51:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106c56:	e9 03 f6 ff ff       	jmp    8010625e <alltraps>

80106c5b <vector132>:
.globl vector132
vector132:
  pushl $0
80106c5b:	6a 00                	push   $0x0
  pushl $132
80106c5d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106c62:	e9 f7 f5 ff ff       	jmp    8010625e <alltraps>

80106c67 <vector133>:
.globl vector133
vector133:
  pushl $0
80106c67:	6a 00                	push   $0x0
  pushl $133
80106c69:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106c6e:	e9 eb f5 ff ff       	jmp    8010625e <alltraps>

80106c73 <vector134>:
.globl vector134
vector134:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $134
80106c75:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106c7a:	e9 df f5 ff ff       	jmp    8010625e <alltraps>

80106c7f <vector135>:
.globl vector135
vector135:
  pushl $0
80106c7f:	6a 00                	push   $0x0
  pushl $135
80106c81:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106c86:	e9 d3 f5 ff ff       	jmp    8010625e <alltraps>

80106c8b <vector136>:
.globl vector136
vector136:
  pushl $0
80106c8b:	6a 00                	push   $0x0
  pushl $136
80106c8d:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106c92:	e9 c7 f5 ff ff       	jmp    8010625e <alltraps>

80106c97 <vector137>:
.globl vector137
vector137:
  pushl $0
80106c97:	6a 00                	push   $0x0
  pushl $137
80106c99:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106c9e:	e9 bb f5 ff ff       	jmp    8010625e <alltraps>

80106ca3 <vector138>:
.globl vector138
vector138:
  pushl $0
80106ca3:	6a 00                	push   $0x0
  pushl $138
80106ca5:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106caa:	e9 af f5 ff ff       	jmp    8010625e <alltraps>

80106caf <vector139>:
.globl vector139
vector139:
  pushl $0
80106caf:	6a 00                	push   $0x0
  pushl $139
80106cb1:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106cb6:	e9 a3 f5 ff ff       	jmp    8010625e <alltraps>

80106cbb <vector140>:
.globl vector140
vector140:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $140
80106cbd:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106cc2:	e9 97 f5 ff ff       	jmp    8010625e <alltraps>

80106cc7 <vector141>:
.globl vector141
vector141:
  pushl $0
80106cc7:	6a 00                	push   $0x0
  pushl $141
80106cc9:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106cce:	e9 8b f5 ff ff       	jmp    8010625e <alltraps>

80106cd3 <vector142>:
.globl vector142
vector142:
  pushl $0
80106cd3:	6a 00                	push   $0x0
  pushl $142
80106cd5:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106cda:	e9 7f f5 ff ff       	jmp    8010625e <alltraps>

80106cdf <vector143>:
.globl vector143
vector143:
  pushl $0
80106cdf:	6a 00                	push   $0x0
  pushl $143
80106ce1:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106ce6:	e9 73 f5 ff ff       	jmp    8010625e <alltraps>

80106ceb <vector144>:
.globl vector144
vector144:
  pushl $0
80106ceb:	6a 00                	push   $0x0
  pushl $144
80106ced:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106cf2:	e9 67 f5 ff ff       	jmp    8010625e <alltraps>

80106cf7 <vector145>:
.globl vector145
vector145:
  pushl $0
80106cf7:	6a 00                	push   $0x0
  pushl $145
80106cf9:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106cfe:	e9 5b f5 ff ff       	jmp    8010625e <alltraps>

80106d03 <vector146>:
.globl vector146
vector146:
  pushl $0
80106d03:	6a 00                	push   $0x0
  pushl $146
80106d05:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106d0a:	e9 4f f5 ff ff       	jmp    8010625e <alltraps>

80106d0f <vector147>:
.globl vector147
vector147:
  pushl $0
80106d0f:	6a 00                	push   $0x0
  pushl $147
80106d11:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106d16:	e9 43 f5 ff ff       	jmp    8010625e <alltraps>

80106d1b <vector148>:
.globl vector148
vector148:
  pushl $0
80106d1b:	6a 00                	push   $0x0
  pushl $148
80106d1d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106d22:	e9 37 f5 ff ff       	jmp    8010625e <alltraps>

80106d27 <vector149>:
.globl vector149
vector149:
  pushl $0
80106d27:	6a 00                	push   $0x0
  pushl $149
80106d29:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106d2e:	e9 2b f5 ff ff       	jmp    8010625e <alltraps>

80106d33 <vector150>:
.globl vector150
vector150:
  pushl $0
80106d33:	6a 00                	push   $0x0
  pushl $150
80106d35:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106d3a:	e9 1f f5 ff ff       	jmp    8010625e <alltraps>

80106d3f <vector151>:
.globl vector151
vector151:
  pushl $0
80106d3f:	6a 00                	push   $0x0
  pushl $151
80106d41:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106d46:	e9 13 f5 ff ff       	jmp    8010625e <alltraps>

80106d4b <vector152>:
.globl vector152
vector152:
  pushl $0
80106d4b:	6a 00                	push   $0x0
  pushl $152
80106d4d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106d52:	e9 07 f5 ff ff       	jmp    8010625e <alltraps>

80106d57 <vector153>:
.globl vector153
vector153:
  pushl $0
80106d57:	6a 00                	push   $0x0
  pushl $153
80106d59:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106d5e:	e9 fb f4 ff ff       	jmp    8010625e <alltraps>

80106d63 <vector154>:
.globl vector154
vector154:
  pushl $0
80106d63:	6a 00                	push   $0x0
  pushl $154
80106d65:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106d6a:	e9 ef f4 ff ff       	jmp    8010625e <alltraps>

80106d6f <vector155>:
.globl vector155
vector155:
  pushl $0
80106d6f:	6a 00                	push   $0x0
  pushl $155
80106d71:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106d76:	e9 e3 f4 ff ff       	jmp    8010625e <alltraps>

80106d7b <vector156>:
.globl vector156
vector156:
  pushl $0
80106d7b:	6a 00                	push   $0x0
  pushl $156
80106d7d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106d82:	e9 d7 f4 ff ff       	jmp    8010625e <alltraps>

80106d87 <vector157>:
.globl vector157
vector157:
  pushl $0
80106d87:	6a 00                	push   $0x0
  pushl $157
80106d89:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106d8e:	e9 cb f4 ff ff       	jmp    8010625e <alltraps>

80106d93 <vector158>:
.globl vector158
vector158:
  pushl $0
80106d93:	6a 00                	push   $0x0
  pushl $158
80106d95:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106d9a:	e9 bf f4 ff ff       	jmp    8010625e <alltraps>

80106d9f <vector159>:
.globl vector159
vector159:
  pushl $0
80106d9f:	6a 00                	push   $0x0
  pushl $159
80106da1:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106da6:	e9 b3 f4 ff ff       	jmp    8010625e <alltraps>

80106dab <vector160>:
.globl vector160
vector160:
  pushl $0
80106dab:	6a 00                	push   $0x0
  pushl $160
80106dad:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106db2:	e9 a7 f4 ff ff       	jmp    8010625e <alltraps>

80106db7 <vector161>:
.globl vector161
vector161:
  pushl $0
80106db7:	6a 00                	push   $0x0
  pushl $161
80106db9:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106dbe:	e9 9b f4 ff ff       	jmp    8010625e <alltraps>

80106dc3 <vector162>:
.globl vector162
vector162:
  pushl $0
80106dc3:	6a 00                	push   $0x0
  pushl $162
80106dc5:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106dca:	e9 8f f4 ff ff       	jmp    8010625e <alltraps>

80106dcf <vector163>:
.globl vector163
vector163:
  pushl $0
80106dcf:	6a 00                	push   $0x0
  pushl $163
80106dd1:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106dd6:	e9 83 f4 ff ff       	jmp    8010625e <alltraps>

80106ddb <vector164>:
.globl vector164
vector164:
  pushl $0
80106ddb:	6a 00                	push   $0x0
  pushl $164
80106ddd:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106de2:	e9 77 f4 ff ff       	jmp    8010625e <alltraps>

80106de7 <vector165>:
.globl vector165
vector165:
  pushl $0
80106de7:	6a 00                	push   $0x0
  pushl $165
80106de9:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106dee:	e9 6b f4 ff ff       	jmp    8010625e <alltraps>

80106df3 <vector166>:
.globl vector166
vector166:
  pushl $0
80106df3:	6a 00                	push   $0x0
  pushl $166
80106df5:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106dfa:	e9 5f f4 ff ff       	jmp    8010625e <alltraps>

80106dff <vector167>:
.globl vector167
vector167:
  pushl $0
80106dff:	6a 00                	push   $0x0
  pushl $167
80106e01:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106e06:	e9 53 f4 ff ff       	jmp    8010625e <alltraps>

80106e0b <vector168>:
.globl vector168
vector168:
  pushl $0
80106e0b:	6a 00                	push   $0x0
  pushl $168
80106e0d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106e12:	e9 47 f4 ff ff       	jmp    8010625e <alltraps>

80106e17 <vector169>:
.globl vector169
vector169:
  pushl $0
80106e17:	6a 00                	push   $0x0
  pushl $169
80106e19:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106e1e:	e9 3b f4 ff ff       	jmp    8010625e <alltraps>

80106e23 <vector170>:
.globl vector170
vector170:
  pushl $0
80106e23:	6a 00                	push   $0x0
  pushl $170
80106e25:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106e2a:	e9 2f f4 ff ff       	jmp    8010625e <alltraps>

80106e2f <vector171>:
.globl vector171
vector171:
  pushl $0
80106e2f:	6a 00                	push   $0x0
  pushl $171
80106e31:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106e36:	e9 23 f4 ff ff       	jmp    8010625e <alltraps>

80106e3b <vector172>:
.globl vector172
vector172:
  pushl $0
80106e3b:	6a 00                	push   $0x0
  pushl $172
80106e3d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106e42:	e9 17 f4 ff ff       	jmp    8010625e <alltraps>

80106e47 <vector173>:
.globl vector173
vector173:
  pushl $0
80106e47:	6a 00                	push   $0x0
  pushl $173
80106e49:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106e4e:	e9 0b f4 ff ff       	jmp    8010625e <alltraps>

80106e53 <vector174>:
.globl vector174
vector174:
  pushl $0
80106e53:	6a 00                	push   $0x0
  pushl $174
80106e55:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106e5a:	e9 ff f3 ff ff       	jmp    8010625e <alltraps>

80106e5f <vector175>:
.globl vector175
vector175:
  pushl $0
80106e5f:	6a 00                	push   $0x0
  pushl $175
80106e61:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106e66:	e9 f3 f3 ff ff       	jmp    8010625e <alltraps>

80106e6b <vector176>:
.globl vector176
vector176:
  pushl $0
80106e6b:	6a 00                	push   $0x0
  pushl $176
80106e6d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106e72:	e9 e7 f3 ff ff       	jmp    8010625e <alltraps>

80106e77 <vector177>:
.globl vector177
vector177:
  pushl $0
80106e77:	6a 00                	push   $0x0
  pushl $177
80106e79:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106e7e:	e9 db f3 ff ff       	jmp    8010625e <alltraps>

80106e83 <vector178>:
.globl vector178
vector178:
  pushl $0
80106e83:	6a 00                	push   $0x0
  pushl $178
80106e85:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106e8a:	e9 cf f3 ff ff       	jmp    8010625e <alltraps>

80106e8f <vector179>:
.globl vector179
vector179:
  pushl $0
80106e8f:	6a 00                	push   $0x0
  pushl $179
80106e91:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106e96:	e9 c3 f3 ff ff       	jmp    8010625e <alltraps>

80106e9b <vector180>:
.globl vector180
vector180:
  pushl $0
80106e9b:	6a 00                	push   $0x0
  pushl $180
80106e9d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106ea2:	e9 b7 f3 ff ff       	jmp    8010625e <alltraps>

80106ea7 <vector181>:
.globl vector181
vector181:
  pushl $0
80106ea7:	6a 00                	push   $0x0
  pushl $181
80106ea9:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106eae:	e9 ab f3 ff ff       	jmp    8010625e <alltraps>

80106eb3 <vector182>:
.globl vector182
vector182:
  pushl $0
80106eb3:	6a 00                	push   $0x0
  pushl $182
80106eb5:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106eba:	e9 9f f3 ff ff       	jmp    8010625e <alltraps>

80106ebf <vector183>:
.globl vector183
vector183:
  pushl $0
80106ebf:	6a 00                	push   $0x0
  pushl $183
80106ec1:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106ec6:	e9 93 f3 ff ff       	jmp    8010625e <alltraps>

80106ecb <vector184>:
.globl vector184
vector184:
  pushl $0
80106ecb:	6a 00                	push   $0x0
  pushl $184
80106ecd:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106ed2:	e9 87 f3 ff ff       	jmp    8010625e <alltraps>

80106ed7 <vector185>:
.globl vector185
vector185:
  pushl $0
80106ed7:	6a 00                	push   $0x0
  pushl $185
80106ed9:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106ede:	e9 7b f3 ff ff       	jmp    8010625e <alltraps>

80106ee3 <vector186>:
.globl vector186
vector186:
  pushl $0
80106ee3:	6a 00                	push   $0x0
  pushl $186
80106ee5:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106eea:	e9 6f f3 ff ff       	jmp    8010625e <alltraps>

80106eef <vector187>:
.globl vector187
vector187:
  pushl $0
80106eef:	6a 00                	push   $0x0
  pushl $187
80106ef1:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106ef6:	e9 63 f3 ff ff       	jmp    8010625e <alltraps>

80106efb <vector188>:
.globl vector188
vector188:
  pushl $0
80106efb:	6a 00                	push   $0x0
  pushl $188
80106efd:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106f02:	e9 57 f3 ff ff       	jmp    8010625e <alltraps>

80106f07 <vector189>:
.globl vector189
vector189:
  pushl $0
80106f07:	6a 00                	push   $0x0
  pushl $189
80106f09:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106f0e:	e9 4b f3 ff ff       	jmp    8010625e <alltraps>

80106f13 <vector190>:
.globl vector190
vector190:
  pushl $0
80106f13:	6a 00                	push   $0x0
  pushl $190
80106f15:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106f1a:	e9 3f f3 ff ff       	jmp    8010625e <alltraps>

80106f1f <vector191>:
.globl vector191
vector191:
  pushl $0
80106f1f:	6a 00                	push   $0x0
  pushl $191
80106f21:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106f26:	e9 33 f3 ff ff       	jmp    8010625e <alltraps>

80106f2b <vector192>:
.globl vector192
vector192:
  pushl $0
80106f2b:	6a 00                	push   $0x0
  pushl $192
80106f2d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106f32:	e9 27 f3 ff ff       	jmp    8010625e <alltraps>

80106f37 <vector193>:
.globl vector193
vector193:
  pushl $0
80106f37:	6a 00                	push   $0x0
  pushl $193
80106f39:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106f3e:	e9 1b f3 ff ff       	jmp    8010625e <alltraps>

80106f43 <vector194>:
.globl vector194
vector194:
  pushl $0
80106f43:	6a 00                	push   $0x0
  pushl $194
80106f45:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106f4a:	e9 0f f3 ff ff       	jmp    8010625e <alltraps>

80106f4f <vector195>:
.globl vector195
vector195:
  pushl $0
80106f4f:	6a 00                	push   $0x0
  pushl $195
80106f51:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106f56:	e9 03 f3 ff ff       	jmp    8010625e <alltraps>

80106f5b <vector196>:
.globl vector196
vector196:
  pushl $0
80106f5b:	6a 00                	push   $0x0
  pushl $196
80106f5d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106f62:	e9 f7 f2 ff ff       	jmp    8010625e <alltraps>

80106f67 <vector197>:
.globl vector197
vector197:
  pushl $0
80106f67:	6a 00                	push   $0x0
  pushl $197
80106f69:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106f6e:	e9 eb f2 ff ff       	jmp    8010625e <alltraps>

80106f73 <vector198>:
.globl vector198
vector198:
  pushl $0
80106f73:	6a 00                	push   $0x0
  pushl $198
80106f75:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106f7a:	e9 df f2 ff ff       	jmp    8010625e <alltraps>

80106f7f <vector199>:
.globl vector199
vector199:
  pushl $0
80106f7f:	6a 00                	push   $0x0
  pushl $199
80106f81:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106f86:	e9 d3 f2 ff ff       	jmp    8010625e <alltraps>

80106f8b <vector200>:
.globl vector200
vector200:
  pushl $0
80106f8b:	6a 00                	push   $0x0
  pushl $200
80106f8d:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106f92:	e9 c7 f2 ff ff       	jmp    8010625e <alltraps>

80106f97 <vector201>:
.globl vector201
vector201:
  pushl $0
80106f97:	6a 00                	push   $0x0
  pushl $201
80106f99:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106f9e:	e9 bb f2 ff ff       	jmp    8010625e <alltraps>

80106fa3 <vector202>:
.globl vector202
vector202:
  pushl $0
80106fa3:	6a 00                	push   $0x0
  pushl $202
80106fa5:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106faa:	e9 af f2 ff ff       	jmp    8010625e <alltraps>

80106faf <vector203>:
.globl vector203
vector203:
  pushl $0
80106faf:	6a 00                	push   $0x0
  pushl $203
80106fb1:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106fb6:	e9 a3 f2 ff ff       	jmp    8010625e <alltraps>

80106fbb <vector204>:
.globl vector204
vector204:
  pushl $0
80106fbb:	6a 00                	push   $0x0
  pushl $204
80106fbd:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106fc2:	e9 97 f2 ff ff       	jmp    8010625e <alltraps>

80106fc7 <vector205>:
.globl vector205
vector205:
  pushl $0
80106fc7:	6a 00                	push   $0x0
  pushl $205
80106fc9:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106fce:	e9 8b f2 ff ff       	jmp    8010625e <alltraps>

80106fd3 <vector206>:
.globl vector206
vector206:
  pushl $0
80106fd3:	6a 00                	push   $0x0
  pushl $206
80106fd5:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106fda:	e9 7f f2 ff ff       	jmp    8010625e <alltraps>

80106fdf <vector207>:
.globl vector207
vector207:
  pushl $0
80106fdf:	6a 00                	push   $0x0
  pushl $207
80106fe1:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106fe6:	e9 73 f2 ff ff       	jmp    8010625e <alltraps>

80106feb <vector208>:
.globl vector208
vector208:
  pushl $0
80106feb:	6a 00                	push   $0x0
  pushl $208
80106fed:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106ff2:	e9 67 f2 ff ff       	jmp    8010625e <alltraps>

80106ff7 <vector209>:
.globl vector209
vector209:
  pushl $0
80106ff7:	6a 00                	push   $0x0
  pushl $209
80106ff9:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106ffe:	e9 5b f2 ff ff       	jmp    8010625e <alltraps>

80107003 <vector210>:
.globl vector210
vector210:
  pushl $0
80107003:	6a 00                	push   $0x0
  pushl $210
80107005:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
8010700a:	e9 4f f2 ff ff       	jmp    8010625e <alltraps>

8010700f <vector211>:
.globl vector211
vector211:
  pushl $0
8010700f:	6a 00                	push   $0x0
  pushl $211
80107011:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107016:	e9 43 f2 ff ff       	jmp    8010625e <alltraps>

8010701b <vector212>:
.globl vector212
vector212:
  pushl $0
8010701b:	6a 00                	push   $0x0
  pushl $212
8010701d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107022:	e9 37 f2 ff ff       	jmp    8010625e <alltraps>

80107027 <vector213>:
.globl vector213
vector213:
  pushl $0
80107027:	6a 00                	push   $0x0
  pushl $213
80107029:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010702e:	e9 2b f2 ff ff       	jmp    8010625e <alltraps>

80107033 <vector214>:
.globl vector214
vector214:
  pushl $0
80107033:	6a 00                	push   $0x0
  pushl $214
80107035:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
8010703a:	e9 1f f2 ff ff       	jmp    8010625e <alltraps>

8010703f <vector215>:
.globl vector215
vector215:
  pushl $0
8010703f:	6a 00                	push   $0x0
  pushl $215
80107041:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107046:	e9 13 f2 ff ff       	jmp    8010625e <alltraps>

8010704b <vector216>:
.globl vector216
vector216:
  pushl $0
8010704b:	6a 00                	push   $0x0
  pushl $216
8010704d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107052:	e9 07 f2 ff ff       	jmp    8010625e <alltraps>

80107057 <vector217>:
.globl vector217
vector217:
  pushl $0
80107057:	6a 00                	push   $0x0
  pushl $217
80107059:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010705e:	e9 fb f1 ff ff       	jmp    8010625e <alltraps>

80107063 <vector218>:
.globl vector218
vector218:
  pushl $0
80107063:	6a 00                	push   $0x0
  pushl $218
80107065:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010706a:	e9 ef f1 ff ff       	jmp    8010625e <alltraps>

8010706f <vector219>:
.globl vector219
vector219:
  pushl $0
8010706f:	6a 00                	push   $0x0
  pushl $219
80107071:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107076:	e9 e3 f1 ff ff       	jmp    8010625e <alltraps>

8010707b <vector220>:
.globl vector220
vector220:
  pushl $0
8010707b:	6a 00                	push   $0x0
  pushl $220
8010707d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107082:	e9 d7 f1 ff ff       	jmp    8010625e <alltraps>

80107087 <vector221>:
.globl vector221
vector221:
  pushl $0
80107087:	6a 00                	push   $0x0
  pushl $221
80107089:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010708e:	e9 cb f1 ff ff       	jmp    8010625e <alltraps>

80107093 <vector222>:
.globl vector222
vector222:
  pushl $0
80107093:	6a 00                	push   $0x0
  pushl $222
80107095:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010709a:	e9 bf f1 ff ff       	jmp    8010625e <alltraps>

8010709f <vector223>:
.globl vector223
vector223:
  pushl $0
8010709f:	6a 00                	push   $0x0
  pushl $223
801070a1:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801070a6:	e9 b3 f1 ff ff       	jmp    8010625e <alltraps>

801070ab <vector224>:
.globl vector224
vector224:
  pushl $0
801070ab:	6a 00                	push   $0x0
  pushl $224
801070ad:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801070b2:	e9 a7 f1 ff ff       	jmp    8010625e <alltraps>

801070b7 <vector225>:
.globl vector225
vector225:
  pushl $0
801070b7:	6a 00                	push   $0x0
  pushl $225
801070b9:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801070be:	e9 9b f1 ff ff       	jmp    8010625e <alltraps>

801070c3 <vector226>:
.globl vector226
vector226:
  pushl $0
801070c3:	6a 00                	push   $0x0
  pushl $226
801070c5:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801070ca:	e9 8f f1 ff ff       	jmp    8010625e <alltraps>

801070cf <vector227>:
.globl vector227
vector227:
  pushl $0
801070cf:	6a 00                	push   $0x0
  pushl $227
801070d1:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801070d6:	e9 83 f1 ff ff       	jmp    8010625e <alltraps>

801070db <vector228>:
.globl vector228
vector228:
  pushl $0
801070db:	6a 00                	push   $0x0
  pushl $228
801070dd:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801070e2:	e9 77 f1 ff ff       	jmp    8010625e <alltraps>

801070e7 <vector229>:
.globl vector229
vector229:
  pushl $0
801070e7:	6a 00                	push   $0x0
  pushl $229
801070e9:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801070ee:	e9 6b f1 ff ff       	jmp    8010625e <alltraps>

801070f3 <vector230>:
.globl vector230
vector230:
  pushl $0
801070f3:	6a 00                	push   $0x0
  pushl $230
801070f5:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801070fa:	e9 5f f1 ff ff       	jmp    8010625e <alltraps>

801070ff <vector231>:
.globl vector231
vector231:
  pushl $0
801070ff:	6a 00                	push   $0x0
  pushl $231
80107101:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107106:	e9 53 f1 ff ff       	jmp    8010625e <alltraps>

8010710b <vector232>:
.globl vector232
vector232:
  pushl $0
8010710b:	6a 00                	push   $0x0
  pushl $232
8010710d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107112:	e9 47 f1 ff ff       	jmp    8010625e <alltraps>

80107117 <vector233>:
.globl vector233
vector233:
  pushl $0
80107117:	6a 00                	push   $0x0
  pushl $233
80107119:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010711e:	e9 3b f1 ff ff       	jmp    8010625e <alltraps>

80107123 <vector234>:
.globl vector234
vector234:
  pushl $0
80107123:	6a 00                	push   $0x0
  pushl $234
80107125:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
8010712a:	e9 2f f1 ff ff       	jmp    8010625e <alltraps>

8010712f <vector235>:
.globl vector235
vector235:
  pushl $0
8010712f:	6a 00                	push   $0x0
  pushl $235
80107131:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107136:	e9 23 f1 ff ff       	jmp    8010625e <alltraps>

8010713b <vector236>:
.globl vector236
vector236:
  pushl $0
8010713b:	6a 00                	push   $0x0
  pushl $236
8010713d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107142:	e9 17 f1 ff ff       	jmp    8010625e <alltraps>

80107147 <vector237>:
.globl vector237
vector237:
  pushl $0
80107147:	6a 00                	push   $0x0
  pushl $237
80107149:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010714e:	e9 0b f1 ff ff       	jmp    8010625e <alltraps>

80107153 <vector238>:
.globl vector238
vector238:
  pushl $0
80107153:	6a 00                	push   $0x0
  pushl $238
80107155:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
8010715a:	e9 ff f0 ff ff       	jmp    8010625e <alltraps>

8010715f <vector239>:
.globl vector239
vector239:
  pushl $0
8010715f:	6a 00                	push   $0x0
  pushl $239
80107161:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107166:	e9 f3 f0 ff ff       	jmp    8010625e <alltraps>

8010716b <vector240>:
.globl vector240
vector240:
  pushl $0
8010716b:	6a 00                	push   $0x0
  pushl $240
8010716d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107172:	e9 e7 f0 ff ff       	jmp    8010625e <alltraps>

80107177 <vector241>:
.globl vector241
vector241:
  pushl $0
80107177:	6a 00                	push   $0x0
  pushl $241
80107179:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010717e:	e9 db f0 ff ff       	jmp    8010625e <alltraps>

80107183 <vector242>:
.globl vector242
vector242:
  pushl $0
80107183:	6a 00                	push   $0x0
  pushl $242
80107185:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
8010718a:	e9 cf f0 ff ff       	jmp    8010625e <alltraps>

8010718f <vector243>:
.globl vector243
vector243:
  pushl $0
8010718f:	6a 00                	push   $0x0
  pushl $243
80107191:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107196:	e9 c3 f0 ff ff       	jmp    8010625e <alltraps>

8010719b <vector244>:
.globl vector244
vector244:
  pushl $0
8010719b:	6a 00                	push   $0x0
  pushl $244
8010719d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801071a2:	e9 b7 f0 ff ff       	jmp    8010625e <alltraps>

801071a7 <vector245>:
.globl vector245
vector245:
  pushl $0
801071a7:	6a 00                	push   $0x0
  pushl $245
801071a9:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801071ae:	e9 ab f0 ff ff       	jmp    8010625e <alltraps>

801071b3 <vector246>:
.globl vector246
vector246:
  pushl $0
801071b3:	6a 00                	push   $0x0
  pushl $246
801071b5:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801071ba:	e9 9f f0 ff ff       	jmp    8010625e <alltraps>

801071bf <vector247>:
.globl vector247
vector247:
  pushl $0
801071bf:	6a 00                	push   $0x0
  pushl $247
801071c1:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801071c6:	e9 93 f0 ff ff       	jmp    8010625e <alltraps>

801071cb <vector248>:
.globl vector248
vector248:
  pushl $0
801071cb:	6a 00                	push   $0x0
  pushl $248
801071cd:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801071d2:	e9 87 f0 ff ff       	jmp    8010625e <alltraps>

801071d7 <vector249>:
.globl vector249
vector249:
  pushl $0
801071d7:	6a 00                	push   $0x0
  pushl $249
801071d9:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801071de:	e9 7b f0 ff ff       	jmp    8010625e <alltraps>

801071e3 <vector250>:
.globl vector250
vector250:
  pushl $0
801071e3:	6a 00                	push   $0x0
  pushl $250
801071e5:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801071ea:	e9 6f f0 ff ff       	jmp    8010625e <alltraps>

801071ef <vector251>:
.globl vector251
vector251:
  pushl $0
801071ef:	6a 00                	push   $0x0
  pushl $251
801071f1:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801071f6:	e9 63 f0 ff ff       	jmp    8010625e <alltraps>

801071fb <vector252>:
.globl vector252
vector252:
  pushl $0
801071fb:	6a 00                	push   $0x0
  pushl $252
801071fd:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107202:	e9 57 f0 ff ff       	jmp    8010625e <alltraps>

80107207 <vector253>:
.globl vector253
vector253:
  pushl $0
80107207:	6a 00                	push   $0x0
  pushl $253
80107209:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010720e:	e9 4b f0 ff ff       	jmp    8010625e <alltraps>

80107213 <vector254>:
.globl vector254
vector254:
  pushl $0
80107213:	6a 00                	push   $0x0
  pushl $254
80107215:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
8010721a:	e9 3f f0 ff ff       	jmp    8010625e <alltraps>

8010721f <vector255>:
.globl vector255
vector255:
  pushl $0
8010721f:	6a 00                	push   $0x0
  pushl $255
80107221:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107226:	e9 33 f0 ff ff       	jmp    8010625e <alltraps>
8010722b:	66 90                	xchg   %ax,%ax
8010722d:	66 90                	xchg   %ax,%ax
8010722f:	90                   	nop

80107230 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107230:	55                   	push   %ebp
80107231:	89 e5                	mov    %esp,%ebp
80107233:	57                   	push   %edi
80107234:	56                   	push   %esi
80107235:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107237:	c1 ea 16             	shr    $0x16,%edx
{
8010723a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
8010723b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
8010723e:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80107241:	8b 1f                	mov    (%edi),%ebx
80107243:	f6 c3 01             	test   $0x1,%bl
80107246:	74 28                	je     80107270 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107248:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010724e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107254:	89 f0                	mov    %esi,%eax
}
80107256:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80107259:	c1 e8 0a             	shr    $0xa,%eax
8010725c:	25 fc 0f 00 00       	and    $0xffc,%eax
80107261:	01 d8                	add    %ebx,%eax
}
80107263:	5b                   	pop    %ebx
80107264:	5e                   	pop    %esi
80107265:	5f                   	pop    %edi
80107266:	5d                   	pop    %ebp
80107267:	c3                   	ret    
80107268:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010726f:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107270:	85 c9                	test   %ecx,%ecx
80107272:	74 2c                	je     801072a0 <walkpgdir+0x70>
80107274:	e8 f7 ba ff ff       	call   80102d70 <kalloc>
80107279:	89 c3                	mov    %eax,%ebx
8010727b:	85 c0                	test   %eax,%eax
8010727d:	74 21                	je     801072a0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010727f:	83 ec 04             	sub    $0x4,%esp
80107282:	68 00 10 00 00       	push   $0x1000
80107287:	6a 00                	push   $0x0
80107289:	50                   	push   %eax
8010728a:	e8 b1 dd ff ff       	call   80105040 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010728f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107295:	83 c4 10             	add    $0x10,%esp
80107298:	83 c8 07             	or     $0x7,%eax
8010729b:	89 07                	mov    %eax,(%edi)
8010729d:	eb b5                	jmp    80107254 <walkpgdir+0x24>
8010729f:	90                   	nop
}
801072a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801072a3:	31 c0                	xor    %eax,%eax
}
801072a5:	5b                   	pop    %ebx
801072a6:	5e                   	pop    %esi
801072a7:	5f                   	pop    %edi
801072a8:	5d                   	pop    %ebp
801072a9:	c3                   	ret    
801072aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801072b0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801072b0:	55                   	push   %ebp
801072b1:	89 e5                	mov    %esp,%ebp
801072b3:	57                   	push   %edi
801072b4:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801072b6:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
801072ba:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801072bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
801072c0:	89 d6                	mov    %edx,%esi
{
801072c2:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
801072c3:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
801072c9:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801072cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
801072cf:	8b 45 08             	mov    0x8(%ebp),%eax
801072d2:	29 f0                	sub    %esi,%eax
801072d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801072d7:	eb 1f                	jmp    801072f8 <mappages+0x48>
801072d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
801072e0:	f6 00 01             	testb  $0x1,(%eax)
801072e3:	75 45                	jne    8010732a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
801072e5:	0b 5d 0c             	or     0xc(%ebp),%ebx
801072e8:	83 cb 01             	or     $0x1,%ebx
801072eb:	89 18                	mov    %ebx,(%eax)
    if(a == last)
801072ed:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801072f0:	74 2e                	je     80107320 <mappages+0x70>
      break;
    a += PGSIZE;
801072f2:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
801072f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801072fb:	b9 01 00 00 00       	mov    $0x1,%ecx
80107300:	89 f2                	mov    %esi,%edx
80107302:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80107305:	89 f8                	mov    %edi,%eax
80107307:	e8 24 ff ff ff       	call   80107230 <walkpgdir>
8010730c:	85 c0                	test   %eax,%eax
8010730e:	75 d0                	jne    801072e0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80107310:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107313:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107318:	5b                   	pop    %ebx
80107319:	5e                   	pop    %esi
8010731a:	5f                   	pop    %edi
8010731b:	5d                   	pop    %ebp
8010731c:	c3                   	ret    
8010731d:	8d 76 00             	lea    0x0(%esi),%esi
80107320:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107323:	31 c0                	xor    %eax,%eax
}
80107325:	5b                   	pop    %ebx
80107326:	5e                   	pop    %esi
80107327:	5f                   	pop    %edi
80107328:	5d                   	pop    %ebp
80107329:	c3                   	ret    
      panic("remap");
8010732a:	83 ec 0c             	sub    $0xc,%esp
8010732d:	68 74 89 10 80       	push   $0x80108974
80107332:	e8 59 90 ff ff       	call   80100390 <panic>
80107337:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010733e:	66 90                	xchg   %ax,%ax

80107340 <find_page_to_swap>:
struct pageinfo* find_page_to_swap(struct proc* p){
80107340:	f3 0f 1e fb          	endbr32 
80107344:	55                   	push   %ebp
80107345:	89 e5                	mov    %esp,%ebp
80107347:	57                   	push   %edi
80107348:	56                   	push   %esi
80107349:	53                   	push   %ebx
8010734a:	83 ec 1c             	sub    $0x1c,%esp
8010734d:	8b 75 08             	mov    0x8(%ebp),%esi
80107350:	8d 86 00 02 00 00    	lea    0x200(%esi),%eax
80107356:	8d 9e 80 03 00 00    	lea    0x380(%esi),%ebx
8010735c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010735f:	90                   	nop
    for (int i = 0; i < MAX_PYSC_PAGES; i++){
80107360:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    struct pageinfo* min_pi = 0;
80107363:	31 ff                	xor    %edi,%edi
    uint min = 0xFFFFFFFF;
80107365:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
8010736a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if (!pi->is_free && pi->page_index < min){
80107370:	8b 10                	mov    (%eax),%edx
80107372:	85 d2                	test   %edx,%edx
80107374:	75 0b                	jne    80107381 <find_page_to_swap+0x41>
80107376:	8b 50 0c             	mov    0xc(%eax),%edx
80107379:	39 ca                	cmp    %ecx,%edx
8010737b:	73 04                	jae    80107381 <find_page_to_swap+0x41>
8010737d:	89 c7                	mov    %eax,%edi
8010737f:	89 d1                	mov    %edx,%ecx
    for (int i = 0; i < MAX_PYSC_PAGES; i++){
80107381:	83 c0 18             	add    $0x18,%eax
80107384:	39 c3                	cmp    %eax,%ebx
80107386:	75 e8                	jne    80107370 <find_page_to_swap+0x30>
    pte_t* pte = walkpgdir(p->pgdir, min_pi, 0);\
80107388:	8b 46 04             	mov    0x4(%esi),%eax
8010738b:	31 c9                	xor    %ecx,%ecx
8010738d:	89 fa                	mov    %edi,%edx
8010738f:	e8 9c fe ff ff       	call   80107230 <walkpgdir>
    if (*pte & PTE_A){
80107394:	f6 00 20             	testb  $0x20,(%eax)
80107397:	74 17                	je     801073b0 <find_page_to_swap+0x70>
      min_pi->page_index = (++page_counter);
80107399:	8b 0d c0 b5 10 80    	mov    0x8010b5c0,%ecx
8010739f:	8d 51 01             	lea    0x1(%ecx),%edx
801073a2:	89 15 c0 b5 10 80    	mov    %edx,0x8010b5c0
801073a8:	89 57 0c             	mov    %edx,0xc(%edi)
      *pte &= ~PTE_A;
801073ab:	83 20 df             	andl   $0xffffffdf,(%eax)
  while(1){
801073ae:	eb b0                	jmp    80107360 <find_page_to_swap+0x20>
}
801073b0:	83 c4 1c             	add    $0x1c,%esp
801073b3:	89 f8                	mov    %edi,%eax
801073b5:	5b                   	pop    %ebx
801073b6:	5e                   	pop    %esi
801073b7:	5f                   	pop    %edi
801073b8:	5d                   	pop    %ebp
801073b9:	c3                   	ret    
801073ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801073c0 <seginit>:
{
801073c0:	f3 0f 1e fb          	endbr32 
801073c4:	55                   	push   %ebp
801073c5:	89 e5                	mov    %esp,%ebp
801073c7:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801073ca:	e8 21 cd ff ff       	call   801040f0 <cpuid>
  pd[0] = size-1;
801073cf:	ba 2f 00 00 00       	mov    $0x2f,%edx
801073d4:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801073da:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801073de:	c7 80 18 38 11 80 ff 	movl   $0xffff,-0x7feec7e8(%eax)
801073e5:	ff 00 00 
801073e8:	c7 80 1c 38 11 80 00 	movl   $0xcf9a00,-0x7feec7e4(%eax)
801073ef:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801073f2:	c7 80 20 38 11 80 ff 	movl   $0xffff,-0x7feec7e0(%eax)
801073f9:	ff 00 00 
801073fc:	c7 80 24 38 11 80 00 	movl   $0xcf9200,-0x7feec7dc(%eax)
80107403:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107406:	c7 80 28 38 11 80 ff 	movl   $0xffff,-0x7feec7d8(%eax)
8010740d:	ff 00 00 
80107410:	c7 80 2c 38 11 80 00 	movl   $0xcffa00,-0x7feec7d4(%eax)
80107417:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010741a:	c7 80 30 38 11 80 ff 	movl   $0xffff,-0x7feec7d0(%eax)
80107421:	ff 00 00 
80107424:	c7 80 34 38 11 80 00 	movl   $0xcff200,-0x7feec7cc(%eax)
8010742b:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010742e:	05 10 38 11 80       	add    $0x80113810,%eax
  pd[1] = (uint)p;
80107433:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107437:	c1 e8 10             	shr    $0x10,%eax
8010743a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010743e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107441:	0f 01 10             	lgdtl  (%eax)
}
80107444:	c9                   	leave  
80107445:	c3                   	ret    
80107446:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010744d:	8d 76 00             	lea    0x0(%esi),%esi

80107450 <public_walkpgdir>:
public_walkpgdir(pde_t *pgdir, const void *va, int alloc){
80107450:	f3 0f 1e fb          	endbr32 
80107454:	55                   	push   %ebp
80107455:	89 e5                	mov    %esp,%ebp
  return walkpgdir(pgdir, va, alloc);
80107457:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010745a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010745d:	8b 45 08             	mov    0x8(%ebp),%eax
}
80107460:	5d                   	pop    %ebp
  return walkpgdir(pgdir, va, alloc);
80107461:	e9 ca fd ff ff       	jmp    80107230 <walkpgdir>
80107466:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010746d:	8d 76 00             	lea    0x0(%esi),%esi

80107470 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107470:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107474:	a1 c4 29 12 80       	mov    0x801229c4,%eax
80107479:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010747e:	0f 22 d8             	mov    %eax,%cr3
}
80107481:	c3                   	ret    
80107482:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107490 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107490:	f3 0f 1e fb          	endbr32 
80107494:	55                   	push   %ebp
80107495:	89 e5                	mov    %esp,%ebp
80107497:	57                   	push   %edi
80107498:	56                   	push   %esi
80107499:	53                   	push   %ebx
8010749a:	83 ec 1c             	sub    $0x1c,%esp
8010749d:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801074a0:	85 f6                	test   %esi,%esi
801074a2:	0f 84 cb 00 00 00    	je     80107573 <switchuvm+0xe3>
    panic("switchuvm: no process");
  if(p->kstack == 0)
801074a8:	8b 46 08             	mov    0x8(%esi),%eax
801074ab:	85 c0                	test   %eax,%eax
801074ad:	0f 84 da 00 00 00    	je     8010758d <switchuvm+0xfd>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
801074b3:	8b 46 04             	mov    0x4(%esi),%eax
801074b6:	85 c0                	test   %eax,%eax
801074b8:	0f 84 c2 00 00 00    	je     80107580 <switchuvm+0xf0>
    panic("switchuvm: no pgdir");

  pushcli();
801074be:	e8 6d d9 ff ff       	call   80104e30 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801074c3:	e8 b8 cb ff ff       	call   80104080 <mycpu>
801074c8:	89 c3                	mov    %eax,%ebx
801074ca:	e8 b1 cb ff ff       	call   80104080 <mycpu>
801074cf:	89 c7                	mov    %eax,%edi
801074d1:	e8 aa cb ff ff       	call   80104080 <mycpu>
801074d6:	83 c7 08             	add    $0x8,%edi
801074d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801074dc:	e8 9f cb ff ff       	call   80104080 <mycpu>
801074e1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801074e4:	ba 67 00 00 00       	mov    $0x67,%edx
801074e9:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801074f0:	83 c0 08             	add    $0x8,%eax
801074f3:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801074fa:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801074ff:	83 c1 08             	add    $0x8,%ecx
80107502:	c1 e8 18             	shr    $0x18,%eax
80107505:	c1 e9 10             	shr    $0x10,%ecx
80107508:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010750e:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107514:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107519:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107520:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107525:	e8 56 cb ff ff       	call   80104080 <mycpu>
8010752a:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107531:	e8 4a cb ff ff       	call   80104080 <mycpu>
80107536:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
8010753a:	8b 5e 08             	mov    0x8(%esi),%ebx
8010753d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107543:	e8 38 cb ff ff       	call   80104080 <mycpu>
80107548:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010754b:	e8 30 cb ff ff       	call   80104080 <mycpu>
80107550:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107554:	b8 28 00 00 00       	mov    $0x28,%eax
80107559:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010755c:	8b 46 04             	mov    0x4(%esi),%eax
8010755f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107564:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
80107567:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010756a:	5b                   	pop    %ebx
8010756b:	5e                   	pop    %esi
8010756c:	5f                   	pop    %edi
8010756d:	5d                   	pop    %ebp
  popcli();
8010756e:	e9 0d d9 ff ff       	jmp    80104e80 <popcli>
    panic("switchuvm: no process");
80107573:	83 ec 0c             	sub    $0xc,%esp
80107576:	68 7a 89 10 80       	push   $0x8010897a
8010757b:	e8 10 8e ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107580:	83 ec 0c             	sub    $0xc,%esp
80107583:	68 a5 89 10 80       	push   $0x801089a5
80107588:	e8 03 8e ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
8010758d:	83 ec 0c             	sub    $0xc,%esp
80107590:	68 90 89 10 80       	push   $0x80108990
80107595:	e8 f6 8d ff ff       	call   80100390 <panic>
8010759a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801075a0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801075a0:	f3 0f 1e fb          	endbr32 
801075a4:	55                   	push   %ebp
801075a5:	89 e5                	mov    %esp,%ebp
801075a7:	57                   	push   %edi
801075a8:	56                   	push   %esi
801075a9:	53                   	push   %ebx
801075aa:	83 ec 1c             	sub    $0x1c,%esp
801075ad:	8b 45 0c             	mov    0xc(%ebp),%eax
801075b0:	8b 75 10             	mov    0x10(%ebp),%esi
801075b3:	8b 7d 08             	mov    0x8(%ebp),%edi
801075b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
801075b9:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801075bf:	77 4b                	ja     8010760c <inituvm+0x6c>
    panic("inituvm: more than a page");
  mem = kalloc();
801075c1:	e8 aa b7 ff ff       	call   80102d70 <kalloc>
  memset(mem, 0, PGSIZE);
801075c6:	83 ec 04             	sub    $0x4,%esp
801075c9:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
801075ce:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801075d0:	6a 00                	push   $0x0
801075d2:	50                   	push   %eax
801075d3:	e8 68 da ff ff       	call   80105040 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801075d8:	58                   	pop    %eax
801075d9:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801075df:	5a                   	pop    %edx
801075e0:	6a 06                	push   $0x6
801075e2:	b9 00 10 00 00       	mov    $0x1000,%ecx
801075e7:	31 d2                	xor    %edx,%edx
801075e9:	50                   	push   %eax
801075ea:	89 f8                	mov    %edi,%eax
801075ec:	e8 bf fc ff ff       	call   801072b0 <mappages>
  memmove(mem, init, sz);
801075f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801075f4:	89 75 10             	mov    %esi,0x10(%ebp)
801075f7:	83 c4 10             	add    $0x10,%esp
801075fa:	89 5d 08             	mov    %ebx,0x8(%ebp)
801075fd:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80107600:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107603:	5b                   	pop    %ebx
80107604:	5e                   	pop    %esi
80107605:	5f                   	pop    %edi
80107606:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107607:	e9 d4 da ff ff       	jmp    801050e0 <memmove>
    panic("inituvm: more than a page");
8010760c:	83 ec 0c             	sub    $0xc,%esp
8010760f:	68 b9 89 10 80       	push   $0x801089b9
80107614:	e8 77 8d ff ff       	call   80100390 <panic>
80107619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107620 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107620:	f3 0f 1e fb          	endbr32 
80107624:	55                   	push   %ebp
80107625:	89 e5                	mov    %esp,%ebp
80107627:	57                   	push   %edi
80107628:	56                   	push   %esi
80107629:	53                   	push   %ebx
8010762a:	83 ec 1c             	sub    $0x1c,%esp
8010762d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107630:	8b 75 18             	mov    0x18(%ebp),%esi
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107633:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107638:	0f 85 99 00 00 00    	jne    801076d7 <loaduvm+0xb7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
8010763e:	01 f0                	add    %esi,%eax
80107640:	89 f3                	mov    %esi,%ebx
80107642:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107645:	8b 45 14             	mov    0x14(%ebp),%eax
80107648:	01 f0                	add    %esi,%eax
8010764a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
8010764d:	85 f6                	test   %esi,%esi
8010764f:	75 15                	jne    80107666 <loaduvm+0x46>
80107651:	eb 6d                	jmp    801076c0 <loaduvm+0xa0>
80107653:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107657:	90                   	nop
80107658:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
8010765e:	89 f0                	mov    %esi,%eax
80107660:	29 d8                	sub    %ebx,%eax
80107662:	39 c6                	cmp    %eax,%esi
80107664:	76 5a                	jbe    801076c0 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107666:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107669:	8b 45 08             	mov    0x8(%ebp),%eax
8010766c:	31 c9                	xor    %ecx,%ecx
8010766e:	29 da                	sub    %ebx,%edx
80107670:	e8 bb fb ff ff       	call   80107230 <walkpgdir>
80107675:	85 c0                	test   %eax,%eax
80107677:	74 51                	je     801076ca <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80107679:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010767b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010767e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107683:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107688:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010768e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107691:	29 d9                	sub    %ebx,%ecx
80107693:	05 00 00 00 80       	add    $0x80000000,%eax
80107698:	57                   	push   %edi
80107699:	51                   	push   %ecx
8010769a:	50                   	push   %eax
8010769b:	ff 75 10             	pushl  0x10(%ebp)
8010769e:	e8 7d a7 ff ff       	call   80101e20 <readi>
801076a3:	83 c4 10             	add    $0x10,%esp
801076a6:	39 f8                	cmp    %edi,%eax
801076a8:	74 ae                	je     80107658 <loaduvm+0x38>
      return -1;
  }
  return 0;
}
801076aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801076ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801076b2:	5b                   	pop    %ebx
801076b3:	5e                   	pop    %esi
801076b4:	5f                   	pop    %edi
801076b5:	5d                   	pop    %ebp
801076b6:	c3                   	ret    
801076b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076be:	66 90                	xchg   %ax,%ax
801076c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801076c3:	31 c0                	xor    %eax,%eax
}
801076c5:	5b                   	pop    %ebx
801076c6:	5e                   	pop    %esi
801076c7:	5f                   	pop    %edi
801076c8:	5d                   	pop    %ebp
801076c9:	c3                   	ret    
      panic("loaduvm: address should exist");
801076ca:	83 ec 0c             	sub    $0xc,%esp
801076cd:	68 d3 89 10 80       	push   $0x801089d3
801076d2:	e8 b9 8c ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
801076d7:	83 ec 0c             	sub    $0xc,%esp
801076da:	68 b0 8a 10 80       	push   $0x80108ab0
801076df:	e8 ac 8c ff ff       	call   80100390 <panic>
801076e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801076ef:	90                   	nop

801076f0 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801076f0:	f3 0f 1e fb          	endbr32 
801076f4:	55                   	push   %ebp
801076f5:	89 e5                	mov    %esp,%ebp
801076f7:	57                   	push   %edi
801076f8:	56                   	push   %esi
801076f9:	53                   	push   %ebx
801076fa:	83 ec 1c             	sub    $0x1c,%esp
801076fd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80107700:	8b 75 08             	mov    0x8(%ebp),%esi
  pte_t *pte;
  uint a, pa;
  struct proc* p = myproc();
80107703:	e8 08 ca ff ff       	call   80104110 <myproc>
80107708:	89 45 e4             	mov    %eax,-0x1c(%ebp)

  if(newsz >= oldsz)
    return oldsz;
8010770b:	89 d8                	mov    %ebx,%eax
  if(newsz >= oldsz)
8010770d:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107710:	0f 83 7d 00 00 00    	jae    80107793 <deallocuvm+0xa3>

  a = PGROUNDUP(newsz);
80107716:	8b 45 10             	mov    0x10(%ebp),%eax
80107719:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
8010771f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107725:	89 d7                	mov    %edx,%edi
  for(; a  < oldsz; a += PGSIZE){
80107727:	39 d3                	cmp    %edx,%ebx
80107729:	76 54                	jbe    8010777f <deallocuvm+0x8f>
8010772b:	89 5d 0c             	mov    %ebx,0xc(%ebp)
8010772e:	eb 0b                	jmp    8010773b <deallocuvm+0x4b>
80107730:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107736:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107739:	73 44                	jae    8010777f <deallocuvm+0x8f>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010773b:	31 c9                	xor    %ecx,%ecx
8010773d:	89 fa                	mov    %edi,%edx
8010773f:	89 f0                	mov    %esi,%eax
80107741:	e8 ea fa ff ff       	call   80107230 <walkpgdir>
80107746:	89 c3                	mov    %eax,%ebx
    if(!pte)
80107748:	85 c0                	test   %eax,%eax
8010774a:	74 54                	je     801077a0 <deallocuvm+0xb0>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
8010774c:	8b 00                	mov    (%eax),%eax
8010774e:	a8 01                	test   $0x1,%al
80107750:	74 de                	je     80107730 <deallocuvm+0x40>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80107752:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107757:	0f 84 ca 00 00 00    	je     80107827 <deallocuvm+0x137>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
8010775d:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80107760:	05 00 00 00 80       	add    $0x80000000,%eax
80107765:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
8010776b:	50                   	push   %eax
8010776c:	e8 3f b4 ff ff       	call   80102bb0 <kfree>
      *pte = 0;
80107771:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80107777:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
8010777a:	3b 7d 0c             	cmp    0xc(%ebp),%edi
8010777d:	72 bc                	jb     8010773b <deallocuvm+0x4b>
    }
  }

  if (p->pid > 2 && p->pgdir == pgdir){
8010777f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107782:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80107786:	7e 08                	jle    80107790 <deallocuvm+0xa0>
80107788:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010778b:	39 70 04             	cmp    %esi,0x4(%eax)
8010778e:	74 20                	je     801077b0 <deallocuvm+0xc0>
      p->ram_pages[i].swap_file_offset = p->swapped_out_pages[i].swap_file_offset = 0;
      p->ram_pages[i].va = p->swapped_out_pages[i].va = 0;
    }
  }

  return newsz;
80107790:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107793:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107796:	5b                   	pop    %ebx
80107797:	5e                   	pop    %esi
80107798:	5f                   	pop    %edi
80107799:	5d                   	pop    %ebp
8010779a:	c3                   	ret    
8010779b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010779f:	90                   	nop
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801077a0:	89 fa                	mov    %edi,%edx
801077a2:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
801077a8:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
801077ae:	eb 86                	jmp    80107736 <deallocuvm+0x46>
    p->num_of_actual_pages_in_mem = 0;
801077b0:	c7 80 84 03 00 00 00 	movl   $0x0,0x384(%eax)
801077b7:	00 00 00 
801077ba:	89 c1                	mov    %eax,%ecx
801077bc:	8d 80 80 00 00 00    	lea    0x80(%eax),%eax
    p->num_of_pages_in_swap_file = 0;
801077c2:	c7 80 00 03 00 00 00 	movl   $0x0,0x300(%eax)
801077c9:	00 00 00 
    for (int i = 0; i < MAX_PYSC_PAGES; i++){
801077cc:	8d b9 00 02 00 00    	lea    0x200(%ecx),%edi
801077d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      p->ram_pages[i].is_free = p->swapped_out_pages[i].is_free = 1;
801077d8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
801077de:	83 c0 18             	add    $0x18,%eax
801077e1:	c7 80 68 01 00 00 01 	movl   $0x1,0x168(%eax)
801077e8:	00 00 00 
      p->ram_pages[i].aging_counter = p->swapped_out_pages[i].aging_counter = 0;
801077eb:	c7 40 f0 00 00 00 00 	movl   $0x0,-0x10(%eax)
801077f2:	c7 80 70 01 00 00 00 	movl   $0x0,0x170(%eax)
801077f9:	00 00 00 
      p->ram_pages[i].swap_file_offset = p->swapped_out_pages[i].swap_file_offset = 0;
801077fc:	c7 40 ec 00 00 00 00 	movl   $0x0,-0x14(%eax)
80107803:	c7 80 6c 01 00 00 00 	movl   $0x0,0x16c(%eax)
8010780a:	00 00 00 
      p->ram_pages[i].va = p->swapped_out_pages[i].va = 0;
8010780d:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
80107814:	c7 80 78 01 00 00 00 	movl   $0x0,0x178(%eax)
8010781b:	00 00 00 
    for (int i = 0; i < MAX_PYSC_PAGES; i++){
8010781e:	39 f8                	cmp    %edi,%eax
80107820:	75 b6                	jne    801077d8 <deallocuvm+0xe8>
80107822:	e9 69 ff ff ff       	jmp    80107790 <deallocuvm+0xa0>
        panic("kfree");
80107827:	83 ec 0c             	sub    $0xc,%esp
8010782a:	68 0a 83 10 80       	push   $0x8010830a
8010782f:	e8 5c 8b ff ff       	call   80100390 <panic>
80107834:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010783b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010783f:	90                   	nop

80107840 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107840:	f3 0f 1e fb          	endbr32 
80107844:	55                   	push   %ebp
80107845:	89 e5                	mov    %esp,%ebp
80107847:	57                   	push   %edi
80107848:	56                   	push   %esi
80107849:	53                   	push   %ebx
8010784a:	83 ec 0c             	sub    $0xc,%esp
8010784d:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107850:	85 f6                	test   %esi,%esi
80107852:	74 5d                	je     801078b1 <freevm+0x71>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
80107854:	83 ec 04             	sub    $0x4,%esp
80107857:	89 f3                	mov    %esi,%ebx
80107859:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
8010785f:	6a 00                	push   $0x0
80107861:	68 00 00 00 80       	push   $0x80000000
80107866:	56                   	push   %esi
80107867:	e8 84 fe ff ff       	call   801076f0 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
8010786c:	83 c4 10             	add    $0x10,%esp
8010786f:	eb 0e                	jmp    8010787f <freevm+0x3f>
80107871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107878:	83 c3 04             	add    $0x4,%ebx
8010787b:	39 df                	cmp    %ebx,%edi
8010787d:	74 23                	je     801078a2 <freevm+0x62>
    if(pgdir[i] & PTE_P){
8010787f:	8b 03                	mov    (%ebx),%eax
80107881:	a8 01                	test   $0x1,%al
80107883:	74 f3                	je     80107878 <freevm+0x38>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107885:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
8010788a:	83 ec 0c             	sub    $0xc,%esp
8010788d:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107890:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107895:	50                   	push   %eax
80107896:	e8 15 b3 ff ff       	call   80102bb0 <kfree>
8010789b:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
8010789e:	39 df                	cmp    %ebx,%edi
801078a0:	75 dd                	jne    8010787f <freevm+0x3f>
    }
  }
  kfree((char*)pgdir);
801078a2:	89 75 08             	mov    %esi,0x8(%ebp)
}
801078a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078a8:	5b                   	pop    %ebx
801078a9:	5e                   	pop    %esi
801078aa:	5f                   	pop    %edi
801078ab:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801078ac:	e9 ff b2 ff ff       	jmp    80102bb0 <kfree>
    panic("freevm: no pgdir");
801078b1:	83 ec 0c             	sub    $0xc,%esp
801078b4:	68 f1 89 10 80       	push   $0x801089f1
801078b9:	e8 d2 8a ff ff       	call   80100390 <panic>
801078be:	66 90                	xchg   %ax,%ax

801078c0 <setupkvm>:
{
801078c0:	f3 0f 1e fb          	endbr32 
801078c4:	55                   	push   %ebp
801078c5:	89 e5                	mov    %esp,%ebp
801078c7:	56                   	push   %esi
801078c8:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801078c9:	e8 a2 b4 ff ff       	call   80102d70 <kalloc>
801078ce:	89 c6                	mov    %eax,%esi
801078d0:	85 c0                	test   %eax,%eax
801078d2:	74 42                	je     80107916 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
801078d4:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801078d7:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801078dc:	68 00 10 00 00       	push   $0x1000
801078e1:	6a 00                	push   $0x0
801078e3:	50                   	push   %eax
801078e4:	e8 57 d7 ff ff       	call   80105040 <memset>
801078e9:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801078ec:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801078ef:	83 ec 08             	sub    $0x8,%esp
801078f2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801078f5:	ff 73 0c             	pushl  0xc(%ebx)
801078f8:	8b 13                	mov    (%ebx),%edx
801078fa:	50                   	push   %eax
801078fb:	29 c1                	sub    %eax,%ecx
801078fd:	89 f0                	mov    %esi,%eax
801078ff:	e8 ac f9 ff ff       	call   801072b0 <mappages>
80107904:	83 c4 10             	add    $0x10,%esp
80107907:	85 c0                	test   %eax,%eax
80107909:	78 15                	js     80107920 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010790b:	83 c3 10             	add    $0x10,%ebx
8010790e:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107914:	75 d6                	jne    801078ec <setupkvm+0x2c>
}
80107916:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107919:	89 f0                	mov    %esi,%eax
8010791b:	5b                   	pop    %ebx
8010791c:	5e                   	pop    %esi
8010791d:	5d                   	pop    %ebp
8010791e:	c3                   	ret    
8010791f:	90                   	nop
      freevm(pgdir);
80107920:	83 ec 0c             	sub    $0xc,%esp
80107923:	56                   	push   %esi
      return 0;
80107924:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107926:	e8 15 ff ff ff       	call   80107840 <freevm>
      return 0;
8010792b:	83 c4 10             	add    $0x10,%esp
}
8010792e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107931:	89 f0                	mov    %esi,%eax
80107933:	5b                   	pop    %ebx
80107934:	5e                   	pop    %esi
80107935:	5d                   	pop    %ebp
80107936:	c3                   	ret    
80107937:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010793e:	66 90                	xchg   %ax,%ax

80107940 <kvmalloc>:
{
80107940:	f3 0f 1e fb          	endbr32 
80107944:	55                   	push   %ebp
80107945:	89 e5                	mov    %esp,%ebp
80107947:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010794a:	e8 71 ff ff ff       	call   801078c0 <setupkvm>
8010794f:	a3 c4 29 12 80       	mov    %eax,0x801229c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107954:	05 00 00 00 80       	add    $0x80000000,%eax
80107959:	0f 22 d8             	mov    %eax,%cr3
}
8010795c:	c9                   	leave  
8010795d:	c3                   	ret    
8010795e:	66 90                	xchg   %ax,%ax

80107960 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107960:	f3 0f 1e fb          	endbr32 
80107964:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107965:	31 c9                	xor    %ecx,%ecx
{
80107967:	89 e5                	mov    %esp,%ebp
80107969:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
8010796c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010796f:	8b 45 08             	mov    0x8(%ebp),%eax
80107972:	e8 b9 f8 ff ff       	call   80107230 <walkpgdir>
  if(pte == 0)
80107977:	85 c0                	test   %eax,%eax
80107979:	74 05                	je     80107980 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
8010797b:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010797e:	c9                   	leave  
8010797f:	c3                   	ret    
    panic("clearpteu");
80107980:	83 ec 0c             	sub    $0xc,%esp
80107983:	68 02 8a 10 80       	push   $0x80108a02
80107988:	e8 03 8a ff ff       	call   80100390 <panic>
8010798d:	8d 76 00             	lea    0x0(%esi),%esi

80107990 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107990:	f3 0f 1e fb          	endbr32 
80107994:	55                   	push   %ebp
80107995:	89 e5                	mov    %esp,%ebp
80107997:	57                   	push   %edi
80107998:	56                   	push   %esi
80107999:	53                   	push   %ebx
8010799a:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010799d:	e8 1e ff ff ff       	call   801078c0 <setupkvm>
801079a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
801079a5:	85 c0                	test   %eax,%eax
801079a7:	0f 84 9b 00 00 00    	je     80107a48 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801079ad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801079b0:	85 c9                	test   %ecx,%ecx
801079b2:	0f 84 90 00 00 00    	je     80107a48 <copyuvm+0xb8>
801079b8:	31 f6                	xor    %esi,%esi
801079ba:	eb 46                	jmp    80107a02 <copyuvm+0x72>
801079bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801079c0:	83 ec 04             	sub    $0x4,%esp
801079c3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801079c9:	68 00 10 00 00       	push   $0x1000
801079ce:	57                   	push   %edi
801079cf:	50                   	push   %eax
801079d0:	e8 0b d7 ff ff       	call   801050e0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801079d5:	58                   	pop    %eax
801079d6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801079dc:	5a                   	pop    %edx
801079dd:	ff 75 e4             	pushl  -0x1c(%ebp)
801079e0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801079e5:	89 f2                	mov    %esi,%edx
801079e7:	50                   	push   %eax
801079e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801079eb:	e8 c0 f8 ff ff       	call   801072b0 <mappages>
801079f0:	83 c4 10             	add    $0x10,%esp
801079f3:	85 c0                	test   %eax,%eax
801079f5:	78 61                	js     80107a58 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
801079f7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801079fd:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107a00:	76 46                	jbe    80107a48 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107a02:	8b 45 08             	mov    0x8(%ebp),%eax
80107a05:	31 c9                	xor    %ecx,%ecx
80107a07:	89 f2                	mov    %esi,%edx
80107a09:	e8 22 f8 ff ff       	call   80107230 <walkpgdir>
80107a0e:	85 c0                	test   %eax,%eax
80107a10:	74 61                	je     80107a73 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107a12:	8b 00                	mov    (%eax),%eax
80107a14:	a8 01                	test   $0x1,%al
80107a16:	74 4e                	je     80107a66 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107a18:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107a1a:	25 ff 0f 00 00       	and    $0xfff,%eax
80107a1f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107a22:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107a28:	e8 43 b3 ff ff       	call   80102d70 <kalloc>
80107a2d:	89 c3                	mov    %eax,%ebx
80107a2f:	85 c0                	test   %eax,%eax
80107a31:	75 8d                	jne    801079c0 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107a33:	83 ec 0c             	sub    $0xc,%esp
80107a36:	ff 75 e0             	pushl  -0x20(%ebp)
80107a39:	e8 02 fe ff ff       	call   80107840 <freevm>
  return 0;
80107a3e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107a45:	83 c4 10             	add    $0x10,%esp
}
80107a48:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107a4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a4e:	5b                   	pop    %ebx
80107a4f:	5e                   	pop    %esi
80107a50:	5f                   	pop    %edi
80107a51:	5d                   	pop    %ebp
80107a52:	c3                   	ret    
80107a53:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107a57:	90                   	nop
      kfree(mem);
80107a58:	83 ec 0c             	sub    $0xc,%esp
80107a5b:	53                   	push   %ebx
80107a5c:	e8 4f b1 ff ff       	call   80102bb0 <kfree>
      goto bad;
80107a61:	83 c4 10             	add    $0x10,%esp
80107a64:	eb cd                	jmp    80107a33 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107a66:	83 ec 0c             	sub    $0xc,%esp
80107a69:	68 26 8a 10 80       	push   $0x80108a26
80107a6e:	e8 1d 89 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107a73:	83 ec 0c             	sub    $0xc,%esp
80107a76:	68 0c 8a 10 80       	push   $0x80108a0c
80107a7b:	e8 10 89 ff ff       	call   80100390 <panic>

80107a80 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107a80:	f3 0f 1e fb          	endbr32 
80107a84:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107a85:	31 c9                	xor    %ecx,%ecx
{
80107a87:	89 e5                	mov    %esp,%ebp
80107a89:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107a8c:	8b 55 0c             	mov    0xc(%ebp),%edx
80107a8f:	8b 45 08             	mov    0x8(%ebp),%eax
80107a92:	e8 99 f7 ff ff       	call   80107230 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107a97:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107a99:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107a9a:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107a9c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107aa1:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107aa4:	05 00 00 00 80       	add    $0x80000000,%eax
80107aa9:	83 fa 05             	cmp    $0x5,%edx
80107aac:	ba 00 00 00 00       	mov    $0x0,%edx
80107ab1:	0f 45 c2             	cmovne %edx,%eax
}
80107ab4:	c3                   	ret    
80107ab5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107ac0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107ac0:	f3 0f 1e fb          	endbr32 
80107ac4:	55                   	push   %ebp
80107ac5:	89 e5                	mov    %esp,%ebp
80107ac7:	57                   	push   %edi
80107ac8:	56                   	push   %esi
80107ac9:	53                   	push   %ebx
80107aca:	83 ec 0c             	sub    $0xc,%esp
80107acd:	8b 75 14             	mov    0x14(%ebp),%esi
80107ad0:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107ad3:	85 f6                	test   %esi,%esi
80107ad5:	75 3c                	jne    80107b13 <copyout+0x53>
80107ad7:	eb 67                	jmp    80107b40 <copyout+0x80>
80107ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107ae0:	8b 55 0c             	mov    0xc(%ebp),%edx
80107ae3:	89 fb                	mov    %edi,%ebx
80107ae5:	29 d3                	sub    %edx,%ebx
80107ae7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80107aed:	39 f3                	cmp    %esi,%ebx
80107aef:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107af2:	29 fa                	sub    %edi,%edx
80107af4:	83 ec 04             	sub    $0x4,%esp
80107af7:	01 c2                	add    %eax,%edx
80107af9:	53                   	push   %ebx
80107afa:	ff 75 10             	pushl  0x10(%ebp)
80107afd:	52                   	push   %edx
80107afe:	e8 dd d5 ff ff       	call   801050e0 <memmove>
    len -= n;
    buf += n;
80107b03:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80107b06:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
80107b0c:	83 c4 10             	add    $0x10,%esp
80107b0f:	29 de                	sub    %ebx,%esi
80107b11:	74 2d                	je     80107b40 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80107b13:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107b15:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107b18:	89 55 0c             	mov    %edx,0xc(%ebp)
80107b1b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107b21:	57                   	push   %edi
80107b22:	ff 75 08             	pushl  0x8(%ebp)
80107b25:	e8 56 ff ff ff       	call   80107a80 <uva2ka>
    if(pa0 == 0)
80107b2a:	83 c4 10             	add    $0x10,%esp
80107b2d:	85 c0                	test   %eax,%eax
80107b2f:	75 af                	jne    80107ae0 <copyout+0x20>
  }
  return 0;
}
80107b31:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107b34:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107b39:	5b                   	pop    %ebx
80107b3a:	5e                   	pop    %esi
80107b3b:	5f                   	pop    %edi
80107b3c:	5d                   	pop    %ebp
80107b3d:	c3                   	ret    
80107b3e:	66 90                	xchg   %ax,%ax
80107b40:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107b43:	31 c0                	xor    %eax,%eax
}
80107b45:	5b                   	pop    %ebx
80107b46:	5e                   	pop    %esi
80107b47:	5f                   	pop    %edi
80107b48:	5d                   	pop    %ebp
80107b49:	c3                   	ret    
80107b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107b50 <swap_out>:
//  if buffer == 0 then we put buffer <-- kernel_va(page_to_swap->va)  // p2v(phiscal(va))
//  and use buffer to swap out from
//  we assume that if buffer is not 0, it is kernel virtual address
void swap_out(struct proc* p, struct pageinfo* page_to_swap, void* buffer, pde_t* pgdir){
80107b50:	f3 0f 1e fb          	endbr32 
80107b54:	55                   	push   %ebp
80107b55:	89 e5                	mov    %esp,%ebp
80107b57:	57                   	push   %edi
80107b58:	56                   	push   %esi
80107b59:	53                   	push   %ebx
80107b5a:	83 ec 1c             	sub    $0x1c,%esp
80107b5d:	8b 75 10             	mov    0x10(%ebp),%esi
80107b60:	8b 5d 08             	mov    0x8(%ebp),%ebx
80107b63:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if (buffer == 0){
80107b66:	85 f6                	test   %esi,%esi
80107b68:	0f 84 ba 00 00 00    	je     80107c28 <swap_out+0xd8>
    buffer = P2V((PTE_ADDR(*(walkpgdir(pgdir, page_to_swap->va, 0)))));
  }
  // swap page
  // INV  : cell swapped_out_pages[i] is free iff there isnt a page that is written in offset i * PGSIZE in the swap file
  int index;
  for (index = 0; index < MAX_PYSC_PAGES; index++){
80107b6e:	8d 93 80 00 00 00    	lea    0x80(%ebx),%edx
80107b74:	31 c0                	xor    %eax,%eax
80107b76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b7d:	8d 76 00             	lea    0x0(%esi),%esi
    if (p->swapped_out_pages[index].is_free){
80107b80:	8b 0a                	mov    (%edx),%ecx
80107b82:	85 c9                	test   %ecx,%ecx
80107b84:	75 7a                	jne    80107c00 <swap_out+0xb0>
  for (index = 0; index < MAX_PYSC_PAGES; index++){
80107b86:	83 c0 01             	add    $0x1,%eax
80107b89:	83 c2 18             	add    $0x18,%edx
80107b8c:	83 f8 10             	cmp    $0x10,%eax
80107b8f:	75 ef                	jne    80107b80 <swap_out+0x30>
80107b91:	b8 00 00 01 00       	mov    $0x10000,%eax
      p->swapped_out_pages[index].is_free = 0;
      p->swapped_out_pages[index].va = page_to_swap->va;
      break;
    }
  }
  int result = writeToSwapFile(p, buffer, index * PGSIZE, PGSIZE);
80107b96:	68 00 10 00 00       	push   $0x1000
80107b9b:	50                   	push   %eax
80107b9c:	56                   	push   %esi
80107b9d:	53                   	push   %ebx
80107b9e:	e8 ad ab ff ff       	call   80102750 <writeToSwapFile>


  
  // update flags in PTE
  pte_t* pte_ptr = walkpgdir(pgdir, page_to_swap->va, 0);
80107ba3:	8b 57 10             	mov    0x10(%edi),%edx
80107ba6:	31 c9                	xor    %ecx,%ecx
  int result = writeToSwapFile(p, buffer, index * PGSIZE, PGSIZE);
80107ba8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  pte_t* pte_ptr = walkpgdir(pgdir, page_to_swap->va, 0);
80107bab:	8b 45 14             	mov    0x14(%ebp),%eax
80107bae:	e8 7d f6 ff ff       	call   80107230 <walkpgdir>
  *pte_ptr |= PTE_PG;
  *pte_ptr &= ~PTE_P;
80107bb3:	8b 10                	mov    (%eax),%edx
80107bb5:	83 e2 fe             	and    $0xfffffffe,%edx
80107bb8:	80 ce 02             	or     $0x2,%dh
80107bbb:	89 10                	mov    %edx,(%eax)
  kfree(buffer);
80107bbd:	89 34 24             	mov    %esi,(%esp)
80107bc0:	e8 eb af ff ff       	call   80102bb0 <kfree>
  // refresh cr3
  lcr3(V2P(p->pgdir));
80107bc5:	8b 4b 04             	mov    0x4(%ebx),%ecx
80107bc8:	8d 81 00 00 00 80    	lea    -0x80000000(%ecx),%eax
80107bce:	0f 22 d8             	mov    %eax,%cr3
  page_to_swap->is_free = 1;
  if (result < 0){
80107bd1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  page_to_swap->is_free = 1;
80107bd4:	c7 07 01 00 00 00    	movl   $0x1,(%edi)
  if (result < 0){
80107bda:	83 c4 10             	add    $0x10,%esp
80107bdd:	85 c0                	test   %eax,%eax
80107bdf:	78 66                	js     80107c47 <swap_out+0xf7>
    panic("swap out failed\n");
  }
  p->num_of_pages_in_swap_file++;
80107be1:	83 83 80 03 00 00 01 	addl   $0x1,0x380(%ebx)
  p->num_of_pageOut_occured++;
80107be8:	83 83 8c 03 00 00 01 	addl   $0x1,0x38c(%ebx)
  p->num_of_actual_pages_in_mem--;
80107bef:	83 ab 84 03 00 00 01 	subl   $0x1,0x384(%ebx)
}
80107bf6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107bf9:	5b                   	pop    %ebx
80107bfa:	5e                   	pop    %esi
80107bfb:	5f                   	pop    %edi
80107bfc:	5d                   	pop    %ebp
80107bfd:	c3                   	ret    
80107bfe:	66 90                	xchg   %ax,%ax
      p->swapped_out_pages[index].is_free = 0;
80107c00:	8d 14 40             	lea    (%eax,%eax,2),%edx
80107c03:	c1 e0 0c             	shl    $0xc,%eax
80107c06:	8d 14 d3             	lea    (%ebx,%edx,8),%edx
80107c09:	c7 82 80 00 00 00 00 	movl   $0x0,0x80(%edx)
80107c10:	00 00 00 
      p->swapped_out_pages[index].va = page_to_swap->va;
80107c13:	8b 4f 10             	mov    0x10(%edi),%ecx
80107c16:	89 8a 90 00 00 00    	mov    %ecx,0x90(%edx)
      break;
80107c1c:	e9 75 ff ff ff       	jmp    80107b96 <swap_out+0x46>
80107c21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    buffer = P2V((PTE_ADDR(*(walkpgdir(pgdir, page_to_swap->va, 0)))));
80107c28:	8b 57 10             	mov    0x10(%edi),%edx
80107c2b:	8b 45 14             	mov    0x14(%ebp),%eax
80107c2e:	31 c9                	xor    %ecx,%ecx
80107c30:	e8 fb f5 ff ff       	call   80107230 <walkpgdir>
80107c35:	8b 00                	mov    (%eax),%eax
80107c37:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107c3c:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
80107c42:	e9 27 ff ff ff       	jmp    80107b6e <swap_out+0x1e>
    panic("swap out failed\n");
80107c47:	83 ec 0c             	sub    $0xc,%esp
80107c4a:	68 40 8a 10 80       	push   $0x80108a40
80107c4f:	e8 3c 87 ff ff       	call   80100390 <panic>
80107c54:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107c5f:	90                   	nop

80107c60 <allocuvm>:
{
80107c60:	f3 0f 1e fb          	endbr32 
80107c64:	55                   	push   %ebp
80107c65:	89 e5                	mov    %esp,%ebp
80107c67:	57                   	push   %edi
80107c68:	56                   	push   %esi
80107c69:	53                   	push   %ebx
80107c6a:	83 ec 1c             	sub    $0x1c,%esp
  struct proc* p = myproc();
80107c6d:	e8 9e c4 ff ff       	call   80104110 <myproc>
80107c72:	89 c7                	mov    %eax,%edi
  if(newsz >= KERNBASE)
80107c74:	8b 45 10             	mov    0x10(%ebp),%eax
80107c77:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107c7a:	85 c0                	test   %eax,%eax
80107c7c:	0f 88 68 01 00 00    	js     80107dea <allocuvm+0x18a>
  if(newsz < oldsz)
80107c82:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107c85:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107c88:	0f 82 ad 00 00 00    	jb     80107d3b <allocuvm+0xdb>
  a = PGROUNDUP(oldsz);
80107c8e:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107c94:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107c9a:	39 75 10             	cmp    %esi,0x10(%ebp)
80107c9d:	0f 86 9b 00 00 00    	jbe    80107d3e <allocuvm+0xde>
80107ca3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107ca7:	90                   	nop
    if (p->pid > 2){
80107ca8:	83 7f 10 02          	cmpl   $0x2,0x10(%edi)
80107cac:	7e 0d                	jle    80107cbb <allocuvm+0x5b>
      if (p->num_of_actual_pages_in_mem >= 16){
80107cae:	83 bf 84 03 00 00 0f 	cmpl   $0xf,0x384(%edi)
80107cb5:	0f 87 d5 00 00 00    	ja     80107d90 <allocuvm+0x130>
    mem = kalloc();
80107cbb:	e8 b0 b0 ff ff       	call   80102d70 <kalloc>
80107cc0:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107cc2:	85 c0                	test   %eax,%eax
80107cc4:	0f 84 ed 00 00 00    	je     80107db7 <allocuvm+0x157>
    memset(mem, 0, PGSIZE);
80107cca:	83 ec 04             	sub    $0x4,%esp
80107ccd:	68 00 10 00 00       	push   $0x1000
80107cd2:	6a 00                	push   $0x0
80107cd4:	50                   	push   %eax
80107cd5:	e8 66 d3 ff ff       	call   80105040 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107cda:	58                   	pop    %eax
80107cdb:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107ce1:	5a                   	pop    %edx
80107ce2:	6a 06                	push   $0x6
80107ce4:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107ce9:	89 f2                	mov    %esi,%edx
80107ceb:	50                   	push   %eax
80107cec:	8b 45 08             	mov    0x8(%ebp),%eax
80107cef:	e8 bc f5 ff ff       	call   801072b0 <mappages>
80107cf4:	83 c4 10             	add    $0x10,%esp
80107cf7:	85 c0                	test   %eax,%eax
80107cf9:	0f 88 fd 00 00 00    	js     80107dfc <allocuvm+0x19c>
80107cff:	8d 97 00 02 00 00    	lea    0x200(%edi),%edx
    for (int i = 0; i < MAX_PYSC_PAGES; i++){
80107d05:	31 c0                	xor    %eax,%eax
80107d07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d0e:	66 90                	xchg   %ax,%ax
      if (p->ram_pages[i].is_free){
80107d10:	8b 0a                	mov    (%edx),%ecx
80107d12:	85 c9                	test   %ecx,%ecx
80107d14:	75 3a                	jne    80107d50 <allocuvm+0xf0>
    for (int i = 0; i < MAX_PYSC_PAGES; i++){
80107d16:	83 c0 01             	add    $0x1,%eax
80107d19:	83 c2 18             	add    $0x18,%edx
80107d1c:	83 f8 10             	cmp    $0x10,%eax
80107d1f:	75 ef                	jne    80107d10 <allocuvm+0xb0>
  for(; a < newsz; a += PGSIZE){
80107d21:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107d27:	39 75 10             	cmp    %esi,0x10(%ebp)
80107d2a:	0f 87 78 ff ff ff    	ja     80107ca8 <allocuvm+0x48>
}
80107d30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107d33:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d36:	5b                   	pop    %ebx
80107d37:	5e                   	pop    %esi
80107d38:	5f                   	pop    %edi
80107d39:	5d                   	pop    %ebp
80107d3a:	c3                   	ret    
    return oldsz;
80107d3b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107d3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107d41:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d44:	5b                   	pop    %ebx
80107d45:	5e                   	pop    %esi
80107d46:	5f                   	pop    %edi
80107d47:	5d                   	pop    %ebp
80107d48:	c3                   	ret    
80107d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        p->ram_pages[i].is_free = 0;
80107d50:	8d 04 40             	lea    (%eax,%eax,2),%eax
80107d53:	8d 14 c7             	lea    (%edi,%eax,8),%edx
        p->ram_pages[i].page_index = ++page_counter;
80107d56:	a1 c0 b5 10 80       	mov    0x8010b5c0,%eax
        p->ram_pages[i].va = (void *)a;
80107d5b:	89 b2 10 02 00 00    	mov    %esi,0x210(%edx)
  for(; a < newsz; a += PGSIZE){
80107d61:	81 c6 00 10 00 00    	add    $0x1000,%esi
        p->ram_pages[i].is_free = 0;
80107d67:	c7 82 00 02 00 00 00 	movl   $0x0,0x200(%edx)
80107d6e:	00 00 00 
        p->ram_pages[i].page_index = ++page_counter;
80107d71:	83 c0 01             	add    $0x1,%eax
80107d74:	a3 c0 b5 10 80       	mov    %eax,0x8010b5c0
80107d79:	89 82 0c 02 00 00    	mov    %eax,0x20c(%edx)
  for(; a < newsz; a += PGSIZE){
80107d7f:	39 75 10             	cmp    %esi,0x10(%ebp)
80107d82:	0f 87 20 ff ff ff    	ja     80107ca8 <allocuvm+0x48>
80107d88:	eb a6                	jmp    80107d30 <allocuvm+0xd0>
80107d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        struct pageinfo* page_to_swap = find_page_to_swap(p);
80107d90:	83 ec 0c             	sub    $0xc,%esp
80107d93:	57                   	push   %edi
80107d94:	e8 a7 f5 ff ff       	call   80107340 <find_page_to_swap>
        swap_out(p, page_to_swap, 0, pgdir);
80107d99:	ff 75 08             	pushl  0x8(%ebp)
80107d9c:	6a 00                	push   $0x0
80107d9e:	50                   	push   %eax
80107d9f:	57                   	push   %edi
80107da0:	e8 ab fd ff ff       	call   80107b50 <swap_out>
80107da5:	83 c4 20             	add    $0x20,%esp
    mem = kalloc();
80107da8:	e8 c3 af ff ff       	call   80102d70 <kalloc>
80107dad:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107daf:	85 c0                	test   %eax,%eax
80107db1:	0f 85 13 ff ff ff    	jne    80107cca <allocuvm+0x6a>
      cprintf("allocuvm out of memory\n");
80107db7:	83 ec 0c             	sub    $0xc,%esp
80107dba:	68 51 8a 10 80       	push   $0x80108a51
80107dbf:	e8 ec 88 ff ff       	call   801006b0 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80107dc4:	83 c4 0c             	add    $0xc,%esp
80107dc7:	ff 75 0c             	pushl  0xc(%ebp)
80107dca:	ff 75 10             	pushl  0x10(%ebp)
80107dcd:	ff 75 08             	pushl  0x8(%ebp)
80107dd0:	e8 1b f9 ff ff       	call   801076f0 <deallocuvm>
      return 0;
80107dd5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80107ddc:	83 c4 10             	add    $0x10,%esp
}
80107ddf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107de2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107de5:	5b                   	pop    %ebx
80107de6:	5e                   	pop    %esi
80107de7:	5f                   	pop    %edi
80107de8:	5d                   	pop    %ebp
80107de9:	c3                   	ret    
    return 0;
80107dea:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107df1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107df4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107df7:	5b                   	pop    %ebx
80107df8:	5e                   	pop    %esi
80107df9:	5f                   	pop    %edi
80107dfa:	5d                   	pop    %ebp
80107dfb:	c3                   	ret    
      cprintf("allocuvm out of memory (2)\n");
80107dfc:	83 ec 0c             	sub    $0xc,%esp
80107dff:	68 69 8a 10 80       	push   $0x80108a69
80107e04:	e8 a7 88 ff ff       	call   801006b0 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80107e09:	83 c4 0c             	add    $0xc,%esp
80107e0c:	ff 75 0c             	pushl  0xc(%ebp)
80107e0f:	ff 75 10             	pushl  0x10(%ebp)
80107e12:	ff 75 08             	pushl  0x8(%ebp)
80107e15:	e8 d6 f8 ff ff       	call   801076f0 <deallocuvm>
      kfree(mem);
80107e1a:	89 1c 24             	mov    %ebx,(%esp)
80107e1d:	e8 8e ad ff ff       	call   80102bb0 <kfree>
      return 0;
80107e22:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80107e29:	83 c4 10             	add    $0x10,%esp
}
80107e2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107e2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107e32:	5b                   	pop    %ebx
80107e33:	5e                   	pop    %esi
80107e34:	5f                   	pop    %edi
80107e35:	5d                   	pop    %ebp
80107e36:	c3                   	ret    
80107e37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107e3e:	66 90                	xchg   %ax,%ax

80107e40 <swap_in>:

// we assume there are at most MAX_PYSC_PAGES in the RAM 
int swap_in(struct proc* p, struct pageinfo* pi){
80107e40:	f3 0f 1e fb          	endbr32 
80107e44:	55                   	push   %ebp
80107e45:	89 e5                	mov    %esp,%ebp
80107e47:	57                   	push   %edi
80107e48:	56                   	push   %esi
80107e49:	53                   	push   %ebx
  pde_t* pgdir = p->pgdir;
  uint offset = pi->swap_file_offset;
  int index;
  for (index = 0; index < MAX_PYSC_PAGES; index++){
80107e4a:	31 db                	xor    %ebx,%ebx
int swap_in(struct proc* p, struct pageinfo* pi){
80107e4c:	83 ec 1c             	sub    $0x1c,%esp
80107e4f:	8b 75 08             	mov    0x8(%ebp),%esi
80107e52:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pde_t* pgdir = p->pgdir;
80107e55:	8b 46 04             	mov    0x4(%esi),%eax
80107e58:	89 45 e0             	mov    %eax,-0x20(%ebp)
  uint offset = pi->swap_file_offset;
80107e5b:	8b 47 04             	mov    0x4(%edi),%eax
80107e5e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  for (index = 0; index < MAX_PYSC_PAGES; index++){
80107e61:	8d 86 00 02 00 00    	lea    0x200(%esi),%eax
80107e67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107e6e:	66 90                	xchg   %ax,%ax
    if (p->ram_pages[index].is_free){
80107e70:	8b 10                	mov    (%eax),%edx
80107e72:	85 d2                	test   %edx,%edx
80107e74:	0f 85 c6 00 00 00    	jne    80107f40 <swap_in+0x100>
  for (index = 0; index < MAX_PYSC_PAGES; index++){
80107e7a:	83 c3 01             	add    $0x1,%ebx
80107e7d:	83 c0 18             	add    $0x18,%eax
80107e80:	83 fb 10             	cmp    $0x10,%ebx
80107e83:	75 eb                	jne    80107e70 <swap_in+0x30>
      p->ram_pages[index].is_free = 0;
      break;
    }
  }
  void* mem = kalloc();
80107e85:	e8 e6 ae ff ff       	call   80102d70 <kalloc>
  mem = kalloc();
80107e8a:	e8 e1 ae ff ff       	call   80102d70 <kalloc>
80107e8f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(mem == 0){
80107e92:	85 c0                	test   %eax,%eax
80107e94:	0f 84 b9 00 00 00    	je     80107f53 <swap_in+0x113>
    cprintf("swap in - out of memory\n");
    // deallocuvm(pgdir, newsz, oldsz);
    return -1;
  }

  void* va = pi->va;
80107e9a:	8b 47 10             	mov    0x10(%edi),%eax
  pte_t* pte_ptr = walkpgdir(pgdir, va, 0);
80107e9d:	31 c9                	xor    %ecx,%ecx
80107e9f:	89 45 d8             	mov    %eax,-0x28(%ebp)
80107ea2:	89 c2                	mov    %eax,%edx
80107ea4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107ea7:	e8 84 f3 ff ff       	call   80107230 <walkpgdir>
  *pte_ptr &= ~PTE_PG;
  *pte_ptr |= PTE_P;

  // updating physical address written in the page table entry
  *pte_ptr = PTE_FLAGS(*pte_ptr);
  *pte_ptr |= PTE_ADDR(V2P(mem));
80107eac:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107eaf:	8d 91 00 00 00 80    	lea    -0x80000000(%ecx),%edx
80107eb5:	8b 08                	mov    (%eax),%ecx
80107eb7:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107ebd:	81 e1 ff 0d 00 00    	and    $0xdff,%ecx
80107ec3:	09 ca                	or     %ecx,%edx
80107ec5:	83 ca 01             	or     $0x1,%edx
80107ec8:	89 10                	mov    %edx,(%eax)

  p->ram_pages[index].page_index = ++page_counter;
80107eca:	8b 0d c0 b5 10 80    	mov    0x8010b5c0,%ecx
80107ed0:	8d 14 5b             	lea    (%ebx,%ebx,2),%edx
80107ed3:	8d 14 d6             	lea    (%esi,%edx,8),%edx
80107ed6:	8d 41 01             	lea    0x1(%ecx),%eax
80107ed9:	89 82 0c 02 00 00    	mov    %eax,0x20c(%edx)
80107edf:	a3 c0 b5 10 80       	mov    %eax,0x8010b5c0
  p->ram_pages[index].va = va;
80107ee4:	8b 45 d8             	mov    -0x28(%ebp),%eax
80107ee7:	89 82 10 02 00 00    	mov    %eax,0x210(%edx)
  int result = readFromSwapFile(p, mem, offset, PGSIZE);
80107eed:	68 00 10 00 00       	push   $0x1000
80107ef2:	ff 75 dc             	pushl  -0x24(%ebp)
80107ef5:	ff 75 e4             	pushl  -0x1c(%ebp)
80107ef8:	56                   	push   %esi
80107ef9:	e8 82 a8 ff ff       	call   80102780 <readFromSwapFile>

  // clean the struct
  pi->is_free = 1;
80107efe:	c7 07 01 00 00 00    	movl   $0x1,(%edi)
  pi->va = 0;
80107f04:	c7 47 10 00 00 00 00 	movl   $0x0,0x10(%edi)
  pi->swap_file_offset = 0;
80107f0b:	c7 47 04 00 00 00 00 	movl   $0x0,0x4(%edi)

  // refresh rc3
  lcr3(V2P(p->pgdir));
80107f12:	8b 7e 04             	mov    0x4(%esi),%edi
80107f15:	8d 97 00 00 00 80    	lea    -0x80000000(%edi),%edx
80107f1b:	0f 22 da             	mov    %edx,%cr3

  p->num_of_actual_pages_in_mem++;
80107f1e:	83 86 84 03 00 00 01 	addl   $0x1,0x384(%esi)
  p->num_of_pages_in_swap_file--;

  if (result < 0){
80107f25:	83 c4 10             	add    $0x10,%esp
  p->num_of_pages_in_swap_file--;
80107f28:	83 ae 80 03 00 00 01 	subl   $0x1,0x380(%esi)
  if (result < 0){
80107f2f:	85 c0                	test   %eax,%eax
80107f31:	78 37                	js     80107f6a <swap_in+0x12a>
    panic("swap in failed");
  }
  return result;
}
80107f33:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f36:	5b                   	pop    %ebx
80107f37:	5e                   	pop    %esi
80107f38:	5f                   	pop    %edi
80107f39:	5d                   	pop    %ebp
80107f3a:	c3                   	ret    
80107f3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107f3f:	90                   	nop
      p->ram_pages[index].is_free = 0;
80107f40:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
80107f43:	c7 84 c6 00 02 00 00 	movl   $0x0,0x200(%esi,%eax,8)
80107f4a:	00 00 00 00 
      break;
80107f4e:	e9 32 ff ff ff       	jmp    80107e85 <swap_in+0x45>
    cprintf("swap in - out of memory\n");
80107f53:	83 ec 0c             	sub    $0xc,%esp
80107f56:	68 85 8a 10 80       	push   $0x80108a85
80107f5b:	e8 50 87 ff ff       	call   801006b0 <cprintf>
    return -1;
80107f60:	83 c4 10             	add    $0x10,%esp
80107f63:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107f68:	eb c9                	jmp    80107f33 <swap_in+0xf3>
    panic("swap in failed");
80107f6a:	83 ec 0c             	sub    $0xc,%esp
80107f6d:	68 9e 8a 10 80       	push   $0x80108a9e
80107f72:	e8 19 84 ff ff       	call   80100390 <panic>
80107f77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107f7e:	66 90                	xchg   %ax,%ax

80107f80 <swap_page_back>:
 * 3. ram not full - swap in
 * 
 * 
 * */

void swap_page_back(struct proc* p, struct pageinfo* pi_to_swapin){
80107f80:	f3 0f 1e fb          	endbr32 
80107f84:	55                   	push   %ebp
80107f85:	89 e5                	mov    %esp,%ebp
80107f87:	57                   	push   %edi
80107f88:	56                   	push   %esi
80107f89:	53                   	push   %ebx
80107f8a:	83 ec 2c             	sub    $0x2c,%esp
80107f8d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (p->num_of_actual_pages_in_mem == MAX_PYSC_PAGES && p->num_of_pages_in_swap_file == MAX_PYSC_PAGES){
80107f90:	83 bb 84 03 00 00 10 	cmpl   $0x10,0x384(%ebx)
80107f97:	74 17                	je     80107fb0 <swap_page_back+0x30>
    struct pageinfo* page_to_swap = find_page_to_swap(p);
    swap_out(p, page_to_swap, 0, p->pgdir);
    swap_in(p, pi_to_swapin);
  }
  else{
    swap_in(p, pi_to_swapin);
80107f99:	83 ec 08             	sub    $0x8,%esp
80107f9c:	ff 75 0c             	pushl  0xc(%ebp)
80107f9f:	53                   	push   %ebx
80107fa0:	e8 9b fe ff ff       	call   80107e40 <swap_in>
80107fa5:	83 c4 10             	add    $0x10,%esp
  }
}
80107fa8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107fab:	5b                   	pop    %ebx
80107fac:	5e                   	pop    %esi
80107fad:	5f                   	pop    %edi
80107fae:	5d                   	pop    %ebp
80107faf:	c3                   	ret    
  if (p->num_of_actual_pages_in_mem == MAX_PYSC_PAGES && p->num_of_pages_in_swap_file == MAX_PYSC_PAGES){
80107fb0:	8b 83 80 03 00 00    	mov    0x380(%ebx),%eax
80107fb6:	83 f8 10             	cmp    $0x10,%eax
80107fb9:	74 35                	je     80107ff0 <swap_page_back+0x70>
  else if (p->num_of_actual_pages_in_mem == MAX_PYSC_PAGES && p->num_of_pages_in_swap_file < MAX_PYSC_PAGES){
80107fbb:	83 f8 0f             	cmp    $0xf,%eax
80107fbe:	77 d9                	ja     80107f99 <swap_page_back+0x19>
    struct pageinfo* page_to_swap = find_page_to_swap(p);
80107fc0:	83 ec 0c             	sub    $0xc,%esp
80107fc3:	53                   	push   %ebx
80107fc4:	e8 77 f3 ff ff       	call   80107340 <find_page_to_swap>
    swap_out(p, page_to_swap, 0, p->pgdir);
80107fc9:	ff 73 04             	pushl  0x4(%ebx)
80107fcc:	6a 00                	push   $0x0
80107fce:	50                   	push   %eax
80107fcf:	53                   	push   %ebx
80107fd0:	e8 7b fb ff ff       	call   80107b50 <swap_out>
    swap_in(p, pi_to_swapin);
80107fd5:	83 c4 18             	add    $0x18,%esp
80107fd8:	ff 75 0c             	pushl  0xc(%ebp)
80107fdb:	53                   	push   %ebx
80107fdc:	e8 5f fe ff ff       	call   80107e40 <swap_in>
  else if (p->num_of_actual_pages_in_mem == MAX_PYSC_PAGES && p->num_of_pages_in_swap_file < MAX_PYSC_PAGES){
80107fe1:	83 c4 10             	add    $0x10,%esp
}
80107fe4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107fe7:	5b                   	pop    %ebx
80107fe8:	5e                   	pop    %esi
80107fe9:	5f                   	pop    %edi
80107fea:	5d                   	pop    %ebp
80107feb:	c3                   	ret    
80107fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    char* buffer = kalloc();
80107ff0:	e8 7b ad ff ff       	call   80102d70 <kalloc>
    struct pageinfo* page_to_swap = find_page_to_swap(p);
80107ff5:	83 ec 0c             	sub    $0xc,%esp
80107ff8:	53                   	push   %ebx
    char* buffer = kalloc();
80107ff9:	89 c7                	mov    %eax,%edi
    struct pageinfo* page_to_swap = find_page_to_swap(p);
80107ffb:	e8 40 f3 ff ff       	call   80107340 <find_page_to_swap>
    memmove(buffer, page_to_swap->va, PGSIZE);
80108000:	83 c4 0c             	add    $0xc,%esp
80108003:	68 00 10 00 00       	push   $0x1000
    struct pageinfo* page_to_swap = find_page_to_swap(p);
80108008:	89 c6                	mov    %eax,%esi
    memmove(buffer, page_to_swap->va, PGSIZE);
8010800a:	ff 70 10             	pushl  0x10(%eax)
8010800d:	57                   	push   %edi
8010800e:	e8 cd d0 ff ff       	call   801050e0 <memmove>
    pi = *page_to_swap;
80108013:	8b 06                	mov    (%esi),%eax
80108015:	89 45 d0             	mov    %eax,-0x30(%ebp)
80108018:	8b 46 04             	mov    0x4(%esi),%eax
8010801b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
8010801e:	8b 46 08             	mov    0x8(%esi),%eax
80108021:	89 45 d8             	mov    %eax,-0x28(%ebp)
80108024:	8b 46 0c             	mov    0xc(%esi),%eax
80108027:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010802a:	8b 46 10             	mov    0x10(%esi),%eax
8010802d:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108030:	8b 46 14             	mov    0x14(%esi),%eax
80108033:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    page_to_swap->is_free = 1;
80108036:	c7 06 01 00 00 00    	movl   $0x1,(%esi)
    swap_in(p, page_to_swap);
8010803c:	58                   	pop    %eax
8010803d:	5a                   	pop    %edx
8010803e:	56                   	push   %esi
8010803f:	53                   	push   %ebx
80108040:	e8 fb fd ff ff       	call   80107e40 <swap_in>
    swap_out(p, &pi, buffer, p->pgdir);
80108045:	8d 45 d0             	lea    -0x30(%ebp),%eax
80108048:	ff 73 04             	pushl  0x4(%ebx)
8010804b:	57                   	push   %edi
8010804c:	50                   	push   %eax
8010804d:	53                   	push   %ebx
8010804e:	e8 fd fa ff ff       	call   80107b50 <swap_out>
  if (p->num_of_actual_pages_in_mem == MAX_PYSC_PAGES && p->num_of_pages_in_swap_file == MAX_PYSC_PAGES){
80108053:	83 c4 20             	add    $0x20,%esp
80108056:	e9 4d ff ff ff       	jmp    80107fa8 <swap_page_back+0x28>
