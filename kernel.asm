
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
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
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
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 60 30 10 80       	mov    $0x80103060,%eax
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
80100048:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 80 71 10 80       	push   $0x80107180
80100055:	68 c0 b5 10 80       	push   $0x8010b5c0
8010005a:	e8 a1 43 00 00       	call   80104400 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 bc fc 10 80       	mov    $0x8010fcbc,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
8010006e:	fc 10 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
80100078:	fc 10 80 
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
8010008b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 87 71 10 80       	push   $0x80107187
80100097:	50                   	push   %eax
80100098:	e8 23 42 00 00       	call   801042c0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb 60 fa 10 80    	cmp    $0x8010fa60,%ebx
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
801000e3:	68 c0 b5 10 80       	push   $0x8010b5c0
801000e8:	e8 93 44 00 00       	call   80104580 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
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
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
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
8010015d:	68 c0 b5 10 80       	push   $0x8010b5c0
80100162:	e8 d9 44 00 00       	call   80104640 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 8e 41 00 00       	call   80104300 <acquiresleep>
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
8010018c:	e8 0f 21 00 00       	call   801022a0 <iderw>
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
801001a3:	68 8e 71 10 80       	push   $0x8010718e
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
801001c2:	e8 d9 41 00 00       	call   801043a0 <holdingsleep>
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
801001d8:	e9 c3 20 00 00       	jmp    801022a0 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 9f 71 10 80       	push   $0x8010719f
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
80100203:	e8 98 41 00 00       	call   801043a0 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 48 41 00 00       	call   80104360 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010021f:	e8 5c 43 00 00       	call   80104580 <acquire>
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
80100246:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 cb 43 00 00       	jmp    80104640 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 a6 71 10 80       	push   $0x801071a6
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
801002a5:	e8 b6 15 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801002b1:	e8 ca 42 00 00       	call   80104580 <acquire>
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
801002c6:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002cb:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 20 a5 10 80       	push   $0x8010a520
801002e0:	68 a0 ff 10 80       	push   $0x8010ffa0
801002e5:	e8 56 3c 00 00       	call   80103f40 <sleep>
    while(input.r == input.w){
801002ea:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 81 36 00 00       	call   80103980 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 a5 10 80       	push   $0x8010a520
8010030e:	e8 2d 43 00 00       	call   80104640 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 64 14 00 00       	call   80101780 <ilock>
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
80100333:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 20 ff 10 80 	movsbl -0x7fef00e0(%edx),%ecx
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
80100360:	68 20 a5 10 80       	push   $0x8010a520
80100365:	e8 d6 42 00 00       	call   80104640 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 0d 14 00 00       	call   80101780 <ilock>
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
80100386:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
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
8010039d:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
801003a4:	00 00 00 
  getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 0e 25 00 00       	call   801028c0 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 ad 71 10 80       	push   $0x801071ad
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 db 7a 10 80 	movl   $0x80107adb,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 3f 40 00 00       	call   80104420 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 c1 71 10 80       	push   $0x801071c1
801003f1:	e8 ba 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003f6:	83 c4 10             	add    $0x10,%esp
801003f9:	39 f3                	cmp    %esi,%ebx
801003fb:	75 e7                	jne    801003e4 <panic+0x54>
  panicked = 1; // freeze other CPU
801003fd:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
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
8010042a:	e8 41 59 00 00       	call   80105d70 <uartputc>
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
80100515:	e8 56 58 00 00       	call   80105d70 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 4a 58 00 00       	call   80105d70 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 3e 58 00 00       	call   80105d70 <uartputc>
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
80100561:	e8 ca 41 00 00       	call   80104730 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 15 41 00 00       	call   80104690 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 c5 71 10 80       	push   $0x801071c5
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
801005c9:	0f b6 92 f0 71 10 80 	movzbl -0x7fef8e10(%edx),%edx
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
80100603:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
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
80100653:	e8 08 12 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
80100658:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010065f:	e8 1c 3f 00 00       	call   80104580 <acquire>
  for(i = 0; i < n; i++)
80100664:	83 c4 10             	add    $0x10,%esp
80100667:	85 db                	test   %ebx,%ebx
80100669:	7e 24                	jle    8010068f <consolewrite+0x4f>
8010066b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010066e:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
80100671:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
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
80100692:	68 20 a5 10 80       	push   $0x8010a520
80100697:	e8 a4 3f 00 00       	call   80104640 <release>
  ilock(ip);
8010069c:	58                   	pop    %eax
8010069d:	ff 75 08             	pushl  0x8(%ebp)
801006a0:	e8 db 10 00 00       	call   80101780 <ilock>

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
801006bd:	a1 54 a5 10 80       	mov    0x8010a554,%eax
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
801006ec:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
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
8010077d:	bb d8 71 10 80       	mov    $0x801071d8,%ebx
      for(; *s; s++)
80100782:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
80100787:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
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
801007b8:	68 20 a5 10 80       	push   $0x8010a520
801007bd:	e8 be 3d 00 00       	call   80104580 <acquire>
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
801007e0:	8b 3d 58 a5 10 80    	mov    0x8010a558,%edi
801007e6:	85 ff                	test   %edi,%edi
801007e8:	0f 84 12 ff ff ff    	je     80100700 <cprintf+0x50>
801007ee:	fa                   	cli    
    for(;;)
801007ef:	eb fe                	jmp    801007ef <cprintf+0x13f>
801007f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801007f8:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
801007fe:	85 c9                	test   %ecx,%ecx
80100800:	74 06                	je     80100808 <cprintf+0x158>
80100802:	fa                   	cli    
    for(;;)
80100803:	eb fe                	jmp    80100803 <cprintf+0x153>
80100805:	8d 76 00             	lea    0x0(%esi),%esi
80100808:	b8 25 00 00 00       	mov    $0x25,%eax
8010080d:	e8 fe fb ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100812:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100818:	85 d2                	test   %edx,%edx
8010081a:	74 2c                	je     80100848 <cprintf+0x198>
8010081c:	fa                   	cli    
    for(;;)
8010081d:	eb fe                	jmp    8010081d <cprintf+0x16d>
8010081f:	90                   	nop
    release(&cons.lock);
80100820:	83 ec 0c             	sub    $0xc,%esp
80100823:	68 20 a5 10 80       	push   $0x8010a520
80100828:	e8 13 3e 00 00       	call   80104640 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 df 71 10 80       	push   $0x801071df
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
80100872:	68 20 a5 10 80       	push   $0x8010a520
80100877:	e8 04 3d 00 00       	call   80104580 <acquire>
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
801008b4:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008b9:	89 c2                	mov    %eax,%edx
801008bb:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
801008c1:	83 fa 7f             	cmp    $0x7f,%edx
801008c4:	77 d2                	ja     80100898 <consoleintr+0x38>
        c = (c == '\r') ? '\n' : c;
801008c6:	8d 48 01             	lea    0x1(%eax),%ecx
801008c9:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801008cf:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
801008d2:	89 0d a8 ff 10 80    	mov    %ecx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
801008d8:	83 fb 0d             	cmp    $0xd,%ebx
801008db:	0f 84 02 01 00 00    	je     801009e3 <consoleintr+0x183>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e1:	88 98 20 ff 10 80    	mov    %bl,-0x7fef00e0(%eax)
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
80100908:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
8010090d:	83 e8 80             	sub    $0xffffff80,%eax
80100910:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
80100916:	75 80                	jne    80100898 <consoleintr+0x38>
80100918:	e9 f6 00 00 00       	jmp    80100a13 <consoleintr+0x1b3>
8010091d:	8d 76 00             	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100920:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100925:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
8010092b:	0f 84 67 ff ff ff    	je     80100898 <consoleintr+0x38>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100931:	83 e8 01             	sub    $0x1,%eax
80100934:	89 c2                	mov    %eax,%edx
80100936:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100939:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
80100940:	0f 84 52 ff ff ff    	je     80100898 <consoleintr+0x38>
  if(panicked){
80100946:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
        input.e--;
8010094c:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
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
8010096a:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010096f:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
80100975:	75 ba                	jne    80100931 <consoleintr+0xd1>
80100977:	e9 1c ff ff ff       	jmp    80100898 <consoleintr+0x38>
8010097c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(input.e != input.w){
80100980:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100985:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010098b:	0f 84 07 ff ff ff    	je     80100898 <consoleintr+0x38>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
  if(panicked){
80100999:	a1 58 a5 10 80       	mov    0x8010a558,%eax
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
801009ca:	68 20 a5 10 80       	push   $0x8010a520
801009cf:	e8 6c 3c 00 00       	call   80104640 <release>
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
801009e3:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
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
801009ff:	e9 ec 37 00 00       	jmp    801041f0 <procdump>
80100a04:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a09:	e8 02 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100a0e:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
          wakeup(&input.r);
80100a13:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a16:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
80100a1b:	68 a0 ff 10 80       	push   $0x8010ffa0
80100a20:	e8 db 36 00 00       	call   80104100 <wakeup>
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
80100a3a:	68 e8 71 10 80       	push   $0x801071e8
80100a3f:	68 20 a5 10 80       	push   $0x8010a520
80100a44:	e8 b7 39 00 00       	call   80104400 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a49:	58                   	pop    %eax
80100a4a:	5a                   	pop    %edx
80100a4b:	6a 00                	push   $0x0
80100a4d:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a4f:	c7 05 6c 09 11 80 40 	movl   $0x80100640,0x8011096c
80100a56:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a59:	c7 05 68 09 11 80 90 	movl   $0x80100290,0x80110968
80100a60:	02 10 80 
  cons.locking = 1;
80100a63:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100a6a:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a6d:	e8 de 19 00 00       	call   80102450 <ioapicenable>
}
80100a72:	83 c4 10             	add    $0x10,%esp
80100a75:	c9                   	leave  
80100a76:	c3                   	ret    
80100a77:	66 90                	xchg   %ax,%ax
80100a79:	66 90                	xchg   %ax,%ax
80100a7b:	66 90                	xchg   %ax,%ax
80100a7d:	66 90                	xchg   %ax,%ax
80100a7f:	90                   	nop

80100a80 <pseudo_main>:
#include "proc.h"
#include "defs.h"
#include "x86.h"
#include "elf.h"

void pseudo_main(int (*entry)(int, char**), int argc, char **argv){
80100a80:	f3 0f 1e fb          	endbr32 
80100a84:	55                   	push   %ebp
80100a85:	89 e5                	mov    %esp,%ebp
80100a87:	83 ec 10             	sub    $0x10,%esp
  int exit_status = entry(argc, argv);
80100a8a:	ff 75 10             	pushl  0x10(%ebp)
80100a8d:	ff 75 0c             	pushl  0xc(%ebp)
80100a90:	ff 55 08             	call   *0x8(%ebp)
  exit(exit_status);
80100a93:	89 45 08             	mov    %eax,0x8(%ebp)
80100a96:	83 c4 10             	add    $0x10,%esp
}
80100a99:	c9                   	leave  
  exit(exit_status);
80100a9a:	e9 11 33 00 00       	jmp    80103db0 <exit>
80100a9f:	90                   	nop

80100aa0 <exec>:

int
exec(char *path, char **argv)
{
80100aa0:	f3 0f 1e fb          	endbr32 
80100aa4:	55                   	push   %ebp
80100aa5:	89 e5                	mov    %esp,%ebp
80100aa7:	57                   	push   %edi
80100aa8:	56                   	push   %esi
80100aa9:	53                   	push   %ebx
80100aaa:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100ab0:	e8 cb 2e 00 00       	call   80103980 <myproc>
80100ab5:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100abb:	e8 90 22 00 00       	call   80102d50 <begin_op>

  if((ip = namei(path)) == 0){
80100ac0:	83 ec 0c             	sub    $0xc,%esp
80100ac3:	ff 75 08             	pushl  0x8(%ebp)
80100ac6:	e8 85 15 00 00       	call   80102050 <namei>
80100acb:	83 c4 10             	add    $0x10,%esp
80100ace:	85 c0                	test   %eax,%eax
80100ad0:	0f 84 fe 02 00 00    	je     80100dd4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ad6:	83 ec 0c             	sub    $0xc,%esp
80100ad9:	89 c3                	mov    %eax,%ebx
80100adb:	50                   	push   %eax
80100adc:	e8 9f 0c 00 00       	call   80101780 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100ae1:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ae7:	6a 34                	push   $0x34
80100ae9:	6a 00                	push   $0x0
80100aeb:	50                   	push   %eax
80100aec:	53                   	push   %ebx
80100aed:	e8 8e 0f 00 00       	call   80101a80 <readi>
80100af2:	83 c4 20             	add    $0x20,%esp
80100af5:	83 f8 34             	cmp    $0x34,%eax
80100af8:	74 26                	je     80100b20 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100afa:	83 ec 0c             	sub    $0xc,%esp
80100afd:	53                   	push   %ebx
80100afe:	e8 1d 0f 00 00       	call   80101a20 <iunlockput>
    end_op();
80100b03:	e8 b8 22 00 00       	call   80102dc0 <end_op>
80100b08:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100b0b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b10:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b13:	5b                   	pop    %ebx
80100b14:	5e                   	pop    %esi
80100b15:	5f                   	pop    %edi
80100b16:	5d                   	pop    %ebp
80100b17:	c3                   	ret    
80100b18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b1f:	90                   	nop
  if(elf.magic != ELF_MAGIC)
80100b20:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b27:	45 4c 46 
80100b2a:	75 ce                	jne    80100afa <exec+0x5a>
  if((pgdir = setupkvm()) == 0)
80100b2c:	e8 af 63 00 00       	call   80106ee0 <setupkvm>
80100b31:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b37:	85 c0                	test   %eax,%eax
80100b39:	74 bf                	je     80100afa <exec+0x5a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b3b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b42:	00 
80100b43:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b49:	0f 84 a4 02 00 00    	je     80100df3 <exec+0x353>
  sz = 0;
80100b4f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b56:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b59:	31 ff                	xor    %edi,%edi
80100b5b:	e9 86 00 00 00       	jmp    80100be6 <exec+0x146>
    if(ph.type != ELF_PROG_LOAD)
80100b60:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b67:	75 6c                	jne    80100bd5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b69:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b6f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b75:	0f 82 87 00 00 00    	jb     80100c02 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b7b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b81:	72 7f                	jb     80100c02 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b83:	83 ec 04             	sub    $0x4,%esp
80100b86:	50                   	push   %eax
80100b87:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b8d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b93:	e8 68 61 00 00       	call   80106d00 <allocuvm>
80100b98:	83 c4 10             	add    $0x10,%esp
80100b9b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100ba1:	85 c0                	test   %eax,%eax
80100ba3:	74 5d                	je     80100c02 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100ba5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bab:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100bb0:	75 50                	jne    80100c02 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100bb2:	83 ec 0c             	sub    $0xc,%esp
80100bb5:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100bbb:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100bc1:	53                   	push   %ebx
80100bc2:	50                   	push   %eax
80100bc3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100bc9:	e8 62 60 00 00       	call   80106c30 <loaduvm>
80100bce:	83 c4 20             	add    $0x20,%esp
80100bd1:	85 c0                	test   %eax,%eax
80100bd3:	78 2d                	js     80100c02 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bd5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bdc:	83 c7 01             	add    $0x1,%edi
80100bdf:	83 c6 20             	add    $0x20,%esi
80100be2:	39 f8                	cmp    %edi,%eax
80100be4:	7e 3a                	jle    80100c20 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100be6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bec:	6a 20                	push   $0x20
80100bee:	56                   	push   %esi
80100bef:	50                   	push   %eax
80100bf0:	53                   	push   %ebx
80100bf1:	e8 8a 0e 00 00       	call   80101a80 <readi>
80100bf6:	83 c4 10             	add    $0x10,%esp
80100bf9:	83 f8 20             	cmp    $0x20,%eax
80100bfc:	0f 84 5e ff ff ff    	je     80100b60 <exec+0xc0>
    freevm(pgdir);
80100c02:	83 ec 0c             	sub    $0xc,%esp
80100c05:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100c0b:	e8 50 62 00 00       	call   80106e60 <freevm>
  if(ip){
80100c10:	83 c4 10             	add    $0x10,%esp
80100c13:	e9 e2 fe ff ff       	jmp    80100afa <exec+0x5a>
80100c18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c1f:	90                   	nop
80100c20:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c26:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c2c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100c32:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c38:	83 ec 0c             	sub    $0xc,%esp
80100c3b:	53                   	push   %ebx
80100c3c:	e8 df 0d 00 00       	call   80101a20 <iunlockput>
  end_op();
80100c41:	e8 7a 21 00 00       	call   80102dc0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c46:	83 c4 0c             	add    $0xc,%esp
80100c49:	56                   	push   %esi
80100c4a:	57                   	push   %edi
80100c4b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c51:	57                   	push   %edi
80100c52:	e8 a9 60 00 00       	call   80106d00 <allocuvm>
80100c57:	83 c4 10             	add    $0x10,%esp
80100c5a:	89 c6                	mov    %eax,%esi
80100c5c:	85 c0                	test   %eax,%eax
80100c5e:	0f 84 94 00 00 00    	je     80100cf8 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c64:	83 ec 08             	sub    $0x8,%esp
80100c67:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c6d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c6f:	50                   	push   %eax
80100c70:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c71:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c73:	e8 08 63 00 00       	call   80106f80 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c78:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c7b:	83 c4 10             	add    $0x10,%esp
80100c7e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c84:	8b 00                	mov    (%eax),%eax
80100c86:	85 c0                	test   %eax,%eax
80100c88:	0f 84 8b 00 00 00    	je     80100d19 <exec+0x279>
80100c8e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100c94:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c9a:	eb 23                	jmp    80100cbf <exec+0x21f>
80100c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100ca0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100ca3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100caa:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100cad:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100cb3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100cb6:	85 c0                	test   %eax,%eax
80100cb8:	74 59                	je     80100d13 <exec+0x273>
    if(argc >= MAXARG)
80100cba:	83 ff 20             	cmp    $0x20,%edi
80100cbd:	74 39                	je     80100cf8 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cbf:	83 ec 0c             	sub    $0xc,%esp
80100cc2:	50                   	push   %eax
80100cc3:	e8 c8 3b 00 00       	call   80104890 <strlen>
80100cc8:	f7 d0                	not    %eax
80100cca:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ccc:	58                   	pop    %eax
80100ccd:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cd0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cd3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cd6:	e8 b5 3b 00 00       	call   80104890 <strlen>
80100cdb:	83 c0 01             	add    $0x1,%eax
80100cde:	50                   	push   %eax
80100cdf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ce2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100ce5:	53                   	push   %ebx
80100ce6:	56                   	push   %esi
80100ce7:	e8 f4 63 00 00       	call   801070e0 <copyout>
80100cec:	83 c4 20             	add    $0x20,%esp
80100cef:	85 c0                	test   %eax,%eax
80100cf1:	79 ad                	jns    80100ca0 <exec+0x200>
80100cf3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cf7:	90                   	nop
    freevm(pgdir);
80100cf8:	83 ec 0c             	sub    $0xc,%esp
80100cfb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100d01:	e8 5a 61 00 00       	call   80106e60 <freevm>
80100d06:	83 c4 10             	add    $0x10,%esp
  return -1;
80100d09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d0e:	e9 fd fd ff ff       	jmp    80100b10 <exec+0x70>
80100d13:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d19:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d20:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d22:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d29:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d2d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d2f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d32:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d38:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d3a:	50                   	push   %eax
80100d3b:	52                   	push   %edx
80100d3c:	53                   	push   %ebx
80100d3d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d43:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d4a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d4d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d53:	e8 88 63 00 00       	call   801070e0 <copyout>
80100d58:	83 c4 10             	add    $0x10,%esp
80100d5b:	85 c0                	test   %eax,%eax
80100d5d:	78 99                	js     80100cf8 <exec+0x258>
  for(last=s=path; *s; s++)
80100d5f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d62:	8b 55 08             	mov    0x8(%ebp),%edx
80100d65:	0f b6 00             	movzbl (%eax),%eax
80100d68:	84 c0                	test   %al,%al
80100d6a:	74 13                	je     80100d7f <exec+0x2df>
80100d6c:	89 d1                	mov    %edx,%ecx
80100d6e:	66 90                	xchg   %ax,%ax
    if(*s == '/')
80100d70:	83 c1 01             	add    $0x1,%ecx
80100d73:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d75:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80100d78:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d7b:	84 c0                	test   %al,%al
80100d7d:	75 f1                	jne    80100d70 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d7f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d85:	83 ec 04             	sub    $0x4,%esp
80100d88:	6a 10                	push   $0x10
80100d8a:	89 f8                	mov    %edi,%eax
80100d8c:	52                   	push   %edx
80100d8d:	83 c0 6c             	add    $0x6c,%eax
80100d90:	50                   	push   %eax
80100d91:	e8 ba 3a 00 00       	call   80104850 <safestrcpy>
  curproc->pgdir = pgdir;
80100d96:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100d9c:	89 f8                	mov    %edi,%eax
80100d9e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100da1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100da3:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry ;// ;  // main
80100da6:	89 c1                	mov    %eax,%ecx
80100da8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dae:	8b 40 18             	mov    0x18(%eax),%eax
80100db1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100db4:	8b 41 18             	mov    0x18(%ecx),%eax
80100db7:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100dba:	89 0c 24             	mov    %ecx,(%esp)
80100dbd:	e8 de 5c 00 00       	call   80106aa0 <switchuvm>
  freevm(oldpgdir);
80100dc2:	89 3c 24             	mov    %edi,(%esp)
80100dc5:	e8 96 60 00 00       	call   80106e60 <freevm>
  return 0;
80100dca:	83 c4 10             	add    $0x10,%esp
80100dcd:	31 c0                	xor    %eax,%eax
80100dcf:	e9 3c fd ff ff       	jmp    80100b10 <exec+0x70>
    end_op();
80100dd4:	e8 e7 1f 00 00       	call   80102dc0 <end_op>
    cprintf("exec: fail\n");
80100dd9:	83 ec 0c             	sub    $0xc,%esp
80100ddc:	68 01 72 10 80       	push   $0x80107201
80100de1:	e8 ca f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100de6:	83 c4 10             	add    $0x10,%esp
80100de9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dee:	e9 1d fd ff ff       	jmp    80100b10 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100df3:	31 ff                	xor    %edi,%edi
80100df5:	be 00 20 00 00       	mov    $0x2000,%esi
80100dfa:	e9 39 fe ff ff       	jmp    80100c38 <exec+0x198>
80100dff:	90                   	nop

80100e00 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e00:	f3 0f 1e fb          	endbr32 
80100e04:	55                   	push   %ebp
80100e05:	89 e5                	mov    %esp,%ebp
80100e07:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e0a:	68 0d 72 10 80       	push   $0x8010720d
80100e0f:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e14:	e8 e7 35 00 00       	call   80104400 <initlock>
}
80100e19:	83 c4 10             	add    $0x10,%esp
80100e1c:	c9                   	leave  
80100e1d:	c3                   	ret    
80100e1e:	66 90                	xchg   %ax,%ax

80100e20 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e20:	f3 0f 1e fb          	endbr32 
80100e24:	55                   	push   %ebp
80100e25:	89 e5                	mov    %esp,%ebp
80100e27:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e28:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100e2d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e30:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e35:	e8 46 37 00 00       	call   80104580 <acquire>
80100e3a:	83 c4 10             	add    $0x10,%esp
80100e3d:	eb 0c                	jmp    80100e4b <filealloc+0x2b>
80100e3f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e40:	83 c3 18             	add    $0x18,%ebx
80100e43:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100e49:	74 25                	je     80100e70 <filealloc+0x50>
    if(f->ref == 0){
80100e4b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e4e:	85 c0                	test   %eax,%eax
80100e50:	75 ee                	jne    80100e40 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e52:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e55:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e5c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e61:	e8 da 37 00 00       	call   80104640 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e66:	89 d8                	mov    %ebx,%eax
      return f;
80100e68:	83 c4 10             	add    $0x10,%esp
}
80100e6b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e6e:	c9                   	leave  
80100e6f:	c3                   	ret    
  release(&ftable.lock);
80100e70:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e73:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e75:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e7a:	e8 c1 37 00 00       	call   80104640 <release>
}
80100e7f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e81:	83 c4 10             	add    $0x10,%esp
}
80100e84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e87:	c9                   	leave  
80100e88:	c3                   	ret    
80100e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e90 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e90:	f3 0f 1e fb          	endbr32 
80100e94:	55                   	push   %ebp
80100e95:	89 e5                	mov    %esp,%ebp
80100e97:	53                   	push   %ebx
80100e98:	83 ec 10             	sub    $0x10,%esp
80100e9b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e9e:	68 c0 ff 10 80       	push   $0x8010ffc0
80100ea3:	e8 d8 36 00 00       	call   80104580 <acquire>
  if(f->ref < 1)
80100ea8:	8b 43 04             	mov    0x4(%ebx),%eax
80100eab:	83 c4 10             	add    $0x10,%esp
80100eae:	85 c0                	test   %eax,%eax
80100eb0:	7e 1a                	jle    80100ecc <filedup+0x3c>
    panic("filedup");
  f->ref++;
80100eb2:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100eb5:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100eb8:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ebb:	68 c0 ff 10 80       	push   $0x8010ffc0
80100ec0:	e8 7b 37 00 00       	call   80104640 <release>
  return f;
}
80100ec5:	89 d8                	mov    %ebx,%eax
80100ec7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eca:	c9                   	leave  
80100ecb:	c3                   	ret    
    panic("filedup");
80100ecc:	83 ec 0c             	sub    $0xc,%esp
80100ecf:	68 14 72 10 80       	push   $0x80107214
80100ed4:	e8 b7 f4 ff ff       	call   80100390 <panic>
80100ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ee0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ee0:	f3 0f 1e fb          	endbr32 
80100ee4:	55                   	push   %ebp
80100ee5:	89 e5                	mov    %esp,%ebp
80100ee7:	57                   	push   %edi
80100ee8:	56                   	push   %esi
80100ee9:	53                   	push   %ebx
80100eea:	83 ec 28             	sub    $0x28,%esp
80100eed:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100ef0:	68 c0 ff 10 80       	push   $0x8010ffc0
80100ef5:	e8 86 36 00 00       	call   80104580 <acquire>
  if(f->ref < 1)
80100efa:	8b 53 04             	mov    0x4(%ebx),%edx
80100efd:	83 c4 10             	add    $0x10,%esp
80100f00:	85 d2                	test   %edx,%edx
80100f02:	0f 8e a1 00 00 00    	jle    80100fa9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f08:	83 ea 01             	sub    $0x1,%edx
80100f0b:	89 53 04             	mov    %edx,0x4(%ebx)
80100f0e:	75 40                	jne    80100f50 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f10:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f14:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f17:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f19:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f1f:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f22:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f25:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f28:	68 c0 ff 10 80       	push   $0x8010ffc0
  ff = *f;
80100f2d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f30:	e8 0b 37 00 00       	call   80104640 <release>

  if(ff.type == FD_PIPE)
80100f35:	83 c4 10             	add    $0x10,%esp
80100f38:	83 ff 01             	cmp    $0x1,%edi
80100f3b:	74 53                	je     80100f90 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f3d:	83 ff 02             	cmp    $0x2,%edi
80100f40:	74 26                	je     80100f68 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f42:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f45:	5b                   	pop    %ebx
80100f46:	5e                   	pop    %esi
80100f47:	5f                   	pop    %edi
80100f48:	5d                   	pop    %ebp
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f50:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
}
80100f57:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f5a:	5b                   	pop    %ebx
80100f5b:	5e                   	pop    %esi
80100f5c:	5f                   	pop    %edi
80100f5d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f5e:	e9 dd 36 00 00       	jmp    80104640 <release>
80100f63:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f67:	90                   	nop
    begin_op();
80100f68:	e8 e3 1d 00 00       	call   80102d50 <begin_op>
    iput(ff.ip);
80100f6d:	83 ec 0c             	sub    $0xc,%esp
80100f70:	ff 75 e0             	pushl  -0x20(%ebp)
80100f73:	e8 38 09 00 00       	call   801018b0 <iput>
    end_op();
80100f78:	83 c4 10             	add    $0x10,%esp
}
80100f7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f7e:	5b                   	pop    %ebx
80100f7f:	5e                   	pop    %esi
80100f80:	5f                   	pop    %edi
80100f81:	5d                   	pop    %ebp
    end_op();
80100f82:	e9 39 1e 00 00       	jmp    80102dc0 <end_op>
80100f87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f8e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100f90:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f94:	83 ec 08             	sub    $0x8,%esp
80100f97:	53                   	push   %ebx
80100f98:	56                   	push   %esi
80100f99:	e8 82 25 00 00       	call   80103520 <pipeclose>
80100f9e:	83 c4 10             	add    $0x10,%esp
}
80100fa1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fa4:	5b                   	pop    %ebx
80100fa5:	5e                   	pop    %esi
80100fa6:	5f                   	pop    %edi
80100fa7:	5d                   	pop    %ebp
80100fa8:	c3                   	ret    
    panic("fileclose");
80100fa9:	83 ec 0c             	sub    $0xc,%esp
80100fac:	68 1c 72 10 80       	push   $0x8010721c
80100fb1:	e8 da f3 ff ff       	call   80100390 <panic>
80100fb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fbd:	8d 76 00             	lea    0x0(%esi),%esi

80100fc0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fc0:	f3 0f 1e fb          	endbr32 
80100fc4:	55                   	push   %ebp
80100fc5:	89 e5                	mov    %esp,%ebp
80100fc7:	53                   	push   %ebx
80100fc8:	83 ec 04             	sub    $0x4,%esp
80100fcb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fce:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fd1:	75 2d                	jne    80101000 <filestat+0x40>
    ilock(f->ip);
80100fd3:	83 ec 0c             	sub    $0xc,%esp
80100fd6:	ff 73 10             	pushl  0x10(%ebx)
80100fd9:	e8 a2 07 00 00       	call   80101780 <ilock>
    stati(f->ip, st);
80100fde:	58                   	pop    %eax
80100fdf:	5a                   	pop    %edx
80100fe0:	ff 75 0c             	pushl  0xc(%ebp)
80100fe3:	ff 73 10             	pushl  0x10(%ebx)
80100fe6:	e8 65 0a 00 00       	call   80101a50 <stati>
    iunlock(f->ip);
80100feb:	59                   	pop    %ecx
80100fec:	ff 73 10             	pushl  0x10(%ebx)
80100fef:	e8 6c 08 00 00       	call   80101860 <iunlock>
    return 0;
  }
  return -1;
}
80100ff4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80100ff7:	83 c4 10             	add    $0x10,%esp
80100ffa:	31 c0                	xor    %eax,%eax
}
80100ffc:	c9                   	leave  
80100ffd:	c3                   	ret    
80100ffe:	66 90                	xchg   %ax,%ax
80101000:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101003:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101008:	c9                   	leave  
80101009:	c3                   	ret    
8010100a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101010 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101010:	f3 0f 1e fb          	endbr32 
80101014:	55                   	push   %ebp
80101015:	89 e5                	mov    %esp,%ebp
80101017:	57                   	push   %edi
80101018:	56                   	push   %esi
80101019:	53                   	push   %ebx
8010101a:	83 ec 0c             	sub    $0xc,%esp
8010101d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101020:	8b 75 0c             	mov    0xc(%ebp),%esi
80101023:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101026:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
8010102a:	74 64                	je     80101090 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
8010102c:	8b 03                	mov    (%ebx),%eax
8010102e:	83 f8 01             	cmp    $0x1,%eax
80101031:	74 45                	je     80101078 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101033:	83 f8 02             	cmp    $0x2,%eax
80101036:	75 5f                	jne    80101097 <fileread+0x87>
    ilock(f->ip);
80101038:	83 ec 0c             	sub    $0xc,%esp
8010103b:	ff 73 10             	pushl  0x10(%ebx)
8010103e:	e8 3d 07 00 00       	call   80101780 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101043:	57                   	push   %edi
80101044:	ff 73 14             	pushl  0x14(%ebx)
80101047:	56                   	push   %esi
80101048:	ff 73 10             	pushl  0x10(%ebx)
8010104b:	e8 30 0a 00 00       	call   80101a80 <readi>
80101050:	83 c4 20             	add    $0x20,%esp
80101053:	89 c6                	mov    %eax,%esi
80101055:	85 c0                	test   %eax,%eax
80101057:	7e 03                	jle    8010105c <fileread+0x4c>
      f->off += r;
80101059:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
8010105c:	83 ec 0c             	sub    $0xc,%esp
8010105f:	ff 73 10             	pushl  0x10(%ebx)
80101062:	e8 f9 07 00 00       	call   80101860 <iunlock>
    return r;
80101067:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
8010106a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010106d:	89 f0                	mov    %esi,%eax
8010106f:	5b                   	pop    %ebx
80101070:	5e                   	pop    %esi
80101071:	5f                   	pop    %edi
80101072:	5d                   	pop    %ebp
80101073:	c3                   	ret    
80101074:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
80101078:	8b 43 0c             	mov    0xc(%ebx),%eax
8010107b:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010107e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101081:	5b                   	pop    %ebx
80101082:	5e                   	pop    %esi
80101083:	5f                   	pop    %edi
80101084:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80101085:	e9 36 26 00 00       	jmp    801036c0 <piperead>
8010108a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101090:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101095:	eb d3                	jmp    8010106a <fileread+0x5a>
  panic("fileread");
80101097:	83 ec 0c             	sub    $0xc,%esp
8010109a:	68 26 72 10 80       	push   $0x80107226
8010109f:	e8 ec f2 ff ff       	call   80100390 <panic>
801010a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801010af:	90                   	nop

801010b0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010b0:	f3 0f 1e fb          	endbr32 
801010b4:	55                   	push   %ebp
801010b5:	89 e5                	mov    %esp,%ebp
801010b7:	57                   	push   %edi
801010b8:	56                   	push   %esi
801010b9:	53                   	push   %ebx
801010ba:	83 ec 1c             	sub    $0x1c,%esp
801010bd:	8b 45 0c             	mov    0xc(%ebp),%eax
801010c0:	8b 75 08             	mov    0x8(%ebp),%esi
801010c3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010c6:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010c9:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801010cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010d0:	0f 84 c1 00 00 00    	je     80101197 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
801010d6:	8b 06                	mov    (%esi),%eax
801010d8:	83 f8 01             	cmp    $0x1,%eax
801010db:	0f 84 c3 00 00 00    	je     801011a4 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010e1:	83 f8 02             	cmp    $0x2,%eax
801010e4:	0f 85 cc 00 00 00    	jne    801011b6 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010ed:	31 ff                	xor    %edi,%edi
    while(i < n){
801010ef:	85 c0                	test   %eax,%eax
801010f1:	7f 34                	jg     80101127 <filewrite+0x77>
801010f3:	e9 98 00 00 00       	jmp    80101190 <filewrite+0xe0>
801010f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010ff:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101100:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
80101103:	83 ec 0c             	sub    $0xc,%esp
80101106:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101109:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
8010110c:	e8 4f 07 00 00       	call   80101860 <iunlock>
      end_op();
80101111:	e8 aa 1c 00 00       	call   80102dc0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
80101116:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101119:	83 c4 10             	add    $0x10,%esp
8010111c:	39 c3                	cmp    %eax,%ebx
8010111e:	75 60                	jne    80101180 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
80101120:	01 df                	add    %ebx,%edi
    while(i < n){
80101122:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101125:	7e 69                	jle    80101190 <filewrite+0xe0>
      int n1 = n - i;
80101127:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010112a:	b8 00 06 00 00       	mov    $0x600,%eax
8010112f:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101131:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101137:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
8010113a:	e8 11 1c 00 00       	call   80102d50 <begin_op>
      ilock(f->ip);
8010113f:	83 ec 0c             	sub    $0xc,%esp
80101142:	ff 76 10             	pushl  0x10(%esi)
80101145:	e8 36 06 00 00       	call   80101780 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010114a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010114d:	53                   	push   %ebx
8010114e:	ff 76 14             	pushl  0x14(%esi)
80101151:	01 f8                	add    %edi,%eax
80101153:	50                   	push   %eax
80101154:	ff 76 10             	pushl  0x10(%esi)
80101157:	e8 24 0a 00 00       	call   80101b80 <writei>
8010115c:	83 c4 20             	add    $0x20,%esp
8010115f:	85 c0                	test   %eax,%eax
80101161:	7f 9d                	jg     80101100 <filewrite+0x50>
      iunlock(f->ip);
80101163:	83 ec 0c             	sub    $0xc,%esp
80101166:	ff 76 10             	pushl  0x10(%esi)
80101169:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010116c:	e8 ef 06 00 00       	call   80101860 <iunlock>
      end_op();
80101171:	e8 4a 1c 00 00       	call   80102dc0 <end_op>
      if(r < 0)
80101176:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101179:	83 c4 10             	add    $0x10,%esp
8010117c:	85 c0                	test   %eax,%eax
8010117e:	75 17                	jne    80101197 <filewrite+0xe7>
        panic("short filewrite");
80101180:	83 ec 0c             	sub    $0xc,%esp
80101183:	68 2f 72 10 80       	push   $0x8010722f
80101188:	e8 03 f2 ff ff       	call   80100390 <panic>
8010118d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101190:	89 f8                	mov    %edi,%eax
80101192:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101195:	74 05                	je     8010119c <filewrite+0xec>
80101197:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
8010119c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010119f:	5b                   	pop    %ebx
801011a0:	5e                   	pop    %esi
801011a1:	5f                   	pop    %edi
801011a2:	5d                   	pop    %ebp
801011a3:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801011a4:	8b 46 0c             	mov    0xc(%esi),%eax
801011a7:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011ad:	5b                   	pop    %ebx
801011ae:	5e                   	pop    %esi
801011af:	5f                   	pop    %edi
801011b0:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011b1:	e9 0a 24 00 00       	jmp    801035c0 <pipewrite>
  panic("filewrite");
801011b6:	83 ec 0c             	sub    $0xc,%esp
801011b9:	68 35 72 10 80       	push   $0x80107235
801011be:	e8 cd f1 ff ff       	call   80100390 <panic>
801011c3:	66 90                	xchg   %ax,%ax
801011c5:	66 90                	xchg   %ax,%ax
801011c7:	66 90                	xchg   %ax,%ax
801011c9:	66 90                	xchg   %ax,%ax
801011cb:	66 90                	xchg   %ax,%ax
801011cd:	66 90                	xchg   %ax,%ax
801011cf:	90                   	nop

801011d0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011d0:	55                   	push   %ebp
801011d1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011d3:	89 d0                	mov    %edx,%eax
801011d5:	c1 e8 0c             	shr    $0xc,%eax
801011d8:	03 05 d8 09 11 80    	add    0x801109d8,%eax
{
801011de:	89 e5                	mov    %esp,%ebp
801011e0:	56                   	push   %esi
801011e1:	53                   	push   %ebx
801011e2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011e4:	83 ec 08             	sub    $0x8,%esp
801011e7:	50                   	push   %eax
801011e8:	51                   	push   %ecx
801011e9:	e8 e2 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011ee:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011f0:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801011f3:	ba 01 00 00 00       	mov    $0x1,%edx
801011f8:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801011fb:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80101201:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101204:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101206:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
8010120b:	85 d1                	test   %edx,%ecx
8010120d:	74 25                	je     80101234 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010120f:	f7 d2                	not    %edx
  log_write(bp);
80101211:	83 ec 0c             	sub    $0xc,%esp
80101214:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
80101216:	21 ca                	and    %ecx,%edx
80101218:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
8010121c:	50                   	push   %eax
8010121d:	e8 0e 1d 00 00       	call   80102f30 <log_write>
  brelse(bp);
80101222:	89 34 24             	mov    %esi,(%esp)
80101225:	e8 c6 ef ff ff       	call   801001f0 <brelse>
}
8010122a:	83 c4 10             	add    $0x10,%esp
8010122d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101230:	5b                   	pop    %ebx
80101231:	5e                   	pop    %esi
80101232:	5d                   	pop    %ebp
80101233:	c3                   	ret    
    panic("freeing free block");
80101234:	83 ec 0c             	sub    $0xc,%esp
80101237:	68 3f 72 10 80       	push   $0x8010723f
8010123c:	e8 4f f1 ff ff       	call   80100390 <panic>
80101241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101248:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010124f:	90                   	nop

80101250 <balloc>:
{
80101250:	55                   	push   %ebp
80101251:	89 e5                	mov    %esp,%ebp
80101253:	57                   	push   %edi
80101254:	56                   	push   %esi
80101255:	53                   	push   %ebx
80101256:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101259:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
{
8010125f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101262:	85 c9                	test   %ecx,%ecx
80101264:	0f 84 87 00 00 00    	je     801012f1 <balloc+0xa1>
8010126a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101271:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101274:	83 ec 08             	sub    $0x8,%esp
80101277:	89 f0                	mov    %esi,%eax
80101279:	c1 f8 0c             	sar    $0xc,%eax
8010127c:	03 05 d8 09 11 80    	add    0x801109d8,%eax
80101282:	50                   	push   %eax
80101283:	ff 75 d8             	pushl  -0x28(%ebp)
80101286:	e8 45 ee ff ff       	call   801000d0 <bread>
8010128b:	83 c4 10             	add    $0x10,%esp
8010128e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101291:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101296:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101299:	31 c0                	xor    %eax,%eax
8010129b:	eb 2f                	jmp    801012cc <balloc+0x7c>
8010129d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801012a0:	89 c1                	mov    %eax,%ecx
801012a2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801012aa:	83 e1 07             	and    $0x7,%ecx
801012ad:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012af:	89 c1                	mov    %eax,%ecx
801012b1:	c1 f9 03             	sar    $0x3,%ecx
801012b4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012b9:	89 fa                	mov    %edi,%edx
801012bb:	85 df                	test   %ebx,%edi
801012bd:	74 41                	je     80101300 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012bf:	83 c0 01             	add    $0x1,%eax
801012c2:	83 c6 01             	add    $0x1,%esi
801012c5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012ca:	74 05                	je     801012d1 <balloc+0x81>
801012cc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012cf:	77 cf                	ja     801012a0 <balloc+0x50>
    brelse(bp);
801012d1:	83 ec 0c             	sub    $0xc,%esp
801012d4:	ff 75 e4             	pushl  -0x1c(%ebp)
801012d7:	e8 14 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012dc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012e3:	83 c4 10             	add    $0x10,%esp
801012e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012e9:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
801012ef:	77 80                	ja     80101271 <balloc+0x21>
  panic("balloc: out of blocks");
801012f1:	83 ec 0c             	sub    $0xc,%esp
801012f4:	68 52 72 10 80       	push   $0x80107252
801012f9:	e8 92 f0 ff ff       	call   80100390 <panic>
801012fe:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101300:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101303:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101306:	09 da                	or     %ebx,%edx
80101308:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010130c:	57                   	push   %edi
8010130d:	e8 1e 1c 00 00       	call   80102f30 <log_write>
        brelse(bp);
80101312:	89 3c 24             	mov    %edi,(%esp)
80101315:	e8 d6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010131a:	58                   	pop    %eax
8010131b:	5a                   	pop    %edx
8010131c:	56                   	push   %esi
8010131d:	ff 75 d8             	pushl  -0x28(%ebp)
80101320:	e8 ab ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101325:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101328:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010132a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010132d:	68 00 02 00 00       	push   $0x200
80101332:	6a 00                	push   $0x0
80101334:	50                   	push   %eax
80101335:	e8 56 33 00 00       	call   80104690 <memset>
  log_write(bp);
8010133a:	89 1c 24             	mov    %ebx,(%esp)
8010133d:	e8 ee 1b 00 00       	call   80102f30 <log_write>
  brelse(bp);
80101342:	89 1c 24             	mov    %ebx,(%esp)
80101345:	e8 a6 ee ff ff       	call   801001f0 <brelse>
}
8010134a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010134d:	89 f0                	mov    %esi,%eax
8010134f:	5b                   	pop    %ebx
80101350:	5e                   	pop    %esi
80101351:	5f                   	pop    %edi
80101352:	5d                   	pop    %ebp
80101353:	c3                   	ret    
80101354:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010135b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010135f:	90                   	nop

80101360 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101360:	55                   	push   %ebp
80101361:	89 e5                	mov    %esp,%ebp
80101363:	57                   	push   %edi
80101364:	89 c7                	mov    %eax,%edi
80101366:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101367:	31 f6                	xor    %esi,%esi
{
80101369:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010136a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
8010136f:	83 ec 28             	sub    $0x28,%esp
80101372:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101375:	68 e0 09 11 80       	push   $0x801109e0
8010137a:	e8 01 32 00 00       	call   80104580 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010137f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101382:	83 c4 10             	add    $0x10,%esp
80101385:	eb 1b                	jmp    801013a2 <iget+0x42>
80101387:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010138e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101390:	39 3b                	cmp    %edi,(%ebx)
80101392:	74 6c                	je     80101400 <iget+0xa0>
80101394:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010139a:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801013a0:	73 26                	jae    801013c8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013a2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801013a5:	85 c9                	test   %ecx,%ecx
801013a7:	7f e7                	jg     80101390 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801013a9:	85 f6                	test   %esi,%esi
801013ab:	75 e7                	jne    80101394 <iget+0x34>
801013ad:	89 d8                	mov    %ebx,%eax
801013af:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013b5:	85 c9                	test   %ecx,%ecx
801013b7:	75 6e                	jne    80101427 <iget+0xc7>
801013b9:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013bb:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801013c1:	72 df                	jb     801013a2 <iget+0x42>
801013c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013c7:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013c8:	85 f6                	test   %esi,%esi
801013ca:	74 73                	je     8010143f <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013cc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013cf:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013d1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013d4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013db:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013e2:	68 e0 09 11 80       	push   $0x801109e0
801013e7:	e8 54 32 00 00       	call   80104640 <release>

  return ip;
801013ec:	83 c4 10             	add    $0x10,%esp
}
801013ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013f2:	89 f0                	mov    %esi,%eax
801013f4:	5b                   	pop    %ebx
801013f5:	5e                   	pop    %esi
801013f6:	5f                   	pop    %edi
801013f7:	5d                   	pop    %ebp
801013f8:	c3                   	ret    
801013f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101400:	39 53 04             	cmp    %edx,0x4(%ebx)
80101403:	75 8f                	jne    80101394 <iget+0x34>
      release(&icache.lock);
80101405:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101408:	83 c1 01             	add    $0x1,%ecx
      return ip;
8010140b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010140d:	68 e0 09 11 80       	push   $0x801109e0
      ip->ref++;
80101412:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101415:	e8 26 32 00 00       	call   80104640 <release>
      return ip;
8010141a:	83 c4 10             	add    $0x10,%esp
}
8010141d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101420:	89 f0                	mov    %esi,%eax
80101422:	5b                   	pop    %ebx
80101423:	5e                   	pop    %esi
80101424:	5f                   	pop    %edi
80101425:	5d                   	pop    %ebp
80101426:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101427:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
8010142d:	73 10                	jae    8010143f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010142f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101432:	85 c9                	test   %ecx,%ecx
80101434:	0f 8f 56 ff ff ff    	jg     80101390 <iget+0x30>
8010143a:	e9 6e ff ff ff       	jmp    801013ad <iget+0x4d>
    panic("iget: no inodes");
8010143f:	83 ec 0c             	sub    $0xc,%esp
80101442:	68 68 72 10 80       	push   $0x80107268
80101447:	e8 44 ef ff ff       	call   80100390 <panic>
8010144c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101450 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101450:	55                   	push   %ebp
80101451:	89 e5                	mov    %esp,%ebp
80101453:	57                   	push   %edi
80101454:	56                   	push   %esi
80101455:	89 c6                	mov    %eax,%esi
80101457:	53                   	push   %ebx
80101458:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010145b:	83 fa 0b             	cmp    $0xb,%edx
8010145e:	0f 86 84 00 00 00    	jbe    801014e8 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101464:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101467:	83 fb 7f             	cmp    $0x7f,%ebx
8010146a:	0f 87 98 00 00 00    	ja     80101508 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101470:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101476:	8b 16                	mov    (%esi),%edx
80101478:	85 c0                	test   %eax,%eax
8010147a:	74 54                	je     801014d0 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010147c:	83 ec 08             	sub    $0x8,%esp
8010147f:	50                   	push   %eax
80101480:	52                   	push   %edx
80101481:	e8 4a ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101486:	83 c4 10             	add    $0x10,%esp
80101489:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
8010148d:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010148f:	8b 1a                	mov    (%edx),%ebx
80101491:	85 db                	test   %ebx,%ebx
80101493:	74 1b                	je     801014b0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101495:	83 ec 0c             	sub    $0xc,%esp
80101498:	57                   	push   %edi
80101499:	e8 52 ed ff ff       	call   801001f0 <brelse>
    return addr;
8010149e:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
801014a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014a4:	89 d8                	mov    %ebx,%eax
801014a6:	5b                   	pop    %ebx
801014a7:	5e                   	pop    %esi
801014a8:	5f                   	pop    %edi
801014a9:	5d                   	pop    %ebp
801014aa:	c3                   	ret    
801014ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801014af:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
801014b0:	8b 06                	mov    (%esi),%eax
801014b2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801014b5:	e8 96 fd ff ff       	call   80101250 <balloc>
801014ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801014bd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014c0:	89 c3                	mov    %eax,%ebx
801014c2:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801014c4:	57                   	push   %edi
801014c5:	e8 66 1a 00 00       	call   80102f30 <log_write>
801014ca:	83 c4 10             	add    $0x10,%esp
801014cd:	eb c6                	jmp    80101495 <bmap+0x45>
801014cf:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014d0:	89 d0                	mov    %edx,%eax
801014d2:	e8 79 fd ff ff       	call   80101250 <balloc>
801014d7:	8b 16                	mov    (%esi),%edx
801014d9:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014df:	eb 9b                	jmp    8010147c <bmap+0x2c>
801014e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
801014e8:	8d 3c 90             	lea    (%eax,%edx,4),%edi
801014eb:	8b 5f 5c             	mov    0x5c(%edi),%ebx
801014ee:	85 db                	test   %ebx,%ebx
801014f0:	75 af                	jne    801014a1 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014f2:	8b 00                	mov    (%eax),%eax
801014f4:	e8 57 fd ff ff       	call   80101250 <balloc>
801014f9:	89 47 5c             	mov    %eax,0x5c(%edi)
801014fc:	89 c3                	mov    %eax,%ebx
}
801014fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101501:	89 d8                	mov    %ebx,%eax
80101503:	5b                   	pop    %ebx
80101504:	5e                   	pop    %esi
80101505:	5f                   	pop    %edi
80101506:	5d                   	pop    %ebp
80101507:	c3                   	ret    
  panic("bmap: out of range");
80101508:	83 ec 0c             	sub    $0xc,%esp
8010150b:	68 78 72 10 80       	push   $0x80107278
80101510:	e8 7b ee ff ff       	call   80100390 <panic>
80101515:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010151c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101520 <readsb>:
{
80101520:	f3 0f 1e fb          	endbr32 
80101524:	55                   	push   %ebp
80101525:	89 e5                	mov    %esp,%ebp
80101527:	56                   	push   %esi
80101528:	53                   	push   %ebx
80101529:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
8010152c:	83 ec 08             	sub    $0x8,%esp
8010152f:	6a 01                	push   $0x1
80101531:	ff 75 08             	pushl  0x8(%ebp)
80101534:	e8 97 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101539:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010153c:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010153e:	8d 40 5c             	lea    0x5c(%eax),%eax
80101541:	6a 1c                	push   $0x1c
80101543:	50                   	push   %eax
80101544:	56                   	push   %esi
80101545:	e8 e6 31 00 00       	call   80104730 <memmove>
  brelse(bp);
8010154a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010154d:	83 c4 10             	add    $0x10,%esp
}
80101550:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101553:	5b                   	pop    %ebx
80101554:	5e                   	pop    %esi
80101555:	5d                   	pop    %ebp
  brelse(bp);
80101556:	e9 95 ec ff ff       	jmp    801001f0 <brelse>
8010155b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010155f:	90                   	nop

80101560 <iinit>:
{
80101560:	f3 0f 1e fb          	endbr32 
80101564:	55                   	push   %ebp
80101565:	89 e5                	mov    %esp,%ebp
80101567:	53                   	push   %ebx
80101568:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
8010156d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101570:	68 8b 72 10 80       	push   $0x8010728b
80101575:	68 e0 09 11 80       	push   $0x801109e0
8010157a:	e8 81 2e 00 00       	call   80104400 <initlock>
  for(i = 0; i < NINODE; i++) {
8010157f:	83 c4 10             	add    $0x10,%esp
80101582:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101588:	83 ec 08             	sub    $0x8,%esp
8010158b:	68 92 72 10 80       	push   $0x80107292
80101590:	53                   	push   %ebx
80101591:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101597:	e8 24 2d 00 00       	call   801042c0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
8010159c:	83 c4 10             	add    $0x10,%esp
8010159f:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
801015a5:	75 e1                	jne    80101588 <iinit+0x28>
  readsb(dev, &sb);
801015a7:	83 ec 08             	sub    $0x8,%esp
801015aa:	68 c0 09 11 80       	push   $0x801109c0
801015af:	ff 75 08             	pushl  0x8(%ebp)
801015b2:	e8 69 ff ff ff       	call   80101520 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015b7:	ff 35 d8 09 11 80    	pushl  0x801109d8
801015bd:	ff 35 d4 09 11 80    	pushl  0x801109d4
801015c3:	ff 35 d0 09 11 80    	pushl  0x801109d0
801015c9:	ff 35 cc 09 11 80    	pushl  0x801109cc
801015cf:	ff 35 c8 09 11 80    	pushl  0x801109c8
801015d5:	ff 35 c4 09 11 80    	pushl  0x801109c4
801015db:	ff 35 c0 09 11 80    	pushl  0x801109c0
801015e1:	68 f8 72 10 80       	push   $0x801072f8
801015e6:	e8 c5 f0 ff ff       	call   801006b0 <cprintf>
}
801015eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015ee:	83 c4 30             	add    $0x30,%esp
801015f1:	c9                   	leave  
801015f2:	c3                   	ret    
801015f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101600 <ialloc>:
{
80101600:	f3 0f 1e fb          	endbr32 
80101604:	55                   	push   %ebp
80101605:	89 e5                	mov    %esp,%ebp
80101607:	57                   	push   %edi
80101608:	56                   	push   %esi
80101609:	53                   	push   %ebx
8010160a:	83 ec 1c             	sub    $0x1c,%esp
8010160d:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80101610:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
80101617:	8b 75 08             	mov    0x8(%ebp),%esi
8010161a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
8010161d:	0f 86 8d 00 00 00    	jbe    801016b0 <ialloc+0xb0>
80101623:	bf 01 00 00 00       	mov    $0x1,%edi
80101628:	eb 1d                	jmp    80101647 <ialloc+0x47>
8010162a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101630:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101633:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101636:	53                   	push   %ebx
80101637:	e8 b4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010163c:	83 c4 10             	add    $0x10,%esp
8010163f:	3b 3d c8 09 11 80    	cmp    0x801109c8,%edi
80101645:	73 69                	jae    801016b0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101647:	89 f8                	mov    %edi,%eax
80101649:	83 ec 08             	sub    $0x8,%esp
8010164c:	c1 e8 03             	shr    $0x3,%eax
8010164f:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101655:	50                   	push   %eax
80101656:	56                   	push   %esi
80101657:	e8 74 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010165c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010165f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101661:	89 f8                	mov    %edi,%eax
80101663:	83 e0 07             	and    $0x7,%eax
80101666:	c1 e0 06             	shl    $0x6,%eax
80101669:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010166d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101671:	75 bd                	jne    80101630 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101673:	83 ec 04             	sub    $0x4,%esp
80101676:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101679:	6a 40                	push   $0x40
8010167b:	6a 00                	push   $0x0
8010167d:	51                   	push   %ecx
8010167e:	e8 0d 30 00 00       	call   80104690 <memset>
      dip->type = type;
80101683:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101687:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010168a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010168d:	89 1c 24             	mov    %ebx,(%esp)
80101690:	e8 9b 18 00 00       	call   80102f30 <log_write>
      brelse(bp);
80101695:	89 1c 24             	mov    %ebx,(%esp)
80101698:	e8 53 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010169d:	83 c4 10             	add    $0x10,%esp
}
801016a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016a3:	89 fa                	mov    %edi,%edx
}
801016a5:	5b                   	pop    %ebx
      return iget(dev, inum);
801016a6:	89 f0                	mov    %esi,%eax
}
801016a8:	5e                   	pop    %esi
801016a9:	5f                   	pop    %edi
801016aa:	5d                   	pop    %ebp
      return iget(dev, inum);
801016ab:	e9 b0 fc ff ff       	jmp    80101360 <iget>
  panic("ialloc: no inodes");
801016b0:	83 ec 0c             	sub    $0xc,%esp
801016b3:	68 98 72 10 80       	push   $0x80107298
801016b8:	e8 d3 ec ff ff       	call   80100390 <panic>
801016bd:	8d 76 00             	lea    0x0(%esi),%esi

801016c0 <iupdate>:
{
801016c0:	f3 0f 1e fb          	endbr32 
801016c4:	55                   	push   %ebp
801016c5:	89 e5                	mov    %esp,%ebp
801016c7:	56                   	push   %esi
801016c8:	53                   	push   %ebx
801016c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016cc:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016cf:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016d2:	83 ec 08             	sub    $0x8,%esp
801016d5:	c1 e8 03             	shr    $0x3,%eax
801016d8:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801016de:	50                   	push   %eax
801016df:	ff 73 a4             	pushl  -0x5c(%ebx)
801016e2:	e8 e9 e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016e7:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016eb:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016ee:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016f0:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016f3:	83 e0 07             	and    $0x7,%eax
801016f6:	c1 e0 06             	shl    $0x6,%eax
801016f9:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801016fd:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101700:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101704:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101707:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
8010170b:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010170f:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101713:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101717:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
8010171b:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010171e:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101721:	6a 34                	push   $0x34
80101723:	53                   	push   %ebx
80101724:	50                   	push   %eax
80101725:	e8 06 30 00 00       	call   80104730 <memmove>
  log_write(bp);
8010172a:	89 34 24             	mov    %esi,(%esp)
8010172d:	e8 fe 17 00 00       	call   80102f30 <log_write>
  brelse(bp);
80101732:	89 75 08             	mov    %esi,0x8(%ebp)
80101735:	83 c4 10             	add    $0x10,%esp
}
80101738:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010173b:	5b                   	pop    %ebx
8010173c:	5e                   	pop    %esi
8010173d:	5d                   	pop    %ebp
  brelse(bp);
8010173e:	e9 ad ea ff ff       	jmp    801001f0 <brelse>
80101743:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010174a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101750 <idup>:
{
80101750:	f3 0f 1e fb          	endbr32 
80101754:	55                   	push   %ebp
80101755:	89 e5                	mov    %esp,%ebp
80101757:	53                   	push   %ebx
80101758:	83 ec 10             	sub    $0x10,%esp
8010175b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010175e:	68 e0 09 11 80       	push   $0x801109e0
80101763:	e8 18 2e 00 00       	call   80104580 <acquire>
  ip->ref++;
80101768:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010176c:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101773:	e8 c8 2e 00 00       	call   80104640 <release>
}
80101778:	89 d8                	mov    %ebx,%eax
8010177a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010177d:	c9                   	leave  
8010177e:	c3                   	ret    
8010177f:	90                   	nop

80101780 <ilock>:
{
80101780:	f3 0f 1e fb          	endbr32 
80101784:	55                   	push   %ebp
80101785:	89 e5                	mov    %esp,%ebp
80101787:	56                   	push   %esi
80101788:	53                   	push   %ebx
80101789:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
8010178c:	85 db                	test   %ebx,%ebx
8010178e:	0f 84 b3 00 00 00    	je     80101847 <ilock+0xc7>
80101794:	8b 53 08             	mov    0x8(%ebx),%edx
80101797:	85 d2                	test   %edx,%edx
80101799:	0f 8e a8 00 00 00    	jle    80101847 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010179f:	83 ec 0c             	sub    $0xc,%esp
801017a2:	8d 43 0c             	lea    0xc(%ebx),%eax
801017a5:	50                   	push   %eax
801017a6:	e8 55 2b 00 00       	call   80104300 <acquiresleep>
  if(ip->valid == 0){
801017ab:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017ae:	83 c4 10             	add    $0x10,%esp
801017b1:	85 c0                	test   %eax,%eax
801017b3:	74 0b                	je     801017c0 <ilock+0x40>
}
801017b5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017b8:	5b                   	pop    %ebx
801017b9:	5e                   	pop    %esi
801017ba:	5d                   	pop    %ebp
801017bb:	c3                   	ret    
801017bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017c0:	8b 43 04             	mov    0x4(%ebx),%eax
801017c3:	83 ec 08             	sub    $0x8,%esp
801017c6:	c1 e8 03             	shr    $0x3,%eax
801017c9:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801017cf:	50                   	push   %eax
801017d0:	ff 33                	pushl  (%ebx)
801017d2:	e8 f9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017d7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017da:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017dc:	8b 43 04             	mov    0x4(%ebx),%eax
801017df:	83 e0 07             	and    $0x7,%eax
801017e2:	c1 e0 06             	shl    $0x6,%eax
801017e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017e9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017ec:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017ef:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017f3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017f7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017fb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017ff:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101803:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101807:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010180b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010180e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101811:	6a 34                	push   $0x34
80101813:	50                   	push   %eax
80101814:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101817:	50                   	push   %eax
80101818:	e8 13 2f 00 00       	call   80104730 <memmove>
    brelse(bp);
8010181d:	89 34 24             	mov    %esi,(%esp)
80101820:	e8 cb e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101825:	83 c4 10             	add    $0x10,%esp
80101828:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010182d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101834:	0f 85 7b ff ff ff    	jne    801017b5 <ilock+0x35>
      panic("ilock: no type");
8010183a:	83 ec 0c             	sub    $0xc,%esp
8010183d:	68 b0 72 10 80       	push   $0x801072b0
80101842:	e8 49 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101847:	83 ec 0c             	sub    $0xc,%esp
8010184a:	68 aa 72 10 80       	push   $0x801072aa
8010184f:	e8 3c eb ff ff       	call   80100390 <panic>
80101854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010185b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010185f:	90                   	nop

80101860 <iunlock>:
{
80101860:	f3 0f 1e fb          	endbr32 
80101864:	55                   	push   %ebp
80101865:	89 e5                	mov    %esp,%ebp
80101867:	56                   	push   %esi
80101868:	53                   	push   %ebx
80101869:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010186c:	85 db                	test   %ebx,%ebx
8010186e:	74 28                	je     80101898 <iunlock+0x38>
80101870:	83 ec 0c             	sub    $0xc,%esp
80101873:	8d 73 0c             	lea    0xc(%ebx),%esi
80101876:	56                   	push   %esi
80101877:	e8 24 2b 00 00       	call   801043a0 <holdingsleep>
8010187c:	83 c4 10             	add    $0x10,%esp
8010187f:	85 c0                	test   %eax,%eax
80101881:	74 15                	je     80101898 <iunlock+0x38>
80101883:	8b 43 08             	mov    0x8(%ebx),%eax
80101886:	85 c0                	test   %eax,%eax
80101888:	7e 0e                	jle    80101898 <iunlock+0x38>
  releasesleep(&ip->lock);
8010188a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010188d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101890:	5b                   	pop    %ebx
80101891:	5e                   	pop    %esi
80101892:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101893:	e9 c8 2a 00 00       	jmp    80104360 <releasesleep>
    panic("iunlock");
80101898:	83 ec 0c             	sub    $0xc,%esp
8010189b:	68 bf 72 10 80       	push   $0x801072bf
801018a0:	e8 eb ea ff ff       	call   80100390 <panic>
801018a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018b0 <iput>:
{
801018b0:	f3 0f 1e fb          	endbr32 
801018b4:	55                   	push   %ebp
801018b5:	89 e5                	mov    %esp,%ebp
801018b7:	57                   	push   %edi
801018b8:	56                   	push   %esi
801018b9:	53                   	push   %ebx
801018ba:	83 ec 28             	sub    $0x28,%esp
801018bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018c0:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018c3:	57                   	push   %edi
801018c4:	e8 37 2a 00 00       	call   80104300 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018c9:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018cc:	83 c4 10             	add    $0x10,%esp
801018cf:	85 d2                	test   %edx,%edx
801018d1:	74 07                	je     801018da <iput+0x2a>
801018d3:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018d8:	74 36                	je     80101910 <iput+0x60>
  releasesleep(&ip->lock);
801018da:	83 ec 0c             	sub    $0xc,%esp
801018dd:	57                   	push   %edi
801018de:	e8 7d 2a 00 00       	call   80104360 <releasesleep>
  acquire(&icache.lock);
801018e3:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801018ea:	e8 91 2c 00 00       	call   80104580 <acquire>
  ip->ref--;
801018ef:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018f3:	83 c4 10             	add    $0x10,%esp
801018f6:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
801018fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101900:	5b                   	pop    %ebx
80101901:	5e                   	pop    %esi
80101902:	5f                   	pop    %edi
80101903:	5d                   	pop    %ebp
  release(&icache.lock);
80101904:	e9 37 2d 00 00       	jmp    80104640 <release>
80101909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
80101910:	83 ec 0c             	sub    $0xc,%esp
80101913:	68 e0 09 11 80       	push   $0x801109e0
80101918:	e8 63 2c 00 00       	call   80104580 <acquire>
    int r = ip->ref;
8010191d:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101920:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101927:	e8 14 2d 00 00       	call   80104640 <release>
    if(r == 1){
8010192c:	83 c4 10             	add    $0x10,%esp
8010192f:	83 fe 01             	cmp    $0x1,%esi
80101932:	75 a6                	jne    801018da <iput+0x2a>
80101934:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
8010193a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010193d:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101940:	89 cf                	mov    %ecx,%edi
80101942:	eb 0b                	jmp    8010194f <iput+0x9f>
80101944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101948:	83 c6 04             	add    $0x4,%esi
8010194b:	39 fe                	cmp    %edi,%esi
8010194d:	74 19                	je     80101968 <iput+0xb8>
    if(ip->addrs[i]){
8010194f:	8b 16                	mov    (%esi),%edx
80101951:	85 d2                	test   %edx,%edx
80101953:	74 f3                	je     80101948 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
80101955:	8b 03                	mov    (%ebx),%eax
80101957:	e8 74 f8 ff ff       	call   801011d0 <bfree>
      ip->addrs[i] = 0;
8010195c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101962:	eb e4                	jmp    80101948 <iput+0x98>
80101964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101968:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
8010196e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101971:	85 c0                	test   %eax,%eax
80101973:	75 33                	jne    801019a8 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101975:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101978:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
8010197f:	53                   	push   %ebx
80101980:	e8 3b fd ff ff       	call   801016c0 <iupdate>
      ip->type = 0;
80101985:	31 c0                	xor    %eax,%eax
80101987:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
8010198b:	89 1c 24             	mov    %ebx,(%esp)
8010198e:	e8 2d fd ff ff       	call   801016c0 <iupdate>
      ip->valid = 0;
80101993:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
8010199a:	83 c4 10             	add    $0x10,%esp
8010199d:	e9 38 ff ff ff       	jmp    801018da <iput+0x2a>
801019a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801019a8:	83 ec 08             	sub    $0x8,%esp
801019ab:	50                   	push   %eax
801019ac:	ff 33                	pushl  (%ebx)
801019ae:	e8 1d e7 ff ff       	call   801000d0 <bread>
801019b3:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019b6:	83 c4 10             	add    $0x10,%esp
801019b9:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019c2:	8d 70 5c             	lea    0x5c(%eax),%esi
801019c5:	89 cf                	mov    %ecx,%edi
801019c7:	eb 0e                	jmp    801019d7 <iput+0x127>
801019c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019d0:	83 c6 04             	add    $0x4,%esi
801019d3:	39 f7                	cmp    %esi,%edi
801019d5:	74 19                	je     801019f0 <iput+0x140>
      if(a[j])
801019d7:	8b 16                	mov    (%esi),%edx
801019d9:	85 d2                	test   %edx,%edx
801019db:	74 f3                	je     801019d0 <iput+0x120>
        bfree(ip->dev, a[j]);
801019dd:	8b 03                	mov    (%ebx),%eax
801019df:	e8 ec f7 ff ff       	call   801011d0 <bfree>
801019e4:	eb ea                	jmp    801019d0 <iput+0x120>
801019e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019ed:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
801019f0:	83 ec 0c             	sub    $0xc,%esp
801019f3:	ff 75 e4             	pushl  -0x1c(%ebp)
801019f6:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019f9:	e8 f2 e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019fe:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101a04:	8b 03                	mov    (%ebx),%eax
80101a06:	e8 c5 f7 ff ff       	call   801011d0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a0b:	83 c4 10             	add    $0x10,%esp
80101a0e:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a15:	00 00 00 
80101a18:	e9 58 ff ff ff       	jmp    80101975 <iput+0xc5>
80101a1d:	8d 76 00             	lea    0x0(%esi),%esi

80101a20 <iunlockput>:
{
80101a20:	f3 0f 1e fb          	endbr32 
80101a24:	55                   	push   %ebp
80101a25:	89 e5                	mov    %esp,%ebp
80101a27:	53                   	push   %ebx
80101a28:	83 ec 10             	sub    $0x10,%esp
80101a2b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101a2e:	53                   	push   %ebx
80101a2f:	e8 2c fe ff ff       	call   80101860 <iunlock>
  iput(ip);
80101a34:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a37:	83 c4 10             	add    $0x10,%esp
}
80101a3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a3d:	c9                   	leave  
  iput(ip);
80101a3e:	e9 6d fe ff ff       	jmp    801018b0 <iput>
80101a43:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a50 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a50:	f3 0f 1e fb          	endbr32 
80101a54:	55                   	push   %ebp
80101a55:	89 e5                	mov    %esp,%ebp
80101a57:	8b 55 08             	mov    0x8(%ebp),%edx
80101a5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a5d:	8b 0a                	mov    (%edx),%ecx
80101a5f:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a62:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a65:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a68:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a6c:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a6f:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a73:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a77:	8b 52 58             	mov    0x58(%edx),%edx
80101a7a:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a7d:	5d                   	pop    %ebp
80101a7e:	c3                   	ret    
80101a7f:	90                   	nop

80101a80 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a80:	f3 0f 1e fb          	endbr32 
80101a84:	55                   	push   %ebp
80101a85:	89 e5                	mov    %esp,%ebp
80101a87:	57                   	push   %edi
80101a88:	56                   	push   %esi
80101a89:	53                   	push   %ebx
80101a8a:	83 ec 1c             	sub    $0x1c,%esp
80101a8d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a90:	8b 45 08             	mov    0x8(%ebp),%eax
80101a93:	8b 75 10             	mov    0x10(%ebp),%esi
80101a96:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a99:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a9c:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101aa1:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101aa4:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101aa7:	0f 84 a3 00 00 00    	je     80101b50 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101aad:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101ab0:	8b 40 58             	mov    0x58(%eax),%eax
80101ab3:	39 c6                	cmp    %eax,%esi
80101ab5:	0f 87 b6 00 00 00    	ja     80101b71 <readi+0xf1>
80101abb:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101abe:	31 c9                	xor    %ecx,%ecx
80101ac0:	89 da                	mov    %ebx,%edx
80101ac2:	01 f2                	add    %esi,%edx
80101ac4:	0f 92 c1             	setb   %cl
80101ac7:	89 cf                	mov    %ecx,%edi
80101ac9:	0f 82 a2 00 00 00    	jb     80101b71 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101acf:	89 c1                	mov    %eax,%ecx
80101ad1:	29 f1                	sub    %esi,%ecx
80101ad3:	39 d0                	cmp    %edx,%eax
80101ad5:	0f 43 cb             	cmovae %ebx,%ecx
80101ad8:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101adb:	85 c9                	test   %ecx,%ecx
80101add:	74 63                	je     80101b42 <readi+0xc2>
80101adf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ae0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101ae3:	89 f2                	mov    %esi,%edx
80101ae5:	c1 ea 09             	shr    $0x9,%edx
80101ae8:	89 d8                	mov    %ebx,%eax
80101aea:	e8 61 f9 ff ff       	call   80101450 <bmap>
80101aef:	83 ec 08             	sub    $0x8,%esp
80101af2:	50                   	push   %eax
80101af3:	ff 33                	pushl  (%ebx)
80101af5:	e8 d6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101afa:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101afd:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b02:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b05:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b07:	89 f0                	mov    %esi,%eax
80101b09:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b0e:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b10:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b13:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b15:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b19:	39 d9                	cmp    %ebx,%ecx
80101b1b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b1e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b1f:	01 df                	add    %ebx,%edi
80101b21:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b23:	50                   	push   %eax
80101b24:	ff 75 e0             	pushl  -0x20(%ebp)
80101b27:	e8 04 2c 00 00       	call   80104730 <memmove>
    brelse(bp);
80101b2c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b2f:	89 14 24             	mov    %edx,(%esp)
80101b32:	e8 b9 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b37:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b3a:	83 c4 10             	add    $0x10,%esp
80101b3d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b40:	77 9e                	ja     80101ae0 <readi+0x60>
  }
  return n;
80101b42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b45:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b48:	5b                   	pop    %ebx
80101b49:	5e                   	pop    %esi
80101b4a:	5f                   	pop    %edi
80101b4b:	5d                   	pop    %ebp
80101b4c:	c3                   	ret    
80101b4d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b50:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b54:	66 83 f8 09          	cmp    $0x9,%ax
80101b58:	77 17                	ja     80101b71 <readi+0xf1>
80101b5a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101b61:	85 c0                	test   %eax,%eax
80101b63:	74 0c                	je     80101b71 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b65:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b6b:	5b                   	pop    %ebx
80101b6c:	5e                   	pop    %esi
80101b6d:	5f                   	pop    %edi
80101b6e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b6f:	ff e0                	jmp    *%eax
      return -1;
80101b71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b76:	eb cd                	jmp    80101b45 <readi+0xc5>
80101b78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b7f:	90                   	nop

80101b80 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b80:	f3 0f 1e fb          	endbr32 
80101b84:	55                   	push   %ebp
80101b85:	89 e5                	mov    %esp,%ebp
80101b87:	57                   	push   %edi
80101b88:	56                   	push   %esi
80101b89:	53                   	push   %ebx
80101b8a:	83 ec 1c             	sub    $0x1c,%esp
80101b8d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b90:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b93:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b96:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b9b:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b9e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ba1:	8b 75 10             	mov    0x10(%ebp),%esi
80101ba4:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101ba7:	0f 84 b3 00 00 00    	je     80101c60 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bad:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bb0:	39 70 58             	cmp    %esi,0x58(%eax)
80101bb3:	0f 82 e3 00 00 00    	jb     80101c9c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101bb9:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bbc:	89 f8                	mov    %edi,%eax
80101bbe:	01 f0                	add    %esi,%eax
80101bc0:	0f 82 d6 00 00 00    	jb     80101c9c <writei+0x11c>
80101bc6:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bcb:	0f 87 cb 00 00 00    	ja     80101c9c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bd1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101bd8:	85 ff                	test   %edi,%edi
80101bda:	74 75                	je     80101c51 <writei+0xd1>
80101bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101be0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101be3:	89 f2                	mov    %esi,%edx
80101be5:	c1 ea 09             	shr    $0x9,%edx
80101be8:	89 f8                	mov    %edi,%eax
80101bea:	e8 61 f8 ff ff       	call   80101450 <bmap>
80101bef:	83 ec 08             	sub    $0x8,%esp
80101bf2:	50                   	push   %eax
80101bf3:	ff 37                	pushl  (%edi)
80101bf5:	e8 d6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101bfa:	b9 00 02 00 00       	mov    $0x200,%ecx
80101bff:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c02:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c05:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c07:	89 f0                	mov    %esi,%eax
80101c09:	83 c4 0c             	add    $0xc,%esp
80101c0c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c11:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c13:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c17:	39 d9                	cmp    %ebx,%ecx
80101c19:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c1c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c1d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c1f:	ff 75 dc             	pushl  -0x24(%ebp)
80101c22:	50                   	push   %eax
80101c23:	e8 08 2b 00 00       	call   80104730 <memmove>
    log_write(bp);
80101c28:	89 3c 24             	mov    %edi,(%esp)
80101c2b:	e8 00 13 00 00       	call   80102f30 <log_write>
    brelse(bp);
80101c30:	89 3c 24             	mov    %edi,(%esp)
80101c33:	e8 b8 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c38:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c3b:	83 c4 10             	add    $0x10,%esp
80101c3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c41:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c44:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c47:	77 97                	ja     80101be0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c49:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c4c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c4f:	77 37                	ja     80101c88 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c51:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c54:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c57:	5b                   	pop    %ebx
80101c58:	5e                   	pop    %esi
80101c59:	5f                   	pop    %edi
80101c5a:	5d                   	pop    %ebp
80101c5b:	c3                   	ret    
80101c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c60:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c64:	66 83 f8 09          	cmp    $0x9,%ax
80101c68:	77 32                	ja     80101c9c <writei+0x11c>
80101c6a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101c71:	85 c0                	test   %eax,%eax
80101c73:	74 27                	je     80101c9c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c75:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c7b:	5b                   	pop    %ebx
80101c7c:	5e                   	pop    %esi
80101c7d:	5f                   	pop    %edi
80101c7e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c7f:	ff e0                	jmp    *%eax
80101c81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c88:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c8b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c8e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101c91:	50                   	push   %eax
80101c92:	e8 29 fa ff ff       	call   801016c0 <iupdate>
80101c97:	83 c4 10             	add    $0x10,%esp
80101c9a:	eb b5                	jmp    80101c51 <writei+0xd1>
      return -1;
80101c9c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ca1:	eb b1                	jmp    80101c54 <writei+0xd4>
80101ca3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101cb0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101cb0:	f3 0f 1e fb          	endbr32 
80101cb4:	55                   	push   %ebp
80101cb5:	89 e5                	mov    %esp,%ebp
80101cb7:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101cba:	6a 0e                	push   $0xe
80101cbc:	ff 75 0c             	pushl  0xc(%ebp)
80101cbf:	ff 75 08             	pushl  0x8(%ebp)
80101cc2:	e8 d9 2a 00 00       	call   801047a0 <strncmp>
}
80101cc7:	c9                   	leave  
80101cc8:	c3                   	ret    
80101cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101cd0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101cd0:	f3 0f 1e fb          	endbr32 
80101cd4:	55                   	push   %ebp
80101cd5:	89 e5                	mov    %esp,%ebp
80101cd7:	57                   	push   %edi
80101cd8:	56                   	push   %esi
80101cd9:	53                   	push   %ebx
80101cda:	83 ec 1c             	sub    $0x1c,%esp
80101cdd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101ce0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101ce5:	0f 85 89 00 00 00    	jne    80101d74 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101ceb:	8b 53 58             	mov    0x58(%ebx),%edx
80101cee:	31 ff                	xor    %edi,%edi
80101cf0:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101cf3:	85 d2                	test   %edx,%edx
80101cf5:	74 42                	je     80101d39 <dirlookup+0x69>
80101cf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cfe:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d00:	6a 10                	push   $0x10
80101d02:	57                   	push   %edi
80101d03:	56                   	push   %esi
80101d04:	53                   	push   %ebx
80101d05:	e8 76 fd ff ff       	call   80101a80 <readi>
80101d0a:	83 c4 10             	add    $0x10,%esp
80101d0d:	83 f8 10             	cmp    $0x10,%eax
80101d10:	75 55                	jne    80101d67 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80101d12:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d17:	74 18                	je     80101d31 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80101d19:	83 ec 04             	sub    $0x4,%esp
80101d1c:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d1f:	6a 0e                	push   $0xe
80101d21:	50                   	push   %eax
80101d22:	ff 75 0c             	pushl  0xc(%ebp)
80101d25:	e8 76 2a 00 00       	call   801047a0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d2a:	83 c4 10             	add    $0x10,%esp
80101d2d:	85 c0                	test   %eax,%eax
80101d2f:	74 17                	je     80101d48 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d31:	83 c7 10             	add    $0x10,%edi
80101d34:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d37:	72 c7                	jb     80101d00 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d39:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d3c:	31 c0                	xor    %eax,%eax
}
80101d3e:	5b                   	pop    %ebx
80101d3f:	5e                   	pop    %esi
80101d40:	5f                   	pop    %edi
80101d41:	5d                   	pop    %ebp
80101d42:	c3                   	ret    
80101d43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d47:	90                   	nop
      if(poff)
80101d48:	8b 45 10             	mov    0x10(%ebp),%eax
80101d4b:	85 c0                	test   %eax,%eax
80101d4d:	74 05                	je     80101d54 <dirlookup+0x84>
        *poff = off;
80101d4f:	8b 45 10             	mov    0x10(%ebp),%eax
80101d52:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d54:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d58:	8b 03                	mov    (%ebx),%eax
80101d5a:	e8 01 f6 ff ff       	call   80101360 <iget>
}
80101d5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d62:	5b                   	pop    %ebx
80101d63:	5e                   	pop    %esi
80101d64:	5f                   	pop    %edi
80101d65:	5d                   	pop    %ebp
80101d66:	c3                   	ret    
      panic("dirlookup read");
80101d67:	83 ec 0c             	sub    $0xc,%esp
80101d6a:	68 d9 72 10 80       	push   $0x801072d9
80101d6f:	e8 1c e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101d74:	83 ec 0c             	sub    $0xc,%esp
80101d77:	68 c7 72 10 80       	push   $0x801072c7
80101d7c:	e8 0f e6 ff ff       	call   80100390 <panic>
80101d81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d8f:	90                   	nop

80101d90 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d90:	55                   	push   %ebp
80101d91:	89 e5                	mov    %esp,%ebp
80101d93:	57                   	push   %edi
80101d94:	56                   	push   %esi
80101d95:	53                   	push   %ebx
80101d96:	89 c3                	mov    %eax,%ebx
80101d98:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d9b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d9e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101da1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101da4:	0f 84 86 01 00 00    	je     80101f30 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101daa:	e8 d1 1b 00 00       	call   80103980 <myproc>
  acquire(&icache.lock);
80101daf:	83 ec 0c             	sub    $0xc,%esp
80101db2:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101db4:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101db7:	68 e0 09 11 80       	push   $0x801109e0
80101dbc:	e8 bf 27 00 00       	call   80104580 <acquire>
  ip->ref++;
80101dc1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dc5:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101dcc:	e8 6f 28 00 00       	call   80104640 <release>
80101dd1:	83 c4 10             	add    $0x10,%esp
80101dd4:	eb 0d                	jmp    80101de3 <namex+0x53>
80101dd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ddd:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80101de0:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101de3:	0f b6 07             	movzbl (%edi),%eax
80101de6:	3c 2f                	cmp    $0x2f,%al
80101de8:	74 f6                	je     80101de0 <namex+0x50>
  if(*path == 0)
80101dea:	84 c0                	test   %al,%al
80101dec:	0f 84 ee 00 00 00    	je     80101ee0 <namex+0x150>
  while(*path != '/' && *path != 0)
80101df2:	0f b6 07             	movzbl (%edi),%eax
80101df5:	84 c0                	test   %al,%al
80101df7:	0f 84 fb 00 00 00    	je     80101ef8 <namex+0x168>
80101dfd:	89 fb                	mov    %edi,%ebx
80101dff:	3c 2f                	cmp    $0x2f,%al
80101e01:	0f 84 f1 00 00 00    	je     80101ef8 <namex+0x168>
80101e07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e0e:	66 90                	xchg   %ax,%ax
80101e10:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80101e14:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80101e17:	3c 2f                	cmp    $0x2f,%al
80101e19:	74 04                	je     80101e1f <namex+0x8f>
80101e1b:	84 c0                	test   %al,%al
80101e1d:	75 f1                	jne    80101e10 <namex+0x80>
  len = path - s;
80101e1f:	89 d8                	mov    %ebx,%eax
80101e21:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80101e23:	83 f8 0d             	cmp    $0xd,%eax
80101e26:	0f 8e 84 00 00 00    	jle    80101eb0 <namex+0x120>
    memmove(name, s, DIRSIZ);
80101e2c:	83 ec 04             	sub    $0x4,%esp
80101e2f:	6a 0e                	push   $0xe
80101e31:	57                   	push   %edi
    path++;
80101e32:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80101e34:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e37:	e8 f4 28 00 00       	call   80104730 <memmove>
80101e3c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e3f:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e42:	75 0c                	jne    80101e50 <namex+0xc0>
80101e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e48:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101e4b:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e4e:	74 f8                	je     80101e48 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e50:	83 ec 0c             	sub    $0xc,%esp
80101e53:	56                   	push   %esi
80101e54:	e8 27 f9 ff ff       	call   80101780 <ilock>
    if(ip->type != T_DIR){
80101e59:	83 c4 10             	add    $0x10,%esp
80101e5c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e61:	0f 85 a1 00 00 00    	jne    80101f08 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e67:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101e6a:	85 d2                	test   %edx,%edx
80101e6c:	74 09                	je     80101e77 <namex+0xe7>
80101e6e:	80 3f 00             	cmpb   $0x0,(%edi)
80101e71:	0f 84 d9 00 00 00    	je     80101f50 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e77:	83 ec 04             	sub    $0x4,%esp
80101e7a:	6a 00                	push   $0x0
80101e7c:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e7f:	56                   	push   %esi
80101e80:	e8 4b fe ff ff       	call   80101cd0 <dirlookup>
80101e85:	83 c4 10             	add    $0x10,%esp
80101e88:	89 c3                	mov    %eax,%ebx
80101e8a:	85 c0                	test   %eax,%eax
80101e8c:	74 7a                	je     80101f08 <namex+0x178>
  iunlock(ip);
80101e8e:	83 ec 0c             	sub    $0xc,%esp
80101e91:	56                   	push   %esi
80101e92:	e8 c9 f9 ff ff       	call   80101860 <iunlock>
  iput(ip);
80101e97:	89 34 24             	mov    %esi,(%esp)
80101e9a:	89 de                	mov    %ebx,%esi
80101e9c:	e8 0f fa ff ff       	call   801018b0 <iput>
80101ea1:	83 c4 10             	add    $0x10,%esp
80101ea4:	e9 3a ff ff ff       	jmp    80101de3 <namex+0x53>
80101ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101eb0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101eb3:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101eb6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80101eb9:	83 ec 04             	sub    $0x4,%esp
80101ebc:	50                   	push   %eax
80101ebd:	57                   	push   %edi
    name[len] = 0;
80101ebe:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80101ec0:	ff 75 e4             	pushl  -0x1c(%ebp)
80101ec3:	e8 68 28 00 00       	call   80104730 <memmove>
    name[len] = 0;
80101ec8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101ecb:	83 c4 10             	add    $0x10,%esp
80101ece:	c6 00 00             	movb   $0x0,(%eax)
80101ed1:	e9 69 ff ff ff       	jmp    80101e3f <namex+0xaf>
80101ed6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101edd:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ee0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ee3:	85 c0                	test   %eax,%eax
80101ee5:	0f 85 85 00 00 00    	jne    80101f70 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
80101eeb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101eee:	89 f0                	mov    %esi,%eax
80101ef0:	5b                   	pop    %ebx
80101ef1:	5e                   	pop    %esi
80101ef2:	5f                   	pop    %edi
80101ef3:	5d                   	pop    %ebp
80101ef4:	c3                   	ret    
80101ef5:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80101ef8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101efb:	89 fb                	mov    %edi,%ebx
80101efd:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101f00:	31 c0                	xor    %eax,%eax
80101f02:	eb b5                	jmp    80101eb9 <namex+0x129>
80101f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101f08:	83 ec 0c             	sub    $0xc,%esp
80101f0b:	56                   	push   %esi
80101f0c:	e8 4f f9 ff ff       	call   80101860 <iunlock>
  iput(ip);
80101f11:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f14:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f16:	e8 95 f9 ff ff       	call   801018b0 <iput>
      return 0;
80101f1b:	83 c4 10             	add    $0x10,%esp
}
80101f1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f21:	89 f0                	mov    %esi,%eax
80101f23:	5b                   	pop    %ebx
80101f24:	5e                   	pop    %esi
80101f25:	5f                   	pop    %edi
80101f26:	5d                   	pop    %ebp
80101f27:	c3                   	ret    
80101f28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f2f:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80101f30:	ba 01 00 00 00       	mov    $0x1,%edx
80101f35:	b8 01 00 00 00       	mov    $0x1,%eax
80101f3a:	89 df                	mov    %ebx,%edi
80101f3c:	e8 1f f4 ff ff       	call   80101360 <iget>
80101f41:	89 c6                	mov    %eax,%esi
80101f43:	e9 9b fe ff ff       	jmp    80101de3 <namex+0x53>
80101f48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f4f:	90                   	nop
      iunlock(ip);
80101f50:	83 ec 0c             	sub    $0xc,%esp
80101f53:	56                   	push   %esi
80101f54:	e8 07 f9 ff ff       	call   80101860 <iunlock>
      return ip;
80101f59:	83 c4 10             	add    $0x10,%esp
}
80101f5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f5f:	89 f0                	mov    %esi,%eax
80101f61:	5b                   	pop    %ebx
80101f62:	5e                   	pop    %esi
80101f63:	5f                   	pop    %edi
80101f64:	5d                   	pop    %ebp
80101f65:	c3                   	ret    
80101f66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f6d:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80101f70:	83 ec 0c             	sub    $0xc,%esp
80101f73:	56                   	push   %esi
    return 0;
80101f74:	31 f6                	xor    %esi,%esi
    iput(ip);
80101f76:	e8 35 f9 ff ff       	call   801018b0 <iput>
    return 0;
80101f7b:	83 c4 10             	add    $0x10,%esp
80101f7e:	e9 68 ff ff ff       	jmp    80101eeb <namex+0x15b>
80101f83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101f90 <dirlink>:
{
80101f90:	f3 0f 1e fb          	endbr32 
80101f94:	55                   	push   %ebp
80101f95:	89 e5                	mov    %esp,%ebp
80101f97:	57                   	push   %edi
80101f98:	56                   	push   %esi
80101f99:	53                   	push   %ebx
80101f9a:	83 ec 20             	sub    $0x20,%esp
80101f9d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101fa0:	6a 00                	push   $0x0
80101fa2:	ff 75 0c             	pushl  0xc(%ebp)
80101fa5:	53                   	push   %ebx
80101fa6:	e8 25 fd ff ff       	call   80101cd0 <dirlookup>
80101fab:	83 c4 10             	add    $0x10,%esp
80101fae:	85 c0                	test   %eax,%eax
80101fb0:	75 6b                	jne    8010201d <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101fb2:	8b 7b 58             	mov    0x58(%ebx),%edi
80101fb5:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fb8:	85 ff                	test   %edi,%edi
80101fba:	74 2d                	je     80101fe9 <dirlink+0x59>
80101fbc:	31 ff                	xor    %edi,%edi
80101fbe:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fc1:	eb 0d                	jmp    80101fd0 <dirlink+0x40>
80101fc3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fc7:	90                   	nop
80101fc8:	83 c7 10             	add    $0x10,%edi
80101fcb:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101fce:	73 19                	jae    80101fe9 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fd0:	6a 10                	push   $0x10
80101fd2:	57                   	push   %edi
80101fd3:	56                   	push   %esi
80101fd4:	53                   	push   %ebx
80101fd5:	e8 a6 fa ff ff       	call   80101a80 <readi>
80101fda:	83 c4 10             	add    $0x10,%esp
80101fdd:	83 f8 10             	cmp    $0x10,%eax
80101fe0:	75 4e                	jne    80102030 <dirlink+0xa0>
    if(de.inum == 0)
80101fe2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101fe7:	75 df                	jne    80101fc8 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80101fe9:	83 ec 04             	sub    $0x4,%esp
80101fec:	8d 45 da             	lea    -0x26(%ebp),%eax
80101fef:	6a 0e                	push   $0xe
80101ff1:	ff 75 0c             	pushl  0xc(%ebp)
80101ff4:	50                   	push   %eax
80101ff5:	e8 f6 27 00 00       	call   801047f0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ffa:	6a 10                	push   $0x10
  de.inum = inum;
80101ffc:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fff:	57                   	push   %edi
80102000:	56                   	push   %esi
80102001:	53                   	push   %ebx
  de.inum = inum;
80102002:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102006:	e8 75 fb ff ff       	call   80101b80 <writei>
8010200b:	83 c4 20             	add    $0x20,%esp
8010200e:	83 f8 10             	cmp    $0x10,%eax
80102011:	75 2a                	jne    8010203d <dirlink+0xad>
  return 0;
80102013:	31 c0                	xor    %eax,%eax
}
80102015:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102018:	5b                   	pop    %ebx
80102019:	5e                   	pop    %esi
8010201a:	5f                   	pop    %edi
8010201b:	5d                   	pop    %ebp
8010201c:	c3                   	ret    
    iput(ip);
8010201d:	83 ec 0c             	sub    $0xc,%esp
80102020:	50                   	push   %eax
80102021:	e8 8a f8 ff ff       	call   801018b0 <iput>
    return -1;
80102026:	83 c4 10             	add    $0x10,%esp
80102029:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010202e:	eb e5                	jmp    80102015 <dirlink+0x85>
      panic("dirlink read");
80102030:	83 ec 0c             	sub    $0xc,%esp
80102033:	68 e8 72 10 80       	push   $0x801072e8
80102038:	e8 53 e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010203d:	83 ec 0c             	sub    $0xc,%esp
80102040:	68 c2 78 10 80       	push   $0x801078c2
80102045:	e8 46 e3 ff ff       	call   80100390 <panic>
8010204a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102050 <namei>:

struct inode*
namei(char *path)
{
80102050:	f3 0f 1e fb          	endbr32 
80102054:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102055:	31 d2                	xor    %edx,%edx
{
80102057:	89 e5                	mov    %esp,%ebp
80102059:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
8010205c:	8b 45 08             	mov    0x8(%ebp),%eax
8010205f:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80102062:	e8 29 fd ff ff       	call   80101d90 <namex>
}
80102067:	c9                   	leave  
80102068:	c3                   	ret    
80102069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102070 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102070:	f3 0f 1e fb          	endbr32 
80102074:	55                   	push   %ebp
  return namex(path, 1, name);
80102075:	ba 01 00 00 00       	mov    $0x1,%edx
{
8010207a:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
8010207c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010207f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102082:	5d                   	pop    %ebp
  return namex(path, 1, name);
80102083:	e9 08 fd ff ff       	jmp    80101d90 <namex>
80102088:	66 90                	xchg   %ax,%ax
8010208a:	66 90                	xchg   %ax,%ax
8010208c:	66 90                	xchg   %ax,%ax
8010208e:	66 90                	xchg   %ax,%ax

80102090 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102090:	55                   	push   %ebp
80102091:	89 e5                	mov    %esp,%ebp
80102093:	57                   	push   %edi
80102094:	56                   	push   %esi
80102095:	53                   	push   %ebx
80102096:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102099:	85 c0                	test   %eax,%eax
8010209b:	0f 84 b4 00 00 00    	je     80102155 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801020a1:	8b 70 08             	mov    0x8(%eax),%esi
801020a4:	89 c3                	mov    %eax,%ebx
801020a6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801020ac:	0f 87 96 00 00 00    	ja     80102148 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020b2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801020b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020be:	66 90                	xchg   %ax,%ax
801020c0:	89 ca                	mov    %ecx,%edx
801020c2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020c3:	83 e0 c0             	and    $0xffffffc0,%eax
801020c6:	3c 40                	cmp    $0x40,%al
801020c8:	75 f6                	jne    801020c0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020ca:	31 ff                	xor    %edi,%edi
801020cc:	ba f6 03 00 00       	mov    $0x3f6,%edx
801020d1:	89 f8                	mov    %edi,%eax
801020d3:	ee                   	out    %al,(%dx)
801020d4:	b8 01 00 00 00       	mov    $0x1,%eax
801020d9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801020de:	ee                   	out    %al,(%dx)
801020df:	ba f3 01 00 00       	mov    $0x1f3,%edx
801020e4:	89 f0                	mov    %esi,%eax
801020e6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801020e7:	89 f0                	mov    %esi,%eax
801020e9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801020ee:	c1 f8 08             	sar    $0x8,%eax
801020f1:	ee                   	out    %al,(%dx)
801020f2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801020f7:	89 f8                	mov    %edi,%eax
801020f9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801020fa:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801020fe:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102103:	c1 e0 04             	shl    $0x4,%eax
80102106:	83 e0 10             	and    $0x10,%eax
80102109:	83 c8 e0             	or     $0xffffffe0,%eax
8010210c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010210d:	f6 03 04             	testb  $0x4,(%ebx)
80102110:	75 16                	jne    80102128 <idestart+0x98>
80102112:	b8 20 00 00 00       	mov    $0x20,%eax
80102117:	89 ca                	mov    %ecx,%edx
80102119:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010211a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010211d:	5b                   	pop    %ebx
8010211e:	5e                   	pop    %esi
8010211f:	5f                   	pop    %edi
80102120:	5d                   	pop    %ebp
80102121:	c3                   	ret    
80102122:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102128:	b8 30 00 00 00       	mov    $0x30,%eax
8010212d:	89 ca                	mov    %ecx,%edx
8010212f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102130:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102135:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102138:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010213d:	fc                   	cld    
8010213e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102140:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102143:	5b                   	pop    %ebx
80102144:	5e                   	pop    %esi
80102145:	5f                   	pop    %edi
80102146:	5d                   	pop    %ebp
80102147:	c3                   	ret    
    panic("incorrect blockno");
80102148:	83 ec 0c             	sub    $0xc,%esp
8010214b:	68 54 73 10 80       	push   $0x80107354
80102150:	e8 3b e2 ff ff       	call   80100390 <panic>
    panic("idestart");
80102155:	83 ec 0c             	sub    $0xc,%esp
80102158:	68 4b 73 10 80       	push   $0x8010734b
8010215d:	e8 2e e2 ff ff       	call   80100390 <panic>
80102162:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102170 <ideinit>:
{
80102170:	f3 0f 1e fb          	endbr32 
80102174:	55                   	push   %ebp
80102175:	89 e5                	mov    %esp,%ebp
80102177:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
8010217a:	68 66 73 10 80       	push   $0x80107366
8010217f:	68 80 a5 10 80       	push   $0x8010a580
80102184:	e8 77 22 00 00       	call   80104400 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102189:	58                   	pop    %eax
8010218a:	a1 00 2d 11 80       	mov    0x80112d00,%eax
8010218f:	5a                   	pop    %edx
80102190:	83 e8 01             	sub    $0x1,%eax
80102193:	50                   	push   %eax
80102194:	6a 0e                	push   $0xe
80102196:	e8 b5 02 00 00       	call   80102450 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
8010219b:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010219e:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801021a7:	90                   	nop
801021a8:	ec                   	in     (%dx),%al
801021a9:	83 e0 c0             	and    $0xffffffc0,%eax
801021ac:	3c 40                	cmp    $0x40,%al
801021ae:	75 f8                	jne    801021a8 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021b0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021b5:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021ba:	ee                   	out    %al,(%dx)
801021bb:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021c0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021c5:	eb 0e                	jmp    801021d5 <ideinit+0x65>
801021c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021ce:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
801021d0:	83 e9 01             	sub    $0x1,%ecx
801021d3:	74 0f                	je     801021e4 <ideinit+0x74>
801021d5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801021d6:	84 c0                	test   %al,%al
801021d8:	74 f6                	je     801021d0 <ideinit+0x60>
      havedisk1 = 1;
801021da:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
801021e1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021e4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801021e9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021ee:	ee                   	out    %al,(%dx)
}
801021ef:	c9                   	leave  
801021f0:	c3                   	ret    
801021f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021ff:	90                   	nop

80102200 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102200:	f3 0f 1e fb          	endbr32 
80102204:	55                   	push   %ebp
80102205:	89 e5                	mov    %esp,%ebp
80102207:	57                   	push   %edi
80102208:	56                   	push   %esi
80102209:	53                   	push   %ebx
8010220a:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
8010220d:	68 80 a5 10 80       	push   $0x8010a580
80102212:	e8 69 23 00 00       	call   80104580 <acquire>

  if((b = idequeue) == 0){
80102217:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
8010221d:	83 c4 10             	add    $0x10,%esp
80102220:	85 db                	test   %ebx,%ebx
80102222:	74 5f                	je     80102283 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102224:	8b 43 58             	mov    0x58(%ebx),%eax
80102227:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010222c:	8b 33                	mov    (%ebx),%esi
8010222e:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102234:	75 2b                	jne    80102261 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102236:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010223b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010223f:	90                   	nop
80102240:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102241:	89 c1                	mov    %eax,%ecx
80102243:	83 e1 c0             	and    $0xffffffc0,%ecx
80102246:	80 f9 40             	cmp    $0x40,%cl
80102249:	75 f5                	jne    80102240 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010224b:	a8 21                	test   $0x21,%al
8010224d:	75 12                	jne    80102261 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010224f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102252:	b9 80 00 00 00       	mov    $0x80,%ecx
80102257:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010225c:	fc                   	cld    
8010225d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010225f:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102261:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102264:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102267:	83 ce 02             	or     $0x2,%esi
8010226a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010226c:	53                   	push   %ebx
8010226d:	e8 8e 1e 00 00       	call   80104100 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102272:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80102277:	83 c4 10             	add    $0x10,%esp
8010227a:	85 c0                	test   %eax,%eax
8010227c:	74 05                	je     80102283 <ideintr+0x83>
    idestart(idequeue);
8010227e:	e8 0d fe ff ff       	call   80102090 <idestart>
    release(&idelock);
80102283:	83 ec 0c             	sub    $0xc,%esp
80102286:	68 80 a5 10 80       	push   $0x8010a580
8010228b:	e8 b0 23 00 00       	call   80104640 <release>

  release(&idelock);
}
80102290:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102293:	5b                   	pop    %ebx
80102294:	5e                   	pop    %esi
80102295:	5f                   	pop    %edi
80102296:	5d                   	pop    %ebp
80102297:	c3                   	ret    
80102298:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010229f:	90                   	nop

801022a0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022a0:	f3 0f 1e fb          	endbr32 
801022a4:	55                   	push   %ebp
801022a5:	89 e5                	mov    %esp,%ebp
801022a7:	53                   	push   %ebx
801022a8:	83 ec 10             	sub    $0x10,%esp
801022ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022ae:	8d 43 0c             	lea    0xc(%ebx),%eax
801022b1:	50                   	push   %eax
801022b2:	e8 e9 20 00 00       	call   801043a0 <holdingsleep>
801022b7:	83 c4 10             	add    $0x10,%esp
801022ba:	85 c0                	test   %eax,%eax
801022bc:	0f 84 cf 00 00 00    	je     80102391 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022c2:	8b 03                	mov    (%ebx),%eax
801022c4:	83 e0 06             	and    $0x6,%eax
801022c7:	83 f8 02             	cmp    $0x2,%eax
801022ca:	0f 84 b4 00 00 00    	je     80102384 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801022d0:	8b 53 04             	mov    0x4(%ebx),%edx
801022d3:	85 d2                	test   %edx,%edx
801022d5:	74 0d                	je     801022e4 <iderw+0x44>
801022d7:	a1 60 a5 10 80       	mov    0x8010a560,%eax
801022dc:	85 c0                	test   %eax,%eax
801022de:	0f 84 93 00 00 00    	je     80102377 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801022e4:	83 ec 0c             	sub    $0xc,%esp
801022e7:	68 80 a5 10 80       	push   $0x8010a580
801022ec:	e8 8f 22 00 00       	call   80104580 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022f1:	a1 64 a5 10 80       	mov    0x8010a564,%eax
  b->qnext = 0;
801022f6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022fd:	83 c4 10             	add    $0x10,%esp
80102300:	85 c0                	test   %eax,%eax
80102302:	74 6c                	je     80102370 <iderw+0xd0>
80102304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102308:	89 c2                	mov    %eax,%edx
8010230a:	8b 40 58             	mov    0x58(%eax),%eax
8010230d:	85 c0                	test   %eax,%eax
8010230f:	75 f7                	jne    80102308 <iderw+0x68>
80102311:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102314:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102316:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
8010231c:	74 42                	je     80102360 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010231e:	8b 03                	mov    (%ebx),%eax
80102320:	83 e0 06             	and    $0x6,%eax
80102323:	83 f8 02             	cmp    $0x2,%eax
80102326:	74 23                	je     8010234b <iderw+0xab>
80102328:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010232f:	90                   	nop
    sleep(b, &idelock);
80102330:	83 ec 08             	sub    $0x8,%esp
80102333:	68 80 a5 10 80       	push   $0x8010a580
80102338:	53                   	push   %ebx
80102339:	e8 02 1c 00 00       	call   80103f40 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010233e:	8b 03                	mov    (%ebx),%eax
80102340:	83 c4 10             	add    $0x10,%esp
80102343:	83 e0 06             	and    $0x6,%eax
80102346:	83 f8 02             	cmp    $0x2,%eax
80102349:	75 e5                	jne    80102330 <iderw+0x90>
  }


  release(&idelock);
8010234b:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102352:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102355:	c9                   	leave  
  release(&idelock);
80102356:	e9 e5 22 00 00       	jmp    80104640 <release>
8010235b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010235f:	90                   	nop
    idestart(b);
80102360:	89 d8                	mov    %ebx,%eax
80102362:	e8 29 fd ff ff       	call   80102090 <idestart>
80102367:	eb b5                	jmp    8010231e <iderw+0x7e>
80102369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102370:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80102375:	eb 9d                	jmp    80102314 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102377:	83 ec 0c             	sub    $0xc,%esp
8010237a:	68 95 73 10 80       	push   $0x80107395
8010237f:	e8 0c e0 ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102384:	83 ec 0c             	sub    $0xc,%esp
80102387:	68 80 73 10 80       	push   $0x80107380
8010238c:	e8 ff df ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102391:	83 ec 0c             	sub    $0xc,%esp
80102394:	68 6a 73 10 80       	push   $0x8010736a
80102399:	e8 f2 df ff ff       	call   80100390 <panic>
8010239e:	66 90                	xchg   %ax,%ax

801023a0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023a0:	f3 0f 1e fb          	endbr32 
801023a4:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023a5:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801023ac:	00 c0 fe 
{
801023af:	89 e5                	mov    %esp,%ebp
801023b1:	56                   	push   %esi
801023b2:	53                   	push   %ebx
  ioapic->reg = reg;
801023b3:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023ba:	00 00 00 
  return ioapic->data;
801023bd:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801023c3:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023c6:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023cc:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023d2:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801023d9:	c1 ee 10             	shr    $0x10,%esi
801023dc:	89 f0                	mov    %esi,%eax
801023de:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801023e1:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
801023e4:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801023e7:	39 c2                	cmp    %eax,%edx
801023e9:	74 16                	je     80102401 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801023eb:	83 ec 0c             	sub    $0xc,%esp
801023ee:	68 b4 73 10 80       	push   $0x801073b4
801023f3:	e8 b8 e2 ff ff       	call   801006b0 <cprintf>
801023f8:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
801023fe:	83 c4 10             	add    $0x10,%esp
80102401:	83 c6 21             	add    $0x21,%esi
{
80102404:	ba 10 00 00 00       	mov    $0x10,%edx
80102409:	b8 20 00 00 00       	mov    $0x20,%eax
8010240e:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
80102410:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102412:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102414:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010241a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010241d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102423:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102426:	8d 5a 01             	lea    0x1(%edx),%ebx
80102429:	83 c2 02             	add    $0x2,%edx
8010242c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010242e:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102434:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010243b:	39 f0                	cmp    %esi,%eax
8010243d:	75 d1                	jne    80102410 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010243f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102442:	5b                   	pop    %ebx
80102443:	5e                   	pop    %esi
80102444:	5d                   	pop    %ebp
80102445:	c3                   	ret    
80102446:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010244d:	8d 76 00             	lea    0x0(%esi),%esi

80102450 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102450:	f3 0f 1e fb          	endbr32 
80102454:	55                   	push   %ebp
  ioapic->reg = reg;
80102455:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
8010245b:	89 e5                	mov    %esp,%ebp
8010245d:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102460:	8d 50 20             	lea    0x20(%eax),%edx
80102463:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102467:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102469:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010246f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102472:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102475:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102478:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010247a:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010247f:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102482:	89 50 10             	mov    %edx,0x10(%eax)
}
80102485:	5d                   	pop    %ebp
80102486:	c3                   	ret    
80102487:	66 90                	xchg   %ax,%ax
80102489:	66 90                	xchg   %ax,%ax
8010248b:	66 90                	xchg   %ax,%ax
8010248d:	66 90                	xchg   %ax,%ax
8010248f:	90                   	nop

80102490 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102490:	f3 0f 1e fb          	endbr32 
80102494:	55                   	push   %ebp
80102495:	89 e5                	mov    %esp,%ebp
80102497:	53                   	push   %ebx
80102498:	83 ec 04             	sub    $0x4,%esp
8010249b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010249e:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024a4:	75 7a                	jne    80102520 <kfree+0x90>
801024a6:	81 fb a8 55 11 80    	cmp    $0x801155a8,%ebx
801024ac:	72 72                	jb     80102520 <kfree+0x90>
801024ae:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024b4:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024b9:	77 65                	ja     80102520 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024bb:	83 ec 04             	sub    $0x4,%esp
801024be:	68 00 10 00 00       	push   $0x1000
801024c3:	6a 01                	push   $0x1
801024c5:	53                   	push   %ebx
801024c6:	e8 c5 21 00 00       	call   80104690 <memset>

  if(kmem.use_lock)
801024cb:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801024d1:	83 c4 10             	add    $0x10,%esp
801024d4:	85 d2                	test   %edx,%edx
801024d6:	75 20                	jne    801024f8 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801024d8:	a1 78 26 11 80       	mov    0x80112678,%eax
801024dd:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801024df:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
801024e4:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
801024ea:	85 c0                	test   %eax,%eax
801024ec:	75 22                	jne    80102510 <kfree+0x80>
    release(&kmem.lock);
}
801024ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024f1:	c9                   	leave  
801024f2:	c3                   	ret    
801024f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024f7:	90                   	nop
    acquire(&kmem.lock);
801024f8:	83 ec 0c             	sub    $0xc,%esp
801024fb:	68 40 26 11 80       	push   $0x80112640
80102500:	e8 7b 20 00 00       	call   80104580 <acquire>
80102505:	83 c4 10             	add    $0x10,%esp
80102508:	eb ce                	jmp    801024d8 <kfree+0x48>
8010250a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102510:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
80102517:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010251a:	c9                   	leave  
    release(&kmem.lock);
8010251b:	e9 20 21 00 00       	jmp    80104640 <release>
    panic("kfree");
80102520:	83 ec 0c             	sub    $0xc,%esp
80102523:	68 e6 73 10 80       	push   $0x801073e6
80102528:	e8 63 de ff ff       	call   80100390 <panic>
8010252d:	8d 76 00             	lea    0x0(%esi),%esi

80102530 <freerange>:
{
80102530:	f3 0f 1e fb          	endbr32 
80102534:	55                   	push   %ebp
80102535:	89 e5                	mov    %esp,%ebp
80102537:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102538:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010253b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010253e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010253f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102545:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010254b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102551:	39 de                	cmp    %ebx,%esi
80102553:	72 1f                	jb     80102574 <freerange+0x44>
80102555:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102558:	83 ec 0c             	sub    $0xc,%esp
8010255b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102561:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102567:	50                   	push   %eax
80102568:	e8 23 ff ff ff       	call   80102490 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010256d:	83 c4 10             	add    $0x10,%esp
80102570:	39 f3                	cmp    %esi,%ebx
80102572:	76 e4                	jbe    80102558 <freerange+0x28>
}
80102574:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102577:	5b                   	pop    %ebx
80102578:	5e                   	pop    %esi
80102579:	5d                   	pop    %ebp
8010257a:	c3                   	ret    
8010257b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010257f:	90                   	nop

80102580 <kinit1>:
{
80102580:	f3 0f 1e fb          	endbr32 
80102584:	55                   	push   %ebp
80102585:	89 e5                	mov    %esp,%ebp
80102587:	56                   	push   %esi
80102588:	53                   	push   %ebx
80102589:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
8010258c:	83 ec 08             	sub    $0x8,%esp
8010258f:	68 ec 73 10 80       	push   $0x801073ec
80102594:	68 40 26 11 80       	push   $0x80112640
80102599:	e8 62 1e 00 00       	call   80104400 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010259e:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025a1:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801025a4:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
801025ab:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801025ae:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025b4:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025ba:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025c0:	39 de                	cmp    %ebx,%esi
801025c2:	72 20                	jb     801025e4 <kinit1+0x64>
801025c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025c8:	83 ec 0c             	sub    $0xc,%esp
801025cb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025d7:	50                   	push   %eax
801025d8:	e8 b3 fe ff ff       	call   80102490 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025dd:	83 c4 10             	add    $0x10,%esp
801025e0:	39 de                	cmp    %ebx,%esi
801025e2:	73 e4                	jae    801025c8 <kinit1+0x48>
}
801025e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025e7:	5b                   	pop    %ebx
801025e8:	5e                   	pop    %esi
801025e9:	5d                   	pop    %ebp
801025ea:	c3                   	ret    
801025eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025ef:	90                   	nop

801025f0 <kinit2>:
{
801025f0:	f3 0f 1e fb          	endbr32 
801025f4:	55                   	push   %ebp
801025f5:	89 e5                	mov    %esp,%ebp
801025f7:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025f8:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025fb:	8b 75 0c             	mov    0xc(%ebp),%esi
801025fe:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025ff:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102605:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010260b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102611:	39 de                	cmp    %ebx,%esi
80102613:	72 1f                	jb     80102634 <kinit2+0x44>
80102615:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102618:	83 ec 0c             	sub    $0xc,%esp
8010261b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102621:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102627:	50                   	push   %eax
80102628:	e8 63 fe ff ff       	call   80102490 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010262d:	83 c4 10             	add    $0x10,%esp
80102630:	39 de                	cmp    %ebx,%esi
80102632:	73 e4                	jae    80102618 <kinit2+0x28>
  kmem.use_lock = 1;
80102634:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010263b:	00 00 00 
}
8010263e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102641:	5b                   	pop    %ebx
80102642:	5e                   	pop    %esi
80102643:	5d                   	pop    %ebp
80102644:	c3                   	ret    
80102645:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010264c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102650 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102650:	f3 0f 1e fb          	endbr32 
  struct run *r;

  if(kmem.use_lock)
80102654:	a1 74 26 11 80       	mov    0x80112674,%eax
80102659:	85 c0                	test   %eax,%eax
8010265b:	75 1b                	jne    80102678 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
8010265d:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
80102662:	85 c0                	test   %eax,%eax
80102664:	74 0a                	je     80102670 <kalloc+0x20>
    kmem.freelist = r->next;
80102666:	8b 10                	mov    (%eax),%edx
80102668:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
8010266e:	c3                   	ret    
8010266f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102670:	c3                   	ret    
80102671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102678:	55                   	push   %ebp
80102679:	89 e5                	mov    %esp,%ebp
8010267b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010267e:	68 40 26 11 80       	push   $0x80112640
80102683:	e8 f8 1e 00 00       	call   80104580 <acquire>
  r = kmem.freelist;
80102688:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
8010268d:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102693:	83 c4 10             	add    $0x10,%esp
80102696:	85 c0                	test   %eax,%eax
80102698:	74 08                	je     801026a2 <kalloc+0x52>
    kmem.freelist = r->next;
8010269a:	8b 08                	mov    (%eax),%ecx
8010269c:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
801026a2:	85 d2                	test   %edx,%edx
801026a4:	74 16                	je     801026bc <kalloc+0x6c>
    release(&kmem.lock);
801026a6:	83 ec 0c             	sub    $0xc,%esp
801026a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026ac:	68 40 26 11 80       	push   $0x80112640
801026b1:	e8 8a 1f 00 00       	call   80104640 <release>
  return (char*)r;
801026b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801026b9:	83 c4 10             	add    $0x10,%esp
}
801026bc:	c9                   	leave  
801026bd:	c3                   	ret    
801026be:	66 90                	xchg   %ax,%ax

801026c0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801026c0:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026c4:	ba 64 00 00 00       	mov    $0x64,%edx
801026c9:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801026ca:	a8 01                	test   $0x1,%al
801026cc:	0f 84 be 00 00 00    	je     80102790 <kbdgetc+0xd0>
{
801026d2:	55                   	push   %ebp
801026d3:	ba 60 00 00 00       	mov    $0x60,%edx
801026d8:	89 e5                	mov    %esp,%ebp
801026da:	53                   	push   %ebx
801026db:	ec                   	in     (%dx),%al
  return data;
801026dc:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
    return -1;
  data = inb(KBDATAP);
801026e2:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
801026e5:	3c e0                	cmp    $0xe0,%al
801026e7:	74 57                	je     80102740 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801026e9:	89 d9                	mov    %ebx,%ecx
801026eb:	83 e1 40             	and    $0x40,%ecx
801026ee:	84 c0                	test   %al,%al
801026f0:	78 5e                	js     80102750 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801026f2:	85 c9                	test   %ecx,%ecx
801026f4:	74 09                	je     801026ff <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801026f6:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801026f9:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801026fc:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801026ff:	0f b6 8a 20 75 10 80 	movzbl -0x7fef8ae0(%edx),%ecx
  shift ^= togglecode[data];
80102706:	0f b6 82 20 74 10 80 	movzbl -0x7fef8be0(%edx),%eax
  shift |= shiftcode[data];
8010270d:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
8010270f:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102711:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102713:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102719:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010271c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
8010271f:	8b 04 85 00 74 10 80 	mov    -0x7fef8c00(,%eax,4),%eax
80102726:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010272a:	74 0b                	je     80102737 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
8010272c:	8d 50 9f             	lea    -0x61(%eax),%edx
8010272f:	83 fa 19             	cmp    $0x19,%edx
80102732:	77 44                	ja     80102778 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102734:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102737:	5b                   	pop    %ebx
80102738:	5d                   	pop    %ebp
80102739:	c3                   	ret    
8010273a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102740:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102743:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102745:	89 1d b4 a5 10 80    	mov    %ebx,0x8010a5b4
}
8010274b:	5b                   	pop    %ebx
8010274c:	5d                   	pop    %ebp
8010274d:	c3                   	ret    
8010274e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102750:	83 e0 7f             	and    $0x7f,%eax
80102753:	85 c9                	test   %ecx,%ecx
80102755:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102758:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010275a:	0f b6 8a 20 75 10 80 	movzbl -0x7fef8ae0(%edx),%ecx
80102761:	83 c9 40             	or     $0x40,%ecx
80102764:	0f b6 c9             	movzbl %cl,%ecx
80102767:	f7 d1                	not    %ecx
80102769:	21 d9                	and    %ebx,%ecx
}
8010276b:	5b                   	pop    %ebx
8010276c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
8010276d:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
}
80102773:	c3                   	ret    
80102774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102778:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010277b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010277e:	5b                   	pop    %ebx
8010277f:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102780:	83 f9 1a             	cmp    $0x1a,%ecx
80102783:	0f 42 c2             	cmovb  %edx,%eax
}
80102786:	c3                   	ret    
80102787:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010278e:	66 90                	xchg   %ax,%ax
    return -1;
80102790:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102795:	c3                   	ret    
80102796:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010279d:	8d 76 00             	lea    0x0(%esi),%esi

801027a0 <kbdintr>:

void
kbdintr(void)
{
801027a0:	f3 0f 1e fb          	endbr32 
801027a4:	55                   	push   %ebp
801027a5:	89 e5                	mov    %esp,%ebp
801027a7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801027aa:	68 c0 26 10 80       	push   $0x801026c0
801027af:	e8 ac e0 ff ff       	call   80100860 <consoleintr>
}
801027b4:	83 c4 10             	add    $0x10,%esp
801027b7:	c9                   	leave  
801027b8:	c3                   	ret    
801027b9:	66 90                	xchg   %ax,%ax
801027bb:	66 90                	xchg   %ax,%ax
801027bd:	66 90                	xchg   %ax,%ax
801027bf:	90                   	nop

801027c0 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
801027c0:	f3 0f 1e fb          	endbr32 
  if(!lapic)
801027c4:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801027c9:	85 c0                	test   %eax,%eax
801027cb:	0f 84 c7 00 00 00    	je     80102898 <lapicinit+0xd8>
  lapic[index] = value;
801027d1:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801027d8:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027db:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027de:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801027e5:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027e8:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027eb:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801027f2:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801027f5:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027f8:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801027ff:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102802:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102805:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010280c:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010280f:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102812:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102819:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010281c:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010281f:	8b 50 30             	mov    0x30(%eax),%edx
80102822:	c1 ea 10             	shr    $0x10,%edx
80102825:	81 e2 fc 00 00 00    	and    $0xfc,%edx
8010282b:	75 73                	jne    801028a0 <lapicinit+0xe0>
  lapic[index] = value;
8010282d:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102834:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102837:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010283a:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102841:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102844:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102847:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010284e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102851:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102854:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
8010285b:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010285e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102861:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102868:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010286b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010286e:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102875:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102878:	8b 50 20             	mov    0x20(%eax),%edx
8010287b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010287f:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102880:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102886:	80 e6 10             	and    $0x10,%dh
80102889:	75 f5                	jne    80102880 <lapicinit+0xc0>
  lapic[index] = value;
8010288b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102892:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102895:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102898:	c3                   	ret    
80102899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801028a0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801028a7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028aa:	8b 50 20             	mov    0x20(%eax),%edx
}
801028ad:	e9 7b ff ff ff       	jmp    8010282d <lapicinit+0x6d>
801028b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801028c0 <lapicid>:

int
lapicid(void)
{
801028c0:	f3 0f 1e fb          	endbr32 
  if (!lapic)
801028c4:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801028c9:	85 c0                	test   %eax,%eax
801028cb:	74 0b                	je     801028d8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
801028cd:	8b 40 20             	mov    0x20(%eax),%eax
801028d0:	c1 e8 18             	shr    $0x18,%eax
801028d3:	c3                   	ret    
801028d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
801028d8:	31 c0                	xor    %eax,%eax
}
801028da:	c3                   	ret    
801028db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028df:	90                   	nop

801028e0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
801028e0:	f3 0f 1e fb          	endbr32 
  if(lapic)
801028e4:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801028e9:	85 c0                	test   %eax,%eax
801028eb:	74 0d                	je     801028fa <lapiceoi+0x1a>
  lapic[index] = value;
801028ed:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028f4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028f7:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801028fa:	c3                   	ret    
801028fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028ff:	90                   	nop

80102900 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102900:	f3 0f 1e fb          	endbr32 
}
80102904:	c3                   	ret    
80102905:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010290c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102910 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102910:	f3 0f 1e fb          	endbr32 
80102914:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102915:	b8 0f 00 00 00       	mov    $0xf,%eax
8010291a:	ba 70 00 00 00       	mov    $0x70,%edx
8010291f:	89 e5                	mov    %esp,%ebp
80102921:	53                   	push   %ebx
80102922:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102925:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102928:	ee                   	out    %al,(%dx)
80102929:	b8 0a 00 00 00       	mov    $0xa,%eax
8010292e:	ba 71 00 00 00       	mov    $0x71,%edx
80102933:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102934:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102936:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102939:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010293f:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102941:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102944:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102946:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102949:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
8010294c:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102952:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102957:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010295d:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102960:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102967:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010296a:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010296d:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102974:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102977:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010297a:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102980:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102983:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102989:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010298c:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102992:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102995:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
8010299b:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
8010299c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010299f:	5d                   	pop    %ebp
801029a0:	c3                   	ret    
801029a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029af:	90                   	nop

801029b0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801029b0:	f3 0f 1e fb          	endbr32 
801029b4:	55                   	push   %ebp
801029b5:	b8 0b 00 00 00       	mov    $0xb,%eax
801029ba:	ba 70 00 00 00       	mov    $0x70,%edx
801029bf:	89 e5                	mov    %esp,%ebp
801029c1:	57                   	push   %edi
801029c2:	56                   	push   %esi
801029c3:	53                   	push   %ebx
801029c4:	83 ec 4c             	sub    $0x4c,%esp
801029c7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029c8:	ba 71 00 00 00       	mov    $0x71,%edx
801029cd:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801029ce:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029d1:	bb 70 00 00 00       	mov    $0x70,%ebx
801029d6:	88 45 b3             	mov    %al,-0x4d(%ebp)
801029d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029e0:	31 c0                	xor    %eax,%eax
801029e2:	89 da                	mov    %ebx,%edx
801029e4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029e5:	b9 71 00 00 00       	mov    $0x71,%ecx
801029ea:	89 ca                	mov    %ecx,%edx
801029ec:	ec                   	in     (%dx),%al
801029ed:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029f0:	89 da                	mov    %ebx,%edx
801029f2:	b8 02 00 00 00       	mov    $0x2,%eax
801029f7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029f8:	89 ca                	mov    %ecx,%edx
801029fa:	ec                   	in     (%dx),%al
801029fb:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029fe:	89 da                	mov    %ebx,%edx
80102a00:	b8 04 00 00 00       	mov    $0x4,%eax
80102a05:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a06:	89 ca                	mov    %ecx,%edx
80102a08:	ec                   	in     (%dx),%al
80102a09:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a0c:	89 da                	mov    %ebx,%edx
80102a0e:	b8 07 00 00 00       	mov    $0x7,%eax
80102a13:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a14:	89 ca                	mov    %ecx,%edx
80102a16:	ec                   	in     (%dx),%al
80102a17:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a1a:	89 da                	mov    %ebx,%edx
80102a1c:	b8 08 00 00 00       	mov    $0x8,%eax
80102a21:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a22:	89 ca                	mov    %ecx,%edx
80102a24:	ec                   	in     (%dx),%al
80102a25:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a27:	89 da                	mov    %ebx,%edx
80102a29:	b8 09 00 00 00       	mov    $0x9,%eax
80102a2e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a2f:	89 ca                	mov    %ecx,%edx
80102a31:	ec                   	in     (%dx),%al
80102a32:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a34:	89 da                	mov    %ebx,%edx
80102a36:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a3b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a3c:	89 ca                	mov    %ecx,%edx
80102a3e:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a3f:	84 c0                	test   %al,%al
80102a41:	78 9d                	js     801029e0 <cmostime+0x30>
  return inb(CMOS_RETURN);
80102a43:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a47:	89 fa                	mov    %edi,%edx
80102a49:	0f b6 fa             	movzbl %dl,%edi
80102a4c:	89 f2                	mov    %esi,%edx
80102a4e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a51:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a55:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a58:	89 da                	mov    %ebx,%edx
80102a5a:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102a5d:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a60:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a64:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a67:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a6a:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a6e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a71:	31 c0                	xor    %eax,%eax
80102a73:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a74:	89 ca                	mov    %ecx,%edx
80102a76:	ec                   	in     (%dx),%al
80102a77:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a7a:	89 da                	mov    %ebx,%edx
80102a7c:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a7f:	b8 02 00 00 00       	mov    $0x2,%eax
80102a84:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a85:	89 ca                	mov    %ecx,%edx
80102a87:	ec                   	in     (%dx),%al
80102a88:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a8b:	89 da                	mov    %ebx,%edx
80102a8d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102a90:	b8 04 00 00 00       	mov    $0x4,%eax
80102a95:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a96:	89 ca                	mov    %ecx,%edx
80102a98:	ec                   	in     (%dx),%al
80102a99:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a9c:	89 da                	mov    %ebx,%edx
80102a9e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102aa1:	b8 07 00 00 00       	mov    $0x7,%eax
80102aa6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aa7:	89 ca                	mov    %ecx,%edx
80102aa9:	ec                   	in     (%dx),%al
80102aaa:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aad:	89 da                	mov    %ebx,%edx
80102aaf:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102ab2:	b8 08 00 00 00       	mov    $0x8,%eax
80102ab7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ab8:	89 ca                	mov    %ecx,%edx
80102aba:	ec                   	in     (%dx),%al
80102abb:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102abe:	89 da                	mov    %ebx,%edx
80102ac0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102ac3:	b8 09 00 00 00       	mov    $0x9,%eax
80102ac8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ac9:	89 ca                	mov    %ecx,%edx
80102acb:	ec                   	in     (%dx),%al
80102acc:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102acf:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102ad2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ad5:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102ad8:	6a 18                	push   $0x18
80102ada:	50                   	push   %eax
80102adb:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102ade:	50                   	push   %eax
80102adf:	e8 fc 1b 00 00       	call   801046e0 <memcmp>
80102ae4:	83 c4 10             	add    $0x10,%esp
80102ae7:	85 c0                	test   %eax,%eax
80102ae9:	0f 85 f1 fe ff ff    	jne    801029e0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102aef:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102af3:	75 78                	jne    80102b6d <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102af5:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102af8:	89 c2                	mov    %eax,%edx
80102afa:	83 e0 0f             	and    $0xf,%eax
80102afd:	c1 ea 04             	shr    $0x4,%edx
80102b00:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b03:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b06:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b09:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b0c:	89 c2                	mov    %eax,%edx
80102b0e:	83 e0 0f             	and    $0xf,%eax
80102b11:	c1 ea 04             	shr    $0x4,%edx
80102b14:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b17:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b1a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b1d:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b20:	89 c2                	mov    %eax,%edx
80102b22:	83 e0 0f             	and    $0xf,%eax
80102b25:	c1 ea 04             	shr    $0x4,%edx
80102b28:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b2b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b2e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b31:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b34:	89 c2                	mov    %eax,%edx
80102b36:	83 e0 0f             	and    $0xf,%eax
80102b39:	c1 ea 04             	shr    $0x4,%edx
80102b3c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b3f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b42:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b45:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b48:	89 c2                	mov    %eax,%edx
80102b4a:	83 e0 0f             	and    $0xf,%eax
80102b4d:	c1 ea 04             	shr    $0x4,%edx
80102b50:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b53:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b56:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b59:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b5c:	89 c2                	mov    %eax,%edx
80102b5e:	83 e0 0f             	and    $0xf,%eax
80102b61:	c1 ea 04             	shr    $0x4,%edx
80102b64:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b67:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b6a:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b6d:	8b 75 08             	mov    0x8(%ebp),%esi
80102b70:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b73:	89 06                	mov    %eax,(%esi)
80102b75:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b78:	89 46 04             	mov    %eax,0x4(%esi)
80102b7b:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b7e:	89 46 08             	mov    %eax,0x8(%esi)
80102b81:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b84:	89 46 0c             	mov    %eax,0xc(%esi)
80102b87:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b8a:	89 46 10             	mov    %eax,0x10(%esi)
80102b8d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b90:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102b93:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102b9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b9d:	5b                   	pop    %ebx
80102b9e:	5e                   	pop    %esi
80102b9f:	5f                   	pop    %edi
80102ba0:	5d                   	pop    %ebp
80102ba1:	c3                   	ret    
80102ba2:	66 90                	xchg   %ax,%ax
80102ba4:	66 90                	xchg   %ax,%ax
80102ba6:	66 90                	xchg   %ax,%ax
80102ba8:	66 90                	xchg   %ax,%ax
80102baa:	66 90                	xchg   %ax,%ax
80102bac:	66 90                	xchg   %ax,%ax
80102bae:	66 90                	xchg   %ax,%ax

80102bb0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102bb0:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102bb6:	85 c9                	test   %ecx,%ecx
80102bb8:	0f 8e 8a 00 00 00    	jle    80102c48 <install_trans+0x98>
{
80102bbe:	55                   	push   %ebp
80102bbf:	89 e5                	mov    %esp,%ebp
80102bc1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102bc2:	31 ff                	xor    %edi,%edi
{
80102bc4:	56                   	push   %esi
80102bc5:	53                   	push   %ebx
80102bc6:	83 ec 0c             	sub    $0xc,%esp
80102bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102bd0:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102bd5:	83 ec 08             	sub    $0x8,%esp
80102bd8:	01 f8                	add    %edi,%eax
80102bda:	83 c0 01             	add    $0x1,%eax
80102bdd:	50                   	push   %eax
80102bde:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102be4:	e8 e7 d4 ff ff       	call   801000d0 <bread>
80102be9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102beb:	58                   	pop    %eax
80102bec:	5a                   	pop    %edx
80102bed:	ff 34 bd cc 26 11 80 	pushl  -0x7feed934(,%edi,4)
80102bf4:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102bfa:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bfd:	e8 ce d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c02:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c05:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c07:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c0a:	68 00 02 00 00       	push   $0x200
80102c0f:	50                   	push   %eax
80102c10:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c13:	50                   	push   %eax
80102c14:	e8 17 1b 00 00       	call   80104730 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c19:	89 1c 24             	mov    %ebx,(%esp)
80102c1c:	e8 8f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c21:	89 34 24             	mov    %esi,(%esp)
80102c24:	e8 c7 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c29:	89 1c 24             	mov    %ebx,(%esp)
80102c2c:	e8 bf d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c31:	83 c4 10             	add    $0x10,%esp
80102c34:	39 3d c8 26 11 80    	cmp    %edi,0x801126c8
80102c3a:	7f 94                	jg     80102bd0 <install_trans+0x20>
  }
}
80102c3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c3f:	5b                   	pop    %ebx
80102c40:	5e                   	pop    %esi
80102c41:	5f                   	pop    %edi
80102c42:	5d                   	pop    %ebp
80102c43:	c3                   	ret    
80102c44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c48:	c3                   	ret    
80102c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c50 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c50:	55                   	push   %ebp
80102c51:	89 e5                	mov    %esp,%ebp
80102c53:	53                   	push   %ebx
80102c54:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c57:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102c5d:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102c63:	e8 68 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c68:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c6b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c6d:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102c72:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c75:	85 c0                	test   %eax,%eax
80102c77:	7e 19                	jle    80102c92 <write_head+0x42>
80102c79:	31 d2                	xor    %edx,%edx
80102c7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c7f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102c80:	8b 0c 95 cc 26 11 80 	mov    -0x7feed934(,%edx,4),%ecx
80102c87:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102c8b:	83 c2 01             	add    $0x1,%edx
80102c8e:	39 d0                	cmp    %edx,%eax
80102c90:	75 ee                	jne    80102c80 <write_head+0x30>
  }
  bwrite(buf);
80102c92:	83 ec 0c             	sub    $0xc,%esp
80102c95:	53                   	push   %ebx
80102c96:	e8 15 d5 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102c9b:	89 1c 24             	mov    %ebx,(%esp)
80102c9e:	e8 4d d5 ff ff       	call   801001f0 <brelse>
}
80102ca3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ca6:	83 c4 10             	add    $0x10,%esp
80102ca9:	c9                   	leave  
80102caa:	c3                   	ret    
80102cab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102caf:	90                   	nop

80102cb0 <initlog>:
{
80102cb0:	f3 0f 1e fb          	endbr32 
80102cb4:	55                   	push   %ebp
80102cb5:	89 e5                	mov    %esp,%ebp
80102cb7:	53                   	push   %ebx
80102cb8:	83 ec 2c             	sub    $0x2c,%esp
80102cbb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102cbe:	68 20 76 10 80       	push   $0x80107620
80102cc3:	68 80 26 11 80       	push   $0x80112680
80102cc8:	e8 33 17 00 00       	call   80104400 <initlock>
  readsb(dev, &sb);
80102ccd:	58                   	pop    %eax
80102cce:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102cd1:	5a                   	pop    %edx
80102cd2:	50                   	push   %eax
80102cd3:	53                   	push   %ebx
80102cd4:	e8 47 e8 ff ff       	call   80101520 <readsb>
  log.start = sb.logstart;
80102cd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102cdc:	59                   	pop    %ecx
  log.dev = dev;
80102cdd:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  log.size = sb.nlog;
80102ce3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102ce6:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  log.size = sb.nlog;
80102ceb:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  struct buf *buf = bread(log.dev, log.start);
80102cf1:	5a                   	pop    %edx
80102cf2:	50                   	push   %eax
80102cf3:	53                   	push   %ebx
80102cf4:	e8 d7 d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102cf9:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102cfc:	8b 48 5c             	mov    0x5c(%eax),%ecx
80102cff:	89 0d c8 26 11 80    	mov    %ecx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102d05:	85 c9                	test   %ecx,%ecx
80102d07:	7e 19                	jle    80102d22 <initlog+0x72>
80102d09:	31 d2                	xor    %edx,%edx
80102d0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d0f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102d10:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80102d14:	89 1c 95 cc 26 11 80 	mov    %ebx,-0x7feed934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d1b:	83 c2 01             	add    $0x1,%edx
80102d1e:	39 d1                	cmp    %edx,%ecx
80102d20:	75 ee                	jne    80102d10 <initlog+0x60>
  brelse(buf);
80102d22:	83 ec 0c             	sub    $0xc,%esp
80102d25:	50                   	push   %eax
80102d26:	e8 c5 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d2b:	e8 80 fe ff ff       	call   80102bb0 <install_trans>
  log.lh.n = 0;
80102d30:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102d37:	00 00 00 
  write_head(); // clear the log
80102d3a:	e8 11 ff ff ff       	call   80102c50 <write_head>
}
80102d3f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d42:	83 c4 10             	add    $0x10,%esp
80102d45:	c9                   	leave  
80102d46:	c3                   	ret    
80102d47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d4e:	66 90                	xchg   %ax,%ax

80102d50 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d50:	f3 0f 1e fb          	endbr32 
80102d54:	55                   	push   %ebp
80102d55:	89 e5                	mov    %esp,%ebp
80102d57:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d5a:	68 80 26 11 80       	push   $0x80112680
80102d5f:	e8 1c 18 00 00       	call   80104580 <acquire>
80102d64:	83 c4 10             	add    $0x10,%esp
80102d67:	eb 1c                	jmp    80102d85 <begin_op+0x35>
80102d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d70:	83 ec 08             	sub    $0x8,%esp
80102d73:	68 80 26 11 80       	push   $0x80112680
80102d78:	68 80 26 11 80       	push   $0x80112680
80102d7d:	e8 be 11 00 00       	call   80103f40 <sleep>
80102d82:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d85:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102d8a:	85 c0                	test   %eax,%eax
80102d8c:	75 e2                	jne    80102d70 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d8e:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102d93:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102d99:	83 c0 01             	add    $0x1,%eax
80102d9c:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102d9f:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102da2:	83 fa 1e             	cmp    $0x1e,%edx
80102da5:	7f c9                	jg     80102d70 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102da7:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102daa:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102daf:	68 80 26 11 80       	push   $0x80112680
80102db4:	e8 87 18 00 00       	call   80104640 <release>
      break;
    }
  }
}
80102db9:	83 c4 10             	add    $0x10,%esp
80102dbc:	c9                   	leave  
80102dbd:	c3                   	ret    
80102dbe:	66 90                	xchg   %ax,%ax

80102dc0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102dc0:	f3 0f 1e fb          	endbr32 
80102dc4:	55                   	push   %ebp
80102dc5:	89 e5                	mov    %esp,%ebp
80102dc7:	57                   	push   %edi
80102dc8:	56                   	push   %esi
80102dc9:	53                   	push   %ebx
80102dca:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102dcd:	68 80 26 11 80       	push   $0x80112680
80102dd2:	e8 a9 17 00 00       	call   80104580 <acquire>
  log.outstanding -= 1;
80102dd7:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102ddc:	8b 35 c0 26 11 80    	mov    0x801126c0,%esi
80102de2:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102de5:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102de8:	89 1d bc 26 11 80    	mov    %ebx,0x801126bc
  if(log.committing)
80102dee:	85 f6                	test   %esi,%esi
80102df0:	0f 85 1e 01 00 00    	jne    80102f14 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102df6:	85 db                	test   %ebx,%ebx
80102df8:	0f 85 f2 00 00 00    	jne    80102ef0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102dfe:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102e05:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e08:	83 ec 0c             	sub    $0xc,%esp
80102e0b:	68 80 26 11 80       	push   $0x80112680
80102e10:	e8 2b 18 00 00       	call   80104640 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e15:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102e1b:	83 c4 10             	add    $0x10,%esp
80102e1e:	85 c9                	test   %ecx,%ecx
80102e20:	7f 3e                	jg     80102e60 <end_op+0xa0>
    acquire(&log.lock);
80102e22:	83 ec 0c             	sub    $0xc,%esp
80102e25:	68 80 26 11 80       	push   $0x80112680
80102e2a:	e8 51 17 00 00       	call   80104580 <acquire>
    wakeup(&log);
80102e2f:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
    log.committing = 0;
80102e36:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102e3d:	00 00 00 
    wakeup(&log);
80102e40:	e8 bb 12 00 00       	call   80104100 <wakeup>
    release(&log.lock);
80102e45:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102e4c:	e8 ef 17 00 00       	call   80104640 <release>
80102e51:	83 c4 10             	add    $0x10,%esp
}
80102e54:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e57:	5b                   	pop    %ebx
80102e58:	5e                   	pop    %esi
80102e59:	5f                   	pop    %edi
80102e5a:	5d                   	pop    %ebp
80102e5b:	c3                   	ret    
80102e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e60:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102e65:	83 ec 08             	sub    $0x8,%esp
80102e68:	01 d8                	add    %ebx,%eax
80102e6a:	83 c0 01             	add    $0x1,%eax
80102e6d:	50                   	push   %eax
80102e6e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102e74:	e8 57 d2 ff ff       	call   801000d0 <bread>
80102e79:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e7b:	58                   	pop    %eax
80102e7c:	5a                   	pop    %edx
80102e7d:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102e84:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102e8a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e8d:	e8 3e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102e92:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e95:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102e97:	8d 40 5c             	lea    0x5c(%eax),%eax
80102e9a:	68 00 02 00 00       	push   $0x200
80102e9f:	50                   	push   %eax
80102ea0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102ea3:	50                   	push   %eax
80102ea4:	e8 87 18 00 00       	call   80104730 <memmove>
    bwrite(to);  // write the log
80102ea9:	89 34 24             	mov    %esi,(%esp)
80102eac:	e8 ff d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102eb1:	89 3c 24             	mov    %edi,(%esp)
80102eb4:	e8 37 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102eb9:	89 34 24             	mov    %esi,(%esp)
80102ebc:	e8 2f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ec1:	83 c4 10             	add    $0x10,%esp
80102ec4:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102eca:	7c 94                	jl     80102e60 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102ecc:	e8 7f fd ff ff       	call   80102c50 <write_head>
    install_trans(); // Now install writes to home locations
80102ed1:	e8 da fc ff ff       	call   80102bb0 <install_trans>
    log.lh.n = 0;
80102ed6:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102edd:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ee0:	e8 6b fd ff ff       	call   80102c50 <write_head>
80102ee5:	e9 38 ff ff ff       	jmp    80102e22 <end_op+0x62>
80102eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102ef0:	83 ec 0c             	sub    $0xc,%esp
80102ef3:	68 80 26 11 80       	push   $0x80112680
80102ef8:	e8 03 12 00 00       	call   80104100 <wakeup>
  release(&log.lock);
80102efd:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102f04:	e8 37 17 00 00       	call   80104640 <release>
80102f09:	83 c4 10             	add    $0x10,%esp
}
80102f0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f0f:	5b                   	pop    %ebx
80102f10:	5e                   	pop    %esi
80102f11:	5f                   	pop    %edi
80102f12:	5d                   	pop    %ebp
80102f13:	c3                   	ret    
    panic("log.committing");
80102f14:	83 ec 0c             	sub    $0xc,%esp
80102f17:	68 24 76 10 80       	push   $0x80107624
80102f1c:	e8 6f d4 ff ff       	call   80100390 <panic>
80102f21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f2f:	90                   	nop

80102f30 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f30:	f3 0f 1e fb          	endbr32 
80102f34:	55                   	push   %ebp
80102f35:	89 e5                	mov    %esp,%ebp
80102f37:	53                   	push   %ebx
80102f38:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f3b:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
{
80102f41:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f44:	83 fa 1d             	cmp    $0x1d,%edx
80102f47:	0f 8f 91 00 00 00    	jg     80102fde <log_write+0xae>
80102f4d:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102f52:	83 e8 01             	sub    $0x1,%eax
80102f55:	39 c2                	cmp    %eax,%edx
80102f57:	0f 8d 81 00 00 00    	jge    80102fde <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f5d:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102f62:	85 c0                	test   %eax,%eax
80102f64:	0f 8e 81 00 00 00    	jle    80102feb <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f6a:	83 ec 0c             	sub    $0xc,%esp
80102f6d:	68 80 26 11 80       	push   $0x80112680
80102f72:	e8 09 16 00 00       	call   80104580 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f77:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102f7d:	83 c4 10             	add    $0x10,%esp
80102f80:	85 d2                	test   %edx,%edx
80102f82:	7e 4e                	jle    80102fd2 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f84:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f87:	31 c0                	xor    %eax,%eax
80102f89:	eb 0c                	jmp    80102f97 <log_write+0x67>
80102f8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f8f:	90                   	nop
80102f90:	83 c0 01             	add    $0x1,%eax
80102f93:	39 c2                	cmp    %eax,%edx
80102f95:	74 29                	je     80102fc0 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f97:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102f9e:	75 f0                	jne    80102f90 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102fa0:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102fa7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102faa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102fad:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102fb4:	c9                   	leave  
  release(&log.lock);
80102fb5:	e9 86 16 00 00       	jmp    80104640 <release>
80102fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102fc0:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
    log.lh.n++;
80102fc7:	83 c2 01             	add    $0x1,%edx
80102fca:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
80102fd0:	eb d5                	jmp    80102fa7 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80102fd2:	8b 43 08             	mov    0x8(%ebx),%eax
80102fd5:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102fda:	75 cb                	jne    80102fa7 <log_write+0x77>
80102fdc:	eb e9                	jmp    80102fc7 <log_write+0x97>
    panic("too big a transaction");
80102fde:	83 ec 0c             	sub    $0xc,%esp
80102fe1:	68 33 76 10 80       	push   $0x80107633
80102fe6:	e8 a5 d3 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102feb:	83 ec 0c             	sub    $0xc,%esp
80102fee:	68 49 76 10 80       	push   $0x80107649
80102ff3:	e8 98 d3 ff ff       	call   80100390 <panic>
80102ff8:	66 90                	xchg   %ax,%ax
80102ffa:	66 90                	xchg   %ax,%ax
80102ffc:	66 90                	xchg   %ax,%ax
80102ffe:	66 90                	xchg   %ax,%ax

80103000 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103000:	55                   	push   %ebp
80103001:	89 e5                	mov    %esp,%ebp
80103003:	53                   	push   %ebx
80103004:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103007:	e8 54 09 00 00       	call   80103960 <cpuid>
8010300c:	89 c3                	mov    %eax,%ebx
8010300e:	e8 4d 09 00 00       	call   80103960 <cpuid>
80103013:	83 ec 04             	sub    $0x4,%esp
80103016:	53                   	push   %ebx
80103017:	50                   	push   %eax
80103018:	68 64 76 10 80       	push   $0x80107664
8010301d:	e8 8e d6 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103022:	e8 59 29 00 00       	call   80105980 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103027:	e8 c4 08 00 00       	call   801038f0 <mycpu>
8010302c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010302e:	b8 01 00 00 00       	mov    $0x1,%eax
80103033:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010303a:	e8 11 0c 00 00       	call   80103c50 <scheduler>
8010303f:	90                   	nop

80103040 <mpenter>:
{
80103040:	f3 0f 1e fb          	endbr32 
80103044:	55                   	push   %ebp
80103045:	89 e5                	mov    %esp,%ebp
80103047:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010304a:	e8 31 3a 00 00       	call   80106a80 <switchkvm>
  seginit();
8010304f:	e8 9c 39 00 00       	call   801069f0 <seginit>
  lapicinit();
80103054:	e8 67 f7 ff ff       	call   801027c0 <lapicinit>
  mpmain();
80103059:	e8 a2 ff ff ff       	call   80103000 <mpmain>
8010305e:	66 90                	xchg   %ax,%ax

80103060 <main>:
{
80103060:	f3 0f 1e fb          	endbr32 
80103064:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103068:	83 e4 f0             	and    $0xfffffff0,%esp
8010306b:	ff 71 fc             	pushl  -0x4(%ecx)
8010306e:	55                   	push   %ebp
8010306f:	89 e5                	mov    %esp,%ebp
80103071:	53                   	push   %ebx
80103072:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103073:	83 ec 08             	sub    $0x8,%esp
80103076:	68 00 00 40 80       	push   $0x80400000
8010307b:	68 a8 55 11 80       	push   $0x801155a8
80103080:	e8 fb f4 ff ff       	call   80102580 <kinit1>
  kvmalloc();      // kernel page table
80103085:	e8 d6 3e 00 00       	call   80106f60 <kvmalloc>
  mpinit();        // detect other processors
8010308a:	e8 81 01 00 00       	call   80103210 <mpinit>
  lapicinit();     // interrupt controller
8010308f:	e8 2c f7 ff ff       	call   801027c0 <lapicinit>
  seginit();       // segment descriptors
80103094:	e8 57 39 00 00       	call   801069f0 <seginit>
  picinit();       // disable pic
80103099:	e8 52 03 00 00       	call   801033f0 <picinit>
  ioapicinit();    // another interrupt controller
8010309e:	e8 fd f2 ff ff       	call   801023a0 <ioapicinit>
  consoleinit();   // console hardware
801030a3:	e8 88 d9 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
801030a8:	e8 03 2c 00 00       	call   80105cb0 <uartinit>
  pinit();         // process table
801030ad:	e8 1e 08 00 00       	call   801038d0 <pinit>
  tvinit();        // trap vectors
801030b2:	e8 49 28 00 00       	call   80105900 <tvinit>
  binit();         // buffer cache
801030b7:	e8 84 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030bc:	e8 3f dd ff ff       	call   80100e00 <fileinit>
  ideinit();       // disk 
801030c1:	e8 aa f0 ff ff       	call   80102170 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030c6:	83 c4 0c             	add    $0xc,%esp
801030c9:	68 8a 00 00 00       	push   $0x8a
801030ce:	68 8c a4 10 80       	push   $0x8010a48c
801030d3:	68 00 70 00 80       	push   $0x80007000
801030d8:	e8 53 16 00 00       	call   80104730 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030dd:	83 c4 10             	add    $0x10,%esp
801030e0:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
801030e7:	00 00 00 
801030ea:	05 80 27 11 80       	add    $0x80112780,%eax
801030ef:	3d 80 27 11 80       	cmp    $0x80112780,%eax
801030f4:	76 7a                	jbe    80103170 <main+0x110>
801030f6:	bb 80 27 11 80       	mov    $0x80112780,%ebx
801030fb:	eb 1c                	jmp    80103119 <main+0xb9>
801030fd:	8d 76 00             	lea    0x0(%esi),%esi
80103100:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80103107:	00 00 00 
8010310a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103110:	05 80 27 11 80       	add    $0x80112780,%eax
80103115:	39 c3                	cmp    %eax,%ebx
80103117:	73 57                	jae    80103170 <main+0x110>
    if(c == mycpu())  // We've started already.
80103119:	e8 d2 07 00 00       	call   801038f0 <mycpu>
8010311e:	39 c3                	cmp    %eax,%ebx
80103120:	74 de                	je     80103100 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103122:	e8 29 f5 ff ff       	call   80102650 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103127:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010312a:	c7 05 f8 6f 00 80 40 	movl   $0x80103040,0x80006ff8
80103131:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103134:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
8010313b:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010313e:	05 00 10 00 00       	add    $0x1000,%eax
80103143:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103148:	0f b6 03             	movzbl (%ebx),%eax
8010314b:	68 00 70 00 00       	push   $0x7000
80103150:	50                   	push   %eax
80103151:	e8 ba f7 ff ff       	call   80102910 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103156:	83 c4 10             	add    $0x10,%esp
80103159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103160:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103166:	85 c0                	test   %eax,%eax
80103168:	74 f6                	je     80103160 <main+0x100>
8010316a:	eb 94                	jmp    80103100 <main+0xa0>
8010316c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103170:	83 ec 08             	sub    $0x8,%esp
80103173:	68 00 00 00 8e       	push   $0x8e000000
80103178:	68 00 00 40 80       	push   $0x80400000
8010317d:	e8 6e f4 ff ff       	call   801025f0 <kinit2>
  userinit();      // first user process
80103182:	e8 29 08 00 00       	call   801039b0 <userinit>
  mpmain();        // finish this processor's setup
80103187:	e8 74 fe ff ff       	call   80103000 <mpmain>
8010318c:	66 90                	xchg   %ax,%ax
8010318e:	66 90                	xchg   %ax,%ax

80103190 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103190:	55                   	push   %ebp
80103191:	89 e5                	mov    %esp,%ebp
80103193:	57                   	push   %edi
80103194:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103195:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010319b:	53                   	push   %ebx
  e = addr+len;
8010319c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010319f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801031a2:	39 de                	cmp    %ebx,%esi
801031a4:	72 10                	jb     801031b6 <mpsearch1+0x26>
801031a6:	eb 50                	jmp    801031f8 <mpsearch1+0x68>
801031a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031af:	90                   	nop
801031b0:	89 fe                	mov    %edi,%esi
801031b2:	39 fb                	cmp    %edi,%ebx
801031b4:	76 42                	jbe    801031f8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031b6:	83 ec 04             	sub    $0x4,%esp
801031b9:	8d 7e 10             	lea    0x10(%esi),%edi
801031bc:	6a 04                	push   $0x4
801031be:	68 78 76 10 80       	push   $0x80107678
801031c3:	56                   	push   %esi
801031c4:	e8 17 15 00 00       	call   801046e0 <memcmp>
801031c9:	83 c4 10             	add    $0x10,%esp
801031cc:	85 c0                	test   %eax,%eax
801031ce:	75 e0                	jne    801031b0 <mpsearch1+0x20>
801031d0:	89 f2                	mov    %esi,%edx
801031d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031d8:	0f b6 0a             	movzbl (%edx),%ecx
801031db:	83 c2 01             	add    $0x1,%edx
801031de:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801031e0:	39 fa                	cmp    %edi,%edx
801031e2:	75 f4                	jne    801031d8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031e4:	84 c0                	test   %al,%al
801031e6:	75 c8                	jne    801031b0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031eb:	89 f0                	mov    %esi,%eax
801031ed:	5b                   	pop    %ebx
801031ee:	5e                   	pop    %esi
801031ef:	5f                   	pop    %edi
801031f0:	5d                   	pop    %ebp
801031f1:	c3                   	ret    
801031f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801031fb:	31 f6                	xor    %esi,%esi
}
801031fd:	5b                   	pop    %ebx
801031fe:	89 f0                	mov    %esi,%eax
80103200:	5e                   	pop    %esi
80103201:	5f                   	pop    %edi
80103202:	5d                   	pop    %ebp
80103203:	c3                   	ret    
80103204:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010320b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010320f:	90                   	nop

80103210 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103210:	f3 0f 1e fb          	endbr32 
80103214:	55                   	push   %ebp
80103215:	89 e5                	mov    %esp,%ebp
80103217:	57                   	push   %edi
80103218:	56                   	push   %esi
80103219:	53                   	push   %ebx
8010321a:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
8010321d:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103224:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
8010322b:	c1 e0 08             	shl    $0x8,%eax
8010322e:	09 d0                	or     %edx,%eax
80103230:	c1 e0 04             	shl    $0x4,%eax
80103233:	75 1b                	jne    80103250 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103235:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010323c:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103243:	c1 e0 08             	shl    $0x8,%eax
80103246:	09 d0                	or     %edx,%eax
80103248:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
8010324b:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103250:	ba 00 04 00 00       	mov    $0x400,%edx
80103255:	e8 36 ff ff ff       	call   80103190 <mpsearch1>
8010325a:	89 c6                	mov    %eax,%esi
8010325c:	85 c0                	test   %eax,%eax
8010325e:	0f 84 4c 01 00 00    	je     801033b0 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103264:	8b 5e 04             	mov    0x4(%esi),%ebx
80103267:	85 db                	test   %ebx,%ebx
80103269:	0f 84 61 01 00 00    	je     801033d0 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
8010326f:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103272:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103278:	6a 04                	push   $0x4
8010327a:	68 7d 76 10 80       	push   $0x8010767d
8010327f:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103280:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103283:	e8 58 14 00 00       	call   801046e0 <memcmp>
80103288:	83 c4 10             	add    $0x10,%esp
8010328b:	85 c0                	test   %eax,%eax
8010328d:	0f 85 3d 01 00 00    	jne    801033d0 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
80103293:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
8010329a:	3c 01                	cmp    $0x1,%al
8010329c:	74 08                	je     801032a6 <mpinit+0x96>
8010329e:	3c 04                	cmp    $0x4,%al
801032a0:	0f 85 2a 01 00 00    	jne    801033d0 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
801032a6:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
801032ad:	66 85 d2             	test   %dx,%dx
801032b0:	74 26                	je     801032d8 <mpinit+0xc8>
801032b2:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
801032b5:	89 d8                	mov    %ebx,%eax
  sum = 0;
801032b7:	31 d2                	xor    %edx,%edx
801032b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801032c0:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
801032c7:	83 c0 01             	add    $0x1,%eax
801032ca:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032cc:	39 f8                	cmp    %edi,%eax
801032ce:	75 f0                	jne    801032c0 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
801032d0:	84 d2                	test   %dl,%dl
801032d2:	0f 85 f8 00 00 00    	jne    801033d0 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032d8:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801032de:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032e3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
801032e9:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
801032f0:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032f5:	03 55 e4             	add    -0x1c(%ebp),%edx
801032f8:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801032fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032ff:	90                   	nop
80103300:	39 c2                	cmp    %eax,%edx
80103302:	76 15                	jbe    80103319 <mpinit+0x109>
    switch(*p){
80103304:	0f b6 08             	movzbl (%eax),%ecx
80103307:	80 f9 02             	cmp    $0x2,%cl
8010330a:	74 5c                	je     80103368 <mpinit+0x158>
8010330c:	77 42                	ja     80103350 <mpinit+0x140>
8010330e:	84 c9                	test   %cl,%cl
80103310:	74 6e                	je     80103380 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103312:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103315:	39 c2                	cmp    %eax,%edx
80103317:	77 eb                	ja     80103304 <mpinit+0xf4>
80103319:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010331c:	85 db                	test   %ebx,%ebx
8010331e:	0f 84 b9 00 00 00    	je     801033dd <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103324:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103328:	74 15                	je     8010333f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010332a:	b8 70 00 00 00       	mov    $0x70,%eax
8010332f:	ba 22 00 00 00       	mov    $0x22,%edx
80103334:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103335:	ba 23 00 00 00       	mov    $0x23,%edx
8010333a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010333b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010333e:	ee                   	out    %al,(%dx)
  }
}
8010333f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103342:	5b                   	pop    %ebx
80103343:	5e                   	pop    %esi
80103344:	5f                   	pop    %edi
80103345:	5d                   	pop    %ebp
80103346:	c3                   	ret    
80103347:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010334e:	66 90                	xchg   %ax,%ax
    switch(*p){
80103350:	83 e9 03             	sub    $0x3,%ecx
80103353:	80 f9 01             	cmp    $0x1,%cl
80103356:	76 ba                	jbe    80103312 <mpinit+0x102>
80103358:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010335f:	eb 9f                	jmp    80103300 <mpinit+0xf0>
80103361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103368:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
8010336c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010336f:	88 0d 60 27 11 80    	mov    %cl,0x80112760
      continue;
80103375:	eb 89                	jmp    80103300 <mpinit+0xf0>
80103377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010337e:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103380:	8b 0d 00 2d 11 80    	mov    0x80112d00,%ecx
80103386:	83 f9 07             	cmp    $0x7,%ecx
80103389:	7f 19                	jg     801033a4 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010338b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103391:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103395:	83 c1 01             	add    $0x1,%ecx
80103398:	89 0d 00 2d 11 80    	mov    %ecx,0x80112d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010339e:	88 9f 80 27 11 80    	mov    %bl,-0x7feed880(%edi)
      p += sizeof(struct mpproc);
801033a4:	83 c0 14             	add    $0x14,%eax
      continue;
801033a7:	e9 54 ff ff ff       	jmp    80103300 <mpinit+0xf0>
801033ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
801033b0:	ba 00 00 01 00       	mov    $0x10000,%edx
801033b5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801033ba:	e8 d1 fd ff ff       	call   80103190 <mpsearch1>
801033bf:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801033c1:	85 c0                	test   %eax,%eax
801033c3:	0f 85 9b fe ff ff    	jne    80103264 <mpinit+0x54>
801033c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801033d0:	83 ec 0c             	sub    $0xc,%esp
801033d3:	68 82 76 10 80       	push   $0x80107682
801033d8:	e8 b3 cf ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801033dd:	83 ec 0c             	sub    $0xc,%esp
801033e0:	68 9c 76 10 80       	push   $0x8010769c
801033e5:	e8 a6 cf ff ff       	call   80100390 <panic>
801033ea:	66 90                	xchg   %ax,%ax
801033ec:	66 90                	xchg   %ax,%ax
801033ee:	66 90                	xchg   %ax,%ax

801033f0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801033f0:	f3 0f 1e fb          	endbr32 
801033f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801033f9:	ba 21 00 00 00       	mov    $0x21,%edx
801033fe:	ee                   	out    %al,(%dx)
801033ff:	ba a1 00 00 00       	mov    $0xa1,%edx
80103404:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103405:	c3                   	ret    
80103406:	66 90                	xchg   %ax,%ax
80103408:	66 90                	xchg   %ax,%ax
8010340a:	66 90                	xchg   %ax,%ax
8010340c:	66 90                	xchg   %ax,%ax
8010340e:	66 90                	xchg   %ax,%ax

80103410 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103410:	f3 0f 1e fb          	endbr32 
80103414:	55                   	push   %ebp
80103415:	89 e5                	mov    %esp,%ebp
80103417:	57                   	push   %edi
80103418:	56                   	push   %esi
80103419:	53                   	push   %ebx
8010341a:	83 ec 0c             	sub    $0xc,%esp
8010341d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103420:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103423:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103429:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010342f:	e8 ec d9 ff ff       	call   80100e20 <filealloc>
80103434:	89 03                	mov    %eax,(%ebx)
80103436:	85 c0                	test   %eax,%eax
80103438:	0f 84 ac 00 00 00    	je     801034ea <pipealloc+0xda>
8010343e:	e8 dd d9 ff ff       	call   80100e20 <filealloc>
80103443:	89 06                	mov    %eax,(%esi)
80103445:	85 c0                	test   %eax,%eax
80103447:	0f 84 8b 00 00 00    	je     801034d8 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010344d:	e8 fe f1 ff ff       	call   80102650 <kalloc>
80103452:	89 c7                	mov    %eax,%edi
80103454:	85 c0                	test   %eax,%eax
80103456:	0f 84 b4 00 00 00    	je     80103510 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
8010345c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103463:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103466:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103469:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103470:	00 00 00 
  p->nwrite = 0;
80103473:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010347a:	00 00 00 
  p->nread = 0;
8010347d:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103484:	00 00 00 
  initlock(&p->lock, "pipe");
80103487:	68 bb 76 10 80       	push   $0x801076bb
8010348c:	50                   	push   %eax
8010348d:	e8 6e 0f 00 00       	call   80104400 <initlock>
  (*f0)->type = FD_PIPE;
80103492:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103494:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103497:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
8010349d:	8b 03                	mov    (%ebx),%eax
8010349f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801034a3:	8b 03                	mov    (%ebx),%eax
801034a5:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034a9:	8b 03                	mov    (%ebx),%eax
801034ab:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034ae:	8b 06                	mov    (%esi),%eax
801034b0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034b6:	8b 06                	mov    (%esi),%eax
801034b8:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034bc:	8b 06                	mov    (%esi),%eax
801034be:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034c2:	8b 06                	mov    (%esi),%eax
801034c4:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034ca:	31 c0                	xor    %eax,%eax
}
801034cc:	5b                   	pop    %ebx
801034cd:	5e                   	pop    %esi
801034ce:	5f                   	pop    %edi
801034cf:	5d                   	pop    %ebp
801034d0:	c3                   	ret    
801034d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801034d8:	8b 03                	mov    (%ebx),%eax
801034da:	85 c0                	test   %eax,%eax
801034dc:	74 1e                	je     801034fc <pipealloc+0xec>
    fileclose(*f0);
801034de:	83 ec 0c             	sub    $0xc,%esp
801034e1:	50                   	push   %eax
801034e2:	e8 f9 d9 ff ff       	call   80100ee0 <fileclose>
801034e7:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801034ea:	8b 06                	mov    (%esi),%eax
801034ec:	85 c0                	test   %eax,%eax
801034ee:	74 0c                	je     801034fc <pipealloc+0xec>
    fileclose(*f1);
801034f0:	83 ec 0c             	sub    $0xc,%esp
801034f3:	50                   	push   %eax
801034f4:	e8 e7 d9 ff ff       	call   80100ee0 <fileclose>
801034f9:	83 c4 10             	add    $0x10,%esp
}
801034fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801034ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103504:	5b                   	pop    %ebx
80103505:	5e                   	pop    %esi
80103506:	5f                   	pop    %edi
80103507:	5d                   	pop    %ebp
80103508:	c3                   	ret    
80103509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103510:	8b 03                	mov    (%ebx),%eax
80103512:	85 c0                	test   %eax,%eax
80103514:	75 c8                	jne    801034de <pipealloc+0xce>
80103516:	eb d2                	jmp    801034ea <pipealloc+0xda>
80103518:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010351f:	90                   	nop

80103520 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103520:	f3 0f 1e fb          	endbr32 
80103524:	55                   	push   %ebp
80103525:	89 e5                	mov    %esp,%ebp
80103527:	56                   	push   %esi
80103528:	53                   	push   %ebx
80103529:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010352c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010352f:	83 ec 0c             	sub    $0xc,%esp
80103532:	53                   	push   %ebx
80103533:	e8 48 10 00 00       	call   80104580 <acquire>
  if(writable){
80103538:	83 c4 10             	add    $0x10,%esp
8010353b:	85 f6                	test   %esi,%esi
8010353d:	74 41                	je     80103580 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010353f:	83 ec 0c             	sub    $0xc,%esp
80103542:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103548:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010354f:	00 00 00 
    wakeup(&p->nread);
80103552:	50                   	push   %eax
80103553:	e8 a8 0b 00 00       	call   80104100 <wakeup>
80103558:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010355b:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103561:	85 d2                	test   %edx,%edx
80103563:	75 0a                	jne    8010356f <pipeclose+0x4f>
80103565:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
8010356b:	85 c0                	test   %eax,%eax
8010356d:	74 31                	je     801035a0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010356f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103572:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103575:	5b                   	pop    %ebx
80103576:	5e                   	pop    %esi
80103577:	5d                   	pop    %ebp
    release(&p->lock);
80103578:	e9 c3 10 00 00       	jmp    80104640 <release>
8010357d:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103580:	83 ec 0c             	sub    $0xc,%esp
80103583:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103589:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103590:	00 00 00 
    wakeup(&p->nwrite);
80103593:	50                   	push   %eax
80103594:	e8 67 0b 00 00       	call   80104100 <wakeup>
80103599:	83 c4 10             	add    $0x10,%esp
8010359c:	eb bd                	jmp    8010355b <pipeclose+0x3b>
8010359e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801035a0:	83 ec 0c             	sub    $0xc,%esp
801035a3:	53                   	push   %ebx
801035a4:	e8 97 10 00 00       	call   80104640 <release>
    kfree((char*)p);
801035a9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801035ac:	83 c4 10             	add    $0x10,%esp
}
801035af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035b2:	5b                   	pop    %ebx
801035b3:	5e                   	pop    %esi
801035b4:	5d                   	pop    %ebp
    kfree((char*)p);
801035b5:	e9 d6 ee ff ff       	jmp    80102490 <kfree>
801035ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801035c0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035c0:	f3 0f 1e fb          	endbr32 
801035c4:	55                   	push   %ebp
801035c5:	89 e5                	mov    %esp,%ebp
801035c7:	57                   	push   %edi
801035c8:	56                   	push   %esi
801035c9:	53                   	push   %ebx
801035ca:	83 ec 28             	sub    $0x28,%esp
801035cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801035d0:	53                   	push   %ebx
801035d1:	e8 aa 0f 00 00       	call   80104580 <acquire>
  for(i = 0; i < n; i++){
801035d6:	8b 45 10             	mov    0x10(%ebp),%eax
801035d9:	83 c4 10             	add    $0x10,%esp
801035dc:	85 c0                	test   %eax,%eax
801035de:	0f 8e bc 00 00 00    	jle    801036a0 <pipewrite+0xe0>
801035e4:	8b 45 0c             	mov    0xc(%ebp),%eax
801035e7:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801035ed:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801035f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801035f6:	03 45 10             	add    0x10(%ebp),%eax
801035f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035fc:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103602:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103608:	89 ca                	mov    %ecx,%edx
8010360a:	05 00 02 00 00       	add    $0x200,%eax
8010360f:	39 c1                	cmp    %eax,%ecx
80103611:	74 3b                	je     8010364e <pipewrite+0x8e>
80103613:	eb 63                	jmp    80103678 <pipewrite+0xb8>
80103615:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103618:	e8 63 03 00 00       	call   80103980 <myproc>
8010361d:	8b 48 24             	mov    0x24(%eax),%ecx
80103620:	85 c9                	test   %ecx,%ecx
80103622:	75 34                	jne    80103658 <pipewrite+0x98>
      wakeup(&p->nread);
80103624:	83 ec 0c             	sub    $0xc,%esp
80103627:	57                   	push   %edi
80103628:	e8 d3 0a 00 00       	call   80104100 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010362d:	58                   	pop    %eax
8010362e:	5a                   	pop    %edx
8010362f:	53                   	push   %ebx
80103630:	56                   	push   %esi
80103631:	e8 0a 09 00 00       	call   80103f40 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103636:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010363c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103642:	83 c4 10             	add    $0x10,%esp
80103645:	05 00 02 00 00       	add    $0x200,%eax
8010364a:	39 c2                	cmp    %eax,%edx
8010364c:	75 2a                	jne    80103678 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010364e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103654:	85 c0                	test   %eax,%eax
80103656:	75 c0                	jne    80103618 <pipewrite+0x58>
        release(&p->lock);
80103658:	83 ec 0c             	sub    $0xc,%esp
8010365b:	53                   	push   %ebx
8010365c:	e8 df 0f 00 00       	call   80104640 <release>
        return -1;
80103661:	83 c4 10             	add    $0x10,%esp
80103664:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103669:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010366c:	5b                   	pop    %ebx
8010366d:	5e                   	pop    %esi
8010366e:	5f                   	pop    %edi
8010366f:	5d                   	pop    %ebp
80103670:	c3                   	ret    
80103671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103678:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010367b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010367e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103684:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010368a:	0f b6 06             	movzbl (%esi),%eax
8010368d:	83 c6 01             	add    $0x1,%esi
80103690:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103693:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103697:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010369a:	0f 85 5c ff ff ff    	jne    801035fc <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801036a0:	83 ec 0c             	sub    $0xc,%esp
801036a3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036a9:	50                   	push   %eax
801036aa:	e8 51 0a 00 00       	call   80104100 <wakeup>
  release(&p->lock);
801036af:	89 1c 24             	mov    %ebx,(%esp)
801036b2:	e8 89 0f 00 00       	call   80104640 <release>
  return n;
801036b7:	8b 45 10             	mov    0x10(%ebp),%eax
801036ba:	83 c4 10             	add    $0x10,%esp
801036bd:	eb aa                	jmp    80103669 <pipewrite+0xa9>
801036bf:	90                   	nop

801036c0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036c0:	f3 0f 1e fb          	endbr32 
801036c4:	55                   	push   %ebp
801036c5:	89 e5                	mov    %esp,%ebp
801036c7:	57                   	push   %edi
801036c8:	56                   	push   %esi
801036c9:	53                   	push   %ebx
801036ca:	83 ec 18             	sub    $0x18,%esp
801036cd:	8b 75 08             	mov    0x8(%ebp),%esi
801036d0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036d3:	56                   	push   %esi
801036d4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801036da:	e8 a1 0e 00 00       	call   80104580 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036df:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801036e5:	83 c4 10             	add    $0x10,%esp
801036e8:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801036ee:	74 33                	je     80103723 <piperead+0x63>
801036f0:	eb 3b                	jmp    8010372d <piperead+0x6d>
801036f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
801036f8:	e8 83 02 00 00       	call   80103980 <myproc>
801036fd:	8b 48 24             	mov    0x24(%eax),%ecx
80103700:	85 c9                	test   %ecx,%ecx
80103702:	0f 85 88 00 00 00    	jne    80103790 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103708:	83 ec 08             	sub    $0x8,%esp
8010370b:	56                   	push   %esi
8010370c:	53                   	push   %ebx
8010370d:	e8 2e 08 00 00       	call   80103f40 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103712:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103718:	83 c4 10             	add    $0x10,%esp
8010371b:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103721:	75 0a                	jne    8010372d <piperead+0x6d>
80103723:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103729:	85 c0                	test   %eax,%eax
8010372b:	75 cb                	jne    801036f8 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010372d:	8b 55 10             	mov    0x10(%ebp),%edx
80103730:	31 db                	xor    %ebx,%ebx
80103732:	85 d2                	test   %edx,%edx
80103734:	7f 28                	jg     8010375e <piperead+0x9e>
80103736:	eb 34                	jmp    8010376c <piperead+0xac>
80103738:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010373f:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103740:	8d 48 01             	lea    0x1(%eax),%ecx
80103743:	25 ff 01 00 00       	and    $0x1ff,%eax
80103748:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010374e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103753:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103756:	83 c3 01             	add    $0x1,%ebx
80103759:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010375c:	74 0e                	je     8010376c <piperead+0xac>
    if(p->nread == p->nwrite)
8010375e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103764:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010376a:	75 d4                	jne    80103740 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010376c:	83 ec 0c             	sub    $0xc,%esp
8010376f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103775:	50                   	push   %eax
80103776:	e8 85 09 00 00       	call   80104100 <wakeup>
  release(&p->lock);
8010377b:	89 34 24             	mov    %esi,(%esp)
8010377e:	e8 bd 0e 00 00       	call   80104640 <release>
  return i;
80103783:	83 c4 10             	add    $0x10,%esp
}
80103786:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103789:	89 d8                	mov    %ebx,%eax
8010378b:	5b                   	pop    %ebx
8010378c:	5e                   	pop    %esi
8010378d:	5f                   	pop    %edi
8010378e:	5d                   	pop    %ebp
8010378f:	c3                   	ret    
      release(&p->lock);
80103790:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103793:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103798:	56                   	push   %esi
80103799:	e8 a2 0e 00 00       	call   80104640 <release>
      return -1;
8010379e:	83 c4 10             	add    $0x10,%esp
}
801037a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037a4:	89 d8                	mov    %ebx,%eax
801037a6:	5b                   	pop    %ebx
801037a7:	5e                   	pop    %esi
801037a8:	5f                   	pop    %edi
801037a9:	5d                   	pop    %ebp
801037aa:	c3                   	ret    
801037ab:	66 90                	xchg   %ax,%ax
801037ad:	66 90                	xchg   %ax,%ax
801037af:	90                   	nop

801037b0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801037b0:	55                   	push   %ebp
801037b1:	89 e5                	mov    %esp,%ebp
801037b3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037b4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
801037b9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801037bc:	68 20 2d 11 80       	push   $0x80112d20
801037c1:	e8 ba 0d 00 00       	call   80104580 <acquire>
801037c6:	83 c4 10             	add    $0x10,%esp
801037c9:	eb 10                	jmp    801037db <allocproc+0x2b>
801037cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037cf:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037d0:	83 eb 80             	sub    $0xffffff80,%ebx
801037d3:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
801037d9:	74 75                	je     80103850 <allocproc+0xa0>
    if(p->state == UNUSED)
801037db:	8b 43 0c             	mov    0xc(%ebx),%eax
801037de:	85 c0                	test   %eax,%eax
801037e0:	75 ee                	jne    801037d0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037e2:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
801037e7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801037ea:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801037f1:	89 43 10             	mov    %eax,0x10(%ebx)
801037f4:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801037f7:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
801037fc:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103802:	e8 39 0e 00 00       	call   80104640 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103807:	e8 44 ee ff ff       	call   80102650 <kalloc>
8010380c:	83 c4 10             	add    $0x10,%esp
8010380f:	89 43 08             	mov    %eax,0x8(%ebx)
80103812:	85 c0                	test   %eax,%eax
80103814:	74 53                	je     80103869 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103816:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010381c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010381f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103824:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103827:	c7 40 14 eb 58 10 80 	movl   $0x801058eb,0x14(%eax)
  p->context = (struct context*)sp;
8010382e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103831:	6a 14                	push   $0x14
80103833:	6a 00                	push   $0x0
80103835:	50                   	push   %eax
80103836:	e8 55 0e 00 00       	call   80104690 <memset>
  p->context->eip = (uint)forkret;
8010383b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010383e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103841:	c7 40 10 80 38 10 80 	movl   $0x80103880,0x10(%eax)
}
80103848:	89 d8                	mov    %ebx,%eax
8010384a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010384d:	c9                   	leave  
8010384e:	c3                   	ret    
8010384f:	90                   	nop
  release(&ptable.lock);
80103850:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103853:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103855:	68 20 2d 11 80       	push   $0x80112d20
8010385a:	e8 e1 0d 00 00       	call   80104640 <release>
}
8010385f:	89 d8                	mov    %ebx,%eax
  return 0;
80103861:	83 c4 10             	add    $0x10,%esp
}
80103864:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103867:	c9                   	leave  
80103868:	c3                   	ret    
    p->state = UNUSED;
80103869:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103870:	31 db                	xor    %ebx,%ebx
}
80103872:	89 d8                	mov    %ebx,%eax
80103874:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103877:	c9                   	leave  
80103878:	c3                   	ret    
80103879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103880 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103880:	f3 0f 1e fb          	endbr32 
80103884:	55                   	push   %ebp
80103885:	89 e5                	mov    %esp,%ebp
80103887:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
8010388a:	68 20 2d 11 80       	push   $0x80112d20
8010388f:	e8 ac 0d 00 00       	call   80104640 <release>

  if (first) {
80103894:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103899:	83 c4 10             	add    $0x10,%esp
8010389c:	85 c0                	test   %eax,%eax
8010389e:	75 08                	jne    801038a8 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038a0:	c9                   	leave  
801038a1:	c3                   	ret    
801038a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
801038a8:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801038af:	00 00 00 
    iinit(ROOTDEV);
801038b2:	83 ec 0c             	sub    $0xc,%esp
801038b5:	6a 01                	push   $0x1
801038b7:	e8 a4 dc ff ff       	call   80101560 <iinit>
    initlog(ROOTDEV);
801038bc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801038c3:	e8 e8 f3 ff ff       	call   80102cb0 <initlog>
}
801038c8:	83 c4 10             	add    $0x10,%esp
801038cb:	c9                   	leave  
801038cc:	c3                   	ret    
801038cd:	8d 76 00             	lea    0x0(%esi),%esi

801038d0 <pinit>:
{
801038d0:	f3 0f 1e fb          	endbr32 
801038d4:	55                   	push   %ebp
801038d5:	89 e5                	mov    %esp,%ebp
801038d7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801038da:	68 c0 76 10 80       	push   $0x801076c0
801038df:	68 20 2d 11 80       	push   $0x80112d20
801038e4:	e8 17 0b 00 00       	call   80104400 <initlock>
}
801038e9:	83 c4 10             	add    $0x10,%esp
801038ec:	c9                   	leave  
801038ed:	c3                   	ret    
801038ee:	66 90                	xchg   %ax,%ax

801038f0 <mycpu>:
{
801038f0:	f3 0f 1e fb          	endbr32 
801038f4:	55                   	push   %ebp
801038f5:	89 e5                	mov    %esp,%ebp
801038f7:	56                   	push   %esi
801038f8:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801038f9:	9c                   	pushf  
801038fa:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801038fb:	f6 c4 02             	test   $0x2,%ah
801038fe:	75 4a                	jne    8010394a <mycpu+0x5a>
  apicid = lapicid();
80103900:	e8 bb ef ff ff       	call   801028c0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103905:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
  apicid = lapicid();
8010390b:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
8010390d:	85 f6                	test   %esi,%esi
8010390f:	7e 2c                	jle    8010393d <mycpu+0x4d>
80103911:	31 d2                	xor    %edx,%edx
80103913:	eb 0a                	jmp    8010391f <mycpu+0x2f>
80103915:	8d 76 00             	lea    0x0(%esi),%esi
80103918:	83 c2 01             	add    $0x1,%edx
8010391b:	39 f2                	cmp    %esi,%edx
8010391d:	74 1e                	je     8010393d <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
8010391f:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103925:	0f b6 81 80 27 11 80 	movzbl -0x7feed880(%ecx),%eax
8010392c:	39 d8                	cmp    %ebx,%eax
8010392e:	75 e8                	jne    80103918 <mycpu+0x28>
}
80103930:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103933:	8d 81 80 27 11 80    	lea    -0x7feed880(%ecx),%eax
}
80103939:	5b                   	pop    %ebx
8010393a:	5e                   	pop    %esi
8010393b:	5d                   	pop    %ebp
8010393c:	c3                   	ret    
  panic("unknown apicid\n");
8010393d:	83 ec 0c             	sub    $0xc,%esp
80103940:	68 c7 76 10 80       	push   $0x801076c7
80103945:	e8 46 ca ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
8010394a:	83 ec 0c             	sub    $0xc,%esp
8010394d:	68 a4 77 10 80       	push   $0x801077a4
80103952:	e8 39 ca ff ff       	call   80100390 <panic>
80103957:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010395e:	66 90                	xchg   %ax,%ax

80103960 <cpuid>:
cpuid() {
80103960:	f3 0f 1e fb          	endbr32 
80103964:	55                   	push   %ebp
80103965:	89 e5                	mov    %esp,%ebp
80103967:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
8010396a:	e8 81 ff ff ff       	call   801038f0 <mycpu>
}
8010396f:	c9                   	leave  
  return mycpu()-cpus;
80103970:	2d 80 27 11 80       	sub    $0x80112780,%eax
80103975:	c1 f8 04             	sar    $0x4,%eax
80103978:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010397e:	c3                   	ret    
8010397f:	90                   	nop

80103980 <myproc>:
myproc(void) {
80103980:	f3 0f 1e fb          	endbr32 
80103984:	55                   	push   %ebp
80103985:	89 e5                	mov    %esp,%ebp
80103987:	53                   	push   %ebx
80103988:	83 ec 04             	sub    $0x4,%esp
  pushcli();
8010398b:	e8 f0 0a 00 00       	call   80104480 <pushcli>
  c = mycpu();
80103990:	e8 5b ff ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103995:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010399b:	e8 30 0b 00 00       	call   801044d0 <popcli>
}
801039a0:	83 c4 04             	add    $0x4,%esp
801039a3:	89 d8                	mov    %ebx,%eax
801039a5:	5b                   	pop    %ebx
801039a6:	5d                   	pop    %ebp
801039a7:	c3                   	ret    
801039a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039af:	90                   	nop

801039b0 <userinit>:
{
801039b0:	f3 0f 1e fb          	endbr32 
801039b4:	55                   	push   %ebp
801039b5:	89 e5                	mov    %esp,%ebp
801039b7:	53                   	push   %ebx
801039b8:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801039bb:	e8 f0 fd ff ff       	call   801037b0 <allocproc>
801039c0:	89 c3                	mov    %eax,%ebx
  initproc = p;
801039c2:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
801039c7:	e8 14 35 00 00       	call   80106ee0 <setupkvm>
801039cc:	89 43 04             	mov    %eax,0x4(%ebx)
801039cf:	85 c0                	test   %eax,%eax
801039d1:	0f 84 bd 00 00 00    	je     80103a94 <userinit+0xe4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801039d7:	83 ec 04             	sub    $0x4,%esp
801039da:	68 2c 00 00 00       	push   $0x2c
801039df:	68 60 a4 10 80       	push   $0x8010a460
801039e4:	50                   	push   %eax
801039e5:	e8 c6 31 00 00       	call   80106bb0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801039ea:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801039ed:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801039f3:	6a 4c                	push   $0x4c
801039f5:	6a 00                	push   $0x0
801039f7:	ff 73 18             	pushl  0x18(%ebx)
801039fa:	e8 91 0c 00 00       	call   80104690 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039ff:	8b 43 18             	mov    0x18(%ebx),%eax
80103a02:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a07:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a0a:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a0f:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a13:	8b 43 18             	mov    0x18(%ebx),%eax
80103a16:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a1a:	8b 43 18             	mov    0x18(%ebx),%eax
80103a1d:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a21:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a25:	8b 43 18             	mov    0x18(%ebx),%eax
80103a28:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a2c:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a30:	8b 43 18             	mov    0x18(%ebx),%eax
80103a33:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a3a:	8b 43 18             	mov    0x18(%ebx),%eax
80103a3d:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a44:	8b 43 18             	mov    0x18(%ebx),%eax
80103a47:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a4e:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a51:	6a 10                	push   $0x10
80103a53:	68 f0 76 10 80       	push   $0x801076f0
80103a58:	50                   	push   %eax
80103a59:	e8 f2 0d 00 00       	call   80104850 <safestrcpy>
  p->cwd = namei("/");
80103a5e:	c7 04 24 f9 76 10 80 	movl   $0x801076f9,(%esp)
80103a65:	e8 e6 e5 ff ff       	call   80102050 <namei>
80103a6a:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103a6d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a74:	e8 07 0b 00 00       	call   80104580 <acquire>
  p->state = RUNNABLE;
80103a79:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103a80:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a87:	e8 b4 0b 00 00       	call   80104640 <release>
}
80103a8c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a8f:	83 c4 10             	add    $0x10,%esp
80103a92:	c9                   	leave  
80103a93:	c3                   	ret    
    panic("userinit: out of memory?");
80103a94:	83 ec 0c             	sub    $0xc,%esp
80103a97:	68 d7 76 10 80       	push   $0x801076d7
80103a9c:	e8 ef c8 ff ff       	call   80100390 <panic>
80103aa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103aa8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103aaf:	90                   	nop

80103ab0 <growproc>:
{
80103ab0:	f3 0f 1e fb          	endbr32 
80103ab4:	55                   	push   %ebp
80103ab5:	89 e5                	mov    %esp,%ebp
80103ab7:	56                   	push   %esi
80103ab8:	53                   	push   %ebx
80103ab9:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103abc:	e8 bf 09 00 00       	call   80104480 <pushcli>
  c = mycpu();
80103ac1:	e8 2a fe ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103ac6:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103acc:	e8 ff 09 00 00       	call   801044d0 <popcli>
  sz = curproc->sz;
80103ad1:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103ad3:	85 f6                	test   %esi,%esi
80103ad5:	7f 19                	jg     80103af0 <growproc+0x40>
  } else if(n < 0){
80103ad7:	75 37                	jne    80103b10 <growproc+0x60>
  switchuvm(curproc);
80103ad9:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103adc:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103ade:	53                   	push   %ebx
80103adf:	e8 bc 2f 00 00       	call   80106aa0 <switchuvm>
  return 0;
80103ae4:	83 c4 10             	add    $0x10,%esp
80103ae7:	31 c0                	xor    %eax,%eax
}
80103ae9:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103aec:	5b                   	pop    %ebx
80103aed:	5e                   	pop    %esi
80103aee:	5d                   	pop    %ebp
80103aef:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103af0:	83 ec 04             	sub    $0x4,%esp
80103af3:	01 c6                	add    %eax,%esi
80103af5:	56                   	push   %esi
80103af6:	50                   	push   %eax
80103af7:	ff 73 04             	pushl  0x4(%ebx)
80103afa:	e8 01 32 00 00       	call   80106d00 <allocuvm>
80103aff:	83 c4 10             	add    $0x10,%esp
80103b02:	85 c0                	test   %eax,%eax
80103b04:	75 d3                	jne    80103ad9 <growproc+0x29>
      return -1;
80103b06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b0b:	eb dc                	jmp    80103ae9 <growproc+0x39>
80103b0d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b10:	83 ec 04             	sub    $0x4,%esp
80103b13:	01 c6                	add    %eax,%esi
80103b15:	56                   	push   %esi
80103b16:	50                   	push   %eax
80103b17:	ff 73 04             	pushl  0x4(%ebx)
80103b1a:	e8 11 33 00 00       	call   80106e30 <deallocuvm>
80103b1f:	83 c4 10             	add    $0x10,%esp
80103b22:	85 c0                	test   %eax,%eax
80103b24:	75 b3                	jne    80103ad9 <growproc+0x29>
80103b26:	eb de                	jmp    80103b06 <growproc+0x56>
80103b28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b2f:	90                   	nop

80103b30 <fork>:
{
80103b30:	f3 0f 1e fb          	endbr32 
80103b34:	55                   	push   %ebp
80103b35:	89 e5                	mov    %esp,%ebp
80103b37:	57                   	push   %edi
80103b38:	56                   	push   %esi
80103b39:	53                   	push   %ebx
80103b3a:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103b3d:	e8 3e 09 00 00       	call   80104480 <pushcli>
  c = mycpu();
80103b42:	e8 a9 fd ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103b47:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b4d:	e8 7e 09 00 00       	call   801044d0 <popcli>
  if((np = allocproc()) == 0){
80103b52:	e8 59 fc ff ff       	call   801037b0 <allocproc>
80103b57:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b5a:	85 c0                	test   %eax,%eax
80103b5c:	0f 84 bb 00 00 00    	je     80103c1d <fork+0xed>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b62:	83 ec 08             	sub    $0x8,%esp
80103b65:	ff 33                	pushl  (%ebx)
80103b67:	89 c7                	mov    %eax,%edi
80103b69:	ff 73 04             	pushl  0x4(%ebx)
80103b6c:	e8 3f 34 00 00       	call   80106fb0 <copyuvm>
80103b71:	83 c4 10             	add    $0x10,%esp
80103b74:	89 47 04             	mov    %eax,0x4(%edi)
80103b77:	85 c0                	test   %eax,%eax
80103b79:	0f 84 a5 00 00 00    	je     80103c24 <fork+0xf4>
  np->sz = curproc->sz;
80103b7f:	8b 03                	mov    (%ebx),%eax
80103b81:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103b84:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103b86:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103b89:	89 c8                	mov    %ecx,%eax
80103b8b:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103b8e:	b9 13 00 00 00       	mov    $0x13,%ecx
80103b93:	8b 73 18             	mov    0x18(%ebx),%esi
80103b96:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103b98:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103b9a:	8b 40 18             	mov    0x18(%eax),%eax
80103b9d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103ba4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80103ba8:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103bac:	85 c0                	test   %eax,%eax
80103bae:	74 13                	je     80103bc3 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103bb0:	83 ec 0c             	sub    $0xc,%esp
80103bb3:	50                   	push   %eax
80103bb4:	e8 d7 d2 ff ff       	call   80100e90 <filedup>
80103bb9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103bbc:	83 c4 10             	add    $0x10,%esp
80103bbf:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103bc3:	83 c6 01             	add    $0x1,%esi
80103bc6:	83 fe 10             	cmp    $0x10,%esi
80103bc9:	75 dd                	jne    80103ba8 <fork+0x78>
  np->cwd = idup(curproc->cwd);
80103bcb:	83 ec 0c             	sub    $0xc,%esp
80103bce:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bd1:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103bd4:	e8 77 db ff ff       	call   80101750 <idup>
80103bd9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bdc:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103bdf:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103be2:	8d 47 6c             	lea    0x6c(%edi),%eax
80103be5:	6a 10                	push   $0x10
80103be7:	53                   	push   %ebx
80103be8:	50                   	push   %eax
80103be9:	e8 62 0c 00 00       	call   80104850 <safestrcpy>
  pid = np->pid;
80103bee:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103bf1:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103bf8:	e8 83 09 00 00       	call   80104580 <acquire>
  np->state = RUNNABLE;
80103bfd:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103c04:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c0b:	e8 30 0a 00 00       	call   80104640 <release>
  return pid;
80103c10:	83 c4 10             	add    $0x10,%esp
}
80103c13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c16:	89 d8                	mov    %ebx,%eax
80103c18:	5b                   	pop    %ebx
80103c19:	5e                   	pop    %esi
80103c1a:	5f                   	pop    %edi
80103c1b:	5d                   	pop    %ebp
80103c1c:	c3                   	ret    
    return -1;
80103c1d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c22:	eb ef                	jmp    80103c13 <fork+0xe3>
    kfree(np->kstack);
80103c24:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103c27:	83 ec 0c             	sub    $0xc,%esp
80103c2a:	ff 73 08             	pushl  0x8(%ebx)
80103c2d:	e8 5e e8 ff ff       	call   80102490 <kfree>
    np->kstack = 0;
80103c32:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103c39:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103c3c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103c43:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c48:	eb c9                	jmp    80103c13 <fork+0xe3>
80103c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103c50 <scheduler>:
{
80103c50:	f3 0f 1e fb          	endbr32 
80103c54:	55                   	push   %ebp
80103c55:	89 e5                	mov    %esp,%ebp
80103c57:	57                   	push   %edi
80103c58:	56                   	push   %esi
80103c59:	53                   	push   %ebx
80103c5a:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103c5d:	e8 8e fc ff ff       	call   801038f0 <mycpu>
  c->proc = 0;
80103c62:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103c69:	00 00 00 
  struct cpu *c = mycpu();
80103c6c:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103c6e:	8d 78 04             	lea    0x4(%eax),%edi
80103c71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80103c78:	fb                   	sti    
    acquire(&ptable.lock);
80103c79:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c7c:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
80103c81:	68 20 2d 11 80       	push   $0x80112d20
80103c86:	e8 f5 08 00 00       	call   80104580 <acquire>
80103c8b:	83 c4 10             	add    $0x10,%esp
80103c8e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80103c90:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103c94:	75 33                	jne    80103cc9 <scheduler+0x79>
      switchuvm(p);
80103c96:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103c99:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103c9f:	53                   	push   %ebx
80103ca0:	e8 fb 2d 00 00       	call   80106aa0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103ca5:	58                   	pop    %eax
80103ca6:	5a                   	pop    %edx
80103ca7:	ff 73 1c             	pushl  0x1c(%ebx)
80103caa:	57                   	push   %edi
      p->state = RUNNING;
80103cab:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103cb2:	e8 fc 0b 00 00       	call   801048b3 <swtch>
      switchkvm();
80103cb7:	e8 c4 2d 00 00       	call   80106a80 <switchkvm>
      c->proc = 0;
80103cbc:	83 c4 10             	add    $0x10,%esp
80103cbf:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103cc6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cc9:	83 eb 80             	sub    $0xffffff80,%ebx
80103ccc:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103cd2:	75 bc                	jne    80103c90 <scheduler+0x40>
    release(&ptable.lock);
80103cd4:	83 ec 0c             	sub    $0xc,%esp
80103cd7:	68 20 2d 11 80       	push   $0x80112d20
80103cdc:	e8 5f 09 00 00       	call   80104640 <release>
    sti();
80103ce1:	83 c4 10             	add    $0x10,%esp
80103ce4:	eb 92                	jmp    80103c78 <scheduler+0x28>
80103ce6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ced:	8d 76 00             	lea    0x0(%esi),%esi

80103cf0 <sched>:
{
80103cf0:	f3 0f 1e fb          	endbr32 
80103cf4:	55                   	push   %ebp
80103cf5:	89 e5                	mov    %esp,%ebp
80103cf7:	56                   	push   %esi
80103cf8:	53                   	push   %ebx
  pushcli();
80103cf9:	e8 82 07 00 00       	call   80104480 <pushcli>
  c = mycpu();
80103cfe:	e8 ed fb ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103d03:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d09:	e8 c2 07 00 00       	call   801044d0 <popcli>
  if(!holding(&ptable.lock))
80103d0e:	83 ec 0c             	sub    $0xc,%esp
80103d11:	68 20 2d 11 80       	push   $0x80112d20
80103d16:	e8 15 08 00 00       	call   80104530 <holding>
80103d1b:	83 c4 10             	add    $0x10,%esp
80103d1e:	85 c0                	test   %eax,%eax
80103d20:	74 4f                	je     80103d71 <sched+0x81>
  if(mycpu()->ncli != 1)
80103d22:	e8 c9 fb ff ff       	call   801038f0 <mycpu>
80103d27:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103d2e:	75 68                	jne    80103d98 <sched+0xa8>
  if(p->state == RUNNING)
80103d30:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103d34:	74 55                	je     80103d8b <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d36:	9c                   	pushf  
80103d37:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103d38:	f6 c4 02             	test   $0x2,%ah
80103d3b:	75 41                	jne    80103d7e <sched+0x8e>
  intena = mycpu()->intena;
80103d3d:	e8 ae fb ff ff       	call   801038f0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103d42:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103d45:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103d4b:	e8 a0 fb ff ff       	call   801038f0 <mycpu>
80103d50:	83 ec 08             	sub    $0x8,%esp
80103d53:	ff 70 04             	pushl  0x4(%eax)
80103d56:	53                   	push   %ebx
80103d57:	e8 57 0b 00 00       	call   801048b3 <swtch>
  mycpu()->intena = intena;
80103d5c:	e8 8f fb ff ff       	call   801038f0 <mycpu>
}
80103d61:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103d64:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103d6a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d6d:	5b                   	pop    %ebx
80103d6e:	5e                   	pop    %esi
80103d6f:	5d                   	pop    %ebp
80103d70:	c3                   	ret    
    panic("sched ptable.lock");
80103d71:	83 ec 0c             	sub    $0xc,%esp
80103d74:	68 fb 76 10 80       	push   $0x801076fb
80103d79:	e8 12 c6 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103d7e:	83 ec 0c             	sub    $0xc,%esp
80103d81:	68 27 77 10 80       	push   $0x80107727
80103d86:	e8 05 c6 ff ff       	call   80100390 <panic>
    panic("sched running");
80103d8b:	83 ec 0c             	sub    $0xc,%esp
80103d8e:	68 19 77 10 80       	push   $0x80107719
80103d93:	e8 f8 c5 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103d98:	83 ec 0c             	sub    $0xc,%esp
80103d9b:	68 0d 77 10 80       	push   $0x8010770d
80103da0:	e8 eb c5 ff ff       	call   80100390 <panic>
80103da5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103db0 <exit>:
{
80103db0:	f3 0f 1e fb          	endbr32 
80103db4:	55                   	push   %ebp
80103db5:	89 e5                	mov    %esp,%ebp
80103db7:	57                   	push   %edi
80103db8:	56                   	push   %esi
80103db9:	53                   	push   %ebx
80103dba:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103dbd:	e8 be 06 00 00       	call   80104480 <pushcli>
  c = mycpu();
80103dc2:	e8 29 fb ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103dc7:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103dcd:	e8 fe 06 00 00       	call   801044d0 <popcli>
  if(curproc == initproc)
80103dd2:	8d 73 28             	lea    0x28(%ebx),%esi
80103dd5:	8d 7b 68             	lea    0x68(%ebx),%edi
80103dd8:	39 1d b8 a5 10 80    	cmp    %ebx,0x8010a5b8
80103dde:	0f 84 f3 00 00 00    	je     80103ed7 <exit+0x127>
80103de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
80103de8:	8b 06                	mov    (%esi),%eax
80103dea:	85 c0                	test   %eax,%eax
80103dec:	74 12                	je     80103e00 <exit+0x50>
      fileclose(curproc->ofile[fd]);
80103dee:	83 ec 0c             	sub    $0xc,%esp
80103df1:	50                   	push   %eax
80103df2:	e8 e9 d0 ff ff       	call   80100ee0 <fileclose>
      curproc->ofile[fd] = 0;
80103df7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103dfd:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103e00:	83 c6 04             	add    $0x4,%esi
80103e03:	39 f7                	cmp    %esi,%edi
80103e05:	75 e1                	jne    80103de8 <exit+0x38>
  begin_op();
80103e07:	e8 44 ef ff ff       	call   80102d50 <begin_op>
  iput(curproc->cwd);
80103e0c:	83 ec 0c             	sub    $0xc,%esp
80103e0f:	ff 73 68             	pushl  0x68(%ebx)
80103e12:	e8 99 da ff ff       	call   801018b0 <iput>
  end_op();
80103e17:	e8 a4 ef ff ff       	call   80102dc0 <end_op>
  curproc->cwd = 0;
80103e1c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103e23:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e2a:	e8 51 07 00 00       	call   80104580 <acquire>
  curproc->exit_status = status;
80103e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  wakeup1(curproc->parent);
80103e32:	8b 53 14             	mov    0x14(%ebx),%edx
80103e35:	83 c4 10             	add    $0x10,%esp
  curproc->exit_status = status;
80103e38:	89 43 7c             	mov    %eax,0x7c(%ebx)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e3b:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103e40:	eb 10                	jmp    80103e52 <exit+0xa2>
80103e42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103e48:	83 e8 80             	sub    $0xffffff80,%eax
80103e4b:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103e50:	74 1c                	je     80103e6e <exit+0xbe>
    if(p->state == SLEEPING && p->chan == chan)
80103e52:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e56:	75 f0                	jne    80103e48 <exit+0x98>
80103e58:	3b 50 20             	cmp    0x20(%eax),%edx
80103e5b:	75 eb                	jne    80103e48 <exit+0x98>
      p->state = RUNNABLE;
80103e5d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e64:	83 e8 80             	sub    $0xffffff80,%eax
80103e67:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103e6c:	75 e4                	jne    80103e52 <exit+0xa2>
      p->parent = initproc;
80103e6e:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e74:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103e79:	eb 10                	jmp    80103e8b <exit+0xdb>
80103e7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e7f:	90                   	nop
80103e80:	83 ea 80             	sub    $0xffffff80,%edx
80103e83:	81 fa 54 4d 11 80    	cmp    $0x80114d54,%edx
80103e89:	74 33                	je     80103ebe <exit+0x10e>
    if(p->parent == curproc){
80103e8b:	39 5a 14             	cmp    %ebx,0x14(%edx)
80103e8e:	75 f0                	jne    80103e80 <exit+0xd0>
      if(p->state == ZOMBIE)
80103e90:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103e94:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103e97:	75 e7                	jne    80103e80 <exit+0xd0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e99:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103e9e:	eb 0a                	jmp    80103eaa <exit+0xfa>
80103ea0:	83 e8 80             	sub    $0xffffff80,%eax
80103ea3:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103ea8:	74 d6                	je     80103e80 <exit+0xd0>
    if(p->state == SLEEPING && p->chan == chan)
80103eaa:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103eae:	75 f0                	jne    80103ea0 <exit+0xf0>
80103eb0:	3b 48 20             	cmp    0x20(%eax),%ecx
80103eb3:	75 eb                	jne    80103ea0 <exit+0xf0>
      p->state = RUNNABLE;
80103eb5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103ebc:	eb e2                	jmp    80103ea0 <exit+0xf0>
  curproc->state = ZOMBIE;
80103ebe:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103ec5:	e8 26 fe ff ff       	call   80103cf0 <sched>
  panic("zombie exit");
80103eca:	83 ec 0c             	sub    $0xc,%esp
80103ecd:	68 48 77 10 80       	push   $0x80107748
80103ed2:	e8 b9 c4 ff ff       	call   80100390 <panic>
    panic("init exiting");
80103ed7:	83 ec 0c             	sub    $0xc,%esp
80103eda:	68 3b 77 10 80       	push   $0x8010773b
80103edf:	e8 ac c4 ff ff       	call   80100390 <panic>
80103ee4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103eeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103eef:	90                   	nop

80103ef0 <yield>:
{
80103ef0:	f3 0f 1e fb          	endbr32 
80103ef4:	55                   	push   %ebp
80103ef5:	89 e5                	mov    %esp,%ebp
80103ef7:	53                   	push   %ebx
80103ef8:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103efb:	68 20 2d 11 80       	push   $0x80112d20
80103f00:	e8 7b 06 00 00       	call   80104580 <acquire>
  pushcli();
80103f05:	e8 76 05 00 00       	call   80104480 <pushcli>
  c = mycpu();
80103f0a:	e8 e1 f9 ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103f0f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f15:	e8 b6 05 00 00       	call   801044d0 <popcli>
  myproc()->state = RUNNABLE;
80103f1a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103f21:	e8 ca fd ff ff       	call   80103cf0 <sched>
  release(&ptable.lock);
80103f26:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f2d:	e8 0e 07 00 00       	call   80104640 <release>
}
80103f32:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f35:	83 c4 10             	add    $0x10,%esp
80103f38:	c9                   	leave  
80103f39:	c3                   	ret    
80103f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103f40 <sleep>:
{
80103f40:	f3 0f 1e fb          	endbr32 
80103f44:	55                   	push   %ebp
80103f45:	89 e5                	mov    %esp,%ebp
80103f47:	57                   	push   %edi
80103f48:	56                   	push   %esi
80103f49:	53                   	push   %ebx
80103f4a:	83 ec 0c             	sub    $0xc,%esp
80103f4d:	8b 7d 08             	mov    0x8(%ebp),%edi
80103f50:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103f53:	e8 28 05 00 00       	call   80104480 <pushcli>
  c = mycpu();
80103f58:	e8 93 f9 ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103f5d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f63:	e8 68 05 00 00       	call   801044d0 <popcli>
  if(p == 0)
80103f68:	85 db                	test   %ebx,%ebx
80103f6a:	0f 84 83 00 00 00    	je     80103ff3 <sleep+0xb3>
  if(lk == 0)
80103f70:	85 f6                	test   %esi,%esi
80103f72:	74 72                	je     80103fe6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103f74:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103f7a:	74 4c                	je     80103fc8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103f7c:	83 ec 0c             	sub    $0xc,%esp
80103f7f:	68 20 2d 11 80       	push   $0x80112d20
80103f84:	e8 f7 05 00 00       	call   80104580 <acquire>
    release(lk);
80103f89:	89 34 24             	mov    %esi,(%esp)
80103f8c:	e8 af 06 00 00       	call   80104640 <release>
  p->chan = chan;
80103f91:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103f94:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103f9b:	e8 50 fd ff ff       	call   80103cf0 <sched>
  p->chan = 0;
80103fa0:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103fa7:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103fae:	e8 8d 06 00 00       	call   80104640 <release>
    acquire(lk);
80103fb3:	89 75 08             	mov    %esi,0x8(%ebp)
80103fb6:	83 c4 10             	add    $0x10,%esp
}
80103fb9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103fbc:	5b                   	pop    %ebx
80103fbd:	5e                   	pop    %esi
80103fbe:	5f                   	pop    %edi
80103fbf:	5d                   	pop    %ebp
    acquire(lk);
80103fc0:	e9 bb 05 00 00       	jmp    80104580 <acquire>
80103fc5:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80103fc8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103fcb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103fd2:	e8 19 fd ff ff       	call   80103cf0 <sched>
  p->chan = 0;
80103fd7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103fde:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103fe1:	5b                   	pop    %ebx
80103fe2:	5e                   	pop    %esi
80103fe3:	5f                   	pop    %edi
80103fe4:	5d                   	pop    %ebp
80103fe5:	c3                   	ret    
    panic("sleep without lk");
80103fe6:	83 ec 0c             	sub    $0xc,%esp
80103fe9:	68 5a 77 10 80       	push   $0x8010775a
80103fee:	e8 9d c3 ff ff       	call   80100390 <panic>
    panic("sleep");
80103ff3:	83 ec 0c             	sub    $0xc,%esp
80103ff6:	68 54 77 10 80       	push   $0x80107754
80103ffb:	e8 90 c3 ff ff       	call   80100390 <panic>

80104000 <wait>:
{
80104000:	f3 0f 1e fb          	endbr32 
80104004:	55                   	push   %ebp
80104005:	89 e5                	mov    %esp,%ebp
80104007:	57                   	push   %edi
80104008:	56                   	push   %esi
80104009:	53                   	push   %ebx
8010400a:	83 ec 0c             	sub    $0xc,%esp
8010400d:	8b 7d 08             	mov    0x8(%ebp),%edi
  pushcli();
80104010:	e8 6b 04 00 00       	call   80104480 <pushcli>
  c = mycpu();
80104015:	e8 d6 f8 ff ff       	call   801038f0 <mycpu>
  p = c->proc;
8010401a:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104020:	e8 ab 04 00 00       	call   801044d0 <popcli>
  acquire(&ptable.lock);
80104025:	83 ec 0c             	sub    $0xc,%esp
80104028:	68 20 2d 11 80       	push   $0x80112d20
8010402d:	e8 4e 05 00 00       	call   80104580 <acquire>
80104032:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80104035:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104037:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
8010403c:	eb 0d                	jmp    8010404b <wait+0x4b>
8010403e:	66 90                	xchg   %ax,%ax
80104040:	83 eb 80             	sub    $0xffffff80,%ebx
80104043:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80104049:	74 1b                	je     80104066 <wait+0x66>
      if(p->parent != curproc)
8010404b:	39 73 14             	cmp    %esi,0x14(%ebx)
8010404e:	75 f0                	jne    80104040 <wait+0x40>
      if(p->state == ZOMBIE){
80104050:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104054:	74 32                	je     80104088 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104056:	83 eb 80             	sub    $0xffffff80,%ebx
      havekids = 1;
80104059:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010405e:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80104064:	75 e5                	jne    8010404b <wait+0x4b>
    if(!havekids || curproc->killed){
80104066:	85 c0                	test   %eax,%eax
80104068:	74 7e                	je     801040e8 <wait+0xe8>
8010406a:	8b 46 24             	mov    0x24(%esi),%eax
8010406d:	85 c0                	test   %eax,%eax
8010406f:	75 77                	jne    801040e8 <wait+0xe8>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104071:	83 ec 08             	sub    $0x8,%esp
80104074:	68 20 2d 11 80       	push   $0x80112d20
80104079:	56                   	push   %esi
8010407a:	e8 c1 fe ff ff       	call   80103f40 <sleep>
    havekids = 0;
8010407f:	83 c4 10             	add    $0x10,%esp
80104082:	eb b1                	jmp    80104035 <wait+0x35>
80104084:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        pid = p->pid;
80104088:	8b 73 10             	mov    0x10(%ebx),%esi
        if (status != null){
8010408b:	85 ff                	test   %edi,%edi
8010408d:	74 05                	je     80104094 <wait+0x94>
          *status = p->exit_status; // returning child's exit status
8010408f:	8b 43 7c             	mov    0x7c(%ebx),%eax
80104092:	89 07                	mov    %eax,(%edi)
        kfree(p->kstack);
80104094:	83 ec 0c             	sub    $0xc,%esp
80104097:	ff 73 08             	pushl  0x8(%ebx)
8010409a:	e8 f1 e3 ff ff       	call   80102490 <kfree>
        freevm(p->pgdir);
8010409f:	5a                   	pop    %edx
801040a0:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
801040a3:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801040aa:	e8 b1 2d 00 00       	call   80106e60 <freevm>
        release(&ptable.lock);
801040af:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
801040b6:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801040bd:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801040c4:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801040c8:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801040cf:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801040d6:	e8 65 05 00 00       	call   80104640 <release>
        return pid;
801040db:	83 c4 10             	add    $0x10,%esp
}
801040de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040e1:	89 f0                	mov    %esi,%eax
801040e3:	5b                   	pop    %ebx
801040e4:	5e                   	pop    %esi
801040e5:	5f                   	pop    %edi
801040e6:	5d                   	pop    %ebp
801040e7:	c3                   	ret    
      release(&ptable.lock);
801040e8:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801040eb:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801040f0:	68 20 2d 11 80       	push   $0x80112d20
801040f5:	e8 46 05 00 00       	call   80104640 <release>
      return -1;
801040fa:	83 c4 10             	add    $0x10,%esp
801040fd:	eb df                	jmp    801040de <wait+0xde>
801040ff:	90                   	nop

80104100 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104100:	f3 0f 1e fb          	endbr32 
80104104:	55                   	push   %ebp
80104105:	89 e5                	mov    %esp,%ebp
80104107:	53                   	push   %ebx
80104108:	83 ec 10             	sub    $0x10,%esp
8010410b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010410e:	68 20 2d 11 80       	push   $0x80112d20
80104113:	e8 68 04 00 00       	call   80104580 <acquire>
80104118:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010411b:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80104120:	eb 10                	jmp    80104132 <wakeup+0x32>
80104122:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104128:	83 e8 80             	sub    $0xffffff80,%eax
8010412b:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80104130:	74 1c                	je     8010414e <wakeup+0x4e>
    if(p->state == SLEEPING && p->chan == chan)
80104132:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104136:	75 f0                	jne    80104128 <wakeup+0x28>
80104138:	3b 58 20             	cmp    0x20(%eax),%ebx
8010413b:	75 eb                	jne    80104128 <wakeup+0x28>
      p->state = RUNNABLE;
8010413d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104144:	83 e8 80             	sub    $0xffffff80,%eax
80104147:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
8010414c:	75 e4                	jne    80104132 <wakeup+0x32>
  wakeup1(chan);
  release(&ptable.lock);
8010414e:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80104155:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104158:	c9                   	leave  
  release(&ptable.lock);
80104159:	e9 e2 04 00 00       	jmp    80104640 <release>
8010415e:	66 90                	xchg   %ax,%ax

80104160 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104160:	f3 0f 1e fb          	endbr32 
80104164:	55                   	push   %ebp
80104165:	89 e5                	mov    %esp,%ebp
80104167:	53                   	push   %ebx
80104168:	83 ec 10             	sub    $0x10,%esp
8010416b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010416e:	68 20 2d 11 80       	push   $0x80112d20
80104173:	e8 08 04 00 00       	call   80104580 <acquire>
80104178:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010417b:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80104180:	eb 10                	jmp    80104192 <kill+0x32>
80104182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104188:	83 e8 80             	sub    $0xffffff80,%eax
8010418b:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80104190:	74 36                	je     801041c8 <kill+0x68>
    if(p->pid == pid){
80104192:	39 58 10             	cmp    %ebx,0x10(%eax)
80104195:	75 f1                	jne    80104188 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104197:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
8010419b:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801041a2:	75 07                	jne    801041ab <kill+0x4b>
        p->state = RUNNABLE;
801041a4:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801041ab:	83 ec 0c             	sub    $0xc,%esp
801041ae:	68 20 2d 11 80       	push   $0x80112d20
801041b3:	e8 88 04 00 00       	call   80104640 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801041b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801041bb:	83 c4 10             	add    $0x10,%esp
801041be:	31 c0                	xor    %eax,%eax
}
801041c0:	c9                   	leave  
801041c1:	c3                   	ret    
801041c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801041c8:	83 ec 0c             	sub    $0xc,%esp
801041cb:	68 20 2d 11 80       	push   $0x80112d20
801041d0:	e8 6b 04 00 00       	call   80104640 <release>
}
801041d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801041d8:	83 c4 10             	add    $0x10,%esp
801041db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801041e0:	c9                   	leave  
801041e1:	c3                   	ret    
801041e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801041f0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801041f0:	f3 0f 1e fb          	endbr32 
801041f4:	55                   	push   %ebp
801041f5:	89 e5                	mov    %esp,%ebp
801041f7:	57                   	push   %edi
801041f8:	56                   	push   %esi
801041f9:	8d 75 e8             	lea    -0x18(%ebp),%esi
801041fc:	53                   	push   %ebx
801041fd:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
80104202:	83 ec 3c             	sub    $0x3c,%esp
80104205:	eb 28                	jmp    8010422f <procdump+0x3f>
80104207:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010420e:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104210:	83 ec 0c             	sub    $0xc,%esp
80104213:	68 db 7a 10 80       	push   $0x80107adb
80104218:	e8 93 c4 ff ff       	call   801006b0 <cprintf>
8010421d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104220:	83 eb 80             	sub    $0xffffff80,%ebx
80104223:	81 fb c0 4d 11 80    	cmp    $0x80114dc0,%ebx
80104229:	0f 84 81 00 00 00    	je     801042b0 <procdump+0xc0>
    if(p->state == UNUSED)
8010422f:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104232:	85 c0                	test   %eax,%eax
80104234:	74 ea                	je     80104220 <procdump+0x30>
      state = "???";
80104236:	ba 6b 77 10 80       	mov    $0x8010776b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010423b:	83 f8 05             	cmp    $0x5,%eax
8010423e:	77 11                	ja     80104251 <procdump+0x61>
80104240:	8b 14 85 cc 77 10 80 	mov    -0x7fef8834(,%eax,4),%edx
      state = "???";
80104247:	b8 6b 77 10 80       	mov    $0x8010776b,%eax
8010424c:	85 d2                	test   %edx,%edx
8010424e:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104251:	53                   	push   %ebx
80104252:	52                   	push   %edx
80104253:	ff 73 a4             	pushl  -0x5c(%ebx)
80104256:	68 6f 77 10 80       	push   $0x8010776f
8010425b:	e8 50 c4 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
80104260:	83 c4 10             	add    $0x10,%esp
80104263:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104267:	75 a7                	jne    80104210 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104269:	83 ec 08             	sub    $0x8,%esp
8010426c:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010426f:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104272:	50                   	push   %eax
80104273:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104276:	8b 40 0c             	mov    0xc(%eax),%eax
80104279:	83 c0 08             	add    $0x8,%eax
8010427c:	50                   	push   %eax
8010427d:	e8 9e 01 00 00       	call   80104420 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104282:	83 c4 10             	add    $0x10,%esp
80104285:	8d 76 00             	lea    0x0(%esi),%esi
80104288:	8b 17                	mov    (%edi),%edx
8010428a:	85 d2                	test   %edx,%edx
8010428c:	74 82                	je     80104210 <procdump+0x20>
        cprintf(" %p", pc[i]);
8010428e:	83 ec 08             	sub    $0x8,%esp
80104291:	83 c7 04             	add    $0x4,%edi
80104294:	52                   	push   %edx
80104295:	68 c1 71 10 80       	push   $0x801071c1
8010429a:	e8 11 c4 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
8010429f:	83 c4 10             	add    $0x10,%esp
801042a2:	39 fe                	cmp    %edi,%esi
801042a4:	75 e2                	jne    80104288 <procdump+0x98>
801042a6:	e9 65 ff ff ff       	jmp    80104210 <procdump+0x20>
801042ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042af:	90                   	nop
  }
}
801042b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042b3:	5b                   	pop    %ebx
801042b4:	5e                   	pop    %esi
801042b5:	5f                   	pop    %edi
801042b6:	5d                   	pop    %ebp
801042b7:	c3                   	ret    
801042b8:	66 90                	xchg   %ax,%ax
801042ba:	66 90                	xchg   %ax,%ax
801042bc:	66 90                	xchg   %ax,%ax
801042be:	66 90                	xchg   %ax,%ax

801042c0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801042c0:	f3 0f 1e fb          	endbr32 
801042c4:	55                   	push   %ebp
801042c5:	89 e5                	mov    %esp,%ebp
801042c7:	53                   	push   %ebx
801042c8:	83 ec 0c             	sub    $0xc,%esp
801042cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801042ce:	68 e4 77 10 80       	push   $0x801077e4
801042d3:	8d 43 04             	lea    0x4(%ebx),%eax
801042d6:	50                   	push   %eax
801042d7:	e8 24 01 00 00       	call   80104400 <initlock>
  lk->name = name;
801042dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801042df:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801042e5:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801042e8:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801042ef:	89 43 38             	mov    %eax,0x38(%ebx)
}
801042f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042f5:	c9                   	leave  
801042f6:	c3                   	ret    
801042f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042fe:	66 90                	xchg   %ax,%ax

80104300 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104300:	f3 0f 1e fb          	endbr32 
80104304:	55                   	push   %ebp
80104305:	89 e5                	mov    %esp,%ebp
80104307:	56                   	push   %esi
80104308:	53                   	push   %ebx
80104309:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010430c:	8d 73 04             	lea    0x4(%ebx),%esi
8010430f:	83 ec 0c             	sub    $0xc,%esp
80104312:	56                   	push   %esi
80104313:	e8 68 02 00 00       	call   80104580 <acquire>
  while (lk->locked) {
80104318:	8b 13                	mov    (%ebx),%edx
8010431a:	83 c4 10             	add    $0x10,%esp
8010431d:	85 d2                	test   %edx,%edx
8010431f:	74 1a                	je     8010433b <acquiresleep+0x3b>
80104321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104328:	83 ec 08             	sub    $0x8,%esp
8010432b:	56                   	push   %esi
8010432c:	53                   	push   %ebx
8010432d:	e8 0e fc ff ff       	call   80103f40 <sleep>
  while (lk->locked) {
80104332:	8b 03                	mov    (%ebx),%eax
80104334:	83 c4 10             	add    $0x10,%esp
80104337:	85 c0                	test   %eax,%eax
80104339:	75 ed                	jne    80104328 <acquiresleep+0x28>
  }
  lk->locked = 1;
8010433b:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104341:	e8 3a f6 ff ff       	call   80103980 <myproc>
80104346:	8b 40 10             	mov    0x10(%eax),%eax
80104349:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
8010434c:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010434f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104352:	5b                   	pop    %ebx
80104353:	5e                   	pop    %esi
80104354:	5d                   	pop    %ebp
  release(&lk->lk);
80104355:	e9 e6 02 00 00       	jmp    80104640 <release>
8010435a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104360 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104360:	f3 0f 1e fb          	endbr32 
80104364:	55                   	push   %ebp
80104365:	89 e5                	mov    %esp,%ebp
80104367:	56                   	push   %esi
80104368:	53                   	push   %ebx
80104369:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010436c:	8d 73 04             	lea    0x4(%ebx),%esi
8010436f:	83 ec 0c             	sub    $0xc,%esp
80104372:	56                   	push   %esi
80104373:	e8 08 02 00 00       	call   80104580 <acquire>
  lk->locked = 0;
80104378:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010437e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104385:	89 1c 24             	mov    %ebx,(%esp)
80104388:	e8 73 fd ff ff       	call   80104100 <wakeup>
  release(&lk->lk);
8010438d:	89 75 08             	mov    %esi,0x8(%ebp)
80104390:	83 c4 10             	add    $0x10,%esp
}
80104393:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104396:	5b                   	pop    %ebx
80104397:	5e                   	pop    %esi
80104398:	5d                   	pop    %ebp
  release(&lk->lk);
80104399:	e9 a2 02 00 00       	jmp    80104640 <release>
8010439e:	66 90                	xchg   %ax,%ax

801043a0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801043a0:	f3 0f 1e fb          	endbr32 
801043a4:	55                   	push   %ebp
801043a5:	89 e5                	mov    %esp,%ebp
801043a7:	57                   	push   %edi
801043a8:	31 ff                	xor    %edi,%edi
801043aa:	56                   	push   %esi
801043ab:	53                   	push   %ebx
801043ac:	83 ec 18             	sub    $0x18,%esp
801043af:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801043b2:	8d 73 04             	lea    0x4(%ebx),%esi
801043b5:	56                   	push   %esi
801043b6:	e8 c5 01 00 00       	call   80104580 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801043bb:	8b 03                	mov    (%ebx),%eax
801043bd:	83 c4 10             	add    $0x10,%esp
801043c0:	85 c0                	test   %eax,%eax
801043c2:	75 1c                	jne    801043e0 <holdingsleep+0x40>
  release(&lk->lk);
801043c4:	83 ec 0c             	sub    $0xc,%esp
801043c7:	56                   	push   %esi
801043c8:	e8 73 02 00 00       	call   80104640 <release>
  return r;
}
801043cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043d0:	89 f8                	mov    %edi,%eax
801043d2:	5b                   	pop    %ebx
801043d3:	5e                   	pop    %esi
801043d4:	5f                   	pop    %edi
801043d5:	5d                   	pop    %ebp
801043d6:	c3                   	ret    
801043d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043de:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
801043e0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801043e3:	e8 98 f5 ff ff       	call   80103980 <myproc>
801043e8:	39 58 10             	cmp    %ebx,0x10(%eax)
801043eb:	0f 94 c0             	sete   %al
801043ee:	0f b6 c0             	movzbl %al,%eax
801043f1:	89 c7                	mov    %eax,%edi
801043f3:	eb cf                	jmp    801043c4 <holdingsleep+0x24>
801043f5:	66 90                	xchg   %ax,%ax
801043f7:	66 90                	xchg   %ax,%ax
801043f9:	66 90                	xchg   %ax,%ax
801043fb:	66 90                	xchg   %ax,%ax
801043fd:	66 90                	xchg   %ax,%ax
801043ff:	90                   	nop

80104400 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104400:	f3 0f 1e fb          	endbr32 
80104404:	55                   	push   %ebp
80104405:	89 e5                	mov    %esp,%ebp
80104407:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
8010440a:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
8010440d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104413:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104416:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010441d:	5d                   	pop    %ebp
8010441e:	c3                   	ret    
8010441f:	90                   	nop

80104420 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104420:	f3 0f 1e fb          	endbr32 
80104424:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104425:	31 d2                	xor    %edx,%edx
{
80104427:	89 e5                	mov    %esp,%ebp
80104429:	53                   	push   %ebx
  ebp = (uint*)v - 2;
8010442a:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010442d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104430:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104433:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104437:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104438:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010443e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104444:	77 1a                	ja     80104460 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104446:	8b 58 04             	mov    0x4(%eax),%ebx
80104449:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
8010444c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
8010444f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104451:	83 fa 0a             	cmp    $0xa,%edx
80104454:	75 e2                	jne    80104438 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104456:	5b                   	pop    %ebx
80104457:	5d                   	pop    %ebp
80104458:	c3                   	ret    
80104459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104460:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104463:	8d 51 28             	lea    0x28(%ecx),%edx
80104466:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010446d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104470:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104476:	83 c0 04             	add    $0x4,%eax
80104479:	39 d0                	cmp    %edx,%eax
8010447b:	75 f3                	jne    80104470 <getcallerpcs+0x50>
}
8010447d:	5b                   	pop    %ebx
8010447e:	5d                   	pop    %ebp
8010447f:	c3                   	ret    

80104480 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104480:	f3 0f 1e fb          	endbr32 
80104484:	55                   	push   %ebp
80104485:	89 e5                	mov    %esp,%ebp
80104487:	53                   	push   %ebx
80104488:	83 ec 04             	sub    $0x4,%esp
8010448b:	9c                   	pushf  
8010448c:	5b                   	pop    %ebx
  asm volatile("cli");
8010448d:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010448e:	e8 5d f4 ff ff       	call   801038f0 <mycpu>
80104493:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104499:	85 c0                	test   %eax,%eax
8010449b:	74 13                	je     801044b0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
8010449d:	e8 4e f4 ff ff       	call   801038f0 <mycpu>
801044a2:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801044a9:	83 c4 04             	add    $0x4,%esp
801044ac:	5b                   	pop    %ebx
801044ad:	5d                   	pop    %ebp
801044ae:	c3                   	ret    
801044af:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
801044b0:	e8 3b f4 ff ff       	call   801038f0 <mycpu>
801044b5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801044bb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801044c1:	eb da                	jmp    8010449d <pushcli+0x1d>
801044c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044d0 <popcli>:

void
popcli(void)
{
801044d0:	f3 0f 1e fb          	endbr32 
801044d4:	55                   	push   %ebp
801044d5:	89 e5                	mov    %esp,%ebp
801044d7:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801044da:	9c                   	pushf  
801044db:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801044dc:	f6 c4 02             	test   $0x2,%ah
801044df:	75 31                	jne    80104512 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801044e1:	e8 0a f4 ff ff       	call   801038f0 <mycpu>
801044e6:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801044ed:	78 30                	js     8010451f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801044ef:	e8 fc f3 ff ff       	call   801038f0 <mycpu>
801044f4:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801044fa:	85 d2                	test   %edx,%edx
801044fc:	74 02                	je     80104500 <popcli+0x30>
    sti();
}
801044fe:	c9                   	leave  
801044ff:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104500:	e8 eb f3 ff ff       	call   801038f0 <mycpu>
80104505:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010450b:	85 c0                	test   %eax,%eax
8010450d:	74 ef                	je     801044fe <popcli+0x2e>
  asm volatile("sti");
8010450f:	fb                   	sti    
}
80104510:	c9                   	leave  
80104511:	c3                   	ret    
    panic("popcli - interruptible");
80104512:	83 ec 0c             	sub    $0xc,%esp
80104515:	68 ef 77 10 80       	push   $0x801077ef
8010451a:	e8 71 be ff ff       	call   80100390 <panic>
    panic("popcli");
8010451f:	83 ec 0c             	sub    $0xc,%esp
80104522:	68 06 78 10 80       	push   $0x80107806
80104527:	e8 64 be ff ff       	call   80100390 <panic>
8010452c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104530 <holding>:
{
80104530:	f3 0f 1e fb          	endbr32 
80104534:	55                   	push   %ebp
80104535:	89 e5                	mov    %esp,%ebp
80104537:	56                   	push   %esi
80104538:	53                   	push   %ebx
80104539:	8b 75 08             	mov    0x8(%ebp),%esi
8010453c:	31 db                	xor    %ebx,%ebx
  pushcli();
8010453e:	e8 3d ff ff ff       	call   80104480 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104543:	8b 06                	mov    (%esi),%eax
80104545:	85 c0                	test   %eax,%eax
80104547:	75 0f                	jne    80104558 <holding+0x28>
  popcli();
80104549:	e8 82 ff ff ff       	call   801044d0 <popcli>
}
8010454e:	89 d8                	mov    %ebx,%eax
80104550:	5b                   	pop    %ebx
80104551:	5e                   	pop    %esi
80104552:	5d                   	pop    %ebp
80104553:	c3                   	ret    
80104554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104558:	8b 5e 08             	mov    0x8(%esi),%ebx
8010455b:	e8 90 f3 ff ff       	call   801038f0 <mycpu>
80104560:	39 c3                	cmp    %eax,%ebx
80104562:	0f 94 c3             	sete   %bl
  popcli();
80104565:	e8 66 ff ff ff       	call   801044d0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
8010456a:	0f b6 db             	movzbl %bl,%ebx
}
8010456d:	89 d8                	mov    %ebx,%eax
8010456f:	5b                   	pop    %ebx
80104570:	5e                   	pop    %esi
80104571:	5d                   	pop    %ebp
80104572:	c3                   	ret    
80104573:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010457a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104580 <acquire>:
{
80104580:	f3 0f 1e fb          	endbr32 
80104584:	55                   	push   %ebp
80104585:	89 e5                	mov    %esp,%ebp
80104587:	56                   	push   %esi
80104588:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104589:	e8 f2 fe ff ff       	call   80104480 <pushcli>
  if(holding(lk))
8010458e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104591:	83 ec 0c             	sub    $0xc,%esp
80104594:	53                   	push   %ebx
80104595:	e8 96 ff ff ff       	call   80104530 <holding>
8010459a:	83 c4 10             	add    $0x10,%esp
8010459d:	85 c0                	test   %eax,%eax
8010459f:	0f 85 7f 00 00 00    	jne    80104624 <acquire+0xa4>
801045a5:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
801045a7:	ba 01 00 00 00       	mov    $0x1,%edx
801045ac:	eb 05                	jmp    801045b3 <acquire+0x33>
801045ae:	66 90                	xchg   %ax,%ax
801045b0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801045b3:	89 d0                	mov    %edx,%eax
801045b5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
801045b8:	85 c0                	test   %eax,%eax
801045ba:	75 f4                	jne    801045b0 <acquire+0x30>
  __sync_synchronize();
801045bc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801045c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801045c4:	e8 27 f3 ff ff       	call   801038f0 <mycpu>
801045c9:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
801045cc:	89 e8                	mov    %ebp,%eax
801045ce:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801045d0:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801045d6:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
801045dc:	77 22                	ja     80104600 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
801045de:	8b 50 04             	mov    0x4(%eax),%edx
801045e1:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
801045e5:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
801045e8:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801045ea:	83 fe 0a             	cmp    $0xa,%esi
801045ed:	75 e1                	jne    801045d0 <acquire+0x50>
}
801045ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045f2:	5b                   	pop    %ebx
801045f3:	5e                   	pop    %esi
801045f4:	5d                   	pop    %ebp
801045f5:	c3                   	ret    
801045f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045fd:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104600:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104604:	83 c3 34             	add    $0x34,%ebx
80104607:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010460e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104610:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104616:	83 c0 04             	add    $0x4,%eax
80104619:	39 d8                	cmp    %ebx,%eax
8010461b:	75 f3                	jne    80104610 <acquire+0x90>
}
8010461d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104620:	5b                   	pop    %ebx
80104621:	5e                   	pop    %esi
80104622:	5d                   	pop    %ebp
80104623:	c3                   	ret    
    panic("acquire");
80104624:	83 ec 0c             	sub    $0xc,%esp
80104627:	68 0d 78 10 80       	push   $0x8010780d
8010462c:	e8 5f bd ff ff       	call   80100390 <panic>
80104631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104638:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010463f:	90                   	nop

80104640 <release>:
{
80104640:	f3 0f 1e fb          	endbr32 
80104644:	55                   	push   %ebp
80104645:	89 e5                	mov    %esp,%ebp
80104647:	53                   	push   %ebx
80104648:	83 ec 10             	sub    $0x10,%esp
8010464b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010464e:	53                   	push   %ebx
8010464f:	e8 dc fe ff ff       	call   80104530 <holding>
80104654:	83 c4 10             	add    $0x10,%esp
80104657:	85 c0                	test   %eax,%eax
80104659:	74 22                	je     8010467d <release+0x3d>
  lk->pcs[0] = 0;
8010465b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104662:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104669:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010466e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104674:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104677:	c9                   	leave  
  popcli();
80104678:	e9 53 fe ff ff       	jmp    801044d0 <popcli>
    panic("release");
8010467d:	83 ec 0c             	sub    $0xc,%esp
80104680:	68 15 78 10 80       	push   $0x80107815
80104685:	e8 06 bd ff ff       	call   80100390 <panic>
8010468a:	66 90                	xchg   %ax,%ax
8010468c:	66 90                	xchg   %ax,%ax
8010468e:	66 90                	xchg   %ax,%ax

80104690 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104690:	f3 0f 1e fb          	endbr32 
80104694:	55                   	push   %ebp
80104695:	89 e5                	mov    %esp,%ebp
80104697:	57                   	push   %edi
80104698:	8b 55 08             	mov    0x8(%ebp),%edx
8010469b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010469e:	53                   	push   %ebx
8010469f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
801046a2:	89 d7                	mov    %edx,%edi
801046a4:	09 cf                	or     %ecx,%edi
801046a6:	83 e7 03             	and    $0x3,%edi
801046a9:	75 25                	jne    801046d0 <memset+0x40>
    c &= 0xFF;
801046ab:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801046ae:	c1 e0 18             	shl    $0x18,%eax
801046b1:	89 fb                	mov    %edi,%ebx
801046b3:	c1 e9 02             	shr    $0x2,%ecx
801046b6:	c1 e3 10             	shl    $0x10,%ebx
801046b9:	09 d8                	or     %ebx,%eax
801046bb:	09 f8                	or     %edi,%eax
801046bd:	c1 e7 08             	shl    $0x8,%edi
801046c0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801046c2:	89 d7                	mov    %edx,%edi
801046c4:	fc                   	cld    
801046c5:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801046c7:	5b                   	pop    %ebx
801046c8:	89 d0                	mov    %edx,%eax
801046ca:	5f                   	pop    %edi
801046cb:	5d                   	pop    %ebp
801046cc:	c3                   	ret    
801046cd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
801046d0:	89 d7                	mov    %edx,%edi
801046d2:	fc                   	cld    
801046d3:	f3 aa                	rep stos %al,%es:(%edi)
801046d5:	5b                   	pop    %ebx
801046d6:	89 d0                	mov    %edx,%eax
801046d8:	5f                   	pop    %edi
801046d9:	5d                   	pop    %ebp
801046da:	c3                   	ret    
801046db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046df:	90                   	nop

801046e0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801046e0:	f3 0f 1e fb          	endbr32 
801046e4:	55                   	push   %ebp
801046e5:	89 e5                	mov    %esp,%ebp
801046e7:	56                   	push   %esi
801046e8:	8b 75 10             	mov    0x10(%ebp),%esi
801046eb:	8b 55 08             	mov    0x8(%ebp),%edx
801046ee:	53                   	push   %ebx
801046ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801046f2:	85 f6                	test   %esi,%esi
801046f4:	74 2a                	je     80104720 <memcmp+0x40>
801046f6:	01 c6                	add    %eax,%esi
801046f8:	eb 10                	jmp    8010470a <memcmp+0x2a>
801046fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104700:	83 c0 01             	add    $0x1,%eax
80104703:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104706:	39 f0                	cmp    %esi,%eax
80104708:	74 16                	je     80104720 <memcmp+0x40>
    if(*s1 != *s2)
8010470a:	0f b6 0a             	movzbl (%edx),%ecx
8010470d:	0f b6 18             	movzbl (%eax),%ebx
80104710:	38 d9                	cmp    %bl,%cl
80104712:	74 ec                	je     80104700 <memcmp+0x20>
      return *s1 - *s2;
80104714:	0f b6 c1             	movzbl %cl,%eax
80104717:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104719:	5b                   	pop    %ebx
8010471a:	5e                   	pop    %esi
8010471b:	5d                   	pop    %ebp
8010471c:	c3                   	ret    
8010471d:	8d 76 00             	lea    0x0(%esi),%esi
80104720:	5b                   	pop    %ebx
  return 0;
80104721:	31 c0                	xor    %eax,%eax
}
80104723:	5e                   	pop    %esi
80104724:	5d                   	pop    %ebp
80104725:	c3                   	ret    
80104726:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010472d:	8d 76 00             	lea    0x0(%esi),%esi

80104730 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104730:	f3 0f 1e fb          	endbr32 
80104734:	55                   	push   %ebp
80104735:	89 e5                	mov    %esp,%ebp
80104737:	57                   	push   %edi
80104738:	8b 55 08             	mov    0x8(%ebp),%edx
8010473b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010473e:	56                   	push   %esi
8010473f:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104742:	39 d6                	cmp    %edx,%esi
80104744:	73 2a                	jae    80104770 <memmove+0x40>
80104746:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104749:	39 fa                	cmp    %edi,%edx
8010474b:	73 23                	jae    80104770 <memmove+0x40>
8010474d:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104750:	85 c9                	test   %ecx,%ecx
80104752:	74 13                	je     80104767 <memmove+0x37>
80104754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104758:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
8010475c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
8010475f:	83 e8 01             	sub    $0x1,%eax
80104762:	83 f8 ff             	cmp    $0xffffffff,%eax
80104765:	75 f1                	jne    80104758 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104767:	5e                   	pop    %esi
80104768:	89 d0                	mov    %edx,%eax
8010476a:	5f                   	pop    %edi
8010476b:	5d                   	pop    %ebp
8010476c:	c3                   	ret    
8010476d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80104770:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104773:	89 d7                	mov    %edx,%edi
80104775:	85 c9                	test   %ecx,%ecx
80104777:	74 ee                	je     80104767 <memmove+0x37>
80104779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104780:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104781:	39 f0                	cmp    %esi,%eax
80104783:	75 fb                	jne    80104780 <memmove+0x50>
}
80104785:	5e                   	pop    %esi
80104786:	89 d0                	mov    %edx,%eax
80104788:	5f                   	pop    %edi
80104789:	5d                   	pop    %ebp
8010478a:	c3                   	ret    
8010478b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010478f:	90                   	nop

80104790 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104790:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80104794:	eb 9a                	jmp    80104730 <memmove>
80104796:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010479d:	8d 76 00             	lea    0x0(%esi),%esi

801047a0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801047a0:	f3 0f 1e fb          	endbr32 
801047a4:	55                   	push   %ebp
801047a5:	89 e5                	mov    %esp,%ebp
801047a7:	56                   	push   %esi
801047a8:	8b 75 10             	mov    0x10(%ebp),%esi
801047ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
801047ae:	53                   	push   %ebx
801047af:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
801047b2:	85 f6                	test   %esi,%esi
801047b4:	74 32                	je     801047e8 <strncmp+0x48>
801047b6:	01 c6                	add    %eax,%esi
801047b8:	eb 14                	jmp    801047ce <strncmp+0x2e>
801047ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801047c0:	38 da                	cmp    %bl,%dl
801047c2:	75 14                	jne    801047d8 <strncmp+0x38>
    n--, p++, q++;
801047c4:	83 c0 01             	add    $0x1,%eax
801047c7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801047ca:	39 f0                	cmp    %esi,%eax
801047cc:	74 1a                	je     801047e8 <strncmp+0x48>
801047ce:	0f b6 11             	movzbl (%ecx),%edx
801047d1:	0f b6 18             	movzbl (%eax),%ebx
801047d4:	84 d2                	test   %dl,%dl
801047d6:	75 e8                	jne    801047c0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801047d8:	0f b6 c2             	movzbl %dl,%eax
801047db:	29 d8                	sub    %ebx,%eax
}
801047dd:	5b                   	pop    %ebx
801047de:	5e                   	pop    %esi
801047df:	5d                   	pop    %ebp
801047e0:	c3                   	ret    
801047e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047e8:	5b                   	pop    %ebx
    return 0;
801047e9:	31 c0                	xor    %eax,%eax
}
801047eb:	5e                   	pop    %esi
801047ec:	5d                   	pop    %ebp
801047ed:	c3                   	ret    
801047ee:	66 90                	xchg   %ax,%ax

801047f0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801047f0:	f3 0f 1e fb          	endbr32 
801047f4:	55                   	push   %ebp
801047f5:	89 e5                	mov    %esp,%ebp
801047f7:	57                   	push   %edi
801047f8:	56                   	push   %esi
801047f9:	8b 75 08             	mov    0x8(%ebp),%esi
801047fc:	53                   	push   %ebx
801047fd:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104800:	89 f2                	mov    %esi,%edx
80104802:	eb 1b                	jmp    8010481f <strncpy+0x2f>
80104804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104808:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
8010480c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010480f:	83 c2 01             	add    $0x1,%edx
80104812:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80104816:	89 f9                	mov    %edi,%ecx
80104818:	88 4a ff             	mov    %cl,-0x1(%edx)
8010481b:	84 c9                	test   %cl,%cl
8010481d:	74 09                	je     80104828 <strncpy+0x38>
8010481f:	89 c3                	mov    %eax,%ebx
80104821:	83 e8 01             	sub    $0x1,%eax
80104824:	85 db                	test   %ebx,%ebx
80104826:	7f e0                	jg     80104808 <strncpy+0x18>
    ;
  while(n-- > 0)
80104828:	89 d1                	mov    %edx,%ecx
8010482a:	85 c0                	test   %eax,%eax
8010482c:	7e 15                	jle    80104843 <strncpy+0x53>
8010482e:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80104830:	83 c1 01             	add    $0x1,%ecx
80104833:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80104837:	89 c8                	mov    %ecx,%eax
80104839:	f7 d0                	not    %eax
8010483b:	01 d0                	add    %edx,%eax
8010483d:	01 d8                	add    %ebx,%eax
8010483f:	85 c0                	test   %eax,%eax
80104841:	7f ed                	jg     80104830 <strncpy+0x40>
  return os;
}
80104843:	5b                   	pop    %ebx
80104844:	89 f0                	mov    %esi,%eax
80104846:	5e                   	pop    %esi
80104847:	5f                   	pop    %edi
80104848:	5d                   	pop    %ebp
80104849:	c3                   	ret    
8010484a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104850 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104850:	f3 0f 1e fb          	endbr32 
80104854:	55                   	push   %ebp
80104855:	89 e5                	mov    %esp,%ebp
80104857:	56                   	push   %esi
80104858:	8b 55 10             	mov    0x10(%ebp),%edx
8010485b:	8b 75 08             	mov    0x8(%ebp),%esi
8010485e:	53                   	push   %ebx
8010485f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104862:	85 d2                	test   %edx,%edx
80104864:	7e 21                	jle    80104887 <safestrcpy+0x37>
80104866:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
8010486a:	89 f2                	mov    %esi,%edx
8010486c:	eb 12                	jmp    80104880 <safestrcpy+0x30>
8010486e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104870:	0f b6 08             	movzbl (%eax),%ecx
80104873:	83 c0 01             	add    $0x1,%eax
80104876:	83 c2 01             	add    $0x1,%edx
80104879:	88 4a ff             	mov    %cl,-0x1(%edx)
8010487c:	84 c9                	test   %cl,%cl
8010487e:	74 04                	je     80104884 <safestrcpy+0x34>
80104880:	39 d8                	cmp    %ebx,%eax
80104882:	75 ec                	jne    80104870 <safestrcpy+0x20>
    ;
  *s = 0;
80104884:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104887:	89 f0                	mov    %esi,%eax
80104889:	5b                   	pop    %ebx
8010488a:	5e                   	pop    %esi
8010488b:	5d                   	pop    %ebp
8010488c:	c3                   	ret    
8010488d:	8d 76 00             	lea    0x0(%esi),%esi

80104890 <strlen>:

int
strlen(const char *s)
{
80104890:	f3 0f 1e fb          	endbr32 
80104894:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104895:	31 c0                	xor    %eax,%eax
{
80104897:	89 e5                	mov    %esp,%ebp
80104899:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
8010489c:	80 3a 00             	cmpb   $0x0,(%edx)
8010489f:	74 10                	je     801048b1 <strlen+0x21>
801048a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048a8:	83 c0 01             	add    $0x1,%eax
801048ab:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801048af:	75 f7                	jne    801048a8 <strlen+0x18>
    ;
  return n;
}
801048b1:	5d                   	pop    %ebp
801048b2:	c3                   	ret    

801048b3 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801048b3:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801048b7:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801048bb:	55                   	push   %ebp
  pushl %ebx
801048bc:	53                   	push   %ebx
  pushl %esi
801048bd:	56                   	push   %esi
  pushl %edi
801048be:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801048bf:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801048c1:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801048c3:	5f                   	pop    %edi
  popl %esi
801048c4:	5e                   	pop    %esi
  popl %ebx
801048c5:	5b                   	pop    %ebx
  popl %ebp
801048c6:	5d                   	pop    %ebp
  ret
801048c7:	c3                   	ret    
801048c8:	66 90                	xchg   %ax,%ax
801048ca:	66 90                	xchg   %ax,%ax
801048cc:	66 90                	xchg   %ax,%ax
801048ce:	66 90                	xchg   %ax,%ax

801048d0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801048d0:	f3 0f 1e fb          	endbr32 
801048d4:	55                   	push   %ebp
801048d5:	89 e5                	mov    %esp,%ebp
801048d7:	53                   	push   %ebx
801048d8:	83 ec 04             	sub    $0x4,%esp
801048db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801048de:	e8 9d f0 ff ff       	call   80103980 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801048e3:	8b 00                	mov    (%eax),%eax
801048e5:	39 d8                	cmp    %ebx,%eax
801048e7:	76 17                	jbe    80104900 <fetchint+0x30>
801048e9:	8d 53 04             	lea    0x4(%ebx),%edx
801048ec:	39 d0                	cmp    %edx,%eax
801048ee:	72 10                	jb     80104900 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801048f0:	8b 45 0c             	mov    0xc(%ebp),%eax
801048f3:	8b 13                	mov    (%ebx),%edx
801048f5:	89 10                	mov    %edx,(%eax)
  return 0;
801048f7:	31 c0                	xor    %eax,%eax
}
801048f9:	83 c4 04             	add    $0x4,%esp
801048fc:	5b                   	pop    %ebx
801048fd:	5d                   	pop    %ebp
801048fe:	c3                   	ret    
801048ff:	90                   	nop
    return -1;
80104900:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104905:	eb f2                	jmp    801048f9 <fetchint+0x29>
80104907:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010490e:	66 90                	xchg   %ax,%ax

80104910 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104910:	f3 0f 1e fb          	endbr32 
80104914:	55                   	push   %ebp
80104915:	89 e5                	mov    %esp,%ebp
80104917:	53                   	push   %ebx
80104918:	83 ec 04             	sub    $0x4,%esp
8010491b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010491e:	e8 5d f0 ff ff       	call   80103980 <myproc>

  if(addr >= curproc->sz)
80104923:	39 18                	cmp    %ebx,(%eax)
80104925:	76 31                	jbe    80104958 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80104927:	8b 55 0c             	mov    0xc(%ebp),%edx
8010492a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010492c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010492e:	39 d3                	cmp    %edx,%ebx
80104930:	73 26                	jae    80104958 <fetchstr+0x48>
80104932:	89 d8                	mov    %ebx,%eax
80104934:	eb 11                	jmp    80104947 <fetchstr+0x37>
80104936:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010493d:	8d 76 00             	lea    0x0(%esi),%esi
80104940:	83 c0 01             	add    $0x1,%eax
80104943:	39 c2                	cmp    %eax,%edx
80104945:	76 11                	jbe    80104958 <fetchstr+0x48>
    if(*s == 0)
80104947:	80 38 00             	cmpb   $0x0,(%eax)
8010494a:	75 f4                	jne    80104940 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
8010494c:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
8010494f:	29 d8                	sub    %ebx,%eax
}
80104951:	5b                   	pop    %ebx
80104952:	5d                   	pop    %ebp
80104953:	c3                   	ret    
80104954:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104958:	83 c4 04             	add    $0x4,%esp
    return -1;
8010495b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104960:	5b                   	pop    %ebx
80104961:	5d                   	pop    %ebp
80104962:	c3                   	ret    
80104963:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010496a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104970 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104970:	f3 0f 1e fb          	endbr32 
80104974:	55                   	push   %ebp
80104975:	89 e5                	mov    %esp,%ebp
80104977:	56                   	push   %esi
80104978:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104979:	e8 02 f0 ff ff       	call   80103980 <myproc>
8010497e:	8b 55 08             	mov    0x8(%ebp),%edx
80104981:	8b 40 18             	mov    0x18(%eax),%eax
80104984:	8b 40 44             	mov    0x44(%eax),%eax
80104987:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
8010498a:	e8 f1 ef ff ff       	call   80103980 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010498f:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104992:	8b 00                	mov    (%eax),%eax
80104994:	39 c6                	cmp    %eax,%esi
80104996:	73 18                	jae    801049b0 <argint+0x40>
80104998:	8d 53 08             	lea    0x8(%ebx),%edx
8010499b:	39 d0                	cmp    %edx,%eax
8010499d:	72 11                	jb     801049b0 <argint+0x40>
  *ip = *(int*)(addr);
8010499f:	8b 45 0c             	mov    0xc(%ebp),%eax
801049a2:	8b 53 04             	mov    0x4(%ebx),%edx
801049a5:	89 10                	mov    %edx,(%eax)
  return 0;
801049a7:	31 c0                	xor    %eax,%eax
}
801049a9:	5b                   	pop    %ebx
801049aa:	5e                   	pop    %esi
801049ab:	5d                   	pop    %ebp
801049ac:	c3                   	ret    
801049ad:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801049b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049b5:	eb f2                	jmp    801049a9 <argint+0x39>
801049b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049be:	66 90                	xchg   %ax,%ax

801049c0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801049c0:	f3 0f 1e fb          	endbr32 
801049c4:	55                   	push   %ebp
801049c5:	89 e5                	mov    %esp,%ebp
801049c7:	56                   	push   %esi
801049c8:	53                   	push   %ebx
801049c9:	83 ec 10             	sub    $0x10,%esp
801049cc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801049cf:	e8 ac ef ff ff       	call   80103980 <myproc>
 
  if(argint(n, &i) < 0)
801049d4:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
801049d7:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
801049d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801049dc:	50                   	push   %eax
801049dd:	ff 75 08             	pushl  0x8(%ebp)
801049e0:	e8 8b ff ff ff       	call   80104970 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801049e5:	83 c4 10             	add    $0x10,%esp
801049e8:	85 c0                	test   %eax,%eax
801049ea:	78 24                	js     80104a10 <argptr+0x50>
801049ec:	85 db                	test   %ebx,%ebx
801049ee:	78 20                	js     80104a10 <argptr+0x50>
801049f0:	8b 16                	mov    (%esi),%edx
801049f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049f5:	39 c2                	cmp    %eax,%edx
801049f7:	76 17                	jbe    80104a10 <argptr+0x50>
801049f9:	01 c3                	add    %eax,%ebx
801049fb:	39 da                	cmp    %ebx,%edx
801049fd:	72 11                	jb     80104a10 <argptr+0x50>
    return -1;
  *pp = (char*)i;
801049ff:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a02:	89 02                	mov    %eax,(%edx)
  return 0;
80104a04:	31 c0                	xor    %eax,%eax
}
80104a06:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a09:	5b                   	pop    %ebx
80104a0a:	5e                   	pop    %esi
80104a0b:	5d                   	pop    %ebp
80104a0c:	c3                   	ret    
80104a0d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104a10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a15:	eb ef                	jmp    80104a06 <argptr+0x46>
80104a17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a1e:	66 90                	xchg   %ax,%ax

80104a20 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104a20:	f3 0f 1e fb          	endbr32 
80104a24:	55                   	push   %ebp
80104a25:	89 e5                	mov    %esp,%ebp
80104a27:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104a2a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a2d:	50                   	push   %eax
80104a2e:	ff 75 08             	pushl  0x8(%ebp)
80104a31:	e8 3a ff ff ff       	call   80104970 <argint>
80104a36:	83 c4 10             	add    $0x10,%esp
80104a39:	85 c0                	test   %eax,%eax
80104a3b:	78 13                	js     80104a50 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104a3d:	83 ec 08             	sub    $0x8,%esp
80104a40:	ff 75 0c             	pushl  0xc(%ebp)
80104a43:	ff 75 f4             	pushl  -0xc(%ebp)
80104a46:	e8 c5 fe ff ff       	call   80104910 <fetchstr>
80104a4b:	83 c4 10             	add    $0x10,%esp
}
80104a4e:	c9                   	leave  
80104a4f:	c3                   	ret    
80104a50:	c9                   	leave  
    return -1;
80104a51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a56:	c3                   	ret    
80104a57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a5e:	66 90                	xchg   %ax,%ax

80104a60 <syscall>:
[SYS_memsize] sys_memsize
};

void
syscall(void)
{
80104a60:	f3 0f 1e fb          	endbr32 
80104a64:	55                   	push   %ebp
80104a65:	89 e5                	mov    %esp,%ebp
80104a67:	53                   	push   %ebx
80104a68:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104a6b:	e8 10 ef ff ff       	call   80103980 <myproc>
80104a70:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104a72:	8b 40 18             	mov    0x18(%eax),%eax
80104a75:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104a78:	8d 50 ff             	lea    -0x1(%eax),%edx
80104a7b:	83 fa 15             	cmp    $0x15,%edx
80104a7e:	77 20                	ja     80104aa0 <syscall+0x40>
80104a80:	8b 14 85 40 78 10 80 	mov    -0x7fef87c0(,%eax,4),%edx
80104a87:	85 d2                	test   %edx,%edx
80104a89:	74 15                	je     80104aa0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104a8b:	ff d2                	call   *%edx
80104a8d:	89 c2                	mov    %eax,%edx
80104a8f:	8b 43 18             	mov    0x18(%ebx),%eax
80104a92:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104a95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a98:	c9                   	leave  
80104a99:	c3                   	ret    
80104a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104aa0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104aa1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104aa4:	50                   	push   %eax
80104aa5:	ff 73 10             	pushl  0x10(%ebx)
80104aa8:	68 1d 78 10 80       	push   $0x8010781d
80104aad:	e8 fe bb ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80104ab2:	8b 43 18             	mov    0x18(%ebx),%eax
80104ab5:	83 c4 10             	add    $0x10,%esp
80104ab8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104abf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ac2:	c9                   	leave  
80104ac3:	c3                   	ret    
80104ac4:	66 90                	xchg   %ax,%ax
80104ac6:	66 90                	xchg   %ax,%ax
80104ac8:	66 90                	xchg   %ax,%ax
80104aca:	66 90                	xchg   %ax,%ax
80104acc:	66 90                	xchg   %ax,%ax
80104ace:	66 90                	xchg   %ax,%ax

80104ad0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104ad0:	55                   	push   %ebp
80104ad1:	89 e5                	mov    %esp,%ebp
80104ad3:	57                   	push   %edi
80104ad4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104ad5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104ad8:	53                   	push   %ebx
80104ad9:	83 ec 34             	sub    $0x34,%esp
80104adc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104adf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104ae2:	57                   	push   %edi
80104ae3:	50                   	push   %eax
{
80104ae4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104ae7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104aea:	e8 81 d5 ff ff       	call   80102070 <nameiparent>
80104aef:	83 c4 10             	add    $0x10,%esp
80104af2:	85 c0                	test   %eax,%eax
80104af4:	0f 84 46 01 00 00    	je     80104c40 <create+0x170>
    return 0;
  ilock(dp);
80104afa:	83 ec 0c             	sub    $0xc,%esp
80104afd:	89 c3                	mov    %eax,%ebx
80104aff:	50                   	push   %eax
80104b00:	e8 7b cc ff ff       	call   80101780 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104b05:	83 c4 0c             	add    $0xc,%esp
80104b08:	6a 00                	push   $0x0
80104b0a:	57                   	push   %edi
80104b0b:	53                   	push   %ebx
80104b0c:	e8 bf d1 ff ff       	call   80101cd0 <dirlookup>
80104b11:	83 c4 10             	add    $0x10,%esp
80104b14:	89 c6                	mov    %eax,%esi
80104b16:	85 c0                	test   %eax,%eax
80104b18:	74 56                	je     80104b70 <create+0xa0>
    iunlockput(dp);
80104b1a:	83 ec 0c             	sub    $0xc,%esp
80104b1d:	53                   	push   %ebx
80104b1e:	e8 fd ce ff ff       	call   80101a20 <iunlockput>
    ilock(ip);
80104b23:	89 34 24             	mov    %esi,(%esp)
80104b26:	e8 55 cc ff ff       	call   80101780 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104b2b:	83 c4 10             	add    $0x10,%esp
80104b2e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104b33:	75 1b                	jne    80104b50 <create+0x80>
80104b35:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104b3a:	75 14                	jne    80104b50 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104b3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b3f:	89 f0                	mov    %esi,%eax
80104b41:	5b                   	pop    %ebx
80104b42:	5e                   	pop    %esi
80104b43:	5f                   	pop    %edi
80104b44:	5d                   	pop    %ebp
80104b45:	c3                   	ret    
80104b46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b4d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104b50:	83 ec 0c             	sub    $0xc,%esp
80104b53:	56                   	push   %esi
    return 0;
80104b54:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104b56:	e8 c5 ce ff ff       	call   80101a20 <iunlockput>
    return 0;
80104b5b:	83 c4 10             	add    $0x10,%esp
}
80104b5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b61:	89 f0                	mov    %esi,%eax
80104b63:	5b                   	pop    %ebx
80104b64:	5e                   	pop    %esi
80104b65:	5f                   	pop    %edi
80104b66:	5d                   	pop    %ebp
80104b67:	c3                   	ret    
80104b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b6f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104b70:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104b74:	83 ec 08             	sub    $0x8,%esp
80104b77:	50                   	push   %eax
80104b78:	ff 33                	pushl  (%ebx)
80104b7a:	e8 81 ca ff ff       	call   80101600 <ialloc>
80104b7f:	83 c4 10             	add    $0x10,%esp
80104b82:	89 c6                	mov    %eax,%esi
80104b84:	85 c0                	test   %eax,%eax
80104b86:	0f 84 cd 00 00 00    	je     80104c59 <create+0x189>
  ilock(ip);
80104b8c:	83 ec 0c             	sub    $0xc,%esp
80104b8f:	50                   	push   %eax
80104b90:	e8 eb cb ff ff       	call   80101780 <ilock>
  ip->major = major;
80104b95:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104b99:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104b9d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104ba1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104ba5:	b8 01 00 00 00       	mov    $0x1,%eax
80104baa:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104bae:	89 34 24             	mov    %esi,(%esp)
80104bb1:	e8 0a cb ff ff       	call   801016c0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104bb6:	83 c4 10             	add    $0x10,%esp
80104bb9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104bbe:	74 30                	je     80104bf0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104bc0:	83 ec 04             	sub    $0x4,%esp
80104bc3:	ff 76 04             	pushl  0x4(%esi)
80104bc6:	57                   	push   %edi
80104bc7:	53                   	push   %ebx
80104bc8:	e8 c3 d3 ff ff       	call   80101f90 <dirlink>
80104bcd:	83 c4 10             	add    $0x10,%esp
80104bd0:	85 c0                	test   %eax,%eax
80104bd2:	78 78                	js     80104c4c <create+0x17c>
  iunlockput(dp);
80104bd4:	83 ec 0c             	sub    $0xc,%esp
80104bd7:	53                   	push   %ebx
80104bd8:	e8 43 ce ff ff       	call   80101a20 <iunlockput>
  return ip;
80104bdd:	83 c4 10             	add    $0x10,%esp
}
80104be0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104be3:	89 f0                	mov    %esi,%eax
80104be5:	5b                   	pop    %ebx
80104be6:	5e                   	pop    %esi
80104be7:	5f                   	pop    %edi
80104be8:	5d                   	pop    %ebp
80104be9:	c3                   	ret    
80104bea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104bf0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104bf3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104bf8:	53                   	push   %ebx
80104bf9:	e8 c2 ca ff ff       	call   801016c0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104bfe:	83 c4 0c             	add    $0xc,%esp
80104c01:	ff 76 04             	pushl  0x4(%esi)
80104c04:	68 b8 78 10 80       	push   $0x801078b8
80104c09:	56                   	push   %esi
80104c0a:	e8 81 d3 ff ff       	call   80101f90 <dirlink>
80104c0f:	83 c4 10             	add    $0x10,%esp
80104c12:	85 c0                	test   %eax,%eax
80104c14:	78 18                	js     80104c2e <create+0x15e>
80104c16:	83 ec 04             	sub    $0x4,%esp
80104c19:	ff 73 04             	pushl  0x4(%ebx)
80104c1c:	68 b7 78 10 80       	push   $0x801078b7
80104c21:	56                   	push   %esi
80104c22:	e8 69 d3 ff ff       	call   80101f90 <dirlink>
80104c27:	83 c4 10             	add    $0x10,%esp
80104c2a:	85 c0                	test   %eax,%eax
80104c2c:	79 92                	jns    80104bc0 <create+0xf0>
      panic("create dots");
80104c2e:	83 ec 0c             	sub    $0xc,%esp
80104c31:	68 ab 78 10 80       	push   $0x801078ab
80104c36:	e8 55 b7 ff ff       	call   80100390 <panic>
80104c3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c3f:	90                   	nop
}
80104c40:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104c43:	31 f6                	xor    %esi,%esi
}
80104c45:	5b                   	pop    %ebx
80104c46:	89 f0                	mov    %esi,%eax
80104c48:	5e                   	pop    %esi
80104c49:	5f                   	pop    %edi
80104c4a:	5d                   	pop    %ebp
80104c4b:	c3                   	ret    
    panic("create: dirlink");
80104c4c:	83 ec 0c             	sub    $0xc,%esp
80104c4f:	68 ba 78 10 80       	push   $0x801078ba
80104c54:	e8 37 b7 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104c59:	83 ec 0c             	sub    $0xc,%esp
80104c5c:	68 9c 78 10 80       	push   $0x8010789c
80104c61:	e8 2a b7 ff ff       	call   80100390 <panic>
80104c66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c6d:	8d 76 00             	lea    0x0(%esi),%esi

80104c70 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
80104c73:	56                   	push   %esi
80104c74:	89 d6                	mov    %edx,%esi
80104c76:	53                   	push   %ebx
80104c77:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104c79:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104c7c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104c7f:	50                   	push   %eax
80104c80:	6a 00                	push   $0x0
80104c82:	e8 e9 fc ff ff       	call   80104970 <argint>
80104c87:	83 c4 10             	add    $0x10,%esp
80104c8a:	85 c0                	test   %eax,%eax
80104c8c:	78 2a                	js     80104cb8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104c8e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104c92:	77 24                	ja     80104cb8 <argfd.constprop.0+0x48>
80104c94:	e8 e7 ec ff ff       	call   80103980 <myproc>
80104c99:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104c9c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104ca0:	85 c0                	test   %eax,%eax
80104ca2:	74 14                	je     80104cb8 <argfd.constprop.0+0x48>
  if(pfd)
80104ca4:	85 db                	test   %ebx,%ebx
80104ca6:	74 02                	je     80104caa <argfd.constprop.0+0x3a>
    *pfd = fd;
80104ca8:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104caa:	89 06                	mov    %eax,(%esi)
  return 0;
80104cac:	31 c0                	xor    %eax,%eax
}
80104cae:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104cb1:	5b                   	pop    %ebx
80104cb2:	5e                   	pop    %esi
80104cb3:	5d                   	pop    %ebp
80104cb4:	c3                   	ret    
80104cb5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104cb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cbd:	eb ef                	jmp    80104cae <argfd.constprop.0+0x3e>
80104cbf:	90                   	nop

80104cc0 <sys_dup>:
{
80104cc0:	f3 0f 1e fb          	endbr32 
80104cc4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104cc5:	31 c0                	xor    %eax,%eax
{
80104cc7:	89 e5                	mov    %esp,%ebp
80104cc9:	56                   	push   %esi
80104cca:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104ccb:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104cce:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104cd1:	e8 9a ff ff ff       	call   80104c70 <argfd.constprop.0>
80104cd6:	85 c0                	test   %eax,%eax
80104cd8:	78 1e                	js     80104cf8 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
80104cda:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104cdd:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104cdf:	e8 9c ec ff ff       	call   80103980 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104ce4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80104ce8:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104cec:	85 d2                	test   %edx,%edx
80104cee:	74 20                	je     80104d10 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80104cf0:	83 c3 01             	add    $0x1,%ebx
80104cf3:	83 fb 10             	cmp    $0x10,%ebx
80104cf6:	75 f0                	jne    80104ce8 <sys_dup+0x28>
}
80104cf8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104cfb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104d00:	89 d8                	mov    %ebx,%eax
80104d02:	5b                   	pop    %ebx
80104d03:	5e                   	pop    %esi
80104d04:	5d                   	pop    %ebp
80104d05:	c3                   	ret    
80104d06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d0d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80104d10:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104d14:	83 ec 0c             	sub    $0xc,%esp
80104d17:	ff 75 f4             	pushl  -0xc(%ebp)
80104d1a:	e8 71 c1 ff ff       	call   80100e90 <filedup>
  return fd;
80104d1f:	83 c4 10             	add    $0x10,%esp
}
80104d22:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d25:	89 d8                	mov    %ebx,%eax
80104d27:	5b                   	pop    %ebx
80104d28:	5e                   	pop    %esi
80104d29:	5d                   	pop    %ebp
80104d2a:	c3                   	ret    
80104d2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d2f:	90                   	nop

80104d30 <sys_read>:
{
80104d30:	f3 0f 1e fb          	endbr32 
80104d34:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d35:	31 c0                	xor    %eax,%eax
{
80104d37:	89 e5                	mov    %esp,%ebp
80104d39:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d3c:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104d3f:	e8 2c ff ff ff       	call   80104c70 <argfd.constprop.0>
80104d44:	85 c0                	test   %eax,%eax
80104d46:	78 48                	js     80104d90 <sys_read+0x60>
80104d48:	83 ec 08             	sub    $0x8,%esp
80104d4b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d4e:	50                   	push   %eax
80104d4f:	6a 02                	push   $0x2
80104d51:	e8 1a fc ff ff       	call   80104970 <argint>
80104d56:	83 c4 10             	add    $0x10,%esp
80104d59:	85 c0                	test   %eax,%eax
80104d5b:	78 33                	js     80104d90 <sys_read+0x60>
80104d5d:	83 ec 04             	sub    $0x4,%esp
80104d60:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d63:	ff 75 f0             	pushl  -0x10(%ebp)
80104d66:	50                   	push   %eax
80104d67:	6a 01                	push   $0x1
80104d69:	e8 52 fc ff ff       	call   801049c0 <argptr>
80104d6e:	83 c4 10             	add    $0x10,%esp
80104d71:	85 c0                	test   %eax,%eax
80104d73:	78 1b                	js     80104d90 <sys_read+0x60>
  return fileread(f, p, n);
80104d75:	83 ec 04             	sub    $0x4,%esp
80104d78:	ff 75 f0             	pushl  -0x10(%ebp)
80104d7b:	ff 75 f4             	pushl  -0xc(%ebp)
80104d7e:	ff 75 ec             	pushl  -0x14(%ebp)
80104d81:	e8 8a c2 ff ff       	call   80101010 <fileread>
80104d86:	83 c4 10             	add    $0x10,%esp
}
80104d89:	c9                   	leave  
80104d8a:	c3                   	ret    
80104d8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d8f:	90                   	nop
80104d90:	c9                   	leave  
    return -1;
80104d91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d96:	c3                   	ret    
80104d97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d9e:	66 90                	xchg   %ax,%ax

80104da0 <sys_write>:
{
80104da0:	f3 0f 1e fb          	endbr32 
80104da4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104da5:	31 c0                	xor    %eax,%eax
{
80104da7:	89 e5                	mov    %esp,%ebp
80104da9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104dac:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104daf:	e8 bc fe ff ff       	call   80104c70 <argfd.constprop.0>
80104db4:	85 c0                	test   %eax,%eax
80104db6:	78 48                	js     80104e00 <sys_write+0x60>
80104db8:	83 ec 08             	sub    $0x8,%esp
80104dbb:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104dbe:	50                   	push   %eax
80104dbf:	6a 02                	push   $0x2
80104dc1:	e8 aa fb ff ff       	call   80104970 <argint>
80104dc6:	83 c4 10             	add    $0x10,%esp
80104dc9:	85 c0                	test   %eax,%eax
80104dcb:	78 33                	js     80104e00 <sys_write+0x60>
80104dcd:	83 ec 04             	sub    $0x4,%esp
80104dd0:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104dd3:	ff 75 f0             	pushl  -0x10(%ebp)
80104dd6:	50                   	push   %eax
80104dd7:	6a 01                	push   $0x1
80104dd9:	e8 e2 fb ff ff       	call   801049c0 <argptr>
80104dde:	83 c4 10             	add    $0x10,%esp
80104de1:	85 c0                	test   %eax,%eax
80104de3:	78 1b                	js     80104e00 <sys_write+0x60>
  return filewrite(f, p, n);
80104de5:	83 ec 04             	sub    $0x4,%esp
80104de8:	ff 75 f0             	pushl  -0x10(%ebp)
80104deb:	ff 75 f4             	pushl  -0xc(%ebp)
80104dee:	ff 75 ec             	pushl  -0x14(%ebp)
80104df1:	e8 ba c2 ff ff       	call   801010b0 <filewrite>
80104df6:	83 c4 10             	add    $0x10,%esp
}
80104df9:	c9                   	leave  
80104dfa:	c3                   	ret    
80104dfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104dff:	90                   	nop
80104e00:	c9                   	leave  
    return -1;
80104e01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e06:	c3                   	ret    
80104e07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e0e:	66 90                	xchg   %ax,%ax

80104e10 <sys_close>:
{
80104e10:	f3 0f 1e fb          	endbr32 
80104e14:	55                   	push   %ebp
80104e15:	89 e5                	mov    %esp,%ebp
80104e17:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104e1a:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104e1d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e20:	e8 4b fe ff ff       	call   80104c70 <argfd.constprop.0>
80104e25:	85 c0                	test   %eax,%eax
80104e27:	78 27                	js     80104e50 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80104e29:	e8 52 eb ff ff       	call   80103980 <myproc>
80104e2e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104e31:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104e34:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104e3b:	00 
  fileclose(f);
80104e3c:	ff 75 f4             	pushl  -0xc(%ebp)
80104e3f:	e8 9c c0 ff ff       	call   80100ee0 <fileclose>
  return 0;
80104e44:	83 c4 10             	add    $0x10,%esp
80104e47:	31 c0                	xor    %eax,%eax
}
80104e49:	c9                   	leave  
80104e4a:	c3                   	ret    
80104e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e4f:	90                   	nop
80104e50:	c9                   	leave  
    return -1;
80104e51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e56:	c3                   	ret    
80104e57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e5e:	66 90                	xchg   %ax,%ax

80104e60 <sys_fstat>:
{
80104e60:	f3 0f 1e fb          	endbr32 
80104e64:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104e65:	31 c0                	xor    %eax,%eax
{
80104e67:	89 e5                	mov    %esp,%ebp
80104e69:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104e6c:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104e6f:	e8 fc fd ff ff       	call   80104c70 <argfd.constprop.0>
80104e74:	85 c0                	test   %eax,%eax
80104e76:	78 30                	js     80104ea8 <sys_fstat+0x48>
80104e78:	83 ec 04             	sub    $0x4,%esp
80104e7b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e7e:	6a 14                	push   $0x14
80104e80:	50                   	push   %eax
80104e81:	6a 01                	push   $0x1
80104e83:	e8 38 fb ff ff       	call   801049c0 <argptr>
80104e88:	83 c4 10             	add    $0x10,%esp
80104e8b:	85 c0                	test   %eax,%eax
80104e8d:	78 19                	js     80104ea8 <sys_fstat+0x48>
  return filestat(f, st);
80104e8f:	83 ec 08             	sub    $0x8,%esp
80104e92:	ff 75 f4             	pushl  -0xc(%ebp)
80104e95:	ff 75 f0             	pushl  -0x10(%ebp)
80104e98:	e8 23 c1 ff ff       	call   80100fc0 <filestat>
80104e9d:	83 c4 10             	add    $0x10,%esp
}
80104ea0:	c9                   	leave  
80104ea1:	c3                   	ret    
80104ea2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ea8:	c9                   	leave  
    return -1;
80104ea9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104eae:	c3                   	ret    
80104eaf:	90                   	nop

80104eb0 <sys_link>:
{
80104eb0:	f3 0f 1e fb          	endbr32 
80104eb4:	55                   	push   %ebp
80104eb5:	89 e5                	mov    %esp,%ebp
80104eb7:	57                   	push   %edi
80104eb8:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104eb9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104ebc:	53                   	push   %ebx
80104ebd:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104ec0:	50                   	push   %eax
80104ec1:	6a 00                	push   $0x0
80104ec3:	e8 58 fb ff ff       	call   80104a20 <argstr>
80104ec8:	83 c4 10             	add    $0x10,%esp
80104ecb:	85 c0                	test   %eax,%eax
80104ecd:	0f 88 ff 00 00 00    	js     80104fd2 <sys_link+0x122>
80104ed3:	83 ec 08             	sub    $0x8,%esp
80104ed6:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104ed9:	50                   	push   %eax
80104eda:	6a 01                	push   $0x1
80104edc:	e8 3f fb ff ff       	call   80104a20 <argstr>
80104ee1:	83 c4 10             	add    $0x10,%esp
80104ee4:	85 c0                	test   %eax,%eax
80104ee6:	0f 88 e6 00 00 00    	js     80104fd2 <sys_link+0x122>
  begin_op();
80104eec:	e8 5f de ff ff       	call   80102d50 <begin_op>
  if((ip = namei(old)) == 0){
80104ef1:	83 ec 0c             	sub    $0xc,%esp
80104ef4:	ff 75 d4             	pushl  -0x2c(%ebp)
80104ef7:	e8 54 d1 ff ff       	call   80102050 <namei>
80104efc:	83 c4 10             	add    $0x10,%esp
80104eff:	89 c3                	mov    %eax,%ebx
80104f01:	85 c0                	test   %eax,%eax
80104f03:	0f 84 e8 00 00 00    	je     80104ff1 <sys_link+0x141>
  ilock(ip);
80104f09:	83 ec 0c             	sub    $0xc,%esp
80104f0c:	50                   	push   %eax
80104f0d:	e8 6e c8 ff ff       	call   80101780 <ilock>
  if(ip->type == T_DIR){
80104f12:	83 c4 10             	add    $0x10,%esp
80104f15:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f1a:	0f 84 b9 00 00 00    	je     80104fd9 <sys_link+0x129>
  iupdate(ip);
80104f20:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80104f23:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80104f28:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104f2b:	53                   	push   %ebx
80104f2c:	e8 8f c7 ff ff       	call   801016c0 <iupdate>
  iunlock(ip);
80104f31:	89 1c 24             	mov    %ebx,(%esp)
80104f34:	e8 27 c9 ff ff       	call   80101860 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104f39:	58                   	pop    %eax
80104f3a:	5a                   	pop    %edx
80104f3b:	57                   	push   %edi
80104f3c:	ff 75 d0             	pushl  -0x30(%ebp)
80104f3f:	e8 2c d1 ff ff       	call   80102070 <nameiparent>
80104f44:	83 c4 10             	add    $0x10,%esp
80104f47:	89 c6                	mov    %eax,%esi
80104f49:	85 c0                	test   %eax,%eax
80104f4b:	74 5f                	je     80104fac <sys_link+0xfc>
  ilock(dp);
80104f4d:	83 ec 0c             	sub    $0xc,%esp
80104f50:	50                   	push   %eax
80104f51:	e8 2a c8 ff ff       	call   80101780 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104f56:	8b 03                	mov    (%ebx),%eax
80104f58:	83 c4 10             	add    $0x10,%esp
80104f5b:	39 06                	cmp    %eax,(%esi)
80104f5d:	75 41                	jne    80104fa0 <sys_link+0xf0>
80104f5f:	83 ec 04             	sub    $0x4,%esp
80104f62:	ff 73 04             	pushl  0x4(%ebx)
80104f65:	57                   	push   %edi
80104f66:	56                   	push   %esi
80104f67:	e8 24 d0 ff ff       	call   80101f90 <dirlink>
80104f6c:	83 c4 10             	add    $0x10,%esp
80104f6f:	85 c0                	test   %eax,%eax
80104f71:	78 2d                	js     80104fa0 <sys_link+0xf0>
  iunlockput(dp);
80104f73:	83 ec 0c             	sub    $0xc,%esp
80104f76:	56                   	push   %esi
80104f77:	e8 a4 ca ff ff       	call   80101a20 <iunlockput>
  iput(ip);
80104f7c:	89 1c 24             	mov    %ebx,(%esp)
80104f7f:	e8 2c c9 ff ff       	call   801018b0 <iput>
  end_op();
80104f84:	e8 37 de ff ff       	call   80102dc0 <end_op>
  return 0;
80104f89:	83 c4 10             	add    $0x10,%esp
80104f8c:	31 c0                	xor    %eax,%eax
}
80104f8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f91:	5b                   	pop    %ebx
80104f92:	5e                   	pop    %esi
80104f93:	5f                   	pop    %edi
80104f94:	5d                   	pop    %ebp
80104f95:	c3                   	ret    
80104f96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f9d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80104fa0:	83 ec 0c             	sub    $0xc,%esp
80104fa3:	56                   	push   %esi
80104fa4:	e8 77 ca ff ff       	call   80101a20 <iunlockput>
    goto bad;
80104fa9:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104fac:	83 ec 0c             	sub    $0xc,%esp
80104faf:	53                   	push   %ebx
80104fb0:	e8 cb c7 ff ff       	call   80101780 <ilock>
  ip->nlink--;
80104fb5:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104fba:	89 1c 24             	mov    %ebx,(%esp)
80104fbd:	e8 fe c6 ff ff       	call   801016c0 <iupdate>
  iunlockput(ip);
80104fc2:	89 1c 24             	mov    %ebx,(%esp)
80104fc5:	e8 56 ca ff ff       	call   80101a20 <iunlockput>
  end_op();
80104fca:	e8 f1 dd ff ff       	call   80102dc0 <end_op>
  return -1;
80104fcf:	83 c4 10             	add    $0x10,%esp
80104fd2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fd7:	eb b5                	jmp    80104f8e <sys_link+0xde>
    iunlockput(ip);
80104fd9:	83 ec 0c             	sub    $0xc,%esp
80104fdc:	53                   	push   %ebx
80104fdd:	e8 3e ca ff ff       	call   80101a20 <iunlockput>
    end_op();
80104fe2:	e8 d9 dd ff ff       	call   80102dc0 <end_op>
    return -1;
80104fe7:	83 c4 10             	add    $0x10,%esp
80104fea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fef:	eb 9d                	jmp    80104f8e <sys_link+0xde>
    end_op();
80104ff1:	e8 ca dd ff ff       	call   80102dc0 <end_op>
    return -1;
80104ff6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ffb:	eb 91                	jmp    80104f8e <sys_link+0xde>
80104ffd:	8d 76 00             	lea    0x0(%esi),%esi

80105000 <sys_unlink>:
{
80105000:	f3 0f 1e fb          	endbr32 
80105004:	55                   	push   %ebp
80105005:	89 e5                	mov    %esp,%ebp
80105007:	57                   	push   %edi
80105008:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105009:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
8010500c:	53                   	push   %ebx
8010500d:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80105010:	50                   	push   %eax
80105011:	6a 00                	push   $0x0
80105013:	e8 08 fa ff ff       	call   80104a20 <argstr>
80105018:	83 c4 10             	add    $0x10,%esp
8010501b:	85 c0                	test   %eax,%eax
8010501d:	0f 88 7d 01 00 00    	js     801051a0 <sys_unlink+0x1a0>
  begin_op();
80105023:	e8 28 dd ff ff       	call   80102d50 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105028:	8d 5d ca             	lea    -0x36(%ebp),%ebx
8010502b:	83 ec 08             	sub    $0x8,%esp
8010502e:	53                   	push   %ebx
8010502f:	ff 75 c0             	pushl  -0x40(%ebp)
80105032:	e8 39 d0 ff ff       	call   80102070 <nameiparent>
80105037:	83 c4 10             	add    $0x10,%esp
8010503a:	89 c6                	mov    %eax,%esi
8010503c:	85 c0                	test   %eax,%eax
8010503e:	0f 84 66 01 00 00    	je     801051aa <sys_unlink+0x1aa>
  ilock(dp);
80105044:	83 ec 0c             	sub    $0xc,%esp
80105047:	50                   	push   %eax
80105048:	e8 33 c7 ff ff       	call   80101780 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010504d:	58                   	pop    %eax
8010504e:	5a                   	pop    %edx
8010504f:	68 b8 78 10 80       	push   $0x801078b8
80105054:	53                   	push   %ebx
80105055:	e8 56 cc ff ff       	call   80101cb0 <namecmp>
8010505a:	83 c4 10             	add    $0x10,%esp
8010505d:	85 c0                	test   %eax,%eax
8010505f:	0f 84 03 01 00 00    	je     80105168 <sys_unlink+0x168>
80105065:	83 ec 08             	sub    $0x8,%esp
80105068:	68 b7 78 10 80       	push   $0x801078b7
8010506d:	53                   	push   %ebx
8010506e:	e8 3d cc ff ff       	call   80101cb0 <namecmp>
80105073:	83 c4 10             	add    $0x10,%esp
80105076:	85 c0                	test   %eax,%eax
80105078:	0f 84 ea 00 00 00    	je     80105168 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010507e:	83 ec 04             	sub    $0x4,%esp
80105081:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105084:	50                   	push   %eax
80105085:	53                   	push   %ebx
80105086:	56                   	push   %esi
80105087:	e8 44 cc ff ff       	call   80101cd0 <dirlookup>
8010508c:	83 c4 10             	add    $0x10,%esp
8010508f:	89 c3                	mov    %eax,%ebx
80105091:	85 c0                	test   %eax,%eax
80105093:	0f 84 cf 00 00 00    	je     80105168 <sys_unlink+0x168>
  ilock(ip);
80105099:	83 ec 0c             	sub    $0xc,%esp
8010509c:	50                   	push   %eax
8010509d:	e8 de c6 ff ff       	call   80101780 <ilock>
  if(ip->nlink < 1)
801050a2:	83 c4 10             	add    $0x10,%esp
801050a5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801050aa:	0f 8e 23 01 00 00    	jle    801051d3 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
801050b0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801050b5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801050b8:	74 66                	je     80105120 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801050ba:	83 ec 04             	sub    $0x4,%esp
801050bd:	6a 10                	push   $0x10
801050bf:	6a 00                	push   $0x0
801050c1:	57                   	push   %edi
801050c2:	e8 c9 f5 ff ff       	call   80104690 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801050c7:	6a 10                	push   $0x10
801050c9:	ff 75 c4             	pushl  -0x3c(%ebp)
801050cc:	57                   	push   %edi
801050cd:	56                   	push   %esi
801050ce:	e8 ad ca ff ff       	call   80101b80 <writei>
801050d3:	83 c4 20             	add    $0x20,%esp
801050d6:	83 f8 10             	cmp    $0x10,%eax
801050d9:	0f 85 e7 00 00 00    	jne    801051c6 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
801050df:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801050e4:	0f 84 96 00 00 00    	je     80105180 <sys_unlink+0x180>
  iunlockput(dp);
801050ea:	83 ec 0c             	sub    $0xc,%esp
801050ed:	56                   	push   %esi
801050ee:	e8 2d c9 ff ff       	call   80101a20 <iunlockput>
  ip->nlink--;
801050f3:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801050f8:	89 1c 24             	mov    %ebx,(%esp)
801050fb:	e8 c0 c5 ff ff       	call   801016c0 <iupdate>
  iunlockput(ip);
80105100:	89 1c 24             	mov    %ebx,(%esp)
80105103:	e8 18 c9 ff ff       	call   80101a20 <iunlockput>
  end_op();
80105108:	e8 b3 dc ff ff       	call   80102dc0 <end_op>
  return 0;
8010510d:	83 c4 10             	add    $0x10,%esp
80105110:	31 c0                	xor    %eax,%eax
}
80105112:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105115:	5b                   	pop    %ebx
80105116:	5e                   	pop    %esi
80105117:	5f                   	pop    %edi
80105118:	5d                   	pop    %ebp
80105119:	c3                   	ret    
8010511a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105120:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105124:	76 94                	jbe    801050ba <sys_unlink+0xba>
80105126:	ba 20 00 00 00       	mov    $0x20,%edx
8010512b:	eb 0b                	jmp    80105138 <sys_unlink+0x138>
8010512d:	8d 76 00             	lea    0x0(%esi),%esi
80105130:	83 c2 10             	add    $0x10,%edx
80105133:	39 53 58             	cmp    %edx,0x58(%ebx)
80105136:	76 82                	jbe    801050ba <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105138:	6a 10                	push   $0x10
8010513a:	52                   	push   %edx
8010513b:	57                   	push   %edi
8010513c:	53                   	push   %ebx
8010513d:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80105140:	e8 3b c9 ff ff       	call   80101a80 <readi>
80105145:	83 c4 10             	add    $0x10,%esp
80105148:	8b 55 b4             	mov    -0x4c(%ebp),%edx
8010514b:	83 f8 10             	cmp    $0x10,%eax
8010514e:	75 69                	jne    801051b9 <sys_unlink+0x1b9>
    if(de.inum != 0)
80105150:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105155:	74 d9                	je     80105130 <sys_unlink+0x130>
    iunlockput(ip);
80105157:	83 ec 0c             	sub    $0xc,%esp
8010515a:	53                   	push   %ebx
8010515b:	e8 c0 c8 ff ff       	call   80101a20 <iunlockput>
    goto bad;
80105160:	83 c4 10             	add    $0x10,%esp
80105163:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105167:	90                   	nop
  iunlockput(dp);
80105168:	83 ec 0c             	sub    $0xc,%esp
8010516b:	56                   	push   %esi
8010516c:	e8 af c8 ff ff       	call   80101a20 <iunlockput>
  end_op();
80105171:	e8 4a dc ff ff       	call   80102dc0 <end_op>
  return -1;
80105176:	83 c4 10             	add    $0x10,%esp
80105179:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010517e:	eb 92                	jmp    80105112 <sys_unlink+0x112>
    iupdate(dp);
80105180:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105183:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105188:	56                   	push   %esi
80105189:	e8 32 c5 ff ff       	call   801016c0 <iupdate>
8010518e:	83 c4 10             	add    $0x10,%esp
80105191:	e9 54 ff ff ff       	jmp    801050ea <sys_unlink+0xea>
80105196:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010519d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801051a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051a5:	e9 68 ff ff ff       	jmp    80105112 <sys_unlink+0x112>
    end_op();
801051aa:	e8 11 dc ff ff       	call   80102dc0 <end_op>
    return -1;
801051af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051b4:	e9 59 ff ff ff       	jmp    80105112 <sys_unlink+0x112>
      panic("isdirempty: readi");
801051b9:	83 ec 0c             	sub    $0xc,%esp
801051bc:	68 dc 78 10 80       	push   $0x801078dc
801051c1:	e8 ca b1 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
801051c6:	83 ec 0c             	sub    $0xc,%esp
801051c9:	68 ee 78 10 80       	push   $0x801078ee
801051ce:	e8 bd b1 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801051d3:	83 ec 0c             	sub    $0xc,%esp
801051d6:	68 ca 78 10 80       	push   $0x801078ca
801051db:	e8 b0 b1 ff ff       	call   80100390 <panic>

801051e0 <sys_open>:

int
sys_open(void)
{
801051e0:	f3 0f 1e fb          	endbr32 
801051e4:	55                   	push   %ebp
801051e5:	89 e5                	mov    %esp,%ebp
801051e7:	57                   	push   %edi
801051e8:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801051e9:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801051ec:	53                   	push   %ebx
801051ed:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801051f0:	50                   	push   %eax
801051f1:	6a 00                	push   $0x0
801051f3:	e8 28 f8 ff ff       	call   80104a20 <argstr>
801051f8:	83 c4 10             	add    $0x10,%esp
801051fb:	85 c0                	test   %eax,%eax
801051fd:	0f 88 8a 00 00 00    	js     8010528d <sys_open+0xad>
80105203:	83 ec 08             	sub    $0x8,%esp
80105206:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105209:	50                   	push   %eax
8010520a:	6a 01                	push   $0x1
8010520c:	e8 5f f7 ff ff       	call   80104970 <argint>
80105211:	83 c4 10             	add    $0x10,%esp
80105214:	85 c0                	test   %eax,%eax
80105216:	78 75                	js     8010528d <sys_open+0xad>
    return -1;

  begin_op();
80105218:	e8 33 db ff ff       	call   80102d50 <begin_op>

  if(omode & O_CREATE){
8010521d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105221:	75 75                	jne    80105298 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105223:	83 ec 0c             	sub    $0xc,%esp
80105226:	ff 75 e0             	pushl  -0x20(%ebp)
80105229:	e8 22 ce ff ff       	call   80102050 <namei>
8010522e:	83 c4 10             	add    $0x10,%esp
80105231:	89 c6                	mov    %eax,%esi
80105233:	85 c0                	test   %eax,%eax
80105235:	74 7e                	je     801052b5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105237:	83 ec 0c             	sub    $0xc,%esp
8010523a:	50                   	push   %eax
8010523b:	e8 40 c5 ff ff       	call   80101780 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105240:	83 c4 10             	add    $0x10,%esp
80105243:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105248:	0f 84 c2 00 00 00    	je     80105310 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010524e:	e8 cd bb ff ff       	call   80100e20 <filealloc>
80105253:	89 c7                	mov    %eax,%edi
80105255:	85 c0                	test   %eax,%eax
80105257:	74 23                	je     8010527c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105259:	e8 22 e7 ff ff       	call   80103980 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010525e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105260:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105264:	85 d2                	test   %edx,%edx
80105266:	74 60                	je     801052c8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105268:	83 c3 01             	add    $0x1,%ebx
8010526b:	83 fb 10             	cmp    $0x10,%ebx
8010526e:	75 f0                	jne    80105260 <sys_open+0x80>
    if(f)
      fileclose(f);
80105270:	83 ec 0c             	sub    $0xc,%esp
80105273:	57                   	push   %edi
80105274:	e8 67 bc ff ff       	call   80100ee0 <fileclose>
80105279:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010527c:	83 ec 0c             	sub    $0xc,%esp
8010527f:	56                   	push   %esi
80105280:	e8 9b c7 ff ff       	call   80101a20 <iunlockput>
    end_op();
80105285:	e8 36 db ff ff       	call   80102dc0 <end_op>
    return -1;
8010528a:	83 c4 10             	add    $0x10,%esp
8010528d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105292:	eb 6d                	jmp    80105301 <sys_open+0x121>
80105294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105298:	83 ec 0c             	sub    $0xc,%esp
8010529b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010529e:	31 c9                	xor    %ecx,%ecx
801052a0:	ba 02 00 00 00       	mov    $0x2,%edx
801052a5:	6a 00                	push   $0x0
801052a7:	e8 24 f8 ff ff       	call   80104ad0 <create>
    if(ip == 0){
801052ac:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801052af:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801052b1:	85 c0                	test   %eax,%eax
801052b3:	75 99                	jne    8010524e <sys_open+0x6e>
      end_op();
801052b5:	e8 06 db ff ff       	call   80102dc0 <end_op>
      return -1;
801052ba:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801052bf:	eb 40                	jmp    80105301 <sys_open+0x121>
801052c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801052c8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801052cb:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801052cf:	56                   	push   %esi
801052d0:	e8 8b c5 ff ff       	call   80101860 <iunlock>
  end_op();
801052d5:	e8 e6 da ff ff       	call   80102dc0 <end_op>

  f->type = FD_INODE;
801052da:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801052e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801052e3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801052e6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801052e9:	89 d0                	mov    %edx,%eax
  f->off = 0;
801052eb:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801052f2:	f7 d0                	not    %eax
801052f4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801052f7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801052fa:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801052fd:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105301:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105304:	89 d8                	mov    %ebx,%eax
80105306:	5b                   	pop    %ebx
80105307:	5e                   	pop    %esi
80105308:	5f                   	pop    %edi
80105309:	5d                   	pop    %ebp
8010530a:	c3                   	ret    
8010530b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010530f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105310:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105313:	85 c9                	test   %ecx,%ecx
80105315:	0f 84 33 ff ff ff    	je     8010524e <sys_open+0x6e>
8010531b:	e9 5c ff ff ff       	jmp    8010527c <sys_open+0x9c>

80105320 <sys_mkdir>:

int
sys_mkdir(void)
{
80105320:	f3 0f 1e fb          	endbr32 
80105324:	55                   	push   %ebp
80105325:	89 e5                	mov    %esp,%ebp
80105327:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010532a:	e8 21 da ff ff       	call   80102d50 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010532f:	83 ec 08             	sub    $0x8,%esp
80105332:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105335:	50                   	push   %eax
80105336:	6a 00                	push   $0x0
80105338:	e8 e3 f6 ff ff       	call   80104a20 <argstr>
8010533d:	83 c4 10             	add    $0x10,%esp
80105340:	85 c0                	test   %eax,%eax
80105342:	78 34                	js     80105378 <sys_mkdir+0x58>
80105344:	83 ec 0c             	sub    $0xc,%esp
80105347:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010534a:	31 c9                	xor    %ecx,%ecx
8010534c:	ba 01 00 00 00       	mov    $0x1,%edx
80105351:	6a 00                	push   $0x0
80105353:	e8 78 f7 ff ff       	call   80104ad0 <create>
80105358:	83 c4 10             	add    $0x10,%esp
8010535b:	85 c0                	test   %eax,%eax
8010535d:	74 19                	je     80105378 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010535f:	83 ec 0c             	sub    $0xc,%esp
80105362:	50                   	push   %eax
80105363:	e8 b8 c6 ff ff       	call   80101a20 <iunlockput>
  end_op();
80105368:	e8 53 da ff ff       	call   80102dc0 <end_op>
  return 0;
8010536d:	83 c4 10             	add    $0x10,%esp
80105370:	31 c0                	xor    %eax,%eax
}
80105372:	c9                   	leave  
80105373:	c3                   	ret    
80105374:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105378:	e8 43 da ff ff       	call   80102dc0 <end_op>
    return -1;
8010537d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105382:	c9                   	leave  
80105383:	c3                   	ret    
80105384:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010538b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010538f:	90                   	nop

80105390 <sys_mknod>:

int
sys_mknod(void)
{
80105390:	f3 0f 1e fb          	endbr32 
80105394:	55                   	push   %ebp
80105395:	89 e5                	mov    %esp,%ebp
80105397:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
8010539a:	e8 b1 d9 ff ff       	call   80102d50 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010539f:	83 ec 08             	sub    $0x8,%esp
801053a2:	8d 45 ec             	lea    -0x14(%ebp),%eax
801053a5:	50                   	push   %eax
801053a6:	6a 00                	push   $0x0
801053a8:	e8 73 f6 ff ff       	call   80104a20 <argstr>
801053ad:	83 c4 10             	add    $0x10,%esp
801053b0:	85 c0                	test   %eax,%eax
801053b2:	78 64                	js     80105418 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
801053b4:	83 ec 08             	sub    $0x8,%esp
801053b7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053ba:	50                   	push   %eax
801053bb:	6a 01                	push   $0x1
801053bd:	e8 ae f5 ff ff       	call   80104970 <argint>
  if((argstr(0, &path)) < 0 ||
801053c2:	83 c4 10             	add    $0x10,%esp
801053c5:	85 c0                	test   %eax,%eax
801053c7:	78 4f                	js     80105418 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
801053c9:	83 ec 08             	sub    $0x8,%esp
801053cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053cf:	50                   	push   %eax
801053d0:	6a 02                	push   $0x2
801053d2:	e8 99 f5 ff ff       	call   80104970 <argint>
     argint(1, &major) < 0 ||
801053d7:	83 c4 10             	add    $0x10,%esp
801053da:	85 c0                	test   %eax,%eax
801053dc:	78 3a                	js     80105418 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
801053de:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801053e2:	83 ec 0c             	sub    $0xc,%esp
801053e5:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801053e9:	ba 03 00 00 00       	mov    $0x3,%edx
801053ee:	50                   	push   %eax
801053ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
801053f2:	e8 d9 f6 ff ff       	call   80104ad0 <create>
     argint(2, &minor) < 0 ||
801053f7:	83 c4 10             	add    $0x10,%esp
801053fa:	85 c0                	test   %eax,%eax
801053fc:	74 1a                	je     80105418 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
801053fe:	83 ec 0c             	sub    $0xc,%esp
80105401:	50                   	push   %eax
80105402:	e8 19 c6 ff ff       	call   80101a20 <iunlockput>
  end_op();
80105407:	e8 b4 d9 ff ff       	call   80102dc0 <end_op>
  return 0;
8010540c:	83 c4 10             	add    $0x10,%esp
8010540f:	31 c0                	xor    %eax,%eax
}
80105411:	c9                   	leave  
80105412:	c3                   	ret    
80105413:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105417:	90                   	nop
    end_op();
80105418:	e8 a3 d9 ff ff       	call   80102dc0 <end_op>
    return -1;
8010541d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105422:	c9                   	leave  
80105423:	c3                   	ret    
80105424:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010542b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010542f:	90                   	nop

80105430 <sys_chdir>:

int
sys_chdir(void)
{
80105430:	f3 0f 1e fb          	endbr32 
80105434:	55                   	push   %ebp
80105435:	89 e5                	mov    %esp,%ebp
80105437:	56                   	push   %esi
80105438:	53                   	push   %ebx
80105439:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
8010543c:	e8 3f e5 ff ff       	call   80103980 <myproc>
80105441:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105443:	e8 08 d9 ff ff       	call   80102d50 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105448:	83 ec 08             	sub    $0x8,%esp
8010544b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010544e:	50                   	push   %eax
8010544f:	6a 00                	push   $0x0
80105451:	e8 ca f5 ff ff       	call   80104a20 <argstr>
80105456:	83 c4 10             	add    $0x10,%esp
80105459:	85 c0                	test   %eax,%eax
8010545b:	78 73                	js     801054d0 <sys_chdir+0xa0>
8010545d:	83 ec 0c             	sub    $0xc,%esp
80105460:	ff 75 f4             	pushl  -0xc(%ebp)
80105463:	e8 e8 cb ff ff       	call   80102050 <namei>
80105468:	83 c4 10             	add    $0x10,%esp
8010546b:	89 c3                	mov    %eax,%ebx
8010546d:	85 c0                	test   %eax,%eax
8010546f:	74 5f                	je     801054d0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105471:	83 ec 0c             	sub    $0xc,%esp
80105474:	50                   	push   %eax
80105475:	e8 06 c3 ff ff       	call   80101780 <ilock>
  if(ip->type != T_DIR){
8010547a:	83 c4 10             	add    $0x10,%esp
8010547d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105482:	75 2c                	jne    801054b0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105484:	83 ec 0c             	sub    $0xc,%esp
80105487:	53                   	push   %ebx
80105488:	e8 d3 c3 ff ff       	call   80101860 <iunlock>
  iput(curproc->cwd);
8010548d:	58                   	pop    %eax
8010548e:	ff 76 68             	pushl  0x68(%esi)
80105491:	e8 1a c4 ff ff       	call   801018b0 <iput>
  end_op();
80105496:	e8 25 d9 ff ff       	call   80102dc0 <end_op>
  curproc->cwd = ip;
8010549b:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010549e:	83 c4 10             	add    $0x10,%esp
801054a1:	31 c0                	xor    %eax,%eax
}
801054a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054a6:	5b                   	pop    %ebx
801054a7:	5e                   	pop    %esi
801054a8:	5d                   	pop    %ebp
801054a9:	c3                   	ret    
801054aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
801054b0:	83 ec 0c             	sub    $0xc,%esp
801054b3:	53                   	push   %ebx
801054b4:	e8 67 c5 ff ff       	call   80101a20 <iunlockput>
    end_op();
801054b9:	e8 02 d9 ff ff       	call   80102dc0 <end_op>
    return -1;
801054be:	83 c4 10             	add    $0x10,%esp
801054c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054c6:	eb db                	jmp    801054a3 <sys_chdir+0x73>
801054c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054cf:	90                   	nop
    end_op();
801054d0:	e8 eb d8 ff ff       	call   80102dc0 <end_op>
    return -1;
801054d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054da:	eb c7                	jmp    801054a3 <sys_chdir+0x73>
801054dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801054e0 <sys_exec>:

int
sys_exec(void)
{
801054e0:	f3 0f 1e fb          	endbr32 
801054e4:	55                   	push   %ebp
801054e5:	89 e5                	mov    %esp,%ebp
801054e7:	57                   	push   %edi
801054e8:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801054e9:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801054ef:	53                   	push   %ebx
801054f0:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801054f6:	50                   	push   %eax
801054f7:	6a 00                	push   $0x0
801054f9:	e8 22 f5 ff ff       	call   80104a20 <argstr>
801054fe:	83 c4 10             	add    $0x10,%esp
80105501:	85 c0                	test   %eax,%eax
80105503:	0f 88 8b 00 00 00    	js     80105594 <sys_exec+0xb4>
80105509:	83 ec 08             	sub    $0x8,%esp
8010550c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105512:	50                   	push   %eax
80105513:	6a 01                	push   $0x1
80105515:	e8 56 f4 ff ff       	call   80104970 <argint>
8010551a:	83 c4 10             	add    $0x10,%esp
8010551d:	85 c0                	test   %eax,%eax
8010551f:	78 73                	js     80105594 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105521:	83 ec 04             	sub    $0x4,%esp
80105524:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
8010552a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
8010552c:	68 80 00 00 00       	push   $0x80
80105531:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105537:	6a 00                	push   $0x0
80105539:	50                   	push   %eax
8010553a:	e8 51 f1 ff ff       	call   80104690 <memset>
8010553f:	83 c4 10             	add    $0x10,%esp
80105542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105548:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
8010554e:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105555:	83 ec 08             	sub    $0x8,%esp
80105558:	57                   	push   %edi
80105559:	01 f0                	add    %esi,%eax
8010555b:	50                   	push   %eax
8010555c:	e8 6f f3 ff ff       	call   801048d0 <fetchint>
80105561:	83 c4 10             	add    $0x10,%esp
80105564:	85 c0                	test   %eax,%eax
80105566:	78 2c                	js     80105594 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80105568:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010556e:	85 c0                	test   %eax,%eax
80105570:	74 36                	je     801055a8 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105572:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105578:	83 ec 08             	sub    $0x8,%esp
8010557b:	8d 14 31             	lea    (%ecx,%esi,1),%edx
8010557e:	52                   	push   %edx
8010557f:	50                   	push   %eax
80105580:	e8 8b f3 ff ff       	call   80104910 <fetchstr>
80105585:	83 c4 10             	add    $0x10,%esp
80105588:	85 c0                	test   %eax,%eax
8010558a:	78 08                	js     80105594 <sys_exec+0xb4>
  for(i=0;; i++){
8010558c:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
8010558f:	83 fb 20             	cmp    $0x20,%ebx
80105592:	75 b4                	jne    80105548 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80105594:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105597:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010559c:	5b                   	pop    %ebx
8010559d:	5e                   	pop    %esi
8010559e:	5f                   	pop    %edi
8010559f:	5d                   	pop    %ebp
801055a0:	c3                   	ret    
801055a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
801055a8:	83 ec 08             	sub    $0x8,%esp
801055ab:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
801055b1:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801055b8:	00 00 00 00 
  return exec(path, argv);
801055bc:	50                   	push   %eax
801055bd:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801055c3:	e8 d8 b4 ff ff       	call   80100aa0 <exec>
801055c8:	83 c4 10             	add    $0x10,%esp
}
801055cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055ce:	5b                   	pop    %ebx
801055cf:	5e                   	pop    %esi
801055d0:	5f                   	pop    %edi
801055d1:	5d                   	pop    %ebp
801055d2:	c3                   	ret    
801055d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801055e0 <sys_pipe>:

int
sys_pipe(void)
{
801055e0:	f3 0f 1e fb          	endbr32 
801055e4:	55                   	push   %ebp
801055e5:	89 e5                	mov    %esp,%ebp
801055e7:	57                   	push   %edi
801055e8:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801055e9:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801055ec:	53                   	push   %ebx
801055ed:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801055f0:	6a 08                	push   $0x8
801055f2:	50                   	push   %eax
801055f3:	6a 00                	push   $0x0
801055f5:	e8 c6 f3 ff ff       	call   801049c0 <argptr>
801055fa:	83 c4 10             	add    $0x10,%esp
801055fd:	85 c0                	test   %eax,%eax
801055ff:	78 4e                	js     8010564f <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105601:	83 ec 08             	sub    $0x8,%esp
80105604:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105607:	50                   	push   %eax
80105608:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010560b:	50                   	push   %eax
8010560c:	e8 ff dd ff ff       	call   80103410 <pipealloc>
80105611:	83 c4 10             	add    $0x10,%esp
80105614:	85 c0                	test   %eax,%eax
80105616:	78 37                	js     8010564f <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105618:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010561b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010561d:	e8 5e e3 ff ff       	call   80103980 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105628:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010562c:	85 f6                	test   %esi,%esi
8010562e:	74 30                	je     80105660 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80105630:	83 c3 01             	add    $0x1,%ebx
80105633:	83 fb 10             	cmp    $0x10,%ebx
80105636:	75 f0                	jne    80105628 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105638:	83 ec 0c             	sub    $0xc,%esp
8010563b:	ff 75 e0             	pushl  -0x20(%ebp)
8010563e:	e8 9d b8 ff ff       	call   80100ee0 <fileclose>
    fileclose(wf);
80105643:	58                   	pop    %eax
80105644:	ff 75 e4             	pushl  -0x1c(%ebp)
80105647:	e8 94 b8 ff ff       	call   80100ee0 <fileclose>
    return -1;
8010564c:	83 c4 10             	add    $0x10,%esp
8010564f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105654:	eb 5b                	jmp    801056b1 <sys_pipe+0xd1>
80105656:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010565d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105660:	8d 73 08             	lea    0x8(%ebx),%esi
80105663:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105667:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010566a:	e8 11 e3 ff ff       	call   80103980 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010566f:	31 d2                	xor    %edx,%edx
80105671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105678:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010567c:	85 c9                	test   %ecx,%ecx
8010567e:	74 20                	je     801056a0 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105680:	83 c2 01             	add    $0x1,%edx
80105683:	83 fa 10             	cmp    $0x10,%edx
80105686:	75 f0                	jne    80105678 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105688:	e8 f3 e2 ff ff       	call   80103980 <myproc>
8010568d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105694:	00 
80105695:	eb a1                	jmp    80105638 <sys_pipe+0x58>
80105697:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010569e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801056a0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
801056a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801056a7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801056a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801056ac:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801056af:	31 c0                	xor    %eax,%eax
}
801056b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056b4:	5b                   	pop    %ebx
801056b5:	5e                   	pop    %esi
801056b6:	5f                   	pop    %edi
801056b7:	5d                   	pop    %ebp
801056b8:	c3                   	ret    
801056b9:	66 90                	xchg   %ax,%ax
801056bb:	66 90                	xchg   %ax,%ax
801056bd:	66 90                	xchg   %ax,%ax
801056bf:	90                   	nop

801056c0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801056c0:	f3 0f 1e fb          	endbr32 
  return fork();
801056c4:	e9 67 e4 ff ff       	jmp    80103b30 <fork>
801056c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801056d0 <sys_exit>:
}

int
sys_exit(void)
{
801056d0:	f3 0f 1e fb          	endbr32 
801056d4:	55                   	push   %ebp
801056d5:	89 e5                	mov    %esp,%ebp
801056d7:	83 ec 20             	sub    $0x20,%esp
  int exit_status;
  argint(0, &exit_status);
801056da:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056dd:	50                   	push   %eax
801056de:	6a 00                	push   $0x0
801056e0:	e8 8b f2 ff ff       	call   80104970 <argint>
  exit(exit_status);
801056e5:	58                   	pop    %eax
801056e6:	ff 75 f4             	pushl  -0xc(%ebp)
801056e9:	e8 c2 e6 ff ff       	call   80103db0 <exit>
  return 0;  // not reached
}
801056ee:	31 c0                	xor    %eax,%eax
801056f0:	c9                   	leave  
801056f1:	c3                   	ret    
801056f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105700 <sys_wait>:

int
sys_wait(void)
{
80105700:	f3 0f 1e fb          	endbr32 
80105704:	55                   	push   %ebp
80105705:	89 e5                	mov    %esp,%ebp
80105707:	83 ec 1c             	sub    $0x1c,%esp
  char *status_ptr;
  argptr(0, &status_ptr, 4);
8010570a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010570d:	6a 04                	push   $0x4
8010570f:	50                   	push   %eax
80105710:	6a 00                	push   $0x0
80105712:	e8 a9 f2 ff ff       	call   801049c0 <argptr>
  return wait((int*)status_ptr);
80105717:	58                   	pop    %eax
80105718:	ff 75 f4             	pushl  -0xc(%ebp)
8010571b:	e8 e0 e8 ff ff       	call   80104000 <wait>
}
80105720:	c9                   	leave  
80105721:	c3                   	ret    
80105722:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105730 <sys_kill>:

int
sys_kill(void)
{
80105730:	f3 0f 1e fb          	endbr32 
80105734:	55                   	push   %ebp
80105735:	89 e5                	mov    %esp,%ebp
80105737:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010573a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010573d:	50                   	push   %eax
8010573e:	6a 00                	push   $0x0
80105740:	e8 2b f2 ff ff       	call   80104970 <argint>
80105745:	83 c4 10             	add    $0x10,%esp
80105748:	85 c0                	test   %eax,%eax
8010574a:	78 14                	js     80105760 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010574c:	83 ec 0c             	sub    $0xc,%esp
8010574f:	ff 75 f4             	pushl  -0xc(%ebp)
80105752:	e8 09 ea ff ff       	call   80104160 <kill>
80105757:	83 c4 10             	add    $0x10,%esp
}
8010575a:	c9                   	leave  
8010575b:	c3                   	ret    
8010575c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105760:	c9                   	leave  
    return -1;
80105761:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105766:	c3                   	ret    
80105767:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010576e:	66 90                	xchg   %ax,%ax

80105770 <sys_getpid>:

int
sys_getpid(void)
{
80105770:	f3 0f 1e fb          	endbr32 
80105774:	55                   	push   %ebp
80105775:	89 e5                	mov    %esp,%ebp
80105777:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
8010577a:	e8 01 e2 ff ff       	call   80103980 <myproc>
8010577f:	8b 40 10             	mov    0x10(%eax),%eax
}
80105782:	c9                   	leave  
80105783:	c3                   	ret    
80105784:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010578b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010578f:	90                   	nop

80105790 <sys_sbrk>:

int
sys_sbrk(void)
{
80105790:	f3 0f 1e fb          	endbr32 
80105794:	55                   	push   %ebp
80105795:	89 e5                	mov    %esp,%ebp
80105797:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105798:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010579b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010579e:	50                   	push   %eax
8010579f:	6a 00                	push   $0x0
801057a1:	e8 ca f1 ff ff       	call   80104970 <argint>
801057a6:	83 c4 10             	add    $0x10,%esp
801057a9:	85 c0                	test   %eax,%eax
801057ab:	78 23                	js     801057d0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801057ad:	e8 ce e1 ff ff       	call   80103980 <myproc>
  if(growproc(n) < 0)
801057b2:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801057b5:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801057b7:	ff 75 f4             	pushl  -0xc(%ebp)
801057ba:	e8 f1 e2 ff ff       	call   80103ab0 <growproc>
801057bf:	83 c4 10             	add    $0x10,%esp
801057c2:	85 c0                	test   %eax,%eax
801057c4:	78 0a                	js     801057d0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801057c6:	89 d8                	mov    %ebx,%eax
801057c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801057cb:	c9                   	leave  
801057cc:	c3                   	ret    
801057cd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801057d0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801057d5:	eb ef                	jmp    801057c6 <sys_sbrk+0x36>
801057d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057de:	66 90                	xchg   %ax,%ax

801057e0 <sys_sleep>:

int
sys_sleep(void)
{
801057e0:	f3 0f 1e fb          	endbr32 
801057e4:	55                   	push   %ebp
801057e5:	89 e5                	mov    %esp,%ebp
801057e7:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801057e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801057eb:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801057ee:	50                   	push   %eax
801057ef:	6a 00                	push   $0x0
801057f1:	e8 7a f1 ff ff       	call   80104970 <argint>
801057f6:	83 c4 10             	add    $0x10,%esp
801057f9:	85 c0                	test   %eax,%eax
801057fb:	0f 88 86 00 00 00    	js     80105887 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105801:	83 ec 0c             	sub    $0xc,%esp
80105804:	68 60 4d 11 80       	push   $0x80114d60
80105809:	e8 72 ed ff ff       	call   80104580 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010580e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105811:	8b 1d a0 55 11 80    	mov    0x801155a0,%ebx
  while(ticks - ticks0 < n){
80105817:	83 c4 10             	add    $0x10,%esp
8010581a:	85 d2                	test   %edx,%edx
8010581c:	75 23                	jne    80105841 <sys_sleep+0x61>
8010581e:	eb 50                	jmp    80105870 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105820:	83 ec 08             	sub    $0x8,%esp
80105823:	68 60 4d 11 80       	push   $0x80114d60
80105828:	68 a0 55 11 80       	push   $0x801155a0
8010582d:	e8 0e e7 ff ff       	call   80103f40 <sleep>
  while(ticks - ticks0 < n){
80105832:	a1 a0 55 11 80       	mov    0x801155a0,%eax
80105837:	83 c4 10             	add    $0x10,%esp
8010583a:	29 d8                	sub    %ebx,%eax
8010583c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010583f:	73 2f                	jae    80105870 <sys_sleep+0x90>
    if(myproc()->killed){
80105841:	e8 3a e1 ff ff       	call   80103980 <myproc>
80105846:	8b 40 24             	mov    0x24(%eax),%eax
80105849:	85 c0                	test   %eax,%eax
8010584b:	74 d3                	je     80105820 <sys_sleep+0x40>
      release(&tickslock);
8010584d:	83 ec 0c             	sub    $0xc,%esp
80105850:	68 60 4d 11 80       	push   $0x80114d60
80105855:	e8 e6 ed ff ff       	call   80104640 <release>
  }
  release(&tickslock);
  return 0;
}
8010585a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010585d:	83 c4 10             	add    $0x10,%esp
80105860:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105865:	c9                   	leave  
80105866:	c3                   	ret    
80105867:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010586e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105870:	83 ec 0c             	sub    $0xc,%esp
80105873:	68 60 4d 11 80       	push   $0x80114d60
80105878:	e8 c3 ed ff ff       	call   80104640 <release>
  return 0;
8010587d:	83 c4 10             	add    $0x10,%esp
80105880:	31 c0                	xor    %eax,%eax
}
80105882:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105885:	c9                   	leave  
80105886:	c3                   	ret    
    return -1;
80105887:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010588c:	eb f4                	jmp    80105882 <sys_sleep+0xa2>
8010588e:	66 90                	xchg   %ax,%ax

80105890 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105890:	f3 0f 1e fb          	endbr32 
80105894:	55                   	push   %ebp
80105895:	89 e5                	mov    %esp,%ebp
80105897:	53                   	push   %ebx
80105898:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
8010589b:	68 60 4d 11 80       	push   $0x80114d60
801058a0:	e8 db ec ff ff       	call   80104580 <acquire>
  xticks = ticks;
801058a5:	8b 1d a0 55 11 80    	mov    0x801155a0,%ebx
  release(&tickslock);
801058ab:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
801058b2:	e8 89 ed ff ff       	call   80104640 <release>
  return xticks;
}
801058b7:	89 d8                	mov    %ebx,%eax
801058b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058bc:	c9                   	leave  
801058bd:	c3                   	ret    
801058be:	66 90                	xchg   %ax,%ax

801058c0 <sys_memsize>:

int sys_memsize(void){
801058c0:	f3 0f 1e fb          	endbr32 
801058c4:	55                   	push   %ebp
801058c5:	89 e5                	mov    %esp,%ebp
801058c7:	83 ec 08             	sub    $0x8,%esp
  return myproc()->sz;
801058ca:	e8 b1 e0 ff ff       	call   80103980 <myproc>
801058cf:	8b 00                	mov    (%eax),%eax
}
801058d1:	c9                   	leave  
801058d2:	c3                   	ret    

801058d3 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801058d3:	1e                   	push   %ds
  pushl %es
801058d4:	06                   	push   %es
  pushl %fs
801058d5:	0f a0                	push   %fs
  pushl %gs
801058d7:	0f a8                	push   %gs
  pushal
801058d9:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801058da:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801058de:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801058e0:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801058e2:	54                   	push   %esp
  call trap
801058e3:	e8 c8 00 00 00       	call   801059b0 <trap>
  addl $4, %esp
801058e8:	83 c4 04             	add    $0x4,%esp

801058eb <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801058eb:	61                   	popa   
  popl %gs
801058ec:	0f a9                	pop    %gs
  popl %fs
801058ee:	0f a1                	pop    %fs
  popl %es
801058f0:	07                   	pop    %es
  popl %ds
801058f1:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801058f2:	83 c4 08             	add    $0x8,%esp
  iret
801058f5:	cf                   	iret   
801058f6:	66 90                	xchg   %ax,%ax
801058f8:	66 90                	xchg   %ax,%ax
801058fa:	66 90                	xchg   %ax,%ax
801058fc:	66 90                	xchg   %ax,%ax
801058fe:	66 90                	xchg   %ax,%ax

80105900 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105900:	f3 0f 1e fb          	endbr32 
80105904:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105905:	31 c0                	xor    %eax,%eax
{
80105907:	89 e5                	mov    %esp,%ebp
80105909:	83 ec 08             	sub    $0x8,%esp
8010590c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105910:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105917:	c7 04 c5 a2 4d 11 80 	movl   $0x8e000008,-0x7feeb25e(,%eax,8)
8010591e:	08 00 00 8e 
80105922:	66 89 14 c5 a0 4d 11 	mov    %dx,-0x7feeb260(,%eax,8)
80105929:	80 
8010592a:	c1 ea 10             	shr    $0x10,%edx
8010592d:	66 89 14 c5 a6 4d 11 	mov    %dx,-0x7feeb25a(,%eax,8)
80105934:	80 
  for(i = 0; i < 256; i++)
80105935:	83 c0 01             	add    $0x1,%eax
80105938:	3d 00 01 00 00       	cmp    $0x100,%eax
8010593d:	75 d1                	jne    80105910 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010593f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105942:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105947:	c7 05 a2 4f 11 80 08 	movl   $0xef000008,0x80114fa2
8010594e:	00 00 ef 
  initlock(&tickslock, "time");
80105951:	68 fd 78 10 80       	push   $0x801078fd
80105956:	68 60 4d 11 80       	push   $0x80114d60
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010595b:	66 a3 a0 4f 11 80    	mov    %ax,0x80114fa0
80105961:	c1 e8 10             	shr    $0x10,%eax
80105964:	66 a3 a6 4f 11 80    	mov    %ax,0x80114fa6
  initlock(&tickslock, "time");
8010596a:	e8 91 ea ff ff       	call   80104400 <initlock>
}
8010596f:	83 c4 10             	add    $0x10,%esp
80105972:	c9                   	leave  
80105973:	c3                   	ret    
80105974:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010597b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010597f:	90                   	nop

80105980 <idtinit>:

void
idtinit(void)
{
80105980:	f3 0f 1e fb          	endbr32 
80105984:	55                   	push   %ebp
  pd[0] = size-1;
80105985:	b8 ff 07 00 00       	mov    $0x7ff,%eax
8010598a:	89 e5                	mov    %esp,%ebp
8010598c:	83 ec 10             	sub    $0x10,%esp
8010598f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105993:	b8 a0 4d 11 80       	mov    $0x80114da0,%eax
80105998:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010599c:	c1 e8 10             	shr    $0x10,%eax
8010599f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801059a3:	8d 45 fa             	lea    -0x6(%ebp),%eax
801059a6:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801059a9:	c9                   	leave  
801059aa:	c3                   	ret    
801059ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801059af:	90                   	nop

801059b0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801059b0:	f3 0f 1e fb          	endbr32 
801059b4:	55                   	push   %ebp
801059b5:	89 e5                	mov    %esp,%ebp
801059b7:	57                   	push   %edi
801059b8:	56                   	push   %esi
801059b9:	53                   	push   %ebx
801059ba:	83 ec 1c             	sub    $0x1c,%esp
801059bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
801059c0:	8b 43 30             	mov    0x30(%ebx),%eax
801059c3:	83 f8 40             	cmp    $0x40,%eax
801059c6:	0f 84 bc 01 00 00    	je     80105b88 <trap+0x1d8>
    if(myproc()->killed)
      exit(myproc()->killed); // TODO: verify this
    return;
  }

  switch(tf->trapno){
801059cc:	83 e8 20             	sub    $0x20,%eax
801059cf:	83 f8 1f             	cmp    $0x1f,%eax
801059d2:	77 08                	ja     801059dc <trap+0x2c>
801059d4:	3e ff 24 85 a4 79 10 	notrack jmp *-0x7fef865c(,%eax,4)
801059db:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801059dc:	e8 9f df ff ff       	call   80103980 <myproc>
801059e1:	8b 7b 38             	mov    0x38(%ebx),%edi
801059e4:	85 c0                	test   %eax,%eax
801059e6:	0f 84 19 02 00 00    	je     80105c05 <trap+0x255>
801059ec:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801059f0:	0f 84 0f 02 00 00    	je     80105c05 <trap+0x255>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801059f6:	0f 20 d1             	mov    %cr2,%ecx
801059f9:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801059fc:	e8 5f df ff ff       	call   80103960 <cpuid>
80105a01:	8b 73 30             	mov    0x30(%ebx),%esi
80105a04:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105a07:	8b 43 34             	mov    0x34(%ebx),%eax
80105a0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105a0d:	e8 6e df ff ff       	call   80103980 <myproc>
80105a12:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105a15:	e8 66 df ff ff       	call   80103980 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a1a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105a1d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105a20:	51                   	push   %ecx
80105a21:	57                   	push   %edi
80105a22:	52                   	push   %edx
80105a23:	ff 75 e4             	pushl  -0x1c(%ebp)
80105a26:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105a27:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105a2a:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a2d:	56                   	push   %esi
80105a2e:	ff 70 10             	pushl  0x10(%eax)
80105a31:	68 60 79 10 80       	push   $0x80107960
80105a36:	e8 75 ac ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105a3b:	83 c4 20             	add    $0x20,%esp
80105a3e:	e8 3d df ff ff       	call   80103980 <myproc>
80105a43:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a4a:	e8 31 df ff ff       	call   80103980 <myproc>
80105a4f:	85 c0                	test   %eax,%eax
80105a51:	74 1d                	je     80105a70 <trap+0xc0>
80105a53:	e8 28 df ff ff       	call   80103980 <myproc>
80105a58:	8b 50 24             	mov    0x24(%eax),%edx
80105a5b:	85 d2                	test   %edx,%edx
80105a5d:	74 11                	je     80105a70 <trap+0xc0>
80105a5f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105a63:	83 e0 03             	and    $0x3,%eax
80105a66:	66 83 f8 03          	cmp    $0x3,%ax
80105a6a:	0f 84 60 01 00 00    	je     80105bd0 <trap+0x220>
    exit(myproc()->killed);

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105a70:	e8 0b df ff ff       	call   80103980 <myproc>
80105a75:	85 c0                	test   %eax,%eax
80105a77:	74 0f                	je     80105a88 <trap+0xd8>
80105a79:	e8 02 df ff ff       	call   80103980 <myproc>
80105a7e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105a82:	0f 84 e8 00 00 00    	je     80105b70 <trap+0x1c0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a88:	e8 f3 de ff ff       	call   80103980 <myproc>
80105a8d:	85 c0                	test   %eax,%eax
80105a8f:	74 1d                	je     80105aae <trap+0xfe>
80105a91:	e8 ea de ff ff       	call   80103980 <myproc>
80105a96:	8b 40 24             	mov    0x24(%eax),%eax
80105a99:	85 c0                	test   %eax,%eax
80105a9b:	74 11                	je     80105aae <trap+0xfe>
80105a9d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105aa1:	83 e0 03             	and    $0x3,%eax
80105aa4:	66 83 f8 03          	cmp    $0x3,%ax
80105aa8:	0f 84 03 01 00 00    	je     80105bb1 <trap+0x201>
    exit(myproc()->killed);
}
80105aae:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ab1:	5b                   	pop    %ebx
80105ab2:	5e                   	pop    %esi
80105ab3:	5f                   	pop    %edi
80105ab4:	5d                   	pop    %ebp
80105ab5:	c3                   	ret    
    ideintr();
80105ab6:	e8 45 c7 ff ff       	call   80102200 <ideintr>
    lapiceoi();
80105abb:	e8 20 ce ff ff       	call   801028e0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ac0:	e8 bb de ff ff       	call   80103980 <myproc>
80105ac5:	85 c0                	test   %eax,%eax
80105ac7:	75 8a                	jne    80105a53 <trap+0xa3>
80105ac9:	eb a5                	jmp    80105a70 <trap+0xc0>
    if(cpuid() == 0){
80105acb:	e8 90 de ff ff       	call   80103960 <cpuid>
80105ad0:	85 c0                	test   %eax,%eax
80105ad2:	75 e7                	jne    80105abb <trap+0x10b>
      acquire(&tickslock);
80105ad4:	83 ec 0c             	sub    $0xc,%esp
80105ad7:	68 60 4d 11 80       	push   $0x80114d60
80105adc:	e8 9f ea ff ff       	call   80104580 <acquire>
      wakeup(&ticks);
80105ae1:	c7 04 24 a0 55 11 80 	movl   $0x801155a0,(%esp)
      ticks++;
80105ae8:	83 05 a0 55 11 80 01 	addl   $0x1,0x801155a0
      wakeup(&ticks);
80105aef:	e8 0c e6 ff ff       	call   80104100 <wakeup>
      release(&tickslock);
80105af4:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
80105afb:	e8 40 eb ff ff       	call   80104640 <release>
80105b00:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105b03:	eb b6                	jmp    80105abb <trap+0x10b>
    kbdintr();
80105b05:	e8 96 cc ff ff       	call   801027a0 <kbdintr>
    lapiceoi();
80105b0a:	e8 d1 cd ff ff       	call   801028e0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b0f:	e8 6c de ff ff       	call   80103980 <myproc>
80105b14:	85 c0                	test   %eax,%eax
80105b16:	0f 85 37 ff ff ff    	jne    80105a53 <trap+0xa3>
80105b1c:	e9 4f ff ff ff       	jmp    80105a70 <trap+0xc0>
    uartintr();
80105b21:	e8 7a 02 00 00       	call   80105da0 <uartintr>
    lapiceoi();
80105b26:	e8 b5 cd ff ff       	call   801028e0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b2b:	e8 50 de ff ff       	call   80103980 <myproc>
80105b30:	85 c0                	test   %eax,%eax
80105b32:	0f 85 1b ff ff ff    	jne    80105a53 <trap+0xa3>
80105b38:	e9 33 ff ff ff       	jmp    80105a70 <trap+0xc0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105b3d:	8b 7b 38             	mov    0x38(%ebx),%edi
80105b40:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105b44:	e8 17 de ff ff       	call   80103960 <cpuid>
80105b49:	57                   	push   %edi
80105b4a:	56                   	push   %esi
80105b4b:	50                   	push   %eax
80105b4c:	68 08 79 10 80       	push   $0x80107908
80105b51:	e8 5a ab ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80105b56:	e8 85 cd ff ff       	call   801028e0 <lapiceoi>
    break;
80105b5b:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b5e:	e8 1d de ff ff       	call   80103980 <myproc>
80105b63:	85 c0                	test   %eax,%eax
80105b65:	0f 85 e8 fe ff ff    	jne    80105a53 <trap+0xa3>
80105b6b:	e9 00 ff ff ff       	jmp    80105a70 <trap+0xc0>
  if(myproc() && myproc()->state == RUNNING &&
80105b70:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105b74:	0f 85 0e ff ff ff    	jne    80105a88 <trap+0xd8>
    yield();
80105b7a:	e8 71 e3 ff ff       	call   80103ef0 <yield>
80105b7f:	e9 04 ff ff ff       	jmp    80105a88 <trap+0xd8>
80105b84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105b88:	e8 f3 dd ff ff       	call   80103980 <myproc>
80105b8d:	8b 70 24             	mov    0x24(%eax),%esi
80105b90:	85 f6                	test   %esi,%esi
80105b92:	75 5c                	jne    80105bf0 <trap+0x240>
    myproc()->tf = tf;
80105b94:	e8 e7 dd ff ff       	call   80103980 <myproc>
80105b99:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105b9c:	e8 bf ee ff ff       	call   80104a60 <syscall>
    if(myproc()->killed)
80105ba1:	e8 da dd ff ff       	call   80103980 <myproc>
80105ba6:	8b 48 24             	mov    0x24(%eax),%ecx
80105ba9:	85 c9                	test   %ecx,%ecx
80105bab:	0f 84 fd fe ff ff    	je     80105aae <trap+0xfe>
    exit(myproc()->killed);
80105bb1:	e8 ca dd ff ff       	call   80103980 <myproc>
80105bb6:	8b 40 24             	mov    0x24(%eax),%eax
80105bb9:	89 45 08             	mov    %eax,0x8(%ebp)
}
80105bbc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bbf:	5b                   	pop    %ebx
80105bc0:	5e                   	pop    %esi
80105bc1:	5f                   	pop    %edi
80105bc2:	5d                   	pop    %ebp
    exit(myproc()->killed);
80105bc3:	e9 e8 e1 ff ff       	jmp    80103db0 <exit>
80105bc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bcf:	90                   	nop
    exit(myproc()->killed);
80105bd0:	e8 ab dd ff ff       	call   80103980 <myproc>
80105bd5:	83 ec 0c             	sub    $0xc,%esp
80105bd8:	ff 70 24             	pushl  0x24(%eax)
80105bdb:	e8 d0 e1 ff ff       	call   80103db0 <exit>
80105be0:	83 c4 10             	add    $0x10,%esp
80105be3:	e9 88 fe ff ff       	jmp    80105a70 <trap+0xc0>
80105be8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bef:	90                   	nop
      exit(myproc()->killed); // TODO: verify this
80105bf0:	e8 8b dd ff ff       	call   80103980 <myproc>
80105bf5:	83 ec 0c             	sub    $0xc,%esp
80105bf8:	ff 70 24             	pushl  0x24(%eax)
80105bfb:	e8 b0 e1 ff ff       	call   80103db0 <exit>
80105c00:	83 c4 10             	add    $0x10,%esp
80105c03:	eb 8f                	jmp    80105b94 <trap+0x1e4>
80105c05:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105c08:	e8 53 dd ff ff       	call   80103960 <cpuid>
80105c0d:	83 ec 0c             	sub    $0xc,%esp
80105c10:	56                   	push   %esi
80105c11:	57                   	push   %edi
80105c12:	50                   	push   %eax
80105c13:	ff 73 30             	pushl  0x30(%ebx)
80105c16:	68 2c 79 10 80       	push   $0x8010792c
80105c1b:	e8 90 aa ff ff       	call   801006b0 <cprintf>
      panic("trap");
80105c20:	83 c4 14             	add    $0x14,%esp
80105c23:	68 02 79 10 80       	push   $0x80107902
80105c28:	e8 63 a7 ff ff       	call   80100390 <panic>
80105c2d:	66 90                	xchg   %ax,%ax
80105c2f:	90                   	nop

80105c30 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105c30:	f3 0f 1e fb          	endbr32 
  if(!uart)
80105c34:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
80105c39:	85 c0                	test   %eax,%eax
80105c3b:	74 1b                	je     80105c58 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105c3d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105c42:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105c43:	a8 01                	test   $0x1,%al
80105c45:	74 11                	je     80105c58 <uartgetc+0x28>
80105c47:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105c4c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105c4d:	0f b6 c0             	movzbl %al,%eax
80105c50:	c3                   	ret    
80105c51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105c58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c5d:	c3                   	ret    
80105c5e:	66 90                	xchg   %ax,%ax

80105c60 <uartputc.part.0>:
uartputc(int c)
80105c60:	55                   	push   %ebp
80105c61:	89 e5                	mov    %esp,%ebp
80105c63:	57                   	push   %edi
80105c64:	89 c7                	mov    %eax,%edi
80105c66:	56                   	push   %esi
80105c67:	be fd 03 00 00       	mov    $0x3fd,%esi
80105c6c:	53                   	push   %ebx
80105c6d:	bb 80 00 00 00       	mov    $0x80,%ebx
80105c72:	83 ec 0c             	sub    $0xc,%esp
80105c75:	eb 1b                	jmp    80105c92 <uartputc.part.0+0x32>
80105c77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c7e:	66 90                	xchg   %ax,%ax
    microdelay(10);
80105c80:	83 ec 0c             	sub    $0xc,%esp
80105c83:	6a 0a                	push   $0xa
80105c85:	e8 76 cc ff ff       	call   80102900 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105c8a:	83 c4 10             	add    $0x10,%esp
80105c8d:	83 eb 01             	sub    $0x1,%ebx
80105c90:	74 07                	je     80105c99 <uartputc.part.0+0x39>
80105c92:	89 f2                	mov    %esi,%edx
80105c94:	ec                   	in     (%dx),%al
80105c95:	a8 20                	test   $0x20,%al
80105c97:	74 e7                	je     80105c80 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105c99:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105c9e:	89 f8                	mov    %edi,%eax
80105ca0:	ee                   	out    %al,(%dx)
}
80105ca1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ca4:	5b                   	pop    %ebx
80105ca5:	5e                   	pop    %esi
80105ca6:	5f                   	pop    %edi
80105ca7:	5d                   	pop    %ebp
80105ca8:	c3                   	ret    
80105ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105cb0 <uartinit>:
{
80105cb0:	f3 0f 1e fb          	endbr32 
80105cb4:	55                   	push   %ebp
80105cb5:	31 c9                	xor    %ecx,%ecx
80105cb7:	89 c8                	mov    %ecx,%eax
80105cb9:	89 e5                	mov    %esp,%ebp
80105cbb:	57                   	push   %edi
80105cbc:	56                   	push   %esi
80105cbd:	53                   	push   %ebx
80105cbe:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105cc3:	89 da                	mov    %ebx,%edx
80105cc5:	83 ec 0c             	sub    $0xc,%esp
80105cc8:	ee                   	out    %al,(%dx)
80105cc9:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105cce:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105cd3:	89 fa                	mov    %edi,%edx
80105cd5:	ee                   	out    %al,(%dx)
80105cd6:	b8 0c 00 00 00       	mov    $0xc,%eax
80105cdb:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ce0:	ee                   	out    %al,(%dx)
80105ce1:	be f9 03 00 00       	mov    $0x3f9,%esi
80105ce6:	89 c8                	mov    %ecx,%eax
80105ce8:	89 f2                	mov    %esi,%edx
80105cea:	ee                   	out    %al,(%dx)
80105ceb:	b8 03 00 00 00       	mov    $0x3,%eax
80105cf0:	89 fa                	mov    %edi,%edx
80105cf2:	ee                   	out    %al,(%dx)
80105cf3:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105cf8:	89 c8                	mov    %ecx,%eax
80105cfa:	ee                   	out    %al,(%dx)
80105cfb:	b8 01 00 00 00       	mov    $0x1,%eax
80105d00:	89 f2                	mov    %esi,%edx
80105d02:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105d03:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105d08:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105d09:	3c ff                	cmp    $0xff,%al
80105d0b:	74 52                	je     80105d5f <uartinit+0xaf>
  uart = 1;
80105d0d:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105d14:	00 00 00 
80105d17:	89 da                	mov    %ebx,%edx
80105d19:	ec                   	in     (%dx),%al
80105d1a:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d1f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105d20:	83 ec 08             	sub    $0x8,%esp
80105d23:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80105d28:	bb 24 7a 10 80       	mov    $0x80107a24,%ebx
  ioapicenable(IRQ_COM1, 0);
80105d2d:	6a 00                	push   $0x0
80105d2f:	6a 04                	push   $0x4
80105d31:	e8 1a c7 ff ff       	call   80102450 <ioapicenable>
80105d36:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105d39:	b8 78 00 00 00       	mov    $0x78,%eax
80105d3e:	eb 04                	jmp    80105d44 <uartinit+0x94>
80105d40:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80105d44:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105d4a:	85 d2                	test   %edx,%edx
80105d4c:	74 08                	je     80105d56 <uartinit+0xa6>
    uartputc(*p);
80105d4e:	0f be c0             	movsbl %al,%eax
80105d51:	e8 0a ff ff ff       	call   80105c60 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80105d56:	89 f0                	mov    %esi,%eax
80105d58:	83 c3 01             	add    $0x1,%ebx
80105d5b:	84 c0                	test   %al,%al
80105d5d:	75 e1                	jne    80105d40 <uartinit+0x90>
}
80105d5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d62:	5b                   	pop    %ebx
80105d63:	5e                   	pop    %esi
80105d64:	5f                   	pop    %edi
80105d65:	5d                   	pop    %ebp
80105d66:	c3                   	ret    
80105d67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d6e:	66 90                	xchg   %ax,%ax

80105d70 <uartputc>:
{
80105d70:	f3 0f 1e fb          	endbr32 
80105d74:	55                   	push   %ebp
  if(!uart)
80105d75:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
{
80105d7b:	89 e5                	mov    %esp,%ebp
80105d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80105d80:	85 d2                	test   %edx,%edx
80105d82:	74 0c                	je     80105d90 <uartputc+0x20>
}
80105d84:	5d                   	pop    %ebp
80105d85:	e9 d6 fe ff ff       	jmp    80105c60 <uartputc.part.0>
80105d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105d90:	5d                   	pop    %ebp
80105d91:	c3                   	ret    
80105d92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105da0 <uartintr>:

void
uartintr(void)
{
80105da0:	f3 0f 1e fb          	endbr32 
80105da4:	55                   	push   %ebp
80105da5:	89 e5                	mov    %esp,%ebp
80105da7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105daa:	68 30 5c 10 80       	push   $0x80105c30
80105daf:	e8 ac aa ff ff       	call   80100860 <consoleintr>
}
80105db4:	83 c4 10             	add    $0x10,%esp
80105db7:	c9                   	leave  
80105db8:	c3                   	ret    

80105db9 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105db9:	6a 00                	push   $0x0
  pushl $0
80105dbb:	6a 00                	push   $0x0
  jmp alltraps
80105dbd:	e9 11 fb ff ff       	jmp    801058d3 <alltraps>

80105dc2 <vector1>:
.globl vector1
vector1:
  pushl $0
80105dc2:	6a 00                	push   $0x0
  pushl $1
80105dc4:	6a 01                	push   $0x1
  jmp alltraps
80105dc6:	e9 08 fb ff ff       	jmp    801058d3 <alltraps>

80105dcb <vector2>:
.globl vector2
vector2:
  pushl $0
80105dcb:	6a 00                	push   $0x0
  pushl $2
80105dcd:	6a 02                	push   $0x2
  jmp alltraps
80105dcf:	e9 ff fa ff ff       	jmp    801058d3 <alltraps>

80105dd4 <vector3>:
.globl vector3
vector3:
  pushl $0
80105dd4:	6a 00                	push   $0x0
  pushl $3
80105dd6:	6a 03                	push   $0x3
  jmp alltraps
80105dd8:	e9 f6 fa ff ff       	jmp    801058d3 <alltraps>

80105ddd <vector4>:
.globl vector4
vector4:
  pushl $0
80105ddd:	6a 00                	push   $0x0
  pushl $4
80105ddf:	6a 04                	push   $0x4
  jmp alltraps
80105de1:	e9 ed fa ff ff       	jmp    801058d3 <alltraps>

80105de6 <vector5>:
.globl vector5
vector5:
  pushl $0
80105de6:	6a 00                	push   $0x0
  pushl $5
80105de8:	6a 05                	push   $0x5
  jmp alltraps
80105dea:	e9 e4 fa ff ff       	jmp    801058d3 <alltraps>

80105def <vector6>:
.globl vector6
vector6:
  pushl $0
80105def:	6a 00                	push   $0x0
  pushl $6
80105df1:	6a 06                	push   $0x6
  jmp alltraps
80105df3:	e9 db fa ff ff       	jmp    801058d3 <alltraps>

80105df8 <vector7>:
.globl vector7
vector7:
  pushl $0
80105df8:	6a 00                	push   $0x0
  pushl $7
80105dfa:	6a 07                	push   $0x7
  jmp alltraps
80105dfc:	e9 d2 fa ff ff       	jmp    801058d3 <alltraps>

80105e01 <vector8>:
.globl vector8
vector8:
  pushl $8
80105e01:	6a 08                	push   $0x8
  jmp alltraps
80105e03:	e9 cb fa ff ff       	jmp    801058d3 <alltraps>

80105e08 <vector9>:
.globl vector9
vector9:
  pushl $0
80105e08:	6a 00                	push   $0x0
  pushl $9
80105e0a:	6a 09                	push   $0x9
  jmp alltraps
80105e0c:	e9 c2 fa ff ff       	jmp    801058d3 <alltraps>

80105e11 <vector10>:
.globl vector10
vector10:
  pushl $10
80105e11:	6a 0a                	push   $0xa
  jmp alltraps
80105e13:	e9 bb fa ff ff       	jmp    801058d3 <alltraps>

80105e18 <vector11>:
.globl vector11
vector11:
  pushl $11
80105e18:	6a 0b                	push   $0xb
  jmp alltraps
80105e1a:	e9 b4 fa ff ff       	jmp    801058d3 <alltraps>

80105e1f <vector12>:
.globl vector12
vector12:
  pushl $12
80105e1f:	6a 0c                	push   $0xc
  jmp alltraps
80105e21:	e9 ad fa ff ff       	jmp    801058d3 <alltraps>

80105e26 <vector13>:
.globl vector13
vector13:
  pushl $13
80105e26:	6a 0d                	push   $0xd
  jmp alltraps
80105e28:	e9 a6 fa ff ff       	jmp    801058d3 <alltraps>

80105e2d <vector14>:
.globl vector14
vector14:
  pushl $14
80105e2d:	6a 0e                	push   $0xe
  jmp alltraps
80105e2f:	e9 9f fa ff ff       	jmp    801058d3 <alltraps>

80105e34 <vector15>:
.globl vector15
vector15:
  pushl $0
80105e34:	6a 00                	push   $0x0
  pushl $15
80105e36:	6a 0f                	push   $0xf
  jmp alltraps
80105e38:	e9 96 fa ff ff       	jmp    801058d3 <alltraps>

80105e3d <vector16>:
.globl vector16
vector16:
  pushl $0
80105e3d:	6a 00                	push   $0x0
  pushl $16
80105e3f:	6a 10                	push   $0x10
  jmp alltraps
80105e41:	e9 8d fa ff ff       	jmp    801058d3 <alltraps>

80105e46 <vector17>:
.globl vector17
vector17:
  pushl $17
80105e46:	6a 11                	push   $0x11
  jmp alltraps
80105e48:	e9 86 fa ff ff       	jmp    801058d3 <alltraps>

80105e4d <vector18>:
.globl vector18
vector18:
  pushl $0
80105e4d:	6a 00                	push   $0x0
  pushl $18
80105e4f:	6a 12                	push   $0x12
  jmp alltraps
80105e51:	e9 7d fa ff ff       	jmp    801058d3 <alltraps>

80105e56 <vector19>:
.globl vector19
vector19:
  pushl $0
80105e56:	6a 00                	push   $0x0
  pushl $19
80105e58:	6a 13                	push   $0x13
  jmp alltraps
80105e5a:	e9 74 fa ff ff       	jmp    801058d3 <alltraps>

80105e5f <vector20>:
.globl vector20
vector20:
  pushl $0
80105e5f:	6a 00                	push   $0x0
  pushl $20
80105e61:	6a 14                	push   $0x14
  jmp alltraps
80105e63:	e9 6b fa ff ff       	jmp    801058d3 <alltraps>

80105e68 <vector21>:
.globl vector21
vector21:
  pushl $0
80105e68:	6a 00                	push   $0x0
  pushl $21
80105e6a:	6a 15                	push   $0x15
  jmp alltraps
80105e6c:	e9 62 fa ff ff       	jmp    801058d3 <alltraps>

80105e71 <vector22>:
.globl vector22
vector22:
  pushl $0
80105e71:	6a 00                	push   $0x0
  pushl $22
80105e73:	6a 16                	push   $0x16
  jmp alltraps
80105e75:	e9 59 fa ff ff       	jmp    801058d3 <alltraps>

80105e7a <vector23>:
.globl vector23
vector23:
  pushl $0
80105e7a:	6a 00                	push   $0x0
  pushl $23
80105e7c:	6a 17                	push   $0x17
  jmp alltraps
80105e7e:	e9 50 fa ff ff       	jmp    801058d3 <alltraps>

80105e83 <vector24>:
.globl vector24
vector24:
  pushl $0
80105e83:	6a 00                	push   $0x0
  pushl $24
80105e85:	6a 18                	push   $0x18
  jmp alltraps
80105e87:	e9 47 fa ff ff       	jmp    801058d3 <alltraps>

80105e8c <vector25>:
.globl vector25
vector25:
  pushl $0
80105e8c:	6a 00                	push   $0x0
  pushl $25
80105e8e:	6a 19                	push   $0x19
  jmp alltraps
80105e90:	e9 3e fa ff ff       	jmp    801058d3 <alltraps>

80105e95 <vector26>:
.globl vector26
vector26:
  pushl $0
80105e95:	6a 00                	push   $0x0
  pushl $26
80105e97:	6a 1a                	push   $0x1a
  jmp alltraps
80105e99:	e9 35 fa ff ff       	jmp    801058d3 <alltraps>

80105e9e <vector27>:
.globl vector27
vector27:
  pushl $0
80105e9e:	6a 00                	push   $0x0
  pushl $27
80105ea0:	6a 1b                	push   $0x1b
  jmp alltraps
80105ea2:	e9 2c fa ff ff       	jmp    801058d3 <alltraps>

80105ea7 <vector28>:
.globl vector28
vector28:
  pushl $0
80105ea7:	6a 00                	push   $0x0
  pushl $28
80105ea9:	6a 1c                	push   $0x1c
  jmp alltraps
80105eab:	e9 23 fa ff ff       	jmp    801058d3 <alltraps>

80105eb0 <vector29>:
.globl vector29
vector29:
  pushl $0
80105eb0:	6a 00                	push   $0x0
  pushl $29
80105eb2:	6a 1d                	push   $0x1d
  jmp alltraps
80105eb4:	e9 1a fa ff ff       	jmp    801058d3 <alltraps>

80105eb9 <vector30>:
.globl vector30
vector30:
  pushl $0
80105eb9:	6a 00                	push   $0x0
  pushl $30
80105ebb:	6a 1e                	push   $0x1e
  jmp alltraps
80105ebd:	e9 11 fa ff ff       	jmp    801058d3 <alltraps>

80105ec2 <vector31>:
.globl vector31
vector31:
  pushl $0
80105ec2:	6a 00                	push   $0x0
  pushl $31
80105ec4:	6a 1f                	push   $0x1f
  jmp alltraps
80105ec6:	e9 08 fa ff ff       	jmp    801058d3 <alltraps>

80105ecb <vector32>:
.globl vector32
vector32:
  pushl $0
80105ecb:	6a 00                	push   $0x0
  pushl $32
80105ecd:	6a 20                	push   $0x20
  jmp alltraps
80105ecf:	e9 ff f9 ff ff       	jmp    801058d3 <alltraps>

80105ed4 <vector33>:
.globl vector33
vector33:
  pushl $0
80105ed4:	6a 00                	push   $0x0
  pushl $33
80105ed6:	6a 21                	push   $0x21
  jmp alltraps
80105ed8:	e9 f6 f9 ff ff       	jmp    801058d3 <alltraps>

80105edd <vector34>:
.globl vector34
vector34:
  pushl $0
80105edd:	6a 00                	push   $0x0
  pushl $34
80105edf:	6a 22                	push   $0x22
  jmp alltraps
80105ee1:	e9 ed f9 ff ff       	jmp    801058d3 <alltraps>

80105ee6 <vector35>:
.globl vector35
vector35:
  pushl $0
80105ee6:	6a 00                	push   $0x0
  pushl $35
80105ee8:	6a 23                	push   $0x23
  jmp alltraps
80105eea:	e9 e4 f9 ff ff       	jmp    801058d3 <alltraps>

80105eef <vector36>:
.globl vector36
vector36:
  pushl $0
80105eef:	6a 00                	push   $0x0
  pushl $36
80105ef1:	6a 24                	push   $0x24
  jmp alltraps
80105ef3:	e9 db f9 ff ff       	jmp    801058d3 <alltraps>

80105ef8 <vector37>:
.globl vector37
vector37:
  pushl $0
80105ef8:	6a 00                	push   $0x0
  pushl $37
80105efa:	6a 25                	push   $0x25
  jmp alltraps
80105efc:	e9 d2 f9 ff ff       	jmp    801058d3 <alltraps>

80105f01 <vector38>:
.globl vector38
vector38:
  pushl $0
80105f01:	6a 00                	push   $0x0
  pushl $38
80105f03:	6a 26                	push   $0x26
  jmp alltraps
80105f05:	e9 c9 f9 ff ff       	jmp    801058d3 <alltraps>

80105f0a <vector39>:
.globl vector39
vector39:
  pushl $0
80105f0a:	6a 00                	push   $0x0
  pushl $39
80105f0c:	6a 27                	push   $0x27
  jmp alltraps
80105f0e:	e9 c0 f9 ff ff       	jmp    801058d3 <alltraps>

80105f13 <vector40>:
.globl vector40
vector40:
  pushl $0
80105f13:	6a 00                	push   $0x0
  pushl $40
80105f15:	6a 28                	push   $0x28
  jmp alltraps
80105f17:	e9 b7 f9 ff ff       	jmp    801058d3 <alltraps>

80105f1c <vector41>:
.globl vector41
vector41:
  pushl $0
80105f1c:	6a 00                	push   $0x0
  pushl $41
80105f1e:	6a 29                	push   $0x29
  jmp alltraps
80105f20:	e9 ae f9 ff ff       	jmp    801058d3 <alltraps>

80105f25 <vector42>:
.globl vector42
vector42:
  pushl $0
80105f25:	6a 00                	push   $0x0
  pushl $42
80105f27:	6a 2a                	push   $0x2a
  jmp alltraps
80105f29:	e9 a5 f9 ff ff       	jmp    801058d3 <alltraps>

80105f2e <vector43>:
.globl vector43
vector43:
  pushl $0
80105f2e:	6a 00                	push   $0x0
  pushl $43
80105f30:	6a 2b                	push   $0x2b
  jmp alltraps
80105f32:	e9 9c f9 ff ff       	jmp    801058d3 <alltraps>

80105f37 <vector44>:
.globl vector44
vector44:
  pushl $0
80105f37:	6a 00                	push   $0x0
  pushl $44
80105f39:	6a 2c                	push   $0x2c
  jmp alltraps
80105f3b:	e9 93 f9 ff ff       	jmp    801058d3 <alltraps>

80105f40 <vector45>:
.globl vector45
vector45:
  pushl $0
80105f40:	6a 00                	push   $0x0
  pushl $45
80105f42:	6a 2d                	push   $0x2d
  jmp alltraps
80105f44:	e9 8a f9 ff ff       	jmp    801058d3 <alltraps>

80105f49 <vector46>:
.globl vector46
vector46:
  pushl $0
80105f49:	6a 00                	push   $0x0
  pushl $46
80105f4b:	6a 2e                	push   $0x2e
  jmp alltraps
80105f4d:	e9 81 f9 ff ff       	jmp    801058d3 <alltraps>

80105f52 <vector47>:
.globl vector47
vector47:
  pushl $0
80105f52:	6a 00                	push   $0x0
  pushl $47
80105f54:	6a 2f                	push   $0x2f
  jmp alltraps
80105f56:	e9 78 f9 ff ff       	jmp    801058d3 <alltraps>

80105f5b <vector48>:
.globl vector48
vector48:
  pushl $0
80105f5b:	6a 00                	push   $0x0
  pushl $48
80105f5d:	6a 30                	push   $0x30
  jmp alltraps
80105f5f:	e9 6f f9 ff ff       	jmp    801058d3 <alltraps>

80105f64 <vector49>:
.globl vector49
vector49:
  pushl $0
80105f64:	6a 00                	push   $0x0
  pushl $49
80105f66:	6a 31                	push   $0x31
  jmp alltraps
80105f68:	e9 66 f9 ff ff       	jmp    801058d3 <alltraps>

80105f6d <vector50>:
.globl vector50
vector50:
  pushl $0
80105f6d:	6a 00                	push   $0x0
  pushl $50
80105f6f:	6a 32                	push   $0x32
  jmp alltraps
80105f71:	e9 5d f9 ff ff       	jmp    801058d3 <alltraps>

80105f76 <vector51>:
.globl vector51
vector51:
  pushl $0
80105f76:	6a 00                	push   $0x0
  pushl $51
80105f78:	6a 33                	push   $0x33
  jmp alltraps
80105f7a:	e9 54 f9 ff ff       	jmp    801058d3 <alltraps>

80105f7f <vector52>:
.globl vector52
vector52:
  pushl $0
80105f7f:	6a 00                	push   $0x0
  pushl $52
80105f81:	6a 34                	push   $0x34
  jmp alltraps
80105f83:	e9 4b f9 ff ff       	jmp    801058d3 <alltraps>

80105f88 <vector53>:
.globl vector53
vector53:
  pushl $0
80105f88:	6a 00                	push   $0x0
  pushl $53
80105f8a:	6a 35                	push   $0x35
  jmp alltraps
80105f8c:	e9 42 f9 ff ff       	jmp    801058d3 <alltraps>

80105f91 <vector54>:
.globl vector54
vector54:
  pushl $0
80105f91:	6a 00                	push   $0x0
  pushl $54
80105f93:	6a 36                	push   $0x36
  jmp alltraps
80105f95:	e9 39 f9 ff ff       	jmp    801058d3 <alltraps>

80105f9a <vector55>:
.globl vector55
vector55:
  pushl $0
80105f9a:	6a 00                	push   $0x0
  pushl $55
80105f9c:	6a 37                	push   $0x37
  jmp alltraps
80105f9e:	e9 30 f9 ff ff       	jmp    801058d3 <alltraps>

80105fa3 <vector56>:
.globl vector56
vector56:
  pushl $0
80105fa3:	6a 00                	push   $0x0
  pushl $56
80105fa5:	6a 38                	push   $0x38
  jmp alltraps
80105fa7:	e9 27 f9 ff ff       	jmp    801058d3 <alltraps>

80105fac <vector57>:
.globl vector57
vector57:
  pushl $0
80105fac:	6a 00                	push   $0x0
  pushl $57
80105fae:	6a 39                	push   $0x39
  jmp alltraps
80105fb0:	e9 1e f9 ff ff       	jmp    801058d3 <alltraps>

80105fb5 <vector58>:
.globl vector58
vector58:
  pushl $0
80105fb5:	6a 00                	push   $0x0
  pushl $58
80105fb7:	6a 3a                	push   $0x3a
  jmp alltraps
80105fb9:	e9 15 f9 ff ff       	jmp    801058d3 <alltraps>

80105fbe <vector59>:
.globl vector59
vector59:
  pushl $0
80105fbe:	6a 00                	push   $0x0
  pushl $59
80105fc0:	6a 3b                	push   $0x3b
  jmp alltraps
80105fc2:	e9 0c f9 ff ff       	jmp    801058d3 <alltraps>

80105fc7 <vector60>:
.globl vector60
vector60:
  pushl $0
80105fc7:	6a 00                	push   $0x0
  pushl $60
80105fc9:	6a 3c                	push   $0x3c
  jmp alltraps
80105fcb:	e9 03 f9 ff ff       	jmp    801058d3 <alltraps>

80105fd0 <vector61>:
.globl vector61
vector61:
  pushl $0
80105fd0:	6a 00                	push   $0x0
  pushl $61
80105fd2:	6a 3d                	push   $0x3d
  jmp alltraps
80105fd4:	e9 fa f8 ff ff       	jmp    801058d3 <alltraps>

80105fd9 <vector62>:
.globl vector62
vector62:
  pushl $0
80105fd9:	6a 00                	push   $0x0
  pushl $62
80105fdb:	6a 3e                	push   $0x3e
  jmp alltraps
80105fdd:	e9 f1 f8 ff ff       	jmp    801058d3 <alltraps>

80105fe2 <vector63>:
.globl vector63
vector63:
  pushl $0
80105fe2:	6a 00                	push   $0x0
  pushl $63
80105fe4:	6a 3f                	push   $0x3f
  jmp alltraps
80105fe6:	e9 e8 f8 ff ff       	jmp    801058d3 <alltraps>

80105feb <vector64>:
.globl vector64
vector64:
  pushl $0
80105feb:	6a 00                	push   $0x0
  pushl $64
80105fed:	6a 40                	push   $0x40
  jmp alltraps
80105fef:	e9 df f8 ff ff       	jmp    801058d3 <alltraps>

80105ff4 <vector65>:
.globl vector65
vector65:
  pushl $0
80105ff4:	6a 00                	push   $0x0
  pushl $65
80105ff6:	6a 41                	push   $0x41
  jmp alltraps
80105ff8:	e9 d6 f8 ff ff       	jmp    801058d3 <alltraps>

80105ffd <vector66>:
.globl vector66
vector66:
  pushl $0
80105ffd:	6a 00                	push   $0x0
  pushl $66
80105fff:	6a 42                	push   $0x42
  jmp alltraps
80106001:	e9 cd f8 ff ff       	jmp    801058d3 <alltraps>

80106006 <vector67>:
.globl vector67
vector67:
  pushl $0
80106006:	6a 00                	push   $0x0
  pushl $67
80106008:	6a 43                	push   $0x43
  jmp alltraps
8010600a:	e9 c4 f8 ff ff       	jmp    801058d3 <alltraps>

8010600f <vector68>:
.globl vector68
vector68:
  pushl $0
8010600f:	6a 00                	push   $0x0
  pushl $68
80106011:	6a 44                	push   $0x44
  jmp alltraps
80106013:	e9 bb f8 ff ff       	jmp    801058d3 <alltraps>

80106018 <vector69>:
.globl vector69
vector69:
  pushl $0
80106018:	6a 00                	push   $0x0
  pushl $69
8010601a:	6a 45                	push   $0x45
  jmp alltraps
8010601c:	e9 b2 f8 ff ff       	jmp    801058d3 <alltraps>

80106021 <vector70>:
.globl vector70
vector70:
  pushl $0
80106021:	6a 00                	push   $0x0
  pushl $70
80106023:	6a 46                	push   $0x46
  jmp alltraps
80106025:	e9 a9 f8 ff ff       	jmp    801058d3 <alltraps>

8010602a <vector71>:
.globl vector71
vector71:
  pushl $0
8010602a:	6a 00                	push   $0x0
  pushl $71
8010602c:	6a 47                	push   $0x47
  jmp alltraps
8010602e:	e9 a0 f8 ff ff       	jmp    801058d3 <alltraps>

80106033 <vector72>:
.globl vector72
vector72:
  pushl $0
80106033:	6a 00                	push   $0x0
  pushl $72
80106035:	6a 48                	push   $0x48
  jmp alltraps
80106037:	e9 97 f8 ff ff       	jmp    801058d3 <alltraps>

8010603c <vector73>:
.globl vector73
vector73:
  pushl $0
8010603c:	6a 00                	push   $0x0
  pushl $73
8010603e:	6a 49                	push   $0x49
  jmp alltraps
80106040:	e9 8e f8 ff ff       	jmp    801058d3 <alltraps>

80106045 <vector74>:
.globl vector74
vector74:
  pushl $0
80106045:	6a 00                	push   $0x0
  pushl $74
80106047:	6a 4a                	push   $0x4a
  jmp alltraps
80106049:	e9 85 f8 ff ff       	jmp    801058d3 <alltraps>

8010604e <vector75>:
.globl vector75
vector75:
  pushl $0
8010604e:	6a 00                	push   $0x0
  pushl $75
80106050:	6a 4b                	push   $0x4b
  jmp alltraps
80106052:	e9 7c f8 ff ff       	jmp    801058d3 <alltraps>

80106057 <vector76>:
.globl vector76
vector76:
  pushl $0
80106057:	6a 00                	push   $0x0
  pushl $76
80106059:	6a 4c                	push   $0x4c
  jmp alltraps
8010605b:	e9 73 f8 ff ff       	jmp    801058d3 <alltraps>

80106060 <vector77>:
.globl vector77
vector77:
  pushl $0
80106060:	6a 00                	push   $0x0
  pushl $77
80106062:	6a 4d                	push   $0x4d
  jmp alltraps
80106064:	e9 6a f8 ff ff       	jmp    801058d3 <alltraps>

80106069 <vector78>:
.globl vector78
vector78:
  pushl $0
80106069:	6a 00                	push   $0x0
  pushl $78
8010606b:	6a 4e                	push   $0x4e
  jmp alltraps
8010606d:	e9 61 f8 ff ff       	jmp    801058d3 <alltraps>

80106072 <vector79>:
.globl vector79
vector79:
  pushl $0
80106072:	6a 00                	push   $0x0
  pushl $79
80106074:	6a 4f                	push   $0x4f
  jmp alltraps
80106076:	e9 58 f8 ff ff       	jmp    801058d3 <alltraps>

8010607b <vector80>:
.globl vector80
vector80:
  pushl $0
8010607b:	6a 00                	push   $0x0
  pushl $80
8010607d:	6a 50                	push   $0x50
  jmp alltraps
8010607f:	e9 4f f8 ff ff       	jmp    801058d3 <alltraps>

80106084 <vector81>:
.globl vector81
vector81:
  pushl $0
80106084:	6a 00                	push   $0x0
  pushl $81
80106086:	6a 51                	push   $0x51
  jmp alltraps
80106088:	e9 46 f8 ff ff       	jmp    801058d3 <alltraps>

8010608d <vector82>:
.globl vector82
vector82:
  pushl $0
8010608d:	6a 00                	push   $0x0
  pushl $82
8010608f:	6a 52                	push   $0x52
  jmp alltraps
80106091:	e9 3d f8 ff ff       	jmp    801058d3 <alltraps>

80106096 <vector83>:
.globl vector83
vector83:
  pushl $0
80106096:	6a 00                	push   $0x0
  pushl $83
80106098:	6a 53                	push   $0x53
  jmp alltraps
8010609a:	e9 34 f8 ff ff       	jmp    801058d3 <alltraps>

8010609f <vector84>:
.globl vector84
vector84:
  pushl $0
8010609f:	6a 00                	push   $0x0
  pushl $84
801060a1:	6a 54                	push   $0x54
  jmp alltraps
801060a3:	e9 2b f8 ff ff       	jmp    801058d3 <alltraps>

801060a8 <vector85>:
.globl vector85
vector85:
  pushl $0
801060a8:	6a 00                	push   $0x0
  pushl $85
801060aa:	6a 55                	push   $0x55
  jmp alltraps
801060ac:	e9 22 f8 ff ff       	jmp    801058d3 <alltraps>

801060b1 <vector86>:
.globl vector86
vector86:
  pushl $0
801060b1:	6a 00                	push   $0x0
  pushl $86
801060b3:	6a 56                	push   $0x56
  jmp alltraps
801060b5:	e9 19 f8 ff ff       	jmp    801058d3 <alltraps>

801060ba <vector87>:
.globl vector87
vector87:
  pushl $0
801060ba:	6a 00                	push   $0x0
  pushl $87
801060bc:	6a 57                	push   $0x57
  jmp alltraps
801060be:	e9 10 f8 ff ff       	jmp    801058d3 <alltraps>

801060c3 <vector88>:
.globl vector88
vector88:
  pushl $0
801060c3:	6a 00                	push   $0x0
  pushl $88
801060c5:	6a 58                	push   $0x58
  jmp alltraps
801060c7:	e9 07 f8 ff ff       	jmp    801058d3 <alltraps>

801060cc <vector89>:
.globl vector89
vector89:
  pushl $0
801060cc:	6a 00                	push   $0x0
  pushl $89
801060ce:	6a 59                	push   $0x59
  jmp alltraps
801060d0:	e9 fe f7 ff ff       	jmp    801058d3 <alltraps>

801060d5 <vector90>:
.globl vector90
vector90:
  pushl $0
801060d5:	6a 00                	push   $0x0
  pushl $90
801060d7:	6a 5a                	push   $0x5a
  jmp alltraps
801060d9:	e9 f5 f7 ff ff       	jmp    801058d3 <alltraps>

801060de <vector91>:
.globl vector91
vector91:
  pushl $0
801060de:	6a 00                	push   $0x0
  pushl $91
801060e0:	6a 5b                	push   $0x5b
  jmp alltraps
801060e2:	e9 ec f7 ff ff       	jmp    801058d3 <alltraps>

801060e7 <vector92>:
.globl vector92
vector92:
  pushl $0
801060e7:	6a 00                	push   $0x0
  pushl $92
801060e9:	6a 5c                	push   $0x5c
  jmp alltraps
801060eb:	e9 e3 f7 ff ff       	jmp    801058d3 <alltraps>

801060f0 <vector93>:
.globl vector93
vector93:
  pushl $0
801060f0:	6a 00                	push   $0x0
  pushl $93
801060f2:	6a 5d                	push   $0x5d
  jmp alltraps
801060f4:	e9 da f7 ff ff       	jmp    801058d3 <alltraps>

801060f9 <vector94>:
.globl vector94
vector94:
  pushl $0
801060f9:	6a 00                	push   $0x0
  pushl $94
801060fb:	6a 5e                	push   $0x5e
  jmp alltraps
801060fd:	e9 d1 f7 ff ff       	jmp    801058d3 <alltraps>

80106102 <vector95>:
.globl vector95
vector95:
  pushl $0
80106102:	6a 00                	push   $0x0
  pushl $95
80106104:	6a 5f                	push   $0x5f
  jmp alltraps
80106106:	e9 c8 f7 ff ff       	jmp    801058d3 <alltraps>

8010610b <vector96>:
.globl vector96
vector96:
  pushl $0
8010610b:	6a 00                	push   $0x0
  pushl $96
8010610d:	6a 60                	push   $0x60
  jmp alltraps
8010610f:	e9 bf f7 ff ff       	jmp    801058d3 <alltraps>

80106114 <vector97>:
.globl vector97
vector97:
  pushl $0
80106114:	6a 00                	push   $0x0
  pushl $97
80106116:	6a 61                	push   $0x61
  jmp alltraps
80106118:	e9 b6 f7 ff ff       	jmp    801058d3 <alltraps>

8010611d <vector98>:
.globl vector98
vector98:
  pushl $0
8010611d:	6a 00                	push   $0x0
  pushl $98
8010611f:	6a 62                	push   $0x62
  jmp alltraps
80106121:	e9 ad f7 ff ff       	jmp    801058d3 <alltraps>

80106126 <vector99>:
.globl vector99
vector99:
  pushl $0
80106126:	6a 00                	push   $0x0
  pushl $99
80106128:	6a 63                	push   $0x63
  jmp alltraps
8010612a:	e9 a4 f7 ff ff       	jmp    801058d3 <alltraps>

8010612f <vector100>:
.globl vector100
vector100:
  pushl $0
8010612f:	6a 00                	push   $0x0
  pushl $100
80106131:	6a 64                	push   $0x64
  jmp alltraps
80106133:	e9 9b f7 ff ff       	jmp    801058d3 <alltraps>

80106138 <vector101>:
.globl vector101
vector101:
  pushl $0
80106138:	6a 00                	push   $0x0
  pushl $101
8010613a:	6a 65                	push   $0x65
  jmp alltraps
8010613c:	e9 92 f7 ff ff       	jmp    801058d3 <alltraps>

80106141 <vector102>:
.globl vector102
vector102:
  pushl $0
80106141:	6a 00                	push   $0x0
  pushl $102
80106143:	6a 66                	push   $0x66
  jmp alltraps
80106145:	e9 89 f7 ff ff       	jmp    801058d3 <alltraps>

8010614a <vector103>:
.globl vector103
vector103:
  pushl $0
8010614a:	6a 00                	push   $0x0
  pushl $103
8010614c:	6a 67                	push   $0x67
  jmp alltraps
8010614e:	e9 80 f7 ff ff       	jmp    801058d3 <alltraps>

80106153 <vector104>:
.globl vector104
vector104:
  pushl $0
80106153:	6a 00                	push   $0x0
  pushl $104
80106155:	6a 68                	push   $0x68
  jmp alltraps
80106157:	e9 77 f7 ff ff       	jmp    801058d3 <alltraps>

8010615c <vector105>:
.globl vector105
vector105:
  pushl $0
8010615c:	6a 00                	push   $0x0
  pushl $105
8010615e:	6a 69                	push   $0x69
  jmp alltraps
80106160:	e9 6e f7 ff ff       	jmp    801058d3 <alltraps>

80106165 <vector106>:
.globl vector106
vector106:
  pushl $0
80106165:	6a 00                	push   $0x0
  pushl $106
80106167:	6a 6a                	push   $0x6a
  jmp alltraps
80106169:	e9 65 f7 ff ff       	jmp    801058d3 <alltraps>

8010616e <vector107>:
.globl vector107
vector107:
  pushl $0
8010616e:	6a 00                	push   $0x0
  pushl $107
80106170:	6a 6b                	push   $0x6b
  jmp alltraps
80106172:	e9 5c f7 ff ff       	jmp    801058d3 <alltraps>

80106177 <vector108>:
.globl vector108
vector108:
  pushl $0
80106177:	6a 00                	push   $0x0
  pushl $108
80106179:	6a 6c                	push   $0x6c
  jmp alltraps
8010617b:	e9 53 f7 ff ff       	jmp    801058d3 <alltraps>

80106180 <vector109>:
.globl vector109
vector109:
  pushl $0
80106180:	6a 00                	push   $0x0
  pushl $109
80106182:	6a 6d                	push   $0x6d
  jmp alltraps
80106184:	e9 4a f7 ff ff       	jmp    801058d3 <alltraps>

80106189 <vector110>:
.globl vector110
vector110:
  pushl $0
80106189:	6a 00                	push   $0x0
  pushl $110
8010618b:	6a 6e                	push   $0x6e
  jmp alltraps
8010618d:	e9 41 f7 ff ff       	jmp    801058d3 <alltraps>

80106192 <vector111>:
.globl vector111
vector111:
  pushl $0
80106192:	6a 00                	push   $0x0
  pushl $111
80106194:	6a 6f                	push   $0x6f
  jmp alltraps
80106196:	e9 38 f7 ff ff       	jmp    801058d3 <alltraps>

8010619b <vector112>:
.globl vector112
vector112:
  pushl $0
8010619b:	6a 00                	push   $0x0
  pushl $112
8010619d:	6a 70                	push   $0x70
  jmp alltraps
8010619f:	e9 2f f7 ff ff       	jmp    801058d3 <alltraps>

801061a4 <vector113>:
.globl vector113
vector113:
  pushl $0
801061a4:	6a 00                	push   $0x0
  pushl $113
801061a6:	6a 71                	push   $0x71
  jmp alltraps
801061a8:	e9 26 f7 ff ff       	jmp    801058d3 <alltraps>

801061ad <vector114>:
.globl vector114
vector114:
  pushl $0
801061ad:	6a 00                	push   $0x0
  pushl $114
801061af:	6a 72                	push   $0x72
  jmp alltraps
801061b1:	e9 1d f7 ff ff       	jmp    801058d3 <alltraps>

801061b6 <vector115>:
.globl vector115
vector115:
  pushl $0
801061b6:	6a 00                	push   $0x0
  pushl $115
801061b8:	6a 73                	push   $0x73
  jmp alltraps
801061ba:	e9 14 f7 ff ff       	jmp    801058d3 <alltraps>

801061bf <vector116>:
.globl vector116
vector116:
  pushl $0
801061bf:	6a 00                	push   $0x0
  pushl $116
801061c1:	6a 74                	push   $0x74
  jmp alltraps
801061c3:	e9 0b f7 ff ff       	jmp    801058d3 <alltraps>

801061c8 <vector117>:
.globl vector117
vector117:
  pushl $0
801061c8:	6a 00                	push   $0x0
  pushl $117
801061ca:	6a 75                	push   $0x75
  jmp alltraps
801061cc:	e9 02 f7 ff ff       	jmp    801058d3 <alltraps>

801061d1 <vector118>:
.globl vector118
vector118:
  pushl $0
801061d1:	6a 00                	push   $0x0
  pushl $118
801061d3:	6a 76                	push   $0x76
  jmp alltraps
801061d5:	e9 f9 f6 ff ff       	jmp    801058d3 <alltraps>

801061da <vector119>:
.globl vector119
vector119:
  pushl $0
801061da:	6a 00                	push   $0x0
  pushl $119
801061dc:	6a 77                	push   $0x77
  jmp alltraps
801061de:	e9 f0 f6 ff ff       	jmp    801058d3 <alltraps>

801061e3 <vector120>:
.globl vector120
vector120:
  pushl $0
801061e3:	6a 00                	push   $0x0
  pushl $120
801061e5:	6a 78                	push   $0x78
  jmp alltraps
801061e7:	e9 e7 f6 ff ff       	jmp    801058d3 <alltraps>

801061ec <vector121>:
.globl vector121
vector121:
  pushl $0
801061ec:	6a 00                	push   $0x0
  pushl $121
801061ee:	6a 79                	push   $0x79
  jmp alltraps
801061f0:	e9 de f6 ff ff       	jmp    801058d3 <alltraps>

801061f5 <vector122>:
.globl vector122
vector122:
  pushl $0
801061f5:	6a 00                	push   $0x0
  pushl $122
801061f7:	6a 7a                	push   $0x7a
  jmp alltraps
801061f9:	e9 d5 f6 ff ff       	jmp    801058d3 <alltraps>

801061fe <vector123>:
.globl vector123
vector123:
  pushl $0
801061fe:	6a 00                	push   $0x0
  pushl $123
80106200:	6a 7b                	push   $0x7b
  jmp alltraps
80106202:	e9 cc f6 ff ff       	jmp    801058d3 <alltraps>

80106207 <vector124>:
.globl vector124
vector124:
  pushl $0
80106207:	6a 00                	push   $0x0
  pushl $124
80106209:	6a 7c                	push   $0x7c
  jmp alltraps
8010620b:	e9 c3 f6 ff ff       	jmp    801058d3 <alltraps>

80106210 <vector125>:
.globl vector125
vector125:
  pushl $0
80106210:	6a 00                	push   $0x0
  pushl $125
80106212:	6a 7d                	push   $0x7d
  jmp alltraps
80106214:	e9 ba f6 ff ff       	jmp    801058d3 <alltraps>

80106219 <vector126>:
.globl vector126
vector126:
  pushl $0
80106219:	6a 00                	push   $0x0
  pushl $126
8010621b:	6a 7e                	push   $0x7e
  jmp alltraps
8010621d:	e9 b1 f6 ff ff       	jmp    801058d3 <alltraps>

80106222 <vector127>:
.globl vector127
vector127:
  pushl $0
80106222:	6a 00                	push   $0x0
  pushl $127
80106224:	6a 7f                	push   $0x7f
  jmp alltraps
80106226:	e9 a8 f6 ff ff       	jmp    801058d3 <alltraps>

8010622b <vector128>:
.globl vector128
vector128:
  pushl $0
8010622b:	6a 00                	push   $0x0
  pushl $128
8010622d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106232:	e9 9c f6 ff ff       	jmp    801058d3 <alltraps>

80106237 <vector129>:
.globl vector129
vector129:
  pushl $0
80106237:	6a 00                	push   $0x0
  pushl $129
80106239:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010623e:	e9 90 f6 ff ff       	jmp    801058d3 <alltraps>

80106243 <vector130>:
.globl vector130
vector130:
  pushl $0
80106243:	6a 00                	push   $0x0
  pushl $130
80106245:	68 82 00 00 00       	push   $0x82
  jmp alltraps
8010624a:	e9 84 f6 ff ff       	jmp    801058d3 <alltraps>

8010624f <vector131>:
.globl vector131
vector131:
  pushl $0
8010624f:	6a 00                	push   $0x0
  pushl $131
80106251:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106256:	e9 78 f6 ff ff       	jmp    801058d3 <alltraps>

8010625b <vector132>:
.globl vector132
vector132:
  pushl $0
8010625b:	6a 00                	push   $0x0
  pushl $132
8010625d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106262:	e9 6c f6 ff ff       	jmp    801058d3 <alltraps>

80106267 <vector133>:
.globl vector133
vector133:
  pushl $0
80106267:	6a 00                	push   $0x0
  pushl $133
80106269:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010626e:	e9 60 f6 ff ff       	jmp    801058d3 <alltraps>

80106273 <vector134>:
.globl vector134
vector134:
  pushl $0
80106273:	6a 00                	push   $0x0
  pushl $134
80106275:	68 86 00 00 00       	push   $0x86
  jmp alltraps
8010627a:	e9 54 f6 ff ff       	jmp    801058d3 <alltraps>

8010627f <vector135>:
.globl vector135
vector135:
  pushl $0
8010627f:	6a 00                	push   $0x0
  pushl $135
80106281:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106286:	e9 48 f6 ff ff       	jmp    801058d3 <alltraps>

8010628b <vector136>:
.globl vector136
vector136:
  pushl $0
8010628b:	6a 00                	push   $0x0
  pushl $136
8010628d:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106292:	e9 3c f6 ff ff       	jmp    801058d3 <alltraps>

80106297 <vector137>:
.globl vector137
vector137:
  pushl $0
80106297:	6a 00                	push   $0x0
  pushl $137
80106299:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010629e:	e9 30 f6 ff ff       	jmp    801058d3 <alltraps>

801062a3 <vector138>:
.globl vector138
vector138:
  pushl $0
801062a3:	6a 00                	push   $0x0
  pushl $138
801062a5:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801062aa:	e9 24 f6 ff ff       	jmp    801058d3 <alltraps>

801062af <vector139>:
.globl vector139
vector139:
  pushl $0
801062af:	6a 00                	push   $0x0
  pushl $139
801062b1:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801062b6:	e9 18 f6 ff ff       	jmp    801058d3 <alltraps>

801062bb <vector140>:
.globl vector140
vector140:
  pushl $0
801062bb:	6a 00                	push   $0x0
  pushl $140
801062bd:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801062c2:	e9 0c f6 ff ff       	jmp    801058d3 <alltraps>

801062c7 <vector141>:
.globl vector141
vector141:
  pushl $0
801062c7:	6a 00                	push   $0x0
  pushl $141
801062c9:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801062ce:	e9 00 f6 ff ff       	jmp    801058d3 <alltraps>

801062d3 <vector142>:
.globl vector142
vector142:
  pushl $0
801062d3:	6a 00                	push   $0x0
  pushl $142
801062d5:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801062da:	e9 f4 f5 ff ff       	jmp    801058d3 <alltraps>

801062df <vector143>:
.globl vector143
vector143:
  pushl $0
801062df:	6a 00                	push   $0x0
  pushl $143
801062e1:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801062e6:	e9 e8 f5 ff ff       	jmp    801058d3 <alltraps>

801062eb <vector144>:
.globl vector144
vector144:
  pushl $0
801062eb:	6a 00                	push   $0x0
  pushl $144
801062ed:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801062f2:	e9 dc f5 ff ff       	jmp    801058d3 <alltraps>

801062f7 <vector145>:
.globl vector145
vector145:
  pushl $0
801062f7:	6a 00                	push   $0x0
  pushl $145
801062f9:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801062fe:	e9 d0 f5 ff ff       	jmp    801058d3 <alltraps>

80106303 <vector146>:
.globl vector146
vector146:
  pushl $0
80106303:	6a 00                	push   $0x0
  pushl $146
80106305:	68 92 00 00 00       	push   $0x92
  jmp alltraps
8010630a:	e9 c4 f5 ff ff       	jmp    801058d3 <alltraps>

8010630f <vector147>:
.globl vector147
vector147:
  pushl $0
8010630f:	6a 00                	push   $0x0
  pushl $147
80106311:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106316:	e9 b8 f5 ff ff       	jmp    801058d3 <alltraps>

8010631b <vector148>:
.globl vector148
vector148:
  pushl $0
8010631b:	6a 00                	push   $0x0
  pushl $148
8010631d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106322:	e9 ac f5 ff ff       	jmp    801058d3 <alltraps>

80106327 <vector149>:
.globl vector149
vector149:
  pushl $0
80106327:	6a 00                	push   $0x0
  pushl $149
80106329:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010632e:	e9 a0 f5 ff ff       	jmp    801058d3 <alltraps>

80106333 <vector150>:
.globl vector150
vector150:
  pushl $0
80106333:	6a 00                	push   $0x0
  pushl $150
80106335:	68 96 00 00 00       	push   $0x96
  jmp alltraps
8010633a:	e9 94 f5 ff ff       	jmp    801058d3 <alltraps>

8010633f <vector151>:
.globl vector151
vector151:
  pushl $0
8010633f:	6a 00                	push   $0x0
  pushl $151
80106341:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106346:	e9 88 f5 ff ff       	jmp    801058d3 <alltraps>

8010634b <vector152>:
.globl vector152
vector152:
  pushl $0
8010634b:	6a 00                	push   $0x0
  pushl $152
8010634d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106352:	e9 7c f5 ff ff       	jmp    801058d3 <alltraps>

80106357 <vector153>:
.globl vector153
vector153:
  pushl $0
80106357:	6a 00                	push   $0x0
  pushl $153
80106359:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010635e:	e9 70 f5 ff ff       	jmp    801058d3 <alltraps>

80106363 <vector154>:
.globl vector154
vector154:
  pushl $0
80106363:	6a 00                	push   $0x0
  pushl $154
80106365:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
8010636a:	e9 64 f5 ff ff       	jmp    801058d3 <alltraps>

8010636f <vector155>:
.globl vector155
vector155:
  pushl $0
8010636f:	6a 00                	push   $0x0
  pushl $155
80106371:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106376:	e9 58 f5 ff ff       	jmp    801058d3 <alltraps>

8010637b <vector156>:
.globl vector156
vector156:
  pushl $0
8010637b:	6a 00                	push   $0x0
  pushl $156
8010637d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106382:	e9 4c f5 ff ff       	jmp    801058d3 <alltraps>

80106387 <vector157>:
.globl vector157
vector157:
  pushl $0
80106387:	6a 00                	push   $0x0
  pushl $157
80106389:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010638e:	e9 40 f5 ff ff       	jmp    801058d3 <alltraps>

80106393 <vector158>:
.globl vector158
vector158:
  pushl $0
80106393:	6a 00                	push   $0x0
  pushl $158
80106395:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
8010639a:	e9 34 f5 ff ff       	jmp    801058d3 <alltraps>

8010639f <vector159>:
.globl vector159
vector159:
  pushl $0
8010639f:	6a 00                	push   $0x0
  pushl $159
801063a1:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801063a6:	e9 28 f5 ff ff       	jmp    801058d3 <alltraps>

801063ab <vector160>:
.globl vector160
vector160:
  pushl $0
801063ab:	6a 00                	push   $0x0
  pushl $160
801063ad:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801063b2:	e9 1c f5 ff ff       	jmp    801058d3 <alltraps>

801063b7 <vector161>:
.globl vector161
vector161:
  pushl $0
801063b7:	6a 00                	push   $0x0
  pushl $161
801063b9:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801063be:	e9 10 f5 ff ff       	jmp    801058d3 <alltraps>

801063c3 <vector162>:
.globl vector162
vector162:
  pushl $0
801063c3:	6a 00                	push   $0x0
  pushl $162
801063c5:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801063ca:	e9 04 f5 ff ff       	jmp    801058d3 <alltraps>

801063cf <vector163>:
.globl vector163
vector163:
  pushl $0
801063cf:	6a 00                	push   $0x0
  pushl $163
801063d1:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801063d6:	e9 f8 f4 ff ff       	jmp    801058d3 <alltraps>

801063db <vector164>:
.globl vector164
vector164:
  pushl $0
801063db:	6a 00                	push   $0x0
  pushl $164
801063dd:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801063e2:	e9 ec f4 ff ff       	jmp    801058d3 <alltraps>

801063e7 <vector165>:
.globl vector165
vector165:
  pushl $0
801063e7:	6a 00                	push   $0x0
  pushl $165
801063e9:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801063ee:	e9 e0 f4 ff ff       	jmp    801058d3 <alltraps>

801063f3 <vector166>:
.globl vector166
vector166:
  pushl $0
801063f3:	6a 00                	push   $0x0
  pushl $166
801063f5:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801063fa:	e9 d4 f4 ff ff       	jmp    801058d3 <alltraps>

801063ff <vector167>:
.globl vector167
vector167:
  pushl $0
801063ff:	6a 00                	push   $0x0
  pushl $167
80106401:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106406:	e9 c8 f4 ff ff       	jmp    801058d3 <alltraps>

8010640b <vector168>:
.globl vector168
vector168:
  pushl $0
8010640b:	6a 00                	push   $0x0
  pushl $168
8010640d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106412:	e9 bc f4 ff ff       	jmp    801058d3 <alltraps>

80106417 <vector169>:
.globl vector169
vector169:
  pushl $0
80106417:	6a 00                	push   $0x0
  pushl $169
80106419:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010641e:	e9 b0 f4 ff ff       	jmp    801058d3 <alltraps>

80106423 <vector170>:
.globl vector170
vector170:
  pushl $0
80106423:	6a 00                	push   $0x0
  pushl $170
80106425:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
8010642a:	e9 a4 f4 ff ff       	jmp    801058d3 <alltraps>

8010642f <vector171>:
.globl vector171
vector171:
  pushl $0
8010642f:	6a 00                	push   $0x0
  pushl $171
80106431:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106436:	e9 98 f4 ff ff       	jmp    801058d3 <alltraps>

8010643b <vector172>:
.globl vector172
vector172:
  pushl $0
8010643b:	6a 00                	push   $0x0
  pushl $172
8010643d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106442:	e9 8c f4 ff ff       	jmp    801058d3 <alltraps>

80106447 <vector173>:
.globl vector173
vector173:
  pushl $0
80106447:	6a 00                	push   $0x0
  pushl $173
80106449:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010644e:	e9 80 f4 ff ff       	jmp    801058d3 <alltraps>

80106453 <vector174>:
.globl vector174
vector174:
  pushl $0
80106453:	6a 00                	push   $0x0
  pushl $174
80106455:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
8010645a:	e9 74 f4 ff ff       	jmp    801058d3 <alltraps>

8010645f <vector175>:
.globl vector175
vector175:
  pushl $0
8010645f:	6a 00                	push   $0x0
  pushl $175
80106461:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106466:	e9 68 f4 ff ff       	jmp    801058d3 <alltraps>

8010646b <vector176>:
.globl vector176
vector176:
  pushl $0
8010646b:	6a 00                	push   $0x0
  pushl $176
8010646d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106472:	e9 5c f4 ff ff       	jmp    801058d3 <alltraps>

80106477 <vector177>:
.globl vector177
vector177:
  pushl $0
80106477:	6a 00                	push   $0x0
  pushl $177
80106479:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010647e:	e9 50 f4 ff ff       	jmp    801058d3 <alltraps>

80106483 <vector178>:
.globl vector178
vector178:
  pushl $0
80106483:	6a 00                	push   $0x0
  pushl $178
80106485:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
8010648a:	e9 44 f4 ff ff       	jmp    801058d3 <alltraps>

8010648f <vector179>:
.globl vector179
vector179:
  pushl $0
8010648f:	6a 00                	push   $0x0
  pushl $179
80106491:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106496:	e9 38 f4 ff ff       	jmp    801058d3 <alltraps>

8010649b <vector180>:
.globl vector180
vector180:
  pushl $0
8010649b:	6a 00                	push   $0x0
  pushl $180
8010649d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801064a2:	e9 2c f4 ff ff       	jmp    801058d3 <alltraps>

801064a7 <vector181>:
.globl vector181
vector181:
  pushl $0
801064a7:	6a 00                	push   $0x0
  pushl $181
801064a9:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801064ae:	e9 20 f4 ff ff       	jmp    801058d3 <alltraps>

801064b3 <vector182>:
.globl vector182
vector182:
  pushl $0
801064b3:	6a 00                	push   $0x0
  pushl $182
801064b5:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801064ba:	e9 14 f4 ff ff       	jmp    801058d3 <alltraps>

801064bf <vector183>:
.globl vector183
vector183:
  pushl $0
801064bf:	6a 00                	push   $0x0
  pushl $183
801064c1:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801064c6:	e9 08 f4 ff ff       	jmp    801058d3 <alltraps>

801064cb <vector184>:
.globl vector184
vector184:
  pushl $0
801064cb:	6a 00                	push   $0x0
  pushl $184
801064cd:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801064d2:	e9 fc f3 ff ff       	jmp    801058d3 <alltraps>

801064d7 <vector185>:
.globl vector185
vector185:
  pushl $0
801064d7:	6a 00                	push   $0x0
  pushl $185
801064d9:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801064de:	e9 f0 f3 ff ff       	jmp    801058d3 <alltraps>

801064e3 <vector186>:
.globl vector186
vector186:
  pushl $0
801064e3:	6a 00                	push   $0x0
  pushl $186
801064e5:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801064ea:	e9 e4 f3 ff ff       	jmp    801058d3 <alltraps>

801064ef <vector187>:
.globl vector187
vector187:
  pushl $0
801064ef:	6a 00                	push   $0x0
  pushl $187
801064f1:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801064f6:	e9 d8 f3 ff ff       	jmp    801058d3 <alltraps>

801064fb <vector188>:
.globl vector188
vector188:
  pushl $0
801064fb:	6a 00                	push   $0x0
  pushl $188
801064fd:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106502:	e9 cc f3 ff ff       	jmp    801058d3 <alltraps>

80106507 <vector189>:
.globl vector189
vector189:
  pushl $0
80106507:	6a 00                	push   $0x0
  pushl $189
80106509:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010650e:	e9 c0 f3 ff ff       	jmp    801058d3 <alltraps>

80106513 <vector190>:
.globl vector190
vector190:
  pushl $0
80106513:	6a 00                	push   $0x0
  pushl $190
80106515:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
8010651a:	e9 b4 f3 ff ff       	jmp    801058d3 <alltraps>

8010651f <vector191>:
.globl vector191
vector191:
  pushl $0
8010651f:	6a 00                	push   $0x0
  pushl $191
80106521:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106526:	e9 a8 f3 ff ff       	jmp    801058d3 <alltraps>

8010652b <vector192>:
.globl vector192
vector192:
  pushl $0
8010652b:	6a 00                	push   $0x0
  pushl $192
8010652d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106532:	e9 9c f3 ff ff       	jmp    801058d3 <alltraps>

80106537 <vector193>:
.globl vector193
vector193:
  pushl $0
80106537:	6a 00                	push   $0x0
  pushl $193
80106539:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010653e:	e9 90 f3 ff ff       	jmp    801058d3 <alltraps>

80106543 <vector194>:
.globl vector194
vector194:
  pushl $0
80106543:	6a 00                	push   $0x0
  pushl $194
80106545:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
8010654a:	e9 84 f3 ff ff       	jmp    801058d3 <alltraps>

8010654f <vector195>:
.globl vector195
vector195:
  pushl $0
8010654f:	6a 00                	push   $0x0
  pushl $195
80106551:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106556:	e9 78 f3 ff ff       	jmp    801058d3 <alltraps>

8010655b <vector196>:
.globl vector196
vector196:
  pushl $0
8010655b:	6a 00                	push   $0x0
  pushl $196
8010655d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106562:	e9 6c f3 ff ff       	jmp    801058d3 <alltraps>

80106567 <vector197>:
.globl vector197
vector197:
  pushl $0
80106567:	6a 00                	push   $0x0
  pushl $197
80106569:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010656e:	e9 60 f3 ff ff       	jmp    801058d3 <alltraps>

80106573 <vector198>:
.globl vector198
vector198:
  pushl $0
80106573:	6a 00                	push   $0x0
  pushl $198
80106575:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
8010657a:	e9 54 f3 ff ff       	jmp    801058d3 <alltraps>

8010657f <vector199>:
.globl vector199
vector199:
  pushl $0
8010657f:	6a 00                	push   $0x0
  pushl $199
80106581:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106586:	e9 48 f3 ff ff       	jmp    801058d3 <alltraps>

8010658b <vector200>:
.globl vector200
vector200:
  pushl $0
8010658b:	6a 00                	push   $0x0
  pushl $200
8010658d:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106592:	e9 3c f3 ff ff       	jmp    801058d3 <alltraps>

80106597 <vector201>:
.globl vector201
vector201:
  pushl $0
80106597:	6a 00                	push   $0x0
  pushl $201
80106599:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010659e:	e9 30 f3 ff ff       	jmp    801058d3 <alltraps>

801065a3 <vector202>:
.globl vector202
vector202:
  pushl $0
801065a3:	6a 00                	push   $0x0
  pushl $202
801065a5:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801065aa:	e9 24 f3 ff ff       	jmp    801058d3 <alltraps>

801065af <vector203>:
.globl vector203
vector203:
  pushl $0
801065af:	6a 00                	push   $0x0
  pushl $203
801065b1:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801065b6:	e9 18 f3 ff ff       	jmp    801058d3 <alltraps>

801065bb <vector204>:
.globl vector204
vector204:
  pushl $0
801065bb:	6a 00                	push   $0x0
  pushl $204
801065bd:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801065c2:	e9 0c f3 ff ff       	jmp    801058d3 <alltraps>

801065c7 <vector205>:
.globl vector205
vector205:
  pushl $0
801065c7:	6a 00                	push   $0x0
  pushl $205
801065c9:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801065ce:	e9 00 f3 ff ff       	jmp    801058d3 <alltraps>

801065d3 <vector206>:
.globl vector206
vector206:
  pushl $0
801065d3:	6a 00                	push   $0x0
  pushl $206
801065d5:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801065da:	e9 f4 f2 ff ff       	jmp    801058d3 <alltraps>

801065df <vector207>:
.globl vector207
vector207:
  pushl $0
801065df:	6a 00                	push   $0x0
  pushl $207
801065e1:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801065e6:	e9 e8 f2 ff ff       	jmp    801058d3 <alltraps>

801065eb <vector208>:
.globl vector208
vector208:
  pushl $0
801065eb:	6a 00                	push   $0x0
  pushl $208
801065ed:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801065f2:	e9 dc f2 ff ff       	jmp    801058d3 <alltraps>

801065f7 <vector209>:
.globl vector209
vector209:
  pushl $0
801065f7:	6a 00                	push   $0x0
  pushl $209
801065f9:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801065fe:	e9 d0 f2 ff ff       	jmp    801058d3 <alltraps>

80106603 <vector210>:
.globl vector210
vector210:
  pushl $0
80106603:	6a 00                	push   $0x0
  pushl $210
80106605:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
8010660a:	e9 c4 f2 ff ff       	jmp    801058d3 <alltraps>

8010660f <vector211>:
.globl vector211
vector211:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $211
80106611:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106616:	e9 b8 f2 ff ff       	jmp    801058d3 <alltraps>

8010661b <vector212>:
.globl vector212
vector212:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $212
8010661d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106622:	e9 ac f2 ff ff       	jmp    801058d3 <alltraps>

80106627 <vector213>:
.globl vector213
vector213:
  pushl $0
80106627:	6a 00                	push   $0x0
  pushl $213
80106629:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010662e:	e9 a0 f2 ff ff       	jmp    801058d3 <alltraps>

80106633 <vector214>:
.globl vector214
vector214:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $214
80106635:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
8010663a:	e9 94 f2 ff ff       	jmp    801058d3 <alltraps>

8010663f <vector215>:
.globl vector215
vector215:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $215
80106641:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106646:	e9 88 f2 ff ff       	jmp    801058d3 <alltraps>

8010664b <vector216>:
.globl vector216
vector216:
  pushl $0
8010664b:	6a 00                	push   $0x0
  pushl $216
8010664d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106652:	e9 7c f2 ff ff       	jmp    801058d3 <alltraps>

80106657 <vector217>:
.globl vector217
vector217:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $217
80106659:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010665e:	e9 70 f2 ff ff       	jmp    801058d3 <alltraps>

80106663 <vector218>:
.globl vector218
vector218:
  pushl $0
80106663:	6a 00                	push   $0x0
  pushl $218
80106665:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010666a:	e9 64 f2 ff ff       	jmp    801058d3 <alltraps>

8010666f <vector219>:
.globl vector219
vector219:
  pushl $0
8010666f:	6a 00                	push   $0x0
  pushl $219
80106671:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106676:	e9 58 f2 ff ff       	jmp    801058d3 <alltraps>

8010667b <vector220>:
.globl vector220
vector220:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $220
8010667d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106682:	e9 4c f2 ff ff       	jmp    801058d3 <alltraps>

80106687 <vector221>:
.globl vector221
vector221:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $221
80106689:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010668e:	e9 40 f2 ff ff       	jmp    801058d3 <alltraps>

80106693 <vector222>:
.globl vector222
vector222:
  pushl $0
80106693:	6a 00                	push   $0x0
  pushl $222
80106695:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010669a:	e9 34 f2 ff ff       	jmp    801058d3 <alltraps>

8010669f <vector223>:
.globl vector223
vector223:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $223
801066a1:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801066a6:	e9 28 f2 ff ff       	jmp    801058d3 <alltraps>

801066ab <vector224>:
.globl vector224
vector224:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $224
801066ad:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801066b2:	e9 1c f2 ff ff       	jmp    801058d3 <alltraps>

801066b7 <vector225>:
.globl vector225
vector225:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $225
801066b9:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801066be:	e9 10 f2 ff ff       	jmp    801058d3 <alltraps>

801066c3 <vector226>:
.globl vector226
vector226:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $226
801066c5:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801066ca:	e9 04 f2 ff ff       	jmp    801058d3 <alltraps>

801066cf <vector227>:
.globl vector227
vector227:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $227
801066d1:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801066d6:	e9 f8 f1 ff ff       	jmp    801058d3 <alltraps>

801066db <vector228>:
.globl vector228
vector228:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $228
801066dd:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801066e2:	e9 ec f1 ff ff       	jmp    801058d3 <alltraps>

801066e7 <vector229>:
.globl vector229
vector229:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $229
801066e9:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801066ee:	e9 e0 f1 ff ff       	jmp    801058d3 <alltraps>

801066f3 <vector230>:
.globl vector230
vector230:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $230
801066f5:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801066fa:	e9 d4 f1 ff ff       	jmp    801058d3 <alltraps>

801066ff <vector231>:
.globl vector231
vector231:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $231
80106701:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106706:	e9 c8 f1 ff ff       	jmp    801058d3 <alltraps>

8010670b <vector232>:
.globl vector232
vector232:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $232
8010670d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106712:	e9 bc f1 ff ff       	jmp    801058d3 <alltraps>

80106717 <vector233>:
.globl vector233
vector233:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $233
80106719:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010671e:	e9 b0 f1 ff ff       	jmp    801058d3 <alltraps>

80106723 <vector234>:
.globl vector234
vector234:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $234
80106725:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
8010672a:	e9 a4 f1 ff ff       	jmp    801058d3 <alltraps>

8010672f <vector235>:
.globl vector235
vector235:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $235
80106731:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106736:	e9 98 f1 ff ff       	jmp    801058d3 <alltraps>

8010673b <vector236>:
.globl vector236
vector236:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $236
8010673d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106742:	e9 8c f1 ff ff       	jmp    801058d3 <alltraps>

80106747 <vector237>:
.globl vector237
vector237:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $237
80106749:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010674e:	e9 80 f1 ff ff       	jmp    801058d3 <alltraps>

80106753 <vector238>:
.globl vector238
vector238:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $238
80106755:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
8010675a:	e9 74 f1 ff ff       	jmp    801058d3 <alltraps>

8010675f <vector239>:
.globl vector239
vector239:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $239
80106761:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106766:	e9 68 f1 ff ff       	jmp    801058d3 <alltraps>

8010676b <vector240>:
.globl vector240
vector240:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $240
8010676d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106772:	e9 5c f1 ff ff       	jmp    801058d3 <alltraps>

80106777 <vector241>:
.globl vector241
vector241:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $241
80106779:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010677e:	e9 50 f1 ff ff       	jmp    801058d3 <alltraps>

80106783 <vector242>:
.globl vector242
vector242:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $242
80106785:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
8010678a:	e9 44 f1 ff ff       	jmp    801058d3 <alltraps>

8010678f <vector243>:
.globl vector243
vector243:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $243
80106791:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106796:	e9 38 f1 ff ff       	jmp    801058d3 <alltraps>

8010679b <vector244>:
.globl vector244
vector244:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $244
8010679d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801067a2:	e9 2c f1 ff ff       	jmp    801058d3 <alltraps>

801067a7 <vector245>:
.globl vector245
vector245:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $245
801067a9:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801067ae:	e9 20 f1 ff ff       	jmp    801058d3 <alltraps>

801067b3 <vector246>:
.globl vector246
vector246:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $246
801067b5:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801067ba:	e9 14 f1 ff ff       	jmp    801058d3 <alltraps>

801067bf <vector247>:
.globl vector247
vector247:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $247
801067c1:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801067c6:	e9 08 f1 ff ff       	jmp    801058d3 <alltraps>

801067cb <vector248>:
.globl vector248
vector248:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $248
801067cd:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801067d2:	e9 fc f0 ff ff       	jmp    801058d3 <alltraps>

801067d7 <vector249>:
.globl vector249
vector249:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $249
801067d9:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801067de:	e9 f0 f0 ff ff       	jmp    801058d3 <alltraps>

801067e3 <vector250>:
.globl vector250
vector250:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $250
801067e5:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801067ea:	e9 e4 f0 ff ff       	jmp    801058d3 <alltraps>

801067ef <vector251>:
.globl vector251
vector251:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $251
801067f1:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801067f6:	e9 d8 f0 ff ff       	jmp    801058d3 <alltraps>

801067fb <vector252>:
.globl vector252
vector252:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $252
801067fd:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106802:	e9 cc f0 ff ff       	jmp    801058d3 <alltraps>

80106807 <vector253>:
.globl vector253
vector253:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $253
80106809:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010680e:	e9 c0 f0 ff ff       	jmp    801058d3 <alltraps>

80106813 <vector254>:
.globl vector254
vector254:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $254
80106815:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
8010681a:	e9 b4 f0 ff ff       	jmp    801058d3 <alltraps>

8010681f <vector255>:
.globl vector255
vector255:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $255
80106821:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106826:	e9 a8 f0 ff ff       	jmp    801058d3 <alltraps>
8010682b:	66 90                	xchg   %ax,%ax
8010682d:	66 90                	xchg   %ax,%ax
8010682f:	90                   	nop

80106830 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106830:	55                   	push   %ebp
80106831:	89 e5                	mov    %esp,%ebp
80106833:	57                   	push   %edi
80106834:	56                   	push   %esi
80106835:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106837:	c1 ea 16             	shr    $0x16,%edx
{
8010683a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
8010683b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
8010683e:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106841:	8b 1f                	mov    (%edi),%ebx
80106843:	f6 c3 01             	test   $0x1,%bl
80106846:	74 28                	je     80106870 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106848:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010684e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106854:	89 f0                	mov    %esi,%eax
}
80106856:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106859:	c1 e8 0a             	shr    $0xa,%eax
8010685c:	25 fc 0f 00 00       	and    $0xffc,%eax
80106861:	01 d8                	add    %ebx,%eax
}
80106863:	5b                   	pop    %ebx
80106864:	5e                   	pop    %esi
80106865:	5f                   	pop    %edi
80106866:	5d                   	pop    %ebp
80106867:	c3                   	ret    
80106868:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010686f:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106870:	85 c9                	test   %ecx,%ecx
80106872:	74 2c                	je     801068a0 <walkpgdir+0x70>
80106874:	e8 d7 bd ff ff       	call   80102650 <kalloc>
80106879:	89 c3                	mov    %eax,%ebx
8010687b:	85 c0                	test   %eax,%eax
8010687d:	74 21                	je     801068a0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010687f:	83 ec 04             	sub    $0x4,%esp
80106882:	68 00 10 00 00       	push   $0x1000
80106887:	6a 00                	push   $0x0
80106889:	50                   	push   %eax
8010688a:	e8 01 de ff ff       	call   80104690 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010688f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106895:	83 c4 10             	add    $0x10,%esp
80106898:	83 c8 07             	or     $0x7,%eax
8010689b:	89 07                	mov    %eax,(%edi)
8010689d:	eb b5                	jmp    80106854 <walkpgdir+0x24>
8010689f:	90                   	nop
}
801068a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801068a3:	31 c0                	xor    %eax,%eax
}
801068a5:	5b                   	pop    %ebx
801068a6:	5e                   	pop    %esi
801068a7:	5f                   	pop    %edi
801068a8:	5d                   	pop    %ebp
801068a9:	c3                   	ret    
801068aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801068b0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801068b0:	55                   	push   %ebp
801068b1:	89 e5                	mov    %esp,%ebp
801068b3:	57                   	push   %edi
801068b4:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801068b6:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
801068ba:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801068bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
801068c0:	89 d6                	mov    %edx,%esi
{
801068c2:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
801068c3:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
801068c9:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801068cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
801068cf:	8b 45 08             	mov    0x8(%ebp),%eax
801068d2:	29 f0                	sub    %esi,%eax
801068d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801068d7:	eb 1f                	jmp    801068f8 <mappages+0x48>
801068d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
801068e0:	f6 00 01             	testb  $0x1,(%eax)
801068e3:	75 45                	jne    8010692a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
801068e5:	0b 5d 0c             	or     0xc(%ebp),%ebx
801068e8:	83 cb 01             	or     $0x1,%ebx
801068eb:	89 18                	mov    %ebx,(%eax)
    if(a == last)
801068ed:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801068f0:	74 2e                	je     80106920 <mappages+0x70>
      break;
    a += PGSIZE;
801068f2:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
801068f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801068fb:	b9 01 00 00 00       	mov    $0x1,%ecx
80106900:	89 f2                	mov    %esi,%edx
80106902:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80106905:	89 f8                	mov    %edi,%eax
80106907:	e8 24 ff ff ff       	call   80106830 <walkpgdir>
8010690c:	85 c0                	test   %eax,%eax
8010690e:	75 d0                	jne    801068e0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106910:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106913:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106918:	5b                   	pop    %ebx
80106919:	5e                   	pop    %esi
8010691a:	5f                   	pop    %edi
8010691b:	5d                   	pop    %ebp
8010691c:	c3                   	ret    
8010691d:	8d 76 00             	lea    0x0(%esi),%esi
80106920:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106923:	31 c0                	xor    %eax,%eax
}
80106925:	5b                   	pop    %ebx
80106926:	5e                   	pop    %esi
80106927:	5f                   	pop    %edi
80106928:	5d                   	pop    %ebp
80106929:	c3                   	ret    
      panic("remap");
8010692a:	83 ec 0c             	sub    $0xc,%esp
8010692d:	68 2c 7a 10 80       	push   $0x80107a2c
80106932:	e8 59 9a ff ff       	call   80100390 <panic>
80106937:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010693e:	66 90                	xchg   %ax,%ax

80106940 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106940:	55                   	push   %ebp
80106941:	89 e5                	mov    %esp,%ebp
80106943:	57                   	push   %edi
80106944:	56                   	push   %esi
80106945:	89 c6                	mov    %eax,%esi
80106947:	53                   	push   %ebx
80106948:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010694a:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
80106950:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106956:	83 ec 1c             	sub    $0x1c,%esp
80106959:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010695c:	39 da                	cmp    %ebx,%edx
8010695e:	73 5b                	jae    801069bb <deallocuvm.part.0+0x7b>
80106960:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80106963:	89 d7                	mov    %edx,%edi
80106965:	eb 14                	jmp    8010697b <deallocuvm.part.0+0x3b>
80106967:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010696e:	66 90                	xchg   %ax,%ax
80106970:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106976:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80106979:	76 40                	jbe    801069bb <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010697b:	31 c9                	xor    %ecx,%ecx
8010697d:	89 fa                	mov    %edi,%edx
8010697f:	89 f0                	mov    %esi,%eax
80106981:	e8 aa fe ff ff       	call   80106830 <walkpgdir>
80106986:	89 c3                	mov    %eax,%ebx
    if(!pte)
80106988:	85 c0                	test   %eax,%eax
8010698a:	74 44                	je     801069d0 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
8010698c:	8b 00                	mov    (%eax),%eax
8010698e:	a8 01                	test   $0x1,%al
80106990:	74 de                	je     80106970 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106992:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106997:	74 47                	je     801069e0 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106999:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010699c:	05 00 00 00 80       	add    $0x80000000,%eax
801069a1:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
801069a7:	50                   	push   %eax
801069a8:	e8 e3 ba ff ff       	call   80102490 <kfree>
      *pte = 0;
801069ad:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801069b3:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
801069b6:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801069b9:	77 c0                	ja     8010697b <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
801069bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801069be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801069c1:	5b                   	pop    %ebx
801069c2:	5e                   	pop    %esi
801069c3:	5f                   	pop    %edi
801069c4:	5d                   	pop    %ebp
801069c5:	c3                   	ret    
801069c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069cd:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801069d0:	89 fa                	mov    %edi,%edx
801069d2:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
801069d8:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
801069de:	eb 96                	jmp    80106976 <deallocuvm.part.0+0x36>
        panic("kfree");
801069e0:	83 ec 0c             	sub    $0xc,%esp
801069e3:	68 e6 73 10 80       	push   $0x801073e6
801069e8:	e8 a3 99 ff ff       	call   80100390 <panic>
801069ed:	8d 76 00             	lea    0x0(%esi),%esi

801069f0 <seginit>:
{
801069f0:	f3 0f 1e fb          	endbr32 
801069f4:	55                   	push   %ebp
801069f5:	89 e5                	mov    %esp,%ebp
801069f7:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801069fa:	e8 61 cf ff ff       	call   80103960 <cpuid>
  pd[0] = size-1;
801069ff:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106a04:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106a0a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106a0e:	c7 80 f8 27 11 80 ff 	movl   $0xffff,-0x7feed808(%eax)
80106a15:	ff 00 00 
80106a18:	c7 80 fc 27 11 80 00 	movl   $0xcf9a00,-0x7feed804(%eax)
80106a1f:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106a22:	c7 80 00 28 11 80 ff 	movl   $0xffff,-0x7feed800(%eax)
80106a29:	ff 00 00 
80106a2c:	c7 80 04 28 11 80 00 	movl   $0xcf9200,-0x7feed7fc(%eax)
80106a33:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106a36:	c7 80 08 28 11 80 ff 	movl   $0xffff,-0x7feed7f8(%eax)
80106a3d:	ff 00 00 
80106a40:	c7 80 0c 28 11 80 00 	movl   $0xcffa00,-0x7feed7f4(%eax)
80106a47:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106a4a:	c7 80 10 28 11 80 ff 	movl   $0xffff,-0x7feed7f0(%eax)
80106a51:	ff 00 00 
80106a54:	c7 80 14 28 11 80 00 	movl   $0xcff200,-0x7feed7ec(%eax)
80106a5b:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106a5e:	05 f0 27 11 80       	add    $0x801127f0,%eax
  pd[1] = (uint)p;
80106a63:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106a67:	c1 e8 10             	shr    $0x10,%eax
80106a6a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106a6e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106a71:	0f 01 10             	lgdtl  (%eax)
}
80106a74:	c9                   	leave  
80106a75:	c3                   	ret    
80106a76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a7d:	8d 76 00             	lea    0x0(%esi),%esi

80106a80 <switchkvm>:
{
80106a80:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106a84:	a1 a4 55 11 80       	mov    0x801155a4,%eax
80106a89:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106a8e:	0f 22 d8             	mov    %eax,%cr3
}
80106a91:	c3                   	ret    
80106a92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106aa0 <switchuvm>:
{
80106aa0:	f3 0f 1e fb          	endbr32 
80106aa4:	55                   	push   %ebp
80106aa5:	89 e5                	mov    %esp,%ebp
80106aa7:	57                   	push   %edi
80106aa8:	56                   	push   %esi
80106aa9:	53                   	push   %ebx
80106aaa:	83 ec 1c             	sub    $0x1c,%esp
80106aad:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106ab0:	85 f6                	test   %esi,%esi
80106ab2:	0f 84 cb 00 00 00    	je     80106b83 <switchuvm+0xe3>
  if(p->kstack == 0)
80106ab8:	8b 46 08             	mov    0x8(%esi),%eax
80106abb:	85 c0                	test   %eax,%eax
80106abd:	0f 84 da 00 00 00    	je     80106b9d <switchuvm+0xfd>
  if(p->pgdir == 0)
80106ac3:	8b 46 04             	mov    0x4(%esi),%eax
80106ac6:	85 c0                	test   %eax,%eax
80106ac8:	0f 84 c2 00 00 00    	je     80106b90 <switchuvm+0xf0>
  pushcli();
80106ace:	e8 ad d9 ff ff       	call   80104480 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106ad3:	e8 18 ce ff ff       	call   801038f0 <mycpu>
80106ad8:	89 c3                	mov    %eax,%ebx
80106ada:	e8 11 ce ff ff       	call   801038f0 <mycpu>
80106adf:	89 c7                	mov    %eax,%edi
80106ae1:	e8 0a ce ff ff       	call   801038f0 <mycpu>
80106ae6:	83 c7 08             	add    $0x8,%edi
80106ae9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106aec:	e8 ff cd ff ff       	call   801038f0 <mycpu>
80106af1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106af4:	ba 67 00 00 00       	mov    $0x67,%edx
80106af9:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106b00:	83 c0 08             	add    $0x8,%eax
80106b03:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106b0a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106b0f:	83 c1 08             	add    $0x8,%ecx
80106b12:	c1 e8 18             	shr    $0x18,%eax
80106b15:	c1 e9 10             	shr    $0x10,%ecx
80106b18:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106b1e:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106b24:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106b29:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106b30:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106b35:	e8 b6 cd ff ff       	call   801038f0 <mycpu>
80106b3a:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106b41:	e8 aa cd ff ff       	call   801038f0 <mycpu>
80106b46:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106b4a:	8b 5e 08             	mov    0x8(%esi),%ebx
80106b4d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106b53:	e8 98 cd ff ff       	call   801038f0 <mycpu>
80106b58:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106b5b:	e8 90 cd ff ff       	call   801038f0 <mycpu>
80106b60:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106b64:	b8 28 00 00 00       	mov    $0x28,%eax
80106b69:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106b6c:	8b 46 04             	mov    0x4(%esi),%eax
80106b6f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106b74:	0f 22 d8             	mov    %eax,%cr3
}
80106b77:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b7a:	5b                   	pop    %ebx
80106b7b:	5e                   	pop    %esi
80106b7c:	5f                   	pop    %edi
80106b7d:	5d                   	pop    %ebp
  popcli();
80106b7e:	e9 4d d9 ff ff       	jmp    801044d0 <popcli>
    panic("switchuvm: no process");
80106b83:	83 ec 0c             	sub    $0xc,%esp
80106b86:	68 32 7a 10 80       	push   $0x80107a32
80106b8b:	e8 00 98 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106b90:	83 ec 0c             	sub    $0xc,%esp
80106b93:	68 5d 7a 10 80       	push   $0x80107a5d
80106b98:	e8 f3 97 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106b9d:	83 ec 0c             	sub    $0xc,%esp
80106ba0:	68 48 7a 10 80       	push   $0x80107a48
80106ba5:	e8 e6 97 ff ff       	call   80100390 <panic>
80106baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106bb0 <inituvm>:
{
80106bb0:	f3 0f 1e fb          	endbr32 
80106bb4:	55                   	push   %ebp
80106bb5:	89 e5                	mov    %esp,%ebp
80106bb7:	57                   	push   %edi
80106bb8:	56                   	push   %esi
80106bb9:	53                   	push   %ebx
80106bba:	83 ec 1c             	sub    $0x1c,%esp
80106bbd:	8b 45 0c             	mov    0xc(%ebp),%eax
80106bc0:	8b 75 10             	mov    0x10(%ebp),%esi
80106bc3:	8b 7d 08             	mov    0x8(%ebp),%edi
80106bc6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106bc9:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106bcf:	77 4b                	ja     80106c1c <inituvm+0x6c>
  mem = kalloc();
80106bd1:	e8 7a ba ff ff       	call   80102650 <kalloc>
  memset(mem, 0, PGSIZE);
80106bd6:	83 ec 04             	sub    $0x4,%esp
80106bd9:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106bde:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106be0:	6a 00                	push   $0x0
80106be2:	50                   	push   %eax
80106be3:	e8 a8 da ff ff       	call   80104690 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106be8:	58                   	pop    %eax
80106be9:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106bef:	5a                   	pop    %edx
80106bf0:	6a 06                	push   $0x6
80106bf2:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106bf7:	31 d2                	xor    %edx,%edx
80106bf9:	50                   	push   %eax
80106bfa:	89 f8                	mov    %edi,%eax
80106bfc:	e8 af fc ff ff       	call   801068b0 <mappages>
  memmove(mem, init, sz);
80106c01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c04:	89 75 10             	mov    %esi,0x10(%ebp)
80106c07:	83 c4 10             	add    $0x10,%esp
80106c0a:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106c0d:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80106c10:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c13:	5b                   	pop    %ebx
80106c14:	5e                   	pop    %esi
80106c15:	5f                   	pop    %edi
80106c16:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106c17:	e9 14 db ff ff       	jmp    80104730 <memmove>
    panic("inituvm: more than a page");
80106c1c:	83 ec 0c             	sub    $0xc,%esp
80106c1f:	68 71 7a 10 80       	push   $0x80107a71
80106c24:	e8 67 97 ff ff       	call   80100390 <panic>
80106c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106c30 <loaduvm>:
{
80106c30:	f3 0f 1e fb          	endbr32 
80106c34:	55                   	push   %ebp
80106c35:	89 e5                	mov    %esp,%ebp
80106c37:	57                   	push   %edi
80106c38:	56                   	push   %esi
80106c39:	53                   	push   %ebx
80106c3a:	83 ec 1c             	sub    $0x1c,%esp
80106c3d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c40:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106c43:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106c48:	0f 85 99 00 00 00    	jne    80106ce7 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
80106c4e:	01 f0                	add    %esi,%eax
80106c50:	89 f3                	mov    %esi,%ebx
80106c52:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106c55:	8b 45 14             	mov    0x14(%ebp),%eax
80106c58:	01 f0                	add    %esi,%eax
80106c5a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106c5d:	85 f6                	test   %esi,%esi
80106c5f:	75 15                	jne    80106c76 <loaduvm+0x46>
80106c61:	eb 6d                	jmp    80106cd0 <loaduvm+0xa0>
80106c63:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106c67:	90                   	nop
80106c68:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106c6e:	89 f0                	mov    %esi,%eax
80106c70:	29 d8                	sub    %ebx,%eax
80106c72:	39 c6                	cmp    %eax,%esi
80106c74:	76 5a                	jbe    80106cd0 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106c76:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106c79:	8b 45 08             	mov    0x8(%ebp),%eax
80106c7c:	31 c9                	xor    %ecx,%ecx
80106c7e:	29 da                	sub    %ebx,%edx
80106c80:	e8 ab fb ff ff       	call   80106830 <walkpgdir>
80106c85:	85 c0                	test   %eax,%eax
80106c87:	74 51                	je     80106cda <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80106c89:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106c8b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106c8e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106c93:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106c98:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106c9e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ca1:	29 d9                	sub    %ebx,%ecx
80106ca3:	05 00 00 00 80       	add    $0x80000000,%eax
80106ca8:	57                   	push   %edi
80106ca9:	51                   	push   %ecx
80106caa:	50                   	push   %eax
80106cab:	ff 75 10             	pushl  0x10(%ebp)
80106cae:	e8 cd ad ff ff       	call   80101a80 <readi>
80106cb3:	83 c4 10             	add    $0x10,%esp
80106cb6:	39 f8                	cmp    %edi,%eax
80106cb8:	74 ae                	je     80106c68 <loaduvm+0x38>
}
80106cba:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106cbd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106cc2:	5b                   	pop    %ebx
80106cc3:	5e                   	pop    %esi
80106cc4:	5f                   	pop    %edi
80106cc5:	5d                   	pop    %ebp
80106cc6:	c3                   	ret    
80106cc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cce:	66 90                	xchg   %ax,%ax
80106cd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106cd3:	31 c0                	xor    %eax,%eax
}
80106cd5:	5b                   	pop    %ebx
80106cd6:	5e                   	pop    %esi
80106cd7:	5f                   	pop    %edi
80106cd8:	5d                   	pop    %ebp
80106cd9:	c3                   	ret    
      panic("loaduvm: address should exist");
80106cda:	83 ec 0c             	sub    $0xc,%esp
80106cdd:	68 8b 7a 10 80       	push   $0x80107a8b
80106ce2:	e8 a9 96 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80106ce7:	83 ec 0c             	sub    $0xc,%esp
80106cea:	68 2c 7b 10 80       	push   $0x80107b2c
80106cef:	e8 9c 96 ff ff       	call   80100390 <panic>
80106cf4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106cff:	90                   	nop

80106d00 <allocuvm>:
{
80106d00:	f3 0f 1e fb          	endbr32 
80106d04:	55                   	push   %ebp
80106d05:	89 e5                	mov    %esp,%ebp
80106d07:	57                   	push   %edi
80106d08:	56                   	push   %esi
80106d09:	53                   	push   %ebx
80106d0a:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106d0d:	8b 45 10             	mov    0x10(%ebp),%eax
{
80106d10:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80106d13:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106d16:	85 c0                	test   %eax,%eax
80106d18:	0f 88 b2 00 00 00    	js     80106dd0 <allocuvm+0xd0>
  if(newsz < oldsz)
80106d1e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80106d21:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80106d24:	0f 82 96 00 00 00    	jb     80106dc0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106d2a:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80106d30:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106d36:	39 75 10             	cmp    %esi,0x10(%ebp)
80106d39:	77 40                	ja     80106d7b <allocuvm+0x7b>
80106d3b:	e9 83 00 00 00       	jmp    80106dc3 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
80106d40:	83 ec 04             	sub    $0x4,%esp
80106d43:	68 00 10 00 00       	push   $0x1000
80106d48:	6a 00                	push   $0x0
80106d4a:	50                   	push   %eax
80106d4b:	e8 40 d9 ff ff       	call   80104690 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106d50:	58                   	pop    %eax
80106d51:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106d57:	5a                   	pop    %edx
80106d58:	6a 06                	push   $0x6
80106d5a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106d5f:	89 f2                	mov    %esi,%edx
80106d61:	50                   	push   %eax
80106d62:	89 f8                	mov    %edi,%eax
80106d64:	e8 47 fb ff ff       	call   801068b0 <mappages>
80106d69:	83 c4 10             	add    $0x10,%esp
80106d6c:	85 c0                	test   %eax,%eax
80106d6e:	78 78                	js     80106de8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80106d70:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106d76:	39 75 10             	cmp    %esi,0x10(%ebp)
80106d79:	76 48                	jbe    80106dc3 <allocuvm+0xc3>
    mem = kalloc();
80106d7b:	e8 d0 b8 ff ff       	call   80102650 <kalloc>
80106d80:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106d82:	85 c0                	test   %eax,%eax
80106d84:	75 ba                	jne    80106d40 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106d86:	83 ec 0c             	sub    $0xc,%esp
80106d89:	68 a9 7a 10 80       	push   $0x80107aa9
80106d8e:	e8 1d 99 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106d93:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d96:	83 c4 10             	add    $0x10,%esp
80106d99:	39 45 10             	cmp    %eax,0x10(%ebp)
80106d9c:	74 32                	je     80106dd0 <allocuvm+0xd0>
80106d9e:	8b 55 10             	mov    0x10(%ebp),%edx
80106da1:	89 c1                	mov    %eax,%ecx
80106da3:	89 f8                	mov    %edi,%eax
80106da5:	e8 96 fb ff ff       	call   80106940 <deallocuvm.part.0>
      return 0;
80106daa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106db1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106db4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106db7:	5b                   	pop    %ebx
80106db8:	5e                   	pop    %esi
80106db9:	5f                   	pop    %edi
80106dba:	5d                   	pop    %ebp
80106dbb:	c3                   	ret    
80106dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80106dc0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80106dc3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106dc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106dc9:	5b                   	pop    %ebx
80106dca:	5e                   	pop    %esi
80106dcb:	5f                   	pop    %edi
80106dcc:	5d                   	pop    %ebp
80106dcd:	c3                   	ret    
80106dce:	66 90                	xchg   %ax,%ax
    return 0;
80106dd0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106dd7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106dda:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ddd:	5b                   	pop    %ebx
80106dde:	5e                   	pop    %esi
80106ddf:	5f                   	pop    %edi
80106de0:	5d                   	pop    %ebp
80106de1:	c3                   	ret    
80106de2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106de8:	83 ec 0c             	sub    $0xc,%esp
80106deb:	68 c1 7a 10 80       	push   $0x80107ac1
80106df0:	e8 bb 98 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106df5:	8b 45 0c             	mov    0xc(%ebp),%eax
80106df8:	83 c4 10             	add    $0x10,%esp
80106dfb:	39 45 10             	cmp    %eax,0x10(%ebp)
80106dfe:	74 0c                	je     80106e0c <allocuvm+0x10c>
80106e00:	8b 55 10             	mov    0x10(%ebp),%edx
80106e03:	89 c1                	mov    %eax,%ecx
80106e05:	89 f8                	mov    %edi,%eax
80106e07:	e8 34 fb ff ff       	call   80106940 <deallocuvm.part.0>
      kfree(mem);
80106e0c:	83 ec 0c             	sub    $0xc,%esp
80106e0f:	53                   	push   %ebx
80106e10:	e8 7b b6 ff ff       	call   80102490 <kfree>
      return 0;
80106e15:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80106e1c:	83 c4 10             	add    $0x10,%esp
}
80106e1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e22:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e25:	5b                   	pop    %ebx
80106e26:	5e                   	pop    %esi
80106e27:	5f                   	pop    %edi
80106e28:	5d                   	pop    %ebp
80106e29:	c3                   	ret    
80106e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106e30 <deallocuvm>:
{
80106e30:	f3 0f 1e fb          	endbr32 
80106e34:	55                   	push   %ebp
80106e35:	89 e5                	mov    %esp,%ebp
80106e37:	8b 55 0c             	mov    0xc(%ebp),%edx
80106e3a:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106e40:	39 d1                	cmp    %edx,%ecx
80106e42:	73 0c                	jae    80106e50 <deallocuvm+0x20>
}
80106e44:	5d                   	pop    %ebp
80106e45:	e9 f6 fa ff ff       	jmp    80106940 <deallocuvm.part.0>
80106e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106e50:	89 d0                	mov    %edx,%eax
80106e52:	5d                   	pop    %ebp
80106e53:	c3                   	ret    
80106e54:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106e5f:	90                   	nop

80106e60 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106e60:	f3 0f 1e fb          	endbr32 
80106e64:	55                   	push   %ebp
80106e65:	89 e5                	mov    %esp,%ebp
80106e67:	57                   	push   %edi
80106e68:	56                   	push   %esi
80106e69:	53                   	push   %ebx
80106e6a:	83 ec 0c             	sub    $0xc,%esp
80106e6d:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106e70:	85 f6                	test   %esi,%esi
80106e72:	74 55                	je     80106ec9 <freevm+0x69>
  if(newsz >= oldsz)
80106e74:	31 c9                	xor    %ecx,%ecx
80106e76:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106e7b:	89 f0                	mov    %esi,%eax
80106e7d:	89 f3                	mov    %esi,%ebx
80106e7f:	e8 bc fa ff ff       	call   80106940 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106e84:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106e8a:	eb 0b                	jmp    80106e97 <freevm+0x37>
80106e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106e90:	83 c3 04             	add    $0x4,%ebx
80106e93:	39 df                	cmp    %ebx,%edi
80106e95:	74 23                	je     80106eba <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106e97:	8b 03                	mov    (%ebx),%eax
80106e99:	a8 01                	test   $0x1,%al
80106e9b:	74 f3                	je     80106e90 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106e9d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80106ea2:	83 ec 0c             	sub    $0xc,%esp
80106ea5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106ea8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106ead:	50                   	push   %eax
80106eae:	e8 dd b5 ff ff       	call   80102490 <kfree>
80106eb3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106eb6:	39 df                	cmp    %ebx,%edi
80106eb8:	75 dd                	jne    80106e97 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106eba:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106ebd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ec0:	5b                   	pop    %ebx
80106ec1:	5e                   	pop    %esi
80106ec2:	5f                   	pop    %edi
80106ec3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106ec4:	e9 c7 b5 ff ff       	jmp    80102490 <kfree>
    panic("freevm: no pgdir");
80106ec9:	83 ec 0c             	sub    $0xc,%esp
80106ecc:	68 dd 7a 10 80       	push   $0x80107add
80106ed1:	e8 ba 94 ff ff       	call   80100390 <panic>
80106ed6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106edd:	8d 76 00             	lea    0x0(%esi),%esi

80106ee0 <setupkvm>:
{
80106ee0:	f3 0f 1e fb          	endbr32 
80106ee4:	55                   	push   %ebp
80106ee5:	89 e5                	mov    %esp,%ebp
80106ee7:	56                   	push   %esi
80106ee8:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106ee9:	e8 62 b7 ff ff       	call   80102650 <kalloc>
80106eee:	89 c6                	mov    %eax,%esi
80106ef0:	85 c0                	test   %eax,%eax
80106ef2:	74 42                	je     80106f36 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80106ef4:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106ef7:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106efc:	68 00 10 00 00       	push   $0x1000
80106f01:	6a 00                	push   $0x0
80106f03:	50                   	push   %eax
80106f04:	e8 87 d7 ff ff       	call   80104690 <memset>
80106f09:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80106f0c:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106f0f:	83 ec 08             	sub    $0x8,%esp
80106f12:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106f15:	ff 73 0c             	pushl  0xc(%ebx)
80106f18:	8b 13                	mov    (%ebx),%edx
80106f1a:	50                   	push   %eax
80106f1b:	29 c1                	sub    %eax,%ecx
80106f1d:	89 f0                	mov    %esi,%eax
80106f1f:	e8 8c f9 ff ff       	call   801068b0 <mappages>
80106f24:	83 c4 10             	add    $0x10,%esp
80106f27:	85 c0                	test   %eax,%eax
80106f29:	78 15                	js     80106f40 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106f2b:	83 c3 10             	add    $0x10,%ebx
80106f2e:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106f34:	75 d6                	jne    80106f0c <setupkvm+0x2c>
}
80106f36:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106f39:	89 f0                	mov    %esi,%eax
80106f3b:	5b                   	pop    %ebx
80106f3c:	5e                   	pop    %esi
80106f3d:	5d                   	pop    %ebp
80106f3e:	c3                   	ret    
80106f3f:	90                   	nop
      freevm(pgdir);
80106f40:	83 ec 0c             	sub    $0xc,%esp
80106f43:	56                   	push   %esi
      return 0;
80106f44:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80106f46:	e8 15 ff ff ff       	call   80106e60 <freevm>
      return 0;
80106f4b:	83 c4 10             	add    $0x10,%esp
}
80106f4e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106f51:	89 f0                	mov    %esi,%eax
80106f53:	5b                   	pop    %ebx
80106f54:	5e                   	pop    %esi
80106f55:	5d                   	pop    %ebp
80106f56:	c3                   	ret    
80106f57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f5e:	66 90                	xchg   %ax,%ax

80106f60 <kvmalloc>:
{
80106f60:	f3 0f 1e fb          	endbr32 
80106f64:	55                   	push   %ebp
80106f65:	89 e5                	mov    %esp,%ebp
80106f67:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106f6a:	e8 71 ff ff ff       	call   80106ee0 <setupkvm>
80106f6f:	a3 a4 55 11 80       	mov    %eax,0x801155a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106f74:	05 00 00 00 80       	add    $0x80000000,%eax
80106f79:	0f 22 d8             	mov    %eax,%cr3
}
80106f7c:	c9                   	leave  
80106f7d:	c3                   	ret    
80106f7e:	66 90                	xchg   %ax,%ax

80106f80 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106f80:	f3 0f 1e fb          	endbr32 
80106f84:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106f85:	31 c9                	xor    %ecx,%ecx
{
80106f87:	89 e5                	mov    %esp,%ebp
80106f89:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106f8c:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f8f:	8b 45 08             	mov    0x8(%ebp),%eax
80106f92:	e8 99 f8 ff ff       	call   80106830 <walkpgdir>
  if(pte == 0)
80106f97:	85 c0                	test   %eax,%eax
80106f99:	74 05                	je     80106fa0 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106f9b:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106f9e:	c9                   	leave  
80106f9f:	c3                   	ret    
    panic("clearpteu");
80106fa0:	83 ec 0c             	sub    $0xc,%esp
80106fa3:	68 ee 7a 10 80       	push   $0x80107aee
80106fa8:	e8 e3 93 ff ff       	call   80100390 <panic>
80106fad:	8d 76 00             	lea    0x0(%esi),%esi

80106fb0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106fb0:	f3 0f 1e fb          	endbr32 
80106fb4:	55                   	push   %ebp
80106fb5:	89 e5                	mov    %esp,%ebp
80106fb7:	57                   	push   %edi
80106fb8:	56                   	push   %esi
80106fb9:	53                   	push   %ebx
80106fba:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106fbd:	e8 1e ff ff ff       	call   80106ee0 <setupkvm>
80106fc2:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106fc5:	85 c0                	test   %eax,%eax
80106fc7:	0f 84 9b 00 00 00    	je     80107068 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106fcd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106fd0:	85 c9                	test   %ecx,%ecx
80106fd2:	0f 84 90 00 00 00    	je     80107068 <copyuvm+0xb8>
80106fd8:	31 f6                	xor    %esi,%esi
80106fda:	eb 46                	jmp    80107022 <copyuvm+0x72>
80106fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106fe0:	83 ec 04             	sub    $0x4,%esp
80106fe3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106fe9:	68 00 10 00 00       	push   $0x1000
80106fee:	57                   	push   %edi
80106fef:	50                   	push   %eax
80106ff0:	e8 3b d7 ff ff       	call   80104730 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80106ff5:	58                   	pop    %eax
80106ff6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106ffc:	5a                   	pop    %edx
80106ffd:	ff 75 e4             	pushl  -0x1c(%ebp)
80107000:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107005:	89 f2                	mov    %esi,%edx
80107007:	50                   	push   %eax
80107008:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010700b:	e8 a0 f8 ff ff       	call   801068b0 <mappages>
80107010:	83 c4 10             	add    $0x10,%esp
80107013:	85 c0                	test   %eax,%eax
80107015:	78 61                	js     80107078 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107017:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010701d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107020:	76 46                	jbe    80107068 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107022:	8b 45 08             	mov    0x8(%ebp),%eax
80107025:	31 c9                	xor    %ecx,%ecx
80107027:	89 f2                	mov    %esi,%edx
80107029:	e8 02 f8 ff ff       	call   80106830 <walkpgdir>
8010702e:	85 c0                	test   %eax,%eax
80107030:	74 61                	je     80107093 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107032:	8b 00                	mov    (%eax),%eax
80107034:	a8 01                	test   $0x1,%al
80107036:	74 4e                	je     80107086 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107038:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
8010703a:	25 ff 0f 00 00       	and    $0xfff,%eax
8010703f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107042:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107048:	e8 03 b6 ff ff       	call   80102650 <kalloc>
8010704d:	89 c3                	mov    %eax,%ebx
8010704f:	85 c0                	test   %eax,%eax
80107051:	75 8d                	jne    80106fe0 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107053:	83 ec 0c             	sub    $0xc,%esp
80107056:	ff 75 e0             	pushl  -0x20(%ebp)
80107059:	e8 02 fe ff ff       	call   80106e60 <freevm>
  return 0;
8010705e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107065:	83 c4 10             	add    $0x10,%esp
}
80107068:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010706b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010706e:	5b                   	pop    %ebx
8010706f:	5e                   	pop    %esi
80107070:	5f                   	pop    %edi
80107071:	5d                   	pop    %ebp
80107072:	c3                   	ret    
80107073:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107077:	90                   	nop
      kfree(mem);
80107078:	83 ec 0c             	sub    $0xc,%esp
8010707b:	53                   	push   %ebx
8010707c:	e8 0f b4 ff ff       	call   80102490 <kfree>
      goto bad;
80107081:	83 c4 10             	add    $0x10,%esp
80107084:	eb cd                	jmp    80107053 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107086:	83 ec 0c             	sub    $0xc,%esp
80107089:	68 12 7b 10 80       	push   $0x80107b12
8010708e:	e8 fd 92 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107093:	83 ec 0c             	sub    $0xc,%esp
80107096:	68 f8 7a 10 80       	push   $0x80107af8
8010709b:	e8 f0 92 ff ff       	call   80100390 <panic>

801070a0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801070a0:	f3 0f 1e fb          	endbr32 
801070a4:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801070a5:	31 c9                	xor    %ecx,%ecx
{
801070a7:	89 e5                	mov    %esp,%ebp
801070a9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801070ac:	8b 55 0c             	mov    0xc(%ebp),%edx
801070af:	8b 45 08             	mov    0x8(%ebp),%eax
801070b2:	e8 79 f7 ff ff       	call   80106830 <walkpgdir>
  if((*pte & PTE_P) == 0)
801070b7:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801070b9:	c9                   	leave  
  if((*pte & PTE_U) == 0)
801070ba:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801070bc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801070c1:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801070c4:	05 00 00 00 80       	add    $0x80000000,%eax
801070c9:	83 fa 05             	cmp    $0x5,%edx
801070cc:	ba 00 00 00 00       	mov    $0x0,%edx
801070d1:	0f 45 c2             	cmovne %edx,%eax
}
801070d4:	c3                   	ret    
801070d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801070e0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801070e0:	f3 0f 1e fb          	endbr32 
801070e4:	55                   	push   %ebp
801070e5:	89 e5                	mov    %esp,%ebp
801070e7:	57                   	push   %edi
801070e8:	56                   	push   %esi
801070e9:	53                   	push   %ebx
801070ea:	83 ec 0c             	sub    $0xc,%esp
801070ed:	8b 75 14             	mov    0x14(%ebp),%esi
801070f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801070f3:	85 f6                	test   %esi,%esi
801070f5:	75 3c                	jne    80107133 <copyout+0x53>
801070f7:	eb 67                	jmp    80107160 <copyout+0x80>
801070f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107100:	8b 55 0c             	mov    0xc(%ebp),%edx
80107103:	89 fb                	mov    %edi,%ebx
80107105:	29 d3                	sub    %edx,%ebx
80107107:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010710d:	39 f3                	cmp    %esi,%ebx
8010710f:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107112:	29 fa                	sub    %edi,%edx
80107114:	83 ec 04             	sub    $0x4,%esp
80107117:	01 c2                	add    %eax,%edx
80107119:	53                   	push   %ebx
8010711a:	ff 75 10             	pushl  0x10(%ebp)
8010711d:	52                   	push   %edx
8010711e:	e8 0d d6 ff ff       	call   80104730 <memmove>
    len -= n;
    buf += n;
80107123:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80107126:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
8010712c:	83 c4 10             	add    $0x10,%esp
8010712f:	29 de                	sub    %ebx,%esi
80107131:	74 2d                	je     80107160 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80107133:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107135:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107138:	89 55 0c             	mov    %edx,0xc(%ebp)
8010713b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107141:	57                   	push   %edi
80107142:	ff 75 08             	pushl  0x8(%ebp)
80107145:	e8 56 ff ff ff       	call   801070a0 <uva2ka>
    if(pa0 == 0)
8010714a:	83 c4 10             	add    $0x10,%esp
8010714d:	85 c0                	test   %eax,%eax
8010714f:	75 af                	jne    80107100 <copyout+0x20>
  }
  return 0;
}
80107151:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107154:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107159:	5b                   	pop    %ebx
8010715a:	5e                   	pop    %esi
8010715b:	5f                   	pop    %edi
8010715c:	5d                   	pop    %ebp
8010715d:	c3                   	ret    
8010715e:	66 90                	xchg   %ax,%ax
80107160:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107163:	31 c0                	xor    %eax,%eax
}
80107165:	5b                   	pop    %ebx
80107166:	5e                   	pop    %esi
80107167:	5f                   	pop    %edi
80107168:	5d                   	pop    %ebp
80107169:	c3                   	ret    
