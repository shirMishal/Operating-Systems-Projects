
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
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
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
80100028:	bc d0 d5 10 80       	mov    $0x8010d5d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 10 38 10 80       	mov    $0x80103810,%eax
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
80100048:	bb 14 d6 10 80       	mov    $0x8010d614,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 60 87 10 80       	push   $0x80108760
80100055:	68 e0 d5 10 80       	push   $0x8010d5e0
8010005a:	e8 91 4e 00 00       	call   80104ef0 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 dc 1c 11 80       	mov    $0x80111cdc,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 2c 1d 11 80 dc 	movl   $0x80111cdc,0x80111d2c
8010006e:	1c 11 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 30 1d 11 80 dc 	movl   $0x80111cdc,0x80111d30
80100078:	1c 11 80 
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
8010008b:	c7 43 50 dc 1c 11 80 	movl   $0x80111cdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 67 87 10 80       	push   $0x80108767
80100097:	50                   	push   %eax
80100098:	e8 13 4d 00 00       	call   80104db0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 30 1d 11 80       	mov    0x80111d30,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 30 1d 11 80    	mov    %ebx,0x80111d30
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb 80 1a 11 80    	cmp    $0x80111a80,%ebx
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
801000e3:	68 e0 d5 10 80       	push   $0x8010d5e0
801000e8:	e8 83 4f 00 00       	call   80105070 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 30 1d 11 80    	mov    0x80111d30,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb dc 1c 11 80    	cmp    $0x80111cdc,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc 1c 11 80    	cmp    $0x80111cdc,%ebx
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
80100120:	8b 1d 2c 1d 11 80    	mov    0x80111d2c,%ebx
80100126:	81 fb dc 1c 11 80    	cmp    $0x80111cdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc 1c 11 80    	cmp    $0x80111cdc,%ebx
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
8010015d:	68 e0 d5 10 80       	push   $0x8010d5e0
80100162:	e8 c9 4f 00 00       	call   80105130 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 7e 4c 00 00       	call   80104df0 <acquiresleep>
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
801001a3:	68 6e 87 10 80       	push   $0x8010876e
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
801001c2:	e8 c9 4c 00 00       	call   80104e90 <holdingsleep>
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
801001e0:	68 7f 87 10 80       	push   $0x8010877f
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
80100203:	e8 88 4c 00 00       	call   80104e90 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 38 4c 00 00       	call   80104e50 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 e0 d5 10 80 	movl   $0x8010d5e0,(%esp)
8010021f:	e8 4c 4e 00 00       	call   80105070 <acquire>
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
80100246:	a1 30 1d 11 80       	mov    0x80111d30,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 dc 1c 11 80 	movl   $0x80111cdc,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 30 1d 11 80       	mov    0x80111d30,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 30 1d 11 80    	mov    %ebx,0x80111d30
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 e0 d5 10 80 	movl   $0x8010d5e0,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 bb 4e 00 00       	jmp    80105130 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 86 87 10 80       	push   $0x80108786
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
801002aa:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
801002b1:	e8 ba 4d 00 00       	call   80105070 <acquire>
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
801002c6:	a1 e0 ff 11 80       	mov    0x8011ffe0,%eax
801002cb:	3b 05 e4 ff 11 80    	cmp    0x8011ffe4,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 20 c5 10 80       	push   $0x8010c520
801002e0:	68 e0 ff 11 80       	push   $0x8011ffe0
801002e5:	e8 76 46 00 00       	call   80104960 <sleep>
    while(input.r == input.w){
801002ea:	a1 e0 ff 11 80       	mov    0x8011ffe0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 e4 ff 11 80    	cmp    0x8011ffe4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 c1 3e 00 00       	call   801041c0 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 c5 10 80       	push   $0x8010c520
8010030e:	e8 1d 4e 00 00       	call   80105130 <release>
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
80100333:	89 15 e0 ff 11 80    	mov    %edx,0x8011ffe0
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 60 ff 11 80 	movsbl -0x7fee00a0(%edx),%ecx
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
80100360:	68 20 c5 10 80       	push   $0x8010c520
80100365:	e8 c6 4d 00 00       	call   80105130 <release>
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
80100386:	a3 e0 ff 11 80       	mov    %eax,0x8011ffe0
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
8010039d:	c7 05 54 c5 10 80 00 	movl   $0x0,0x8010c554
801003a4:	00 00 00 
  getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 be 2c 00 00       	call   80103070 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 8d 87 10 80       	push   $0x8010878d
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 2e 93 10 80 	movl   $0x8010932e,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 2f 4b 00 00       	call   80104f10 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 a1 87 10 80       	push   $0x801087a1
801003f1:	e8 ba 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003f6:	83 c4 10             	add    $0x10,%esp
801003f9:	39 f3                	cmp    %esi,%ebx
801003fb:	75 e7                	jne    801003e4 <panic+0x54>
  panicked = 1; // freeze other CPU
801003fd:	c7 05 58 c5 10 80 01 	movl   $0x1,0x8010c558
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
8010042a:	e8 61 65 00 00       	call   80106990 <uartputc>
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
80100515:	e8 76 64 00 00       	call   80106990 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 6a 64 00 00       	call   80106990 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 5e 64 00 00       	call   80106990 <uartputc>
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
80100561:	e8 ba 4c 00 00       	call   80105220 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 05 4c 00 00       	call   80105180 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 a5 87 10 80       	push   $0x801087a5
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
801005c9:	0f b6 92 d0 87 10 80 	movzbl -0x7fef7830(%edx),%edx
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
80100603:	8b 15 58 c5 10 80    	mov    0x8010c558,%edx
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
80100658:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010065f:	e8 0c 4a 00 00       	call   80105070 <acquire>
  for(i = 0; i < n; i++)
80100664:	83 c4 10             	add    $0x10,%esp
80100667:	85 db                	test   %ebx,%ebx
80100669:	7e 24                	jle    8010068f <consolewrite+0x4f>
8010066b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010066e:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
80100671:	8b 15 58 c5 10 80    	mov    0x8010c558,%edx
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
80100692:	68 20 c5 10 80       	push   $0x8010c520
80100697:	e8 94 4a 00 00       	call   80105130 <release>
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
801006bd:	a1 54 c5 10 80       	mov    0x8010c554,%eax
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
801006ec:	8b 0d 58 c5 10 80    	mov    0x8010c558,%ecx
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
8010077d:	bb b8 87 10 80       	mov    $0x801087b8,%ebx
      for(; *s; s++)
80100782:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
80100787:	8b 15 58 c5 10 80    	mov    0x8010c558,%edx
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
801007b8:	68 20 c5 10 80       	push   $0x8010c520
801007bd:	e8 ae 48 00 00       	call   80105070 <acquire>
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
801007e0:	8b 3d 58 c5 10 80    	mov    0x8010c558,%edi
801007e6:	85 ff                	test   %edi,%edi
801007e8:	0f 84 12 ff ff ff    	je     80100700 <cprintf+0x50>
801007ee:	fa                   	cli    
    for(;;)
801007ef:	eb fe                	jmp    801007ef <cprintf+0x13f>
801007f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801007f8:	8b 0d 58 c5 10 80    	mov    0x8010c558,%ecx
801007fe:	85 c9                	test   %ecx,%ecx
80100800:	74 06                	je     80100808 <cprintf+0x158>
80100802:	fa                   	cli    
    for(;;)
80100803:	eb fe                	jmp    80100803 <cprintf+0x153>
80100805:	8d 76 00             	lea    0x0(%esi),%esi
80100808:	b8 25 00 00 00       	mov    $0x25,%eax
8010080d:	e8 fe fb ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100812:	8b 15 58 c5 10 80    	mov    0x8010c558,%edx
80100818:	85 d2                	test   %edx,%edx
8010081a:	74 2c                	je     80100848 <cprintf+0x198>
8010081c:	fa                   	cli    
    for(;;)
8010081d:	eb fe                	jmp    8010081d <cprintf+0x16d>
8010081f:	90                   	nop
    release(&cons.lock);
80100820:	83 ec 0c             	sub    $0xc,%esp
80100823:	68 20 c5 10 80       	push   $0x8010c520
80100828:	e8 03 49 00 00       	call   80105130 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 bf 87 10 80       	push   $0x801087bf
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
80100872:	68 20 c5 10 80       	push   $0x8010c520
80100877:	e8 f4 47 00 00       	call   80105070 <acquire>
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
801008b4:	a1 e8 ff 11 80       	mov    0x8011ffe8,%eax
801008b9:	89 c2                	mov    %eax,%edx
801008bb:	2b 15 e0 ff 11 80    	sub    0x8011ffe0,%edx
801008c1:	83 fa 7f             	cmp    $0x7f,%edx
801008c4:	77 d2                	ja     80100898 <consoleintr+0x38>
        c = (c == '\r') ? '\n' : c;
801008c6:	8d 48 01             	lea    0x1(%eax),%ecx
801008c9:	8b 15 58 c5 10 80    	mov    0x8010c558,%edx
801008cf:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
801008d2:	89 0d e8 ff 11 80    	mov    %ecx,0x8011ffe8
        c = (c == '\r') ? '\n' : c;
801008d8:	83 fb 0d             	cmp    $0xd,%ebx
801008db:	0f 84 02 01 00 00    	je     801009e3 <consoleintr+0x183>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e1:	88 98 60 ff 11 80    	mov    %bl,-0x7fee00a0(%eax)
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
80100908:	a1 e0 ff 11 80       	mov    0x8011ffe0,%eax
8010090d:	83 e8 80             	sub    $0xffffff80,%eax
80100910:	39 05 e8 ff 11 80    	cmp    %eax,0x8011ffe8
80100916:	75 80                	jne    80100898 <consoleintr+0x38>
80100918:	e9 f6 00 00 00       	jmp    80100a13 <consoleintr+0x1b3>
8010091d:	8d 76 00             	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100920:	a1 e8 ff 11 80       	mov    0x8011ffe8,%eax
80100925:	39 05 e4 ff 11 80    	cmp    %eax,0x8011ffe4
8010092b:	0f 84 67 ff ff ff    	je     80100898 <consoleintr+0x38>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100931:	83 e8 01             	sub    $0x1,%eax
80100934:	89 c2                	mov    %eax,%edx
80100936:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100939:	80 ba 60 ff 11 80 0a 	cmpb   $0xa,-0x7fee00a0(%edx)
80100940:	0f 84 52 ff ff ff    	je     80100898 <consoleintr+0x38>
  if(panicked){
80100946:	8b 15 58 c5 10 80    	mov    0x8010c558,%edx
        input.e--;
8010094c:	a3 e8 ff 11 80       	mov    %eax,0x8011ffe8
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
8010096a:	a1 e8 ff 11 80       	mov    0x8011ffe8,%eax
8010096f:	3b 05 e4 ff 11 80    	cmp    0x8011ffe4,%eax
80100975:	75 ba                	jne    80100931 <consoleintr+0xd1>
80100977:	e9 1c ff ff ff       	jmp    80100898 <consoleintr+0x38>
8010097c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(input.e != input.w){
80100980:	a1 e8 ff 11 80       	mov    0x8011ffe8,%eax
80100985:	3b 05 e4 ff 11 80    	cmp    0x8011ffe4,%eax
8010098b:	0f 84 07 ff ff ff    	je     80100898 <consoleintr+0x38>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 e8 ff 11 80       	mov    %eax,0x8011ffe8
  if(panicked){
80100999:	a1 58 c5 10 80       	mov    0x8010c558,%eax
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
801009ca:	68 20 c5 10 80       	push   $0x8010c520
801009cf:	e8 5c 47 00 00       	call   80105130 <release>
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
801009e3:	c6 80 60 ff 11 80 0a 	movb   $0xa,-0x7fee00a0(%eax)
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
801009ff:	e9 bc 42 00 00       	jmp    80104cc0 <procdump>
80100a04:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a09:	e8 02 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100a0e:	a1 e8 ff 11 80       	mov    0x8011ffe8,%eax
          wakeup(&input.r);
80100a13:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a16:	a3 e4 ff 11 80       	mov    %eax,0x8011ffe4
          wakeup(&input.r);
80100a1b:	68 e0 ff 11 80       	push   $0x8011ffe0
80100a20:	e8 9b 41 00 00       	call   80104bc0 <wakeup>
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
80100a3a:	68 c8 87 10 80       	push   $0x801087c8
80100a3f:	68 20 c5 10 80       	push   $0x8010c520
80100a44:	e8 a7 44 00 00       	call   80104ef0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a49:	58                   	pop    %eax
80100a4a:	5a                   	pop    %edx
80100a4b:	6a 00                	push   $0x0
80100a4d:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a4f:	c7 05 ac 09 12 80 40 	movl   $0x80100640,0x801209ac
80100a56:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a59:	c7 05 a8 09 12 80 90 	movl   $0x80100290,0x801209a8
80100a60:	02 10 80 
  cons.locking = 1;
80100a63:	c7 05 54 c5 10 80 01 	movl   $0x1,0x8010c554
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
80100b20:	e8 9b 36 00 00       	call   801041c0 <myproc>
80100b25:	89 c7                	mov    %eax,%edi
  struct pageinfo mem_pginfo_bu[MAX_PYSC_PAGES];
  struct pageinfo swp_pginfo_bu[MAX_PYSC_PAGES];
  struct file* swap_file_bu = 0;
  struct file* temp_swap_file = 0;

  begin_op();
80100b27:	e8 d4 29 00 00       	call   80103500 <begin_op>

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
80100b6f:	e8 fc 29 00 00       	call   80103570 <end_op>
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
80100b94:	e8 a7 71 00 00       	call   80107d40 <setupkvm>
80100b99:	89 85 f4 fb ff ff    	mov    %eax,-0x40c(%ebp)
80100b9f:	85 c0                	test   %eax,%eax
80100ba1:	74 c3                	je     80100b66 <exec+0x56>
  if (curproc->pid > 2){
80100ba3:	83 7f 10 64          	cmpl   $0x64,0x10(%edi)
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
80100d7f:	e8 1c 75 00 00       	call   801082a0 <allocuvm>
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
80100db5:	e8 96 6c 00 00       	call   80107a50 <loaduvm>
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
80100df8:	83 7f 10 64          	cmpl   $0x64,0x10(%edi)
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
80100ee9:	e8 42 6d 00 00       	call   80107c30 <freevm>
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
80100f72:	e8 f9 25 00 00       	call   80103570 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100f77:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
80100f7d:	8b b5 f4 fb ff ff    	mov    -0x40c(%ebp),%esi
80100f83:	83 c4 0c             	add    $0xc,%esp
80100f86:	53                   	push   %ebx
80100f87:	50                   	push   %eax
80100f88:	56                   	push   %esi
80100f89:	e8 12 73 00 00       	call   801082a0 <allocuvm>
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
80100fae:	e8 2d 6e 00 00       	call   80107de0 <clearpteu>
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
80100fff:	e8 7c 43 00 00       	call   80105380 <strlen>
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
80101012:	e8 69 43 00 00       	call   80105380 <strlen>
80101017:	83 c0 01             	add    $0x1,%eax
8010101a:	50                   	push   %eax
8010101b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010101e:	ff 34 b8             	pushl  (%eax,%edi,4)
80101021:	53                   	push   %ebx
80101022:	56                   	push   %esi
80101023:	e8 58 70 00 00       	call   80108080 <copyout>
80101028:	83 c4 20             	add    $0x20,%esp
8010102b:	85 c0                	test   %eax,%eax
8010102d:	79 a9                	jns    80100fd8 <exec+0x4c8>
8010102f:	8b bd d8 fb ff ff    	mov    -0x428(%ebp),%edi
    if (curproc->pid > 2){
80101035:	83 7f 10 64          	cmpl   $0x64,0x10(%edi)
80101039:	7f 16                	jg     80101051 <exec+0x541>
    freevm(pgdir);
8010103b:	83 ec 0c             	sub    $0xc,%esp
8010103e:	ff b5 f4 fb ff ff    	pushl  -0x40c(%ebp)
80101044:	e8 e7 6b 00 00       	call   80107c30 <freevm>
80101049:	83 c4 10             	add    $0x10,%esp
8010104c:	e9 a8 fe ff ff       	jmp    80100ef9 <exec+0x3e9>
  ip = 0;
80101051:	31 f6                	xor    %esi,%esi
80101053:	e9 aa fd ff ff       	jmp    80100e02 <exec+0x2f2>
    end_op();
80101058:	e8 13 25 00 00       	call   80103570 <end_op>
    cprintf("exec: fail\n");
8010105d:	83 ec 0c             	sub    $0xc,%esp
80101060:	68 e1 87 10 80       	push   $0x801087e1
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
801010bb:	e8 c0 6f 00 00       	call   80108080 <copyout>
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
801010f3:	e8 48 42 00 00       	call   80105340 <safestrcpy>
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
80101121:	83 7f 10 64          	cmpl   $0x64,0x10(%edi)
80101125:	7f 27                	jg     8010114e <exec+0x63e>
  switchuvm(curproc);
80101127:	83 ec 0c             	sub    $0xc,%esp
8010112a:	57                   	push   %edi
8010112b:	e8 90 67 00 00       	call   801078c0 <switchuvm>
  freevm(oldpgdir);
80101130:	89 1c 24             	mov    %ebx,(%esp)
80101133:	e8 f8 6a 00 00       	call   80107c30 <freevm>
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
80101185:	e8 a6 6a 00 00       	call   80107c30 <freevm>
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
801011aa:	68 ed 87 10 80       	push   $0x801087ed
801011af:	68 00 00 12 80       	push   $0x80120000
801011b4:	e8 37 3d 00 00       	call   80104ef0 <initlock>
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
801011c8:	bb 34 00 12 80       	mov    $0x80120034,%ebx
{
801011cd:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
801011d0:	68 00 00 12 80       	push   $0x80120000
801011d5:	e8 96 3e 00 00       	call   80105070 <acquire>
801011da:	83 c4 10             	add    $0x10,%esp
801011dd:	eb 0c                	jmp    801011eb <filealloc+0x2b>
801011df:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801011e0:	83 c3 18             	add    $0x18,%ebx
801011e3:	81 fb 94 09 12 80    	cmp    $0x80120994,%ebx
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
801011fc:	68 00 00 12 80       	push   $0x80120000
80101201:	e8 2a 3f 00 00       	call   80105130 <release>
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
80101215:	68 00 00 12 80       	push   $0x80120000
8010121a:	e8 11 3f 00 00       	call   80105130 <release>
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
8010123e:	68 00 00 12 80       	push   $0x80120000
80101243:	e8 28 3e 00 00       	call   80105070 <acquire>
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
8010125b:	68 00 00 12 80       	push   $0x80120000
80101260:	e8 cb 3e 00 00       	call   80105130 <release>
  return f;
}
80101265:	89 d8                	mov    %ebx,%eax
80101267:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010126a:	c9                   	leave  
8010126b:	c3                   	ret    
    panic("filedup");
8010126c:	83 ec 0c             	sub    $0xc,%esp
8010126f:	68 f4 87 10 80       	push   $0x801087f4
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
80101290:	68 00 00 12 80       	push   $0x80120000
80101295:	e8 d6 3d 00 00       	call   80105070 <acquire>
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
801012c8:	68 00 00 12 80       	push   $0x80120000
  ff = *f;
801012cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
801012d0:	e8 5b 3e 00 00       	call   80105130 <release>

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
801012f0:	c7 45 08 00 00 12 80 	movl   $0x80120000,0x8(%ebp)
}
801012f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012fa:	5b                   	pop    %ebx
801012fb:	5e                   	pop    %esi
801012fc:	5f                   	pop    %edi
801012fd:	5d                   	pop    %ebp
    release(&ftable.lock);
801012fe:	e9 2d 3e 00 00       	jmp    80105130 <release>
80101303:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101307:	90                   	nop
    begin_op();
80101308:	e8 f3 21 00 00       	call   80103500 <begin_op>
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
80101322:	e9 49 22 00 00       	jmp    80103570 <end_op>
80101327:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010132e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80101330:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80101334:	83 ec 08             	sub    $0x8,%esp
80101337:	53                   	push   %ebx
80101338:	56                   	push   %esi
80101339:	e8 a2 29 00 00       	call   80103ce0 <pipeclose>
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
8010134c:	68 fc 87 10 80       	push   $0x801087fc
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
80101425:	e9 56 2a 00 00       	jmp    80103e80 <piperead>
8010142a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101430:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101435:	eb d3                	jmp    8010140a <fileread+0x5a>
  panic("fileread");
80101437:	83 ec 0c             	sub    $0xc,%esp
8010143a:	68 06 88 10 80       	push   $0x80108806
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
801014b1:	e8 ba 20 00 00       	call   80103570 <end_op>

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
801014da:	e8 21 20 00 00       	call   80103500 <begin_op>
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
80101511:	e8 5a 20 00 00       	call   80103570 <end_op>
      if(r < 0)
80101516:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101519:	83 c4 10             	add    $0x10,%esp
8010151c:	85 c0                	test   %eax,%eax
8010151e:	75 17                	jne    80101537 <filewrite+0xe7>
        panic("short filewrite");
80101520:	83 ec 0c             	sub    $0xc,%esp
80101523:	68 0f 88 10 80       	push   $0x8010880f
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
80101551:	e9 2a 28 00 00       	jmp    80103d80 <pipewrite>
  panic("filewrite");
80101556:	83 ec 0c             	sub    $0xc,%esp
80101559:	68 15 88 10 80       	push   $0x80108815
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
80101578:	03 05 18 0a 12 80    	add    0x80120a18,%eax
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
801015bd:	e8 1e 21 00 00       	call   801036e0 <log_write>
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
801015d7:	68 1f 88 10 80       	push   $0x8010881f
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
801015f9:	8b 0d 00 0a 12 80    	mov    0x80120a00,%ecx
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
8010161c:	03 05 18 0a 12 80    	add    0x80120a18,%eax
80101622:	50                   	push   %eax
80101623:	ff 75 d8             	pushl  -0x28(%ebp)
80101626:	e8 a5 ea ff ff       	call   801000d0 <bread>
8010162b:	83 c4 10             	add    $0x10,%esp
8010162e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101631:	a1 00 0a 12 80       	mov    0x80120a00,%eax
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
80101689:	39 05 00 0a 12 80    	cmp    %eax,0x80120a00
8010168f:	77 80                	ja     80101611 <balloc+0x21>
  panic("balloc: out of blocks");
80101691:	83 ec 0c             	sub    $0xc,%esp
80101694:	68 32 88 10 80       	push   $0x80108832
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
801016ad:	e8 2e 20 00 00       	call   801036e0 <log_write>
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
801016d5:	e8 a6 3a 00 00       	call   80105180 <memset>
  log_write(bp);
801016da:	89 1c 24             	mov    %ebx,(%esp)
801016dd:	e8 fe 1f 00 00       	call   801036e0 <log_write>
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
8010170a:	bb 54 0a 12 80       	mov    $0x80120a54,%ebx
{
8010170f:	83 ec 28             	sub    $0x28,%esp
80101712:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101715:	68 20 0a 12 80       	push   $0x80120a20
8010171a:	e8 51 39 00 00       	call   80105070 <acquire>
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
8010173a:	81 fb 74 26 12 80    	cmp    $0x80122674,%ebx
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
8010175b:	81 fb 74 26 12 80    	cmp    $0x80122674,%ebx
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
80101782:	68 20 0a 12 80       	push   $0x80120a20
80101787:	e8 a4 39 00 00       	call   80105130 <release>

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
801017ad:	68 20 0a 12 80       	push   $0x80120a20
      ip->ref++;
801017b2:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801017b5:	e8 76 39 00 00       	call   80105130 <release>
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
801017c7:	81 fb 74 26 12 80    	cmp    $0x80122674,%ebx
801017cd:	73 10                	jae    801017df <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801017cf:	8b 4b 08             	mov    0x8(%ebx),%ecx
801017d2:	85 c9                	test   %ecx,%ecx
801017d4:	0f 8f 56 ff ff ff    	jg     80101730 <iget+0x30>
801017da:	e9 6e ff ff ff       	jmp    8010174d <iget+0x4d>
    panic("iget: no inodes");
801017df:	83 ec 0c             	sub    $0xc,%esp
801017e2:	68 48 88 10 80       	push   $0x80108848
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
80101865:	e8 76 1e 00 00       	call   801036e0 <log_write>
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
801018ab:	68 58 88 10 80       	push   $0x80108858
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
801018e5:	e8 36 39 00 00       	call   80105220 <memmove>
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
80101908:	bb 60 0a 12 80       	mov    $0x80120a60,%ebx
8010190d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101910:	68 6b 88 10 80       	push   $0x8010886b
80101915:	68 20 0a 12 80       	push   $0x80120a20
8010191a:	e8 d1 35 00 00       	call   80104ef0 <initlock>
  for(i = 0; i < NINODE; i++) {
8010191f:	83 c4 10             	add    $0x10,%esp
80101922:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101928:	83 ec 08             	sub    $0x8,%esp
8010192b:	68 72 88 10 80       	push   $0x80108872
80101930:	53                   	push   %ebx
80101931:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101937:	e8 74 34 00 00       	call   80104db0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
8010193c:	83 c4 10             	add    $0x10,%esp
8010193f:	81 fb 80 26 12 80    	cmp    $0x80122680,%ebx
80101945:	75 e1                	jne    80101928 <iinit+0x28>
  readsb(dev, &sb);
80101947:	83 ec 08             	sub    $0x8,%esp
8010194a:	68 00 0a 12 80       	push   $0x80120a00
8010194f:	ff 75 08             	pushl  0x8(%ebp)
80101952:	e8 69 ff ff ff       	call   801018c0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101957:	ff 35 18 0a 12 80    	pushl  0x80120a18
8010195d:	ff 35 14 0a 12 80    	pushl  0x80120a14
80101963:	ff 35 10 0a 12 80    	pushl  0x80120a10
80101969:	ff 35 0c 0a 12 80    	pushl  0x80120a0c
8010196f:	ff 35 08 0a 12 80    	pushl  0x80120a08
80101975:	ff 35 04 0a 12 80    	pushl  0x80120a04
8010197b:	ff 35 00 0a 12 80    	pushl  0x80120a00
80101981:	68 1c 89 10 80       	push   $0x8010891c
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
801019b0:	83 3d 08 0a 12 80 01 	cmpl   $0x1,0x80120a08
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
801019df:	3b 3d 08 0a 12 80    	cmp    0x80120a08,%edi
801019e5:	73 69                	jae    80101a50 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801019e7:	89 f8                	mov    %edi,%eax
801019e9:	83 ec 08             	sub    $0x8,%esp
801019ec:	c1 e8 03             	shr    $0x3,%eax
801019ef:	03 05 14 0a 12 80    	add    0x80120a14,%eax
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
80101a1e:	e8 5d 37 00 00       	call   80105180 <memset>
      dip->type = type;
80101a23:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101a27:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101a2a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
80101a2d:	89 1c 24             	mov    %ebx,(%esp)
80101a30:	e8 ab 1c 00 00       	call   801036e0 <log_write>
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
80101a53:	68 78 88 10 80       	push   $0x80108878
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
80101a78:	03 05 14 0a 12 80    	add    0x80120a14,%eax
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
80101ac5:	e8 56 37 00 00       	call   80105220 <memmove>
  log_write(bp);
80101aca:	89 34 24             	mov    %esi,(%esp)
80101acd:	e8 0e 1c 00 00       	call   801036e0 <log_write>
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
80101afe:	68 20 0a 12 80       	push   $0x80120a20
80101b03:	e8 68 35 00 00       	call   80105070 <acquire>
  ip->ref++;
80101b08:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101b0c:	c7 04 24 20 0a 12 80 	movl   $0x80120a20,(%esp)
80101b13:	e8 18 36 00 00       	call   80105130 <release>
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
80101b46:	e8 a5 32 00 00       	call   80104df0 <acquiresleep>
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
80101b69:	03 05 14 0a 12 80    	add    0x80120a14,%eax
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
80101bb8:	e8 63 36 00 00       	call   80105220 <memmove>
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
80101bdd:	68 90 88 10 80       	push   $0x80108890
80101be2:	e8 a9 e7 ff ff       	call   80100390 <panic>
    panic("ilock");
80101be7:	83 ec 0c             	sub    $0xc,%esp
80101bea:	68 8a 88 10 80       	push   $0x8010888a
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
80101c17:	e8 74 32 00 00       	call   80104e90 <holdingsleep>
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
80101c33:	e9 18 32 00 00       	jmp    80104e50 <releasesleep>
    panic("iunlock");
80101c38:	83 ec 0c             	sub    $0xc,%esp
80101c3b:	68 9f 88 10 80       	push   $0x8010889f
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
80101c64:	e8 87 31 00 00       	call   80104df0 <acquiresleep>
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
80101c7e:	e8 cd 31 00 00       	call   80104e50 <releasesleep>
  acquire(&icache.lock);
80101c83:	c7 04 24 20 0a 12 80 	movl   $0x80120a20,(%esp)
80101c8a:	e8 e1 33 00 00       	call   80105070 <acquire>
  ip->ref--;
80101c8f:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101c93:	83 c4 10             	add    $0x10,%esp
80101c96:	c7 45 08 20 0a 12 80 	movl   $0x80120a20,0x8(%ebp)
}
80101c9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ca0:	5b                   	pop    %ebx
80101ca1:	5e                   	pop    %esi
80101ca2:	5f                   	pop    %edi
80101ca3:	5d                   	pop    %ebp
  release(&icache.lock);
80101ca4:	e9 87 34 00 00       	jmp    80105130 <release>
80101ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
80101cb0:	83 ec 0c             	sub    $0xc,%esp
80101cb3:	68 20 0a 12 80       	push   $0x80120a20
80101cb8:	e8 b3 33 00 00       	call   80105070 <acquire>
    int r = ip->ref;
80101cbd:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101cc0:	c7 04 24 20 0a 12 80 	movl   $0x80120a20,(%esp)
80101cc7:	e8 64 34 00 00       	call   80105130 <release>
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
80101ec7:	e8 54 33 00 00       	call   80105220 <memmove>
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
80101efa:	8b 04 c5 a0 09 12 80 	mov    -0x7fedf660(,%eax,8),%eax
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
80101fc3:	e8 58 32 00 00       	call   80105220 <memmove>
    log_write(bp);
80101fc8:	89 3c 24             	mov    %edi,(%esp)
80101fcb:	e8 10 17 00 00       	call   801036e0 <log_write>
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
8010200a:	8b 04 c5 a4 09 12 80 	mov    -0x7fedf65c(,%eax,8),%eax
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
80102062:	e8 29 32 00 00       	call   80105290 <strncmp>
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
801020c5:	e8 c6 31 00 00       	call   80105290 <strncmp>
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
8010210a:	68 b9 88 10 80       	push   $0x801088b9
8010210f:	e8 7c e2 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80102114:	83 ec 0c             	sub    $0xc,%esp
80102117:	68 a7 88 10 80       	push   $0x801088a7
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
8010214a:	e8 71 20 00 00       	call   801041c0 <myproc>
  acquire(&icache.lock);
8010214f:	83 ec 0c             	sub    $0xc,%esp
80102152:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80102154:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80102157:	68 20 0a 12 80       	push   $0x80120a20
8010215c:	e8 0f 2f 00 00       	call   80105070 <acquire>
  ip->ref++;
80102161:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102165:	c7 04 24 20 0a 12 80 	movl   $0x80120a20,(%esp)
8010216c:	e8 bf 2f 00 00       	call   80105130 <release>
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
801021d7:	e8 44 30 00 00       	call   80105220 <memmove>
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
80102263:	e8 b8 2f 00 00       	call   80105220 <memmove>
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
80102395:	e8 46 2f 00 00       	call   801052e0 <strncpy>
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
801023d3:	68 c8 88 10 80       	push   $0x801088c8
801023d8:	e8 b3 df ff ff       	call   80100390 <panic>
    panic("dirlink");
801023dd:	83 ec 0c             	sub    $0xc,%esp
801023e0:	68 71 8f 10 80       	push   $0x80108f71
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
801024d5:	68 d5 88 10 80       	push   $0x801088d5
801024da:	56                   	push   %esi
801024db:	e8 40 2d 00 00       	call   80105220 <memmove>
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
80102508:	e8 f3 0f 00 00       	call   80103500 <begin_op>
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
80102536:	68 dd 88 10 80       	push   $0x801088dd
8010253b:	53                   	push   %ebx
8010253c:	e8 4f 2d 00 00       	call   80105290 <strncmp>

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80102541:	83 c4 10             	add    $0x10,%esp
80102544:	85 c0                	test   %eax,%eax
80102546:	0f 84 f4 00 00 00    	je     80102640 <removeSwapFile+0x180>
  return strncmp(s, t, DIRSIZ);
8010254c:	83 ec 04             	sub    $0x4,%esp
8010254f:	6a 0e                	push   $0xe
80102551:	68 dc 88 10 80       	push   $0x801088dc
80102556:	53                   	push   %ebx
80102557:	e8 34 2d 00 00       	call   80105290 <strncmp>
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
801025ab:	e8 d0 2b 00 00       	call   80105180 <memset>
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
80102601:	e8 6a 0f 00 00       	call   80103570 <end_op>

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
8010261c:	e8 2f 33 00 00       	call   80105950 <isdirempty>
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
80102651:	e8 1a 0f 00 00       	call   80103570 <end_op>
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
8010267d:	e8 ee 0e 00 00       	call   80103570 <end_op>
    return -1;
80102682:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102687:	e9 7f ff ff ff       	jmp    8010260b <removeSwapFile+0x14b>
    panic("unlink: writei");
8010268c:	83 ec 0c             	sub    $0xc,%esp
8010268f:	68 f1 88 10 80       	push   $0x801088f1
80102694:	e8 f7 dc ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80102699:	83 ec 0c             	sub    $0xc,%esp
8010269c:	68 df 88 10 80       	push   $0x801088df
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
801026c4:	68 d5 88 10 80       	push   $0x801088d5
801026c9:	56                   	push   %esi
801026ca:	e8 51 2b 00 00       	call   80105220 <memmove>
  itoa(p->pid, path+ 6);
801026cf:	58                   	pop    %eax
801026d0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801026d3:	5a                   	pop    %edx
801026d4:	50                   	push   %eax
801026d5:	ff 73 10             	pushl  0x10(%ebx)
801026d8:	e8 53 fd ff ff       	call   80102430 <itoa>

    begin_op();
801026dd:	e8 1e 0e 00 00       	call   80103500 <begin_op>
    struct inode * in = create(path, T_FILE, 0, 0);
801026e2:	6a 00                	push   $0x0
801026e4:	6a 00                	push   $0x0
801026e6:	6a 02                	push   $0x2
801026e8:	56                   	push   %esi
801026e9:	e8 82 34 00 00       	call   80105b70 <create>
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
8010272c:	e8 3f 0e 00 00       	call   80103570 <end_op>

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
8010273d:	68 00 89 10 80       	push   $0x80108900
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
8010286b:	68 78 89 10 80       	push   $0x80108978
80102870:	e8 1b db ff ff       	call   80100390 <panic>
    panic("idestart");
80102875:	83 ec 0c             	sub    $0xc,%esp
80102878:	68 6f 89 10 80       	push   $0x8010896f
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
8010289a:	68 8a 89 10 80       	push   $0x8010898a
8010289f:	68 80 c5 10 80       	push   $0x8010c580
801028a4:	e8 47 26 00 00       	call   80104ef0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801028a9:	58                   	pop    %eax
801028aa:	a1 80 2d 12 80       	mov    0x80122d80,%eax
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
801028fa:	c7 05 60 c5 10 80 01 	movl   $0x1,0x8010c560
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
8010292d:	68 80 c5 10 80       	push   $0x8010c580
80102932:	e8 39 27 00 00       	call   80105070 <acquire>

  if((b = idequeue) == 0){
80102937:	8b 1d 64 c5 10 80    	mov    0x8010c564,%ebx
8010293d:	83 c4 10             	add    $0x10,%esp
80102940:	85 db                	test   %ebx,%ebx
80102942:	74 5f                	je     801029a3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102944:	8b 43 58             	mov    0x58(%ebx),%eax
80102947:	a3 64 c5 10 80       	mov    %eax,0x8010c564

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
8010298d:	e8 2e 22 00 00       	call   80104bc0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102992:	a1 64 c5 10 80       	mov    0x8010c564,%eax
80102997:	83 c4 10             	add    $0x10,%esp
8010299a:	85 c0                	test   %eax,%eax
8010299c:	74 05                	je     801029a3 <ideintr+0x83>
    idestart(idequeue);
8010299e:	e8 0d fe ff ff       	call   801027b0 <idestart>
    release(&idelock);
801029a3:	83 ec 0c             	sub    $0xc,%esp
801029a6:	68 80 c5 10 80       	push   $0x8010c580
801029ab:	e8 80 27 00 00       	call   80105130 <release>

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
801029d2:	e8 b9 24 00 00       	call   80104e90 <holdingsleep>
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
801029f7:	a1 60 c5 10 80       	mov    0x8010c560,%eax
801029fc:	85 c0                	test   %eax,%eax
801029fe:	0f 84 93 00 00 00    	je     80102a97 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102a04:	83 ec 0c             	sub    $0xc,%esp
80102a07:	68 80 c5 10 80       	push   $0x8010c580
80102a0c:	e8 5f 26 00 00       	call   80105070 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102a11:	a1 64 c5 10 80       	mov    0x8010c564,%eax
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
80102a36:	39 1d 64 c5 10 80    	cmp    %ebx,0x8010c564
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
80102a53:	68 80 c5 10 80       	push   $0x8010c580
80102a58:	53                   	push   %ebx
80102a59:	e8 02 1f 00 00       	call   80104960 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102a5e:	8b 03                	mov    (%ebx),%eax
80102a60:	83 c4 10             	add    $0x10,%esp
80102a63:	83 e0 06             	and    $0x6,%eax
80102a66:	83 f8 02             	cmp    $0x2,%eax
80102a69:	75 e5                	jne    80102a50 <iderw+0x90>
  }


  release(&idelock);
80102a6b:	c7 45 08 80 c5 10 80 	movl   $0x8010c580,0x8(%ebp)
}
80102a72:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a75:	c9                   	leave  
  release(&idelock);
80102a76:	e9 b5 26 00 00       	jmp    80105130 <release>
80102a7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a7f:	90                   	nop
    idestart(b);
80102a80:	89 d8                	mov    %ebx,%eax
80102a82:	e8 29 fd ff ff       	call   801027b0 <idestart>
80102a87:	eb b5                	jmp    80102a3e <iderw+0x7e>
80102a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102a90:	ba 64 c5 10 80       	mov    $0x8010c564,%edx
80102a95:	eb 9d                	jmp    80102a34 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102a97:	83 ec 0c             	sub    $0xc,%esp
80102a9a:	68 b9 89 10 80       	push   $0x801089b9
80102a9f:	e8 ec d8 ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102aa4:	83 ec 0c             	sub    $0xc,%esp
80102aa7:	68 a4 89 10 80       	push   $0x801089a4
80102aac:	e8 df d8 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102ab1:	83 ec 0c             	sub    $0xc,%esp
80102ab4:	68 8e 89 10 80       	push   $0x8010898e
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
80102ac5:	c7 05 74 26 12 80 00 	movl   $0xfec00000,0x80122674
80102acc:	00 c0 fe 
{
80102acf:	89 e5                	mov    %esp,%ebp
80102ad1:	56                   	push   %esi
80102ad2:	53                   	push   %ebx
  ioapic->reg = reg;
80102ad3:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102ada:	00 00 00 
  return ioapic->data;
80102add:	8b 15 74 26 12 80    	mov    0x80122674,%edx
80102ae3:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102ae6:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102aec:	8b 0d 74 26 12 80    	mov    0x80122674,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102af2:	0f b6 15 e0 27 12 80 	movzbl 0x801227e0,%edx
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
80102b0e:	68 d8 89 10 80       	push   $0x801089d8
80102b13:	e8 98 db ff ff       	call   801006b0 <cprintf>
80102b18:	8b 0d 74 26 12 80    	mov    0x80122674,%ecx
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
80102b34:	8b 0d 74 26 12 80    	mov    0x80122674,%ecx
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
80102b4e:	8b 0d 74 26 12 80    	mov    0x80122674,%ecx
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
80102b75:	8b 0d 74 26 12 80    	mov    0x80122674,%ecx
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
80102b89:	8b 0d 74 26 12 80    	mov    0x80122674,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102b8f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102b92:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102b95:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102b98:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102b9a:	a1 74 26 12 80       	mov    0x80122674,%eax
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

80102bb0 <init_cow>:



struct spinlock r_cow_lock;

void init_cow(){
80102bb0:	f3 0f 1e fb          	endbr32 
80102bb4:	55                   	push   %ebp
80102bb5:	89 e5                	mov    %esp,%ebp
80102bb7:	83 ec 14             	sub    $0x14,%esp
  cprintf("initing cow\n");
80102bba:	68 0a 8a 10 80       	push   $0x80108a0a
80102bbf:	e8 ec da ff ff       	call   801006b0 <cprintf>
  memset((void*)pg_ref_counts, 0, sizeof(pg_ref_counts));
80102bc4:	83 c4 0c             	add    $0xc,%esp
80102bc7:	68 00 e0 00 00       	push   $0xe000
80102bcc:	6a 00                	push   $0x0
80102bce:	68 40 1f 11 80       	push   $0x80111f40
80102bd3:	e8 a8 25 00 00       	call   80105180 <memset>
  initlock(&r_cow_lock, "cow lock");
80102bd8:	58                   	pop    %eax
80102bd9:	5a                   	pop    %edx
80102bda:	68 17 8a 10 80       	push   $0x80108a17
80102bdf:	68 c0 26 12 80       	push   $0x801226c0
80102be4:	e8 07 23 00 00       	call   80104ef0 <initlock>
  cow_lock = &r_cow_lock;
  cprintf("initing cow end\n");
80102be9:	c7 04 24 20 8a 10 80 	movl   $0x80108a20,(%esp)
  cow_lock = &r_cow_lock;
80102bf0:	c7 05 40 ff 11 80 c0 	movl   $0x801226c0,0x8011ff40
80102bf7:	26 12 80 
  cprintf("initing cow end\n");
80102bfa:	e8 b1 da ff ff       	call   801006b0 <cprintf>
}
80102bff:	83 c4 10             	add    $0x10,%esp
80102c02:	c9                   	leave  
80102c03:	c3                   	ret    
80102c04:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c0f:	90                   	nop

80102c10 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102c10:	f3 0f 1e fb          	endbr32 
80102c14:	55                   	push   %ebp
80102c15:	89 e5                	mov    %esp,%ebp
80102c17:	53                   	push   %ebx
80102c18:	83 ec 04             	sub    $0x4,%esp
80102c1b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102c1e:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102c24:	75 7a                	jne    80102ca0 <kfree+0x90>
80102c26:	81 fb 28 1a 13 80    	cmp    $0x80131a28,%ebx
80102c2c:	72 72                	jb     80102ca0 <kfree+0x90>
80102c2e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102c34:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102c39:	77 65                	ja     80102ca0 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102c3b:	83 ec 04             	sub    $0x4,%esp
80102c3e:	68 00 10 00 00       	push   $0x1000
80102c43:	6a 01                	push   $0x1
80102c45:	53                   	push   %ebx
80102c46:	e8 35 25 00 00       	call   80105180 <memset>

  if(kmem.use_lock)
80102c4b:	8b 15 b4 26 12 80    	mov    0x801226b4,%edx
80102c51:	83 c4 10             	add    $0x10,%esp
80102c54:	85 d2                	test   %edx,%edx
80102c56:	75 20                	jne    80102c78 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102c58:	a1 b8 26 12 80       	mov    0x801226b8,%eax
80102c5d:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102c5f:	a1 b4 26 12 80       	mov    0x801226b4,%eax
  kmem.freelist = r;
80102c64:	89 1d b8 26 12 80    	mov    %ebx,0x801226b8
  if(kmem.use_lock)
80102c6a:	85 c0                	test   %eax,%eax
80102c6c:	75 22                	jne    80102c90 <kfree+0x80>
    release(&kmem.lock);
}
80102c6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c71:	c9                   	leave  
80102c72:	c3                   	ret    
80102c73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c77:	90                   	nop
    acquire(&kmem.lock);
80102c78:	83 ec 0c             	sub    $0xc,%esp
80102c7b:	68 80 26 12 80       	push   $0x80122680
80102c80:	e8 eb 23 00 00       	call   80105070 <acquire>
80102c85:	83 c4 10             	add    $0x10,%esp
80102c88:	eb ce                	jmp    80102c58 <kfree+0x48>
80102c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102c90:	c7 45 08 80 26 12 80 	movl   $0x80122680,0x8(%ebp)
}
80102c97:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c9a:	c9                   	leave  
    release(&kmem.lock);
80102c9b:	e9 90 24 00 00       	jmp    80105130 <release>
    panic("kfree");
80102ca0:	83 ec 0c             	sub    $0xc,%esp
80102ca3:	68 63 92 10 80       	push   $0x80109263
80102ca8:	e8 e3 d6 ff ff       	call   80100390 <panic>
80102cad:	8d 76 00             	lea    0x0(%esi),%esi

80102cb0 <freerange>:
{
80102cb0:	f3 0f 1e fb          	endbr32 
80102cb4:	55                   	push   %ebp
80102cb5:	89 e5                	mov    %esp,%ebp
80102cb7:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102cb8:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102cbb:	8b 75 0c             	mov    0xc(%ebp),%esi
80102cbe:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102cbf:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102cc5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102ccb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102cd1:	39 de                	cmp    %ebx,%esi
80102cd3:	72 2f                	jb     80102d04 <freerange+0x54>
80102cd5:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102cd8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102cde:	83 ec 0c             	sub    $0xc,%esp
80102ce1:	50                   	push   %eax
80102ce2:	e8 29 ff ff ff       	call   80102c10 <kfree>
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
80102ce7:	8d 83 00 f0 ff 7f    	lea    0x7ffff000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102ced:	83 c4 10             	add    $0x10,%esp
80102cf0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
80102cf6:	c1 e8 0c             	shr    $0xc,%eax
80102cf9:	c6 80 40 1f 11 80 00 	movb   $0x0,-0x7feee0c0(%eax)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102d00:	39 f3                	cmp    %esi,%ebx
80102d02:	76 d4                	jbe    80102cd8 <freerange+0x28>
}
80102d04:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102d07:	5b                   	pop    %ebx
80102d08:	5e                   	pop    %esi
80102d09:	5d                   	pop    %ebp
80102d0a:	c3                   	ret    
80102d0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d0f:	90                   	nop

80102d10 <kinit1>:
{
80102d10:	f3 0f 1e fb          	endbr32 
80102d14:	55                   	push   %ebp
80102d15:	89 e5                	mov    %esp,%ebp
80102d17:	56                   	push   %esi
80102d18:	53                   	push   %ebx
80102d19:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102d1c:	83 ec 08             	sub    $0x8,%esp
80102d1f:	68 31 8a 10 80       	push   $0x80108a31
80102d24:	68 80 26 12 80       	push   $0x80122680
80102d29:	e8 c2 21 00 00       	call   80104ef0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102d31:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102d34:	c7 05 b4 26 12 80 00 	movl   $0x0,0x801226b4
80102d3b:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80102d3e:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102d44:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102d4a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102d50:	39 de                	cmp    %ebx,%esi
80102d52:	72 30                	jb     80102d84 <kinit1+0x74>
80102d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102d58:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102d5e:	83 ec 0c             	sub    $0xc,%esp
80102d61:	50                   	push   %eax
80102d62:	e8 a9 fe ff ff       	call   80102c10 <kfree>
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
80102d67:	8d 83 00 f0 ff 7f    	lea    0x7ffff000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102d6d:	83 c4 10             	add    $0x10,%esp
80102d70:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
80102d76:	c1 e8 0c             	shr    $0xc,%eax
80102d79:	c6 80 40 1f 11 80 00 	movb   $0x0,-0x7feee0c0(%eax)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102d80:	39 de                	cmp    %ebx,%esi
80102d82:	73 d4                	jae    80102d58 <kinit1+0x48>
}
80102d84:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102d87:	5b                   	pop    %ebx
80102d88:	5e                   	pop    %esi
80102d89:	5d                   	pop    %ebp
80102d8a:	c3                   	ret    
80102d8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d8f:	90                   	nop

80102d90 <kinit2>:
{
80102d90:	f3 0f 1e fb          	endbr32 
80102d94:	55                   	push   %ebp
80102d95:	89 e5                	mov    %esp,%ebp
80102d97:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102d98:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102d9b:	8b 75 0c             	mov    0xc(%ebp),%esi
80102d9e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102d9f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102da5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102dab:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102db1:	39 de                	cmp    %ebx,%esi
80102db3:	72 2f                	jb     80102de4 <kinit2+0x54>
80102db5:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102db8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102dbe:	83 ec 0c             	sub    $0xc,%esp
80102dc1:	50                   	push   %eax
80102dc2:	e8 49 fe ff ff       	call   80102c10 <kfree>
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
80102dc7:	8d 83 00 f0 ff 7f    	lea    0x7ffff000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102dcd:	83 c4 10             	add    $0x10,%esp
80102dd0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
80102dd6:	c1 e8 0c             	shr    $0xc,%eax
80102dd9:	c6 80 40 1f 11 80 00 	movb   $0x0,-0x7feee0c0(%eax)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102de0:	39 de                	cmp    %ebx,%esi
80102de2:	73 d4                	jae    80102db8 <kinit2+0x28>
  kmem.use_lock = 1;
80102de4:	c7 05 b4 26 12 80 01 	movl   $0x1,0x801226b4
80102deb:	00 00 00 
}
80102dee:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102df1:	5b                   	pop    %ebx
80102df2:	5e                   	pop    %esi
80102df3:	5d                   	pop    %ebp
80102df4:	c3                   	ret    
80102df5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102e00 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102e00:	f3 0f 1e fb          	endbr32 
  struct run *r;
  if(kmem.use_lock)
80102e04:	a1 b4 26 12 80       	mov    0x801226b4,%eax
80102e09:	85 c0                	test   %eax,%eax
80102e0b:	75 1b                	jne    80102e28 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102e0d:	a1 b8 26 12 80       	mov    0x801226b8,%eax
  if(r)
80102e12:	85 c0                	test   %eax,%eax
80102e14:	74 0a                	je     80102e20 <kalloc+0x20>
    kmem.freelist = r->next;
80102e16:	8b 10                	mov    (%eax),%edx
80102e18:	89 15 b8 26 12 80    	mov    %edx,0x801226b8
  if(kmem.use_lock)
80102e1e:	c3                   	ret    
80102e1f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102e20:	c3                   	ret    
80102e21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102e28:	55                   	push   %ebp
80102e29:	89 e5                	mov    %esp,%ebp
80102e2b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
80102e2e:	68 80 26 12 80       	push   $0x80122680
80102e33:	e8 38 22 00 00       	call   80105070 <acquire>
  r = kmem.freelist;
80102e38:	a1 b8 26 12 80       	mov    0x801226b8,%eax
  if(r)
80102e3d:	8b 15 b4 26 12 80    	mov    0x801226b4,%edx
80102e43:	83 c4 10             	add    $0x10,%esp
80102e46:	85 c0                	test   %eax,%eax
80102e48:	74 08                	je     80102e52 <kalloc+0x52>
    kmem.freelist = r->next;
80102e4a:	8b 08                	mov    (%eax),%ecx
80102e4c:	89 0d b8 26 12 80    	mov    %ecx,0x801226b8
  if(kmem.use_lock)
80102e52:	85 d2                	test   %edx,%edx
80102e54:	74 16                	je     80102e6c <kalloc+0x6c>
    release(&kmem.lock);
80102e56:	83 ec 0c             	sub    $0xc,%esp
80102e59:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102e5c:	68 80 26 12 80       	push   $0x80122680
80102e61:	e8 ca 22 00 00       	call   80105130 <release>
  return (char*)r;
80102e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102e69:	83 c4 10             	add    $0x10,%esp
}
80102e6c:	c9                   	leave  
80102e6d:	c3                   	ret    
80102e6e:	66 90                	xchg   %ax,%ax

80102e70 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102e70:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e74:	ba 64 00 00 00       	mov    $0x64,%edx
80102e79:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102e7a:	a8 01                	test   $0x1,%al
80102e7c:	0f 84 be 00 00 00    	je     80102f40 <kbdgetc+0xd0>
{
80102e82:	55                   	push   %ebp
80102e83:	ba 60 00 00 00       	mov    $0x60,%edx
80102e88:	89 e5                	mov    %esp,%ebp
80102e8a:	53                   	push   %ebx
80102e8b:	ec                   	in     (%dx),%al
  return data;
80102e8c:	8b 1d b4 c5 10 80    	mov    0x8010c5b4,%ebx
    return -1;
  data = inb(KBDATAP);
80102e92:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80102e95:	3c e0                	cmp    $0xe0,%al
80102e97:	74 57                	je     80102ef0 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102e99:	89 d9                	mov    %ebx,%ecx
80102e9b:	83 e1 40             	and    $0x40,%ecx
80102e9e:	84 c0                	test   %al,%al
80102ea0:	78 5e                	js     80102f00 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102ea2:	85 c9                	test   %ecx,%ecx
80102ea4:	74 09                	je     80102eaf <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102ea6:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102ea9:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102eac:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102eaf:	0f b6 8a 60 8b 10 80 	movzbl -0x7fef74a0(%edx),%ecx
  shift ^= togglecode[data];
80102eb6:	0f b6 82 60 8a 10 80 	movzbl -0x7fef75a0(%edx),%eax
  shift |= shiftcode[data];
80102ebd:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
80102ebf:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102ec1:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102ec3:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102ec9:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102ecc:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102ecf:	8b 04 85 40 8a 10 80 	mov    -0x7fef75c0(,%eax,4),%eax
80102ed6:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102eda:	74 0b                	je     80102ee7 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
80102edc:	8d 50 9f             	lea    -0x61(%eax),%edx
80102edf:	83 fa 19             	cmp    $0x19,%edx
80102ee2:	77 44                	ja     80102f28 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102ee4:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102ee7:	5b                   	pop    %ebx
80102ee8:	5d                   	pop    %ebp
80102ee9:	c3                   	ret    
80102eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102ef0:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102ef3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102ef5:	89 1d b4 c5 10 80    	mov    %ebx,0x8010c5b4
}
80102efb:	5b                   	pop    %ebx
80102efc:	5d                   	pop    %ebp
80102efd:	c3                   	ret    
80102efe:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102f00:	83 e0 7f             	and    $0x7f,%eax
80102f03:	85 c9                	test   %ecx,%ecx
80102f05:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102f08:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102f0a:	0f b6 8a 60 8b 10 80 	movzbl -0x7fef74a0(%edx),%ecx
80102f11:	83 c9 40             	or     $0x40,%ecx
80102f14:	0f b6 c9             	movzbl %cl,%ecx
80102f17:	f7 d1                	not    %ecx
80102f19:	21 d9                	and    %ebx,%ecx
}
80102f1b:	5b                   	pop    %ebx
80102f1c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
80102f1d:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
}
80102f23:	c3                   	ret    
80102f24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102f28:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102f2b:	8d 50 20             	lea    0x20(%eax),%edx
}
80102f2e:	5b                   	pop    %ebx
80102f2f:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102f30:	83 f9 1a             	cmp    $0x1a,%ecx
80102f33:	0f 42 c2             	cmovb  %edx,%eax
}
80102f36:	c3                   	ret    
80102f37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f3e:	66 90                	xchg   %ax,%ax
    return -1;
80102f40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102f45:	c3                   	ret    
80102f46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f4d:	8d 76 00             	lea    0x0(%esi),%esi

80102f50 <kbdintr>:

void
kbdintr(void)
{
80102f50:	f3 0f 1e fb          	endbr32 
80102f54:	55                   	push   %ebp
80102f55:	89 e5                	mov    %esp,%ebp
80102f57:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102f5a:	68 70 2e 10 80       	push   $0x80102e70
80102f5f:	e8 fc d8 ff ff       	call   80100860 <consoleintr>
}
80102f64:	83 c4 10             	add    $0x10,%esp
80102f67:	c9                   	leave  
80102f68:	c3                   	ret    
80102f69:	66 90                	xchg   %ax,%ax
80102f6b:	66 90                	xchg   %ax,%ax
80102f6d:	66 90                	xchg   %ax,%ax
80102f6f:	90                   	nop

80102f70 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102f70:	f3 0f 1e fb          	endbr32 
  if(!lapic)
80102f74:	a1 f4 26 12 80       	mov    0x801226f4,%eax
80102f79:	85 c0                	test   %eax,%eax
80102f7b:	0f 84 c7 00 00 00    	je     80103048 <lapicinit+0xd8>
  lapic[index] = value;
80102f81:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102f88:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f8b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f8e:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102f95:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f98:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f9b:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102fa2:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102fa5:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102fa8:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102faf:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102fb2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102fb5:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102fbc:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102fbf:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102fc2:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102fc9:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102fcc:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102fcf:	8b 50 30             	mov    0x30(%eax),%edx
80102fd2:	c1 ea 10             	shr    $0x10,%edx
80102fd5:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102fdb:	75 73                	jne    80103050 <lapicinit+0xe0>
  lapic[index] = value;
80102fdd:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102fe4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102fe7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102fea:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102ff1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ff4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ff7:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102ffe:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103001:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103004:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
8010300b:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010300e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103011:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80103018:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010301b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010301e:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80103025:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80103028:	8b 50 20             	mov    0x20(%eax),%edx
8010302b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010302f:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80103030:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80103036:	80 e6 10             	and    $0x10,%dh
80103039:	75 f5                	jne    80103030 <lapicinit+0xc0>
  lapic[index] = value;
8010303b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80103042:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103045:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80103048:	c3                   	ret    
80103049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80103050:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80103057:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010305a:	8b 50 20             	mov    0x20(%eax),%edx
}
8010305d:	e9 7b ff ff ff       	jmp    80102fdd <lapicinit+0x6d>
80103062:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103070 <lapicid>:

int
lapicid(void)
{
80103070:	f3 0f 1e fb          	endbr32 
  if (!lapic)
80103074:	a1 f4 26 12 80       	mov    0x801226f4,%eax
80103079:	85 c0                	test   %eax,%eax
8010307b:	74 0b                	je     80103088 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
8010307d:	8b 40 20             	mov    0x20(%eax),%eax
80103080:	c1 e8 18             	shr    $0x18,%eax
80103083:	c3                   	ret    
80103084:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80103088:	31 c0                	xor    %eax,%eax
}
8010308a:	c3                   	ret    
8010308b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010308f:	90                   	nop

80103090 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80103090:	f3 0f 1e fb          	endbr32 
  if(lapic)
80103094:	a1 f4 26 12 80       	mov    0x801226f4,%eax
80103099:	85 c0                	test   %eax,%eax
8010309b:	74 0d                	je     801030aa <lapiceoi+0x1a>
  lapic[index] = value;
8010309d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801030a4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801030a7:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801030aa:	c3                   	ret    
801030ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801030af:	90                   	nop

801030b0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801030b0:	f3 0f 1e fb          	endbr32 
}
801030b4:	c3                   	ret    
801030b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801030c0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801030c0:	f3 0f 1e fb          	endbr32 
801030c4:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801030ca:	ba 70 00 00 00       	mov    $0x70,%edx
801030cf:	89 e5                	mov    %esp,%ebp
801030d1:	53                   	push   %ebx
801030d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801030d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801030d8:	ee                   	out    %al,(%dx)
801030d9:	b8 0a 00 00 00       	mov    $0xa,%eax
801030de:	ba 71 00 00 00       	mov    $0x71,%edx
801030e3:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801030e4:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801030e6:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801030e9:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801030ef:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801030f1:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
801030f4:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
801030f6:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
801030f9:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801030fc:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80103102:	a1 f4 26 12 80       	mov    0x801226f4,%eax
80103107:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010310d:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103110:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80103117:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010311a:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010311d:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80103124:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103127:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010312a:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103130:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103133:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103139:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010313c:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103142:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103145:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
8010314b:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
8010314c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010314f:	5d                   	pop    %ebp
80103150:	c3                   	ret    
80103151:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103158:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010315f:	90                   	nop

80103160 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80103160:	f3 0f 1e fb          	endbr32 
80103164:	55                   	push   %ebp
80103165:	b8 0b 00 00 00       	mov    $0xb,%eax
8010316a:	ba 70 00 00 00       	mov    $0x70,%edx
8010316f:	89 e5                	mov    %esp,%ebp
80103171:	57                   	push   %edi
80103172:	56                   	push   %esi
80103173:	53                   	push   %ebx
80103174:	83 ec 4c             	sub    $0x4c,%esp
80103177:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103178:	ba 71 00 00 00       	mov    $0x71,%edx
8010317d:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010317e:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103181:	bb 70 00 00 00       	mov    $0x70,%ebx
80103186:	88 45 b3             	mov    %al,-0x4d(%ebp)
80103189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103190:	31 c0                	xor    %eax,%eax
80103192:	89 da                	mov    %ebx,%edx
80103194:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103195:	b9 71 00 00 00       	mov    $0x71,%ecx
8010319a:	89 ca                	mov    %ecx,%edx
8010319c:	ec                   	in     (%dx),%al
8010319d:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031a0:	89 da                	mov    %ebx,%edx
801031a2:	b8 02 00 00 00       	mov    $0x2,%eax
801031a7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031a8:	89 ca                	mov    %ecx,%edx
801031aa:	ec                   	in     (%dx),%al
801031ab:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031ae:	89 da                	mov    %ebx,%edx
801031b0:	b8 04 00 00 00       	mov    $0x4,%eax
801031b5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031b6:	89 ca                	mov    %ecx,%edx
801031b8:	ec                   	in     (%dx),%al
801031b9:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031bc:	89 da                	mov    %ebx,%edx
801031be:	b8 07 00 00 00       	mov    $0x7,%eax
801031c3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031c4:	89 ca                	mov    %ecx,%edx
801031c6:	ec                   	in     (%dx),%al
801031c7:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031ca:	89 da                	mov    %ebx,%edx
801031cc:	b8 08 00 00 00       	mov    $0x8,%eax
801031d1:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031d2:	89 ca                	mov    %ecx,%edx
801031d4:	ec                   	in     (%dx),%al
801031d5:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031d7:	89 da                	mov    %ebx,%edx
801031d9:	b8 09 00 00 00       	mov    $0x9,%eax
801031de:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031df:	89 ca                	mov    %ecx,%edx
801031e1:	ec                   	in     (%dx),%al
801031e2:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031e4:	89 da                	mov    %ebx,%edx
801031e6:	b8 0a 00 00 00       	mov    $0xa,%eax
801031eb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031ec:	89 ca                	mov    %ecx,%edx
801031ee:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801031ef:	84 c0                	test   %al,%al
801031f1:	78 9d                	js     80103190 <cmostime+0x30>
  return inb(CMOS_RETURN);
801031f3:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
801031f7:	89 fa                	mov    %edi,%edx
801031f9:	0f b6 fa             	movzbl %dl,%edi
801031fc:	89 f2                	mov    %esi,%edx
801031fe:	89 45 b8             	mov    %eax,-0x48(%ebp)
80103201:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80103205:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103208:	89 da                	mov    %ebx,%edx
8010320a:	89 7d c8             	mov    %edi,-0x38(%ebp)
8010320d:	89 45 bc             	mov    %eax,-0x44(%ebp)
80103210:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80103214:	89 75 cc             	mov    %esi,-0x34(%ebp)
80103217:	89 45 c0             	mov    %eax,-0x40(%ebp)
8010321a:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
8010321e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80103221:	31 c0                	xor    %eax,%eax
80103223:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103224:	89 ca                	mov    %ecx,%edx
80103226:	ec                   	in     (%dx),%al
80103227:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010322a:	89 da                	mov    %ebx,%edx
8010322c:	89 45 d0             	mov    %eax,-0x30(%ebp)
8010322f:	b8 02 00 00 00       	mov    $0x2,%eax
80103234:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103235:	89 ca                	mov    %ecx,%edx
80103237:	ec                   	in     (%dx),%al
80103238:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010323b:	89 da                	mov    %ebx,%edx
8010323d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80103240:	b8 04 00 00 00       	mov    $0x4,%eax
80103245:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103246:	89 ca                	mov    %ecx,%edx
80103248:	ec                   	in     (%dx),%al
80103249:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010324c:	89 da                	mov    %ebx,%edx
8010324e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80103251:	b8 07 00 00 00       	mov    $0x7,%eax
80103256:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103257:	89 ca                	mov    %ecx,%edx
80103259:	ec                   	in     (%dx),%al
8010325a:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010325d:	89 da                	mov    %ebx,%edx
8010325f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80103262:	b8 08 00 00 00       	mov    $0x8,%eax
80103267:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103268:	89 ca                	mov    %ecx,%edx
8010326a:	ec                   	in     (%dx),%al
8010326b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010326e:	89 da                	mov    %ebx,%edx
80103270:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103273:	b8 09 00 00 00       	mov    $0x9,%eax
80103278:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103279:	89 ca                	mov    %ecx,%edx
8010327b:	ec                   	in     (%dx),%al
8010327c:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010327f:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80103282:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103285:	8d 45 d0             	lea    -0x30(%ebp),%eax
80103288:	6a 18                	push   $0x18
8010328a:	50                   	push   %eax
8010328b:	8d 45 b8             	lea    -0x48(%ebp),%eax
8010328e:	50                   	push   %eax
8010328f:	e8 3c 1f 00 00       	call   801051d0 <memcmp>
80103294:	83 c4 10             	add    $0x10,%esp
80103297:	85 c0                	test   %eax,%eax
80103299:	0f 85 f1 fe ff ff    	jne    80103190 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
8010329f:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
801032a3:	75 78                	jne    8010331d <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801032a5:	8b 45 b8             	mov    -0x48(%ebp),%eax
801032a8:	89 c2                	mov    %eax,%edx
801032aa:	83 e0 0f             	and    $0xf,%eax
801032ad:	c1 ea 04             	shr    $0x4,%edx
801032b0:	8d 14 92             	lea    (%edx,%edx,4),%edx
801032b3:	8d 04 50             	lea    (%eax,%edx,2),%eax
801032b6:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801032b9:	8b 45 bc             	mov    -0x44(%ebp),%eax
801032bc:	89 c2                	mov    %eax,%edx
801032be:	83 e0 0f             	and    $0xf,%eax
801032c1:	c1 ea 04             	shr    $0x4,%edx
801032c4:	8d 14 92             	lea    (%edx,%edx,4),%edx
801032c7:	8d 04 50             	lea    (%eax,%edx,2),%eax
801032ca:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801032cd:	8b 45 c0             	mov    -0x40(%ebp),%eax
801032d0:	89 c2                	mov    %eax,%edx
801032d2:	83 e0 0f             	and    $0xf,%eax
801032d5:	c1 ea 04             	shr    $0x4,%edx
801032d8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801032db:	8d 04 50             	lea    (%eax,%edx,2),%eax
801032de:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801032e1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801032e4:	89 c2                	mov    %eax,%edx
801032e6:	83 e0 0f             	and    $0xf,%eax
801032e9:	c1 ea 04             	shr    $0x4,%edx
801032ec:	8d 14 92             	lea    (%edx,%edx,4),%edx
801032ef:	8d 04 50             	lea    (%eax,%edx,2),%eax
801032f2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801032f5:	8b 45 c8             	mov    -0x38(%ebp),%eax
801032f8:	89 c2                	mov    %eax,%edx
801032fa:	83 e0 0f             	and    $0xf,%eax
801032fd:	c1 ea 04             	shr    $0x4,%edx
80103300:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103303:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103306:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80103309:	8b 45 cc             	mov    -0x34(%ebp),%eax
8010330c:	89 c2                	mov    %eax,%edx
8010330e:	83 e0 0f             	and    $0xf,%eax
80103311:	c1 ea 04             	shr    $0x4,%edx
80103314:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103317:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010331a:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
8010331d:	8b 75 08             	mov    0x8(%ebp),%esi
80103320:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103323:	89 06                	mov    %eax,(%esi)
80103325:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103328:	89 46 04             	mov    %eax,0x4(%esi)
8010332b:	8b 45 c0             	mov    -0x40(%ebp),%eax
8010332e:	89 46 08             	mov    %eax,0x8(%esi)
80103331:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103334:	89 46 0c             	mov    %eax,0xc(%esi)
80103337:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010333a:	89 46 10             	mov    %eax,0x10(%esi)
8010333d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103340:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80103343:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
8010334a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010334d:	5b                   	pop    %ebx
8010334e:	5e                   	pop    %esi
8010334f:	5f                   	pop    %edi
80103350:	5d                   	pop    %ebp
80103351:	c3                   	ret    
80103352:	66 90                	xchg   %ax,%ax
80103354:	66 90                	xchg   %ax,%ax
80103356:	66 90                	xchg   %ax,%ax
80103358:	66 90                	xchg   %ax,%ax
8010335a:	66 90                	xchg   %ax,%ax
8010335c:	66 90                	xchg   %ax,%ax
8010335e:	66 90                	xchg   %ax,%ax

80103360 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103360:	8b 0d 48 27 12 80    	mov    0x80122748,%ecx
80103366:	85 c9                	test   %ecx,%ecx
80103368:	0f 8e 8a 00 00 00    	jle    801033f8 <install_trans+0x98>
{
8010336e:	55                   	push   %ebp
8010336f:	89 e5                	mov    %esp,%ebp
80103371:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80103372:	31 ff                	xor    %edi,%edi
{
80103374:	56                   	push   %esi
80103375:	53                   	push   %ebx
80103376:	83 ec 0c             	sub    $0xc,%esp
80103379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103380:	a1 34 27 12 80       	mov    0x80122734,%eax
80103385:	83 ec 08             	sub    $0x8,%esp
80103388:	01 f8                	add    %edi,%eax
8010338a:	83 c0 01             	add    $0x1,%eax
8010338d:	50                   	push   %eax
8010338e:	ff 35 44 27 12 80    	pushl  0x80122744
80103394:	e8 37 cd ff ff       	call   801000d0 <bread>
80103399:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010339b:	58                   	pop    %eax
8010339c:	5a                   	pop    %edx
8010339d:	ff 34 bd 4c 27 12 80 	pushl  -0x7fedd8b4(,%edi,4)
801033a4:	ff 35 44 27 12 80    	pushl  0x80122744
  for (tail = 0; tail < log.lh.n; tail++) {
801033aa:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801033ad:	e8 1e cd ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801033b2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801033b5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801033b7:	8d 46 5c             	lea    0x5c(%esi),%eax
801033ba:	68 00 02 00 00       	push   $0x200
801033bf:	50                   	push   %eax
801033c0:	8d 43 5c             	lea    0x5c(%ebx),%eax
801033c3:	50                   	push   %eax
801033c4:	e8 57 1e 00 00       	call   80105220 <memmove>
    bwrite(dbuf);  // write dst to disk
801033c9:	89 1c 24             	mov    %ebx,(%esp)
801033cc:	e8 df cd ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
801033d1:	89 34 24             	mov    %esi,(%esp)
801033d4:	e8 17 ce ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
801033d9:	89 1c 24             	mov    %ebx,(%esp)
801033dc:	e8 0f ce ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801033e1:	83 c4 10             	add    $0x10,%esp
801033e4:	39 3d 48 27 12 80    	cmp    %edi,0x80122748
801033ea:	7f 94                	jg     80103380 <install_trans+0x20>
  }
}
801033ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033ef:	5b                   	pop    %ebx
801033f0:	5e                   	pop    %esi
801033f1:	5f                   	pop    %edi
801033f2:	5d                   	pop    %ebp
801033f3:	c3                   	ret    
801033f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801033f8:	c3                   	ret    
801033f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103400 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103400:	55                   	push   %ebp
80103401:	89 e5                	mov    %esp,%ebp
80103403:	53                   	push   %ebx
80103404:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80103407:	ff 35 34 27 12 80    	pushl  0x80122734
8010340d:	ff 35 44 27 12 80    	pushl  0x80122744
80103413:	e8 b8 cc ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103418:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
8010341b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
8010341d:	a1 48 27 12 80       	mov    0x80122748,%eax
80103422:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80103425:	85 c0                	test   %eax,%eax
80103427:	7e 19                	jle    80103442 <write_head+0x42>
80103429:	31 d2                	xor    %edx,%edx
8010342b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010342f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80103430:	8b 0c 95 4c 27 12 80 	mov    -0x7fedd8b4(,%edx,4),%ecx
80103437:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010343b:	83 c2 01             	add    $0x1,%edx
8010343e:	39 d0                	cmp    %edx,%eax
80103440:	75 ee                	jne    80103430 <write_head+0x30>
  }
  bwrite(buf);
80103442:	83 ec 0c             	sub    $0xc,%esp
80103445:	53                   	push   %ebx
80103446:	e8 65 cd ff ff       	call   801001b0 <bwrite>
  brelse(buf);
8010344b:	89 1c 24             	mov    %ebx,(%esp)
8010344e:	e8 9d cd ff ff       	call   801001f0 <brelse>
}
80103453:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103456:	83 c4 10             	add    $0x10,%esp
80103459:	c9                   	leave  
8010345a:	c3                   	ret    
8010345b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010345f:	90                   	nop

80103460 <initlog>:
{
80103460:	f3 0f 1e fb          	endbr32 
80103464:	55                   	push   %ebp
80103465:	89 e5                	mov    %esp,%ebp
80103467:	53                   	push   %ebx
80103468:	83 ec 2c             	sub    $0x2c,%esp
8010346b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010346e:	68 60 8c 10 80       	push   $0x80108c60
80103473:	68 00 27 12 80       	push   $0x80122700
80103478:	e8 73 1a 00 00       	call   80104ef0 <initlock>
  readsb(dev, &sb);
8010347d:	58                   	pop    %eax
8010347e:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103481:	5a                   	pop    %edx
80103482:	50                   	push   %eax
80103483:	53                   	push   %ebx
80103484:	e8 37 e4 ff ff       	call   801018c0 <readsb>
  log.start = sb.logstart;
80103489:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
8010348c:	59                   	pop    %ecx
  log.dev = dev;
8010348d:	89 1d 44 27 12 80    	mov    %ebx,0x80122744
  log.size = sb.nlog;
80103493:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103496:	a3 34 27 12 80       	mov    %eax,0x80122734
  log.size = sb.nlog;
8010349b:	89 15 38 27 12 80    	mov    %edx,0x80122738
  struct buf *buf = bread(log.dev, log.start);
801034a1:	5a                   	pop    %edx
801034a2:	50                   	push   %eax
801034a3:	53                   	push   %ebx
801034a4:	e8 27 cc ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
801034a9:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
801034ac:	8b 48 5c             	mov    0x5c(%eax),%ecx
801034af:	89 0d 48 27 12 80    	mov    %ecx,0x80122748
  for (i = 0; i < log.lh.n; i++) {
801034b5:	85 c9                	test   %ecx,%ecx
801034b7:	7e 19                	jle    801034d2 <initlog+0x72>
801034b9:	31 d2                	xor    %edx,%edx
801034bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034bf:	90                   	nop
    log.lh.block[i] = lh->block[i];
801034c0:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
801034c4:	89 1c 95 4c 27 12 80 	mov    %ebx,-0x7fedd8b4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801034cb:	83 c2 01             	add    $0x1,%edx
801034ce:	39 d1                	cmp    %edx,%ecx
801034d0:	75 ee                	jne    801034c0 <initlog+0x60>
  brelse(buf);
801034d2:	83 ec 0c             	sub    $0xc,%esp
801034d5:	50                   	push   %eax
801034d6:	e8 15 cd ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
801034db:	e8 80 fe ff ff       	call   80103360 <install_trans>
  log.lh.n = 0;
801034e0:	c7 05 48 27 12 80 00 	movl   $0x0,0x80122748
801034e7:	00 00 00 
  write_head(); // clear the log
801034ea:	e8 11 ff ff ff       	call   80103400 <write_head>
}
801034ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801034f2:	83 c4 10             	add    $0x10,%esp
801034f5:	c9                   	leave  
801034f6:	c3                   	ret    
801034f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034fe:	66 90                	xchg   %ax,%ax

80103500 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103500:	f3 0f 1e fb          	endbr32 
80103504:	55                   	push   %ebp
80103505:	89 e5                	mov    %esp,%ebp
80103507:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
8010350a:	68 00 27 12 80       	push   $0x80122700
8010350f:	e8 5c 1b 00 00       	call   80105070 <acquire>
80103514:	83 c4 10             	add    $0x10,%esp
80103517:	eb 1c                	jmp    80103535 <begin_op+0x35>
80103519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103520:	83 ec 08             	sub    $0x8,%esp
80103523:	68 00 27 12 80       	push   $0x80122700
80103528:	68 00 27 12 80       	push   $0x80122700
8010352d:	e8 2e 14 00 00       	call   80104960 <sleep>
80103532:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80103535:	a1 40 27 12 80       	mov    0x80122740,%eax
8010353a:	85 c0                	test   %eax,%eax
8010353c:	75 e2                	jne    80103520 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
8010353e:	a1 3c 27 12 80       	mov    0x8012273c,%eax
80103543:	8b 15 48 27 12 80    	mov    0x80122748,%edx
80103549:	83 c0 01             	add    $0x1,%eax
8010354c:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
8010354f:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80103552:	83 fa 1e             	cmp    $0x1e,%edx
80103555:	7f c9                	jg     80103520 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80103557:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
8010355a:	a3 3c 27 12 80       	mov    %eax,0x8012273c
      release(&log.lock);
8010355f:	68 00 27 12 80       	push   $0x80122700
80103564:	e8 c7 1b 00 00       	call   80105130 <release>
      break;
    }
  }
}
80103569:	83 c4 10             	add    $0x10,%esp
8010356c:	c9                   	leave  
8010356d:	c3                   	ret    
8010356e:	66 90                	xchg   %ax,%ax

80103570 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103570:	f3 0f 1e fb          	endbr32 
80103574:	55                   	push   %ebp
80103575:	89 e5                	mov    %esp,%ebp
80103577:	57                   	push   %edi
80103578:	56                   	push   %esi
80103579:	53                   	push   %ebx
8010357a:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
8010357d:	68 00 27 12 80       	push   $0x80122700
80103582:	e8 e9 1a 00 00       	call   80105070 <acquire>
  log.outstanding -= 1;
80103587:	a1 3c 27 12 80       	mov    0x8012273c,%eax
  if(log.committing)
8010358c:	8b 35 40 27 12 80    	mov    0x80122740,%esi
80103592:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103595:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103598:	89 1d 3c 27 12 80    	mov    %ebx,0x8012273c
  if(log.committing)
8010359e:	85 f6                	test   %esi,%esi
801035a0:	0f 85 1e 01 00 00    	jne    801036c4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
801035a6:	85 db                	test   %ebx,%ebx
801035a8:	0f 85 f2 00 00 00    	jne    801036a0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
801035ae:	c7 05 40 27 12 80 01 	movl   $0x1,0x80122740
801035b5:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
801035b8:	83 ec 0c             	sub    $0xc,%esp
801035bb:	68 00 27 12 80       	push   $0x80122700
801035c0:	e8 6b 1b 00 00       	call   80105130 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
801035c5:	8b 0d 48 27 12 80    	mov    0x80122748,%ecx
801035cb:	83 c4 10             	add    $0x10,%esp
801035ce:	85 c9                	test   %ecx,%ecx
801035d0:	7f 3e                	jg     80103610 <end_op+0xa0>
    acquire(&log.lock);
801035d2:	83 ec 0c             	sub    $0xc,%esp
801035d5:	68 00 27 12 80       	push   $0x80122700
801035da:	e8 91 1a 00 00       	call   80105070 <acquire>
    wakeup(&log);
801035df:	c7 04 24 00 27 12 80 	movl   $0x80122700,(%esp)
    log.committing = 0;
801035e6:	c7 05 40 27 12 80 00 	movl   $0x0,0x80122740
801035ed:	00 00 00 
    wakeup(&log);
801035f0:	e8 cb 15 00 00       	call   80104bc0 <wakeup>
    release(&log.lock);
801035f5:	c7 04 24 00 27 12 80 	movl   $0x80122700,(%esp)
801035fc:	e8 2f 1b 00 00       	call   80105130 <release>
80103601:	83 c4 10             	add    $0x10,%esp
}
80103604:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103607:	5b                   	pop    %ebx
80103608:	5e                   	pop    %esi
80103609:	5f                   	pop    %edi
8010360a:	5d                   	pop    %ebp
8010360b:	c3                   	ret    
8010360c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103610:	a1 34 27 12 80       	mov    0x80122734,%eax
80103615:	83 ec 08             	sub    $0x8,%esp
80103618:	01 d8                	add    %ebx,%eax
8010361a:	83 c0 01             	add    $0x1,%eax
8010361d:	50                   	push   %eax
8010361e:	ff 35 44 27 12 80    	pushl  0x80122744
80103624:	e8 a7 ca ff ff       	call   801000d0 <bread>
80103629:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010362b:	58                   	pop    %eax
8010362c:	5a                   	pop    %edx
8010362d:	ff 34 9d 4c 27 12 80 	pushl  -0x7fedd8b4(,%ebx,4)
80103634:	ff 35 44 27 12 80    	pushl  0x80122744
  for (tail = 0; tail < log.lh.n; tail++) {
8010363a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010363d:	e8 8e ca ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103642:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103645:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103647:	8d 40 5c             	lea    0x5c(%eax),%eax
8010364a:	68 00 02 00 00       	push   $0x200
8010364f:	50                   	push   %eax
80103650:	8d 46 5c             	lea    0x5c(%esi),%eax
80103653:	50                   	push   %eax
80103654:	e8 c7 1b 00 00       	call   80105220 <memmove>
    bwrite(to);  // write the log
80103659:	89 34 24             	mov    %esi,(%esp)
8010365c:	e8 4f cb ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103661:	89 3c 24             	mov    %edi,(%esp)
80103664:	e8 87 cb ff ff       	call   801001f0 <brelse>
    brelse(to);
80103669:	89 34 24             	mov    %esi,(%esp)
8010366c:	e8 7f cb ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103671:	83 c4 10             	add    $0x10,%esp
80103674:	3b 1d 48 27 12 80    	cmp    0x80122748,%ebx
8010367a:	7c 94                	jl     80103610 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010367c:	e8 7f fd ff ff       	call   80103400 <write_head>
    install_trans(); // Now install writes to home locations
80103681:	e8 da fc ff ff       	call   80103360 <install_trans>
    log.lh.n = 0;
80103686:	c7 05 48 27 12 80 00 	movl   $0x0,0x80122748
8010368d:	00 00 00 
    write_head();    // Erase the transaction from the log
80103690:	e8 6b fd ff ff       	call   80103400 <write_head>
80103695:	e9 38 ff ff ff       	jmp    801035d2 <end_op+0x62>
8010369a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
801036a0:	83 ec 0c             	sub    $0xc,%esp
801036a3:	68 00 27 12 80       	push   $0x80122700
801036a8:	e8 13 15 00 00       	call   80104bc0 <wakeup>
  release(&log.lock);
801036ad:	c7 04 24 00 27 12 80 	movl   $0x80122700,(%esp)
801036b4:	e8 77 1a 00 00       	call   80105130 <release>
801036b9:	83 c4 10             	add    $0x10,%esp
}
801036bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036bf:	5b                   	pop    %ebx
801036c0:	5e                   	pop    %esi
801036c1:	5f                   	pop    %edi
801036c2:	5d                   	pop    %ebp
801036c3:	c3                   	ret    
    panic("log.committing");
801036c4:	83 ec 0c             	sub    $0xc,%esp
801036c7:	68 64 8c 10 80       	push   $0x80108c64
801036cc:	e8 bf cc ff ff       	call   80100390 <panic>
801036d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036df:	90                   	nop

801036e0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801036e0:	f3 0f 1e fb          	endbr32 
801036e4:	55                   	push   %ebp
801036e5:	89 e5                	mov    %esp,%ebp
801036e7:	53                   	push   %ebx
801036e8:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801036eb:	8b 15 48 27 12 80    	mov    0x80122748,%edx
{
801036f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801036f4:	83 fa 1d             	cmp    $0x1d,%edx
801036f7:	0f 8f 91 00 00 00    	jg     8010378e <log_write+0xae>
801036fd:	a1 38 27 12 80       	mov    0x80122738,%eax
80103702:	83 e8 01             	sub    $0x1,%eax
80103705:	39 c2                	cmp    %eax,%edx
80103707:	0f 8d 81 00 00 00    	jge    8010378e <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
8010370d:	a1 3c 27 12 80       	mov    0x8012273c,%eax
80103712:	85 c0                	test   %eax,%eax
80103714:	0f 8e 81 00 00 00    	jle    8010379b <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010371a:	83 ec 0c             	sub    $0xc,%esp
8010371d:	68 00 27 12 80       	push   $0x80122700
80103722:	e8 49 19 00 00       	call   80105070 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103727:	8b 15 48 27 12 80    	mov    0x80122748,%edx
8010372d:	83 c4 10             	add    $0x10,%esp
80103730:	85 d2                	test   %edx,%edx
80103732:	7e 4e                	jle    80103782 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103734:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80103737:	31 c0                	xor    %eax,%eax
80103739:	eb 0c                	jmp    80103747 <log_write+0x67>
8010373b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010373f:	90                   	nop
80103740:	83 c0 01             	add    $0x1,%eax
80103743:	39 c2                	cmp    %eax,%edx
80103745:	74 29                	je     80103770 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103747:	39 0c 85 4c 27 12 80 	cmp    %ecx,-0x7fedd8b4(,%eax,4)
8010374e:	75 f0                	jne    80103740 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103750:	89 0c 85 4c 27 12 80 	mov    %ecx,-0x7fedd8b4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103757:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010375a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010375d:	c7 45 08 00 27 12 80 	movl   $0x80122700,0x8(%ebp)
}
80103764:	c9                   	leave  
  release(&log.lock);
80103765:	e9 c6 19 00 00       	jmp    80105130 <release>
8010376a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103770:	89 0c 95 4c 27 12 80 	mov    %ecx,-0x7fedd8b4(,%edx,4)
    log.lh.n++;
80103777:	83 c2 01             	add    $0x1,%edx
8010377a:	89 15 48 27 12 80    	mov    %edx,0x80122748
80103780:	eb d5                	jmp    80103757 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80103782:	8b 43 08             	mov    0x8(%ebx),%eax
80103785:	a3 4c 27 12 80       	mov    %eax,0x8012274c
  if (i == log.lh.n)
8010378a:	75 cb                	jne    80103757 <log_write+0x77>
8010378c:	eb e9                	jmp    80103777 <log_write+0x97>
    panic("too big a transaction");
8010378e:	83 ec 0c             	sub    $0xc,%esp
80103791:	68 73 8c 10 80       	push   $0x80108c73
80103796:	e8 f5 cb ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
8010379b:	83 ec 0c             	sub    $0xc,%esp
8010379e:	68 89 8c 10 80       	push   $0x80108c89
801037a3:	e8 e8 cb ff ff       	call   80100390 <panic>
801037a8:	66 90                	xchg   %ax,%ax
801037aa:	66 90                	xchg   %ax,%ax
801037ac:	66 90                	xchg   %ax,%ax
801037ae:	66 90                	xchg   %ax,%ax

801037b0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801037b0:	55                   	push   %ebp
801037b1:	89 e5                	mov    %esp,%ebp
801037b3:	53                   	push   %ebx
801037b4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801037b7:	e8 e4 09 00 00       	call   801041a0 <cpuid>
801037bc:	89 c3                	mov    %eax,%ebx
801037be:	e8 dd 09 00 00       	call   801041a0 <cpuid>
801037c3:	83 ec 04             	sub    $0x4,%esp
801037c6:	53                   	push   %ebx
801037c7:	50                   	push   %eax
801037c8:	68 a4 8c 10 80       	push   $0x80108ca4
801037cd:	e8 de ce ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
801037d2:	e8 79 2c 00 00       	call   80106450 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801037d7:	e8 44 09 00 00       	call   80104120 <mycpu>
801037dc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801037de:	b8 01 00 00 00       	mov    $0x1,%eax
801037e3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801037ea:	e8 81 0e 00 00       	call   80104670 <scheduler>
801037ef:	90                   	nop

801037f0 <mpenter>:
{
801037f0:	f3 0f 1e fb          	endbr32 
801037f4:	55                   	push   %ebp
801037f5:	89 e5                	mov    %esp,%ebp
801037f7:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801037fa:	e8 a1 40 00 00       	call   801078a0 <switchkvm>
  seginit();
801037ff:	e8 ec 3f 00 00       	call   801077f0 <seginit>
  lapicinit();
80103804:	e8 67 f7 ff ff       	call   80102f70 <lapicinit>
  mpmain();
80103809:	e8 a2 ff ff ff       	call   801037b0 <mpmain>
8010380e:	66 90                	xchg   %ax,%ax

80103810 <main>:
{
80103810:	f3 0f 1e fb          	endbr32 
80103814:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103818:	83 e4 f0             	and    $0xfffffff0,%esp
8010381b:	ff 71 fc             	pushl  -0x4(%ecx)
8010381e:	55                   	push   %ebp
8010381f:	89 e5                	mov    %esp,%ebp
80103821:	53                   	push   %ebx
80103822:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103823:	83 ec 08             	sub    $0x8,%esp
80103826:	68 00 00 40 80       	push   $0x80400000
8010382b:	68 28 1a 13 80       	push   $0x80131a28
80103830:	e8 db f4 ff ff       	call   80102d10 <kinit1>
  kvmalloc();      // kernel page table
80103835:	e8 86 45 00 00       	call   80107dc0 <kvmalloc>
  mpinit();        // detect other processors
8010383a:	e8 91 01 00 00       	call   801039d0 <mpinit>
  lapicinit();     // interrupt controller
8010383f:	e8 2c f7 ff ff       	call   80102f70 <lapicinit>
  init_cow();
80103844:	e8 67 f3 ff ff       	call   80102bb0 <init_cow>
  seginit();       // segment descriptors
80103849:	e8 a2 3f 00 00       	call   801077f0 <seginit>
  picinit();       // disable pic
8010384e:	e8 5d 03 00 00       	call   80103bb0 <picinit>
  ioapicinit();    // another interrupt controller
80103853:	e8 68 f2 ff ff       	call   80102ac0 <ioapicinit>
  consoleinit();   // console hardware
80103858:	e8 d3 d1 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
8010385d:	e8 6e 30 00 00       	call   801068d0 <uartinit>
  pinit();         // process table
80103862:	e8 99 08 00 00       	call   80104100 <pinit>
  tvinit();        // trap vectors
80103867:	e8 64 2b 00 00       	call   801063d0 <tvinit>
  binit();         // buffer cache
8010386c:	e8 cf c7 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103871:	e8 2a d9 ff ff       	call   801011a0 <fileinit>
  ideinit();       // disk 
80103876:	e8 15 f0 ff ff       	call   80102890 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
8010387b:	83 c4 0c             	add    $0xc,%esp
8010387e:	68 8a 00 00 00       	push   $0x8a
80103883:	68 8c c4 10 80       	push   $0x8010c48c
80103888:	68 00 70 00 80       	push   $0x80007000
8010388d:	e8 8e 19 00 00       	call   80105220 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103892:	83 c4 10             	add    $0x10,%esp
80103895:	69 05 80 2d 12 80 b0 	imul   $0xb0,0x80122d80,%eax
8010389c:	00 00 00 
8010389f:	05 00 28 12 80       	add    $0x80122800,%eax
801038a4:	3d 00 28 12 80       	cmp    $0x80122800,%eax
801038a9:	76 7d                	jbe    80103928 <main+0x118>
801038ab:	bb 00 28 12 80       	mov    $0x80122800,%ebx
801038b0:	eb 1f                	jmp    801038d1 <main+0xc1>
801038b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801038b8:	69 05 80 2d 12 80 b0 	imul   $0xb0,0x80122d80,%eax
801038bf:	00 00 00 
801038c2:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801038c8:	05 00 28 12 80       	add    $0x80122800,%eax
801038cd:	39 c3                	cmp    %eax,%ebx
801038cf:	73 57                	jae    80103928 <main+0x118>
    if(c == mycpu())  // We've started already.
801038d1:	e8 4a 08 00 00       	call   80104120 <mycpu>
801038d6:	39 c3                	cmp    %eax,%ebx
801038d8:	74 de                	je     801038b8 <main+0xa8>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = cow_kalloc();
801038da:	e8 11 3c 00 00       	call   801074f0 <cow_kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801038df:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
801038e2:	c7 05 f8 6f 00 80 f0 	movl   $0x801037f0,0x80006ff8
801038e9:	37 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801038ec:	c7 05 f4 6f 00 80 00 	movl   $0x10b000,0x80006ff4
801038f3:	b0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801038f6:	05 00 10 00 00       	add    $0x1000,%eax
801038fb:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103900:	0f b6 03             	movzbl (%ebx),%eax
80103903:	68 00 70 00 00       	push   $0x7000
80103908:	50                   	push   %eax
80103909:	e8 b2 f7 ff ff       	call   801030c0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
8010390e:	83 c4 10             	add    $0x10,%esp
80103911:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103918:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
8010391e:	85 c0                	test   %eax,%eax
80103920:	74 f6                	je     80103918 <main+0x108>
80103922:	eb 94                	jmp    801038b8 <main+0xa8>
80103924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103928:	83 ec 08             	sub    $0x8,%esp
8010392b:	68 00 00 00 8e       	push   $0x8e000000
80103930:	68 00 00 40 80       	push   $0x80400000
80103935:	e8 56 f4 ff ff       	call   80102d90 <kinit2>
  userinit();      // first user process
8010393a:	e8 b1 08 00 00       	call   801041f0 <userinit>
  mpmain();        // finish this processor's setup
8010393f:	e8 6c fe ff ff       	call   801037b0 <mpmain>
80103944:	66 90                	xchg   %ax,%ax
80103946:	66 90                	xchg   %ax,%ax
80103948:	66 90                	xchg   %ax,%ax
8010394a:	66 90                	xchg   %ax,%ax
8010394c:	66 90                	xchg   %ax,%ax
8010394e:	66 90                	xchg   %ax,%ax

80103950 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103950:	55                   	push   %ebp
80103951:	89 e5                	mov    %esp,%ebp
80103953:	57                   	push   %edi
80103954:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103955:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010395b:	53                   	push   %ebx
  e = addr+len;
8010395c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010395f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103962:	39 de                	cmp    %ebx,%esi
80103964:	72 10                	jb     80103976 <mpsearch1+0x26>
80103966:	eb 50                	jmp    801039b8 <mpsearch1+0x68>
80103968:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010396f:	90                   	nop
80103970:	89 fe                	mov    %edi,%esi
80103972:	39 fb                	cmp    %edi,%ebx
80103974:	76 42                	jbe    801039b8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103976:	83 ec 04             	sub    $0x4,%esp
80103979:	8d 7e 10             	lea    0x10(%esi),%edi
8010397c:	6a 04                	push   $0x4
8010397e:	68 b8 8c 10 80       	push   $0x80108cb8
80103983:	56                   	push   %esi
80103984:	e8 47 18 00 00       	call   801051d0 <memcmp>
80103989:	83 c4 10             	add    $0x10,%esp
8010398c:	85 c0                	test   %eax,%eax
8010398e:	75 e0                	jne    80103970 <mpsearch1+0x20>
80103990:	89 f2                	mov    %esi,%edx
80103992:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103998:	0f b6 0a             	movzbl (%edx),%ecx
8010399b:	83 c2 01             	add    $0x1,%edx
8010399e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801039a0:	39 fa                	cmp    %edi,%edx
801039a2:	75 f4                	jne    80103998 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801039a4:	84 c0                	test   %al,%al
801039a6:	75 c8                	jne    80103970 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801039a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039ab:	89 f0                	mov    %esi,%eax
801039ad:	5b                   	pop    %ebx
801039ae:	5e                   	pop    %esi
801039af:	5f                   	pop    %edi
801039b0:	5d                   	pop    %ebp
801039b1:	c3                   	ret    
801039b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801039b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801039bb:	31 f6                	xor    %esi,%esi
}
801039bd:	5b                   	pop    %ebx
801039be:	89 f0                	mov    %esi,%eax
801039c0:	5e                   	pop    %esi
801039c1:	5f                   	pop    %edi
801039c2:	5d                   	pop    %ebp
801039c3:	c3                   	ret    
801039c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039cf:	90                   	nop

801039d0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801039d0:	f3 0f 1e fb          	endbr32 
801039d4:	55                   	push   %ebp
801039d5:	89 e5                	mov    %esp,%ebp
801039d7:	57                   	push   %edi
801039d8:	56                   	push   %esi
801039d9:	53                   	push   %ebx
801039da:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801039dd:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801039e4:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801039eb:	c1 e0 08             	shl    $0x8,%eax
801039ee:	09 d0                	or     %edx,%eax
801039f0:	c1 e0 04             	shl    $0x4,%eax
801039f3:	75 1b                	jne    80103a10 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801039f5:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801039fc:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103a03:	c1 e0 08             	shl    $0x8,%eax
80103a06:	09 d0                	or     %edx,%eax
80103a08:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103a0b:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103a10:	ba 00 04 00 00       	mov    $0x400,%edx
80103a15:	e8 36 ff ff ff       	call   80103950 <mpsearch1>
80103a1a:	89 c6                	mov    %eax,%esi
80103a1c:	85 c0                	test   %eax,%eax
80103a1e:	0f 84 4c 01 00 00    	je     80103b70 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103a24:	8b 5e 04             	mov    0x4(%esi),%ebx
80103a27:	85 db                	test   %ebx,%ebx
80103a29:	0f 84 61 01 00 00    	je     80103b90 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
80103a2f:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103a32:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103a38:	6a 04                	push   $0x4
80103a3a:	68 bd 8c 10 80       	push   $0x80108cbd
80103a3f:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103a40:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103a43:	e8 88 17 00 00       	call   801051d0 <memcmp>
80103a48:	83 c4 10             	add    $0x10,%esp
80103a4b:	85 c0                	test   %eax,%eax
80103a4d:	0f 85 3d 01 00 00    	jne    80103b90 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
80103a53:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103a5a:	3c 01                	cmp    $0x1,%al
80103a5c:	74 08                	je     80103a66 <mpinit+0x96>
80103a5e:	3c 04                	cmp    $0x4,%al
80103a60:	0f 85 2a 01 00 00    	jne    80103b90 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
80103a66:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
80103a6d:	66 85 d2             	test   %dx,%dx
80103a70:	74 26                	je     80103a98 <mpinit+0xc8>
80103a72:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
80103a75:	89 d8                	mov    %ebx,%eax
  sum = 0;
80103a77:	31 d2                	xor    %edx,%edx
80103a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103a80:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
80103a87:	83 c0 01             	add    $0x1,%eax
80103a8a:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103a8c:	39 f8                	cmp    %edi,%eax
80103a8e:	75 f0                	jne    80103a80 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
80103a90:	84 d2                	test   %dl,%dl
80103a92:	0f 85 f8 00 00 00    	jne    80103b90 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103a98:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103a9e:	a3 f4 26 12 80       	mov    %eax,0x801226f4
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103aa3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80103aa9:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
80103ab0:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103ab5:	03 55 e4             	add    -0x1c(%ebp),%edx
80103ab8:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103abb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103abf:	90                   	nop
80103ac0:	39 c2                	cmp    %eax,%edx
80103ac2:	76 15                	jbe    80103ad9 <mpinit+0x109>
    switch(*p){
80103ac4:	0f b6 08             	movzbl (%eax),%ecx
80103ac7:	80 f9 02             	cmp    $0x2,%cl
80103aca:	74 5c                	je     80103b28 <mpinit+0x158>
80103acc:	77 42                	ja     80103b10 <mpinit+0x140>
80103ace:	84 c9                	test   %cl,%cl
80103ad0:	74 6e                	je     80103b40 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103ad2:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103ad5:	39 c2                	cmp    %eax,%edx
80103ad7:	77 eb                	ja     80103ac4 <mpinit+0xf4>
80103ad9:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103adc:	85 db                	test   %ebx,%ebx
80103ade:	0f 84 b9 00 00 00    	je     80103b9d <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103ae4:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103ae8:	74 15                	je     80103aff <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103aea:	b8 70 00 00 00       	mov    $0x70,%eax
80103aef:	ba 22 00 00 00       	mov    $0x22,%edx
80103af4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103af5:	ba 23 00 00 00       	mov    $0x23,%edx
80103afa:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103afb:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103afe:	ee                   	out    %al,(%dx)
  }
}
80103aff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b02:	5b                   	pop    %ebx
80103b03:	5e                   	pop    %esi
80103b04:	5f                   	pop    %edi
80103b05:	5d                   	pop    %ebp
80103b06:	c3                   	ret    
80103b07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b0e:	66 90                	xchg   %ax,%ax
    switch(*p){
80103b10:	83 e9 03             	sub    $0x3,%ecx
80103b13:	80 f9 01             	cmp    $0x1,%cl
80103b16:	76 ba                	jbe    80103ad2 <mpinit+0x102>
80103b18:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80103b1f:	eb 9f                	jmp    80103ac0 <mpinit+0xf0>
80103b21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103b28:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103b2c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103b2f:	88 0d e0 27 12 80    	mov    %cl,0x801227e0
      continue;
80103b35:	eb 89                	jmp    80103ac0 <mpinit+0xf0>
80103b37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b3e:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103b40:	8b 0d 80 2d 12 80    	mov    0x80122d80,%ecx
80103b46:	83 f9 07             	cmp    $0x7,%ecx
80103b49:	7f 19                	jg     80103b64 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103b4b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103b51:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103b55:	83 c1 01             	add    $0x1,%ecx
80103b58:	89 0d 80 2d 12 80    	mov    %ecx,0x80122d80
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103b5e:	88 9f 00 28 12 80    	mov    %bl,-0x7fedd800(%edi)
      p += sizeof(struct mpproc);
80103b64:	83 c0 14             	add    $0x14,%eax
      continue;
80103b67:	e9 54 ff ff ff       	jmp    80103ac0 <mpinit+0xf0>
80103b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
80103b70:	ba 00 00 01 00       	mov    $0x10000,%edx
80103b75:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103b7a:	e8 d1 fd ff ff       	call   80103950 <mpsearch1>
80103b7f:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103b81:	85 c0                	test   %eax,%eax
80103b83:	0f 85 9b fe ff ff    	jne    80103a24 <mpinit+0x54>
80103b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103b90:	83 ec 0c             	sub    $0xc,%esp
80103b93:	68 c2 8c 10 80       	push   $0x80108cc2
80103b98:	e8 f3 c7 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
80103b9d:	83 ec 0c             	sub    $0xc,%esp
80103ba0:	68 dc 8c 10 80       	push   $0x80108cdc
80103ba5:	e8 e6 c7 ff ff       	call   80100390 <panic>
80103baa:	66 90                	xchg   %ax,%ax
80103bac:	66 90                	xchg   %ax,%ax
80103bae:	66 90                	xchg   %ax,%ax

80103bb0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103bb0:	f3 0f 1e fb          	endbr32 
80103bb4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103bb9:	ba 21 00 00 00       	mov    $0x21,%edx
80103bbe:	ee                   	out    %al,(%dx)
80103bbf:	ba a1 00 00 00       	mov    $0xa1,%edx
80103bc4:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103bc5:	c3                   	ret    
80103bc6:	66 90                	xchg   %ax,%ax
80103bc8:	66 90                	xchg   %ax,%ax
80103bca:	66 90                	xchg   %ax,%ax
80103bcc:	66 90                	xchg   %ax,%ax
80103bce:	66 90                	xchg   %ax,%ax

80103bd0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103bd0:	f3 0f 1e fb          	endbr32 
80103bd4:	55                   	push   %ebp
80103bd5:	89 e5                	mov    %esp,%ebp
80103bd7:	57                   	push   %edi
80103bd8:	56                   	push   %esi
80103bd9:	53                   	push   %ebx
80103bda:	83 ec 0c             	sub    $0xc,%esp
80103bdd:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103be0:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103be3:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103be9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103bef:	e8 cc d5 ff ff       	call   801011c0 <filealloc>
80103bf4:	89 03                	mov    %eax,(%ebx)
80103bf6:	85 c0                	test   %eax,%eax
80103bf8:	0f 84 ac 00 00 00    	je     80103caa <pipealloc+0xda>
80103bfe:	e8 bd d5 ff ff       	call   801011c0 <filealloc>
80103c03:	89 06                	mov    %eax,(%esi)
80103c05:	85 c0                	test   %eax,%eax
80103c07:	0f 84 8b 00 00 00    	je     80103c98 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)cow_kalloc()) == 0)
80103c0d:	e8 de 38 00 00       	call   801074f0 <cow_kalloc>
80103c12:	89 c7                	mov    %eax,%edi
80103c14:	85 c0                	test   %eax,%eax
80103c16:	0f 84 b4 00 00 00    	je     80103cd0 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
80103c1c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103c23:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103c26:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103c29:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103c30:	00 00 00 
  p->nwrite = 0;
80103c33:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103c3a:	00 00 00 
  p->nread = 0;
80103c3d:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103c44:	00 00 00 
  initlock(&p->lock, "pipe");
80103c47:	68 fb 8c 10 80       	push   $0x80108cfb
80103c4c:	50                   	push   %eax
80103c4d:	e8 9e 12 00 00       	call   80104ef0 <initlock>
  (*f0)->type = FD_PIPE;
80103c52:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103c54:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103c57:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103c5d:	8b 03                	mov    (%ebx),%eax
80103c5f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103c63:	8b 03                	mov    (%ebx),%eax
80103c65:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103c69:	8b 03                	mov    (%ebx),%eax
80103c6b:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103c6e:	8b 06                	mov    (%esi),%eax
80103c70:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103c76:	8b 06                	mov    (%esi),%eax
80103c78:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103c7c:	8b 06                	mov    (%esi),%eax
80103c7e:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103c82:	8b 06                	mov    (%esi),%eax
80103c84:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103c87:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103c8a:	31 c0                	xor    %eax,%eax
}
80103c8c:	5b                   	pop    %ebx
80103c8d:	5e                   	pop    %esi
80103c8e:	5f                   	pop    %edi
80103c8f:	5d                   	pop    %ebp
80103c90:	c3                   	ret    
80103c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103c98:	8b 03                	mov    (%ebx),%eax
80103c9a:	85 c0                	test   %eax,%eax
80103c9c:	74 1e                	je     80103cbc <pipealloc+0xec>
    fileclose(*f0);
80103c9e:	83 ec 0c             	sub    $0xc,%esp
80103ca1:	50                   	push   %eax
80103ca2:	e8 d9 d5 ff ff       	call   80101280 <fileclose>
80103ca7:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103caa:	8b 06                	mov    (%esi),%eax
80103cac:	85 c0                	test   %eax,%eax
80103cae:	74 0c                	je     80103cbc <pipealloc+0xec>
    fileclose(*f1);
80103cb0:	83 ec 0c             	sub    $0xc,%esp
80103cb3:	50                   	push   %eax
80103cb4:	e8 c7 d5 ff ff       	call   80101280 <fileclose>
80103cb9:	83 c4 10             	add    $0x10,%esp
}
80103cbc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103cbf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103cc4:	5b                   	pop    %ebx
80103cc5:	5e                   	pop    %esi
80103cc6:	5f                   	pop    %edi
80103cc7:	5d                   	pop    %ebp
80103cc8:	c3                   	ret    
80103cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103cd0:	8b 03                	mov    (%ebx),%eax
80103cd2:	85 c0                	test   %eax,%eax
80103cd4:	75 c8                	jne    80103c9e <pipealloc+0xce>
80103cd6:	eb d2                	jmp    80103caa <pipealloc+0xda>
80103cd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cdf:	90                   	nop

80103ce0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103ce0:	f3 0f 1e fb          	endbr32 
80103ce4:	55                   	push   %ebp
80103ce5:	89 e5                	mov    %esp,%ebp
80103ce7:	56                   	push   %esi
80103ce8:	53                   	push   %ebx
80103ce9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103cec:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80103cef:	83 ec 0c             	sub    $0xc,%esp
80103cf2:	53                   	push   %ebx
80103cf3:	e8 78 13 00 00       	call   80105070 <acquire>
  if(writable){
80103cf8:	83 c4 10             	add    $0x10,%esp
80103cfb:	85 f6                	test   %esi,%esi
80103cfd:	74 41                	je     80103d40 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
80103cff:	83 ec 0c             	sub    $0xc,%esp
80103d02:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103d08:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103d0f:	00 00 00 
    wakeup(&p->nread);
80103d12:	50                   	push   %eax
80103d13:	e8 a8 0e 00 00       	call   80104bc0 <wakeup>
80103d18:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103d1b:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103d21:	85 d2                	test   %edx,%edx
80103d23:	75 0a                	jne    80103d2f <pipeclose+0x4f>
80103d25:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103d2b:	85 c0                	test   %eax,%eax
80103d2d:	74 31                	je     80103d60 <pipeclose+0x80>
    release(&p->lock);
    cow_kfree((char*)p);
  } else
    release(&p->lock);
80103d2f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103d32:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d35:	5b                   	pop    %ebx
80103d36:	5e                   	pop    %esi
80103d37:	5d                   	pop    %ebp
    release(&p->lock);
80103d38:	e9 f3 13 00 00       	jmp    80105130 <release>
80103d3d:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103d40:	83 ec 0c             	sub    $0xc,%esp
80103d43:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103d49:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103d50:	00 00 00 
    wakeup(&p->nwrite);
80103d53:	50                   	push   %eax
80103d54:	e8 67 0e 00 00       	call   80104bc0 <wakeup>
80103d59:	83 c4 10             	add    $0x10,%esp
80103d5c:	eb bd                	jmp    80103d1b <pipeclose+0x3b>
80103d5e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103d60:	83 ec 0c             	sub    $0xc,%esp
80103d63:	53                   	push   %ebx
80103d64:	e8 c7 13 00 00       	call   80105130 <release>
    cow_kfree((char*)p);
80103d69:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103d6c:	83 c4 10             	add    $0x10,%esp
}
80103d6f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d72:	5b                   	pop    %ebx
80103d73:	5e                   	pop    %esi
80103d74:	5d                   	pop    %ebp
    cow_kfree((char*)p);
80103d75:	e9 d6 36 00 00       	jmp    80107450 <cow_kfree>
80103d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103d80 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103d80:	f3 0f 1e fb          	endbr32 
80103d84:	55                   	push   %ebp
80103d85:	89 e5                	mov    %esp,%ebp
80103d87:	57                   	push   %edi
80103d88:	56                   	push   %esi
80103d89:	53                   	push   %ebx
80103d8a:	83 ec 28             	sub    $0x28,%esp
80103d8d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103d90:	53                   	push   %ebx
80103d91:	e8 da 12 00 00       	call   80105070 <acquire>
  for(i = 0; i < n; i++){
80103d96:	8b 45 10             	mov    0x10(%ebp),%eax
80103d99:	83 c4 10             	add    $0x10,%esp
80103d9c:	85 c0                	test   %eax,%eax
80103d9e:	0f 8e bc 00 00 00    	jle    80103e60 <pipewrite+0xe0>
80103da4:	8b 45 0c             	mov    0xc(%ebp),%eax
80103da7:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103dad:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103db3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103db6:	03 45 10             	add    0x10(%ebp),%eax
80103db9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103dbc:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103dc2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103dc8:	89 ca                	mov    %ecx,%edx
80103dca:	05 00 02 00 00       	add    $0x200,%eax
80103dcf:	39 c1                	cmp    %eax,%ecx
80103dd1:	74 3b                	je     80103e0e <pipewrite+0x8e>
80103dd3:	eb 63                	jmp    80103e38 <pipewrite+0xb8>
80103dd5:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103dd8:	e8 e3 03 00 00       	call   801041c0 <myproc>
80103ddd:	8b 48 24             	mov    0x24(%eax),%ecx
80103de0:	85 c9                	test   %ecx,%ecx
80103de2:	75 34                	jne    80103e18 <pipewrite+0x98>
      wakeup(&p->nread);
80103de4:	83 ec 0c             	sub    $0xc,%esp
80103de7:	57                   	push   %edi
80103de8:	e8 d3 0d 00 00       	call   80104bc0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103ded:	58                   	pop    %eax
80103dee:	5a                   	pop    %edx
80103def:	53                   	push   %ebx
80103df0:	56                   	push   %esi
80103df1:	e8 6a 0b 00 00       	call   80104960 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103df6:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103dfc:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103e02:	83 c4 10             	add    $0x10,%esp
80103e05:	05 00 02 00 00       	add    $0x200,%eax
80103e0a:	39 c2                	cmp    %eax,%edx
80103e0c:	75 2a                	jne    80103e38 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
80103e0e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103e14:	85 c0                	test   %eax,%eax
80103e16:	75 c0                	jne    80103dd8 <pipewrite+0x58>
        release(&p->lock);
80103e18:	83 ec 0c             	sub    $0xc,%esp
80103e1b:	53                   	push   %ebx
80103e1c:	e8 0f 13 00 00       	call   80105130 <release>
        return -1;
80103e21:	83 c4 10             	add    $0x10,%esp
80103e24:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103e29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e2c:	5b                   	pop    %ebx
80103e2d:	5e                   	pop    %esi
80103e2e:	5f                   	pop    %edi
80103e2f:	5d                   	pop    %ebp
80103e30:	c3                   	ret    
80103e31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103e38:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103e3b:	8d 4a 01             	lea    0x1(%edx),%ecx
80103e3e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103e44:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
80103e4a:	0f b6 06             	movzbl (%esi),%eax
80103e4d:	83 c6 01             	add    $0x1,%esi
80103e50:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103e53:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103e57:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103e5a:	0f 85 5c ff ff ff    	jne    80103dbc <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103e60:	83 ec 0c             	sub    $0xc,%esp
80103e63:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103e69:	50                   	push   %eax
80103e6a:	e8 51 0d 00 00       	call   80104bc0 <wakeup>
  release(&p->lock);
80103e6f:	89 1c 24             	mov    %ebx,(%esp)
80103e72:	e8 b9 12 00 00       	call   80105130 <release>
  return n;
80103e77:	8b 45 10             	mov    0x10(%ebp),%eax
80103e7a:	83 c4 10             	add    $0x10,%esp
80103e7d:	eb aa                	jmp    80103e29 <pipewrite+0xa9>
80103e7f:	90                   	nop

80103e80 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103e80:	f3 0f 1e fb          	endbr32 
80103e84:	55                   	push   %ebp
80103e85:	89 e5                	mov    %esp,%ebp
80103e87:	57                   	push   %edi
80103e88:	56                   	push   %esi
80103e89:	53                   	push   %ebx
80103e8a:	83 ec 18             	sub    $0x18,%esp
80103e8d:	8b 75 08             	mov    0x8(%ebp),%esi
80103e90:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103e93:	56                   	push   %esi
80103e94:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103e9a:	e8 d1 11 00 00       	call   80105070 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103e9f:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103ea5:	83 c4 10             	add    $0x10,%esp
80103ea8:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
80103eae:	74 33                	je     80103ee3 <piperead+0x63>
80103eb0:	eb 3b                	jmp    80103eed <piperead+0x6d>
80103eb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
80103eb8:	e8 03 03 00 00       	call   801041c0 <myproc>
80103ebd:	8b 48 24             	mov    0x24(%eax),%ecx
80103ec0:	85 c9                	test   %ecx,%ecx
80103ec2:	0f 85 88 00 00 00    	jne    80103f50 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103ec8:	83 ec 08             	sub    $0x8,%esp
80103ecb:	56                   	push   %esi
80103ecc:	53                   	push   %ebx
80103ecd:	e8 8e 0a 00 00       	call   80104960 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103ed2:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103ed8:	83 c4 10             	add    $0x10,%esp
80103edb:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103ee1:	75 0a                	jne    80103eed <piperead+0x6d>
80103ee3:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103ee9:	85 c0                	test   %eax,%eax
80103eeb:	75 cb                	jne    80103eb8 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103eed:	8b 55 10             	mov    0x10(%ebp),%edx
80103ef0:	31 db                	xor    %ebx,%ebx
80103ef2:	85 d2                	test   %edx,%edx
80103ef4:	7f 28                	jg     80103f1e <piperead+0x9e>
80103ef6:	eb 34                	jmp    80103f2c <piperead+0xac>
80103ef8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103eff:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103f00:	8d 48 01             	lea    0x1(%eax),%ecx
80103f03:	25 ff 01 00 00       	and    $0x1ff,%eax
80103f08:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80103f0e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103f13:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103f16:	83 c3 01             	add    $0x1,%ebx
80103f19:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103f1c:	74 0e                	je     80103f2c <piperead+0xac>
    if(p->nread == p->nwrite)
80103f1e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103f24:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103f2a:	75 d4                	jne    80103f00 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103f2c:	83 ec 0c             	sub    $0xc,%esp
80103f2f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103f35:	50                   	push   %eax
80103f36:	e8 85 0c 00 00       	call   80104bc0 <wakeup>
  release(&p->lock);
80103f3b:	89 34 24             	mov    %esi,(%esp)
80103f3e:	e8 ed 11 00 00       	call   80105130 <release>
  return i;
80103f43:	83 c4 10             	add    $0x10,%esp
}
80103f46:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f49:	89 d8                	mov    %ebx,%eax
80103f4b:	5b                   	pop    %ebx
80103f4c:	5e                   	pop    %esi
80103f4d:	5f                   	pop    %edi
80103f4e:	5d                   	pop    %ebp
80103f4f:	c3                   	ret    
      release(&p->lock);
80103f50:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103f53:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103f58:	56                   	push   %esi
80103f59:	e8 d2 11 00 00       	call   80105130 <release>
      return -1;
80103f5e:	83 c4 10             	add    $0x10,%esp
}
80103f61:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f64:	89 d8                	mov    %ebx,%eax
80103f66:	5b                   	pop    %ebx
80103f67:	5e                   	pop    %esi
80103f68:	5f                   	pop    %edi
80103f69:	5d                   	pop    %ebp
80103f6a:	c3                   	ret    
80103f6b:	66 90                	xchg   %ax,%ax
80103f6d:	66 90                	xchg   %ax,%ax
80103f6f:	90                   	nop

80103f70 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103f70:	55                   	push   %ebp
80103f71:	89 e5                	mov    %esp,%ebp
80103f73:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f74:	bb d4 2d 12 80       	mov    $0x80122dd4,%ebx
{
80103f79:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103f7c:	68 a0 2d 12 80       	push   $0x80122da0
80103f81:	e8 ea 10 00 00       	call   80105070 <acquire>
80103f86:	83 c4 10             	add    $0x10,%esp
80103f89:	eb 17                	jmp    80103fa2 <allocproc+0x32>
80103f8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f8f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f90:	81 c3 90 03 00 00    	add    $0x390,%ebx
80103f96:	81 fb d4 11 13 80    	cmp    $0x801311d4,%ebx
80103f9c:	0f 84 de 00 00 00    	je     80104080 <allocproc+0x110>
    if(p->state == UNUSED)
80103fa2:	8b 43 0c             	mov    0xc(%ebx),%eax
80103fa5:	85 c0                	test   %eax,%eax
80103fa7:	75 e7                	jne    80103f90 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103fa9:	a1 04 c0 10 80       	mov    0x8010c004,%eax

  release(&ptable.lock);
80103fae:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103fb1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103fb8:	89 43 10             	mov    %eax,0x10(%ebx)
80103fbb:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103fbe:	68 a0 2d 12 80       	push   $0x80122da0
  p->pid = nextpid++;
80103fc3:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
  release(&ptable.lock);
80103fc9:	e8 62 11 00 00       	call   80105130 <release>

  // Allocate kernel stack.
  if((p->kstack = cow_kalloc()) == 0){
80103fce:	e8 1d 35 00 00       	call   801074f0 <cow_kalloc>
80103fd3:	83 c4 10             	add    $0x10,%esp
80103fd6:	89 43 08             	mov    %eax,0x8(%ebx)
80103fd9:	85 c0                	test   %eax,%eax
80103fdb:	0f 84 b8 00 00 00    	je     80104099 <allocproc+0x129>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103fe1:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103fe7:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103fea:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103fef:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103ff2:	c7 40 14 c1 63 10 80 	movl   $0x801063c1,0x14(%eax)
  p->context = (struct context*)sp;
80103ff9:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103ffc:	6a 14                	push   $0x14
80103ffe:	6a 00                	push   $0x0
80104000:	50                   	push   %eax
80104001:	e8 7a 11 00 00       	call   80105180 <memset>
  p->context->eip = (uint)forkret;
80104006:	8b 43 1c             	mov    0x1c(%ebx),%eax

 if (p->pid > 2){
80104009:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
8010400c:	c7 40 10 b0 40 10 80 	movl   $0x801040b0,0x10(%eax)
 if (p->pid > 2){
80104013:	83 7b 10 64          	cmpl   $0x64,0x10(%ebx)
80104017:	7f 07                	jg     80104020 <allocproc+0xb0>
    for (int i = 0; i < 16; i++){
      p->ram_pages[i].is_free = p->swapped_out_pages[i].is_free = 1;
  }
 }
  return p;
}
80104019:	89 d8                	mov    %ebx,%eax
8010401b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010401e:	c9                   	leave  
8010401f:	c3                   	ret    
    p->num_of_actual_pages_in_mem = 0;
80104020:	c7 83 84 03 00 00 00 	movl   $0x0,0x384(%ebx)
80104027:	00 00 00 
    createSwapFile(p);
8010402a:	83 ec 0c             	sub    $0xc,%esp
    p->num_of_pagefaults_occurs = 0;
8010402d:	c7 83 88 03 00 00 00 	movl   $0x0,0x388(%ebx)
80104034:	00 00 00 
    p->num_of_pageOut_occured = 0;
80104037:	c7 83 8c 03 00 00 00 	movl   $0x0,0x38c(%ebx)
8010403e:	00 00 00 
    p->num_of_pages_in_swap_file = 0;
80104041:	c7 83 80 03 00 00 00 	movl   $0x0,0x380(%ebx)
80104048:	00 00 00 
    createSwapFile(p);
8010404b:	53                   	push   %ebx
8010404c:	e8 5f e6 ff ff       	call   801026b0 <createSwapFile>
    for (int i = 0; i < 16; i++){
80104051:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
80104057:	8d 93 00 02 00 00    	lea    0x200(%ebx),%edx
8010405d:	83 c4 10             	add    $0x10,%esp
      p->ram_pages[i].is_free = p->swapped_out_pages[i].is_free = 1;
80104060:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
80104066:	83 c0 18             	add    $0x18,%eax
80104069:	c7 80 68 01 00 00 01 	movl   $0x1,0x168(%eax)
80104070:	00 00 00 
    for (int i = 0; i < 16; i++){
80104073:	39 c2                	cmp    %eax,%edx
80104075:	75 e9                	jne    80104060 <allocproc+0xf0>
}
80104077:	89 d8                	mov    %ebx,%eax
80104079:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010407c:	c9                   	leave  
8010407d:	c3                   	ret    
8010407e:	66 90                	xchg   %ax,%ax
  release(&ptable.lock);
80104080:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80104083:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80104085:	68 a0 2d 12 80       	push   $0x80122da0
8010408a:	e8 a1 10 00 00       	call   80105130 <release>
}
8010408f:	89 d8                	mov    %ebx,%eax
  return 0;
80104091:	83 c4 10             	add    $0x10,%esp
}
80104094:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104097:	c9                   	leave  
80104098:	c3                   	ret    
    p->state = UNUSED;
80104099:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801040a0:	31 db                	xor    %ebx,%ebx
}
801040a2:	89 d8                	mov    %ebx,%eax
801040a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040a7:	c9                   	leave  
801040a8:	c3                   	ret    
801040a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801040b0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801040b0:	f3 0f 1e fb          	endbr32 
801040b4:	55                   	push   %ebp
801040b5:	89 e5                	mov    %esp,%ebp
801040b7:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801040ba:	68 a0 2d 12 80       	push   $0x80122da0
801040bf:	e8 6c 10 00 00       	call   80105130 <release>

  if (first) {
801040c4:	a1 00 c0 10 80       	mov    0x8010c000,%eax
801040c9:	83 c4 10             	add    $0x10,%esp
801040cc:	85 c0                	test   %eax,%eax
801040ce:	75 08                	jne    801040d8 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801040d0:	c9                   	leave  
801040d1:	c3                   	ret    
801040d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
801040d8:	c7 05 00 c0 10 80 00 	movl   $0x0,0x8010c000
801040df:	00 00 00 
    iinit(ROOTDEV);
801040e2:	83 ec 0c             	sub    $0xc,%esp
801040e5:	6a 01                	push   $0x1
801040e7:	e8 14 d8 ff ff       	call   80101900 <iinit>
    initlog(ROOTDEV);
801040ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801040f3:	e8 68 f3 ff ff       	call   80103460 <initlog>
}
801040f8:	83 c4 10             	add    $0x10,%esp
801040fb:	c9                   	leave  
801040fc:	c3                   	ret    
801040fd:	8d 76 00             	lea    0x0(%esi),%esi

80104100 <pinit>:
{
80104100:	f3 0f 1e fb          	endbr32 
80104104:	55                   	push   %ebp
80104105:	89 e5                	mov    %esp,%ebp
80104107:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
8010410a:	68 00 8d 10 80       	push   $0x80108d00
8010410f:	68 a0 2d 12 80       	push   $0x80122da0
80104114:	e8 d7 0d 00 00       	call   80104ef0 <initlock>
}
80104119:	83 c4 10             	add    $0x10,%esp
8010411c:	c9                   	leave  
8010411d:	c3                   	ret    
8010411e:	66 90                	xchg   %ax,%ax

80104120 <mycpu>:
{
80104120:	f3 0f 1e fb          	endbr32 
80104124:	55                   	push   %ebp
80104125:	89 e5                	mov    %esp,%ebp
80104127:	56                   	push   %esi
80104128:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104129:	9c                   	pushf  
8010412a:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010412b:	f6 c4 02             	test   $0x2,%ah
8010412e:	75 57                	jne    80104187 <mycpu+0x67>
  apicid = lapicid();
80104130:	e8 3b ef ff ff       	call   80103070 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80104135:	8b 35 80 2d 12 80    	mov    0x80122d80,%esi
  apicid = lapicid();
8010413b:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
8010413d:	85 f6                	test   %esi,%esi
8010413f:	7e 2c                	jle    8010416d <mycpu+0x4d>
80104141:	31 d2                	xor    %edx,%edx
80104143:	eb 0a                	jmp    8010414f <mycpu+0x2f>
80104145:	8d 76 00             	lea    0x0(%esi),%esi
80104148:	83 c2 01             	add    $0x1,%edx
8010414b:	39 f2                	cmp    %esi,%edx
8010414d:	74 1e                	je     8010416d <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
8010414f:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80104155:	0f b6 81 00 28 12 80 	movzbl -0x7fedd800(%ecx),%eax
8010415c:	39 d8                	cmp    %ebx,%eax
8010415e:	75 e8                	jne    80104148 <mycpu+0x28>
}
80104160:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80104163:	8d 81 00 28 12 80    	lea    -0x7fedd800(%ecx),%eax
}
80104169:	5b                   	pop    %ebx
8010416a:	5e                   	pop    %esi
8010416b:	5d                   	pop    %ebp
8010416c:	c3                   	ret    
  cprintf("The unknown apicid is %d\n", apicid);
8010416d:	83 ec 08             	sub    $0x8,%esp
80104170:	53                   	push   %ebx
80104171:	68 07 8d 10 80       	push   $0x80108d07
80104176:	e8 35 c5 ff ff       	call   801006b0 <cprintf>
  panic("unknown apicid\n");
8010417b:	c7 04 24 21 8d 10 80 	movl   $0x80108d21,(%esp)
80104182:	e8 09 c2 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80104187:	83 ec 0c             	sub    $0xc,%esp
8010418a:	68 10 8e 10 80       	push   $0x80108e10
8010418f:	e8 fc c1 ff ff       	call   80100390 <panic>
80104194:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010419b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010419f:	90                   	nop

801041a0 <cpuid>:
cpuid() {
801041a0:	f3 0f 1e fb          	endbr32 
801041a4:	55                   	push   %ebp
801041a5:	89 e5                	mov    %esp,%ebp
801041a7:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801041aa:	e8 71 ff ff ff       	call   80104120 <mycpu>
}
801041af:	c9                   	leave  
  return mycpu()-cpus;
801041b0:	2d 00 28 12 80       	sub    $0x80122800,%eax
801041b5:	c1 f8 04             	sar    $0x4,%eax
801041b8:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801041be:	c3                   	ret    
801041bf:	90                   	nop

801041c0 <myproc>:
myproc(void) {
801041c0:	f3 0f 1e fb          	endbr32 
801041c4:	55                   	push   %ebp
801041c5:	89 e5                	mov    %esp,%ebp
801041c7:	53                   	push   %ebx
801041c8:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801041cb:	e8 a0 0d 00 00       	call   80104f70 <pushcli>
  c = mycpu();
801041d0:	e8 4b ff ff ff       	call   80104120 <mycpu>
  p = c->proc;
801041d5:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041db:	e8 e0 0d 00 00       	call   80104fc0 <popcli>
}
801041e0:	83 c4 04             	add    $0x4,%esp
801041e3:	89 d8                	mov    %ebx,%eax
801041e5:	5b                   	pop    %ebx
801041e6:	5d                   	pop    %ebp
801041e7:	c3                   	ret    
801041e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041ef:	90                   	nop

801041f0 <userinit>:
{
801041f0:	f3 0f 1e fb          	endbr32 
801041f4:	55                   	push   %ebp
801041f5:	89 e5                	mov    %esp,%ebp
801041f7:	53                   	push   %ebx
801041f8:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801041fb:	e8 70 fd ff ff       	call   80103f70 <allocproc>
80104200:	89 c3                	mov    %eax,%ebx
  initproc = p;
80104202:	a3 b8 c5 10 80       	mov    %eax,0x8010c5b8
  if((p->pgdir = setupkvm()) == 0)
80104207:	e8 34 3b 00 00       	call   80107d40 <setupkvm>
8010420c:	89 43 04             	mov    %eax,0x4(%ebx)
8010420f:	85 c0                	test   %eax,%eax
80104211:	0f 84 bd 00 00 00    	je     801042d4 <userinit+0xe4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104217:	83 ec 04             	sub    $0x4,%esp
8010421a:	68 2c 00 00 00       	push   $0x2c
8010421f:	68 60 c4 10 80       	push   $0x8010c460
80104224:	50                   	push   %eax
80104225:	e8 a6 37 00 00       	call   801079d0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
8010422a:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
8010422d:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80104233:	6a 4c                	push   $0x4c
80104235:	6a 00                	push   $0x0
80104237:	ff 73 18             	pushl  0x18(%ebx)
8010423a:	e8 41 0f 00 00       	call   80105180 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010423f:	8b 43 18             	mov    0x18(%ebx),%eax
80104242:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104247:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010424a:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010424f:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104253:	8b 43 18             	mov    0x18(%ebx),%eax
80104256:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010425a:	8b 43 18             	mov    0x18(%ebx),%eax
8010425d:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104261:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104265:	8b 43 18             	mov    0x18(%ebx),%eax
80104268:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010426c:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104270:	8b 43 18             	mov    0x18(%ebx),%eax
80104273:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
8010427a:	8b 43 18             	mov    0x18(%ebx),%eax
8010427d:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104284:	8b 43 18             	mov    0x18(%ebx),%eax
80104287:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010428e:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104291:	6a 10                	push   $0x10
80104293:	68 4a 8d 10 80       	push   $0x80108d4a
80104298:	50                   	push   %eax
80104299:	e8 a2 10 00 00       	call   80105340 <safestrcpy>
  p->cwd = namei("/");
8010429e:	c7 04 24 53 8d 10 80 	movl   $0x80108d53,(%esp)
801042a5:	e8 46 e1 ff ff       	call   801023f0 <namei>
801042aa:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801042ad:	c7 04 24 a0 2d 12 80 	movl   $0x80122da0,(%esp)
801042b4:	e8 b7 0d 00 00       	call   80105070 <acquire>
  p->state = RUNNABLE;
801042b9:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
801042c0:	c7 04 24 a0 2d 12 80 	movl   $0x80122da0,(%esp)
801042c7:	e8 64 0e 00 00       	call   80105130 <release>
}
801042cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042cf:	83 c4 10             	add    $0x10,%esp
801042d2:	c9                   	leave  
801042d3:	c3                   	ret    
    panic("userinit: out of memory?");
801042d4:	83 ec 0c             	sub    $0xc,%esp
801042d7:	68 31 8d 10 80       	push   $0x80108d31
801042dc:	e8 af c0 ff ff       	call   80100390 <panic>
801042e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042ef:	90                   	nop

801042f0 <growproc>:
{
801042f0:	f3 0f 1e fb          	endbr32 
801042f4:	55                   	push   %ebp
801042f5:	89 e5                	mov    %esp,%ebp
801042f7:	56                   	push   %esi
801042f8:	53                   	push   %ebx
801042f9:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
801042fc:	e8 6f 0c 00 00       	call   80104f70 <pushcli>
  c = mycpu();
80104301:	e8 1a fe ff ff       	call   80104120 <mycpu>
  p = c->proc;
80104306:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010430c:	e8 af 0c 00 00       	call   80104fc0 <popcli>
  sz = curproc->sz;
80104311:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80104313:	85 f6                	test   %esi,%esi
80104315:	7f 19                	jg     80104330 <growproc+0x40>
  } else if(n < 0){
80104317:	75 37                	jne    80104350 <growproc+0x60>
  switchuvm(curproc);
80104319:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
8010431c:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010431e:	53                   	push   %ebx
8010431f:	e8 9c 35 00 00       	call   801078c0 <switchuvm>
  return 0;
80104324:	83 c4 10             	add    $0x10,%esp
80104327:	31 c0                	xor    %eax,%eax
}
80104329:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010432c:	5b                   	pop    %ebx
8010432d:	5e                   	pop    %esi
8010432e:	5d                   	pop    %ebp
8010432f:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104330:	83 ec 04             	sub    $0x4,%esp
80104333:	01 c6                	add    %eax,%esi
80104335:	56                   	push   %esi
80104336:	50                   	push   %eax
80104337:	ff 73 04             	pushl  0x4(%ebx)
8010433a:	e8 61 3f 00 00       	call   801082a0 <allocuvm>
8010433f:	83 c4 10             	add    $0x10,%esp
80104342:	85 c0                	test   %eax,%eax
80104344:	75 d3                	jne    80104319 <growproc+0x29>
      return -1;
80104346:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010434b:	eb dc                	jmp    80104329 <growproc+0x39>
8010434d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104350:	83 ec 04             	sub    $0x4,%esp
80104353:	01 c6                	add    %eax,%esi
80104355:	56                   	push   %esi
80104356:	50                   	push   %eax
80104357:	ff 73 04             	pushl  0x4(%ebx)
8010435a:	e8 c1 37 00 00       	call   80107b20 <deallocuvm>
8010435f:	83 c4 10             	add    $0x10,%esp
80104362:	85 c0                	test   %eax,%eax
80104364:	75 b3                	jne    80104319 <growproc+0x29>
80104366:	eb de                	jmp    80104346 <growproc+0x56>
80104368:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010436f:	90                   	nop

80104370 <sys_get_number_of_free_pages_impl>:
int sys_get_number_of_free_pages_impl(void){
80104370:	f3 0f 1e fb          	endbr32 
  for (int i = 0; i < PHYSTOP / PGSIZE; i++){
80104374:	31 c0                	xor    %eax,%eax
  int count = 0;
80104376:	31 d2                	xor    %edx,%edx
80104378:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010437f:	90                   	nop
      count++;
80104380:	80 b8 40 1f 11 80 01 	cmpb   $0x1,-0x7feee0c0(%eax)
80104387:	83 da ff             	sbb    $0xffffffff,%edx
  for (int i = 0; i < PHYSTOP / PGSIZE; i++){
8010438a:	83 c0 01             	add    $0x1,%eax
8010438d:	3d 00 e0 00 00       	cmp    $0xe000,%eax
80104392:	75 ec                	jne    80104380 <sys_get_number_of_free_pages_impl+0x10>
  return (PHYSTOP/PGSIZE) - count;
80104394:	29 d0                	sub    %edx,%eax
}
80104396:	c3                   	ret    
80104397:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010439e:	66 90                	xchg   %ax,%ax

801043a0 <fork>:
{
801043a0:	f3 0f 1e fb          	endbr32 
801043a4:	55                   	push   %ebp
801043a5:	89 e5                	mov    %esp,%ebp
801043a7:	57                   	push   %edi
801043a8:	56                   	push   %esi
801043a9:	53                   	push   %ebx
801043aa:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
801043ad:	e8 be 0b 00 00       	call   80104f70 <pushcli>
  c = mycpu();
801043b2:	e8 69 fd ff ff       	call   80104120 <mycpu>
  p = c->proc;
801043b7:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801043bd:	e8 fe 0b 00 00       	call   80104fc0 <popcli>
  if((np = allocproc()) == 0){
801043c2:	e8 a9 fb ff ff       	call   80103f70 <allocproc>
801043c7:	85 c0                	test   %eax,%eax
801043c9:	0f 84 89 02 00 00    	je     80104658 <fork+0x2b8>
  cprintf("pages : %d, curproc size : %d\n", 57344 - sys_get_number_of_free_pages_impl(), curproc->sz);
801043cf:	8b 33                	mov    (%ebx),%esi
801043d1:	89 c2                	mov    %eax,%edx
  int count = 0;
801043d3:	31 c9                	xor    %ecx,%ecx
  for (int i = 0; i < PHYSTOP / PGSIZE; i++){
801043d5:	31 c0                	xor    %eax,%eax
801043d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043de:	66 90                	xchg   %ax,%ax
      count++;
801043e0:	80 b8 40 1f 11 80 01 	cmpb   $0x1,-0x7feee0c0(%eax)
801043e7:	83 d9 ff             	sbb    $0xffffffff,%ecx
  for (int i = 0; i < PHYSTOP / PGSIZE; i++){
801043ea:	83 c0 01             	add    $0x1,%eax
801043ed:	3d 00 e0 00 00       	cmp    $0xe000,%eax
801043f2:	75 ec                	jne    801043e0 <fork+0x40>
  cprintf("pages : %d, curproc size : %d\n", 57344 - sys_get_number_of_free_pages_impl(), curproc->sz);
801043f4:	83 ec 04             	sub    $0x4,%esp
801043f7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801043fa:	56                   	push   %esi
801043fb:	51                   	push   %ecx
801043fc:	68 38 8e 10 80       	push   $0x80108e38
80104401:	e8 aa c2 ff ff       	call   801006b0 <cprintf>
  if((np->pgdir = cow_copyuvm(curproc->pgdir, curproc->sz)) == 0){ // (np->pid > 2 ? cow_copyuvm : copyuvm)
80104406:	58                   	pop    %eax
80104407:	5a                   	pop    %edx
80104408:	ff 33                	pushl  (%ebx)
8010440a:	ff 73 04             	pushl  0x4(%ebx)
8010440d:	e8 fe 39 00 00       	call   80107e10 <cow_copyuvm>
80104412:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104415:	83 c4 10             	add    $0x10,%esp
80104418:	89 42 04             	mov    %eax,0x4(%edx)
8010441b:	85 c0                	test   %eax,%eax
8010441d:	0f 84 0a 02 00 00    	je     8010462d <fork+0x28d>
  np->sz = curproc->sz;
80104423:	8b 03                	mov    (%ebx),%eax
  *np->tf = *curproc->tf;
80104425:	8b 7a 18             	mov    0x18(%edx),%edi
  np->parent = curproc;
80104428:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
8010442b:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->sz = curproc->sz;
80104430:	89 02                	mov    %eax,(%edx)
  *np->tf = *curproc->tf;
80104432:	8b 73 18             	mov    0x18(%ebx),%esi
80104435:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80104437:	31 f6                	xor    %esi,%esi
80104439:	89 d7                	mov    %edx,%edi
  np->tf->eax = 0;
8010443b:	8b 42 18             	mov    0x18(%edx),%eax
8010443e:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80104445:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[i])
80104448:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
8010444c:	85 c0                	test   %eax,%eax
8010444e:	74 10                	je     80104460 <fork+0xc0>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104450:	83 ec 0c             	sub    $0xc,%esp
80104453:	50                   	push   %eax
80104454:	e8 d7 cd ff ff       	call   80101230 <filedup>
80104459:	83 c4 10             	add    $0x10,%esp
8010445c:	89 44 b7 28          	mov    %eax,0x28(%edi,%esi,4)
  for(i = 0; i < NOFILE; i++)
80104460:	83 c6 01             	add    $0x1,%esi
80104463:	83 fe 10             	cmp    $0x10,%esi
80104466:	75 e0                	jne    80104448 <fork+0xa8>
  np->cwd = idup(curproc->cwd);
80104468:	83 ec 0c             	sub    $0xc,%esp
8010446b:	ff 73 68             	pushl  0x68(%ebx)
8010446e:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80104471:	e8 7a d6 ff ff       	call   80101af0 <idup>
80104476:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104479:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
8010447c:	89 42 68             	mov    %eax,0x68(%edx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010447f:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104482:	6a 10                	push   $0x10
80104484:	50                   	push   %eax
80104485:	8d 42 6c             	lea    0x6c(%edx),%eax
80104488:	50                   	push   %eax
80104489:	e8 b2 0e 00 00       	call   80105340 <safestrcpy>
  pid = np->pid;
8010448e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  if (curproc->pid > 2 && np->pid > 2){
80104491:	83 c4 10             	add    $0x10,%esp
80104494:	83 7b 10 64          	cmpl   $0x64,0x10(%ebx)
  pid = np->pid;
80104498:	8b 42 10             	mov    0x10(%edx),%eax
8010449b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if (curproc->pid > 2 && np->pid > 2){
8010449e:	7e 05                	jle    801044a5 <fork+0x105>
801044a0:	83 f8 64             	cmp    $0x64,%eax
801044a3:	7f 34                	jg     801044d9 <fork+0x139>
  acquire(&ptable.lock);
801044a5:	83 ec 0c             	sub    $0xc,%esp
801044a8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801044ab:	68 a0 2d 12 80       	push   $0x80122da0
801044b0:	e8 bb 0b 00 00       	call   80105070 <acquire>
  np->state = RUNNABLE;
801044b5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801044b8:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  release(&ptable.lock);
801044bf:	c7 04 24 a0 2d 12 80 	movl   $0x80122da0,(%esp)
801044c6:	e8 65 0c 00 00       	call   80105130 <release>
  return pid;
801044cb:	83 c4 10             	add    $0x10,%esp
}
801044ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
801044d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044d4:	5b                   	pop    %ebx
801044d5:	5e                   	pop    %esi
801044d6:	5f                   	pop    %edi
801044d7:	5d                   	pop    %ebp
801044d8:	c3                   	ret    
801044d9:	8d 83 e8 01 00 00    	lea    0x1e8(%ebx),%eax
    int last_not_free_in_file = MAX_PYSC_PAGES - 1;
801044df:	b9 0f 00 00 00       	mov    $0xf,%ecx
801044e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while (last_not_free_in_file >= 0 && curproc->swapped_out_pages[last_not_free_in_file].is_free){ last_not_free_in_file--; }
801044e8:	8b 30                	mov    (%eax),%esi
801044ea:	85 f6                	test   %esi,%esi
801044ec:	74 1a                	je     80104508 <fork+0x168>
801044ee:	83 e9 01             	sub    $0x1,%ecx
801044f1:	83 e8 18             	sub    $0x18,%eax
801044f4:	83 f9 ff             	cmp    $0xffffffff,%ecx
801044f7:	75 ef                	jne    801044e8 <fork+0x148>
801044f9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    void* pg_buffer = cow_kalloc();
801044fc:	e8 ef 2f 00 00       	call   801074f0 <cow_kalloc>
80104501:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104504:	89 c7                	mov    %eax,%edi
    for (int i = 0; i < last_not_free_in_file * PGSIZE; i += PGSIZE){
80104506:	eb 57                	jmp    8010455f <fork+0x1bf>
80104508:	89 55 d8             	mov    %edx,-0x28(%ebp)
8010450b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    void* pg_buffer = cow_kalloc();
8010450e:	e8 dd 2f 00 00       	call   801074f0 <cow_kalloc>
    last_not_free_in_file++;
80104513:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    for (int i = 0; i < last_not_free_in_file * PGSIZE; i += PGSIZE){
80104516:	8b 55 d8             	mov    -0x28(%ebp),%edx
80104519:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
    void* pg_buffer = cow_kalloc();
8010451c:	89 c7                	mov    %eax,%edi
    for (int i = 0; i < last_not_free_in_file * PGSIZE; i += PGSIZE){
8010451e:	89 f3                	mov    %esi,%ebx
    last_not_free_in_file++;
80104520:	83 c1 01             	add    $0x1,%ecx
    for (int i = 0; i < last_not_free_in_file * PGSIZE; i += PGSIZE){
80104523:	89 d6                	mov    %edx,%esi
80104525:	c1 e1 0c             	shl    $0xc,%ecx
80104528:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010452b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010452f:	90                   	nop
      readFromSwapFile(curproc, pg_buffer, i, PGSIZE);
80104530:	68 00 10 00 00       	push   $0x1000
80104535:	53                   	push   %ebx
80104536:	57                   	push   %edi
80104537:	ff 75 e4             	pushl  -0x1c(%ebp)
8010453a:	e8 41 e2 ff ff       	call   80102780 <readFromSwapFile>
      writeToSwapFile(np, pg_buffer, i, PGSIZE);
8010453f:	68 00 10 00 00       	push   $0x1000
80104544:	53                   	push   %ebx
    for (int i = 0; i < last_not_free_in_file * PGSIZE; i += PGSIZE){
80104545:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      writeToSwapFile(np, pg_buffer, i, PGSIZE);
8010454b:	57                   	push   %edi
8010454c:	56                   	push   %esi
8010454d:	e8 fe e1 ff ff       	call   80102750 <writeToSwapFile>
    for (int i = 0; i < last_not_free_in_file * PGSIZE; i += PGSIZE){
80104552:	83 c4 20             	add    $0x20,%esp
80104555:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
80104558:	7c d6                	jl     80104530 <fork+0x190>
8010455a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010455d:	89 f2                	mov    %esi,%edx
    cow_kfree(pg_buffer);
8010455f:	83 ec 0c             	sub    $0xc,%esp
80104562:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80104565:	57                   	push   %edi
80104566:	e8 e5 2e 00 00       	call   80107450 <cow_kfree>
8010456b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010456e:	83 c4 10             	add    $0x10,%esp
80104571:	b8 80 00 00 00       	mov    $0x80,%eax
80104576:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010457d:	8d 76 00             	lea    0x0(%esi),%esi
      np->ram_pages[i] = curproc->ram_pages[i];
80104580:	8b 8c 03 80 01 00 00 	mov    0x180(%ebx,%eax,1),%ecx
80104587:	89 8c 02 80 01 00 00 	mov    %ecx,0x180(%edx,%eax,1)
8010458e:	8b 8c 03 84 01 00 00 	mov    0x184(%ebx,%eax,1),%ecx
80104595:	89 8c 02 84 01 00 00 	mov    %ecx,0x184(%edx,%eax,1)
8010459c:	8b 8c 03 88 01 00 00 	mov    0x188(%ebx,%eax,1),%ecx
801045a3:	89 8c 02 88 01 00 00 	mov    %ecx,0x188(%edx,%eax,1)
801045aa:	8b 8c 03 8c 01 00 00 	mov    0x18c(%ebx,%eax,1),%ecx
801045b1:	89 8c 02 8c 01 00 00 	mov    %ecx,0x18c(%edx,%eax,1)
801045b8:	8b 8c 03 90 01 00 00 	mov    0x190(%ebx,%eax,1),%ecx
801045bf:	89 8c 02 90 01 00 00 	mov    %ecx,0x190(%edx,%eax,1)
801045c6:	8b 8c 03 94 01 00 00 	mov    0x194(%ebx,%eax,1),%ecx
801045cd:	89 8c 02 94 01 00 00 	mov    %ecx,0x194(%edx,%eax,1)
      np->swapped_out_pages[i] = curproc->swapped_out_pages[i];
801045d4:	8b 0c 03             	mov    (%ebx,%eax,1),%ecx
801045d7:	89 0c 02             	mov    %ecx,(%edx,%eax,1)
801045da:	8b 4c 03 04          	mov    0x4(%ebx,%eax,1),%ecx
801045de:	89 4c 02 04          	mov    %ecx,0x4(%edx,%eax,1)
801045e2:	8b 4c 03 08          	mov    0x8(%ebx,%eax,1),%ecx
801045e6:	89 4c 02 08          	mov    %ecx,0x8(%edx,%eax,1)
801045ea:	8b 4c 03 0c          	mov    0xc(%ebx,%eax,1),%ecx
801045ee:	89 4c 02 0c          	mov    %ecx,0xc(%edx,%eax,1)
801045f2:	8b 4c 03 10          	mov    0x10(%ebx,%eax,1),%ecx
801045f6:	89 4c 02 10          	mov    %ecx,0x10(%edx,%eax,1)
801045fa:	8b 4c 03 14          	mov    0x14(%ebx,%eax,1),%ecx
801045fe:	89 4c 02 14          	mov    %ecx,0x14(%edx,%eax,1)
    for (int i = 0; i < MAX_PYSC_PAGES; i++){
80104602:	83 c0 18             	add    $0x18,%eax
80104605:	3d 00 02 00 00       	cmp    $0x200,%eax
8010460a:	0f 85 70 ff ff ff    	jne    80104580 <fork+0x1e0>
    np->num_of_actual_pages_in_mem = curproc->num_of_actual_pages_in_mem;
80104610:	8b 83 84 03 00 00    	mov    0x384(%ebx),%eax
80104616:	89 82 84 03 00 00    	mov    %eax,0x384(%edx)
    np->num_of_pages_in_swap_file = curproc->num_of_pages_in_swap_file;
8010461c:	8b 83 80 03 00 00    	mov    0x380(%ebx),%eax
80104622:	89 82 80 03 00 00    	mov    %eax,0x380(%edx)
80104628:	e9 78 fe ff ff       	jmp    801044a5 <fork+0x105>
    cow_kfree(np->kstack);
8010462d:	83 ec 0c             	sub    $0xc,%esp
80104630:	ff 72 08             	pushl  0x8(%edx)
80104633:	e8 18 2e 00 00       	call   80107450 <cow_kfree>
    np->kstack = 0;
80104638:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    return -1;
8010463b:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
80104642:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80104645:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
    np->state = UNUSED;
8010464c:	c7 42 0c 00 00 00 00 	movl   $0x0,0xc(%edx)
    return -1;
80104653:	e9 76 fe ff ff       	jmp    801044ce <fork+0x12e>
    return -1;
80104658:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
8010465f:	e9 6a fe ff ff       	jmp    801044ce <fork+0x12e>
80104664:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010466b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010466f:	90                   	nop

80104670 <scheduler>:
{
80104670:	f3 0f 1e fb          	endbr32 
80104674:	55                   	push   %ebp
80104675:	89 e5                	mov    %esp,%ebp
80104677:	57                   	push   %edi
80104678:	56                   	push   %esi
80104679:	53                   	push   %ebx
8010467a:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
8010467d:	e8 9e fa ff ff       	call   80104120 <mycpu>
  c->proc = 0;
80104682:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104689:	00 00 00 
  struct cpu *c = mycpu();
8010468c:	89 c6                	mov    %eax,%esi
  c->proc = 0;
8010468e:	8d 78 04             	lea    0x4(%eax),%edi
80104691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80104698:	fb                   	sti    
    acquire(&ptable.lock);
80104699:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010469c:	bb d4 2d 12 80       	mov    $0x80122dd4,%ebx
    acquire(&ptable.lock);
801046a1:	68 a0 2d 12 80       	push   $0x80122da0
801046a6:	e8 c5 09 00 00       	call   80105070 <acquire>
801046ab:	83 c4 10             	add    $0x10,%esp
801046ae:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
801046b0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801046b4:	75 33                	jne    801046e9 <scheduler+0x79>
      switchuvm(p);
801046b6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
801046b9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
801046bf:	53                   	push   %ebx
801046c0:	e8 fb 31 00 00       	call   801078c0 <switchuvm>
      swtch(&(c->scheduler), p->context);
801046c5:	58                   	pop    %eax
801046c6:	5a                   	pop    %edx
801046c7:	ff 73 1c             	pushl  0x1c(%ebx)
801046ca:	57                   	push   %edi
      p->state = RUNNING;
801046cb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
801046d2:	e8 cc 0c 00 00       	call   801053a3 <swtch>
      switchkvm();
801046d7:	e8 c4 31 00 00       	call   801078a0 <switchkvm>
      c->proc = 0;
801046dc:	83 c4 10             	add    $0x10,%esp
801046df:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801046e6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046e9:	81 c3 90 03 00 00    	add    $0x390,%ebx
801046ef:	81 fb d4 11 13 80    	cmp    $0x801311d4,%ebx
801046f5:	75 b9                	jne    801046b0 <scheduler+0x40>
    release(&ptable.lock);
801046f7:	83 ec 0c             	sub    $0xc,%esp
801046fa:	68 a0 2d 12 80       	push   $0x80122da0
801046ff:	e8 2c 0a 00 00       	call   80105130 <release>
    sti();
80104704:	83 c4 10             	add    $0x10,%esp
80104707:	eb 8f                	jmp    80104698 <scheduler+0x28>
80104709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104710 <sched>:
{
80104710:	f3 0f 1e fb          	endbr32 
80104714:	55                   	push   %ebp
80104715:	89 e5                	mov    %esp,%ebp
80104717:	56                   	push   %esi
80104718:	53                   	push   %ebx
  pushcli();
80104719:	e8 52 08 00 00       	call   80104f70 <pushcli>
  c = mycpu();
8010471e:	e8 fd f9 ff ff       	call   80104120 <mycpu>
  p = c->proc;
80104723:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104729:	e8 92 08 00 00       	call   80104fc0 <popcli>
  if(!holding(&ptable.lock))
8010472e:	83 ec 0c             	sub    $0xc,%esp
80104731:	68 a0 2d 12 80       	push   $0x80122da0
80104736:	e8 e5 08 00 00       	call   80105020 <holding>
8010473b:	83 c4 10             	add    $0x10,%esp
8010473e:	85 c0                	test   %eax,%eax
80104740:	74 4f                	je     80104791 <sched+0x81>
  if(mycpu()->ncli != 1)
80104742:	e8 d9 f9 ff ff       	call   80104120 <mycpu>
80104747:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010474e:	75 68                	jne    801047b8 <sched+0xa8>
  if(p->state == RUNNING)
80104750:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104754:	74 55                	je     801047ab <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104756:	9c                   	pushf  
80104757:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104758:	f6 c4 02             	test   $0x2,%ah
8010475b:	75 41                	jne    8010479e <sched+0x8e>
  intena = mycpu()->intena;
8010475d:	e8 be f9 ff ff       	call   80104120 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80104762:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104765:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
8010476b:	e8 b0 f9 ff ff       	call   80104120 <mycpu>
80104770:	83 ec 08             	sub    $0x8,%esp
80104773:	ff 70 04             	pushl  0x4(%eax)
80104776:	53                   	push   %ebx
80104777:	e8 27 0c 00 00       	call   801053a3 <swtch>
  mycpu()->intena = intena;
8010477c:	e8 9f f9 ff ff       	call   80104120 <mycpu>
}
80104781:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104784:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
8010478a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010478d:	5b                   	pop    %ebx
8010478e:	5e                   	pop    %esi
8010478f:	5d                   	pop    %ebp
80104790:	c3                   	ret    
    panic("sched ptable.lock");
80104791:	83 ec 0c             	sub    $0xc,%esp
80104794:	68 55 8d 10 80       	push   $0x80108d55
80104799:	e8 f2 bb ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010479e:	83 ec 0c             	sub    $0xc,%esp
801047a1:	68 81 8d 10 80       	push   $0x80108d81
801047a6:	e8 e5 bb ff ff       	call   80100390 <panic>
    panic("sched running");
801047ab:	83 ec 0c             	sub    $0xc,%esp
801047ae:	68 73 8d 10 80       	push   $0x80108d73
801047b3:	e8 d8 bb ff ff       	call   80100390 <panic>
    panic("sched locks");
801047b8:	83 ec 0c             	sub    $0xc,%esp
801047bb:	68 67 8d 10 80       	push   $0x80108d67
801047c0:	e8 cb bb ff ff       	call   80100390 <panic>
801047c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047d0 <exit>:
{
801047d0:	f3 0f 1e fb          	endbr32 
801047d4:	55                   	push   %ebp
801047d5:	89 e5                	mov    %esp,%ebp
801047d7:	57                   	push   %edi
801047d8:	56                   	push   %esi
801047d9:	53                   	push   %ebx
801047da:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
801047dd:	e8 8e 07 00 00       	call   80104f70 <pushcli>
  c = mycpu();
801047e2:	e8 39 f9 ff ff       	call   80104120 <mycpu>
  p = c->proc;
801047e7:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801047ed:	e8 ce 07 00 00       	call   80104fc0 <popcli>
  if(curproc == initproc)
801047f2:	8d 73 28             	lea    0x28(%ebx),%esi
801047f5:	8d 7b 68             	lea    0x68(%ebx),%edi
801047f8:	39 1d b8 c5 10 80    	cmp    %ebx,0x8010c5b8
801047fe:	0f 84 fd 00 00 00    	je     80104901 <exit+0x131>
80104804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
80104808:	8b 06                	mov    (%esi),%eax
8010480a:	85 c0                	test   %eax,%eax
8010480c:	74 12                	je     80104820 <exit+0x50>
      fileclose(curproc->ofile[fd]);
8010480e:	83 ec 0c             	sub    $0xc,%esp
80104811:	50                   	push   %eax
80104812:	e8 69 ca ff ff       	call   80101280 <fileclose>
      curproc->ofile[fd] = 0;
80104817:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010481d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104820:	83 c6 04             	add    $0x4,%esi
80104823:	39 f7                	cmp    %esi,%edi
80104825:	75 e1                	jne    80104808 <exit+0x38>
  begin_op();
80104827:	e8 d4 ec ff ff       	call   80103500 <begin_op>
  iput(curproc->cwd);
8010482c:	83 ec 0c             	sub    $0xc,%esp
8010482f:	ff 73 68             	pushl  0x68(%ebx)
80104832:	e8 19 d4 ff ff       	call   80101c50 <iput>
  end_op();
80104837:	e8 34 ed ff ff       	call   80103570 <end_op>
  curproc->cwd = 0;
8010483c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  removeSwapFile(curproc);
80104843:	89 1c 24             	mov    %ebx,(%esp)
80104846:	e8 75 dc ff ff       	call   801024c0 <removeSwapFile>
  acquire(&ptable.lock);
8010484b:	c7 04 24 a0 2d 12 80 	movl   $0x80122da0,(%esp)
80104852:	e8 19 08 00 00       	call   80105070 <acquire>
  wakeup1(curproc->parent);
80104857:	8b 53 14             	mov    0x14(%ebx),%edx
8010485a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010485d:	b8 d4 2d 12 80       	mov    $0x80122dd4,%eax
80104862:	eb 10                	jmp    80104874 <exit+0xa4>
80104864:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104868:	05 90 03 00 00       	add    $0x390,%eax
8010486d:	3d d4 11 13 80       	cmp    $0x801311d4,%eax
80104872:	74 1e                	je     80104892 <exit+0xc2>
    if(p->state == SLEEPING && p->chan == chan)
80104874:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104878:	75 ee                	jne    80104868 <exit+0x98>
8010487a:	3b 50 20             	cmp    0x20(%eax),%edx
8010487d:	75 e9                	jne    80104868 <exit+0x98>
      p->state = RUNNABLE;
8010487f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104886:	05 90 03 00 00       	add    $0x390,%eax
8010488b:	3d d4 11 13 80       	cmp    $0x801311d4,%eax
80104890:	75 e2                	jne    80104874 <exit+0xa4>
      p->parent = initproc;
80104892:	8b 0d b8 c5 10 80    	mov    0x8010c5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104898:	ba d4 2d 12 80       	mov    $0x80122dd4,%edx
8010489d:	eb 0f                	jmp    801048ae <exit+0xde>
8010489f:	90                   	nop
801048a0:	81 c2 90 03 00 00    	add    $0x390,%edx
801048a6:	81 fa d4 11 13 80    	cmp    $0x801311d4,%edx
801048ac:	74 3a                	je     801048e8 <exit+0x118>
    if(p->parent == curproc){
801048ae:	39 5a 14             	cmp    %ebx,0x14(%edx)
801048b1:	75 ed                	jne    801048a0 <exit+0xd0>
      if(p->state == ZOMBIE)
801048b3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
801048b7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801048ba:	75 e4                	jne    801048a0 <exit+0xd0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801048bc:	b8 d4 2d 12 80       	mov    $0x80122dd4,%eax
801048c1:	eb 11                	jmp    801048d4 <exit+0x104>
801048c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048c7:	90                   	nop
801048c8:	05 90 03 00 00       	add    $0x390,%eax
801048cd:	3d d4 11 13 80       	cmp    $0x801311d4,%eax
801048d2:	74 cc                	je     801048a0 <exit+0xd0>
    if(p->state == SLEEPING && p->chan == chan)
801048d4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801048d8:	75 ee                	jne    801048c8 <exit+0xf8>
801048da:	3b 48 20             	cmp    0x20(%eax),%ecx
801048dd:	75 e9                	jne    801048c8 <exit+0xf8>
      p->state = RUNNABLE;
801048df:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801048e6:	eb e0                	jmp    801048c8 <exit+0xf8>
  curproc->state = ZOMBIE;
801048e8:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
801048ef:	e8 1c fe ff ff       	call   80104710 <sched>
  panic("zombie exit");
801048f4:	83 ec 0c             	sub    $0xc,%esp
801048f7:	68 a2 8d 10 80       	push   $0x80108da2
801048fc:	e8 8f ba ff ff       	call   80100390 <panic>
    panic("init exiting");
80104901:	83 ec 0c             	sub    $0xc,%esp
80104904:	68 95 8d 10 80       	push   $0x80108d95
80104909:	e8 82 ba ff ff       	call   80100390 <panic>
8010490e:	66 90                	xchg   %ax,%ax

80104910 <yield>:
{
80104910:	f3 0f 1e fb          	endbr32 
80104914:	55                   	push   %ebp
80104915:	89 e5                	mov    %esp,%ebp
80104917:	53                   	push   %ebx
80104918:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
8010491b:	68 a0 2d 12 80       	push   $0x80122da0
80104920:	e8 4b 07 00 00       	call   80105070 <acquire>
  pushcli();
80104925:	e8 46 06 00 00       	call   80104f70 <pushcli>
  c = mycpu();
8010492a:	e8 f1 f7 ff ff       	call   80104120 <mycpu>
  p = c->proc;
8010492f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104935:	e8 86 06 00 00       	call   80104fc0 <popcli>
  myproc()->state = RUNNABLE;
8010493a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80104941:	e8 ca fd ff ff       	call   80104710 <sched>
  release(&ptable.lock);
80104946:	c7 04 24 a0 2d 12 80 	movl   $0x80122da0,(%esp)
8010494d:	e8 de 07 00 00       	call   80105130 <release>
}
80104952:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104955:	83 c4 10             	add    $0x10,%esp
80104958:	c9                   	leave  
80104959:	c3                   	ret    
8010495a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104960 <sleep>:
{
80104960:	f3 0f 1e fb          	endbr32 
80104964:	55                   	push   %ebp
80104965:	89 e5                	mov    %esp,%ebp
80104967:	57                   	push   %edi
80104968:	56                   	push   %esi
80104969:	53                   	push   %ebx
8010496a:	83 ec 0c             	sub    $0xc,%esp
8010496d:	8b 7d 08             	mov    0x8(%ebp),%edi
80104970:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104973:	e8 f8 05 00 00       	call   80104f70 <pushcli>
  c = mycpu();
80104978:	e8 a3 f7 ff ff       	call   80104120 <mycpu>
  p = c->proc;
8010497d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104983:	e8 38 06 00 00       	call   80104fc0 <popcli>
  if(p == 0)
80104988:	85 db                	test   %ebx,%ebx
8010498a:	0f 84 83 00 00 00    	je     80104a13 <sleep+0xb3>
  if(lk == 0)
80104990:	85 f6                	test   %esi,%esi
80104992:	74 72                	je     80104a06 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104994:	81 fe a0 2d 12 80    	cmp    $0x80122da0,%esi
8010499a:	74 4c                	je     801049e8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
8010499c:	83 ec 0c             	sub    $0xc,%esp
8010499f:	68 a0 2d 12 80       	push   $0x80122da0
801049a4:	e8 c7 06 00 00       	call   80105070 <acquire>
    release(lk);
801049a9:	89 34 24             	mov    %esi,(%esp)
801049ac:	e8 7f 07 00 00       	call   80105130 <release>
  p->chan = chan;
801049b1:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801049b4:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801049bb:	e8 50 fd ff ff       	call   80104710 <sched>
  p->chan = 0;
801049c0:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801049c7:	c7 04 24 a0 2d 12 80 	movl   $0x80122da0,(%esp)
801049ce:	e8 5d 07 00 00       	call   80105130 <release>
    acquire(lk);
801049d3:	89 75 08             	mov    %esi,0x8(%ebp)
801049d6:	83 c4 10             	add    $0x10,%esp
}
801049d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801049dc:	5b                   	pop    %ebx
801049dd:	5e                   	pop    %esi
801049de:	5f                   	pop    %edi
801049df:	5d                   	pop    %ebp
    acquire(lk);
801049e0:	e9 8b 06 00 00       	jmp    80105070 <acquire>
801049e5:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
801049e8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801049eb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801049f2:	e8 19 fd ff ff       	call   80104710 <sched>
  p->chan = 0;
801049f7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801049fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a01:	5b                   	pop    %ebx
80104a02:	5e                   	pop    %esi
80104a03:	5f                   	pop    %edi
80104a04:	5d                   	pop    %ebp
80104a05:	c3                   	ret    
    panic("sleep without lk");
80104a06:	83 ec 0c             	sub    $0xc,%esp
80104a09:	68 b4 8d 10 80       	push   $0x80108db4
80104a0e:	e8 7d b9 ff ff       	call   80100390 <panic>
    panic("sleep");
80104a13:	83 ec 0c             	sub    $0xc,%esp
80104a16:	68 ae 8d 10 80       	push   $0x80108dae
80104a1b:	e8 70 b9 ff ff       	call   80100390 <panic>

80104a20 <wait>:
{
80104a20:	f3 0f 1e fb          	endbr32 
80104a24:	55                   	push   %ebp
80104a25:	89 e5                	mov    %esp,%ebp
80104a27:	56                   	push   %esi
80104a28:	53                   	push   %ebx
  pushcli();
80104a29:	e8 42 05 00 00       	call   80104f70 <pushcli>
  c = mycpu();
80104a2e:	e8 ed f6 ff ff       	call   80104120 <mycpu>
  p = c->proc;
80104a33:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104a39:	e8 82 05 00 00       	call   80104fc0 <popcli>
  acquire(&ptable.lock);
80104a3e:	83 ec 0c             	sub    $0xc,%esp
80104a41:	68 a0 2d 12 80       	push   $0x80122da0
80104a46:	e8 25 06 00 00       	call   80105070 <acquire>
80104a4b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80104a4e:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a50:	bb d4 2d 12 80       	mov    $0x80122dd4,%ebx
80104a55:	eb 17                	jmp    80104a6e <wait+0x4e>
80104a57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a5e:	66 90                	xchg   %ax,%ax
80104a60:	81 c3 90 03 00 00    	add    $0x390,%ebx
80104a66:	81 fb d4 11 13 80    	cmp    $0x801311d4,%ebx
80104a6c:	74 1e                	je     80104a8c <wait+0x6c>
      if(p->parent != curproc)
80104a6e:	39 73 14             	cmp    %esi,0x14(%ebx)
80104a71:	75 ed                	jne    80104a60 <wait+0x40>
      if(p->state == ZOMBIE){
80104a73:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104a77:	74 3f                	je     80104ab8 <wait+0x98>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a79:	81 c3 90 03 00 00    	add    $0x390,%ebx
      havekids = 1;
80104a7f:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a84:	81 fb d4 11 13 80    	cmp    $0x801311d4,%ebx
80104a8a:	75 e2                	jne    80104a6e <wait+0x4e>
    if(!havekids || curproc->killed){
80104a8c:	85 c0                	test   %eax,%eax
80104a8e:	0f 84 09 01 00 00    	je     80104b9d <wait+0x17d>
80104a94:	8b 46 24             	mov    0x24(%esi),%eax
80104a97:	85 c0                	test   %eax,%eax
80104a99:	0f 85 fe 00 00 00    	jne    80104b9d <wait+0x17d>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104a9f:	83 ec 08             	sub    $0x8,%esp
80104aa2:	68 a0 2d 12 80       	push   $0x80122da0
80104aa7:	56                   	push   %esi
80104aa8:	e8 b3 fe ff ff       	call   80104960 <sleep>
    havekids = 0;
80104aad:	83 c4 10             	add    $0x10,%esp
80104ab0:	eb 9c                	jmp    80104a4e <wait+0x2e>
80104ab2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (p->pid > 2){
80104ab8:	8b 73 10             	mov    0x10(%ebx),%esi
80104abb:	83 fe 64             	cmp    $0x64,%esi
80104abe:	0f 8e 86 00 00 00    	jle    80104b4a <wait+0x12a>
          p->num_of_pagefaults_occurs = 0;
80104ac4:	c7 83 88 03 00 00 00 	movl   $0x0,0x388(%ebx)
80104acb:	00 00 00 
          p->num_of_actual_pages_in_mem = 0;
80104ace:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
80104ad4:	8d 93 00 02 00 00    	lea    0x200(%ebx),%edx
80104ada:	c7 83 84 03 00 00 00 	movl   $0x0,0x384(%ebx)
80104ae1:	00 00 00 
          p->num_of_pageOut_occured = 0;
80104ae4:	c7 83 8c 03 00 00 00 	movl   $0x0,0x38c(%ebx)
80104aeb:	00 00 00 
          p->num_of_pages_in_swap_file = 0;
80104aee:	c7 83 80 03 00 00 00 	movl   $0x0,0x380(%ebx)
80104af5:	00 00 00 
          for (int i = 0; i < MAX_PYSC_PAGES; i++){
80104af8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aff:	90                   	nop
            p->ram_pages[i].is_free = p->swapped_out_pages[i].is_free = 1;
80104b00:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
80104b06:	83 c0 18             	add    $0x18,%eax
80104b09:	c7 80 68 01 00 00 01 	movl   $0x1,0x168(%eax)
80104b10:	00 00 00 
            p->ram_pages[i].aging_counter = p->swapped_out_pages[i].aging_counter = 0;
80104b13:	c7 40 f0 00 00 00 00 	movl   $0x0,-0x10(%eax)
80104b1a:	c7 80 70 01 00 00 00 	movl   $0x0,0x170(%eax)
80104b21:	00 00 00 
            p->ram_pages[i].swap_file_offset = p->swapped_out_pages[i].swap_file_offset = 0;
80104b24:	c7 40 ec 00 00 00 00 	movl   $0x0,-0x14(%eax)
80104b2b:	c7 80 6c 01 00 00 00 	movl   $0x0,0x16c(%eax)
80104b32:	00 00 00 
            p->ram_pages[i].va = p->swapped_out_pages[i].va = 0;
80104b35:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
80104b3c:	c7 80 78 01 00 00 00 	movl   $0x0,0x178(%eax)
80104b43:	00 00 00 
          for (int i = 0; i < MAX_PYSC_PAGES; i++){
80104b46:	39 d0                	cmp    %edx,%eax
80104b48:	75 b6                	jne    80104b00 <wait+0xe0>
        cow_kfree(p->kstack);
80104b4a:	83 ec 0c             	sub    $0xc,%esp
80104b4d:	ff 73 08             	pushl  0x8(%ebx)
80104b50:	e8 fb 28 00 00       	call   80107450 <cow_kfree>
        freevm(p->pgdir);
80104b55:	5a                   	pop    %edx
80104b56:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104b59:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104b60:	e8 cb 30 00 00       	call   80107c30 <freevm>
        release(&ptable.lock);
80104b65:	c7 04 24 a0 2d 12 80 	movl   $0x80122da0,(%esp)
        p->pid = 0;
80104b6c:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104b73:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104b7a:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104b7e:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104b85:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104b8c:	e8 9f 05 00 00       	call   80105130 <release>
        return pid;
80104b91:	83 c4 10             	add    $0x10,%esp
}
80104b94:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b97:	89 f0                	mov    %esi,%eax
80104b99:	5b                   	pop    %ebx
80104b9a:	5e                   	pop    %esi
80104b9b:	5d                   	pop    %ebp
80104b9c:	c3                   	ret    
      release(&ptable.lock);
80104b9d:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104ba0:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104ba5:	68 a0 2d 12 80       	push   $0x80122da0
80104baa:	e8 81 05 00 00       	call   80105130 <release>
      return -1;
80104baf:	83 c4 10             	add    $0x10,%esp
80104bb2:	eb e0                	jmp    80104b94 <wait+0x174>
80104bb4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bbf:	90                   	nop

80104bc0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104bc0:	f3 0f 1e fb          	endbr32 
80104bc4:	55                   	push   %ebp
80104bc5:	89 e5                	mov    %esp,%ebp
80104bc7:	53                   	push   %ebx
80104bc8:	83 ec 10             	sub    $0x10,%esp
80104bcb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80104bce:	68 a0 2d 12 80       	push   $0x80122da0
80104bd3:	e8 98 04 00 00       	call   80105070 <acquire>
80104bd8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104bdb:	b8 d4 2d 12 80       	mov    $0x80122dd4,%eax
80104be0:	eb 12                	jmp    80104bf4 <wakeup+0x34>
80104be2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104be8:	05 90 03 00 00       	add    $0x390,%eax
80104bed:	3d d4 11 13 80       	cmp    $0x801311d4,%eax
80104bf2:	74 1e                	je     80104c12 <wakeup+0x52>
    if(p->state == SLEEPING && p->chan == chan)
80104bf4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104bf8:	75 ee                	jne    80104be8 <wakeup+0x28>
80104bfa:	3b 58 20             	cmp    0x20(%eax),%ebx
80104bfd:	75 e9                	jne    80104be8 <wakeup+0x28>
      p->state = RUNNABLE;
80104bff:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104c06:	05 90 03 00 00       	add    $0x390,%eax
80104c0b:	3d d4 11 13 80       	cmp    $0x801311d4,%eax
80104c10:	75 e2                	jne    80104bf4 <wakeup+0x34>
  wakeup1(chan);
  release(&ptable.lock);
80104c12:	c7 45 08 a0 2d 12 80 	movl   $0x80122da0,0x8(%ebp)
}
80104c19:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c1c:	c9                   	leave  
  release(&ptable.lock);
80104c1d:	e9 0e 05 00 00       	jmp    80105130 <release>
80104c22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104c30 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104c30:	f3 0f 1e fb          	endbr32 
80104c34:	55                   	push   %ebp
80104c35:	89 e5                	mov    %esp,%ebp
80104c37:	53                   	push   %ebx
80104c38:	83 ec 10             	sub    $0x10,%esp
80104c3b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80104c3e:	68 a0 2d 12 80       	push   $0x80122da0
80104c43:	e8 28 04 00 00       	call   80105070 <acquire>
80104c48:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c4b:	b8 d4 2d 12 80       	mov    $0x80122dd4,%eax
80104c50:	eb 12                	jmp    80104c64 <kill+0x34>
80104c52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c58:	05 90 03 00 00       	add    $0x390,%eax
80104c5d:	3d d4 11 13 80       	cmp    $0x801311d4,%eax
80104c62:	74 34                	je     80104c98 <kill+0x68>
    if(p->pid == pid){
80104c64:	39 58 10             	cmp    %ebx,0x10(%eax)
80104c67:	75 ef                	jne    80104c58 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104c69:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104c6d:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80104c74:	75 07                	jne    80104c7d <kill+0x4d>
        p->state = RUNNABLE;
80104c76:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104c7d:	83 ec 0c             	sub    $0xc,%esp
80104c80:	68 a0 2d 12 80       	push   $0x80122da0
80104c85:	e8 a6 04 00 00       	call   80105130 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104c8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104c8d:	83 c4 10             	add    $0x10,%esp
80104c90:	31 c0                	xor    %eax,%eax
}
80104c92:	c9                   	leave  
80104c93:	c3                   	ret    
80104c94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104c98:	83 ec 0c             	sub    $0xc,%esp
80104c9b:	68 a0 2d 12 80       	push   $0x80122da0
80104ca0:	e8 8b 04 00 00       	call   80105130 <release>
}
80104ca5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104ca8:	83 c4 10             	add    $0x10,%esp
80104cab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104cb0:	c9                   	leave  
80104cb1:	c3                   	ret    
80104cb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104cc0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104cc0:	f3 0f 1e fb          	endbr32 
80104cc4:	55                   	push   %ebp
80104cc5:	89 e5                	mov    %esp,%ebp
80104cc7:	57                   	push   %edi
80104cc8:	56                   	push   %esi
80104cc9:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104ccc:	53                   	push   %ebx
80104ccd:	bb 40 2e 12 80       	mov    $0x80122e40,%ebx
80104cd2:	83 ec 3c             	sub    $0x3c,%esp
80104cd5:	eb 2b                	jmp    80104d02 <procdump+0x42>
80104cd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cde:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104ce0:	83 ec 0c             	sub    $0xc,%esp
80104ce3:	68 2e 93 10 80       	push   $0x8010932e
80104ce8:	e8 c3 b9 ff ff       	call   801006b0 <cprintf>
80104ced:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104cf0:	81 c3 90 03 00 00    	add    $0x390,%ebx
80104cf6:	81 fb 40 12 13 80    	cmp    $0x80131240,%ebx
80104cfc:	0f 84 9e 00 00 00    	je     80104da0 <procdump+0xe0>
    if(p->state == UNUSED)
80104d02:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104d05:	85 c0                	test   %eax,%eax
80104d07:	74 e7                	je     80104cf0 <procdump+0x30>
      state = "???";
80104d09:	ba c5 8d 10 80       	mov    $0x80108dc5,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104d0e:	83 f8 05             	cmp    $0x5,%eax
80104d11:	77 11                	ja     80104d24 <procdump+0x64>
80104d13:	8b 14 85 58 8e 10 80 	mov    -0x7fef71a8(,%eax,4),%edx
      state = "???";
80104d1a:	b8 c5 8d 10 80       	mov    $0x80108dc5,%eax
80104d1f:	85 d2                	test   %edx,%edx
80104d21:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s RAM: %d SWAP: %d", p->pid, state, p->name, p->num_of_actual_pages_in_mem, p->num_of_pages_in_swap_file);
80104d24:	83 ec 08             	sub    $0x8,%esp
80104d27:	ff b3 14 03 00 00    	pushl  0x314(%ebx)
80104d2d:	ff b3 18 03 00 00    	pushl  0x318(%ebx)
80104d33:	53                   	push   %ebx
80104d34:	52                   	push   %edx
80104d35:	ff 73 a4             	pushl  -0x5c(%ebx)
80104d38:	68 c9 8d 10 80       	push   $0x80108dc9
80104d3d:	e8 6e b9 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
80104d42:	83 c4 20             	add    $0x20,%esp
80104d45:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104d49:	75 95                	jne    80104ce0 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104d4b:	83 ec 08             	sub    $0x8,%esp
80104d4e:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104d51:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104d54:	50                   	push   %eax
80104d55:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104d58:	8b 40 0c             	mov    0xc(%eax),%eax
80104d5b:	83 c0 08             	add    $0x8,%eax
80104d5e:	50                   	push   %eax
80104d5f:	e8 ac 01 00 00       	call   80104f10 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104d64:	83 c4 10             	add    $0x10,%esp
80104d67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d6e:	66 90                	xchg   %ax,%ax
80104d70:	8b 17                	mov    (%edi),%edx
80104d72:	85 d2                	test   %edx,%edx
80104d74:	0f 84 66 ff ff ff    	je     80104ce0 <procdump+0x20>
        cprintf(" %p", pc[i]);
80104d7a:	83 ec 08             	sub    $0x8,%esp
80104d7d:	83 c7 04             	add    $0x4,%edi
80104d80:	52                   	push   %edx
80104d81:	68 a1 87 10 80       	push   $0x801087a1
80104d86:	e8 25 b9 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104d8b:	83 c4 10             	add    $0x10,%esp
80104d8e:	39 fe                	cmp    %edi,%esi
80104d90:	75 de                	jne    80104d70 <procdump+0xb0>
80104d92:	e9 49 ff ff ff       	jmp    80104ce0 <procdump+0x20>
80104d97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d9e:	66 90                	xchg   %ax,%ax
  }
}
80104da0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104da3:	5b                   	pop    %ebx
80104da4:	5e                   	pop    %esi
80104da5:	5f                   	pop    %edi
80104da6:	5d                   	pop    %ebp
80104da7:	c3                   	ret    
80104da8:	66 90                	xchg   %ax,%ax
80104daa:	66 90                	xchg   %ax,%ax
80104dac:	66 90                	xchg   %ax,%ax
80104dae:	66 90                	xchg   %ax,%ax

80104db0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104db0:	f3 0f 1e fb          	endbr32 
80104db4:	55                   	push   %ebp
80104db5:	89 e5                	mov    %esp,%ebp
80104db7:	53                   	push   %ebx
80104db8:	83 ec 0c             	sub    $0xc,%esp
80104dbb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104dbe:	68 70 8e 10 80       	push   $0x80108e70
80104dc3:	8d 43 04             	lea    0x4(%ebx),%eax
80104dc6:	50                   	push   %eax
80104dc7:	e8 24 01 00 00       	call   80104ef0 <initlock>
  lk->name = name;
80104dcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104dcf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104dd5:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104dd8:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104ddf:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104de2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104de5:	c9                   	leave  
80104de6:	c3                   	ret    
80104de7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dee:	66 90                	xchg   %ax,%ax

80104df0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104df0:	f3 0f 1e fb          	endbr32 
80104df4:	55                   	push   %ebp
80104df5:	89 e5                	mov    %esp,%ebp
80104df7:	56                   	push   %esi
80104df8:	53                   	push   %ebx
80104df9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104dfc:	8d 73 04             	lea    0x4(%ebx),%esi
80104dff:	83 ec 0c             	sub    $0xc,%esp
80104e02:	56                   	push   %esi
80104e03:	e8 68 02 00 00       	call   80105070 <acquire>
  while (lk->locked) {
80104e08:	8b 13                	mov    (%ebx),%edx
80104e0a:	83 c4 10             	add    $0x10,%esp
80104e0d:	85 d2                	test   %edx,%edx
80104e0f:	74 1a                	je     80104e2b <acquiresleep+0x3b>
80104e11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104e18:	83 ec 08             	sub    $0x8,%esp
80104e1b:	56                   	push   %esi
80104e1c:	53                   	push   %ebx
80104e1d:	e8 3e fb ff ff       	call   80104960 <sleep>
  while (lk->locked) {
80104e22:	8b 03                	mov    (%ebx),%eax
80104e24:	83 c4 10             	add    $0x10,%esp
80104e27:	85 c0                	test   %eax,%eax
80104e29:	75 ed                	jne    80104e18 <acquiresleep+0x28>
  }
  lk->locked = 1;
80104e2b:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104e31:	e8 8a f3 ff ff       	call   801041c0 <myproc>
80104e36:	8b 40 10             	mov    0x10(%eax),%eax
80104e39:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104e3c:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104e3f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e42:	5b                   	pop    %ebx
80104e43:	5e                   	pop    %esi
80104e44:	5d                   	pop    %ebp
  release(&lk->lk);
80104e45:	e9 e6 02 00 00       	jmp    80105130 <release>
80104e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104e50 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104e50:	f3 0f 1e fb          	endbr32 
80104e54:	55                   	push   %ebp
80104e55:	89 e5                	mov    %esp,%ebp
80104e57:	56                   	push   %esi
80104e58:	53                   	push   %ebx
80104e59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104e5c:	8d 73 04             	lea    0x4(%ebx),%esi
80104e5f:	83 ec 0c             	sub    $0xc,%esp
80104e62:	56                   	push   %esi
80104e63:	e8 08 02 00 00       	call   80105070 <acquire>
  lk->locked = 0;
80104e68:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104e6e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104e75:	89 1c 24             	mov    %ebx,(%esp)
80104e78:	e8 43 fd ff ff       	call   80104bc0 <wakeup>
  release(&lk->lk);
80104e7d:	89 75 08             	mov    %esi,0x8(%ebp)
80104e80:	83 c4 10             	add    $0x10,%esp
}
80104e83:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e86:	5b                   	pop    %ebx
80104e87:	5e                   	pop    %esi
80104e88:	5d                   	pop    %ebp
  release(&lk->lk);
80104e89:	e9 a2 02 00 00       	jmp    80105130 <release>
80104e8e:	66 90                	xchg   %ax,%ax

80104e90 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104e90:	f3 0f 1e fb          	endbr32 
80104e94:	55                   	push   %ebp
80104e95:	89 e5                	mov    %esp,%ebp
80104e97:	57                   	push   %edi
80104e98:	31 ff                	xor    %edi,%edi
80104e9a:	56                   	push   %esi
80104e9b:	53                   	push   %ebx
80104e9c:	83 ec 18             	sub    $0x18,%esp
80104e9f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104ea2:	8d 73 04             	lea    0x4(%ebx),%esi
80104ea5:	56                   	push   %esi
80104ea6:	e8 c5 01 00 00       	call   80105070 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104eab:	8b 03                	mov    (%ebx),%eax
80104ead:	83 c4 10             	add    $0x10,%esp
80104eb0:	85 c0                	test   %eax,%eax
80104eb2:	75 1c                	jne    80104ed0 <holdingsleep+0x40>
  release(&lk->lk);
80104eb4:	83 ec 0c             	sub    $0xc,%esp
80104eb7:	56                   	push   %esi
80104eb8:	e8 73 02 00 00       	call   80105130 <release>
  return r;
}
80104ebd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ec0:	89 f8                	mov    %edi,%eax
80104ec2:	5b                   	pop    %ebx
80104ec3:	5e                   	pop    %esi
80104ec4:	5f                   	pop    %edi
80104ec5:	5d                   	pop    %ebp
80104ec6:	c3                   	ret    
80104ec7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ece:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104ed0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104ed3:	e8 e8 f2 ff ff       	call   801041c0 <myproc>
80104ed8:	39 58 10             	cmp    %ebx,0x10(%eax)
80104edb:	0f 94 c0             	sete   %al
80104ede:	0f b6 c0             	movzbl %al,%eax
80104ee1:	89 c7                	mov    %eax,%edi
80104ee3:	eb cf                	jmp    80104eb4 <holdingsleep+0x24>
80104ee5:	66 90                	xchg   %ax,%ax
80104ee7:	66 90                	xchg   %ax,%ax
80104ee9:	66 90                	xchg   %ax,%ax
80104eeb:	66 90                	xchg   %ax,%ax
80104eed:	66 90                	xchg   %ax,%ax
80104eef:	90                   	nop

80104ef0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104ef0:	f3 0f 1e fb          	endbr32 
80104ef4:	55                   	push   %ebp
80104ef5:	89 e5                	mov    %esp,%ebp
80104ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104efa:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104efd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104f03:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104f06:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104f0d:	5d                   	pop    %ebp
80104f0e:	c3                   	ret    
80104f0f:	90                   	nop

80104f10 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104f10:	f3 0f 1e fb          	endbr32 
80104f14:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104f15:	31 d2                	xor    %edx,%edx
{
80104f17:	89 e5                	mov    %esp,%ebp
80104f19:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104f1a:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104f1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104f20:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104f23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f27:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104f28:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104f2e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104f34:	77 1a                	ja     80104f50 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104f36:	8b 58 04             	mov    0x4(%eax),%ebx
80104f39:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104f3c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104f3f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104f41:	83 fa 0a             	cmp    $0xa,%edx
80104f44:	75 e2                	jne    80104f28 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104f46:	5b                   	pop    %ebx
80104f47:	5d                   	pop    %ebp
80104f48:	c3                   	ret    
80104f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104f50:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104f53:	8d 51 28             	lea    0x28(%ecx),%edx
80104f56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f5d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104f60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104f66:	83 c0 04             	add    $0x4,%eax
80104f69:	39 d0                	cmp    %edx,%eax
80104f6b:	75 f3                	jne    80104f60 <getcallerpcs+0x50>
}
80104f6d:	5b                   	pop    %ebx
80104f6e:	5d                   	pop    %ebp
80104f6f:	c3                   	ret    

80104f70 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104f70:	f3 0f 1e fb          	endbr32 
80104f74:	55                   	push   %ebp
80104f75:	89 e5                	mov    %esp,%ebp
80104f77:	53                   	push   %ebx
80104f78:	83 ec 04             	sub    $0x4,%esp
80104f7b:	9c                   	pushf  
80104f7c:	5b                   	pop    %ebx
  asm volatile("cli");
80104f7d:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104f7e:	e8 9d f1 ff ff       	call   80104120 <mycpu>
80104f83:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104f89:	85 c0                	test   %eax,%eax
80104f8b:	74 13                	je     80104fa0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104f8d:	e8 8e f1 ff ff       	call   80104120 <mycpu>
80104f92:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104f99:	83 c4 04             	add    $0x4,%esp
80104f9c:	5b                   	pop    %ebx
80104f9d:	5d                   	pop    %ebp
80104f9e:	c3                   	ret    
80104f9f:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104fa0:	e8 7b f1 ff ff       	call   80104120 <mycpu>
80104fa5:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104fab:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104fb1:	eb da                	jmp    80104f8d <pushcli+0x1d>
80104fb3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104fc0 <popcli>:

void
popcli(void)
{
80104fc0:	f3 0f 1e fb          	endbr32 
80104fc4:	55                   	push   %ebp
80104fc5:	89 e5                	mov    %esp,%ebp
80104fc7:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104fca:	9c                   	pushf  
80104fcb:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104fcc:	f6 c4 02             	test   $0x2,%ah
80104fcf:	75 31                	jne    80105002 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104fd1:	e8 4a f1 ff ff       	call   80104120 <mycpu>
80104fd6:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104fdd:	78 30                	js     8010500f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104fdf:	e8 3c f1 ff ff       	call   80104120 <mycpu>
80104fe4:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104fea:	85 d2                	test   %edx,%edx
80104fec:	74 02                	je     80104ff0 <popcli+0x30>
    sti();
}
80104fee:	c9                   	leave  
80104fef:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104ff0:	e8 2b f1 ff ff       	call   80104120 <mycpu>
80104ff5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104ffb:	85 c0                	test   %eax,%eax
80104ffd:	74 ef                	je     80104fee <popcli+0x2e>
  asm volatile("sti");
80104fff:	fb                   	sti    
}
80105000:	c9                   	leave  
80105001:	c3                   	ret    
    panic("popcli - interruptible");
80105002:	83 ec 0c             	sub    $0xc,%esp
80105005:	68 7b 8e 10 80       	push   $0x80108e7b
8010500a:	e8 81 b3 ff ff       	call   80100390 <panic>
    panic("popcli");
8010500f:	83 ec 0c             	sub    $0xc,%esp
80105012:	68 92 8e 10 80       	push   $0x80108e92
80105017:	e8 74 b3 ff ff       	call   80100390 <panic>
8010501c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105020 <holding>:
{
80105020:	f3 0f 1e fb          	endbr32 
80105024:	55                   	push   %ebp
80105025:	89 e5                	mov    %esp,%ebp
80105027:	56                   	push   %esi
80105028:	53                   	push   %ebx
80105029:	8b 75 08             	mov    0x8(%ebp),%esi
8010502c:	31 db                	xor    %ebx,%ebx
  pushcli();
8010502e:	e8 3d ff ff ff       	call   80104f70 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80105033:	8b 06                	mov    (%esi),%eax
80105035:	85 c0                	test   %eax,%eax
80105037:	75 0f                	jne    80105048 <holding+0x28>
  popcli();
80105039:	e8 82 ff ff ff       	call   80104fc0 <popcli>
}
8010503e:	89 d8                	mov    %ebx,%eax
80105040:	5b                   	pop    %ebx
80105041:	5e                   	pop    %esi
80105042:	5d                   	pop    %ebp
80105043:	c3                   	ret    
80105044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80105048:	8b 5e 08             	mov    0x8(%esi),%ebx
8010504b:	e8 d0 f0 ff ff       	call   80104120 <mycpu>
80105050:	39 c3                	cmp    %eax,%ebx
80105052:	0f 94 c3             	sete   %bl
  popcli();
80105055:	e8 66 ff ff ff       	call   80104fc0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
8010505a:	0f b6 db             	movzbl %bl,%ebx
}
8010505d:	89 d8                	mov    %ebx,%eax
8010505f:	5b                   	pop    %ebx
80105060:	5e                   	pop    %esi
80105061:	5d                   	pop    %ebp
80105062:	c3                   	ret    
80105063:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010506a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105070 <acquire>:
{
80105070:	f3 0f 1e fb          	endbr32 
80105074:	55                   	push   %ebp
80105075:	89 e5                	mov    %esp,%ebp
80105077:	56                   	push   %esi
80105078:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80105079:	e8 f2 fe ff ff       	call   80104f70 <pushcli>
  if(holding(lk))
8010507e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105081:	83 ec 0c             	sub    $0xc,%esp
80105084:	53                   	push   %ebx
80105085:	e8 96 ff ff ff       	call   80105020 <holding>
8010508a:	83 c4 10             	add    $0x10,%esp
8010508d:	85 c0                	test   %eax,%eax
8010508f:	0f 85 7f 00 00 00    	jne    80105114 <acquire+0xa4>
80105095:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80105097:	ba 01 00 00 00       	mov    $0x1,%edx
8010509c:	eb 05                	jmp    801050a3 <acquire+0x33>
8010509e:	66 90                	xchg   %ax,%ax
801050a0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801050a3:	89 d0                	mov    %edx,%eax
801050a5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
801050a8:	85 c0                	test   %eax,%eax
801050aa:	75 f4                	jne    801050a0 <acquire+0x30>
  __sync_synchronize();
801050ac:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801050b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801050b4:	e8 67 f0 ff ff       	call   80104120 <mycpu>
801050b9:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
801050bc:	89 e8                	mov    %ebp,%eax
801050be:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801050c0:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801050c6:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
801050cc:	77 22                	ja     801050f0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
801050ce:	8b 50 04             	mov    0x4(%eax),%edx
801050d1:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
801050d5:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
801050d8:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801050da:	83 fe 0a             	cmp    $0xa,%esi
801050dd:	75 e1                	jne    801050c0 <acquire+0x50>
}
801050df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050e2:	5b                   	pop    %ebx
801050e3:	5e                   	pop    %esi
801050e4:	5d                   	pop    %ebp
801050e5:	c3                   	ret    
801050e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050ed:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
801050f0:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
801050f4:	83 c3 34             	add    $0x34,%ebx
801050f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050fe:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80105100:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105106:	83 c0 04             	add    $0x4,%eax
80105109:	39 d8                	cmp    %ebx,%eax
8010510b:	75 f3                	jne    80105100 <acquire+0x90>
}
8010510d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105110:	5b                   	pop    %ebx
80105111:	5e                   	pop    %esi
80105112:	5d                   	pop    %ebp
80105113:	c3                   	ret    
    panic("acquire");
80105114:	83 ec 0c             	sub    $0xc,%esp
80105117:	68 99 8e 10 80       	push   $0x80108e99
8010511c:	e8 6f b2 ff ff       	call   80100390 <panic>
80105121:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105128:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010512f:	90                   	nop

80105130 <release>:
{
80105130:	f3 0f 1e fb          	endbr32 
80105134:	55                   	push   %ebp
80105135:	89 e5                	mov    %esp,%ebp
80105137:	53                   	push   %ebx
80105138:	83 ec 10             	sub    $0x10,%esp
8010513b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010513e:	53                   	push   %ebx
8010513f:	e8 dc fe ff ff       	call   80105020 <holding>
80105144:	83 c4 10             	add    $0x10,%esp
80105147:	85 c0                	test   %eax,%eax
80105149:	74 22                	je     8010516d <release+0x3d>
  lk->pcs[0] = 0;
8010514b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80105152:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80105159:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010515e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80105164:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105167:	c9                   	leave  
  popcli();
80105168:	e9 53 fe ff ff       	jmp    80104fc0 <popcli>
    panic("release");
8010516d:	83 ec 0c             	sub    $0xc,%esp
80105170:	68 a1 8e 10 80       	push   $0x80108ea1
80105175:	e8 16 b2 ff ff       	call   80100390 <panic>
8010517a:	66 90                	xchg   %ax,%ax
8010517c:	66 90                	xchg   %ax,%ax
8010517e:	66 90                	xchg   %ax,%ax

80105180 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105180:	f3 0f 1e fb          	endbr32 
80105184:	55                   	push   %ebp
80105185:	89 e5                	mov    %esp,%ebp
80105187:	57                   	push   %edi
80105188:	8b 55 08             	mov    0x8(%ebp),%edx
8010518b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010518e:	53                   	push   %ebx
8010518f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80105192:	89 d7                	mov    %edx,%edi
80105194:	09 cf                	or     %ecx,%edi
80105196:	83 e7 03             	and    $0x3,%edi
80105199:	75 25                	jne    801051c0 <memset+0x40>
    c &= 0xFF;
8010519b:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010519e:	c1 e0 18             	shl    $0x18,%eax
801051a1:	89 fb                	mov    %edi,%ebx
801051a3:	c1 e9 02             	shr    $0x2,%ecx
801051a6:	c1 e3 10             	shl    $0x10,%ebx
801051a9:	09 d8                	or     %ebx,%eax
801051ab:	09 f8                	or     %edi,%eax
801051ad:	c1 e7 08             	shl    $0x8,%edi
801051b0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801051b2:	89 d7                	mov    %edx,%edi
801051b4:	fc                   	cld    
801051b5:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801051b7:	5b                   	pop    %ebx
801051b8:	89 d0                	mov    %edx,%eax
801051ba:	5f                   	pop    %edi
801051bb:	5d                   	pop    %ebp
801051bc:	c3                   	ret    
801051bd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
801051c0:	89 d7                	mov    %edx,%edi
801051c2:	fc                   	cld    
801051c3:	f3 aa                	rep stos %al,%es:(%edi)
801051c5:	5b                   	pop    %ebx
801051c6:	89 d0                	mov    %edx,%eax
801051c8:	5f                   	pop    %edi
801051c9:	5d                   	pop    %ebp
801051ca:	c3                   	ret    
801051cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051cf:	90                   	nop

801051d0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801051d0:	f3 0f 1e fb          	endbr32 
801051d4:	55                   	push   %ebp
801051d5:	89 e5                	mov    %esp,%ebp
801051d7:	56                   	push   %esi
801051d8:	8b 75 10             	mov    0x10(%ebp),%esi
801051db:	8b 55 08             	mov    0x8(%ebp),%edx
801051de:	53                   	push   %ebx
801051df:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801051e2:	85 f6                	test   %esi,%esi
801051e4:	74 2a                	je     80105210 <memcmp+0x40>
801051e6:	01 c6                	add    %eax,%esi
801051e8:	eb 10                	jmp    801051fa <memcmp+0x2a>
801051ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
801051f0:	83 c0 01             	add    $0x1,%eax
801051f3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801051f6:	39 f0                	cmp    %esi,%eax
801051f8:	74 16                	je     80105210 <memcmp+0x40>
    if(*s1 != *s2)
801051fa:	0f b6 0a             	movzbl (%edx),%ecx
801051fd:	0f b6 18             	movzbl (%eax),%ebx
80105200:	38 d9                	cmp    %bl,%cl
80105202:	74 ec                	je     801051f0 <memcmp+0x20>
      return *s1 - *s2;
80105204:	0f b6 c1             	movzbl %cl,%eax
80105207:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80105209:	5b                   	pop    %ebx
8010520a:	5e                   	pop    %esi
8010520b:	5d                   	pop    %ebp
8010520c:	c3                   	ret    
8010520d:	8d 76 00             	lea    0x0(%esi),%esi
80105210:	5b                   	pop    %ebx
  return 0;
80105211:	31 c0                	xor    %eax,%eax
}
80105213:	5e                   	pop    %esi
80105214:	5d                   	pop    %ebp
80105215:	c3                   	ret    
80105216:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010521d:	8d 76 00             	lea    0x0(%esi),%esi

80105220 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105220:	f3 0f 1e fb          	endbr32 
80105224:	55                   	push   %ebp
80105225:	89 e5                	mov    %esp,%ebp
80105227:	57                   	push   %edi
80105228:	8b 55 08             	mov    0x8(%ebp),%edx
8010522b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010522e:	56                   	push   %esi
8010522f:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105232:	39 d6                	cmp    %edx,%esi
80105234:	73 2a                	jae    80105260 <memmove+0x40>
80105236:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80105239:	39 fa                	cmp    %edi,%edx
8010523b:	73 23                	jae    80105260 <memmove+0x40>
8010523d:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80105240:	85 c9                	test   %ecx,%ecx
80105242:	74 13                	je     80105257 <memmove+0x37>
80105244:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80105248:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
8010524c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
8010524f:	83 e8 01             	sub    $0x1,%eax
80105252:	83 f8 ff             	cmp    $0xffffffff,%eax
80105255:	75 f1                	jne    80105248 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80105257:	5e                   	pop    %esi
80105258:	89 d0                	mov    %edx,%eax
8010525a:	5f                   	pop    %edi
8010525b:	5d                   	pop    %ebp
8010525c:	c3                   	ret    
8010525d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80105260:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80105263:	89 d7                	mov    %edx,%edi
80105265:	85 c9                	test   %ecx,%ecx
80105267:	74 ee                	je     80105257 <memmove+0x37>
80105269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80105270:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80105271:	39 f0                	cmp    %esi,%eax
80105273:	75 fb                	jne    80105270 <memmove+0x50>
}
80105275:	5e                   	pop    %esi
80105276:	89 d0                	mov    %edx,%eax
80105278:	5f                   	pop    %edi
80105279:	5d                   	pop    %ebp
8010527a:	c3                   	ret    
8010527b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010527f:	90                   	nop

80105280 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105280:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80105284:	eb 9a                	jmp    80105220 <memmove>
80105286:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010528d:	8d 76 00             	lea    0x0(%esi),%esi

80105290 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80105290:	f3 0f 1e fb          	endbr32 
80105294:	55                   	push   %ebp
80105295:	89 e5                	mov    %esp,%ebp
80105297:	56                   	push   %esi
80105298:	8b 75 10             	mov    0x10(%ebp),%esi
8010529b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010529e:	53                   	push   %ebx
8010529f:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
801052a2:	85 f6                	test   %esi,%esi
801052a4:	74 32                	je     801052d8 <strncmp+0x48>
801052a6:	01 c6                	add    %eax,%esi
801052a8:	eb 14                	jmp    801052be <strncmp+0x2e>
801052aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801052b0:	38 da                	cmp    %bl,%dl
801052b2:	75 14                	jne    801052c8 <strncmp+0x38>
    n--, p++, q++;
801052b4:	83 c0 01             	add    $0x1,%eax
801052b7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801052ba:	39 f0                	cmp    %esi,%eax
801052bc:	74 1a                	je     801052d8 <strncmp+0x48>
801052be:	0f b6 11             	movzbl (%ecx),%edx
801052c1:	0f b6 18             	movzbl (%eax),%ebx
801052c4:	84 d2                	test   %dl,%dl
801052c6:	75 e8                	jne    801052b0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801052c8:	0f b6 c2             	movzbl %dl,%eax
801052cb:	29 d8                	sub    %ebx,%eax
}
801052cd:	5b                   	pop    %ebx
801052ce:	5e                   	pop    %esi
801052cf:	5d                   	pop    %ebp
801052d0:	c3                   	ret    
801052d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052d8:	5b                   	pop    %ebx
    return 0;
801052d9:	31 c0                	xor    %eax,%eax
}
801052db:	5e                   	pop    %esi
801052dc:	5d                   	pop    %ebp
801052dd:	c3                   	ret    
801052de:	66 90                	xchg   %ax,%ax

801052e0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801052e0:	f3 0f 1e fb          	endbr32 
801052e4:	55                   	push   %ebp
801052e5:	89 e5                	mov    %esp,%ebp
801052e7:	57                   	push   %edi
801052e8:	56                   	push   %esi
801052e9:	8b 75 08             	mov    0x8(%ebp),%esi
801052ec:	53                   	push   %ebx
801052ed:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801052f0:	89 f2                	mov    %esi,%edx
801052f2:	eb 1b                	jmp    8010530f <strncpy+0x2f>
801052f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801052f8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801052fc:	8b 7d 0c             	mov    0xc(%ebp),%edi
801052ff:	83 c2 01             	add    $0x1,%edx
80105302:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80105306:	89 f9                	mov    %edi,%ecx
80105308:	88 4a ff             	mov    %cl,-0x1(%edx)
8010530b:	84 c9                	test   %cl,%cl
8010530d:	74 09                	je     80105318 <strncpy+0x38>
8010530f:	89 c3                	mov    %eax,%ebx
80105311:	83 e8 01             	sub    $0x1,%eax
80105314:	85 db                	test   %ebx,%ebx
80105316:	7f e0                	jg     801052f8 <strncpy+0x18>
    ;
  while(n-- > 0)
80105318:	89 d1                	mov    %edx,%ecx
8010531a:	85 c0                	test   %eax,%eax
8010531c:	7e 15                	jle    80105333 <strncpy+0x53>
8010531e:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80105320:	83 c1 01             	add    $0x1,%ecx
80105323:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80105327:	89 c8                	mov    %ecx,%eax
80105329:	f7 d0                	not    %eax
8010532b:	01 d0                	add    %edx,%eax
8010532d:	01 d8                	add    %ebx,%eax
8010532f:	85 c0                	test   %eax,%eax
80105331:	7f ed                	jg     80105320 <strncpy+0x40>
  return os;
}
80105333:	5b                   	pop    %ebx
80105334:	89 f0                	mov    %esi,%eax
80105336:	5e                   	pop    %esi
80105337:	5f                   	pop    %edi
80105338:	5d                   	pop    %ebp
80105339:	c3                   	ret    
8010533a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105340 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105340:	f3 0f 1e fb          	endbr32 
80105344:	55                   	push   %ebp
80105345:	89 e5                	mov    %esp,%ebp
80105347:	56                   	push   %esi
80105348:	8b 55 10             	mov    0x10(%ebp),%edx
8010534b:	8b 75 08             	mov    0x8(%ebp),%esi
8010534e:	53                   	push   %ebx
8010534f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80105352:	85 d2                	test   %edx,%edx
80105354:	7e 21                	jle    80105377 <safestrcpy+0x37>
80105356:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
8010535a:	89 f2                	mov    %esi,%edx
8010535c:	eb 12                	jmp    80105370 <safestrcpy+0x30>
8010535e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105360:	0f b6 08             	movzbl (%eax),%ecx
80105363:	83 c0 01             	add    $0x1,%eax
80105366:	83 c2 01             	add    $0x1,%edx
80105369:	88 4a ff             	mov    %cl,-0x1(%edx)
8010536c:	84 c9                	test   %cl,%cl
8010536e:	74 04                	je     80105374 <safestrcpy+0x34>
80105370:	39 d8                	cmp    %ebx,%eax
80105372:	75 ec                	jne    80105360 <safestrcpy+0x20>
    ;
  *s = 0;
80105374:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80105377:	89 f0                	mov    %esi,%eax
80105379:	5b                   	pop    %ebx
8010537a:	5e                   	pop    %esi
8010537b:	5d                   	pop    %ebp
8010537c:	c3                   	ret    
8010537d:	8d 76 00             	lea    0x0(%esi),%esi

80105380 <strlen>:

int
strlen(const char *s)
{
80105380:	f3 0f 1e fb          	endbr32 
80105384:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105385:	31 c0                	xor    %eax,%eax
{
80105387:	89 e5                	mov    %esp,%ebp
80105389:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
8010538c:	80 3a 00             	cmpb   $0x0,(%edx)
8010538f:	74 10                	je     801053a1 <strlen+0x21>
80105391:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105398:	83 c0 01             	add    $0x1,%eax
8010539b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
8010539f:	75 f7                	jne    80105398 <strlen+0x18>
    ;
  return n;
}
801053a1:	5d                   	pop    %ebp
801053a2:	c3                   	ret    

801053a3 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801053a3:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801053a7:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801053ab:	55                   	push   %ebp
  pushl %ebx
801053ac:	53                   	push   %ebx
  pushl %esi
801053ad:	56                   	push   %esi
  pushl %edi
801053ae:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801053af:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801053b1:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801053b3:	5f                   	pop    %edi
  popl %esi
801053b4:	5e                   	pop    %esi
  popl %ebx
801053b5:	5b                   	pop    %ebx
  popl %ebp
801053b6:	5d                   	pop    %ebp
  ret
801053b7:	c3                   	ret    
801053b8:	66 90                	xchg   %ax,%ax
801053ba:	66 90                	xchg   %ax,%ax
801053bc:	66 90                	xchg   %ax,%ax
801053be:	66 90                	xchg   %ax,%ax

801053c0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801053c0:	f3 0f 1e fb          	endbr32 
801053c4:	55                   	push   %ebp
801053c5:	89 e5                	mov    %esp,%ebp
801053c7:	53                   	push   %ebx
801053c8:	83 ec 04             	sub    $0x4,%esp
801053cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801053ce:	e8 ed ed ff ff       	call   801041c0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801053d3:	8b 00                	mov    (%eax),%eax
801053d5:	39 d8                	cmp    %ebx,%eax
801053d7:	76 17                	jbe    801053f0 <fetchint+0x30>
801053d9:	8d 53 04             	lea    0x4(%ebx),%edx
801053dc:	39 d0                	cmp    %edx,%eax
801053de:	72 10                	jb     801053f0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801053e0:	8b 45 0c             	mov    0xc(%ebp),%eax
801053e3:	8b 13                	mov    (%ebx),%edx
801053e5:	89 10                	mov    %edx,(%eax)
  return 0;
801053e7:	31 c0                	xor    %eax,%eax
}
801053e9:	83 c4 04             	add    $0x4,%esp
801053ec:	5b                   	pop    %ebx
801053ed:	5d                   	pop    %ebp
801053ee:	c3                   	ret    
801053ef:	90                   	nop
    return -1;
801053f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053f5:	eb f2                	jmp    801053e9 <fetchint+0x29>
801053f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053fe:	66 90                	xchg   %ax,%ax

80105400 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105400:	f3 0f 1e fb          	endbr32 
80105404:	55                   	push   %ebp
80105405:	89 e5                	mov    %esp,%ebp
80105407:	53                   	push   %ebx
80105408:	83 ec 04             	sub    $0x4,%esp
8010540b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010540e:	e8 ad ed ff ff       	call   801041c0 <myproc>

  if(addr >= curproc->sz)
80105413:	39 18                	cmp    %ebx,(%eax)
80105415:	76 31                	jbe    80105448 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80105417:	8b 55 0c             	mov    0xc(%ebp),%edx
8010541a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010541c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010541e:	39 d3                	cmp    %edx,%ebx
80105420:	73 26                	jae    80105448 <fetchstr+0x48>
80105422:	89 d8                	mov    %ebx,%eax
80105424:	eb 11                	jmp    80105437 <fetchstr+0x37>
80105426:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010542d:	8d 76 00             	lea    0x0(%esi),%esi
80105430:	83 c0 01             	add    $0x1,%eax
80105433:	39 c2                	cmp    %eax,%edx
80105435:	76 11                	jbe    80105448 <fetchstr+0x48>
    if(*s == 0)
80105437:	80 38 00             	cmpb   $0x0,(%eax)
8010543a:	75 f4                	jne    80105430 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
8010543c:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
8010543f:	29 d8                	sub    %ebx,%eax
}
80105441:	5b                   	pop    %ebx
80105442:	5d                   	pop    %ebp
80105443:	c3                   	ret    
80105444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105448:	83 c4 04             	add    $0x4,%esp
    return -1;
8010544b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105450:	5b                   	pop    %ebx
80105451:	5d                   	pop    %ebp
80105452:	c3                   	ret    
80105453:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010545a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105460 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105460:	f3 0f 1e fb          	endbr32 
80105464:	55                   	push   %ebp
80105465:	89 e5                	mov    %esp,%ebp
80105467:	56                   	push   %esi
80105468:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105469:	e8 52 ed ff ff       	call   801041c0 <myproc>
8010546e:	8b 55 08             	mov    0x8(%ebp),%edx
80105471:	8b 40 18             	mov    0x18(%eax),%eax
80105474:	8b 40 44             	mov    0x44(%eax),%eax
80105477:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
8010547a:	e8 41 ed ff ff       	call   801041c0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010547f:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105482:	8b 00                	mov    (%eax),%eax
80105484:	39 c6                	cmp    %eax,%esi
80105486:	73 18                	jae    801054a0 <argint+0x40>
80105488:	8d 53 08             	lea    0x8(%ebx),%edx
8010548b:	39 d0                	cmp    %edx,%eax
8010548d:	72 11                	jb     801054a0 <argint+0x40>
  *ip = *(int*)(addr);
8010548f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105492:	8b 53 04             	mov    0x4(%ebx),%edx
80105495:	89 10                	mov    %edx,(%eax)
  return 0;
80105497:	31 c0                	xor    %eax,%eax
}
80105499:	5b                   	pop    %ebx
8010549a:	5e                   	pop    %esi
8010549b:	5d                   	pop    %ebp
8010549c:	c3                   	ret    
8010549d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801054a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801054a5:	eb f2                	jmp    80105499 <argint+0x39>
801054a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054ae:	66 90                	xchg   %ax,%ax

801054b0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801054b0:	f3 0f 1e fb          	endbr32 
801054b4:	55                   	push   %ebp
801054b5:	89 e5                	mov    %esp,%ebp
801054b7:	56                   	push   %esi
801054b8:	53                   	push   %ebx
801054b9:	83 ec 10             	sub    $0x10,%esp
801054bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801054bf:	e8 fc ec ff ff       	call   801041c0 <myproc>
 
  if(argint(n, &i) < 0)
801054c4:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
801054c7:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
801054c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054cc:	50                   	push   %eax
801054cd:	ff 75 08             	pushl  0x8(%ebp)
801054d0:	e8 8b ff ff ff       	call   80105460 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801054d5:	83 c4 10             	add    $0x10,%esp
801054d8:	85 c0                	test   %eax,%eax
801054da:	78 24                	js     80105500 <argptr+0x50>
801054dc:	85 db                	test   %ebx,%ebx
801054de:	78 20                	js     80105500 <argptr+0x50>
801054e0:	8b 16                	mov    (%esi),%edx
801054e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054e5:	39 c2                	cmp    %eax,%edx
801054e7:	76 17                	jbe    80105500 <argptr+0x50>
801054e9:	01 c3                	add    %eax,%ebx
801054eb:	39 da                	cmp    %ebx,%edx
801054ed:	72 11                	jb     80105500 <argptr+0x50>
    return -1;
  *pp = (char*)i;
801054ef:	8b 55 0c             	mov    0xc(%ebp),%edx
801054f2:	89 02                	mov    %eax,(%edx)
  return 0;
801054f4:	31 c0                	xor    %eax,%eax
}
801054f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054f9:	5b                   	pop    %ebx
801054fa:	5e                   	pop    %esi
801054fb:	5d                   	pop    %ebp
801054fc:	c3                   	ret    
801054fd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105500:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105505:	eb ef                	jmp    801054f6 <argptr+0x46>
80105507:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010550e:	66 90                	xchg   %ax,%ax

80105510 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105510:	f3 0f 1e fb          	endbr32 
80105514:	55                   	push   %ebp
80105515:	89 e5                	mov    %esp,%ebp
80105517:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
8010551a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010551d:	50                   	push   %eax
8010551e:	ff 75 08             	pushl  0x8(%ebp)
80105521:	e8 3a ff ff ff       	call   80105460 <argint>
80105526:	83 c4 10             	add    $0x10,%esp
80105529:	85 c0                	test   %eax,%eax
8010552b:	78 13                	js     80105540 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
8010552d:	83 ec 08             	sub    $0x8,%esp
80105530:	ff 75 0c             	pushl  0xc(%ebp)
80105533:	ff 75 f4             	pushl  -0xc(%ebp)
80105536:	e8 c5 fe ff ff       	call   80105400 <fetchstr>
8010553b:	83 c4 10             	add    $0x10,%esp
}
8010553e:	c9                   	leave  
8010553f:	c3                   	ret    
80105540:	c9                   	leave  
    return -1;
80105541:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105546:	c3                   	ret    
80105547:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010554e:	66 90                	xchg   %ax,%ax

80105550 <syscall>:
[SYS_get_number_of_free_pages] sys_get_number_of_free_pages
};

void
syscall(void)
{
80105550:	f3 0f 1e fb          	endbr32 
80105554:	55                   	push   %ebp
80105555:	89 e5                	mov    %esp,%ebp
80105557:	53                   	push   %ebx
80105558:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
8010555b:	e8 60 ec ff ff       	call   801041c0 <myproc>
80105560:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80105562:	8b 40 18             	mov    0x18(%eax),%eax
80105565:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105568:	8d 50 ff             	lea    -0x1(%eax),%edx
8010556b:	83 fa 15             	cmp    $0x15,%edx
8010556e:	77 20                	ja     80105590 <syscall+0x40>
80105570:	8b 14 85 e0 8e 10 80 	mov    -0x7fef7120(,%eax,4),%edx
80105577:	85 d2                	test   %edx,%edx
80105579:	74 15                	je     80105590 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
8010557b:	ff d2                	call   *%edx
8010557d:	89 c2                	mov    %eax,%edx
8010557f:	8b 43 18             	mov    0x18(%ebx),%eax
80105582:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105585:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105588:	c9                   	leave  
80105589:	c3                   	ret    
8010558a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105590:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105591:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105594:	50                   	push   %eax
80105595:	ff 73 10             	pushl  0x10(%ebx)
80105598:	68 a9 8e 10 80       	push   $0x80108ea9
8010559d:	e8 0e b1 ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
801055a2:	8b 43 18             	mov    0x18(%ebx),%eax
801055a5:	83 c4 10             	add    $0x10,%esp
801055a8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801055af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801055b2:	c9                   	leave  
801055b3:	c3                   	ret    
801055b4:	66 90                	xchg   %ax,%ax
801055b6:	66 90                	xchg   %ax,%ax
801055b8:	66 90                	xchg   %ax,%ax
801055ba:	66 90                	xchg   %ax,%ax
801055bc:	66 90                	xchg   %ax,%ax
801055be:	66 90                	xchg   %ax,%ax

801055c0 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
801055c0:	55                   	push   %ebp
801055c1:	89 e5                	mov    %esp,%ebp
801055c3:	56                   	push   %esi
801055c4:	89 d6                	mov    %edx,%esi
801055c6:	53                   	push   %ebx
801055c7:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801055c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
801055cc:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801055cf:	50                   	push   %eax
801055d0:	6a 00                	push   $0x0
801055d2:	e8 89 fe ff ff       	call   80105460 <argint>
801055d7:	83 c4 10             	add    $0x10,%esp
801055da:	85 c0                	test   %eax,%eax
801055dc:	78 2a                	js     80105608 <argfd.constprop.0+0x48>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801055de:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801055e2:	77 24                	ja     80105608 <argfd.constprop.0+0x48>
801055e4:	e8 d7 eb ff ff       	call   801041c0 <myproc>
801055e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801055ec:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801055f0:	85 c0                	test   %eax,%eax
801055f2:	74 14                	je     80105608 <argfd.constprop.0+0x48>
    return -1;
  if(pfd)
801055f4:	85 db                	test   %ebx,%ebx
801055f6:	74 02                	je     801055fa <argfd.constprop.0+0x3a>
    *pfd = fd;
801055f8:	89 13                	mov    %edx,(%ebx)
  if(pf)
    *pf = f;
801055fa:	89 06                	mov    %eax,(%esi)
  return 0;
801055fc:	31 c0                	xor    %eax,%eax
}
801055fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105601:	5b                   	pop    %ebx
80105602:	5e                   	pop    %esi
80105603:	5d                   	pop    %ebp
80105604:	c3                   	ret    
80105605:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105608:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010560d:	eb ef                	jmp    801055fe <argfd.constprop.0+0x3e>
8010560f:	90                   	nop

80105610 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80105610:	f3 0f 1e fb          	endbr32 
80105614:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105615:	31 c0                	xor    %eax,%eax
{
80105617:	89 e5                	mov    %esp,%ebp
80105619:	56                   	push   %esi
8010561a:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
8010561b:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010561e:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80105621:	e8 9a ff ff ff       	call   801055c0 <argfd.constprop.0>
80105626:	85 c0                	test   %eax,%eax
80105628:	78 1e                	js     80105648 <sys_dup+0x38>
    return -1;
  if((fd=fdalloc(f)) < 0)
8010562a:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
8010562d:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010562f:	e8 8c eb ff ff       	call   801041c0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105638:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
8010563c:	85 d2                	test   %edx,%edx
8010563e:	74 20                	je     80105660 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80105640:	83 c3 01             	add    $0x1,%ebx
80105643:	83 fb 10             	cmp    $0x10,%ebx
80105646:	75 f0                	jne    80105638 <sys_dup+0x28>
    return -1;
  filedup(f);
  return fd;
}
80105648:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010564b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105650:	89 d8                	mov    %ebx,%eax
80105652:	5b                   	pop    %ebx
80105653:	5e                   	pop    %esi
80105654:	5d                   	pop    %ebp
80105655:	c3                   	ret    
80105656:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010565d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105660:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105664:	83 ec 0c             	sub    $0xc,%esp
80105667:	ff 75 f4             	pushl  -0xc(%ebp)
8010566a:	e8 c1 bb ff ff       	call   80101230 <filedup>
  return fd;
8010566f:	83 c4 10             	add    $0x10,%esp
}
80105672:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105675:	89 d8                	mov    %ebx,%eax
80105677:	5b                   	pop    %ebx
80105678:	5e                   	pop    %esi
80105679:	5d                   	pop    %ebp
8010567a:	c3                   	ret    
8010567b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010567f:	90                   	nop

80105680 <sys_read>:

int
sys_read(void)
{
80105680:	f3 0f 1e fb          	endbr32 
80105684:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105685:	31 c0                	xor    %eax,%eax
{
80105687:	89 e5                	mov    %esp,%ebp
80105689:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010568c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010568f:	e8 2c ff ff ff       	call   801055c0 <argfd.constprop.0>
80105694:	85 c0                	test   %eax,%eax
80105696:	78 48                	js     801056e0 <sys_read+0x60>
80105698:	83 ec 08             	sub    $0x8,%esp
8010569b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010569e:	50                   	push   %eax
8010569f:	6a 02                	push   $0x2
801056a1:	e8 ba fd ff ff       	call   80105460 <argint>
801056a6:	83 c4 10             	add    $0x10,%esp
801056a9:	85 c0                	test   %eax,%eax
801056ab:	78 33                	js     801056e0 <sys_read+0x60>
801056ad:	83 ec 04             	sub    $0x4,%esp
801056b0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056b3:	ff 75 f0             	pushl  -0x10(%ebp)
801056b6:	50                   	push   %eax
801056b7:	6a 01                	push   $0x1
801056b9:	e8 f2 fd ff ff       	call   801054b0 <argptr>
801056be:	83 c4 10             	add    $0x10,%esp
801056c1:	85 c0                	test   %eax,%eax
801056c3:	78 1b                	js     801056e0 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
801056c5:	83 ec 04             	sub    $0x4,%esp
801056c8:	ff 75 f0             	pushl  -0x10(%ebp)
801056cb:	ff 75 f4             	pushl  -0xc(%ebp)
801056ce:	ff 75 ec             	pushl  -0x14(%ebp)
801056d1:	e8 da bc ff ff       	call   801013b0 <fileread>
801056d6:	83 c4 10             	add    $0x10,%esp
}
801056d9:	c9                   	leave  
801056da:	c3                   	ret    
801056db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056df:	90                   	nop
801056e0:	c9                   	leave  
    return -1;
801056e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056e6:	c3                   	ret    
801056e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056ee:	66 90                	xchg   %ax,%ax

801056f0 <sys_write>:

int
sys_write(void)
{
801056f0:	f3 0f 1e fb          	endbr32 
801056f4:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801056f5:	31 c0                	xor    %eax,%eax
{
801056f7:	89 e5                	mov    %esp,%ebp
801056f9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801056fc:	8d 55 ec             	lea    -0x14(%ebp),%edx
801056ff:	e8 bc fe ff ff       	call   801055c0 <argfd.constprop.0>
80105704:	85 c0                	test   %eax,%eax
80105706:	78 48                	js     80105750 <sys_write+0x60>
80105708:	83 ec 08             	sub    $0x8,%esp
8010570b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010570e:	50                   	push   %eax
8010570f:	6a 02                	push   $0x2
80105711:	e8 4a fd ff ff       	call   80105460 <argint>
80105716:	83 c4 10             	add    $0x10,%esp
80105719:	85 c0                	test   %eax,%eax
8010571b:	78 33                	js     80105750 <sys_write+0x60>
8010571d:	83 ec 04             	sub    $0x4,%esp
80105720:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105723:	ff 75 f0             	pushl  -0x10(%ebp)
80105726:	50                   	push   %eax
80105727:	6a 01                	push   $0x1
80105729:	e8 82 fd ff ff       	call   801054b0 <argptr>
8010572e:	83 c4 10             	add    $0x10,%esp
80105731:	85 c0                	test   %eax,%eax
80105733:	78 1b                	js     80105750 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80105735:	83 ec 04             	sub    $0x4,%esp
80105738:	ff 75 f0             	pushl  -0x10(%ebp)
8010573b:	ff 75 f4             	pushl  -0xc(%ebp)
8010573e:	ff 75 ec             	pushl  -0x14(%ebp)
80105741:	e8 0a bd ff ff       	call   80101450 <filewrite>
80105746:	83 c4 10             	add    $0x10,%esp
}
80105749:	c9                   	leave  
8010574a:	c3                   	ret    
8010574b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010574f:	90                   	nop
80105750:	c9                   	leave  
    return -1;
80105751:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105756:	c3                   	ret    
80105757:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010575e:	66 90                	xchg   %ax,%ax

80105760 <sys_close>:

int
sys_close(void)
{
80105760:	f3 0f 1e fb          	endbr32 
80105764:	55                   	push   %ebp
80105765:	89 e5                	mov    %esp,%ebp
80105767:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
8010576a:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010576d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105770:	e8 4b fe ff ff       	call   801055c0 <argfd.constprop.0>
80105775:	85 c0                	test   %eax,%eax
80105777:	78 27                	js     801057a0 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80105779:	e8 42 ea ff ff       	call   801041c0 <myproc>
8010577e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80105781:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105784:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
8010578b:	00 
  fileclose(f);
8010578c:	ff 75 f4             	pushl  -0xc(%ebp)
8010578f:	e8 ec ba ff ff       	call   80101280 <fileclose>
  return 0;
80105794:	83 c4 10             	add    $0x10,%esp
80105797:	31 c0                	xor    %eax,%eax
}
80105799:	c9                   	leave  
8010579a:	c3                   	ret    
8010579b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010579f:	90                   	nop
801057a0:	c9                   	leave  
    return -1;
801057a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057a6:	c3                   	ret    
801057a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057ae:	66 90                	xchg   %ax,%ax

801057b0 <sys_fstat>:

int
sys_fstat(void)
{
801057b0:	f3 0f 1e fb          	endbr32 
801057b4:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801057b5:	31 c0                	xor    %eax,%eax
{
801057b7:	89 e5                	mov    %esp,%ebp
801057b9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801057bc:	8d 55 f0             	lea    -0x10(%ebp),%edx
801057bf:	e8 fc fd ff ff       	call   801055c0 <argfd.constprop.0>
801057c4:	85 c0                	test   %eax,%eax
801057c6:	78 30                	js     801057f8 <sys_fstat+0x48>
801057c8:	83 ec 04             	sub    $0x4,%esp
801057cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057ce:	6a 14                	push   $0x14
801057d0:	50                   	push   %eax
801057d1:	6a 01                	push   $0x1
801057d3:	e8 d8 fc ff ff       	call   801054b0 <argptr>
801057d8:	83 c4 10             	add    $0x10,%esp
801057db:	85 c0                	test   %eax,%eax
801057dd:	78 19                	js     801057f8 <sys_fstat+0x48>
    return -1;
  return filestat(f, st);
801057df:	83 ec 08             	sub    $0x8,%esp
801057e2:	ff 75 f4             	pushl  -0xc(%ebp)
801057e5:	ff 75 f0             	pushl  -0x10(%ebp)
801057e8:	e8 73 bb ff ff       	call   80101360 <filestat>
801057ed:	83 c4 10             	add    $0x10,%esp
}
801057f0:	c9                   	leave  
801057f1:	c3                   	ret    
801057f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801057f8:	c9                   	leave  
    return -1;
801057f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057fe:	c3                   	ret    
801057ff:	90                   	nop

80105800 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105800:	f3 0f 1e fb          	endbr32 
80105804:	55                   	push   %ebp
80105805:	89 e5                	mov    %esp,%ebp
80105807:	57                   	push   %edi
80105808:	56                   	push   %esi
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105809:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
8010580c:	53                   	push   %ebx
8010580d:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105810:	50                   	push   %eax
80105811:	6a 00                	push   $0x0
80105813:	e8 f8 fc ff ff       	call   80105510 <argstr>
80105818:	83 c4 10             	add    $0x10,%esp
8010581b:	85 c0                	test   %eax,%eax
8010581d:	0f 88 ff 00 00 00    	js     80105922 <sys_link+0x122>
80105823:	83 ec 08             	sub    $0x8,%esp
80105826:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105829:	50                   	push   %eax
8010582a:	6a 01                	push   $0x1
8010582c:	e8 df fc ff ff       	call   80105510 <argstr>
80105831:	83 c4 10             	add    $0x10,%esp
80105834:	85 c0                	test   %eax,%eax
80105836:	0f 88 e6 00 00 00    	js     80105922 <sys_link+0x122>
    return -1;

  begin_op();
8010583c:	e8 bf dc ff ff       	call   80103500 <begin_op>
  if((ip = namei(old)) == 0){
80105841:	83 ec 0c             	sub    $0xc,%esp
80105844:	ff 75 d4             	pushl  -0x2c(%ebp)
80105847:	e8 a4 cb ff ff       	call   801023f0 <namei>
8010584c:	83 c4 10             	add    $0x10,%esp
8010584f:	89 c3                	mov    %eax,%ebx
80105851:	85 c0                	test   %eax,%eax
80105853:	0f 84 e8 00 00 00    	je     80105941 <sys_link+0x141>
    end_op();
    return -1;
  }

  ilock(ip);
80105859:	83 ec 0c             	sub    $0xc,%esp
8010585c:	50                   	push   %eax
8010585d:	e8 be c2 ff ff       	call   80101b20 <ilock>
  if(ip->type == T_DIR){
80105862:	83 c4 10             	add    $0x10,%esp
80105865:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010586a:	0f 84 b9 00 00 00    	je     80105929 <sys_link+0x129>
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80105870:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105873:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80105878:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
8010587b:	53                   	push   %ebx
8010587c:	e8 df c1 ff ff       	call   80101a60 <iupdate>
  iunlock(ip);
80105881:	89 1c 24             	mov    %ebx,(%esp)
80105884:	e8 77 c3 ff ff       	call   80101c00 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105889:	58                   	pop    %eax
8010588a:	5a                   	pop    %edx
8010588b:	57                   	push   %edi
8010588c:	ff 75 d0             	pushl  -0x30(%ebp)
8010588f:	e8 7c cb ff ff       	call   80102410 <nameiparent>
80105894:	83 c4 10             	add    $0x10,%esp
80105897:	89 c6                	mov    %eax,%esi
80105899:	85 c0                	test   %eax,%eax
8010589b:	74 5f                	je     801058fc <sys_link+0xfc>
    goto bad;
  ilock(dp);
8010589d:	83 ec 0c             	sub    $0xc,%esp
801058a0:	50                   	push   %eax
801058a1:	e8 7a c2 ff ff       	call   80101b20 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801058a6:	8b 03                	mov    (%ebx),%eax
801058a8:	83 c4 10             	add    $0x10,%esp
801058ab:	39 06                	cmp    %eax,(%esi)
801058ad:	75 41                	jne    801058f0 <sys_link+0xf0>
801058af:	83 ec 04             	sub    $0x4,%esp
801058b2:	ff 73 04             	pushl  0x4(%ebx)
801058b5:	57                   	push   %edi
801058b6:	56                   	push   %esi
801058b7:	e8 74 ca ff ff       	call   80102330 <dirlink>
801058bc:	83 c4 10             	add    $0x10,%esp
801058bf:	85 c0                	test   %eax,%eax
801058c1:	78 2d                	js     801058f0 <sys_link+0xf0>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
801058c3:	83 ec 0c             	sub    $0xc,%esp
801058c6:	56                   	push   %esi
801058c7:	e8 f4 c4 ff ff       	call   80101dc0 <iunlockput>
  iput(ip);
801058cc:	89 1c 24             	mov    %ebx,(%esp)
801058cf:	e8 7c c3 ff ff       	call   80101c50 <iput>

  end_op();
801058d4:	e8 97 dc ff ff       	call   80103570 <end_op>

  return 0;
801058d9:	83 c4 10             	add    $0x10,%esp
801058dc:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
801058de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058e1:	5b                   	pop    %ebx
801058e2:	5e                   	pop    %esi
801058e3:	5f                   	pop    %edi
801058e4:	5d                   	pop    %ebp
801058e5:	c3                   	ret    
801058e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ed:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
801058f0:	83 ec 0c             	sub    $0xc,%esp
801058f3:	56                   	push   %esi
801058f4:	e8 c7 c4 ff ff       	call   80101dc0 <iunlockput>
    goto bad;
801058f9:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801058fc:	83 ec 0c             	sub    $0xc,%esp
801058ff:	53                   	push   %ebx
80105900:	e8 1b c2 ff ff       	call   80101b20 <ilock>
  ip->nlink--;
80105905:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010590a:	89 1c 24             	mov    %ebx,(%esp)
8010590d:	e8 4e c1 ff ff       	call   80101a60 <iupdate>
  iunlockput(ip);
80105912:	89 1c 24             	mov    %ebx,(%esp)
80105915:	e8 a6 c4 ff ff       	call   80101dc0 <iunlockput>
  end_op();
8010591a:	e8 51 dc ff ff       	call   80103570 <end_op>
  return -1;
8010591f:	83 c4 10             	add    $0x10,%esp
80105922:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105927:	eb b5                	jmp    801058de <sys_link+0xde>
    iunlockput(ip);
80105929:	83 ec 0c             	sub    $0xc,%esp
8010592c:	53                   	push   %ebx
8010592d:	e8 8e c4 ff ff       	call   80101dc0 <iunlockput>
    end_op();
80105932:	e8 39 dc ff ff       	call   80103570 <end_op>
    return -1;
80105937:	83 c4 10             	add    $0x10,%esp
8010593a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010593f:	eb 9d                	jmp    801058de <sys_link+0xde>
    end_op();
80105941:	e8 2a dc ff ff       	call   80103570 <end_op>
    return -1;
80105946:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010594b:	eb 91                	jmp    801058de <sys_link+0xde>
8010594d:	8d 76 00             	lea    0x0(%esi),%esi

80105950 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
80105950:	f3 0f 1e fb          	endbr32 
80105954:	55                   	push   %ebp
80105955:	89 e5                	mov    %esp,%ebp
80105957:	57                   	push   %edi
80105958:	56                   	push   %esi
80105959:	8d 7d d8             	lea    -0x28(%ebp),%edi
8010595c:	53                   	push   %ebx
8010595d:	bb 20 00 00 00       	mov    $0x20,%ebx
80105962:	83 ec 1c             	sub    $0x1c,%esp
80105965:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105968:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
8010596c:	77 0a                	ja     80105978 <isdirempty+0x28>
8010596e:	eb 30                	jmp    801059a0 <isdirempty+0x50>
80105970:	83 c3 10             	add    $0x10,%ebx
80105973:	39 5e 58             	cmp    %ebx,0x58(%esi)
80105976:	76 28                	jbe    801059a0 <isdirempty+0x50>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105978:	6a 10                	push   $0x10
8010597a:	53                   	push   %ebx
8010597b:	57                   	push   %edi
8010597c:	56                   	push   %esi
8010597d:	e8 9e c4 ff ff       	call   80101e20 <readi>
80105982:	83 c4 10             	add    $0x10,%esp
80105985:	83 f8 10             	cmp    $0x10,%eax
80105988:	75 23                	jne    801059ad <isdirempty+0x5d>
      panic("isdirempty: readi");
    if(de.inum != 0)
8010598a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010598f:	74 df                	je     80105970 <isdirempty+0x20>
      return 0;
  }
  return 1;
}
80105991:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80105994:	31 c0                	xor    %eax,%eax
}
80105996:	5b                   	pop    %ebx
80105997:	5e                   	pop    %esi
80105998:	5f                   	pop    %edi
80105999:	5d                   	pop    %ebp
8010599a:	c3                   	ret    
8010599b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010599f:	90                   	nop
801059a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 1;
801059a3:	b8 01 00 00 00       	mov    $0x1,%eax
}
801059a8:	5b                   	pop    %ebx
801059a9:	5e                   	pop    %esi
801059aa:	5f                   	pop    %edi
801059ab:	5d                   	pop    %ebp
801059ac:	c3                   	ret    
      panic("isdirempty: readi");
801059ad:	83 ec 0c             	sub    $0xc,%esp
801059b0:	68 3c 8f 10 80       	push   $0x80108f3c
801059b5:	e8 d6 a9 ff ff       	call   80100390 <panic>
801059ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801059c0 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
801059c0:	f3 0f 1e fb          	endbr32 
801059c4:	55                   	push   %ebp
801059c5:	89 e5                	mov    %esp,%ebp
801059c7:	57                   	push   %edi
801059c8:	56                   	push   %esi
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801059c9:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801059cc:	53                   	push   %ebx
801059cd:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
801059d0:	50                   	push   %eax
801059d1:	6a 00                	push   $0x0
801059d3:	e8 38 fb ff ff       	call   80105510 <argstr>
801059d8:	83 c4 10             	add    $0x10,%esp
801059db:	85 c0                	test   %eax,%eax
801059dd:	0f 88 5d 01 00 00    	js     80105b40 <sys_unlink+0x180>
    return -1;

  begin_op();
801059e3:	e8 18 db ff ff       	call   80103500 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801059e8:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801059eb:	83 ec 08             	sub    $0x8,%esp
801059ee:	53                   	push   %ebx
801059ef:	ff 75 c0             	pushl  -0x40(%ebp)
801059f2:	e8 19 ca ff ff       	call   80102410 <nameiparent>
801059f7:	83 c4 10             	add    $0x10,%esp
801059fa:	89 c6                	mov    %eax,%esi
801059fc:	85 c0                	test   %eax,%eax
801059fe:	0f 84 43 01 00 00    	je     80105b47 <sys_unlink+0x187>
    end_op();
    return -1;
  }

  ilock(dp);
80105a04:	83 ec 0c             	sub    $0xc,%esp
80105a07:	50                   	push   %eax
80105a08:	e8 13 c1 ff ff       	call   80101b20 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105a0d:	58                   	pop    %eax
80105a0e:	5a                   	pop    %edx
80105a0f:	68 dd 88 10 80       	push   $0x801088dd
80105a14:	53                   	push   %ebx
80105a15:	e8 36 c6 ff ff       	call   80102050 <namecmp>
80105a1a:	83 c4 10             	add    $0x10,%esp
80105a1d:	85 c0                	test   %eax,%eax
80105a1f:	0f 84 db 00 00 00    	je     80105b00 <sys_unlink+0x140>
80105a25:	83 ec 08             	sub    $0x8,%esp
80105a28:	68 dc 88 10 80       	push   $0x801088dc
80105a2d:	53                   	push   %ebx
80105a2e:	e8 1d c6 ff ff       	call   80102050 <namecmp>
80105a33:	83 c4 10             	add    $0x10,%esp
80105a36:	85 c0                	test   %eax,%eax
80105a38:	0f 84 c2 00 00 00    	je     80105b00 <sys_unlink+0x140>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105a3e:	83 ec 04             	sub    $0x4,%esp
80105a41:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105a44:	50                   	push   %eax
80105a45:	53                   	push   %ebx
80105a46:	56                   	push   %esi
80105a47:	e8 24 c6 ff ff       	call   80102070 <dirlookup>
80105a4c:	83 c4 10             	add    $0x10,%esp
80105a4f:	89 c3                	mov    %eax,%ebx
80105a51:	85 c0                	test   %eax,%eax
80105a53:	0f 84 a7 00 00 00    	je     80105b00 <sys_unlink+0x140>
    goto bad;
  ilock(ip);
80105a59:	83 ec 0c             	sub    $0xc,%esp
80105a5c:	50                   	push   %eax
80105a5d:	e8 be c0 ff ff       	call   80101b20 <ilock>

  if(ip->nlink < 1)
80105a62:	83 c4 10             	add    $0x10,%esp
80105a65:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105a6a:	0f 8e f3 00 00 00    	jle    80105b63 <sys_unlink+0x1a3>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80105a70:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105a75:	74 69                	je     80105ae0 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80105a77:	83 ec 04             	sub    $0x4,%esp
80105a7a:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105a7d:	6a 10                	push   $0x10
80105a7f:	6a 00                	push   $0x0
80105a81:	57                   	push   %edi
80105a82:	e8 f9 f6 ff ff       	call   80105180 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105a87:	6a 10                	push   $0x10
80105a89:	ff 75 c4             	pushl  -0x3c(%ebp)
80105a8c:	57                   	push   %edi
80105a8d:	56                   	push   %esi
80105a8e:	e8 8d c4 ff ff       	call   80101f20 <writei>
80105a93:	83 c4 20             	add    $0x20,%esp
80105a96:	83 f8 10             	cmp    $0x10,%eax
80105a99:	0f 85 b7 00 00 00    	jne    80105b56 <sys_unlink+0x196>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80105a9f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105aa4:	74 7a                	je     80105b20 <sys_unlink+0x160>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80105aa6:	83 ec 0c             	sub    $0xc,%esp
80105aa9:	56                   	push   %esi
80105aaa:	e8 11 c3 ff ff       	call   80101dc0 <iunlockput>

  ip->nlink--;
80105aaf:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105ab4:	89 1c 24             	mov    %ebx,(%esp)
80105ab7:	e8 a4 bf ff ff       	call   80101a60 <iupdate>
  iunlockput(ip);
80105abc:	89 1c 24             	mov    %ebx,(%esp)
80105abf:	e8 fc c2 ff ff       	call   80101dc0 <iunlockput>

  end_op();
80105ac4:	e8 a7 da ff ff       	call   80103570 <end_op>

  return 0;
80105ac9:	83 c4 10             	add    $0x10,%esp
80105acc:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80105ace:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ad1:	5b                   	pop    %ebx
80105ad2:	5e                   	pop    %esi
80105ad3:	5f                   	pop    %edi
80105ad4:	5d                   	pop    %ebp
80105ad5:	c3                   	ret    
80105ad6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105add:	8d 76 00             	lea    0x0(%esi),%esi
  if(ip->type == T_DIR && !isdirempty(ip)){
80105ae0:	83 ec 0c             	sub    $0xc,%esp
80105ae3:	53                   	push   %ebx
80105ae4:	e8 67 fe ff ff       	call   80105950 <isdirempty>
80105ae9:	83 c4 10             	add    $0x10,%esp
80105aec:	85 c0                	test   %eax,%eax
80105aee:	75 87                	jne    80105a77 <sys_unlink+0xb7>
    iunlockput(ip);
80105af0:	83 ec 0c             	sub    $0xc,%esp
80105af3:	53                   	push   %ebx
80105af4:	e8 c7 c2 ff ff       	call   80101dc0 <iunlockput>
    goto bad;
80105af9:	83 c4 10             	add    $0x10,%esp
80105afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
80105b00:	83 ec 0c             	sub    $0xc,%esp
80105b03:	56                   	push   %esi
80105b04:	e8 b7 c2 ff ff       	call   80101dc0 <iunlockput>
  end_op();
80105b09:	e8 62 da ff ff       	call   80103570 <end_op>
  return -1;
80105b0e:	83 c4 10             	add    $0x10,%esp
80105b11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b16:	eb b6                	jmp    80105ace <sys_unlink+0x10e>
80105b18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b1f:	90                   	nop
    iupdate(dp);
80105b20:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105b23:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105b28:	56                   	push   %esi
80105b29:	e8 32 bf ff ff       	call   80101a60 <iupdate>
80105b2e:	83 c4 10             	add    $0x10,%esp
80105b31:	e9 70 ff ff ff       	jmp    80105aa6 <sys_unlink+0xe6>
80105b36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b3d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105b40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b45:	eb 87                	jmp    80105ace <sys_unlink+0x10e>
    end_op();
80105b47:	e8 24 da ff ff       	call   80103570 <end_op>
    return -1;
80105b4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b51:	e9 78 ff ff ff       	jmp    80105ace <sys_unlink+0x10e>
    panic("unlink: writei");
80105b56:	83 ec 0c             	sub    $0xc,%esp
80105b59:	68 f1 88 10 80       	push   $0x801088f1
80105b5e:	e8 2d a8 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105b63:	83 ec 0c             	sub    $0xc,%esp
80105b66:	68 df 88 10 80       	push   $0x801088df
80105b6b:	e8 20 a8 ff ff       	call   80100390 <panic>

80105b70 <create>:

struct inode*
create(char *path, short type, short major, short minor)
{
80105b70:	f3 0f 1e fb          	endbr32 
80105b74:	55                   	push   %ebp
80105b75:	89 e5                	mov    %esp,%ebp
80105b77:	57                   	push   %edi
80105b78:	56                   	push   %esi
80105b79:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105b7a:	8d 5d da             	lea    -0x26(%ebp),%ebx
{
80105b7d:	83 ec 34             	sub    $0x34,%esp
80105b80:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b83:	8b 55 10             	mov    0x10(%ebp),%edx
  if((dp = nameiparent(path, name)) == 0)
80105b86:	53                   	push   %ebx
{
80105b87:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105b8a:	ff 75 08             	pushl  0x8(%ebp)
{
80105b8d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80105b90:	89 55 d0             	mov    %edx,-0x30(%ebp)
80105b93:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105b96:	e8 75 c8 ff ff       	call   80102410 <nameiparent>
80105b9b:	83 c4 10             	add    $0x10,%esp
80105b9e:	85 c0                	test   %eax,%eax
80105ba0:	0f 84 3a 01 00 00    	je     80105ce0 <create+0x170>
    return 0;
  ilock(dp);
80105ba6:	83 ec 0c             	sub    $0xc,%esp
80105ba9:	89 c6                	mov    %eax,%esi
80105bab:	50                   	push   %eax
80105bac:	e8 6f bf ff ff       	call   80101b20 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105bb1:	83 c4 0c             	add    $0xc,%esp
80105bb4:	6a 00                	push   $0x0
80105bb6:	53                   	push   %ebx
80105bb7:	56                   	push   %esi
80105bb8:	e8 b3 c4 ff ff       	call   80102070 <dirlookup>
80105bbd:	83 c4 10             	add    $0x10,%esp
80105bc0:	89 c7                	mov    %eax,%edi
80105bc2:	85 c0                	test   %eax,%eax
80105bc4:	74 4a                	je     80105c10 <create+0xa0>
    iunlockput(dp);
80105bc6:	83 ec 0c             	sub    $0xc,%esp
80105bc9:	56                   	push   %esi
80105bca:	e8 f1 c1 ff ff       	call   80101dc0 <iunlockput>
    ilock(ip);
80105bcf:	89 3c 24             	mov    %edi,(%esp)
80105bd2:	e8 49 bf ff ff       	call   80101b20 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105bd7:	83 c4 10             	add    $0x10,%esp
80105bda:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105bdf:	75 17                	jne    80105bf8 <create+0x88>
80105be1:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80105be6:	75 10                	jne    80105bf8 <create+0x88>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105be8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105beb:	89 f8                	mov    %edi,%eax
80105bed:	5b                   	pop    %ebx
80105bee:	5e                   	pop    %esi
80105bef:	5f                   	pop    %edi
80105bf0:	5d                   	pop    %ebp
80105bf1:	c3                   	ret    
80105bf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105bf8:	83 ec 0c             	sub    $0xc,%esp
80105bfb:	57                   	push   %edi
    return 0;
80105bfc:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105bfe:	e8 bd c1 ff ff       	call   80101dc0 <iunlockput>
    return 0;
80105c03:	83 c4 10             	add    $0x10,%esp
}
80105c06:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c09:	89 f8                	mov    %edi,%eax
80105c0b:	5b                   	pop    %ebx
80105c0c:	5e                   	pop    %esi
80105c0d:	5f                   	pop    %edi
80105c0e:	5d                   	pop    %ebp
80105c0f:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80105c10:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105c14:	83 ec 08             	sub    $0x8,%esp
80105c17:	50                   	push   %eax
80105c18:	ff 36                	pushl  (%esi)
80105c1a:	e8 81 bd ff ff       	call   801019a0 <ialloc>
80105c1f:	83 c4 10             	add    $0x10,%esp
80105c22:	89 c7                	mov    %eax,%edi
80105c24:	85 c0                	test   %eax,%eax
80105c26:	0f 84 cd 00 00 00    	je     80105cf9 <create+0x189>
  ilock(ip);
80105c2c:	83 ec 0c             	sub    $0xc,%esp
80105c2f:	50                   	push   %eax
80105c30:	e8 eb be ff ff       	call   80101b20 <ilock>
  ip->major = major;
80105c35:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105c39:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80105c3d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105c41:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105c45:	b8 01 00 00 00       	mov    $0x1,%eax
80105c4a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80105c4e:	89 3c 24             	mov    %edi,(%esp)
80105c51:	e8 0a be ff ff       	call   80101a60 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105c56:	83 c4 10             	add    $0x10,%esp
80105c59:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105c5e:	74 30                	je     80105c90 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105c60:	83 ec 04             	sub    $0x4,%esp
80105c63:	ff 77 04             	pushl  0x4(%edi)
80105c66:	53                   	push   %ebx
80105c67:	56                   	push   %esi
80105c68:	e8 c3 c6 ff ff       	call   80102330 <dirlink>
80105c6d:	83 c4 10             	add    $0x10,%esp
80105c70:	85 c0                	test   %eax,%eax
80105c72:	78 78                	js     80105cec <create+0x17c>
  iunlockput(dp);
80105c74:	83 ec 0c             	sub    $0xc,%esp
80105c77:	56                   	push   %esi
80105c78:	e8 43 c1 ff ff       	call   80101dc0 <iunlockput>
  return ip;
80105c7d:	83 c4 10             	add    $0x10,%esp
}
80105c80:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c83:	89 f8                	mov    %edi,%eax
80105c85:	5b                   	pop    %ebx
80105c86:	5e                   	pop    %esi
80105c87:	5f                   	pop    %edi
80105c88:	5d                   	pop    %ebp
80105c89:	c3                   	ret    
80105c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105c90:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105c93:	66 83 46 56 01       	addw   $0x1,0x56(%esi)
    iupdate(dp);
80105c98:	56                   	push   %esi
80105c99:	e8 c2 bd ff ff       	call   80101a60 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105c9e:	83 c4 0c             	add    $0xc,%esp
80105ca1:	ff 77 04             	pushl  0x4(%edi)
80105ca4:	68 dd 88 10 80       	push   $0x801088dd
80105ca9:	57                   	push   %edi
80105caa:	e8 81 c6 ff ff       	call   80102330 <dirlink>
80105caf:	83 c4 10             	add    $0x10,%esp
80105cb2:	85 c0                	test   %eax,%eax
80105cb4:	78 18                	js     80105cce <create+0x15e>
80105cb6:	83 ec 04             	sub    $0x4,%esp
80105cb9:	ff 76 04             	pushl  0x4(%esi)
80105cbc:	68 dc 88 10 80       	push   $0x801088dc
80105cc1:	57                   	push   %edi
80105cc2:	e8 69 c6 ff ff       	call   80102330 <dirlink>
80105cc7:	83 c4 10             	add    $0x10,%esp
80105cca:	85 c0                	test   %eax,%eax
80105ccc:	79 92                	jns    80105c60 <create+0xf0>
      panic("create dots");
80105cce:	83 ec 0c             	sub    $0xc,%esp
80105cd1:	68 5d 8f 10 80       	push   $0x80108f5d
80105cd6:	e8 b5 a6 ff ff       	call   80100390 <panic>
80105cdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105cdf:	90                   	nop
}
80105ce0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105ce3:	31 ff                	xor    %edi,%edi
}
80105ce5:	5b                   	pop    %ebx
80105ce6:	89 f8                	mov    %edi,%eax
80105ce8:	5e                   	pop    %esi
80105ce9:	5f                   	pop    %edi
80105cea:	5d                   	pop    %ebp
80105ceb:	c3                   	ret    
    panic("create: dirlink");
80105cec:	83 ec 0c             	sub    $0xc,%esp
80105cef:	68 69 8f 10 80       	push   $0x80108f69
80105cf4:	e8 97 a6 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105cf9:	83 ec 0c             	sub    $0xc,%esp
80105cfc:	68 4e 8f 10 80       	push   $0x80108f4e
80105d01:	e8 8a a6 ff ff       	call   80100390 <panic>
80105d06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d0d:	8d 76 00             	lea    0x0(%esi),%esi

80105d10 <sys_open>:

int
sys_open(void)
{
80105d10:	f3 0f 1e fb          	endbr32 
80105d14:	55                   	push   %ebp
80105d15:	89 e5                	mov    %esp,%ebp
80105d17:	57                   	push   %edi
80105d18:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105d19:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105d1c:	53                   	push   %ebx
80105d1d:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105d20:	50                   	push   %eax
80105d21:	6a 00                	push   $0x0
80105d23:	e8 e8 f7 ff ff       	call   80105510 <argstr>
80105d28:	83 c4 10             	add    $0x10,%esp
80105d2b:	85 c0                	test   %eax,%eax
80105d2d:	0f 88 8a 00 00 00    	js     80105dbd <sys_open+0xad>
80105d33:	83 ec 08             	sub    $0x8,%esp
80105d36:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105d39:	50                   	push   %eax
80105d3a:	6a 01                	push   $0x1
80105d3c:	e8 1f f7 ff ff       	call   80105460 <argint>
80105d41:	83 c4 10             	add    $0x10,%esp
80105d44:	85 c0                	test   %eax,%eax
80105d46:	78 75                	js     80105dbd <sys_open+0xad>
    return -1;

  begin_op();
80105d48:	e8 b3 d7 ff ff       	call   80103500 <begin_op>

  if(omode & O_CREATE){
80105d4d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105d51:	75 75                	jne    80105dc8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105d53:	83 ec 0c             	sub    $0xc,%esp
80105d56:	ff 75 e0             	pushl  -0x20(%ebp)
80105d59:	e8 92 c6 ff ff       	call   801023f0 <namei>
80105d5e:	83 c4 10             	add    $0x10,%esp
80105d61:	89 c6                	mov    %eax,%esi
80105d63:	85 c0                	test   %eax,%eax
80105d65:	74 78                	je     80105ddf <sys_open+0xcf>
      end_op();
      return -1;
    }
    ilock(ip);
80105d67:	83 ec 0c             	sub    $0xc,%esp
80105d6a:	50                   	push   %eax
80105d6b:	e8 b0 bd ff ff       	call   80101b20 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105d70:	83 c4 10             	add    $0x10,%esp
80105d73:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105d78:	0f 84 ba 00 00 00    	je     80105e38 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105d7e:	e8 3d b4 ff ff       	call   801011c0 <filealloc>
80105d83:	89 c7                	mov    %eax,%edi
80105d85:	85 c0                	test   %eax,%eax
80105d87:	74 23                	je     80105dac <sys_open+0x9c>
  struct proc *curproc = myproc();
80105d89:	e8 32 e4 ff ff       	call   801041c0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105d8e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105d90:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105d94:	85 d2                	test   %edx,%edx
80105d96:	74 58                	je     80105df0 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
80105d98:	83 c3 01             	add    $0x1,%ebx
80105d9b:	83 fb 10             	cmp    $0x10,%ebx
80105d9e:	75 f0                	jne    80105d90 <sys_open+0x80>
    if(f)
      fileclose(f);
80105da0:	83 ec 0c             	sub    $0xc,%esp
80105da3:	57                   	push   %edi
80105da4:	e8 d7 b4 ff ff       	call   80101280 <fileclose>
80105da9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105dac:	83 ec 0c             	sub    $0xc,%esp
80105daf:	56                   	push   %esi
80105db0:	e8 0b c0 ff ff       	call   80101dc0 <iunlockput>
    end_op();
80105db5:	e8 b6 d7 ff ff       	call   80103570 <end_op>
    return -1;
80105dba:	83 c4 10             	add    $0x10,%esp
80105dbd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105dc2:	eb 65                	jmp    80105e29 <sys_open+0x119>
80105dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105dc8:	6a 00                	push   $0x0
80105dca:	6a 00                	push   $0x0
80105dcc:	6a 02                	push   $0x2
80105dce:	ff 75 e0             	pushl  -0x20(%ebp)
80105dd1:	e8 9a fd ff ff       	call   80105b70 <create>
    if(ip == 0){
80105dd6:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105dd9:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105ddb:	85 c0                	test   %eax,%eax
80105ddd:	75 9f                	jne    80105d7e <sys_open+0x6e>
      end_op();
80105ddf:	e8 8c d7 ff ff       	call   80103570 <end_op>
      return -1;
80105de4:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105de9:	eb 3e                	jmp    80105e29 <sys_open+0x119>
80105deb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105def:	90                   	nop
  }
  iunlock(ip);
80105df0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105df3:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105df7:	56                   	push   %esi
80105df8:	e8 03 be ff ff       	call   80101c00 <iunlock>
  end_op();
80105dfd:	e8 6e d7 ff ff       	call   80103570 <end_op>

  f->type = FD_INODE;
80105e02:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105e08:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105e0b:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105e0e:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105e11:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105e13:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105e1a:	f7 d0                	not    %eax
80105e1c:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105e1f:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105e22:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105e25:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105e29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e2c:	89 d8                	mov    %ebx,%eax
80105e2e:	5b                   	pop    %ebx
80105e2f:	5e                   	pop    %esi
80105e30:	5f                   	pop    %edi
80105e31:	5d                   	pop    %ebp
80105e32:	c3                   	ret    
80105e33:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e37:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105e38:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105e3b:	85 c9                	test   %ecx,%ecx
80105e3d:	0f 84 3b ff ff ff    	je     80105d7e <sys_open+0x6e>
80105e43:	e9 64 ff ff ff       	jmp    80105dac <sys_open+0x9c>
80105e48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e4f:	90                   	nop

80105e50 <sys_mkdir>:

int
sys_mkdir(void)
{
80105e50:	f3 0f 1e fb          	endbr32 
80105e54:	55                   	push   %ebp
80105e55:	89 e5                	mov    %esp,%ebp
80105e57:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105e5a:	e8 a1 d6 ff ff       	call   80103500 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105e5f:	83 ec 08             	sub    $0x8,%esp
80105e62:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e65:	50                   	push   %eax
80105e66:	6a 00                	push   $0x0
80105e68:	e8 a3 f6 ff ff       	call   80105510 <argstr>
80105e6d:	83 c4 10             	add    $0x10,%esp
80105e70:	85 c0                	test   %eax,%eax
80105e72:	78 2c                	js     80105ea0 <sys_mkdir+0x50>
80105e74:	6a 00                	push   $0x0
80105e76:	6a 00                	push   $0x0
80105e78:	6a 01                	push   $0x1
80105e7a:	ff 75 f4             	pushl  -0xc(%ebp)
80105e7d:	e8 ee fc ff ff       	call   80105b70 <create>
80105e82:	83 c4 10             	add    $0x10,%esp
80105e85:	85 c0                	test   %eax,%eax
80105e87:	74 17                	je     80105ea0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105e89:	83 ec 0c             	sub    $0xc,%esp
80105e8c:	50                   	push   %eax
80105e8d:	e8 2e bf ff ff       	call   80101dc0 <iunlockput>
  end_op();
80105e92:	e8 d9 d6 ff ff       	call   80103570 <end_op>
  return 0;
80105e97:	83 c4 10             	add    $0x10,%esp
80105e9a:	31 c0                	xor    %eax,%eax
}
80105e9c:	c9                   	leave  
80105e9d:	c3                   	ret    
80105e9e:	66 90                	xchg   %ax,%ax
    end_op();
80105ea0:	e8 cb d6 ff ff       	call   80103570 <end_op>
    return -1;
80105ea5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105eaa:	c9                   	leave  
80105eab:	c3                   	ret    
80105eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105eb0 <sys_mknod>:

int
sys_mknod(void)
{
80105eb0:	f3 0f 1e fb          	endbr32 
80105eb4:	55                   	push   %ebp
80105eb5:	89 e5                	mov    %esp,%ebp
80105eb7:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105eba:	e8 41 d6 ff ff       	call   80103500 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105ebf:	83 ec 08             	sub    $0x8,%esp
80105ec2:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105ec5:	50                   	push   %eax
80105ec6:	6a 00                	push   $0x0
80105ec8:	e8 43 f6 ff ff       	call   80105510 <argstr>
80105ecd:	83 c4 10             	add    $0x10,%esp
80105ed0:	85 c0                	test   %eax,%eax
80105ed2:	78 5c                	js     80105f30 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105ed4:	83 ec 08             	sub    $0x8,%esp
80105ed7:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105eda:	50                   	push   %eax
80105edb:	6a 01                	push   $0x1
80105edd:	e8 7e f5 ff ff       	call   80105460 <argint>
  if((argstr(0, &path)) < 0 ||
80105ee2:	83 c4 10             	add    $0x10,%esp
80105ee5:	85 c0                	test   %eax,%eax
80105ee7:	78 47                	js     80105f30 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105ee9:	83 ec 08             	sub    $0x8,%esp
80105eec:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105eef:	50                   	push   %eax
80105ef0:	6a 02                	push   $0x2
80105ef2:	e8 69 f5 ff ff       	call   80105460 <argint>
     argint(1, &major) < 0 ||
80105ef7:	83 c4 10             	add    $0x10,%esp
80105efa:	85 c0                	test   %eax,%eax
80105efc:	78 32                	js     80105f30 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105efe:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105f02:	50                   	push   %eax
80105f03:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
80105f07:	50                   	push   %eax
80105f08:	6a 03                	push   $0x3
80105f0a:	ff 75 ec             	pushl  -0x14(%ebp)
80105f0d:	e8 5e fc ff ff       	call   80105b70 <create>
     argint(2, &minor) < 0 ||
80105f12:	83 c4 10             	add    $0x10,%esp
80105f15:	85 c0                	test   %eax,%eax
80105f17:	74 17                	je     80105f30 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105f19:	83 ec 0c             	sub    $0xc,%esp
80105f1c:	50                   	push   %eax
80105f1d:	e8 9e be ff ff       	call   80101dc0 <iunlockput>
  end_op();
80105f22:	e8 49 d6 ff ff       	call   80103570 <end_op>
  return 0;
80105f27:	83 c4 10             	add    $0x10,%esp
80105f2a:	31 c0                	xor    %eax,%eax
}
80105f2c:	c9                   	leave  
80105f2d:	c3                   	ret    
80105f2e:	66 90                	xchg   %ax,%ax
    end_op();
80105f30:	e8 3b d6 ff ff       	call   80103570 <end_op>
    return -1;
80105f35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f3a:	c9                   	leave  
80105f3b:	c3                   	ret    
80105f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105f40 <sys_chdir>:

int
sys_chdir(void)
{
80105f40:	f3 0f 1e fb          	endbr32 
80105f44:	55                   	push   %ebp
80105f45:	89 e5                	mov    %esp,%ebp
80105f47:	56                   	push   %esi
80105f48:	53                   	push   %ebx
80105f49:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105f4c:	e8 6f e2 ff ff       	call   801041c0 <myproc>
80105f51:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105f53:	e8 a8 d5 ff ff       	call   80103500 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105f58:	83 ec 08             	sub    $0x8,%esp
80105f5b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f5e:	50                   	push   %eax
80105f5f:	6a 00                	push   $0x0
80105f61:	e8 aa f5 ff ff       	call   80105510 <argstr>
80105f66:	83 c4 10             	add    $0x10,%esp
80105f69:	85 c0                	test   %eax,%eax
80105f6b:	78 73                	js     80105fe0 <sys_chdir+0xa0>
80105f6d:	83 ec 0c             	sub    $0xc,%esp
80105f70:	ff 75 f4             	pushl  -0xc(%ebp)
80105f73:	e8 78 c4 ff ff       	call   801023f0 <namei>
80105f78:	83 c4 10             	add    $0x10,%esp
80105f7b:	89 c3                	mov    %eax,%ebx
80105f7d:	85 c0                	test   %eax,%eax
80105f7f:	74 5f                	je     80105fe0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105f81:	83 ec 0c             	sub    $0xc,%esp
80105f84:	50                   	push   %eax
80105f85:	e8 96 bb ff ff       	call   80101b20 <ilock>
  if(ip->type != T_DIR){
80105f8a:	83 c4 10             	add    $0x10,%esp
80105f8d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105f92:	75 2c                	jne    80105fc0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105f94:	83 ec 0c             	sub    $0xc,%esp
80105f97:	53                   	push   %ebx
80105f98:	e8 63 bc ff ff       	call   80101c00 <iunlock>
  iput(curproc->cwd);
80105f9d:	58                   	pop    %eax
80105f9e:	ff 76 68             	pushl  0x68(%esi)
80105fa1:	e8 aa bc ff ff       	call   80101c50 <iput>
  end_op();
80105fa6:	e8 c5 d5 ff ff       	call   80103570 <end_op>
  curproc->cwd = ip;
80105fab:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105fae:	83 c4 10             	add    $0x10,%esp
80105fb1:	31 c0                	xor    %eax,%eax
}
80105fb3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105fb6:	5b                   	pop    %ebx
80105fb7:	5e                   	pop    %esi
80105fb8:	5d                   	pop    %ebp
80105fb9:	c3                   	ret    
80105fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105fc0:	83 ec 0c             	sub    $0xc,%esp
80105fc3:	53                   	push   %ebx
80105fc4:	e8 f7 bd ff ff       	call   80101dc0 <iunlockput>
    end_op();
80105fc9:	e8 a2 d5 ff ff       	call   80103570 <end_op>
    return -1;
80105fce:	83 c4 10             	add    $0x10,%esp
80105fd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fd6:	eb db                	jmp    80105fb3 <sys_chdir+0x73>
80105fd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fdf:	90                   	nop
    end_op();
80105fe0:	e8 8b d5 ff ff       	call   80103570 <end_op>
    return -1;
80105fe5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fea:	eb c7                	jmp    80105fb3 <sys_chdir+0x73>
80105fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ff0 <sys_exec>:

int
sys_exec(void)
{
80105ff0:	f3 0f 1e fb          	endbr32 
80105ff4:	55                   	push   %ebp
80105ff5:	89 e5                	mov    %esp,%ebp
80105ff7:	57                   	push   %edi
80105ff8:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105ff9:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105fff:	53                   	push   %ebx
80106000:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106006:	50                   	push   %eax
80106007:	6a 00                	push   $0x0
80106009:	e8 02 f5 ff ff       	call   80105510 <argstr>
8010600e:	83 c4 10             	add    $0x10,%esp
80106011:	85 c0                	test   %eax,%eax
80106013:	0f 88 8b 00 00 00    	js     801060a4 <sys_exec+0xb4>
80106019:	83 ec 08             	sub    $0x8,%esp
8010601c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80106022:	50                   	push   %eax
80106023:	6a 01                	push   $0x1
80106025:	e8 36 f4 ff ff       	call   80105460 <argint>
8010602a:	83 c4 10             	add    $0x10,%esp
8010602d:	85 c0                	test   %eax,%eax
8010602f:	78 73                	js     801060a4 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80106031:	83 ec 04             	sub    $0x4,%esp
80106034:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
8010603a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
8010603c:	68 80 00 00 00       	push   $0x80
80106041:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80106047:	6a 00                	push   $0x0
80106049:	50                   	push   %eax
8010604a:	e8 31 f1 ff ff       	call   80105180 <memset>
8010604f:	83 c4 10             	add    $0x10,%esp
80106052:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106058:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
8010605e:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80106065:	83 ec 08             	sub    $0x8,%esp
80106068:	57                   	push   %edi
80106069:	01 f0                	add    %esi,%eax
8010606b:	50                   	push   %eax
8010606c:	e8 4f f3 ff ff       	call   801053c0 <fetchint>
80106071:	83 c4 10             	add    $0x10,%esp
80106074:	85 c0                	test   %eax,%eax
80106076:	78 2c                	js     801060a4 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80106078:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010607e:	85 c0                	test   %eax,%eax
80106080:	74 36                	je     801060b8 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80106082:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80106088:	83 ec 08             	sub    $0x8,%esp
8010608b:	8d 14 31             	lea    (%ecx,%esi,1),%edx
8010608e:	52                   	push   %edx
8010608f:	50                   	push   %eax
80106090:	e8 6b f3 ff ff       	call   80105400 <fetchstr>
80106095:	83 c4 10             	add    $0x10,%esp
80106098:	85 c0                	test   %eax,%eax
8010609a:	78 08                	js     801060a4 <sys_exec+0xb4>
  for(i=0;; i++){
8010609c:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
8010609f:	83 fb 20             	cmp    $0x20,%ebx
801060a2:	75 b4                	jne    80106058 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
801060a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801060a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801060ac:	5b                   	pop    %ebx
801060ad:	5e                   	pop    %esi
801060ae:	5f                   	pop    %edi
801060af:	5d                   	pop    %ebp
801060b0:	c3                   	ret    
801060b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
801060b8:	83 ec 08             	sub    $0x8,%esp
801060bb:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
801060c1:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801060c8:	00 00 00 00 
  return exec(path, argv);
801060cc:	50                   	push   %eax
801060cd:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801060d3:	e8 38 aa ff ff       	call   80100b10 <exec>
801060d8:	83 c4 10             	add    $0x10,%esp
}
801060db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060de:	5b                   	pop    %ebx
801060df:	5e                   	pop    %esi
801060e0:	5f                   	pop    %edi
801060e1:	5d                   	pop    %ebp
801060e2:	c3                   	ret    
801060e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801060f0 <sys_pipe>:

int
sys_pipe(void)
{
801060f0:	f3 0f 1e fb          	endbr32 
801060f4:	55                   	push   %ebp
801060f5:	89 e5                	mov    %esp,%ebp
801060f7:	57                   	push   %edi
801060f8:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801060f9:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801060fc:	53                   	push   %ebx
801060fd:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106100:	6a 08                	push   $0x8
80106102:	50                   	push   %eax
80106103:	6a 00                	push   $0x0
80106105:	e8 a6 f3 ff ff       	call   801054b0 <argptr>
8010610a:	83 c4 10             	add    $0x10,%esp
8010610d:	85 c0                	test   %eax,%eax
8010610f:	78 4e                	js     8010615f <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80106111:	83 ec 08             	sub    $0x8,%esp
80106114:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106117:	50                   	push   %eax
80106118:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010611b:	50                   	push   %eax
8010611c:	e8 af da ff ff       	call   80103bd0 <pipealloc>
80106121:	83 c4 10             	add    $0x10,%esp
80106124:	85 c0                	test   %eax,%eax
80106126:	78 37                	js     8010615f <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106128:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010612b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010612d:	e8 8e e0 ff ff       	call   801041c0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80106132:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80106138:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010613c:	85 f6                	test   %esi,%esi
8010613e:	74 30                	je     80106170 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80106140:	83 c3 01             	add    $0x1,%ebx
80106143:	83 fb 10             	cmp    $0x10,%ebx
80106146:	75 f0                	jne    80106138 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80106148:	83 ec 0c             	sub    $0xc,%esp
8010614b:	ff 75 e0             	pushl  -0x20(%ebp)
8010614e:	e8 2d b1 ff ff       	call   80101280 <fileclose>
    fileclose(wf);
80106153:	58                   	pop    %eax
80106154:	ff 75 e4             	pushl  -0x1c(%ebp)
80106157:	e8 24 b1 ff ff       	call   80101280 <fileclose>
    return -1;
8010615c:	83 c4 10             	add    $0x10,%esp
8010615f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106164:	eb 5b                	jmp    801061c1 <sys_pipe+0xd1>
80106166:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010616d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80106170:	8d 73 08             	lea    0x8(%ebx),%esi
80106173:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106177:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010617a:	e8 41 e0 ff ff       	call   801041c0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010617f:	31 d2                	xor    %edx,%edx
80106181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80106188:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010618c:	85 c9                	test   %ecx,%ecx
8010618e:	74 20                	je     801061b0 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80106190:	83 c2 01             	add    $0x1,%edx
80106193:	83 fa 10             	cmp    $0x10,%edx
80106196:	75 f0                	jne    80106188 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80106198:	e8 23 e0 ff ff       	call   801041c0 <myproc>
8010619d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801061a4:	00 
801061a5:	eb a1                	jmp    80106148 <sys_pipe+0x58>
801061a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061ae:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801061b0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
801061b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801061b7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801061b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801061bc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801061bf:	31 c0                	xor    %eax,%eax
}
801061c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061c4:	5b                   	pop    %ebx
801061c5:	5e                   	pop    %esi
801061c6:	5f                   	pop    %edi
801061c7:	5d                   	pop    %ebp
801061c8:	c3                   	ret    
801061c9:	66 90                	xchg   %ax,%ax
801061cb:	66 90                	xchg   %ax,%ax
801061cd:	66 90                	xchg   %ax,%ax
801061cf:	90                   	nop

801061d0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801061d0:	f3 0f 1e fb          	endbr32 
  return fork();
801061d4:	e9 c7 e1 ff ff       	jmp    801043a0 <fork>
801061d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801061e0 <sys_exit>:
}

int
sys_exit(void)
{
801061e0:	f3 0f 1e fb          	endbr32 
801061e4:	55                   	push   %ebp
801061e5:	89 e5                	mov    %esp,%ebp
801061e7:	83 ec 08             	sub    $0x8,%esp
  exit();
801061ea:	e8 e1 e5 ff ff       	call   801047d0 <exit>
  return 0;  // not reached
}
801061ef:	31 c0                	xor    %eax,%eax
801061f1:	c9                   	leave  
801061f2:	c3                   	ret    
801061f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106200 <sys_wait>:

int
sys_wait(void)
{
80106200:	f3 0f 1e fb          	endbr32 
  return wait();
80106204:	e9 17 e8 ff ff       	jmp    80104a20 <wait>
80106209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106210 <sys_kill>:
}

int
sys_kill(void)
{
80106210:	f3 0f 1e fb          	endbr32 
80106214:	55                   	push   %ebp
80106215:	89 e5                	mov    %esp,%ebp
80106217:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010621a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010621d:	50                   	push   %eax
8010621e:	6a 00                	push   $0x0
80106220:	e8 3b f2 ff ff       	call   80105460 <argint>
80106225:	83 c4 10             	add    $0x10,%esp
80106228:	85 c0                	test   %eax,%eax
8010622a:	78 14                	js     80106240 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010622c:	83 ec 0c             	sub    $0xc,%esp
8010622f:	ff 75 f4             	pushl  -0xc(%ebp)
80106232:	e8 f9 e9 ff ff       	call   80104c30 <kill>
80106237:	83 c4 10             	add    $0x10,%esp
}
8010623a:	c9                   	leave  
8010623b:	c3                   	ret    
8010623c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106240:	c9                   	leave  
    return -1;
80106241:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106246:	c3                   	ret    
80106247:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010624e:	66 90                	xchg   %ax,%ax

80106250 <sys_getpid>:

int
sys_getpid(void)
{
80106250:	f3 0f 1e fb          	endbr32 
80106254:	55                   	push   %ebp
80106255:	89 e5                	mov    %esp,%ebp
80106257:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
8010625a:	e8 61 df ff ff       	call   801041c0 <myproc>
8010625f:	8b 40 10             	mov    0x10(%eax),%eax
}
80106262:	c9                   	leave  
80106263:	c3                   	ret    
80106264:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010626b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010626f:	90                   	nop

80106270 <sys_sbrk>:

int
sys_sbrk(void)
{
80106270:	f3 0f 1e fb          	endbr32 
80106274:	55                   	push   %ebp
80106275:	89 e5                	mov    %esp,%ebp
80106277:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106278:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010627b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010627e:	50                   	push   %eax
8010627f:	6a 00                	push   $0x0
80106281:	e8 da f1 ff ff       	call   80105460 <argint>
80106286:	83 c4 10             	add    $0x10,%esp
80106289:	85 c0                	test   %eax,%eax
8010628b:	78 23                	js     801062b0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
8010628d:	e8 2e df ff ff       	call   801041c0 <myproc>
  if(growproc(n) < 0)
80106292:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106295:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106297:	ff 75 f4             	pushl  -0xc(%ebp)
8010629a:	e8 51 e0 ff ff       	call   801042f0 <growproc>
8010629f:	83 c4 10             	add    $0x10,%esp
801062a2:	85 c0                	test   %eax,%eax
801062a4:	78 0a                	js     801062b0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801062a6:	89 d8                	mov    %ebx,%eax
801062a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801062ab:	c9                   	leave  
801062ac:	c3                   	ret    
801062ad:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801062b0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801062b5:	eb ef                	jmp    801062a6 <sys_sbrk+0x36>
801062b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801062be:	66 90                	xchg   %ax,%ax

801062c0 <sys_sleep>:

int
sys_sleep(void)
{
801062c0:	f3 0f 1e fb          	endbr32 
801062c4:	55                   	push   %ebp
801062c5:	89 e5                	mov    %esp,%ebp
801062c7:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801062c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801062cb:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801062ce:	50                   	push   %eax
801062cf:	6a 00                	push   $0x0
801062d1:	e8 8a f1 ff ff       	call   80105460 <argint>
801062d6:	83 c4 10             	add    $0x10,%esp
801062d9:	85 c0                	test   %eax,%eax
801062db:	0f 88 86 00 00 00    	js     80106367 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801062e1:	83 ec 0c             	sub    $0xc,%esp
801062e4:	68 e0 11 13 80       	push   $0x801311e0
801062e9:	e8 82 ed ff ff       	call   80105070 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801062ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801062f1:	8b 1d 20 1a 13 80    	mov    0x80131a20,%ebx
  while(ticks - ticks0 < n){
801062f7:	83 c4 10             	add    $0x10,%esp
801062fa:	85 d2                	test   %edx,%edx
801062fc:	75 23                	jne    80106321 <sys_sleep+0x61>
801062fe:	eb 50                	jmp    80106350 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106300:	83 ec 08             	sub    $0x8,%esp
80106303:	68 e0 11 13 80       	push   $0x801311e0
80106308:	68 20 1a 13 80       	push   $0x80131a20
8010630d:	e8 4e e6 ff ff       	call   80104960 <sleep>
  while(ticks - ticks0 < n){
80106312:	a1 20 1a 13 80       	mov    0x80131a20,%eax
80106317:	83 c4 10             	add    $0x10,%esp
8010631a:	29 d8                	sub    %ebx,%eax
8010631c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010631f:	73 2f                	jae    80106350 <sys_sleep+0x90>
    if(myproc()->killed){
80106321:	e8 9a de ff ff       	call   801041c0 <myproc>
80106326:	8b 40 24             	mov    0x24(%eax),%eax
80106329:	85 c0                	test   %eax,%eax
8010632b:	74 d3                	je     80106300 <sys_sleep+0x40>
      release(&tickslock);
8010632d:	83 ec 0c             	sub    $0xc,%esp
80106330:	68 e0 11 13 80       	push   $0x801311e0
80106335:	e8 f6 ed ff ff       	call   80105130 <release>
  }
  release(&tickslock);
  return 0;
}
8010633a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010633d:	83 c4 10             	add    $0x10,%esp
80106340:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106345:	c9                   	leave  
80106346:	c3                   	ret    
80106347:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010634e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80106350:	83 ec 0c             	sub    $0xc,%esp
80106353:	68 e0 11 13 80       	push   $0x801311e0
80106358:	e8 d3 ed ff ff       	call   80105130 <release>
  return 0;
8010635d:	83 c4 10             	add    $0x10,%esp
80106360:	31 c0                	xor    %eax,%eax
}
80106362:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106365:	c9                   	leave  
80106366:	c3                   	ret    
    return -1;
80106367:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010636c:	eb f4                	jmp    80106362 <sys_sleep+0xa2>
8010636e:	66 90                	xchg   %ax,%ax

80106370 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106370:	f3 0f 1e fb          	endbr32 
80106374:	55                   	push   %ebp
80106375:	89 e5                	mov    %esp,%ebp
80106377:	53                   	push   %ebx
80106378:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
8010637b:	68 e0 11 13 80       	push   $0x801311e0
80106380:	e8 eb ec ff ff       	call   80105070 <acquire>
  xticks = ticks;
80106385:	8b 1d 20 1a 13 80    	mov    0x80131a20,%ebx
  release(&tickslock);
8010638b:	c7 04 24 e0 11 13 80 	movl   $0x801311e0,(%esp)
80106392:	e8 99 ed ff ff       	call   80105130 <release>
  return xticks;
}
80106397:	89 d8                	mov    %ebx,%eax
80106399:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010639c:	c9                   	leave  
8010639d:	c3                   	ret    
8010639e:	66 90                	xchg   %ax,%ax

801063a0 <sys_get_number_of_free_pages>:

int sys_get_number_of_free_pages(void){
801063a0:	f3 0f 1e fb          	endbr32 
  return sys_get_number_of_free_pages_impl();
801063a4:	e9 c7 df ff ff       	jmp    80104370 <sys_get_number_of_free_pages_impl>

801063a9 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801063a9:	1e                   	push   %ds
  pushl %es
801063aa:	06                   	push   %es
  pushl %fs
801063ab:	0f a0                	push   %fs
  pushl %gs
801063ad:	0f a8                	push   %gs
  pushal
801063af:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801063b0:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801063b4:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801063b6:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801063b8:	54                   	push   %esp
  call trap
801063b9:	e8 c2 00 00 00       	call   80106480 <trap>
  addl $4, %esp
801063be:	83 c4 04             	add    $0x4,%esp

801063c1 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801063c1:	61                   	popa   
  popl %gs
801063c2:	0f a9                	pop    %gs
  popl %fs
801063c4:	0f a1                	pop    %fs
  popl %es
801063c6:	07                   	pop    %es
  popl %ds
801063c7:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801063c8:	83 c4 08             	add    $0x8,%esp
  iret
801063cb:	cf                   	iret   
801063cc:	66 90                	xchg   %ax,%ax
801063ce:	66 90                	xchg   %ax,%ax

801063d0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801063d0:	f3 0f 1e fb          	endbr32 
801063d4:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801063d5:	31 c0                	xor    %eax,%eax
{
801063d7:	89 e5                	mov    %esp,%ebp
801063d9:	83 ec 08             	sub    $0x8,%esp
801063dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801063e0:	8b 14 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%edx
801063e7:	c7 04 c5 22 12 13 80 	movl   $0x8e000008,-0x7fecedde(,%eax,8)
801063ee:	08 00 00 8e 
801063f2:	66 89 14 c5 20 12 13 	mov    %dx,-0x7fecede0(,%eax,8)
801063f9:	80 
801063fa:	c1 ea 10             	shr    $0x10,%edx
801063fd:	66 89 14 c5 26 12 13 	mov    %dx,-0x7fecedda(,%eax,8)
80106404:	80 
  for(i = 0; i < 256; i++)
80106405:	83 c0 01             	add    $0x1,%eax
80106408:	3d 00 01 00 00       	cmp    $0x100,%eax
8010640d:	75 d1                	jne    801063e0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010640f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106412:	a1 08 c1 10 80       	mov    0x8010c108,%eax
80106417:	c7 05 22 14 13 80 08 	movl   $0xef000008,0x80131422
8010641e:	00 00 ef 
  initlock(&tickslock, "time");
80106421:	68 79 8f 10 80       	push   $0x80108f79
80106426:	68 e0 11 13 80       	push   $0x801311e0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010642b:	66 a3 20 14 13 80    	mov    %ax,0x80131420
80106431:	c1 e8 10             	shr    $0x10,%eax
80106434:	66 a3 26 14 13 80    	mov    %ax,0x80131426
  initlock(&tickslock, "time");
8010643a:	e8 b1 ea ff ff       	call   80104ef0 <initlock>
}
8010643f:	83 c4 10             	add    $0x10,%esp
80106442:	c9                   	leave  
80106443:	c3                   	ret    
80106444:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010644b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010644f:	90                   	nop

80106450 <idtinit>:

void
idtinit(void)
{
80106450:	f3 0f 1e fb          	endbr32 
80106454:	55                   	push   %ebp
  pd[0] = size-1;
80106455:	b8 ff 07 00 00       	mov    $0x7ff,%eax
8010645a:	89 e5                	mov    %esp,%ebp
8010645c:	83 ec 10             	sub    $0x10,%esp
8010645f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106463:	b8 20 12 13 80       	mov    $0x80131220,%eax
80106468:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010646c:	c1 e8 10             	shr    $0x10,%eax
8010646f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106473:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106476:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106479:	c9                   	leave  
8010647a:	c3                   	ret    
8010647b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010647f:	90                   	nop

80106480 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106480:	f3 0f 1e fb          	endbr32 
80106484:	55                   	push   %ebp
80106485:	89 e5                	mov    %esp,%ebp
80106487:	57                   	push   %edi
80106488:	56                   	push   %esi
80106489:	53                   	push   %ebx
8010648a:	83 ec 1c             	sub    $0x1c,%esp
8010648d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80106490:	8b 43 30             	mov    0x30(%ebx),%eax
80106493:	83 f8 40             	cmp    $0x40,%eax
80106496:	0f 84 6c 02 00 00    	je     80106708 <trap+0x288>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
8010649c:	83 e8 0e             	sub    $0xe,%eax
8010649f:	83 f8 31             	cmp    $0x31,%eax
801064a2:	0f 87 2b 01 00 00    	ja     801065d3 <trap+0x153>
801064a8:	3e ff 24 85 68 90 10 	notrack jmp *-0x7fef6f98(,%eax,4)
801064af:	80 

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801064b0:	0f 20 d7             	mov    %cr2,%edi
    break;

  case T_PGFLT:
  ;
    uint faulting_addr = rcr2();
    struct proc* p = myproc();
801064b3:	e8 08 dd ff ff       	call   801041c0 <myproc>
    pte_t* pte_ptr = public_walkpgdir(p->pgdir, (void *)faulting_addr, 0);
801064b8:	83 ec 04             	sub    $0x4,%esp
801064bb:	6a 00                	push   $0x0
801064bd:	57                   	push   %edi
801064be:	ff 70 04             	pushl  0x4(%eax)
    struct proc* p = myproc();
801064c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pte_t* pte_ptr = public_walkpgdir(p->pgdir, (void *)faulting_addr, 0);
801064c4:	e8 b7 13 00 00       	call   80107880 <public_walkpgdir>
    if (!(pte_ptr == 0) && (*pte_ptr & PTE_U) && (*pte_ptr & PTE_PG)){
801064c9:	83 c4 10             	add    $0x10,%esp
    pte_t* pte_ptr = public_walkpgdir(p->pgdir, (void *)faulting_addr, 0);
801064cc:	89 c6                	mov    %eax,%esi
    if (!(pte_ptr == 0) && (*pte_ptr & PTE_U) && (*pte_ptr & PTE_PG)){
801064ce:	85 c0                	test   %eax,%eax
801064d0:	0f 84 fd 00 00 00    	je     801065d3 <trap+0x153>
801064d6:	8b 00                	mov    (%eax),%eax
801064d8:	89 c1                	mov    %eax,%ecx
801064da:	81 e1 04 02 00 00    	and    $0x204,%ecx
801064e0:	81 f9 04 02 00 00    	cmp    $0x204,%ecx
801064e6:	0f 84 ac 02 00 00    	je     80106798 <trap+0x318>
        }
      }
      p->num_of_pagefaults_occurs++;
      break;
    }
    if (!(pte_ptr == 0) && *pte_ptr & PTE_COW){
801064ec:	f6 c4 08             	test   $0x8,%ah
801064ef:	0f 84 de 00 00 00    	je     801065d3 <trap+0x153>
      // cprintf("trap %d\n", p->pid);
      acquire(cow_lock);
801064f5:	83 ec 0c             	sub    $0xc,%esp
801064f8:	ff 35 40 ff 11 80    	pushl  0x8011ff40
801064fe:	e8 6d eb ff ff       	call   80105070 <acquire>
      char* ref_count = &(pg_ref_counts[PGROUNDDOWN(PTE_ADDR(*pte_ptr)) / PGSIZE]);
80106503:	8b 0e                	mov    (%esi),%ecx
      if (*ref_count == 1){
80106505:	83 c4 10             	add    $0x10,%esp
      char* ref_count = &(pg_ref_counts[PGROUNDDOWN(PTE_ADDR(*pte_ptr)) / PGSIZE]);
80106508:	89 ca                	mov    %ecx,%edx
8010650a:	c1 ea 0c             	shr    $0xc,%edx
      if (*ref_count == 1){
8010650d:	0f b6 82 40 1f 11 80 	movzbl -0x7feee0c0(%edx),%eax
80106514:	3c 01                	cmp    $0x1,%al
80106516:	0f 84 dd 02 00 00    	je     801067f9 <trap+0x379>
        *pte_ptr &= (~PTE_COW);
        // cprintf("rel trap %d\n", p->pid);
        release(cow_lock);
        break;
      }
      else if (*ref_count > 1){
8010651c:	0f 8e 1d 03 00 00    	jle    8010683f <trap+0x3bf>
        (*ref_count)--;
        // cprintf("rel trap %d\n", p->pid);
        release(cow_lock);
80106522:	83 ec 0c             	sub    $0xc,%esp
80106525:	ff 35 40 ff 11 80    	pushl  0x8011ff40
        (*ref_count)--;
8010652b:	83 e8 01             	sub    $0x1,%eax
8010652e:	88 82 40 1f 11 80    	mov    %al,-0x7feee0c0(%edx)
        release(cow_lock);
80106534:	e8 f7 eb ff ff       	call   80105130 <release>
        int result = copy_page(p->pgdir, pte_ptr);
80106539:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010653c:	59                   	pop    %ecx
8010653d:	5f                   	pop    %edi
8010653e:	56                   	push   %esi
8010653f:	ff 70 04             	pushl  0x4(%eax)
80106542:	e8 b9 21 00 00       	call   80108700 <copy_page>
        if (result < 0){
80106547:	83 c4 10             	add    $0x10,%esp
8010654a:	85 c0                	test   %eax,%eax
8010654c:	79 0f                	jns    8010655d <trap+0xdd>
          p->killed = 1;
8010654e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106551:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
          exit();
80106558:	e8 73 e2 ff ff       	call   801047d0 <exit>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010655d:	e8 5e dc ff ff       	call   801041c0 <myproc>
80106562:	85 c0                	test   %eax,%eax
80106564:	74 27                	je     8010658d <trap+0x10d>
80106566:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010656d:	8d 76 00             	lea    0x0(%esi),%esi
80106570:	e8 4b dc ff ff       	call   801041c0 <myproc>
80106575:	8b 50 24             	mov    0x24(%eax),%edx
80106578:	85 d2                	test   %edx,%edx
8010657a:	74 11                	je     8010658d <trap+0x10d>
8010657c:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106580:	83 e0 03             	and    $0x3,%eax
80106583:	66 83 f8 03          	cmp    $0x3,%ax
80106587:	0f 84 b3 01 00 00    	je     80106740 <trap+0x2c0>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
8010658d:	e8 2e dc ff ff       	call   801041c0 <myproc>
80106592:	85 c0                	test   %eax,%eax
80106594:	74 0f                	je     801065a5 <trap+0x125>
80106596:	e8 25 dc ff ff       	call   801041c0 <myproc>
8010659b:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
8010659f:	0f 84 4b 01 00 00    	je     801066f0 <trap+0x270>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801065a5:	e8 16 dc ff ff       	call   801041c0 <myproc>
801065aa:	85 c0                	test   %eax,%eax
801065ac:	74 1d                	je     801065cb <trap+0x14b>
801065ae:	e8 0d dc ff ff       	call   801041c0 <myproc>
801065b3:	8b 40 24             	mov    0x24(%eax),%eax
801065b6:	85 c0                	test   %eax,%eax
801065b8:	74 11                	je     801065cb <trap+0x14b>
801065ba:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801065be:	83 e0 03             	and    $0x3,%eax
801065c1:	66 83 f8 03          	cmp    $0x3,%ax
801065c5:	0f 84 66 01 00 00    	je     80106731 <trap+0x2b1>
    exit();
}
801065cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801065ce:	5b                   	pop    %ebx
801065cf:	5e                   	pop    %esi
801065d0:	5f                   	pop    %edi
801065d1:	5d                   	pop    %ebp
801065d2:	c3                   	ret    
    if(myproc() == 0 || (tf->cs&3) == 0){
801065d3:	e8 e8 db ff ff       	call   801041c0 <myproc>
801065d8:	8b 7b 38             	mov    0x38(%ebx),%edi
801065db:	85 c0                	test   %eax,%eax
801065dd:	0f 84 34 02 00 00    	je     80106817 <trap+0x397>
801065e3:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801065e7:	0f 84 2a 02 00 00    	je     80106817 <trap+0x397>
801065ed:	0f 20 d1             	mov    %cr2,%ecx
801065f0:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801065f3:	e8 a8 db ff ff       	call   801041a0 <cpuid>
801065f8:	8b 73 30             	mov    0x30(%ebx),%esi
801065fb:	89 45 dc             	mov    %eax,-0x24(%ebp)
801065fe:	8b 43 34             	mov    0x34(%ebx),%eax
80106601:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80106604:	e8 b7 db ff ff       	call   801041c0 <myproc>
80106609:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010660c:	e8 af db ff ff       	call   801041c0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106611:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106614:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106617:	51                   	push   %ecx
80106618:	57                   	push   %edi
80106619:	52                   	push   %edx
8010661a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010661d:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
8010661e:	8b 75 e0             	mov    -0x20(%ebp),%esi
80106621:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106624:	56                   	push   %esi
80106625:	ff 70 10             	pushl  0x10(%eax)
80106628:	68 24 90 10 80       	push   $0x80109024
8010662d:	e8 7e a0 ff ff       	call   801006b0 <cprintf>
    myproc()->killed = 1;
80106632:	83 c4 20             	add    $0x20,%esp
80106635:	e8 86 db ff ff       	call   801041c0 <myproc>
8010663a:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106641:	e8 7a db ff ff       	call   801041c0 <myproc>
80106646:	85 c0                	test   %eax,%eax
80106648:	0f 85 22 ff ff ff    	jne    80106570 <trap+0xf0>
8010664e:	e9 3a ff ff ff       	jmp    8010658d <trap+0x10d>
    if(cpuid() == 0){
80106653:	e8 48 db ff ff       	call   801041a0 <cpuid>
80106658:	85 c0                	test   %eax,%eax
8010665a:	0f 84 00 01 00 00    	je     80106760 <trap+0x2e0>
    lapiceoi();
80106660:	e8 2b ca ff ff       	call   80103090 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106665:	e8 56 db ff ff       	call   801041c0 <myproc>
8010666a:	85 c0                	test   %eax,%eax
8010666c:	0f 85 fe fe ff ff    	jne    80106570 <trap+0xf0>
80106672:	e9 16 ff ff ff       	jmp    8010658d <trap+0x10d>
    kbdintr();
80106677:	e8 d4 c8 ff ff       	call   80102f50 <kbdintr>
    lapiceoi();
8010667c:	e8 0f ca ff ff       	call   80103090 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106681:	e8 3a db ff ff       	call   801041c0 <myproc>
80106686:	85 c0                	test   %eax,%eax
80106688:	0f 85 e2 fe ff ff    	jne    80106570 <trap+0xf0>
8010668e:	e9 fa fe ff ff       	jmp    8010658d <trap+0x10d>
    uartintr();
80106693:	e8 28 03 00 00       	call   801069c0 <uartintr>
    lapiceoi();
80106698:	e8 f3 c9 ff ff       	call   80103090 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010669d:	e8 1e db ff ff       	call   801041c0 <myproc>
801066a2:	85 c0                	test   %eax,%eax
801066a4:	0f 85 c6 fe ff ff    	jne    80106570 <trap+0xf0>
801066aa:	e9 de fe ff ff       	jmp    8010658d <trap+0x10d>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801066af:	8b 7b 38             	mov    0x38(%ebx),%edi
801066b2:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801066b6:	e8 e5 da ff ff       	call   801041a0 <cpuid>
801066bb:	57                   	push   %edi
801066bc:	56                   	push   %esi
801066bd:	50                   	push   %eax
801066be:	68 a0 8f 10 80       	push   $0x80108fa0
801066c3:	e8 e8 9f ff ff       	call   801006b0 <cprintf>
    lapiceoi();
801066c8:	e8 c3 c9 ff ff       	call   80103090 <lapiceoi>
    break;
801066cd:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801066d0:	e8 eb da ff ff       	call   801041c0 <myproc>
801066d5:	85 c0                	test   %eax,%eax
801066d7:	0f 85 93 fe ff ff    	jne    80106570 <trap+0xf0>
801066dd:	e9 ab fe ff ff       	jmp    8010658d <trap+0x10d>
    ideintr();
801066e2:	e8 39 c2 ff ff       	call   80102920 <ideintr>
801066e7:	e9 74 ff ff ff       	jmp    80106660 <trap+0x1e0>
801066ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->state == RUNNING &&
801066f0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801066f4:	0f 85 ab fe ff ff    	jne    801065a5 <trap+0x125>
    yield();
801066fa:	e8 11 e2 ff ff       	call   80104910 <yield>
801066ff:	e9 a1 fe ff ff       	jmp    801065a5 <trap+0x125>
80106704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80106708:	e8 b3 da ff ff       	call   801041c0 <myproc>
8010670d:	8b 70 24             	mov    0x24(%eax),%esi
80106710:	85 f6                	test   %esi,%esi
80106712:	75 3c                	jne    80106750 <trap+0x2d0>
    myproc()->tf = tf;
80106714:	e8 a7 da ff ff       	call   801041c0 <myproc>
80106719:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
8010671c:	e8 2f ee ff ff       	call   80105550 <syscall>
    if(myproc()->killed)
80106721:	e8 9a da ff ff       	call   801041c0 <myproc>
80106726:	8b 48 24             	mov    0x24(%eax),%ecx
80106729:	85 c9                	test   %ecx,%ecx
8010672b:	0f 84 9a fe ff ff    	je     801065cb <trap+0x14b>
}
80106731:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106734:	5b                   	pop    %ebx
80106735:	5e                   	pop    %esi
80106736:	5f                   	pop    %edi
80106737:	5d                   	pop    %ebp
      exit();
80106738:	e9 93 e0 ff ff       	jmp    801047d0 <exit>
8010673d:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80106740:	e8 8b e0 ff ff       	call   801047d0 <exit>
80106745:	e9 43 fe ff ff       	jmp    8010658d <trap+0x10d>
8010674a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106750:	e8 7b e0 ff ff       	call   801047d0 <exit>
80106755:	eb bd                	jmp    80106714 <trap+0x294>
80106757:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010675e:	66 90                	xchg   %ax,%ax
      acquire(&tickslock);
80106760:	83 ec 0c             	sub    $0xc,%esp
80106763:	68 e0 11 13 80       	push   $0x801311e0
80106768:	e8 03 e9 ff ff       	call   80105070 <acquire>
      wakeup(&ticks);
8010676d:	c7 04 24 20 1a 13 80 	movl   $0x80131a20,(%esp)
      ticks++;
80106774:	83 05 20 1a 13 80 01 	addl   $0x1,0x80131a20
      wakeup(&ticks);
8010677b:	e8 40 e4 ff ff       	call   80104bc0 <wakeup>
      release(&tickslock);
80106780:	c7 04 24 e0 11 13 80 	movl   $0x801311e0,(%esp)
80106787:	e8 a4 e9 ff ff       	call   80105130 <release>
8010678c:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
8010678f:	e9 cc fe ff ff       	jmp    80106660 <trap+0x1e0>
80106794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106798:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      for (int i = 0; i < MAX_PYSC_PAGES; i++){
8010679b:	31 f6                	xor    %esi,%esi
8010679d:	05 90 00 00 00       	add    $0x90,%eax
801067a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (PGROUNDDOWN((uint)(p->swapped_out_pages[i].va)) == PGROUNDDOWN(faulting_addr)){
801067a8:	8b 10                	mov    (%eax),%edx
801067aa:	31 fa                	xor    %edi,%edx
801067ac:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801067b2:	74 1c                	je     801067d0 <trap+0x350>
      for (int i = 0; i < MAX_PYSC_PAGES; i++){
801067b4:	83 c6 01             	add    $0x1,%esi
801067b7:	83 c0 18             	add    $0x18,%eax
801067ba:	83 fe 10             	cmp    $0x10,%esi
801067bd:	75 e9                	jne    801067a8 <trap+0x328>
      p->num_of_pagefaults_occurs++;
801067bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801067c2:	83 80 88 03 00 00 01 	addl   $0x1,0x388(%eax)
      break;
801067c9:	e9 8f fd ff ff       	jmp    8010655d <trap+0xdd>
801067ce:	66 90                	xchg   %ax,%ax
          cprintf("\nPGFAULT flting_addr = %d\n", faulting_addr);
801067d0:	83 ec 08             	sub    $0x8,%esp
801067d3:	57                   	push   %edi
801067d4:	68 7e 8f 10 80       	push   $0x80108f7e
801067d9:	e8 d2 9e ff ff       	call   801006b0 <cprintf>
          swap_page_back(p, &(p->swapped_out_pages[i]));
801067de:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801067e1:	58                   	pop    %eax
801067e2:	8d 04 76             	lea    (%esi,%esi,2),%eax
801067e5:	5a                   	pop    %edx
801067e6:	8d 84 c7 80 00 00 00 	lea    0x80(%edi,%eax,8),%eax
801067ed:	50                   	push   %eax
801067ee:	57                   	push   %edi
801067ef:	e8 1c 1e 00 00       	call   80108610 <swap_page_back>
          break;
801067f4:	83 c4 10             	add    $0x10,%esp
801067f7:	eb c6                	jmp    801067bf <trap+0x33f>
        *pte_ptr &= (~PTE_COW);
801067f9:	80 e5 f7             	and    $0xf7,%ch
        release(cow_lock);
801067fc:	83 ec 0c             	sub    $0xc,%esp
        *pte_ptr &= (~PTE_COW);
801067ff:	83 c9 02             	or     $0x2,%ecx
80106802:	89 0e                	mov    %ecx,(%esi)
        release(cow_lock);
80106804:	ff 35 40 ff 11 80    	pushl  0x8011ff40
8010680a:	e8 21 e9 ff ff       	call   80105130 <release>
        break;
8010680f:	83 c4 10             	add    $0x10,%esp
80106812:	e9 46 fd ff ff       	jmp    8010655d <trap+0xdd>
80106817:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010681a:	e8 81 d9 ff ff       	call   801041a0 <cpuid>
8010681f:	83 ec 0c             	sub    $0xc,%esp
80106822:	56                   	push   %esi
80106823:	57                   	push   %edi
80106824:	50                   	push   %eax
80106825:	ff 73 30             	pushl  0x30(%ebx)
80106828:	68 f0 8f 10 80       	push   $0x80108ff0
8010682d:	e8 7e 9e ff ff       	call   801006b0 <cprintf>
      panic("trap");
80106832:	83 c4 14             	add    $0x14,%esp
80106835:	68 99 8f 10 80       	push   $0x80108f99
8010683a:	e8 51 9b ff ff       	call   80100390 <panic>
        panic("ref count to page is 0 but it was reffed");
8010683f:	83 ec 0c             	sub    $0xc,%esp
80106842:	68 c4 8f 10 80       	push   $0x80108fc4
80106847:	e8 44 9b ff ff       	call   80100390 <panic>
8010684c:	66 90                	xchg   %ax,%ax
8010684e:	66 90                	xchg   %ax,%ax

80106850 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106850:	f3 0f 1e fb          	endbr32 
  if(!uart)
80106854:	a1 bc c5 10 80       	mov    0x8010c5bc,%eax
80106859:	85 c0                	test   %eax,%eax
8010685b:	74 1b                	je     80106878 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010685d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106862:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106863:	a8 01                	test   $0x1,%al
80106865:	74 11                	je     80106878 <uartgetc+0x28>
80106867:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010686c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010686d:	0f b6 c0             	movzbl %al,%eax
80106870:	c3                   	ret    
80106871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106878:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010687d:	c3                   	ret    
8010687e:	66 90                	xchg   %ax,%ax

80106880 <uartputc.part.0>:
uartputc(int c)
80106880:	55                   	push   %ebp
80106881:	89 e5                	mov    %esp,%ebp
80106883:	57                   	push   %edi
80106884:	89 c7                	mov    %eax,%edi
80106886:	56                   	push   %esi
80106887:	be fd 03 00 00       	mov    $0x3fd,%esi
8010688c:	53                   	push   %ebx
8010688d:	bb 80 00 00 00       	mov    $0x80,%ebx
80106892:	83 ec 0c             	sub    $0xc,%esp
80106895:	eb 1b                	jmp    801068b2 <uartputc.part.0+0x32>
80106897:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010689e:	66 90                	xchg   %ax,%ax
    microdelay(10);
801068a0:	83 ec 0c             	sub    $0xc,%esp
801068a3:	6a 0a                	push   $0xa
801068a5:	e8 06 c8 ff ff       	call   801030b0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801068aa:	83 c4 10             	add    $0x10,%esp
801068ad:	83 eb 01             	sub    $0x1,%ebx
801068b0:	74 07                	je     801068b9 <uartputc.part.0+0x39>
801068b2:	89 f2                	mov    %esi,%edx
801068b4:	ec                   	in     (%dx),%al
801068b5:	a8 20                	test   $0x20,%al
801068b7:	74 e7                	je     801068a0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801068b9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801068be:	89 f8                	mov    %edi,%eax
801068c0:	ee                   	out    %al,(%dx)
}
801068c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801068c4:	5b                   	pop    %ebx
801068c5:	5e                   	pop    %esi
801068c6:	5f                   	pop    %edi
801068c7:	5d                   	pop    %ebp
801068c8:	c3                   	ret    
801068c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801068d0 <uartinit>:
{
801068d0:	f3 0f 1e fb          	endbr32 
801068d4:	55                   	push   %ebp
801068d5:	31 c9                	xor    %ecx,%ecx
801068d7:	89 c8                	mov    %ecx,%eax
801068d9:	89 e5                	mov    %esp,%ebp
801068db:	57                   	push   %edi
801068dc:	56                   	push   %esi
801068dd:	53                   	push   %ebx
801068de:	bb fa 03 00 00       	mov    $0x3fa,%ebx
801068e3:	89 da                	mov    %ebx,%edx
801068e5:	83 ec 0c             	sub    $0xc,%esp
801068e8:	ee                   	out    %al,(%dx)
801068e9:	bf fb 03 00 00       	mov    $0x3fb,%edi
801068ee:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801068f3:	89 fa                	mov    %edi,%edx
801068f5:	ee                   	out    %al,(%dx)
801068f6:	b8 0c 00 00 00       	mov    $0xc,%eax
801068fb:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106900:	ee                   	out    %al,(%dx)
80106901:	be f9 03 00 00       	mov    $0x3f9,%esi
80106906:	89 c8                	mov    %ecx,%eax
80106908:	89 f2                	mov    %esi,%edx
8010690a:	ee                   	out    %al,(%dx)
8010690b:	b8 03 00 00 00       	mov    $0x3,%eax
80106910:	89 fa                	mov    %edi,%edx
80106912:	ee                   	out    %al,(%dx)
80106913:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106918:	89 c8                	mov    %ecx,%eax
8010691a:	ee                   	out    %al,(%dx)
8010691b:	b8 01 00 00 00       	mov    $0x1,%eax
80106920:	89 f2                	mov    %esi,%edx
80106922:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106923:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106928:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106929:	3c ff                	cmp    $0xff,%al
8010692b:	74 52                	je     8010697f <uartinit+0xaf>
  uart = 1;
8010692d:	c7 05 bc c5 10 80 01 	movl   $0x1,0x8010c5bc
80106934:	00 00 00 
80106937:	89 da                	mov    %ebx,%edx
80106939:	ec                   	in     (%dx),%al
8010693a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010693f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106940:	83 ec 08             	sub    $0x8,%esp
80106943:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80106948:	bb 30 91 10 80       	mov    $0x80109130,%ebx
  ioapicenable(IRQ_COM1, 0);
8010694d:	6a 00                	push   $0x0
8010694f:	6a 04                	push   $0x4
80106951:	e8 1a c2 ff ff       	call   80102b70 <ioapicenable>
80106956:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106959:	b8 78 00 00 00       	mov    $0x78,%eax
8010695e:	eb 04                	jmp    80106964 <uartinit+0x94>
80106960:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80106964:	8b 15 bc c5 10 80    	mov    0x8010c5bc,%edx
8010696a:	85 d2                	test   %edx,%edx
8010696c:	74 08                	je     80106976 <uartinit+0xa6>
    uartputc(*p);
8010696e:	0f be c0             	movsbl %al,%eax
80106971:	e8 0a ff ff ff       	call   80106880 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80106976:	89 f0                	mov    %esi,%eax
80106978:	83 c3 01             	add    $0x1,%ebx
8010697b:	84 c0                	test   %al,%al
8010697d:	75 e1                	jne    80106960 <uartinit+0x90>
}
8010697f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106982:	5b                   	pop    %ebx
80106983:	5e                   	pop    %esi
80106984:	5f                   	pop    %edi
80106985:	5d                   	pop    %ebp
80106986:	c3                   	ret    
80106987:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010698e:	66 90                	xchg   %ax,%ax

80106990 <uartputc>:
{
80106990:	f3 0f 1e fb          	endbr32 
80106994:	55                   	push   %ebp
  if(!uart)
80106995:	8b 15 bc c5 10 80    	mov    0x8010c5bc,%edx
{
8010699b:	89 e5                	mov    %esp,%ebp
8010699d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801069a0:	85 d2                	test   %edx,%edx
801069a2:	74 0c                	je     801069b0 <uartputc+0x20>
}
801069a4:	5d                   	pop    %ebp
801069a5:	e9 d6 fe ff ff       	jmp    80106880 <uartputc.part.0>
801069aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801069b0:	5d                   	pop    %ebp
801069b1:	c3                   	ret    
801069b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801069c0 <uartintr>:

void
uartintr(void)
{
801069c0:	f3 0f 1e fb          	endbr32 
801069c4:	55                   	push   %ebp
801069c5:	89 e5                	mov    %esp,%ebp
801069c7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801069ca:	68 50 68 10 80       	push   $0x80106850
801069cf:	e8 8c 9e ff ff       	call   80100860 <consoleintr>
}
801069d4:	83 c4 10             	add    $0x10,%esp
801069d7:	c9                   	leave  
801069d8:	c3                   	ret    

801069d9 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801069d9:	6a 00                	push   $0x0
  pushl $0
801069db:	6a 00                	push   $0x0
  jmp alltraps
801069dd:	e9 c7 f9 ff ff       	jmp    801063a9 <alltraps>

801069e2 <vector1>:
.globl vector1
vector1:
  pushl $0
801069e2:	6a 00                	push   $0x0
  pushl $1
801069e4:	6a 01                	push   $0x1
  jmp alltraps
801069e6:	e9 be f9 ff ff       	jmp    801063a9 <alltraps>

801069eb <vector2>:
.globl vector2
vector2:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $2
801069ed:	6a 02                	push   $0x2
  jmp alltraps
801069ef:	e9 b5 f9 ff ff       	jmp    801063a9 <alltraps>

801069f4 <vector3>:
.globl vector3
vector3:
  pushl $0
801069f4:	6a 00                	push   $0x0
  pushl $3
801069f6:	6a 03                	push   $0x3
  jmp alltraps
801069f8:	e9 ac f9 ff ff       	jmp    801063a9 <alltraps>

801069fd <vector4>:
.globl vector4
vector4:
  pushl $0
801069fd:	6a 00                	push   $0x0
  pushl $4
801069ff:	6a 04                	push   $0x4
  jmp alltraps
80106a01:	e9 a3 f9 ff ff       	jmp    801063a9 <alltraps>

80106a06 <vector5>:
.globl vector5
vector5:
  pushl $0
80106a06:	6a 00                	push   $0x0
  pushl $5
80106a08:	6a 05                	push   $0x5
  jmp alltraps
80106a0a:	e9 9a f9 ff ff       	jmp    801063a9 <alltraps>

80106a0f <vector6>:
.globl vector6
vector6:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $6
80106a11:	6a 06                	push   $0x6
  jmp alltraps
80106a13:	e9 91 f9 ff ff       	jmp    801063a9 <alltraps>

80106a18 <vector7>:
.globl vector7
vector7:
  pushl $0
80106a18:	6a 00                	push   $0x0
  pushl $7
80106a1a:	6a 07                	push   $0x7
  jmp alltraps
80106a1c:	e9 88 f9 ff ff       	jmp    801063a9 <alltraps>

80106a21 <vector8>:
.globl vector8
vector8:
  pushl $8
80106a21:	6a 08                	push   $0x8
  jmp alltraps
80106a23:	e9 81 f9 ff ff       	jmp    801063a9 <alltraps>

80106a28 <vector9>:
.globl vector9
vector9:
  pushl $0
80106a28:	6a 00                	push   $0x0
  pushl $9
80106a2a:	6a 09                	push   $0x9
  jmp alltraps
80106a2c:	e9 78 f9 ff ff       	jmp    801063a9 <alltraps>

80106a31 <vector10>:
.globl vector10
vector10:
  pushl $10
80106a31:	6a 0a                	push   $0xa
  jmp alltraps
80106a33:	e9 71 f9 ff ff       	jmp    801063a9 <alltraps>

80106a38 <vector11>:
.globl vector11
vector11:
  pushl $11
80106a38:	6a 0b                	push   $0xb
  jmp alltraps
80106a3a:	e9 6a f9 ff ff       	jmp    801063a9 <alltraps>

80106a3f <vector12>:
.globl vector12
vector12:
  pushl $12
80106a3f:	6a 0c                	push   $0xc
  jmp alltraps
80106a41:	e9 63 f9 ff ff       	jmp    801063a9 <alltraps>

80106a46 <vector13>:
.globl vector13
vector13:
  pushl $13
80106a46:	6a 0d                	push   $0xd
  jmp alltraps
80106a48:	e9 5c f9 ff ff       	jmp    801063a9 <alltraps>

80106a4d <vector14>:
.globl vector14
vector14:
  pushl $14
80106a4d:	6a 0e                	push   $0xe
  jmp alltraps
80106a4f:	e9 55 f9 ff ff       	jmp    801063a9 <alltraps>

80106a54 <vector15>:
.globl vector15
vector15:
  pushl $0
80106a54:	6a 00                	push   $0x0
  pushl $15
80106a56:	6a 0f                	push   $0xf
  jmp alltraps
80106a58:	e9 4c f9 ff ff       	jmp    801063a9 <alltraps>

80106a5d <vector16>:
.globl vector16
vector16:
  pushl $0
80106a5d:	6a 00                	push   $0x0
  pushl $16
80106a5f:	6a 10                	push   $0x10
  jmp alltraps
80106a61:	e9 43 f9 ff ff       	jmp    801063a9 <alltraps>

80106a66 <vector17>:
.globl vector17
vector17:
  pushl $17
80106a66:	6a 11                	push   $0x11
  jmp alltraps
80106a68:	e9 3c f9 ff ff       	jmp    801063a9 <alltraps>

80106a6d <vector18>:
.globl vector18
vector18:
  pushl $0
80106a6d:	6a 00                	push   $0x0
  pushl $18
80106a6f:	6a 12                	push   $0x12
  jmp alltraps
80106a71:	e9 33 f9 ff ff       	jmp    801063a9 <alltraps>

80106a76 <vector19>:
.globl vector19
vector19:
  pushl $0
80106a76:	6a 00                	push   $0x0
  pushl $19
80106a78:	6a 13                	push   $0x13
  jmp alltraps
80106a7a:	e9 2a f9 ff ff       	jmp    801063a9 <alltraps>

80106a7f <vector20>:
.globl vector20
vector20:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $20
80106a81:	6a 14                	push   $0x14
  jmp alltraps
80106a83:	e9 21 f9 ff ff       	jmp    801063a9 <alltraps>

80106a88 <vector21>:
.globl vector21
vector21:
  pushl $0
80106a88:	6a 00                	push   $0x0
  pushl $21
80106a8a:	6a 15                	push   $0x15
  jmp alltraps
80106a8c:	e9 18 f9 ff ff       	jmp    801063a9 <alltraps>

80106a91 <vector22>:
.globl vector22
vector22:
  pushl $0
80106a91:	6a 00                	push   $0x0
  pushl $22
80106a93:	6a 16                	push   $0x16
  jmp alltraps
80106a95:	e9 0f f9 ff ff       	jmp    801063a9 <alltraps>

80106a9a <vector23>:
.globl vector23
vector23:
  pushl $0
80106a9a:	6a 00                	push   $0x0
  pushl $23
80106a9c:	6a 17                	push   $0x17
  jmp alltraps
80106a9e:	e9 06 f9 ff ff       	jmp    801063a9 <alltraps>

80106aa3 <vector24>:
.globl vector24
vector24:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $24
80106aa5:	6a 18                	push   $0x18
  jmp alltraps
80106aa7:	e9 fd f8 ff ff       	jmp    801063a9 <alltraps>

80106aac <vector25>:
.globl vector25
vector25:
  pushl $0
80106aac:	6a 00                	push   $0x0
  pushl $25
80106aae:	6a 19                	push   $0x19
  jmp alltraps
80106ab0:	e9 f4 f8 ff ff       	jmp    801063a9 <alltraps>

80106ab5 <vector26>:
.globl vector26
vector26:
  pushl $0
80106ab5:	6a 00                	push   $0x0
  pushl $26
80106ab7:	6a 1a                	push   $0x1a
  jmp alltraps
80106ab9:	e9 eb f8 ff ff       	jmp    801063a9 <alltraps>

80106abe <vector27>:
.globl vector27
vector27:
  pushl $0
80106abe:	6a 00                	push   $0x0
  pushl $27
80106ac0:	6a 1b                	push   $0x1b
  jmp alltraps
80106ac2:	e9 e2 f8 ff ff       	jmp    801063a9 <alltraps>

80106ac7 <vector28>:
.globl vector28
vector28:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $28
80106ac9:	6a 1c                	push   $0x1c
  jmp alltraps
80106acb:	e9 d9 f8 ff ff       	jmp    801063a9 <alltraps>

80106ad0 <vector29>:
.globl vector29
vector29:
  pushl $0
80106ad0:	6a 00                	push   $0x0
  pushl $29
80106ad2:	6a 1d                	push   $0x1d
  jmp alltraps
80106ad4:	e9 d0 f8 ff ff       	jmp    801063a9 <alltraps>

80106ad9 <vector30>:
.globl vector30
vector30:
  pushl $0
80106ad9:	6a 00                	push   $0x0
  pushl $30
80106adb:	6a 1e                	push   $0x1e
  jmp alltraps
80106add:	e9 c7 f8 ff ff       	jmp    801063a9 <alltraps>

80106ae2 <vector31>:
.globl vector31
vector31:
  pushl $0
80106ae2:	6a 00                	push   $0x0
  pushl $31
80106ae4:	6a 1f                	push   $0x1f
  jmp alltraps
80106ae6:	e9 be f8 ff ff       	jmp    801063a9 <alltraps>

80106aeb <vector32>:
.globl vector32
vector32:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $32
80106aed:	6a 20                	push   $0x20
  jmp alltraps
80106aef:	e9 b5 f8 ff ff       	jmp    801063a9 <alltraps>

80106af4 <vector33>:
.globl vector33
vector33:
  pushl $0
80106af4:	6a 00                	push   $0x0
  pushl $33
80106af6:	6a 21                	push   $0x21
  jmp alltraps
80106af8:	e9 ac f8 ff ff       	jmp    801063a9 <alltraps>

80106afd <vector34>:
.globl vector34
vector34:
  pushl $0
80106afd:	6a 00                	push   $0x0
  pushl $34
80106aff:	6a 22                	push   $0x22
  jmp alltraps
80106b01:	e9 a3 f8 ff ff       	jmp    801063a9 <alltraps>

80106b06 <vector35>:
.globl vector35
vector35:
  pushl $0
80106b06:	6a 00                	push   $0x0
  pushl $35
80106b08:	6a 23                	push   $0x23
  jmp alltraps
80106b0a:	e9 9a f8 ff ff       	jmp    801063a9 <alltraps>

80106b0f <vector36>:
.globl vector36
vector36:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $36
80106b11:	6a 24                	push   $0x24
  jmp alltraps
80106b13:	e9 91 f8 ff ff       	jmp    801063a9 <alltraps>

80106b18 <vector37>:
.globl vector37
vector37:
  pushl $0
80106b18:	6a 00                	push   $0x0
  pushl $37
80106b1a:	6a 25                	push   $0x25
  jmp alltraps
80106b1c:	e9 88 f8 ff ff       	jmp    801063a9 <alltraps>

80106b21 <vector38>:
.globl vector38
vector38:
  pushl $0
80106b21:	6a 00                	push   $0x0
  pushl $38
80106b23:	6a 26                	push   $0x26
  jmp alltraps
80106b25:	e9 7f f8 ff ff       	jmp    801063a9 <alltraps>

80106b2a <vector39>:
.globl vector39
vector39:
  pushl $0
80106b2a:	6a 00                	push   $0x0
  pushl $39
80106b2c:	6a 27                	push   $0x27
  jmp alltraps
80106b2e:	e9 76 f8 ff ff       	jmp    801063a9 <alltraps>

80106b33 <vector40>:
.globl vector40
vector40:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $40
80106b35:	6a 28                	push   $0x28
  jmp alltraps
80106b37:	e9 6d f8 ff ff       	jmp    801063a9 <alltraps>

80106b3c <vector41>:
.globl vector41
vector41:
  pushl $0
80106b3c:	6a 00                	push   $0x0
  pushl $41
80106b3e:	6a 29                	push   $0x29
  jmp alltraps
80106b40:	e9 64 f8 ff ff       	jmp    801063a9 <alltraps>

80106b45 <vector42>:
.globl vector42
vector42:
  pushl $0
80106b45:	6a 00                	push   $0x0
  pushl $42
80106b47:	6a 2a                	push   $0x2a
  jmp alltraps
80106b49:	e9 5b f8 ff ff       	jmp    801063a9 <alltraps>

80106b4e <vector43>:
.globl vector43
vector43:
  pushl $0
80106b4e:	6a 00                	push   $0x0
  pushl $43
80106b50:	6a 2b                	push   $0x2b
  jmp alltraps
80106b52:	e9 52 f8 ff ff       	jmp    801063a9 <alltraps>

80106b57 <vector44>:
.globl vector44
vector44:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $44
80106b59:	6a 2c                	push   $0x2c
  jmp alltraps
80106b5b:	e9 49 f8 ff ff       	jmp    801063a9 <alltraps>

80106b60 <vector45>:
.globl vector45
vector45:
  pushl $0
80106b60:	6a 00                	push   $0x0
  pushl $45
80106b62:	6a 2d                	push   $0x2d
  jmp alltraps
80106b64:	e9 40 f8 ff ff       	jmp    801063a9 <alltraps>

80106b69 <vector46>:
.globl vector46
vector46:
  pushl $0
80106b69:	6a 00                	push   $0x0
  pushl $46
80106b6b:	6a 2e                	push   $0x2e
  jmp alltraps
80106b6d:	e9 37 f8 ff ff       	jmp    801063a9 <alltraps>

80106b72 <vector47>:
.globl vector47
vector47:
  pushl $0
80106b72:	6a 00                	push   $0x0
  pushl $47
80106b74:	6a 2f                	push   $0x2f
  jmp alltraps
80106b76:	e9 2e f8 ff ff       	jmp    801063a9 <alltraps>

80106b7b <vector48>:
.globl vector48
vector48:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $48
80106b7d:	6a 30                	push   $0x30
  jmp alltraps
80106b7f:	e9 25 f8 ff ff       	jmp    801063a9 <alltraps>

80106b84 <vector49>:
.globl vector49
vector49:
  pushl $0
80106b84:	6a 00                	push   $0x0
  pushl $49
80106b86:	6a 31                	push   $0x31
  jmp alltraps
80106b88:	e9 1c f8 ff ff       	jmp    801063a9 <alltraps>

80106b8d <vector50>:
.globl vector50
vector50:
  pushl $0
80106b8d:	6a 00                	push   $0x0
  pushl $50
80106b8f:	6a 32                	push   $0x32
  jmp alltraps
80106b91:	e9 13 f8 ff ff       	jmp    801063a9 <alltraps>

80106b96 <vector51>:
.globl vector51
vector51:
  pushl $0
80106b96:	6a 00                	push   $0x0
  pushl $51
80106b98:	6a 33                	push   $0x33
  jmp alltraps
80106b9a:	e9 0a f8 ff ff       	jmp    801063a9 <alltraps>

80106b9f <vector52>:
.globl vector52
vector52:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $52
80106ba1:	6a 34                	push   $0x34
  jmp alltraps
80106ba3:	e9 01 f8 ff ff       	jmp    801063a9 <alltraps>

80106ba8 <vector53>:
.globl vector53
vector53:
  pushl $0
80106ba8:	6a 00                	push   $0x0
  pushl $53
80106baa:	6a 35                	push   $0x35
  jmp alltraps
80106bac:	e9 f8 f7 ff ff       	jmp    801063a9 <alltraps>

80106bb1 <vector54>:
.globl vector54
vector54:
  pushl $0
80106bb1:	6a 00                	push   $0x0
  pushl $54
80106bb3:	6a 36                	push   $0x36
  jmp alltraps
80106bb5:	e9 ef f7 ff ff       	jmp    801063a9 <alltraps>

80106bba <vector55>:
.globl vector55
vector55:
  pushl $0
80106bba:	6a 00                	push   $0x0
  pushl $55
80106bbc:	6a 37                	push   $0x37
  jmp alltraps
80106bbe:	e9 e6 f7 ff ff       	jmp    801063a9 <alltraps>

80106bc3 <vector56>:
.globl vector56
vector56:
  pushl $0
80106bc3:	6a 00                	push   $0x0
  pushl $56
80106bc5:	6a 38                	push   $0x38
  jmp alltraps
80106bc7:	e9 dd f7 ff ff       	jmp    801063a9 <alltraps>

80106bcc <vector57>:
.globl vector57
vector57:
  pushl $0
80106bcc:	6a 00                	push   $0x0
  pushl $57
80106bce:	6a 39                	push   $0x39
  jmp alltraps
80106bd0:	e9 d4 f7 ff ff       	jmp    801063a9 <alltraps>

80106bd5 <vector58>:
.globl vector58
vector58:
  pushl $0
80106bd5:	6a 00                	push   $0x0
  pushl $58
80106bd7:	6a 3a                	push   $0x3a
  jmp alltraps
80106bd9:	e9 cb f7 ff ff       	jmp    801063a9 <alltraps>

80106bde <vector59>:
.globl vector59
vector59:
  pushl $0
80106bde:	6a 00                	push   $0x0
  pushl $59
80106be0:	6a 3b                	push   $0x3b
  jmp alltraps
80106be2:	e9 c2 f7 ff ff       	jmp    801063a9 <alltraps>

80106be7 <vector60>:
.globl vector60
vector60:
  pushl $0
80106be7:	6a 00                	push   $0x0
  pushl $60
80106be9:	6a 3c                	push   $0x3c
  jmp alltraps
80106beb:	e9 b9 f7 ff ff       	jmp    801063a9 <alltraps>

80106bf0 <vector61>:
.globl vector61
vector61:
  pushl $0
80106bf0:	6a 00                	push   $0x0
  pushl $61
80106bf2:	6a 3d                	push   $0x3d
  jmp alltraps
80106bf4:	e9 b0 f7 ff ff       	jmp    801063a9 <alltraps>

80106bf9 <vector62>:
.globl vector62
vector62:
  pushl $0
80106bf9:	6a 00                	push   $0x0
  pushl $62
80106bfb:	6a 3e                	push   $0x3e
  jmp alltraps
80106bfd:	e9 a7 f7 ff ff       	jmp    801063a9 <alltraps>

80106c02 <vector63>:
.globl vector63
vector63:
  pushl $0
80106c02:	6a 00                	push   $0x0
  pushl $63
80106c04:	6a 3f                	push   $0x3f
  jmp alltraps
80106c06:	e9 9e f7 ff ff       	jmp    801063a9 <alltraps>

80106c0b <vector64>:
.globl vector64
vector64:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $64
80106c0d:	6a 40                	push   $0x40
  jmp alltraps
80106c0f:	e9 95 f7 ff ff       	jmp    801063a9 <alltraps>

80106c14 <vector65>:
.globl vector65
vector65:
  pushl $0
80106c14:	6a 00                	push   $0x0
  pushl $65
80106c16:	6a 41                	push   $0x41
  jmp alltraps
80106c18:	e9 8c f7 ff ff       	jmp    801063a9 <alltraps>

80106c1d <vector66>:
.globl vector66
vector66:
  pushl $0
80106c1d:	6a 00                	push   $0x0
  pushl $66
80106c1f:	6a 42                	push   $0x42
  jmp alltraps
80106c21:	e9 83 f7 ff ff       	jmp    801063a9 <alltraps>

80106c26 <vector67>:
.globl vector67
vector67:
  pushl $0
80106c26:	6a 00                	push   $0x0
  pushl $67
80106c28:	6a 43                	push   $0x43
  jmp alltraps
80106c2a:	e9 7a f7 ff ff       	jmp    801063a9 <alltraps>

80106c2f <vector68>:
.globl vector68
vector68:
  pushl $0
80106c2f:	6a 00                	push   $0x0
  pushl $68
80106c31:	6a 44                	push   $0x44
  jmp alltraps
80106c33:	e9 71 f7 ff ff       	jmp    801063a9 <alltraps>

80106c38 <vector69>:
.globl vector69
vector69:
  pushl $0
80106c38:	6a 00                	push   $0x0
  pushl $69
80106c3a:	6a 45                	push   $0x45
  jmp alltraps
80106c3c:	e9 68 f7 ff ff       	jmp    801063a9 <alltraps>

80106c41 <vector70>:
.globl vector70
vector70:
  pushl $0
80106c41:	6a 00                	push   $0x0
  pushl $70
80106c43:	6a 46                	push   $0x46
  jmp alltraps
80106c45:	e9 5f f7 ff ff       	jmp    801063a9 <alltraps>

80106c4a <vector71>:
.globl vector71
vector71:
  pushl $0
80106c4a:	6a 00                	push   $0x0
  pushl $71
80106c4c:	6a 47                	push   $0x47
  jmp alltraps
80106c4e:	e9 56 f7 ff ff       	jmp    801063a9 <alltraps>

80106c53 <vector72>:
.globl vector72
vector72:
  pushl $0
80106c53:	6a 00                	push   $0x0
  pushl $72
80106c55:	6a 48                	push   $0x48
  jmp alltraps
80106c57:	e9 4d f7 ff ff       	jmp    801063a9 <alltraps>

80106c5c <vector73>:
.globl vector73
vector73:
  pushl $0
80106c5c:	6a 00                	push   $0x0
  pushl $73
80106c5e:	6a 49                	push   $0x49
  jmp alltraps
80106c60:	e9 44 f7 ff ff       	jmp    801063a9 <alltraps>

80106c65 <vector74>:
.globl vector74
vector74:
  pushl $0
80106c65:	6a 00                	push   $0x0
  pushl $74
80106c67:	6a 4a                	push   $0x4a
  jmp alltraps
80106c69:	e9 3b f7 ff ff       	jmp    801063a9 <alltraps>

80106c6e <vector75>:
.globl vector75
vector75:
  pushl $0
80106c6e:	6a 00                	push   $0x0
  pushl $75
80106c70:	6a 4b                	push   $0x4b
  jmp alltraps
80106c72:	e9 32 f7 ff ff       	jmp    801063a9 <alltraps>

80106c77 <vector76>:
.globl vector76
vector76:
  pushl $0
80106c77:	6a 00                	push   $0x0
  pushl $76
80106c79:	6a 4c                	push   $0x4c
  jmp alltraps
80106c7b:	e9 29 f7 ff ff       	jmp    801063a9 <alltraps>

80106c80 <vector77>:
.globl vector77
vector77:
  pushl $0
80106c80:	6a 00                	push   $0x0
  pushl $77
80106c82:	6a 4d                	push   $0x4d
  jmp alltraps
80106c84:	e9 20 f7 ff ff       	jmp    801063a9 <alltraps>

80106c89 <vector78>:
.globl vector78
vector78:
  pushl $0
80106c89:	6a 00                	push   $0x0
  pushl $78
80106c8b:	6a 4e                	push   $0x4e
  jmp alltraps
80106c8d:	e9 17 f7 ff ff       	jmp    801063a9 <alltraps>

80106c92 <vector79>:
.globl vector79
vector79:
  pushl $0
80106c92:	6a 00                	push   $0x0
  pushl $79
80106c94:	6a 4f                	push   $0x4f
  jmp alltraps
80106c96:	e9 0e f7 ff ff       	jmp    801063a9 <alltraps>

80106c9b <vector80>:
.globl vector80
vector80:
  pushl $0
80106c9b:	6a 00                	push   $0x0
  pushl $80
80106c9d:	6a 50                	push   $0x50
  jmp alltraps
80106c9f:	e9 05 f7 ff ff       	jmp    801063a9 <alltraps>

80106ca4 <vector81>:
.globl vector81
vector81:
  pushl $0
80106ca4:	6a 00                	push   $0x0
  pushl $81
80106ca6:	6a 51                	push   $0x51
  jmp alltraps
80106ca8:	e9 fc f6 ff ff       	jmp    801063a9 <alltraps>

80106cad <vector82>:
.globl vector82
vector82:
  pushl $0
80106cad:	6a 00                	push   $0x0
  pushl $82
80106caf:	6a 52                	push   $0x52
  jmp alltraps
80106cb1:	e9 f3 f6 ff ff       	jmp    801063a9 <alltraps>

80106cb6 <vector83>:
.globl vector83
vector83:
  pushl $0
80106cb6:	6a 00                	push   $0x0
  pushl $83
80106cb8:	6a 53                	push   $0x53
  jmp alltraps
80106cba:	e9 ea f6 ff ff       	jmp    801063a9 <alltraps>

80106cbf <vector84>:
.globl vector84
vector84:
  pushl $0
80106cbf:	6a 00                	push   $0x0
  pushl $84
80106cc1:	6a 54                	push   $0x54
  jmp alltraps
80106cc3:	e9 e1 f6 ff ff       	jmp    801063a9 <alltraps>

80106cc8 <vector85>:
.globl vector85
vector85:
  pushl $0
80106cc8:	6a 00                	push   $0x0
  pushl $85
80106cca:	6a 55                	push   $0x55
  jmp alltraps
80106ccc:	e9 d8 f6 ff ff       	jmp    801063a9 <alltraps>

80106cd1 <vector86>:
.globl vector86
vector86:
  pushl $0
80106cd1:	6a 00                	push   $0x0
  pushl $86
80106cd3:	6a 56                	push   $0x56
  jmp alltraps
80106cd5:	e9 cf f6 ff ff       	jmp    801063a9 <alltraps>

80106cda <vector87>:
.globl vector87
vector87:
  pushl $0
80106cda:	6a 00                	push   $0x0
  pushl $87
80106cdc:	6a 57                	push   $0x57
  jmp alltraps
80106cde:	e9 c6 f6 ff ff       	jmp    801063a9 <alltraps>

80106ce3 <vector88>:
.globl vector88
vector88:
  pushl $0
80106ce3:	6a 00                	push   $0x0
  pushl $88
80106ce5:	6a 58                	push   $0x58
  jmp alltraps
80106ce7:	e9 bd f6 ff ff       	jmp    801063a9 <alltraps>

80106cec <vector89>:
.globl vector89
vector89:
  pushl $0
80106cec:	6a 00                	push   $0x0
  pushl $89
80106cee:	6a 59                	push   $0x59
  jmp alltraps
80106cf0:	e9 b4 f6 ff ff       	jmp    801063a9 <alltraps>

80106cf5 <vector90>:
.globl vector90
vector90:
  pushl $0
80106cf5:	6a 00                	push   $0x0
  pushl $90
80106cf7:	6a 5a                	push   $0x5a
  jmp alltraps
80106cf9:	e9 ab f6 ff ff       	jmp    801063a9 <alltraps>

80106cfe <vector91>:
.globl vector91
vector91:
  pushl $0
80106cfe:	6a 00                	push   $0x0
  pushl $91
80106d00:	6a 5b                	push   $0x5b
  jmp alltraps
80106d02:	e9 a2 f6 ff ff       	jmp    801063a9 <alltraps>

80106d07 <vector92>:
.globl vector92
vector92:
  pushl $0
80106d07:	6a 00                	push   $0x0
  pushl $92
80106d09:	6a 5c                	push   $0x5c
  jmp alltraps
80106d0b:	e9 99 f6 ff ff       	jmp    801063a9 <alltraps>

80106d10 <vector93>:
.globl vector93
vector93:
  pushl $0
80106d10:	6a 00                	push   $0x0
  pushl $93
80106d12:	6a 5d                	push   $0x5d
  jmp alltraps
80106d14:	e9 90 f6 ff ff       	jmp    801063a9 <alltraps>

80106d19 <vector94>:
.globl vector94
vector94:
  pushl $0
80106d19:	6a 00                	push   $0x0
  pushl $94
80106d1b:	6a 5e                	push   $0x5e
  jmp alltraps
80106d1d:	e9 87 f6 ff ff       	jmp    801063a9 <alltraps>

80106d22 <vector95>:
.globl vector95
vector95:
  pushl $0
80106d22:	6a 00                	push   $0x0
  pushl $95
80106d24:	6a 5f                	push   $0x5f
  jmp alltraps
80106d26:	e9 7e f6 ff ff       	jmp    801063a9 <alltraps>

80106d2b <vector96>:
.globl vector96
vector96:
  pushl $0
80106d2b:	6a 00                	push   $0x0
  pushl $96
80106d2d:	6a 60                	push   $0x60
  jmp alltraps
80106d2f:	e9 75 f6 ff ff       	jmp    801063a9 <alltraps>

80106d34 <vector97>:
.globl vector97
vector97:
  pushl $0
80106d34:	6a 00                	push   $0x0
  pushl $97
80106d36:	6a 61                	push   $0x61
  jmp alltraps
80106d38:	e9 6c f6 ff ff       	jmp    801063a9 <alltraps>

80106d3d <vector98>:
.globl vector98
vector98:
  pushl $0
80106d3d:	6a 00                	push   $0x0
  pushl $98
80106d3f:	6a 62                	push   $0x62
  jmp alltraps
80106d41:	e9 63 f6 ff ff       	jmp    801063a9 <alltraps>

80106d46 <vector99>:
.globl vector99
vector99:
  pushl $0
80106d46:	6a 00                	push   $0x0
  pushl $99
80106d48:	6a 63                	push   $0x63
  jmp alltraps
80106d4a:	e9 5a f6 ff ff       	jmp    801063a9 <alltraps>

80106d4f <vector100>:
.globl vector100
vector100:
  pushl $0
80106d4f:	6a 00                	push   $0x0
  pushl $100
80106d51:	6a 64                	push   $0x64
  jmp alltraps
80106d53:	e9 51 f6 ff ff       	jmp    801063a9 <alltraps>

80106d58 <vector101>:
.globl vector101
vector101:
  pushl $0
80106d58:	6a 00                	push   $0x0
  pushl $101
80106d5a:	6a 65                	push   $0x65
  jmp alltraps
80106d5c:	e9 48 f6 ff ff       	jmp    801063a9 <alltraps>

80106d61 <vector102>:
.globl vector102
vector102:
  pushl $0
80106d61:	6a 00                	push   $0x0
  pushl $102
80106d63:	6a 66                	push   $0x66
  jmp alltraps
80106d65:	e9 3f f6 ff ff       	jmp    801063a9 <alltraps>

80106d6a <vector103>:
.globl vector103
vector103:
  pushl $0
80106d6a:	6a 00                	push   $0x0
  pushl $103
80106d6c:	6a 67                	push   $0x67
  jmp alltraps
80106d6e:	e9 36 f6 ff ff       	jmp    801063a9 <alltraps>

80106d73 <vector104>:
.globl vector104
vector104:
  pushl $0
80106d73:	6a 00                	push   $0x0
  pushl $104
80106d75:	6a 68                	push   $0x68
  jmp alltraps
80106d77:	e9 2d f6 ff ff       	jmp    801063a9 <alltraps>

80106d7c <vector105>:
.globl vector105
vector105:
  pushl $0
80106d7c:	6a 00                	push   $0x0
  pushl $105
80106d7e:	6a 69                	push   $0x69
  jmp alltraps
80106d80:	e9 24 f6 ff ff       	jmp    801063a9 <alltraps>

80106d85 <vector106>:
.globl vector106
vector106:
  pushl $0
80106d85:	6a 00                	push   $0x0
  pushl $106
80106d87:	6a 6a                	push   $0x6a
  jmp alltraps
80106d89:	e9 1b f6 ff ff       	jmp    801063a9 <alltraps>

80106d8e <vector107>:
.globl vector107
vector107:
  pushl $0
80106d8e:	6a 00                	push   $0x0
  pushl $107
80106d90:	6a 6b                	push   $0x6b
  jmp alltraps
80106d92:	e9 12 f6 ff ff       	jmp    801063a9 <alltraps>

80106d97 <vector108>:
.globl vector108
vector108:
  pushl $0
80106d97:	6a 00                	push   $0x0
  pushl $108
80106d99:	6a 6c                	push   $0x6c
  jmp alltraps
80106d9b:	e9 09 f6 ff ff       	jmp    801063a9 <alltraps>

80106da0 <vector109>:
.globl vector109
vector109:
  pushl $0
80106da0:	6a 00                	push   $0x0
  pushl $109
80106da2:	6a 6d                	push   $0x6d
  jmp alltraps
80106da4:	e9 00 f6 ff ff       	jmp    801063a9 <alltraps>

80106da9 <vector110>:
.globl vector110
vector110:
  pushl $0
80106da9:	6a 00                	push   $0x0
  pushl $110
80106dab:	6a 6e                	push   $0x6e
  jmp alltraps
80106dad:	e9 f7 f5 ff ff       	jmp    801063a9 <alltraps>

80106db2 <vector111>:
.globl vector111
vector111:
  pushl $0
80106db2:	6a 00                	push   $0x0
  pushl $111
80106db4:	6a 6f                	push   $0x6f
  jmp alltraps
80106db6:	e9 ee f5 ff ff       	jmp    801063a9 <alltraps>

80106dbb <vector112>:
.globl vector112
vector112:
  pushl $0
80106dbb:	6a 00                	push   $0x0
  pushl $112
80106dbd:	6a 70                	push   $0x70
  jmp alltraps
80106dbf:	e9 e5 f5 ff ff       	jmp    801063a9 <alltraps>

80106dc4 <vector113>:
.globl vector113
vector113:
  pushl $0
80106dc4:	6a 00                	push   $0x0
  pushl $113
80106dc6:	6a 71                	push   $0x71
  jmp alltraps
80106dc8:	e9 dc f5 ff ff       	jmp    801063a9 <alltraps>

80106dcd <vector114>:
.globl vector114
vector114:
  pushl $0
80106dcd:	6a 00                	push   $0x0
  pushl $114
80106dcf:	6a 72                	push   $0x72
  jmp alltraps
80106dd1:	e9 d3 f5 ff ff       	jmp    801063a9 <alltraps>

80106dd6 <vector115>:
.globl vector115
vector115:
  pushl $0
80106dd6:	6a 00                	push   $0x0
  pushl $115
80106dd8:	6a 73                	push   $0x73
  jmp alltraps
80106dda:	e9 ca f5 ff ff       	jmp    801063a9 <alltraps>

80106ddf <vector116>:
.globl vector116
vector116:
  pushl $0
80106ddf:	6a 00                	push   $0x0
  pushl $116
80106de1:	6a 74                	push   $0x74
  jmp alltraps
80106de3:	e9 c1 f5 ff ff       	jmp    801063a9 <alltraps>

80106de8 <vector117>:
.globl vector117
vector117:
  pushl $0
80106de8:	6a 00                	push   $0x0
  pushl $117
80106dea:	6a 75                	push   $0x75
  jmp alltraps
80106dec:	e9 b8 f5 ff ff       	jmp    801063a9 <alltraps>

80106df1 <vector118>:
.globl vector118
vector118:
  pushl $0
80106df1:	6a 00                	push   $0x0
  pushl $118
80106df3:	6a 76                	push   $0x76
  jmp alltraps
80106df5:	e9 af f5 ff ff       	jmp    801063a9 <alltraps>

80106dfa <vector119>:
.globl vector119
vector119:
  pushl $0
80106dfa:	6a 00                	push   $0x0
  pushl $119
80106dfc:	6a 77                	push   $0x77
  jmp alltraps
80106dfe:	e9 a6 f5 ff ff       	jmp    801063a9 <alltraps>

80106e03 <vector120>:
.globl vector120
vector120:
  pushl $0
80106e03:	6a 00                	push   $0x0
  pushl $120
80106e05:	6a 78                	push   $0x78
  jmp alltraps
80106e07:	e9 9d f5 ff ff       	jmp    801063a9 <alltraps>

80106e0c <vector121>:
.globl vector121
vector121:
  pushl $0
80106e0c:	6a 00                	push   $0x0
  pushl $121
80106e0e:	6a 79                	push   $0x79
  jmp alltraps
80106e10:	e9 94 f5 ff ff       	jmp    801063a9 <alltraps>

80106e15 <vector122>:
.globl vector122
vector122:
  pushl $0
80106e15:	6a 00                	push   $0x0
  pushl $122
80106e17:	6a 7a                	push   $0x7a
  jmp alltraps
80106e19:	e9 8b f5 ff ff       	jmp    801063a9 <alltraps>

80106e1e <vector123>:
.globl vector123
vector123:
  pushl $0
80106e1e:	6a 00                	push   $0x0
  pushl $123
80106e20:	6a 7b                	push   $0x7b
  jmp alltraps
80106e22:	e9 82 f5 ff ff       	jmp    801063a9 <alltraps>

80106e27 <vector124>:
.globl vector124
vector124:
  pushl $0
80106e27:	6a 00                	push   $0x0
  pushl $124
80106e29:	6a 7c                	push   $0x7c
  jmp alltraps
80106e2b:	e9 79 f5 ff ff       	jmp    801063a9 <alltraps>

80106e30 <vector125>:
.globl vector125
vector125:
  pushl $0
80106e30:	6a 00                	push   $0x0
  pushl $125
80106e32:	6a 7d                	push   $0x7d
  jmp alltraps
80106e34:	e9 70 f5 ff ff       	jmp    801063a9 <alltraps>

80106e39 <vector126>:
.globl vector126
vector126:
  pushl $0
80106e39:	6a 00                	push   $0x0
  pushl $126
80106e3b:	6a 7e                	push   $0x7e
  jmp alltraps
80106e3d:	e9 67 f5 ff ff       	jmp    801063a9 <alltraps>

80106e42 <vector127>:
.globl vector127
vector127:
  pushl $0
80106e42:	6a 00                	push   $0x0
  pushl $127
80106e44:	6a 7f                	push   $0x7f
  jmp alltraps
80106e46:	e9 5e f5 ff ff       	jmp    801063a9 <alltraps>

80106e4b <vector128>:
.globl vector128
vector128:
  pushl $0
80106e4b:	6a 00                	push   $0x0
  pushl $128
80106e4d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106e52:	e9 52 f5 ff ff       	jmp    801063a9 <alltraps>

80106e57 <vector129>:
.globl vector129
vector129:
  pushl $0
80106e57:	6a 00                	push   $0x0
  pushl $129
80106e59:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106e5e:	e9 46 f5 ff ff       	jmp    801063a9 <alltraps>

80106e63 <vector130>:
.globl vector130
vector130:
  pushl $0
80106e63:	6a 00                	push   $0x0
  pushl $130
80106e65:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106e6a:	e9 3a f5 ff ff       	jmp    801063a9 <alltraps>

80106e6f <vector131>:
.globl vector131
vector131:
  pushl $0
80106e6f:	6a 00                	push   $0x0
  pushl $131
80106e71:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106e76:	e9 2e f5 ff ff       	jmp    801063a9 <alltraps>

80106e7b <vector132>:
.globl vector132
vector132:
  pushl $0
80106e7b:	6a 00                	push   $0x0
  pushl $132
80106e7d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106e82:	e9 22 f5 ff ff       	jmp    801063a9 <alltraps>

80106e87 <vector133>:
.globl vector133
vector133:
  pushl $0
80106e87:	6a 00                	push   $0x0
  pushl $133
80106e89:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106e8e:	e9 16 f5 ff ff       	jmp    801063a9 <alltraps>

80106e93 <vector134>:
.globl vector134
vector134:
  pushl $0
80106e93:	6a 00                	push   $0x0
  pushl $134
80106e95:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106e9a:	e9 0a f5 ff ff       	jmp    801063a9 <alltraps>

80106e9f <vector135>:
.globl vector135
vector135:
  pushl $0
80106e9f:	6a 00                	push   $0x0
  pushl $135
80106ea1:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106ea6:	e9 fe f4 ff ff       	jmp    801063a9 <alltraps>

80106eab <vector136>:
.globl vector136
vector136:
  pushl $0
80106eab:	6a 00                	push   $0x0
  pushl $136
80106ead:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106eb2:	e9 f2 f4 ff ff       	jmp    801063a9 <alltraps>

80106eb7 <vector137>:
.globl vector137
vector137:
  pushl $0
80106eb7:	6a 00                	push   $0x0
  pushl $137
80106eb9:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106ebe:	e9 e6 f4 ff ff       	jmp    801063a9 <alltraps>

80106ec3 <vector138>:
.globl vector138
vector138:
  pushl $0
80106ec3:	6a 00                	push   $0x0
  pushl $138
80106ec5:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106eca:	e9 da f4 ff ff       	jmp    801063a9 <alltraps>

80106ecf <vector139>:
.globl vector139
vector139:
  pushl $0
80106ecf:	6a 00                	push   $0x0
  pushl $139
80106ed1:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106ed6:	e9 ce f4 ff ff       	jmp    801063a9 <alltraps>

80106edb <vector140>:
.globl vector140
vector140:
  pushl $0
80106edb:	6a 00                	push   $0x0
  pushl $140
80106edd:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106ee2:	e9 c2 f4 ff ff       	jmp    801063a9 <alltraps>

80106ee7 <vector141>:
.globl vector141
vector141:
  pushl $0
80106ee7:	6a 00                	push   $0x0
  pushl $141
80106ee9:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106eee:	e9 b6 f4 ff ff       	jmp    801063a9 <alltraps>

80106ef3 <vector142>:
.globl vector142
vector142:
  pushl $0
80106ef3:	6a 00                	push   $0x0
  pushl $142
80106ef5:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106efa:	e9 aa f4 ff ff       	jmp    801063a9 <alltraps>

80106eff <vector143>:
.globl vector143
vector143:
  pushl $0
80106eff:	6a 00                	push   $0x0
  pushl $143
80106f01:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106f06:	e9 9e f4 ff ff       	jmp    801063a9 <alltraps>

80106f0b <vector144>:
.globl vector144
vector144:
  pushl $0
80106f0b:	6a 00                	push   $0x0
  pushl $144
80106f0d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106f12:	e9 92 f4 ff ff       	jmp    801063a9 <alltraps>

80106f17 <vector145>:
.globl vector145
vector145:
  pushl $0
80106f17:	6a 00                	push   $0x0
  pushl $145
80106f19:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106f1e:	e9 86 f4 ff ff       	jmp    801063a9 <alltraps>

80106f23 <vector146>:
.globl vector146
vector146:
  pushl $0
80106f23:	6a 00                	push   $0x0
  pushl $146
80106f25:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106f2a:	e9 7a f4 ff ff       	jmp    801063a9 <alltraps>

80106f2f <vector147>:
.globl vector147
vector147:
  pushl $0
80106f2f:	6a 00                	push   $0x0
  pushl $147
80106f31:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106f36:	e9 6e f4 ff ff       	jmp    801063a9 <alltraps>

80106f3b <vector148>:
.globl vector148
vector148:
  pushl $0
80106f3b:	6a 00                	push   $0x0
  pushl $148
80106f3d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106f42:	e9 62 f4 ff ff       	jmp    801063a9 <alltraps>

80106f47 <vector149>:
.globl vector149
vector149:
  pushl $0
80106f47:	6a 00                	push   $0x0
  pushl $149
80106f49:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106f4e:	e9 56 f4 ff ff       	jmp    801063a9 <alltraps>

80106f53 <vector150>:
.globl vector150
vector150:
  pushl $0
80106f53:	6a 00                	push   $0x0
  pushl $150
80106f55:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106f5a:	e9 4a f4 ff ff       	jmp    801063a9 <alltraps>

80106f5f <vector151>:
.globl vector151
vector151:
  pushl $0
80106f5f:	6a 00                	push   $0x0
  pushl $151
80106f61:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106f66:	e9 3e f4 ff ff       	jmp    801063a9 <alltraps>

80106f6b <vector152>:
.globl vector152
vector152:
  pushl $0
80106f6b:	6a 00                	push   $0x0
  pushl $152
80106f6d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106f72:	e9 32 f4 ff ff       	jmp    801063a9 <alltraps>

80106f77 <vector153>:
.globl vector153
vector153:
  pushl $0
80106f77:	6a 00                	push   $0x0
  pushl $153
80106f79:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106f7e:	e9 26 f4 ff ff       	jmp    801063a9 <alltraps>

80106f83 <vector154>:
.globl vector154
vector154:
  pushl $0
80106f83:	6a 00                	push   $0x0
  pushl $154
80106f85:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106f8a:	e9 1a f4 ff ff       	jmp    801063a9 <alltraps>

80106f8f <vector155>:
.globl vector155
vector155:
  pushl $0
80106f8f:	6a 00                	push   $0x0
  pushl $155
80106f91:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106f96:	e9 0e f4 ff ff       	jmp    801063a9 <alltraps>

80106f9b <vector156>:
.globl vector156
vector156:
  pushl $0
80106f9b:	6a 00                	push   $0x0
  pushl $156
80106f9d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106fa2:	e9 02 f4 ff ff       	jmp    801063a9 <alltraps>

80106fa7 <vector157>:
.globl vector157
vector157:
  pushl $0
80106fa7:	6a 00                	push   $0x0
  pushl $157
80106fa9:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106fae:	e9 f6 f3 ff ff       	jmp    801063a9 <alltraps>

80106fb3 <vector158>:
.globl vector158
vector158:
  pushl $0
80106fb3:	6a 00                	push   $0x0
  pushl $158
80106fb5:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106fba:	e9 ea f3 ff ff       	jmp    801063a9 <alltraps>

80106fbf <vector159>:
.globl vector159
vector159:
  pushl $0
80106fbf:	6a 00                	push   $0x0
  pushl $159
80106fc1:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106fc6:	e9 de f3 ff ff       	jmp    801063a9 <alltraps>

80106fcb <vector160>:
.globl vector160
vector160:
  pushl $0
80106fcb:	6a 00                	push   $0x0
  pushl $160
80106fcd:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106fd2:	e9 d2 f3 ff ff       	jmp    801063a9 <alltraps>

80106fd7 <vector161>:
.globl vector161
vector161:
  pushl $0
80106fd7:	6a 00                	push   $0x0
  pushl $161
80106fd9:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106fde:	e9 c6 f3 ff ff       	jmp    801063a9 <alltraps>

80106fe3 <vector162>:
.globl vector162
vector162:
  pushl $0
80106fe3:	6a 00                	push   $0x0
  pushl $162
80106fe5:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106fea:	e9 ba f3 ff ff       	jmp    801063a9 <alltraps>

80106fef <vector163>:
.globl vector163
vector163:
  pushl $0
80106fef:	6a 00                	push   $0x0
  pushl $163
80106ff1:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106ff6:	e9 ae f3 ff ff       	jmp    801063a9 <alltraps>

80106ffb <vector164>:
.globl vector164
vector164:
  pushl $0
80106ffb:	6a 00                	push   $0x0
  pushl $164
80106ffd:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107002:	e9 a2 f3 ff ff       	jmp    801063a9 <alltraps>

80107007 <vector165>:
.globl vector165
vector165:
  pushl $0
80107007:	6a 00                	push   $0x0
  pushl $165
80107009:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010700e:	e9 96 f3 ff ff       	jmp    801063a9 <alltraps>

80107013 <vector166>:
.globl vector166
vector166:
  pushl $0
80107013:	6a 00                	push   $0x0
  pushl $166
80107015:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
8010701a:	e9 8a f3 ff ff       	jmp    801063a9 <alltraps>

8010701f <vector167>:
.globl vector167
vector167:
  pushl $0
8010701f:	6a 00                	push   $0x0
  pushl $167
80107021:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107026:	e9 7e f3 ff ff       	jmp    801063a9 <alltraps>

8010702b <vector168>:
.globl vector168
vector168:
  pushl $0
8010702b:	6a 00                	push   $0x0
  pushl $168
8010702d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107032:	e9 72 f3 ff ff       	jmp    801063a9 <alltraps>

80107037 <vector169>:
.globl vector169
vector169:
  pushl $0
80107037:	6a 00                	push   $0x0
  pushl $169
80107039:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010703e:	e9 66 f3 ff ff       	jmp    801063a9 <alltraps>

80107043 <vector170>:
.globl vector170
vector170:
  pushl $0
80107043:	6a 00                	push   $0x0
  pushl $170
80107045:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
8010704a:	e9 5a f3 ff ff       	jmp    801063a9 <alltraps>

8010704f <vector171>:
.globl vector171
vector171:
  pushl $0
8010704f:	6a 00                	push   $0x0
  pushl $171
80107051:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107056:	e9 4e f3 ff ff       	jmp    801063a9 <alltraps>

8010705b <vector172>:
.globl vector172
vector172:
  pushl $0
8010705b:	6a 00                	push   $0x0
  pushl $172
8010705d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107062:	e9 42 f3 ff ff       	jmp    801063a9 <alltraps>

80107067 <vector173>:
.globl vector173
vector173:
  pushl $0
80107067:	6a 00                	push   $0x0
  pushl $173
80107069:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010706e:	e9 36 f3 ff ff       	jmp    801063a9 <alltraps>

80107073 <vector174>:
.globl vector174
vector174:
  pushl $0
80107073:	6a 00                	push   $0x0
  pushl $174
80107075:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
8010707a:	e9 2a f3 ff ff       	jmp    801063a9 <alltraps>

8010707f <vector175>:
.globl vector175
vector175:
  pushl $0
8010707f:	6a 00                	push   $0x0
  pushl $175
80107081:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107086:	e9 1e f3 ff ff       	jmp    801063a9 <alltraps>

8010708b <vector176>:
.globl vector176
vector176:
  pushl $0
8010708b:	6a 00                	push   $0x0
  pushl $176
8010708d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107092:	e9 12 f3 ff ff       	jmp    801063a9 <alltraps>

80107097 <vector177>:
.globl vector177
vector177:
  pushl $0
80107097:	6a 00                	push   $0x0
  pushl $177
80107099:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010709e:	e9 06 f3 ff ff       	jmp    801063a9 <alltraps>

801070a3 <vector178>:
.globl vector178
vector178:
  pushl $0
801070a3:	6a 00                	push   $0x0
  pushl $178
801070a5:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801070aa:	e9 fa f2 ff ff       	jmp    801063a9 <alltraps>

801070af <vector179>:
.globl vector179
vector179:
  pushl $0
801070af:	6a 00                	push   $0x0
  pushl $179
801070b1:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801070b6:	e9 ee f2 ff ff       	jmp    801063a9 <alltraps>

801070bb <vector180>:
.globl vector180
vector180:
  pushl $0
801070bb:	6a 00                	push   $0x0
  pushl $180
801070bd:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801070c2:	e9 e2 f2 ff ff       	jmp    801063a9 <alltraps>

801070c7 <vector181>:
.globl vector181
vector181:
  pushl $0
801070c7:	6a 00                	push   $0x0
  pushl $181
801070c9:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801070ce:	e9 d6 f2 ff ff       	jmp    801063a9 <alltraps>

801070d3 <vector182>:
.globl vector182
vector182:
  pushl $0
801070d3:	6a 00                	push   $0x0
  pushl $182
801070d5:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801070da:	e9 ca f2 ff ff       	jmp    801063a9 <alltraps>

801070df <vector183>:
.globl vector183
vector183:
  pushl $0
801070df:	6a 00                	push   $0x0
  pushl $183
801070e1:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801070e6:	e9 be f2 ff ff       	jmp    801063a9 <alltraps>

801070eb <vector184>:
.globl vector184
vector184:
  pushl $0
801070eb:	6a 00                	push   $0x0
  pushl $184
801070ed:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801070f2:	e9 b2 f2 ff ff       	jmp    801063a9 <alltraps>

801070f7 <vector185>:
.globl vector185
vector185:
  pushl $0
801070f7:	6a 00                	push   $0x0
  pushl $185
801070f9:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801070fe:	e9 a6 f2 ff ff       	jmp    801063a9 <alltraps>

80107103 <vector186>:
.globl vector186
vector186:
  pushl $0
80107103:	6a 00                	push   $0x0
  pushl $186
80107105:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
8010710a:	e9 9a f2 ff ff       	jmp    801063a9 <alltraps>

8010710f <vector187>:
.globl vector187
vector187:
  pushl $0
8010710f:	6a 00                	push   $0x0
  pushl $187
80107111:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107116:	e9 8e f2 ff ff       	jmp    801063a9 <alltraps>

8010711b <vector188>:
.globl vector188
vector188:
  pushl $0
8010711b:	6a 00                	push   $0x0
  pushl $188
8010711d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107122:	e9 82 f2 ff ff       	jmp    801063a9 <alltraps>

80107127 <vector189>:
.globl vector189
vector189:
  pushl $0
80107127:	6a 00                	push   $0x0
  pushl $189
80107129:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010712e:	e9 76 f2 ff ff       	jmp    801063a9 <alltraps>

80107133 <vector190>:
.globl vector190
vector190:
  pushl $0
80107133:	6a 00                	push   $0x0
  pushl $190
80107135:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
8010713a:	e9 6a f2 ff ff       	jmp    801063a9 <alltraps>

8010713f <vector191>:
.globl vector191
vector191:
  pushl $0
8010713f:	6a 00                	push   $0x0
  pushl $191
80107141:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107146:	e9 5e f2 ff ff       	jmp    801063a9 <alltraps>

8010714b <vector192>:
.globl vector192
vector192:
  pushl $0
8010714b:	6a 00                	push   $0x0
  pushl $192
8010714d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107152:	e9 52 f2 ff ff       	jmp    801063a9 <alltraps>

80107157 <vector193>:
.globl vector193
vector193:
  pushl $0
80107157:	6a 00                	push   $0x0
  pushl $193
80107159:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010715e:	e9 46 f2 ff ff       	jmp    801063a9 <alltraps>

80107163 <vector194>:
.globl vector194
vector194:
  pushl $0
80107163:	6a 00                	push   $0x0
  pushl $194
80107165:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
8010716a:	e9 3a f2 ff ff       	jmp    801063a9 <alltraps>

8010716f <vector195>:
.globl vector195
vector195:
  pushl $0
8010716f:	6a 00                	push   $0x0
  pushl $195
80107171:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107176:	e9 2e f2 ff ff       	jmp    801063a9 <alltraps>

8010717b <vector196>:
.globl vector196
vector196:
  pushl $0
8010717b:	6a 00                	push   $0x0
  pushl $196
8010717d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107182:	e9 22 f2 ff ff       	jmp    801063a9 <alltraps>

80107187 <vector197>:
.globl vector197
vector197:
  pushl $0
80107187:	6a 00                	push   $0x0
  pushl $197
80107189:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010718e:	e9 16 f2 ff ff       	jmp    801063a9 <alltraps>

80107193 <vector198>:
.globl vector198
vector198:
  pushl $0
80107193:	6a 00                	push   $0x0
  pushl $198
80107195:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
8010719a:	e9 0a f2 ff ff       	jmp    801063a9 <alltraps>

8010719f <vector199>:
.globl vector199
vector199:
  pushl $0
8010719f:	6a 00                	push   $0x0
  pushl $199
801071a1:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801071a6:	e9 fe f1 ff ff       	jmp    801063a9 <alltraps>

801071ab <vector200>:
.globl vector200
vector200:
  pushl $0
801071ab:	6a 00                	push   $0x0
  pushl $200
801071ad:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801071b2:	e9 f2 f1 ff ff       	jmp    801063a9 <alltraps>

801071b7 <vector201>:
.globl vector201
vector201:
  pushl $0
801071b7:	6a 00                	push   $0x0
  pushl $201
801071b9:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801071be:	e9 e6 f1 ff ff       	jmp    801063a9 <alltraps>

801071c3 <vector202>:
.globl vector202
vector202:
  pushl $0
801071c3:	6a 00                	push   $0x0
  pushl $202
801071c5:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801071ca:	e9 da f1 ff ff       	jmp    801063a9 <alltraps>

801071cf <vector203>:
.globl vector203
vector203:
  pushl $0
801071cf:	6a 00                	push   $0x0
  pushl $203
801071d1:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801071d6:	e9 ce f1 ff ff       	jmp    801063a9 <alltraps>

801071db <vector204>:
.globl vector204
vector204:
  pushl $0
801071db:	6a 00                	push   $0x0
  pushl $204
801071dd:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801071e2:	e9 c2 f1 ff ff       	jmp    801063a9 <alltraps>

801071e7 <vector205>:
.globl vector205
vector205:
  pushl $0
801071e7:	6a 00                	push   $0x0
  pushl $205
801071e9:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801071ee:	e9 b6 f1 ff ff       	jmp    801063a9 <alltraps>

801071f3 <vector206>:
.globl vector206
vector206:
  pushl $0
801071f3:	6a 00                	push   $0x0
  pushl $206
801071f5:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801071fa:	e9 aa f1 ff ff       	jmp    801063a9 <alltraps>

801071ff <vector207>:
.globl vector207
vector207:
  pushl $0
801071ff:	6a 00                	push   $0x0
  pushl $207
80107201:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107206:	e9 9e f1 ff ff       	jmp    801063a9 <alltraps>

8010720b <vector208>:
.globl vector208
vector208:
  pushl $0
8010720b:	6a 00                	push   $0x0
  pushl $208
8010720d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107212:	e9 92 f1 ff ff       	jmp    801063a9 <alltraps>

80107217 <vector209>:
.globl vector209
vector209:
  pushl $0
80107217:	6a 00                	push   $0x0
  pushl $209
80107219:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010721e:	e9 86 f1 ff ff       	jmp    801063a9 <alltraps>

80107223 <vector210>:
.globl vector210
vector210:
  pushl $0
80107223:	6a 00                	push   $0x0
  pushl $210
80107225:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
8010722a:	e9 7a f1 ff ff       	jmp    801063a9 <alltraps>

8010722f <vector211>:
.globl vector211
vector211:
  pushl $0
8010722f:	6a 00                	push   $0x0
  pushl $211
80107231:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107236:	e9 6e f1 ff ff       	jmp    801063a9 <alltraps>

8010723b <vector212>:
.globl vector212
vector212:
  pushl $0
8010723b:	6a 00                	push   $0x0
  pushl $212
8010723d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107242:	e9 62 f1 ff ff       	jmp    801063a9 <alltraps>

80107247 <vector213>:
.globl vector213
vector213:
  pushl $0
80107247:	6a 00                	push   $0x0
  pushl $213
80107249:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010724e:	e9 56 f1 ff ff       	jmp    801063a9 <alltraps>

80107253 <vector214>:
.globl vector214
vector214:
  pushl $0
80107253:	6a 00                	push   $0x0
  pushl $214
80107255:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
8010725a:	e9 4a f1 ff ff       	jmp    801063a9 <alltraps>

8010725f <vector215>:
.globl vector215
vector215:
  pushl $0
8010725f:	6a 00                	push   $0x0
  pushl $215
80107261:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107266:	e9 3e f1 ff ff       	jmp    801063a9 <alltraps>

8010726b <vector216>:
.globl vector216
vector216:
  pushl $0
8010726b:	6a 00                	push   $0x0
  pushl $216
8010726d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107272:	e9 32 f1 ff ff       	jmp    801063a9 <alltraps>

80107277 <vector217>:
.globl vector217
vector217:
  pushl $0
80107277:	6a 00                	push   $0x0
  pushl $217
80107279:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010727e:	e9 26 f1 ff ff       	jmp    801063a9 <alltraps>

80107283 <vector218>:
.globl vector218
vector218:
  pushl $0
80107283:	6a 00                	push   $0x0
  pushl $218
80107285:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010728a:	e9 1a f1 ff ff       	jmp    801063a9 <alltraps>

8010728f <vector219>:
.globl vector219
vector219:
  pushl $0
8010728f:	6a 00                	push   $0x0
  pushl $219
80107291:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107296:	e9 0e f1 ff ff       	jmp    801063a9 <alltraps>

8010729b <vector220>:
.globl vector220
vector220:
  pushl $0
8010729b:	6a 00                	push   $0x0
  pushl $220
8010729d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801072a2:	e9 02 f1 ff ff       	jmp    801063a9 <alltraps>

801072a7 <vector221>:
.globl vector221
vector221:
  pushl $0
801072a7:	6a 00                	push   $0x0
  pushl $221
801072a9:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801072ae:	e9 f6 f0 ff ff       	jmp    801063a9 <alltraps>

801072b3 <vector222>:
.globl vector222
vector222:
  pushl $0
801072b3:	6a 00                	push   $0x0
  pushl $222
801072b5:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801072ba:	e9 ea f0 ff ff       	jmp    801063a9 <alltraps>

801072bf <vector223>:
.globl vector223
vector223:
  pushl $0
801072bf:	6a 00                	push   $0x0
  pushl $223
801072c1:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801072c6:	e9 de f0 ff ff       	jmp    801063a9 <alltraps>

801072cb <vector224>:
.globl vector224
vector224:
  pushl $0
801072cb:	6a 00                	push   $0x0
  pushl $224
801072cd:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801072d2:	e9 d2 f0 ff ff       	jmp    801063a9 <alltraps>

801072d7 <vector225>:
.globl vector225
vector225:
  pushl $0
801072d7:	6a 00                	push   $0x0
  pushl $225
801072d9:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801072de:	e9 c6 f0 ff ff       	jmp    801063a9 <alltraps>

801072e3 <vector226>:
.globl vector226
vector226:
  pushl $0
801072e3:	6a 00                	push   $0x0
  pushl $226
801072e5:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801072ea:	e9 ba f0 ff ff       	jmp    801063a9 <alltraps>

801072ef <vector227>:
.globl vector227
vector227:
  pushl $0
801072ef:	6a 00                	push   $0x0
  pushl $227
801072f1:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801072f6:	e9 ae f0 ff ff       	jmp    801063a9 <alltraps>

801072fb <vector228>:
.globl vector228
vector228:
  pushl $0
801072fb:	6a 00                	push   $0x0
  pushl $228
801072fd:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107302:	e9 a2 f0 ff ff       	jmp    801063a9 <alltraps>

80107307 <vector229>:
.globl vector229
vector229:
  pushl $0
80107307:	6a 00                	push   $0x0
  pushl $229
80107309:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010730e:	e9 96 f0 ff ff       	jmp    801063a9 <alltraps>

80107313 <vector230>:
.globl vector230
vector230:
  pushl $0
80107313:	6a 00                	push   $0x0
  pushl $230
80107315:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
8010731a:	e9 8a f0 ff ff       	jmp    801063a9 <alltraps>

8010731f <vector231>:
.globl vector231
vector231:
  pushl $0
8010731f:	6a 00                	push   $0x0
  pushl $231
80107321:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107326:	e9 7e f0 ff ff       	jmp    801063a9 <alltraps>

8010732b <vector232>:
.globl vector232
vector232:
  pushl $0
8010732b:	6a 00                	push   $0x0
  pushl $232
8010732d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107332:	e9 72 f0 ff ff       	jmp    801063a9 <alltraps>

80107337 <vector233>:
.globl vector233
vector233:
  pushl $0
80107337:	6a 00                	push   $0x0
  pushl $233
80107339:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010733e:	e9 66 f0 ff ff       	jmp    801063a9 <alltraps>

80107343 <vector234>:
.globl vector234
vector234:
  pushl $0
80107343:	6a 00                	push   $0x0
  pushl $234
80107345:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
8010734a:	e9 5a f0 ff ff       	jmp    801063a9 <alltraps>

8010734f <vector235>:
.globl vector235
vector235:
  pushl $0
8010734f:	6a 00                	push   $0x0
  pushl $235
80107351:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107356:	e9 4e f0 ff ff       	jmp    801063a9 <alltraps>

8010735b <vector236>:
.globl vector236
vector236:
  pushl $0
8010735b:	6a 00                	push   $0x0
  pushl $236
8010735d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107362:	e9 42 f0 ff ff       	jmp    801063a9 <alltraps>

80107367 <vector237>:
.globl vector237
vector237:
  pushl $0
80107367:	6a 00                	push   $0x0
  pushl $237
80107369:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010736e:	e9 36 f0 ff ff       	jmp    801063a9 <alltraps>

80107373 <vector238>:
.globl vector238
vector238:
  pushl $0
80107373:	6a 00                	push   $0x0
  pushl $238
80107375:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
8010737a:	e9 2a f0 ff ff       	jmp    801063a9 <alltraps>

8010737f <vector239>:
.globl vector239
vector239:
  pushl $0
8010737f:	6a 00                	push   $0x0
  pushl $239
80107381:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107386:	e9 1e f0 ff ff       	jmp    801063a9 <alltraps>

8010738b <vector240>:
.globl vector240
vector240:
  pushl $0
8010738b:	6a 00                	push   $0x0
  pushl $240
8010738d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107392:	e9 12 f0 ff ff       	jmp    801063a9 <alltraps>

80107397 <vector241>:
.globl vector241
vector241:
  pushl $0
80107397:	6a 00                	push   $0x0
  pushl $241
80107399:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010739e:	e9 06 f0 ff ff       	jmp    801063a9 <alltraps>

801073a3 <vector242>:
.globl vector242
vector242:
  pushl $0
801073a3:	6a 00                	push   $0x0
  pushl $242
801073a5:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801073aa:	e9 fa ef ff ff       	jmp    801063a9 <alltraps>

801073af <vector243>:
.globl vector243
vector243:
  pushl $0
801073af:	6a 00                	push   $0x0
  pushl $243
801073b1:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801073b6:	e9 ee ef ff ff       	jmp    801063a9 <alltraps>

801073bb <vector244>:
.globl vector244
vector244:
  pushl $0
801073bb:	6a 00                	push   $0x0
  pushl $244
801073bd:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801073c2:	e9 e2 ef ff ff       	jmp    801063a9 <alltraps>

801073c7 <vector245>:
.globl vector245
vector245:
  pushl $0
801073c7:	6a 00                	push   $0x0
  pushl $245
801073c9:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801073ce:	e9 d6 ef ff ff       	jmp    801063a9 <alltraps>

801073d3 <vector246>:
.globl vector246
vector246:
  pushl $0
801073d3:	6a 00                	push   $0x0
  pushl $246
801073d5:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801073da:	e9 ca ef ff ff       	jmp    801063a9 <alltraps>

801073df <vector247>:
.globl vector247
vector247:
  pushl $0
801073df:	6a 00                	push   $0x0
  pushl $247
801073e1:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801073e6:	e9 be ef ff ff       	jmp    801063a9 <alltraps>

801073eb <vector248>:
.globl vector248
vector248:
  pushl $0
801073eb:	6a 00                	push   $0x0
  pushl $248
801073ed:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801073f2:	e9 b2 ef ff ff       	jmp    801063a9 <alltraps>

801073f7 <vector249>:
.globl vector249
vector249:
  pushl $0
801073f7:	6a 00                	push   $0x0
  pushl $249
801073f9:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801073fe:	e9 a6 ef ff ff       	jmp    801063a9 <alltraps>

80107403 <vector250>:
.globl vector250
vector250:
  pushl $0
80107403:	6a 00                	push   $0x0
  pushl $250
80107405:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
8010740a:	e9 9a ef ff ff       	jmp    801063a9 <alltraps>

8010740f <vector251>:
.globl vector251
vector251:
  pushl $0
8010740f:	6a 00                	push   $0x0
  pushl $251
80107411:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107416:	e9 8e ef ff ff       	jmp    801063a9 <alltraps>

8010741b <vector252>:
.globl vector252
vector252:
  pushl $0
8010741b:	6a 00                	push   $0x0
  pushl $252
8010741d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107422:	e9 82 ef ff ff       	jmp    801063a9 <alltraps>

80107427 <vector253>:
.globl vector253
vector253:
  pushl $0
80107427:	6a 00                	push   $0x0
  pushl $253
80107429:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010742e:	e9 76 ef ff ff       	jmp    801063a9 <alltraps>

80107433 <vector254>:
.globl vector254
vector254:
  pushl $0
80107433:	6a 00                	push   $0x0
  pushl $254
80107435:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
8010743a:	e9 6a ef ff ff       	jmp    801063a9 <alltraps>

8010743f <vector255>:
.globl vector255
vector255:
  pushl $0
8010743f:	6a 00                	push   $0x0
  pushl $255
80107441:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107446:	e9 5e ef ff ff       	jmp    801063a9 <alltraps>
8010744b:	66 90                	xchg   %ax,%ax
8010744d:	66 90                	xchg   %ax,%ax
8010744f:	90                   	nop

80107450 <cow_kfree>:
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc);
int swap_in(struct proc* p, struct pageinfo* pi);
void swap_out(struct proc* p, struct pageinfo* page_to_swap, void* buffer, pde_t* pgdir);

void cow_kfree(char* to_free_kva){
80107450:	f3 0f 1e fb          	endbr32 
80107454:	55                   	push   %ebp
80107455:	89 e5                	mov    %esp,%ebp
80107457:	56                   	push   %esi
80107458:	53                   	push   %ebx
80107459:	8b 75 08             	mov    0x8(%ebp),%esi
8010745c:	8d 9e 00 00 00 80    	lea    -0x80000000(%esi),%ebx
  char count;
  int acq = 0;
  if (lapicid() != 0){
80107462:	e8 09 bc ff ff       	call   80103070 <lapicid>
80107467:	c1 eb 0c             	shr    $0xc,%ebx
8010746a:	85 c0                	test   %eax,%eax
8010746c:	75 22                	jne    80107490 <cow_kfree+0x40>
    acquire(cow_lock);
  }
  // struct proc* p = myproc();
  // if (p != 0 ){ // && p->pid > 2
  count = --pg_ref_counts[PGROUNDDOWN(V2P(to_free_kva)) / PGSIZE];
  if (count != 0){
8010746e:	80 ab 40 1f 11 80 01 	subb   $0x1,-0x7feee0c0(%ebx)
80107475:	75 11                	jne    80107488 <cow_kfree+0x38>
  // possible bug
  if (acq){
    // cprintf("rel kfree %d\n", myproc()->pid);
    release(cow_lock);
  }
  kfree(to_free_kva);
80107477:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010747a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010747d:	5b                   	pop    %ebx
8010747e:	5e                   	pop    %esi
8010747f:	5d                   	pop    %ebp
  kfree(to_free_kva);
80107480:	e9 8b b7 ff ff       	jmp    80102c10 <kfree>
80107485:	8d 76 00             	lea    0x0(%esi),%esi
}
80107488:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010748b:	5b                   	pop    %ebx
8010748c:	5e                   	pop    %esi
8010748d:	5d                   	pop    %ebp
8010748e:	c3                   	ret    
8010748f:	90                   	nop
    acquire(cow_lock);
80107490:	83 ec 0c             	sub    $0xc,%esp
80107493:	ff 35 40 ff 11 80    	pushl  0x8011ff40
80107499:	e8 d2 db ff ff       	call   80105070 <acquire>
  count = --pg_ref_counts[PGROUNDDOWN(V2P(to_free_kva)) / PGSIZE];
8010749e:	0f b6 83 40 1f 11 80 	movzbl -0x7feee0c0(%ebx),%eax
  if (count != 0){
801074a5:	83 c4 10             	add    $0x10,%esp
  count = --pg_ref_counts[PGROUNDDOWN(V2P(to_free_kva)) / PGSIZE];
801074a8:	83 e8 01             	sub    $0x1,%eax
801074ab:	88 83 40 1f 11 80    	mov    %al,-0x7feee0c0(%ebx)
  if (count != 0){
801074b1:	84 c0                	test   %al,%al
801074b3:	75 23                	jne    801074d8 <cow_kfree+0x88>
    release(cow_lock);
801074b5:	83 ec 0c             	sub    $0xc,%esp
801074b8:	ff 35 40 ff 11 80    	pushl  0x8011ff40
801074be:	e8 6d dc ff ff       	call   80105130 <release>
  kfree(to_free_kva);
801074c3:	89 75 08             	mov    %esi,0x8(%ebp)
    release(cow_lock);
801074c6:	83 c4 10             	add    $0x10,%esp
}
801074c9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801074cc:	5b                   	pop    %ebx
801074cd:	5e                   	pop    %esi
801074ce:	5d                   	pop    %ebp
  kfree(to_free_kva);
801074cf:	e9 3c b7 ff ff       	jmp    80102c10 <kfree>
801074d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      release(cow_lock);
801074d8:	a1 40 ff 11 80       	mov    0x8011ff40,%eax
801074dd:	89 45 08             	mov    %eax,0x8(%ebp)
}
801074e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801074e3:	5b                   	pop    %ebx
801074e4:	5e                   	pop    %esi
801074e5:	5d                   	pop    %ebp
      release(cow_lock);
801074e6:	e9 45 dc ff ff       	jmp    80105130 <release>
801074eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801074ef:	90                   	nop

801074f0 <cow_kalloc>:

char* cow_kalloc(){
801074f0:	f3 0f 1e fb          	endbr32 
801074f4:	55                   	push   %ebp
801074f5:	89 e5                	mov    %esp,%ebp
801074f7:	57                   	push   %edi
801074f8:	56                   	push   %esi
801074f9:	53                   	push   %ebx
801074fa:	83 ec 0c             	sub    $0xc,%esp
  char* r = kalloc();
801074fd:	e8 fe b8 ff ff       	call   80102e00 <kalloc>
80107502:	89 c3                	mov    %eax,%ebx
  if (r == 0){
80107504:	85 c0                	test   %eax,%eax
80107506:	74 28                	je     80107530 <cow_kalloc+0x40>
    return r;
  }
  int acq = 0;
  // cprintf("kalloc \n");
  if (lapicid() != 0){
80107508:	e8 63 bb ff ff       	call   80103070 <lapicid>
8010750d:	8d bb 00 00 00 80    	lea    -0x80000000(%ebx),%edi
80107513:	89 fe                	mov    %edi,%esi
80107515:	c1 ee 0c             	shr    $0xc,%esi
80107518:	85 c0                	test   %eax,%eax
8010751a:	75 24                	jne    80107540 <cow_kalloc+0x50>
    acq = 1;
    // cprintf("kalloc %d\n", myproc()->pid);
    acquire(cow_lock);
  }
  if (pg_ref_counts[PGROUNDDOWN(V2P(r)) / PGSIZE]++ != 0){ 
8010751c:	0f b6 86 40 1f 11 80 	movzbl -0x7feee0c0(%esi),%eax
80107523:	8d 50 01             	lea    0x1(%eax),%edx
80107526:	88 96 40 1f 11 80    	mov    %dl,-0x7feee0c0(%esi)
8010752c:	84 c0                	test   %al,%al
8010752e:	75 50                	jne    80107580 <cow_kalloc+0x90>
  }
  if (acq){
    release(cow_lock);
  }
  return r;
}
80107530:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107533:	89 d8                	mov    %ebx,%eax
80107535:	5b                   	pop    %ebx
80107536:	5e                   	pop    %esi
80107537:	5f                   	pop    %edi
80107538:	5d                   	pop    %ebp
80107539:	c3                   	ret    
8010753a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(cow_lock);
80107540:	83 ec 0c             	sub    $0xc,%esp
80107543:	ff 35 40 ff 11 80    	pushl  0x8011ff40
80107549:	e8 22 db ff ff       	call   80105070 <acquire>
  if (pg_ref_counts[PGROUNDDOWN(V2P(r)) / PGSIZE]++ != 0){ 
8010754e:	0f b6 86 40 1f 11 80 	movzbl -0x7feee0c0(%esi),%eax
80107555:	83 c4 10             	add    $0x10,%esp
80107558:	8d 50 01             	lea    0x1(%eax),%edx
8010755b:	88 96 40 1f 11 80    	mov    %dl,-0x7feee0c0(%esi)
80107561:	84 c0                	test   %al,%al
80107563:	75 1b                	jne    80107580 <cow_kalloc+0x90>
    release(cow_lock);
80107565:	83 ec 0c             	sub    $0xc,%esp
80107568:	ff 35 40 ff 11 80    	pushl  0x8011ff40
8010756e:	e8 bd db ff ff       	call   80105130 <release>
80107573:	83 c4 10             	add    $0x10,%esp
}
80107576:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107579:	89 d8                	mov    %ebx,%eax
8010757b:	5b                   	pop    %ebx
8010757c:	5e                   	pop    %esi
8010757d:	5f                   	pop    %edi
8010757e:	5d                   	pop    %ebp
8010757f:	c3                   	ret    
    cprintf("actual ref count = %d, pg index = %x, pg pa = %x\n", pg_ref_counts[PGROUNDDOWN(V2P(r)) / PGSIZE] - 1, PGROUNDDOWN(V2P(r)) / PGSIZE, V2P(r));
80107580:	0f be c2             	movsbl %dl,%eax
80107583:	57                   	push   %edi
80107584:	83 e8 01             	sub    $0x1,%eax
80107587:	56                   	push   %esi
80107588:	50                   	push   %eax
80107589:	68 38 91 10 80       	push   $0x80109138
8010758e:	e8 1d 91 ff ff       	call   801006b0 <cprintf>
    panic("kalloc allocated something with a reference");
80107593:	c7 04 24 6c 91 10 80 	movl   $0x8010916c,(%esp)
8010759a:	e8 f1 8d ff ff       	call   80100390 <panic>
8010759f:	90                   	nop

801075a0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801075a0:	55                   	push   %ebp
801075a1:	89 e5                	mov    %esp,%ebp
801075a3:	57                   	push   %edi
801075a4:	56                   	push   %esi
801075a5:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801075a7:	c1 ea 16             	shr    $0x16,%edx
{
801075aa:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
801075ab:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
801075ae:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
801075b1:	8b 1f                	mov    (%edi),%ebx
801075b3:	f6 c3 01             	test   $0x1,%bl
801075b6:	74 28                	je     801075e0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801075b8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801075be:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801075c4:	89 f0                	mov    %esi,%eax
}
801075c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
801075c9:	c1 e8 0a             	shr    $0xa,%eax
801075cc:	25 fc 0f 00 00       	and    $0xffc,%eax
801075d1:	01 d8                	add    %ebx,%eax
}
801075d3:	5b                   	pop    %ebx
801075d4:	5e                   	pop    %esi
801075d5:	5f                   	pop    %edi
801075d6:	5d                   	pop    %ebp
801075d7:	c3                   	ret    
801075d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075df:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)cow_kalloc()) == 0)
801075e0:	85 c9                	test   %ecx,%ecx
801075e2:	74 2c                	je     80107610 <walkpgdir+0x70>
801075e4:	e8 07 ff ff ff       	call   801074f0 <cow_kalloc>
801075e9:	89 c3                	mov    %eax,%ebx
801075eb:	85 c0                	test   %eax,%eax
801075ed:	74 21                	je     80107610 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
801075ef:	83 ec 04             	sub    $0x4,%esp
801075f2:	68 00 10 00 00       	push   $0x1000
801075f7:	6a 00                	push   $0x0
801075f9:	50                   	push   %eax
801075fa:	e8 81 db ff ff       	call   80105180 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801075ff:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107605:	83 c4 10             	add    $0x10,%esp
80107608:	83 c8 07             	or     $0x7,%eax
8010760b:	89 07                	mov    %eax,(%edi)
8010760d:	eb b5                	jmp    801075c4 <walkpgdir+0x24>
8010760f:	90                   	nop
}
80107610:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107613:	31 c0                	xor    %eax,%eax
}
80107615:	5b                   	pop    %ebx
80107616:	5e                   	pop    %esi
80107617:	5f                   	pop    %edi
80107618:	5d                   	pop    %ebp
80107619:	c3                   	ret    
8010761a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107620 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107620:	55                   	push   %ebp
80107621:	89 e5                	mov    %esp,%ebp
80107623:	57                   	push   %edi
80107624:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107626:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
8010762a:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010762b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80107630:	89 d6                	mov    %edx,%esi
{
80107632:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107633:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80107639:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010763c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010763f:	8b 45 08             	mov    0x8(%ebp),%eax
80107642:	29 f0                	sub    %esi,%eax
80107644:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107647:	eb 1f                	jmp    80107668 <mappages+0x48>
80107649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  // cprintf("mappages start: %x end: %x \n", a, last);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80107650:	f6 00 01             	testb  $0x1,(%eax)
80107653:	75 45                	jne    8010769a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80107655:	0b 5d 0c             	or     0xc(%ebp),%ebx
80107658:	83 cb 01             	or     $0x1,%ebx
8010765b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
8010765d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80107660:	74 2e                	je     80107690 <mappages+0x70>
      break;
    a += PGSIZE;
80107662:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
80107668:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010766b:	b9 01 00 00 00       	mov    $0x1,%ecx
80107670:	89 f2                	mov    %esi,%edx
80107672:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80107675:	89 f8                	mov    %edi,%eax
80107677:	e8 24 ff ff ff       	call   801075a0 <walkpgdir>
8010767c:	85 c0                	test   %eax,%eax
8010767e:	75 d0                	jne    80107650 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80107680:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107683:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107688:	5b                   	pop    %ebx
80107689:	5e                   	pop    %esi
8010768a:	5f                   	pop    %edi
8010768b:	5d                   	pop    %ebp
8010768c:	c3                   	ret    
8010768d:	8d 76 00             	lea    0x0(%esi),%esi
80107690:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107693:	31 c0                	xor    %eax,%eax
}
80107695:	5b                   	pop    %ebx
80107696:	5e                   	pop    %esi
80107697:	5f                   	pop    %edi
80107698:	5d                   	pop    %ebp
80107699:	c3                   	ret    
      panic("remap");
8010769a:	83 ec 0c             	sub    $0xc,%esp
8010769d:	68 e2 91 10 80       	push   $0x801091e2
801076a2:	e8 e9 8c ff ff       	call   80100390 <panic>
801076a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076ae:	66 90                	xchg   %ax,%ax

801076b0 <find_page_to_swap>:
struct pageinfo* find_page_to_swap(struct proc* p, pde_t* pgdir){
801076b0:	f3 0f 1e fb          	endbr32 
801076b4:	55                   	push   %ebp
801076b5:	89 e5                	mov    %esp,%ebp
801076b7:	57                   	push   %edi
801076b8:	56                   	push   %esi
801076b9:	53                   	push   %ebx
801076ba:	83 ec 1c             	sub    $0x1c,%esp
801076bd:	8b 45 08             	mov    0x8(%ebp),%eax
801076c0:	8b 75 0c             	mov    0xc(%ebp),%esi
801076c3:	8d b8 00 02 00 00    	lea    0x200(%eax),%edi
801076c9:	8d 98 80 03 00 00    	lea    0x380(%eax),%ebx
801076cf:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801076d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    for (int i = 0; i < MAX_PYSC_PAGES; i++){
801076d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    struct pageinfo* min_pi = 0;
801076db:	31 ff                	xor    %edi,%edi
    uint min = 0x0FFFFFFF;
801076dd:	b9 ff ff ff 0f       	mov    $0xfffffff,%ecx
801076e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if (!pi->is_free && pi->page_index < min){
801076e8:	8b 10                	mov    (%eax),%edx
801076ea:	85 d2                	test   %edx,%edx
801076ec:	75 0b                	jne    801076f9 <find_page_to_swap+0x49>
801076ee:	8b 50 0c             	mov    0xc(%eax),%edx
801076f1:	39 ca                	cmp    %ecx,%edx
801076f3:	73 04                	jae    801076f9 <find_page_to_swap+0x49>
801076f5:	89 c7                	mov    %eax,%edi
801076f7:	89 d1                	mov    %edx,%ecx
    for (int i = 0; i < MAX_PYSC_PAGES; i++){
801076f9:	83 c0 18             	add    $0x18,%eax
801076fc:	39 d8                	cmp    %ebx,%eax
801076fe:	75 e8                	jne    801076e8 <find_page_to_swap+0x38>
    pte_t* pte = walkpgdir(pgdir, min_pi, 0);
80107700:	31 c9                	xor    %ecx,%ecx
80107702:	89 fa                	mov    %edi,%edx
80107704:	89 f0                	mov    %esi,%eax
80107706:	e8 95 fe ff ff       	call   801075a0 <walkpgdir>
    if (*pte & PTE_A){
8010770b:	f6 00 20             	testb  $0x20,(%eax)
8010770e:	74 17                	je     80107727 <find_page_to_swap+0x77>
      min_pi->page_index = (++page_counter);
80107710:	8b 0d c0 c5 10 80    	mov    0x8010c5c0,%ecx
80107716:	8d 51 01             	lea    0x1(%ecx),%edx
80107719:	89 15 c0 c5 10 80    	mov    %edx,0x8010c5c0
8010771f:	89 57 0c             	mov    %edx,0xc(%edi)
      *pte &= ~PTE_A;
80107722:	83 20 df             	andl   $0xffffffdf,(%eax)
  while(1){
80107725:	eb b1                	jmp    801076d8 <find_page_to_swap+0x28>
}
80107727:	83 c4 1c             	add    $0x1c,%esp
8010772a:	89 f8                	mov    %edi,%eax
8010772c:	5b                   	pop    %ebx
8010772d:	5e                   	pop    %esi
8010772e:	5f                   	pop    %edi
8010772f:	5d                   	pop    %ebp
80107730:	c3                   	ret    
80107731:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107738:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010773f:	90                   	nop

80107740 <find_page_to_swap1>:
struct pageinfo* find_page_to_swap1(struct proc* p, pde_t* pgdir){
80107740:	f3 0f 1e fb          	endbr32 
80107744:	55                   	push   %ebp
  j = j % 16;
80107745:	99                   	cltd   
80107746:	c1 ea 1c             	shr    $0x1c,%edx
struct pageinfo* find_page_to_swap1(struct proc* p, pde_t* pgdir){
80107749:	89 e5                	mov    %esp,%ebp
8010774b:	57                   	push   %edi
8010774c:	56                   	push   %esi
8010774d:	53                   	push   %ebx
  j = j % 16;
8010774e:	8d 1c 10             	lea    (%eax,%edx,1),%ebx
80107751:	83 e3 0f             	and    $0xf,%ebx
80107754:	29 d3                	sub    %edx,%ebx
struct pageinfo* find_page_to_swap1(struct proc* p, pde_t* pgdir){
80107756:	83 ec 14             	sub    $0x14,%esp
  for (int i = j; i != (j - 1) % 16; i = (i + 1) % 16){
80107759:	8d 73 ff             	lea    -0x1(%ebx),%esi
  cprintf("%d\n", j);
8010775c:	53                   	push   %ebx
8010775d:	68 95 8f 10 80       	push   $0x80108f95
80107762:	e8 49 8f ff ff       	call   801006b0 <cprintf>
  for (int i = j; i != (j - 1) % 16; i = (i + 1) % 16){
80107767:	89 f0                	mov    %esi,%eax
80107769:	83 c4 10             	add    $0x10,%esp
8010776c:	c1 f8 1f             	sar    $0x1f,%eax
8010776f:	c1 e8 1c             	shr    $0x1c,%eax
80107772:	01 c6                	add    %eax,%esi
80107774:	83 e6 0f             	and    $0xf,%esi
80107777:	29 c6                	sub    %eax,%esi
80107779:	39 f3                	cmp    %esi,%ebx
8010777b:	74 5b                	je     801077d8 <find_page_to_swap1+0x98>
8010777d:	89 df                	mov    %ebx,%edi
8010777f:	eb 1b                	jmp    8010779c <find_page_to_swap1+0x5c>
80107781:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107788:	8d 47 01             	lea    0x1(%edi),%eax
8010778b:	99                   	cltd   
8010778c:	c1 ea 1c             	shr    $0x1c,%edx
8010778f:	01 d0                	add    %edx,%eax
80107791:	83 e0 0f             	and    $0xf,%eax
80107794:	29 d0                	sub    %edx,%eax
80107796:	89 c7                	mov    %eax,%edi
80107798:	39 f0                	cmp    %esi,%eax
8010779a:	74 3c                	je     801077d8 <find_page_to_swap1+0x98>
    cprintf("%d\n", j);
8010779c:	83 ec 08             	sub    $0x8,%esp
8010779f:	53                   	push   %ebx
801077a0:	68 95 8f 10 80       	push   $0x80108f95
801077a5:	e8 06 8f ff ff       	call   801006b0 <cprintf>
    if (!p->ram_pages[i].is_free){
801077aa:	8b 45 08             	mov    0x8(%ebp),%eax
801077ad:	8d 14 7f             	lea    (%edi,%edi,2),%edx
801077b0:	83 c4 10             	add    $0x10,%esp
801077b3:	8d 0c d5 00 00 00 00 	lea    0x0(,%edx,8),%ecx
801077ba:	8b 94 d0 00 02 00 00 	mov    0x200(%eax,%edx,8),%edx
801077c1:	85 d2                	test   %edx,%edx
801077c3:	75 c3                	jne    80107788 <find_page_to_swap1+0x48>
}
801077c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return &p->ram_pages[i];
801077c8:	8d 84 08 00 02 00 00 	lea    0x200(%eax,%ecx,1),%eax
}
801077cf:	5b                   	pop    %ebx
801077d0:	5e                   	pop    %esi
801077d1:	5f                   	pop    %edi
801077d2:	5d                   	pop    %ebp
801077d3:	c3                   	ret    
801077d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801077d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801077db:	31 c0                	xor    %eax,%eax
}
801077dd:	5b                   	pop    %ebx
801077de:	5e                   	pop    %esi
801077df:	5f                   	pop    %edi
801077e0:	5d                   	pop    %ebp
801077e1:	c3                   	ret    
801077e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801077f0 <seginit>:
{
801077f0:	f3 0f 1e fb          	endbr32 
801077f4:	55                   	push   %ebp
801077f5:	89 e5                	mov    %esp,%ebp
801077f7:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801077fa:	e8 a1 c9 ff ff       	call   801041a0 <cpuid>
  pd[0] = size-1;
801077ff:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107804:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
8010780a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010780e:	c7 80 78 28 12 80 ff 	movl   $0xffff,-0x7fedd788(%eax)
80107815:	ff 00 00 
80107818:	c7 80 7c 28 12 80 00 	movl   $0xcf9a00,-0x7fedd784(%eax)
8010781f:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107822:	c7 80 80 28 12 80 ff 	movl   $0xffff,-0x7fedd780(%eax)
80107829:	ff 00 00 
8010782c:	c7 80 84 28 12 80 00 	movl   $0xcf9200,-0x7fedd77c(%eax)
80107833:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107836:	c7 80 88 28 12 80 ff 	movl   $0xffff,-0x7fedd778(%eax)
8010783d:	ff 00 00 
80107840:	c7 80 8c 28 12 80 00 	movl   $0xcffa00,-0x7fedd774(%eax)
80107847:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010784a:	c7 80 90 28 12 80 ff 	movl   $0xffff,-0x7fedd770(%eax)
80107851:	ff 00 00 
80107854:	c7 80 94 28 12 80 00 	movl   $0xcff200,-0x7fedd76c(%eax)
8010785b:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010785e:	05 70 28 12 80       	add    $0x80122870,%eax
  pd[1] = (uint)p;
80107863:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107867:	c1 e8 10             	shr    $0x10,%eax
8010786a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010786e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107871:	0f 01 10             	lgdtl  (%eax)
}
80107874:	c9                   	leave  
80107875:	c3                   	ret    
80107876:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010787d:	8d 76 00             	lea    0x0(%esi),%esi

80107880 <public_walkpgdir>:
public_walkpgdir(pde_t *pgdir, const void *va, int alloc){
80107880:	f3 0f 1e fb          	endbr32 
80107884:	55                   	push   %ebp
80107885:	89 e5                	mov    %esp,%ebp
  return walkpgdir(pgdir, va, alloc);
80107887:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010788a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010788d:	8b 45 08             	mov    0x8(%ebp),%eax
}
80107890:	5d                   	pop    %ebp
  return walkpgdir(pgdir, va, alloc);
80107891:	e9 0a fd ff ff       	jmp    801075a0 <walkpgdir>
80107896:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010789d:	8d 76 00             	lea    0x0(%esi),%esi

801078a0 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801078a0:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801078a4:	a1 24 1a 13 80       	mov    0x80131a24,%eax
801078a9:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801078ae:	0f 22 d8             	mov    %eax,%cr3
}
801078b1:	c3                   	ret    
801078b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801078c0 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801078c0:	f3 0f 1e fb          	endbr32 
801078c4:	55                   	push   %ebp
801078c5:	89 e5                	mov    %esp,%ebp
801078c7:	57                   	push   %edi
801078c8:	56                   	push   %esi
801078c9:	53                   	push   %ebx
801078ca:	83 ec 1c             	sub    $0x1c,%esp
801078cd:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801078d0:	85 f6                	test   %esi,%esi
801078d2:	0f 84 cb 00 00 00    	je     801079a3 <switchuvm+0xe3>
    panic("switchuvm: no process");
  if(p->kstack == 0)
801078d8:	8b 46 08             	mov    0x8(%esi),%eax
801078db:	85 c0                	test   %eax,%eax
801078dd:	0f 84 da 00 00 00    	je     801079bd <switchuvm+0xfd>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
801078e3:	8b 46 04             	mov    0x4(%esi),%eax
801078e6:	85 c0                	test   %eax,%eax
801078e8:	0f 84 c2 00 00 00    	je     801079b0 <switchuvm+0xf0>
    panic("switchuvm: no pgdir");

  pushcli();
801078ee:	e8 7d d6 ff ff       	call   80104f70 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801078f3:	e8 28 c8 ff ff       	call   80104120 <mycpu>
801078f8:	89 c3                	mov    %eax,%ebx
801078fa:	e8 21 c8 ff ff       	call   80104120 <mycpu>
801078ff:	89 c7                	mov    %eax,%edi
80107901:	e8 1a c8 ff ff       	call   80104120 <mycpu>
80107906:	83 c7 08             	add    $0x8,%edi
80107909:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010790c:	e8 0f c8 ff ff       	call   80104120 <mycpu>
80107911:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107914:	ba 67 00 00 00       	mov    $0x67,%edx
80107919:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107920:	83 c0 08             	add    $0x8,%eax
80107923:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010792a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010792f:	83 c1 08             	add    $0x8,%ecx
80107932:	c1 e8 18             	shr    $0x18,%eax
80107935:	c1 e9 10             	shr    $0x10,%ecx
80107938:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010793e:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107944:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107949:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107950:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107955:	e8 c6 c7 ff ff       	call   80104120 <mycpu>
8010795a:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107961:	e8 ba c7 ff ff       	call   80104120 <mycpu>
80107966:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
8010796a:	8b 5e 08             	mov    0x8(%esi),%ebx
8010796d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107973:	e8 a8 c7 ff ff       	call   80104120 <mycpu>
80107978:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010797b:	e8 a0 c7 ff ff       	call   80104120 <mycpu>
80107980:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107984:	b8 28 00 00 00       	mov    $0x28,%eax
80107989:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010798c:	8b 46 04             	mov    0x4(%esi),%eax
8010798f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107994:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
80107997:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010799a:	5b                   	pop    %ebx
8010799b:	5e                   	pop    %esi
8010799c:	5f                   	pop    %edi
8010799d:	5d                   	pop    %ebp
  popcli();
8010799e:	e9 1d d6 ff ff       	jmp    80104fc0 <popcli>
    panic("switchuvm: no process");
801079a3:	83 ec 0c             	sub    $0xc,%esp
801079a6:	68 e8 91 10 80       	push   $0x801091e8
801079ab:	e8 e0 89 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
801079b0:	83 ec 0c             	sub    $0xc,%esp
801079b3:	68 13 92 10 80       	push   $0x80109213
801079b8:	e8 d3 89 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
801079bd:	83 ec 0c             	sub    $0xc,%esp
801079c0:	68 fe 91 10 80       	push   $0x801091fe
801079c5:	e8 c6 89 ff ff       	call   80100390 <panic>
801079ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801079d0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801079d0:	f3 0f 1e fb          	endbr32 
801079d4:	55                   	push   %ebp
801079d5:	89 e5                	mov    %esp,%ebp
801079d7:	57                   	push   %edi
801079d8:	56                   	push   %esi
801079d9:	53                   	push   %ebx
801079da:	83 ec 1c             	sub    $0x1c,%esp
801079dd:	8b 45 0c             	mov    0xc(%ebp),%eax
801079e0:	8b 75 10             	mov    0x10(%ebp),%esi
801079e3:	8b 7d 08             	mov    0x8(%ebp),%edi
801079e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
801079e9:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801079ef:	77 4b                	ja     80107a3c <inituvm+0x6c>
    panic("inituvm: more than a page");
  mem = cow_kalloc();
801079f1:	e8 fa fa ff ff       	call   801074f0 <cow_kalloc>
  memset(mem, 0, PGSIZE);
801079f6:	83 ec 04             	sub    $0x4,%esp
801079f9:	68 00 10 00 00       	push   $0x1000
  mem = cow_kalloc();
801079fe:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107a00:	6a 00                	push   $0x0
80107a02:	50                   	push   %eax
80107a03:	e8 78 d7 ff ff       	call   80105180 <memset>
  // cprintf("init1");
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107a08:	58                   	pop    %eax
80107a09:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107a0f:	5a                   	pop    %edx
80107a10:	6a 06                	push   $0x6
80107a12:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107a17:	31 d2                	xor    %edx,%edx
80107a19:	50                   	push   %eax
80107a1a:	89 f8                	mov    %edi,%eax
80107a1c:	e8 ff fb ff ff       	call   80107620 <mappages>
  // cprintf("init2");
  memmove(mem, init, sz);
80107a21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107a24:	89 75 10             	mov    %esi,0x10(%ebp)
80107a27:	83 c4 10             	add    $0x10,%esp
80107a2a:	89 5d 08             	mov    %ebx,0x8(%ebp)
80107a2d:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80107a30:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a33:	5b                   	pop    %ebx
80107a34:	5e                   	pop    %esi
80107a35:	5f                   	pop    %edi
80107a36:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107a37:	e9 e4 d7 ff ff       	jmp    80105220 <memmove>
    panic("inituvm: more than a page");
80107a3c:	83 ec 0c             	sub    $0xc,%esp
80107a3f:	68 27 92 10 80       	push   $0x80109227
80107a44:	e8 47 89 ff ff       	call   80100390 <panic>
80107a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107a50 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107a50:	f3 0f 1e fb          	endbr32 
80107a54:	55                   	push   %ebp
80107a55:	89 e5                	mov    %esp,%ebp
80107a57:	57                   	push   %edi
80107a58:	56                   	push   %esi
80107a59:	53                   	push   %ebx
80107a5a:	83 ec 1c             	sub    $0x1c,%esp
80107a5d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107a60:	8b 75 18             	mov    0x18(%ebp),%esi
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107a63:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107a68:	0f 85 99 00 00 00    	jne    80107b07 <loaduvm+0xb7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80107a6e:	01 f0                	add    %esi,%eax
80107a70:	89 f3                	mov    %esi,%ebx
80107a72:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107a75:	8b 45 14             	mov    0x14(%ebp),%eax
80107a78:	01 f0                	add    %esi,%eax
80107a7a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80107a7d:	85 f6                	test   %esi,%esi
80107a7f:	75 15                	jne    80107a96 <loaduvm+0x46>
80107a81:	eb 6d                	jmp    80107af0 <loaduvm+0xa0>
80107a83:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107a87:	90                   	nop
80107a88:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107a8e:	89 f0                	mov    %esi,%eax
80107a90:	29 d8                	sub    %ebx,%eax
80107a92:	39 c6                	cmp    %eax,%esi
80107a94:	76 5a                	jbe    80107af0 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107a96:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107a99:	8b 45 08             	mov    0x8(%ebp),%eax
80107a9c:	31 c9                	xor    %ecx,%ecx
80107a9e:	29 da                	sub    %ebx,%edx
80107aa0:	e8 fb fa ff ff       	call   801075a0 <walkpgdir>
80107aa5:	85 c0                	test   %eax,%eax
80107aa7:	74 51                	je     80107afa <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80107aa9:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107aab:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80107aae:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107ab3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107ab8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80107abe:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107ac1:	29 d9                	sub    %ebx,%ecx
80107ac3:	05 00 00 00 80       	add    $0x80000000,%eax
80107ac8:	57                   	push   %edi
80107ac9:	51                   	push   %ecx
80107aca:	50                   	push   %eax
80107acb:	ff 75 10             	pushl  0x10(%ebp)
80107ace:	e8 4d a3 ff ff       	call   80101e20 <readi>
80107ad3:	83 c4 10             	add    $0x10,%esp
80107ad6:	39 f8                	cmp    %edi,%eax
80107ad8:	74 ae                	je     80107a88 <loaduvm+0x38>
      return -1;
  }
  return 0;
}
80107ada:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107add:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107ae2:	5b                   	pop    %ebx
80107ae3:	5e                   	pop    %esi
80107ae4:	5f                   	pop    %edi
80107ae5:	5d                   	pop    %ebp
80107ae6:	c3                   	ret    
80107ae7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107aee:	66 90                	xchg   %ax,%ax
80107af0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107af3:	31 c0                	xor    %eax,%eax
}
80107af5:	5b                   	pop    %ebx
80107af6:	5e                   	pop    %esi
80107af7:	5f                   	pop    %edi
80107af8:	5d                   	pop    %ebp
80107af9:	c3                   	ret    
      panic("loaduvm: address should exist");
80107afa:	83 ec 0c             	sub    $0xc,%esp
80107afd:	68 41 92 10 80       	push   $0x80109241
80107b02:	e8 89 88 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107b07:	83 ec 0c             	sub    $0xc,%esp
80107b0a:	68 98 91 10 80       	push   $0x80109198
80107b0f:	e8 7c 88 ff ff       	call   80100390 <panic>
80107b14:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107b1f:	90                   	nop

80107b20 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107b20:	f3 0f 1e fb          	endbr32 
80107b24:	55                   	push   %ebp
80107b25:	89 e5                	mov    %esp,%ebp
80107b27:	57                   	push   %edi
80107b28:	56                   	push   %esi
80107b29:	53                   	push   %ebx
80107b2a:	83 ec 1c             	sub    $0x1c,%esp
80107b2d:	8b 7d 08             	mov    0x8(%ebp),%edi
  pte_t *pte;
  uint a, pa;
  struct proc* p = myproc();
80107b30:	e8 8b c6 ff ff       	call   801041c0 <myproc>
80107b35:	89 45 e4             	mov    %eax,-0x1c(%ebp)

  if(newsz >= oldsz)
80107b38:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b3b:	39 45 10             	cmp    %eax,0x10(%ebp)
80107b3e:	0f 83 84 00 00 00    	jae    80107bc8 <deallocuvm+0xa8>
    return oldsz;

  a = PGROUNDUP(newsz);
80107b44:	8b 45 10             	mov    0x10(%ebp),%eax
80107b47:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80107b4d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107b53:	89 d6                	mov    %edx,%esi
  for(; a  < oldsz; a += PGSIZE){
80107b55:	39 55 0c             	cmp    %edx,0xc(%ebp)
80107b58:	77 47                	ja     80107ba1 <deallocuvm+0x81>
80107b5a:	eb 69                	jmp    80107bc5 <deallocuvm+0xa5>
80107b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80107b60:	8b 00                	mov    (%eax),%eax
80107b62:	a8 01                	test   $0x1,%al
80107b64:	74 30                	je     80107b96 <deallocuvm+0x76>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80107b66:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107b6b:	0f 84 b1 00 00 00    	je     80107c22 <deallocuvm+0x102>
        panic("cow_kfree");
      char *v = P2V(pa);
      cow_kfree(v);
80107b71:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80107b74:	05 00 00 00 80       	add    $0x80000000,%eax
      cow_kfree(v);
80107b79:	50                   	push   %eax
80107b7a:	e8 d1 f8 ff ff       	call   80107450 <cow_kfree>
      if (p->pid > 2 && pgdir == p->pgdir){
80107b7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107b82:	83 c4 10             	add    $0x10,%esp
80107b85:	83 78 10 64          	cmpl   $0x64,0x10(%eax)
80107b89:	7e 05                	jle    80107b90 <deallocuvm+0x70>
80107b8b:	39 78 04             	cmp    %edi,0x4(%eax)
80107b8e:	74 40                	je     80107bd0 <deallocuvm+0xb0>
            p->ram_pages[i].va = 0;
            break;
          }
        }
      }
      *pte = 0;
80107b90:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80107b96:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(; a  < oldsz; a += PGSIZE){
80107b9c:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107b9f:	73 24                	jae    80107bc5 <deallocuvm+0xa5>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107ba1:	31 c9                	xor    %ecx,%ecx
80107ba3:	89 f2                	mov    %esi,%edx
80107ba5:	89 f8                	mov    %edi,%eax
80107ba7:	e8 f4 f9 ff ff       	call   801075a0 <walkpgdir>
80107bac:	89 c3                	mov    %eax,%ebx
    if(!pte)
80107bae:	85 c0                	test   %eax,%eax
80107bb0:	75 ae                	jne    80107b60 <deallocuvm+0x40>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107bb2:	89 f2                	mov    %esi,%edx
80107bb4:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80107bba:	8d b2 00 00 40 00    	lea    0x400000(%edx),%esi
  for(; a  < oldsz; a += PGSIZE){
80107bc0:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107bc3:	72 dc                	jb     80107ba1 <deallocuvm+0x81>
    }
  }

  return newsz;
80107bc5:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107bc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107bcb:	5b                   	pop    %ebx
80107bcc:	5e                   	pop    %esi
80107bcd:	5f                   	pop    %edi
80107bce:	5d                   	pop    %ebp
80107bcf:	c3                   	ret    
80107bd0:	8d 88 10 02 00 00    	lea    0x210(%eax),%ecx
        for (int i = 0; i < MAX_PYSC_PAGES; i++){
80107bd6:	31 c0                	xor    %eax,%eax
80107bd8:	eb 11                	jmp    80107beb <deallocuvm+0xcb>
80107bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107be0:	83 c0 01             	add    $0x1,%eax
80107be3:	83 c1 18             	add    $0x18,%ecx
80107be6:	83 f8 10             	cmp    $0x10,%eax
80107be9:	74 a5                	je     80107b90 <deallocuvm+0x70>
          if (p->ram_pages[i].va == (void*)a){
80107beb:	3b 31                	cmp    (%ecx),%esi
80107bed:	75 f1                	jne    80107be0 <deallocuvm+0xc0>
            p->num_of_actual_pages_in_mem--;
80107bef:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
            p->ram_pages[i].is_free = 1;
80107bf2:	8d 04 40             	lea    (%eax,%eax,2),%eax
80107bf5:	8d 04 c1             	lea    (%ecx,%eax,8),%eax
            p->num_of_actual_pages_in_mem--;
80107bf8:	83 a9 84 03 00 00 01 	subl   $0x1,0x384(%ecx)
            p->ram_pages[i].is_free = 1;
80107bff:	c7 80 00 02 00 00 01 	movl   $0x1,0x200(%eax)
80107c06:	00 00 00 
            p->ram_pages[i].aging_counter = 0;
80107c09:	c7 80 08 02 00 00 00 	movl   $0x0,0x208(%eax)
80107c10:	00 00 00 
            p->ram_pages[i].va = 0;
80107c13:	c7 80 10 02 00 00 00 	movl   $0x0,0x210(%eax)
80107c1a:	00 00 00 
            break;
80107c1d:	e9 6e ff ff ff       	jmp    80107b90 <deallocuvm+0x70>
        panic("cow_kfree");
80107c22:	83 ec 0c             	sub    $0xc,%esp
80107c25:	68 5f 92 10 80       	push   $0x8010925f
80107c2a:	e8 61 87 ff ff       	call   80100390 <panic>
80107c2f:	90                   	nop

80107c30 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107c30:	f3 0f 1e fb          	endbr32 
80107c34:	55                   	push   %ebp
80107c35:	89 e5                	mov    %esp,%ebp
80107c37:	57                   	push   %edi
80107c38:	56                   	push   %esi
80107c39:	53                   	push   %ebx
80107c3a:	83 ec 0c             	sub    $0xc,%esp
80107c3d:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;
  struct proc* p = myproc();
80107c40:	e8 7b c5 ff ff       	call   801041c0 <myproc>
  if(pgdir == 0)
80107c45:	85 f6                	test   %esi,%esi
80107c47:	0f 84 e2 00 00 00    	je     80107d2f <freevm+0xff>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
80107c4d:	83 ec 04             	sub    $0x4,%esp
80107c50:	89 c3                	mov    %eax,%ebx
80107c52:	6a 00                	push   $0x0
80107c54:	68 00 00 00 80       	push   $0x80000000
80107c59:	56                   	push   %esi
80107c5a:	e8 c1 fe ff ff       	call   80107b20 <deallocuvm>
  if (p->pid > 2 && p->pgdir == pgdir){
80107c5f:	83 c4 10             	add    $0x10,%esp
80107c62:	83 7b 10 64          	cmpl   $0x64,0x10(%ebx)
80107c66:	7f 49                	jg     80107cb1 <freevm+0x81>
80107c68:	89 f3                	mov    %esi,%ebx
80107c6a:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107c70:	eb 0d                	jmp    80107c7f <freevm+0x4f>
80107c72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      p->ram_pages[i].aging_counter = p->swapped_out_pages[i].aging_counter = 0;
      p->ram_pages[i].swap_file_offset = p->swapped_out_pages[i].swap_file_offset = 0;
      p->ram_pages[i].va = p->swapped_out_pages[i].va = 0;
    }
  }
  for(i = 0; i < NPDENTRIES; i++){
80107c78:	83 c3 04             	add    $0x4,%ebx
80107c7b:	39 fb                	cmp    %edi,%ebx
80107c7d:	74 23                	je     80107ca2 <freevm+0x72>
    if(pgdir[i] & PTE_P){
80107c7f:	8b 03                	mov    (%ebx),%eax
80107c81:	a8 01                	test   $0x1,%al
80107c83:	74 f3                	je     80107c78 <freevm+0x48>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107c85:	25 00 f0 ff ff       	and    $0xfffff000,%eax
       cow_kfree(v);
80107c8a:	83 ec 0c             	sub    $0xc,%esp
80107c8d:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107c90:	05 00 00 00 80       	add    $0x80000000,%eax
       cow_kfree(v);
80107c95:	50                   	push   %eax
80107c96:	e8 b5 f7 ff ff       	call   80107450 <cow_kfree>
80107c9b:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107c9e:	39 fb                	cmp    %edi,%ebx
80107ca0:	75 dd                	jne    80107c7f <freevm+0x4f>
    }
  }
   cow_kfree((char*)pgdir);
80107ca2:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107ca5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ca8:	5b                   	pop    %ebx
80107ca9:	5e                   	pop    %esi
80107caa:	5f                   	pop    %edi
80107cab:	5d                   	pop    %ebp
   cow_kfree((char*)pgdir);
80107cac:	e9 9f f7 ff ff       	jmp    80107450 <cow_kfree>
  if (p->pid > 2 && p->pgdir == pgdir){
80107cb1:	39 73 04             	cmp    %esi,0x4(%ebx)
80107cb4:	75 b2                	jne    80107c68 <freevm+0x38>
    p->num_of_actual_pages_in_mem = 0;
80107cb6:	c7 83 84 03 00 00 00 	movl   $0x0,0x384(%ebx)
80107cbd:	00 00 00 
    p->num_of_pages_in_swap_file = 0;
80107cc0:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
80107cc6:	81 c3 00 02 00 00    	add    $0x200,%ebx
80107ccc:	c7 83 80 01 00 00 00 	movl   $0x0,0x180(%ebx)
80107cd3:	00 00 00 
    for (int i = 0; i < MAX_PYSC_PAGES; i++){
80107cd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107cdd:	8d 76 00             	lea    0x0(%esi),%esi
      p->ram_pages[i].is_free = p->swapped_out_pages[i].is_free = 1;
80107ce0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
80107ce6:	83 c0 18             	add    $0x18,%eax
80107ce9:	c7 80 68 01 00 00 01 	movl   $0x1,0x168(%eax)
80107cf0:	00 00 00 
      p->ram_pages[i].aging_counter = p->swapped_out_pages[i].aging_counter = 0;
80107cf3:	c7 40 f0 00 00 00 00 	movl   $0x0,-0x10(%eax)
80107cfa:	c7 80 70 01 00 00 00 	movl   $0x0,0x170(%eax)
80107d01:	00 00 00 
      p->ram_pages[i].swap_file_offset = p->swapped_out_pages[i].swap_file_offset = 0;
80107d04:	c7 40 ec 00 00 00 00 	movl   $0x0,-0x14(%eax)
80107d0b:	c7 80 6c 01 00 00 00 	movl   $0x0,0x16c(%eax)
80107d12:	00 00 00 
      p->ram_pages[i].va = p->swapped_out_pages[i].va = 0;
80107d15:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
80107d1c:	c7 80 78 01 00 00 00 	movl   $0x0,0x178(%eax)
80107d23:	00 00 00 
    for (int i = 0; i < MAX_PYSC_PAGES; i++){
80107d26:	39 d8                	cmp    %ebx,%eax
80107d28:	75 b6                	jne    80107ce0 <freevm+0xb0>
80107d2a:	e9 39 ff ff ff       	jmp    80107c68 <freevm+0x38>
    panic("freevm: no pgdir");
80107d2f:	83 ec 0c             	sub    $0xc,%esp
80107d32:	68 69 92 10 80       	push   $0x80109269
80107d37:	e8 54 86 ff ff       	call   80100390 <panic>
80107d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107d40 <setupkvm>:
{
80107d40:	f3 0f 1e fb          	endbr32 
80107d44:	55                   	push   %ebp
80107d45:	89 e5                	mov    %esp,%ebp
80107d47:	56                   	push   %esi
80107d48:	53                   	push   %ebx
  if((pgdir = (pde_t*)cow_kalloc()) == 0)
80107d49:	e8 a2 f7 ff ff       	call   801074f0 <cow_kalloc>
80107d4e:	89 c6                	mov    %eax,%esi
80107d50:	85 c0                	test   %eax,%eax
80107d52:	74 42                	je     80107d96 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80107d54:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++){
80107d57:	bb 20 c4 10 80       	mov    $0x8010c420,%ebx
  memset(pgdir, 0, PGSIZE);
80107d5c:	68 00 10 00 00       	push   $0x1000
80107d61:	6a 00                	push   $0x0
80107d63:	50                   	push   %eax
80107d64:	e8 17 d4 ff ff       	call   80105180 <memset>
80107d69:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107d6c:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107d6f:	83 ec 08             	sub    $0x8,%esp
80107d72:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107d75:	ff 73 0c             	pushl  0xc(%ebx)
80107d78:	8b 13                	mov    (%ebx),%edx
80107d7a:	50                   	push   %eax
80107d7b:	29 c1                	sub    %eax,%ecx
80107d7d:	89 f0                	mov    %esi,%eax
80107d7f:	e8 9c f8 ff ff       	call   80107620 <mappages>
80107d84:	83 c4 10             	add    $0x10,%esp
80107d87:	85 c0                	test   %eax,%eax
80107d89:	78 15                	js     80107da0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++){
80107d8b:	83 c3 10             	add    $0x10,%ebx
80107d8e:	81 fb 60 c4 10 80    	cmp    $0x8010c460,%ebx
80107d94:	75 d6                	jne    80107d6c <setupkvm+0x2c>
}
80107d96:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107d99:	89 f0                	mov    %esi,%eax
80107d9b:	5b                   	pop    %ebx
80107d9c:	5e                   	pop    %esi
80107d9d:	5d                   	pop    %ebp
80107d9e:	c3                   	ret    
80107d9f:	90                   	nop
      freevm(pgdir);
80107da0:	83 ec 0c             	sub    $0xc,%esp
80107da3:	56                   	push   %esi
      return 0;
80107da4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107da6:	e8 85 fe ff ff       	call   80107c30 <freevm>
      return 0;
80107dab:	83 c4 10             	add    $0x10,%esp
}
80107dae:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107db1:	89 f0                	mov    %esi,%eax
80107db3:	5b                   	pop    %ebx
80107db4:	5e                   	pop    %esi
80107db5:	5d                   	pop    %ebp
80107db6:	c3                   	ret    
80107db7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107dbe:	66 90                	xchg   %ax,%ax

80107dc0 <kvmalloc>:
{
80107dc0:	f3 0f 1e fb          	endbr32 
80107dc4:	55                   	push   %ebp
80107dc5:	89 e5                	mov    %esp,%ebp
80107dc7:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107dca:	e8 71 ff ff ff       	call   80107d40 <setupkvm>
80107dcf:	a3 24 1a 13 80       	mov    %eax,0x80131a24
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107dd4:	05 00 00 00 80       	add    $0x80000000,%eax
80107dd9:	0f 22 d8             	mov    %eax,%cr3
}
80107ddc:	c9                   	leave  
80107ddd:	c3                   	ret    
80107dde:	66 90                	xchg   %ax,%ax

80107de0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107de0:	f3 0f 1e fb          	endbr32 
80107de4:	55                   	push   %ebp
  pte_t *pte;
  pte = walkpgdir(pgdir, uva, 0);
80107de5:	31 c9                	xor    %ecx,%ecx
{
80107de7:	89 e5                	mov    %esp,%ebp
80107de9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107dec:	8b 55 0c             	mov    0xc(%ebp),%edx
80107def:	8b 45 08             	mov    0x8(%ebp),%eax
80107df2:	e8 a9 f7 ff ff       	call   801075a0 <walkpgdir>
  if(pte == 0)
80107df7:	85 c0                	test   %eax,%eax
80107df9:	74 05                	je     80107e00 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107dfb:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107dfe:	c9                   	leave  
80107dff:	c3                   	ret    
    panic("clearpteu");
80107e00:	83 ec 0c             	sub    $0xc,%esp
80107e03:	68 7a 92 10 80       	push   $0x8010927a
80107e08:	e8 83 85 ff ff       	call   80100390 <panic>
80107e0d:	8d 76 00             	lea    0x0(%esi),%esi

80107e10 <cow_copyuvm>:

pde_t*
cow_copyuvm(pde_t *pgdir, uint sz)
{
80107e10:	f3 0f 1e fb          	endbr32 
80107e14:	55                   	push   %ebp
80107e15:	89 e5                	mov    %esp,%ebp
80107e17:	57                   	push   %edi
80107e18:	56                   	push   %esi
80107e19:	53                   	push   %ebx
80107e1a:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  if((d = setupkvm()) == 0)
80107e1d:	e8 1e ff ff ff       	call   80107d40 <setupkvm>
80107e22:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107e25:	85 c0                	test   %eax,%eax
80107e27:	0f 84 eb 00 00 00    	je     80107f18 <cow_copyuvm+0x108>
    return 0;
  cprintf("cow : pages = %d\n", 57344 - sys_get_number_of_free_pages_impl());
80107e2d:	e8 3e c5 ff ff       	call   80104370 <sys_get_number_of_free_pages_impl>
80107e32:	83 ec 08             	sub    $0x8,%esp
80107e35:	89 c2                	mov    %eax,%edx
80107e37:	b8 00 e0 00 00       	mov    $0xe000,%eax
80107e3c:	29 d0                	sub    %edx,%eax
80107e3e:	50                   	push   %eax
80107e3f:	68 84 92 10 80       	push   $0x80109284
80107e44:	e8 67 88 ff ff       	call   801006b0 <cprintf>

  // cprintf("cow_copyuvm : pages = %d\n", 57344 - sys_get_number_of_free_pages_impl());
  for(i = 0; i < sz; i += PGSIZE){
80107e49:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80107e4c:	83 c4 10             	add    $0x10,%esp
80107e4f:	85 db                	test   %ebx,%ebx
80107e51:	0f 84 c1 00 00 00    	je     80107f18 <cow_copyuvm+0x108>
80107e57:	31 ff                	xor    %edi,%edi
80107e59:	eb 1b                	jmp    80107e76 <cow_copyuvm+0x66>
80107e5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107e5f:	90                   	nop
      // cprintf("cow2");
      goto bad;
    }
    // cprintf("cow2");
    // update parents flags
    *pte |= (PTE_W & flags ? PTE_COW : 0);
80107e60:	0b 1e                	or     (%esi),%ebx
  for(i = 0; i < sz; i += PGSIZE){
80107e62:	81 c7 00 10 00 00    	add    $0x1000,%edi
    *pte &= (~PTE_W);
80107e68:	83 e3 fd             	and    $0xfffffffd,%ebx
80107e6b:	89 1e                	mov    %ebx,(%esi)
  for(i = 0; i < sz; i += PGSIZE){
80107e6d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107e70:	0f 86 a2 00 00 00    	jbe    80107f18 <cow_copyuvm+0x108>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107e76:	8b 45 08             	mov    0x8(%ebp),%eax
80107e79:	31 c9                	xor    %ecx,%ecx
80107e7b:	89 fa                	mov    %edi,%edx
80107e7d:	e8 1e f7 ff ff       	call   801075a0 <walkpgdir>
80107e82:	89 c6                	mov    %eax,%esi
80107e84:	85 c0                	test   %eax,%eax
80107e86:	0f 84 a4 00 00 00    	je     80107f30 <cow_copyuvm+0x120>
    if(!(*pte & PTE_P) && !(*pte & PTE_PG))
80107e8c:	f7 00 01 02 00 00    	testl  $0x201,(%eax)
80107e92:	0f 84 8b 00 00 00    	je     80107f23 <cow_copyuvm+0x113>
    acquire(cow_lock);
80107e98:	83 ec 0c             	sub    $0xc,%esp
80107e9b:	ff 35 40 ff 11 80    	pushl  0x8011ff40
80107ea1:	e8 ca d1 ff ff       	call   80105070 <acquire>
    pa = PTE_ADDR(*pte);
80107ea6:	8b 06                	mov    (%esi),%eax
    pg_ref_counts[PGROUNDDOWN(pa)/PGSIZE]++;
80107ea8:	89 45 e0             	mov    %eax,-0x20(%ebp)
    pa = PTE_ADDR(*pte);
80107eab:	89 c1                	mov    %eax,%ecx
    pg_ref_counts[PGROUNDDOWN(pa)/PGSIZE]++;
80107ead:	89 c2                	mov    %eax,%edx
    release(cow_lock);
80107eaf:	58                   	pop    %eax
80107eb0:	ff 35 40 ff 11 80    	pushl  0x8011ff40
    pa = PTE_ADDR(*pte);
80107eb6:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
    pg_ref_counts[PGROUNDDOWN(pa)/PGSIZE]++;
80107ebc:	c1 ea 0c             	shr    $0xc,%edx
80107ebf:	80 82 40 1f 11 80 01 	addb   $0x1,-0x7feee0c0(%edx)
    pa = PTE_ADDR(*pte);
80107ec6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    release(cow_lock);
80107ec9:	e8 62 d2 ff ff       	call   80105130 <release>
    if(mappages(d, (void*)i, PGSIZE, pa, (flags & (~PTE_W)) | (PTE_W & flags ? PTE_COW : 0)) < 0) {
80107ece:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107ed1:	5a                   	pop    %edx
80107ed2:	89 fa                	mov    %edi,%edx
80107ed4:	59                   	pop    %ecx
80107ed5:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107eda:	89 c3                	mov    %eax,%ebx
80107edc:	25 fd 0f 00 00       	and    $0xffd,%eax
80107ee1:	c1 e3 0a             	shl    $0xa,%ebx
80107ee4:	81 e3 00 08 00 00    	and    $0x800,%ebx
80107eea:	09 d8                	or     %ebx,%eax
80107eec:	50                   	push   %eax
80107eed:	8b 45 dc             	mov    -0x24(%ebp),%eax
80107ef0:	ff 75 e4             	pushl  -0x1c(%ebp)
80107ef3:	e8 28 f7 ff ff       	call   80107620 <mappages>
80107ef8:	83 c4 10             	add    $0x10,%esp
80107efb:	85 c0                	test   %eax,%eax
80107efd:	0f 89 5d ff ff ff    	jns    80107e60 <cow_copyuvm+0x50>
  }
  return d;

bad:
  // release(cow_lock);
  freevm(d);
80107f03:	83 ec 0c             	sub    $0xc,%esp
80107f06:	ff 75 dc             	pushl  -0x24(%ebp)
80107f09:	e8 22 fd ff ff       	call   80107c30 <freevm>
  return 0;
80107f0e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
80107f15:	83 c4 10             	add    $0x10,%esp
}
80107f18:	8b 45 dc             	mov    -0x24(%ebp),%eax
80107f1b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f1e:	5b                   	pop    %ebx
80107f1f:	5e                   	pop    %esi
80107f20:	5f                   	pop    %edi
80107f21:	5d                   	pop    %ebp
80107f22:	c3                   	ret    
      panic("copyuvm: page not present");
80107f23:	83 ec 0c             	sub    $0xc,%esp
80107f26:	68 b0 92 10 80       	push   $0x801092b0
80107f2b:	e8 60 84 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107f30:	83 ec 0c             	sub    $0xc,%esp
80107f33:	68 96 92 10 80       	push   $0x80109296
80107f38:	e8 53 84 ff ff       	call   80100390 <panic>
80107f3d:	8d 76 00             	lea    0x0(%esi),%esi

80107f40 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107f40:	f3 0f 1e fb          	endbr32 
80107f44:	55                   	push   %ebp
80107f45:	89 e5                	mov    %esp,%ebp
80107f47:	57                   	push   %edi
80107f48:	56                   	push   %esi
80107f49:	53                   	push   %ebx
80107f4a:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107f4d:	e8 ee fd ff ff       	call   80107d40 <setupkvm>
80107f52:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107f55:	85 c0                	test   %eax,%eax
80107f57:	0f 84 9e 00 00 00    	je     80107ffb <copyuvm+0xbb>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107f5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107f60:	85 c9                	test   %ecx,%ecx
80107f62:	0f 84 93 00 00 00    	je     80107ffb <copyuvm+0xbb>
80107f68:	31 f6                	xor    %esi,%esi
80107f6a:	eb 46                	jmp    80107fb2 <copyuvm+0x72>
80107f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = cow_kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107f70:	83 ec 04             	sub    $0x4,%esp
80107f73:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107f79:	68 00 10 00 00       	push   $0x1000
80107f7e:	57                   	push   %edi
80107f7f:	50                   	push   %eax
80107f80:	e8 9b d2 ff ff       	call   80105220 <memmove>
    // cprintf("copy1");
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107f85:	58                   	pop    %eax
80107f86:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107f8c:	5a                   	pop    %edx
80107f8d:	ff 75 e4             	pushl  -0x1c(%ebp)
80107f90:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107f95:	89 f2                	mov    %esi,%edx
80107f97:	50                   	push   %eax
80107f98:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107f9b:	e8 80 f6 ff ff       	call   80107620 <mappages>
80107fa0:	83 c4 10             	add    $0x10,%esp
80107fa3:	85 c0                	test   %eax,%eax
80107fa5:	78 69                	js     80108010 <copyuvm+0xd0>
  for(i = 0; i < sz; i += PGSIZE){
80107fa7:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107fad:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107fb0:	76 49                	jbe    80107ffb <copyuvm+0xbb>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107fb2:	8b 45 08             	mov    0x8(%ebp),%eax
80107fb5:	31 c9                	xor    %ecx,%ecx
80107fb7:	89 f2                	mov    %esi,%edx
80107fb9:	e8 e2 f5 ff ff       	call   801075a0 <walkpgdir>
80107fbe:	85 c0                	test   %eax,%eax
80107fc0:	74 69                	je     8010802b <copyuvm+0xeb>
    if(!(*pte & PTE_P) && !(*pte & PTE_PG))
80107fc2:	8b 00                	mov    (%eax),%eax
80107fc4:	a9 01 02 00 00       	test   $0x201,%eax
80107fc9:	74 53                	je     8010801e <copyuvm+0xde>
    pa = PTE_ADDR(*pte);
80107fcb:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107fcd:	25 ff 0f 00 00       	and    $0xfff,%eax
80107fd2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107fd5:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = cow_kalloc()) == 0)
80107fdb:	e8 10 f5 ff ff       	call   801074f0 <cow_kalloc>
80107fe0:	89 c3                	mov    %eax,%ebx
80107fe2:	85 c0                	test   %eax,%eax
80107fe4:	75 8a                	jne    80107f70 <copyuvm+0x30>
    // cprintf("copy2");
  }
  return d;

bad:
  freevm(d);
80107fe6:	83 ec 0c             	sub    $0xc,%esp
80107fe9:	ff 75 e0             	pushl  -0x20(%ebp)
80107fec:	e8 3f fc ff ff       	call   80107c30 <freevm>
  return 0;
80107ff1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107ff8:	83 c4 10             	add    $0x10,%esp
}
80107ffb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107ffe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108001:	5b                   	pop    %ebx
80108002:	5e                   	pop    %esi
80108003:	5f                   	pop    %edi
80108004:	5d                   	pop    %ebp
80108005:	c3                   	ret    
80108006:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010800d:	8d 76 00             	lea    0x0(%esi),%esi
       cow_kfree(mem);
80108010:	83 ec 0c             	sub    $0xc,%esp
80108013:	53                   	push   %ebx
80108014:	e8 37 f4 ff ff       	call   80107450 <cow_kfree>
      goto bad;
80108019:	83 c4 10             	add    $0x10,%esp
8010801c:	eb c8                	jmp    80107fe6 <copyuvm+0xa6>
      panic("copyuvm: page not present");
8010801e:	83 ec 0c             	sub    $0xc,%esp
80108021:	68 b0 92 10 80       	push   $0x801092b0
80108026:	e8 65 83 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
8010802b:	83 ec 0c             	sub    $0xc,%esp
8010802e:	68 96 92 10 80       	push   $0x80109296
80108033:	e8 58 83 ff ff       	call   80100390 <panic>
80108038:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010803f:	90                   	nop

80108040 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108040:	f3 0f 1e fb          	endbr32 
80108044:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108045:	31 c9                	xor    %ecx,%ecx
{
80108047:	89 e5                	mov    %esp,%ebp
80108049:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
8010804c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010804f:	8b 45 08             	mov    0x8(%ebp),%eax
80108052:	e8 49 f5 ff ff       	call   801075a0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80108057:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80108059:	c9                   	leave  
  if((*pte & PTE_U) == 0)
8010805a:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010805c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80108061:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108064:	05 00 00 00 80       	add    $0x80000000,%eax
80108069:	83 fa 05             	cmp    $0x5,%edx
8010806c:	ba 00 00 00 00       	mov    $0x0,%edx
80108071:	0f 45 c2             	cmovne %edx,%eax
}
80108074:	c3                   	ret    
80108075:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010807c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80108080 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108080:	f3 0f 1e fb          	endbr32 
80108084:	55                   	push   %ebp
80108085:	89 e5                	mov    %esp,%ebp
80108087:	57                   	push   %edi
80108088:	56                   	push   %esi
80108089:	53                   	push   %ebx
8010808a:	83 ec 0c             	sub    $0xc,%esp
8010808d:	8b 75 14             	mov    0x14(%ebp),%esi
80108090:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108093:	85 f6                	test   %esi,%esi
80108095:	75 3c                	jne    801080d3 <copyout+0x53>
80108097:	eb 67                	jmp    80108100 <copyout+0x80>
80108099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801080a0:	8b 55 0c             	mov    0xc(%ebp),%edx
801080a3:	89 fb                	mov    %edi,%ebx
801080a5:	29 d3                	sub    %edx,%ebx
801080a7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
801080ad:	39 f3                	cmp    %esi,%ebx
801080af:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801080b2:	29 fa                	sub    %edi,%edx
801080b4:	83 ec 04             	sub    $0x4,%esp
801080b7:	01 c2                	add    %eax,%edx
801080b9:	53                   	push   %ebx
801080ba:	ff 75 10             	pushl  0x10(%ebp)
801080bd:	52                   	push   %edx
801080be:	e8 5d d1 ff ff       	call   80105220 <memmove>
    len -= n;
    buf += n;
801080c3:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
801080c6:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
801080cc:	83 c4 10             	add    $0x10,%esp
801080cf:	29 de                	sub    %ebx,%esi
801080d1:	74 2d                	je     80108100 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
801080d3:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
801080d5:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
801080d8:	89 55 0c             	mov    %edx,0xc(%ebp)
801080db:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
801080e1:	57                   	push   %edi
801080e2:	ff 75 08             	pushl  0x8(%ebp)
801080e5:	e8 56 ff ff ff       	call   80108040 <uva2ka>
    if(pa0 == 0)
801080ea:	83 c4 10             	add    $0x10,%esp
801080ed:	85 c0                	test   %eax,%eax
801080ef:	75 af                	jne    801080a0 <copyout+0x20>
  }
  return 0;
}
801080f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801080f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801080f9:	5b                   	pop    %ebx
801080fa:	5e                   	pop    %esi
801080fb:	5f                   	pop    %edi
801080fc:	5d                   	pop    %ebp
801080fd:	c3                   	ret    
801080fe:	66 90                	xchg   %ax,%ax
80108100:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80108103:	31 c0                	xor    %eax,%eax
}
80108105:	5b                   	pop    %ebx
80108106:	5e                   	pop    %esi
80108107:	5f                   	pop    %edi
80108108:	5d                   	pop    %ebp
80108109:	c3                   	ret    
8010810a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108110 <swap_out>:


//  if buffer == 0 then we put buffer <-- kernel_va(page_to_swap->va)  // p2v(phiscal(va))
//  and use buffer to swap out from
//  we assume that if buffer is not 0, it is kernel virtual address
void swap_out(struct proc* p, struct pageinfo* page_to_swap, void* buffer, pde_t* pgdir){
80108110:	f3 0f 1e fb          	endbr32 
80108114:	55                   	push   %ebp
80108115:	89 e5                	mov    %esp,%ebp
80108117:	57                   	push   %edi
80108118:	56                   	push   %esi
80108119:	53                   	push   %ebx
8010811a:	83 ec 1c             	sub    $0x1c,%esp
  // cprintf("SWAP OUT : ");
  // print_user_char(pgdir, page_to_swap->va);
  if (buffer == 0){
8010811d:	8b 75 10             	mov    0x10(%ebp),%esi
void swap_out(struct proc* p, struct pageinfo* page_to_swap, void* buffer, pde_t* pgdir){
80108120:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (buffer == 0){
80108123:	85 f6                	test   %esi,%esi
80108125:	0f 84 0d 01 00 00    	je     80108238 <swap_out+0x128>
  // swap page
  // INV  : cell swapped_out_pages[i] is free iff there isnt a page that is written in offset i * PGSIZE in the swap file
  int index;
  int found = 0;
  int count = 0;
  p->num_of_pages_in_swap_file++;
8010812b:	8b 83 80 03 00 00    	mov    0x380(%ebx),%eax
  for (index = 0; index < MAX_PYSC_PAGES; index++){
80108131:	31 c9                	xor    %ecx,%ecx
  p->num_of_pages_in_swap_file++;
80108133:	83 c0 01             	add    $0x1,%eax
80108136:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108139:	89 83 80 03 00 00    	mov    %eax,0x380(%ebx)
  for (index = 0; index < MAX_PYSC_PAGES; index++){
8010813f:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
  p->num_of_pages_in_swap_file++;
80108145:	89 c2                	mov    %eax,%edx
80108147:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010814e:	66 90                	xchg   %ax,%ax
    if (p->swapped_out_pages[index].is_free){
80108150:	8b 32                	mov    (%edx),%esi
80108152:	85 f6                	test   %esi,%esi
80108154:	0f 85 a6 00 00 00    	jne    80108200 <swap_out+0xf0>
  for (index = 0; index < MAX_PYSC_PAGES; index++){
8010815a:	83 c1 01             	add    $0x1,%ecx
8010815d:	83 c2 18             	add    $0x18,%edx
80108160:	83 f9 10             	cmp    $0x10,%ecx
80108163:	75 eb                	jne    80108150 <swap_out+0x40>
      p->swapped_out_pages[index].swap_file_offset = index * PGSIZE;
      found = 1;
      break;
    }
  }
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
80108165:	8d bb 00 02 00 00    	lea    0x200(%ebx),%edi
  int count = 0;
8010816b:	31 d2                	xor    %edx,%edx
8010816d:	8d 76 00             	lea    0x0(%esi),%esi
    if (!p->swapped_out_pages[i].is_free){
      count++;
80108170:	83 38 01             	cmpl   $0x1,(%eax)
80108173:	83 d2 00             	adc    $0x0,%edx
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
80108176:	83 c0 18             	add    $0x18,%eax
80108179:	39 c7                	cmp    %eax,%edi
8010817b:	75 f3                	jne    80108170 <swap_out+0x60>
    }
  }
  if (!found){
8010817d:	85 f6                	test   %esi,%esi
8010817f:	0f 84 d7 00 00 00    	je     8010825c <swap_out+0x14c>
    cprintf("RAM count : %d , REAL RAM count : %d\n", p->num_of_pages_in_swap_file, count);
    panic("SWAP OUT BALAGAN\n");
  }
  if (index < 0 || index > 15){
80108185:	83 f9 10             	cmp    $0x10,%ecx
80108188:	0f 84 f6 00 00 00    	je     80108284 <swap_out+0x174>
    panic("we have a bug\n");
  }
  int result = writeToSwapFile(p, buffer, index * PGSIZE, PGSIZE);
8010818e:	c1 e1 0c             	shl    $0xc,%ecx
80108191:	68 00 10 00 00       	push   $0x1000
80108196:	51                   	push   %ecx
80108197:	ff 75 10             	pushl  0x10(%ebp)
8010819a:	53                   	push   %ebx
8010819b:	e8 b0 a5 ff ff       	call   80102750 <writeToSwapFile>


  
  // update flags in PTE
  pte_t* pte_ptr = walkpgdir(pgdir, page_to_swap->va, 0);
801081a0:	31 c9                	xor    %ecx,%ecx
  int result = writeToSwapFile(p, buffer, index * PGSIZE, PGSIZE);
801081a2:	89 c6                	mov    %eax,%esi
  pte_t* pte_ptr = walkpgdir(pgdir, page_to_swap->va, 0);
801081a4:	8b 45 0c             	mov    0xc(%ebp),%eax
801081a7:	8b 50 10             	mov    0x10(%eax),%edx
801081aa:	8b 45 14             	mov    0x14(%ebp),%eax
801081ad:	e8 ee f3 ff ff       	call   801075a0 <walkpgdir>
  *pte_ptr |= PTE_PG;
  *pte_ptr &= ~PTE_P;
801081b2:	8b 10                	mov    (%eax),%edx
801081b4:	83 e2 fe             	and    $0xfffffffe,%edx
801081b7:	80 ce 02             	or     $0x2,%dh
801081ba:	89 10                	mov    %edx,(%eax)
  // *pte_ptr |= PTE_U;
  cow_kfree(buffer);
801081bc:	58                   	pop    %eax
801081bd:	ff 75 10             	pushl  0x10(%ebp)
801081c0:	e8 8b f2 ff ff       	call   80107450 <cow_kfree>
  // refresh cr3
  lcr3(V2P(p->pgdir));
801081c5:	8b 43 04             	mov    0x4(%ebx),%eax
801081c8:	05 00 00 00 80       	add    $0x80000000,%eax
801081cd:	0f 22 d8             	mov    %eax,%cr3
  page_to_swap->is_free = 1;
801081d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  if (result < 0){
801081d3:	83 c4 10             	add    $0x10,%esp
  page_to_swap->is_free = 1;
801081d6:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  if (result < 0){
801081dc:	85 f6                	test   %esi,%esi
801081de:	0f 88 93 00 00 00    	js     80108277 <swap_out+0x167>
    panic("swap out failed\n");
  }
  p->num_of_pageOut_occured++;
801081e4:	83 83 8c 03 00 00 01 	addl   $0x1,0x38c(%ebx)
  p->num_of_actual_pages_in_mem--;
801081eb:	83 ab 84 03 00 00 01 	subl   $0x1,0x384(%ebx)
}
801081f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801081f5:	5b                   	pop    %ebx
801081f6:	5e                   	pop    %esi
801081f7:	5f                   	pop    %edi
801081f8:	5d                   	pop    %ebp
801081f9:	c3                   	ret    
801081fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      p->swapped_out_pages[index].va = page_to_swap->va;
80108200:	8b 7d 0c             	mov    0xc(%ebp),%edi
      p->swapped_out_pages[index].is_free = 0;
80108203:	8d 14 49             	lea    (%ecx,%ecx,2),%edx
80108206:	8d 14 d3             	lea    (%ebx,%edx,8),%edx
80108209:	c7 82 80 00 00 00 00 	movl   $0x0,0x80(%edx)
80108210:	00 00 00 
      p->swapped_out_pages[index].va = page_to_swap->va;
80108213:	8b 77 10             	mov    0x10(%edi),%esi
80108216:	89 b2 90 00 00 00    	mov    %esi,0x90(%edx)
      p->swapped_out_pages[index].swap_file_offset = index * PGSIZE;
8010821c:	89 ce                	mov    %ecx,%esi
8010821e:	c1 e6 0c             	shl    $0xc,%esi
80108221:	89 b2 84 00 00 00    	mov    %esi,0x84(%edx)
      found = 1;
80108227:	be 01 00 00 00       	mov    $0x1,%esi
      break;
8010822c:	e9 34 ff ff ff       	jmp    80108165 <swap_out+0x55>
80108231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    buffer = P2V((PTE_ADDR(*(walkpgdir(pgdir, page_to_swap->va, 0)))));
80108238:	8b 45 0c             	mov    0xc(%ebp),%eax
8010823b:	31 c9                	xor    %ecx,%ecx
8010823d:	8b 50 10             	mov    0x10(%eax),%edx
80108240:	8b 45 14             	mov    0x14(%ebp),%eax
80108243:	e8 58 f3 ff ff       	call   801075a0 <walkpgdir>
80108248:	8b 00                	mov    (%eax),%eax
8010824a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010824f:	05 00 00 00 80       	add    $0x80000000,%eax
80108254:	89 45 10             	mov    %eax,0x10(%ebp)
80108257:	e9 cf fe ff ff       	jmp    8010812b <swap_out+0x1b>
    cprintf("RAM count : %d , REAL RAM count : %d\n", p->num_of_pages_in_swap_file, count);
8010825c:	51                   	push   %ecx
8010825d:	52                   	push   %edx
8010825e:	ff 75 e4             	pushl  -0x1c(%ebp)
80108261:	68 bc 91 10 80       	push   $0x801091bc
80108266:	e8 45 84 ff ff       	call   801006b0 <cprintf>
    panic("SWAP OUT BALAGAN\n");
8010826b:	c7 04 24 ca 92 10 80 	movl   $0x801092ca,(%esp)
80108272:	e8 19 81 ff ff       	call   80100390 <panic>
    panic("swap out failed\n");
80108277:	83 ec 0c             	sub    $0xc,%esp
8010827a:	68 eb 92 10 80       	push   $0x801092eb
8010827f:	e8 0c 81 ff ff       	call   80100390 <panic>
    panic("we have a bug\n");
80108284:	83 ec 0c             	sub    $0xc,%esp
80108287:	68 dc 92 10 80       	push   $0x801092dc
8010828c:	e8 ff 80 ff ff       	call   80100390 <panic>
80108291:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108298:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010829f:	90                   	nop

801082a0 <allocuvm>:
{
801082a0:	f3 0f 1e fb          	endbr32 
801082a4:	55                   	push   %ebp
801082a5:	89 e5                	mov    %esp,%ebp
801082a7:	57                   	push   %edi
801082a8:	56                   	push   %esi
801082a9:	53                   	push   %ebx
801082aa:	83 ec 1c             	sub    $0x1c,%esp
  struct proc* p = myproc();
801082ad:	e8 0e bf ff ff       	call   801041c0 <myproc>
801082b2:	89 c6                	mov    %eax,%esi
  if(newsz >= KERNBASE)
801082b4:	8b 45 10             	mov    0x10(%ebp),%eax
801082b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801082ba:	85 c0                	test   %eax,%eax
801082bc:	0f 88 3e 01 00 00    	js     80108400 <allocuvm+0x160>
  if(newsz < oldsz)
801082c2:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
801082c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
801082c8:	0f 82 1a 01 00 00    	jb     801083e8 <allocuvm+0x148>
  a = PGROUNDUP(oldsz);
801082ce:	8d b8 ff 0f 00 00    	lea    0xfff(%eax),%edi
801082d4:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  for(; a < newsz; a += PGSIZE){
801082da:	39 7d 10             	cmp    %edi,0x10(%ebp)
801082dd:	0f 86 08 01 00 00    	jbe    801083eb <allocuvm+0x14b>
801082e3:	8b 4e 10             	mov    0x10(%esi),%ecx
801082e6:	eb 17                	jmp    801082ff <allocuvm+0x5f>
801082e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801082ef:	90                   	nop
801082f0:	81 c7 00 10 00 00    	add    $0x1000,%edi
801082f6:	39 7d 10             	cmp    %edi,0x10(%ebp)
801082f9:	0f 86 ec 00 00 00    	jbe    801083eb <allocuvm+0x14b>
    if (p->pid > 2){
801082ff:	83 f9 64             	cmp    $0x64,%ecx
80108302:	7e 42                	jle    80108346 <allocuvm+0xa6>
      if (p->num_of_actual_pages_in_mem >= 16){
80108304:	8b 86 84 03 00 00    	mov    0x384(%esi),%eax
8010830a:	83 f8 0f             	cmp    $0xf,%eax
8010830d:	76 2e                	jbe    8010833d <allocuvm+0x9d>
        if (p->num_of_pages_in_swap_file >= 16){
8010830f:	83 be 80 03 00 00 0f 	cmpl   $0xf,0x380(%esi)
80108316:	0f 87 fc 00 00 00    	ja     80108418 <allocuvm+0x178>
        struct pageinfo* page_to_swap = find_page_to_swap(p, pgdir);
8010831c:	83 ec 08             	sub    $0x8,%esp
8010831f:	ff 75 08             	pushl  0x8(%ebp)
80108322:	56                   	push   %esi
80108323:	e8 88 f3 ff ff       	call   801076b0 <find_page_to_swap>
        swap_out(p, page_to_swap, 0, pgdir);
80108328:	ff 75 08             	pushl  0x8(%ebp)
8010832b:	6a 00                	push   $0x0
8010832d:	50                   	push   %eax
8010832e:	56                   	push   %esi
8010832f:	e8 dc fd ff ff       	call   80108110 <swap_out>
80108334:	8b 86 84 03 00 00    	mov    0x384(%esi),%eax
8010833a:	83 c4 20             	add    $0x20,%esp
      p->num_of_actual_pages_in_mem++;
8010833d:	83 c0 01             	add    $0x1,%eax
80108340:	89 86 84 03 00 00    	mov    %eax,0x384(%esi)
    mem = cow_kalloc();
80108346:	e8 a5 f1 ff ff       	call   801074f0 <cow_kalloc>
8010834b:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
8010834d:	85 c0                	test   %eax,%eax
8010834f:	0f 84 c3 00 00 00    	je     80108418 <allocuvm+0x178>
    memset(mem, 0, PGSIZE);
80108355:	83 ec 04             	sub    $0x4,%esp
80108358:	68 00 10 00 00       	push   $0x1000
8010835d:	6a 00                	push   $0x0
8010835f:	50                   	push   %eax
80108360:	e8 1b ce ff ff       	call   80105180 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80108365:	58                   	pop    %eax
80108366:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010836c:	5a                   	pop    %edx
8010836d:	6a 06                	push   $0x6
8010836f:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108374:	89 fa                	mov    %edi,%edx
80108376:	50                   	push   %eax
80108377:	8b 45 08             	mov    0x8(%ebp),%eax
8010837a:	e8 a1 f2 ff ff       	call   80107620 <mappages>
8010837f:	83 c4 10             	add    $0x10,%esp
80108382:	85 c0                	test   %eax,%eax
80108384:	0f 88 c6 00 00 00    	js     80108450 <allocuvm+0x1b0>
    if (p->pid > 2){
8010838a:	8b 4e 10             	mov    0x10(%esi),%ecx
8010838d:	83 f9 64             	cmp    $0x64,%ecx
80108390:	0f 8e 5a ff ff ff    	jle    801082f0 <allocuvm+0x50>
80108396:	8d 96 00 02 00 00    	lea    0x200(%esi),%edx
      for (int i = 0; i < MAX_PYSC_PAGES; i++){
8010839c:	31 c0                	xor    %eax,%eax
8010839e:	eb 0f                	jmp    801083af <allocuvm+0x10f>
801083a0:	83 c0 01             	add    $0x1,%eax
801083a3:	83 c2 18             	add    $0x18,%edx
801083a6:	83 f8 10             	cmp    $0x10,%eax
801083a9:	0f 84 41 ff ff ff    	je     801082f0 <allocuvm+0x50>
        if (p->ram_pages[i].is_free){
801083af:	8b 1a                	mov    (%edx),%ebx
801083b1:	85 db                	test   %ebx,%ebx
801083b3:	74 eb                	je     801083a0 <allocuvm+0x100>
          p->ram_pages[i].is_free = 0;
801083b5:	8d 04 40             	lea    (%eax,%eax,2),%eax
801083b8:	8d 14 c6             	lea    (%esi,%eax,8),%edx
          p->ram_pages[i].page_index = ++page_counter;
801083bb:	a1 c0 c5 10 80       	mov    0x8010c5c0,%eax
          p->ram_pages[i].is_free = 0;
801083c0:	c7 82 00 02 00 00 00 	movl   $0x0,0x200(%edx)
801083c7:	00 00 00 
          p->ram_pages[i].page_index = ++page_counter;
801083ca:	83 c0 01             	add    $0x1,%eax
          p->ram_pages[i].va = (void *)a;
801083cd:	89 ba 10 02 00 00    	mov    %edi,0x210(%edx)
          p->ram_pages[i].page_index = ++page_counter;
801083d3:	a3 c0 c5 10 80       	mov    %eax,0x8010c5c0
801083d8:	89 82 0c 02 00 00    	mov    %eax,0x20c(%edx)
          break;
801083de:	e9 0d ff ff ff       	jmp    801082f0 <allocuvm+0x50>
801083e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801083e7:	90                   	nop
    return oldsz;
801083e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
801083eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801083ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801083f1:	5b                   	pop    %ebx
801083f2:	5e                   	pop    %esi
801083f3:	5f                   	pop    %edi
801083f4:	5d                   	pop    %ebp
801083f5:	c3                   	ret    
801083f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801083fd:	8d 76 00             	lea    0x0(%esi),%esi
    return 0;
80108400:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80108407:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010840a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010840d:	5b                   	pop    %ebx
8010840e:	5e                   	pop    %esi
8010840f:	5f                   	pop    %edi
80108410:	5d                   	pop    %ebp
80108411:	c3                   	ret    
80108412:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          cprintf("allocuvm out of memory\n");
80108418:	83 ec 0c             	sub    $0xc,%esp
8010841b:	68 fc 92 10 80       	push   $0x801092fc
80108420:	e8 8b 82 ff ff       	call   801006b0 <cprintf>
          deallocuvm(pgdir, newsz, oldsz);
80108425:	83 c4 0c             	add    $0xc,%esp
80108428:	ff 75 0c             	pushl  0xc(%ebp)
8010842b:	ff 75 10             	pushl  0x10(%ebp)
8010842e:	ff 75 08             	pushl  0x8(%ebp)
80108431:	e8 ea f6 ff ff       	call   80107b20 <deallocuvm>
          return 0;
80108436:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010843d:	83 c4 10             	add    $0x10,%esp
}
80108440:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108443:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108446:	5b                   	pop    %ebx
80108447:	5e                   	pop    %esi
80108448:	5f                   	pop    %edi
80108449:	5d                   	pop    %ebp
8010844a:	c3                   	ret    
8010844b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010844f:	90                   	nop
      cprintf("allocuvm out of memory (2)\n");
80108450:	83 ec 0c             	sub    $0xc,%esp
80108453:	68 14 93 10 80       	push   $0x80109314
80108458:	e8 53 82 ff ff       	call   801006b0 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
8010845d:	83 c4 0c             	add    $0xc,%esp
80108460:	ff 75 0c             	pushl  0xc(%ebp)
80108463:	ff 75 10             	pushl  0x10(%ebp)
80108466:	ff 75 08             	pushl  0x8(%ebp)
80108469:	e8 b2 f6 ff ff       	call   80107b20 <deallocuvm>
      cow_kfree(mem);
8010846e:	89 1c 24             	mov    %ebx,(%esp)
80108471:	e8 da ef ff ff       	call   80107450 <cow_kfree>
      return 0;
80108476:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010847d:	83 c4 10             	add    $0x10,%esp
}
80108480:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108483:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108486:	5b                   	pop    %ebx
80108487:	5e                   	pop    %esi
80108488:	5f                   	pop    %edi
80108489:	5d                   	pop    %ebp
8010848a:	c3                   	ret    
8010848b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010848f:	90                   	nop

80108490 <swap_in>:

// we assume there are at most MAX_PYSC_PAGES in the RAM 
int swap_in(struct proc* p, struct pageinfo* pi){
80108490:	f3 0f 1e fb          	endbr32 
80108494:	55                   	push   %ebp
80108495:	89 e5                	mov    %esp,%ebp
80108497:	57                   	push   %edi
80108498:	56                   	push   %esi
80108499:	53                   	push   %ebx
  // print_user_char(pgdir, pi->va);
  int found = 0;
  int index;
  int count = 0;
  // cprintf("SWAP IN: va = %d\n", pi->va);
  for (index = 0; index < MAX_PYSC_PAGES; index++){
8010849a:	31 db                	xor    %ebx,%ebx
int swap_in(struct proc* p, struct pageinfo* pi){
8010849c:	83 ec 1c             	sub    $0x1c,%esp
8010849f:	8b 75 08             	mov    0x8(%ebp),%esi
  pde_t* pgdir = p->pgdir;
801084a2:	8b 46 04             	mov    0x4(%esi),%eax
801084a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint offset = pi->swap_file_offset;
801084a8:	8b 45 0c             	mov    0xc(%ebp),%eax
801084ab:	8b 40 04             	mov    0x4(%eax),%eax
801084ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for (index = 0; index < MAX_PYSC_PAGES; index++){
801084b1:	8d 86 00 02 00 00    	lea    0x200(%esi),%eax
  uint offset = pi->swap_file_offset;
801084b7:	89 c2                	mov    %eax,%edx
801084b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (p->ram_pages[index].is_free){
801084c0:	8b 0a                	mov    (%edx),%ecx
801084c2:	85 c9                	test   %ecx,%ecx
801084c4:	0f 85 e6 00 00 00    	jne    801085b0 <swap_in+0x120>
  for (index = 0; index < MAX_PYSC_PAGES; index++){
801084ca:	83 c3 01             	add    $0x1,%ebx
801084cd:	83 c2 18             	add    $0x18,%edx
801084d0:	83 fb 10             	cmp    $0x10,%ebx
801084d3:	75 eb                	jne    801084c0 <swap_in+0x30>
      found = 1;
      p->ram_pages[index].is_free = 0;
      break;
    }
  }
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
801084d5:	8d be 80 03 00 00    	lea    0x380(%esi),%edi
  int count = 0;
801084db:	31 d2                	xor    %edx,%edx
801084dd:	8d 76 00             	lea    0x0(%esi),%esi
    if (!p->ram_pages[i].is_free){
      count++;
801084e0:	83 38 01             	cmpl   $0x1,(%eax)
801084e3:	83 d2 00             	adc    $0x0,%edx
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
801084e6:	83 c0 18             	add    $0x18,%eax
801084e9:	39 c7                	cmp    %eax,%edi
801084eb:	75 f3                	jne    801084e0 <swap_in+0x50>
    }
  }
  if (!found){
801084ed:	85 c9                	test   %ecx,%ecx
801084ef:	0f 84 f7 00 00 00    	je     801085ec <swap_in+0x15c>
    cprintf("RAM count : %d , REAL RAM count : %d\n", p->num_of_actual_pages_in_mem, count);
    panic("SWAP IN BALAGAN\n");
  }
  void* mem = cow_kalloc();
801084f5:	e8 f6 ef ff ff       	call   801074f0 <cow_kalloc>
801084fa:	89 c7                	mov    %eax,%edi
  // mem = cow_kalloc();
  if(mem == 0){
801084fc:	85 c0                	test   %eax,%eax
801084fe:	0f 84 c4 00 00 00    	je     801085c8 <swap_in+0x138>
    cprintf("swap in - out of memory\n");
    // deallocuvm(pgdir, newsz, oldsz);
    return -1;
  }

  void* va = pi->va;
80108504:	8b 45 0c             	mov    0xc(%ebp),%eax
  pte_t* pte_ptr = walkpgdir(pgdir, va, 0);
80108507:	31 c9                	xor    %ecx,%ecx
  void* va = pi->va;
80108509:	8b 40 10             	mov    0x10(%eax),%eax
  pte_t* pte_ptr = walkpgdir(pgdir, va, 0);
8010850c:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010850f:	89 c2                	mov    %eax,%edx
80108511:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108514:	e8 87 f0 ff ff       	call   801075a0 <walkpgdir>
  *pte_ptr &= ~PTE_PG;
  *pte_ptr |= (PTE_P | PTE_U | PTE_W);

  // updating physical address written in the page table entry
  *pte_ptr = PTE_FLAGS(*pte_ptr);
  *pte_ptr |= PTE_ADDR(V2P(mem));
80108519:	8d 97 00 00 00 80    	lea    -0x80000000(%edi),%edx
8010851f:	8b 08                	mov    (%eax),%ecx
80108521:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80108527:	81 e1 ff 0d 00 00    	and    $0xdff,%ecx
8010852d:	09 ca                	or     %ecx,%edx
8010852f:	83 ca 07             	or     $0x7,%edx
80108532:	89 10                	mov    %edx,(%eax)

  p->ram_pages[index].page_index = ++page_counter;
80108534:	8b 0d c0 c5 10 80    	mov    0x8010c5c0,%ecx
8010853a:	8d 14 5b             	lea    (%ebx,%ebx,2),%edx
8010853d:	8d 14 d6             	lea    (%esi,%edx,8),%edx
80108540:	8d 41 01             	lea    0x1(%ecx),%eax
80108543:	89 82 0c 02 00 00    	mov    %eax,0x20c(%edx)
80108549:	a3 c0 c5 10 80       	mov    %eax,0x8010c5c0
  p->ram_pages[index].va = va;
8010854e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108551:	89 82 10 02 00 00    	mov    %eax,0x210(%edx)
  int result = readFromSwapFile(p, mem, offset, PGSIZE);
80108557:	68 00 10 00 00       	push   $0x1000
8010855c:	ff 75 e0             	pushl  -0x20(%ebp)
8010855f:	57                   	push   %edi
80108560:	56                   	push   %esi
80108561:	e8 1a a2 ff ff       	call   80102780 <readFromSwapFile>

  // clean the struct
  pi->is_free = 1;
80108566:	8b 7d 0c             	mov    0xc(%ebp),%edi
80108569:	c7 07 01 00 00 00    	movl   $0x1,(%edi)
  pi->va = 0;
8010856f:	c7 47 10 00 00 00 00 	movl   $0x0,0x10(%edi)
  pi->swap_file_offset = 0;
80108576:	c7 47 04 00 00 00 00 	movl   $0x0,0x4(%edi)

  // refresh rc3
  lcr3(V2P(p->pgdir));
8010857d:	8b 7e 04             	mov    0x4(%esi),%edi
80108580:	8d 97 00 00 00 80    	lea    -0x80000000(%edi),%edx
80108586:	0f 22 da             	mov    %edx,%cr3

  p->num_of_actual_pages_in_mem++;
80108589:	83 86 84 03 00 00 01 	addl   $0x1,0x384(%esi)
  p->num_of_pages_in_swap_file--;

  if (result < 0){
80108590:	83 c4 10             	add    $0x10,%esp
  p->num_of_pages_in_swap_file--;
80108593:	83 ae 80 03 00 00 01 	subl   $0x1,0x380(%esi)
  if (result < 0){
8010859a:	85 c0                	test   %eax,%eax
8010859c:	78 41                	js     801085df <swap_in+0x14f>
    panic("swap in failed");
  }
  return result;
}
8010859e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801085a1:	5b                   	pop    %ebx
801085a2:	5e                   	pop    %esi
801085a3:	5f                   	pop    %edi
801085a4:	5d                   	pop    %ebp
801085a5:	c3                   	ret    
801085a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801085ad:	8d 76 00             	lea    0x0(%esi),%esi
      p->ram_pages[index].is_free = 0;
801085b0:	8d 14 5b             	lea    (%ebx,%ebx,2),%edx
      found = 1;
801085b3:	b9 01 00 00 00       	mov    $0x1,%ecx
      p->ram_pages[index].is_free = 0;
801085b8:	c7 84 d6 00 02 00 00 	movl   $0x0,0x200(%esi,%edx,8)
801085bf:	00 00 00 00 
      break;
801085c3:	e9 0d ff ff ff       	jmp    801084d5 <swap_in+0x45>
    cprintf("swap in - out of memory\n");
801085c8:	83 ec 0c             	sub    $0xc,%esp
801085cb:	68 41 93 10 80       	push   $0x80109341
801085d0:	e8 db 80 ff ff       	call   801006b0 <cprintf>
    return -1;
801085d5:	83 c4 10             	add    $0x10,%esp
801085d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801085dd:	eb bf                	jmp    8010859e <swap_in+0x10e>
    panic("swap in failed");
801085df:	83 ec 0c             	sub    $0xc,%esp
801085e2:	68 5a 93 10 80       	push   $0x8010935a
801085e7:	e8 a4 7d ff ff       	call   80100390 <panic>
    cprintf("RAM count : %d , REAL RAM count : %d\n", p->num_of_actual_pages_in_mem, count);
801085ec:	50                   	push   %eax
801085ed:	52                   	push   %edx
801085ee:	ff b6 84 03 00 00    	pushl  0x384(%esi)
801085f4:	68 bc 91 10 80       	push   $0x801091bc
801085f9:	e8 b2 80 ff ff       	call   801006b0 <cprintf>
    panic("SWAP IN BALAGAN\n");
801085fe:	c7 04 24 30 93 10 80 	movl   $0x80109330,(%esp)
80108605:	e8 86 7d ff ff       	call   80100390 <panic>
8010860a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108610 <swap_page_back>:
 * 3. ram not full - swap in
 * 
 * 
 * */

void swap_page_back(struct proc* p, struct pageinfo* pi_to_swapin){
80108610:	f3 0f 1e fb          	endbr32 
80108614:	55                   	push   %ebp
80108615:	89 e5                	mov    %esp,%ebp
80108617:	57                   	push   %edi
80108618:	56                   	push   %esi
80108619:	53                   	push   %ebx
8010861a:	83 ec 2c             	sub    $0x2c,%esp
8010861d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  //   if (!p->swapped_out_pages[i].is_free){
  //     swap++;
  //   }
  // }
  // cprintf("RAM: %d SWAP: %d\n", ram, swap);
  if (p->num_of_actual_pages_in_mem == MAX_PYSC_PAGES && p->num_of_pages_in_swap_file == MAX_PYSC_PAGES){
80108620:	83 bb 84 03 00 00 10 	cmpl   $0x10,0x384(%ebx)
80108627:	74 17                	je     80108640 <swap_page_back+0x30>
    // cprintf("swap page back 2\n");
    swap_out(p, page_to_swap, 0, p->pgdir);
    swap_in(p, pi_to_swapin);
  }
  else{
    swap_in(p, pi_to_swapin);
80108629:	83 ec 08             	sub    $0x8,%esp
8010862c:	ff 75 0c             	pushl  0xc(%ebp)
8010862f:	53                   	push   %ebx
80108630:	e8 5b fe ff ff       	call   80108490 <swap_in>
80108635:	83 c4 10             	add    $0x10,%esp
  }
}
80108638:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010863b:	5b                   	pop    %ebx
8010863c:	5e                   	pop    %esi
8010863d:	5f                   	pop    %edi
8010863e:	5d                   	pop    %ebp
8010863f:	c3                   	ret    
  if (p->num_of_actual_pages_in_mem == MAX_PYSC_PAGES && p->num_of_pages_in_swap_file == MAX_PYSC_PAGES){
80108640:	8b 83 80 03 00 00    	mov    0x380(%ebx),%eax
80108646:	83 f8 10             	cmp    $0x10,%eax
80108649:	74 35                	je     80108680 <swap_page_back+0x70>
  else if (p->num_of_actual_pages_in_mem == MAX_PYSC_PAGES && p->num_of_pages_in_swap_file < MAX_PYSC_PAGES){
8010864b:	83 f8 0f             	cmp    $0xf,%eax
8010864e:	77 d9                	ja     80108629 <swap_page_back+0x19>
    struct pageinfo* page_to_swap = find_page_to_swap(p, p->pgdir);
80108650:	83 ec 08             	sub    $0x8,%esp
80108653:	ff 73 04             	pushl  0x4(%ebx)
80108656:	53                   	push   %ebx
80108657:	e8 54 f0 ff ff       	call   801076b0 <find_page_to_swap>
    swap_out(p, page_to_swap, 0, p->pgdir);
8010865c:	ff 73 04             	pushl  0x4(%ebx)
8010865f:	6a 00                	push   $0x0
80108661:	50                   	push   %eax
80108662:	53                   	push   %ebx
80108663:	e8 a8 fa ff ff       	call   80108110 <swap_out>
    swap_in(p, pi_to_swapin);
80108668:	83 c4 18             	add    $0x18,%esp
8010866b:	ff 75 0c             	pushl  0xc(%ebp)
8010866e:	53                   	push   %ebx
8010866f:	e8 1c fe ff ff       	call   80108490 <swap_in>
  else if (p->num_of_actual_pages_in_mem == MAX_PYSC_PAGES && p->num_of_pages_in_swap_file < MAX_PYSC_PAGES){
80108674:	83 c4 10             	add    $0x10,%esp
}
80108677:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010867a:	5b                   	pop    %ebx
8010867b:	5e                   	pop    %esi
8010867c:	5f                   	pop    %edi
8010867d:	5d                   	pop    %ebp
8010867e:	c3                   	ret    
8010867f:	90                   	nop
    char* buffer = cow_kalloc();
80108680:	e8 6b ee ff ff       	call   801074f0 <cow_kalloc>
    struct pageinfo* page_to_swap = find_page_to_swap(p, p->pgdir);
80108685:	83 ec 08             	sub    $0x8,%esp
80108688:	ff 73 04             	pushl  0x4(%ebx)
8010868b:	53                   	push   %ebx
    char* buffer = cow_kalloc();
8010868c:	89 c7                	mov    %eax,%edi
    struct pageinfo* page_to_swap = find_page_to_swap(p, p->pgdir);
8010868e:	e8 1d f0 ff ff       	call   801076b0 <find_page_to_swap>
    memmove(buffer, page_to_swap->va, PGSIZE);
80108693:	83 c4 0c             	add    $0xc,%esp
80108696:	68 00 10 00 00       	push   $0x1000
    struct pageinfo* page_to_swap = find_page_to_swap(p, p->pgdir);
8010869b:	89 c6                	mov    %eax,%esi
    memmove(buffer, page_to_swap->va, PGSIZE);
8010869d:	ff 70 10             	pushl  0x10(%eax)
801086a0:	57                   	push   %edi
801086a1:	e8 7a cb ff ff       	call   80105220 <memmove>
    pi = *page_to_swap;
801086a6:	8b 06                	mov    (%esi),%eax
801086a8:	89 45 d0             	mov    %eax,-0x30(%ebp)
801086ab:	8b 46 04             	mov    0x4(%esi),%eax
801086ae:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801086b1:	8b 46 08             	mov    0x8(%esi),%eax
801086b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
801086b7:	8b 46 0c             	mov    0xc(%esi),%eax
801086ba:	89 45 dc             	mov    %eax,-0x24(%ebp)
801086bd:	8b 46 10             	mov    0x10(%esi),%eax
801086c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801086c3:	8b 46 14             	mov    0x14(%esi),%eax
801086c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    page_to_swap->is_free = 1;
801086c9:	c7 06 01 00 00 00    	movl   $0x1,(%esi)
    p->num_of_actual_pages_in_mem--;
801086cf:	83 ab 84 03 00 00 01 	subl   $0x1,0x384(%ebx)
    swap_in(p, page_to_swap);
801086d6:	58                   	pop    %eax
801086d7:	5a                   	pop    %edx
801086d8:	56                   	push   %esi
801086d9:	53                   	push   %ebx
801086da:	e8 b1 fd ff ff       	call   80108490 <swap_in>
    swap_out(p, &pi, buffer, p->pgdir);
801086df:	8d 45 d0             	lea    -0x30(%ebp),%eax
801086e2:	ff 73 04             	pushl  0x4(%ebx)
801086e5:	57                   	push   %edi
801086e6:	50                   	push   %eax
801086e7:	53                   	push   %ebx
801086e8:	e8 23 fa ff ff       	call   80108110 <swap_out>
  if (p->num_of_actual_pages_in_mem == MAX_PYSC_PAGES && p->num_of_pages_in_swap_file == MAX_PYSC_PAGES){
801086ed:	83 c4 20             	add    $0x20,%esp
801086f0:	e9 43 ff ff ff       	jmp    80108638 <swap_page_back+0x28>
801086f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801086fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80108700 <copy_page>:

int copy_page(pde_t* pgdir, pte_t* pte_ptr){
80108700:	f3 0f 1e fb          	endbr32 
80108704:	55                   	push   %ebp
80108705:	89 e5                	mov    %esp,%ebp
80108707:	57                   	push   %edi
80108708:	56                   	push   %esi
80108709:	53                   	push   %ebx
8010870a:	83 ec 0c             	sub    $0xc,%esp
8010870d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  uint pa = PTE_ADDR(*pte_ptr);
80108710:	8b 37                	mov    (%edi),%esi
80108712:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  char* mem = cow_kalloc();
80108718:	e8 d3 ed ff ff       	call   801074f0 <cow_kalloc>
  if (mem == 0){
8010871d:	85 c0                	test   %eax,%eax
8010871f:	74 35                	je     80108756 <copy_page+0x56>
    return -1;
  }
  memmove(mem, P2V(pa), PGSIZE);
80108721:	83 ec 04             	sub    $0x4,%esp
80108724:	89 c3                	mov    %eax,%ebx
80108726:	81 c6 00 00 00 80    	add    $0x80000000,%esi
8010872c:	68 00 10 00 00       	push   $0x1000
  *pte_ptr = PTE_ADDR(V2P(mem)) | PTE_U | PTE_W | PTE_P;
80108731:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
  memmove(mem, P2V(pa), PGSIZE);
80108737:	56                   	push   %esi
  *pte_ptr = PTE_ADDR(V2P(mem)) | PTE_U | PTE_W | PTE_P;
80108738:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  memmove(mem, P2V(pa), PGSIZE);
8010873e:	50                   	push   %eax
  *pte_ptr = PTE_ADDR(V2P(mem)) | PTE_U | PTE_W | PTE_P;
8010873f:	83 cb 07             	or     $0x7,%ebx
  memmove(mem, P2V(pa), PGSIZE);
80108742:	e8 d9 ca ff ff       	call   80105220 <memmove>
  *pte_ptr = PTE_ADDR(V2P(mem)) | PTE_U | PTE_W | PTE_P;
80108747:	89 1f                	mov    %ebx,(%edi)
  return 0;
80108749:	83 c4 10             	add    $0x10,%esp
8010874c:	31 c0                	xor    %eax,%eax
}
8010874e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108751:	5b                   	pop    %ebx
80108752:	5e                   	pop    %esi
80108753:	5f                   	pop    %edi
80108754:	5d                   	pop    %ebp
80108755:	c3                   	ret    
    return -1;
80108756:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010875b:	eb f1                	jmp    8010874e <copy_page+0x4e>
