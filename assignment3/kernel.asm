
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
8010002d:	b8 e0 34 10 80       	mov    $0x801034e0,%eax
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
80100050:	68 40 80 10 80       	push   $0x80108040
80100055:	68 e0 c5 10 80       	push   $0x8010c5e0
8010005a:	e8 e1 48 00 00       	call   80104940 <initlock>
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
80100092:	68 47 80 10 80       	push   $0x80108047
80100097:	50                   	push   %eax
80100098:	e8 63 47 00 00       	call   80104800 <initsleeplock>
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
801000e8:	e8 d3 49 00 00       	call   80104ac0 <acquire>
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
80100162:	e8 19 4a 00 00       	call   80104b80 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ce 46 00 00       	call   80104840 <acquiresleep>
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
8010018c:	e8 ff 24 00 00       	call   80102690 <iderw>
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
801001a3:	68 4e 80 10 80       	push   $0x8010804e
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
801001c2:	e8 19 47 00 00       	call   801048e0 <holdingsleep>
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
801001d8:	e9 b3 24 00 00       	jmp    80102690 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 5f 80 10 80       	push   $0x8010805f
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
80100203:	e8 d8 46 00 00       	call   801048e0 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 88 46 00 00       	call   801048a0 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
8010021f:	e8 9c 48 00 00       	call   80104ac0 <acquire>
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
80100270:	e9 0b 49 00 00       	jmp    80104b80 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 66 80 10 80       	push   $0x80108066
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
801002a5:	e8 26 16 00 00       	call   801018d0 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
801002b1:	e8 0a 48 00 00       	call   80104ac0 <acquire>
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
801002c6:	a1 e0 ef 11 80       	mov    0x8011efe0,%eax
801002cb:	3b 05 e4 ef 11 80    	cmp    0x8011efe4,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 20 b5 10 80       	push   $0x8010b520
801002e0:	68 e0 ef 11 80       	push   $0x8011efe0
801002e5:	e8 66 41 00 00       	call   80104450 <sleep>
    while(input.r == input.w){
801002ea:	a1 e0 ef 11 80       	mov    0x8011efe0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 e4 ef 11 80    	cmp    0x8011efe4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 31 3b 00 00       	call   80103e30 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 b5 10 80       	push   $0x8010b520
8010030e:	e8 6d 48 00 00       	call   80104b80 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 d4 14 00 00       	call   801017f0 <ilock>
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
80100333:	89 15 e0 ef 11 80    	mov    %edx,0x8011efe0
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 60 ef 11 80 	movsbl -0x7fee10a0(%edx),%ecx
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
80100365:	e8 16 48 00 00       	call   80104b80 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 7d 14 00 00       	call   801017f0 <ilock>
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
80100386:	a3 e0 ef 11 80       	mov    %eax,0x8011efe0
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
801003ad:	e8 8e 29 00 00       	call   80102d40 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 6d 80 10 80       	push   $0x8010806d
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 7b 8b 10 80 	movl   $0x80108b7b,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 7f 45 00 00       	call   80104960 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 81 80 10 80       	push   $0x80108081
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
8010042a:	e8 b1 5f 00 00       	call   801063e0 <uartputc>
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
80100515:	e8 c6 5e 00 00       	call   801063e0 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 ba 5e 00 00       	call   801063e0 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 ae 5e 00 00       	call   801063e0 <uartputc>
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
80100561:	e8 0a 47 00 00       	call   80104c70 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 55 46 00 00       	call   80104bd0 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 85 80 10 80       	push   $0x80108085
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
801005c9:	0f b6 92 b0 80 10 80 	movzbl -0x7fef7f50(%edx),%edx
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
80100653:	e8 78 12 00 00       	call   801018d0 <iunlock>
  acquire(&cons.lock);
80100658:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010065f:	e8 5c 44 00 00       	call   80104ac0 <acquire>
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
80100697:	e8 e4 44 00 00       	call   80104b80 <release>
  ilock(ip);
8010069c:	58                   	pop    %eax
8010069d:	ff 75 08             	pushl  0x8(%ebp)
801006a0:	e8 4b 11 00 00       	call   801017f0 <ilock>

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
8010077d:	bb 98 80 10 80       	mov    $0x80108098,%ebx
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
801007bd:	e8 fe 42 00 00       	call   80104ac0 <acquire>
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
80100828:	e8 53 43 00 00       	call   80104b80 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 9f 80 10 80       	push   $0x8010809f
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
80100877:	e8 44 42 00 00       	call   80104ac0 <acquire>
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
801008b4:	a1 e8 ef 11 80       	mov    0x8011efe8,%eax
801008b9:	89 c2                	mov    %eax,%edx
801008bb:	2b 15 e0 ef 11 80    	sub    0x8011efe0,%edx
801008c1:	83 fa 7f             	cmp    $0x7f,%edx
801008c4:	77 d2                	ja     80100898 <consoleintr+0x38>
        c = (c == '\r') ? '\n' : c;
801008c6:	8d 48 01             	lea    0x1(%eax),%ecx
801008c9:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
801008cf:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
801008d2:	89 0d e8 ef 11 80    	mov    %ecx,0x8011efe8
        c = (c == '\r') ? '\n' : c;
801008d8:	83 fb 0d             	cmp    $0xd,%ebx
801008db:	0f 84 02 01 00 00    	je     801009e3 <consoleintr+0x183>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e1:	88 98 60 ef 11 80    	mov    %bl,-0x7fee10a0(%eax)
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
80100908:	a1 e0 ef 11 80       	mov    0x8011efe0,%eax
8010090d:	83 e8 80             	sub    $0xffffff80,%eax
80100910:	39 05 e8 ef 11 80    	cmp    %eax,0x8011efe8
80100916:	75 80                	jne    80100898 <consoleintr+0x38>
80100918:	e9 f6 00 00 00       	jmp    80100a13 <consoleintr+0x1b3>
8010091d:	8d 76 00             	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100920:	a1 e8 ef 11 80       	mov    0x8011efe8,%eax
80100925:	39 05 e4 ef 11 80    	cmp    %eax,0x8011efe4
8010092b:	0f 84 67 ff ff ff    	je     80100898 <consoleintr+0x38>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100931:	83 e8 01             	sub    $0x1,%eax
80100934:	89 c2                	mov    %eax,%edx
80100936:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100939:	80 ba 60 ef 11 80 0a 	cmpb   $0xa,-0x7fee10a0(%edx)
80100940:	0f 84 52 ff ff ff    	je     80100898 <consoleintr+0x38>
  if(panicked){
80100946:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
        input.e--;
8010094c:	a3 e8 ef 11 80       	mov    %eax,0x8011efe8
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
8010096a:	a1 e8 ef 11 80       	mov    0x8011efe8,%eax
8010096f:	3b 05 e4 ef 11 80    	cmp    0x8011efe4,%eax
80100975:	75 ba                	jne    80100931 <consoleintr+0xd1>
80100977:	e9 1c ff ff ff       	jmp    80100898 <consoleintr+0x38>
8010097c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(input.e != input.w){
80100980:	a1 e8 ef 11 80       	mov    0x8011efe8,%eax
80100985:	3b 05 e4 ef 11 80    	cmp    0x8011efe4,%eax
8010098b:	0f 84 07 ff ff ff    	je     80100898 <consoleintr+0x38>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 e8 ef 11 80       	mov    %eax,0x8011efe8
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
801009cf:	e8 ac 41 00 00       	call   80104b80 <release>
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
801009e3:	c6 80 60 ef 11 80 0a 	movb   $0xa,-0x7fee10a0(%eax)
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
801009ff:	e9 0c 3d 00 00       	jmp    80104710 <procdump>
80100a04:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a09:	e8 02 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100a0e:	a1 e8 ef 11 80       	mov    0x8011efe8,%eax
          wakeup(&input.r);
80100a13:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a16:	a3 e4 ef 11 80       	mov    %eax,0x8011efe4
          wakeup(&input.r);
80100a1b:	68 e0 ef 11 80       	push   $0x8011efe0
80100a20:	e8 eb 3b 00 00       	call   80104610 <wakeup>
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
80100a3a:	68 a8 80 10 80       	push   $0x801080a8
80100a3f:	68 20 b5 10 80       	push   $0x8010b520
80100a44:	e8 f7 3e 00 00       	call   80104940 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a49:	58                   	pop    %eax
80100a4a:	5a                   	pop    %edx
80100a4b:	6a 00                	push   $0x0
80100a4d:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a4f:	c7 05 ac f9 11 80 40 	movl   $0x80100640,0x8011f9ac
80100a56:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a59:	c7 05 a8 f9 11 80 90 	movl   $0x80100290,0x8011f9a8
80100a60:	02 10 80 
  cons.locking = 1;
80100a63:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
80100a6a:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a6d:	e8 ce 1d 00 00       	call   80102840 <ioapicenable>
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
80100b1a:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100b20:	e8 0b 33 00 00       	call   80103e30 <myproc>
80100b25:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
  // struct pageinfo mem_pginfo_bu[MAX_PYSC_PAGES];
  // struct pageinfo swp_pginfo_bu[MAX_PYSC_PAGES];
  // struct file* swap_file_bu = 0;
  // struct file* temp_swap_file = 0;

  begin_op();
80100b2b:	e8 a0 26 00 00       	call   801031d0 <begin_op>

  if((ip = namei(path)) == 0){
80100b30:	83 ec 0c             	sub    $0xc,%esp
80100b33:	ff 75 08             	pushl  0x8(%ebp)
80100b36:	e8 85 15 00 00       	call   801020c0 <namei>
80100b3b:	83 c4 10             	add    $0x10,%esp
80100b3e:	85 c0                	test   %eax,%eax
80100b40:	0f 84 fe 02 00 00    	je     80100e44 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100b46:	83 ec 0c             	sub    $0xc,%esp
80100b49:	89 c3                	mov    %eax,%ebx
80100b4b:	50                   	push   %eax
80100b4c:	e8 9f 0c 00 00       	call   801017f0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100b51:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100b57:	6a 34                	push   $0x34
80100b59:	6a 00                	push   $0x0
80100b5b:	50                   	push   %eax
80100b5c:	53                   	push   %ebx
80100b5d:	e8 8e 0f 00 00       	call   80101af0 <readi>
80100b62:	83 c4 20             	add    $0x20,%esp
80100b65:	83 f8 34             	cmp    $0x34,%eax
80100b68:	74 26                	je     80100b90 <exec+0x80>
    #endif

    freevm(pgdir);
  }
  if(ip){
    iunlockput(ip);
80100b6a:	83 ec 0c             	sub    $0xc,%esp
80100b6d:	53                   	push   %ebx
80100b6e:	e8 1d 0f 00 00       	call   80101a90 <iunlockput>
    end_op();
80100b73:	e8 c8 26 00 00       	call   80103240 <end_op>
80100b78:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100b7b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b80:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b83:	5b                   	pop    %ebx
80100b84:	5e                   	pop    %esi
80100b85:	5f                   	pop    %edi
80100b86:	5d                   	pop    %ebp
80100b87:	c3                   	ret    
80100b88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b8f:	90                   	nop
  if(elf.magic != ELF_MAGIC)
80100b90:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b97:	45 4c 46 
80100b9a:	75 ce                	jne    80100b6a <exec+0x5a>
  if((pgdir = setupkvm()) == 0)
80100b9c:	e8 5f 6c 00 00       	call   80107800 <setupkvm>
80100ba1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100ba7:	85 c0                	test   %eax,%eax
80100ba9:	74 bf                	je     80100b6a <exec+0x5a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bab:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100bb2:	00 
80100bb3:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100bb9:	0f 84 a4 02 00 00    	je     80100e63 <exec+0x353>
  sz = 0;
80100bbf:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100bc6:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bc9:	31 ff                	xor    %edi,%edi
80100bcb:	e9 86 00 00 00       	jmp    80100c56 <exec+0x146>
    if(ph.type != ELF_PROG_LOAD)
80100bd0:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100bd7:	75 6c                	jne    80100c45 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100bd9:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100bdf:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100be5:	0f 82 87 00 00 00    	jb     80100c72 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100beb:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100bf1:	72 7f                	jb     80100c72 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100bf3:	83 ec 04             	sub    $0x4,%esp
80100bf6:	50                   	push   %eax
80100bf7:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bfd:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100c03:	e8 18 6a 00 00       	call   80107620 <allocuvm>
80100c08:	83 c4 10             	add    $0x10,%esp
80100c0b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100c11:	85 c0                	test   %eax,%eax
80100c13:	74 5d                	je     80100c72 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100c15:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100c1b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100c20:	75 50                	jne    80100c72 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c22:	83 ec 0c             	sub    $0xc,%esp
80100c25:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100c2b:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100c31:	53                   	push   %ebx
80100c32:	50                   	push   %eax
80100c33:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100c39:	e8 12 69 00 00       	call   80107550 <loaduvm>
80100c3e:	83 c4 20             	add    $0x20,%esp
80100c41:	85 c0                	test   %eax,%eax
80100c43:	78 2d                	js     80100c72 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c45:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100c4c:	83 c7 01             	add    $0x1,%edi
80100c4f:	83 c6 20             	add    $0x20,%esi
80100c52:	39 f8                	cmp    %edi,%eax
80100c54:	7e 3a                	jle    80100c90 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c56:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100c5c:	6a 20                	push   $0x20
80100c5e:	56                   	push   %esi
80100c5f:	50                   	push   %eax
80100c60:	53                   	push   %ebx
80100c61:	e8 8a 0e 00 00       	call   80101af0 <readi>
80100c66:	83 c4 10             	add    $0x10,%esp
80100c69:	83 f8 20             	cmp    $0x20,%eax
80100c6c:	0f 84 5e ff ff ff    	je     80100bd0 <exec+0xc0>
    freevm(pgdir);
80100c72:	83 ec 0c             	sub    $0xc,%esp
80100c75:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100c7b:	e8 00 6b 00 00       	call   80107780 <freevm>
  if(ip){
80100c80:	83 c4 10             	add    $0x10,%esp
80100c83:	e9 e2 fe ff ff       	jmp    80100b6a <exec+0x5a>
80100c88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c8f:	90                   	nop
80100c90:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c96:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c9c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100ca2:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100ca8:	83 ec 0c             	sub    $0xc,%esp
80100cab:	53                   	push   %ebx
80100cac:	e8 df 0d 00 00       	call   80101a90 <iunlockput>
  end_op();
80100cb1:	e8 8a 25 00 00       	call   80103240 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100cb6:	83 c4 0c             	add    $0xc,%esp
80100cb9:	56                   	push   %esi
80100cba:	57                   	push   %edi
80100cbb:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cc1:	57                   	push   %edi
80100cc2:	e8 59 69 00 00       	call   80107620 <allocuvm>
80100cc7:	83 c4 10             	add    $0x10,%esp
80100cca:	89 c6                	mov    %eax,%esi
80100ccc:	85 c0                	test   %eax,%eax
80100cce:	0f 84 94 00 00 00    	je     80100d68 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cd4:	83 ec 08             	sub    $0x8,%esp
80100cd7:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100cdd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cdf:	50                   	push   %eax
80100ce0:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100ce1:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100ce3:	e8 b8 6b 00 00       	call   801078a0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100ce8:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ceb:	83 c4 10             	add    $0x10,%esp
80100cee:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100cf4:	8b 00                	mov    (%eax),%eax
80100cf6:	85 c0                	test   %eax,%eax
80100cf8:	0f 84 8b 00 00 00    	je     80100d89 <exec+0x279>
80100cfe:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100d04:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100d0a:	eb 23                	jmp    80100d2f <exec+0x21f>
80100d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100d10:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100d13:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100d1a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100d1d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100d23:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100d26:	85 c0                	test   %eax,%eax
80100d28:	74 59                	je     80100d83 <exec+0x273>
    if(argc >= MAXARG)
80100d2a:	83 ff 20             	cmp    $0x20,%edi
80100d2d:	74 39                	je     80100d68 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d2f:	83 ec 0c             	sub    $0xc,%esp
80100d32:	50                   	push   %eax
80100d33:	e8 98 40 00 00       	call   80104dd0 <strlen>
80100d38:	f7 d0                	not    %eax
80100d3a:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d3c:	58                   	pop    %eax
80100d3d:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d40:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d43:	ff 34 b8             	pushl  (%eax,%edi,4)
80100d46:	e8 85 40 00 00       	call   80104dd0 <strlen>
80100d4b:	83 c0 01             	add    $0x1,%eax
80100d4e:	50                   	push   %eax
80100d4f:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d52:	ff 34 b8             	pushl  (%eax,%edi,4)
80100d55:	53                   	push   %ebx
80100d56:	56                   	push   %esi
80100d57:	e8 e4 6d 00 00       	call   80107b40 <copyout>
80100d5c:	83 c4 20             	add    $0x20,%esp
80100d5f:	85 c0                	test   %eax,%eax
80100d61:	79 ad                	jns    80100d10 <exec+0x200>
80100d63:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100d67:	90                   	nop
    freevm(pgdir);
80100d68:	83 ec 0c             	sub    $0xc,%esp
80100d6b:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100d71:	e8 0a 6a 00 00       	call   80107780 <freevm>
80100d76:	83 c4 10             	add    $0x10,%esp
  return -1;
80100d79:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d7e:	e9 fd fd ff ff       	jmp    80100b80 <exec+0x70>
80100d83:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d89:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d90:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d92:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d99:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d9d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d9f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100da2:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100da8:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100daa:	50                   	push   %eax
80100dab:	52                   	push   %edx
80100dac:	53                   	push   %ebx
80100dad:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100db3:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100dba:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100dbd:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100dc3:	e8 78 6d 00 00       	call   80107b40 <copyout>
80100dc8:	83 c4 10             	add    $0x10,%esp
80100dcb:	85 c0                	test   %eax,%eax
80100dcd:	78 99                	js     80100d68 <exec+0x258>
  for(last=s=path; *s; s++)
80100dcf:	8b 45 08             	mov    0x8(%ebp),%eax
80100dd2:	8b 55 08             	mov    0x8(%ebp),%edx
80100dd5:	0f b6 00             	movzbl (%eax),%eax
80100dd8:	84 c0                	test   %al,%al
80100dda:	74 13                	je     80100def <exec+0x2df>
80100ddc:	89 d1                	mov    %edx,%ecx
80100dde:	66 90                	xchg   %ax,%ax
    if(*s == '/')
80100de0:	83 c1 01             	add    $0x1,%ecx
80100de3:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100de5:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80100de8:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100deb:	84 c0                	test   %al,%al
80100ded:	75 f1                	jne    80100de0 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100def:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100df5:	83 ec 04             	sub    $0x4,%esp
80100df8:	6a 10                	push   $0x10
80100dfa:	89 f8                	mov    %edi,%eax
80100dfc:	52                   	push   %edx
80100dfd:	83 c0 6c             	add    $0x6c,%eax
80100e00:	50                   	push   %eax
80100e01:	e8 8a 3f 00 00       	call   80104d90 <safestrcpy>
  curproc->pgdir = pgdir;
80100e06:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100e0c:	89 f8                	mov    %edi,%eax
80100e0e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100e11:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100e13:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100e16:	89 c1                	mov    %eax,%ecx
80100e18:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100e1e:	8b 40 18             	mov    0x18(%eax),%eax
80100e21:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100e24:	8b 41 18             	mov    0x18(%ecx),%eax
80100e27:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100e2a:	89 0c 24             	mov    %ecx,(%esp)
80100e2d:	e8 8e 65 00 00       	call   801073c0 <switchuvm>
  freevm(oldpgdir);
80100e32:	89 3c 24             	mov    %edi,(%esp)
80100e35:	e8 46 69 00 00       	call   80107780 <freevm>
  return 0;
80100e3a:	83 c4 10             	add    $0x10,%esp
80100e3d:	31 c0                	xor    %eax,%eax
80100e3f:	e9 3c fd ff ff       	jmp    80100b80 <exec+0x70>
    end_op();
80100e44:	e8 f7 23 00 00       	call   80103240 <end_op>
    cprintf("exec: fail\n");
80100e49:	83 ec 0c             	sub    $0xc,%esp
80100e4c:	68 c1 80 10 80       	push   $0x801080c1
80100e51:	e8 5a f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100e56:	83 c4 10             	add    $0x10,%esp
80100e59:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100e5e:	e9 1d fd ff ff       	jmp    80100b80 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e63:	31 ff                	xor    %edi,%edi
80100e65:	be 00 20 00 00       	mov    $0x2000,%esi
80100e6a:	e9 39 fe ff ff       	jmp    80100ca8 <exec+0x198>
80100e6f:	90                   	nop

80100e70 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e70:	f3 0f 1e fb          	endbr32 
80100e74:	55                   	push   %ebp
80100e75:	89 e5                	mov    %esp,%ebp
80100e77:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e7a:	68 cd 80 10 80       	push   $0x801080cd
80100e7f:	68 00 f0 11 80       	push   $0x8011f000
80100e84:	e8 b7 3a 00 00       	call   80104940 <initlock>
}
80100e89:	83 c4 10             	add    $0x10,%esp
80100e8c:	c9                   	leave  
80100e8d:	c3                   	ret    
80100e8e:	66 90                	xchg   %ax,%ax

80100e90 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e90:	f3 0f 1e fb          	endbr32 
80100e94:	55                   	push   %ebp
80100e95:	89 e5                	mov    %esp,%ebp
80100e97:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e98:	bb 34 f0 11 80       	mov    $0x8011f034,%ebx
{
80100e9d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100ea0:	68 00 f0 11 80       	push   $0x8011f000
80100ea5:	e8 16 3c 00 00       	call   80104ac0 <acquire>
80100eaa:	83 c4 10             	add    $0x10,%esp
80100ead:	eb 0c                	jmp    80100ebb <filealloc+0x2b>
80100eaf:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100eb0:	83 c3 18             	add    $0x18,%ebx
80100eb3:	81 fb 94 f9 11 80    	cmp    $0x8011f994,%ebx
80100eb9:	74 25                	je     80100ee0 <filealloc+0x50>
    if(f->ref == 0){
80100ebb:	8b 43 04             	mov    0x4(%ebx),%eax
80100ebe:	85 c0                	test   %eax,%eax
80100ec0:	75 ee                	jne    80100eb0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100ec2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100ec5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100ecc:	68 00 f0 11 80       	push   $0x8011f000
80100ed1:	e8 aa 3c 00 00       	call   80104b80 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100ed6:	89 d8                	mov    %ebx,%eax
      return f;
80100ed8:	83 c4 10             	add    $0x10,%esp
}
80100edb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ede:	c9                   	leave  
80100edf:	c3                   	ret    
  release(&ftable.lock);
80100ee0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100ee3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100ee5:	68 00 f0 11 80       	push   $0x8011f000
80100eea:	e8 91 3c 00 00       	call   80104b80 <release>
}
80100eef:	89 d8                	mov    %ebx,%eax
  return 0;
80100ef1:	83 c4 10             	add    $0x10,%esp
}
80100ef4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ef7:	c9                   	leave  
80100ef8:	c3                   	ret    
80100ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100f00 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100f00:	f3 0f 1e fb          	endbr32 
80100f04:	55                   	push   %ebp
80100f05:	89 e5                	mov    %esp,%ebp
80100f07:	53                   	push   %ebx
80100f08:	83 ec 10             	sub    $0x10,%esp
80100f0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100f0e:	68 00 f0 11 80       	push   $0x8011f000
80100f13:	e8 a8 3b 00 00       	call   80104ac0 <acquire>
  if(f->ref < 1)
80100f18:	8b 43 04             	mov    0x4(%ebx),%eax
80100f1b:	83 c4 10             	add    $0x10,%esp
80100f1e:	85 c0                	test   %eax,%eax
80100f20:	7e 1a                	jle    80100f3c <filedup+0x3c>
    panic("filedup");
  f->ref++;
80100f22:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100f25:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100f28:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100f2b:	68 00 f0 11 80       	push   $0x8011f000
80100f30:	e8 4b 3c 00 00       	call   80104b80 <release>
  return f;
}
80100f35:	89 d8                	mov    %ebx,%eax
80100f37:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f3a:	c9                   	leave  
80100f3b:	c3                   	ret    
    panic("filedup");
80100f3c:	83 ec 0c             	sub    $0xc,%esp
80100f3f:	68 d4 80 10 80       	push   $0x801080d4
80100f44:	e8 47 f4 ff ff       	call   80100390 <panic>
80100f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100f50 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f50:	f3 0f 1e fb          	endbr32 
80100f54:	55                   	push   %ebp
80100f55:	89 e5                	mov    %esp,%ebp
80100f57:	57                   	push   %edi
80100f58:	56                   	push   %esi
80100f59:	53                   	push   %ebx
80100f5a:	83 ec 28             	sub    $0x28,%esp
80100f5d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f60:	68 00 f0 11 80       	push   $0x8011f000
80100f65:	e8 56 3b 00 00       	call   80104ac0 <acquire>
  if(f->ref < 1)
80100f6a:	8b 53 04             	mov    0x4(%ebx),%edx
80100f6d:	83 c4 10             	add    $0x10,%esp
80100f70:	85 d2                	test   %edx,%edx
80100f72:	0f 8e a1 00 00 00    	jle    80101019 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f78:	83 ea 01             	sub    $0x1,%edx
80100f7b:	89 53 04             	mov    %edx,0x4(%ebx)
80100f7e:	75 40                	jne    80100fc0 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f80:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f84:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f87:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f89:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f8f:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f92:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f95:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f98:	68 00 f0 11 80       	push   $0x8011f000
  ff = *f;
80100f9d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100fa0:	e8 db 3b 00 00       	call   80104b80 <release>

  if(ff.type == FD_PIPE)
80100fa5:	83 c4 10             	add    $0x10,%esp
80100fa8:	83 ff 01             	cmp    $0x1,%edi
80100fab:	74 53                	je     80101000 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100fad:	83 ff 02             	cmp    $0x2,%edi
80100fb0:	74 26                	je     80100fd8 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100fb2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb5:	5b                   	pop    %ebx
80100fb6:	5e                   	pop    %esi
80100fb7:	5f                   	pop    %edi
80100fb8:	5d                   	pop    %ebp
80100fb9:	c3                   	ret    
80100fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100fc0:	c7 45 08 00 f0 11 80 	movl   $0x8011f000,0x8(%ebp)
}
80100fc7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fca:	5b                   	pop    %ebx
80100fcb:	5e                   	pop    %esi
80100fcc:	5f                   	pop    %edi
80100fcd:	5d                   	pop    %ebp
    release(&ftable.lock);
80100fce:	e9 ad 3b 00 00       	jmp    80104b80 <release>
80100fd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100fd7:	90                   	nop
    begin_op();
80100fd8:	e8 f3 21 00 00       	call   801031d0 <begin_op>
    iput(ff.ip);
80100fdd:	83 ec 0c             	sub    $0xc,%esp
80100fe0:	ff 75 e0             	pushl  -0x20(%ebp)
80100fe3:	e8 38 09 00 00       	call   80101920 <iput>
    end_op();
80100fe8:	83 c4 10             	add    $0x10,%esp
}
80100feb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fee:	5b                   	pop    %ebx
80100fef:	5e                   	pop    %esi
80100ff0:	5f                   	pop    %edi
80100ff1:	5d                   	pop    %ebp
    end_op();
80100ff2:	e9 49 22 00 00       	jmp    80103240 <end_op>
80100ff7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100ffe:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80101000:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80101004:	83 ec 08             	sub    $0x8,%esp
80101007:	53                   	push   %ebx
80101008:	56                   	push   %esi
80101009:	e8 a2 29 00 00       	call   801039b0 <pipeclose>
8010100e:	83 c4 10             	add    $0x10,%esp
}
80101011:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101014:	5b                   	pop    %ebx
80101015:	5e                   	pop    %esi
80101016:	5f                   	pop    %edi
80101017:	5d                   	pop    %ebp
80101018:	c3                   	ret    
    panic("fileclose");
80101019:	83 ec 0c             	sub    $0xc,%esp
8010101c:	68 dc 80 10 80       	push   $0x801080dc
80101021:	e8 6a f3 ff ff       	call   80100390 <panic>
80101026:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010102d:	8d 76 00             	lea    0x0(%esi),%esi

80101030 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101030:	f3 0f 1e fb          	endbr32 
80101034:	55                   	push   %ebp
80101035:	89 e5                	mov    %esp,%ebp
80101037:	53                   	push   %ebx
80101038:	83 ec 04             	sub    $0x4,%esp
8010103b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010103e:	83 3b 02             	cmpl   $0x2,(%ebx)
80101041:	75 2d                	jne    80101070 <filestat+0x40>
    ilock(f->ip);
80101043:	83 ec 0c             	sub    $0xc,%esp
80101046:	ff 73 10             	pushl  0x10(%ebx)
80101049:	e8 a2 07 00 00       	call   801017f0 <ilock>
    stati(f->ip, st);
8010104e:	58                   	pop    %eax
8010104f:	5a                   	pop    %edx
80101050:	ff 75 0c             	pushl  0xc(%ebp)
80101053:	ff 73 10             	pushl  0x10(%ebx)
80101056:	e8 65 0a 00 00       	call   80101ac0 <stati>
    iunlock(f->ip);
8010105b:	59                   	pop    %ecx
8010105c:	ff 73 10             	pushl  0x10(%ebx)
8010105f:	e8 6c 08 00 00       	call   801018d0 <iunlock>
    return 0;
  }
  return -1;
}
80101064:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101067:	83 c4 10             	add    $0x10,%esp
8010106a:	31 c0                	xor    %eax,%eax
}
8010106c:	c9                   	leave  
8010106d:	c3                   	ret    
8010106e:	66 90                	xchg   %ax,%ax
80101070:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101073:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101078:	c9                   	leave  
80101079:	c3                   	ret    
8010107a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101080 <fileread>:

// Read from file f.
int
fileread(struct file* f, char *addr, int n)
{
80101080:	f3 0f 1e fb          	endbr32 
80101084:	55                   	push   %ebp
80101085:	89 e5                	mov    %esp,%ebp
80101087:	57                   	push   %edi
80101088:	56                   	push   %esi
80101089:	53                   	push   %ebx
8010108a:	83 ec 0c             	sub    $0xc,%esp
8010108d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101090:	8b 75 0c             	mov    0xc(%ebp),%esi
80101093:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101096:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
8010109a:	74 64                	je     80101100 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
8010109c:	8b 03                	mov    (%ebx),%eax
8010109e:	83 f8 01             	cmp    $0x1,%eax
801010a1:	74 45                	je     801010e8 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010a3:	83 f8 02             	cmp    $0x2,%eax
801010a6:	75 5f                	jne    80101107 <fileread+0x87>
    ilock(f->ip);
801010a8:	83 ec 0c             	sub    $0xc,%esp
801010ab:	ff 73 10             	pushl  0x10(%ebx)
801010ae:	e8 3d 07 00 00       	call   801017f0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801010b3:	57                   	push   %edi
801010b4:	ff 73 14             	pushl  0x14(%ebx)
801010b7:	56                   	push   %esi
801010b8:	ff 73 10             	pushl  0x10(%ebx)
801010bb:	e8 30 0a 00 00       	call   80101af0 <readi>
801010c0:	83 c4 20             	add    $0x20,%esp
801010c3:	89 c6                	mov    %eax,%esi
801010c5:	85 c0                	test   %eax,%eax
801010c7:	7e 03                	jle    801010cc <fileread+0x4c>
      f->off += r;
801010c9:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801010cc:	83 ec 0c             	sub    $0xc,%esp
801010cf:	ff 73 10             	pushl  0x10(%ebx)
801010d2:	e8 f9 07 00 00       	call   801018d0 <iunlock>
    return r;
801010d7:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801010da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010dd:	89 f0                	mov    %esi,%eax
801010df:	5b                   	pop    %ebx
801010e0:	5e                   	pop    %esi
801010e1:	5f                   	pop    %edi
801010e2:	5d                   	pop    %ebp
801010e3:	c3                   	ret    
801010e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
801010e8:	8b 43 0c             	mov    0xc(%ebx),%eax
801010eb:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010f1:	5b                   	pop    %ebx
801010f2:	5e                   	pop    %esi
801010f3:	5f                   	pop    %edi
801010f4:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801010f5:	e9 56 2a 00 00       	jmp    80103b50 <piperead>
801010fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101100:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101105:	eb d3                	jmp    801010da <fileread+0x5a>
  panic("fileread");
80101107:	83 ec 0c             	sub    $0xc,%esp
8010110a:	68 e6 80 10 80       	push   $0x801080e6
8010110f:	e8 7c f2 ff ff       	call   80100390 <panic>
80101114:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010111b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010111f:	90                   	nop

80101120 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101120:	f3 0f 1e fb          	endbr32 
80101124:	55                   	push   %ebp
80101125:	89 e5                	mov    %esp,%ebp
80101127:	57                   	push   %edi
80101128:	56                   	push   %esi
80101129:	53                   	push   %ebx
8010112a:	83 ec 1c             	sub    $0x1c,%esp
8010112d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101130:	8b 75 08             	mov    0x8(%ebp),%esi
80101133:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101136:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101139:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
8010113d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
80101140:	0f 84 c1 00 00 00    	je     80101207 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
80101146:	8b 06                	mov    (%esi),%eax
80101148:	83 f8 01             	cmp    $0x1,%eax
8010114b:	0f 84 c3 00 00 00    	je     80101214 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101151:	83 f8 02             	cmp    $0x2,%eax
80101154:	0f 85 cc 00 00 00    	jne    80101226 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010115a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
8010115d:	31 ff                	xor    %edi,%edi
    while(i < n){
8010115f:	85 c0                	test   %eax,%eax
80101161:	7f 34                	jg     80101197 <filewrite+0x77>
80101163:	e9 98 00 00 00       	jmp    80101200 <filewrite+0xe0>
80101168:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010116f:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101170:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
80101173:	83 ec 0c             	sub    $0xc,%esp
80101176:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101179:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
8010117c:	e8 4f 07 00 00       	call   801018d0 <iunlock>
      end_op();
80101181:	e8 ba 20 00 00       	call   80103240 <end_op>

      if(r < 0)
        break;
      if(r != n1)
80101186:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101189:	83 c4 10             	add    $0x10,%esp
8010118c:	39 c3                	cmp    %eax,%ebx
8010118e:	75 60                	jne    801011f0 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
80101190:	01 df                	add    %ebx,%edi
    while(i < n){
80101192:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101195:	7e 69                	jle    80101200 <filewrite+0xe0>
      int n1 = n - i;
80101197:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010119a:	b8 00 06 00 00       	mov    $0x600,%eax
8010119f:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
801011a1:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
801011a7:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
801011aa:	e8 21 20 00 00       	call   801031d0 <begin_op>
      ilock(f->ip);
801011af:	83 ec 0c             	sub    $0xc,%esp
801011b2:	ff 76 10             	pushl  0x10(%esi)
801011b5:	e8 36 06 00 00       	call   801017f0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801011ba:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011bd:	53                   	push   %ebx
801011be:	ff 76 14             	pushl  0x14(%esi)
801011c1:	01 f8                	add    %edi,%eax
801011c3:	50                   	push   %eax
801011c4:	ff 76 10             	pushl  0x10(%esi)
801011c7:	e8 24 0a 00 00       	call   80101bf0 <writei>
801011cc:	83 c4 20             	add    $0x20,%esp
801011cf:	85 c0                	test   %eax,%eax
801011d1:	7f 9d                	jg     80101170 <filewrite+0x50>
      iunlock(f->ip);
801011d3:	83 ec 0c             	sub    $0xc,%esp
801011d6:	ff 76 10             	pushl  0x10(%esi)
801011d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801011dc:	e8 ef 06 00 00       	call   801018d0 <iunlock>
      end_op();
801011e1:	e8 5a 20 00 00       	call   80103240 <end_op>
      if(r < 0)
801011e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801011e9:	83 c4 10             	add    $0x10,%esp
801011ec:	85 c0                	test   %eax,%eax
801011ee:	75 17                	jne    80101207 <filewrite+0xe7>
        panic("short filewrite");
801011f0:	83 ec 0c             	sub    $0xc,%esp
801011f3:	68 ef 80 10 80       	push   $0x801080ef
801011f8:	e8 93 f1 ff ff       	call   80100390 <panic>
801011fd:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101200:	89 f8                	mov    %edi,%eax
80101202:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101205:	74 05                	je     8010120c <filewrite+0xec>
80101207:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
8010120c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010120f:	5b                   	pop    %ebx
80101210:	5e                   	pop    %esi
80101211:	5f                   	pop    %edi
80101212:	5d                   	pop    %ebp
80101213:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
80101214:	8b 46 0c             	mov    0xc(%esi),%eax
80101217:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010121a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010121d:	5b                   	pop    %ebx
8010121e:	5e                   	pop    %esi
8010121f:	5f                   	pop    %edi
80101220:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101221:	e9 2a 28 00 00       	jmp    80103a50 <pipewrite>
  panic("filewrite");
80101226:	83 ec 0c             	sub    $0xc,%esp
80101229:	68 f5 80 10 80       	push   $0x801080f5
8010122e:	e8 5d f1 ff ff       	call   80100390 <panic>
80101233:	66 90                	xchg   %ax,%ax
80101235:	66 90                	xchg   %ax,%ax
80101237:	66 90                	xchg   %ax,%ax
80101239:	66 90                	xchg   %ax,%ax
8010123b:	66 90                	xchg   %ax,%ax
8010123d:	66 90                	xchg   %ax,%ax
8010123f:	90                   	nop

80101240 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101240:	55                   	push   %ebp
80101241:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101243:	89 d0                	mov    %edx,%eax
80101245:	c1 e8 0c             	shr    $0xc,%eax
80101248:	03 05 18 fa 11 80    	add    0x8011fa18,%eax
{
8010124e:	89 e5                	mov    %esp,%ebp
80101250:	56                   	push   %esi
80101251:	53                   	push   %ebx
80101252:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101254:	83 ec 08             	sub    $0x8,%esp
80101257:	50                   	push   %eax
80101258:	51                   	push   %ecx
80101259:	e8 72 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010125e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101260:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101263:	ba 01 00 00 00       	mov    $0x1,%edx
80101268:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
8010126b:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80101271:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101274:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101276:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
8010127b:	85 d1                	test   %edx,%ecx
8010127d:	74 25                	je     801012a4 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010127f:	f7 d2                	not    %edx
  log_write(bp);
80101281:	83 ec 0c             	sub    $0xc,%esp
80101284:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
80101286:	21 ca                	and    %ecx,%edx
80101288:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
8010128c:	50                   	push   %eax
8010128d:	e8 1e 21 00 00       	call   801033b0 <log_write>
  brelse(bp);
80101292:	89 34 24             	mov    %esi,(%esp)
80101295:	e8 56 ef ff ff       	call   801001f0 <brelse>
}
8010129a:	83 c4 10             	add    $0x10,%esp
8010129d:	8d 65 f8             	lea    -0x8(%ebp),%esp
801012a0:	5b                   	pop    %ebx
801012a1:	5e                   	pop    %esi
801012a2:	5d                   	pop    %ebp
801012a3:	c3                   	ret    
    panic("freeing free block");
801012a4:	83 ec 0c             	sub    $0xc,%esp
801012a7:	68 ff 80 10 80       	push   $0x801080ff
801012ac:	e8 df f0 ff ff       	call   80100390 <panic>
801012b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801012b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801012bf:	90                   	nop

801012c0 <balloc>:
{
801012c0:	55                   	push   %ebp
801012c1:	89 e5                	mov    %esp,%ebp
801012c3:	57                   	push   %edi
801012c4:	56                   	push   %esi
801012c5:	53                   	push   %ebx
801012c6:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
801012c9:	8b 0d 00 fa 11 80    	mov    0x8011fa00,%ecx
{
801012cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801012d2:	85 c9                	test   %ecx,%ecx
801012d4:	0f 84 87 00 00 00    	je     80101361 <balloc+0xa1>
801012da:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801012e1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801012e4:	83 ec 08             	sub    $0x8,%esp
801012e7:	89 f0                	mov    %esi,%eax
801012e9:	c1 f8 0c             	sar    $0xc,%eax
801012ec:	03 05 18 fa 11 80    	add    0x8011fa18,%eax
801012f2:	50                   	push   %eax
801012f3:	ff 75 d8             	pushl  -0x28(%ebp)
801012f6:	e8 d5 ed ff ff       	call   801000d0 <bread>
801012fb:	83 c4 10             	add    $0x10,%esp
801012fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101301:	a1 00 fa 11 80       	mov    0x8011fa00,%eax
80101306:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101309:	31 c0                	xor    %eax,%eax
8010130b:	eb 2f                	jmp    8010133c <balloc+0x7c>
8010130d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101310:	89 c1                	mov    %eax,%ecx
80101312:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101317:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010131a:	83 e1 07             	and    $0x7,%ecx
8010131d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010131f:	89 c1                	mov    %eax,%ecx
80101321:	c1 f9 03             	sar    $0x3,%ecx
80101324:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101329:	89 fa                	mov    %edi,%edx
8010132b:	85 df                	test   %ebx,%edi
8010132d:	74 41                	je     80101370 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010132f:	83 c0 01             	add    $0x1,%eax
80101332:	83 c6 01             	add    $0x1,%esi
80101335:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010133a:	74 05                	je     80101341 <balloc+0x81>
8010133c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010133f:	77 cf                	ja     80101310 <balloc+0x50>
    brelse(bp);
80101341:	83 ec 0c             	sub    $0xc,%esp
80101344:	ff 75 e4             	pushl  -0x1c(%ebp)
80101347:	e8 a4 ee ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010134c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101353:	83 c4 10             	add    $0x10,%esp
80101356:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101359:	39 05 00 fa 11 80    	cmp    %eax,0x8011fa00
8010135f:	77 80                	ja     801012e1 <balloc+0x21>
  panic("balloc: out of blocks");
80101361:	83 ec 0c             	sub    $0xc,%esp
80101364:	68 12 81 10 80       	push   $0x80108112
80101369:	e8 22 f0 ff ff       	call   80100390 <panic>
8010136e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101370:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101373:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101376:	09 da                	or     %ebx,%edx
80101378:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010137c:	57                   	push   %edi
8010137d:	e8 2e 20 00 00       	call   801033b0 <log_write>
        brelse(bp);
80101382:	89 3c 24             	mov    %edi,(%esp)
80101385:	e8 66 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010138a:	58                   	pop    %eax
8010138b:	5a                   	pop    %edx
8010138c:	56                   	push   %esi
8010138d:	ff 75 d8             	pushl  -0x28(%ebp)
80101390:	e8 3b ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101395:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101398:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010139a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010139d:	68 00 02 00 00       	push   $0x200
801013a2:	6a 00                	push   $0x0
801013a4:	50                   	push   %eax
801013a5:	e8 26 38 00 00       	call   80104bd0 <memset>
  log_write(bp);
801013aa:	89 1c 24             	mov    %ebx,(%esp)
801013ad:	e8 fe 1f 00 00       	call   801033b0 <log_write>
  brelse(bp);
801013b2:	89 1c 24             	mov    %ebx,(%esp)
801013b5:	e8 36 ee ff ff       	call   801001f0 <brelse>
}
801013ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013bd:	89 f0                	mov    %esi,%eax
801013bf:	5b                   	pop    %ebx
801013c0:	5e                   	pop    %esi
801013c1:	5f                   	pop    %edi
801013c2:	5d                   	pop    %ebp
801013c3:	c3                   	ret    
801013c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801013cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013cf:	90                   	nop

801013d0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801013d0:	55                   	push   %ebp
801013d1:	89 e5                	mov    %esp,%ebp
801013d3:	57                   	push   %edi
801013d4:	89 c7                	mov    %eax,%edi
801013d6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801013d7:	31 f6                	xor    %esi,%esi
{
801013d9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013da:	bb 54 fa 11 80       	mov    $0x8011fa54,%ebx
{
801013df:	83 ec 28             	sub    $0x28,%esp
801013e2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801013e5:	68 20 fa 11 80       	push   $0x8011fa20
801013ea:	e8 d1 36 00 00       	call   80104ac0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013ef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
801013f2:	83 c4 10             	add    $0x10,%esp
801013f5:	eb 1b                	jmp    80101412 <iget+0x42>
801013f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801013fe:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101400:	39 3b                	cmp    %edi,(%ebx)
80101402:	74 6c                	je     80101470 <iget+0xa0>
80101404:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010140a:	81 fb 74 16 12 80    	cmp    $0x80121674,%ebx
80101410:	73 26                	jae    80101438 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101412:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101415:	85 c9                	test   %ecx,%ecx
80101417:	7f e7                	jg     80101400 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101419:	85 f6                	test   %esi,%esi
8010141b:	75 e7                	jne    80101404 <iget+0x34>
8010141d:	89 d8                	mov    %ebx,%eax
8010141f:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101425:	85 c9                	test   %ecx,%ecx
80101427:	75 6e                	jne    80101497 <iget+0xc7>
80101429:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010142b:	81 fb 74 16 12 80    	cmp    $0x80121674,%ebx
80101431:	72 df                	jb     80101412 <iget+0x42>
80101433:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101437:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101438:	85 f6                	test   %esi,%esi
8010143a:	74 73                	je     801014af <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010143c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010143f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101441:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101444:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010144b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101452:	68 20 fa 11 80       	push   $0x8011fa20
80101457:	e8 24 37 00 00       	call   80104b80 <release>

  return ip;
8010145c:	83 c4 10             	add    $0x10,%esp
}
8010145f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101462:	89 f0                	mov    %esi,%eax
80101464:	5b                   	pop    %ebx
80101465:	5e                   	pop    %esi
80101466:	5f                   	pop    %edi
80101467:	5d                   	pop    %ebp
80101468:	c3                   	ret    
80101469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101470:	39 53 04             	cmp    %edx,0x4(%ebx)
80101473:	75 8f                	jne    80101404 <iget+0x34>
      release(&icache.lock);
80101475:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101478:	83 c1 01             	add    $0x1,%ecx
      return ip;
8010147b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010147d:	68 20 fa 11 80       	push   $0x8011fa20
      ip->ref++;
80101482:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101485:	e8 f6 36 00 00       	call   80104b80 <release>
      return ip;
8010148a:	83 c4 10             	add    $0x10,%esp
}
8010148d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101490:	89 f0                	mov    %esi,%eax
80101492:	5b                   	pop    %ebx
80101493:	5e                   	pop    %esi
80101494:	5f                   	pop    %edi
80101495:	5d                   	pop    %ebp
80101496:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101497:	81 fb 74 16 12 80    	cmp    $0x80121674,%ebx
8010149d:	73 10                	jae    801014af <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010149f:	8b 4b 08             	mov    0x8(%ebx),%ecx
801014a2:	85 c9                	test   %ecx,%ecx
801014a4:	0f 8f 56 ff ff ff    	jg     80101400 <iget+0x30>
801014aa:	e9 6e ff ff ff       	jmp    8010141d <iget+0x4d>
    panic("iget: no inodes");
801014af:	83 ec 0c             	sub    $0xc,%esp
801014b2:	68 28 81 10 80       	push   $0x80108128
801014b7:	e8 d4 ee ff ff       	call   80100390 <panic>
801014bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801014c0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801014c0:	55                   	push   %ebp
801014c1:	89 e5                	mov    %esp,%ebp
801014c3:	57                   	push   %edi
801014c4:	56                   	push   %esi
801014c5:	89 c6                	mov    %eax,%esi
801014c7:	53                   	push   %ebx
801014c8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801014cb:	83 fa 0b             	cmp    $0xb,%edx
801014ce:	0f 86 84 00 00 00    	jbe    80101558 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801014d4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801014d7:	83 fb 7f             	cmp    $0x7f,%ebx
801014da:	0f 87 98 00 00 00    	ja     80101578 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801014e0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801014e6:	8b 16                	mov    (%esi),%edx
801014e8:	85 c0                	test   %eax,%eax
801014ea:	74 54                	je     80101540 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801014ec:	83 ec 08             	sub    $0x8,%esp
801014ef:	50                   	push   %eax
801014f0:	52                   	push   %edx
801014f1:	e8 da eb ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801014f6:	83 c4 10             	add    $0x10,%esp
801014f9:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
801014fd:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801014ff:	8b 1a                	mov    (%edx),%ebx
80101501:	85 db                	test   %ebx,%ebx
80101503:	74 1b                	je     80101520 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101505:	83 ec 0c             	sub    $0xc,%esp
80101508:	57                   	push   %edi
80101509:	e8 e2 ec ff ff       	call   801001f0 <brelse>
    return addr;
8010150e:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
80101511:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101514:	89 d8                	mov    %ebx,%eax
80101516:	5b                   	pop    %ebx
80101517:	5e                   	pop    %esi
80101518:	5f                   	pop    %edi
80101519:	5d                   	pop    %ebp
8010151a:	c3                   	ret    
8010151b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010151f:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
80101520:	8b 06                	mov    (%esi),%eax
80101522:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101525:	e8 96 fd ff ff       	call   801012c0 <balloc>
8010152a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
8010152d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101530:	89 c3                	mov    %eax,%ebx
80101532:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101534:	57                   	push   %edi
80101535:	e8 76 1e 00 00       	call   801033b0 <log_write>
8010153a:	83 c4 10             	add    $0x10,%esp
8010153d:	eb c6                	jmp    80101505 <bmap+0x45>
8010153f:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101540:	89 d0                	mov    %edx,%eax
80101542:	e8 79 fd ff ff       	call   801012c0 <balloc>
80101547:	8b 16                	mov    (%esi),%edx
80101549:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010154f:	eb 9b                	jmp    801014ec <bmap+0x2c>
80101551:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
80101558:	8d 3c 90             	lea    (%eax,%edx,4),%edi
8010155b:	8b 5f 5c             	mov    0x5c(%edi),%ebx
8010155e:	85 db                	test   %ebx,%ebx
80101560:	75 af                	jne    80101511 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101562:	8b 00                	mov    (%eax),%eax
80101564:	e8 57 fd ff ff       	call   801012c0 <balloc>
80101569:	89 47 5c             	mov    %eax,0x5c(%edi)
8010156c:	89 c3                	mov    %eax,%ebx
}
8010156e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101571:	89 d8                	mov    %ebx,%eax
80101573:	5b                   	pop    %ebx
80101574:	5e                   	pop    %esi
80101575:	5f                   	pop    %edi
80101576:	5d                   	pop    %ebp
80101577:	c3                   	ret    
  panic("bmap: out of range");
80101578:	83 ec 0c             	sub    $0xc,%esp
8010157b:	68 38 81 10 80       	push   $0x80108138
80101580:	e8 0b ee ff ff       	call   80100390 <panic>
80101585:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010158c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101590 <readsb>:
{
80101590:	f3 0f 1e fb          	endbr32 
80101594:	55                   	push   %ebp
80101595:	89 e5                	mov    %esp,%ebp
80101597:	56                   	push   %esi
80101598:	53                   	push   %ebx
80101599:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
8010159c:	83 ec 08             	sub    $0x8,%esp
8010159f:	6a 01                	push   $0x1
801015a1:	ff 75 08             	pushl  0x8(%ebp)
801015a4:	e8 27 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015a9:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015ac:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015ae:	8d 40 5c             	lea    0x5c(%eax),%eax
801015b1:	6a 1c                	push   $0x1c
801015b3:	50                   	push   %eax
801015b4:	56                   	push   %esi
801015b5:	e8 b6 36 00 00       	call   80104c70 <memmove>
  brelse(bp);
801015ba:	89 5d 08             	mov    %ebx,0x8(%ebp)
801015bd:	83 c4 10             	add    $0x10,%esp
}
801015c0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015c3:	5b                   	pop    %ebx
801015c4:	5e                   	pop    %esi
801015c5:	5d                   	pop    %ebp
  brelse(bp);
801015c6:	e9 25 ec ff ff       	jmp    801001f0 <brelse>
801015cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801015cf:	90                   	nop

801015d0 <iinit>:
{
801015d0:	f3 0f 1e fb          	endbr32 
801015d4:	55                   	push   %ebp
801015d5:	89 e5                	mov    %esp,%ebp
801015d7:	53                   	push   %ebx
801015d8:	bb 60 fa 11 80       	mov    $0x8011fa60,%ebx
801015dd:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801015e0:	68 4b 81 10 80       	push   $0x8010814b
801015e5:	68 20 fa 11 80       	push   $0x8011fa20
801015ea:	e8 51 33 00 00       	call   80104940 <initlock>
  for(i = 0; i < NINODE; i++) {
801015ef:	83 c4 10             	add    $0x10,%esp
801015f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
801015f8:	83 ec 08             	sub    $0x8,%esp
801015fb:	68 52 81 10 80       	push   $0x80108152
80101600:	53                   	push   %ebx
80101601:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101607:	e8 f4 31 00 00       	call   80104800 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
8010160c:	83 c4 10             	add    $0x10,%esp
8010160f:	81 fb 80 16 12 80    	cmp    $0x80121680,%ebx
80101615:	75 e1                	jne    801015f8 <iinit+0x28>
  readsb(dev, &sb);
80101617:	83 ec 08             	sub    $0x8,%esp
8010161a:	68 00 fa 11 80       	push   $0x8011fa00
8010161f:	ff 75 08             	pushl  0x8(%ebp)
80101622:	e8 69 ff ff ff       	call   80101590 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101627:	ff 35 18 fa 11 80    	pushl  0x8011fa18
8010162d:	ff 35 14 fa 11 80    	pushl  0x8011fa14
80101633:	ff 35 10 fa 11 80    	pushl  0x8011fa10
80101639:	ff 35 0c fa 11 80    	pushl  0x8011fa0c
8010163f:	ff 35 08 fa 11 80    	pushl  0x8011fa08
80101645:	ff 35 04 fa 11 80    	pushl  0x8011fa04
8010164b:	ff 35 00 fa 11 80    	pushl  0x8011fa00
80101651:	68 fc 81 10 80       	push   $0x801081fc
80101656:	e8 55 f0 ff ff       	call   801006b0 <cprintf>
}
8010165b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010165e:	83 c4 30             	add    $0x30,%esp
80101661:	c9                   	leave  
80101662:	c3                   	ret    
80101663:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010166a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101670 <ialloc>:
{
80101670:	f3 0f 1e fb          	endbr32 
80101674:	55                   	push   %ebp
80101675:	89 e5                	mov    %esp,%ebp
80101677:	57                   	push   %edi
80101678:	56                   	push   %esi
80101679:	53                   	push   %ebx
8010167a:	83 ec 1c             	sub    $0x1c,%esp
8010167d:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80101680:	83 3d 08 fa 11 80 01 	cmpl   $0x1,0x8011fa08
{
80101687:	8b 75 08             	mov    0x8(%ebp),%esi
8010168a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
8010168d:	0f 86 8d 00 00 00    	jbe    80101720 <ialloc+0xb0>
80101693:	bf 01 00 00 00       	mov    $0x1,%edi
80101698:	eb 1d                	jmp    801016b7 <ialloc+0x47>
8010169a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
801016a0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801016a3:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
801016a6:	53                   	push   %ebx
801016a7:	e8 44 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801016ac:	83 c4 10             	add    $0x10,%esp
801016af:	3b 3d 08 fa 11 80    	cmp    0x8011fa08,%edi
801016b5:	73 69                	jae    80101720 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801016b7:	89 f8                	mov    %edi,%eax
801016b9:	83 ec 08             	sub    $0x8,%esp
801016bc:	c1 e8 03             	shr    $0x3,%eax
801016bf:	03 05 14 fa 11 80    	add    0x8011fa14,%eax
801016c5:	50                   	push   %eax
801016c6:	56                   	push   %esi
801016c7:	e8 04 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
801016cc:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
801016cf:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
801016d1:	89 f8                	mov    %edi,%eax
801016d3:	83 e0 07             	and    $0x7,%eax
801016d6:	c1 e0 06             	shl    $0x6,%eax
801016d9:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801016dd:	66 83 39 00          	cmpw   $0x0,(%ecx)
801016e1:	75 bd                	jne    801016a0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801016e3:	83 ec 04             	sub    $0x4,%esp
801016e6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801016e9:	6a 40                	push   $0x40
801016eb:	6a 00                	push   $0x0
801016ed:	51                   	push   %ecx
801016ee:	e8 dd 34 00 00       	call   80104bd0 <memset>
      dip->type = type;
801016f3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801016f7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801016fa:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801016fd:	89 1c 24             	mov    %ebx,(%esp)
80101700:	e8 ab 1c 00 00       	call   801033b0 <log_write>
      brelse(bp);
80101705:	89 1c 24             	mov    %ebx,(%esp)
80101708:	e8 e3 ea ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010170d:	83 c4 10             	add    $0x10,%esp
}
80101710:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101713:	89 fa                	mov    %edi,%edx
}
80101715:	5b                   	pop    %ebx
      return iget(dev, inum);
80101716:	89 f0                	mov    %esi,%eax
}
80101718:	5e                   	pop    %esi
80101719:	5f                   	pop    %edi
8010171a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010171b:	e9 b0 fc ff ff       	jmp    801013d0 <iget>
  panic("ialloc: no inodes");
80101720:	83 ec 0c             	sub    $0xc,%esp
80101723:	68 58 81 10 80       	push   $0x80108158
80101728:	e8 63 ec ff ff       	call   80100390 <panic>
8010172d:	8d 76 00             	lea    0x0(%esi),%esi

80101730 <iupdate>:
{
80101730:	f3 0f 1e fb          	endbr32 
80101734:	55                   	push   %ebp
80101735:	89 e5                	mov    %esp,%ebp
80101737:	56                   	push   %esi
80101738:	53                   	push   %ebx
80101739:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010173c:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010173f:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101742:	83 ec 08             	sub    $0x8,%esp
80101745:	c1 e8 03             	shr    $0x3,%eax
80101748:	03 05 14 fa 11 80    	add    0x8011fa14,%eax
8010174e:	50                   	push   %eax
8010174f:	ff 73 a4             	pushl  -0x5c(%ebx)
80101752:	e8 79 e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101757:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010175b:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010175e:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101760:	8b 43 a8             	mov    -0x58(%ebx),%eax
80101763:	83 e0 07             	and    $0x7,%eax
80101766:	c1 e0 06             	shl    $0x6,%eax
80101769:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
8010176d:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101770:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101774:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101777:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
8010177b:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010177f:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101783:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101787:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
8010178b:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010178e:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101791:	6a 34                	push   $0x34
80101793:	53                   	push   %ebx
80101794:	50                   	push   %eax
80101795:	e8 d6 34 00 00       	call   80104c70 <memmove>
  log_write(bp);
8010179a:	89 34 24             	mov    %esi,(%esp)
8010179d:	e8 0e 1c 00 00       	call   801033b0 <log_write>
  brelse(bp);
801017a2:	89 75 08             	mov    %esi,0x8(%ebp)
801017a5:	83 c4 10             	add    $0x10,%esp
}
801017a8:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017ab:	5b                   	pop    %ebx
801017ac:	5e                   	pop    %esi
801017ad:	5d                   	pop    %ebp
  brelse(bp);
801017ae:	e9 3d ea ff ff       	jmp    801001f0 <brelse>
801017b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801017c0 <idup>:
{
801017c0:	f3 0f 1e fb          	endbr32 
801017c4:	55                   	push   %ebp
801017c5:	89 e5                	mov    %esp,%ebp
801017c7:	53                   	push   %ebx
801017c8:	83 ec 10             	sub    $0x10,%esp
801017cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801017ce:	68 20 fa 11 80       	push   $0x8011fa20
801017d3:	e8 e8 32 00 00       	call   80104ac0 <acquire>
  ip->ref++;
801017d8:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017dc:	c7 04 24 20 fa 11 80 	movl   $0x8011fa20,(%esp)
801017e3:	e8 98 33 00 00       	call   80104b80 <release>
}
801017e8:	89 d8                	mov    %ebx,%eax
801017ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801017ed:	c9                   	leave  
801017ee:	c3                   	ret    
801017ef:	90                   	nop

801017f0 <ilock>:
{
801017f0:	f3 0f 1e fb          	endbr32 
801017f4:	55                   	push   %ebp
801017f5:	89 e5                	mov    %esp,%ebp
801017f7:	56                   	push   %esi
801017f8:	53                   	push   %ebx
801017f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801017fc:	85 db                	test   %ebx,%ebx
801017fe:	0f 84 b3 00 00 00    	je     801018b7 <ilock+0xc7>
80101804:	8b 53 08             	mov    0x8(%ebx),%edx
80101807:	85 d2                	test   %edx,%edx
80101809:	0f 8e a8 00 00 00    	jle    801018b7 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010180f:	83 ec 0c             	sub    $0xc,%esp
80101812:	8d 43 0c             	lea    0xc(%ebx),%eax
80101815:	50                   	push   %eax
80101816:	e8 25 30 00 00       	call   80104840 <acquiresleep>
  if(ip->valid == 0){
8010181b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010181e:	83 c4 10             	add    $0x10,%esp
80101821:	85 c0                	test   %eax,%eax
80101823:	74 0b                	je     80101830 <ilock+0x40>
}
80101825:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101828:	5b                   	pop    %ebx
80101829:	5e                   	pop    %esi
8010182a:	5d                   	pop    %ebp
8010182b:	c3                   	ret    
8010182c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101830:	8b 43 04             	mov    0x4(%ebx),%eax
80101833:	83 ec 08             	sub    $0x8,%esp
80101836:	c1 e8 03             	shr    $0x3,%eax
80101839:	03 05 14 fa 11 80    	add    0x8011fa14,%eax
8010183f:	50                   	push   %eax
80101840:	ff 33                	pushl  (%ebx)
80101842:	e8 89 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101847:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010184a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010184c:	8b 43 04             	mov    0x4(%ebx),%eax
8010184f:	83 e0 07             	and    $0x7,%eax
80101852:	c1 e0 06             	shl    $0x6,%eax
80101855:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101859:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010185c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010185f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101863:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101867:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010186b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010186f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101873:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101877:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010187b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010187e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101881:	6a 34                	push   $0x34
80101883:	50                   	push   %eax
80101884:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101887:	50                   	push   %eax
80101888:	e8 e3 33 00 00       	call   80104c70 <memmove>
    brelse(bp);
8010188d:	89 34 24             	mov    %esi,(%esp)
80101890:	e8 5b e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101895:	83 c4 10             	add    $0x10,%esp
80101898:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010189d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801018a4:	0f 85 7b ff ff ff    	jne    80101825 <ilock+0x35>
      panic("ilock: no type");
801018aa:	83 ec 0c             	sub    $0xc,%esp
801018ad:	68 70 81 10 80       	push   $0x80108170
801018b2:	e8 d9 ea ff ff       	call   80100390 <panic>
    panic("ilock");
801018b7:	83 ec 0c             	sub    $0xc,%esp
801018ba:	68 6a 81 10 80       	push   $0x8010816a
801018bf:	e8 cc ea ff ff       	call   80100390 <panic>
801018c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801018cf:	90                   	nop

801018d0 <iunlock>:
{
801018d0:	f3 0f 1e fb          	endbr32 
801018d4:	55                   	push   %ebp
801018d5:	89 e5                	mov    %esp,%ebp
801018d7:	56                   	push   %esi
801018d8:	53                   	push   %ebx
801018d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801018dc:	85 db                	test   %ebx,%ebx
801018de:	74 28                	je     80101908 <iunlock+0x38>
801018e0:	83 ec 0c             	sub    $0xc,%esp
801018e3:	8d 73 0c             	lea    0xc(%ebx),%esi
801018e6:	56                   	push   %esi
801018e7:	e8 f4 2f 00 00       	call   801048e0 <holdingsleep>
801018ec:	83 c4 10             	add    $0x10,%esp
801018ef:	85 c0                	test   %eax,%eax
801018f1:	74 15                	je     80101908 <iunlock+0x38>
801018f3:	8b 43 08             	mov    0x8(%ebx),%eax
801018f6:	85 c0                	test   %eax,%eax
801018f8:	7e 0e                	jle    80101908 <iunlock+0x38>
  releasesleep(&ip->lock);
801018fa:	89 75 08             	mov    %esi,0x8(%ebp)
}
801018fd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101900:	5b                   	pop    %ebx
80101901:	5e                   	pop    %esi
80101902:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101903:	e9 98 2f 00 00       	jmp    801048a0 <releasesleep>
    panic("iunlock");
80101908:	83 ec 0c             	sub    $0xc,%esp
8010190b:	68 7f 81 10 80       	push   $0x8010817f
80101910:	e8 7b ea ff ff       	call   80100390 <panic>
80101915:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010191c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101920 <iput>:
{
80101920:	f3 0f 1e fb          	endbr32 
80101924:	55                   	push   %ebp
80101925:	89 e5                	mov    %esp,%ebp
80101927:	57                   	push   %edi
80101928:	56                   	push   %esi
80101929:	53                   	push   %ebx
8010192a:	83 ec 28             	sub    $0x28,%esp
8010192d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101930:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101933:	57                   	push   %edi
80101934:	e8 07 2f 00 00       	call   80104840 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101939:	8b 53 4c             	mov    0x4c(%ebx),%edx
8010193c:	83 c4 10             	add    $0x10,%esp
8010193f:	85 d2                	test   %edx,%edx
80101941:	74 07                	je     8010194a <iput+0x2a>
80101943:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101948:	74 36                	je     80101980 <iput+0x60>
  releasesleep(&ip->lock);
8010194a:	83 ec 0c             	sub    $0xc,%esp
8010194d:	57                   	push   %edi
8010194e:	e8 4d 2f 00 00       	call   801048a0 <releasesleep>
  acquire(&icache.lock);
80101953:	c7 04 24 20 fa 11 80 	movl   $0x8011fa20,(%esp)
8010195a:	e8 61 31 00 00       	call   80104ac0 <acquire>
  ip->ref--;
8010195f:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101963:	83 c4 10             	add    $0x10,%esp
80101966:	c7 45 08 20 fa 11 80 	movl   $0x8011fa20,0x8(%ebp)
}
8010196d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101970:	5b                   	pop    %ebx
80101971:	5e                   	pop    %esi
80101972:	5f                   	pop    %edi
80101973:	5d                   	pop    %ebp
  release(&icache.lock);
80101974:	e9 07 32 00 00       	jmp    80104b80 <release>
80101979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
80101980:	83 ec 0c             	sub    $0xc,%esp
80101983:	68 20 fa 11 80       	push   $0x8011fa20
80101988:	e8 33 31 00 00       	call   80104ac0 <acquire>
    int r = ip->ref;
8010198d:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101990:	c7 04 24 20 fa 11 80 	movl   $0x8011fa20,(%esp)
80101997:	e8 e4 31 00 00       	call   80104b80 <release>
    if(r == 1){
8010199c:	83 c4 10             	add    $0x10,%esp
8010199f:	83 fe 01             	cmp    $0x1,%esi
801019a2:	75 a6                	jne    8010194a <iput+0x2a>
801019a4:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
801019aa:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801019ad:	8d 73 5c             	lea    0x5c(%ebx),%esi
801019b0:	89 cf                	mov    %ecx,%edi
801019b2:	eb 0b                	jmp    801019bf <iput+0x9f>
801019b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801019b8:	83 c6 04             	add    $0x4,%esi
801019bb:	39 fe                	cmp    %edi,%esi
801019bd:	74 19                	je     801019d8 <iput+0xb8>
    if(ip->addrs[i]){
801019bf:	8b 16                	mov    (%esi),%edx
801019c1:	85 d2                	test   %edx,%edx
801019c3:	74 f3                	je     801019b8 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
801019c5:	8b 03                	mov    (%ebx),%eax
801019c7:	e8 74 f8 ff ff       	call   80101240 <bfree>
      ip->addrs[i] = 0;
801019cc:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801019d2:	eb e4                	jmp    801019b8 <iput+0x98>
801019d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801019d8:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801019de:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019e1:	85 c0                	test   %eax,%eax
801019e3:	75 33                	jne    80101a18 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
801019e5:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
801019e8:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
801019ef:	53                   	push   %ebx
801019f0:	e8 3b fd ff ff       	call   80101730 <iupdate>
      ip->type = 0;
801019f5:	31 c0                	xor    %eax,%eax
801019f7:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801019fb:	89 1c 24             	mov    %ebx,(%esp)
801019fe:	e8 2d fd ff ff       	call   80101730 <iupdate>
      ip->valid = 0;
80101a03:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101a0a:	83 c4 10             	add    $0x10,%esp
80101a0d:	e9 38 ff ff ff       	jmp    8010194a <iput+0x2a>
80101a12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101a18:	83 ec 08             	sub    $0x8,%esp
80101a1b:	50                   	push   %eax
80101a1c:	ff 33                	pushl  (%ebx)
80101a1e:	e8 ad e6 ff ff       	call   801000d0 <bread>
80101a23:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a26:	83 c4 10             	add    $0x10,%esp
80101a29:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101a2f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101a32:	8d 70 5c             	lea    0x5c(%eax),%esi
80101a35:	89 cf                	mov    %ecx,%edi
80101a37:	eb 0e                	jmp    80101a47 <iput+0x127>
80101a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a40:	83 c6 04             	add    $0x4,%esi
80101a43:	39 f7                	cmp    %esi,%edi
80101a45:	74 19                	je     80101a60 <iput+0x140>
      if(a[j])
80101a47:	8b 16                	mov    (%esi),%edx
80101a49:	85 d2                	test   %edx,%edx
80101a4b:	74 f3                	je     80101a40 <iput+0x120>
        bfree(ip->dev, a[j]);
80101a4d:	8b 03                	mov    (%ebx),%eax
80101a4f:	e8 ec f7 ff ff       	call   80101240 <bfree>
80101a54:	eb ea                	jmp    80101a40 <iput+0x120>
80101a56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a5d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101a60:	83 ec 0c             	sub    $0xc,%esp
80101a63:	ff 75 e4             	pushl  -0x1c(%ebp)
80101a66:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a69:	e8 82 e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a6e:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101a74:	8b 03                	mov    (%ebx),%eax
80101a76:	e8 c5 f7 ff ff       	call   80101240 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a7b:	83 c4 10             	add    $0x10,%esp
80101a7e:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a85:	00 00 00 
80101a88:	e9 58 ff ff ff       	jmp    801019e5 <iput+0xc5>
80101a8d:	8d 76 00             	lea    0x0(%esi),%esi

80101a90 <iunlockput>:
{
80101a90:	f3 0f 1e fb          	endbr32 
80101a94:	55                   	push   %ebp
80101a95:	89 e5                	mov    %esp,%ebp
80101a97:	53                   	push   %ebx
80101a98:	83 ec 10             	sub    $0x10,%esp
80101a9b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101a9e:	53                   	push   %ebx
80101a9f:	e8 2c fe ff ff       	call   801018d0 <iunlock>
  iput(ip);
80101aa4:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101aa7:	83 c4 10             	add    $0x10,%esp
}
80101aaa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101aad:	c9                   	leave  
  iput(ip);
80101aae:	e9 6d fe ff ff       	jmp    80101920 <iput>
80101ab3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101ac0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101ac0:	f3 0f 1e fb          	endbr32 
80101ac4:	55                   	push   %ebp
80101ac5:	89 e5                	mov    %esp,%ebp
80101ac7:	8b 55 08             	mov    0x8(%ebp),%edx
80101aca:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101acd:	8b 0a                	mov    (%edx),%ecx
80101acf:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101ad2:	8b 4a 04             	mov    0x4(%edx),%ecx
80101ad5:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101ad8:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101adc:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101adf:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101ae3:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101ae7:	8b 52 58             	mov    0x58(%edx),%edx
80101aea:	89 50 10             	mov    %edx,0x10(%eax)
}
80101aed:	5d                   	pop    %ebp
80101aee:	c3                   	ret    
80101aef:	90                   	nop

80101af0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101af0:	f3 0f 1e fb          	endbr32 
80101af4:	55                   	push   %ebp
80101af5:	89 e5                	mov    %esp,%ebp
80101af7:	57                   	push   %edi
80101af8:	56                   	push   %esi
80101af9:	53                   	push   %ebx
80101afa:	83 ec 1c             	sub    $0x1c,%esp
80101afd:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101b00:	8b 45 08             	mov    0x8(%ebp),%eax
80101b03:	8b 75 10             	mov    0x10(%ebp),%esi
80101b06:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101b09:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b0c:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b11:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b14:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101b17:	0f 84 a3 00 00 00    	je     80101bc0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101b1d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b20:	8b 40 58             	mov    0x58(%eax),%eax
80101b23:	39 c6                	cmp    %eax,%esi
80101b25:	0f 87 b6 00 00 00    	ja     80101be1 <readi+0xf1>
80101b2b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b2e:	31 c9                	xor    %ecx,%ecx
80101b30:	89 da                	mov    %ebx,%edx
80101b32:	01 f2                	add    %esi,%edx
80101b34:	0f 92 c1             	setb   %cl
80101b37:	89 cf                	mov    %ecx,%edi
80101b39:	0f 82 a2 00 00 00    	jb     80101be1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101b3f:	89 c1                	mov    %eax,%ecx
80101b41:	29 f1                	sub    %esi,%ecx
80101b43:	39 d0                	cmp    %edx,%eax
80101b45:	0f 43 cb             	cmovae %ebx,%ecx
80101b48:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b4b:	85 c9                	test   %ecx,%ecx
80101b4d:	74 63                	je     80101bb2 <readi+0xc2>
80101b4f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b50:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b53:	89 f2                	mov    %esi,%edx
80101b55:	c1 ea 09             	shr    $0x9,%edx
80101b58:	89 d8                	mov    %ebx,%eax
80101b5a:	e8 61 f9 ff ff       	call   801014c0 <bmap>
80101b5f:	83 ec 08             	sub    $0x8,%esp
80101b62:	50                   	push   %eax
80101b63:	ff 33                	pushl  (%ebx)
80101b65:	e8 66 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b6a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b6d:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b72:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b75:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b77:	89 f0                	mov    %esi,%eax
80101b79:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b7e:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b80:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b83:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b85:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b89:	39 d9                	cmp    %ebx,%ecx
80101b8b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b8e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b8f:	01 df                	add    %ebx,%edi
80101b91:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b93:	50                   	push   %eax
80101b94:	ff 75 e0             	pushl  -0x20(%ebp)
80101b97:	e8 d4 30 00 00       	call   80104c70 <memmove>
    brelse(bp);
80101b9c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b9f:	89 14 24             	mov    %edx,(%esp)
80101ba2:	e8 49 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ba7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101baa:	83 c4 10             	add    $0x10,%esp
80101bad:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101bb0:	77 9e                	ja     80101b50 <readi+0x60>
  }
  return n;
80101bb2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101bb5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bb8:	5b                   	pop    %ebx
80101bb9:	5e                   	pop    %esi
80101bba:	5f                   	pop    %edi
80101bbb:	5d                   	pop    %ebp
80101bbc:	c3                   	ret    
80101bbd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101bc0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101bc4:	66 83 f8 09          	cmp    $0x9,%ax
80101bc8:	77 17                	ja     80101be1 <readi+0xf1>
80101bca:	8b 04 c5 a0 f9 11 80 	mov    -0x7fee0660(,%eax,8),%eax
80101bd1:	85 c0                	test   %eax,%eax
80101bd3:	74 0c                	je     80101be1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101bd5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101bd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bdb:	5b                   	pop    %ebx
80101bdc:	5e                   	pop    %esi
80101bdd:	5f                   	pop    %edi
80101bde:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101bdf:	ff e0                	jmp    *%eax
      return -1;
80101be1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101be6:	eb cd                	jmp    80101bb5 <readi+0xc5>
80101be8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bef:	90                   	nop

80101bf0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101bf0:	f3 0f 1e fb          	endbr32 
80101bf4:	55                   	push   %ebp
80101bf5:	89 e5                	mov    %esp,%ebp
80101bf7:	57                   	push   %edi
80101bf8:	56                   	push   %esi
80101bf9:	53                   	push   %ebx
80101bfa:	83 ec 1c             	sub    $0x1c,%esp
80101bfd:	8b 45 08             	mov    0x8(%ebp),%eax
80101c00:	8b 75 0c             	mov    0xc(%ebp),%esi
80101c03:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101c06:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101c0b:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101c0e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c11:	8b 75 10             	mov    0x10(%ebp),%esi
80101c14:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101c17:	0f 84 b3 00 00 00    	je     80101cd0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101c1d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c20:	39 70 58             	cmp    %esi,0x58(%eax)
80101c23:	0f 82 e3 00 00 00    	jb     80101d0c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101c29:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101c2c:	89 f8                	mov    %edi,%eax
80101c2e:	01 f0                	add    %esi,%eax
80101c30:	0f 82 d6 00 00 00    	jb     80101d0c <writei+0x11c>
80101c36:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101c3b:	0f 87 cb 00 00 00    	ja     80101d0c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c41:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101c48:	85 ff                	test   %edi,%edi
80101c4a:	74 75                	je     80101cc1 <writei+0xd1>
80101c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c50:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101c53:	89 f2                	mov    %esi,%edx
80101c55:	c1 ea 09             	shr    $0x9,%edx
80101c58:	89 f8                	mov    %edi,%eax
80101c5a:	e8 61 f8 ff ff       	call   801014c0 <bmap>
80101c5f:	83 ec 08             	sub    $0x8,%esp
80101c62:	50                   	push   %eax
80101c63:	ff 37                	pushl  (%edi)
80101c65:	e8 66 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c6a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c6f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c72:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c75:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c77:	89 f0                	mov    %esi,%eax
80101c79:	83 c4 0c             	add    $0xc,%esp
80101c7c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c81:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c83:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c87:	39 d9                	cmp    %ebx,%ecx
80101c89:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c8c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c8d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c8f:	ff 75 dc             	pushl  -0x24(%ebp)
80101c92:	50                   	push   %eax
80101c93:	e8 d8 2f 00 00       	call   80104c70 <memmove>
    log_write(bp);
80101c98:	89 3c 24             	mov    %edi,(%esp)
80101c9b:	e8 10 17 00 00       	call   801033b0 <log_write>
    brelse(bp);
80101ca0:	89 3c 24             	mov    %edi,(%esp)
80101ca3:	e8 48 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ca8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101cab:	83 c4 10             	add    $0x10,%esp
80101cae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101cb1:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101cb4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101cb7:	77 97                	ja     80101c50 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101cb9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101cbc:	3b 70 58             	cmp    0x58(%eax),%esi
80101cbf:	77 37                	ja     80101cf8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101cc1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101cc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cc7:	5b                   	pop    %ebx
80101cc8:	5e                   	pop    %esi
80101cc9:	5f                   	pop    %edi
80101cca:	5d                   	pop    %ebp
80101ccb:	c3                   	ret    
80101ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101cd0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101cd4:	66 83 f8 09          	cmp    $0x9,%ax
80101cd8:	77 32                	ja     80101d0c <writei+0x11c>
80101cda:	8b 04 c5 a4 f9 11 80 	mov    -0x7fee065c(,%eax,8),%eax
80101ce1:	85 c0                	test   %eax,%eax
80101ce3:	74 27                	je     80101d0c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101ce5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101ce8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ceb:	5b                   	pop    %ebx
80101cec:	5e                   	pop    %esi
80101ced:	5f                   	pop    %edi
80101cee:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101cef:	ff e0                	jmp    *%eax
80101cf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101cf8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101cfb:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101cfe:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101d01:	50                   	push   %eax
80101d02:	e8 29 fa ff ff       	call   80101730 <iupdate>
80101d07:	83 c4 10             	add    $0x10,%esp
80101d0a:	eb b5                	jmp    80101cc1 <writei+0xd1>
      return -1;
80101d0c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d11:	eb b1                	jmp    80101cc4 <writei+0xd4>
80101d13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101d20 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101d20:	f3 0f 1e fb          	endbr32 
80101d24:	55                   	push   %ebp
80101d25:	89 e5                	mov    %esp,%ebp
80101d27:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101d2a:	6a 0e                	push   $0xe
80101d2c:	ff 75 0c             	pushl  0xc(%ebp)
80101d2f:	ff 75 08             	pushl  0x8(%ebp)
80101d32:	e8 a9 2f 00 00       	call   80104ce0 <strncmp>
}
80101d37:	c9                   	leave  
80101d38:	c3                   	ret    
80101d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d40 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101d40:	f3 0f 1e fb          	endbr32 
80101d44:	55                   	push   %ebp
80101d45:	89 e5                	mov    %esp,%ebp
80101d47:	57                   	push   %edi
80101d48:	56                   	push   %esi
80101d49:	53                   	push   %ebx
80101d4a:	83 ec 1c             	sub    $0x1c,%esp
80101d4d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101d50:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d55:	0f 85 89 00 00 00    	jne    80101de4 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d5b:	8b 53 58             	mov    0x58(%ebx),%edx
80101d5e:	31 ff                	xor    %edi,%edi
80101d60:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d63:	85 d2                	test   %edx,%edx
80101d65:	74 42                	je     80101da9 <dirlookup+0x69>
80101d67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d6e:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d70:	6a 10                	push   $0x10
80101d72:	57                   	push   %edi
80101d73:	56                   	push   %esi
80101d74:	53                   	push   %ebx
80101d75:	e8 76 fd ff ff       	call   80101af0 <readi>
80101d7a:	83 c4 10             	add    $0x10,%esp
80101d7d:	83 f8 10             	cmp    $0x10,%eax
80101d80:	75 55                	jne    80101dd7 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80101d82:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d87:	74 18                	je     80101da1 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80101d89:	83 ec 04             	sub    $0x4,%esp
80101d8c:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d8f:	6a 0e                	push   $0xe
80101d91:	50                   	push   %eax
80101d92:	ff 75 0c             	pushl  0xc(%ebp)
80101d95:	e8 46 2f 00 00       	call   80104ce0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d9a:	83 c4 10             	add    $0x10,%esp
80101d9d:	85 c0                	test   %eax,%eax
80101d9f:	74 17                	je     80101db8 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101da1:	83 c7 10             	add    $0x10,%edi
80101da4:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101da7:	72 c7                	jb     80101d70 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101da9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101dac:	31 c0                	xor    %eax,%eax
}
80101dae:	5b                   	pop    %ebx
80101daf:	5e                   	pop    %esi
80101db0:	5f                   	pop    %edi
80101db1:	5d                   	pop    %ebp
80101db2:	c3                   	ret    
80101db3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101db7:	90                   	nop
      if(poff)
80101db8:	8b 45 10             	mov    0x10(%ebp),%eax
80101dbb:	85 c0                	test   %eax,%eax
80101dbd:	74 05                	je     80101dc4 <dirlookup+0x84>
        *poff = off;
80101dbf:	8b 45 10             	mov    0x10(%ebp),%eax
80101dc2:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101dc4:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101dc8:	8b 03                	mov    (%ebx),%eax
80101dca:	e8 01 f6 ff ff       	call   801013d0 <iget>
}
80101dcf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dd2:	5b                   	pop    %ebx
80101dd3:	5e                   	pop    %esi
80101dd4:	5f                   	pop    %edi
80101dd5:	5d                   	pop    %ebp
80101dd6:	c3                   	ret    
      panic("dirlookup read");
80101dd7:	83 ec 0c             	sub    $0xc,%esp
80101dda:	68 99 81 10 80       	push   $0x80108199
80101ddf:	e8 ac e5 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101de4:	83 ec 0c             	sub    $0xc,%esp
80101de7:	68 87 81 10 80       	push   $0x80108187
80101dec:	e8 9f e5 ff ff       	call   80100390 <panic>
80101df1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101df8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dff:	90                   	nop

80101e00 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101e00:	55                   	push   %ebp
80101e01:	89 e5                	mov    %esp,%ebp
80101e03:	57                   	push   %edi
80101e04:	56                   	push   %esi
80101e05:	53                   	push   %ebx
80101e06:	89 c3                	mov    %eax,%ebx
80101e08:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101e0b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101e0e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101e11:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101e14:	0f 84 86 01 00 00    	je     80101fa0 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101e1a:	e8 11 20 00 00       	call   80103e30 <myproc>
  acquire(&icache.lock);
80101e1f:	83 ec 0c             	sub    $0xc,%esp
80101e22:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101e24:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101e27:	68 20 fa 11 80       	push   $0x8011fa20
80101e2c:	e8 8f 2c 00 00       	call   80104ac0 <acquire>
  ip->ref++;
80101e31:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101e35:	c7 04 24 20 fa 11 80 	movl   $0x8011fa20,(%esp)
80101e3c:	e8 3f 2d 00 00       	call   80104b80 <release>
80101e41:	83 c4 10             	add    $0x10,%esp
80101e44:	eb 0d                	jmp    80101e53 <namex+0x53>
80101e46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e4d:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80101e50:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101e53:	0f b6 07             	movzbl (%edi),%eax
80101e56:	3c 2f                	cmp    $0x2f,%al
80101e58:	74 f6                	je     80101e50 <namex+0x50>
  if(*path == 0)
80101e5a:	84 c0                	test   %al,%al
80101e5c:	0f 84 ee 00 00 00    	je     80101f50 <namex+0x150>
  while(*path != '/' && *path != 0)
80101e62:	0f b6 07             	movzbl (%edi),%eax
80101e65:	84 c0                	test   %al,%al
80101e67:	0f 84 fb 00 00 00    	je     80101f68 <namex+0x168>
80101e6d:	89 fb                	mov    %edi,%ebx
80101e6f:	3c 2f                	cmp    $0x2f,%al
80101e71:	0f 84 f1 00 00 00    	je     80101f68 <namex+0x168>
80101e77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e7e:	66 90                	xchg   %ax,%ax
80101e80:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80101e84:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80101e87:	3c 2f                	cmp    $0x2f,%al
80101e89:	74 04                	je     80101e8f <namex+0x8f>
80101e8b:	84 c0                	test   %al,%al
80101e8d:	75 f1                	jne    80101e80 <namex+0x80>
  len = path - s;
80101e8f:	89 d8                	mov    %ebx,%eax
80101e91:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80101e93:	83 f8 0d             	cmp    $0xd,%eax
80101e96:	0f 8e 84 00 00 00    	jle    80101f20 <namex+0x120>
    memmove(name, s, DIRSIZ);
80101e9c:	83 ec 04             	sub    $0x4,%esp
80101e9f:	6a 0e                	push   $0xe
80101ea1:	57                   	push   %edi
    path++;
80101ea2:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80101ea4:	ff 75 e4             	pushl  -0x1c(%ebp)
80101ea7:	e8 c4 2d 00 00       	call   80104c70 <memmove>
80101eac:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101eaf:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101eb2:	75 0c                	jne    80101ec0 <namex+0xc0>
80101eb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101eb8:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101ebb:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101ebe:	74 f8                	je     80101eb8 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101ec0:	83 ec 0c             	sub    $0xc,%esp
80101ec3:	56                   	push   %esi
80101ec4:	e8 27 f9 ff ff       	call   801017f0 <ilock>
    if(ip->type != T_DIR){
80101ec9:	83 c4 10             	add    $0x10,%esp
80101ecc:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101ed1:	0f 85 a1 00 00 00    	jne    80101f78 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101ed7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101eda:	85 d2                	test   %edx,%edx
80101edc:	74 09                	je     80101ee7 <namex+0xe7>
80101ede:	80 3f 00             	cmpb   $0x0,(%edi)
80101ee1:	0f 84 d9 00 00 00    	je     80101fc0 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101ee7:	83 ec 04             	sub    $0x4,%esp
80101eea:	6a 00                	push   $0x0
80101eec:	ff 75 e4             	pushl  -0x1c(%ebp)
80101eef:	56                   	push   %esi
80101ef0:	e8 4b fe ff ff       	call   80101d40 <dirlookup>
80101ef5:	83 c4 10             	add    $0x10,%esp
80101ef8:	89 c3                	mov    %eax,%ebx
80101efa:	85 c0                	test   %eax,%eax
80101efc:	74 7a                	je     80101f78 <namex+0x178>
  iunlock(ip);
80101efe:	83 ec 0c             	sub    $0xc,%esp
80101f01:	56                   	push   %esi
80101f02:	e8 c9 f9 ff ff       	call   801018d0 <iunlock>
  iput(ip);
80101f07:	89 34 24             	mov    %esi,(%esp)
80101f0a:	89 de                	mov    %ebx,%esi
80101f0c:	e8 0f fa ff ff       	call   80101920 <iput>
80101f11:	83 c4 10             	add    $0x10,%esp
80101f14:	e9 3a ff ff ff       	jmp    80101e53 <namex+0x53>
80101f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f20:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f23:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101f26:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80101f29:	83 ec 04             	sub    $0x4,%esp
80101f2c:	50                   	push   %eax
80101f2d:	57                   	push   %edi
    name[len] = 0;
80101f2e:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80101f30:	ff 75 e4             	pushl  -0x1c(%ebp)
80101f33:	e8 38 2d 00 00       	call   80104c70 <memmove>
    name[len] = 0;
80101f38:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f3b:	83 c4 10             	add    $0x10,%esp
80101f3e:	c6 00 00             	movb   $0x0,(%eax)
80101f41:	e9 69 ff ff ff       	jmp    80101eaf <namex+0xaf>
80101f46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f4d:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101f50:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101f53:	85 c0                	test   %eax,%eax
80101f55:	0f 85 85 00 00 00    	jne    80101fe0 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f5e:	89 f0                	mov    %esi,%eax
80101f60:	5b                   	pop    %ebx
80101f61:	5e                   	pop    %esi
80101f62:	5f                   	pop    %edi
80101f63:	5d                   	pop    %ebp
80101f64:	c3                   	ret    
80101f65:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80101f68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101f6b:	89 fb                	mov    %edi,%ebx
80101f6d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101f70:	31 c0                	xor    %eax,%eax
80101f72:	eb b5                	jmp    80101f29 <namex+0x129>
80101f74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101f78:	83 ec 0c             	sub    $0xc,%esp
80101f7b:	56                   	push   %esi
80101f7c:	e8 4f f9 ff ff       	call   801018d0 <iunlock>
  iput(ip);
80101f81:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f84:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f86:	e8 95 f9 ff ff       	call   80101920 <iput>
      return 0;
80101f8b:	83 c4 10             	add    $0x10,%esp
}
80101f8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f91:	89 f0                	mov    %esi,%eax
80101f93:	5b                   	pop    %ebx
80101f94:	5e                   	pop    %esi
80101f95:	5f                   	pop    %edi
80101f96:	5d                   	pop    %ebp
80101f97:	c3                   	ret    
80101f98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f9f:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80101fa0:	ba 01 00 00 00       	mov    $0x1,%edx
80101fa5:	b8 01 00 00 00       	mov    $0x1,%eax
80101faa:	89 df                	mov    %ebx,%edi
80101fac:	e8 1f f4 ff ff       	call   801013d0 <iget>
80101fb1:	89 c6                	mov    %eax,%esi
80101fb3:	e9 9b fe ff ff       	jmp    80101e53 <namex+0x53>
80101fb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101fbf:	90                   	nop
      iunlock(ip);
80101fc0:	83 ec 0c             	sub    $0xc,%esp
80101fc3:	56                   	push   %esi
80101fc4:	e8 07 f9 ff ff       	call   801018d0 <iunlock>
      return ip;
80101fc9:	83 c4 10             	add    $0x10,%esp
}
80101fcc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fcf:	89 f0                	mov    %esi,%eax
80101fd1:	5b                   	pop    %ebx
80101fd2:	5e                   	pop    %esi
80101fd3:	5f                   	pop    %edi
80101fd4:	5d                   	pop    %ebp
80101fd5:	c3                   	ret    
80101fd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101fdd:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80101fe0:	83 ec 0c             	sub    $0xc,%esp
80101fe3:	56                   	push   %esi
    return 0;
80101fe4:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fe6:	e8 35 f9 ff ff       	call   80101920 <iput>
    return 0;
80101feb:	83 c4 10             	add    $0x10,%esp
80101fee:	e9 68 ff ff ff       	jmp    80101f5b <namex+0x15b>
80101ff3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102000 <dirlink>:
{
80102000:	f3 0f 1e fb          	endbr32 
80102004:	55                   	push   %ebp
80102005:	89 e5                	mov    %esp,%ebp
80102007:	57                   	push   %edi
80102008:	56                   	push   %esi
80102009:	53                   	push   %ebx
8010200a:	83 ec 20             	sub    $0x20,%esp
8010200d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80102010:	6a 00                	push   $0x0
80102012:	ff 75 0c             	pushl  0xc(%ebp)
80102015:	53                   	push   %ebx
80102016:	e8 25 fd ff ff       	call   80101d40 <dirlookup>
8010201b:	83 c4 10             	add    $0x10,%esp
8010201e:	85 c0                	test   %eax,%eax
80102020:	75 6b                	jne    8010208d <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102022:	8b 7b 58             	mov    0x58(%ebx),%edi
80102025:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102028:	85 ff                	test   %edi,%edi
8010202a:	74 2d                	je     80102059 <dirlink+0x59>
8010202c:	31 ff                	xor    %edi,%edi
8010202e:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102031:	eb 0d                	jmp    80102040 <dirlink+0x40>
80102033:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102037:	90                   	nop
80102038:	83 c7 10             	add    $0x10,%edi
8010203b:	3b 7b 58             	cmp    0x58(%ebx),%edi
8010203e:	73 19                	jae    80102059 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102040:	6a 10                	push   $0x10
80102042:	57                   	push   %edi
80102043:	56                   	push   %esi
80102044:	53                   	push   %ebx
80102045:	e8 a6 fa ff ff       	call   80101af0 <readi>
8010204a:	83 c4 10             	add    $0x10,%esp
8010204d:	83 f8 10             	cmp    $0x10,%eax
80102050:	75 4e                	jne    801020a0 <dirlink+0xa0>
    if(de.inum == 0)
80102052:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80102057:	75 df                	jne    80102038 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80102059:	83 ec 04             	sub    $0x4,%esp
8010205c:	8d 45 da             	lea    -0x26(%ebp),%eax
8010205f:	6a 0e                	push   $0xe
80102061:	ff 75 0c             	pushl  0xc(%ebp)
80102064:	50                   	push   %eax
80102065:	e8 c6 2c 00 00       	call   80104d30 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010206a:	6a 10                	push   $0x10
  de.inum = inum;
8010206c:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010206f:	57                   	push   %edi
80102070:	56                   	push   %esi
80102071:	53                   	push   %ebx
  de.inum = inum;
80102072:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102076:	e8 75 fb ff ff       	call   80101bf0 <writei>
8010207b:	83 c4 20             	add    $0x20,%esp
8010207e:	83 f8 10             	cmp    $0x10,%eax
80102081:	75 2a                	jne    801020ad <dirlink+0xad>
  return 0;
80102083:	31 c0                	xor    %eax,%eax
}
80102085:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102088:	5b                   	pop    %ebx
80102089:	5e                   	pop    %esi
8010208a:	5f                   	pop    %edi
8010208b:	5d                   	pop    %ebp
8010208c:	c3                   	ret    
    iput(ip);
8010208d:	83 ec 0c             	sub    $0xc,%esp
80102090:	50                   	push   %eax
80102091:	e8 8a f8 ff ff       	call   80101920 <iput>
    return -1;
80102096:	83 c4 10             	add    $0x10,%esp
80102099:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010209e:	eb e5                	jmp    80102085 <dirlink+0x85>
      panic("dirlink read");
801020a0:	83 ec 0c             	sub    $0xc,%esp
801020a3:	68 a8 81 10 80       	push   $0x801081a8
801020a8:	e8 e3 e2 ff ff       	call   80100390 <panic>
    panic("dirlink");
801020ad:	83 ec 0c             	sub    $0xc,%esp
801020b0:	68 51 88 10 80       	push   $0x80108851
801020b5:	e8 d6 e2 ff ff       	call   80100390 <panic>
801020ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801020c0 <namei>:

struct inode*
namei(char *path)
{
801020c0:	f3 0f 1e fb          	endbr32 
801020c4:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801020c5:	31 d2                	xor    %edx,%edx
{
801020c7:	89 e5                	mov    %esp,%ebp
801020c9:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801020cc:	8b 45 08             	mov    0x8(%ebp),%eax
801020cf:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020d2:	e8 29 fd ff ff       	call   80101e00 <namex>
}
801020d7:	c9                   	leave  
801020d8:	c3                   	ret    
801020d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020e0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020e0:	f3 0f 1e fb          	endbr32 
801020e4:	55                   	push   %ebp
  return namex(path, 1, name);
801020e5:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020ea:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020ef:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020f2:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020f3:	e9 08 fd ff ff       	jmp    80101e00 <namex>
801020f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020ff:	90                   	nop

80102100 <itoa>:

#include "fcntl.h"
#define DIGITS 14

char* itoa(int i, char b[]){
80102100:	f3 0f 1e fb          	endbr32 
80102104:	55                   	push   %ebp
    char const digit[] = "0123456789";
80102105:	b8 38 39 00 00       	mov    $0x3938,%eax
char* itoa(int i, char b[]){
8010210a:	89 e5                	mov    %esp,%ebp
8010210c:	57                   	push   %edi
8010210d:	56                   	push   %esi
8010210e:	53                   	push   %ebx
8010210f:	83 ec 10             	sub    $0x10,%esp
80102112:	8b 7d 0c             	mov    0xc(%ebp),%edi
80102115:	8b 4d 08             	mov    0x8(%ebp),%ecx
    char const digit[] = "0123456789";
80102118:	c7 45 e9 30 31 32 33 	movl   $0x33323130,-0x17(%ebp)
8010211f:	c7 45 ed 34 35 36 37 	movl   $0x37363534,-0x13(%ebp)
80102126:	66 89 45 f1          	mov    %ax,-0xf(%ebp)
8010212a:	89 fb                	mov    %edi,%ebx
8010212c:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
    char* p = b;
    if(i<0){
80102130:	85 c9                	test   %ecx,%ecx
80102132:	79 08                	jns    8010213c <itoa+0x3c>
        *p++ = '-';
80102134:	c6 07 2d             	movb   $0x2d,(%edi)
80102137:	8d 5f 01             	lea    0x1(%edi),%ebx
        i *= -1;
8010213a:	f7 d9                	neg    %ecx
    }
    int shifter = i;
8010213c:	89 ca                	mov    %ecx,%edx
    do{ //Move to where representation ends
        ++p;
        shifter = shifter/10;
8010213e:	be cd cc cc cc       	mov    $0xcccccccd,%esi
80102143:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102147:	90                   	nop
80102148:	89 d0                	mov    %edx,%eax
        ++p;
8010214a:	83 c3 01             	add    $0x1,%ebx
        shifter = shifter/10;
8010214d:	f7 e6                	mul    %esi
    }while(shifter);
8010214f:	c1 ea 03             	shr    $0x3,%edx
80102152:	75 f4                	jne    80102148 <itoa+0x48>
    *p = '\0';
80102154:	c6 03 00             	movb   $0x0,(%ebx)
    do{ //Move back, inserting digits as u go
        *--p = digit[i%10];
80102157:	be cd cc cc cc       	mov    $0xcccccccd,%esi
8010215c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102160:	89 c8                	mov    %ecx,%eax
80102162:	83 eb 01             	sub    $0x1,%ebx
80102165:	f7 e6                	mul    %esi
80102167:	c1 ea 03             	shr    $0x3,%edx
8010216a:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010216d:	01 c0                	add    %eax,%eax
8010216f:	29 c1                	sub    %eax,%ecx
80102171:	0f b6 44 0d e9       	movzbl -0x17(%ebp,%ecx,1),%eax
        i = i/10;
80102176:	89 d1                	mov    %edx,%ecx
        *--p = digit[i%10];
80102178:	88 03                	mov    %al,(%ebx)
    }while(i);
8010217a:	85 d2                	test   %edx,%edx
8010217c:	75 e2                	jne    80102160 <itoa+0x60>
    return b;
}
8010217e:	83 c4 10             	add    $0x10,%esp
80102181:	89 f8                	mov    %edi,%eax
80102183:	5b                   	pop    %ebx
80102184:	5e                   	pop    %esi
80102185:	5f                   	pop    %edi
80102186:	5d                   	pop    %ebp
80102187:	c3                   	ret    
80102188:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010218f:	90                   	nop

80102190 <removeSwapFile>:
//remove swap file of proc p;
int
removeSwapFile(struct proc* p)
{
80102190:	f3 0f 1e fb          	endbr32 
80102194:	55                   	push   %ebp
80102195:	89 e5                	mov    %esp,%ebp
80102197:	57                   	push   %edi
80102198:	56                   	push   %esi
  //path of proccess
  char path[DIGITS];
  memmove(path,"/.swap", 6);
80102199:	8d 75 bc             	lea    -0x44(%ebp),%esi
{
8010219c:	53                   	push   %ebx
8010219d:	83 ec 40             	sub    $0x40,%esp
801021a0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
801021a3:	6a 06                	push   $0x6
801021a5:	68 b5 81 10 80       	push   $0x801081b5
801021aa:	56                   	push   %esi
801021ab:	e8 c0 2a 00 00       	call   80104c70 <memmove>
  itoa(p->pid, path+ 6);
801021b0:	58                   	pop    %eax
801021b1:	8d 45 c2             	lea    -0x3e(%ebp),%eax
801021b4:	5a                   	pop    %edx
801021b5:	50                   	push   %eax
801021b6:	ff 73 10             	pushl  0x10(%ebx)
801021b9:	e8 42 ff ff ff       	call   80102100 <itoa>
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ];
  uint off;

  if(0 == p->swapFile)
801021be:	8b 43 7c             	mov    0x7c(%ebx),%eax
801021c1:	83 c4 10             	add    $0x10,%esp
801021c4:	85 c0                	test   %eax,%eax
801021c6:	0f 84 7a 01 00 00    	je     80102346 <removeSwapFile+0x1b6>
  {
    return -1;
  }
  fileclose(p->swapFile);
801021cc:	83 ec 0c             	sub    $0xc,%esp
  return namex(path, 1, name);
801021cf:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  fileclose(p->swapFile);
801021d2:	50                   	push   %eax
801021d3:	e8 78 ed ff ff       	call   80100f50 <fileclose>

  begin_op();
801021d8:	e8 f3 0f 00 00       	call   801031d0 <begin_op>
  return namex(path, 1, name);
801021dd:	89 f0                	mov    %esi,%eax
801021df:	89 d9                	mov    %ebx,%ecx
801021e1:	ba 01 00 00 00       	mov    $0x1,%edx
801021e6:	e8 15 fc ff ff       	call   80101e00 <namex>
  if((dp = nameiparent(path, name)) == 0)
801021eb:	83 c4 10             	add    $0x10,%esp
  return namex(path, 1, name);
801021ee:	89 c6                	mov    %eax,%esi
  if((dp = nameiparent(path, name)) == 0)
801021f0:	85 c0                	test   %eax,%eax
801021f2:	0f 84 55 01 00 00    	je     8010234d <removeSwapFile+0x1bd>
  {
    end_op();
    return -1;
  }

  ilock(dp);
801021f8:	83 ec 0c             	sub    $0xc,%esp
801021fb:	50                   	push   %eax
801021fc:	e8 ef f5 ff ff       	call   801017f0 <ilock>
  return strncmp(s, t, DIRSIZ);
80102201:	83 c4 0c             	add    $0xc,%esp
80102204:	6a 0e                	push   $0xe
80102206:	68 bd 81 10 80       	push   $0x801081bd
8010220b:	53                   	push   %ebx
8010220c:	e8 cf 2a 00 00       	call   80104ce0 <strncmp>

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80102211:	83 c4 10             	add    $0x10,%esp
80102214:	85 c0                	test   %eax,%eax
80102216:	0f 84 f4 00 00 00    	je     80102310 <removeSwapFile+0x180>
  return strncmp(s, t, DIRSIZ);
8010221c:	83 ec 04             	sub    $0x4,%esp
8010221f:	6a 0e                	push   $0xe
80102221:	68 bc 81 10 80       	push   $0x801081bc
80102226:	53                   	push   %ebx
80102227:	e8 b4 2a 00 00       	call   80104ce0 <strncmp>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010222c:	83 c4 10             	add    $0x10,%esp
8010222f:	85 c0                	test   %eax,%eax
80102231:	0f 84 d9 00 00 00    	je     80102310 <removeSwapFile+0x180>
     goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80102237:	83 ec 04             	sub    $0x4,%esp
8010223a:	8d 45 b8             	lea    -0x48(%ebp),%eax
8010223d:	50                   	push   %eax
8010223e:	53                   	push   %ebx
8010223f:	56                   	push   %esi
80102240:	e8 fb fa ff ff       	call   80101d40 <dirlookup>
80102245:	83 c4 10             	add    $0x10,%esp
80102248:	89 c3                	mov    %eax,%ebx
8010224a:	85 c0                	test   %eax,%eax
8010224c:	0f 84 be 00 00 00    	je     80102310 <removeSwapFile+0x180>
    goto bad;
  ilock(ip);
80102252:	83 ec 0c             	sub    $0xc,%esp
80102255:	50                   	push   %eax
80102256:	e8 95 f5 ff ff       	call   801017f0 <ilock>

  if(ip->nlink < 1)
8010225b:	83 c4 10             	add    $0x10,%esp
8010225e:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80102263:	0f 8e 00 01 00 00    	jle    80102369 <removeSwapFile+0x1d9>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80102269:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010226e:	74 78                	je     801022e8 <removeSwapFile+0x158>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80102270:	83 ec 04             	sub    $0x4,%esp
80102273:	8d 7d d8             	lea    -0x28(%ebp),%edi
80102276:	6a 10                	push   $0x10
80102278:	6a 00                	push   $0x0
8010227a:	57                   	push   %edi
8010227b:	e8 50 29 00 00       	call   80104bd0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102280:	6a 10                	push   $0x10
80102282:	ff 75 b8             	pushl  -0x48(%ebp)
80102285:	57                   	push   %edi
80102286:	56                   	push   %esi
80102287:	e8 64 f9 ff ff       	call   80101bf0 <writei>
8010228c:	83 c4 20             	add    $0x20,%esp
8010228f:	83 f8 10             	cmp    $0x10,%eax
80102292:	0f 85 c4 00 00 00    	jne    8010235c <removeSwapFile+0x1cc>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80102298:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010229d:	0f 84 8d 00 00 00    	je     80102330 <removeSwapFile+0x1a0>
  iunlock(ip);
801022a3:	83 ec 0c             	sub    $0xc,%esp
801022a6:	56                   	push   %esi
801022a7:	e8 24 f6 ff ff       	call   801018d0 <iunlock>
  iput(ip);
801022ac:	89 34 24             	mov    %esi,(%esp)
801022af:	e8 6c f6 ff ff       	call   80101920 <iput>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);

  ip->nlink--;
801022b4:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801022b9:	89 1c 24             	mov    %ebx,(%esp)
801022bc:	e8 6f f4 ff ff       	call   80101730 <iupdate>
  iunlock(ip);
801022c1:	89 1c 24             	mov    %ebx,(%esp)
801022c4:	e8 07 f6 ff ff       	call   801018d0 <iunlock>
  iput(ip);
801022c9:	89 1c 24             	mov    %ebx,(%esp)
801022cc:	e8 4f f6 ff ff       	call   80101920 <iput>
  iunlockput(ip);

  end_op();
801022d1:	e8 6a 0f 00 00       	call   80103240 <end_op>

  return 0;
801022d6:	83 c4 10             	add    $0x10,%esp
801022d9:	31 c0                	xor    %eax,%eax
  bad:
    iunlockput(dp);
    end_op();
    return -1;

}
801022db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022de:	5b                   	pop    %ebx
801022df:	5e                   	pop    %esi
801022e0:	5f                   	pop    %edi
801022e1:	5d                   	pop    %ebp
801022e2:	c3                   	ret    
801022e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022e7:	90                   	nop
  if(ip->type == T_DIR && !isdirempty(ip)){
801022e8:	83 ec 0c             	sub    $0xc,%esp
801022eb:	53                   	push   %ebx
801022ec:	e8 af 30 00 00       	call   801053a0 <isdirempty>
801022f1:	83 c4 10             	add    $0x10,%esp
801022f4:	85 c0                	test   %eax,%eax
801022f6:	0f 85 74 ff ff ff    	jne    80102270 <removeSwapFile+0xe0>
  iunlock(ip);
801022fc:	83 ec 0c             	sub    $0xc,%esp
801022ff:	53                   	push   %ebx
80102300:	e8 cb f5 ff ff       	call   801018d0 <iunlock>
  iput(ip);
80102305:	89 1c 24             	mov    %ebx,(%esp)
80102308:	e8 13 f6 ff ff       	call   80101920 <iput>
    goto bad;
8010230d:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80102310:	83 ec 0c             	sub    $0xc,%esp
80102313:	56                   	push   %esi
80102314:	e8 b7 f5 ff ff       	call   801018d0 <iunlock>
  iput(ip);
80102319:	89 34 24             	mov    %esi,(%esp)
8010231c:	e8 ff f5 ff ff       	call   80101920 <iput>
    end_op();
80102321:	e8 1a 0f 00 00       	call   80103240 <end_op>
    return -1;
80102326:	83 c4 10             	add    $0x10,%esp
80102329:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010232e:	eb ab                	jmp    801022db <removeSwapFile+0x14b>
    iupdate(dp);
80102330:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80102333:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80102338:	56                   	push   %esi
80102339:	e8 f2 f3 ff ff       	call   80101730 <iupdate>
8010233e:	83 c4 10             	add    $0x10,%esp
80102341:	e9 5d ff ff ff       	jmp    801022a3 <removeSwapFile+0x113>
    return -1;
80102346:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010234b:	eb 8e                	jmp    801022db <removeSwapFile+0x14b>
    end_op();
8010234d:	e8 ee 0e 00 00       	call   80103240 <end_op>
    return -1;
80102352:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102357:	e9 7f ff ff ff       	jmp    801022db <removeSwapFile+0x14b>
    panic("unlink: writei");
8010235c:	83 ec 0c             	sub    $0xc,%esp
8010235f:	68 d1 81 10 80       	push   $0x801081d1
80102364:	e8 27 e0 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80102369:	83 ec 0c             	sub    $0xc,%esp
8010236c:	68 bf 81 10 80       	push   $0x801081bf
80102371:	e8 1a e0 ff ff       	call   80100390 <panic>
80102376:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010237d:	8d 76 00             	lea    0x0(%esi),%esi

80102380 <createSwapFile>:


//return 0 on success
int
createSwapFile(struct proc* p)
{
80102380:	f3 0f 1e fb          	endbr32 
80102384:	55                   	push   %ebp
80102385:	89 e5                	mov    %esp,%ebp
80102387:	56                   	push   %esi
80102388:	53                   	push   %ebx

  char path[DIGITS];
  memmove(path,"/.swap", 6);
80102389:	8d 75 ea             	lea    -0x16(%ebp),%esi
{
8010238c:	83 ec 14             	sub    $0x14,%esp
8010238f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
80102392:	6a 06                	push   $0x6
80102394:	68 b5 81 10 80       	push   $0x801081b5
80102399:	56                   	push   %esi
8010239a:	e8 d1 28 00 00       	call   80104c70 <memmove>
  itoa(p->pid, path+ 6);
8010239f:	58                   	pop    %eax
801023a0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801023a3:	5a                   	pop    %edx
801023a4:	50                   	push   %eax
801023a5:	ff 73 10             	pushl  0x10(%ebx)
801023a8:	e8 53 fd ff ff       	call   80102100 <itoa>

    begin_op();
801023ad:	e8 1e 0e 00 00       	call   801031d0 <begin_op>
    struct inode * in = create(path, T_FILE, 0, 0);
801023b2:	6a 00                	push   $0x0
801023b4:	6a 00                	push   $0x0
801023b6:	6a 02                	push   $0x2
801023b8:	56                   	push   %esi
801023b9:	e8 02 32 00 00       	call   801055c0 <create>
  iunlock(in);
801023be:	83 c4 14             	add    $0x14,%esp
801023c1:	50                   	push   %eax
    struct inode * in = create(path, T_FILE, 0, 0);
801023c2:	89 c6                	mov    %eax,%esi
  iunlock(in);
801023c4:	e8 07 f5 ff ff       	call   801018d0 <iunlock>

  p->swapFile = filealloc();
801023c9:	e8 c2 ea ff ff       	call   80100e90 <filealloc>
  if (p->swapFile == 0)
801023ce:	83 c4 10             	add    $0x10,%esp
  p->swapFile = filealloc();
801023d1:	89 43 7c             	mov    %eax,0x7c(%ebx)
  if (p->swapFile == 0)
801023d4:	85 c0                	test   %eax,%eax
801023d6:	74 32                	je     8010240a <createSwapFile+0x8a>
    panic("no slot for files on /store");

  p->swapFile->ip = in;
801023d8:	89 70 10             	mov    %esi,0x10(%eax)
  p->swapFile->type = FD_INODE;
801023db:	8b 43 7c             	mov    0x7c(%ebx),%eax
801023de:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  p->swapFile->off = 0;
801023e4:	8b 43 7c             	mov    0x7c(%ebx),%eax
801023e7:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  p->swapFile->readable = O_WRONLY;
801023ee:	8b 43 7c             	mov    0x7c(%ebx),%eax
801023f1:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  p->swapFile->writable = O_RDWR;
801023f5:	8b 43 7c             	mov    0x7c(%ebx),%eax
801023f8:	c6 40 09 02          	movb   $0x2,0x9(%eax)
    end_op();
801023fc:	e8 3f 0e 00 00       	call   80103240 <end_op>

    return 0;
}
80102401:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102404:	31 c0                	xor    %eax,%eax
80102406:	5b                   	pop    %ebx
80102407:	5e                   	pop    %esi
80102408:	5d                   	pop    %ebp
80102409:	c3                   	ret    
    panic("no slot for files on /store");
8010240a:	83 ec 0c             	sub    $0xc,%esp
8010240d:	68 e0 81 10 80       	push   $0x801081e0
80102412:	e8 79 df ff ff       	call   80100390 <panic>
80102417:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010241e:	66 90                	xchg   %ax,%ax

80102420 <writeToSwapFile>:

//return as sys_write (-1 when error)
int
writeToSwapFile(struct proc* p, char* buffer, uint placeOnFile, uint size)
{
80102420:	f3 0f 1e fb          	endbr32 
80102424:	55                   	push   %ebp
80102425:	89 e5                	mov    %esp,%ebp
80102427:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
8010242a:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010242d:	8b 50 7c             	mov    0x7c(%eax),%edx
80102430:	89 4a 14             	mov    %ecx,0x14(%edx)

  return filewrite(p->swapFile, buffer, size);
80102433:	8b 55 14             	mov    0x14(%ebp),%edx
80102436:	89 55 10             	mov    %edx,0x10(%ebp)
80102439:	8b 40 7c             	mov    0x7c(%eax),%eax
8010243c:	89 45 08             	mov    %eax,0x8(%ebp)

}
8010243f:	5d                   	pop    %ebp
  return filewrite(p->swapFile, buffer, size);
80102440:	e9 db ec ff ff       	jmp    80101120 <filewrite>
80102445:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010244c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102450 <readFromSwapFile>:

//return as sys_read (-1 when error)
int
readFromSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
80102450:	f3 0f 1e fb          	endbr32 
80102454:	55                   	push   %ebp
80102455:	89 e5                	mov    %esp,%ebp
80102457:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
8010245a:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010245d:	8b 50 7c             	mov    0x7c(%eax),%edx
80102460:	89 4a 14             	mov    %ecx,0x14(%edx)

  return fileread(p->swapFile, buffer,  size);
80102463:	8b 55 14             	mov    0x14(%ebp),%edx
80102466:	89 55 10             	mov    %edx,0x10(%ebp)
80102469:	8b 40 7c             	mov    0x7c(%eax),%eax
8010246c:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010246f:	5d                   	pop    %ebp
  return fileread(p->swapFile, buffer,  size);
80102470:	e9 0b ec ff ff       	jmp    80101080 <fileread>
80102475:	66 90                	xchg   %ax,%ax
80102477:	66 90                	xchg   %ax,%ax
80102479:	66 90                	xchg   %ax,%ax
8010247b:	66 90                	xchg   %ax,%ax
8010247d:	66 90                	xchg   %ax,%ax
8010247f:	90                   	nop

80102480 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102480:	55                   	push   %ebp
80102481:	89 e5                	mov    %esp,%ebp
80102483:	57                   	push   %edi
80102484:	56                   	push   %esi
80102485:	53                   	push   %ebx
80102486:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102489:	85 c0                	test   %eax,%eax
8010248b:	0f 84 b4 00 00 00    	je     80102545 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102491:	8b 70 08             	mov    0x8(%eax),%esi
80102494:	89 c3                	mov    %eax,%ebx
80102496:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010249c:	0f 87 96 00 00 00    	ja     80102538 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024a2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801024a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801024ae:	66 90                	xchg   %ax,%ax
801024b0:	89 ca                	mov    %ecx,%edx
801024b2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801024b3:	83 e0 c0             	and    $0xffffffc0,%eax
801024b6:	3c 40                	cmp    $0x40,%al
801024b8:	75 f6                	jne    801024b0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801024ba:	31 ff                	xor    %edi,%edi
801024bc:	ba f6 03 00 00       	mov    $0x3f6,%edx
801024c1:	89 f8                	mov    %edi,%eax
801024c3:	ee                   	out    %al,(%dx)
801024c4:	b8 01 00 00 00       	mov    $0x1,%eax
801024c9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801024ce:	ee                   	out    %al,(%dx)
801024cf:	ba f3 01 00 00       	mov    $0x1f3,%edx
801024d4:	89 f0                	mov    %esi,%eax
801024d6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801024d7:	89 f0                	mov    %esi,%eax
801024d9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801024de:	c1 f8 08             	sar    $0x8,%eax
801024e1:	ee                   	out    %al,(%dx)
801024e2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801024e7:	89 f8                	mov    %edi,%eax
801024e9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801024ea:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801024ee:	ba f6 01 00 00       	mov    $0x1f6,%edx
801024f3:	c1 e0 04             	shl    $0x4,%eax
801024f6:	83 e0 10             	and    $0x10,%eax
801024f9:	83 c8 e0             	or     $0xffffffe0,%eax
801024fc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801024fd:	f6 03 04             	testb  $0x4,(%ebx)
80102500:	75 16                	jne    80102518 <idestart+0x98>
80102502:	b8 20 00 00 00       	mov    $0x20,%eax
80102507:	89 ca                	mov    %ecx,%edx
80102509:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010250a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010250d:	5b                   	pop    %ebx
8010250e:	5e                   	pop    %esi
8010250f:	5f                   	pop    %edi
80102510:	5d                   	pop    %ebp
80102511:	c3                   	ret    
80102512:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102518:	b8 30 00 00 00       	mov    $0x30,%eax
8010251d:	89 ca                	mov    %ecx,%edx
8010251f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102520:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102525:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102528:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010252d:	fc                   	cld    
8010252e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102530:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102533:	5b                   	pop    %ebx
80102534:	5e                   	pop    %esi
80102535:	5f                   	pop    %edi
80102536:	5d                   	pop    %ebp
80102537:	c3                   	ret    
    panic("incorrect blockno");
80102538:	83 ec 0c             	sub    $0xc,%esp
8010253b:	68 58 82 10 80       	push   $0x80108258
80102540:	e8 4b de ff ff       	call   80100390 <panic>
    panic("idestart");
80102545:	83 ec 0c             	sub    $0xc,%esp
80102548:	68 4f 82 10 80       	push   $0x8010824f
8010254d:	e8 3e de ff ff       	call   80100390 <panic>
80102552:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102560 <ideinit>:
{
80102560:	f3 0f 1e fb          	endbr32 
80102564:	55                   	push   %ebp
80102565:	89 e5                	mov    %esp,%ebp
80102567:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
8010256a:	68 6a 82 10 80       	push   $0x8010826a
8010256f:	68 80 b5 10 80       	push   $0x8010b580
80102574:	e8 c7 23 00 00       	call   80104940 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102579:	58                   	pop    %eax
8010257a:	a1 80 1d 12 80       	mov    0x80121d80,%eax
8010257f:	5a                   	pop    %edx
80102580:	83 e8 01             	sub    $0x1,%eax
80102583:	50                   	push   %eax
80102584:	6a 0e                	push   $0xe
80102586:	e8 b5 02 00 00       	call   80102840 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
8010258b:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010258e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102593:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102597:	90                   	nop
80102598:	ec                   	in     (%dx),%al
80102599:	83 e0 c0             	and    $0xffffffc0,%eax
8010259c:	3c 40                	cmp    $0x40,%al
8010259e:	75 f8                	jne    80102598 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025a0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801025a5:	ba f6 01 00 00       	mov    $0x1f6,%edx
801025aa:	ee                   	out    %al,(%dx)
801025ab:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025b0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801025b5:	eb 0e                	jmp    801025c5 <ideinit+0x65>
801025b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025be:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
801025c0:	83 e9 01             	sub    $0x1,%ecx
801025c3:	74 0f                	je     801025d4 <ideinit+0x74>
801025c5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801025c6:	84 c0                	test   %al,%al
801025c8:	74 f6                	je     801025c0 <ideinit+0x60>
      havedisk1 = 1;
801025ca:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
801025d1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025d4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801025d9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801025de:	ee                   	out    %al,(%dx)
}
801025df:	c9                   	leave  
801025e0:	c3                   	ret    
801025e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025ef:	90                   	nop

801025f0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801025f0:	f3 0f 1e fb          	endbr32 
801025f4:	55                   	push   %ebp
801025f5:	89 e5                	mov    %esp,%ebp
801025f7:	57                   	push   %edi
801025f8:	56                   	push   %esi
801025f9:	53                   	push   %ebx
801025fa:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801025fd:	68 80 b5 10 80       	push   $0x8010b580
80102602:	e8 b9 24 00 00       	call   80104ac0 <acquire>

  if((b = idequeue) == 0){
80102607:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
8010260d:	83 c4 10             	add    $0x10,%esp
80102610:	85 db                	test   %ebx,%ebx
80102612:	74 5f                	je     80102673 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102614:	8b 43 58             	mov    0x58(%ebx),%eax
80102617:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010261c:	8b 33                	mov    (%ebx),%esi
8010261e:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102624:	75 2b                	jne    80102651 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102626:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010262b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010262f:	90                   	nop
80102630:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102631:	89 c1                	mov    %eax,%ecx
80102633:	83 e1 c0             	and    $0xffffffc0,%ecx
80102636:	80 f9 40             	cmp    $0x40,%cl
80102639:	75 f5                	jne    80102630 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010263b:	a8 21                	test   $0x21,%al
8010263d:	75 12                	jne    80102651 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010263f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102642:	b9 80 00 00 00       	mov    $0x80,%ecx
80102647:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010264c:	fc                   	cld    
8010264d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010264f:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102651:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102654:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102657:	83 ce 02             	or     $0x2,%esi
8010265a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010265c:	53                   	push   %ebx
8010265d:	e8 ae 1f 00 00       	call   80104610 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102662:	a1 64 b5 10 80       	mov    0x8010b564,%eax
80102667:	83 c4 10             	add    $0x10,%esp
8010266a:	85 c0                	test   %eax,%eax
8010266c:	74 05                	je     80102673 <ideintr+0x83>
    idestart(idequeue);
8010266e:	e8 0d fe ff ff       	call   80102480 <idestart>
    release(&idelock);
80102673:	83 ec 0c             	sub    $0xc,%esp
80102676:	68 80 b5 10 80       	push   $0x8010b580
8010267b:	e8 00 25 00 00       	call   80104b80 <release>

  release(&idelock);
}
80102680:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102683:	5b                   	pop    %ebx
80102684:	5e                   	pop    %esi
80102685:	5f                   	pop    %edi
80102686:	5d                   	pop    %ebp
80102687:	c3                   	ret    
80102688:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010268f:	90                   	nop

80102690 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102690:	f3 0f 1e fb          	endbr32 
80102694:	55                   	push   %ebp
80102695:	89 e5                	mov    %esp,%ebp
80102697:	53                   	push   %ebx
80102698:	83 ec 10             	sub    $0x10,%esp
8010269b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010269e:	8d 43 0c             	lea    0xc(%ebx),%eax
801026a1:	50                   	push   %eax
801026a2:	e8 39 22 00 00       	call   801048e0 <holdingsleep>
801026a7:	83 c4 10             	add    $0x10,%esp
801026aa:	85 c0                	test   %eax,%eax
801026ac:	0f 84 cf 00 00 00    	je     80102781 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801026b2:	8b 03                	mov    (%ebx),%eax
801026b4:	83 e0 06             	and    $0x6,%eax
801026b7:	83 f8 02             	cmp    $0x2,%eax
801026ba:	0f 84 b4 00 00 00    	je     80102774 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801026c0:	8b 53 04             	mov    0x4(%ebx),%edx
801026c3:	85 d2                	test   %edx,%edx
801026c5:	74 0d                	je     801026d4 <iderw+0x44>
801026c7:	a1 60 b5 10 80       	mov    0x8010b560,%eax
801026cc:	85 c0                	test   %eax,%eax
801026ce:	0f 84 93 00 00 00    	je     80102767 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801026d4:	83 ec 0c             	sub    $0xc,%esp
801026d7:	68 80 b5 10 80       	push   $0x8010b580
801026dc:	e8 df 23 00 00       	call   80104ac0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801026e1:	a1 64 b5 10 80       	mov    0x8010b564,%eax
  b->qnext = 0;
801026e6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801026ed:	83 c4 10             	add    $0x10,%esp
801026f0:	85 c0                	test   %eax,%eax
801026f2:	74 6c                	je     80102760 <iderw+0xd0>
801026f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801026f8:	89 c2                	mov    %eax,%edx
801026fa:	8b 40 58             	mov    0x58(%eax),%eax
801026fd:	85 c0                	test   %eax,%eax
801026ff:	75 f7                	jne    801026f8 <iderw+0x68>
80102701:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102704:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102706:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
8010270c:	74 42                	je     80102750 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010270e:	8b 03                	mov    (%ebx),%eax
80102710:	83 e0 06             	and    $0x6,%eax
80102713:	83 f8 02             	cmp    $0x2,%eax
80102716:	74 23                	je     8010273b <iderw+0xab>
80102718:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010271f:	90                   	nop
    sleep(b, &idelock);
80102720:	83 ec 08             	sub    $0x8,%esp
80102723:	68 80 b5 10 80       	push   $0x8010b580
80102728:	53                   	push   %ebx
80102729:	e8 22 1d 00 00       	call   80104450 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010272e:	8b 03                	mov    (%ebx),%eax
80102730:	83 c4 10             	add    $0x10,%esp
80102733:	83 e0 06             	and    $0x6,%eax
80102736:	83 f8 02             	cmp    $0x2,%eax
80102739:	75 e5                	jne    80102720 <iderw+0x90>
  }


  release(&idelock);
8010273b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102742:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102745:	c9                   	leave  
  release(&idelock);
80102746:	e9 35 24 00 00       	jmp    80104b80 <release>
8010274b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010274f:	90                   	nop
    idestart(b);
80102750:	89 d8                	mov    %ebx,%eax
80102752:	e8 29 fd ff ff       	call   80102480 <idestart>
80102757:	eb b5                	jmp    8010270e <iderw+0x7e>
80102759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102760:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102765:	eb 9d                	jmp    80102704 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102767:	83 ec 0c             	sub    $0xc,%esp
8010276a:	68 99 82 10 80       	push   $0x80108299
8010276f:	e8 1c dc ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102774:	83 ec 0c             	sub    $0xc,%esp
80102777:	68 84 82 10 80       	push   $0x80108284
8010277c:	e8 0f dc ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102781:	83 ec 0c             	sub    $0xc,%esp
80102784:	68 6e 82 10 80       	push   $0x8010826e
80102789:	e8 02 dc ff ff       	call   80100390 <panic>
8010278e:	66 90                	xchg   %ax,%ax

80102790 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102790:	f3 0f 1e fb          	endbr32 
80102794:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102795:	c7 05 74 16 12 80 00 	movl   $0xfec00000,0x80121674
8010279c:	00 c0 fe 
{
8010279f:	89 e5                	mov    %esp,%ebp
801027a1:	56                   	push   %esi
801027a2:	53                   	push   %ebx
  ioapic->reg = reg;
801027a3:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801027aa:	00 00 00 
  return ioapic->data;
801027ad:	8b 15 74 16 12 80    	mov    0x80121674,%edx
801027b3:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801027b6:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801027bc:	8b 0d 74 16 12 80    	mov    0x80121674,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801027c2:	0f b6 15 e0 17 12 80 	movzbl 0x801217e0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801027c9:	c1 ee 10             	shr    $0x10,%esi
801027cc:	89 f0                	mov    %esi,%eax
801027ce:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801027d1:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
801027d4:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801027d7:	39 c2                	cmp    %eax,%edx
801027d9:	74 16                	je     801027f1 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801027db:	83 ec 0c             	sub    $0xc,%esp
801027de:	68 b8 82 10 80       	push   $0x801082b8
801027e3:	e8 c8 de ff ff       	call   801006b0 <cprintf>
801027e8:	8b 0d 74 16 12 80    	mov    0x80121674,%ecx
801027ee:	83 c4 10             	add    $0x10,%esp
801027f1:	83 c6 21             	add    $0x21,%esi
{
801027f4:	ba 10 00 00 00       	mov    $0x10,%edx
801027f9:	b8 20 00 00 00       	mov    $0x20,%eax
801027fe:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
80102800:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102802:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102804:	8b 0d 74 16 12 80    	mov    0x80121674,%ecx
8010280a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010280d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102813:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102816:	8d 5a 01             	lea    0x1(%edx),%ebx
80102819:	83 c2 02             	add    $0x2,%edx
8010281c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010281e:	8b 0d 74 16 12 80    	mov    0x80121674,%ecx
80102824:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010282b:	39 f0                	cmp    %esi,%eax
8010282d:	75 d1                	jne    80102800 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010282f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102832:	5b                   	pop    %ebx
80102833:	5e                   	pop    %esi
80102834:	5d                   	pop    %ebp
80102835:	c3                   	ret    
80102836:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010283d:	8d 76 00             	lea    0x0(%esi),%esi

80102840 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102840:	f3 0f 1e fb          	endbr32 
80102844:	55                   	push   %ebp
  ioapic->reg = reg;
80102845:	8b 0d 74 16 12 80    	mov    0x80121674,%ecx
{
8010284b:	89 e5                	mov    %esp,%ebp
8010284d:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102850:	8d 50 20             	lea    0x20(%eax),%edx
80102853:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102857:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102859:	8b 0d 74 16 12 80    	mov    0x80121674,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010285f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102862:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102865:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102868:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010286a:	a1 74 16 12 80       	mov    0x80121674,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010286f:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102872:	89 50 10             	mov    %edx,0x10(%eax)
}
80102875:	5d                   	pop    %ebp
80102876:	c3                   	ret    
80102877:	66 90                	xchg   %ax,%ax
80102879:	66 90                	xchg   %ax,%ax
8010287b:	66 90                	xchg   %ax,%ax
8010287d:	66 90                	xchg   %ax,%ax
8010287f:	90                   	nop

80102880 <init_cow>:



struct spinlock r_cow_lock;

void init_cow(){
80102880:	f3 0f 1e fb          	endbr32 
80102884:	55                   	push   %ebp
80102885:	89 e5                	mov    %esp,%ebp
80102887:	83 ec 14             	sub    $0x14,%esp
  cprintf("initing cow\n");
8010288a:	68 ea 82 10 80       	push   $0x801082ea
8010288f:	e8 1c de ff ff       	call   801006b0 <cprintf>
  memset((void*)pg_ref_counts, 0, sizeof(pg_ref_counts));
80102894:	83 c4 0c             	add    $0xc,%esp
80102897:	68 00 e0 00 00       	push   $0xe000
8010289c:	6a 00                	push   $0x0
8010289e:	68 40 0f 11 80       	push   $0x80110f40
801028a3:	e8 28 23 00 00       	call   80104bd0 <memset>
  initlock(&r_cow_lock, "cow lock");
801028a8:	58                   	pop    %eax
801028a9:	5a                   	pop    %edx
801028aa:	68 f7 82 10 80       	push   $0x801082f7
801028af:	68 c0 16 12 80       	push   $0x801216c0
801028b4:	e8 87 20 00 00       	call   80104940 <initlock>
  cow_lock = &r_cow_lock;
  cprintf("initing cow end\n");
801028b9:	c7 04 24 00 83 10 80 	movl   $0x80108300,(%esp)
  cow_lock = &r_cow_lock;
801028c0:	c7 05 40 ef 11 80 c0 	movl   $0x801216c0,0x8011ef40
801028c7:	16 12 80 
  cprintf("initing cow end\n");
801028ca:	e8 e1 dd ff ff       	call   801006b0 <cprintf>
}
801028cf:	83 c4 10             	add    $0x10,%esp
801028d2:	c9                   	leave  
801028d3:	c3                   	ret    
801028d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028df:	90                   	nop

801028e0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801028e0:	f3 0f 1e fb          	endbr32 
801028e4:	55                   	push   %ebp
801028e5:	89 e5                	mov    %esp,%ebp
801028e7:	53                   	push   %ebx
801028e8:	83 ec 04             	sub    $0x4,%esp
801028eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801028ee:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801028f4:	75 7a                	jne    80102970 <kfree+0x90>
801028f6:	81 fb 28 0a 13 80    	cmp    $0x80130a28,%ebx
801028fc:	72 72                	jb     80102970 <kfree+0x90>
801028fe:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102904:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102909:	77 65                	ja     80102970 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
8010290b:	83 ec 04             	sub    $0x4,%esp
8010290e:	68 00 10 00 00       	push   $0x1000
80102913:	6a 01                	push   $0x1
80102915:	53                   	push   %ebx
80102916:	e8 b5 22 00 00       	call   80104bd0 <memset>

  if(kmem.use_lock)
8010291b:	8b 15 b4 16 12 80    	mov    0x801216b4,%edx
80102921:	83 c4 10             	add    $0x10,%esp
80102924:	85 d2                	test   %edx,%edx
80102926:	75 20                	jne    80102948 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102928:	a1 b8 16 12 80       	mov    0x801216b8,%eax
8010292d:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010292f:	a1 b4 16 12 80       	mov    0x801216b4,%eax
  kmem.freelist = r;
80102934:	89 1d b8 16 12 80    	mov    %ebx,0x801216b8
  if(kmem.use_lock)
8010293a:	85 c0                	test   %eax,%eax
8010293c:	75 22                	jne    80102960 <kfree+0x80>
    release(&kmem.lock);
}
8010293e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102941:	c9                   	leave  
80102942:	c3                   	ret    
80102943:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102947:	90                   	nop
    acquire(&kmem.lock);
80102948:	83 ec 0c             	sub    $0xc,%esp
8010294b:	68 80 16 12 80       	push   $0x80121680
80102950:	e8 6b 21 00 00       	call   80104ac0 <acquire>
80102955:	83 c4 10             	add    $0x10,%esp
80102958:	eb ce                	jmp    80102928 <kfree+0x48>
8010295a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102960:	c7 45 08 80 16 12 80 	movl   $0x80121680,0x8(%ebp)
}
80102967:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010296a:	c9                   	leave  
    release(&kmem.lock);
8010296b:	e9 10 22 00 00       	jmp    80104b80 <release>
    panic("kfree");
80102970:	83 ec 0c             	sub    $0xc,%esp
80102973:	68 cc 8a 10 80       	push   $0x80108acc
80102978:	e8 13 da ff ff       	call   80100390 <panic>
8010297d:	8d 76 00             	lea    0x0(%esi),%esi

80102980 <freerange>:
{
80102980:	f3 0f 1e fb          	endbr32 
80102984:	55                   	push   %ebp
80102985:	89 e5                	mov    %esp,%ebp
80102987:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102988:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010298b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010298e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010298f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102995:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
8010299b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801029a1:	39 de                	cmp    %ebx,%esi
801029a3:	72 2f                	jb     801029d4 <freerange+0x54>
801029a5:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
801029a8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801029ae:	83 ec 0c             	sub    $0xc,%esp
801029b1:	50                   	push   %eax
801029b2:	e8 29 ff ff ff       	call   801028e0 <kfree>
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
801029b7:	8d 83 00 f0 ff 7f    	lea    0x7ffff000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801029bd:	83 c4 10             	add    $0x10,%esp
801029c0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
801029c6:	c1 e8 0c             	shr    $0xc,%eax
801029c9:	c6 80 40 0f 11 80 00 	movb   $0x0,-0x7feef0c0(%eax)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801029d0:	39 f3                	cmp    %esi,%ebx
801029d2:	76 d4                	jbe    801029a8 <freerange+0x28>
}
801029d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801029d7:	5b                   	pop    %ebx
801029d8:	5e                   	pop    %esi
801029d9:	5d                   	pop    %ebp
801029da:	c3                   	ret    
801029db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801029df:	90                   	nop

801029e0 <kinit1>:
{
801029e0:	f3 0f 1e fb          	endbr32 
801029e4:	55                   	push   %ebp
801029e5:	89 e5                	mov    %esp,%ebp
801029e7:	56                   	push   %esi
801029e8:	53                   	push   %ebx
801029e9:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801029ec:	83 ec 08             	sub    $0x8,%esp
801029ef:	68 11 83 10 80       	push   $0x80108311
801029f4:	68 80 16 12 80       	push   $0x80121680
801029f9:	e8 42 1f 00 00       	call   80104940 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801029fe:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102a01:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102a04:	c7 05 b4 16 12 80 00 	movl   $0x0,0x801216b4
80102a0b:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80102a0e:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102a14:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102a1a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102a20:	39 de                	cmp    %ebx,%esi
80102a22:	72 30                	jb     80102a54 <kinit1+0x74>
80102a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102a28:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102a2e:	83 ec 0c             	sub    $0xc,%esp
80102a31:	50                   	push   %eax
80102a32:	e8 a9 fe ff ff       	call   801028e0 <kfree>
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
80102a37:	8d 83 00 f0 ff 7f    	lea    0x7ffff000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102a3d:	83 c4 10             	add    $0x10,%esp
80102a40:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
80102a46:	c1 e8 0c             	shr    $0xc,%eax
80102a49:	c6 80 40 0f 11 80 00 	movb   $0x0,-0x7feef0c0(%eax)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102a50:	39 de                	cmp    %ebx,%esi
80102a52:	73 d4                	jae    80102a28 <kinit1+0x48>
}
80102a54:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102a57:	5b                   	pop    %ebx
80102a58:	5e                   	pop    %esi
80102a59:	5d                   	pop    %ebp
80102a5a:	c3                   	ret    
80102a5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a5f:	90                   	nop

80102a60 <kinit2>:
{
80102a60:	f3 0f 1e fb          	endbr32 
80102a64:	55                   	push   %ebp
80102a65:	89 e5                	mov    %esp,%ebp
80102a67:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102a68:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102a6b:	8b 75 0c             	mov    0xc(%ebp),%esi
80102a6e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102a6f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102a75:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102a7b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102a81:	39 de                	cmp    %ebx,%esi
80102a83:	72 2f                	jb     80102ab4 <kinit2+0x54>
80102a85:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102a88:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102a8e:	83 ec 0c             	sub    $0xc,%esp
80102a91:	50                   	push   %eax
80102a92:	e8 49 fe ff ff       	call   801028e0 <kfree>
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
80102a97:	8d 83 00 f0 ff 7f    	lea    0x7ffff000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102a9d:	83 c4 10             	add    $0x10,%esp
80102aa0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
80102aa6:	c1 e8 0c             	shr    $0xc,%eax
80102aa9:	c6 80 40 0f 11 80 00 	movb   $0x0,-0x7feef0c0(%eax)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102ab0:	39 de                	cmp    %ebx,%esi
80102ab2:	73 d4                	jae    80102a88 <kinit2+0x28>
  kmem.use_lock = 1;
80102ab4:	c7 05 b4 16 12 80 01 	movl   $0x1,0x801216b4
80102abb:	00 00 00 
}
80102abe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102ac1:	5b                   	pop    %ebx
80102ac2:	5e                   	pop    %esi
80102ac3:	5d                   	pop    %ebp
80102ac4:	c3                   	ret    
80102ac5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102ad0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102ad0:	f3 0f 1e fb          	endbr32 
  struct run *r;
  if(kmem.use_lock)
80102ad4:	a1 b4 16 12 80       	mov    0x801216b4,%eax
80102ad9:	85 c0                	test   %eax,%eax
80102adb:	75 1b                	jne    80102af8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102add:	a1 b8 16 12 80       	mov    0x801216b8,%eax
  if(r)
80102ae2:	85 c0                	test   %eax,%eax
80102ae4:	74 0a                	je     80102af0 <kalloc+0x20>
    kmem.freelist = r->next;
80102ae6:	8b 10                	mov    (%eax),%edx
80102ae8:	89 15 b8 16 12 80    	mov    %edx,0x801216b8
  if(kmem.use_lock)
80102aee:	c3                   	ret    
80102aef:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102af0:	c3                   	ret    
80102af1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102af8:	55                   	push   %ebp
80102af9:	89 e5                	mov    %esp,%ebp
80102afb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
80102afe:	68 80 16 12 80       	push   $0x80121680
80102b03:	e8 b8 1f 00 00       	call   80104ac0 <acquire>
  r = kmem.freelist;
80102b08:	a1 b8 16 12 80       	mov    0x801216b8,%eax
  if(r)
80102b0d:	8b 15 b4 16 12 80    	mov    0x801216b4,%edx
80102b13:	83 c4 10             	add    $0x10,%esp
80102b16:	85 c0                	test   %eax,%eax
80102b18:	74 08                	je     80102b22 <kalloc+0x52>
    kmem.freelist = r->next;
80102b1a:	8b 08                	mov    (%eax),%ecx
80102b1c:	89 0d b8 16 12 80    	mov    %ecx,0x801216b8
  if(kmem.use_lock)
80102b22:	85 d2                	test   %edx,%edx
80102b24:	74 16                	je     80102b3c <kalloc+0x6c>
    release(&kmem.lock);
80102b26:	83 ec 0c             	sub    $0xc,%esp
80102b29:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102b2c:	68 80 16 12 80       	push   $0x80121680
80102b31:	e8 4a 20 00 00       	call   80104b80 <release>
  return (char*)r;
80102b36:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102b39:	83 c4 10             	add    $0x10,%esp
}
80102b3c:	c9                   	leave  
80102b3d:	c3                   	ret    
80102b3e:	66 90                	xchg   %ax,%ax

80102b40 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102b40:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b44:	ba 64 00 00 00       	mov    $0x64,%edx
80102b49:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102b4a:	a8 01                	test   $0x1,%al
80102b4c:	0f 84 be 00 00 00    	je     80102c10 <kbdgetc+0xd0>
{
80102b52:	55                   	push   %ebp
80102b53:	ba 60 00 00 00       	mov    $0x60,%edx
80102b58:	89 e5                	mov    %esp,%ebp
80102b5a:	53                   	push   %ebx
80102b5b:	ec                   	in     (%dx),%al
  return data;
80102b5c:	8b 1d b4 b5 10 80    	mov    0x8010b5b4,%ebx
    return -1;
  data = inb(KBDATAP);
80102b62:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80102b65:	3c e0                	cmp    $0xe0,%al
80102b67:	74 57                	je     80102bc0 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102b69:	89 d9                	mov    %ebx,%ecx
80102b6b:	83 e1 40             	and    $0x40,%ecx
80102b6e:	84 c0                	test   %al,%al
80102b70:	78 5e                	js     80102bd0 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102b72:	85 c9                	test   %ecx,%ecx
80102b74:	74 09                	je     80102b7f <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102b76:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102b79:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102b7c:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102b7f:	0f b6 8a 40 84 10 80 	movzbl -0x7fef7bc0(%edx),%ecx
  shift ^= togglecode[data];
80102b86:	0f b6 82 40 83 10 80 	movzbl -0x7fef7cc0(%edx),%eax
  shift |= shiftcode[data];
80102b8d:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
80102b8f:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102b91:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102b93:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102b99:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102b9c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102b9f:	8b 04 85 20 83 10 80 	mov    -0x7fef7ce0(,%eax,4),%eax
80102ba6:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102baa:	74 0b                	je     80102bb7 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
80102bac:	8d 50 9f             	lea    -0x61(%eax),%edx
80102baf:	83 fa 19             	cmp    $0x19,%edx
80102bb2:	77 44                	ja     80102bf8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102bb4:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102bb7:	5b                   	pop    %ebx
80102bb8:	5d                   	pop    %ebp
80102bb9:	c3                   	ret    
80102bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102bc0:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102bc3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102bc5:	89 1d b4 b5 10 80    	mov    %ebx,0x8010b5b4
}
80102bcb:	5b                   	pop    %ebx
80102bcc:	5d                   	pop    %ebp
80102bcd:	c3                   	ret    
80102bce:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102bd0:	83 e0 7f             	and    $0x7f,%eax
80102bd3:	85 c9                	test   %ecx,%ecx
80102bd5:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102bd8:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102bda:	0f b6 8a 40 84 10 80 	movzbl -0x7fef7bc0(%edx),%ecx
80102be1:	83 c9 40             	or     $0x40,%ecx
80102be4:	0f b6 c9             	movzbl %cl,%ecx
80102be7:	f7 d1                	not    %ecx
80102be9:	21 d9                	and    %ebx,%ecx
}
80102beb:	5b                   	pop    %ebx
80102bec:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
80102bed:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
80102bf3:	c3                   	ret    
80102bf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102bf8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102bfb:	8d 50 20             	lea    0x20(%eax),%edx
}
80102bfe:	5b                   	pop    %ebx
80102bff:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102c00:	83 f9 1a             	cmp    $0x1a,%ecx
80102c03:	0f 42 c2             	cmovb  %edx,%eax
}
80102c06:	c3                   	ret    
80102c07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c0e:	66 90                	xchg   %ax,%ax
    return -1;
80102c10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102c15:	c3                   	ret    
80102c16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c1d:	8d 76 00             	lea    0x0(%esi),%esi

80102c20 <kbdintr>:

void
kbdintr(void)
{
80102c20:	f3 0f 1e fb          	endbr32 
80102c24:	55                   	push   %ebp
80102c25:	89 e5                	mov    %esp,%ebp
80102c27:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102c2a:	68 40 2b 10 80       	push   $0x80102b40
80102c2f:	e8 2c dc ff ff       	call   80100860 <consoleintr>
}
80102c34:	83 c4 10             	add    $0x10,%esp
80102c37:	c9                   	leave  
80102c38:	c3                   	ret    
80102c39:	66 90                	xchg   %ax,%ax
80102c3b:	66 90                	xchg   %ax,%ax
80102c3d:	66 90                	xchg   %ax,%ax
80102c3f:	90                   	nop

80102c40 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102c40:	f3 0f 1e fb          	endbr32 
  if(!lapic)
80102c44:	a1 f4 16 12 80       	mov    0x801216f4,%eax
80102c49:	85 c0                	test   %eax,%eax
80102c4b:	0f 84 c7 00 00 00    	je     80102d18 <lapicinit+0xd8>
  lapic[index] = value;
80102c51:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102c58:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c5b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c5e:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102c65:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c68:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c6b:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102c72:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102c75:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c78:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102c7f:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102c82:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c85:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102c8c:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102c8f:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c92:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102c99:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102c9c:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102c9f:	8b 50 30             	mov    0x30(%eax),%edx
80102ca2:	c1 ea 10             	shr    $0x10,%edx
80102ca5:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102cab:	75 73                	jne    80102d20 <lapicinit+0xe0>
  lapic[index] = value;
80102cad:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102cb4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102cb7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cba:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102cc1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102cc4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cc7:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102cce:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102cd1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cd4:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102cdb:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102cde:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ce1:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102ce8:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ceb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cee:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102cf5:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102cf8:	8b 50 20             	mov    0x20(%eax),%edx
80102cfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cff:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102d00:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102d06:	80 e6 10             	and    $0x10,%dh
80102d09:	75 f5                	jne    80102d00 <lapicinit+0xc0>
  lapic[index] = value;
80102d0b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102d12:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d15:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102d18:	c3                   	ret    
80102d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102d20:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102d27:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102d2a:	8b 50 20             	mov    0x20(%eax),%edx
}
80102d2d:	e9 7b ff ff ff       	jmp    80102cad <lapicinit+0x6d>
80102d32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102d40 <lapicid>:

int
lapicid(void)
{
80102d40:	f3 0f 1e fb          	endbr32 
  if (!lapic)
80102d44:	a1 f4 16 12 80       	mov    0x801216f4,%eax
80102d49:	85 c0                	test   %eax,%eax
80102d4b:	74 0b                	je     80102d58 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
80102d4d:	8b 40 20             	mov    0x20(%eax),%eax
80102d50:	c1 e8 18             	shr    $0x18,%eax
80102d53:	c3                   	ret    
80102d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80102d58:	31 c0                	xor    %eax,%eax
}
80102d5a:	c3                   	ret    
80102d5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d5f:	90                   	nop

80102d60 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102d60:	f3 0f 1e fb          	endbr32 
  if(lapic)
80102d64:	a1 f4 16 12 80       	mov    0x801216f4,%eax
80102d69:	85 c0                	test   %eax,%eax
80102d6b:	74 0d                	je     80102d7a <lapiceoi+0x1a>
  lapic[index] = value;
80102d6d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102d74:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d77:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102d7a:	c3                   	ret    
80102d7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d7f:	90                   	nop

80102d80 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102d80:	f3 0f 1e fb          	endbr32 
}
80102d84:	c3                   	ret    
80102d85:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102d90 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102d90:	f3 0f 1e fb          	endbr32 
80102d94:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d95:	b8 0f 00 00 00       	mov    $0xf,%eax
80102d9a:	ba 70 00 00 00       	mov    $0x70,%edx
80102d9f:	89 e5                	mov    %esp,%ebp
80102da1:	53                   	push   %ebx
80102da2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102da5:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102da8:	ee                   	out    %al,(%dx)
80102da9:	b8 0a 00 00 00       	mov    $0xa,%eax
80102dae:	ba 71 00 00 00       	mov    $0x71,%edx
80102db3:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102db4:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102db6:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102db9:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102dbf:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102dc1:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102dc4:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102dc6:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102dc9:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102dcc:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102dd2:	a1 f4 16 12 80       	mov    0x801216f4,%eax
80102dd7:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ddd:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102de0:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102de7:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102dea:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ded:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102df4:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102df7:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102dfa:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e00:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e03:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e09:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e0c:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e12:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e15:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
80102e1b:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
80102e1c:	8b 40 20             	mov    0x20(%eax),%eax
}
80102e1f:	5d                   	pop    %ebp
80102e20:	c3                   	ret    
80102e21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e2f:	90                   	nop

80102e30 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102e30:	f3 0f 1e fb          	endbr32 
80102e34:	55                   	push   %ebp
80102e35:	b8 0b 00 00 00       	mov    $0xb,%eax
80102e3a:	ba 70 00 00 00       	mov    $0x70,%edx
80102e3f:	89 e5                	mov    %esp,%ebp
80102e41:	57                   	push   %edi
80102e42:	56                   	push   %esi
80102e43:	53                   	push   %ebx
80102e44:	83 ec 4c             	sub    $0x4c,%esp
80102e47:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e48:	ba 71 00 00 00       	mov    $0x71,%edx
80102e4d:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102e4e:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e51:	bb 70 00 00 00       	mov    $0x70,%ebx
80102e56:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e60:	31 c0                	xor    %eax,%eax
80102e62:	89 da                	mov    %ebx,%edx
80102e64:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e65:	b9 71 00 00 00       	mov    $0x71,%ecx
80102e6a:	89 ca                	mov    %ecx,%edx
80102e6c:	ec                   	in     (%dx),%al
80102e6d:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e70:	89 da                	mov    %ebx,%edx
80102e72:	b8 02 00 00 00       	mov    $0x2,%eax
80102e77:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e78:	89 ca                	mov    %ecx,%edx
80102e7a:	ec                   	in     (%dx),%al
80102e7b:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e7e:	89 da                	mov    %ebx,%edx
80102e80:	b8 04 00 00 00       	mov    $0x4,%eax
80102e85:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e86:	89 ca                	mov    %ecx,%edx
80102e88:	ec                   	in     (%dx),%al
80102e89:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e8c:	89 da                	mov    %ebx,%edx
80102e8e:	b8 07 00 00 00       	mov    $0x7,%eax
80102e93:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e94:	89 ca                	mov    %ecx,%edx
80102e96:	ec                   	in     (%dx),%al
80102e97:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e9a:	89 da                	mov    %ebx,%edx
80102e9c:	b8 08 00 00 00       	mov    $0x8,%eax
80102ea1:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ea2:	89 ca                	mov    %ecx,%edx
80102ea4:	ec                   	in     (%dx),%al
80102ea5:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ea7:	89 da                	mov    %ebx,%edx
80102ea9:	b8 09 00 00 00       	mov    $0x9,%eax
80102eae:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102eaf:	89 ca                	mov    %ecx,%edx
80102eb1:	ec                   	in     (%dx),%al
80102eb2:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102eb4:	89 da                	mov    %ebx,%edx
80102eb6:	b8 0a 00 00 00       	mov    $0xa,%eax
80102ebb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ebc:	89 ca                	mov    %ecx,%edx
80102ebe:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102ebf:	84 c0                	test   %al,%al
80102ec1:	78 9d                	js     80102e60 <cmostime+0x30>
  return inb(CMOS_RETURN);
80102ec3:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102ec7:	89 fa                	mov    %edi,%edx
80102ec9:	0f b6 fa             	movzbl %dl,%edi
80102ecc:	89 f2                	mov    %esi,%edx
80102ece:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102ed1:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102ed5:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ed8:	89 da                	mov    %ebx,%edx
80102eda:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102edd:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102ee0:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102ee4:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102ee7:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102eea:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102eee:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102ef1:	31 c0                	xor    %eax,%eax
80102ef3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ef4:	89 ca                	mov    %ecx,%edx
80102ef6:	ec                   	in     (%dx),%al
80102ef7:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102efa:	89 da                	mov    %ebx,%edx
80102efc:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102eff:	b8 02 00 00 00       	mov    $0x2,%eax
80102f04:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f05:	89 ca                	mov    %ecx,%edx
80102f07:	ec                   	in     (%dx),%al
80102f08:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f0b:	89 da                	mov    %ebx,%edx
80102f0d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102f10:	b8 04 00 00 00       	mov    $0x4,%eax
80102f15:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f16:	89 ca                	mov    %ecx,%edx
80102f18:	ec                   	in     (%dx),%al
80102f19:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f1c:	89 da                	mov    %ebx,%edx
80102f1e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102f21:	b8 07 00 00 00       	mov    $0x7,%eax
80102f26:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f27:	89 ca                	mov    %ecx,%edx
80102f29:	ec                   	in     (%dx),%al
80102f2a:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f2d:	89 da                	mov    %ebx,%edx
80102f2f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102f32:	b8 08 00 00 00       	mov    $0x8,%eax
80102f37:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f38:	89 ca                	mov    %ecx,%edx
80102f3a:	ec                   	in     (%dx),%al
80102f3b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f3e:	89 da                	mov    %ebx,%edx
80102f40:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102f43:	b8 09 00 00 00       	mov    $0x9,%eax
80102f48:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f49:	89 ca                	mov    %ecx,%edx
80102f4b:	ec                   	in     (%dx),%al
80102f4c:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102f4f:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102f52:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102f55:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102f58:	6a 18                	push   $0x18
80102f5a:	50                   	push   %eax
80102f5b:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102f5e:	50                   	push   %eax
80102f5f:	e8 bc 1c 00 00       	call   80104c20 <memcmp>
80102f64:	83 c4 10             	add    $0x10,%esp
80102f67:	85 c0                	test   %eax,%eax
80102f69:	0f 85 f1 fe ff ff    	jne    80102e60 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102f6f:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102f73:	75 78                	jne    80102fed <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102f75:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102f78:	89 c2                	mov    %eax,%edx
80102f7a:	83 e0 0f             	and    $0xf,%eax
80102f7d:	c1 ea 04             	shr    $0x4,%edx
80102f80:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102f83:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102f86:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102f89:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102f8c:	89 c2                	mov    %eax,%edx
80102f8e:	83 e0 0f             	and    $0xf,%eax
80102f91:	c1 ea 04             	shr    $0x4,%edx
80102f94:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102f97:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102f9a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102f9d:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102fa0:	89 c2                	mov    %eax,%edx
80102fa2:	83 e0 0f             	and    $0xf,%eax
80102fa5:	c1 ea 04             	shr    $0x4,%edx
80102fa8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102fab:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102fae:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102fb1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102fb4:	89 c2                	mov    %eax,%edx
80102fb6:	83 e0 0f             	and    $0xf,%eax
80102fb9:	c1 ea 04             	shr    $0x4,%edx
80102fbc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102fbf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102fc2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102fc5:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102fc8:	89 c2                	mov    %eax,%edx
80102fca:	83 e0 0f             	and    $0xf,%eax
80102fcd:	c1 ea 04             	shr    $0x4,%edx
80102fd0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102fd3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102fd6:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102fd9:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102fdc:	89 c2                	mov    %eax,%edx
80102fde:	83 e0 0f             	and    $0xf,%eax
80102fe1:	c1 ea 04             	shr    $0x4,%edx
80102fe4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102fe7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102fea:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102fed:	8b 75 08             	mov    0x8(%ebp),%esi
80102ff0:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102ff3:	89 06                	mov    %eax,(%esi)
80102ff5:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ff8:	89 46 04             	mov    %eax,0x4(%esi)
80102ffb:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ffe:	89 46 08             	mov    %eax,0x8(%esi)
80103001:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103004:	89 46 0c             	mov    %eax,0xc(%esi)
80103007:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010300a:	89 46 10             	mov    %eax,0x10(%esi)
8010300d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103010:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80103013:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
8010301a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010301d:	5b                   	pop    %ebx
8010301e:	5e                   	pop    %esi
8010301f:	5f                   	pop    %edi
80103020:	5d                   	pop    %ebp
80103021:	c3                   	ret    
80103022:	66 90                	xchg   %ax,%ax
80103024:	66 90                	xchg   %ax,%ax
80103026:	66 90                	xchg   %ax,%ax
80103028:	66 90                	xchg   %ax,%ax
8010302a:	66 90                	xchg   %ax,%ax
8010302c:	66 90                	xchg   %ax,%ax
8010302e:	66 90                	xchg   %ax,%ax

80103030 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103030:	8b 0d 48 17 12 80    	mov    0x80121748,%ecx
80103036:	85 c9                	test   %ecx,%ecx
80103038:	0f 8e 8a 00 00 00    	jle    801030c8 <install_trans+0x98>
{
8010303e:	55                   	push   %ebp
8010303f:	89 e5                	mov    %esp,%ebp
80103041:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80103042:	31 ff                	xor    %edi,%edi
{
80103044:	56                   	push   %esi
80103045:	53                   	push   %ebx
80103046:	83 ec 0c             	sub    $0xc,%esp
80103049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103050:	a1 34 17 12 80       	mov    0x80121734,%eax
80103055:	83 ec 08             	sub    $0x8,%esp
80103058:	01 f8                	add    %edi,%eax
8010305a:	83 c0 01             	add    $0x1,%eax
8010305d:	50                   	push   %eax
8010305e:	ff 35 44 17 12 80    	pushl  0x80121744
80103064:	e8 67 d0 ff ff       	call   801000d0 <bread>
80103069:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010306b:	58                   	pop    %eax
8010306c:	5a                   	pop    %edx
8010306d:	ff 34 bd 4c 17 12 80 	pushl  -0x7fede8b4(,%edi,4)
80103074:	ff 35 44 17 12 80    	pushl  0x80121744
  for (tail = 0; tail < log.lh.n; tail++) {
8010307a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010307d:	e8 4e d0 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103082:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103085:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103087:	8d 46 5c             	lea    0x5c(%esi),%eax
8010308a:	68 00 02 00 00       	push   $0x200
8010308f:	50                   	push   %eax
80103090:	8d 43 5c             	lea    0x5c(%ebx),%eax
80103093:	50                   	push   %eax
80103094:	e8 d7 1b 00 00       	call   80104c70 <memmove>
    bwrite(dbuf);  // write dst to disk
80103099:	89 1c 24             	mov    %ebx,(%esp)
8010309c:	e8 0f d1 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
801030a1:	89 34 24             	mov    %esi,(%esp)
801030a4:	e8 47 d1 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
801030a9:	89 1c 24             	mov    %ebx,(%esp)
801030ac:	e8 3f d1 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801030b1:	83 c4 10             	add    $0x10,%esp
801030b4:	39 3d 48 17 12 80    	cmp    %edi,0x80121748
801030ba:	7f 94                	jg     80103050 <install_trans+0x20>
  }
}
801030bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030bf:	5b                   	pop    %ebx
801030c0:	5e                   	pop    %esi
801030c1:	5f                   	pop    %edi
801030c2:	5d                   	pop    %ebp
801030c3:	c3                   	ret    
801030c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801030c8:	c3                   	ret    
801030c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801030d0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801030d0:	55                   	push   %ebp
801030d1:	89 e5                	mov    %esp,%ebp
801030d3:	53                   	push   %ebx
801030d4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
801030d7:	ff 35 34 17 12 80    	pushl  0x80121734
801030dd:	ff 35 44 17 12 80    	pushl  0x80121744
801030e3:	e8 e8 cf ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801030e8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
801030eb:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
801030ed:	a1 48 17 12 80       	mov    0x80121748,%eax
801030f2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
801030f5:	85 c0                	test   %eax,%eax
801030f7:	7e 19                	jle    80103112 <write_head+0x42>
801030f9:	31 d2                	xor    %edx,%edx
801030fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801030ff:	90                   	nop
    hb->block[i] = log.lh.block[i];
80103100:	8b 0c 95 4c 17 12 80 	mov    -0x7fede8b4(,%edx,4),%ecx
80103107:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010310b:	83 c2 01             	add    $0x1,%edx
8010310e:	39 d0                	cmp    %edx,%eax
80103110:	75 ee                	jne    80103100 <write_head+0x30>
  }
  bwrite(buf);
80103112:	83 ec 0c             	sub    $0xc,%esp
80103115:	53                   	push   %ebx
80103116:	e8 95 d0 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
8010311b:	89 1c 24             	mov    %ebx,(%esp)
8010311e:	e8 cd d0 ff ff       	call   801001f0 <brelse>
}
80103123:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103126:	83 c4 10             	add    $0x10,%esp
80103129:	c9                   	leave  
8010312a:	c3                   	ret    
8010312b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010312f:	90                   	nop

80103130 <initlog>:
{
80103130:	f3 0f 1e fb          	endbr32 
80103134:	55                   	push   %ebp
80103135:	89 e5                	mov    %esp,%ebp
80103137:	53                   	push   %ebx
80103138:	83 ec 2c             	sub    $0x2c,%esp
8010313b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010313e:	68 40 85 10 80       	push   $0x80108540
80103143:	68 00 17 12 80       	push   $0x80121700
80103148:	e8 f3 17 00 00       	call   80104940 <initlock>
  readsb(dev, &sb);
8010314d:	58                   	pop    %eax
8010314e:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103151:	5a                   	pop    %edx
80103152:	50                   	push   %eax
80103153:	53                   	push   %ebx
80103154:	e8 37 e4 ff ff       	call   80101590 <readsb>
  log.start = sb.logstart;
80103159:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
8010315c:	59                   	pop    %ecx
  log.dev = dev;
8010315d:	89 1d 44 17 12 80    	mov    %ebx,0x80121744
  log.size = sb.nlog;
80103163:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103166:	a3 34 17 12 80       	mov    %eax,0x80121734
  log.size = sb.nlog;
8010316b:	89 15 38 17 12 80    	mov    %edx,0x80121738
  struct buf *buf = bread(log.dev, log.start);
80103171:	5a                   	pop    %edx
80103172:	50                   	push   %eax
80103173:	53                   	push   %ebx
80103174:	e8 57 cf ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80103179:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
8010317c:	8b 48 5c             	mov    0x5c(%eax),%ecx
8010317f:	89 0d 48 17 12 80    	mov    %ecx,0x80121748
  for (i = 0; i < log.lh.n; i++) {
80103185:	85 c9                	test   %ecx,%ecx
80103187:	7e 19                	jle    801031a2 <initlog+0x72>
80103189:	31 d2                	xor    %edx,%edx
8010318b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010318f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80103190:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80103194:	89 1c 95 4c 17 12 80 	mov    %ebx,-0x7fede8b4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010319b:	83 c2 01             	add    $0x1,%edx
8010319e:	39 d1                	cmp    %edx,%ecx
801031a0:	75 ee                	jne    80103190 <initlog+0x60>
  brelse(buf);
801031a2:	83 ec 0c             	sub    $0xc,%esp
801031a5:	50                   	push   %eax
801031a6:	e8 45 d0 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
801031ab:	e8 80 fe ff ff       	call   80103030 <install_trans>
  log.lh.n = 0;
801031b0:	c7 05 48 17 12 80 00 	movl   $0x0,0x80121748
801031b7:	00 00 00 
  write_head(); // clear the log
801031ba:	e8 11 ff ff ff       	call   801030d0 <write_head>
}
801031bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801031c2:	83 c4 10             	add    $0x10,%esp
801031c5:	c9                   	leave  
801031c6:	c3                   	ret    
801031c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031ce:	66 90                	xchg   %ax,%ax

801031d0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
801031d0:	f3 0f 1e fb          	endbr32 
801031d4:	55                   	push   %ebp
801031d5:	89 e5                	mov    %esp,%ebp
801031d7:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
801031da:	68 00 17 12 80       	push   $0x80121700
801031df:	e8 dc 18 00 00       	call   80104ac0 <acquire>
801031e4:	83 c4 10             	add    $0x10,%esp
801031e7:	eb 1c                	jmp    80103205 <begin_op+0x35>
801031e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
801031f0:	83 ec 08             	sub    $0x8,%esp
801031f3:	68 00 17 12 80       	push   $0x80121700
801031f8:	68 00 17 12 80       	push   $0x80121700
801031fd:	e8 4e 12 00 00       	call   80104450 <sleep>
80103202:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80103205:	a1 40 17 12 80       	mov    0x80121740,%eax
8010320a:	85 c0                	test   %eax,%eax
8010320c:	75 e2                	jne    801031f0 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
8010320e:	a1 3c 17 12 80       	mov    0x8012173c,%eax
80103213:	8b 15 48 17 12 80    	mov    0x80121748,%edx
80103219:	83 c0 01             	add    $0x1,%eax
8010321c:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
8010321f:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80103222:	83 fa 1e             	cmp    $0x1e,%edx
80103225:	7f c9                	jg     801031f0 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80103227:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
8010322a:	a3 3c 17 12 80       	mov    %eax,0x8012173c
      release(&log.lock);
8010322f:	68 00 17 12 80       	push   $0x80121700
80103234:	e8 47 19 00 00       	call   80104b80 <release>
      break;
    }
  }
}
80103239:	83 c4 10             	add    $0x10,%esp
8010323c:	c9                   	leave  
8010323d:	c3                   	ret    
8010323e:	66 90                	xchg   %ax,%ax

80103240 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103240:	f3 0f 1e fb          	endbr32 
80103244:	55                   	push   %ebp
80103245:	89 e5                	mov    %esp,%ebp
80103247:	57                   	push   %edi
80103248:	56                   	push   %esi
80103249:	53                   	push   %ebx
8010324a:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
8010324d:	68 00 17 12 80       	push   $0x80121700
80103252:	e8 69 18 00 00       	call   80104ac0 <acquire>
  log.outstanding -= 1;
80103257:	a1 3c 17 12 80       	mov    0x8012173c,%eax
  if(log.committing)
8010325c:	8b 35 40 17 12 80    	mov    0x80121740,%esi
80103262:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103265:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103268:	89 1d 3c 17 12 80    	mov    %ebx,0x8012173c
  if(log.committing)
8010326e:	85 f6                	test   %esi,%esi
80103270:	0f 85 1e 01 00 00    	jne    80103394 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80103276:	85 db                	test   %ebx,%ebx
80103278:	0f 85 f2 00 00 00    	jne    80103370 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
8010327e:	c7 05 40 17 12 80 01 	movl   $0x1,0x80121740
80103285:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103288:	83 ec 0c             	sub    $0xc,%esp
8010328b:	68 00 17 12 80       	push   $0x80121700
80103290:	e8 eb 18 00 00       	call   80104b80 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103295:	8b 0d 48 17 12 80    	mov    0x80121748,%ecx
8010329b:	83 c4 10             	add    $0x10,%esp
8010329e:	85 c9                	test   %ecx,%ecx
801032a0:	7f 3e                	jg     801032e0 <end_op+0xa0>
    acquire(&log.lock);
801032a2:	83 ec 0c             	sub    $0xc,%esp
801032a5:	68 00 17 12 80       	push   $0x80121700
801032aa:	e8 11 18 00 00       	call   80104ac0 <acquire>
    wakeup(&log);
801032af:	c7 04 24 00 17 12 80 	movl   $0x80121700,(%esp)
    log.committing = 0;
801032b6:	c7 05 40 17 12 80 00 	movl   $0x0,0x80121740
801032bd:	00 00 00 
    wakeup(&log);
801032c0:	e8 4b 13 00 00       	call   80104610 <wakeup>
    release(&log.lock);
801032c5:	c7 04 24 00 17 12 80 	movl   $0x80121700,(%esp)
801032cc:	e8 af 18 00 00       	call   80104b80 <release>
801032d1:	83 c4 10             	add    $0x10,%esp
}
801032d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032d7:	5b                   	pop    %ebx
801032d8:	5e                   	pop    %esi
801032d9:	5f                   	pop    %edi
801032da:	5d                   	pop    %ebp
801032db:	c3                   	ret    
801032dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801032e0:	a1 34 17 12 80       	mov    0x80121734,%eax
801032e5:	83 ec 08             	sub    $0x8,%esp
801032e8:	01 d8                	add    %ebx,%eax
801032ea:	83 c0 01             	add    $0x1,%eax
801032ed:	50                   	push   %eax
801032ee:	ff 35 44 17 12 80    	pushl  0x80121744
801032f4:	e8 d7 cd ff ff       	call   801000d0 <bread>
801032f9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801032fb:	58                   	pop    %eax
801032fc:	5a                   	pop    %edx
801032fd:	ff 34 9d 4c 17 12 80 	pushl  -0x7fede8b4(,%ebx,4)
80103304:	ff 35 44 17 12 80    	pushl  0x80121744
  for (tail = 0; tail < log.lh.n; tail++) {
8010330a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010330d:	e8 be cd ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103312:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103315:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103317:	8d 40 5c             	lea    0x5c(%eax),%eax
8010331a:	68 00 02 00 00       	push   $0x200
8010331f:	50                   	push   %eax
80103320:	8d 46 5c             	lea    0x5c(%esi),%eax
80103323:	50                   	push   %eax
80103324:	e8 47 19 00 00       	call   80104c70 <memmove>
    bwrite(to);  // write the log
80103329:	89 34 24             	mov    %esi,(%esp)
8010332c:	e8 7f ce ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103331:	89 3c 24             	mov    %edi,(%esp)
80103334:	e8 b7 ce ff ff       	call   801001f0 <brelse>
    brelse(to);
80103339:	89 34 24             	mov    %esi,(%esp)
8010333c:	e8 af ce ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103341:	83 c4 10             	add    $0x10,%esp
80103344:	3b 1d 48 17 12 80    	cmp    0x80121748,%ebx
8010334a:	7c 94                	jl     801032e0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010334c:	e8 7f fd ff ff       	call   801030d0 <write_head>
    install_trans(); // Now install writes to home locations
80103351:	e8 da fc ff ff       	call   80103030 <install_trans>
    log.lh.n = 0;
80103356:	c7 05 48 17 12 80 00 	movl   $0x0,0x80121748
8010335d:	00 00 00 
    write_head();    // Erase the transaction from the log
80103360:	e8 6b fd ff ff       	call   801030d0 <write_head>
80103365:	e9 38 ff ff ff       	jmp    801032a2 <end_op+0x62>
8010336a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103370:	83 ec 0c             	sub    $0xc,%esp
80103373:	68 00 17 12 80       	push   $0x80121700
80103378:	e8 93 12 00 00       	call   80104610 <wakeup>
  release(&log.lock);
8010337d:	c7 04 24 00 17 12 80 	movl   $0x80121700,(%esp)
80103384:	e8 f7 17 00 00       	call   80104b80 <release>
80103389:	83 c4 10             	add    $0x10,%esp
}
8010338c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010338f:	5b                   	pop    %ebx
80103390:	5e                   	pop    %esi
80103391:	5f                   	pop    %edi
80103392:	5d                   	pop    %ebp
80103393:	c3                   	ret    
    panic("log.committing");
80103394:	83 ec 0c             	sub    $0xc,%esp
80103397:	68 44 85 10 80       	push   $0x80108544
8010339c:	e8 ef cf ff ff       	call   80100390 <panic>
801033a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033af:	90                   	nop

801033b0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801033b0:	f3 0f 1e fb          	endbr32 
801033b4:	55                   	push   %ebp
801033b5:	89 e5                	mov    %esp,%ebp
801033b7:	53                   	push   %ebx
801033b8:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801033bb:	8b 15 48 17 12 80    	mov    0x80121748,%edx
{
801033c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801033c4:	83 fa 1d             	cmp    $0x1d,%edx
801033c7:	0f 8f 91 00 00 00    	jg     8010345e <log_write+0xae>
801033cd:	a1 38 17 12 80       	mov    0x80121738,%eax
801033d2:	83 e8 01             	sub    $0x1,%eax
801033d5:	39 c2                	cmp    %eax,%edx
801033d7:	0f 8d 81 00 00 00    	jge    8010345e <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
801033dd:	a1 3c 17 12 80       	mov    0x8012173c,%eax
801033e2:	85 c0                	test   %eax,%eax
801033e4:	0f 8e 81 00 00 00    	jle    8010346b <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
801033ea:	83 ec 0c             	sub    $0xc,%esp
801033ed:	68 00 17 12 80       	push   $0x80121700
801033f2:	e8 c9 16 00 00       	call   80104ac0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801033f7:	8b 15 48 17 12 80    	mov    0x80121748,%edx
801033fd:	83 c4 10             	add    $0x10,%esp
80103400:	85 d2                	test   %edx,%edx
80103402:	7e 4e                	jle    80103452 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103404:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80103407:	31 c0                	xor    %eax,%eax
80103409:	eb 0c                	jmp    80103417 <log_write+0x67>
8010340b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010340f:	90                   	nop
80103410:	83 c0 01             	add    $0x1,%eax
80103413:	39 c2                	cmp    %eax,%edx
80103415:	74 29                	je     80103440 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103417:	39 0c 85 4c 17 12 80 	cmp    %ecx,-0x7fede8b4(,%eax,4)
8010341e:	75 f0                	jne    80103410 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103420:	89 0c 85 4c 17 12 80 	mov    %ecx,-0x7fede8b4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103427:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010342a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010342d:	c7 45 08 00 17 12 80 	movl   $0x80121700,0x8(%ebp)
}
80103434:	c9                   	leave  
  release(&log.lock);
80103435:	e9 46 17 00 00       	jmp    80104b80 <release>
8010343a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103440:	89 0c 95 4c 17 12 80 	mov    %ecx,-0x7fede8b4(,%edx,4)
    log.lh.n++;
80103447:	83 c2 01             	add    $0x1,%edx
8010344a:	89 15 48 17 12 80    	mov    %edx,0x80121748
80103450:	eb d5                	jmp    80103427 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80103452:	8b 43 08             	mov    0x8(%ebx),%eax
80103455:	a3 4c 17 12 80       	mov    %eax,0x8012174c
  if (i == log.lh.n)
8010345a:	75 cb                	jne    80103427 <log_write+0x77>
8010345c:	eb e9                	jmp    80103447 <log_write+0x97>
    panic("too big a transaction");
8010345e:	83 ec 0c             	sub    $0xc,%esp
80103461:	68 53 85 10 80       	push   $0x80108553
80103466:	e8 25 cf ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
8010346b:	83 ec 0c             	sub    $0xc,%esp
8010346e:	68 69 85 10 80       	push   $0x80108569
80103473:	e8 18 cf ff ff       	call   80100390 <panic>
80103478:	66 90                	xchg   %ax,%ax
8010347a:	66 90                	xchg   %ax,%ax
8010347c:	66 90                	xchg   %ax,%ax
8010347e:	66 90                	xchg   %ax,%ax

80103480 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103480:	55                   	push   %ebp
80103481:	89 e5                	mov    %esp,%ebp
80103483:	53                   	push   %ebx
80103484:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103487:	e8 84 09 00 00       	call   80103e10 <cpuid>
8010348c:	89 c3                	mov    %eax,%ebx
8010348e:	e8 7d 09 00 00       	call   80103e10 <cpuid>
80103493:	83 ec 04             	sub    $0x4,%esp
80103496:	53                   	push   %ebx
80103497:	50                   	push   %eax
80103498:	68 84 85 10 80       	push   $0x80108584
8010349d:	e8 0e d2 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
801034a2:	e8 f9 29 00 00       	call   80105ea0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801034a7:	e8 e4 08 00 00       	call   80103d90 <mycpu>
801034ac:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801034ae:	b8 01 00 00 00       	mov    $0x1,%eax
801034b3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801034ba:	e8 a1 0c 00 00       	call   80104160 <scheduler>
801034bf:	90                   	nop

801034c0 <mpenter>:
{
801034c0:	f3 0f 1e fb          	endbr32 
801034c4:	55                   	push   %ebp
801034c5:	89 e5                	mov    %esp,%ebp
801034c7:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801034ca:	e8 d1 3e 00 00       	call   801073a0 <switchkvm>
  seginit();
801034cf:	e8 1c 3e 00 00       	call   801072f0 <seginit>
  lapicinit();
801034d4:	e8 67 f7 ff ff       	call   80102c40 <lapicinit>
  mpmain();
801034d9:	e8 a2 ff ff ff       	call   80103480 <mpmain>
801034de:	66 90                	xchg   %ax,%ax

801034e0 <main>:
{
801034e0:	f3 0f 1e fb          	endbr32 
801034e4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801034e8:	83 e4 f0             	and    $0xfffffff0,%esp
801034eb:	ff 71 fc             	pushl  -0x4(%ecx)
801034ee:	55                   	push   %ebp
801034ef:	89 e5                	mov    %esp,%ebp
801034f1:	53                   	push   %ebx
801034f2:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801034f3:	83 ec 08             	sub    $0x8,%esp
801034f6:	68 00 00 40 80       	push   $0x80400000
801034fb:	68 28 0a 13 80       	push   $0x80130a28
80103500:	e8 db f4 ff ff       	call   801029e0 <kinit1>
  kvmalloc();      // kernel page table
80103505:	e8 76 43 00 00       	call   80107880 <kvmalloc>
  mpinit();        // detect other processors
8010350a:	e8 91 01 00 00       	call   801036a0 <mpinit>
  lapicinit();     // interrupt controller
8010350f:	e8 2c f7 ff ff       	call   80102c40 <lapicinit>
  init_cow();
80103514:	e8 67 f3 ff ff       	call   80102880 <init_cow>
  seginit();       // segment descriptors
80103519:	e8 d2 3d 00 00       	call   801072f0 <seginit>
  picinit();       // disable pic
8010351e:	e8 5d 03 00 00       	call   80103880 <picinit>
  ioapicinit();    // another interrupt controller
80103523:	e8 68 f2 ff ff       	call   80102790 <ioapicinit>
  consoleinit();   // console hardware
80103528:	e8 03 d5 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
8010352d:	e8 ee 2d 00 00       	call   80106320 <uartinit>
  pinit();         // process table
80103532:	e8 39 08 00 00       	call   80103d70 <pinit>
  tvinit();        // trap vectors
80103537:	e8 e4 28 00 00       	call   80105e20 <tvinit>
  binit();         // buffer cache
8010353c:	e8 ff ca ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103541:	e8 2a d9 ff ff       	call   80100e70 <fileinit>
  ideinit();       // disk 
80103546:	e8 15 f0 ff ff       	call   80102560 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
8010354b:	83 c4 0c             	add    $0xc,%esp
8010354e:	68 8a 00 00 00       	push   $0x8a
80103553:	68 8c b4 10 80       	push   $0x8010b48c
80103558:	68 00 70 00 80       	push   $0x80007000
8010355d:	e8 0e 17 00 00       	call   80104c70 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103562:	83 c4 10             	add    $0x10,%esp
80103565:	69 05 80 1d 12 80 b0 	imul   $0xb0,0x80121d80,%eax
8010356c:	00 00 00 
8010356f:	05 00 18 12 80       	add    $0x80121800,%eax
80103574:	3d 00 18 12 80       	cmp    $0x80121800,%eax
80103579:	76 7d                	jbe    801035f8 <main+0x118>
8010357b:	bb 00 18 12 80       	mov    $0x80121800,%ebx
80103580:	eb 1f                	jmp    801035a1 <main+0xc1>
80103582:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103588:	69 05 80 1d 12 80 b0 	imul   $0xb0,0x80121d80,%eax
8010358f:	00 00 00 
80103592:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103598:	05 00 18 12 80       	add    $0x80121800,%eax
8010359d:	39 c3                	cmp    %eax,%ebx
8010359f:	73 57                	jae    801035f8 <main+0x118>
    if(c == mycpu())  // We've started already.
801035a1:	e8 ea 07 00 00       	call   80103d90 <mycpu>
801035a6:	39 c3                	cmp    %eax,%ebx
801035a8:	74 de                	je     80103588 <main+0xa8>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = cow_kalloc();
801035aa:	e8 91 39 00 00       	call   80106f40 <cow_kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801035af:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
801035b2:	c7 05 f8 6f 00 80 c0 	movl   $0x801034c0,0x80006ff8
801035b9:	34 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801035bc:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
801035c3:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801035c6:	05 00 10 00 00       	add    $0x1000,%eax
801035cb:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801035d0:	0f b6 03             	movzbl (%ebx),%eax
801035d3:	68 00 70 00 00       	push   $0x7000
801035d8:	50                   	push   %eax
801035d9:	e8 b2 f7 ff ff       	call   80102d90 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801035de:	83 c4 10             	add    $0x10,%esp
801035e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035e8:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801035ee:	85 c0                	test   %eax,%eax
801035f0:	74 f6                	je     801035e8 <main+0x108>
801035f2:	eb 94                	jmp    80103588 <main+0xa8>
801035f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801035f8:	83 ec 08             	sub    $0x8,%esp
801035fb:	68 00 00 00 8e       	push   $0x8e000000
80103600:	68 00 00 40 80       	push   $0x80400000
80103605:	e8 56 f4 ff ff       	call   80102a60 <kinit2>
  userinit();      // first user process
8010360a:	e8 51 08 00 00       	call   80103e60 <userinit>
  mpmain();        // finish this processor's setup
8010360f:	e8 6c fe ff ff       	call   80103480 <mpmain>
80103614:	66 90                	xchg   %ax,%ax
80103616:	66 90                	xchg   %ax,%ax
80103618:	66 90                	xchg   %ax,%ax
8010361a:	66 90                	xchg   %ax,%ax
8010361c:	66 90                	xchg   %ax,%ax
8010361e:	66 90                	xchg   %ax,%ax

80103620 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103620:	55                   	push   %ebp
80103621:	89 e5                	mov    %esp,%ebp
80103623:	57                   	push   %edi
80103624:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103625:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010362b:	53                   	push   %ebx
  e = addr+len;
8010362c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010362f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103632:	39 de                	cmp    %ebx,%esi
80103634:	72 10                	jb     80103646 <mpsearch1+0x26>
80103636:	eb 50                	jmp    80103688 <mpsearch1+0x68>
80103638:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010363f:	90                   	nop
80103640:	89 fe                	mov    %edi,%esi
80103642:	39 fb                	cmp    %edi,%ebx
80103644:	76 42                	jbe    80103688 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103646:	83 ec 04             	sub    $0x4,%esp
80103649:	8d 7e 10             	lea    0x10(%esi),%edi
8010364c:	6a 04                	push   $0x4
8010364e:	68 98 85 10 80       	push   $0x80108598
80103653:	56                   	push   %esi
80103654:	e8 c7 15 00 00       	call   80104c20 <memcmp>
80103659:	83 c4 10             	add    $0x10,%esp
8010365c:	85 c0                	test   %eax,%eax
8010365e:	75 e0                	jne    80103640 <mpsearch1+0x20>
80103660:	89 f2                	mov    %esi,%edx
80103662:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103668:	0f b6 0a             	movzbl (%edx),%ecx
8010366b:	83 c2 01             	add    $0x1,%edx
8010366e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103670:	39 fa                	cmp    %edi,%edx
80103672:	75 f4                	jne    80103668 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103674:	84 c0                	test   %al,%al
80103676:	75 c8                	jne    80103640 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103678:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010367b:	89 f0                	mov    %esi,%eax
8010367d:	5b                   	pop    %ebx
8010367e:	5e                   	pop    %esi
8010367f:	5f                   	pop    %edi
80103680:	5d                   	pop    %ebp
80103681:	c3                   	ret    
80103682:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103688:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010368b:	31 f6                	xor    %esi,%esi
}
8010368d:	5b                   	pop    %ebx
8010368e:	89 f0                	mov    %esi,%eax
80103690:	5e                   	pop    %esi
80103691:	5f                   	pop    %edi
80103692:	5d                   	pop    %ebp
80103693:	c3                   	ret    
80103694:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010369b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010369f:	90                   	nop

801036a0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801036a0:	f3 0f 1e fb          	endbr32 
801036a4:	55                   	push   %ebp
801036a5:	89 e5                	mov    %esp,%ebp
801036a7:	57                   	push   %edi
801036a8:	56                   	push   %esi
801036a9:	53                   	push   %ebx
801036aa:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801036ad:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801036b4:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801036bb:	c1 e0 08             	shl    $0x8,%eax
801036be:	09 d0                	or     %edx,%eax
801036c0:	c1 e0 04             	shl    $0x4,%eax
801036c3:	75 1b                	jne    801036e0 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801036c5:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801036cc:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801036d3:	c1 e0 08             	shl    $0x8,%eax
801036d6:	09 d0                	or     %edx,%eax
801036d8:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801036db:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801036e0:	ba 00 04 00 00       	mov    $0x400,%edx
801036e5:	e8 36 ff ff ff       	call   80103620 <mpsearch1>
801036ea:	89 c6                	mov    %eax,%esi
801036ec:	85 c0                	test   %eax,%eax
801036ee:	0f 84 4c 01 00 00    	je     80103840 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801036f4:	8b 5e 04             	mov    0x4(%esi),%ebx
801036f7:	85 db                	test   %ebx,%ebx
801036f9:	0f 84 61 01 00 00    	je     80103860 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
801036ff:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103702:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103708:	6a 04                	push   $0x4
8010370a:	68 9d 85 10 80       	push   $0x8010859d
8010370f:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103710:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103713:	e8 08 15 00 00       	call   80104c20 <memcmp>
80103718:	83 c4 10             	add    $0x10,%esp
8010371b:	85 c0                	test   %eax,%eax
8010371d:	0f 85 3d 01 00 00    	jne    80103860 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
80103723:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
8010372a:	3c 01                	cmp    $0x1,%al
8010372c:	74 08                	je     80103736 <mpinit+0x96>
8010372e:	3c 04                	cmp    $0x4,%al
80103730:	0f 85 2a 01 00 00    	jne    80103860 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
80103736:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
8010373d:	66 85 d2             	test   %dx,%dx
80103740:	74 26                	je     80103768 <mpinit+0xc8>
80103742:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
80103745:	89 d8                	mov    %ebx,%eax
  sum = 0;
80103747:	31 d2                	xor    %edx,%edx
80103749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103750:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
80103757:	83 c0 01             	add    $0x1,%eax
8010375a:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
8010375c:	39 f8                	cmp    %edi,%eax
8010375e:	75 f0                	jne    80103750 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
80103760:	84 d2                	test   %dl,%dl
80103762:	0f 85 f8 00 00 00    	jne    80103860 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103768:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
8010376e:	a3 f4 16 12 80       	mov    %eax,0x801216f4
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103773:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80103779:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
80103780:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103785:	03 55 e4             	add    -0x1c(%ebp),%edx
80103788:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
8010378b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010378f:	90                   	nop
80103790:	39 c2                	cmp    %eax,%edx
80103792:	76 15                	jbe    801037a9 <mpinit+0x109>
    switch(*p){
80103794:	0f b6 08             	movzbl (%eax),%ecx
80103797:	80 f9 02             	cmp    $0x2,%cl
8010379a:	74 5c                	je     801037f8 <mpinit+0x158>
8010379c:	77 42                	ja     801037e0 <mpinit+0x140>
8010379e:	84 c9                	test   %cl,%cl
801037a0:	74 6e                	je     80103810 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801037a2:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801037a5:	39 c2                	cmp    %eax,%edx
801037a7:	77 eb                	ja     80103794 <mpinit+0xf4>
801037a9:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801037ac:	85 db                	test   %ebx,%ebx
801037ae:	0f 84 b9 00 00 00    	je     8010386d <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801037b4:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
801037b8:	74 15                	je     801037cf <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801037ba:	b8 70 00 00 00       	mov    $0x70,%eax
801037bf:	ba 22 00 00 00       	mov    $0x22,%edx
801037c4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801037c5:	ba 23 00 00 00       	mov    $0x23,%edx
801037ca:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801037cb:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801037ce:	ee                   	out    %al,(%dx)
  }
}
801037cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037d2:	5b                   	pop    %ebx
801037d3:	5e                   	pop    %esi
801037d4:	5f                   	pop    %edi
801037d5:	5d                   	pop    %ebp
801037d6:	c3                   	ret    
801037d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037de:	66 90                	xchg   %ax,%ax
    switch(*p){
801037e0:	83 e9 03             	sub    $0x3,%ecx
801037e3:	80 f9 01             	cmp    $0x1,%cl
801037e6:	76 ba                	jbe    801037a2 <mpinit+0x102>
801037e8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801037ef:	eb 9f                	jmp    80103790 <mpinit+0xf0>
801037f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801037f8:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801037fc:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801037ff:	88 0d e0 17 12 80    	mov    %cl,0x801217e0
      continue;
80103805:	eb 89                	jmp    80103790 <mpinit+0xf0>
80103807:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010380e:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103810:	8b 0d 80 1d 12 80    	mov    0x80121d80,%ecx
80103816:	83 f9 07             	cmp    $0x7,%ecx
80103819:	7f 19                	jg     80103834 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010381b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103821:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103825:	83 c1 01             	add    $0x1,%ecx
80103828:	89 0d 80 1d 12 80    	mov    %ecx,0x80121d80
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010382e:	88 9f 00 18 12 80    	mov    %bl,-0x7fede800(%edi)
      p += sizeof(struct mpproc);
80103834:	83 c0 14             	add    $0x14,%eax
      continue;
80103837:	e9 54 ff ff ff       	jmp    80103790 <mpinit+0xf0>
8010383c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
80103840:	ba 00 00 01 00       	mov    $0x10000,%edx
80103845:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010384a:	e8 d1 fd ff ff       	call   80103620 <mpsearch1>
8010384f:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103851:	85 c0                	test   %eax,%eax
80103853:	0f 85 9b fe ff ff    	jne    801036f4 <mpinit+0x54>
80103859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103860:	83 ec 0c             	sub    $0xc,%esp
80103863:	68 a2 85 10 80       	push   $0x801085a2
80103868:	e8 23 cb ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010386d:	83 ec 0c             	sub    $0xc,%esp
80103870:	68 bc 85 10 80       	push   $0x801085bc
80103875:	e8 16 cb ff ff       	call   80100390 <panic>
8010387a:	66 90                	xchg   %ax,%ax
8010387c:	66 90                	xchg   %ax,%ax
8010387e:	66 90                	xchg   %ax,%ax

80103880 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103880:	f3 0f 1e fb          	endbr32 
80103884:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103889:	ba 21 00 00 00       	mov    $0x21,%edx
8010388e:	ee                   	out    %al,(%dx)
8010388f:	ba a1 00 00 00       	mov    $0xa1,%edx
80103894:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103895:	c3                   	ret    
80103896:	66 90                	xchg   %ax,%ax
80103898:	66 90                	xchg   %ax,%ax
8010389a:	66 90                	xchg   %ax,%ax
8010389c:	66 90                	xchg   %ax,%ax
8010389e:	66 90                	xchg   %ax,%ax

801038a0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801038a0:	f3 0f 1e fb          	endbr32 
801038a4:	55                   	push   %ebp
801038a5:	89 e5                	mov    %esp,%ebp
801038a7:	57                   	push   %edi
801038a8:	56                   	push   %esi
801038a9:	53                   	push   %ebx
801038aa:	83 ec 0c             	sub    $0xc,%esp
801038ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
801038b0:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801038b3:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801038b9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801038bf:	e8 cc d5 ff ff       	call   80100e90 <filealloc>
801038c4:	89 03                	mov    %eax,(%ebx)
801038c6:	85 c0                	test   %eax,%eax
801038c8:	0f 84 ac 00 00 00    	je     8010397a <pipealloc+0xda>
801038ce:	e8 bd d5 ff ff       	call   80100e90 <filealloc>
801038d3:	89 06                	mov    %eax,(%esi)
801038d5:	85 c0                	test   %eax,%eax
801038d7:	0f 84 8b 00 00 00    	je     80103968 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)cow_kalloc()) == 0)
801038dd:	e8 5e 36 00 00       	call   80106f40 <cow_kalloc>
801038e2:	89 c7                	mov    %eax,%edi
801038e4:	85 c0                	test   %eax,%eax
801038e6:	0f 84 b4 00 00 00    	je     801039a0 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
801038ec:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801038f3:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801038f6:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
801038f9:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103900:	00 00 00 
  p->nwrite = 0;
80103903:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010390a:	00 00 00 
  p->nread = 0;
8010390d:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103914:	00 00 00 
  initlock(&p->lock, "pipe");
80103917:	68 db 85 10 80       	push   $0x801085db
8010391c:	50                   	push   %eax
8010391d:	e8 1e 10 00 00       	call   80104940 <initlock>
  (*f0)->type = FD_PIPE;
80103922:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103924:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103927:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
8010392d:	8b 03                	mov    (%ebx),%eax
8010392f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103933:	8b 03                	mov    (%ebx),%eax
80103935:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103939:	8b 03                	mov    (%ebx),%eax
8010393b:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010393e:	8b 06                	mov    (%esi),%eax
80103940:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103946:	8b 06                	mov    (%esi),%eax
80103948:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
8010394c:	8b 06                	mov    (%esi),%eax
8010394e:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103952:	8b 06                	mov    (%esi),%eax
80103954:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103957:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010395a:	31 c0                	xor    %eax,%eax
}
8010395c:	5b                   	pop    %ebx
8010395d:	5e                   	pop    %esi
8010395e:	5f                   	pop    %edi
8010395f:	5d                   	pop    %ebp
80103960:	c3                   	ret    
80103961:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103968:	8b 03                	mov    (%ebx),%eax
8010396a:	85 c0                	test   %eax,%eax
8010396c:	74 1e                	je     8010398c <pipealloc+0xec>
    fileclose(*f0);
8010396e:	83 ec 0c             	sub    $0xc,%esp
80103971:	50                   	push   %eax
80103972:	e8 d9 d5 ff ff       	call   80100f50 <fileclose>
80103977:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010397a:	8b 06                	mov    (%esi),%eax
8010397c:	85 c0                	test   %eax,%eax
8010397e:	74 0c                	je     8010398c <pipealloc+0xec>
    fileclose(*f1);
80103980:	83 ec 0c             	sub    $0xc,%esp
80103983:	50                   	push   %eax
80103984:	e8 c7 d5 ff ff       	call   80100f50 <fileclose>
80103989:	83 c4 10             	add    $0x10,%esp
}
8010398c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010398f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103994:	5b                   	pop    %ebx
80103995:	5e                   	pop    %esi
80103996:	5f                   	pop    %edi
80103997:	5d                   	pop    %ebp
80103998:	c3                   	ret    
80103999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801039a0:	8b 03                	mov    (%ebx),%eax
801039a2:	85 c0                	test   %eax,%eax
801039a4:	75 c8                	jne    8010396e <pipealloc+0xce>
801039a6:	eb d2                	jmp    8010397a <pipealloc+0xda>
801039a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039af:	90                   	nop

801039b0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801039b0:	f3 0f 1e fb          	endbr32 
801039b4:	55                   	push   %ebp
801039b5:	89 e5                	mov    %esp,%ebp
801039b7:	56                   	push   %esi
801039b8:	53                   	push   %ebx
801039b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801039bc:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801039bf:	83 ec 0c             	sub    $0xc,%esp
801039c2:	53                   	push   %ebx
801039c3:	e8 f8 10 00 00       	call   80104ac0 <acquire>
  if(writable){
801039c8:	83 c4 10             	add    $0x10,%esp
801039cb:	85 f6                	test   %esi,%esi
801039cd:	74 41                	je     80103a10 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801039cf:	83 ec 0c             	sub    $0xc,%esp
801039d2:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
801039d8:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801039df:	00 00 00 
    wakeup(&p->nread);
801039e2:	50                   	push   %eax
801039e3:	e8 28 0c 00 00       	call   80104610 <wakeup>
801039e8:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801039eb:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801039f1:	85 d2                	test   %edx,%edx
801039f3:	75 0a                	jne    801039ff <pipeclose+0x4f>
801039f5:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801039fb:	85 c0                	test   %eax,%eax
801039fd:	74 31                	je     80103a30 <pipeclose+0x80>
    release(&p->lock);
    cow_kfree((char*)p);
  } else
    release(&p->lock);
801039ff:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103a02:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a05:	5b                   	pop    %ebx
80103a06:	5e                   	pop    %esi
80103a07:	5d                   	pop    %ebp
    release(&p->lock);
80103a08:	e9 73 11 00 00       	jmp    80104b80 <release>
80103a0d:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103a10:	83 ec 0c             	sub    $0xc,%esp
80103a13:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103a19:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103a20:	00 00 00 
    wakeup(&p->nwrite);
80103a23:	50                   	push   %eax
80103a24:	e8 e7 0b 00 00       	call   80104610 <wakeup>
80103a29:	83 c4 10             	add    $0x10,%esp
80103a2c:	eb bd                	jmp    801039eb <pipeclose+0x3b>
80103a2e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103a30:	83 ec 0c             	sub    $0xc,%esp
80103a33:	53                   	push   %ebx
80103a34:	e8 47 11 00 00       	call   80104b80 <release>
    cow_kfree((char*)p);
80103a39:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103a3c:	83 c4 10             	add    $0x10,%esp
}
80103a3f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a42:	5b                   	pop    %ebx
80103a43:	5e                   	pop    %esi
80103a44:	5d                   	pop    %ebp
    cow_kfree((char*)p);
80103a45:	e9 56 34 00 00       	jmp    80106ea0 <cow_kfree>
80103a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a50 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103a50:	f3 0f 1e fb          	endbr32 
80103a54:	55                   	push   %ebp
80103a55:	89 e5                	mov    %esp,%ebp
80103a57:	57                   	push   %edi
80103a58:	56                   	push   %esi
80103a59:	53                   	push   %ebx
80103a5a:	83 ec 28             	sub    $0x28,%esp
80103a5d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103a60:	53                   	push   %ebx
80103a61:	e8 5a 10 00 00       	call   80104ac0 <acquire>
  for(i = 0; i < n; i++){
80103a66:	8b 45 10             	mov    0x10(%ebp),%eax
80103a69:	83 c4 10             	add    $0x10,%esp
80103a6c:	85 c0                	test   %eax,%eax
80103a6e:	0f 8e bc 00 00 00    	jle    80103b30 <pipewrite+0xe0>
80103a74:	8b 45 0c             	mov    0xc(%ebp),%eax
80103a77:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103a7d:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103a83:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103a86:	03 45 10             	add    0x10(%ebp),%eax
80103a89:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103a8c:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103a92:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103a98:	89 ca                	mov    %ecx,%edx
80103a9a:	05 00 02 00 00       	add    $0x200,%eax
80103a9f:	39 c1                	cmp    %eax,%ecx
80103aa1:	74 3b                	je     80103ade <pipewrite+0x8e>
80103aa3:	eb 63                	jmp    80103b08 <pipewrite+0xb8>
80103aa5:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103aa8:	e8 83 03 00 00       	call   80103e30 <myproc>
80103aad:	8b 48 24             	mov    0x24(%eax),%ecx
80103ab0:	85 c9                	test   %ecx,%ecx
80103ab2:	75 34                	jne    80103ae8 <pipewrite+0x98>
      wakeup(&p->nread);
80103ab4:	83 ec 0c             	sub    $0xc,%esp
80103ab7:	57                   	push   %edi
80103ab8:	e8 53 0b 00 00       	call   80104610 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103abd:	58                   	pop    %eax
80103abe:	5a                   	pop    %edx
80103abf:	53                   	push   %ebx
80103ac0:	56                   	push   %esi
80103ac1:	e8 8a 09 00 00       	call   80104450 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103ac6:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103acc:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103ad2:	83 c4 10             	add    $0x10,%esp
80103ad5:	05 00 02 00 00       	add    $0x200,%eax
80103ada:	39 c2                	cmp    %eax,%edx
80103adc:	75 2a                	jne    80103b08 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
80103ade:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103ae4:	85 c0                	test   %eax,%eax
80103ae6:	75 c0                	jne    80103aa8 <pipewrite+0x58>
        release(&p->lock);
80103ae8:	83 ec 0c             	sub    $0xc,%esp
80103aeb:	53                   	push   %ebx
80103aec:	e8 8f 10 00 00       	call   80104b80 <release>
        return -1;
80103af1:	83 c4 10             	add    $0x10,%esp
80103af4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103af9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103afc:	5b                   	pop    %ebx
80103afd:	5e                   	pop    %esi
80103afe:	5f                   	pop    %edi
80103aff:	5d                   	pop    %ebp
80103b00:	c3                   	ret    
80103b01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103b08:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103b0b:	8d 4a 01             	lea    0x1(%edx),%ecx
80103b0e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103b14:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
80103b1a:	0f b6 06             	movzbl (%esi),%eax
80103b1d:	83 c6 01             	add    $0x1,%esi
80103b20:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103b23:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103b27:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103b2a:	0f 85 5c ff ff ff    	jne    80103a8c <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103b30:	83 ec 0c             	sub    $0xc,%esp
80103b33:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103b39:	50                   	push   %eax
80103b3a:	e8 d1 0a 00 00       	call   80104610 <wakeup>
  release(&p->lock);
80103b3f:	89 1c 24             	mov    %ebx,(%esp)
80103b42:	e8 39 10 00 00       	call   80104b80 <release>
  return n;
80103b47:	8b 45 10             	mov    0x10(%ebp),%eax
80103b4a:	83 c4 10             	add    $0x10,%esp
80103b4d:	eb aa                	jmp    80103af9 <pipewrite+0xa9>
80103b4f:	90                   	nop

80103b50 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103b50:	f3 0f 1e fb          	endbr32 
80103b54:	55                   	push   %ebp
80103b55:	89 e5                	mov    %esp,%ebp
80103b57:	57                   	push   %edi
80103b58:	56                   	push   %esi
80103b59:	53                   	push   %ebx
80103b5a:	83 ec 18             	sub    $0x18,%esp
80103b5d:	8b 75 08             	mov    0x8(%ebp),%esi
80103b60:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103b63:	56                   	push   %esi
80103b64:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103b6a:	e8 51 0f 00 00       	call   80104ac0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103b6f:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103b75:	83 c4 10             	add    $0x10,%esp
80103b78:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
80103b7e:	74 33                	je     80103bb3 <piperead+0x63>
80103b80:	eb 3b                	jmp    80103bbd <piperead+0x6d>
80103b82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
80103b88:	e8 a3 02 00 00       	call   80103e30 <myproc>
80103b8d:	8b 48 24             	mov    0x24(%eax),%ecx
80103b90:	85 c9                	test   %ecx,%ecx
80103b92:	0f 85 88 00 00 00    	jne    80103c20 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103b98:	83 ec 08             	sub    $0x8,%esp
80103b9b:	56                   	push   %esi
80103b9c:	53                   	push   %ebx
80103b9d:	e8 ae 08 00 00       	call   80104450 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103ba2:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103ba8:	83 c4 10             	add    $0x10,%esp
80103bab:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103bb1:	75 0a                	jne    80103bbd <piperead+0x6d>
80103bb3:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103bb9:	85 c0                	test   %eax,%eax
80103bbb:	75 cb                	jne    80103b88 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103bbd:	8b 55 10             	mov    0x10(%ebp),%edx
80103bc0:	31 db                	xor    %ebx,%ebx
80103bc2:	85 d2                	test   %edx,%edx
80103bc4:	7f 28                	jg     80103bee <piperead+0x9e>
80103bc6:	eb 34                	jmp    80103bfc <piperead+0xac>
80103bc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bcf:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103bd0:	8d 48 01             	lea    0x1(%eax),%ecx
80103bd3:	25 ff 01 00 00       	and    $0x1ff,%eax
80103bd8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80103bde:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103be3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103be6:	83 c3 01             	add    $0x1,%ebx
80103be9:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103bec:	74 0e                	je     80103bfc <piperead+0xac>
    if(p->nread == p->nwrite)
80103bee:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103bf4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103bfa:	75 d4                	jne    80103bd0 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103bfc:	83 ec 0c             	sub    $0xc,%esp
80103bff:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103c05:	50                   	push   %eax
80103c06:	e8 05 0a 00 00       	call   80104610 <wakeup>
  release(&p->lock);
80103c0b:	89 34 24             	mov    %esi,(%esp)
80103c0e:	e8 6d 0f 00 00       	call   80104b80 <release>
  return i;
80103c13:	83 c4 10             	add    $0x10,%esp
}
80103c16:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c19:	89 d8                	mov    %ebx,%eax
80103c1b:	5b                   	pop    %ebx
80103c1c:	5e                   	pop    %esi
80103c1d:	5f                   	pop    %edi
80103c1e:	5d                   	pop    %ebp
80103c1f:	c3                   	ret    
      release(&p->lock);
80103c20:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103c23:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103c28:	56                   	push   %esi
80103c29:	e8 52 0f 00 00       	call   80104b80 <release>
      return -1;
80103c2e:	83 c4 10             	add    $0x10,%esp
}
80103c31:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c34:	89 d8                	mov    %ebx,%eax
80103c36:	5b                   	pop    %ebx
80103c37:	5e                   	pop    %esi
80103c38:	5f                   	pop    %edi
80103c39:	5d                   	pop    %ebp
80103c3a:	c3                   	ret    
80103c3b:	66 90                	xchg   %ax,%ax
80103c3d:	66 90                	xchg   %ax,%ax
80103c3f:	90                   	nop

80103c40 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103c40:	55                   	push   %ebp
80103c41:	89 e5                	mov    %esp,%ebp
80103c43:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c44:	bb d4 1d 12 80       	mov    $0x80121dd4,%ebx
{
80103c49:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103c4c:	68 a0 1d 12 80       	push   $0x80121da0
80103c51:	e8 6a 0e 00 00       	call   80104ac0 <acquire>
80103c56:	83 c4 10             	add    $0x10,%esp
80103c59:	eb 13                	jmp    80103c6e <allocproc+0x2e>
80103c5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c5f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c60:	81 c3 90 03 00 00    	add    $0x390,%ebx
80103c66:	81 fb d4 01 13 80    	cmp    $0x801301d4,%ebx
80103c6c:	74 7a                	je     80103ce8 <allocproc+0xa8>
    if(p->state == UNUSED)
80103c6e:	8b 43 0c             	mov    0xc(%ebx),%eax
80103c71:	85 c0                	test   %eax,%eax
80103c73:	75 eb                	jne    80103c60 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103c75:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80103c7a:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103c7d:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103c84:	89 43 10             	mov    %eax,0x10(%ebx)
80103c87:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103c8a:	68 a0 1d 12 80       	push   $0x80121da0
  p->pid = nextpid++;
80103c8f:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103c95:	e8 e6 0e 00 00       	call   80104b80 <release>

  // Allocate kernel stack.
  if((p->kstack = cow_kalloc()) == 0){
80103c9a:	e8 a1 32 00 00       	call   80106f40 <cow_kalloc>
80103c9f:	83 c4 10             	add    $0x10,%esp
80103ca2:	89 43 08             	mov    %eax,0x8(%ebx)
80103ca5:	85 c0                	test   %eax,%eax
80103ca7:	74 58                	je     80103d01 <allocproc+0xc1>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103ca9:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103caf:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103cb2:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103cb7:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103cba:	c7 40 14 11 5e 10 80 	movl   $0x80105e11,0x14(%eax)
  p->context = (struct context*)sp;
80103cc1:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103cc4:	6a 14                	push   $0x14
80103cc6:	6a 00                	push   $0x0
80103cc8:	50                   	push   %eax
80103cc9:	e8 02 0f 00 00       	call   80104bd0 <memset>
  p->context->eip = (uint)forkret;
80103cce:	8b 43 1c             	mov    0x1c(%ebx),%eax
      p->ram_pages[i].is_free = p->swapped_out_pages[i].is_free = 1;
    }
  }
  #endif

  return p;
80103cd1:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103cd4:	c7 40 10 20 3d 10 80 	movl   $0x80103d20,0x10(%eax)
}
80103cdb:	89 d8                	mov    %ebx,%eax
80103cdd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ce0:	c9                   	leave  
80103ce1:	c3                   	ret    
80103ce2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103ce8:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103ceb:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103ced:	68 a0 1d 12 80       	push   $0x80121da0
80103cf2:	e8 89 0e 00 00       	call   80104b80 <release>
}
80103cf7:	89 d8                	mov    %ebx,%eax
  return 0;
80103cf9:	83 c4 10             	add    $0x10,%esp
}
80103cfc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103cff:	c9                   	leave  
80103d00:	c3                   	ret    
    p->state = UNUSED;
80103d01:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103d08:	31 db                	xor    %ebx,%ebx
}
80103d0a:	89 d8                	mov    %ebx,%eax
80103d0c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d0f:	c9                   	leave  
80103d10:	c3                   	ret    
80103d11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d1f:	90                   	nop

80103d20 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103d20:	f3 0f 1e fb          	endbr32 
80103d24:	55                   	push   %ebp
80103d25:	89 e5                	mov    %esp,%ebp
80103d27:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103d2a:	68 a0 1d 12 80       	push   $0x80121da0
80103d2f:	e8 4c 0e 00 00       	call   80104b80 <release>

  if (first) {
80103d34:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103d39:	83 c4 10             	add    $0x10,%esp
80103d3c:	85 c0                	test   %eax,%eax
80103d3e:	75 08                	jne    80103d48 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103d40:	c9                   	leave  
80103d41:	c3                   	ret    
80103d42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
80103d48:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103d4f:	00 00 00 
    iinit(ROOTDEV);
80103d52:	83 ec 0c             	sub    $0xc,%esp
80103d55:	6a 01                	push   $0x1
80103d57:	e8 74 d8 ff ff       	call   801015d0 <iinit>
    initlog(ROOTDEV);
80103d5c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103d63:	e8 c8 f3 ff ff       	call   80103130 <initlog>
}
80103d68:	83 c4 10             	add    $0x10,%esp
80103d6b:	c9                   	leave  
80103d6c:	c3                   	ret    
80103d6d:	8d 76 00             	lea    0x0(%esi),%esi

80103d70 <pinit>:
{
80103d70:	f3 0f 1e fb          	endbr32 
80103d74:	55                   	push   %ebp
80103d75:	89 e5                	mov    %esp,%ebp
80103d77:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103d7a:	68 e0 85 10 80       	push   $0x801085e0
80103d7f:	68 a0 1d 12 80       	push   $0x80121da0
80103d84:	e8 b7 0b 00 00       	call   80104940 <initlock>
}
80103d89:	83 c4 10             	add    $0x10,%esp
80103d8c:	c9                   	leave  
80103d8d:	c3                   	ret    
80103d8e:	66 90                	xchg   %ax,%ax

80103d90 <mycpu>:
{
80103d90:	f3 0f 1e fb          	endbr32 
80103d94:	55                   	push   %ebp
80103d95:	89 e5                	mov    %esp,%ebp
80103d97:	56                   	push   %esi
80103d98:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d99:	9c                   	pushf  
80103d9a:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103d9b:	f6 c4 02             	test   $0x2,%ah
80103d9e:	75 57                	jne    80103df7 <mycpu+0x67>
  apicid = lapicid();
80103da0:	e8 9b ef ff ff       	call   80102d40 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103da5:	8b 35 80 1d 12 80    	mov    0x80121d80,%esi
  apicid = lapicid();
80103dab:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
80103dad:	85 f6                	test   %esi,%esi
80103daf:	7e 2c                	jle    80103ddd <mycpu+0x4d>
80103db1:	31 d2                	xor    %edx,%edx
80103db3:	eb 0a                	jmp    80103dbf <mycpu+0x2f>
80103db5:	8d 76 00             	lea    0x0(%esi),%esi
80103db8:	83 c2 01             	add    $0x1,%edx
80103dbb:	39 f2                	cmp    %esi,%edx
80103dbd:	74 1e                	je     80103ddd <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
80103dbf:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103dc5:	0f b6 81 00 18 12 80 	movzbl -0x7fede800(%ecx),%eax
80103dcc:	39 d8                	cmp    %ebx,%eax
80103dce:	75 e8                	jne    80103db8 <mycpu+0x28>
}
80103dd0:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103dd3:	8d 81 00 18 12 80    	lea    -0x7fede800(%ecx),%eax
}
80103dd9:	5b                   	pop    %ebx
80103dda:	5e                   	pop    %esi
80103ddb:	5d                   	pop    %ebp
80103ddc:	c3                   	ret    
  cprintf("The unknown apicid is %d\n", apicid);
80103ddd:	83 ec 08             	sub    $0x8,%esp
80103de0:	53                   	push   %ebx
80103de1:	68 e7 85 10 80       	push   $0x801085e7
80103de6:	e8 c5 c8 ff ff       	call   801006b0 <cprintf>
  panic("unknown apicid\n");
80103deb:	c7 04 24 01 86 10 80 	movl   $0x80108601,(%esp)
80103df2:	e8 99 c5 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103df7:	83 ec 0c             	sub    $0xc,%esp
80103dfa:	68 f0 86 10 80       	push   $0x801086f0
80103dff:	e8 8c c5 ff ff       	call   80100390 <panic>
80103e04:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e0f:	90                   	nop

80103e10 <cpuid>:
cpuid() {
80103e10:	f3 0f 1e fb          	endbr32 
80103e14:	55                   	push   %ebp
80103e15:	89 e5                	mov    %esp,%ebp
80103e17:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103e1a:	e8 71 ff ff ff       	call   80103d90 <mycpu>
}
80103e1f:	c9                   	leave  
  return mycpu()-cpus;
80103e20:	2d 00 18 12 80       	sub    $0x80121800,%eax
80103e25:	c1 f8 04             	sar    $0x4,%eax
80103e28:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103e2e:	c3                   	ret    
80103e2f:	90                   	nop

80103e30 <myproc>:
myproc(void) {
80103e30:	f3 0f 1e fb          	endbr32 
80103e34:	55                   	push   %ebp
80103e35:	89 e5                	mov    %esp,%ebp
80103e37:	53                   	push   %ebx
80103e38:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103e3b:	e8 80 0b 00 00       	call   801049c0 <pushcli>
  c = mycpu();
80103e40:	e8 4b ff ff ff       	call   80103d90 <mycpu>
  p = c->proc;
80103e45:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e4b:	e8 c0 0b 00 00       	call   80104a10 <popcli>
}
80103e50:	83 c4 04             	add    $0x4,%esp
80103e53:	89 d8                	mov    %ebx,%eax
80103e55:	5b                   	pop    %ebx
80103e56:	5d                   	pop    %ebp
80103e57:	c3                   	ret    
80103e58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e5f:	90                   	nop

80103e60 <userinit>:
{
80103e60:	f3 0f 1e fb          	endbr32 
80103e64:	55                   	push   %ebp
80103e65:	89 e5                	mov    %esp,%ebp
80103e67:	53                   	push   %ebx
80103e68:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103e6b:	e8 d0 fd ff ff       	call   80103c40 <allocproc>
80103e70:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103e72:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80103e77:	e8 84 39 00 00       	call   80107800 <setupkvm>
80103e7c:	89 43 04             	mov    %eax,0x4(%ebx)
80103e7f:	85 c0                	test   %eax,%eax
80103e81:	0f 84 bd 00 00 00    	je     80103f44 <userinit+0xe4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103e87:	83 ec 04             	sub    $0x4,%esp
80103e8a:	68 2c 00 00 00       	push   $0x2c
80103e8f:	68 60 b4 10 80       	push   $0x8010b460
80103e94:	50                   	push   %eax
80103e95:	e8 36 36 00 00       	call   801074d0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103e9a:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103e9d:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103ea3:	6a 4c                	push   $0x4c
80103ea5:	6a 00                	push   $0x0
80103ea7:	ff 73 18             	pushl  0x18(%ebx)
80103eaa:	e8 21 0d 00 00       	call   80104bd0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103eaf:	8b 43 18             	mov    0x18(%ebx),%eax
80103eb2:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103eb7:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103eba:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103ebf:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103ec3:	8b 43 18             	mov    0x18(%ebx),%eax
80103ec6:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103eca:	8b 43 18             	mov    0x18(%ebx),%eax
80103ecd:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103ed1:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103ed5:	8b 43 18             	mov    0x18(%ebx),%eax
80103ed8:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103edc:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103ee0:	8b 43 18             	mov    0x18(%ebx),%eax
80103ee3:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103eea:	8b 43 18             	mov    0x18(%ebx),%eax
80103eed:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103ef4:	8b 43 18             	mov    0x18(%ebx),%eax
80103ef7:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103efe:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103f01:	6a 10                	push   $0x10
80103f03:	68 2a 86 10 80       	push   $0x8010862a
80103f08:	50                   	push   %eax
80103f09:	e8 82 0e 00 00       	call   80104d90 <safestrcpy>
  p->cwd = namei("/");
80103f0e:	c7 04 24 33 86 10 80 	movl   $0x80108633,(%esp)
80103f15:	e8 a6 e1 ff ff       	call   801020c0 <namei>
80103f1a:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103f1d:	c7 04 24 a0 1d 12 80 	movl   $0x80121da0,(%esp)
80103f24:	e8 97 0b 00 00       	call   80104ac0 <acquire>
  p->state = RUNNABLE;
80103f29:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103f30:	c7 04 24 a0 1d 12 80 	movl   $0x80121da0,(%esp)
80103f37:	e8 44 0c 00 00       	call   80104b80 <release>
}
80103f3c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f3f:	83 c4 10             	add    $0x10,%esp
80103f42:	c9                   	leave  
80103f43:	c3                   	ret    
    panic("userinit: out of memory?");
80103f44:	83 ec 0c             	sub    $0xc,%esp
80103f47:	68 11 86 10 80       	push   $0x80108611
80103f4c:	e8 3f c4 ff ff       	call   80100390 <panic>
80103f51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f5f:	90                   	nop

80103f60 <growproc>:
{
80103f60:	f3 0f 1e fb          	endbr32 
80103f64:	55                   	push   %ebp
80103f65:	89 e5                	mov    %esp,%ebp
80103f67:	56                   	push   %esi
80103f68:	53                   	push   %ebx
80103f69:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103f6c:	e8 4f 0a 00 00       	call   801049c0 <pushcli>
  c = mycpu();
80103f71:	e8 1a fe ff ff       	call   80103d90 <mycpu>
  p = c->proc;
80103f76:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f7c:	e8 8f 0a 00 00       	call   80104a10 <popcli>
  sz = curproc->sz;
80103f81:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103f83:	85 f6                	test   %esi,%esi
80103f85:	7f 19                	jg     80103fa0 <growproc+0x40>
  } else if(n < 0){
80103f87:	75 37                	jne    80103fc0 <growproc+0x60>
  switchuvm(curproc);
80103f89:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103f8c:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103f8e:	53                   	push   %ebx
80103f8f:	e8 2c 34 00 00       	call   801073c0 <switchuvm>
  return 0;
80103f94:	83 c4 10             	add    $0x10,%esp
80103f97:	31 c0                	xor    %eax,%eax
}
80103f99:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f9c:	5b                   	pop    %ebx
80103f9d:	5e                   	pop    %esi
80103f9e:	5d                   	pop    %ebp
80103f9f:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103fa0:	83 ec 04             	sub    $0x4,%esp
80103fa3:	01 c6                	add    %eax,%esi
80103fa5:	56                   	push   %esi
80103fa6:	50                   	push   %eax
80103fa7:	ff 73 04             	pushl  0x4(%ebx)
80103faa:	e8 71 36 00 00       	call   80107620 <allocuvm>
80103faf:	83 c4 10             	add    $0x10,%esp
80103fb2:	85 c0                	test   %eax,%eax
80103fb4:	75 d3                	jne    80103f89 <growproc+0x29>
      return -1;
80103fb6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103fbb:	eb dc                	jmp    80103f99 <growproc+0x39>
80103fbd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103fc0:	83 ec 04             	sub    $0x4,%esp
80103fc3:	01 c6                	add    %eax,%esi
80103fc5:	56                   	push   %esi
80103fc6:	50                   	push   %eax
80103fc7:	ff 73 04             	pushl  0x4(%ebx)
80103fca:	e8 81 37 00 00       	call   80107750 <deallocuvm>
80103fcf:	83 c4 10             	add    $0x10,%esp
80103fd2:	85 c0                	test   %eax,%eax
80103fd4:	75 b3                	jne    80103f89 <growproc+0x29>
80103fd6:	eb de                	jmp    80103fb6 <growproc+0x56>
80103fd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fdf:	90                   	nop

80103fe0 <sys_get_number_of_free_pages_impl>:
int sys_get_number_of_free_pages_impl(void){
80103fe0:	f3 0f 1e fb          	endbr32 
  for (int i = 0; i < PHYSTOP / PGSIZE; i++){
80103fe4:	31 c0                	xor    %eax,%eax
  int count = 0;
80103fe6:	31 d2                	xor    %edx,%edx
80103fe8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fef:	90                   	nop
      count++;
80103ff0:	80 b8 40 0f 11 80 01 	cmpb   $0x1,-0x7feef0c0(%eax)
80103ff7:	83 da ff             	sbb    $0xffffffff,%edx
  for (int i = 0; i < PHYSTOP / PGSIZE; i++){
80103ffa:	83 c0 01             	add    $0x1,%eax
80103ffd:	3d 00 e0 00 00       	cmp    $0xe000,%eax
80104002:	75 ec                	jne    80103ff0 <sys_get_number_of_free_pages_impl+0x10>
  return (PHYSTOP/PGSIZE) - count;
80104004:	29 d0                	sub    %edx,%eax
}
80104006:	c3                   	ret    
80104007:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010400e:	66 90                	xchg   %ax,%ax

80104010 <fork>:
{
80104010:	f3 0f 1e fb          	endbr32 
80104014:	55                   	push   %ebp
80104015:	89 e5                	mov    %esp,%ebp
80104017:	57                   	push   %edi
80104018:	56                   	push   %esi
80104019:	53                   	push   %ebx
8010401a:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
8010401d:	e8 9e 09 00 00       	call   801049c0 <pushcli>
  c = mycpu();
80104022:	e8 69 fd ff ff       	call   80103d90 <mycpu>
  p = c->proc;
80104027:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010402d:	e8 de 09 00 00       	call   80104a10 <popcli>
  if((np = allocproc()) == 0){
80104032:	e8 09 fc ff ff       	call   80103c40 <allocproc>
80104037:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010403a:	85 c0                	test   %eax,%eax
8010403c:	0f 84 eb 00 00 00    	je     8010412d <fork+0x11d>
  cprintf("pages : %d, curproc size : %d\n", 57344 - sys_get_number_of_free_pages_impl(), curproc->sz);
80104042:	8b 0b                	mov    (%ebx),%ecx
  int count = 0;
80104044:	31 d2                	xor    %edx,%edx
  for (int i = 0; i < PHYSTOP / PGSIZE; i++){
80104046:	31 c0                	xor    %eax,%eax
80104048:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010404f:	90                   	nop
      count++;
80104050:	80 b8 40 0f 11 80 01 	cmpb   $0x1,-0x7feef0c0(%eax)
80104057:	83 da ff             	sbb    $0xffffffff,%edx
  for (int i = 0; i < PHYSTOP / PGSIZE; i++){
8010405a:	83 c0 01             	add    $0x1,%eax
8010405d:	3d 00 e0 00 00       	cmp    $0xe000,%eax
80104062:	75 ec                	jne    80104050 <fork+0x40>
  cprintf("pages : %d, curproc size : %d\n", 57344 - sys_get_number_of_free_pages_impl(), curproc->sz);
80104064:	83 ec 04             	sub    $0x4,%esp
80104067:	51                   	push   %ecx
80104068:	52                   	push   %edx
80104069:	68 18 87 10 80       	push   $0x80108718
8010406e:	e8 3d c6 ff ff       	call   801006b0 <cprintf>
  if((np->pgdir = cow_copyuvm(curproc->pgdir, curproc->sz)) == 0){ // (np->pid > 2 ? cow_copyuvm : copyuvm)
80104073:	58                   	pop    %eax
80104074:	5a                   	pop    %edx
80104075:	ff 33                	pushl  (%ebx)
80104077:	ff 73 04             	pushl  0x4(%ebx)
8010407a:	e8 51 38 00 00       	call   801078d0 <cow_copyuvm>
8010407f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104082:	83 c4 10             	add    $0x10,%esp
80104085:	89 41 04             	mov    %eax,0x4(%ecx)
80104088:	85 c0                	test   %eax,%eax
8010408a:	0f 84 a4 00 00 00    	je     80104134 <fork+0x124>
  np->sz = curproc->sz;
80104090:	8b 03                	mov    (%ebx),%eax
80104092:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  *np->tf = *curproc->tf;
80104095:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->sz = curproc->sz;
8010409a:	89 07                	mov    %eax,(%edi)
  np->parent = curproc;
8010409c:	89 f8                	mov    %edi,%eax
8010409e:	89 5f 14             	mov    %ebx,0x14(%edi)
  *np->tf = *curproc->tf;
801040a1:	8b 7f 18             	mov    0x18(%edi),%edi
801040a4:	8b 73 18             	mov    0x18(%ebx),%esi
801040a7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
801040a9:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
801040ab:	8b 40 18             	mov    0x18(%eax),%eax
801040ae:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
801040b5:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[i])
801040b8:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801040bc:	85 c0                	test   %eax,%eax
801040be:	74 13                	je     801040d3 <fork+0xc3>
      np->ofile[i] = filedup(curproc->ofile[i]);
801040c0:	83 ec 0c             	sub    $0xc,%esp
801040c3:	50                   	push   %eax
801040c4:	e8 37 ce ff ff       	call   80100f00 <filedup>
801040c9:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801040cc:	83 c4 10             	add    $0x10,%esp
801040cf:	89 44 b1 28          	mov    %eax,0x28(%ecx,%esi,4)
  for(i = 0; i < NOFILE; i++)
801040d3:	83 c6 01             	add    $0x1,%esi
801040d6:	83 fe 10             	cmp    $0x10,%esi
801040d9:	75 dd                	jne    801040b8 <fork+0xa8>
  np->cwd = idup(curproc->cwd);
801040db:	83 ec 0c             	sub    $0xc,%esp
801040de:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801040e1:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
801040e4:	e8 d7 d6 ff ff       	call   801017c0 <idup>
801040e9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801040ec:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
801040ef:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801040f2:	8d 47 6c             	lea    0x6c(%edi),%eax
801040f5:	6a 10                	push   $0x10
801040f7:	53                   	push   %ebx
801040f8:	50                   	push   %eax
801040f9:	e8 92 0c 00 00       	call   80104d90 <safestrcpy>
  pid = np->pid;
801040fe:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104101:	c7 04 24 a0 1d 12 80 	movl   $0x80121da0,(%esp)
80104108:	e8 b3 09 00 00       	call   80104ac0 <acquire>
  np->state = RUNNABLE;
8010410d:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80104114:	c7 04 24 a0 1d 12 80 	movl   $0x80121da0,(%esp)
8010411b:	e8 60 0a 00 00       	call   80104b80 <release>
  return pid;
80104120:	83 c4 10             	add    $0x10,%esp
}
80104123:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104126:	89 d8                	mov    %ebx,%eax
80104128:	5b                   	pop    %ebx
80104129:	5e                   	pop    %esi
8010412a:	5f                   	pop    %edi
8010412b:	5d                   	pop    %ebp
8010412c:	c3                   	ret    
    return -1;
8010412d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104132:	eb ef                	jmp    80104123 <fork+0x113>
    cow_kfree(np->kstack);
80104134:	83 ec 0c             	sub    $0xc,%esp
80104137:	ff 71 08             	pushl  0x8(%ecx)
8010413a:	89 cf                	mov    %ecx,%edi
    return -1;
8010413c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    cow_kfree(np->kstack);
80104141:	e8 5a 2d 00 00       	call   80106ea0 <cow_kfree>
    np->kstack = 0;
80104146:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    return -1;
8010414d:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80104150:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80104157:	eb ca                	jmp    80104123 <fork+0x113>
80104159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104160 <scheduler>:
{
80104160:	f3 0f 1e fb          	endbr32 
80104164:	55                   	push   %ebp
80104165:	89 e5                	mov    %esp,%ebp
80104167:	57                   	push   %edi
80104168:	56                   	push   %esi
80104169:	53                   	push   %ebx
8010416a:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
8010416d:	e8 1e fc ff ff       	call   80103d90 <mycpu>
  c->proc = 0;
80104172:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104179:	00 00 00 
  struct cpu *c = mycpu();
8010417c:	89 c6                	mov    %eax,%esi
  c->proc = 0;
8010417e:	8d 78 04             	lea    0x4(%eax),%edi
80104181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80104188:	fb                   	sti    
    acquire(&ptable.lock);
80104189:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010418c:	bb d4 1d 12 80       	mov    $0x80121dd4,%ebx
    acquire(&ptable.lock);
80104191:	68 a0 1d 12 80       	push   $0x80121da0
80104196:	e8 25 09 00 00       	call   80104ac0 <acquire>
8010419b:	83 c4 10             	add    $0x10,%esp
8010419e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
801041a0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801041a4:	75 33                	jne    801041d9 <scheduler+0x79>
      switchuvm(p);
801041a6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
801041a9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
801041af:	53                   	push   %ebx
801041b0:	e8 0b 32 00 00       	call   801073c0 <switchuvm>
      swtch(&(c->scheduler), p->context);
801041b5:	58                   	pop    %eax
801041b6:	5a                   	pop    %edx
801041b7:	ff 73 1c             	pushl  0x1c(%ebx)
801041ba:	57                   	push   %edi
      p->state = RUNNING;
801041bb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
801041c2:	e8 2c 0c 00 00       	call   80104df3 <swtch>
      switchkvm();
801041c7:	e8 d4 31 00 00       	call   801073a0 <switchkvm>
      c->proc = 0;
801041cc:	83 c4 10             	add    $0x10,%esp
801041cf:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801041d6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041d9:	81 c3 90 03 00 00    	add    $0x390,%ebx
801041df:	81 fb d4 01 13 80    	cmp    $0x801301d4,%ebx
801041e5:	75 b9                	jne    801041a0 <scheduler+0x40>
    release(&ptable.lock);
801041e7:	83 ec 0c             	sub    $0xc,%esp
801041ea:	68 a0 1d 12 80       	push   $0x80121da0
801041ef:	e8 8c 09 00 00       	call   80104b80 <release>
    sti();
801041f4:	83 c4 10             	add    $0x10,%esp
801041f7:	eb 8f                	jmp    80104188 <scheduler+0x28>
801041f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104200 <sched>:
{
80104200:	f3 0f 1e fb          	endbr32 
80104204:	55                   	push   %ebp
80104205:	89 e5                	mov    %esp,%ebp
80104207:	56                   	push   %esi
80104208:	53                   	push   %ebx
  pushcli();
80104209:	e8 b2 07 00 00       	call   801049c0 <pushcli>
  c = mycpu();
8010420e:	e8 7d fb ff ff       	call   80103d90 <mycpu>
  p = c->proc;
80104213:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104219:	e8 f2 07 00 00       	call   80104a10 <popcli>
  if(!holding(&ptable.lock))
8010421e:	83 ec 0c             	sub    $0xc,%esp
80104221:	68 a0 1d 12 80       	push   $0x80121da0
80104226:	e8 45 08 00 00       	call   80104a70 <holding>
8010422b:	83 c4 10             	add    $0x10,%esp
8010422e:	85 c0                	test   %eax,%eax
80104230:	74 4f                	je     80104281 <sched+0x81>
  if(mycpu()->ncli != 1)
80104232:	e8 59 fb ff ff       	call   80103d90 <mycpu>
80104237:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010423e:	75 68                	jne    801042a8 <sched+0xa8>
  if(p->state == RUNNING)
80104240:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104244:	74 55                	je     8010429b <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104246:	9c                   	pushf  
80104247:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104248:	f6 c4 02             	test   $0x2,%ah
8010424b:	75 41                	jne    8010428e <sched+0x8e>
  intena = mycpu()->intena;
8010424d:	e8 3e fb ff ff       	call   80103d90 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80104252:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104255:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
8010425b:	e8 30 fb ff ff       	call   80103d90 <mycpu>
80104260:	83 ec 08             	sub    $0x8,%esp
80104263:	ff 70 04             	pushl  0x4(%eax)
80104266:	53                   	push   %ebx
80104267:	e8 87 0b 00 00       	call   80104df3 <swtch>
  mycpu()->intena = intena;
8010426c:	e8 1f fb ff ff       	call   80103d90 <mycpu>
}
80104271:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104274:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
8010427a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010427d:	5b                   	pop    %ebx
8010427e:	5e                   	pop    %esi
8010427f:	5d                   	pop    %ebp
80104280:	c3                   	ret    
    panic("sched ptable.lock");
80104281:	83 ec 0c             	sub    $0xc,%esp
80104284:	68 35 86 10 80       	push   $0x80108635
80104289:	e8 02 c1 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010428e:	83 ec 0c             	sub    $0xc,%esp
80104291:	68 61 86 10 80       	push   $0x80108661
80104296:	e8 f5 c0 ff ff       	call   80100390 <panic>
    panic("sched running");
8010429b:	83 ec 0c             	sub    $0xc,%esp
8010429e:	68 53 86 10 80       	push   $0x80108653
801042a3:	e8 e8 c0 ff ff       	call   80100390 <panic>
    panic("sched locks");
801042a8:	83 ec 0c             	sub    $0xc,%esp
801042ab:	68 47 86 10 80       	push   $0x80108647
801042b0:	e8 db c0 ff ff       	call   80100390 <panic>
801042b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801042c0 <exit>:
{
801042c0:	f3 0f 1e fb          	endbr32 
801042c4:	55                   	push   %ebp
801042c5:	89 e5                	mov    %esp,%ebp
801042c7:	57                   	push   %edi
801042c8:	56                   	push   %esi
801042c9:	53                   	push   %ebx
801042ca:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
801042cd:	e8 ee 06 00 00       	call   801049c0 <pushcli>
  c = mycpu();
801042d2:	e8 b9 fa ff ff       	call   80103d90 <mycpu>
  p = c->proc;
801042d7:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801042dd:	e8 2e 07 00 00       	call   80104a10 <popcli>
  if(curproc == initproc)
801042e2:	8d 5e 28             	lea    0x28(%esi),%ebx
801042e5:	8d 7e 68             	lea    0x68(%esi),%edi
801042e8:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
801042ee:	0f 84 fd 00 00 00    	je     801043f1 <exit+0x131>
801042f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
801042f8:	8b 03                	mov    (%ebx),%eax
801042fa:	85 c0                	test   %eax,%eax
801042fc:	74 12                	je     80104310 <exit+0x50>
      fileclose(curproc->ofile[fd]);
801042fe:	83 ec 0c             	sub    $0xc,%esp
80104301:	50                   	push   %eax
80104302:	e8 49 cc ff ff       	call   80100f50 <fileclose>
      curproc->ofile[fd] = 0;
80104307:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010430d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104310:	83 c3 04             	add    $0x4,%ebx
80104313:	39 df                	cmp    %ebx,%edi
80104315:	75 e1                	jne    801042f8 <exit+0x38>
  begin_op();
80104317:	e8 b4 ee ff ff       	call   801031d0 <begin_op>
  iput(curproc->cwd);
8010431c:	83 ec 0c             	sub    $0xc,%esp
8010431f:	ff 76 68             	pushl  0x68(%esi)
80104322:	e8 f9 d5 ff ff       	call   80101920 <iput>
  end_op();
80104327:	e8 14 ef ff ff       	call   80103240 <end_op>
  curproc->cwd = 0;
8010432c:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80104333:	c7 04 24 a0 1d 12 80 	movl   $0x80121da0,(%esp)
8010433a:	e8 81 07 00 00       	call   80104ac0 <acquire>
  wakeup1(curproc->parent);
8010433f:	8b 56 14             	mov    0x14(%esi),%edx
80104342:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104345:	b8 d4 1d 12 80       	mov    $0x80121dd4,%eax
8010434a:	eb 10                	jmp    8010435c <exit+0x9c>
8010434c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104350:	05 90 03 00 00       	add    $0x390,%eax
80104355:	3d d4 01 13 80       	cmp    $0x801301d4,%eax
8010435a:	74 1e                	je     8010437a <exit+0xba>
    if(p->state == SLEEPING && p->chan == chan)
8010435c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104360:	75 ee                	jne    80104350 <exit+0x90>
80104362:	3b 50 20             	cmp    0x20(%eax),%edx
80104365:	75 e9                	jne    80104350 <exit+0x90>
      p->state = RUNNABLE;
80104367:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010436e:	05 90 03 00 00       	add    $0x390,%eax
80104373:	3d d4 01 13 80       	cmp    $0x801301d4,%eax
80104378:	75 e2                	jne    8010435c <exit+0x9c>
      p->parent = initproc;
8010437a:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104380:	ba d4 1d 12 80       	mov    $0x80121dd4,%edx
80104385:	eb 17                	jmp    8010439e <exit+0xde>
80104387:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010438e:	66 90                	xchg   %ax,%ax
80104390:	81 c2 90 03 00 00    	add    $0x390,%edx
80104396:	81 fa d4 01 13 80    	cmp    $0x801301d4,%edx
8010439c:	74 3a                	je     801043d8 <exit+0x118>
    if(p->parent == curproc){
8010439e:	39 72 14             	cmp    %esi,0x14(%edx)
801043a1:	75 ed                	jne    80104390 <exit+0xd0>
      if(p->state == ZOMBIE)
801043a3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
801043a7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801043aa:	75 e4                	jne    80104390 <exit+0xd0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043ac:	b8 d4 1d 12 80       	mov    $0x80121dd4,%eax
801043b1:	eb 11                	jmp    801043c4 <exit+0x104>
801043b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043b7:	90                   	nop
801043b8:	05 90 03 00 00       	add    $0x390,%eax
801043bd:	3d d4 01 13 80       	cmp    $0x801301d4,%eax
801043c2:	74 cc                	je     80104390 <exit+0xd0>
    if(p->state == SLEEPING && p->chan == chan)
801043c4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801043c8:	75 ee                	jne    801043b8 <exit+0xf8>
801043ca:	3b 48 20             	cmp    0x20(%eax),%ecx
801043cd:	75 e9                	jne    801043b8 <exit+0xf8>
      p->state = RUNNABLE;
801043cf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801043d6:	eb e0                	jmp    801043b8 <exit+0xf8>
  curproc->state = ZOMBIE;
801043d8:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
801043df:	e8 1c fe ff ff       	call   80104200 <sched>
  panic("zombie exit");
801043e4:	83 ec 0c             	sub    $0xc,%esp
801043e7:	68 82 86 10 80       	push   $0x80108682
801043ec:	e8 9f bf ff ff       	call   80100390 <panic>
    panic("init exiting");
801043f1:	83 ec 0c             	sub    $0xc,%esp
801043f4:	68 75 86 10 80       	push   $0x80108675
801043f9:	e8 92 bf ff ff       	call   80100390 <panic>
801043fe:	66 90                	xchg   %ax,%ax

80104400 <yield>:
{
80104400:	f3 0f 1e fb          	endbr32 
80104404:	55                   	push   %ebp
80104405:	89 e5                	mov    %esp,%ebp
80104407:	53                   	push   %ebx
80104408:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
8010440b:	68 a0 1d 12 80       	push   $0x80121da0
80104410:	e8 ab 06 00 00       	call   80104ac0 <acquire>
  pushcli();
80104415:	e8 a6 05 00 00       	call   801049c0 <pushcli>
  c = mycpu();
8010441a:	e8 71 f9 ff ff       	call   80103d90 <mycpu>
  p = c->proc;
8010441f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104425:	e8 e6 05 00 00       	call   80104a10 <popcli>
  myproc()->state = RUNNABLE;
8010442a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80104431:	e8 ca fd ff ff       	call   80104200 <sched>
  release(&ptable.lock);
80104436:	c7 04 24 a0 1d 12 80 	movl   $0x80121da0,(%esp)
8010443d:	e8 3e 07 00 00       	call   80104b80 <release>
}
80104442:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104445:	83 c4 10             	add    $0x10,%esp
80104448:	c9                   	leave  
80104449:	c3                   	ret    
8010444a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104450 <sleep>:
{
80104450:	f3 0f 1e fb          	endbr32 
80104454:	55                   	push   %ebp
80104455:	89 e5                	mov    %esp,%ebp
80104457:	57                   	push   %edi
80104458:	56                   	push   %esi
80104459:	53                   	push   %ebx
8010445a:	83 ec 0c             	sub    $0xc,%esp
8010445d:	8b 7d 08             	mov    0x8(%ebp),%edi
80104460:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104463:	e8 58 05 00 00       	call   801049c0 <pushcli>
  c = mycpu();
80104468:	e8 23 f9 ff ff       	call   80103d90 <mycpu>
  p = c->proc;
8010446d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104473:	e8 98 05 00 00       	call   80104a10 <popcli>
  if(p == 0)
80104478:	85 db                	test   %ebx,%ebx
8010447a:	0f 84 83 00 00 00    	je     80104503 <sleep+0xb3>
  if(lk == 0)
80104480:	85 f6                	test   %esi,%esi
80104482:	74 72                	je     801044f6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104484:	81 fe a0 1d 12 80    	cmp    $0x80121da0,%esi
8010448a:	74 4c                	je     801044d8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
8010448c:	83 ec 0c             	sub    $0xc,%esp
8010448f:	68 a0 1d 12 80       	push   $0x80121da0
80104494:	e8 27 06 00 00       	call   80104ac0 <acquire>
    release(lk);
80104499:	89 34 24             	mov    %esi,(%esp)
8010449c:	e8 df 06 00 00       	call   80104b80 <release>
  p->chan = chan;
801044a1:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801044a4:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801044ab:	e8 50 fd ff ff       	call   80104200 <sched>
  p->chan = 0;
801044b0:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801044b7:	c7 04 24 a0 1d 12 80 	movl   $0x80121da0,(%esp)
801044be:	e8 bd 06 00 00       	call   80104b80 <release>
    acquire(lk);
801044c3:	89 75 08             	mov    %esi,0x8(%ebp)
801044c6:	83 c4 10             	add    $0x10,%esp
}
801044c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044cc:	5b                   	pop    %ebx
801044cd:	5e                   	pop    %esi
801044ce:	5f                   	pop    %edi
801044cf:	5d                   	pop    %ebp
    acquire(lk);
801044d0:	e9 eb 05 00 00       	jmp    80104ac0 <acquire>
801044d5:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
801044d8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801044db:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801044e2:	e8 19 fd ff ff       	call   80104200 <sched>
  p->chan = 0;
801044e7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801044ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044f1:	5b                   	pop    %ebx
801044f2:	5e                   	pop    %esi
801044f3:	5f                   	pop    %edi
801044f4:	5d                   	pop    %ebp
801044f5:	c3                   	ret    
    panic("sleep without lk");
801044f6:	83 ec 0c             	sub    $0xc,%esp
801044f9:	68 94 86 10 80       	push   $0x80108694
801044fe:	e8 8d be ff ff       	call   80100390 <panic>
    panic("sleep");
80104503:	83 ec 0c             	sub    $0xc,%esp
80104506:	68 8e 86 10 80       	push   $0x8010868e
8010450b:	e8 80 be ff ff       	call   80100390 <panic>

80104510 <wait>:
{
80104510:	f3 0f 1e fb          	endbr32 
80104514:	55                   	push   %ebp
80104515:	89 e5                	mov    %esp,%ebp
80104517:	56                   	push   %esi
80104518:	53                   	push   %ebx
  pushcli();
80104519:	e8 a2 04 00 00       	call   801049c0 <pushcli>
  c = mycpu();
8010451e:	e8 6d f8 ff ff       	call   80103d90 <mycpu>
  p = c->proc;
80104523:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104529:	e8 e2 04 00 00       	call   80104a10 <popcli>
  acquire(&ptable.lock);
8010452e:	83 ec 0c             	sub    $0xc,%esp
80104531:	68 a0 1d 12 80       	push   $0x80121da0
80104536:	e8 85 05 00 00       	call   80104ac0 <acquire>
8010453b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010453e:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104540:	bb d4 1d 12 80       	mov    $0x80121dd4,%ebx
80104545:	eb 17                	jmp    8010455e <wait+0x4e>
80104547:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010454e:	66 90                	xchg   %ax,%ax
80104550:	81 c3 90 03 00 00    	add    $0x390,%ebx
80104556:	81 fb d4 01 13 80    	cmp    $0x801301d4,%ebx
8010455c:	74 1e                	je     8010457c <wait+0x6c>
      if(p->parent != curproc)
8010455e:	39 73 14             	cmp    %esi,0x14(%ebx)
80104561:	75 ed                	jne    80104550 <wait+0x40>
      if(p->state == ZOMBIE){
80104563:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104567:	74 37                	je     801045a0 <wait+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104569:	81 c3 90 03 00 00    	add    $0x390,%ebx
      havekids = 1;
8010456f:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104574:	81 fb d4 01 13 80    	cmp    $0x801301d4,%ebx
8010457a:	75 e2                	jne    8010455e <wait+0x4e>
    if(!havekids || curproc->killed){
8010457c:	85 c0                	test   %eax,%eax
8010457e:	74 76                	je     801045f6 <wait+0xe6>
80104580:	8b 46 24             	mov    0x24(%esi),%eax
80104583:	85 c0                	test   %eax,%eax
80104585:	75 6f                	jne    801045f6 <wait+0xe6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104587:	83 ec 08             	sub    $0x8,%esp
8010458a:	68 a0 1d 12 80       	push   $0x80121da0
8010458f:	56                   	push   %esi
80104590:	e8 bb fe ff ff       	call   80104450 <sleep>
    havekids = 0;
80104595:	83 c4 10             	add    $0x10,%esp
80104598:	eb a4                	jmp    8010453e <wait+0x2e>
8010459a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        cow_kfree(p->kstack);
801045a0:	83 ec 0c             	sub    $0xc,%esp
801045a3:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
801045a6:	8b 73 10             	mov    0x10(%ebx),%esi
        cow_kfree(p->kstack);
801045a9:	e8 f2 28 00 00       	call   80106ea0 <cow_kfree>
        freevm(p->pgdir);
801045ae:	5a                   	pop    %edx
801045af:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
801045b2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801045b9:	e8 c2 31 00 00       	call   80107780 <freevm>
        release(&ptable.lock);
801045be:	c7 04 24 a0 1d 12 80 	movl   $0x80121da0,(%esp)
        p->pid = 0;
801045c5:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801045cc:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801045d3:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801045d7:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801045de:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801045e5:	e8 96 05 00 00       	call   80104b80 <release>
        return pid;
801045ea:	83 c4 10             	add    $0x10,%esp
}
801045ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045f0:	89 f0                	mov    %esi,%eax
801045f2:	5b                   	pop    %ebx
801045f3:	5e                   	pop    %esi
801045f4:	5d                   	pop    %ebp
801045f5:	c3                   	ret    
      release(&ptable.lock);
801045f6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801045f9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801045fe:	68 a0 1d 12 80       	push   $0x80121da0
80104603:	e8 78 05 00 00       	call   80104b80 <release>
      return -1;
80104608:	83 c4 10             	add    $0x10,%esp
8010460b:	eb e0                	jmp    801045ed <wait+0xdd>
8010460d:	8d 76 00             	lea    0x0(%esi),%esi

80104610 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104610:	f3 0f 1e fb          	endbr32 
80104614:	55                   	push   %ebp
80104615:	89 e5                	mov    %esp,%ebp
80104617:	53                   	push   %ebx
80104618:	83 ec 10             	sub    $0x10,%esp
8010461b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010461e:	68 a0 1d 12 80       	push   $0x80121da0
80104623:	e8 98 04 00 00       	call   80104ac0 <acquire>
80104628:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010462b:	b8 d4 1d 12 80       	mov    $0x80121dd4,%eax
80104630:	eb 12                	jmp    80104644 <wakeup+0x34>
80104632:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104638:	05 90 03 00 00       	add    $0x390,%eax
8010463d:	3d d4 01 13 80       	cmp    $0x801301d4,%eax
80104642:	74 1e                	je     80104662 <wakeup+0x52>
    if(p->state == SLEEPING && p->chan == chan)
80104644:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104648:	75 ee                	jne    80104638 <wakeup+0x28>
8010464a:	3b 58 20             	cmp    0x20(%eax),%ebx
8010464d:	75 e9                	jne    80104638 <wakeup+0x28>
      p->state = RUNNABLE;
8010464f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104656:	05 90 03 00 00       	add    $0x390,%eax
8010465b:	3d d4 01 13 80       	cmp    $0x801301d4,%eax
80104660:	75 e2                	jne    80104644 <wakeup+0x34>
  wakeup1(chan);
  release(&ptable.lock);
80104662:	c7 45 08 a0 1d 12 80 	movl   $0x80121da0,0x8(%ebp)
}
80104669:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010466c:	c9                   	leave  
  release(&ptable.lock);
8010466d:	e9 0e 05 00 00       	jmp    80104b80 <release>
80104672:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104680 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104680:	f3 0f 1e fb          	endbr32 
80104684:	55                   	push   %ebp
80104685:	89 e5                	mov    %esp,%ebp
80104687:	53                   	push   %ebx
80104688:	83 ec 10             	sub    $0x10,%esp
8010468b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010468e:	68 a0 1d 12 80       	push   $0x80121da0
80104693:	e8 28 04 00 00       	call   80104ac0 <acquire>
80104698:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010469b:	b8 d4 1d 12 80       	mov    $0x80121dd4,%eax
801046a0:	eb 12                	jmp    801046b4 <kill+0x34>
801046a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801046a8:	05 90 03 00 00       	add    $0x390,%eax
801046ad:	3d d4 01 13 80       	cmp    $0x801301d4,%eax
801046b2:	74 34                	je     801046e8 <kill+0x68>
    if(p->pid == pid){
801046b4:	39 58 10             	cmp    %ebx,0x10(%eax)
801046b7:	75 ef                	jne    801046a8 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801046b9:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801046bd:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801046c4:	75 07                	jne    801046cd <kill+0x4d>
        p->state = RUNNABLE;
801046c6:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801046cd:	83 ec 0c             	sub    $0xc,%esp
801046d0:	68 a0 1d 12 80       	push   $0x80121da0
801046d5:	e8 a6 04 00 00       	call   80104b80 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801046da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801046dd:	83 c4 10             	add    $0x10,%esp
801046e0:	31 c0                	xor    %eax,%eax
}
801046e2:	c9                   	leave  
801046e3:	c3                   	ret    
801046e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
801046e8:	83 ec 0c             	sub    $0xc,%esp
801046eb:	68 a0 1d 12 80       	push   $0x80121da0
801046f0:	e8 8b 04 00 00       	call   80104b80 <release>
}
801046f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801046f8:	83 c4 10             	add    $0x10,%esp
801046fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104700:	c9                   	leave  
80104701:	c3                   	ret    
80104702:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104710 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104710:	f3 0f 1e fb          	endbr32 
80104714:	55                   	push   %ebp
80104715:	89 e5                	mov    %esp,%ebp
80104717:	57                   	push   %edi
80104718:	56                   	push   %esi
80104719:	8d 75 e8             	lea    -0x18(%ebp),%esi
8010471c:	53                   	push   %ebx
8010471d:	bb 40 1e 12 80       	mov    $0x80121e40,%ebx
80104722:	83 ec 3c             	sub    $0x3c,%esp
80104725:	eb 2b                	jmp    80104752 <procdump+0x42>
80104727:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010472e:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104730:	83 ec 0c             	sub    $0xc,%esp
80104733:	68 7b 8b 10 80       	push   $0x80108b7b
80104738:	e8 73 bf ff ff       	call   801006b0 <cprintf>
8010473d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104740:	81 c3 90 03 00 00    	add    $0x390,%ebx
80104746:	81 fb 40 02 13 80    	cmp    $0x80130240,%ebx
8010474c:	0f 84 9e 00 00 00    	je     801047f0 <procdump+0xe0>
    if(p->state == UNUSED)
80104752:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104755:	85 c0                	test   %eax,%eax
80104757:	74 e7                	je     80104740 <procdump+0x30>
      state = "???";
80104759:	ba a5 86 10 80       	mov    $0x801086a5,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010475e:	83 f8 05             	cmp    $0x5,%eax
80104761:	77 11                	ja     80104774 <procdump+0x64>
80104763:	8b 14 85 38 87 10 80 	mov    -0x7fef78c8(,%eax,4),%edx
      state = "???";
8010476a:	b8 a5 86 10 80       	mov    $0x801086a5,%eax
8010476f:	85 d2                	test   %edx,%edx
80104771:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s RAM: %d SWAP: %d", p->pid, state, p->name, p->num_of_actual_pages_in_mem, p->num_of_pages_in_swap_file);
80104774:	83 ec 08             	sub    $0x8,%esp
80104777:	ff b3 14 03 00 00    	pushl  0x314(%ebx)
8010477d:	ff b3 18 03 00 00    	pushl  0x318(%ebx)
80104783:	53                   	push   %ebx
80104784:	52                   	push   %edx
80104785:	ff 73 a4             	pushl  -0x5c(%ebx)
80104788:	68 a9 86 10 80       	push   $0x801086a9
8010478d:	e8 1e bf ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
80104792:	83 c4 20             	add    $0x20,%esp
80104795:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104799:	75 95                	jne    80104730 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
8010479b:	83 ec 08             	sub    $0x8,%esp
8010479e:	8d 45 c0             	lea    -0x40(%ebp),%eax
801047a1:	8d 7d c0             	lea    -0x40(%ebp),%edi
801047a4:	50                   	push   %eax
801047a5:	8b 43 b0             	mov    -0x50(%ebx),%eax
801047a8:	8b 40 0c             	mov    0xc(%eax),%eax
801047ab:	83 c0 08             	add    $0x8,%eax
801047ae:	50                   	push   %eax
801047af:	e8 ac 01 00 00       	call   80104960 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801047b4:	83 c4 10             	add    $0x10,%esp
801047b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047be:	66 90                	xchg   %ax,%ax
801047c0:	8b 17                	mov    (%edi),%edx
801047c2:	85 d2                	test   %edx,%edx
801047c4:	0f 84 66 ff ff ff    	je     80104730 <procdump+0x20>
        cprintf(" %p", pc[i]);
801047ca:	83 ec 08             	sub    $0x8,%esp
801047cd:	83 c7 04             	add    $0x4,%edi
801047d0:	52                   	push   %edx
801047d1:	68 81 80 10 80       	push   $0x80108081
801047d6:	e8 d5 be ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801047db:	83 c4 10             	add    $0x10,%esp
801047de:	39 fe                	cmp    %edi,%esi
801047e0:	75 de                	jne    801047c0 <procdump+0xb0>
801047e2:	e9 49 ff ff ff       	jmp    80104730 <procdump+0x20>
801047e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047ee:	66 90                	xchg   %ax,%ax
  }
}
801047f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801047f3:	5b                   	pop    %ebx
801047f4:	5e                   	pop    %esi
801047f5:	5f                   	pop    %edi
801047f6:	5d                   	pop    %ebp
801047f7:	c3                   	ret    
801047f8:	66 90                	xchg   %ax,%ax
801047fa:	66 90                	xchg   %ax,%ax
801047fc:	66 90                	xchg   %ax,%ax
801047fe:	66 90                	xchg   %ax,%ax

80104800 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104800:	f3 0f 1e fb          	endbr32 
80104804:	55                   	push   %ebp
80104805:	89 e5                	mov    %esp,%ebp
80104807:	53                   	push   %ebx
80104808:	83 ec 0c             	sub    $0xc,%esp
8010480b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010480e:	68 50 87 10 80       	push   $0x80108750
80104813:	8d 43 04             	lea    0x4(%ebx),%eax
80104816:	50                   	push   %eax
80104817:	e8 24 01 00 00       	call   80104940 <initlock>
  lk->name = name;
8010481c:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010481f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104825:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104828:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010482f:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104832:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104835:	c9                   	leave  
80104836:	c3                   	ret    
80104837:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010483e:	66 90                	xchg   %ax,%ax

80104840 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104840:	f3 0f 1e fb          	endbr32 
80104844:	55                   	push   %ebp
80104845:	89 e5                	mov    %esp,%ebp
80104847:	56                   	push   %esi
80104848:	53                   	push   %ebx
80104849:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010484c:	8d 73 04             	lea    0x4(%ebx),%esi
8010484f:	83 ec 0c             	sub    $0xc,%esp
80104852:	56                   	push   %esi
80104853:	e8 68 02 00 00       	call   80104ac0 <acquire>
  while (lk->locked) {
80104858:	8b 13                	mov    (%ebx),%edx
8010485a:	83 c4 10             	add    $0x10,%esp
8010485d:	85 d2                	test   %edx,%edx
8010485f:	74 1a                	je     8010487b <acquiresleep+0x3b>
80104861:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104868:	83 ec 08             	sub    $0x8,%esp
8010486b:	56                   	push   %esi
8010486c:	53                   	push   %ebx
8010486d:	e8 de fb ff ff       	call   80104450 <sleep>
  while (lk->locked) {
80104872:	8b 03                	mov    (%ebx),%eax
80104874:	83 c4 10             	add    $0x10,%esp
80104877:	85 c0                	test   %eax,%eax
80104879:	75 ed                	jne    80104868 <acquiresleep+0x28>
  }
  lk->locked = 1;
8010487b:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104881:	e8 aa f5 ff ff       	call   80103e30 <myproc>
80104886:	8b 40 10             	mov    0x10(%eax),%eax
80104889:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
8010488c:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010488f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104892:	5b                   	pop    %ebx
80104893:	5e                   	pop    %esi
80104894:	5d                   	pop    %ebp
  release(&lk->lk);
80104895:	e9 e6 02 00 00       	jmp    80104b80 <release>
8010489a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801048a0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801048a0:	f3 0f 1e fb          	endbr32 
801048a4:	55                   	push   %ebp
801048a5:	89 e5                	mov    %esp,%ebp
801048a7:	56                   	push   %esi
801048a8:	53                   	push   %ebx
801048a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801048ac:	8d 73 04             	lea    0x4(%ebx),%esi
801048af:	83 ec 0c             	sub    $0xc,%esp
801048b2:	56                   	push   %esi
801048b3:	e8 08 02 00 00       	call   80104ac0 <acquire>
  lk->locked = 0;
801048b8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801048be:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801048c5:	89 1c 24             	mov    %ebx,(%esp)
801048c8:	e8 43 fd ff ff       	call   80104610 <wakeup>
  release(&lk->lk);
801048cd:	89 75 08             	mov    %esi,0x8(%ebp)
801048d0:	83 c4 10             	add    $0x10,%esp
}
801048d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048d6:	5b                   	pop    %ebx
801048d7:	5e                   	pop    %esi
801048d8:	5d                   	pop    %ebp
  release(&lk->lk);
801048d9:	e9 a2 02 00 00       	jmp    80104b80 <release>
801048de:	66 90                	xchg   %ax,%ax

801048e0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801048e0:	f3 0f 1e fb          	endbr32 
801048e4:	55                   	push   %ebp
801048e5:	89 e5                	mov    %esp,%ebp
801048e7:	57                   	push   %edi
801048e8:	31 ff                	xor    %edi,%edi
801048ea:	56                   	push   %esi
801048eb:	53                   	push   %ebx
801048ec:	83 ec 18             	sub    $0x18,%esp
801048ef:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801048f2:	8d 73 04             	lea    0x4(%ebx),%esi
801048f5:	56                   	push   %esi
801048f6:	e8 c5 01 00 00       	call   80104ac0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801048fb:	8b 03                	mov    (%ebx),%eax
801048fd:	83 c4 10             	add    $0x10,%esp
80104900:	85 c0                	test   %eax,%eax
80104902:	75 1c                	jne    80104920 <holdingsleep+0x40>
  release(&lk->lk);
80104904:	83 ec 0c             	sub    $0xc,%esp
80104907:	56                   	push   %esi
80104908:	e8 73 02 00 00       	call   80104b80 <release>
  return r;
}
8010490d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104910:	89 f8                	mov    %edi,%eax
80104912:	5b                   	pop    %ebx
80104913:	5e                   	pop    %esi
80104914:	5f                   	pop    %edi
80104915:	5d                   	pop    %ebp
80104916:	c3                   	ret    
80104917:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010491e:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104920:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104923:	e8 08 f5 ff ff       	call   80103e30 <myproc>
80104928:	39 58 10             	cmp    %ebx,0x10(%eax)
8010492b:	0f 94 c0             	sete   %al
8010492e:	0f b6 c0             	movzbl %al,%eax
80104931:	89 c7                	mov    %eax,%edi
80104933:	eb cf                	jmp    80104904 <holdingsleep+0x24>
80104935:	66 90                	xchg   %ax,%ax
80104937:	66 90                	xchg   %ax,%ax
80104939:	66 90                	xchg   %ax,%ax
8010493b:	66 90                	xchg   %ax,%ax
8010493d:	66 90                	xchg   %ax,%ax
8010493f:	90                   	nop

80104940 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104940:	f3 0f 1e fb          	endbr32 
80104944:	55                   	push   %ebp
80104945:	89 e5                	mov    %esp,%ebp
80104947:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
8010494a:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
8010494d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104953:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104956:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010495d:	5d                   	pop    %ebp
8010495e:	c3                   	ret    
8010495f:	90                   	nop

80104960 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104960:	f3 0f 1e fb          	endbr32 
80104964:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104965:	31 d2                	xor    %edx,%edx
{
80104967:	89 e5                	mov    %esp,%ebp
80104969:	53                   	push   %ebx
  ebp = (uint*)v - 2;
8010496a:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010496d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104970:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104973:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104977:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104978:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010497e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104984:	77 1a                	ja     801049a0 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104986:	8b 58 04             	mov    0x4(%eax),%ebx
80104989:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
8010498c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
8010498f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104991:	83 fa 0a             	cmp    $0xa,%edx
80104994:	75 e2                	jne    80104978 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104996:	5b                   	pop    %ebx
80104997:	5d                   	pop    %ebp
80104998:	c3                   	ret    
80104999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
801049a0:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801049a3:	8d 51 28             	lea    0x28(%ecx),%edx
801049a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049ad:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
801049b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801049b6:	83 c0 04             	add    $0x4,%eax
801049b9:	39 d0                	cmp    %edx,%eax
801049bb:	75 f3                	jne    801049b0 <getcallerpcs+0x50>
}
801049bd:	5b                   	pop    %ebx
801049be:	5d                   	pop    %ebp
801049bf:	c3                   	ret    

801049c0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801049c0:	f3 0f 1e fb          	endbr32 
801049c4:	55                   	push   %ebp
801049c5:	89 e5                	mov    %esp,%ebp
801049c7:	53                   	push   %ebx
801049c8:	83 ec 04             	sub    $0x4,%esp
801049cb:	9c                   	pushf  
801049cc:	5b                   	pop    %ebx
  asm volatile("cli");
801049cd:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801049ce:	e8 bd f3 ff ff       	call   80103d90 <mycpu>
801049d3:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801049d9:	85 c0                	test   %eax,%eax
801049db:	74 13                	je     801049f0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801049dd:	e8 ae f3 ff ff       	call   80103d90 <mycpu>
801049e2:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801049e9:	83 c4 04             	add    $0x4,%esp
801049ec:	5b                   	pop    %ebx
801049ed:	5d                   	pop    %ebp
801049ee:	c3                   	ret    
801049ef:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
801049f0:	e8 9b f3 ff ff       	call   80103d90 <mycpu>
801049f5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801049fb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104a01:	eb da                	jmp    801049dd <pushcli+0x1d>
80104a03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a10 <popcli>:

void
popcli(void)
{
80104a10:	f3 0f 1e fb          	endbr32 
80104a14:	55                   	push   %ebp
80104a15:	89 e5                	mov    %esp,%ebp
80104a17:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104a1a:	9c                   	pushf  
80104a1b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104a1c:	f6 c4 02             	test   $0x2,%ah
80104a1f:	75 31                	jne    80104a52 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104a21:	e8 6a f3 ff ff       	call   80103d90 <mycpu>
80104a26:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104a2d:	78 30                	js     80104a5f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104a2f:	e8 5c f3 ff ff       	call   80103d90 <mycpu>
80104a34:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104a3a:	85 d2                	test   %edx,%edx
80104a3c:	74 02                	je     80104a40 <popcli+0x30>
    sti();
}
80104a3e:	c9                   	leave  
80104a3f:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104a40:	e8 4b f3 ff ff       	call   80103d90 <mycpu>
80104a45:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104a4b:	85 c0                	test   %eax,%eax
80104a4d:	74 ef                	je     80104a3e <popcli+0x2e>
  asm volatile("sti");
80104a4f:	fb                   	sti    
}
80104a50:	c9                   	leave  
80104a51:	c3                   	ret    
    panic("popcli - interruptible");
80104a52:	83 ec 0c             	sub    $0xc,%esp
80104a55:	68 5b 87 10 80       	push   $0x8010875b
80104a5a:	e8 31 b9 ff ff       	call   80100390 <panic>
    panic("popcli");
80104a5f:	83 ec 0c             	sub    $0xc,%esp
80104a62:	68 72 87 10 80       	push   $0x80108772
80104a67:	e8 24 b9 ff ff       	call   80100390 <panic>
80104a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a70 <holding>:
{
80104a70:	f3 0f 1e fb          	endbr32 
80104a74:	55                   	push   %ebp
80104a75:	89 e5                	mov    %esp,%ebp
80104a77:	56                   	push   %esi
80104a78:	53                   	push   %ebx
80104a79:	8b 75 08             	mov    0x8(%ebp),%esi
80104a7c:	31 db                	xor    %ebx,%ebx
  pushcli();
80104a7e:	e8 3d ff ff ff       	call   801049c0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104a83:	8b 06                	mov    (%esi),%eax
80104a85:	85 c0                	test   %eax,%eax
80104a87:	75 0f                	jne    80104a98 <holding+0x28>
  popcli();
80104a89:	e8 82 ff ff ff       	call   80104a10 <popcli>
}
80104a8e:	89 d8                	mov    %ebx,%eax
80104a90:	5b                   	pop    %ebx
80104a91:	5e                   	pop    %esi
80104a92:	5d                   	pop    %ebp
80104a93:	c3                   	ret    
80104a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104a98:	8b 5e 08             	mov    0x8(%esi),%ebx
80104a9b:	e8 f0 f2 ff ff       	call   80103d90 <mycpu>
80104aa0:	39 c3                	cmp    %eax,%ebx
80104aa2:	0f 94 c3             	sete   %bl
  popcli();
80104aa5:	e8 66 ff ff ff       	call   80104a10 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104aaa:	0f b6 db             	movzbl %bl,%ebx
}
80104aad:	89 d8                	mov    %ebx,%eax
80104aaf:	5b                   	pop    %ebx
80104ab0:	5e                   	pop    %esi
80104ab1:	5d                   	pop    %ebp
80104ab2:	c3                   	ret    
80104ab3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ac0 <acquire>:
{
80104ac0:	f3 0f 1e fb          	endbr32 
80104ac4:	55                   	push   %ebp
80104ac5:	89 e5                	mov    %esp,%ebp
80104ac7:	56                   	push   %esi
80104ac8:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104ac9:	e8 f2 fe ff ff       	call   801049c0 <pushcli>
  if(holding(lk))
80104ace:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104ad1:	83 ec 0c             	sub    $0xc,%esp
80104ad4:	53                   	push   %ebx
80104ad5:	e8 96 ff ff ff       	call   80104a70 <holding>
80104ada:	83 c4 10             	add    $0x10,%esp
80104add:	85 c0                	test   %eax,%eax
80104adf:	0f 85 7f 00 00 00    	jne    80104b64 <acquire+0xa4>
80104ae5:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104ae7:	ba 01 00 00 00       	mov    $0x1,%edx
80104aec:	eb 05                	jmp    80104af3 <acquire+0x33>
80104aee:	66 90                	xchg   %ax,%ax
80104af0:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104af3:	89 d0                	mov    %edx,%eax
80104af5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104af8:	85 c0                	test   %eax,%eax
80104afa:	75 f4                	jne    80104af0 <acquire+0x30>
  __sync_synchronize();
80104afc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104b01:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104b04:	e8 87 f2 ff ff       	call   80103d90 <mycpu>
80104b09:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104b0c:	89 e8                	mov    %ebp,%eax
80104b0e:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104b10:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104b16:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
80104b1c:	77 22                	ja     80104b40 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104b1e:	8b 50 04             	mov    0x4(%eax),%edx
80104b21:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80104b25:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104b28:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104b2a:	83 fe 0a             	cmp    $0xa,%esi
80104b2d:	75 e1                	jne    80104b10 <acquire+0x50>
}
80104b2f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b32:	5b                   	pop    %ebx
80104b33:	5e                   	pop    %esi
80104b34:	5d                   	pop    %ebp
80104b35:	c3                   	ret    
80104b36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b3d:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104b40:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104b44:	83 c3 34             	add    $0x34,%ebx
80104b47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b4e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104b50:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104b56:	83 c0 04             	add    $0x4,%eax
80104b59:	39 d8                	cmp    %ebx,%eax
80104b5b:	75 f3                	jne    80104b50 <acquire+0x90>
}
80104b5d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b60:	5b                   	pop    %ebx
80104b61:	5e                   	pop    %esi
80104b62:	5d                   	pop    %ebp
80104b63:	c3                   	ret    
    panic("acquire");
80104b64:	83 ec 0c             	sub    $0xc,%esp
80104b67:	68 79 87 10 80       	push   $0x80108779
80104b6c:	e8 1f b8 ff ff       	call   80100390 <panic>
80104b71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b7f:	90                   	nop

80104b80 <release>:
{
80104b80:	f3 0f 1e fb          	endbr32 
80104b84:	55                   	push   %ebp
80104b85:	89 e5                	mov    %esp,%ebp
80104b87:	53                   	push   %ebx
80104b88:	83 ec 10             	sub    $0x10,%esp
80104b8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104b8e:	53                   	push   %ebx
80104b8f:	e8 dc fe ff ff       	call   80104a70 <holding>
80104b94:	83 c4 10             	add    $0x10,%esp
80104b97:	85 c0                	test   %eax,%eax
80104b99:	74 22                	je     80104bbd <release+0x3d>
  lk->pcs[0] = 0;
80104b9b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104ba2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104ba9:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104bae:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104bb4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bb7:	c9                   	leave  
  popcli();
80104bb8:	e9 53 fe ff ff       	jmp    80104a10 <popcli>
    panic("release");
80104bbd:	83 ec 0c             	sub    $0xc,%esp
80104bc0:	68 81 87 10 80       	push   $0x80108781
80104bc5:	e8 c6 b7 ff ff       	call   80100390 <panic>
80104bca:	66 90                	xchg   %ax,%ax
80104bcc:	66 90                	xchg   %ax,%ax
80104bce:	66 90                	xchg   %ax,%ax

80104bd0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104bd0:	f3 0f 1e fb          	endbr32 
80104bd4:	55                   	push   %ebp
80104bd5:	89 e5                	mov    %esp,%ebp
80104bd7:	57                   	push   %edi
80104bd8:	8b 55 08             	mov    0x8(%ebp),%edx
80104bdb:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104bde:	53                   	push   %ebx
80104bdf:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104be2:	89 d7                	mov    %edx,%edi
80104be4:	09 cf                	or     %ecx,%edi
80104be6:	83 e7 03             	and    $0x3,%edi
80104be9:	75 25                	jne    80104c10 <memset+0x40>
    c &= 0xFF;
80104beb:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104bee:	c1 e0 18             	shl    $0x18,%eax
80104bf1:	89 fb                	mov    %edi,%ebx
80104bf3:	c1 e9 02             	shr    $0x2,%ecx
80104bf6:	c1 e3 10             	shl    $0x10,%ebx
80104bf9:	09 d8                	or     %ebx,%eax
80104bfb:	09 f8                	or     %edi,%eax
80104bfd:	c1 e7 08             	shl    $0x8,%edi
80104c00:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104c02:	89 d7                	mov    %edx,%edi
80104c04:	fc                   	cld    
80104c05:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104c07:	5b                   	pop    %ebx
80104c08:	89 d0                	mov    %edx,%eax
80104c0a:	5f                   	pop    %edi
80104c0b:	5d                   	pop    %ebp
80104c0c:	c3                   	ret    
80104c0d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80104c10:	89 d7                	mov    %edx,%edi
80104c12:	fc                   	cld    
80104c13:	f3 aa                	rep stos %al,%es:(%edi)
80104c15:	5b                   	pop    %ebx
80104c16:	89 d0                	mov    %edx,%eax
80104c18:	5f                   	pop    %edi
80104c19:	5d                   	pop    %ebp
80104c1a:	c3                   	ret    
80104c1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c1f:	90                   	nop

80104c20 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104c20:	f3 0f 1e fb          	endbr32 
80104c24:	55                   	push   %ebp
80104c25:	89 e5                	mov    %esp,%ebp
80104c27:	56                   	push   %esi
80104c28:	8b 75 10             	mov    0x10(%ebp),%esi
80104c2b:	8b 55 08             	mov    0x8(%ebp),%edx
80104c2e:	53                   	push   %ebx
80104c2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104c32:	85 f6                	test   %esi,%esi
80104c34:	74 2a                	je     80104c60 <memcmp+0x40>
80104c36:	01 c6                	add    %eax,%esi
80104c38:	eb 10                	jmp    80104c4a <memcmp+0x2a>
80104c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104c40:	83 c0 01             	add    $0x1,%eax
80104c43:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104c46:	39 f0                	cmp    %esi,%eax
80104c48:	74 16                	je     80104c60 <memcmp+0x40>
    if(*s1 != *s2)
80104c4a:	0f b6 0a             	movzbl (%edx),%ecx
80104c4d:	0f b6 18             	movzbl (%eax),%ebx
80104c50:	38 d9                	cmp    %bl,%cl
80104c52:	74 ec                	je     80104c40 <memcmp+0x20>
      return *s1 - *s2;
80104c54:	0f b6 c1             	movzbl %cl,%eax
80104c57:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104c59:	5b                   	pop    %ebx
80104c5a:	5e                   	pop    %esi
80104c5b:	5d                   	pop    %ebp
80104c5c:	c3                   	ret    
80104c5d:	8d 76 00             	lea    0x0(%esi),%esi
80104c60:	5b                   	pop    %ebx
  return 0;
80104c61:	31 c0                	xor    %eax,%eax
}
80104c63:	5e                   	pop    %esi
80104c64:	5d                   	pop    %ebp
80104c65:	c3                   	ret    
80104c66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c6d:	8d 76 00             	lea    0x0(%esi),%esi

80104c70 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104c70:	f3 0f 1e fb          	endbr32 
80104c74:	55                   	push   %ebp
80104c75:	89 e5                	mov    %esp,%ebp
80104c77:	57                   	push   %edi
80104c78:	8b 55 08             	mov    0x8(%ebp),%edx
80104c7b:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104c7e:	56                   	push   %esi
80104c7f:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104c82:	39 d6                	cmp    %edx,%esi
80104c84:	73 2a                	jae    80104cb0 <memmove+0x40>
80104c86:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104c89:	39 fa                	cmp    %edi,%edx
80104c8b:	73 23                	jae    80104cb0 <memmove+0x40>
80104c8d:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104c90:	85 c9                	test   %ecx,%ecx
80104c92:	74 13                	je     80104ca7 <memmove+0x37>
80104c94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104c98:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104c9c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104c9f:	83 e8 01             	sub    $0x1,%eax
80104ca2:	83 f8 ff             	cmp    $0xffffffff,%eax
80104ca5:	75 f1                	jne    80104c98 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104ca7:	5e                   	pop    %esi
80104ca8:	89 d0                	mov    %edx,%eax
80104caa:	5f                   	pop    %edi
80104cab:	5d                   	pop    %ebp
80104cac:	c3                   	ret    
80104cad:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80104cb0:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104cb3:	89 d7                	mov    %edx,%edi
80104cb5:	85 c9                	test   %ecx,%ecx
80104cb7:	74 ee                	je     80104ca7 <memmove+0x37>
80104cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104cc0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104cc1:	39 f0                	cmp    %esi,%eax
80104cc3:	75 fb                	jne    80104cc0 <memmove+0x50>
}
80104cc5:	5e                   	pop    %esi
80104cc6:	89 d0                	mov    %edx,%eax
80104cc8:	5f                   	pop    %edi
80104cc9:	5d                   	pop    %ebp
80104cca:	c3                   	ret    
80104ccb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ccf:	90                   	nop

80104cd0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104cd0:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80104cd4:	eb 9a                	jmp    80104c70 <memmove>
80104cd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cdd:	8d 76 00             	lea    0x0(%esi),%esi

80104ce0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104ce0:	f3 0f 1e fb          	endbr32 
80104ce4:	55                   	push   %ebp
80104ce5:	89 e5                	mov    %esp,%ebp
80104ce7:	56                   	push   %esi
80104ce8:	8b 75 10             	mov    0x10(%ebp),%esi
80104ceb:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104cee:	53                   	push   %ebx
80104cef:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80104cf2:	85 f6                	test   %esi,%esi
80104cf4:	74 32                	je     80104d28 <strncmp+0x48>
80104cf6:	01 c6                	add    %eax,%esi
80104cf8:	eb 14                	jmp    80104d0e <strncmp+0x2e>
80104cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d00:	38 da                	cmp    %bl,%dl
80104d02:	75 14                	jne    80104d18 <strncmp+0x38>
    n--, p++, q++;
80104d04:	83 c0 01             	add    $0x1,%eax
80104d07:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104d0a:	39 f0                	cmp    %esi,%eax
80104d0c:	74 1a                	je     80104d28 <strncmp+0x48>
80104d0e:	0f b6 11             	movzbl (%ecx),%edx
80104d11:	0f b6 18             	movzbl (%eax),%ebx
80104d14:	84 d2                	test   %dl,%dl
80104d16:	75 e8                	jne    80104d00 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104d18:	0f b6 c2             	movzbl %dl,%eax
80104d1b:	29 d8                	sub    %ebx,%eax
}
80104d1d:	5b                   	pop    %ebx
80104d1e:	5e                   	pop    %esi
80104d1f:	5d                   	pop    %ebp
80104d20:	c3                   	ret    
80104d21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d28:	5b                   	pop    %ebx
    return 0;
80104d29:	31 c0                	xor    %eax,%eax
}
80104d2b:	5e                   	pop    %esi
80104d2c:	5d                   	pop    %ebp
80104d2d:	c3                   	ret    
80104d2e:	66 90                	xchg   %ax,%ax

80104d30 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104d30:	f3 0f 1e fb          	endbr32 
80104d34:	55                   	push   %ebp
80104d35:	89 e5                	mov    %esp,%ebp
80104d37:	57                   	push   %edi
80104d38:	56                   	push   %esi
80104d39:	8b 75 08             	mov    0x8(%ebp),%esi
80104d3c:	53                   	push   %ebx
80104d3d:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104d40:	89 f2                	mov    %esi,%edx
80104d42:	eb 1b                	jmp    80104d5f <strncpy+0x2f>
80104d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d48:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104d4c:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104d4f:	83 c2 01             	add    $0x1,%edx
80104d52:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80104d56:	89 f9                	mov    %edi,%ecx
80104d58:	88 4a ff             	mov    %cl,-0x1(%edx)
80104d5b:	84 c9                	test   %cl,%cl
80104d5d:	74 09                	je     80104d68 <strncpy+0x38>
80104d5f:	89 c3                	mov    %eax,%ebx
80104d61:	83 e8 01             	sub    $0x1,%eax
80104d64:	85 db                	test   %ebx,%ebx
80104d66:	7f e0                	jg     80104d48 <strncpy+0x18>
    ;
  while(n-- > 0)
80104d68:	89 d1                	mov    %edx,%ecx
80104d6a:	85 c0                	test   %eax,%eax
80104d6c:	7e 15                	jle    80104d83 <strncpy+0x53>
80104d6e:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80104d70:	83 c1 01             	add    $0x1,%ecx
80104d73:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80104d77:	89 c8                	mov    %ecx,%eax
80104d79:	f7 d0                	not    %eax
80104d7b:	01 d0                	add    %edx,%eax
80104d7d:	01 d8                	add    %ebx,%eax
80104d7f:	85 c0                	test   %eax,%eax
80104d81:	7f ed                	jg     80104d70 <strncpy+0x40>
  return os;
}
80104d83:	5b                   	pop    %ebx
80104d84:	89 f0                	mov    %esi,%eax
80104d86:	5e                   	pop    %esi
80104d87:	5f                   	pop    %edi
80104d88:	5d                   	pop    %ebp
80104d89:	c3                   	ret    
80104d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104d90 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104d90:	f3 0f 1e fb          	endbr32 
80104d94:	55                   	push   %ebp
80104d95:	89 e5                	mov    %esp,%ebp
80104d97:	56                   	push   %esi
80104d98:	8b 55 10             	mov    0x10(%ebp),%edx
80104d9b:	8b 75 08             	mov    0x8(%ebp),%esi
80104d9e:	53                   	push   %ebx
80104d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104da2:	85 d2                	test   %edx,%edx
80104da4:	7e 21                	jle    80104dc7 <safestrcpy+0x37>
80104da6:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104daa:	89 f2                	mov    %esi,%edx
80104dac:	eb 12                	jmp    80104dc0 <safestrcpy+0x30>
80104dae:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104db0:	0f b6 08             	movzbl (%eax),%ecx
80104db3:	83 c0 01             	add    $0x1,%eax
80104db6:	83 c2 01             	add    $0x1,%edx
80104db9:	88 4a ff             	mov    %cl,-0x1(%edx)
80104dbc:	84 c9                	test   %cl,%cl
80104dbe:	74 04                	je     80104dc4 <safestrcpy+0x34>
80104dc0:	39 d8                	cmp    %ebx,%eax
80104dc2:	75 ec                	jne    80104db0 <safestrcpy+0x20>
    ;
  *s = 0;
80104dc4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104dc7:	89 f0                	mov    %esi,%eax
80104dc9:	5b                   	pop    %ebx
80104dca:	5e                   	pop    %esi
80104dcb:	5d                   	pop    %ebp
80104dcc:	c3                   	ret    
80104dcd:	8d 76 00             	lea    0x0(%esi),%esi

80104dd0 <strlen>:

int
strlen(const char *s)
{
80104dd0:	f3 0f 1e fb          	endbr32 
80104dd4:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104dd5:	31 c0                	xor    %eax,%eax
{
80104dd7:	89 e5                	mov    %esp,%ebp
80104dd9:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104ddc:	80 3a 00             	cmpb   $0x0,(%edx)
80104ddf:	74 10                	je     80104df1 <strlen+0x21>
80104de1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104de8:	83 c0 01             	add    $0x1,%eax
80104deb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104def:	75 f7                	jne    80104de8 <strlen+0x18>
    ;
  return n;
}
80104df1:	5d                   	pop    %ebp
80104df2:	c3                   	ret    

80104df3 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104df3:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104df7:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104dfb:	55                   	push   %ebp
  pushl %ebx
80104dfc:	53                   	push   %ebx
  pushl %esi
80104dfd:	56                   	push   %esi
  pushl %edi
80104dfe:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104dff:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104e01:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104e03:	5f                   	pop    %edi
  popl %esi
80104e04:	5e                   	pop    %esi
  popl %ebx
80104e05:	5b                   	pop    %ebx
  popl %ebp
80104e06:	5d                   	pop    %ebp
  ret
80104e07:	c3                   	ret    
80104e08:	66 90                	xchg   %ax,%ax
80104e0a:	66 90                	xchg   %ax,%ax
80104e0c:	66 90                	xchg   %ax,%ax
80104e0e:	66 90                	xchg   %ax,%ax

80104e10 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104e10:	f3 0f 1e fb          	endbr32 
80104e14:	55                   	push   %ebp
80104e15:	89 e5                	mov    %esp,%ebp
80104e17:	53                   	push   %ebx
80104e18:	83 ec 04             	sub    $0x4,%esp
80104e1b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104e1e:	e8 0d f0 ff ff       	call   80103e30 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104e23:	8b 00                	mov    (%eax),%eax
80104e25:	39 d8                	cmp    %ebx,%eax
80104e27:	76 17                	jbe    80104e40 <fetchint+0x30>
80104e29:	8d 53 04             	lea    0x4(%ebx),%edx
80104e2c:	39 d0                	cmp    %edx,%eax
80104e2e:	72 10                	jb     80104e40 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104e30:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e33:	8b 13                	mov    (%ebx),%edx
80104e35:	89 10                	mov    %edx,(%eax)
  return 0;
80104e37:	31 c0                	xor    %eax,%eax
}
80104e39:	83 c4 04             	add    $0x4,%esp
80104e3c:	5b                   	pop    %ebx
80104e3d:	5d                   	pop    %ebp
80104e3e:	c3                   	ret    
80104e3f:	90                   	nop
    return -1;
80104e40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e45:	eb f2                	jmp    80104e39 <fetchint+0x29>
80104e47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e4e:	66 90                	xchg   %ax,%ax

80104e50 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104e50:	f3 0f 1e fb          	endbr32 
80104e54:	55                   	push   %ebp
80104e55:	89 e5                	mov    %esp,%ebp
80104e57:	53                   	push   %ebx
80104e58:	83 ec 04             	sub    $0x4,%esp
80104e5b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104e5e:	e8 cd ef ff ff       	call   80103e30 <myproc>

  if(addr >= curproc->sz)
80104e63:	39 18                	cmp    %ebx,(%eax)
80104e65:	76 31                	jbe    80104e98 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80104e67:	8b 55 0c             	mov    0xc(%ebp),%edx
80104e6a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104e6c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104e6e:	39 d3                	cmp    %edx,%ebx
80104e70:	73 26                	jae    80104e98 <fetchstr+0x48>
80104e72:	89 d8                	mov    %ebx,%eax
80104e74:	eb 11                	jmp    80104e87 <fetchstr+0x37>
80104e76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e7d:	8d 76 00             	lea    0x0(%esi),%esi
80104e80:	83 c0 01             	add    $0x1,%eax
80104e83:	39 c2                	cmp    %eax,%edx
80104e85:	76 11                	jbe    80104e98 <fetchstr+0x48>
    if(*s == 0)
80104e87:	80 38 00             	cmpb   $0x0,(%eax)
80104e8a:	75 f4                	jne    80104e80 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
80104e8c:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
80104e8f:	29 d8                	sub    %ebx,%eax
}
80104e91:	5b                   	pop    %ebx
80104e92:	5d                   	pop    %ebp
80104e93:	c3                   	ret    
80104e94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e98:	83 c4 04             	add    $0x4,%esp
    return -1;
80104e9b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ea0:	5b                   	pop    %ebx
80104ea1:	5d                   	pop    %ebp
80104ea2:	c3                   	ret    
80104ea3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104eb0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104eb0:	f3 0f 1e fb          	endbr32 
80104eb4:	55                   	push   %ebp
80104eb5:	89 e5                	mov    %esp,%ebp
80104eb7:	56                   	push   %esi
80104eb8:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104eb9:	e8 72 ef ff ff       	call   80103e30 <myproc>
80104ebe:	8b 55 08             	mov    0x8(%ebp),%edx
80104ec1:	8b 40 18             	mov    0x18(%eax),%eax
80104ec4:	8b 40 44             	mov    0x44(%eax),%eax
80104ec7:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104eca:	e8 61 ef ff ff       	call   80103e30 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ecf:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104ed2:	8b 00                	mov    (%eax),%eax
80104ed4:	39 c6                	cmp    %eax,%esi
80104ed6:	73 18                	jae    80104ef0 <argint+0x40>
80104ed8:	8d 53 08             	lea    0x8(%ebx),%edx
80104edb:	39 d0                	cmp    %edx,%eax
80104edd:	72 11                	jb     80104ef0 <argint+0x40>
  *ip = *(int*)(addr);
80104edf:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ee2:	8b 53 04             	mov    0x4(%ebx),%edx
80104ee5:	89 10                	mov    %edx,(%eax)
  return 0;
80104ee7:	31 c0                	xor    %eax,%eax
}
80104ee9:	5b                   	pop    %ebx
80104eea:	5e                   	pop    %esi
80104eeb:	5d                   	pop    %ebp
80104eec:	c3                   	ret    
80104eed:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104ef0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ef5:	eb f2                	jmp    80104ee9 <argint+0x39>
80104ef7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104efe:	66 90                	xchg   %ax,%ax

80104f00 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104f00:	f3 0f 1e fb          	endbr32 
80104f04:	55                   	push   %ebp
80104f05:	89 e5                	mov    %esp,%ebp
80104f07:	56                   	push   %esi
80104f08:	53                   	push   %ebx
80104f09:	83 ec 10             	sub    $0x10,%esp
80104f0c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104f0f:	e8 1c ef ff ff       	call   80103e30 <myproc>
 
  if(argint(n, &i) < 0)
80104f14:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80104f17:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80104f19:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f1c:	50                   	push   %eax
80104f1d:	ff 75 08             	pushl  0x8(%ebp)
80104f20:	e8 8b ff ff ff       	call   80104eb0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104f25:	83 c4 10             	add    $0x10,%esp
80104f28:	85 c0                	test   %eax,%eax
80104f2a:	78 24                	js     80104f50 <argptr+0x50>
80104f2c:	85 db                	test   %ebx,%ebx
80104f2e:	78 20                	js     80104f50 <argptr+0x50>
80104f30:	8b 16                	mov    (%esi),%edx
80104f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f35:	39 c2                	cmp    %eax,%edx
80104f37:	76 17                	jbe    80104f50 <argptr+0x50>
80104f39:	01 c3                	add    %eax,%ebx
80104f3b:	39 da                	cmp    %ebx,%edx
80104f3d:	72 11                	jb     80104f50 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104f3f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104f42:	89 02                	mov    %eax,(%edx)
  return 0;
80104f44:	31 c0                	xor    %eax,%eax
}
80104f46:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f49:	5b                   	pop    %ebx
80104f4a:	5e                   	pop    %esi
80104f4b:	5d                   	pop    %ebp
80104f4c:	c3                   	ret    
80104f4d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f55:	eb ef                	jmp    80104f46 <argptr+0x46>
80104f57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f5e:	66 90                	xchg   %ax,%ax

80104f60 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104f60:	f3 0f 1e fb          	endbr32 
80104f64:	55                   	push   %ebp
80104f65:	89 e5                	mov    %esp,%ebp
80104f67:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104f6a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f6d:	50                   	push   %eax
80104f6e:	ff 75 08             	pushl  0x8(%ebp)
80104f71:	e8 3a ff ff ff       	call   80104eb0 <argint>
80104f76:	83 c4 10             	add    $0x10,%esp
80104f79:	85 c0                	test   %eax,%eax
80104f7b:	78 13                	js     80104f90 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104f7d:	83 ec 08             	sub    $0x8,%esp
80104f80:	ff 75 0c             	pushl  0xc(%ebp)
80104f83:	ff 75 f4             	pushl  -0xc(%ebp)
80104f86:	e8 c5 fe ff ff       	call   80104e50 <fetchstr>
80104f8b:	83 c4 10             	add    $0x10,%esp
}
80104f8e:	c9                   	leave  
80104f8f:	c3                   	ret    
80104f90:	c9                   	leave  
    return -1;
80104f91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f96:	c3                   	ret    
80104f97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f9e:	66 90                	xchg   %ax,%ax

80104fa0 <syscall>:
[SYS_get_number_of_free_pages] sys_get_number_of_free_pages
};

void
syscall(void)
{
80104fa0:	f3 0f 1e fb          	endbr32 
80104fa4:	55                   	push   %ebp
80104fa5:	89 e5                	mov    %esp,%ebp
80104fa7:	53                   	push   %ebx
80104fa8:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104fab:	e8 80 ee ff ff       	call   80103e30 <myproc>
80104fb0:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104fb2:	8b 40 18             	mov    0x18(%eax),%eax
80104fb5:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104fb8:	8d 50 ff             	lea    -0x1(%eax),%edx
80104fbb:	83 fa 15             	cmp    $0x15,%edx
80104fbe:	77 20                	ja     80104fe0 <syscall+0x40>
80104fc0:	8b 14 85 c0 87 10 80 	mov    -0x7fef7840(,%eax,4),%edx
80104fc7:	85 d2                	test   %edx,%edx
80104fc9:	74 15                	je     80104fe0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104fcb:	ff d2                	call   *%edx
80104fcd:	89 c2                	mov    %eax,%edx
80104fcf:	8b 43 18             	mov    0x18(%ebx),%eax
80104fd2:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104fd5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104fd8:	c9                   	leave  
80104fd9:	c3                   	ret    
80104fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104fe0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104fe1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104fe4:	50                   	push   %eax
80104fe5:	ff 73 10             	pushl  0x10(%ebx)
80104fe8:	68 89 87 10 80       	push   $0x80108789
80104fed:	e8 be b6 ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80104ff2:	8b 43 18             	mov    0x18(%ebx),%eax
80104ff5:	83 c4 10             	add    $0x10,%esp
80104ff8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104fff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105002:	c9                   	leave  
80105003:	c3                   	ret    
80105004:	66 90                	xchg   %ax,%ax
80105006:	66 90                	xchg   %ax,%ax
80105008:	66 90                	xchg   %ax,%ax
8010500a:	66 90                	xchg   %ax,%ax
8010500c:	66 90                	xchg   %ax,%ax
8010500e:	66 90                	xchg   %ax,%ax

80105010 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80105010:	55                   	push   %ebp
80105011:	89 e5                	mov    %esp,%ebp
80105013:	56                   	push   %esi
80105014:	89 d6                	mov    %edx,%esi
80105016:	53                   	push   %ebx
80105017:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105019:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010501c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010501f:	50                   	push   %eax
80105020:	6a 00                	push   $0x0
80105022:	e8 89 fe ff ff       	call   80104eb0 <argint>
80105027:	83 c4 10             	add    $0x10,%esp
8010502a:	85 c0                	test   %eax,%eax
8010502c:	78 2a                	js     80105058 <argfd.constprop.0+0x48>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010502e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105032:	77 24                	ja     80105058 <argfd.constprop.0+0x48>
80105034:	e8 f7 ed ff ff       	call   80103e30 <myproc>
80105039:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010503c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105040:	85 c0                	test   %eax,%eax
80105042:	74 14                	je     80105058 <argfd.constprop.0+0x48>
    return -1;
  if(pfd)
80105044:	85 db                	test   %ebx,%ebx
80105046:	74 02                	je     8010504a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105048:	89 13                	mov    %edx,(%ebx)
  if(pf)
    *pf = f;
8010504a:	89 06                	mov    %eax,(%esi)
  return 0;
8010504c:	31 c0                	xor    %eax,%eax
}
8010504e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105051:	5b                   	pop    %ebx
80105052:	5e                   	pop    %esi
80105053:	5d                   	pop    %ebp
80105054:	c3                   	ret    
80105055:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105058:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010505d:	eb ef                	jmp    8010504e <argfd.constprop.0+0x3e>
8010505f:	90                   	nop

80105060 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80105060:	f3 0f 1e fb          	endbr32 
80105064:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105065:	31 c0                	xor    %eax,%eax
{
80105067:	89 e5                	mov    %esp,%ebp
80105069:	56                   	push   %esi
8010506a:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
8010506b:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010506e:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80105071:	e8 9a ff ff ff       	call   80105010 <argfd.constprop.0>
80105076:	85 c0                	test   %eax,%eax
80105078:	78 1e                	js     80105098 <sys_dup+0x38>
    return -1;
  if((fd=fdalloc(f)) < 0)
8010507a:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
8010507d:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010507f:	e8 ac ed ff ff       	call   80103e30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105084:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105088:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
8010508c:	85 d2                	test   %edx,%edx
8010508e:	74 20                	je     801050b0 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80105090:	83 c3 01             	add    $0x1,%ebx
80105093:	83 fb 10             	cmp    $0x10,%ebx
80105096:	75 f0                	jne    80105088 <sys_dup+0x28>
    return -1;
  filedup(f);
  return fd;
}
80105098:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010509b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801050a0:	89 d8                	mov    %ebx,%eax
801050a2:	5b                   	pop    %ebx
801050a3:	5e                   	pop    %esi
801050a4:	5d                   	pop    %ebp
801050a5:	c3                   	ret    
801050a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050ad:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
801050b0:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
801050b4:	83 ec 0c             	sub    $0xc,%esp
801050b7:	ff 75 f4             	pushl  -0xc(%ebp)
801050ba:	e8 41 be ff ff       	call   80100f00 <filedup>
  return fd;
801050bf:	83 c4 10             	add    $0x10,%esp
}
801050c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050c5:	89 d8                	mov    %ebx,%eax
801050c7:	5b                   	pop    %ebx
801050c8:	5e                   	pop    %esi
801050c9:	5d                   	pop    %ebp
801050ca:	c3                   	ret    
801050cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801050cf:	90                   	nop

801050d0 <sys_read>:

int
sys_read(void)
{
801050d0:	f3 0f 1e fb          	endbr32 
801050d4:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801050d5:	31 c0                	xor    %eax,%eax
{
801050d7:	89 e5                	mov    %esp,%ebp
801050d9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801050dc:	8d 55 ec             	lea    -0x14(%ebp),%edx
801050df:	e8 2c ff ff ff       	call   80105010 <argfd.constprop.0>
801050e4:	85 c0                	test   %eax,%eax
801050e6:	78 48                	js     80105130 <sys_read+0x60>
801050e8:	83 ec 08             	sub    $0x8,%esp
801050eb:	8d 45 f0             	lea    -0x10(%ebp),%eax
801050ee:	50                   	push   %eax
801050ef:	6a 02                	push   $0x2
801050f1:	e8 ba fd ff ff       	call   80104eb0 <argint>
801050f6:	83 c4 10             	add    $0x10,%esp
801050f9:	85 c0                	test   %eax,%eax
801050fb:	78 33                	js     80105130 <sys_read+0x60>
801050fd:	83 ec 04             	sub    $0x4,%esp
80105100:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105103:	ff 75 f0             	pushl  -0x10(%ebp)
80105106:	50                   	push   %eax
80105107:	6a 01                	push   $0x1
80105109:	e8 f2 fd ff ff       	call   80104f00 <argptr>
8010510e:	83 c4 10             	add    $0x10,%esp
80105111:	85 c0                	test   %eax,%eax
80105113:	78 1b                	js     80105130 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80105115:	83 ec 04             	sub    $0x4,%esp
80105118:	ff 75 f0             	pushl  -0x10(%ebp)
8010511b:	ff 75 f4             	pushl  -0xc(%ebp)
8010511e:	ff 75 ec             	pushl  -0x14(%ebp)
80105121:	e8 5a bf ff ff       	call   80101080 <fileread>
80105126:	83 c4 10             	add    $0x10,%esp
}
80105129:	c9                   	leave  
8010512a:	c3                   	ret    
8010512b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010512f:	90                   	nop
80105130:	c9                   	leave  
    return -1;
80105131:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105136:	c3                   	ret    
80105137:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010513e:	66 90                	xchg   %ax,%ax

80105140 <sys_write>:

int
sys_write(void)
{
80105140:	f3 0f 1e fb          	endbr32 
80105144:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105145:	31 c0                	xor    %eax,%eax
{
80105147:	89 e5                	mov    %esp,%ebp
80105149:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010514c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010514f:	e8 bc fe ff ff       	call   80105010 <argfd.constprop.0>
80105154:	85 c0                	test   %eax,%eax
80105156:	78 48                	js     801051a0 <sys_write+0x60>
80105158:	83 ec 08             	sub    $0x8,%esp
8010515b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010515e:	50                   	push   %eax
8010515f:	6a 02                	push   $0x2
80105161:	e8 4a fd ff ff       	call   80104eb0 <argint>
80105166:	83 c4 10             	add    $0x10,%esp
80105169:	85 c0                	test   %eax,%eax
8010516b:	78 33                	js     801051a0 <sys_write+0x60>
8010516d:	83 ec 04             	sub    $0x4,%esp
80105170:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105173:	ff 75 f0             	pushl  -0x10(%ebp)
80105176:	50                   	push   %eax
80105177:	6a 01                	push   $0x1
80105179:	e8 82 fd ff ff       	call   80104f00 <argptr>
8010517e:	83 c4 10             	add    $0x10,%esp
80105181:	85 c0                	test   %eax,%eax
80105183:	78 1b                	js     801051a0 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80105185:	83 ec 04             	sub    $0x4,%esp
80105188:	ff 75 f0             	pushl  -0x10(%ebp)
8010518b:	ff 75 f4             	pushl  -0xc(%ebp)
8010518e:	ff 75 ec             	pushl  -0x14(%ebp)
80105191:	e8 8a bf ff ff       	call   80101120 <filewrite>
80105196:	83 c4 10             	add    $0x10,%esp
}
80105199:	c9                   	leave  
8010519a:	c3                   	ret    
8010519b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010519f:	90                   	nop
801051a0:	c9                   	leave  
    return -1;
801051a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051a6:	c3                   	ret    
801051a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051ae:	66 90                	xchg   %ax,%ax

801051b0 <sys_close>:

int
sys_close(void)
{
801051b0:	f3 0f 1e fb          	endbr32 
801051b4:	55                   	push   %ebp
801051b5:	89 e5                	mov    %esp,%ebp
801051b7:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
801051ba:	8d 55 f4             	lea    -0xc(%ebp),%edx
801051bd:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051c0:	e8 4b fe ff ff       	call   80105010 <argfd.constprop.0>
801051c5:	85 c0                	test   %eax,%eax
801051c7:	78 27                	js     801051f0 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
801051c9:	e8 62 ec ff ff       	call   80103e30 <myproc>
801051ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801051d1:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801051d4:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801051db:	00 
  fileclose(f);
801051dc:	ff 75 f4             	pushl  -0xc(%ebp)
801051df:	e8 6c bd ff ff       	call   80100f50 <fileclose>
  return 0;
801051e4:	83 c4 10             	add    $0x10,%esp
801051e7:	31 c0                	xor    %eax,%eax
}
801051e9:	c9                   	leave  
801051ea:	c3                   	ret    
801051eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051ef:	90                   	nop
801051f0:	c9                   	leave  
    return -1;
801051f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051f6:	c3                   	ret    
801051f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051fe:	66 90                	xchg   %ax,%ax

80105200 <sys_fstat>:

int
sys_fstat(void)
{
80105200:	f3 0f 1e fb          	endbr32 
80105204:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105205:	31 c0                	xor    %eax,%eax
{
80105207:	89 e5                	mov    %esp,%ebp
80105209:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010520c:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010520f:	e8 fc fd ff ff       	call   80105010 <argfd.constprop.0>
80105214:	85 c0                	test   %eax,%eax
80105216:	78 30                	js     80105248 <sys_fstat+0x48>
80105218:	83 ec 04             	sub    $0x4,%esp
8010521b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010521e:	6a 14                	push   $0x14
80105220:	50                   	push   %eax
80105221:	6a 01                	push   $0x1
80105223:	e8 d8 fc ff ff       	call   80104f00 <argptr>
80105228:	83 c4 10             	add    $0x10,%esp
8010522b:	85 c0                	test   %eax,%eax
8010522d:	78 19                	js     80105248 <sys_fstat+0x48>
    return -1;
  return filestat(f, st);
8010522f:	83 ec 08             	sub    $0x8,%esp
80105232:	ff 75 f4             	pushl  -0xc(%ebp)
80105235:	ff 75 f0             	pushl  -0x10(%ebp)
80105238:	e8 f3 bd ff ff       	call   80101030 <filestat>
8010523d:	83 c4 10             	add    $0x10,%esp
}
80105240:	c9                   	leave  
80105241:	c3                   	ret    
80105242:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105248:	c9                   	leave  
    return -1;
80105249:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010524e:	c3                   	ret    
8010524f:	90                   	nop

80105250 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105250:	f3 0f 1e fb          	endbr32 
80105254:	55                   	push   %ebp
80105255:	89 e5                	mov    %esp,%ebp
80105257:	57                   	push   %edi
80105258:	56                   	push   %esi
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105259:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
8010525c:	53                   	push   %ebx
8010525d:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105260:	50                   	push   %eax
80105261:	6a 00                	push   $0x0
80105263:	e8 f8 fc ff ff       	call   80104f60 <argstr>
80105268:	83 c4 10             	add    $0x10,%esp
8010526b:	85 c0                	test   %eax,%eax
8010526d:	0f 88 ff 00 00 00    	js     80105372 <sys_link+0x122>
80105273:	83 ec 08             	sub    $0x8,%esp
80105276:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105279:	50                   	push   %eax
8010527a:	6a 01                	push   $0x1
8010527c:	e8 df fc ff ff       	call   80104f60 <argstr>
80105281:	83 c4 10             	add    $0x10,%esp
80105284:	85 c0                	test   %eax,%eax
80105286:	0f 88 e6 00 00 00    	js     80105372 <sys_link+0x122>
    return -1;

  begin_op();
8010528c:	e8 3f df ff ff       	call   801031d0 <begin_op>
  if((ip = namei(old)) == 0){
80105291:	83 ec 0c             	sub    $0xc,%esp
80105294:	ff 75 d4             	pushl  -0x2c(%ebp)
80105297:	e8 24 ce ff ff       	call   801020c0 <namei>
8010529c:	83 c4 10             	add    $0x10,%esp
8010529f:	89 c3                	mov    %eax,%ebx
801052a1:	85 c0                	test   %eax,%eax
801052a3:	0f 84 e8 00 00 00    	je     80105391 <sys_link+0x141>
    end_op();
    return -1;
  }

  ilock(ip);
801052a9:	83 ec 0c             	sub    $0xc,%esp
801052ac:	50                   	push   %eax
801052ad:	e8 3e c5 ff ff       	call   801017f0 <ilock>
  if(ip->type == T_DIR){
801052b2:	83 c4 10             	add    $0x10,%esp
801052b5:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052ba:	0f 84 b9 00 00 00    	je     80105379 <sys_link+0x129>
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
801052c0:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801052c3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
801052c8:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801052cb:	53                   	push   %ebx
801052cc:	e8 5f c4 ff ff       	call   80101730 <iupdate>
  iunlock(ip);
801052d1:	89 1c 24             	mov    %ebx,(%esp)
801052d4:	e8 f7 c5 ff ff       	call   801018d0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801052d9:	58                   	pop    %eax
801052da:	5a                   	pop    %edx
801052db:	57                   	push   %edi
801052dc:	ff 75 d0             	pushl  -0x30(%ebp)
801052df:	e8 fc cd ff ff       	call   801020e0 <nameiparent>
801052e4:	83 c4 10             	add    $0x10,%esp
801052e7:	89 c6                	mov    %eax,%esi
801052e9:	85 c0                	test   %eax,%eax
801052eb:	74 5f                	je     8010534c <sys_link+0xfc>
    goto bad;
  ilock(dp);
801052ed:	83 ec 0c             	sub    $0xc,%esp
801052f0:	50                   	push   %eax
801052f1:	e8 fa c4 ff ff       	call   801017f0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801052f6:	8b 03                	mov    (%ebx),%eax
801052f8:	83 c4 10             	add    $0x10,%esp
801052fb:	39 06                	cmp    %eax,(%esi)
801052fd:	75 41                	jne    80105340 <sys_link+0xf0>
801052ff:	83 ec 04             	sub    $0x4,%esp
80105302:	ff 73 04             	pushl  0x4(%ebx)
80105305:	57                   	push   %edi
80105306:	56                   	push   %esi
80105307:	e8 f4 cc ff ff       	call   80102000 <dirlink>
8010530c:	83 c4 10             	add    $0x10,%esp
8010530f:	85 c0                	test   %eax,%eax
80105311:	78 2d                	js     80105340 <sys_link+0xf0>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80105313:	83 ec 0c             	sub    $0xc,%esp
80105316:	56                   	push   %esi
80105317:	e8 74 c7 ff ff       	call   80101a90 <iunlockput>
  iput(ip);
8010531c:	89 1c 24             	mov    %ebx,(%esp)
8010531f:	e8 fc c5 ff ff       	call   80101920 <iput>

  end_op();
80105324:	e8 17 df ff ff       	call   80103240 <end_op>

  return 0;
80105329:	83 c4 10             	add    $0x10,%esp
8010532c:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
8010532e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105331:	5b                   	pop    %ebx
80105332:	5e                   	pop    %esi
80105333:	5f                   	pop    %edi
80105334:	5d                   	pop    %ebp
80105335:	c3                   	ret    
80105336:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010533d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80105340:	83 ec 0c             	sub    $0xc,%esp
80105343:	56                   	push   %esi
80105344:	e8 47 c7 ff ff       	call   80101a90 <iunlockput>
    goto bad;
80105349:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
8010534c:	83 ec 0c             	sub    $0xc,%esp
8010534f:	53                   	push   %ebx
80105350:	e8 9b c4 ff ff       	call   801017f0 <ilock>
  ip->nlink--;
80105355:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010535a:	89 1c 24             	mov    %ebx,(%esp)
8010535d:	e8 ce c3 ff ff       	call   80101730 <iupdate>
  iunlockput(ip);
80105362:	89 1c 24             	mov    %ebx,(%esp)
80105365:	e8 26 c7 ff ff       	call   80101a90 <iunlockput>
  end_op();
8010536a:	e8 d1 de ff ff       	call   80103240 <end_op>
  return -1;
8010536f:	83 c4 10             	add    $0x10,%esp
80105372:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105377:	eb b5                	jmp    8010532e <sys_link+0xde>
    iunlockput(ip);
80105379:	83 ec 0c             	sub    $0xc,%esp
8010537c:	53                   	push   %ebx
8010537d:	e8 0e c7 ff ff       	call   80101a90 <iunlockput>
    end_op();
80105382:	e8 b9 de ff ff       	call   80103240 <end_op>
    return -1;
80105387:	83 c4 10             	add    $0x10,%esp
8010538a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010538f:	eb 9d                	jmp    8010532e <sys_link+0xde>
    end_op();
80105391:	e8 aa de ff ff       	call   80103240 <end_op>
    return -1;
80105396:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010539b:	eb 91                	jmp    8010532e <sys_link+0xde>
8010539d:	8d 76 00             	lea    0x0(%esi),%esi

801053a0 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
801053a0:	f3 0f 1e fb          	endbr32 
801053a4:	55                   	push   %ebp
801053a5:	89 e5                	mov    %esp,%ebp
801053a7:	57                   	push   %edi
801053a8:	56                   	push   %esi
801053a9:	8d 7d d8             	lea    -0x28(%ebp),%edi
801053ac:	53                   	push   %ebx
801053ad:	bb 20 00 00 00       	mov    $0x20,%ebx
801053b2:	83 ec 1c             	sub    $0x1c,%esp
801053b5:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801053b8:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
801053bc:	77 0a                	ja     801053c8 <isdirempty+0x28>
801053be:	eb 30                	jmp    801053f0 <isdirempty+0x50>
801053c0:	83 c3 10             	add    $0x10,%ebx
801053c3:	39 5e 58             	cmp    %ebx,0x58(%esi)
801053c6:	76 28                	jbe    801053f0 <isdirempty+0x50>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801053c8:	6a 10                	push   $0x10
801053ca:	53                   	push   %ebx
801053cb:	57                   	push   %edi
801053cc:	56                   	push   %esi
801053cd:	e8 1e c7 ff ff       	call   80101af0 <readi>
801053d2:	83 c4 10             	add    $0x10,%esp
801053d5:	83 f8 10             	cmp    $0x10,%eax
801053d8:	75 23                	jne    801053fd <isdirempty+0x5d>
      panic("isdirempty: readi");
    if(de.inum != 0)
801053da:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801053df:	74 df                	je     801053c0 <isdirempty+0x20>
      return 0;
  }
  return 1;
}
801053e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801053e4:	31 c0                	xor    %eax,%eax
}
801053e6:	5b                   	pop    %ebx
801053e7:	5e                   	pop    %esi
801053e8:	5f                   	pop    %edi
801053e9:	5d                   	pop    %ebp
801053ea:	c3                   	ret    
801053eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053ef:	90                   	nop
801053f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 1;
801053f3:	b8 01 00 00 00       	mov    $0x1,%eax
}
801053f8:	5b                   	pop    %ebx
801053f9:	5e                   	pop    %esi
801053fa:	5f                   	pop    %edi
801053fb:	5d                   	pop    %ebp
801053fc:	c3                   	ret    
      panic("isdirempty: readi");
801053fd:	83 ec 0c             	sub    $0xc,%esp
80105400:	68 1c 88 10 80       	push   $0x8010881c
80105405:	e8 86 af ff ff       	call   80100390 <panic>
8010540a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105410 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105410:	f3 0f 1e fb          	endbr32 
80105414:	55                   	push   %ebp
80105415:	89 e5                	mov    %esp,%ebp
80105417:	57                   	push   %edi
80105418:	56                   	push   %esi
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105419:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
8010541c:	53                   	push   %ebx
8010541d:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
80105420:	50                   	push   %eax
80105421:	6a 00                	push   $0x0
80105423:	e8 38 fb ff ff       	call   80104f60 <argstr>
80105428:	83 c4 10             	add    $0x10,%esp
8010542b:	85 c0                	test   %eax,%eax
8010542d:	0f 88 5d 01 00 00    	js     80105590 <sys_unlink+0x180>
    return -1;

  begin_op();
80105433:	e8 98 dd ff ff       	call   801031d0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105438:	8d 5d ca             	lea    -0x36(%ebp),%ebx
8010543b:	83 ec 08             	sub    $0x8,%esp
8010543e:	53                   	push   %ebx
8010543f:	ff 75 c0             	pushl  -0x40(%ebp)
80105442:	e8 99 cc ff ff       	call   801020e0 <nameiparent>
80105447:	83 c4 10             	add    $0x10,%esp
8010544a:	89 c6                	mov    %eax,%esi
8010544c:	85 c0                	test   %eax,%eax
8010544e:	0f 84 43 01 00 00    	je     80105597 <sys_unlink+0x187>
    end_op();
    return -1;
  }

  ilock(dp);
80105454:	83 ec 0c             	sub    $0xc,%esp
80105457:	50                   	push   %eax
80105458:	e8 93 c3 ff ff       	call   801017f0 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010545d:	58                   	pop    %eax
8010545e:	5a                   	pop    %edx
8010545f:	68 bd 81 10 80       	push   $0x801081bd
80105464:	53                   	push   %ebx
80105465:	e8 b6 c8 ff ff       	call   80101d20 <namecmp>
8010546a:	83 c4 10             	add    $0x10,%esp
8010546d:	85 c0                	test   %eax,%eax
8010546f:	0f 84 db 00 00 00    	je     80105550 <sys_unlink+0x140>
80105475:	83 ec 08             	sub    $0x8,%esp
80105478:	68 bc 81 10 80       	push   $0x801081bc
8010547d:	53                   	push   %ebx
8010547e:	e8 9d c8 ff ff       	call   80101d20 <namecmp>
80105483:	83 c4 10             	add    $0x10,%esp
80105486:	85 c0                	test   %eax,%eax
80105488:	0f 84 c2 00 00 00    	je     80105550 <sys_unlink+0x140>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010548e:	83 ec 04             	sub    $0x4,%esp
80105491:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105494:	50                   	push   %eax
80105495:	53                   	push   %ebx
80105496:	56                   	push   %esi
80105497:	e8 a4 c8 ff ff       	call   80101d40 <dirlookup>
8010549c:	83 c4 10             	add    $0x10,%esp
8010549f:	89 c3                	mov    %eax,%ebx
801054a1:	85 c0                	test   %eax,%eax
801054a3:	0f 84 a7 00 00 00    	je     80105550 <sys_unlink+0x140>
    goto bad;
  ilock(ip);
801054a9:	83 ec 0c             	sub    $0xc,%esp
801054ac:	50                   	push   %eax
801054ad:	e8 3e c3 ff ff       	call   801017f0 <ilock>

  if(ip->nlink < 1)
801054b2:	83 c4 10             	add    $0x10,%esp
801054b5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801054ba:	0f 8e f3 00 00 00    	jle    801055b3 <sys_unlink+0x1a3>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
801054c0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801054c5:	74 69                	je     80105530 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
801054c7:	83 ec 04             	sub    $0x4,%esp
801054ca:	8d 7d d8             	lea    -0x28(%ebp),%edi
801054cd:	6a 10                	push   $0x10
801054cf:	6a 00                	push   $0x0
801054d1:	57                   	push   %edi
801054d2:	e8 f9 f6 ff ff       	call   80104bd0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801054d7:	6a 10                	push   $0x10
801054d9:	ff 75 c4             	pushl  -0x3c(%ebp)
801054dc:	57                   	push   %edi
801054dd:	56                   	push   %esi
801054de:	e8 0d c7 ff ff       	call   80101bf0 <writei>
801054e3:	83 c4 20             	add    $0x20,%esp
801054e6:	83 f8 10             	cmp    $0x10,%eax
801054e9:	0f 85 b7 00 00 00    	jne    801055a6 <sys_unlink+0x196>
    panic("unlink: writei");
  if(ip->type == T_DIR){
801054ef:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801054f4:	74 7a                	je     80105570 <sys_unlink+0x160>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
801054f6:	83 ec 0c             	sub    $0xc,%esp
801054f9:	56                   	push   %esi
801054fa:	e8 91 c5 ff ff       	call   80101a90 <iunlockput>

  ip->nlink--;
801054ff:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105504:	89 1c 24             	mov    %ebx,(%esp)
80105507:	e8 24 c2 ff ff       	call   80101730 <iupdate>
  iunlockput(ip);
8010550c:	89 1c 24             	mov    %ebx,(%esp)
8010550f:	e8 7c c5 ff ff       	call   80101a90 <iunlockput>

  end_op();
80105514:	e8 27 dd ff ff       	call   80103240 <end_op>

  return 0;
80105519:	83 c4 10             	add    $0x10,%esp
8010551c:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
8010551e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105521:	5b                   	pop    %ebx
80105522:	5e                   	pop    %esi
80105523:	5f                   	pop    %edi
80105524:	5d                   	pop    %ebp
80105525:	c3                   	ret    
80105526:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010552d:	8d 76 00             	lea    0x0(%esi),%esi
  if(ip->type == T_DIR && !isdirempty(ip)){
80105530:	83 ec 0c             	sub    $0xc,%esp
80105533:	53                   	push   %ebx
80105534:	e8 67 fe ff ff       	call   801053a0 <isdirempty>
80105539:	83 c4 10             	add    $0x10,%esp
8010553c:	85 c0                	test   %eax,%eax
8010553e:	75 87                	jne    801054c7 <sys_unlink+0xb7>
    iunlockput(ip);
80105540:	83 ec 0c             	sub    $0xc,%esp
80105543:	53                   	push   %ebx
80105544:	e8 47 c5 ff ff       	call   80101a90 <iunlockput>
    goto bad;
80105549:	83 c4 10             	add    $0x10,%esp
8010554c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
80105550:	83 ec 0c             	sub    $0xc,%esp
80105553:	56                   	push   %esi
80105554:	e8 37 c5 ff ff       	call   80101a90 <iunlockput>
  end_op();
80105559:	e8 e2 dc ff ff       	call   80103240 <end_op>
  return -1;
8010555e:	83 c4 10             	add    $0x10,%esp
80105561:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105566:	eb b6                	jmp    8010551e <sys_unlink+0x10e>
80105568:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010556f:	90                   	nop
    iupdate(dp);
80105570:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105573:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105578:	56                   	push   %esi
80105579:	e8 b2 c1 ff ff       	call   80101730 <iupdate>
8010557e:	83 c4 10             	add    $0x10,%esp
80105581:	e9 70 ff ff ff       	jmp    801054f6 <sys_unlink+0xe6>
80105586:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010558d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105590:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105595:	eb 87                	jmp    8010551e <sys_unlink+0x10e>
    end_op();
80105597:	e8 a4 dc ff ff       	call   80103240 <end_op>
    return -1;
8010559c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055a1:	e9 78 ff ff ff       	jmp    8010551e <sys_unlink+0x10e>
    panic("unlink: writei");
801055a6:	83 ec 0c             	sub    $0xc,%esp
801055a9:	68 d1 81 10 80       	push   $0x801081d1
801055ae:	e8 dd ad ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801055b3:	83 ec 0c             	sub    $0xc,%esp
801055b6:	68 bf 81 10 80       	push   $0x801081bf
801055bb:	e8 d0 ad ff ff       	call   80100390 <panic>

801055c0 <create>:

struct inode*
create(char *path, short type, short major, short minor)
{
801055c0:	f3 0f 1e fb          	endbr32 
801055c4:	55                   	push   %ebp
801055c5:	89 e5                	mov    %esp,%ebp
801055c7:	57                   	push   %edi
801055c8:	56                   	push   %esi
801055c9:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801055ca:	8d 5d da             	lea    -0x26(%ebp),%ebx
{
801055cd:	83 ec 34             	sub    $0x34,%esp
801055d0:	8b 45 0c             	mov    0xc(%ebp),%eax
801055d3:	8b 55 10             	mov    0x10(%ebp),%edx
  if((dp = nameiparent(path, name)) == 0)
801055d6:	53                   	push   %ebx
{
801055d7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
801055da:	ff 75 08             	pushl  0x8(%ebp)
{
801055dd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801055e0:	89 55 d0             	mov    %edx,-0x30(%ebp)
801055e3:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801055e6:	e8 f5 ca ff ff       	call   801020e0 <nameiparent>
801055eb:	83 c4 10             	add    $0x10,%esp
801055ee:	85 c0                	test   %eax,%eax
801055f0:	0f 84 3a 01 00 00    	je     80105730 <create+0x170>
    return 0;
  ilock(dp);
801055f6:	83 ec 0c             	sub    $0xc,%esp
801055f9:	89 c6                	mov    %eax,%esi
801055fb:	50                   	push   %eax
801055fc:	e8 ef c1 ff ff       	call   801017f0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105601:	83 c4 0c             	add    $0xc,%esp
80105604:	6a 00                	push   $0x0
80105606:	53                   	push   %ebx
80105607:	56                   	push   %esi
80105608:	e8 33 c7 ff ff       	call   80101d40 <dirlookup>
8010560d:	83 c4 10             	add    $0x10,%esp
80105610:	89 c7                	mov    %eax,%edi
80105612:	85 c0                	test   %eax,%eax
80105614:	74 4a                	je     80105660 <create+0xa0>
    iunlockput(dp);
80105616:	83 ec 0c             	sub    $0xc,%esp
80105619:	56                   	push   %esi
8010561a:	e8 71 c4 ff ff       	call   80101a90 <iunlockput>
    ilock(ip);
8010561f:	89 3c 24             	mov    %edi,(%esp)
80105622:	e8 c9 c1 ff ff       	call   801017f0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105627:	83 c4 10             	add    $0x10,%esp
8010562a:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
8010562f:	75 17                	jne    80105648 <create+0x88>
80105631:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80105636:	75 10                	jne    80105648 <create+0x88>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105638:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010563b:	89 f8                	mov    %edi,%eax
8010563d:	5b                   	pop    %ebx
8010563e:	5e                   	pop    %esi
8010563f:	5f                   	pop    %edi
80105640:	5d                   	pop    %ebp
80105641:	c3                   	ret    
80105642:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105648:	83 ec 0c             	sub    $0xc,%esp
8010564b:	57                   	push   %edi
    return 0;
8010564c:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
8010564e:	e8 3d c4 ff ff       	call   80101a90 <iunlockput>
    return 0;
80105653:	83 c4 10             	add    $0x10,%esp
}
80105656:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105659:	89 f8                	mov    %edi,%eax
8010565b:	5b                   	pop    %ebx
8010565c:	5e                   	pop    %esi
8010565d:	5f                   	pop    %edi
8010565e:	5d                   	pop    %ebp
8010565f:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80105660:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105664:	83 ec 08             	sub    $0x8,%esp
80105667:	50                   	push   %eax
80105668:	ff 36                	pushl  (%esi)
8010566a:	e8 01 c0 ff ff       	call   80101670 <ialloc>
8010566f:	83 c4 10             	add    $0x10,%esp
80105672:	89 c7                	mov    %eax,%edi
80105674:	85 c0                	test   %eax,%eax
80105676:	0f 84 cd 00 00 00    	je     80105749 <create+0x189>
  ilock(ip);
8010567c:	83 ec 0c             	sub    $0xc,%esp
8010567f:	50                   	push   %eax
80105680:	e8 6b c1 ff ff       	call   801017f0 <ilock>
  ip->major = major;
80105685:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105689:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
8010568d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105691:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105695:	b8 01 00 00 00       	mov    $0x1,%eax
8010569a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
8010569e:	89 3c 24             	mov    %edi,(%esp)
801056a1:	e8 8a c0 ff ff       	call   80101730 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801056a6:	83 c4 10             	add    $0x10,%esp
801056a9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801056ae:	74 30                	je     801056e0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
801056b0:	83 ec 04             	sub    $0x4,%esp
801056b3:	ff 77 04             	pushl  0x4(%edi)
801056b6:	53                   	push   %ebx
801056b7:	56                   	push   %esi
801056b8:	e8 43 c9 ff ff       	call   80102000 <dirlink>
801056bd:	83 c4 10             	add    $0x10,%esp
801056c0:	85 c0                	test   %eax,%eax
801056c2:	78 78                	js     8010573c <create+0x17c>
  iunlockput(dp);
801056c4:	83 ec 0c             	sub    $0xc,%esp
801056c7:	56                   	push   %esi
801056c8:	e8 c3 c3 ff ff       	call   80101a90 <iunlockput>
  return ip;
801056cd:	83 c4 10             	add    $0x10,%esp
}
801056d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056d3:	89 f8                	mov    %edi,%eax
801056d5:	5b                   	pop    %ebx
801056d6:	5e                   	pop    %esi
801056d7:	5f                   	pop    %edi
801056d8:	5d                   	pop    %ebp
801056d9:	c3                   	ret    
801056da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
801056e0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
801056e3:	66 83 46 56 01       	addw   $0x1,0x56(%esi)
    iupdate(dp);
801056e8:	56                   	push   %esi
801056e9:	e8 42 c0 ff ff       	call   80101730 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801056ee:	83 c4 0c             	add    $0xc,%esp
801056f1:	ff 77 04             	pushl  0x4(%edi)
801056f4:	68 bd 81 10 80       	push   $0x801081bd
801056f9:	57                   	push   %edi
801056fa:	e8 01 c9 ff ff       	call   80102000 <dirlink>
801056ff:	83 c4 10             	add    $0x10,%esp
80105702:	85 c0                	test   %eax,%eax
80105704:	78 18                	js     8010571e <create+0x15e>
80105706:	83 ec 04             	sub    $0x4,%esp
80105709:	ff 76 04             	pushl  0x4(%esi)
8010570c:	68 bc 81 10 80       	push   $0x801081bc
80105711:	57                   	push   %edi
80105712:	e8 e9 c8 ff ff       	call   80102000 <dirlink>
80105717:	83 c4 10             	add    $0x10,%esp
8010571a:	85 c0                	test   %eax,%eax
8010571c:	79 92                	jns    801056b0 <create+0xf0>
      panic("create dots");
8010571e:	83 ec 0c             	sub    $0xc,%esp
80105721:	68 3d 88 10 80       	push   $0x8010883d
80105726:	e8 65 ac ff ff       	call   80100390 <panic>
8010572b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010572f:	90                   	nop
}
80105730:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105733:	31 ff                	xor    %edi,%edi
}
80105735:	5b                   	pop    %ebx
80105736:	89 f8                	mov    %edi,%eax
80105738:	5e                   	pop    %esi
80105739:	5f                   	pop    %edi
8010573a:	5d                   	pop    %ebp
8010573b:	c3                   	ret    
    panic("create: dirlink");
8010573c:	83 ec 0c             	sub    $0xc,%esp
8010573f:	68 49 88 10 80       	push   $0x80108849
80105744:	e8 47 ac ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105749:	83 ec 0c             	sub    $0xc,%esp
8010574c:	68 2e 88 10 80       	push   $0x8010882e
80105751:	e8 3a ac ff ff       	call   80100390 <panic>
80105756:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010575d:	8d 76 00             	lea    0x0(%esi),%esi

80105760 <sys_open>:

int
sys_open(void)
{
80105760:	f3 0f 1e fb          	endbr32 
80105764:	55                   	push   %ebp
80105765:	89 e5                	mov    %esp,%ebp
80105767:	57                   	push   %edi
80105768:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105769:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
8010576c:	53                   	push   %ebx
8010576d:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105770:	50                   	push   %eax
80105771:	6a 00                	push   $0x0
80105773:	e8 e8 f7 ff ff       	call   80104f60 <argstr>
80105778:	83 c4 10             	add    $0x10,%esp
8010577b:	85 c0                	test   %eax,%eax
8010577d:	0f 88 8a 00 00 00    	js     8010580d <sys_open+0xad>
80105783:	83 ec 08             	sub    $0x8,%esp
80105786:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105789:	50                   	push   %eax
8010578a:	6a 01                	push   $0x1
8010578c:	e8 1f f7 ff ff       	call   80104eb0 <argint>
80105791:	83 c4 10             	add    $0x10,%esp
80105794:	85 c0                	test   %eax,%eax
80105796:	78 75                	js     8010580d <sys_open+0xad>
    return -1;

  begin_op();
80105798:	e8 33 da ff ff       	call   801031d0 <begin_op>

  if(omode & O_CREATE){
8010579d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801057a1:	75 75                	jne    80105818 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801057a3:	83 ec 0c             	sub    $0xc,%esp
801057a6:	ff 75 e0             	pushl  -0x20(%ebp)
801057a9:	e8 12 c9 ff ff       	call   801020c0 <namei>
801057ae:	83 c4 10             	add    $0x10,%esp
801057b1:	89 c6                	mov    %eax,%esi
801057b3:	85 c0                	test   %eax,%eax
801057b5:	74 78                	je     8010582f <sys_open+0xcf>
      end_op();
      return -1;
    }
    ilock(ip);
801057b7:	83 ec 0c             	sub    $0xc,%esp
801057ba:	50                   	push   %eax
801057bb:	e8 30 c0 ff ff       	call   801017f0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801057c0:	83 c4 10             	add    $0x10,%esp
801057c3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801057c8:	0f 84 ba 00 00 00    	je     80105888 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801057ce:	e8 bd b6 ff ff       	call   80100e90 <filealloc>
801057d3:	89 c7                	mov    %eax,%edi
801057d5:	85 c0                	test   %eax,%eax
801057d7:	74 23                	je     801057fc <sys_open+0x9c>
  struct proc *curproc = myproc();
801057d9:	e8 52 e6 ff ff       	call   80103e30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801057de:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801057e0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801057e4:	85 d2                	test   %edx,%edx
801057e6:	74 58                	je     80105840 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
801057e8:	83 c3 01             	add    $0x1,%ebx
801057eb:	83 fb 10             	cmp    $0x10,%ebx
801057ee:	75 f0                	jne    801057e0 <sys_open+0x80>
    if(f)
      fileclose(f);
801057f0:	83 ec 0c             	sub    $0xc,%esp
801057f3:	57                   	push   %edi
801057f4:	e8 57 b7 ff ff       	call   80100f50 <fileclose>
801057f9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801057fc:	83 ec 0c             	sub    $0xc,%esp
801057ff:	56                   	push   %esi
80105800:	e8 8b c2 ff ff       	call   80101a90 <iunlockput>
    end_op();
80105805:	e8 36 da ff ff       	call   80103240 <end_op>
    return -1;
8010580a:	83 c4 10             	add    $0x10,%esp
8010580d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105812:	eb 65                	jmp    80105879 <sys_open+0x119>
80105814:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105818:	6a 00                	push   $0x0
8010581a:	6a 00                	push   $0x0
8010581c:	6a 02                	push   $0x2
8010581e:	ff 75 e0             	pushl  -0x20(%ebp)
80105821:	e8 9a fd ff ff       	call   801055c0 <create>
    if(ip == 0){
80105826:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105829:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010582b:	85 c0                	test   %eax,%eax
8010582d:	75 9f                	jne    801057ce <sys_open+0x6e>
      end_op();
8010582f:	e8 0c da ff ff       	call   80103240 <end_op>
      return -1;
80105834:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105839:	eb 3e                	jmp    80105879 <sys_open+0x119>
8010583b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010583f:	90                   	nop
  }
  iunlock(ip);
80105840:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105843:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105847:	56                   	push   %esi
80105848:	e8 83 c0 ff ff       	call   801018d0 <iunlock>
  end_op();
8010584d:	e8 ee d9 ff ff       	call   80103240 <end_op>

  f->type = FD_INODE;
80105852:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105858:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010585b:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
8010585e:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105861:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105863:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010586a:	f7 d0                	not    %eax
8010586c:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010586f:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105872:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105875:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105879:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010587c:	89 d8                	mov    %ebx,%eax
8010587e:	5b                   	pop    %ebx
8010587f:	5e                   	pop    %esi
80105880:	5f                   	pop    %edi
80105881:	5d                   	pop    %ebp
80105882:	c3                   	ret    
80105883:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105887:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105888:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010588b:	85 c9                	test   %ecx,%ecx
8010588d:	0f 84 3b ff ff ff    	je     801057ce <sys_open+0x6e>
80105893:	e9 64 ff ff ff       	jmp    801057fc <sys_open+0x9c>
80105898:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010589f:	90                   	nop

801058a0 <sys_mkdir>:

int
sys_mkdir(void)
{
801058a0:	f3 0f 1e fb          	endbr32 
801058a4:	55                   	push   %ebp
801058a5:	89 e5                	mov    %esp,%ebp
801058a7:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801058aa:	e8 21 d9 ff ff       	call   801031d0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801058af:	83 ec 08             	sub    $0x8,%esp
801058b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058b5:	50                   	push   %eax
801058b6:	6a 00                	push   $0x0
801058b8:	e8 a3 f6 ff ff       	call   80104f60 <argstr>
801058bd:	83 c4 10             	add    $0x10,%esp
801058c0:	85 c0                	test   %eax,%eax
801058c2:	78 2c                	js     801058f0 <sys_mkdir+0x50>
801058c4:	6a 00                	push   $0x0
801058c6:	6a 00                	push   $0x0
801058c8:	6a 01                	push   $0x1
801058ca:	ff 75 f4             	pushl  -0xc(%ebp)
801058cd:	e8 ee fc ff ff       	call   801055c0 <create>
801058d2:	83 c4 10             	add    $0x10,%esp
801058d5:	85 c0                	test   %eax,%eax
801058d7:	74 17                	je     801058f0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801058d9:	83 ec 0c             	sub    $0xc,%esp
801058dc:	50                   	push   %eax
801058dd:	e8 ae c1 ff ff       	call   80101a90 <iunlockput>
  end_op();
801058e2:	e8 59 d9 ff ff       	call   80103240 <end_op>
  return 0;
801058e7:	83 c4 10             	add    $0x10,%esp
801058ea:	31 c0                	xor    %eax,%eax
}
801058ec:	c9                   	leave  
801058ed:	c3                   	ret    
801058ee:	66 90                	xchg   %ax,%ax
    end_op();
801058f0:	e8 4b d9 ff ff       	call   80103240 <end_op>
    return -1;
801058f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058fa:	c9                   	leave  
801058fb:	c3                   	ret    
801058fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105900 <sys_mknod>:

int
sys_mknod(void)
{
80105900:	f3 0f 1e fb          	endbr32 
80105904:	55                   	push   %ebp
80105905:	89 e5                	mov    %esp,%ebp
80105907:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
8010590a:	e8 c1 d8 ff ff       	call   801031d0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010590f:	83 ec 08             	sub    $0x8,%esp
80105912:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105915:	50                   	push   %eax
80105916:	6a 00                	push   $0x0
80105918:	e8 43 f6 ff ff       	call   80104f60 <argstr>
8010591d:	83 c4 10             	add    $0x10,%esp
80105920:	85 c0                	test   %eax,%eax
80105922:	78 5c                	js     80105980 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105924:	83 ec 08             	sub    $0x8,%esp
80105927:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010592a:	50                   	push   %eax
8010592b:	6a 01                	push   $0x1
8010592d:	e8 7e f5 ff ff       	call   80104eb0 <argint>
  if((argstr(0, &path)) < 0 ||
80105932:	83 c4 10             	add    $0x10,%esp
80105935:	85 c0                	test   %eax,%eax
80105937:	78 47                	js     80105980 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105939:	83 ec 08             	sub    $0x8,%esp
8010593c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010593f:	50                   	push   %eax
80105940:	6a 02                	push   $0x2
80105942:	e8 69 f5 ff ff       	call   80104eb0 <argint>
     argint(1, &major) < 0 ||
80105947:	83 c4 10             	add    $0x10,%esp
8010594a:	85 c0                	test   %eax,%eax
8010594c:	78 32                	js     80105980 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010594e:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105952:	50                   	push   %eax
80105953:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
80105957:	50                   	push   %eax
80105958:	6a 03                	push   $0x3
8010595a:	ff 75 ec             	pushl  -0x14(%ebp)
8010595d:	e8 5e fc ff ff       	call   801055c0 <create>
     argint(2, &minor) < 0 ||
80105962:	83 c4 10             	add    $0x10,%esp
80105965:	85 c0                	test   %eax,%eax
80105967:	74 17                	je     80105980 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105969:	83 ec 0c             	sub    $0xc,%esp
8010596c:	50                   	push   %eax
8010596d:	e8 1e c1 ff ff       	call   80101a90 <iunlockput>
  end_op();
80105972:	e8 c9 d8 ff ff       	call   80103240 <end_op>
  return 0;
80105977:	83 c4 10             	add    $0x10,%esp
8010597a:	31 c0                	xor    %eax,%eax
}
8010597c:	c9                   	leave  
8010597d:	c3                   	ret    
8010597e:	66 90                	xchg   %ax,%ax
    end_op();
80105980:	e8 bb d8 ff ff       	call   80103240 <end_op>
    return -1;
80105985:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010598a:	c9                   	leave  
8010598b:	c3                   	ret    
8010598c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105990 <sys_chdir>:

int
sys_chdir(void)
{
80105990:	f3 0f 1e fb          	endbr32 
80105994:	55                   	push   %ebp
80105995:	89 e5                	mov    %esp,%ebp
80105997:	56                   	push   %esi
80105998:	53                   	push   %ebx
80105999:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
8010599c:	e8 8f e4 ff ff       	call   80103e30 <myproc>
801059a1:	89 c6                	mov    %eax,%esi
  
  begin_op();
801059a3:	e8 28 d8 ff ff       	call   801031d0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801059a8:	83 ec 08             	sub    $0x8,%esp
801059ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059ae:	50                   	push   %eax
801059af:	6a 00                	push   $0x0
801059b1:	e8 aa f5 ff ff       	call   80104f60 <argstr>
801059b6:	83 c4 10             	add    $0x10,%esp
801059b9:	85 c0                	test   %eax,%eax
801059bb:	78 73                	js     80105a30 <sys_chdir+0xa0>
801059bd:	83 ec 0c             	sub    $0xc,%esp
801059c0:	ff 75 f4             	pushl  -0xc(%ebp)
801059c3:	e8 f8 c6 ff ff       	call   801020c0 <namei>
801059c8:	83 c4 10             	add    $0x10,%esp
801059cb:	89 c3                	mov    %eax,%ebx
801059cd:	85 c0                	test   %eax,%eax
801059cf:	74 5f                	je     80105a30 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801059d1:	83 ec 0c             	sub    $0xc,%esp
801059d4:	50                   	push   %eax
801059d5:	e8 16 be ff ff       	call   801017f0 <ilock>
  if(ip->type != T_DIR){
801059da:	83 c4 10             	add    $0x10,%esp
801059dd:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801059e2:	75 2c                	jne    80105a10 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801059e4:	83 ec 0c             	sub    $0xc,%esp
801059e7:	53                   	push   %ebx
801059e8:	e8 e3 be ff ff       	call   801018d0 <iunlock>
  iput(curproc->cwd);
801059ed:	58                   	pop    %eax
801059ee:	ff 76 68             	pushl  0x68(%esi)
801059f1:	e8 2a bf ff ff       	call   80101920 <iput>
  end_op();
801059f6:	e8 45 d8 ff ff       	call   80103240 <end_op>
  curproc->cwd = ip;
801059fb:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801059fe:	83 c4 10             	add    $0x10,%esp
80105a01:	31 c0                	xor    %eax,%eax
}
80105a03:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105a06:	5b                   	pop    %ebx
80105a07:	5e                   	pop    %esi
80105a08:	5d                   	pop    %ebp
80105a09:	c3                   	ret    
80105a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105a10:	83 ec 0c             	sub    $0xc,%esp
80105a13:	53                   	push   %ebx
80105a14:	e8 77 c0 ff ff       	call   80101a90 <iunlockput>
    end_op();
80105a19:	e8 22 d8 ff ff       	call   80103240 <end_op>
    return -1;
80105a1e:	83 c4 10             	add    $0x10,%esp
80105a21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a26:	eb db                	jmp    80105a03 <sys_chdir+0x73>
80105a28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a2f:	90                   	nop
    end_op();
80105a30:	e8 0b d8 ff ff       	call   80103240 <end_op>
    return -1;
80105a35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a3a:	eb c7                	jmp    80105a03 <sys_chdir+0x73>
80105a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a40 <sys_exec>:

int
sys_exec(void)
{
80105a40:	f3 0f 1e fb          	endbr32 
80105a44:	55                   	push   %ebp
80105a45:	89 e5                	mov    %esp,%ebp
80105a47:	57                   	push   %edi
80105a48:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105a49:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105a4f:	53                   	push   %ebx
80105a50:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105a56:	50                   	push   %eax
80105a57:	6a 00                	push   $0x0
80105a59:	e8 02 f5 ff ff       	call   80104f60 <argstr>
80105a5e:	83 c4 10             	add    $0x10,%esp
80105a61:	85 c0                	test   %eax,%eax
80105a63:	0f 88 8b 00 00 00    	js     80105af4 <sys_exec+0xb4>
80105a69:	83 ec 08             	sub    $0x8,%esp
80105a6c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105a72:	50                   	push   %eax
80105a73:	6a 01                	push   $0x1
80105a75:	e8 36 f4 ff ff       	call   80104eb0 <argint>
80105a7a:	83 c4 10             	add    $0x10,%esp
80105a7d:	85 c0                	test   %eax,%eax
80105a7f:	78 73                	js     80105af4 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105a81:	83 ec 04             	sub    $0x4,%esp
80105a84:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
80105a8a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105a8c:	68 80 00 00 00       	push   $0x80
80105a91:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105a97:	6a 00                	push   $0x0
80105a99:	50                   	push   %eax
80105a9a:	e8 31 f1 ff ff       	call   80104bd0 <memset>
80105a9f:	83 c4 10             	add    $0x10,%esp
80105aa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105aa8:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105aae:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105ab5:	83 ec 08             	sub    $0x8,%esp
80105ab8:	57                   	push   %edi
80105ab9:	01 f0                	add    %esi,%eax
80105abb:	50                   	push   %eax
80105abc:	e8 4f f3 ff ff       	call   80104e10 <fetchint>
80105ac1:	83 c4 10             	add    $0x10,%esp
80105ac4:	85 c0                	test   %eax,%eax
80105ac6:	78 2c                	js     80105af4 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80105ac8:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105ace:	85 c0                	test   %eax,%eax
80105ad0:	74 36                	je     80105b08 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105ad2:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105ad8:	83 ec 08             	sub    $0x8,%esp
80105adb:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105ade:	52                   	push   %edx
80105adf:	50                   	push   %eax
80105ae0:	e8 6b f3 ff ff       	call   80104e50 <fetchstr>
80105ae5:	83 c4 10             	add    $0x10,%esp
80105ae8:	85 c0                	test   %eax,%eax
80105aea:	78 08                	js     80105af4 <sys_exec+0xb4>
  for(i=0;; i++){
80105aec:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105aef:	83 fb 20             	cmp    $0x20,%ebx
80105af2:	75 b4                	jne    80105aa8 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80105af4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105af7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105afc:	5b                   	pop    %ebx
80105afd:	5e                   	pop    %esi
80105afe:	5f                   	pop    %edi
80105aff:	5d                   	pop    %ebp
80105b00:	c3                   	ret    
80105b01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105b08:	83 ec 08             	sub    $0x8,%esp
80105b0b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105b11:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105b18:	00 00 00 00 
  return exec(path, argv);
80105b1c:	50                   	push   %eax
80105b1d:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105b23:	e8 e8 af ff ff       	call   80100b10 <exec>
80105b28:	83 c4 10             	add    $0x10,%esp
}
80105b2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b2e:	5b                   	pop    %ebx
80105b2f:	5e                   	pop    %esi
80105b30:	5f                   	pop    %edi
80105b31:	5d                   	pop    %ebp
80105b32:	c3                   	ret    
80105b33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105b40 <sys_pipe>:

int
sys_pipe(void)
{
80105b40:	f3 0f 1e fb          	endbr32 
80105b44:	55                   	push   %ebp
80105b45:	89 e5                	mov    %esp,%ebp
80105b47:	57                   	push   %edi
80105b48:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105b49:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105b4c:	53                   	push   %ebx
80105b4d:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105b50:	6a 08                	push   $0x8
80105b52:	50                   	push   %eax
80105b53:	6a 00                	push   $0x0
80105b55:	e8 a6 f3 ff ff       	call   80104f00 <argptr>
80105b5a:	83 c4 10             	add    $0x10,%esp
80105b5d:	85 c0                	test   %eax,%eax
80105b5f:	78 4e                	js     80105baf <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105b61:	83 ec 08             	sub    $0x8,%esp
80105b64:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105b67:	50                   	push   %eax
80105b68:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105b6b:	50                   	push   %eax
80105b6c:	e8 2f dd ff ff       	call   801038a0 <pipealloc>
80105b71:	83 c4 10             	add    $0x10,%esp
80105b74:	85 c0                	test   %eax,%eax
80105b76:	78 37                	js     80105baf <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105b78:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105b7b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105b7d:	e8 ae e2 ff ff       	call   80103e30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105b82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105b88:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105b8c:	85 f6                	test   %esi,%esi
80105b8e:	74 30                	je     80105bc0 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80105b90:	83 c3 01             	add    $0x1,%ebx
80105b93:	83 fb 10             	cmp    $0x10,%ebx
80105b96:	75 f0                	jne    80105b88 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105b98:	83 ec 0c             	sub    $0xc,%esp
80105b9b:	ff 75 e0             	pushl  -0x20(%ebp)
80105b9e:	e8 ad b3 ff ff       	call   80100f50 <fileclose>
    fileclose(wf);
80105ba3:	58                   	pop    %eax
80105ba4:	ff 75 e4             	pushl  -0x1c(%ebp)
80105ba7:	e8 a4 b3 ff ff       	call   80100f50 <fileclose>
    return -1;
80105bac:	83 c4 10             	add    $0x10,%esp
80105baf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bb4:	eb 5b                	jmp    80105c11 <sys_pipe+0xd1>
80105bb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bbd:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105bc0:	8d 73 08             	lea    0x8(%ebx),%esi
80105bc3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105bc7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105bca:	e8 61 e2 ff ff       	call   80103e30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105bcf:	31 d2                	xor    %edx,%edx
80105bd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105bd8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105bdc:	85 c9                	test   %ecx,%ecx
80105bde:	74 20                	je     80105c00 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105be0:	83 c2 01             	add    $0x1,%edx
80105be3:	83 fa 10             	cmp    $0x10,%edx
80105be6:	75 f0                	jne    80105bd8 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105be8:	e8 43 e2 ff ff       	call   80103e30 <myproc>
80105bed:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105bf4:	00 
80105bf5:	eb a1                	jmp    80105b98 <sys_pipe+0x58>
80105bf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bfe:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105c00:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105c04:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105c07:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105c09:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105c0c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105c0f:	31 c0                	xor    %eax,%eax
}
80105c11:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c14:	5b                   	pop    %ebx
80105c15:	5e                   	pop    %esi
80105c16:	5f                   	pop    %edi
80105c17:	5d                   	pop    %ebp
80105c18:	c3                   	ret    
80105c19:	66 90                	xchg   %ax,%ax
80105c1b:	66 90                	xchg   %ax,%ax
80105c1d:	66 90                	xchg   %ax,%ax
80105c1f:	90                   	nop

80105c20 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105c20:	f3 0f 1e fb          	endbr32 
  return fork();
80105c24:	e9 e7 e3 ff ff       	jmp    80104010 <fork>
80105c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105c30 <sys_exit>:
}

int
sys_exit(void)
{
80105c30:	f3 0f 1e fb          	endbr32 
80105c34:	55                   	push   %ebp
80105c35:	89 e5                	mov    %esp,%ebp
80105c37:	83 ec 08             	sub    $0x8,%esp
  exit();
80105c3a:	e8 81 e6 ff ff       	call   801042c0 <exit>
  return 0;  // not reached
}
80105c3f:	31 c0                	xor    %eax,%eax
80105c41:	c9                   	leave  
80105c42:	c3                   	ret    
80105c43:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105c50 <sys_wait>:

int
sys_wait(void)
{
80105c50:	f3 0f 1e fb          	endbr32 
  return wait();
80105c54:	e9 b7 e8 ff ff       	jmp    80104510 <wait>
80105c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105c60 <sys_kill>:
}

int
sys_kill(void)
{
80105c60:	f3 0f 1e fb          	endbr32 
80105c64:	55                   	push   %ebp
80105c65:	89 e5                	mov    %esp,%ebp
80105c67:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105c6a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c6d:	50                   	push   %eax
80105c6e:	6a 00                	push   $0x0
80105c70:	e8 3b f2 ff ff       	call   80104eb0 <argint>
80105c75:	83 c4 10             	add    $0x10,%esp
80105c78:	85 c0                	test   %eax,%eax
80105c7a:	78 14                	js     80105c90 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105c7c:	83 ec 0c             	sub    $0xc,%esp
80105c7f:	ff 75 f4             	pushl  -0xc(%ebp)
80105c82:	e8 f9 e9 ff ff       	call   80104680 <kill>
80105c87:	83 c4 10             	add    $0x10,%esp
}
80105c8a:	c9                   	leave  
80105c8b:	c3                   	ret    
80105c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c90:	c9                   	leave  
    return -1;
80105c91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c96:	c3                   	ret    
80105c97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c9e:	66 90                	xchg   %ax,%ax

80105ca0 <sys_getpid>:

int
sys_getpid(void)
{
80105ca0:	f3 0f 1e fb          	endbr32 
80105ca4:	55                   	push   %ebp
80105ca5:	89 e5                	mov    %esp,%ebp
80105ca7:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105caa:	e8 81 e1 ff ff       	call   80103e30 <myproc>
80105caf:	8b 40 10             	mov    0x10(%eax),%eax
}
80105cb2:	c9                   	leave  
80105cb3:	c3                   	ret    
80105cb4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105cbf:	90                   	nop

80105cc0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105cc0:	f3 0f 1e fb          	endbr32 
80105cc4:	55                   	push   %ebp
80105cc5:	89 e5                	mov    %esp,%ebp
80105cc7:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105cc8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105ccb:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105cce:	50                   	push   %eax
80105ccf:	6a 00                	push   $0x0
80105cd1:	e8 da f1 ff ff       	call   80104eb0 <argint>
80105cd6:	83 c4 10             	add    $0x10,%esp
80105cd9:	85 c0                	test   %eax,%eax
80105cdb:	78 23                	js     80105d00 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105cdd:	e8 4e e1 ff ff       	call   80103e30 <myproc>
  if(growproc(n) < 0)
80105ce2:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105ce5:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105ce7:	ff 75 f4             	pushl  -0xc(%ebp)
80105cea:	e8 71 e2 ff ff       	call   80103f60 <growproc>
80105cef:	83 c4 10             	add    $0x10,%esp
80105cf2:	85 c0                	test   %eax,%eax
80105cf4:	78 0a                	js     80105d00 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105cf6:	89 d8                	mov    %ebx,%eax
80105cf8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105cfb:	c9                   	leave  
80105cfc:	c3                   	ret    
80105cfd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105d00:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105d05:	eb ef                	jmp    80105cf6 <sys_sbrk+0x36>
80105d07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d0e:	66 90                	xchg   %ax,%ax

80105d10 <sys_sleep>:

int
sys_sleep(void)
{
80105d10:	f3 0f 1e fb          	endbr32 
80105d14:	55                   	push   %ebp
80105d15:	89 e5                	mov    %esp,%ebp
80105d17:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105d18:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105d1b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105d1e:	50                   	push   %eax
80105d1f:	6a 00                	push   $0x0
80105d21:	e8 8a f1 ff ff       	call   80104eb0 <argint>
80105d26:	83 c4 10             	add    $0x10,%esp
80105d29:	85 c0                	test   %eax,%eax
80105d2b:	0f 88 86 00 00 00    	js     80105db7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105d31:	83 ec 0c             	sub    $0xc,%esp
80105d34:	68 e0 01 13 80       	push   $0x801301e0
80105d39:	e8 82 ed ff ff       	call   80104ac0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105d3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105d41:	8b 1d 20 0a 13 80    	mov    0x80130a20,%ebx
  while(ticks - ticks0 < n){
80105d47:	83 c4 10             	add    $0x10,%esp
80105d4a:	85 d2                	test   %edx,%edx
80105d4c:	75 23                	jne    80105d71 <sys_sleep+0x61>
80105d4e:	eb 50                	jmp    80105da0 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105d50:	83 ec 08             	sub    $0x8,%esp
80105d53:	68 e0 01 13 80       	push   $0x801301e0
80105d58:	68 20 0a 13 80       	push   $0x80130a20
80105d5d:	e8 ee e6 ff ff       	call   80104450 <sleep>
  while(ticks - ticks0 < n){
80105d62:	a1 20 0a 13 80       	mov    0x80130a20,%eax
80105d67:	83 c4 10             	add    $0x10,%esp
80105d6a:	29 d8                	sub    %ebx,%eax
80105d6c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105d6f:	73 2f                	jae    80105da0 <sys_sleep+0x90>
    if(myproc()->killed){
80105d71:	e8 ba e0 ff ff       	call   80103e30 <myproc>
80105d76:	8b 40 24             	mov    0x24(%eax),%eax
80105d79:	85 c0                	test   %eax,%eax
80105d7b:	74 d3                	je     80105d50 <sys_sleep+0x40>
      release(&tickslock);
80105d7d:	83 ec 0c             	sub    $0xc,%esp
80105d80:	68 e0 01 13 80       	push   $0x801301e0
80105d85:	e8 f6 ed ff ff       	call   80104b80 <release>
  }
  release(&tickslock);
  return 0;
}
80105d8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105d8d:	83 c4 10             	add    $0x10,%esp
80105d90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d95:	c9                   	leave  
80105d96:	c3                   	ret    
80105d97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d9e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105da0:	83 ec 0c             	sub    $0xc,%esp
80105da3:	68 e0 01 13 80       	push   $0x801301e0
80105da8:	e8 d3 ed ff ff       	call   80104b80 <release>
  return 0;
80105dad:	83 c4 10             	add    $0x10,%esp
80105db0:	31 c0                	xor    %eax,%eax
}
80105db2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105db5:	c9                   	leave  
80105db6:	c3                   	ret    
    return -1;
80105db7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dbc:	eb f4                	jmp    80105db2 <sys_sleep+0xa2>
80105dbe:	66 90                	xchg   %ax,%ax

80105dc0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105dc0:	f3 0f 1e fb          	endbr32 
80105dc4:	55                   	push   %ebp
80105dc5:	89 e5                	mov    %esp,%ebp
80105dc7:	53                   	push   %ebx
80105dc8:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105dcb:	68 e0 01 13 80       	push   $0x801301e0
80105dd0:	e8 eb ec ff ff       	call   80104ac0 <acquire>
  xticks = ticks;
80105dd5:	8b 1d 20 0a 13 80    	mov    0x80130a20,%ebx
  release(&tickslock);
80105ddb:	c7 04 24 e0 01 13 80 	movl   $0x801301e0,(%esp)
80105de2:	e8 99 ed ff ff       	call   80104b80 <release>
  return xticks;
}
80105de7:	89 d8                	mov    %ebx,%eax
80105de9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105dec:	c9                   	leave  
80105ded:	c3                   	ret    
80105dee:	66 90                	xchg   %ax,%ax

80105df0 <sys_get_number_of_free_pages>:

int sys_get_number_of_free_pages(void){
80105df0:	f3 0f 1e fb          	endbr32 
  return sys_get_number_of_free_pages_impl();
80105df4:	e9 e7 e1 ff ff       	jmp    80103fe0 <sys_get_number_of_free_pages_impl>

80105df9 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105df9:	1e                   	push   %ds
  pushl %es
80105dfa:	06                   	push   %es
  pushl %fs
80105dfb:	0f a0                	push   %fs
  pushl %gs
80105dfd:	0f a8                	push   %gs
  pushal
80105dff:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105e00:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105e04:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105e06:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105e08:	54                   	push   %esp
  call trap
80105e09:	e8 c2 00 00 00       	call   80105ed0 <trap>
  addl $4, %esp
80105e0e:	83 c4 04             	add    $0x4,%esp

80105e11 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105e11:	61                   	popa   
  popl %gs
80105e12:	0f a9                	pop    %gs
  popl %fs
80105e14:	0f a1                	pop    %fs
  popl %es
80105e16:	07                   	pop    %es
  popl %ds
80105e17:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105e18:	83 c4 08             	add    $0x8,%esp
  iret
80105e1b:	cf                   	iret   
80105e1c:	66 90                	xchg   %ax,%ax
80105e1e:	66 90                	xchg   %ax,%ax

80105e20 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105e20:	f3 0f 1e fb          	endbr32 
80105e24:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105e25:	31 c0                	xor    %eax,%eax
{
80105e27:	89 e5                	mov    %esp,%ebp
80105e29:	83 ec 08             	sub    $0x8,%esp
80105e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105e30:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105e37:	c7 04 c5 22 02 13 80 	movl   $0x8e000008,-0x7fecfdde(,%eax,8)
80105e3e:	08 00 00 8e 
80105e42:	66 89 14 c5 20 02 13 	mov    %dx,-0x7fecfde0(,%eax,8)
80105e49:	80 
80105e4a:	c1 ea 10             	shr    $0x10,%edx
80105e4d:	66 89 14 c5 26 02 13 	mov    %dx,-0x7fecfdda(,%eax,8)
80105e54:	80 
  for(i = 0; i < 256; i++)
80105e55:	83 c0 01             	add    $0x1,%eax
80105e58:	3d 00 01 00 00       	cmp    $0x100,%eax
80105e5d:	75 d1                	jne    80105e30 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105e5f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105e62:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105e67:	c7 05 22 04 13 80 08 	movl   $0xef000008,0x80130422
80105e6e:	00 00 ef 
  initlock(&tickslock, "time");
80105e71:	68 59 88 10 80       	push   $0x80108859
80105e76:	68 e0 01 13 80       	push   $0x801301e0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105e7b:	66 a3 20 04 13 80    	mov    %ax,0x80130420
80105e81:	c1 e8 10             	shr    $0x10,%eax
80105e84:	66 a3 26 04 13 80    	mov    %ax,0x80130426
  initlock(&tickslock, "time");
80105e8a:	e8 b1 ea ff ff       	call   80104940 <initlock>
}
80105e8f:	83 c4 10             	add    $0x10,%esp
80105e92:	c9                   	leave  
80105e93:	c3                   	ret    
80105e94:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e9f:	90                   	nop

80105ea0 <idtinit>:

void
idtinit(void)
{
80105ea0:	f3 0f 1e fb          	endbr32 
80105ea4:	55                   	push   %ebp
  pd[0] = size-1;
80105ea5:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105eaa:	89 e5                	mov    %esp,%ebp
80105eac:	83 ec 10             	sub    $0x10,%esp
80105eaf:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105eb3:	b8 20 02 13 80       	mov    $0x80130220,%eax
80105eb8:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105ebc:	c1 e8 10             	shr    $0x10,%eax
80105ebf:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105ec3:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105ec6:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105ec9:	c9                   	leave  
80105eca:	c3                   	ret    
80105ecb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ecf:	90                   	nop

80105ed0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105ed0:	f3 0f 1e fb          	endbr32 
80105ed4:	55                   	push   %ebp
80105ed5:	89 e5                	mov    %esp,%ebp
80105ed7:	57                   	push   %edi
80105ed8:	56                   	push   %esi
80105ed9:	53                   	push   %ebx
80105eda:	83 ec 1c             	sub    $0x1c,%esp
80105edd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105ee0:	8b 43 30             	mov    0x30(%ebx),%eax
80105ee3:	83 f8 40             	cmp    $0x40,%eax
80105ee6:	0f 84 6c 02 00 00    	je     80106158 <trap+0x288>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105eec:	83 e8 0e             	sub    $0xe,%eax
80105eef:	83 f8 31             	cmp    $0x31,%eax
80105ef2:	0f 87 2b 01 00 00    	ja     80106023 <trap+0x153>
80105ef8:	3e ff 24 85 48 89 10 	notrack jmp *-0x7fef76b8(,%eax,4)
80105eff:	80 

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105f00:	0f 20 d7             	mov    %cr2,%edi
    break;

  case T_PGFLT:
  ;
    uint faulting_addr = rcr2();
    struct proc* p = myproc();
80105f03:	e8 28 df ff ff       	call   80103e30 <myproc>
    pte_t* pte_ptr = public_walkpgdir(p->pgdir, (void *)faulting_addr, 0);
80105f08:	83 ec 04             	sub    $0x4,%esp
80105f0b:	6a 00                	push   $0x0
80105f0d:	57                   	push   %edi
80105f0e:	ff 70 04             	pushl  0x4(%eax)
    struct proc* p = myproc();
80105f11:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pte_t* pte_ptr = public_walkpgdir(p->pgdir, (void *)faulting_addr, 0);
80105f14:	e8 67 14 00 00       	call   80107380 <public_walkpgdir>
    if (!(pte_ptr == 0) && (*pte_ptr & PTE_U) && (*pte_ptr & PTE_PG)){
80105f19:	83 c4 10             	add    $0x10,%esp
    pte_t* pte_ptr = public_walkpgdir(p->pgdir, (void *)faulting_addr, 0);
80105f1c:	89 c6                	mov    %eax,%esi
    if (!(pte_ptr == 0) && (*pte_ptr & PTE_U) && (*pte_ptr & PTE_PG)){
80105f1e:	85 c0                	test   %eax,%eax
80105f20:	0f 84 fd 00 00 00    	je     80106023 <trap+0x153>
80105f26:	8b 00                	mov    (%eax),%eax
80105f28:	89 c1                	mov    %eax,%ecx
80105f2a:	81 e1 04 02 00 00    	and    $0x204,%ecx
80105f30:	81 f9 04 02 00 00    	cmp    $0x204,%ecx
80105f36:	0f 84 ac 02 00 00    	je     801061e8 <trap+0x318>
        }
      }
      p->num_of_pagefaults_occurs++;
      break;
    }
    if (!(pte_ptr == 0) && *pte_ptr & PTE_COW){
80105f3c:	f6 c4 08             	test   $0x8,%ah
80105f3f:	0f 84 de 00 00 00    	je     80106023 <trap+0x153>
      // cprintf("trap %d\n", p->pid);
      acquire(cow_lock);
80105f45:	83 ec 0c             	sub    $0xc,%esp
80105f48:	ff 35 40 ef 11 80    	pushl  0x8011ef40
80105f4e:	e8 6d eb ff ff       	call   80104ac0 <acquire>
      char* ref_count = &(pg_ref_counts[PGROUNDDOWN(PTE_ADDR(*pte_ptr)) / PGSIZE]);
80105f53:	8b 0e                	mov    (%esi),%ecx
      if (*ref_count == 1){
80105f55:	83 c4 10             	add    $0x10,%esp
      char* ref_count = &(pg_ref_counts[PGROUNDDOWN(PTE_ADDR(*pte_ptr)) / PGSIZE]);
80105f58:	89 ca                	mov    %ecx,%edx
80105f5a:	c1 ea 0c             	shr    $0xc,%edx
      if (*ref_count == 1){
80105f5d:	0f b6 82 40 0f 11 80 	movzbl -0x7feef0c0(%edx),%eax
80105f64:	3c 01                	cmp    $0x1,%al
80105f66:	0f 84 dd 02 00 00    	je     80106249 <trap+0x379>
        *pte_ptr &= (~PTE_COW);
        // cprintf("rel trap %d\n", p->pid);
        release(cow_lock);
        break;
      }
      else if (*ref_count > 1){
80105f6c:	0f 8e 1d 03 00 00    	jle    8010628f <trap+0x3bf>
        (*ref_count)--;
        // cprintf("rel trap %d\n", p->pid);
        release(cow_lock);
80105f72:	83 ec 0c             	sub    $0xc,%esp
80105f75:	ff 35 40 ef 11 80    	pushl  0x8011ef40
        (*ref_count)--;
80105f7b:	83 e8 01             	sub    $0x1,%eax
80105f7e:	88 82 40 0f 11 80    	mov    %al,-0x7feef0c0(%edx)
        release(cow_lock);
80105f84:	e8 f7 eb ff ff       	call   80104b80 <release>
        int result = copy_page(p->pgdir, pte_ptr);
80105f89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105f8c:	59                   	pop    %ecx
80105f8d:	5f                   	pop    %edi
80105f8e:	56                   	push   %esi
80105f8f:	ff 70 04             	pushl  0x4(%eax)
80105f92:	e8 49 20 00 00       	call   80107fe0 <copy_page>
        if (result < 0){
80105f97:	83 c4 10             	add    $0x10,%esp
80105f9a:	85 c0                	test   %eax,%eax
80105f9c:	79 0f                	jns    80105fad <trap+0xdd>
          p->killed = 1;
80105f9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105fa1:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
          exit();
80105fa8:	e8 13 e3 ff ff       	call   801042c0 <exit>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105fad:	e8 7e de ff ff       	call   80103e30 <myproc>
80105fb2:	85 c0                	test   %eax,%eax
80105fb4:	74 27                	je     80105fdd <trap+0x10d>
80105fb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fbd:	8d 76 00             	lea    0x0(%esi),%esi
80105fc0:	e8 6b de ff ff       	call   80103e30 <myproc>
80105fc5:	8b 50 24             	mov    0x24(%eax),%edx
80105fc8:	85 d2                	test   %edx,%edx
80105fca:	74 11                	je     80105fdd <trap+0x10d>
80105fcc:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105fd0:	83 e0 03             	and    $0x3,%eax
80105fd3:	66 83 f8 03          	cmp    $0x3,%ax
80105fd7:	0f 84 b3 01 00 00    	je     80106190 <trap+0x2c0>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105fdd:	e8 4e de ff ff       	call   80103e30 <myproc>
80105fe2:	85 c0                	test   %eax,%eax
80105fe4:	74 0f                	je     80105ff5 <trap+0x125>
80105fe6:	e8 45 de ff ff       	call   80103e30 <myproc>
80105feb:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105fef:	0f 84 4b 01 00 00    	je     80106140 <trap+0x270>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ff5:	e8 36 de ff ff       	call   80103e30 <myproc>
80105ffa:	85 c0                	test   %eax,%eax
80105ffc:	74 1d                	je     8010601b <trap+0x14b>
80105ffe:	e8 2d de ff ff       	call   80103e30 <myproc>
80106003:	8b 40 24             	mov    0x24(%eax),%eax
80106006:	85 c0                	test   %eax,%eax
80106008:	74 11                	je     8010601b <trap+0x14b>
8010600a:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
8010600e:	83 e0 03             	and    $0x3,%eax
80106011:	66 83 f8 03          	cmp    $0x3,%ax
80106015:	0f 84 66 01 00 00    	je     80106181 <trap+0x2b1>
    exit();
}
8010601b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010601e:	5b                   	pop    %ebx
8010601f:	5e                   	pop    %esi
80106020:	5f                   	pop    %edi
80106021:	5d                   	pop    %ebp
80106022:	c3                   	ret    
    if(myproc() == 0 || (tf->cs&3) == 0){
80106023:	e8 08 de ff ff       	call   80103e30 <myproc>
80106028:	8b 7b 38             	mov    0x38(%ebx),%edi
8010602b:	85 c0                	test   %eax,%eax
8010602d:	0f 84 34 02 00 00    	je     80106267 <trap+0x397>
80106033:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106037:	0f 84 2a 02 00 00    	je     80106267 <trap+0x397>
8010603d:	0f 20 d1             	mov    %cr2,%ecx
80106040:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106043:	e8 c8 dd ff ff       	call   80103e10 <cpuid>
80106048:	8b 73 30             	mov    0x30(%ebx),%esi
8010604b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010604e:	8b 43 34             	mov    0x34(%ebx),%eax
80106051:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80106054:	e8 d7 dd ff ff       	call   80103e30 <myproc>
80106059:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010605c:	e8 cf dd ff ff       	call   80103e30 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106061:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106064:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106067:	51                   	push   %ecx
80106068:	57                   	push   %edi
80106069:	52                   	push   %edx
8010606a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010606d:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
8010606e:	8b 75 e0             	mov    -0x20(%ebp),%esi
80106071:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106074:	56                   	push   %esi
80106075:	ff 70 10             	pushl  0x10(%eax)
80106078:	68 04 89 10 80       	push   $0x80108904
8010607d:	e8 2e a6 ff ff       	call   801006b0 <cprintf>
    myproc()->killed = 1;
80106082:	83 c4 20             	add    $0x20,%esp
80106085:	e8 a6 dd ff ff       	call   80103e30 <myproc>
8010608a:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106091:	e8 9a dd ff ff       	call   80103e30 <myproc>
80106096:	85 c0                	test   %eax,%eax
80106098:	0f 85 22 ff ff ff    	jne    80105fc0 <trap+0xf0>
8010609e:	e9 3a ff ff ff       	jmp    80105fdd <trap+0x10d>
    if(cpuid() == 0){
801060a3:	e8 68 dd ff ff       	call   80103e10 <cpuid>
801060a8:	85 c0                	test   %eax,%eax
801060aa:	0f 84 00 01 00 00    	je     801061b0 <trap+0x2e0>
    lapiceoi();
801060b0:	e8 ab cc ff ff       	call   80102d60 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801060b5:	e8 76 dd ff ff       	call   80103e30 <myproc>
801060ba:	85 c0                	test   %eax,%eax
801060bc:	0f 85 fe fe ff ff    	jne    80105fc0 <trap+0xf0>
801060c2:	e9 16 ff ff ff       	jmp    80105fdd <trap+0x10d>
    kbdintr();
801060c7:	e8 54 cb ff ff       	call   80102c20 <kbdintr>
    lapiceoi();
801060cc:	e8 8f cc ff ff       	call   80102d60 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801060d1:	e8 5a dd ff ff       	call   80103e30 <myproc>
801060d6:	85 c0                	test   %eax,%eax
801060d8:	0f 85 e2 fe ff ff    	jne    80105fc0 <trap+0xf0>
801060de:	e9 fa fe ff ff       	jmp    80105fdd <trap+0x10d>
    uartintr();
801060e3:	e8 28 03 00 00       	call   80106410 <uartintr>
    lapiceoi();
801060e8:	e8 73 cc ff ff       	call   80102d60 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801060ed:	e8 3e dd ff ff       	call   80103e30 <myproc>
801060f2:	85 c0                	test   %eax,%eax
801060f4:	0f 85 c6 fe ff ff    	jne    80105fc0 <trap+0xf0>
801060fa:	e9 de fe ff ff       	jmp    80105fdd <trap+0x10d>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801060ff:	8b 7b 38             	mov    0x38(%ebx),%edi
80106102:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80106106:	e8 05 dd ff ff       	call   80103e10 <cpuid>
8010610b:	57                   	push   %edi
8010610c:	56                   	push   %esi
8010610d:	50                   	push   %eax
8010610e:	68 80 88 10 80       	push   $0x80108880
80106113:	e8 98 a5 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80106118:	e8 43 cc ff ff       	call   80102d60 <lapiceoi>
    break;
8010611d:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106120:	e8 0b dd ff ff       	call   80103e30 <myproc>
80106125:	85 c0                	test   %eax,%eax
80106127:	0f 85 93 fe ff ff    	jne    80105fc0 <trap+0xf0>
8010612d:	e9 ab fe ff ff       	jmp    80105fdd <trap+0x10d>
    ideintr();
80106132:	e8 b9 c4 ff ff       	call   801025f0 <ideintr>
80106137:	e9 74 ff ff ff       	jmp    801060b0 <trap+0x1e0>
8010613c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->state == RUNNING &&
80106140:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106144:	0f 85 ab fe ff ff    	jne    80105ff5 <trap+0x125>
    yield();
8010614a:	e8 b1 e2 ff ff       	call   80104400 <yield>
8010614f:	e9 a1 fe ff ff       	jmp    80105ff5 <trap+0x125>
80106154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80106158:	e8 d3 dc ff ff       	call   80103e30 <myproc>
8010615d:	8b 70 24             	mov    0x24(%eax),%esi
80106160:	85 f6                	test   %esi,%esi
80106162:	75 3c                	jne    801061a0 <trap+0x2d0>
    myproc()->tf = tf;
80106164:	e8 c7 dc ff ff       	call   80103e30 <myproc>
80106169:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
8010616c:	e8 2f ee ff ff       	call   80104fa0 <syscall>
    if(myproc()->killed)
80106171:	e8 ba dc ff ff       	call   80103e30 <myproc>
80106176:	8b 48 24             	mov    0x24(%eax),%ecx
80106179:	85 c9                	test   %ecx,%ecx
8010617b:	0f 84 9a fe ff ff    	je     8010601b <trap+0x14b>
}
80106181:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106184:	5b                   	pop    %ebx
80106185:	5e                   	pop    %esi
80106186:	5f                   	pop    %edi
80106187:	5d                   	pop    %ebp
      exit();
80106188:	e9 33 e1 ff ff       	jmp    801042c0 <exit>
8010618d:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80106190:	e8 2b e1 ff ff       	call   801042c0 <exit>
80106195:	e9 43 fe ff ff       	jmp    80105fdd <trap+0x10d>
8010619a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
801061a0:	e8 1b e1 ff ff       	call   801042c0 <exit>
801061a5:	eb bd                	jmp    80106164 <trap+0x294>
801061a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061ae:	66 90                	xchg   %ax,%ax
      acquire(&tickslock);
801061b0:	83 ec 0c             	sub    $0xc,%esp
801061b3:	68 e0 01 13 80       	push   $0x801301e0
801061b8:	e8 03 e9 ff ff       	call   80104ac0 <acquire>
      wakeup(&ticks);
801061bd:	c7 04 24 20 0a 13 80 	movl   $0x80130a20,(%esp)
      ticks++;
801061c4:	83 05 20 0a 13 80 01 	addl   $0x1,0x80130a20
      wakeup(&ticks);
801061cb:	e8 40 e4 ff ff       	call   80104610 <wakeup>
      release(&tickslock);
801061d0:	c7 04 24 e0 01 13 80 	movl   $0x801301e0,(%esp)
801061d7:	e8 a4 e9 ff ff       	call   80104b80 <release>
801061dc:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
801061df:	e9 cc fe ff ff       	jmp    801060b0 <trap+0x1e0>
801061e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801061e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      for (int i = 0; i < MAX_PYSC_PAGES; i++){
801061eb:	31 f6                	xor    %esi,%esi
801061ed:	05 90 00 00 00       	add    $0x90,%eax
801061f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (PGROUNDDOWN((uint)(p->swapped_out_pages[i].va)) == PGROUNDDOWN(faulting_addr)){
801061f8:	8b 10                	mov    (%eax),%edx
801061fa:	31 fa                	xor    %edi,%edx
801061fc:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106202:	74 1c                	je     80106220 <trap+0x350>
      for (int i = 0; i < MAX_PYSC_PAGES; i++){
80106204:	83 c6 01             	add    $0x1,%esi
80106207:	83 c0 18             	add    $0x18,%eax
8010620a:	83 fe 10             	cmp    $0x10,%esi
8010620d:	75 e9                	jne    801061f8 <trap+0x328>
      p->num_of_pagefaults_occurs++;
8010620f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106212:	83 80 88 03 00 00 01 	addl   $0x1,0x388(%eax)
      break;
80106219:	e9 8f fd ff ff       	jmp    80105fad <trap+0xdd>
8010621e:	66 90                	xchg   %ax,%ax
          cprintf("\nPGFAULT flting_addr = %d\n", faulting_addr);
80106220:	83 ec 08             	sub    $0x8,%esp
80106223:	57                   	push   %edi
80106224:	68 5e 88 10 80       	push   $0x8010885e
80106229:	e8 82 a4 ff ff       	call   801006b0 <cprintf>
          swap_page_back(p, &(p->swapped_out_pages[i]));
8010622e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80106231:	58                   	pop    %eax
80106232:	8d 04 76             	lea    (%esi,%esi,2),%eax
80106235:	5a                   	pop    %edx
80106236:	8d 84 c7 80 00 00 00 	lea    0x80(%edi,%eax,8),%eax
8010623d:	50                   	push   %eax
8010623e:	57                   	push   %edi
8010623f:	e8 ac 1c 00 00       	call   80107ef0 <swap_page_back>
          break;
80106244:	83 c4 10             	add    $0x10,%esp
80106247:	eb c6                	jmp    8010620f <trap+0x33f>
        *pte_ptr &= (~PTE_COW);
80106249:	80 e5 f7             	and    $0xf7,%ch
        release(cow_lock);
8010624c:	83 ec 0c             	sub    $0xc,%esp
        *pte_ptr &= (~PTE_COW);
8010624f:	83 c9 02             	or     $0x2,%ecx
80106252:	89 0e                	mov    %ecx,(%esi)
        release(cow_lock);
80106254:	ff 35 40 ef 11 80    	pushl  0x8011ef40
8010625a:	e8 21 e9 ff ff       	call   80104b80 <release>
        break;
8010625f:	83 c4 10             	add    $0x10,%esp
80106262:	e9 46 fd ff ff       	jmp    80105fad <trap+0xdd>
80106267:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010626a:	e8 a1 db ff ff       	call   80103e10 <cpuid>
8010626f:	83 ec 0c             	sub    $0xc,%esp
80106272:	56                   	push   %esi
80106273:	57                   	push   %edi
80106274:	50                   	push   %eax
80106275:	ff 73 30             	pushl  0x30(%ebx)
80106278:	68 d0 88 10 80       	push   $0x801088d0
8010627d:	e8 2e a4 ff ff       	call   801006b0 <cprintf>
      panic("trap");
80106282:	83 c4 14             	add    $0x14,%esp
80106285:	68 79 88 10 80       	push   $0x80108879
8010628a:	e8 01 a1 ff ff       	call   80100390 <panic>
        panic("ref count to page is 0 but it was reffed");
8010628f:	83 ec 0c             	sub    $0xc,%esp
80106292:	68 a4 88 10 80       	push   $0x801088a4
80106297:	e8 f4 a0 ff ff       	call   80100390 <panic>
8010629c:	66 90                	xchg   %ax,%ax
8010629e:	66 90                	xchg   %ax,%ax

801062a0 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
801062a0:	f3 0f 1e fb          	endbr32 
  if(!uart)
801062a4:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
801062a9:	85 c0                	test   %eax,%eax
801062ab:	74 1b                	je     801062c8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801062ad:	ba fd 03 00 00       	mov    $0x3fd,%edx
801062b2:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801062b3:	a8 01                	test   $0x1,%al
801062b5:	74 11                	je     801062c8 <uartgetc+0x28>
801062b7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801062bc:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801062bd:	0f b6 c0             	movzbl %al,%eax
801062c0:	c3                   	ret    
801062c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801062c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801062cd:	c3                   	ret    
801062ce:	66 90                	xchg   %ax,%ax

801062d0 <uartputc.part.0>:
uartputc(int c)
801062d0:	55                   	push   %ebp
801062d1:	89 e5                	mov    %esp,%ebp
801062d3:	57                   	push   %edi
801062d4:	89 c7                	mov    %eax,%edi
801062d6:	56                   	push   %esi
801062d7:	be fd 03 00 00       	mov    $0x3fd,%esi
801062dc:	53                   	push   %ebx
801062dd:	bb 80 00 00 00       	mov    $0x80,%ebx
801062e2:	83 ec 0c             	sub    $0xc,%esp
801062e5:	eb 1b                	jmp    80106302 <uartputc.part.0+0x32>
801062e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801062ee:	66 90                	xchg   %ax,%ax
    microdelay(10);
801062f0:	83 ec 0c             	sub    $0xc,%esp
801062f3:	6a 0a                	push   $0xa
801062f5:	e8 86 ca ff ff       	call   80102d80 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801062fa:	83 c4 10             	add    $0x10,%esp
801062fd:	83 eb 01             	sub    $0x1,%ebx
80106300:	74 07                	je     80106309 <uartputc.part.0+0x39>
80106302:	89 f2                	mov    %esi,%edx
80106304:	ec                   	in     (%dx),%al
80106305:	a8 20                	test   $0x20,%al
80106307:	74 e7                	je     801062f0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106309:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010630e:	89 f8                	mov    %edi,%eax
80106310:	ee                   	out    %al,(%dx)
}
80106311:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106314:	5b                   	pop    %ebx
80106315:	5e                   	pop    %esi
80106316:	5f                   	pop    %edi
80106317:	5d                   	pop    %ebp
80106318:	c3                   	ret    
80106319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106320 <uartinit>:
{
80106320:	f3 0f 1e fb          	endbr32 
80106324:	55                   	push   %ebp
80106325:	31 c9                	xor    %ecx,%ecx
80106327:	89 c8                	mov    %ecx,%eax
80106329:	89 e5                	mov    %esp,%ebp
8010632b:	57                   	push   %edi
8010632c:	56                   	push   %esi
8010632d:	53                   	push   %ebx
8010632e:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106333:	89 da                	mov    %ebx,%edx
80106335:	83 ec 0c             	sub    $0xc,%esp
80106338:	ee                   	out    %al,(%dx)
80106339:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010633e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106343:	89 fa                	mov    %edi,%edx
80106345:	ee                   	out    %al,(%dx)
80106346:	b8 0c 00 00 00       	mov    $0xc,%eax
8010634b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106350:	ee                   	out    %al,(%dx)
80106351:	be f9 03 00 00       	mov    $0x3f9,%esi
80106356:	89 c8                	mov    %ecx,%eax
80106358:	89 f2                	mov    %esi,%edx
8010635a:	ee                   	out    %al,(%dx)
8010635b:	b8 03 00 00 00       	mov    $0x3,%eax
80106360:	89 fa                	mov    %edi,%edx
80106362:	ee                   	out    %al,(%dx)
80106363:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106368:	89 c8                	mov    %ecx,%eax
8010636a:	ee                   	out    %al,(%dx)
8010636b:	b8 01 00 00 00       	mov    $0x1,%eax
80106370:	89 f2                	mov    %esi,%edx
80106372:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106373:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106378:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106379:	3c ff                	cmp    $0xff,%al
8010637b:	74 52                	je     801063cf <uartinit+0xaf>
  uart = 1;
8010637d:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80106384:	00 00 00 
80106387:	89 da                	mov    %ebx,%edx
80106389:	ec                   	in     (%dx),%al
8010638a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010638f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106390:	83 ec 08             	sub    $0x8,%esp
80106393:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80106398:	bb 10 8a 10 80       	mov    $0x80108a10,%ebx
  ioapicenable(IRQ_COM1, 0);
8010639d:	6a 00                	push   $0x0
8010639f:	6a 04                	push   $0x4
801063a1:	e8 9a c4 ff ff       	call   80102840 <ioapicenable>
801063a6:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801063a9:	b8 78 00 00 00       	mov    $0x78,%eax
801063ae:	eb 04                	jmp    801063b4 <uartinit+0x94>
801063b0:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
801063b4:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
801063ba:	85 d2                	test   %edx,%edx
801063bc:	74 08                	je     801063c6 <uartinit+0xa6>
    uartputc(*p);
801063be:	0f be c0             	movsbl %al,%eax
801063c1:	e8 0a ff ff ff       	call   801062d0 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
801063c6:	89 f0                	mov    %esi,%eax
801063c8:	83 c3 01             	add    $0x1,%ebx
801063cb:	84 c0                	test   %al,%al
801063cd:	75 e1                	jne    801063b0 <uartinit+0x90>
}
801063cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063d2:	5b                   	pop    %ebx
801063d3:	5e                   	pop    %esi
801063d4:	5f                   	pop    %edi
801063d5:	5d                   	pop    %ebp
801063d6:	c3                   	ret    
801063d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063de:	66 90                	xchg   %ax,%ax

801063e0 <uartputc>:
{
801063e0:	f3 0f 1e fb          	endbr32 
801063e4:	55                   	push   %ebp
  if(!uart)
801063e5:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
801063eb:	89 e5                	mov    %esp,%ebp
801063ed:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801063f0:	85 d2                	test   %edx,%edx
801063f2:	74 0c                	je     80106400 <uartputc+0x20>
}
801063f4:	5d                   	pop    %ebp
801063f5:	e9 d6 fe ff ff       	jmp    801062d0 <uartputc.part.0>
801063fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106400:	5d                   	pop    %ebp
80106401:	c3                   	ret    
80106402:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106410 <uartintr>:

void
uartintr(void)
{
80106410:	f3 0f 1e fb          	endbr32 
80106414:	55                   	push   %ebp
80106415:	89 e5                	mov    %esp,%ebp
80106417:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
8010641a:	68 a0 62 10 80       	push   $0x801062a0
8010641f:	e8 3c a4 ff ff       	call   80100860 <consoleintr>
}
80106424:	83 c4 10             	add    $0x10,%esp
80106427:	c9                   	leave  
80106428:	c3                   	ret    

80106429 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106429:	6a 00                	push   $0x0
  pushl $0
8010642b:	6a 00                	push   $0x0
  jmp alltraps
8010642d:	e9 c7 f9 ff ff       	jmp    80105df9 <alltraps>

80106432 <vector1>:
.globl vector1
vector1:
  pushl $0
80106432:	6a 00                	push   $0x0
  pushl $1
80106434:	6a 01                	push   $0x1
  jmp alltraps
80106436:	e9 be f9 ff ff       	jmp    80105df9 <alltraps>

8010643b <vector2>:
.globl vector2
vector2:
  pushl $0
8010643b:	6a 00                	push   $0x0
  pushl $2
8010643d:	6a 02                	push   $0x2
  jmp alltraps
8010643f:	e9 b5 f9 ff ff       	jmp    80105df9 <alltraps>

80106444 <vector3>:
.globl vector3
vector3:
  pushl $0
80106444:	6a 00                	push   $0x0
  pushl $3
80106446:	6a 03                	push   $0x3
  jmp alltraps
80106448:	e9 ac f9 ff ff       	jmp    80105df9 <alltraps>

8010644d <vector4>:
.globl vector4
vector4:
  pushl $0
8010644d:	6a 00                	push   $0x0
  pushl $4
8010644f:	6a 04                	push   $0x4
  jmp alltraps
80106451:	e9 a3 f9 ff ff       	jmp    80105df9 <alltraps>

80106456 <vector5>:
.globl vector5
vector5:
  pushl $0
80106456:	6a 00                	push   $0x0
  pushl $5
80106458:	6a 05                	push   $0x5
  jmp alltraps
8010645a:	e9 9a f9 ff ff       	jmp    80105df9 <alltraps>

8010645f <vector6>:
.globl vector6
vector6:
  pushl $0
8010645f:	6a 00                	push   $0x0
  pushl $6
80106461:	6a 06                	push   $0x6
  jmp alltraps
80106463:	e9 91 f9 ff ff       	jmp    80105df9 <alltraps>

80106468 <vector7>:
.globl vector7
vector7:
  pushl $0
80106468:	6a 00                	push   $0x0
  pushl $7
8010646a:	6a 07                	push   $0x7
  jmp alltraps
8010646c:	e9 88 f9 ff ff       	jmp    80105df9 <alltraps>

80106471 <vector8>:
.globl vector8
vector8:
  pushl $8
80106471:	6a 08                	push   $0x8
  jmp alltraps
80106473:	e9 81 f9 ff ff       	jmp    80105df9 <alltraps>

80106478 <vector9>:
.globl vector9
vector9:
  pushl $0
80106478:	6a 00                	push   $0x0
  pushl $9
8010647a:	6a 09                	push   $0x9
  jmp alltraps
8010647c:	e9 78 f9 ff ff       	jmp    80105df9 <alltraps>

80106481 <vector10>:
.globl vector10
vector10:
  pushl $10
80106481:	6a 0a                	push   $0xa
  jmp alltraps
80106483:	e9 71 f9 ff ff       	jmp    80105df9 <alltraps>

80106488 <vector11>:
.globl vector11
vector11:
  pushl $11
80106488:	6a 0b                	push   $0xb
  jmp alltraps
8010648a:	e9 6a f9 ff ff       	jmp    80105df9 <alltraps>

8010648f <vector12>:
.globl vector12
vector12:
  pushl $12
8010648f:	6a 0c                	push   $0xc
  jmp alltraps
80106491:	e9 63 f9 ff ff       	jmp    80105df9 <alltraps>

80106496 <vector13>:
.globl vector13
vector13:
  pushl $13
80106496:	6a 0d                	push   $0xd
  jmp alltraps
80106498:	e9 5c f9 ff ff       	jmp    80105df9 <alltraps>

8010649d <vector14>:
.globl vector14
vector14:
  pushl $14
8010649d:	6a 0e                	push   $0xe
  jmp alltraps
8010649f:	e9 55 f9 ff ff       	jmp    80105df9 <alltraps>

801064a4 <vector15>:
.globl vector15
vector15:
  pushl $0
801064a4:	6a 00                	push   $0x0
  pushl $15
801064a6:	6a 0f                	push   $0xf
  jmp alltraps
801064a8:	e9 4c f9 ff ff       	jmp    80105df9 <alltraps>

801064ad <vector16>:
.globl vector16
vector16:
  pushl $0
801064ad:	6a 00                	push   $0x0
  pushl $16
801064af:	6a 10                	push   $0x10
  jmp alltraps
801064b1:	e9 43 f9 ff ff       	jmp    80105df9 <alltraps>

801064b6 <vector17>:
.globl vector17
vector17:
  pushl $17
801064b6:	6a 11                	push   $0x11
  jmp alltraps
801064b8:	e9 3c f9 ff ff       	jmp    80105df9 <alltraps>

801064bd <vector18>:
.globl vector18
vector18:
  pushl $0
801064bd:	6a 00                	push   $0x0
  pushl $18
801064bf:	6a 12                	push   $0x12
  jmp alltraps
801064c1:	e9 33 f9 ff ff       	jmp    80105df9 <alltraps>

801064c6 <vector19>:
.globl vector19
vector19:
  pushl $0
801064c6:	6a 00                	push   $0x0
  pushl $19
801064c8:	6a 13                	push   $0x13
  jmp alltraps
801064ca:	e9 2a f9 ff ff       	jmp    80105df9 <alltraps>

801064cf <vector20>:
.globl vector20
vector20:
  pushl $0
801064cf:	6a 00                	push   $0x0
  pushl $20
801064d1:	6a 14                	push   $0x14
  jmp alltraps
801064d3:	e9 21 f9 ff ff       	jmp    80105df9 <alltraps>

801064d8 <vector21>:
.globl vector21
vector21:
  pushl $0
801064d8:	6a 00                	push   $0x0
  pushl $21
801064da:	6a 15                	push   $0x15
  jmp alltraps
801064dc:	e9 18 f9 ff ff       	jmp    80105df9 <alltraps>

801064e1 <vector22>:
.globl vector22
vector22:
  pushl $0
801064e1:	6a 00                	push   $0x0
  pushl $22
801064e3:	6a 16                	push   $0x16
  jmp alltraps
801064e5:	e9 0f f9 ff ff       	jmp    80105df9 <alltraps>

801064ea <vector23>:
.globl vector23
vector23:
  pushl $0
801064ea:	6a 00                	push   $0x0
  pushl $23
801064ec:	6a 17                	push   $0x17
  jmp alltraps
801064ee:	e9 06 f9 ff ff       	jmp    80105df9 <alltraps>

801064f3 <vector24>:
.globl vector24
vector24:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $24
801064f5:	6a 18                	push   $0x18
  jmp alltraps
801064f7:	e9 fd f8 ff ff       	jmp    80105df9 <alltraps>

801064fc <vector25>:
.globl vector25
vector25:
  pushl $0
801064fc:	6a 00                	push   $0x0
  pushl $25
801064fe:	6a 19                	push   $0x19
  jmp alltraps
80106500:	e9 f4 f8 ff ff       	jmp    80105df9 <alltraps>

80106505 <vector26>:
.globl vector26
vector26:
  pushl $0
80106505:	6a 00                	push   $0x0
  pushl $26
80106507:	6a 1a                	push   $0x1a
  jmp alltraps
80106509:	e9 eb f8 ff ff       	jmp    80105df9 <alltraps>

8010650e <vector27>:
.globl vector27
vector27:
  pushl $0
8010650e:	6a 00                	push   $0x0
  pushl $27
80106510:	6a 1b                	push   $0x1b
  jmp alltraps
80106512:	e9 e2 f8 ff ff       	jmp    80105df9 <alltraps>

80106517 <vector28>:
.globl vector28
vector28:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $28
80106519:	6a 1c                	push   $0x1c
  jmp alltraps
8010651b:	e9 d9 f8 ff ff       	jmp    80105df9 <alltraps>

80106520 <vector29>:
.globl vector29
vector29:
  pushl $0
80106520:	6a 00                	push   $0x0
  pushl $29
80106522:	6a 1d                	push   $0x1d
  jmp alltraps
80106524:	e9 d0 f8 ff ff       	jmp    80105df9 <alltraps>

80106529 <vector30>:
.globl vector30
vector30:
  pushl $0
80106529:	6a 00                	push   $0x0
  pushl $30
8010652b:	6a 1e                	push   $0x1e
  jmp alltraps
8010652d:	e9 c7 f8 ff ff       	jmp    80105df9 <alltraps>

80106532 <vector31>:
.globl vector31
vector31:
  pushl $0
80106532:	6a 00                	push   $0x0
  pushl $31
80106534:	6a 1f                	push   $0x1f
  jmp alltraps
80106536:	e9 be f8 ff ff       	jmp    80105df9 <alltraps>

8010653b <vector32>:
.globl vector32
vector32:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $32
8010653d:	6a 20                	push   $0x20
  jmp alltraps
8010653f:	e9 b5 f8 ff ff       	jmp    80105df9 <alltraps>

80106544 <vector33>:
.globl vector33
vector33:
  pushl $0
80106544:	6a 00                	push   $0x0
  pushl $33
80106546:	6a 21                	push   $0x21
  jmp alltraps
80106548:	e9 ac f8 ff ff       	jmp    80105df9 <alltraps>

8010654d <vector34>:
.globl vector34
vector34:
  pushl $0
8010654d:	6a 00                	push   $0x0
  pushl $34
8010654f:	6a 22                	push   $0x22
  jmp alltraps
80106551:	e9 a3 f8 ff ff       	jmp    80105df9 <alltraps>

80106556 <vector35>:
.globl vector35
vector35:
  pushl $0
80106556:	6a 00                	push   $0x0
  pushl $35
80106558:	6a 23                	push   $0x23
  jmp alltraps
8010655a:	e9 9a f8 ff ff       	jmp    80105df9 <alltraps>

8010655f <vector36>:
.globl vector36
vector36:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $36
80106561:	6a 24                	push   $0x24
  jmp alltraps
80106563:	e9 91 f8 ff ff       	jmp    80105df9 <alltraps>

80106568 <vector37>:
.globl vector37
vector37:
  pushl $0
80106568:	6a 00                	push   $0x0
  pushl $37
8010656a:	6a 25                	push   $0x25
  jmp alltraps
8010656c:	e9 88 f8 ff ff       	jmp    80105df9 <alltraps>

80106571 <vector38>:
.globl vector38
vector38:
  pushl $0
80106571:	6a 00                	push   $0x0
  pushl $38
80106573:	6a 26                	push   $0x26
  jmp alltraps
80106575:	e9 7f f8 ff ff       	jmp    80105df9 <alltraps>

8010657a <vector39>:
.globl vector39
vector39:
  pushl $0
8010657a:	6a 00                	push   $0x0
  pushl $39
8010657c:	6a 27                	push   $0x27
  jmp alltraps
8010657e:	e9 76 f8 ff ff       	jmp    80105df9 <alltraps>

80106583 <vector40>:
.globl vector40
vector40:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $40
80106585:	6a 28                	push   $0x28
  jmp alltraps
80106587:	e9 6d f8 ff ff       	jmp    80105df9 <alltraps>

8010658c <vector41>:
.globl vector41
vector41:
  pushl $0
8010658c:	6a 00                	push   $0x0
  pushl $41
8010658e:	6a 29                	push   $0x29
  jmp alltraps
80106590:	e9 64 f8 ff ff       	jmp    80105df9 <alltraps>

80106595 <vector42>:
.globl vector42
vector42:
  pushl $0
80106595:	6a 00                	push   $0x0
  pushl $42
80106597:	6a 2a                	push   $0x2a
  jmp alltraps
80106599:	e9 5b f8 ff ff       	jmp    80105df9 <alltraps>

8010659e <vector43>:
.globl vector43
vector43:
  pushl $0
8010659e:	6a 00                	push   $0x0
  pushl $43
801065a0:	6a 2b                	push   $0x2b
  jmp alltraps
801065a2:	e9 52 f8 ff ff       	jmp    80105df9 <alltraps>

801065a7 <vector44>:
.globl vector44
vector44:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $44
801065a9:	6a 2c                	push   $0x2c
  jmp alltraps
801065ab:	e9 49 f8 ff ff       	jmp    80105df9 <alltraps>

801065b0 <vector45>:
.globl vector45
vector45:
  pushl $0
801065b0:	6a 00                	push   $0x0
  pushl $45
801065b2:	6a 2d                	push   $0x2d
  jmp alltraps
801065b4:	e9 40 f8 ff ff       	jmp    80105df9 <alltraps>

801065b9 <vector46>:
.globl vector46
vector46:
  pushl $0
801065b9:	6a 00                	push   $0x0
  pushl $46
801065bb:	6a 2e                	push   $0x2e
  jmp alltraps
801065bd:	e9 37 f8 ff ff       	jmp    80105df9 <alltraps>

801065c2 <vector47>:
.globl vector47
vector47:
  pushl $0
801065c2:	6a 00                	push   $0x0
  pushl $47
801065c4:	6a 2f                	push   $0x2f
  jmp alltraps
801065c6:	e9 2e f8 ff ff       	jmp    80105df9 <alltraps>

801065cb <vector48>:
.globl vector48
vector48:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $48
801065cd:	6a 30                	push   $0x30
  jmp alltraps
801065cf:	e9 25 f8 ff ff       	jmp    80105df9 <alltraps>

801065d4 <vector49>:
.globl vector49
vector49:
  pushl $0
801065d4:	6a 00                	push   $0x0
  pushl $49
801065d6:	6a 31                	push   $0x31
  jmp alltraps
801065d8:	e9 1c f8 ff ff       	jmp    80105df9 <alltraps>

801065dd <vector50>:
.globl vector50
vector50:
  pushl $0
801065dd:	6a 00                	push   $0x0
  pushl $50
801065df:	6a 32                	push   $0x32
  jmp alltraps
801065e1:	e9 13 f8 ff ff       	jmp    80105df9 <alltraps>

801065e6 <vector51>:
.globl vector51
vector51:
  pushl $0
801065e6:	6a 00                	push   $0x0
  pushl $51
801065e8:	6a 33                	push   $0x33
  jmp alltraps
801065ea:	e9 0a f8 ff ff       	jmp    80105df9 <alltraps>

801065ef <vector52>:
.globl vector52
vector52:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $52
801065f1:	6a 34                	push   $0x34
  jmp alltraps
801065f3:	e9 01 f8 ff ff       	jmp    80105df9 <alltraps>

801065f8 <vector53>:
.globl vector53
vector53:
  pushl $0
801065f8:	6a 00                	push   $0x0
  pushl $53
801065fa:	6a 35                	push   $0x35
  jmp alltraps
801065fc:	e9 f8 f7 ff ff       	jmp    80105df9 <alltraps>

80106601 <vector54>:
.globl vector54
vector54:
  pushl $0
80106601:	6a 00                	push   $0x0
  pushl $54
80106603:	6a 36                	push   $0x36
  jmp alltraps
80106605:	e9 ef f7 ff ff       	jmp    80105df9 <alltraps>

8010660a <vector55>:
.globl vector55
vector55:
  pushl $0
8010660a:	6a 00                	push   $0x0
  pushl $55
8010660c:	6a 37                	push   $0x37
  jmp alltraps
8010660e:	e9 e6 f7 ff ff       	jmp    80105df9 <alltraps>

80106613 <vector56>:
.globl vector56
vector56:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $56
80106615:	6a 38                	push   $0x38
  jmp alltraps
80106617:	e9 dd f7 ff ff       	jmp    80105df9 <alltraps>

8010661c <vector57>:
.globl vector57
vector57:
  pushl $0
8010661c:	6a 00                	push   $0x0
  pushl $57
8010661e:	6a 39                	push   $0x39
  jmp alltraps
80106620:	e9 d4 f7 ff ff       	jmp    80105df9 <alltraps>

80106625 <vector58>:
.globl vector58
vector58:
  pushl $0
80106625:	6a 00                	push   $0x0
  pushl $58
80106627:	6a 3a                	push   $0x3a
  jmp alltraps
80106629:	e9 cb f7 ff ff       	jmp    80105df9 <alltraps>

8010662e <vector59>:
.globl vector59
vector59:
  pushl $0
8010662e:	6a 00                	push   $0x0
  pushl $59
80106630:	6a 3b                	push   $0x3b
  jmp alltraps
80106632:	e9 c2 f7 ff ff       	jmp    80105df9 <alltraps>

80106637 <vector60>:
.globl vector60
vector60:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $60
80106639:	6a 3c                	push   $0x3c
  jmp alltraps
8010663b:	e9 b9 f7 ff ff       	jmp    80105df9 <alltraps>

80106640 <vector61>:
.globl vector61
vector61:
  pushl $0
80106640:	6a 00                	push   $0x0
  pushl $61
80106642:	6a 3d                	push   $0x3d
  jmp alltraps
80106644:	e9 b0 f7 ff ff       	jmp    80105df9 <alltraps>

80106649 <vector62>:
.globl vector62
vector62:
  pushl $0
80106649:	6a 00                	push   $0x0
  pushl $62
8010664b:	6a 3e                	push   $0x3e
  jmp alltraps
8010664d:	e9 a7 f7 ff ff       	jmp    80105df9 <alltraps>

80106652 <vector63>:
.globl vector63
vector63:
  pushl $0
80106652:	6a 00                	push   $0x0
  pushl $63
80106654:	6a 3f                	push   $0x3f
  jmp alltraps
80106656:	e9 9e f7 ff ff       	jmp    80105df9 <alltraps>

8010665b <vector64>:
.globl vector64
vector64:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $64
8010665d:	6a 40                	push   $0x40
  jmp alltraps
8010665f:	e9 95 f7 ff ff       	jmp    80105df9 <alltraps>

80106664 <vector65>:
.globl vector65
vector65:
  pushl $0
80106664:	6a 00                	push   $0x0
  pushl $65
80106666:	6a 41                	push   $0x41
  jmp alltraps
80106668:	e9 8c f7 ff ff       	jmp    80105df9 <alltraps>

8010666d <vector66>:
.globl vector66
vector66:
  pushl $0
8010666d:	6a 00                	push   $0x0
  pushl $66
8010666f:	6a 42                	push   $0x42
  jmp alltraps
80106671:	e9 83 f7 ff ff       	jmp    80105df9 <alltraps>

80106676 <vector67>:
.globl vector67
vector67:
  pushl $0
80106676:	6a 00                	push   $0x0
  pushl $67
80106678:	6a 43                	push   $0x43
  jmp alltraps
8010667a:	e9 7a f7 ff ff       	jmp    80105df9 <alltraps>

8010667f <vector68>:
.globl vector68
vector68:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $68
80106681:	6a 44                	push   $0x44
  jmp alltraps
80106683:	e9 71 f7 ff ff       	jmp    80105df9 <alltraps>

80106688 <vector69>:
.globl vector69
vector69:
  pushl $0
80106688:	6a 00                	push   $0x0
  pushl $69
8010668a:	6a 45                	push   $0x45
  jmp alltraps
8010668c:	e9 68 f7 ff ff       	jmp    80105df9 <alltraps>

80106691 <vector70>:
.globl vector70
vector70:
  pushl $0
80106691:	6a 00                	push   $0x0
  pushl $70
80106693:	6a 46                	push   $0x46
  jmp alltraps
80106695:	e9 5f f7 ff ff       	jmp    80105df9 <alltraps>

8010669a <vector71>:
.globl vector71
vector71:
  pushl $0
8010669a:	6a 00                	push   $0x0
  pushl $71
8010669c:	6a 47                	push   $0x47
  jmp alltraps
8010669e:	e9 56 f7 ff ff       	jmp    80105df9 <alltraps>

801066a3 <vector72>:
.globl vector72
vector72:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $72
801066a5:	6a 48                	push   $0x48
  jmp alltraps
801066a7:	e9 4d f7 ff ff       	jmp    80105df9 <alltraps>

801066ac <vector73>:
.globl vector73
vector73:
  pushl $0
801066ac:	6a 00                	push   $0x0
  pushl $73
801066ae:	6a 49                	push   $0x49
  jmp alltraps
801066b0:	e9 44 f7 ff ff       	jmp    80105df9 <alltraps>

801066b5 <vector74>:
.globl vector74
vector74:
  pushl $0
801066b5:	6a 00                	push   $0x0
  pushl $74
801066b7:	6a 4a                	push   $0x4a
  jmp alltraps
801066b9:	e9 3b f7 ff ff       	jmp    80105df9 <alltraps>

801066be <vector75>:
.globl vector75
vector75:
  pushl $0
801066be:	6a 00                	push   $0x0
  pushl $75
801066c0:	6a 4b                	push   $0x4b
  jmp alltraps
801066c2:	e9 32 f7 ff ff       	jmp    80105df9 <alltraps>

801066c7 <vector76>:
.globl vector76
vector76:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $76
801066c9:	6a 4c                	push   $0x4c
  jmp alltraps
801066cb:	e9 29 f7 ff ff       	jmp    80105df9 <alltraps>

801066d0 <vector77>:
.globl vector77
vector77:
  pushl $0
801066d0:	6a 00                	push   $0x0
  pushl $77
801066d2:	6a 4d                	push   $0x4d
  jmp alltraps
801066d4:	e9 20 f7 ff ff       	jmp    80105df9 <alltraps>

801066d9 <vector78>:
.globl vector78
vector78:
  pushl $0
801066d9:	6a 00                	push   $0x0
  pushl $78
801066db:	6a 4e                	push   $0x4e
  jmp alltraps
801066dd:	e9 17 f7 ff ff       	jmp    80105df9 <alltraps>

801066e2 <vector79>:
.globl vector79
vector79:
  pushl $0
801066e2:	6a 00                	push   $0x0
  pushl $79
801066e4:	6a 4f                	push   $0x4f
  jmp alltraps
801066e6:	e9 0e f7 ff ff       	jmp    80105df9 <alltraps>

801066eb <vector80>:
.globl vector80
vector80:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $80
801066ed:	6a 50                	push   $0x50
  jmp alltraps
801066ef:	e9 05 f7 ff ff       	jmp    80105df9 <alltraps>

801066f4 <vector81>:
.globl vector81
vector81:
  pushl $0
801066f4:	6a 00                	push   $0x0
  pushl $81
801066f6:	6a 51                	push   $0x51
  jmp alltraps
801066f8:	e9 fc f6 ff ff       	jmp    80105df9 <alltraps>

801066fd <vector82>:
.globl vector82
vector82:
  pushl $0
801066fd:	6a 00                	push   $0x0
  pushl $82
801066ff:	6a 52                	push   $0x52
  jmp alltraps
80106701:	e9 f3 f6 ff ff       	jmp    80105df9 <alltraps>

80106706 <vector83>:
.globl vector83
vector83:
  pushl $0
80106706:	6a 00                	push   $0x0
  pushl $83
80106708:	6a 53                	push   $0x53
  jmp alltraps
8010670a:	e9 ea f6 ff ff       	jmp    80105df9 <alltraps>

8010670f <vector84>:
.globl vector84
vector84:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $84
80106711:	6a 54                	push   $0x54
  jmp alltraps
80106713:	e9 e1 f6 ff ff       	jmp    80105df9 <alltraps>

80106718 <vector85>:
.globl vector85
vector85:
  pushl $0
80106718:	6a 00                	push   $0x0
  pushl $85
8010671a:	6a 55                	push   $0x55
  jmp alltraps
8010671c:	e9 d8 f6 ff ff       	jmp    80105df9 <alltraps>

80106721 <vector86>:
.globl vector86
vector86:
  pushl $0
80106721:	6a 00                	push   $0x0
  pushl $86
80106723:	6a 56                	push   $0x56
  jmp alltraps
80106725:	e9 cf f6 ff ff       	jmp    80105df9 <alltraps>

8010672a <vector87>:
.globl vector87
vector87:
  pushl $0
8010672a:	6a 00                	push   $0x0
  pushl $87
8010672c:	6a 57                	push   $0x57
  jmp alltraps
8010672e:	e9 c6 f6 ff ff       	jmp    80105df9 <alltraps>

80106733 <vector88>:
.globl vector88
vector88:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $88
80106735:	6a 58                	push   $0x58
  jmp alltraps
80106737:	e9 bd f6 ff ff       	jmp    80105df9 <alltraps>

8010673c <vector89>:
.globl vector89
vector89:
  pushl $0
8010673c:	6a 00                	push   $0x0
  pushl $89
8010673e:	6a 59                	push   $0x59
  jmp alltraps
80106740:	e9 b4 f6 ff ff       	jmp    80105df9 <alltraps>

80106745 <vector90>:
.globl vector90
vector90:
  pushl $0
80106745:	6a 00                	push   $0x0
  pushl $90
80106747:	6a 5a                	push   $0x5a
  jmp alltraps
80106749:	e9 ab f6 ff ff       	jmp    80105df9 <alltraps>

8010674e <vector91>:
.globl vector91
vector91:
  pushl $0
8010674e:	6a 00                	push   $0x0
  pushl $91
80106750:	6a 5b                	push   $0x5b
  jmp alltraps
80106752:	e9 a2 f6 ff ff       	jmp    80105df9 <alltraps>

80106757 <vector92>:
.globl vector92
vector92:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $92
80106759:	6a 5c                	push   $0x5c
  jmp alltraps
8010675b:	e9 99 f6 ff ff       	jmp    80105df9 <alltraps>

80106760 <vector93>:
.globl vector93
vector93:
  pushl $0
80106760:	6a 00                	push   $0x0
  pushl $93
80106762:	6a 5d                	push   $0x5d
  jmp alltraps
80106764:	e9 90 f6 ff ff       	jmp    80105df9 <alltraps>

80106769 <vector94>:
.globl vector94
vector94:
  pushl $0
80106769:	6a 00                	push   $0x0
  pushl $94
8010676b:	6a 5e                	push   $0x5e
  jmp alltraps
8010676d:	e9 87 f6 ff ff       	jmp    80105df9 <alltraps>

80106772 <vector95>:
.globl vector95
vector95:
  pushl $0
80106772:	6a 00                	push   $0x0
  pushl $95
80106774:	6a 5f                	push   $0x5f
  jmp alltraps
80106776:	e9 7e f6 ff ff       	jmp    80105df9 <alltraps>

8010677b <vector96>:
.globl vector96
vector96:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $96
8010677d:	6a 60                	push   $0x60
  jmp alltraps
8010677f:	e9 75 f6 ff ff       	jmp    80105df9 <alltraps>

80106784 <vector97>:
.globl vector97
vector97:
  pushl $0
80106784:	6a 00                	push   $0x0
  pushl $97
80106786:	6a 61                	push   $0x61
  jmp alltraps
80106788:	e9 6c f6 ff ff       	jmp    80105df9 <alltraps>

8010678d <vector98>:
.globl vector98
vector98:
  pushl $0
8010678d:	6a 00                	push   $0x0
  pushl $98
8010678f:	6a 62                	push   $0x62
  jmp alltraps
80106791:	e9 63 f6 ff ff       	jmp    80105df9 <alltraps>

80106796 <vector99>:
.globl vector99
vector99:
  pushl $0
80106796:	6a 00                	push   $0x0
  pushl $99
80106798:	6a 63                	push   $0x63
  jmp alltraps
8010679a:	e9 5a f6 ff ff       	jmp    80105df9 <alltraps>

8010679f <vector100>:
.globl vector100
vector100:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $100
801067a1:	6a 64                	push   $0x64
  jmp alltraps
801067a3:	e9 51 f6 ff ff       	jmp    80105df9 <alltraps>

801067a8 <vector101>:
.globl vector101
vector101:
  pushl $0
801067a8:	6a 00                	push   $0x0
  pushl $101
801067aa:	6a 65                	push   $0x65
  jmp alltraps
801067ac:	e9 48 f6 ff ff       	jmp    80105df9 <alltraps>

801067b1 <vector102>:
.globl vector102
vector102:
  pushl $0
801067b1:	6a 00                	push   $0x0
  pushl $102
801067b3:	6a 66                	push   $0x66
  jmp alltraps
801067b5:	e9 3f f6 ff ff       	jmp    80105df9 <alltraps>

801067ba <vector103>:
.globl vector103
vector103:
  pushl $0
801067ba:	6a 00                	push   $0x0
  pushl $103
801067bc:	6a 67                	push   $0x67
  jmp alltraps
801067be:	e9 36 f6 ff ff       	jmp    80105df9 <alltraps>

801067c3 <vector104>:
.globl vector104
vector104:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $104
801067c5:	6a 68                	push   $0x68
  jmp alltraps
801067c7:	e9 2d f6 ff ff       	jmp    80105df9 <alltraps>

801067cc <vector105>:
.globl vector105
vector105:
  pushl $0
801067cc:	6a 00                	push   $0x0
  pushl $105
801067ce:	6a 69                	push   $0x69
  jmp alltraps
801067d0:	e9 24 f6 ff ff       	jmp    80105df9 <alltraps>

801067d5 <vector106>:
.globl vector106
vector106:
  pushl $0
801067d5:	6a 00                	push   $0x0
  pushl $106
801067d7:	6a 6a                	push   $0x6a
  jmp alltraps
801067d9:	e9 1b f6 ff ff       	jmp    80105df9 <alltraps>

801067de <vector107>:
.globl vector107
vector107:
  pushl $0
801067de:	6a 00                	push   $0x0
  pushl $107
801067e0:	6a 6b                	push   $0x6b
  jmp alltraps
801067e2:	e9 12 f6 ff ff       	jmp    80105df9 <alltraps>

801067e7 <vector108>:
.globl vector108
vector108:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $108
801067e9:	6a 6c                	push   $0x6c
  jmp alltraps
801067eb:	e9 09 f6 ff ff       	jmp    80105df9 <alltraps>

801067f0 <vector109>:
.globl vector109
vector109:
  pushl $0
801067f0:	6a 00                	push   $0x0
  pushl $109
801067f2:	6a 6d                	push   $0x6d
  jmp alltraps
801067f4:	e9 00 f6 ff ff       	jmp    80105df9 <alltraps>

801067f9 <vector110>:
.globl vector110
vector110:
  pushl $0
801067f9:	6a 00                	push   $0x0
  pushl $110
801067fb:	6a 6e                	push   $0x6e
  jmp alltraps
801067fd:	e9 f7 f5 ff ff       	jmp    80105df9 <alltraps>

80106802 <vector111>:
.globl vector111
vector111:
  pushl $0
80106802:	6a 00                	push   $0x0
  pushl $111
80106804:	6a 6f                	push   $0x6f
  jmp alltraps
80106806:	e9 ee f5 ff ff       	jmp    80105df9 <alltraps>

8010680b <vector112>:
.globl vector112
vector112:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $112
8010680d:	6a 70                	push   $0x70
  jmp alltraps
8010680f:	e9 e5 f5 ff ff       	jmp    80105df9 <alltraps>

80106814 <vector113>:
.globl vector113
vector113:
  pushl $0
80106814:	6a 00                	push   $0x0
  pushl $113
80106816:	6a 71                	push   $0x71
  jmp alltraps
80106818:	e9 dc f5 ff ff       	jmp    80105df9 <alltraps>

8010681d <vector114>:
.globl vector114
vector114:
  pushl $0
8010681d:	6a 00                	push   $0x0
  pushl $114
8010681f:	6a 72                	push   $0x72
  jmp alltraps
80106821:	e9 d3 f5 ff ff       	jmp    80105df9 <alltraps>

80106826 <vector115>:
.globl vector115
vector115:
  pushl $0
80106826:	6a 00                	push   $0x0
  pushl $115
80106828:	6a 73                	push   $0x73
  jmp alltraps
8010682a:	e9 ca f5 ff ff       	jmp    80105df9 <alltraps>

8010682f <vector116>:
.globl vector116
vector116:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $116
80106831:	6a 74                	push   $0x74
  jmp alltraps
80106833:	e9 c1 f5 ff ff       	jmp    80105df9 <alltraps>

80106838 <vector117>:
.globl vector117
vector117:
  pushl $0
80106838:	6a 00                	push   $0x0
  pushl $117
8010683a:	6a 75                	push   $0x75
  jmp alltraps
8010683c:	e9 b8 f5 ff ff       	jmp    80105df9 <alltraps>

80106841 <vector118>:
.globl vector118
vector118:
  pushl $0
80106841:	6a 00                	push   $0x0
  pushl $118
80106843:	6a 76                	push   $0x76
  jmp alltraps
80106845:	e9 af f5 ff ff       	jmp    80105df9 <alltraps>

8010684a <vector119>:
.globl vector119
vector119:
  pushl $0
8010684a:	6a 00                	push   $0x0
  pushl $119
8010684c:	6a 77                	push   $0x77
  jmp alltraps
8010684e:	e9 a6 f5 ff ff       	jmp    80105df9 <alltraps>

80106853 <vector120>:
.globl vector120
vector120:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $120
80106855:	6a 78                	push   $0x78
  jmp alltraps
80106857:	e9 9d f5 ff ff       	jmp    80105df9 <alltraps>

8010685c <vector121>:
.globl vector121
vector121:
  pushl $0
8010685c:	6a 00                	push   $0x0
  pushl $121
8010685e:	6a 79                	push   $0x79
  jmp alltraps
80106860:	e9 94 f5 ff ff       	jmp    80105df9 <alltraps>

80106865 <vector122>:
.globl vector122
vector122:
  pushl $0
80106865:	6a 00                	push   $0x0
  pushl $122
80106867:	6a 7a                	push   $0x7a
  jmp alltraps
80106869:	e9 8b f5 ff ff       	jmp    80105df9 <alltraps>

8010686e <vector123>:
.globl vector123
vector123:
  pushl $0
8010686e:	6a 00                	push   $0x0
  pushl $123
80106870:	6a 7b                	push   $0x7b
  jmp alltraps
80106872:	e9 82 f5 ff ff       	jmp    80105df9 <alltraps>

80106877 <vector124>:
.globl vector124
vector124:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $124
80106879:	6a 7c                	push   $0x7c
  jmp alltraps
8010687b:	e9 79 f5 ff ff       	jmp    80105df9 <alltraps>

80106880 <vector125>:
.globl vector125
vector125:
  pushl $0
80106880:	6a 00                	push   $0x0
  pushl $125
80106882:	6a 7d                	push   $0x7d
  jmp alltraps
80106884:	e9 70 f5 ff ff       	jmp    80105df9 <alltraps>

80106889 <vector126>:
.globl vector126
vector126:
  pushl $0
80106889:	6a 00                	push   $0x0
  pushl $126
8010688b:	6a 7e                	push   $0x7e
  jmp alltraps
8010688d:	e9 67 f5 ff ff       	jmp    80105df9 <alltraps>

80106892 <vector127>:
.globl vector127
vector127:
  pushl $0
80106892:	6a 00                	push   $0x0
  pushl $127
80106894:	6a 7f                	push   $0x7f
  jmp alltraps
80106896:	e9 5e f5 ff ff       	jmp    80105df9 <alltraps>

8010689b <vector128>:
.globl vector128
vector128:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $128
8010689d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801068a2:	e9 52 f5 ff ff       	jmp    80105df9 <alltraps>

801068a7 <vector129>:
.globl vector129
vector129:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $129
801068a9:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801068ae:	e9 46 f5 ff ff       	jmp    80105df9 <alltraps>

801068b3 <vector130>:
.globl vector130
vector130:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $130
801068b5:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801068ba:	e9 3a f5 ff ff       	jmp    80105df9 <alltraps>

801068bf <vector131>:
.globl vector131
vector131:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $131
801068c1:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801068c6:	e9 2e f5 ff ff       	jmp    80105df9 <alltraps>

801068cb <vector132>:
.globl vector132
vector132:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $132
801068cd:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801068d2:	e9 22 f5 ff ff       	jmp    80105df9 <alltraps>

801068d7 <vector133>:
.globl vector133
vector133:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $133
801068d9:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801068de:	e9 16 f5 ff ff       	jmp    80105df9 <alltraps>

801068e3 <vector134>:
.globl vector134
vector134:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $134
801068e5:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801068ea:	e9 0a f5 ff ff       	jmp    80105df9 <alltraps>

801068ef <vector135>:
.globl vector135
vector135:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $135
801068f1:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801068f6:	e9 fe f4 ff ff       	jmp    80105df9 <alltraps>

801068fb <vector136>:
.globl vector136
vector136:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $136
801068fd:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106902:	e9 f2 f4 ff ff       	jmp    80105df9 <alltraps>

80106907 <vector137>:
.globl vector137
vector137:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $137
80106909:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010690e:	e9 e6 f4 ff ff       	jmp    80105df9 <alltraps>

80106913 <vector138>:
.globl vector138
vector138:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $138
80106915:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
8010691a:	e9 da f4 ff ff       	jmp    80105df9 <alltraps>

8010691f <vector139>:
.globl vector139
vector139:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $139
80106921:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106926:	e9 ce f4 ff ff       	jmp    80105df9 <alltraps>

8010692b <vector140>:
.globl vector140
vector140:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $140
8010692d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106932:	e9 c2 f4 ff ff       	jmp    80105df9 <alltraps>

80106937 <vector141>:
.globl vector141
vector141:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $141
80106939:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010693e:	e9 b6 f4 ff ff       	jmp    80105df9 <alltraps>

80106943 <vector142>:
.globl vector142
vector142:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $142
80106945:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
8010694a:	e9 aa f4 ff ff       	jmp    80105df9 <alltraps>

8010694f <vector143>:
.globl vector143
vector143:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $143
80106951:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106956:	e9 9e f4 ff ff       	jmp    80105df9 <alltraps>

8010695b <vector144>:
.globl vector144
vector144:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $144
8010695d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106962:	e9 92 f4 ff ff       	jmp    80105df9 <alltraps>

80106967 <vector145>:
.globl vector145
vector145:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $145
80106969:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010696e:	e9 86 f4 ff ff       	jmp    80105df9 <alltraps>

80106973 <vector146>:
.globl vector146
vector146:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $146
80106975:	68 92 00 00 00       	push   $0x92
  jmp alltraps
8010697a:	e9 7a f4 ff ff       	jmp    80105df9 <alltraps>

8010697f <vector147>:
.globl vector147
vector147:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $147
80106981:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106986:	e9 6e f4 ff ff       	jmp    80105df9 <alltraps>

8010698b <vector148>:
.globl vector148
vector148:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $148
8010698d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106992:	e9 62 f4 ff ff       	jmp    80105df9 <alltraps>

80106997 <vector149>:
.globl vector149
vector149:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $149
80106999:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010699e:	e9 56 f4 ff ff       	jmp    80105df9 <alltraps>

801069a3 <vector150>:
.globl vector150
vector150:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $150
801069a5:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801069aa:	e9 4a f4 ff ff       	jmp    80105df9 <alltraps>

801069af <vector151>:
.globl vector151
vector151:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $151
801069b1:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801069b6:	e9 3e f4 ff ff       	jmp    80105df9 <alltraps>

801069bb <vector152>:
.globl vector152
vector152:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $152
801069bd:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801069c2:	e9 32 f4 ff ff       	jmp    80105df9 <alltraps>

801069c7 <vector153>:
.globl vector153
vector153:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $153
801069c9:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801069ce:	e9 26 f4 ff ff       	jmp    80105df9 <alltraps>

801069d3 <vector154>:
.globl vector154
vector154:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $154
801069d5:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801069da:	e9 1a f4 ff ff       	jmp    80105df9 <alltraps>

801069df <vector155>:
.globl vector155
vector155:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $155
801069e1:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801069e6:	e9 0e f4 ff ff       	jmp    80105df9 <alltraps>

801069eb <vector156>:
.globl vector156
vector156:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $156
801069ed:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801069f2:	e9 02 f4 ff ff       	jmp    80105df9 <alltraps>

801069f7 <vector157>:
.globl vector157
vector157:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $157
801069f9:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801069fe:	e9 f6 f3 ff ff       	jmp    80105df9 <alltraps>

80106a03 <vector158>:
.globl vector158
vector158:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $158
80106a05:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106a0a:	e9 ea f3 ff ff       	jmp    80105df9 <alltraps>

80106a0f <vector159>:
.globl vector159
vector159:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $159
80106a11:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106a16:	e9 de f3 ff ff       	jmp    80105df9 <alltraps>

80106a1b <vector160>:
.globl vector160
vector160:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $160
80106a1d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106a22:	e9 d2 f3 ff ff       	jmp    80105df9 <alltraps>

80106a27 <vector161>:
.globl vector161
vector161:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $161
80106a29:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106a2e:	e9 c6 f3 ff ff       	jmp    80105df9 <alltraps>

80106a33 <vector162>:
.globl vector162
vector162:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $162
80106a35:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106a3a:	e9 ba f3 ff ff       	jmp    80105df9 <alltraps>

80106a3f <vector163>:
.globl vector163
vector163:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $163
80106a41:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106a46:	e9 ae f3 ff ff       	jmp    80105df9 <alltraps>

80106a4b <vector164>:
.globl vector164
vector164:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $164
80106a4d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106a52:	e9 a2 f3 ff ff       	jmp    80105df9 <alltraps>

80106a57 <vector165>:
.globl vector165
vector165:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $165
80106a59:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106a5e:	e9 96 f3 ff ff       	jmp    80105df9 <alltraps>

80106a63 <vector166>:
.globl vector166
vector166:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $166
80106a65:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106a6a:	e9 8a f3 ff ff       	jmp    80105df9 <alltraps>

80106a6f <vector167>:
.globl vector167
vector167:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $167
80106a71:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106a76:	e9 7e f3 ff ff       	jmp    80105df9 <alltraps>

80106a7b <vector168>:
.globl vector168
vector168:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $168
80106a7d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106a82:	e9 72 f3 ff ff       	jmp    80105df9 <alltraps>

80106a87 <vector169>:
.globl vector169
vector169:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $169
80106a89:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106a8e:	e9 66 f3 ff ff       	jmp    80105df9 <alltraps>

80106a93 <vector170>:
.globl vector170
vector170:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $170
80106a95:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106a9a:	e9 5a f3 ff ff       	jmp    80105df9 <alltraps>

80106a9f <vector171>:
.globl vector171
vector171:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $171
80106aa1:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106aa6:	e9 4e f3 ff ff       	jmp    80105df9 <alltraps>

80106aab <vector172>:
.globl vector172
vector172:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $172
80106aad:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106ab2:	e9 42 f3 ff ff       	jmp    80105df9 <alltraps>

80106ab7 <vector173>:
.globl vector173
vector173:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $173
80106ab9:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106abe:	e9 36 f3 ff ff       	jmp    80105df9 <alltraps>

80106ac3 <vector174>:
.globl vector174
vector174:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $174
80106ac5:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106aca:	e9 2a f3 ff ff       	jmp    80105df9 <alltraps>

80106acf <vector175>:
.globl vector175
vector175:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $175
80106ad1:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106ad6:	e9 1e f3 ff ff       	jmp    80105df9 <alltraps>

80106adb <vector176>:
.globl vector176
vector176:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $176
80106add:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106ae2:	e9 12 f3 ff ff       	jmp    80105df9 <alltraps>

80106ae7 <vector177>:
.globl vector177
vector177:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $177
80106ae9:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106aee:	e9 06 f3 ff ff       	jmp    80105df9 <alltraps>

80106af3 <vector178>:
.globl vector178
vector178:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $178
80106af5:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106afa:	e9 fa f2 ff ff       	jmp    80105df9 <alltraps>

80106aff <vector179>:
.globl vector179
vector179:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $179
80106b01:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106b06:	e9 ee f2 ff ff       	jmp    80105df9 <alltraps>

80106b0b <vector180>:
.globl vector180
vector180:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $180
80106b0d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106b12:	e9 e2 f2 ff ff       	jmp    80105df9 <alltraps>

80106b17 <vector181>:
.globl vector181
vector181:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $181
80106b19:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106b1e:	e9 d6 f2 ff ff       	jmp    80105df9 <alltraps>

80106b23 <vector182>:
.globl vector182
vector182:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $182
80106b25:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106b2a:	e9 ca f2 ff ff       	jmp    80105df9 <alltraps>

80106b2f <vector183>:
.globl vector183
vector183:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $183
80106b31:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106b36:	e9 be f2 ff ff       	jmp    80105df9 <alltraps>

80106b3b <vector184>:
.globl vector184
vector184:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $184
80106b3d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106b42:	e9 b2 f2 ff ff       	jmp    80105df9 <alltraps>

80106b47 <vector185>:
.globl vector185
vector185:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $185
80106b49:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106b4e:	e9 a6 f2 ff ff       	jmp    80105df9 <alltraps>

80106b53 <vector186>:
.globl vector186
vector186:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $186
80106b55:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106b5a:	e9 9a f2 ff ff       	jmp    80105df9 <alltraps>

80106b5f <vector187>:
.globl vector187
vector187:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $187
80106b61:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106b66:	e9 8e f2 ff ff       	jmp    80105df9 <alltraps>

80106b6b <vector188>:
.globl vector188
vector188:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $188
80106b6d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106b72:	e9 82 f2 ff ff       	jmp    80105df9 <alltraps>

80106b77 <vector189>:
.globl vector189
vector189:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $189
80106b79:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106b7e:	e9 76 f2 ff ff       	jmp    80105df9 <alltraps>

80106b83 <vector190>:
.globl vector190
vector190:
  pushl $0
80106b83:	6a 00                	push   $0x0
  pushl $190
80106b85:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106b8a:	e9 6a f2 ff ff       	jmp    80105df9 <alltraps>

80106b8f <vector191>:
.globl vector191
vector191:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $191
80106b91:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106b96:	e9 5e f2 ff ff       	jmp    80105df9 <alltraps>

80106b9b <vector192>:
.globl vector192
vector192:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $192
80106b9d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106ba2:	e9 52 f2 ff ff       	jmp    80105df9 <alltraps>

80106ba7 <vector193>:
.globl vector193
vector193:
  pushl $0
80106ba7:	6a 00                	push   $0x0
  pushl $193
80106ba9:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106bae:	e9 46 f2 ff ff       	jmp    80105df9 <alltraps>

80106bb3 <vector194>:
.globl vector194
vector194:
  pushl $0
80106bb3:	6a 00                	push   $0x0
  pushl $194
80106bb5:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106bba:	e9 3a f2 ff ff       	jmp    80105df9 <alltraps>

80106bbf <vector195>:
.globl vector195
vector195:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $195
80106bc1:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106bc6:	e9 2e f2 ff ff       	jmp    80105df9 <alltraps>

80106bcb <vector196>:
.globl vector196
vector196:
  pushl $0
80106bcb:	6a 00                	push   $0x0
  pushl $196
80106bcd:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106bd2:	e9 22 f2 ff ff       	jmp    80105df9 <alltraps>

80106bd7 <vector197>:
.globl vector197
vector197:
  pushl $0
80106bd7:	6a 00                	push   $0x0
  pushl $197
80106bd9:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106bde:	e9 16 f2 ff ff       	jmp    80105df9 <alltraps>

80106be3 <vector198>:
.globl vector198
vector198:
  pushl $0
80106be3:	6a 00                	push   $0x0
  pushl $198
80106be5:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106bea:	e9 0a f2 ff ff       	jmp    80105df9 <alltraps>

80106bef <vector199>:
.globl vector199
vector199:
  pushl $0
80106bef:	6a 00                	push   $0x0
  pushl $199
80106bf1:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106bf6:	e9 fe f1 ff ff       	jmp    80105df9 <alltraps>

80106bfb <vector200>:
.globl vector200
vector200:
  pushl $0
80106bfb:	6a 00                	push   $0x0
  pushl $200
80106bfd:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106c02:	e9 f2 f1 ff ff       	jmp    80105df9 <alltraps>

80106c07 <vector201>:
.globl vector201
vector201:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $201
80106c09:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106c0e:	e9 e6 f1 ff ff       	jmp    80105df9 <alltraps>

80106c13 <vector202>:
.globl vector202
vector202:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $202
80106c15:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106c1a:	e9 da f1 ff ff       	jmp    80105df9 <alltraps>

80106c1f <vector203>:
.globl vector203
vector203:
  pushl $0
80106c1f:	6a 00                	push   $0x0
  pushl $203
80106c21:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106c26:	e9 ce f1 ff ff       	jmp    80105df9 <alltraps>

80106c2b <vector204>:
.globl vector204
vector204:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $204
80106c2d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106c32:	e9 c2 f1 ff ff       	jmp    80105df9 <alltraps>

80106c37 <vector205>:
.globl vector205
vector205:
  pushl $0
80106c37:	6a 00                	push   $0x0
  pushl $205
80106c39:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106c3e:	e9 b6 f1 ff ff       	jmp    80105df9 <alltraps>

80106c43 <vector206>:
.globl vector206
vector206:
  pushl $0
80106c43:	6a 00                	push   $0x0
  pushl $206
80106c45:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106c4a:	e9 aa f1 ff ff       	jmp    80105df9 <alltraps>

80106c4f <vector207>:
.globl vector207
vector207:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $207
80106c51:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106c56:	e9 9e f1 ff ff       	jmp    80105df9 <alltraps>

80106c5b <vector208>:
.globl vector208
vector208:
  pushl $0
80106c5b:	6a 00                	push   $0x0
  pushl $208
80106c5d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106c62:	e9 92 f1 ff ff       	jmp    80105df9 <alltraps>

80106c67 <vector209>:
.globl vector209
vector209:
  pushl $0
80106c67:	6a 00                	push   $0x0
  pushl $209
80106c69:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106c6e:	e9 86 f1 ff ff       	jmp    80105df9 <alltraps>

80106c73 <vector210>:
.globl vector210
vector210:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $210
80106c75:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106c7a:	e9 7a f1 ff ff       	jmp    80105df9 <alltraps>

80106c7f <vector211>:
.globl vector211
vector211:
  pushl $0
80106c7f:	6a 00                	push   $0x0
  pushl $211
80106c81:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106c86:	e9 6e f1 ff ff       	jmp    80105df9 <alltraps>

80106c8b <vector212>:
.globl vector212
vector212:
  pushl $0
80106c8b:	6a 00                	push   $0x0
  pushl $212
80106c8d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106c92:	e9 62 f1 ff ff       	jmp    80105df9 <alltraps>

80106c97 <vector213>:
.globl vector213
vector213:
  pushl $0
80106c97:	6a 00                	push   $0x0
  pushl $213
80106c99:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106c9e:	e9 56 f1 ff ff       	jmp    80105df9 <alltraps>

80106ca3 <vector214>:
.globl vector214
vector214:
  pushl $0
80106ca3:	6a 00                	push   $0x0
  pushl $214
80106ca5:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106caa:	e9 4a f1 ff ff       	jmp    80105df9 <alltraps>

80106caf <vector215>:
.globl vector215
vector215:
  pushl $0
80106caf:	6a 00                	push   $0x0
  pushl $215
80106cb1:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106cb6:	e9 3e f1 ff ff       	jmp    80105df9 <alltraps>

80106cbb <vector216>:
.globl vector216
vector216:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $216
80106cbd:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106cc2:	e9 32 f1 ff ff       	jmp    80105df9 <alltraps>

80106cc7 <vector217>:
.globl vector217
vector217:
  pushl $0
80106cc7:	6a 00                	push   $0x0
  pushl $217
80106cc9:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106cce:	e9 26 f1 ff ff       	jmp    80105df9 <alltraps>

80106cd3 <vector218>:
.globl vector218
vector218:
  pushl $0
80106cd3:	6a 00                	push   $0x0
  pushl $218
80106cd5:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106cda:	e9 1a f1 ff ff       	jmp    80105df9 <alltraps>

80106cdf <vector219>:
.globl vector219
vector219:
  pushl $0
80106cdf:	6a 00                	push   $0x0
  pushl $219
80106ce1:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106ce6:	e9 0e f1 ff ff       	jmp    80105df9 <alltraps>

80106ceb <vector220>:
.globl vector220
vector220:
  pushl $0
80106ceb:	6a 00                	push   $0x0
  pushl $220
80106ced:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106cf2:	e9 02 f1 ff ff       	jmp    80105df9 <alltraps>

80106cf7 <vector221>:
.globl vector221
vector221:
  pushl $0
80106cf7:	6a 00                	push   $0x0
  pushl $221
80106cf9:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106cfe:	e9 f6 f0 ff ff       	jmp    80105df9 <alltraps>

80106d03 <vector222>:
.globl vector222
vector222:
  pushl $0
80106d03:	6a 00                	push   $0x0
  pushl $222
80106d05:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106d0a:	e9 ea f0 ff ff       	jmp    80105df9 <alltraps>

80106d0f <vector223>:
.globl vector223
vector223:
  pushl $0
80106d0f:	6a 00                	push   $0x0
  pushl $223
80106d11:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106d16:	e9 de f0 ff ff       	jmp    80105df9 <alltraps>

80106d1b <vector224>:
.globl vector224
vector224:
  pushl $0
80106d1b:	6a 00                	push   $0x0
  pushl $224
80106d1d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106d22:	e9 d2 f0 ff ff       	jmp    80105df9 <alltraps>

80106d27 <vector225>:
.globl vector225
vector225:
  pushl $0
80106d27:	6a 00                	push   $0x0
  pushl $225
80106d29:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106d2e:	e9 c6 f0 ff ff       	jmp    80105df9 <alltraps>

80106d33 <vector226>:
.globl vector226
vector226:
  pushl $0
80106d33:	6a 00                	push   $0x0
  pushl $226
80106d35:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106d3a:	e9 ba f0 ff ff       	jmp    80105df9 <alltraps>

80106d3f <vector227>:
.globl vector227
vector227:
  pushl $0
80106d3f:	6a 00                	push   $0x0
  pushl $227
80106d41:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106d46:	e9 ae f0 ff ff       	jmp    80105df9 <alltraps>

80106d4b <vector228>:
.globl vector228
vector228:
  pushl $0
80106d4b:	6a 00                	push   $0x0
  pushl $228
80106d4d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106d52:	e9 a2 f0 ff ff       	jmp    80105df9 <alltraps>

80106d57 <vector229>:
.globl vector229
vector229:
  pushl $0
80106d57:	6a 00                	push   $0x0
  pushl $229
80106d59:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106d5e:	e9 96 f0 ff ff       	jmp    80105df9 <alltraps>

80106d63 <vector230>:
.globl vector230
vector230:
  pushl $0
80106d63:	6a 00                	push   $0x0
  pushl $230
80106d65:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106d6a:	e9 8a f0 ff ff       	jmp    80105df9 <alltraps>

80106d6f <vector231>:
.globl vector231
vector231:
  pushl $0
80106d6f:	6a 00                	push   $0x0
  pushl $231
80106d71:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106d76:	e9 7e f0 ff ff       	jmp    80105df9 <alltraps>

80106d7b <vector232>:
.globl vector232
vector232:
  pushl $0
80106d7b:	6a 00                	push   $0x0
  pushl $232
80106d7d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106d82:	e9 72 f0 ff ff       	jmp    80105df9 <alltraps>

80106d87 <vector233>:
.globl vector233
vector233:
  pushl $0
80106d87:	6a 00                	push   $0x0
  pushl $233
80106d89:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106d8e:	e9 66 f0 ff ff       	jmp    80105df9 <alltraps>

80106d93 <vector234>:
.globl vector234
vector234:
  pushl $0
80106d93:	6a 00                	push   $0x0
  pushl $234
80106d95:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106d9a:	e9 5a f0 ff ff       	jmp    80105df9 <alltraps>

80106d9f <vector235>:
.globl vector235
vector235:
  pushl $0
80106d9f:	6a 00                	push   $0x0
  pushl $235
80106da1:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106da6:	e9 4e f0 ff ff       	jmp    80105df9 <alltraps>

80106dab <vector236>:
.globl vector236
vector236:
  pushl $0
80106dab:	6a 00                	push   $0x0
  pushl $236
80106dad:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106db2:	e9 42 f0 ff ff       	jmp    80105df9 <alltraps>

80106db7 <vector237>:
.globl vector237
vector237:
  pushl $0
80106db7:	6a 00                	push   $0x0
  pushl $237
80106db9:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106dbe:	e9 36 f0 ff ff       	jmp    80105df9 <alltraps>

80106dc3 <vector238>:
.globl vector238
vector238:
  pushl $0
80106dc3:	6a 00                	push   $0x0
  pushl $238
80106dc5:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106dca:	e9 2a f0 ff ff       	jmp    80105df9 <alltraps>

80106dcf <vector239>:
.globl vector239
vector239:
  pushl $0
80106dcf:	6a 00                	push   $0x0
  pushl $239
80106dd1:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106dd6:	e9 1e f0 ff ff       	jmp    80105df9 <alltraps>

80106ddb <vector240>:
.globl vector240
vector240:
  pushl $0
80106ddb:	6a 00                	push   $0x0
  pushl $240
80106ddd:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106de2:	e9 12 f0 ff ff       	jmp    80105df9 <alltraps>

80106de7 <vector241>:
.globl vector241
vector241:
  pushl $0
80106de7:	6a 00                	push   $0x0
  pushl $241
80106de9:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106dee:	e9 06 f0 ff ff       	jmp    80105df9 <alltraps>

80106df3 <vector242>:
.globl vector242
vector242:
  pushl $0
80106df3:	6a 00                	push   $0x0
  pushl $242
80106df5:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106dfa:	e9 fa ef ff ff       	jmp    80105df9 <alltraps>

80106dff <vector243>:
.globl vector243
vector243:
  pushl $0
80106dff:	6a 00                	push   $0x0
  pushl $243
80106e01:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106e06:	e9 ee ef ff ff       	jmp    80105df9 <alltraps>

80106e0b <vector244>:
.globl vector244
vector244:
  pushl $0
80106e0b:	6a 00                	push   $0x0
  pushl $244
80106e0d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106e12:	e9 e2 ef ff ff       	jmp    80105df9 <alltraps>

80106e17 <vector245>:
.globl vector245
vector245:
  pushl $0
80106e17:	6a 00                	push   $0x0
  pushl $245
80106e19:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106e1e:	e9 d6 ef ff ff       	jmp    80105df9 <alltraps>

80106e23 <vector246>:
.globl vector246
vector246:
  pushl $0
80106e23:	6a 00                	push   $0x0
  pushl $246
80106e25:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106e2a:	e9 ca ef ff ff       	jmp    80105df9 <alltraps>

80106e2f <vector247>:
.globl vector247
vector247:
  pushl $0
80106e2f:	6a 00                	push   $0x0
  pushl $247
80106e31:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106e36:	e9 be ef ff ff       	jmp    80105df9 <alltraps>

80106e3b <vector248>:
.globl vector248
vector248:
  pushl $0
80106e3b:	6a 00                	push   $0x0
  pushl $248
80106e3d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106e42:	e9 b2 ef ff ff       	jmp    80105df9 <alltraps>

80106e47 <vector249>:
.globl vector249
vector249:
  pushl $0
80106e47:	6a 00                	push   $0x0
  pushl $249
80106e49:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106e4e:	e9 a6 ef ff ff       	jmp    80105df9 <alltraps>

80106e53 <vector250>:
.globl vector250
vector250:
  pushl $0
80106e53:	6a 00                	push   $0x0
  pushl $250
80106e55:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106e5a:	e9 9a ef ff ff       	jmp    80105df9 <alltraps>

80106e5f <vector251>:
.globl vector251
vector251:
  pushl $0
80106e5f:	6a 00                	push   $0x0
  pushl $251
80106e61:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106e66:	e9 8e ef ff ff       	jmp    80105df9 <alltraps>

80106e6b <vector252>:
.globl vector252
vector252:
  pushl $0
80106e6b:	6a 00                	push   $0x0
  pushl $252
80106e6d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106e72:	e9 82 ef ff ff       	jmp    80105df9 <alltraps>

80106e77 <vector253>:
.globl vector253
vector253:
  pushl $0
80106e77:	6a 00                	push   $0x0
  pushl $253
80106e79:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106e7e:	e9 76 ef ff ff       	jmp    80105df9 <alltraps>

80106e83 <vector254>:
.globl vector254
vector254:
  pushl $0
80106e83:	6a 00                	push   $0x0
  pushl $254
80106e85:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106e8a:	e9 6a ef ff ff       	jmp    80105df9 <alltraps>

80106e8f <vector255>:
.globl vector255
vector255:
  pushl $0
80106e8f:	6a 00                	push   $0x0
  pushl $255
80106e91:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106e96:	e9 5e ef ff ff       	jmp    80105df9 <alltraps>
80106e9b:	66 90                	xchg   %ax,%ax
80106e9d:	66 90                	xchg   %ax,%ax
80106e9f:	90                   	nop

80106ea0 <cow_kfree>:
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc);
int swap_in(struct proc* p, struct pageinfo* pi);
void swap_out(struct proc* p, struct pageinfo* page_to_swap, void* buffer, pde_t* pgdir);

void cow_kfree(char* to_free_kva){
80106ea0:	f3 0f 1e fb          	endbr32 
80106ea4:	55                   	push   %ebp
80106ea5:	89 e5                	mov    %esp,%ebp
80106ea7:	56                   	push   %esi
80106ea8:	53                   	push   %ebx
80106ea9:	8b 75 08             	mov    0x8(%ebp),%esi
80106eac:	8d 9e 00 00 00 80    	lea    -0x80000000(%esi),%ebx
  char count;
  int acq = 0;
  if (lapicid() != 0){
80106eb2:	e8 89 be ff ff       	call   80102d40 <lapicid>
80106eb7:	c1 eb 0c             	shr    $0xc,%ebx
80106eba:	85 c0                	test   %eax,%eax
80106ebc:	75 22                	jne    80106ee0 <cow_kfree+0x40>
    acquire(cow_lock);
  }
  // struct proc* p = myproc();
  // if (p != 0 ){ // && p->pid > 2
  count = --pg_ref_counts[PGROUNDDOWN(V2P(to_free_kva)) / PGSIZE];
  if (count != 0){
80106ebe:	80 ab 40 0f 11 80 01 	subb   $0x1,-0x7feef0c0(%ebx)
80106ec5:	75 11                	jne    80106ed8 <cow_kfree+0x38>
  // possible bug
  if (acq){
    // cprintf("rel kfree %d\n", myproc()->pid);
    release(cow_lock);
  }
  kfree(to_free_kva);
80106ec7:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106eca:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106ecd:	5b                   	pop    %ebx
80106ece:	5e                   	pop    %esi
80106ecf:	5d                   	pop    %ebp
  kfree(to_free_kva);
80106ed0:	e9 0b ba ff ff       	jmp    801028e0 <kfree>
80106ed5:	8d 76 00             	lea    0x0(%esi),%esi
}
80106ed8:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106edb:	5b                   	pop    %ebx
80106edc:	5e                   	pop    %esi
80106edd:	5d                   	pop    %ebp
80106ede:	c3                   	ret    
80106edf:	90                   	nop
    acquire(cow_lock);
80106ee0:	83 ec 0c             	sub    $0xc,%esp
80106ee3:	ff 35 40 ef 11 80    	pushl  0x8011ef40
80106ee9:	e8 d2 db ff ff       	call   80104ac0 <acquire>
  count = --pg_ref_counts[PGROUNDDOWN(V2P(to_free_kva)) / PGSIZE];
80106eee:	0f b6 83 40 0f 11 80 	movzbl -0x7feef0c0(%ebx),%eax
  if (count != 0){
80106ef5:	83 c4 10             	add    $0x10,%esp
  count = --pg_ref_counts[PGROUNDDOWN(V2P(to_free_kva)) / PGSIZE];
80106ef8:	83 e8 01             	sub    $0x1,%eax
80106efb:	88 83 40 0f 11 80    	mov    %al,-0x7feef0c0(%ebx)
  if (count != 0){
80106f01:	84 c0                	test   %al,%al
80106f03:	75 23                	jne    80106f28 <cow_kfree+0x88>
    release(cow_lock);
80106f05:	83 ec 0c             	sub    $0xc,%esp
80106f08:	ff 35 40 ef 11 80    	pushl  0x8011ef40
80106f0e:	e8 6d dc ff ff       	call   80104b80 <release>
  kfree(to_free_kva);
80106f13:	89 75 08             	mov    %esi,0x8(%ebp)
    release(cow_lock);
80106f16:	83 c4 10             	add    $0x10,%esp
}
80106f19:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106f1c:	5b                   	pop    %ebx
80106f1d:	5e                   	pop    %esi
80106f1e:	5d                   	pop    %ebp
  kfree(to_free_kva);
80106f1f:	e9 bc b9 ff ff       	jmp    801028e0 <kfree>
80106f24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      release(cow_lock);
80106f28:	a1 40 ef 11 80       	mov    0x8011ef40,%eax
80106f2d:	89 45 08             	mov    %eax,0x8(%ebp)
}
80106f30:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106f33:	5b                   	pop    %ebx
80106f34:	5e                   	pop    %esi
80106f35:	5d                   	pop    %ebp
      release(cow_lock);
80106f36:	e9 45 dc ff ff       	jmp    80104b80 <release>
80106f3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106f3f:	90                   	nop

80106f40 <cow_kalloc>:

char* cow_kalloc(){
80106f40:	f3 0f 1e fb          	endbr32 
80106f44:	55                   	push   %ebp
80106f45:	89 e5                	mov    %esp,%ebp
80106f47:	57                   	push   %edi
80106f48:	56                   	push   %esi
80106f49:	53                   	push   %ebx
80106f4a:	83 ec 0c             	sub    $0xc,%esp
  char* r = kalloc();
80106f4d:	e8 7e bb ff ff       	call   80102ad0 <kalloc>
80106f52:	89 c3                	mov    %eax,%ebx
  if (r == 0){
80106f54:	85 c0                	test   %eax,%eax
80106f56:	74 28                	je     80106f80 <cow_kalloc+0x40>
    return r;
  }
  int acq = 0;
  // cprintf("kalloc \n");
  if (lapicid() != 0){
80106f58:	e8 e3 bd ff ff       	call   80102d40 <lapicid>
80106f5d:	8d bb 00 00 00 80    	lea    -0x80000000(%ebx),%edi
80106f63:	89 fe                	mov    %edi,%esi
80106f65:	c1 ee 0c             	shr    $0xc,%esi
80106f68:	85 c0                	test   %eax,%eax
80106f6a:	75 24                	jne    80106f90 <cow_kalloc+0x50>
    acq = 1;
    // cprintf("kalloc %d\n", myproc()->pid);
    acquire(cow_lock);
  }
  if (pg_ref_counts[PGROUNDDOWN(V2P(r)) / PGSIZE]++ != 0){ 
80106f6c:	0f b6 86 40 0f 11 80 	movzbl -0x7feef0c0(%esi),%eax
80106f73:	8d 50 01             	lea    0x1(%eax),%edx
80106f76:	88 96 40 0f 11 80    	mov    %dl,-0x7feef0c0(%esi)
80106f7c:	84 c0                	test   %al,%al
80106f7e:	75 50                	jne    80106fd0 <cow_kalloc+0x90>
  }
  if (acq){
    release(cow_lock);
  }
  return r;
}
80106f80:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f83:	89 d8                	mov    %ebx,%eax
80106f85:	5b                   	pop    %ebx
80106f86:	5e                   	pop    %esi
80106f87:	5f                   	pop    %edi
80106f88:	5d                   	pop    %ebp
80106f89:	c3                   	ret    
80106f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(cow_lock);
80106f90:	83 ec 0c             	sub    $0xc,%esp
80106f93:	ff 35 40 ef 11 80    	pushl  0x8011ef40
80106f99:	e8 22 db ff ff       	call   80104ac0 <acquire>
  if (pg_ref_counts[PGROUNDDOWN(V2P(r)) / PGSIZE]++ != 0){ 
80106f9e:	0f b6 86 40 0f 11 80 	movzbl -0x7feef0c0(%esi),%eax
80106fa5:	83 c4 10             	add    $0x10,%esp
80106fa8:	8d 50 01             	lea    0x1(%eax),%edx
80106fab:	88 96 40 0f 11 80    	mov    %dl,-0x7feef0c0(%esi)
80106fb1:	84 c0                	test   %al,%al
80106fb3:	75 1b                	jne    80106fd0 <cow_kalloc+0x90>
    release(cow_lock);
80106fb5:	83 ec 0c             	sub    $0xc,%esp
80106fb8:	ff 35 40 ef 11 80    	pushl  0x8011ef40
80106fbe:	e8 bd db ff ff       	call   80104b80 <release>
80106fc3:	83 c4 10             	add    $0x10,%esp
}
80106fc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fc9:	89 d8                	mov    %ebx,%eax
80106fcb:	5b                   	pop    %ebx
80106fcc:	5e                   	pop    %esi
80106fcd:	5f                   	pop    %edi
80106fce:	5d                   	pop    %ebp
80106fcf:	c3                   	ret    
    cprintf("actual ref count = %d, pg index = %x, pg pa = %x\n", pg_ref_counts[PGROUNDDOWN(V2P(r)) / PGSIZE] - 1, PGROUNDDOWN(V2P(r)) / PGSIZE, V2P(r));
80106fd0:	0f be c2             	movsbl %dl,%eax
80106fd3:	57                   	push   %edi
80106fd4:	83 e8 01             	sub    $0x1,%eax
80106fd7:	56                   	push   %esi
80106fd8:	50                   	push   %eax
80106fd9:	68 18 8a 10 80       	push   $0x80108a18
80106fde:	e8 cd 96 ff ff       	call   801006b0 <cprintf>
    panic("kalloc allocated something with a reference");
80106fe3:	c7 04 24 4c 8a 10 80 	movl   $0x80108a4c,(%esp)
80106fea:	e8 a1 93 ff ff       	call   80100390 <panic>
80106fef:	90                   	nop

80106ff0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106ff0:	55                   	push   %ebp
80106ff1:	89 e5                	mov    %esp,%ebp
80106ff3:	57                   	push   %edi
80106ff4:	56                   	push   %esi
80106ff5:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106ff7:	c1 ea 16             	shr    $0x16,%edx
{
80106ffa:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
80106ffb:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
80106ffe:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80107001:	8b 1f                	mov    (%edi),%ebx
80107003:	f6 c3 01             	test   $0x1,%bl
80107006:	74 28                	je     80107030 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107008:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010700e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107014:	89 f0                	mov    %esi,%eax
}
80107016:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80107019:	c1 e8 0a             	shr    $0xa,%eax
8010701c:	25 fc 0f 00 00       	and    $0xffc,%eax
80107021:	01 d8                	add    %ebx,%eax
}
80107023:	5b                   	pop    %ebx
80107024:	5e                   	pop    %esi
80107025:	5f                   	pop    %edi
80107026:	5d                   	pop    %ebp
80107027:	c3                   	ret    
80107028:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010702f:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)cow_kalloc()) == 0)
80107030:	85 c9                	test   %ecx,%ecx
80107032:	74 2c                	je     80107060 <walkpgdir+0x70>
80107034:	e8 07 ff ff ff       	call   80106f40 <cow_kalloc>
80107039:	89 c3                	mov    %eax,%ebx
8010703b:	85 c0                	test   %eax,%eax
8010703d:	74 21                	je     80107060 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010703f:	83 ec 04             	sub    $0x4,%esp
80107042:	68 00 10 00 00       	push   $0x1000
80107047:	6a 00                	push   $0x0
80107049:	50                   	push   %eax
8010704a:	e8 81 db ff ff       	call   80104bd0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010704f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107055:	83 c4 10             	add    $0x10,%esp
80107058:	83 c8 07             	or     $0x7,%eax
8010705b:	89 07                	mov    %eax,(%edi)
8010705d:	eb b5                	jmp    80107014 <walkpgdir+0x24>
8010705f:	90                   	nop
}
80107060:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107063:	31 c0                	xor    %eax,%eax
}
80107065:	5b                   	pop    %ebx
80107066:	5e                   	pop    %esi
80107067:	5f                   	pop    %edi
80107068:	5d                   	pop    %ebp
80107069:	c3                   	ret    
8010706a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107070 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107070:	55                   	push   %ebp
80107071:	89 e5                	mov    %esp,%ebp
80107073:	57                   	push   %edi
80107074:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107076:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
8010707a:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010707b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80107080:	89 d6                	mov    %edx,%esi
{
80107082:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107083:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80107089:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010708c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010708f:	8b 45 08             	mov    0x8(%ebp),%eax
80107092:	29 f0                	sub    %esi,%eax
80107094:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107097:	eb 1f                	jmp    801070b8 <mappages+0x48>
80107099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  // cprintf("mappages start: %x end: %x \n", a, last);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
801070a0:	f6 00 01             	testb  $0x1,(%eax)
801070a3:	75 45                	jne    801070ea <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
801070a5:	0b 5d 0c             	or     0xc(%ebp),%ebx
801070a8:	83 cb 01             	or     $0x1,%ebx
801070ab:	89 18                	mov    %ebx,(%eax)
    if(a == last)
801070ad:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801070b0:	74 2e                	je     801070e0 <mappages+0x70>
      break;
    a += PGSIZE;
801070b2:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
801070b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801070bb:	b9 01 00 00 00       	mov    $0x1,%ecx
801070c0:	89 f2                	mov    %esi,%edx
801070c2:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
801070c5:	89 f8                	mov    %edi,%eax
801070c7:	e8 24 ff ff ff       	call   80106ff0 <walkpgdir>
801070cc:	85 c0                	test   %eax,%eax
801070ce:	75 d0                	jne    801070a0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
801070d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801070d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801070d8:	5b                   	pop    %ebx
801070d9:	5e                   	pop    %esi
801070da:	5f                   	pop    %edi
801070db:	5d                   	pop    %ebp
801070dc:	c3                   	ret    
801070dd:	8d 76 00             	lea    0x0(%esi),%esi
801070e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801070e3:	31 c0                	xor    %eax,%eax
}
801070e5:	5b                   	pop    %ebx
801070e6:	5e                   	pop    %esi
801070e7:	5f                   	pop    %edi
801070e8:	5d                   	pop    %ebp
801070e9:	c3                   	ret    
      panic("remap");
801070ea:	83 ec 0c             	sub    $0xc,%esp
801070ed:	68 c2 8a 10 80       	push   $0x80108ac2
801070f2:	e8 99 92 ff ff       	call   80100390 <panic>
801070f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070fe:	66 90                	xchg   %ax,%ax

80107100 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107100:	55                   	push   %ebp
80107101:	89 e5                	mov    %esp,%ebp
80107103:	57                   	push   %edi
80107104:	56                   	push   %esi
80107105:	89 c6                	mov    %eax,%esi
80107107:	53                   	push   %ebx
80107108:	89 d3                	mov    %edx,%ebx
  // struct proc* p = myproc();

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010710a:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
80107110:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107116:	83 ec 1c             	sub    $0x1c,%esp
80107119:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010711c:	39 da                	cmp    %ebx,%edx
8010711e:	73 5b                	jae    8010717b <deallocuvm.part.0+0x7b>
80107120:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80107123:	89 d7                	mov    %edx,%edi
80107125:	eb 14                	jmp    8010713b <deallocuvm.part.0+0x3b>
80107127:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010712e:	66 90                	xchg   %ax,%ax
80107130:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107136:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80107139:	76 40                	jbe    8010717b <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010713b:	31 c9                	xor    %ecx,%ecx
8010713d:	89 fa                	mov    %edi,%edx
8010713f:	89 f0                	mov    %esi,%eax
80107141:	e8 aa fe ff ff       	call   80106ff0 <walkpgdir>
80107146:	89 c3                	mov    %eax,%ebx
    if(!pte)
80107148:	85 c0                	test   %eax,%eax
8010714a:	74 44                	je     80107190 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
8010714c:	8b 00                	mov    (%eax),%eax
8010714e:	a8 01                	test   $0x1,%al
80107150:	74 de                	je     80107130 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80107152:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107157:	74 47                	je     801071a0 <deallocuvm.part.0+0xa0>
        panic("cow_kfree");
      char *v = P2V(pa);
      cow_kfree(v);
80107159:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010715c:	05 00 00 00 80       	add    $0x80000000,%eax
80107161:	81 c7 00 10 00 00    	add    $0x1000,%edi
      cow_kfree(v);
80107167:	50                   	push   %eax
80107168:	e8 33 fd ff ff       	call   80106ea0 <cow_kfree>
            break;
          }
        }
      }
      #endif
      *pte = 0;
8010716d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80107173:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
80107176:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80107179:	77 c0                	ja     8010713b <deallocuvm.part.0+0x3b>
    }
  }

  return newsz;
}
8010717b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010717e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107181:	5b                   	pop    %ebx
80107182:	5e                   	pop    %esi
80107183:	5f                   	pop    %edi
80107184:	5d                   	pop    %ebp
80107185:	c3                   	ret    
80107186:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010718d:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107190:	89 fa                	mov    %edi,%edx
80107192:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80107198:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
8010719e:	eb 96                	jmp    80107136 <deallocuvm.part.0+0x36>
        panic("cow_kfree");
801071a0:	83 ec 0c             	sub    $0xc,%esp
801071a3:	68 c8 8a 10 80       	push   $0x80108ac8
801071a8:	e8 e3 91 ff ff       	call   80100390 <panic>
801071ad:	8d 76 00             	lea    0x0(%esi),%esi

801071b0 <find_page_to_swap>:
struct pageinfo* find_page_to_swap(struct proc* p, pde_t* pgdir){
801071b0:	f3 0f 1e fb          	endbr32 
801071b4:	55                   	push   %ebp
801071b5:	89 e5                	mov    %esp,%ebp
801071b7:	57                   	push   %edi
801071b8:	56                   	push   %esi
801071b9:	53                   	push   %ebx
801071ba:	83 ec 1c             	sub    $0x1c,%esp
801071bd:	8b 45 08             	mov    0x8(%ebp),%eax
801071c0:	8b 75 0c             	mov    0xc(%ebp),%esi
801071c3:	8d b8 00 02 00 00    	lea    0x200(%eax),%edi
801071c9:	8d 98 80 03 00 00    	lea    0x380(%eax),%ebx
801071cf:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801071d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    for (int i = 0; i < MAX_PYSC_PAGES; i++){
801071d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    struct pageinfo* min_pi = 0;
801071db:	31 ff                	xor    %edi,%edi
    uint min = 0x0FFFFFFF;
801071dd:	b9 ff ff ff 0f       	mov    $0xfffffff,%ecx
801071e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if (!pi->is_free && pi->page_index < min){
801071e8:	8b 10                	mov    (%eax),%edx
801071ea:	85 d2                	test   %edx,%edx
801071ec:	75 0b                	jne    801071f9 <find_page_to_swap+0x49>
801071ee:	8b 50 0c             	mov    0xc(%eax),%edx
801071f1:	39 ca                	cmp    %ecx,%edx
801071f3:	73 04                	jae    801071f9 <find_page_to_swap+0x49>
801071f5:	89 c7                	mov    %eax,%edi
801071f7:	89 d1                	mov    %edx,%ecx
    for (int i = 0; i < MAX_PYSC_PAGES; i++){
801071f9:	83 c0 18             	add    $0x18,%eax
801071fc:	39 d8                	cmp    %ebx,%eax
801071fe:	75 e8                	jne    801071e8 <find_page_to_swap+0x38>
    pte_t* pte = walkpgdir(pgdir, min_pi, 0);
80107200:	31 c9                	xor    %ecx,%ecx
80107202:	89 fa                	mov    %edi,%edx
80107204:	89 f0                	mov    %esi,%eax
80107206:	e8 e5 fd ff ff       	call   80106ff0 <walkpgdir>
    if (*pte & PTE_A){
8010720b:	f6 00 20             	testb  $0x20,(%eax)
8010720e:	74 17                	je     80107227 <find_page_to_swap+0x77>
      min_pi->page_index = (++page_counter);
80107210:	8b 0d c0 b5 10 80    	mov    0x8010b5c0,%ecx
80107216:	8d 51 01             	lea    0x1(%ecx),%edx
80107219:	89 15 c0 b5 10 80    	mov    %edx,0x8010b5c0
8010721f:	89 57 0c             	mov    %edx,0xc(%edi)
      *pte &= ~PTE_A;
80107222:	83 20 df             	andl   $0xffffffdf,(%eax)
  while(1){
80107225:	eb b1                	jmp    801071d8 <find_page_to_swap+0x28>
}
80107227:	83 c4 1c             	add    $0x1c,%esp
8010722a:	89 f8                	mov    %edi,%eax
8010722c:	5b                   	pop    %ebx
8010722d:	5e                   	pop    %esi
8010722e:	5f                   	pop    %edi
8010722f:	5d                   	pop    %ebp
80107230:	c3                   	ret    
80107231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010723f:	90                   	nop

80107240 <find_page_to_swap1>:
struct pageinfo* find_page_to_swap1(struct proc* p, pde_t* pgdir){
80107240:	f3 0f 1e fb          	endbr32 
80107244:	55                   	push   %ebp
  j = j % 16;
80107245:	99                   	cltd   
80107246:	c1 ea 1c             	shr    $0x1c,%edx
struct pageinfo* find_page_to_swap1(struct proc* p, pde_t* pgdir){
80107249:	89 e5                	mov    %esp,%ebp
8010724b:	57                   	push   %edi
8010724c:	56                   	push   %esi
8010724d:	53                   	push   %ebx
  j = j % 16;
8010724e:	8d 1c 10             	lea    (%eax,%edx,1),%ebx
80107251:	83 e3 0f             	and    $0xf,%ebx
80107254:	29 d3                	sub    %edx,%ebx
struct pageinfo* find_page_to_swap1(struct proc* p, pde_t* pgdir){
80107256:	83 ec 14             	sub    $0x14,%esp
  for (int i = j; i != (j - 1) % 16; i = (i + 1) % 16){
80107259:	8d 73 ff             	lea    -0x1(%ebx),%esi
  cprintf("%d\n", j);
8010725c:	53                   	push   %ebx
8010725d:	68 75 88 10 80       	push   $0x80108875
80107262:	e8 49 94 ff ff       	call   801006b0 <cprintf>
  for (int i = j; i != (j - 1) % 16; i = (i + 1) % 16){
80107267:	89 f0                	mov    %esi,%eax
80107269:	83 c4 10             	add    $0x10,%esp
8010726c:	c1 f8 1f             	sar    $0x1f,%eax
8010726f:	c1 e8 1c             	shr    $0x1c,%eax
80107272:	01 c6                	add    %eax,%esi
80107274:	83 e6 0f             	and    $0xf,%esi
80107277:	29 c6                	sub    %eax,%esi
80107279:	39 f3                	cmp    %esi,%ebx
8010727b:	74 5b                	je     801072d8 <find_page_to_swap1+0x98>
8010727d:	89 df                	mov    %ebx,%edi
8010727f:	eb 1b                	jmp    8010729c <find_page_to_swap1+0x5c>
80107281:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107288:	8d 47 01             	lea    0x1(%edi),%eax
8010728b:	99                   	cltd   
8010728c:	c1 ea 1c             	shr    $0x1c,%edx
8010728f:	01 d0                	add    %edx,%eax
80107291:	83 e0 0f             	and    $0xf,%eax
80107294:	29 d0                	sub    %edx,%eax
80107296:	89 c7                	mov    %eax,%edi
80107298:	39 f0                	cmp    %esi,%eax
8010729a:	74 3c                	je     801072d8 <find_page_to_swap1+0x98>
    cprintf("%d\n", j);
8010729c:	83 ec 08             	sub    $0x8,%esp
8010729f:	53                   	push   %ebx
801072a0:	68 75 88 10 80       	push   $0x80108875
801072a5:	e8 06 94 ff ff       	call   801006b0 <cprintf>
    if (!p->ram_pages[i].is_free){
801072aa:	8b 45 08             	mov    0x8(%ebp),%eax
801072ad:	8d 14 7f             	lea    (%edi,%edi,2),%edx
801072b0:	83 c4 10             	add    $0x10,%esp
801072b3:	8d 0c d5 00 00 00 00 	lea    0x0(,%edx,8),%ecx
801072ba:	8b 94 d0 00 02 00 00 	mov    0x200(%eax,%edx,8),%edx
801072c1:	85 d2                	test   %edx,%edx
801072c3:	75 c3                	jne    80107288 <find_page_to_swap1+0x48>
}
801072c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return &p->ram_pages[i];
801072c8:	8d 84 08 00 02 00 00 	lea    0x200(%eax,%ecx,1),%eax
}
801072cf:	5b                   	pop    %ebx
801072d0:	5e                   	pop    %esi
801072d1:	5f                   	pop    %edi
801072d2:	5d                   	pop    %ebp
801072d3:	c3                   	ret    
801072d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801072d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801072db:	31 c0                	xor    %eax,%eax
}
801072dd:	5b                   	pop    %ebx
801072de:	5e                   	pop    %esi
801072df:	5f                   	pop    %edi
801072e0:	5d                   	pop    %ebp
801072e1:	c3                   	ret    
801072e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801072f0 <seginit>:
{
801072f0:	f3 0f 1e fb          	endbr32 
801072f4:	55                   	push   %ebp
801072f5:	89 e5                	mov    %esp,%ebp
801072f7:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801072fa:	e8 11 cb ff ff       	call   80103e10 <cpuid>
  pd[0] = size-1;
801072ff:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107304:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
8010730a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010730e:	c7 80 78 18 12 80 ff 	movl   $0xffff,-0x7fede788(%eax)
80107315:	ff 00 00 
80107318:	c7 80 7c 18 12 80 00 	movl   $0xcf9a00,-0x7fede784(%eax)
8010731f:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107322:	c7 80 80 18 12 80 ff 	movl   $0xffff,-0x7fede780(%eax)
80107329:	ff 00 00 
8010732c:	c7 80 84 18 12 80 00 	movl   $0xcf9200,-0x7fede77c(%eax)
80107333:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107336:	c7 80 88 18 12 80 ff 	movl   $0xffff,-0x7fede778(%eax)
8010733d:	ff 00 00 
80107340:	c7 80 8c 18 12 80 00 	movl   $0xcffa00,-0x7fede774(%eax)
80107347:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010734a:	c7 80 90 18 12 80 ff 	movl   $0xffff,-0x7fede770(%eax)
80107351:	ff 00 00 
80107354:	c7 80 94 18 12 80 00 	movl   $0xcff200,-0x7fede76c(%eax)
8010735b:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010735e:	05 70 18 12 80       	add    $0x80121870,%eax
  pd[1] = (uint)p;
80107363:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107367:	c1 e8 10             	shr    $0x10,%eax
8010736a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010736e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107371:	0f 01 10             	lgdtl  (%eax)
}
80107374:	c9                   	leave  
80107375:	c3                   	ret    
80107376:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010737d:	8d 76 00             	lea    0x0(%esi),%esi

80107380 <public_walkpgdir>:
public_walkpgdir(pde_t *pgdir, const void *va, int alloc){
80107380:	f3 0f 1e fb          	endbr32 
80107384:	55                   	push   %ebp
80107385:	89 e5                	mov    %esp,%ebp
  return walkpgdir(pgdir, va, alloc);
80107387:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010738a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010738d:	8b 45 08             	mov    0x8(%ebp),%eax
}
80107390:	5d                   	pop    %ebp
  return walkpgdir(pgdir, va, alloc);
80107391:	e9 5a fc ff ff       	jmp    80106ff0 <walkpgdir>
80107396:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010739d:	8d 76 00             	lea    0x0(%esi),%esi

801073a0 <switchkvm>:
{
801073a0:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801073a4:	a1 24 0a 13 80       	mov    0x80130a24,%eax
801073a9:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801073ae:	0f 22 d8             	mov    %eax,%cr3
}
801073b1:	c3                   	ret    
801073b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801073c0 <switchuvm>:
{
801073c0:	f3 0f 1e fb          	endbr32 
801073c4:	55                   	push   %ebp
801073c5:	89 e5                	mov    %esp,%ebp
801073c7:	57                   	push   %edi
801073c8:	56                   	push   %esi
801073c9:	53                   	push   %ebx
801073ca:	83 ec 1c             	sub    $0x1c,%esp
801073cd:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801073d0:	85 f6                	test   %esi,%esi
801073d2:	0f 84 cb 00 00 00    	je     801074a3 <switchuvm+0xe3>
  if(p->kstack == 0)
801073d8:	8b 46 08             	mov    0x8(%esi),%eax
801073db:	85 c0                	test   %eax,%eax
801073dd:	0f 84 da 00 00 00    	je     801074bd <switchuvm+0xfd>
  if(p->pgdir == 0)
801073e3:	8b 46 04             	mov    0x4(%esi),%eax
801073e6:	85 c0                	test   %eax,%eax
801073e8:	0f 84 c2 00 00 00    	je     801074b0 <switchuvm+0xf0>
  pushcli();
801073ee:	e8 cd d5 ff ff       	call   801049c0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801073f3:	e8 98 c9 ff ff       	call   80103d90 <mycpu>
801073f8:	89 c3                	mov    %eax,%ebx
801073fa:	e8 91 c9 ff ff       	call   80103d90 <mycpu>
801073ff:	89 c7                	mov    %eax,%edi
80107401:	e8 8a c9 ff ff       	call   80103d90 <mycpu>
80107406:	83 c7 08             	add    $0x8,%edi
80107409:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010740c:	e8 7f c9 ff ff       	call   80103d90 <mycpu>
80107411:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107414:	ba 67 00 00 00       	mov    $0x67,%edx
80107419:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107420:	83 c0 08             	add    $0x8,%eax
80107423:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010742a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010742f:	83 c1 08             	add    $0x8,%ecx
80107432:	c1 e8 18             	shr    $0x18,%eax
80107435:	c1 e9 10             	shr    $0x10,%ecx
80107438:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010743e:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107444:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107449:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107450:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107455:	e8 36 c9 ff ff       	call   80103d90 <mycpu>
8010745a:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107461:	e8 2a c9 ff ff       	call   80103d90 <mycpu>
80107466:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
8010746a:	8b 5e 08             	mov    0x8(%esi),%ebx
8010746d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107473:	e8 18 c9 ff ff       	call   80103d90 <mycpu>
80107478:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010747b:	e8 10 c9 ff ff       	call   80103d90 <mycpu>
80107480:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107484:	b8 28 00 00 00       	mov    $0x28,%eax
80107489:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010748c:	8b 46 04             	mov    0x4(%esi),%eax
8010748f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107494:	0f 22 d8             	mov    %eax,%cr3
}
80107497:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010749a:	5b                   	pop    %ebx
8010749b:	5e                   	pop    %esi
8010749c:	5f                   	pop    %edi
8010749d:	5d                   	pop    %ebp
  popcli();
8010749e:	e9 6d d5 ff ff       	jmp    80104a10 <popcli>
    panic("switchuvm: no process");
801074a3:	83 ec 0c             	sub    $0xc,%esp
801074a6:	68 d2 8a 10 80       	push   $0x80108ad2
801074ab:	e8 e0 8e ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
801074b0:	83 ec 0c             	sub    $0xc,%esp
801074b3:	68 fd 8a 10 80       	push   $0x80108afd
801074b8:	e8 d3 8e ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
801074bd:	83 ec 0c             	sub    $0xc,%esp
801074c0:	68 e8 8a 10 80       	push   $0x80108ae8
801074c5:	e8 c6 8e ff ff       	call   80100390 <panic>
801074ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801074d0 <inituvm>:
{
801074d0:	f3 0f 1e fb          	endbr32 
801074d4:	55                   	push   %ebp
801074d5:	89 e5                	mov    %esp,%ebp
801074d7:	57                   	push   %edi
801074d8:	56                   	push   %esi
801074d9:	53                   	push   %ebx
801074da:	83 ec 1c             	sub    $0x1c,%esp
801074dd:	8b 45 0c             	mov    0xc(%ebp),%eax
801074e0:	8b 75 10             	mov    0x10(%ebp),%esi
801074e3:	8b 7d 08             	mov    0x8(%ebp),%edi
801074e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801074e9:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801074ef:	77 4b                	ja     8010753c <inituvm+0x6c>
  mem = cow_kalloc();
801074f1:	e8 4a fa ff ff       	call   80106f40 <cow_kalloc>
  memset(mem, 0, PGSIZE);
801074f6:	83 ec 04             	sub    $0x4,%esp
801074f9:	68 00 10 00 00       	push   $0x1000
  mem = cow_kalloc();
801074fe:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107500:	6a 00                	push   $0x0
80107502:	50                   	push   %eax
80107503:	e8 c8 d6 ff ff       	call   80104bd0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107508:	58                   	pop    %eax
80107509:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010750f:	5a                   	pop    %edx
80107510:	6a 06                	push   $0x6
80107512:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107517:	31 d2                	xor    %edx,%edx
80107519:	50                   	push   %eax
8010751a:	89 f8                	mov    %edi,%eax
8010751c:	e8 4f fb ff ff       	call   80107070 <mappages>
  memmove(mem, init, sz);
80107521:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107524:	89 75 10             	mov    %esi,0x10(%ebp)
80107527:	83 c4 10             	add    $0x10,%esp
8010752a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010752d:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80107530:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107533:	5b                   	pop    %ebx
80107534:	5e                   	pop    %esi
80107535:	5f                   	pop    %edi
80107536:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107537:	e9 34 d7 ff ff       	jmp    80104c70 <memmove>
    panic("inituvm: more than a page");
8010753c:	83 ec 0c             	sub    $0xc,%esp
8010753f:	68 11 8b 10 80       	push   $0x80108b11
80107544:	e8 47 8e ff ff       	call   80100390 <panic>
80107549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107550 <loaduvm>:
{
80107550:	f3 0f 1e fb          	endbr32 
80107554:	55                   	push   %ebp
80107555:	89 e5                	mov    %esp,%ebp
80107557:	57                   	push   %edi
80107558:	56                   	push   %esi
80107559:	53                   	push   %ebx
8010755a:	83 ec 1c             	sub    $0x1c,%esp
8010755d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107560:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80107563:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107568:	0f 85 99 00 00 00    	jne    80107607 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
8010756e:	01 f0                	add    %esi,%eax
80107570:	89 f3                	mov    %esi,%ebx
80107572:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107575:	8b 45 14             	mov    0x14(%ebp),%eax
80107578:	01 f0                	add    %esi,%eax
8010757a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
8010757d:	85 f6                	test   %esi,%esi
8010757f:	75 15                	jne    80107596 <loaduvm+0x46>
80107581:	eb 6d                	jmp    801075f0 <loaduvm+0xa0>
80107583:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107587:	90                   	nop
80107588:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
8010758e:	89 f0                	mov    %esi,%eax
80107590:	29 d8                	sub    %ebx,%eax
80107592:	39 c6                	cmp    %eax,%esi
80107594:	76 5a                	jbe    801075f0 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107596:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107599:	8b 45 08             	mov    0x8(%ebp),%eax
8010759c:	31 c9                	xor    %ecx,%ecx
8010759e:	29 da                	sub    %ebx,%edx
801075a0:	e8 4b fa ff ff       	call   80106ff0 <walkpgdir>
801075a5:	85 c0                	test   %eax,%eax
801075a7:	74 51                	je     801075fa <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
801075a9:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801075ab:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
801075ae:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801075b3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801075b8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
801075be:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801075c1:	29 d9                	sub    %ebx,%ecx
801075c3:	05 00 00 00 80       	add    $0x80000000,%eax
801075c8:	57                   	push   %edi
801075c9:	51                   	push   %ecx
801075ca:	50                   	push   %eax
801075cb:	ff 75 10             	pushl  0x10(%ebp)
801075ce:	e8 1d a5 ff ff       	call   80101af0 <readi>
801075d3:	83 c4 10             	add    $0x10,%esp
801075d6:	39 f8                	cmp    %edi,%eax
801075d8:	74 ae                	je     80107588 <loaduvm+0x38>
}
801075da:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801075dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801075e2:	5b                   	pop    %ebx
801075e3:	5e                   	pop    %esi
801075e4:	5f                   	pop    %edi
801075e5:	5d                   	pop    %ebp
801075e6:	c3                   	ret    
801075e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075ee:	66 90                	xchg   %ax,%ax
801075f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801075f3:	31 c0                	xor    %eax,%eax
}
801075f5:	5b                   	pop    %ebx
801075f6:	5e                   	pop    %esi
801075f7:	5f                   	pop    %edi
801075f8:	5d                   	pop    %ebp
801075f9:	c3                   	ret    
      panic("loaduvm: address should exist");
801075fa:	83 ec 0c             	sub    $0xc,%esp
801075fd:	68 2b 8b 10 80       	push   $0x80108b2b
80107602:	e8 89 8d ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107607:	83 ec 0c             	sub    $0xc,%esp
8010760a:	68 78 8a 10 80       	push   $0x80108a78
8010760f:	e8 7c 8d ff ff       	call   80100390 <panic>
80107614:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010761b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010761f:	90                   	nop

80107620 <allocuvm>:
{
80107620:	f3 0f 1e fb          	endbr32 
80107624:	55                   	push   %ebp
80107625:	89 e5                	mov    %esp,%ebp
80107627:	57                   	push   %edi
80107628:	56                   	push   %esi
80107629:	53                   	push   %ebx
8010762a:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
8010762d:	8b 45 10             	mov    0x10(%ebp),%eax
{
80107630:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80107633:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107636:	85 c0                	test   %eax,%eax
80107638:	0f 88 b2 00 00 00    	js     801076f0 <allocuvm+0xd0>
  if(newsz < oldsz)
8010763e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107641:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107644:	0f 82 96 00 00 00    	jb     801076e0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
8010764a:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107650:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107656:	39 75 10             	cmp    %esi,0x10(%ebp)
80107659:	77 40                	ja     8010769b <allocuvm+0x7b>
8010765b:	e9 83 00 00 00       	jmp    801076e3 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
80107660:	83 ec 04             	sub    $0x4,%esp
80107663:	68 00 10 00 00       	push   $0x1000
80107668:	6a 00                	push   $0x0
8010766a:	50                   	push   %eax
8010766b:	e8 60 d5 ff ff       	call   80104bd0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107670:	58                   	pop    %eax
80107671:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107677:	5a                   	pop    %edx
80107678:	6a 06                	push   $0x6
8010767a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010767f:	89 f2                	mov    %esi,%edx
80107681:	50                   	push   %eax
80107682:	89 f8                	mov    %edi,%eax
80107684:	e8 e7 f9 ff ff       	call   80107070 <mappages>
80107689:	83 c4 10             	add    $0x10,%esp
8010768c:	85 c0                	test   %eax,%eax
8010768e:	78 78                	js     80107708 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107690:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107696:	39 75 10             	cmp    %esi,0x10(%ebp)
80107699:	76 48                	jbe    801076e3 <allocuvm+0xc3>
    mem = cow_kalloc();
8010769b:	e8 a0 f8 ff ff       	call   80106f40 <cow_kalloc>
801076a0:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801076a2:	85 c0                	test   %eax,%eax
801076a4:	75 ba                	jne    80107660 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801076a6:	83 ec 0c             	sub    $0xc,%esp
801076a9:	68 49 8b 10 80       	push   $0x80108b49
801076ae:	e8 fd 8f ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
801076b3:	8b 45 0c             	mov    0xc(%ebp),%eax
801076b6:	83 c4 10             	add    $0x10,%esp
801076b9:	39 45 10             	cmp    %eax,0x10(%ebp)
801076bc:	74 32                	je     801076f0 <allocuvm+0xd0>
801076be:	8b 55 10             	mov    0x10(%ebp),%edx
801076c1:	89 c1                	mov    %eax,%ecx
801076c3:	89 f8                	mov    %edi,%eax
801076c5:	e8 36 fa ff ff       	call   80107100 <deallocuvm.part.0>
      return 0;
801076ca:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801076d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801076d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076d7:	5b                   	pop    %ebx
801076d8:	5e                   	pop    %esi
801076d9:	5f                   	pop    %edi
801076da:	5d                   	pop    %ebp
801076db:	c3                   	ret    
801076dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
801076e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
801076e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801076e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076e9:	5b                   	pop    %ebx
801076ea:	5e                   	pop    %esi
801076eb:	5f                   	pop    %edi
801076ec:	5d                   	pop    %ebp
801076ed:	c3                   	ret    
801076ee:	66 90                	xchg   %ax,%ax
    return 0;
801076f0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801076f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801076fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076fd:	5b                   	pop    %ebx
801076fe:	5e                   	pop    %esi
801076ff:	5f                   	pop    %edi
80107700:	5d                   	pop    %ebp
80107701:	c3                   	ret    
80107702:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107708:	83 ec 0c             	sub    $0xc,%esp
8010770b:	68 61 8b 10 80       	push   $0x80108b61
80107710:	e8 9b 8f ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80107715:	8b 45 0c             	mov    0xc(%ebp),%eax
80107718:	83 c4 10             	add    $0x10,%esp
8010771b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010771e:	74 0c                	je     8010772c <allocuvm+0x10c>
80107720:	8b 55 10             	mov    0x10(%ebp),%edx
80107723:	89 c1                	mov    %eax,%ecx
80107725:	89 f8                	mov    %edi,%eax
80107727:	e8 d4 f9 ff ff       	call   80107100 <deallocuvm.part.0>
      cow_kfree(mem);
8010772c:	83 ec 0c             	sub    $0xc,%esp
8010772f:	53                   	push   %ebx
80107730:	e8 6b f7 ff ff       	call   80106ea0 <cow_kfree>
      return 0;
80107735:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010773c:	83 c4 10             	add    $0x10,%esp
}
8010773f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107742:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107745:	5b                   	pop    %ebx
80107746:	5e                   	pop    %esi
80107747:	5f                   	pop    %edi
80107748:	5d                   	pop    %ebp
80107749:	c3                   	ret    
8010774a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107750 <deallocuvm>:
{
80107750:	f3 0f 1e fb          	endbr32 
80107754:	55                   	push   %ebp
80107755:	89 e5                	mov    %esp,%ebp
80107757:	8b 55 0c             	mov    0xc(%ebp),%edx
8010775a:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010775d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107760:	39 d1                	cmp    %edx,%ecx
80107762:	73 0c                	jae    80107770 <deallocuvm+0x20>
}
80107764:	5d                   	pop    %ebp
80107765:	e9 96 f9 ff ff       	jmp    80107100 <deallocuvm.part.0>
8010776a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107770:	89 d0                	mov    %edx,%eax
80107772:	5d                   	pop    %ebp
80107773:	c3                   	ret    
80107774:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010777b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010777f:	90                   	nop

80107780 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107780:	f3 0f 1e fb          	endbr32 
80107784:	55                   	push   %ebp
80107785:	89 e5                	mov    %esp,%ebp
80107787:	57                   	push   %edi
80107788:	56                   	push   %esi
80107789:	53                   	push   %ebx
8010778a:	83 ec 0c             	sub    $0xc,%esp
8010778d:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;
  // struct proc* p = myproc();
  if(pgdir == 0)
80107790:	85 f6                	test   %esi,%esi
80107792:	74 55                	je     801077e9 <freevm+0x69>
  if(newsz >= oldsz)
80107794:	31 c9                	xor    %ecx,%ecx
80107796:	ba 00 00 00 80       	mov    $0x80000000,%edx
8010779b:	89 f0                	mov    %esi,%eax
8010779d:	89 f3                	mov    %esi,%ebx
8010779f:	e8 5c f9 ff ff       	call   80107100 <deallocuvm.part.0>
      p->ram_pages[i].swap_file_offset = p->swapped_out_pages[i].swap_file_offset = 0;
      p->ram_pages[i].va = p->swapped_out_pages[i].va = 0;
    }
  }
  #endif
  for(i = 0; i < NPDENTRIES; i++){
801077a4:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801077aa:	eb 0b                	jmp    801077b7 <freevm+0x37>
801077ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801077b0:	83 c3 04             	add    $0x4,%ebx
801077b3:	39 df                	cmp    %ebx,%edi
801077b5:	74 23                	je     801077da <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801077b7:	8b 03                	mov    (%ebx),%eax
801077b9:	a8 01                	test   $0x1,%al
801077bb:	74 f3                	je     801077b0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801077bd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
       cow_kfree(v);
801077c2:	83 ec 0c             	sub    $0xc,%esp
801077c5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801077c8:	05 00 00 00 80       	add    $0x80000000,%eax
       cow_kfree(v);
801077cd:	50                   	push   %eax
801077ce:	e8 cd f6 ff ff       	call   80106ea0 <cow_kfree>
801077d3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801077d6:	39 df                	cmp    %ebx,%edi
801077d8:	75 dd                	jne    801077b7 <freevm+0x37>
    }
  }
   cow_kfree((char*)pgdir);
801077da:	89 75 08             	mov    %esi,0x8(%ebp)
}
801077dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077e0:	5b                   	pop    %ebx
801077e1:	5e                   	pop    %esi
801077e2:	5f                   	pop    %edi
801077e3:	5d                   	pop    %ebp
   cow_kfree((char*)pgdir);
801077e4:	e9 b7 f6 ff ff       	jmp    80106ea0 <cow_kfree>
    panic("freevm: no pgdir");
801077e9:	83 ec 0c             	sub    $0xc,%esp
801077ec:	68 7d 8b 10 80       	push   $0x80108b7d
801077f1:	e8 9a 8b ff ff       	call   80100390 <panic>
801077f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077fd:	8d 76 00             	lea    0x0(%esi),%esi

80107800 <setupkvm>:
{
80107800:	f3 0f 1e fb          	endbr32 
80107804:	55                   	push   %ebp
80107805:	89 e5                	mov    %esp,%ebp
80107807:	56                   	push   %esi
80107808:	53                   	push   %ebx
  if((pgdir = (pde_t*)cow_kalloc()) == 0)
80107809:	e8 32 f7 ff ff       	call   80106f40 <cow_kalloc>
8010780e:	89 c6                	mov    %eax,%esi
80107810:	85 c0                	test   %eax,%eax
80107812:	74 42                	je     80107856 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80107814:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++){
80107817:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
8010781c:	68 00 10 00 00       	push   $0x1000
80107821:	6a 00                	push   $0x0
80107823:	50                   	push   %eax
80107824:	e8 a7 d3 ff ff       	call   80104bd0 <memset>
80107829:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
8010782c:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010782f:	83 ec 08             	sub    $0x8,%esp
80107832:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107835:	ff 73 0c             	pushl  0xc(%ebx)
80107838:	8b 13                	mov    (%ebx),%edx
8010783a:	50                   	push   %eax
8010783b:	29 c1                	sub    %eax,%ecx
8010783d:	89 f0                	mov    %esi,%eax
8010783f:	e8 2c f8 ff ff       	call   80107070 <mappages>
80107844:	83 c4 10             	add    $0x10,%esp
80107847:	85 c0                	test   %eax,%eax
80107849:	78 15                	js     80107860 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++){
8010784b:	83 c3 10             	add    $0x10,%ebx
8010784e:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107854:	75 d6                	jne    8010782c <setupkvm+0x2c>
}
80107856:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107859:	89 f0                	mov    %esi,%eax
8010785b:	5b                   	pop    %ebx
8010785c:	5e                   	pop    %esi
8010785d:	5d                   	pop    %ebp
8010785e:	c3                   	ret    
8010785f:	90                   	nop
      freevm(pgdir);
80107860:	83 ec 0c             	sub    $0xc,%esp
80107863:	56                   	push   %esi
      return 0;
80107864:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107866:	e8 15 ff ff ff       	call   80107780 <freevm>
      return 0;
8010786b:	83 c4 10             	add    $0x10,%esp
}
8010786e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107871:	89 f0                	mov    %esi,%eax
80107873:	5b                   	pop    %ebx
80107874:	5e                   	pop    %esi
80107875:	5d                   	pop    %ebp
80107876:	c3                   	ret    
80107877:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010787e:	66 90                	xchg   %ax,%ax

80107880 <kvmalloc>:
{
80107880:	f3 0f 1e fb          	endbr32 
80107884:	55                   	push   %ebp
80107885:	89 e5                	mov    %esp,%ebp
80107887:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010788a:	e8 71 ff ff ff       	call   80107800 <setupkvm>
8010788f:	a3 24 0a 13 80       	mov    %eax,0x80130a24
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107894:	05 00 00 00 80       	add    $0x80000000,%eax
80107899:	0f 22 d8             	mov    %eax,%cr3
}
8010789c:	c9                   	leave  
8010789d:	c3                   	ret    
8010789e:	66 90                	xchg   %ax,%ax

801078a0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801078a0:	f3 0f 1e fb          	endbr32 
801078a4:	55                   	push   %ebp
  pte_t *pte;
  pte = walkpgdir(pgdir, uva, 0);
801078a5:	31 c9                	xor    %ecx,%ecx
{
801078a7:	89 e5                	mov    %esp,%ebp
801078a9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801078ac:	8b 55 0c             	mov    0xc(%ebp),%edx
801078af:	8b 45 08             	mov    0x8(%ebp),%eax
801078b2:	e8 39 f7 ff ff       	call   80106ff0 <walkpgdir>
  if(pte == 0)
801078b7:	85 c0                	test   %eax,%eax
801078b9:	74 05                	je     801078c0 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
801078bb:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801078be:	c9                   	leave  
801078bf:	c3                   	ret    
    panic("clearpteu");
801078c0:	83 ec 0c             	sub    $0xc,%esp
801078c3:	68 8e 8b 10 80       	push   $0x80108b8e
801078c8:	e8 c3 8a ff ff       	call   80100390 <panic>
801078cd:	8d 76 00             	lea    0x0(%esi),%esi

801078d0 <cow_copyuvm>:

pde_t*
cow_copyuvm(pde_t *pgdir, uint sz)
{
801078d0:	f3 0f 1e fb          	endbr32 
801078d4:	55                   	push   %ebp
801078d5:	89 e5                	mov    %esp,%ebp
801078d7:	57                   	push   %edi
801078d8:	56                   	push   %esi
801078d9:	53                   	push   %ebx
801078da:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  if((d = setupkvm()) == 0)
801078dd:	e8 1e ff ff ff       	call   80107800 <setupkvm>
801078e2:	89 45 dc             	mov    %eax,-0x24(%ebp)
801078e5:	85 c0                	test   %eax,%eax
801078e7:	0f 84 eb 00 00 00    	je     801079d8 <cow_copyuvm+0x108>
    return 0;
  cprintf("cow : pages = %d\n", 57344 - sys_get_number_of_free_pages_impl());
801078ed:	e8 ee c6 ff ff       	call   80103fe0 <sys_get_number_of_free_pages_impl>
801078f2:	83 ec 08             	sub    $0x8,%esp
801078f5:	89 c2                	mov    %eax,%edx
801078f7:	b8 00 e0 00 00       	mov    $0xe000,%eax
801078fc:	29 d0                	sub    %edx,%eax
801078fe:	50                   	push   %eax
801078ff:	68 98 8b 10 80       	push   $0x80108b98
80107904:	e8 a7 8d ff ff       	call   801006b0 <cprintf>

  // cprintf("cow_copyuvm : pages = %d\n", 57344 - sys_get_number_of_free_pages_impl());
  for(i = 0; i < sz; i += PGSIZE){
80107909:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010790c:	83 c4 10             	add    $0x10,%esp
8010790f:	85 db                	test   %ebx,%ebx
80107911:	0f 84 c1 00 00 00    	je     801079d8 <cow_copyuvm+0x108>
80107917:	31 ff                	xor    %edi,%edi
80107919:	eb 1b                	jmp    80107936 <cow_copyuvm+0x66>
8010791b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010791f:	90                   	nop
      // cprintf("cow2");
      goto bad;
    }
    // cprintf("cow2");
    // update parents flags
    *pte |= (PTE_W & flags ? PTE_COW : 0);
80107920:	0b 1e                	or     (%esi),%ebx
  for(i = 0; i < sz; i += PGSIZE){
80107922:	81 c7 00 10 00 00    	add    $0x1000,%edi
    *pte &= (~PTE_W);
80107928:	83 e3 fd             	and    $0xfffffffd,%ebx
8010792b:	89 1e                	mov    %ebx,(%esi)
  for(i = 0; i < sz; i += PGSIZE){
8010792d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107930:	0f 86 a2 00 00 00    	jbe    801079d8 <cow_copyuvm+0x108>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107936:	8b 45 08             	mov    0x8(%ebp),%eax
80107939:	31 c9                	xor    %ecx,%ecx
8010793b:	89 fa                	mov    %edi,%edx
8010793d:	e8 ae f6 ff ff       	call   80106ff0 <walkpgdir>
80107942:	89 c6                	mov    %eax,%esi
80107944:	85 c0                	test   %eax,%eax
80107946:	0f 84 a4 00 00 00    	je     801079f0 <cow_copyuvm+0x120>
    if(!(*pte & PTE_P) && !(*pte & PTE_PG))
8010794c:	f7 00 01 02 00 00    	testl  $0x201,(%eax)
80107952:	0f 84 8b 00 00 00    	je     801079e3 <cow_copyuvm+0x113>
    acquire(cow_lock);
80107958:	83 ec 0c             	sub    $0xc,%esp
8010795b:	ff 35 40 ef 11 80    	pushl  0x8011ef40
80107961:	e8 5a d1 ff ff       	call   80104ac0 <acquire>
    pa = PTE_ADDR(*pte);
80107966:	8b 06                	mov    (%esi),%eax
    pg_ref_counts[PGROUNDDOWN(pa)/PGSIZE]++;
80107968:	89 45 e0             	mov    %eax,-0x20(%ebp)
    pa = PTE_ADDR(*pte);
8010796b:	89 c1                	mov    %eax,%ecx
    pg_ref_counts[PGROUNDDOWN(pa)/PGSIZE]++;
8010796d:	89 c2                	mov    %eax,%edx
    release(cow_lock);
8010796f:	58                   	pop    %eax
80107970:	ff 35 40 ef 11 80    	pushl  0x8011ef40
    pa = PTE_ADDR(*pte);
80107976:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
    pg_ref_counts[PGROUNDDOWN(pa)/PGSIZE]++;
8010797c:	c1 ea 0c             	shr    $0xc,%edx
8010797f:	80 82 40 0f 11 80 01 	addb   $0x1,-0x7feef0c0(%edx)
    pa = PTE_ADDR(*pte);
80107986:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    release(cow_lock);
80107989:	e8 f2 d1 ff ff       	call   80104b80 <release>
    if(mappages(d, (void*)i, PGSIZE, pa, (flags & (~PTE_W)) | (PTE_W & flags ? PTE_COW : 0)) < 0) {
8010798e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107991:	5a                   	pop    %edx
80107992:	89 fa                	mov    %edi,%edx
80107994:	59                   	pop    %ecx
80107995:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010799a:	89 c3                	mov    %eax,%ebx
8010799c:	25 fd 0f 00 00       	and    $0xffd,%eax
801079a1:	c1 e3 0a             	shl    $0xa,%ebx
801079a4:	81 e3 00 08 00 00    	and    $0x800,%ebx
801079aa:	09 d8                	or     %ebx,%eax
801079ac:	50                   	push   %eax
801079ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
801079b0:	ff 75 e4             	pushl  -0x1c(%ebp)
801079b3:	e8 b8 f6 ff ff       	call   80107070 <mappages>
801079b8:	83 c4 10             	add    $0x10,%esp
801079bb:	85 c0                	test   %eax,%eax
801079bd:	0f 89 5d ff ff ff    	jns    80107920 <cow_copyuvm+0x50>
  }
  return d;

bad:
  // release(cow_lock);
  freevm(d);
801079c3:	83 ec 0c             	sub    $0xc,%esp
801079c6:	ff 75 dc             	pushl  -0x24(%ebp)
801079c9:	e8 b2 fd ff ff       	call   80107780 <freevm>
  return 0;
801079ce:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
801079d5:	83 c4 10             	add    $0x10,%esp
}
801079d8:	8b 45 dc             	mov    -0x24(%ebp),%eax
801079db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801079de:	5b                   	pop    %ebx
801079df:	5e                   	pop    %esi
801079e0:	5f                   	pop    %edi
801079e1:	5d                   	pop    %ebp
801079e2:	c3                   	ret    
      panic("copyuvm: page not present");
801079e3:	83 ec 0c             	sub    $0xc,%esp
801079e6:	68 c4 8b 10 80       	push   $0x80108bc4
801079eb:	e8 a0 89 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
801079f0:	83 ec 0c             	sub    $0xc,%esp
801079f3:	68 aa 8b 10 80       	push   $0x80108baa
801079f8:	e8 93 89 ff ff       	call   80100390 <panic>
801079fd:	8d 76 00             	lea    0x0(%esi),%esi

80107a00 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107a00:	f3 0f 1e fb          	endbr32 
80107a04:	55                   	push   %ebp
80107a05:	89 e5                	mov    %esp,%ebp
80107a07:	57                   	push   %edi
80107a08:	56                   	push   %esi
80107a09:	53                   	push   %ebx
80107a0a:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107a0d:	e8 ee fd ff ff       	call   80107800 <setupkvm>
80107a12:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107a15:	85 c0                	test   %eax,%eax
80107a17:	0f 84 9e 00 00 00    	je     80107abb <copyuvm+0xbb>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107a1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107a20:	85 c9                	test   %ecx,%ecx
80107a22:	0f 84 93 00 00 00    	je     80107abb <copyuvm+0xbb>
80107a28:	31 f6                	xor    %esi,%esi
80107a2a:	eb 46                	jmp    80107a72 <copyuvm+0x72>
80107a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = cow_kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107a30:	83 ec 04             	sub    $0x4,%esp
80107a33:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107a39:	68 00 10 00 00       	push   $0x1000
80107a3e:	57                   	push   %edi
80107a3f:	50                   	push   %eax
80107a40:	e8 2b d2 ff ff       	call   80104c70 <memmove>
    // cprintf("copy1");
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107a45:	58                   	pop    %eax
80107a46:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107a4c:	5a                   	pop    %edx
80107a4d:	ff 75 e4             	pushl  -0x1c(%ebp)
80107a50:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107a55:	89 f2                	mov    %esi,%edx
80107a57:	50                   	push   %eax
80107a58:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107a5b:	e8 10 f6 ff ff       	call   80107070 <mappages>
80107a60:	83 c4 10             	add    $0x10,%esp
80107a63:	85 c0                	test   %eax,%eax
80107a65:	78 69                	js     80107ad0 <copyuvm+0xd0>
  for(i = 0; i < sz; i += PGSIZE){
80107a67:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107a6d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107a70:	76 49                	jbe    80107abb <copyuvm+0xbb>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107a72:	8b 45 08             	mov    0x8(%ebp),%eax
80107a75:	31 c9                	xor    %ecx,%ecx
80107a77:	89 f2                	mov    %esi,%edx
80107a79:	e8 72 f5 ff ff       	call   80106ff0 <walkpgdir>
80107a7e:	85 c0                	test   %eax,%eax
80107a80:	74 69                	je     80107aeb <copyuvm+0xeb>
    if(!(*pte & PTE_P) && !(*pte & PTE_PG))
80107a82:	8b 00                	mov    (%eax),%eax
80107a84:	a9 01 02 00 00       	test   $0x201,%eax
80107a89:	74 53                	je     80107ade <copyuvm+0xde>
    pa = PTE_ADDR(*pte);
80107a8b:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107a8d:	25 ff 0f 00 00       	and    $0xfff,%eax
80107a92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107a95:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = cow_kalloc()) == 0)
80107a9b:	e8 a0 f4 ff ff       	call   80106f40 <cow_kalloc>
80107aa0:	89 c3                	mov    %eax,%ebx
80107aa2:	85 c0                	test   %eax,%eax
80107aa4:	75 8a                	jne    80107a30 <copyuvm+0x30>
    // cprintf("copy2");
  }
  return d;

bad:
  freevm(d);
80107aa6:	83 ec 0c             	sub    $0xc,%esp
80107aa9:	ff 75 e0             	pushl  -0x20(%ebp)
80107aac:	e8 cf fc ff ff       	call   80107780 <freevm>
  return 0;
80107ab1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107ab8:	83 c4 10             	add    $0x10,%esp
}
80107abb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107abe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ac1:	5b                   	pop    %ebx
80107ac2:	5e                   	pop    %esi
80107ac3:	5f                   	pop    %edi
80107ac4:	5d                   	pop    %ebp
80107ac5:	c3                   	ret    
80107ac6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107acd:	8d 76 00             	lea    0x0(%esi),%esi
       cow_kfree(mem);
80107ad0:	83 ec 0c             	sub    $0xc,%esp
80107ad3:	53                   	push   %ebx
80107ad4:	e8 c7 f3 ff ff       	call   80106ea0 <cow_kfree>
      goto bad;
80107ad9:	83 c4 10             	add    $0x10,%esp
80107adc:	eb c8                	jmp    80107aa6 <copyuvm+0xa6>
      panic("copyuvm: page not present");
80107ade:	83 ec 0c             	sub    $0xc,%esp
80107ae1:	68 c4 8b 10 80       	push   $0x80108bc4
80107ae6:	e8 a5 88 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107aeb:	83 ec 0c             	sub    $0xc,%esp
80107aee:	68 aa 8b 10 80       	push   $0x80108baa
80107af3:	e8 98 88 ff ff       	call   80100390 <panic>
80107af8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107aff:	90                   	nop

80107b00 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107b00:	f3 0f 1e fb          	endbr32 
80107b04:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107b05:	31 c9                	xor    %ecx,%ecx
{
80107b07:	89 e5                	mov    %esp,%ebp
80107b09:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107b0c:	8b 55 0c             	mov    0xc(%ebp),%edx
80107b0f:	8b 45 08             	mov    0x8(%ebp),%eax
80107b12:	e8 d9 f4 ff ff       	call   80106ff0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107b17:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107b19:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107b1a:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107b1c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107b21:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107b24:	05 00 00 00 80       	add    $0x80000000,%eax
80107b29:	83 fa 05             	cmp    $0x5,%edx
80107b2c:	ba 00 00 00 00       	mov    $0x0,%edx
80107b31:	0f 45 c2             	cmovne %edx,%eax
}
80107b34:	c3                   	ret    
80107b35:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107b40 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107b40:	f3 0f 1e fb          	endbr32 
80107b44:	55                   	push   %ebp
80107b45:	89 e5                	mov    %esp,%ebp
80107b47:	57                   	push   %edi
80107b48:	56                   	push   %esi
80107b49:	53                   	push   %ebx
80107b4a:	83 ec 0c             	sub    $0xc,%esp
80107b4d:	8b 75 14             	mov    0x14(%ebp),%esi
80107b50:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107b53:	85 f6                	test   %esi,%esi
80107b55:	75 3c                	jne    80107b93 <copyout+0x53>
80107b57:	eb 67                	jmp    80107bc0 <copyout+0x80>
80107b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107b60:	8b 55 0c             	mov    0xc(%ebp),%edx
80107b63:	89 fb                	mov    %edi,%ebx
80107b65:	29 d3                	sub    %edx,%ebx
80107b67:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80107b6d:	39 f3                	cmp    %esi,%ebx
80107b6f:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107b72:	29 fa                	sub    %edi,%edx
80107b74:	83 ec 04             	sub    $0x4,%esp
80107b77:	01 c2                	add    %eax,%edx
80107b79:	53                   	push   %ebx
80107b7a:	ff 75 10             	pushl  0x10(%ebp)
80107b7d:	52                   	push   %edx
80107b7e:	e8 ed d0 ff ff       	call   80104c70 <memmove>
    len -= n;
    buf += n;
80107b83:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80107b86:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
80107b8c:	83 c4 10             	add    $0x10,%esp
80107b8f:	29 de                	sub    %ebx,%esi
80107b91:	74 2d                	je     80107bc0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80107b93:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107b95:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107b98:	89 55 0c             	mov    %edx,0xc(%ebp)
80107b9b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107ba1:	57                   	push   %edi
80107ba2:	ff 75 08             	pushl  0x8(%ebp)
80107ba5:	e8 56 ff ff ff       	call   80107b00 <uva2ka>
    if(pa0 == 0)
80107baa:	83 c4 10             	add    $0x10,%esp
80107bad:	85 c0                	test   %eax,%eax
80107baf:	75 af                	jne    80107b60 <copyout+0x20>
  }
  return 0;
}
80107bb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107bb4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107bb9:	5b                   	pop    %ebx
80107bba:	5e                   	pop    %esi
80107bbb:	5f                   	pop    %edi
80107bbc:	5d                   	pop    %ebp
80107bbd:	c3                   	ret    
80107bbe:	66 90                	xchg   %ax,%ax
80107bc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107bc3:	31 c0                	xor    %eax,%eax
}
80107bc5:	5b                   	pop    %ebx
80107bc6:	5e                   	pop    %esi
80107bc7:	5f                   	pop    %edi
80107bc8:	5d                   	pop    %ebp
80107bc9:	c3                   	ret    
80107bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107bd0 <swap_out>:


//  if buffer == 0 then we put buffer <-- kernel_va(page_to_swap->va)  // p2v(phiscal(va))
//  and use buffer to swap out from
//  we assume that if buffer is not 0, it is kernel virtual address
void swap_out(struct proc* p, struct pageinfo* page_to_swap, void* buffer, pde_t* pgdir){
80107bd0:	f3 0f 1e fb          	endbr32 
80107bd4:	55                   	push   %ebp
80107bd5:	89 e5                	mov    %esp,%ebp
80107bd7:	57                   	push   %edi
80107bd8:	56                   	push   %esi
80107bd9:	53                   	push   %ebx
80107bda:	83 ec 28             	sub    $0x28,%esp
80107bdd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  cprintf("SWAP OUT : ");
80107be0:	68 de 8b 10 80       	push   $0x80108bde
80107be5:	e8 c6 8a ff ff       	call   801006b0 <cprintf>
  // print_user_char(pgdir, page_to_swap->va);
  if (buffer == 0){
80107bea:	8b 75 10             	mov    0x10(%ebp),%esi
80107bed:	83 c4 10             	add    $0x10,%esp
80107bf0:	85 f6                	test   %esi,%esi
80107bf2:	0f 84 08 01 00 00    	je     80107d00 <swap_out+0x130>
  // swap page
  // INV  : cell swapped_out_pages[i] is free iff there isnt a page that is written in offset i * PGSIZE in the swap file
  int index;
  int found = 0;
  int count = 0;
  p->num_of_pages_in_swap_file++;
80107bf8:	8b 83 80 03 00 00    	mov    0x380(%ebx),%eax
  for (index = 0; index < MAX_PYSC_PAGES; index++){
80107bfe:	31 c9                	xor    %ecx,%ecx
  p->num_of_pages_in_swap_file++;
80107c00:	83 c0 01             	add    $0x1,%eax
80107c03:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107c06:	89 83 80 03 00 00    	mov    %eax,0x380(%ebx)
  for (index = 0; index < MAX_PYSC_PAGES; index++){
80107c0c:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
  p->num_of_pages_in_swap_file++;
80107c12:	89 c2                	mov    %eax,%edx
80107c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (p->swapped_out_pages[index].is_free){
80107c18:	8b 32                	mov    (%edx),%esi
80107c1a:	85 f6                	test   %esi,%esi
80107c1c:	0f 85 a6 00 00 00    	jne    80107cc8 <swap_out+0xf8>
  for (index = 0; index < MAX_PYSC_PAGES; index++){
80107c22:	83 c1 01             	add    $0x1,%ecx
80107c25:	83 c2 18             	add    $0x18,%edx
80107c28:	83 f9 10             	cmp    $0x10,%ecx
80107c2b:	75 eb                	jne    80107c18 <swap_out+0x48>
      p->swapped_out_pages[index].swap_file_offset = index * PGSIZE;
      found = 1;
      break;
    }
  }
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
80107c2d:	8d bb 00 02 00 00    	lea    0x200(%ebx),%edi
  int count = 0;
80107c33:	31 d2                	xor    %edx,%edx
80107c35:	8d 76 00             	lea    0x0(%esi),%esi
    if (!p->swapped_out_pages[i].is_free){
      count++;
80107c38:	83 38 01             	cmpl   $0x1,(%eax)
80107c3b:	83 d2 00             	adc    $0x0,%edx
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
80107c3e:	83 c0 18             	add    $0x18,%eax
80107c41:	39 c7                	cmp    %eax,%edi
80107c43:	75 f3                	jne    80107c38 <swap_out+0x68>
    }
  }
  if (!found){
80107c45:	85 f6                	test   %esi,%esi
80107c47:	0f 84 d7 00 00 00    	je     80107d24 <swap_out+0x154>
    cprintf("RAM count : %d , REAL RAM count : %d\n", p->num_of_pages_in_swap_file, count);
    panic("SWAP OUT BALAGAN\n");
  }
  if (index < 0 || index > 15){
80107c4d:	83 f9 10             	cmp    $0x10,%ecx
80107c50:	0f 84 f6 00 00 00    	je     80107d4c <swap_out+0x17c>
    panic("we have a bug\n");
  }
  int result = writeToSwapFile(p, buffer, index * PGSIZE, PGSIZE);
80107c56:	c1 e1 0c             	shl    $0xc,%ecx
80107c59:	68 00 10 00 00       	push   $0x1000
80107c5e:	51                   	push   %ecx
80107c5f:	ff 75 10             	pushl  0x10(%ebp)
80107c62:	53                   	push   %ebx
80107c63:	e8 b8 a7 ff ff       	call   80102420 <writeToSwapFile>


  
  // update flags in PTE
  pte_t* pte_ptr = walkpgdir(pgdir, page_to_swap->va, 0);
80107c68:	31 c9                	xor    %ecx,%ecx
  int result = writeToSwapFile(p, buffer, index * PGSIZE, PGSIZE);
80107c6a:	89 c6                	mov    %eax,%esi
  pte_t* pte_ptr = walkpgdir(pgdir, page_to_swap->va, 0);
80107c6c:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c6f:	8b 50 10             	mov    0x10(%eax),%edx
80107c72:	8b 45 14             	mov    0x14(%ebp),%eax
80107c75:	e8 76 f3 ff ff       	call   80106ff0 <walkpgdir>
  *pte_ptr |= PTE_PG;
  *pte_ptr &= ~PTE_P;
80107c7a:	8b 10                	mov    (%eax),%edx
80107c7c:	83 e2 fe             	and    $0xfffffffe,%edx
80107c7f:	80 ce 02             	or     $0x2,%dh
80107c82:	89 10                	mov    %edx,(%eax)
  // *pte_ptr |= PTE_U;
  cow_kfree(buffer);
80107c84:	58                   	pop    %eax
80107c85:	ff 75 10             	pushl  0x10(%ebp)
80107c88:	e8 13 f2 ff ff       	call   80106ea0 <cow_kfree>
  // refresh cr3
  lcr3(V2P(p->pgdir));
80107c8d:	8b 43 04             	mov    0x4(%ebx),%eax
80107c90:	05 00 00 00 80       	add    $0x80000000,%eax
80107c95:	0f 22 d8             	mov    %eax,%cr3
  page_to_swap->is_free = 1;
80107c98:	8b 45 0c             	mov    0xc(%ebp),%eax
  if (result < 0){
80107c9b:	83 c4 10             	add    $0x10,%esp
  page_to_swap->is_free = 1;
80107c9e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  if (result < 0){
80107ca4:	85 f6                	test   %esi,%esi
80107ca6:	0f 88 93 00 00 00    	js     80107d3f <swap_out+0x16f>
    panic("swap out failed\n");
  }
  p->num_of_pageOut_occured++;
80107cac:	83 83 8c 03 00 00 01 	addl   $0x1,0x38c(%ebx)
  p->num_of_actual_pages_in_mem--;
80107cb3:	83 ab 84 03 00 00 01 	subl   $0x1,0x384(%ebx)
}
80107cba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107cbd:	5b                   	pop    %ebx
80107cbe:	5e                   	pop    %esi
80107cbf:	5f                   	pop    %edi
80107cc0:	5d                   	pop    %ebp
80107cc1:	c3                   	ret    
80107cc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      p->swapped_out_pages[index].va = page_to_swap->va;
80107cc8:	8b 7d 0c             	mov    0xc(%ebp),%edi
      p->swapped_out_pages[index].is_free = 0;
80107ccb:	8d 14 49             	lea    (%ecx,%ecx,2),%edx
80107cce:	8d 14 d3             	lea    (%ebx,%edx,8),%edx
80107cd1:	c7 82 80 00 00 00 00 	movl   $0x0,0x80(%edx)
80107cd8:	00 00 00 
      p->swapped_out_pages[index].va = page_to_swap->va;
80107cdb:	8b 77 10             	mov    0x10(%edi),%esi
80107cde:	89 b2 90 00 00 00    	mov    %esi,0x90(%edx)
      p->swapped_out_pages[index].swap_file_offset = index * PGSIZE;
80107ce4:	89 ce                	mov    %ecx,%esi
80107ce6:	c1 e6 0c             	shl    $0xc,%esi
80107ce9:	89 b2 84 00 00 00    	mov    %esi,0x84(%edx)
      found = 1;
80107cef:	be 01 00 00 00       	mov    $0x1,%esi
      break;
80107cf4:	e9 34 ff ff ff       	jmp    80107c2d <swap_out+0x5d>
80107cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    buffer = P2V((PTE_ADDR(*(walkpgdir(pgdir, page_to_swap->va, 0)))));
80107d00:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d03:	31 c9                	xor    %ecx,%ecx
80107d05:	8b 50 10             	mov    0x10(%eax),%edx
80107d08:	8b 45 14             	mov    0x14(%ebp),%eax
80107d0b:	e8 e0 f2 ff ff       	call   80106ff0 <walkpgdir>
80107d10:	8b 00                	mov    (%eax),%eax
80107d12:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107d17:	05 00 00 00 80       	add    $0x80000000,%eax
80107d1c:	89 45 10             	mov    %eax,0x10(%ebp)
80107d1f:	e9 d4 fe ff ff       	jmp    80107bf8 <swap_out+0x28>
    cprintf("RAM count : %d , REAL RAM count : %d\n", p->num_of_pages_in_swap_file, count);
80107d24:	51                   	push   %ecx
80107d25:	52                   	push   %edx
80107d26:	ff 75 e4             	pushl  -0x1c(%ebp)
80107d29:	68 9c 8a 10 80       	push   $0x80108a9c
80107d2e:	e8 7d 89 ff ff       	call   801006b0 <cprintf>
    panic("SWAP OUT BALAGAN\n");
80107d33:	c7 04 24 ea 8b 10 80 	movl   $0x80108bea,(%esp)
80107d3a:	e8 51 86 ff ff       	call   80100390 <panic>
    panic("swap out failed\n");
80107d3f:	83 ec 0c             	sub    $0xc,%esp
80107d42:	68 0b 8c 10 80       	push   $0x80108c0b
80107d47:	e8 44 86 ff ff       	call   80100390 <panic>
    panic("we have a bug\n");
80107d4c:	83 ec 0c             	sub    $0xc,%esp
80107d4f:	68 fc 8b 10 80       	push   $0x80108bfc
80107d54:	e8 37 86 ff ff       	call   80100390 <panic>
80107d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107d60 <swap_in>:

// we assume there are at most MAX_PYSC_PAGES in the RAM 
int swap_in(struct proc* p, struct pageinfo* pi){
80107d60:	f3 0f 1e fb          	endbr32 
80107d64:	55                   	push   %ebp
80107d65:	89 e5                	mov    %esp,%ebp
80107d67:	57                   	push   %edi
80107d68:	56                   	push   %esi
80107d69:	53                   	push   %ebx
  // print_user_char(pgdir, pi->va);
  int found = 0;
  int index;
  int count = 0;
  // cprintf("SWAP IN: va = %d\n", pi->va);
  for (index = 0; index < MAX_PYSC_PAGES; index++){
80107d6a:	31 db                	xor    %ebx,%ebx
int swap_in(struct proc* p, struct pageinfo* pi){
80107d6c:	83 ec 28             	sub    $0x28,%esp
80107d6f:	8b 75 08             	mov    0x8(%ebp),%esi
  pde_t* pgdir = p->pgdir;
80107d72:	8b 46 04             	mov    0x4(%esi),%eax
80107d75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint offset = pi->swap_file_offset;
80107d78:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d7b:	8b 40 04             	mov    0x4(%eax),%eax
  cprintf("SWAP IN : ");
80107d7e:	68 1c 8c 10 80       	push   $0x80108c1c
  uint offset = pi->swap_file_offset;
80107d83:	89 45 e0             	mov    %eax,-0x20(%ebp)
  cprintf("SWAP IN : ");
80107d86:	e8 25 89 ff ff       	call   801006b0 <cprintf>
  for (index = 0; index < MAX_PYSC_PAGES; index++){
80107d8b:	8d 86 00 02 00 00    	lea    0x200(%esi),%eax
80107d91:	83 c4 10             	add    $0x10,%esp
  cprintf("SWAP IN : ");
80107d94:	89 c2                	mov    %eax,%edx
80107d96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d9d:	8d 76 00             	lea    0x0(%esi),%esi
    if (p->ram_pages[index].is_free){
80107da0:	8b 0a                	mov    (%edx),%ecx
80107da2:	85 c9                	test   %ecx,%ecx
80107da4:	0f 85 e6 00 00 00    	jne    80107e90 <swap_in+0x130>
  for (index = 0; index < MAX_PYSC_PAGES; index++){
80107daa:	83 c3 01             	add    $0x1,%ebx
80107dad:	83 c2 18             	add    $0x18,%edx
80107db0:	83 fb 10             	cmp    $0x10,%ebx
80107db3:	75 eb                	jne    80107da0 <swap_in+0x40>
      found = 1;
      p->ram_pages[index].is_free = 0;
      break;
    }
  }
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
80107db5:	8d be 80 03 00 00    	lea    0x380(%esi),%edi
  int count = 0;
80107dbb:	31 d2                	xor    %edx,%edx
80107dbd:	8d 76 00             	lea    0x0(%esi),%esi
    if (!p->ram_pages[i].is_free){
      count++;
80107dc0:	83 38 01             	cmpl   $0x1,(%eax)
80107dc3:	83 d2 00             	adc    $0x0,%edx
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
80107dc6:	83 c0 18             	add    $0x18,%eax
80107dc9:	39 c7                	cmp    %eax,%edi
80107dcb:	75 f3                	jne    80107dc0 <swap_in+0x60>
    }
  }
  if (!found){
80107dcd:	85 c9                	test   %ecx,%ecx
80107dcf:	0f 84 f7 00 00 00    	je     80107ecc <swap_in+0x16c>
    cprintf("RAM count : %d , REAL RAM count : %d\n", p->num_of_actual_pages_in_mem, count);
    panic("SWAP IN BALAGAN\n");
  }
  void* mem = cow_kalloc();
80107dd5:	e8 66 f1 ff ff       	call   80106f40 <cow_kalloc>
80107dda:	89 c7                	mov    %eax,%edi
  // mem = cow_kalloc();
  if(mem == 0){
80107ddc:	85 c0                	test   %eax,%eax
80107dde:	0f 84 c4 00 00 00    	je     80107ea8 <swap_in+0x148>
    cprintf("swap in - out of memory\n");
    // deallocuvm(pgdir, newsz, oldsz);
    return -1;
  }

  void* va = pi->va;
80107de4:	8b 45 0c             	mov    0xc(%ebp),%eax
  pte_t* pte_ptr = walkpgdir(pgdir, va, 0);
80107de7:	31 c9                	xor    %ecx,%ecx
  void* va = pi->va;
80107de9:	8b 40 10             	mov    0x10(%eax),%eax
  pte_t* pte_ptr = walkpgdir(pgdir, va, 0);
80107dec:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107def:	89 c2                	mov    %eax,%edx
80107df1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107df4:	e8 f7 f1 ff ff       	call   80106ff0 <walkpgdir>
  *pte_ptr &= ~PTE_PG;
  *pte_ptr |= (PTE_P | PTE_U | PTE_W);

  // updating physical address written in the page table entry
  *pte_ptr = PTE_FLAGS(*pte_ptr);
  *pte_ptr |= PTE_ADDR(V2P(mem));
80107df9:	8d 97 00 00 00 80    	lea    -0x80000000(%edi),%edx
80107dff:	8b 08                	mov    (%eax),%ecx
80107e01:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107e07:	81 e1 ff 0d 00 00    	and    $0xdff,%ecx
80107e0d:	09 ca                	or     %ecx,%edx
80107e0f:	83 ca 07             	or     $0x7,%edx
80107e12:	89 10                	mov    %edx,(%eax)

  p->ram_pages[index].page_index = ++page_counter;
80107e14:	8b 0d c0 b5 10 80    	mov    0x8010b5c0,%ecx
80107e1a:	8d 14 5b             	lea    (%ebx,%ebx,2),%edx
80107e1d:	8d 14 d6             	lea    (%esi,%edx,8),%edx
80107e20:	8d 41 01             	lea    0x1(%ecx),%eax
80107e23:	89 82 0c 02 00 00    	mov    %eax,0x20c(%edx)
80107e29:	a3 c0 b5 10 80       	mov    %eax,0x8010b5c0
  p->ram_pages[index].va = va;
80107e2e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80107e31:	89 82 10 02 00 00    	mov    %eax,0x210(%edx)
  int result = readFromSwapFile(p, mem, offset, PGSIZE);
80107e37:	68 00 10 00 00       	push   $0x1000
80107e3c:	ff 75 e0             	pushl  -0x20(%ebp)
80107e3f:	57                   	push   %edi
80107e40:	56                   	push   %esi
80107e41:	e8 0a a6 ff ff       	call   80102450 <readFromSwapFile>

  // clean the struct
  pi->is_free = 1;
80107e46:	8b 7d 0c             	mov    0xc(%ebp),%edi
80107e49:	c7 07 01 00 00 00    	movl   $0x1,(%edi)
  pi->va = 0;
80107e4f:	c7 47 10 00 00 00 00 	movl   $0x0,0x10(%edi)
  pi->swap_file_offset = 0;
80107e56:	c7 47 04 00 00 00 00 	movl   $0x0,0x4(%edi)

  // refresh rc3
  lcr3(V2P(p->pgdir));
80107e5d:	8b 7e 04             	mov    0x4(%esi),%edi
80107e60:	8d 97 00 00 00 80    	lea    -0x80000000(%edi),%edx
80107e66:	0f 22 da             	mov    %edx,%cr3

  p->num_of_actual_pages_in_mem++;
80107e69:	83 86 84 03 00 00 01 	addl   $0x1,0x384(%esi)
  p->num_of_pages_in_swap_file--;

  if (result < 0){
80107e70:	83 c4 10             	add    $0x10,%esp
  p->num_of_pages_in_swap_file--;
80107e73:	83 ae 80 03 00 00 01 	subl   $0x1,0x380(%esi)
  if (result < 0){
80107e7a:	85 c0                	test   %eax,%eax
80107e7c:	78 41                	js     80107ebf <swap_in+0x15f>
    panic("swap in failed");
  }
  return result;
}
80107e7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107e81:	5b                   	pop    %ebx
80107e82:	5e                   	pop    %esi
80107e83:	5f                   	pop    %edi
80107e84:	5d                   	pop    %ebp
80107e85:	c3                   	ret    
80107e86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107e8d:	8d 76 00             	lea    0x0(%esi),%esi
      p->ram_pages[index].is_free = 0;
80107e90:	8d 14 5b             	lea    (%ebx,%ebx,2),%edx
      found = 1;
80107e93:	b9 01 00 00 00       	mov    $0x1,%ecx
      p->ram_pages[index].is_free = 0;
80107e98:	c7 84 d6 00 02 00 00 	movl   $0x0,0x200(%esi,%edx,8)
80107e9f:	00 00 00 00 
      break;
80107ea3:	e9 0d ff ff ff       	jmp    80107db5 <swap_in+0x55>
    cprintf("swap in - out of memory\n");
80107ea8:	83 ec 0c             	sub    $0xc,%esp
80107eab:	68 38 8c 10 80       	push   $0x80108c38
80107eb0:	e8 fb 87 ff ff       	call   801006b0 <cprintf>
    return -1;
80107eb5:	83 c4 10             	add    $0x10,%esp
80107eb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107ebd:	eb bf                	jmp    80107e7e <swap_in+0x11e>
    panic("swap in failed");
80107ebf:	83 ec 0c             	sub    $0xc,%esp
80107ec2:	68 51 8c 10 80       	push   $0x80108c51
80107ec7:	e8 c4 84 ff ff       	call   80100390 <panic>
    cprintf("RAM count : %d , REAL RAM count : %d\n", p->num_of_actual_pages_in_mem, count);
80107ecc:	50                   	push   %eax
80107ecd:	52                   	push   %edx
80107ece:	ff b6 84 03 00 00    	pushl  0x384(%esi)
80107ed4:	68 9c 8a 10 80       	push   $0x80108a9c
80107ed9:	e8 d2 87 ff ff       	call   801006b0 <cprintf>
    panic("SWAP IN BALAGAN\n");
80107ede:	c7 04 24 27 8c 10 80 	movl   $0x80108c27,(%esp)
80107ee5:	e8 a6 84 ff ff       	call   80100390 <panic>
80107eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107ef0 <swap_page_back>:
 * 3. ram not full - swap in
 * 
 * 
 * */

void swap_page_back(struct proc* p, struct pageinfo* pi_to_swapin){
80107ef0:	f3 0f 1e fb          	endbr32 
80107ef4:	55                   	push   %ebp
80107ef5:	89 e5                	mov    %esp,%ebp
80107ef7:	57                   	push   %edi
80107ef8:	56                   	push   %esi
80107ef9:	53                   	push   %ebx
80107efa:	83 ec 2c             	sub    $0x2c,%esp
80107efd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  //   if (!p->swapped_out_pages[i].is_free){
  //     swap++;
  //   }
  // }
  // cprintf("RAM: %d SWAP: %d\n", ram, swap);
  if (p->num_of_actual_pages_in_mem == MAX_PYSC_PAGES && p->num_of_pages_in_swap_file == MAX_PYSC_PAGES){
80107f00:	83 bb 84 03 00 00 10 	cmpl   $0x10,0x384(%ebx)
80107f07:	74 17                	je     80107f20 <swap_page_back+0x30>
    // cprintf("swap page back 2\n");
    swap_out(p, page_to_swap, 0, p->pgdir);
    swap_in(p, pi_to_swapin);
  }
  else{
    swap_in(p, pi_to_swapin);
80107f09:	83 ec 08             	sub    $0x8,%esp
80107f0c:	ff 75 0c             	pushl  0xc(%ebp)
80107f0f:	53                   	push   %ebx
80107f10:	e8 4b fe ff ff       	call   80107d60 <swap_in>
80107f15:	83 c4 10             	add    $0x10,%esp
  }
}
80107f18:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f1b:	5b                   	pop    %ebx
80107f1c:	5e                   	pop    %esi
80107f1d:	5f                   	pop    %edi
80107f1e:	5d                   	pop    %ebp
80107f1f:	c3                   	ret    
  if (p->num_of_actual_pages_in_mem == MAX_PYSC_PAGES && p->num_of_pages_in_swap_file == MAX_PYSC_PAGES){
80107f20:	8b 83 80 03 00 00    	mov    0x380(%ebx),%eax
80107f26:	83 f8 10             	cmp    $0x10,%eax
80107f29:	74 35                	je     80107f60 <swap_page_back+0x70>
  else if (p->num_of_actual_pages_in_mem == MAX_PYSC_PAGES && p->num_of_pages_in_swap_file < MAX_PYSC_PAGES){
80107f2b:	83 f8 0f             	cmp    $0xf,%eax
80107f2e:	77 d9                	ja     80107f09 <swap_page_back+0x19>
    struct pageinfo* page_to_swap = find_page_to_swap(p, p->pgdir);
80107f30:	83 ec 08             	sub    $0x8,%esp
80107f33:	ff 73 04             	pushl  0x4(%ebx)
80107f36:	53                   	push   %ebx
80107f37:	e8 74 f2 ff ff       	call   801071b0 <find_page_to_swap>
    swap_out(p, page_to_swap, 0, p->pgdir);
80107f3c:	ff 73 04             	pushl  0x4(%ebx)
80107f3f:	6a 00                	push   $0x0
80107f41:	50                   	push   %eax
80107f42:	53                   	push   %ebx
80107f43:	e8 88 fc ff ff       	call   80107bd0 <swap_out>
    swap_in(p, pi_to_swapin);
80107f48:	83 c4 18             	add    $0x18,%esp
80107f4b:	ff 75 0c             	pushl  0xc(%ebp)
80107f4e:	53                   	push   %ebx
80107f4f:	e8 0c fe ff ff       	call   80107d60 <swap_in>
  else if (p->num_of_actual_pages_in_mem == MAX_PYSC_PAGES && p->num_of_pages_in_swap_file < MAX_PYSC_PAGES){
80107f54:	83 c4 10             	add    $0x10,%esp
}
80107f57:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f5a:	5b                   	pop    %ebx
80107f5b:	5e                   	pop    %esi
80107f5c:	5f                   	pop    %edi
80107f5d:	5d                   	pop    %ebp
80107f5e:	c3                   	ret    
80107f5f:	90                   	nop
    char* buffer = cow_kalloc();
80107f60:	e8 db ef ff ff       	call   80106f40 <cow_kalloc>
    struct pageinfo* page_to_swap = find_page_to_swap(p, p->pgdir);
80107f65:	83 ec 08             	sub    $0x8,%esp
80107f68:	ff 73 04             	pushl  0x4(%ebx)
80107f6b:	53                   	push   %ebx
    char* buffer = cow_kalloc();
80107f6c:	89 c7                	mov    %eax,%edi
    struct pageinfo* page_to_swap = find_page_to_swap(p, p->pgdir);
80107f6e:	e8 3d f2 ff ff       	call   801071b0 <find_page_to_swap>
    memmove(buffer, page_to_swap->va, PGSIZE);
80107f73:	83 c4 0c             	add    $0xc,%esp
80107f76:	68 00 10 00 00       	push   $0x1000
    struct pageinfo* page_to_swap = find_page_to_swap(p, p->pgdir);
80107f7b:	89 c6                	mov    %eax,%esi
    memmove(buffer, page_to_swap->va, PGSIZE);
80107f7d:	ff 70 10             	pushl  0x10(%eax)
80107f80:	57                   	push   %edi
80107f81:	e8 ea cc ff ff       	call   80104c70 <memmove>
    pi = *page_to_swap;
80107f86:	8b 06                	mov    (%esi),%eax
80107f88:	89 45 d0             	mov    %eax,-0x30(%ebp)
80107f8b:	8b 46 04             	mov    0x4(%esi),%eax
80107f8e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80107f91:	8b 46 08             	mov    0x8(%esi),%eax
80107f94:	89 45 d8             	mov    %eax,-0x28(%ebp)
80107f97:	8b 46 0c             	mov    0xc(%esi),%eax
80107f9a:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107f9d:	8b 46 10             	mov    0x10(%esi),%eax
80107fa0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107fa3:	8b 46 14             	mov    0x14(%esi),%eax
80107fa6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    page_to_swap->is_free = 1;
80107fa9:	c7 06 01 00 00 00    	movl   $0x1,(%esi)
    p->num_of_actual_pages_in_mem--;
80107faf:	83 ab 84 03 00 00 01 	subl   $0x1,0x384(%ebx)
    swap_in(p, page_to_swap);
80107fb6:	58                   	pop    %eax
80107fb7:	5a                   	pop    %edx
80107fb8:	56                   	push   %esi
80107fb9:	53                   	push   %ebx
80107fba:	e8 a1 fd ff ff       	call   80107d60 <swap_in>
    swap_out(p, &pi, buffer, p->pgdir);
80107fbf:	8d 45 d0             	lea    -0x30(%ebp),%eax
80107fc2:	ff 73 04             	pushl  0x4(%ebx)
80107fc5:	57                   	push   %edi
80107fc6:	50                   	push   %eax
80107fc7:	53                   	push   %ebx
80107fc8:	e8 03 fc ff ff       	call   80107bd0 <swap_out>
  if (p->num_of_actual_pages_in_mem == MAX_PYSC_PAGES && p->num_of_pages_in_swap_file == MAX_PYSC_PAGES){
80107fcd:	83 c4 20             	add    $0x20,%esp
80107fd0:	e9 43 ff ff ff       	jmp    80107f18 <swap_page_back+0x28>
80107fd5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107fe0 <copy_page>:

int copy_page(pde_t* pgdir, pte_t* pte_ptr){
80107fe0:	f3 0f 1e fb          	endbr32 
80107fe4:	55                   	push   %ebp
80107fe5:	89 e5                	mov    %esp,%ebp
80107fe7:	57                   	push   %edi
80107fe8:	56                   	push   %esi
80107fe9:	53                   	push   %ebx
80107fea:	83 ec 0c             	sub    $0xc,%esp
80107fed:	8b 7d 0c             	mov    0xc(%ebp),%edi
  uint pa = PTE_ADDR(*pte_ptr);
80107ff0:	8b 37                	mov    (%edi),%esi
80107ff2:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  char* mem = cow_kalloc();
80107ff8:	e8 43 ef ff ff       	call   80106f40 <cow_kalloc>
  if (mem == 0){
80107ffd:	85 c0                	test   %eax,%eax
80107fff:	74 35                	je     80108036 <copy_page+0x56>
    return -1;
  }
  memmove(mem, P2V(pa), PGSIZE);
80108001:	83 ec 04             	sub    $0x4,%esp
80108004:	89 c3                	mov    %eax,%ebx
80108006:	81 c6 00 00 00 80    	add    $0x80000000,%esi
8010800c:	68 00 10 00 00       	push   $0x1000
  *pte_ptr = PTE_ADDR(V2P(mem)) | PTE_U | PTE_W | PTE_P;
80108011:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
  memmove(mem, P2V(pa), PGSIZE);
80108017:	56                   	push   %esi
  *pte_ptr = PTE_ADDR(V2P(mem)) | PTE_U | PTE_W | PTE_P;
80108018:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  memmove(mem, P2V(pa), PGSIZE);
8010801e:	50                   	push   %eax
  *pte_ptr = PTE_ADDR(V2P(mem)) | PTE_U | PTE_W | PTE_P;
8010801f:	83 cb 07             	or     $0x7,%ebx
  memmove(mem, P2V(pa), PGSIZE);
80108022:	e8 49 cc ff ff       	call   80104c70 <memmove>
  *pte_ptr = PTE_ADDR(V2P(mem)) | PTE_U | PTE_W | PTE_P;
80108027:	89 1f                	mov    %ebx,(%edi)
  return 0;
80108029:	83 c4 10             	add    $0x10,%esp
8010802c:	31 c0                	xor    %eax,%eax
}
8010802e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108031:	5b                   	pop    %ebx
80108032:	5e                   	pop    %esi
80108033:	5f                   	pop    %edi
80108034:	5d                   	pop    %ebp
80108035:	c3                   	ret    
    return -1;
80108036:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010803b:	eb f1                	jmp    8010802e <copy_page+0x4e>
