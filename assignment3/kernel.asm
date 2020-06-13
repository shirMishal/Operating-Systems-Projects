
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
8010002d:	b8 00 35 10 80       	mov    $0x80103500,%eax
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
80100050:	68 20 7a 10 80       	push   $0x80107a20
80100055:	68 e0 c5 10 80       	push   $0x8010c5e0
8010005a:	e8 c1 48 00 00       	call   80104920 <initlock>
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
80100092:	68 27 7a 10 80       	push   $0x80107a27
80100097:	50                   	push   %eax
80100098:	e8 43 47 00 00       	call   801047e0 <initsleeplock>
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
801000e8:	e8 b3 49 00 00       	call   80104aa0 <acquire>
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
80100162:	e8 f9 49 00 00       	call   80104b60 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ae 46 00 00       	call   80104820 <acquiresleep>
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
8010018c:	e8 1f 25 00 00       	call   801026b0 <iderw>
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
801001a3:	68 2e 7a 10 80       	push   $0x80107a2e
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
801001c2:	e8 f9 46 00 00       	call   801048c0 <holdingsleep>
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
801001d8:	e9 d3 24 00 00       	jmp    801026b0 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 3f 7a 10 80       	push   $0x80107a3f
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
80100203:	e8 b8 46 00 00       	call   801048c0 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 68 46 00 00       	call   80104880 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
8010021f:	e8 7c 48 00 00       	call   80104aa0 <acquire>
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
80100270:	e9 eb 48 00 00       	jmp    80104b60 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 46 7a 10 80       	push   $0x80107a46
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
801002a5:	e8 46 16 00 00       	call   801018f0 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
801002b1:	e8 ea 47 00 00       	call   80104aa0 <acquire>
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
801002e5:	e8 56 41 00 00       	call   80104440 <sleep>
    while(input.r == input.w){
801002ea:	a1 e0 ef 11 80       	mov    0x8011efe0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 e4 ef 11 80    	cmp    0x8011efe4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 51 3b 00 00       	call   80103e50 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 b5 10 80       	push   $0x8010b520
8010030e:	e8 4d 48 00 00       	call   80104b60 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 f4 14 00 00       	call   80101810 <ilock>
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
80100365:	e8 f6 47 00 00       	call   80104b60 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 9d 14 00 00       	call   80101810 <ilock>
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
801003ad:	e8 ae 29 00 00       	call   80102d60 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 4d 7a 10 80       	push   $0x80107a4d
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 2c 85 10 80 	movl   $0x8010852c,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 5f 45 00 00       	call   80104940 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 61 7a 10 80       	push   $0x80107a61
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
8010042a:	e8 61 5f 00 00       	call   80106390 <uartputc>
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
80100515:	e8 76 5e 00 00       	call   80106390 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 6a 5e 00 00       	call   80106390 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 5e 5e 00 00       	call   80106390 <uartputc>
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
80100561:	e8 ea 46 00 00       	call   80104c50 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 35 46 00 00       	call   80104bb0 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 65 7a 10 80       	push   $0x80107a65
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
801005c9:	0f b6 92 90 7a 10 80 	movzbl -0x7fef8570(%edx),%edx
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
80100653:	e8 98 12 00 00       	call   801018f0 <iunlock>
  acquire(&cons.lock);
80100658:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010065f:	e8 3c 44 00 00       	call   80104aa0 <acquire>
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
80100697:	e8 c4 44 00 00       	call   80104b60 <release>
  ilock(ip);
8010069c:	58                   	pop    %eax
8010069d:	ff 75 08             	pushl  0x8(%ebp)
801006a0:	e8 6b 11 00 00       	call   80101810 <ilock>

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
8010077d:	bb 78 7a 10 80       	mov    $0x80107a78,%ebx
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
801007bd:	e8 de 42 00 00       	call   80104aa0 <acquire>
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
80100828:	e8 33 43 00 00       	call   80104b60 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 7f 7a 10 80       	push   $0x80107a7f
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
80100877:	e8 24 42 00 00       	call   80104aa0 <acquire>
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
801009cf:	e8 8c 41 00 00       	call   80104b60 <release>
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
801009ff:	e9 fc 3c 00 00       	jmp    80104700 <procdump>
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
80100a20:	e8 db 3b 00 00       	call   80104600 <wakeup>
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
80100a3a:	68 88 7a 10 80       	push   $0x80107a88
80100a3f:	68 20 b5 10 80       	push   $0x8010b520
80100a44:	e8 d7 3e 00 00       	call   80104920 <initlock>

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
80100a6d:	e8 ee 1d 00 00       	call   80102860 <ioapicenable>
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
80100a87:	8b 4d 08             	mov    0x8(%ebp),%ecx
  p->num_of_pageOut_occured = 0;
80100a8a:	c7 81 cc 03 00 00 00 	movl   $0x0,0x3cc(%ecx)
80100a91:	00 00 00 
  p->num_of_pagefaults_occurs = 0;
80100a94:	8d 81 80 00 00 00    	lea    0x80(%ecx),%eax
80100a9a:	8d 91 80 03 00 00    	lea    0x380(%ecx),%edx
80100aa0:	81 c1 00 02 00 00    	add    $0x200,%ecx
80100aa6:	c7 81 c8 01 00 00 00 	movl   $0x0,0x1c8(%ecx)
80100aad:	00 00 00 
  p->num_of_actual_pages_in_mem = 0;
80100ab0:	c7 81 c4 01 00 00 00 	movl   $0x0,0x1c4(%ecx)
80100ab7:	00 00 00 
  p->num_of_pages_in_swap_file = 0;
80100aba:	c7 81 c0 01 00 00 00 	movl   $0x0,0x1c0(%ecx)
80100ac1:	00 00 00 
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
80100ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->ram_pages[i].is_free = p->swapped_out_pages[i].is_free = 1;
80100ac8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
80100ace:	83 c0 18             	add    $0x18,%eax
80100ad1:	83 c2 04             	add    $0x4,%edx
80100ad4:	c7 80 68 01 00 00 01 	movl   $0x1,0x168(%eax)
80100adb:	00 00 00 
    p->ram_pages[i].aging_counter = p->swapped_out_pages[i].aging_counter = 0;
80100ade:	c7 40 f0 00 00 00 00 	movl   $0x0,-0x10(%eax)
80100ae5:	c7 80 70 01 00 00 00 	movl   $0x0,0x170(%eax)
80100aec:	00 00 00 
    p->ram_pages[i].swap_file_offset = p->swapped_out_pages[i].swap_file_offset = 0;
80100aef:	c7 40 ec 00 00 00 00 	movl   $0x0,-0x14(%eax)
80100af6:	c7 80 6c 01 00 00 00 	movl   $0x0,0x16c(%eax)
80100afd:	00 00 00 
    p->ram_pages[i].va = p->swapped_out_pages[i].va = 0;
80100b00:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
80100b07:	c7 80 78 01 00 00 00 	movl   $0x0,0x178(%eax)
80100b0e:	00 00 00 
    p->advance_queue[i] = -1;//AQ
80100b11:	c7 42 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%edx)
  for (int i = 0; i < MAX_PYSC_PAGES; i++){
80100b18:	39 c8                	cmp    %ecx,%eax
80100b1a:	75 ac                	jne    80100ac8 <intiate_pg_info+0x48>
  }
}
80100b1c:	5d                   	pop    %ebp
80100b1d:	c3                   	ret    
80100b1e:	66 90                	xchg   %ax,%ax

80100b20 <exec>:


int
exec(char *path, char **argv)
{
80100b20:	f3 0f 1e fb          	endbr32 
80100b24:	55                   	push   %ebp
80100b25:	89 e5                	mov    %esp,%ebp
80100b27:	57                   	push   %edi
80100b28:	56                   	push   %esi
80100b29:	53                   	push   %ebx
80100b2a:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  // cprintf("before setup\n");
  struct proc *curproc = myproc();
80100b30:	e8 1b 33 00 00       	call   80103e50 <myproc>
80100b35:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
  int advance_q_bu[MAX_PYSC_PAGES];
  struct file* swap_file_bu = 0;
  struct file* temp_swap_file = 0;
  #endif

  begin_op();
80100b3b:	e8 b0 26 00 00       	call   801031f0 <begin_op>

  if((ip = namei(path)) == 0){
80100b40:	83 ec 0c             	sub    $0xc,%esp
80100b43:	ff 75 08             	pushl  0x8(%ebp)
80100b46:	e8 95 15 00 00       	call   801020e0 <namei>
80100b4b:	83 c4 10             	add    $0x10,%esp
80100b4e:	85 c0                	test   %eax,%eax
80100b50:	0f 84 08 03 00 00    	je     80100e5e <exec+0x33e>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100b56:	83 ec 0c             	sub    $0xc,%esp
80100b59:	89 c3                	mov    %eax,%ebx
80100b5b:	50                   	push   %eax
80100b5c:	e8 af 0c 00 00       	call   80101810 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100b61:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100b67:	6a 34                	push   $0x34
80100b69:	6a 00                	push   $0x0
80100b6b:	50                   	push   %eax
80100b6c:	53                   	push   %ebx
80100b6d:	e8 9e 0f 00 00       	call   80101b10 <readi>
80100b72:	83 c4 20             	add    $0x20,%esp
80100b75:	83 f8 34             	cmp    $0x34,%eax
80100b78:	74 26                	je     80100ba0 <exec+0x80>
    }
    #endif
    freevm(pgdir);
  }
  if(ip){
    iunlockput(ip);
80100b7a:	83 ec 0c             	sub    $0xc,%esp
80100b7d:	53                   	push   %ebx
80100b7e:	e8 2d 0f 00 00       	call   80101ab0 <iunlockput>
    end_op();
80100b83:	e8 d8 26 00 00       	call   80103260 <end_op>
80100b88:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100b8b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b90:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b93:	5b                   	pop    %ebx
80100b94:	5e                   	pop    %esi
80100b95:	5f                   	pop    %edi
80100b96:	5d                   	pop    %ebp
80100b97:	c3                   	ret    
80100b98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b9f:	90                   	nop
  if(elf.magic != ELF_MAGIC)
80100ba0:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100ba7:	45 4c 46 
80100baa:	75 ce                	jne    80100b7a <exec+0x5a>
  if((pgdir = setupkvm()) == 0)
80100bac:	e8 ff 6a 00 00       	call   801076b0 <setupkvm>
80100bb1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100bb7:	85 c0                	test   %eax,%eax
80100bb9:	74 bf                	je     80100b7a <exec+0x5a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bbb:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100bc2:	00 
80100bc3:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100bc9:	0f 84 ae 02 00 00    	je     80100e7d <exec+0x35d>
  sz = 0;
80100bcf:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100bd6:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bd9:	31 ff                	xor    %edi,%edi
80100bdb:	e9 86 00 00 00       	jmp    80100c66 <exec+0x146>
    if(ph.type != ELF_PROG_LOAD)
80100be0:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100be7:	75 6c                	jne    80100c55 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100be9:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100bef:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100bf5:	0f 82 87 00 00 00    	jb     80100c82 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100bfb:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100c01:	72 7f                	jb     80100c82 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100c03:	83 ec 04             	sub    $0x4,%esp
80100c06:	50                   	push   %eax
80100c07:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c0d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100c13:	e8 b8 68 00 00       	call   801074d0 <allocuvm>
80100c18:	83 c4 10             	add    $0x10,%esp
80100c1b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100c21:	85 c0                	test   %eax,%eax
80100c23:	74 5d                	je     80100c82 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100c25:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100c2b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100c30:	75 50                	jne    80100c82 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c32:	83 ec 0c             	sub    $0xc,%esp
80100c35:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100c3b:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100c41:	53                   	push   %ebx
80100c42:	50                   	push   %eax
80100c43:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100c49:	e8 b2 67 00 00       	call   80107400 <loaduvm>
80100c4e:	83 c4 20             	add    $0x20,%esp
80100c51:	85 c0                	test   %eax,%eax
80100c53:	78 2d                	js     80100c82 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c55:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100c5c:	83 c7 01             	add    $0x1,%edi
80100c5f:	83 c6 20             	add    $0x20,%esi
80100c62:	39 f8                	cmp    %edi,%eax
80100c64:	7e 3a                	jle    80100ca0 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c66:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100c6c:	6a 20                	push   $0x20
80100c6e:	56                   	push   %esi
80100c6f:	50                   	push   %eax
80100c70:	53                   	push   %ebx
80100c71:	e8 9a 0e 00 00       	call   80101b10 <readi>
80100c76:	83 c4 10             	add    $0x10,%esp
80100c79:	83 f8 20             	cmp    $0x20,%eax
80100c7c:	0f 84 5e ff ff ff    	je     80100be0 <exec+0xc0>
    freevm(pgdir);
80100c82:	83 ec 0c             	sub    $0xc,%esp
80100c85:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100c8b:	e8 a0 69 00 00       	call   80107630 <freevm>
  if(ip){
80100c90:	83 c4 10             	add    $0x10,%esp
80100c93:	e9 e2 fe ff ff       	jmp    80100b7a <exec+0x5a>
80100c98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c9f:	90                   	nop
80100ca0:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100ca6:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100cac:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100cb2:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100cb8:	83 ec 0c             	sub    $0xc,%esp
80100cbb:	53                   	push   %ebx
80100cbc:	e8 ef 0d 00 00       	call   80101ab0 <iunlockput>
  end_op();
80100cc1:	e8 9a 25 00 00       	call   80103260 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0){
80100cc6:	83 c4 0c             	add    $0xc,%esp
80100cc9:	56                   	push   %esi
80100cca:	57                   	push   %edi
80100ccb:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cd1:	57                   	push   %edi
80100cd2:	e8 f9 67 00 00       	call   801074d0 <allocuvm>
80100cd7:	83 c4 10             	add    $0x10,%esp
80100cda:	89 c6                	mov    %eax,%esi
80100cdc:	85 c0                	test   %eax,%eax
80100cde:	0f 84 94 00 00 00    	je     80100d78 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100ce4:	83 ec 08             	sub    $0x8,%esp
80100ce7:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100ced:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cef:	50                   	push   %eax
80100cf0:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100cf1:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cf3:	e8 58 6a 00 00       	call   80107750 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100cf8:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cfb:	83 c4 10             	add    $0x10,%esp
80100cfe:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100d04:	8b 00                	mov    (%eax),%eax
80100d06:	85 c0                	test   %eax,%eax
80100d08:	0f 84 8b 00 00 00    	je     80100d99 <exec+0x279>
80100d0e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100d14:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100d1a:	eb 23                	jmp    80100d3f <exec+0x21f>
80100d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100d20:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100d23:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100d2a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100d2d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100d33:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100d36:	85 c0                	test   %eax,%eax
80100d38:	74 59                	je     80100d93 <exec+0x273>
    if(argc >= MAXARG)
80100d3a:	83 ff 20             	cmp    $0x20,%edi
80100d3d:	74 39                	je     80100d78 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d3f:	83 ec 0c             	sub    $0xc,%esp
80100d42:	50                   	push   %eax
80100d43:	e8 68 40 00 00       	call   80104db0 <strlen>
80100d48:	f7 d0                	not    %eax
80100d4a:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d4c:	58                   	pop    %eax
80100d4d:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d50:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d53:	ff 34 b8             	pushl  (%eax,%edi,4)
80100d56:	e8 55 40 00 00       	call   80104db0 <strlen>
80100d5b:	83 c0 01             	add    $0x1,%eax
80100d5e:	50                   	push   %eax
80100d5f:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d62:	ff 34 b8             	pushl  (%eax,%edi,4)
80100d65:	53                   	push   %ebx
80100d66:	56                   	push   %esi
80100d67:	e8 a4 6b 00 00       	call   80107910 <copyout>
80100d6c:	83 c4 20             	add    $0x20,%esp
80100d6f:	85 c0                	test   %eax,%eax
80100d71:	79 ad                	jns    80100d20 <exec+0x200>
80100d73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100d77:	90                   	nop
    freevm(pgdir);
80100d78:	83 ec 0c             	sub    $0xc,%esp
80100d7b:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100d81:	e8 aa 68 00 00       	call   80107630 <freevm>
80100d86:	83 c4 10             	add    $0x10,%esp
  return -1;
80100d89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d8e:	e9 fd fd ff ff       	jmp    80100b90 <exec+0x70>
80100d93:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d99:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100da0:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100da2:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100da9:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100dad:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100daf:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100db2:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100db8:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100dba:	50                   	push   %eax
80100dbb:	52                   	push   %edx
80100dbc:	53                   	push   %ebx
80100dbd:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100dc3:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100dca:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100dcd:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100dd3:	e8 38 6b 00 00       	call   80107910 <copyout>
80100dd8:	83 c4 10             	add    $0x10,%esp
80100ddb:	85 c0                	test   %eax,%eax
80100ddd:	78 99                	js     80100d78 <exec+0x258>
  for(last=s=path; *s; s++)
80100ddf:	8b 45 08             	mov    0x8(%ebp),%eax
80100de2:	8b 55 08             	mov    0x8(%ebp),%edx
80100de5:	0f b6 00             	movzbl (%eax),%eax
80100de8:	84 c0                	test   %al,%al
80100dea:	74 13                	je     80100dff <exec+0x2df>
80100dec:	89 d1                	mov    %edx,%ecx
80100dee:	66 90                	xchg   %ax,%ax
    if(*s == '/')
80100df0:	83 c1 01             	add    $0x1,%ecx
80100df3:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100df5:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80100df8:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100dfb:	84 c0                	test   %al,%al
80100dfd:	75 f1                	jne    80100df0 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100dff:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100e05:	83 ec 04             	sub    $0x4,%esp
80100e08:	6a 10                	push   $0x10
80100e0a:	8d 47 6c             	lea    0x6c(%edi),%eax
80100e0d:	52                   	push   %edx
80100e0e:	50                   	push   %eax
80100e0f:	e8 5c 3f 00 00       	call   80104d70 <safestrcpy>
  curproc->pgdir = pgdir;
80100e14:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  oldpgdir = curproc->pgdir;
80100e1a:	89 f9                	mov    %edi,%ecx
80100e1c:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100e1f:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
80100e21:	89 41 04             	mov    %eax,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100e24:	8b 41 18             	mov    0x18(%ecx),%eax
80100e27:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100e2d:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100e30:	8b 41 18             	mov    0x18(%ecx),%eax
80100e33:	89 58 44             	mov    %ebx,0x44(%eax)
  lcr3(V2P(pgdir));
80100e36:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100e3c:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80100e41:	0f 22 d8             	mov    %eax,%cr3
  switchuvm(curproc);
80100e44:	89 0c 24             	mov    %ecx,(%esp)
80100e47:	e8 24 64 00 00       	call   80107270 <switchuvm>
  freevm(oldpgdir);
80100e4c:	89 3c 24             	mov    %edi,(%esp)
80100e4f:	e8 dc 67 00 00       	call   80107630 <freevm>
  return 0;
80100e54:	83 c4 10             	add    $0x10,%esp
80100e57:	31 c0                	xor    %eax,%eax
80100e59:	e9 32 fd ff ff       	jmp    80100b90 <exec+0x70>
    end_op();
80100e5e:	e8 fd 23 00 00       	call   80103260 <end_op>
    cprintf("exec: fail\n");
80100e63:	83 ec 0c             	sub    $0xc,%esp
80100e66:	68 a1 7a 10 80       	push   $0x80107aa1
80100e6b:	e8 40 f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100e70:	83 c4 10             	add    $0x10,%esp
80100e73:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100e78:	e9 13 fd ff ff       	jmp    80100b90 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e7d:	31 ff                	xor    %edi,%edi
80100e7f:	be 00 20 00 00       	mov    $0x2000,%esi
80100e84:	e9 2f fe ff ff       	jmp    80100cb8 <exec+0x198>
80100e89:	66 90                	xchg   %ax,%ax
80100e8b:	66 90                	xchg   %ax,%ax
80100e8d:	66 90                	xchg   %ax,%ax
80100e8f:	90                   	nop

80100e90 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e90:	f3 0f 1e fb          	endbr32 
80100e94:	55                   	push   %ebp
80100e95:	89 e5                	mov    %esp,%ebp
80100e97:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e9a:	68 ad 7a 10 80       	push   $0x80107aad
80100e9f:	68 00 f0 11 80       	push   $0x8011f000
80100ea4:	e8 77 3a 00 00       	call   80104920 <initlock>
}
80100ea9:	83 c4 10             	add    $0x10,%esp
80100eac:	c9                   	leave  
80100ead:	c3                   	ret    
80100eae:	66 90                	xchg   %ax,%ax

80100eb0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100eb0:	f3 0f 1e fb          	endbr32 
80100eb4:	55                   	push   %ebp
80100eb5:	89 e5                	mov    %esp,%ebp
80100eb7:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100eb8:	bb 34 f0 11 80       	mov    $0x8011f034,%ebx
{
80100ebd:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100ec0:	68 00 f0 11 80       	push   $0x8011f000
80100ec5:	e8 d6 3b 00 00       	call   80104aa0 <acquire>
80100eca:	83 c4 10             	add    $0x10,%esp
80100ecd:	eb 0c                	jmp    80100edb <filealloc+0x2b>
80100ecf:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ed0:	83 c3 18             	add    $0x18,%ebx
80100ed3:	81 fb 94 f9 11 80    	cmp    $0x8011f994,%ebx
80100ed9:	74 25                	je     80100f00 <filealloc+0x50>
    if(f->ref == 0){
80100edb:	8b 43 04             	mov    0x4(%ebx),%eax
80100ede:	85 c0                	test   %eax,%eax
80100ee0:	75 ee                	jne    80100ed0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100ee2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100ee5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100eec:	68 00 f0 11 80       	push   $0x8011f000
80100ef1:	e8 6a 3c 00 00       	call   80104b60 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100ef6:	89 d8                	mov    %ebx,%eax
      return f;
80100ef8:	83 c4 10             	add    $0x10,%esp
}
80100efb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100efe:	c9                   	leave  
80100eff:	c3                   	ret    
  release(&ftable.lock);
80100f00:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100f03:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100f05:	68 00 f0 11 80       	push   $0x8011f000
80100f0a:	e8 51 3c 00 00       	call   80104b60 <release>
}
80100f0f:	89 d8                	mov    %ebx,%eax
  return 0;
80100f11:	83 c4 10             	add    $0x10,%esp
}
80100f14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f17:	c9                   	leave  
80100f18:	c3                   	ret    
80100f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100f20 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100f20:	f3 0f 1e fb          	endbr32 
80100f24:	55                   	push   %ebp
80100f25:	89 e5                	mov    %esp,%ebp
80100f27:	53                   	push   %ebx
80100f28:	83 ec 10             	sub    $0x10,%esp
80100f2b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100f2e:	68 00 f0 11 80       	push   $0x8011f000
80100f33:	e8 68 3b 00 00       	call   80104aa0 <acquire>
  if(f->ref < 1)
80100f38:	8b 43 04             	mov    0x4(%ebx),%eax
80100f3b:	83 c4 10             	add    $0x10,%esp
80100f3e:	85 c0                	test   %eax,%eax
80100f40:	7e 1a                	jle    80100f5c <filedup+0x3c>
    panic("filedup");
  f->ref++;
80100f42:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100f45:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100f48:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100f4b:	68 00 f0 11 80       	push   $0x8011f000
80100f50:	e8 0b 3c 00 00       	call   80104b60 <release>
  return f;
}
80100f55:	89 d8                	mov    %ebx,%eax
80100f57:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f5a:	c9                   	leave  
80100f5b:	c3                   	ret    
    panic("filedup");
80100f5c:	83 ec 0c             	sub    $0xc,%esp
80100f5f:	68 b4 7a 10 80       	push   $0x80107ab4
80100f64:	e8 27 f4 ff ff       	call   80100390 <panic>
80100f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100f70 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f70:	f3 0f 1e fb          	endbr32 
80100f74:	55                   	push   %ebp
80100f75:	89 e5                	mov    %esp,%ebp
80100f77:	57                   	push   %edi
80100f78:	56                   	push   %esi
80100f79:	53                   	push   %ebx
80100f7a:	83 ec 28             	sub    $0x28,%esp
80100f7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f80:	68 00 f0 11 80       	push   $0x8011f000
80100f85:	e8 16 3b 00 00       	call   80104aa0 <acquire>
  if(f->ref < 1)
80100f8a:	8b 53 04             	mov    0x4(%ebx),%edx
80100f8d:	83 c4 10             	add    $0x10,%esp
80100f90:	85 d2                	test   %edx,%edx
80100f92:	0f 8e a1 00 00 00    	jle    80101039 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f98:	83 ea 01             	sub    $0x1,%edx
80100f9b:	89 53 04             	mov    %edx,0x4(%ebx)
80100f9e:	75 40                	jne    80100fe0 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100fa0:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100fa4:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100fa7:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100fa9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100faf:	8b 73 0c             	mov    0xc(%ebx),%esi
80100fb2:	88 45 e7             	mov    %al,-0x19(%ebp)
80100fb5:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100fb8:	68 00 f0 11 80       	push   $0x8011f000
  ff = *f;
80100fbd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100fc0:	e8 9b 3b 00 00       	call   80104b60 <release>

  if(ff.type == FD_PIPE)
80100fc5:	83 c4 10             	add    $0x10,%esp
80100fc8:	83 ff 01             	cmp    $0x1,%edi
80100fcb:	74 53                	je     80101020 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100fcd:	83 ff 02             	cmp    $0x2,%edi
80100fd0:	74 26                	je     80100ff8 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100fd2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fd5:	5b                   	pop    %ebx
80100fd6:	5e                   	pop    %esi
80100fd7:	5f                   	pop    %edi
80100fd8:	5d                   	pop    %ebp
80100fd9:	c3                   	ret    
80100fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100fe0:	c7 45 08 00 f0 11 80 	movl   $0x8011f000,0x8(%ebp)
}
80100fe7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fea:	5b                   	pop    %ebx
80100feb:	5e                   	pop    %esi
80100fec:	5f                   	pop    %edi
80100fed:	5d                   	pop    %ebp
    release(&ftable.lock);
80100fee:	e9 6d 3b 00 00       	jmp    80104b60 <release>
80100ff3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100ff7:	90                   	nop
    begin_op();
80100ff8:	e8 f3 21 00 00       	call   801031f0 <begin_op>
    iput(ff.ip);
80100ffd:	83 ec 0c             	sub    $0xc,%esp
80101000:	ff 75 e0             	pushl  -0x20(%ebp)
80101003:	e8 38 09 00 00       	call   80101940 <iput>
    end_op();
80101008:	83 c4 10             	add    $0x10,%esp
}
8010100b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010100e:	5b                   	pop    %ebx
8010100f:	5e                   	pop    %esi
80101010:	5f                   	pop    %edi
80101011:	5d                   	pop    %ebp
    end_op();
80101012:	e9 49 22 00 00       	jmp    80103260 <end_op>
80101017:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010101e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80101020:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80101024:	83 ec 08             	sub    $0x8,%esp
80101027:	53                   	push   %ebx
80101028:	56                   	push   %esi
80101029:	e8 a2 29 00 00       	call   801039d0 <pipeclose>
8010102e:	83 c4 10             	add    $0x10,%esp
}
80101031:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101034:	5b                   	pop    %ebx
80101035:	5e                   	pop    %esi
80101036:	5f                   	pop    %edi
80101037:	5d                   	pop    %ebp
80101038:	c3                   	ret    
    panic("fileclose");
80101039:	83 ec 0c             	sub    $0xc,%esp
8010103c:	68 bc 7a 10 80       	push   $0x80107abc
80101041:	e8 4a f3 ff ff       	call   80100390 <panic>
80101046:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010104d:	8d 76 00             	lea    0x0(%esi),%esi

80101050 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101050:	f3 0f 1e fb          	endbr32 
80101054:	55                   	push   %ebp
80101055:	89 e5                	mov    %esp,%ebp
80101057:	53                   	push   %ebx
80101058:	83 ec 04             	sub    $0x4,%esp
8010105b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010105e:	83 3b 02             	cmpl   $0x2,(%ebx)
80101061:	75 2d                	jne    80101090 <filestat+0x40>
    ilock(f->ip);
80101063:	83 ec 0c             	sub    $0xc,%esp
80101066:	ff 73 10             	pushl  0x10(%ebx)
80101069:	e8 a2 07 00 00       	call   80101810 <ilock>
    stati(f->ip, st);
8010106e:	58                   	pop    %eax
8010106f:	5a                   	pop    %edx
80101070:	ff 75 0c             	pushl  0xc(%ebp)
80101073:	ff 73 10             	pushl  0x10(%ebx)
80101076:	e8 65 0a 00 00       	call   80101ae0 <stati>
    iunlock(f->ip);
8010107b:	59                   	pop    %ecx
8010107c:	ff 73 10             	pushl  0x10(%ebx)
8010107f:	e8 6c 08 00 00       	call   801018f0 <iunlock>
    return 0;
  }
  return -1;
}
80101084:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101087:	83 c4 10             	add    $0x10,%esp
8010108a:	31 c0                	xor    %eax,%eax
}
8010108c:	c9                   	leave  
8010108d:	c3                   	ret    
8010108e:	66 90                	xchg   %ax,%ax
80101090:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101093:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101098:	c9                   	leave  
80101099:	c3                   	ret    
8010109a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801010a0 <fileread>:

// Read from file f.
int
fileread(struct file* f, char *addr, int n)
{
801010a0:	f3 0f 1e fb          	endbr32 
801010a4:	55                   	push   %ebp
801010a5:	89 e5                	mov    %esp,%ebp
801010a7:	57                   	push   %edi
801010a8:	56                   	push   %esi
801010a9:	53                   	push   %ebx
801010aa:	83 ec 0c             	sub    $0xc,%esp
801010ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010b0:	8b 75 0c             	mov    0xc(%ebp),%esi
801010b3:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
801010b6:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
801010ba:	74 64                	je     80101120 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
801010bc:	8b 03                	mov    (%ebx),%eax
801010be:	83 f8 01             	cmp    $0x1,%eax
801010c1:	74 45                	je     80101108 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010c3:	83 f8 02             	cmp    $0x2,%eax
801010c6:	75 5f                	jne    80101127 <fileread+0x87>
    ilock(f->ip);
801010c8:	83 ec 0c             	sub    $0xc,%esp
801010cb:	ff 73 10             	pushl  0x10(%ebx)
801010ce:	e8 3d 07 00 00       	call   80101810 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801010d3:	57                   	push   %edi
801010d4:	ff 73 14             	pushl  0x14(%ebx)
801010d7:	56                   	push   %esi
801010d8:	ff 73 10             	pushl  0x10(%ebx)
801010db:	e8 30 0a 00 00       	call   80101b10 <readi>
801010e0:	83 c4 20             	add    $0x20,%esp
801010e3:	89 c6                	mov    %eax,%esi
801010e5:	85 c0                	test   %eax,%eax
801010e7:	7e 03                	jle    801010ec <fileread+0x4c>
      f->off += r;
801010e9:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801010ec:	83 ec 0c             	sub    $0xc,%esp
801010ef:	ff 73 10             	pushl  0x10(%ebx)
801010f2:	e8 f9 07 00 00       	call   801018f0 <iunlock>
    return r;
801010f7:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801010fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010fd:	89 f0                	mov    %esi,%eax
801010ff:	5b                   	pop    %ebx
80101100:	5e                   	pop    %esi
80101101:	5f                   	pop    %edi
80101102:	5d                   	pop    %ebp
80101103:	c3                   	ret    
80101104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
80101108:	8b 43 0c             	mov    0xc(%ebx),%eax
8010110b:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010110e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101111:	5b                   	pop    %ebx
80101112:	5e                   	pop    %esi
80101113:	5f                   	pop    %edi
80101114:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80101115:	e9 56 2a 00 00       	jmp    80103b70 <piperead>
8010111a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101120:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101125:	eb d3                	jmp    801010fa <fileread+0x5a>
  panic("fileread");
80101127:	83 ec 0c             	sub    $0xc,%esp
8010112a:	68 c6 7a 10 80       	push   $0x80107ac6
8010112f:	e8 5c f2 ff ff       	call   80100390 <panic>
80101134:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010113b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010113f:	90                   	nop

80101140 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101140:	f3 0f 1e fb          	endbr32 
80101144:	55                   	push   %ebp
80101145:	89 e5                	mov    %esp,%ebp
80101147:	57                   	push   %edi
80101148:	56                   	push   %esi
80101149:	53                   	push   %ebx
8010114a:	83 ec 1c             	sub    $0x1c,%esp
8010114d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101150:	8b 75 08             	mov    0x8(%ebp),%esi
80101153:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101156:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101159:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
8010115d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
80101160:	0f 84 c1 00 00 00    	je     80101227 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
80101166:	8b 06                	mov    (%esi),%eax
80101168:	83 f8 01             	cmp    $0x1,%eax
8010116b:	0f 84 c3 00 00 00    	je     80101234 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101171:	83 f8 02             	cmp    $0x2,%eax
80101174:	0f 85 cc 00 00 00    	jne    80101246 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010117a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
8010117d:	31 ff                	xor    %edi,%edi
    while(i < n){
8010117f:	85 c0                	test   %eax,%eax
80101181:	7f 34                	jg     801011b7 <filewrite+0x77>
80101183:	e9 98 00 00 00       	jmp    80101220 <filewrite+0xe0>
80101188:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010118f:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101190:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
80101193:	83 ec 0c             	sub    $0xc,%esp
80101196:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101199:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
8010119c:	e8 4f 07 00 00       	call   801018f0 <iunlock>
      end_op();
801011a1:	e8 ba 20 00 00       	call   80103260 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801011a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011a9:	83 c4 10             	add    $0x10,%esp
801011ac:	39 c3                	cmp    %eax,%ebx
801011ae:	75 60                	jne    80101210 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
801011b0:	01 df                	add    %ebx,%edi
    while(i < n){
801011b2:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801011b5:	7e 69                	jle    80101220 <filewrite+0xe0>
      int n1 = n - i;
801011b7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801011ba:	b8 00 06 00 00       	mov    $0x600,%eax
801011bf:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
801011c1:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
801011c7:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
801011ca:	e8 21 20 00 00       	call   801031f0 <begin_op>
      ilock(f->ip);
801011cf:	83 ec 0c             	sub    $0xc,%esp
801011d2:	ff 76 10             	pushl  0x10(%esi)
801011d5:	e8 36 06 00 00       	call   80101810 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801011da:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011dd:	53                   	push   %ebx
801011de:	ff 76 14             	pushl  0x14(%esi)
801011e1:	01 f8                	add    %edi,%eax
801011e3:	50                   	push   %eax
801011e4:	ff 76 10             	pushl  0x10(%esi)
801011e7:	e8 24 0a 00 00       	call   80101c10 <writei>
801011ec:	83 c4 20             	add    $0x20,%esp
801011ef:	85 c0                	test   %eax,%eax
801011f1:	7f 9d                	jg     80101190 <filewrite+0x50>
      iunlock(f->ip);
801011f3:	83 ec 0c             	sub    $0xc,%esp
801011f6:	ff 76 10             	pushl  0x10(%esi)
801011f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801011fc:	e8 ef 06 00 00       	call   801018f0 <iunlock>
      end_op();
80101201:	e8 5a 20 00 00       	call   80103260 <end_op>
      if(r < 0)
80101206:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101209:	83 c4 10             	add    $0x10,%esp
8010120c:	85 c0                	test   %eax,%eax
8010120e:	75 17                	jne    80101227 <filewrite+0xe7>
        panic("short filewrite");
80101210:	83 ec 0c             	sub    $0xc,%esp
80101213:	68 cf 7a 10 80       	push   $0x80107acf
80101218:	e8 73 f1 ff ff       	call   80100390 <panic>
8010121d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101220:	89 f8                	mov    %edi,%eax
80101222:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101225:	74 05                	je     8010122c <filewrite+0xec>
80101227:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
8010122c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010122f:	5b                   	pop    %ebx
80101230:	5e                   	pop    %esi
80101231:	5f                   	pop    %edi
80101232:	5d                   	pop    %ebp
80101233:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
80101234:	8b 46 0c             	mov    0xc(%esi),%eax
80101237:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010123a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010123d:	5b                   	pop    %ebx
8010123e:	5e                   	pop    %esi
8010123f:	5f                   	pop    %edi
80101240:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101241:	e9 2a 28 00 00       	jmp    80103a70 <pipewrite>
  panic("filewrite");
80101246:	83 ec 0c             	sub    $0xc,%esp
80101249:	68 d5 7a 10 80       	push   $0x80107ad5
8010124e:	e8 3d f1 ff ff       	call   80100390 <panic>
80101253:	66 90                	xchg   %ax,%ax
80101255:	66 90                	xchg   %ax,%ax
80101257:	66 90                	xchg   %ax,%ax
80101259:	66 90                	xchg   %ax,%ax
8010125b:	66 90                	xchg   %ax,%ax
8010125d:	66 90                	xchg   %ax,%ax
8010125f:	90                   	nop

80101260 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101260:	55                   	push   %ebp
80101261:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101263:	89 d0                	mov    %edx,%eax
80101265:	c1 e8 0c             	shr    $0xc,%eax
80101268:	03 05 18 fa 11 80    	add    0x8011fa18,%eax
{
8010126e:	89 e5                	mov    %esp,%ebp
80101270:	56                   	push   %esi
80101271:	53                   	push   %ebx
80101272:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101274:	83 ec 08             	sub    $0x8,%esp
80101277:	50                   	push   %eax
80101278:	51                   	push   %ecx
80101279:	e8 52 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010127e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101280:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101283:	ba 01 00 00 00       	mov    $0x1,%edx
80101288:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
8010128b:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80101291:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101294:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101296:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
8010129b:	85 d1                	test   %edx,%ecx
8010129d:	74 25                	je     801012c4 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010129f:	f7 d2                	not    %edx
  log_write(bp);
801012a1:	83 ec 0c             	sub    $0xc,%esp
801012a4:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
801012a6:	21 ca                	and    %ecx,%edx
801012a8:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
801012ac:	50                   	push   %eax
801012ad:	e8 1e 21 00 00       	call   801033d0 <log_write>
  brelse(bp);
801012b2:	89 34 24             	mov    %esi,(%esp)
801012b5:	e8 36 ef ff ff       	call   801001f0 <brelse>
}
801012ba:	83 c4 10             	add    $0x10,%esp
801012bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801012c0:	5b                   	pop    %ebx
801012c1:	5e                   	pop    %esi
801012c2:	5d                   	pop    %ebp
801012c3:	c3                   	ret    
    panic("freeing free block");
801012c4:	83 ec 0c             	sub    $0xc,%esp
801012c7:	68 df 7a 10 80       	push   $0x80107adf
801012cc:	e8 bf f0 ff ff       	call   80100390 <panic>
801012d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801012d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801012df:	90                   	nop

801012e0 <balloc>:
{
801012e0:	55                   	push   %ebp
801012e1:	89 e5                	mov    %esp,%ebp
801012e3:	57                   	push   %edi
801012e4:	56                   	push   %esi
801012e5:	53                   	push   %ebx
801012e6:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
801012e9:	8b 0d 00 fa 11 80    	mov    0x8011fa00,%ecx
{
801012ef:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801012f2:	85 c9                	test   %ecx,%ecx
801012f4:	0f 84 87 00 00 00    	je     80101381 <balloc+0xa1>
801012fa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101301:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101304:	83 ec 08             	sub    $0x8,%esp
80101307:	89 f0                	mov    %esi,%eax
80101309:	c1 f8 0c             	sar    $0xc,%eax
8010130c:	03 05 18 fa 11 80    	add    0x8011fa18,%eax
80101312:	50                   	push   %eax
80101313:	ff 75 d8             	pushl  -0x28(%ebp)
80101316:	e8 b5 ed ff ff       	call   801000d0 <bread>
8010131b:	83 c4 10             	add    $0x10,%esp
8010131e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101321:	a1 00 fa 11 80       	mov    0x8011fa00,%eax
80101326:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101329:	31 c0                	xor    %eax,%eax
8010132b:	eb 2f                	jmp    8010135c <balloc+0x7c>
8010132d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101330:	89 c1                	mov    %eax,%ecx
80101332:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101337:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010133a:	83 e1 07             	and    $0x7,%ecx
8010133d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010133f:	89 c1                	mov    %eax,%ecx
80101341:	c1 f9 03             	sar    $0x3,%ecx
80101344:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101349:	89 fa                	mov    %edi,%edx
8010134b:	85 df                	test   %ebx,%edi
8010134d:	74 41                	je     80101390 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010134f:	83 c0 01             	add    $0x1,%eax
80101352:	83 c6 01             	add    $0x1,%esi
80101355:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010135a:	74 05                	je     80101361 <balloc+0x81>
8010135c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010135f:	77 cf                	ja     80101330 <balloc+0x50>
    brelse(bp);
80101361:	83 ec 0c             	sub    $0xc,%esp
80101364:	ff 75 e4             	pushl  -0x1c(%ebp)
80101367:	e8 84 ee ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010136c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101373:	83 c4 10             	add    $0x10,%esp
80101376:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101379:	39 05 00 fa 11 80    	cmp    %eax,0x8011fa00
8010137f:	77 80                	ja     80101301 <balloc+0x21>
  panic("balloc: out of blocks");
80101381:	83 ec 0c             	sub    $0xc,%esp
80101384:	68 f2 7a 10 80       	push   $0x80107af2
80101389:	e8 02 f0 ff ff       	call   80100390 <panic>
8010138e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101390:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101393:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101396:	09 da                	or     %ebx,%edx
80101398:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010139c:	57                   	push   %edi
8010139d:	e8 2e 20 00 00       	call   801033d0 <log_write>
        brelse(bp);
801013a2:	89 3c 24             	mov    %edi,(%esp)
801013a5:	e8 46 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801013aa:	58                   	pop    %eax
801013ab:	5a                   	pop    %edx
801013ac:	56                   	push   %esi
801013ad:	ff 75 d8             	pushl  -0x28(%ebp)
801013b0:	e8 1b ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801013b5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
801013b8:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801013ba:	8d 40 5c             	lea    0x5c(%eax),%eax
801013bd:	68 00 02 00 00       	push   $0x200
801013c2:	6a 00                	push   $0x0
801013c4:	50                   	push   %eax
801013c5:	e8 e6 37 00 00       	call   80104bb0 <memset>
  log_write(bp);
801013ca:	89 1c 24             	mov    %ebx,(%esp)
801013cd:	e8 fe 1f 00 00       	call   801033d0 <log_write>
  brelse(bp);
801013d2:	89 1c 24             	mov    %ebx,(%esp)
801013d5:	e8 16 ee ff ff       	call   801001f0 <brelse>
}
801013da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013dd:	89 f0                	mov    %esi,%eax
801013df:	5b                   	pop    %ebx
801013e0:	5e                   	pop    %esi
801013e1:	5f                   	pop    %edi
801013e2:	5d                   	pop    %ebp
801013e3:	c3                   	ret    
801013e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801013eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013ef:	90                   	nop

801013f0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801013f0:	55                   	push   %ebp
801013f1:	89 e5                	mov    %esp,%ebp
801013f3:	57                   	push   %edi
801013f4:	89 c7                	mov    %eax,%edi
801013f6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801013f7:	31 f6                	xor    %esi,%esi
{
801013f9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013fa:	bb 54 fa 11 80       	mov    $0x8011fa54,%ebx
{
801013ff:	83 ec 28             	sub    $0x28,%esp
80101402:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101405:	68 20 fa 11 80       	push   $0x8011fa20
8010140a:	e8 91 36 00 00       	call   80104aa0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010140f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101412:	83 c4 10             	add    $0x10,%esp
80101415:	eb 1b                	jmp    80101432 <iget+0x42>
80101417:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010141e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101420:	39 3b                	cmp    %edi,(%ebx)
80101422:	74 6c                	je     80101490 <iget+0xa0>
80101424:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010142a:	81 fb 74 16 12 80    	cmp    $0x80121674,%ebx
80101430:	73 26                	jae    80101458 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101432:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101435:	85 c9                	test   %ecx,%ecx
80101437:	7f e7                	jg     80101420 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101439:	85 f6                	test   %esi,%esi
8010143b:	75 e7                	jne    80101424 <iget+0x34>
8010143d:	89 d8                	mov    %ebx,%eax
8010143f:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101445:	85 c9                	test   %ecx,%ecx
80101447:	75 6e                	jne    801014b7 <iget+0xc7>
80101449:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010144b:	81 fb 74 16 12 80    	cmp    $0x80121674,%ebx
80101451:	72 df                	jb     80101432 <iget+0x42>
80101453:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101457:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101458:	85 f6                	test   %esi,%esi
8010145a:	74 73                	je     801014cf <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010145c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010145f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101461:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101464:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010146b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101472:	68 20 fa 11 80       	push   $0x8011fa20
80101477:	e8 e4 36 00 00       	call   80104b60 <release>

  return ip;
8010147c:	83 c4 10             	add    $0x10,%esp
}
8010147f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101482:	89 f0                	mov    %esi,%eax
80101484:	5b                   	pop    %ebx
80101485:	5e                   	pop    %esi
80101486:	5f                   	pop    %edi
80101487:	5d                   	pop    %ebp
80101488:	c3                   	ret    
80101489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101490:	39 53 04             	cmp    %edx,0x4(%ebx)
80101493:	75 8f                	jne    80101424 <iget+0x34>
      release(&icache.lock);
80101495:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101498:	83 c1 01             	add    $0x1,%ecx
      return ip;
8010149b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010149d:	68 20 fa 11 80       	push   $0x8011fa20
      ip->ref++;
801014a2:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801014a5:	e8 b6 36 00 00       	call   80104b60 <release>
      return ip;
801014aa:	83 c4 10             	add    $0x10,%esp
}
801014ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014b0:	89 f0                	mov    %esi,%eax
801014b2:	5b                   	pop    %ebx
801014b3:	5e                   	pop    %esi
801014b4:	5f                   	pop    %edi
801014b5:	5d                   	pop    %ebp
801014b6:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801014b7:	81 fb 74 16 12 80    	cmp    $0x80121674,%ebx
801014bd:	73 10                	jae    801014cf <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801014bf:	8b 4b 08             	mov    0x8(%ebx),%ecx
801014c2:	85 c9                	test   %ecx,%ecx
801014c4:	0f 8f 56 ff ff ff    	jg     80101420 <iget+0x30>
801014ca:	e9 6e ff ff ff       	jmp    8010143d <iget+0x4d>
    panic("iget: no inodes");
801014cf:	83 ec 0c             	sub    $0xc,%esp
801014d2:	68 08 7b 10 80       	push   $0x80107b08
801014d7:	e8 b4 ee ff ff       	call   80100390 <panic>
801014dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801014e0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801014e0:	55                   	push   %ebp
801014e1:	89 e5                	mov    %esp,%ebp
801014e3:	57                   	push   %edi
801014e4:	56                   	push   %esi
801014e5:	89 c6                	mov    %eax,%esi
801014e7:	53                   	push   %ebx
801014e8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801014eb:	83 fa 0b             	cmp    $0xb,%edx
801014ee:	0f 86 84 00 00 00    	jbe    80101578 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801014f4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801014f7:	83 fb 7f             	cmp    $0x7f,%ebx
801014fa:	0f 87 98 00 00 00    	ja     80101598 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101500:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101506:	8b 16                	mov    (%esi),%edx
80101508:	85 c0                	test   %eax,%eax
8010150a:	74 54                	je     80101560 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010150c:	83 ec 08             	sub    $0x8,%esp
8010150f:	50                   	push   %eax
80101510:	52                   	push   %edx
80101511:	e8 ba eb ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101516:	83 c4 10             	add    $0x10,%esp
80101519:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
8010151d:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010151f:	8b 1a                	mov    (%edx),%ebx
80101521:	85 db                	test   %ebx,%ebx
80101523:	74 1b                	je     80101540 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101525:	83 ec 0c             	sub    $0xc,%esp
80101528:	57                   	push   %edi
80101529:	e8 c2 ec ff ff       	call   801001f0 <brelse>
    return addr;
8010152e:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
80101531:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101534:	89 d8                	mov    %ebx,%eax
80101536:	5b                   	pop    %ebx
80101537:	5e                   	pop    %esi
80101538:	5f                   	pop    %edi
80101539:	5d                   	pop    %ebp
8010153a:	c3                   	ret    
8010153b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010153f:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
80101540:	8b 06                	mov    (%esi),%eax
80101542:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101545:	e8 96 fd ff ff       	call   801012e0 <balloc>
8010154a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
8010154d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101550:	89 c3                	mov    %eax,%ebx
80101552:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101554:	57                   	push   %edi
80101555:	e8 76 1e 00 00       	call   801033d0 <log_write>
8010155a:	83 c4 10             	add    $0x10,%esp
8010155d:	eb c6                	jmp    80101525 <bmap+0x45>
8010155f:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101560:	89 d0                	mov    %edx,%eax
80101562:	e8 79 fd ff ff       	call   801012e0 <balloc>
80101567:	8b 16                	mov    (%esi),%edx
80101569:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010156f:	eb 9b                	jmp    8010150c <bmap+0x2c>
80101571:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
80101578:	8d 3c 90             	lea    (%eax,%edx,4),%edi
8010157b:	8b 5f 5c             	mov    0x5c(%edi),%ebx
8010157e:	85 db                	test   %ebx,%ebx
80101580:	75 af                	jne    80101531 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101582:	8b 00                	mov    (%eax),%eax
80101584:	e8 57 fd ff ff       	call   801012e0 <balloc>
80101589:	89 47 5c             	mov    %eax,0x5c(%edi)
8010158c:	89 c3                	mov    %eax,%ebx
}
8010158e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101591:	89 d8                	mov    %ebx,%eax
80101593:	5b                   	pop    %ebx
80101594:	5e                   	pop    %esi
80101595:	5f                   	pop    %edi
80101596:	5d                   	pop    %ebp
80101597:	c3                   	ret    
  panic("bmap: out of range");
80101598:	83 ec 0c             	sub    $0xc,%esp
8010159b:	68 18 7b 10 80       	push   $0x80107b18
801015a0:	e8 eb ed ff ff       	call   80100390 <panic>
801015a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801015b0 <readsb>:
{
801015b0:	f3 0f 1e fb          	endbr32 
801015b4:	55                   	push   %ebp
801015b5:	89 e5                	mov    %esp,%ebp
801015b7:	56                   	push   %esi
801015b8:	53                   	push   %ebx
801015b9:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801015bc:	83 ec 08             	sub    $0x8,%esp
801015bf:	6a 01                	push   $0x1
801015c1:	ff 75 08             	pushl  0x8(%ebp)
801015c4:	e8 07 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015c9:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015cc:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015ce:	8d 40 5c             	lea    0x5c(%eax),%eax
801015d1:	6a 1c                	push   $0x1c
801015d3:	50                   	push   %eax
801015d4:	56                   	push   %esi
801015d5:	e8 76 36 00 00       	call   80104c50 <memmove>
  brelse(bp);
801015da:	89 5d 08             	mov    %ebx,0x8(%ebp)
801015dd:	83 c4 10             	add    $0x10,%esp
}
801015e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015e3:	5b                   	pop    %ebx
801015e4:	5e                   	pop    %esi
801015e5:	5d                   	pop    %ebp
  brelse(bp);
801015e6:	e9 05 ec ff ff       	jmp    801001f0 <brelse>
801015eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801015ef:	90                   	nop

801015f0 <iinit>:
{
801015f0:	f3 0f 1e fb          	endbr32 
801015f4:	55                   	push   %ebp
801015f5:	89 e5                	mov    %esp,%ebp
801015f7:	53                   	push   %ebx
801015f8:	bb 60 fa 11 80       	mov    $0x8011fa60,%ebx
801015fd:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101600:	68 2b 7b 10 80       	push   $0x80107b2b
80101605:	68 20 fa 11 80       	push   $0x8011fa20
8010160a:	e8 11 33 00 00       	call   80104920 <initlock>
  for(i = 0; i < NINODE; i++) {
8010160f:	83 c4 10             	add    $0x10,%esp
80101612:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101618:	83 ec 08             	sub    $0x8,%esp
8010161b:	68 32 7b 10 80       	push   $0x80107b32
80101620:	53                   	push   %ebx
80101621:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101627:	e8 b4 31 00 00       	call   801047e0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
8010162c:	83 c4 10             	add    $0x10,%esp
8010162f:	81 fb 80 16 12 80    	cmp    $0x80121680,%ebx
80101635:	75 e1                	jne    80101618 <iinit+0x28>
  readsb(dev, &sb);
80101637:	83 ec 08             	sub    $0x8,%esp
8010163a:	68 00 fa 11 80       	push   $0x8011fa00
8010163f:	ff 75 08             	pushl  0x8(%ebp)
80101642:	e8 69 ff ff ff       	call   801015b0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101647:	ff 35 18 fa 11 80    	pushl  0x8011fa18
8010164d:	ff 35 14 fa 11 80    	pushl  0x8011fa14
80101653:	ff 35 10 fa 11 80    	pushl  0x8011fa10
80101659:	ff 35 0c fa 11 80    	pushl  0x8011fa0c
8010165f:	ff 35 08 fa 11 80    	pushl  0x8011fa08
80101665:	ff 35 04 fa 11 80    	pushl  0x8011fa04
8010166b:	ff 35 00 fa 11 80    	pushl  0x8011fa00
80101671:	68 dc 7b 10 80       	push   $0x80107bdc
80101676:	e8 35 f0 ff ff       	call   801006b0 <cprintf>
}
8010167b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010167e:	83 c4 30             	add    $0x30,%esp
80101681:	c9                   	leave  
80101682:	c3                   	ret    
80101683:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010168a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101690 <ialloc>:
{
80101690:	f3 0f 1e fb          	endbr32 
80101694:	55                   	push   %ebp
80101695:	89 e5                	mov    %esp,%ebp
80101697:	57                   	push   %edi
80101698:	56                   	push   %esi
80101699:	53                   	push   %ebx
8010169a:	83 ec 1c             	sub    $0x1c,%esp
8010169d:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
801016a0:	83 3d 08 fa 11 80 01 	cmpl   $0x1,0x8011fa08
{
801016a7:	8b 75 08             	mov    0x8(%ebp),%esi
801016aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801016ad:	0f 86 8d 00 00 00    	jbe    80101740 <ialloc+0xb0>
801016b3:	bf 01 00 00 00       	mov    $0x1,%edi
801016b8:	eb 1d                	jmp    801016d7 <ialloc+0x47>
801016ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
801016c0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801016c3:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
801016c6:	53                   	push   %ebx
801016c7:	e8 24 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801016cc:	83 c4 10             	add    $0x10,%esp
801016cf:	3b 3d 08 fa 11 80    	cmp    0x8011fa08,%edi
801016d5:	73 69                	jae    80101740 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801016d7:	89 f8                	mov    %edi,%eax
801016d9:	83 ec 08             	sub    $0x8,%esp
801016dc:	c1 e8 03             	shr    $0x3,%eax
801016df:	03 05 14 fa 11 80    	add    0x8011fa14,%eax
801016e5:	50                   	push   %eax
801016e6:	56                   	push   %esi
801016e7:	e8 e4 e9 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
801016ec:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
801016ef:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
801016f1:	89 f8                	mov    %edi,%eax
801016f3:	83 e0 07             	and    $0x7,%eax
801016f6:	c1 e0 06             	shl    $0x6,%eax
801016f9:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801016fd:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101701:	75 bd                	jne    801016c0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101703:	83 ec 04             	sub    $0x4,%esp
80101706:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101709:	6a 40                	push   $0x40
8010170b:	6a 00                	push   $0x0
8010170d:	51                   	push   %ecx
8010170e:	e8 9d 34 00 00       	call   80104bb0 <memset>
      dip->type = type;
80101713:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101717:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010171a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010171d:	89 1c 24             	mov    %ebx,(%esp)
80101720:	e8 ab 1c 00 00       	call   801033d0 <log_write>
      brelse(bp);
80101725:	89 1c 24             	mov    %ebx,(%esp)
80101728:	e8 c3 ea ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010172d:	83 c4 10             	add    $0x10,%esp
}
80101730:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101733:	89 fa                	mov    %edi,%edx
}
80101735:	5b                   	pop    %ebx
      return iget(dev, inum);
80101736:	89 f0                	mov    %esi,%eax
}
80101738:	5e                   	pop    %esi
80101739:	5f                   	pop    %edi
8010173a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010173b:	e9 b0 fc ff ff       	jmp    801013f0 <iget>
  panic("ialloc: no inodes");
80101740:	83 ec 0c             	sub    $0xc,%esp
80101743:	68 38 7b 10 80       	push   $0x80107b38
80101748:	e8 43 ec ff ff       	call   80100390 <panic>
8010174d:	8d 76 00             	lea    0x0(%esi),%esi

80101750 <iupdate>:
{
80101750:	f3 0f 1e fb          	endbr32 
80101754:	55                   	push   %ebp
80101755:	89 e5                	mov    %esp,%ebp
80101757:	56                   	push   %esi
80101758:	53                   	push   %ebx
80101759:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010175c:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010175f:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101762:	83 ec 08             	sub    $0x8,%esp
80101765:	c1 e8 03             	shr    $0x3,%eax
80101768:	03 05 14 fa 11 80    	add    0x8011fa14,%eax
8010176e:	50                   	push   %eax
8010176f:	ff 73 a4             	pushl  -0x5c(%ebx)
80101772:	e8 59 e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101777:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010177b:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010177e:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101780:	8b 43 a8             	mov    -0x58(%ebx),%eax
80101783:	83 e0 07             	and    $0x7,%eax
80101786:	c1 e0 06             	shl    $0x6,%eax
80101789:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
8010178d:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101790:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101794:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101797:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
8010179b:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010179f:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801017a3:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801017a7:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801017ab:	8b 53 fc             	mov    -0x4(%ebx),%edx
801017ae:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017b1:	6a 34                	push   $0x34
801017b3:	53                   	push   %ebx
801017b4:	50                   	push   %eax
801017b5:	e8 96 34 00 00       	call   80104c50 <memmove>
  log_write(bp);
801017ba:	89 34 24             	mov    %esi,(%esp)
801017bd:	e8 0e 1c 00 00       	call   801033d0 <log_write>
  brelse(bp);
801017c2:	89 75 08             	mov    %esi,0x8(%ebp)
801017c5:	83 c4 10             	add    $0x10,%esp
}
801017c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017cb:	5b                   	pop    %ebx
801017cc:	5e                   	pop    %esi
801017cd:	5d                   	pop    %ebp
  brelse(bp);
801017ce:	e9 1d ea ff ff       	jmp    801001f0 <brelse>
801017d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801017e0 <idup>:
{
801017e0:	f3 0f 1e fb          	endbr32 
801017e4:	55                   	push   %ebp
801017e5:	89 e5                	mov    %esp,%ebp
801017e7:	53                   	push   %ebx
801017e8:	83 ec 10             	sub    $0x10,%esp
801017eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801017ee:	68 20 fa 11 80       	push   $0x8011fa20
801017f3:	e8 a8 32 00 00       	call   80104aa0 <acquire>
  ip->ref++;
801017f8:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017fc:	c7 04 24 20 fa 11 80 	movl   $0x8011fa20,(%esp)
80101803:	e8 58 33 00 00       	call   80104b60 <release>
}
80101808:	89 d8                	mov    %ebx,%eax
8010180a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010180d:	c9                   	leave  
8010180e:	c3                   	ret    
8010180f:	90                   	nop

80101810 <ilock>:
{
80101810:	f3 0f 1e fb          	endbr32 
80101814:	55                   	push   %ebp
80101815:	89 e5                	mov    %esp,%ebp
80101817:	56                   	push   %esi
80101818:	53                   	push   %ebx
80101819:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
8010181c:	85 db                	test   %ebx,%ebx
8010181e:	0f 84 b3 00 00 00    	je     801018d7 <ilock+0xc7>
80101824:	8b 53 08             	mov    0x8(%ebx),%edx
80101827:	85 d2                	test   %edx,%edx
80101829:	0f 8e a8 00 00 00    	jle    801018d7 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010182f:	83 ec 0c             	sub    $0xc,%esp
80101832:	8d 43 0c             	lea    0xc(%ebx),%eax
80101835:	50                   	push   %eax
80101836:	e8 e5 2f 00 00       	call   80104820 <acquiresleep>
  if(ip->valid == 0){
8010183b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010183e:	83 c4 10             	add    $0x10,%esp
80101841:	85 c0                	test   %eax,%eax
80101843:	74 0b                	je     80101850 <ilock+0x40>
}
80101845:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101848:	5b                   	pop    %ebx
80101849:	5e                   	pop    %esi
8010184a:	5d                   	pop    %ebp
8010184b:	c3                   	ret    
8010184c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101850:	8b 43 04             	mov    0x4(%ebx),%eax
80101853:	83 ec 08             	sub    $0x8,%esp
80101856:	c1 e8 03             	shr    $0x3,%eax
80101859:	03 05 14 fa 11 80    	add    0x8011fa14,%eax
8010185f:	50                   	push   %eax
80101860:	ff 33                	pushl  (%ebx)
80101862:	e8 69 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101867:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010186a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010186c:	8b 43 04             	mov    0x4(%ebx),%eax
8010186f:	83 e0 07             	and    $0x7,%eax
80101872:	c1 e0 06             	shl    $0x6,%eax
80101875:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101879:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010187c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010187f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101883:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101887:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010188b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010188f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101893:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101897:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010189b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010189e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801018a1:	6a 34                	push   $0x34
801018a3:	50                   	push   %eax
801018a4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801018a7:	50                   	push   %eax
801018a8:	e8 a3 33 00 00       	call   80104c50 <memmove>
    brelse(bp);
801018ad:	89 34 24             	mov    %esi,(%esp)
801018b0:	e8 3b e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
801018b5:	83 c4 10             	add    $0x10,%esp
801018b8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
801018bd:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801018c4:	0f 85 7b ff ff ff    	jne    80101845 <ilock+0x35>
      panic("ilock: no type");
801018ca:	83 ec 0c             	sub    $0xc,%esp
801018cd:	68 50 7b 10 80       	push   $0x80107b50
801018d2:	e8 b9 ea ff ff       	call   80100390 <panic>
    panic("ilock");
801018d7:	83 ec 0c             	sub    $0xc,%esp
801018da:	68 4a 7b 10 80       	push   $0x80107b4a
801018df:	e8 ac ea ff ff       	call   80100390 <panic>
801018e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801018ef:	90                   	nop

801018f0 <iunlock>:
{
801018f0:	f3 0f 1e fb          	endbr32 
801018f4:	55                   	push   %ebp
801018f5:	89 e5                	mov    %esp,%ebp
801018f7:	56                   	push   %esi
801018f8:	53                   	push   %ebx
801018f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801018fc:	85 db                	test   %ebx,%ebx
801018fe:	74 28                	je     80101928 <iunlock+0x38>
80101900:	83 ec 0c             	sub    $0xc,%esp
80101903:	8d 73 0c             	lea    0xc(%ebx),%esi
80101906:	56                   	push   %esi
80101907:	e8 b4 2f 00 00       	call   801048c0 <holdingsleep>
8010190c:	83 c4 10             	add    $0x10,%esp
8010190f:	85 c0                	test   %eax,%eax
80101911:	74 15                	je     80101928 <iunlock+0x38>
80101913:	8b 43 08             	mov    0x8(%ebx),%eax
80101916:	85 c0                	test   %eax,%eax
80101918:	7e 0e                	jle    80101928 <iunlock+0x38>
  releasesleep(&ip->lock);
8010191a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010191d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101920:	5b                   	pop    %ebx
80101921:	5e                   	pop    %esi
80101922:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101923:	e9 58 2f 00 00       	jmp    80104880 <releasesleep>
    panic("iunlock");
80101928:	83 ec 0c             	sub    $0xc,%esp
8010192b:	68 5f 7b 10 80       	push   $0x80107b5f
80101930:	e8 5b ea ff ff       	call   80100390 <panic>
80101935:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010193c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101940 <iput>:
{
80101940:	f3 0f 1e fb          	endbr32 
80101944:	55                   	push   %ebp
80101945:	89 e5                	mov    %esp,%ebp
80101947:	57                   	push   %edi
80101948:	56                   	push   %esi
80101949:	53                   	push   %ebx
8010194a:	83 ec 28             	sub    $0x28,%esp
8010194d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101950:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101953:	57                   	push   %edi
80101954:	e8 c7 2e 00 00       	call   80104820 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101959:	8b 53 4c             	mov    0x4c(%ebx),%edx
8010195c:	83 c4 10             	add    $0x10,%esp
8010195f:	85 d2                	test   %edx,%edx
80101961:	74 07                	je     8010196a <iput+0x2a>
80101963:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101968:	74 36                	je     801019a0 <iput+0x60>
  releasesleep(&ip->lock);
8010196a:	83 ec 0c             	sub    $0xc,%esp
8010196d:	57                   	push   %edi
8010196e:	e8 0d 2f 00 00       	call   80104880 <releasesleep>
  acquire(&icache.lock);
80101973:	c7 04 24 20 fa 11 80 	movl   $0x8011fa20,(%esp)
8010197a:	e8 21 31 00 00       	call   80104aa0 <acquire>
  ip->ref--;
8010197f:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101983:	83 c4 10             	add    $0x10,%esp
80101986:	c7 45 08 20 fa 11 80 	movl   $0x8011fa20,0x8(%ebp)
}
8010198d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101990:	5b                   	pop    %ebx
80101991:	5e                   	pop    %esi
80101992:	5f                   	pop    %edi
80101993:	5d                   	pop    %ebp
  release(&icache.lock);
80101994:	e9 c7 31 00 00       	jmp    80104b60 <release>
80101999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
801019a0:	83 ec 0c             	sub    $0xc,%esp
801019a3:	68 20 fa 11 80       	push   $0x8011fa20
801019a8:	e8 f3 30 00 00       	call   80104aa0 <acquire>
    int r = ip->ref;
801019ad:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
801019b0:	c7 04 24 20 fa 11 80 	movl   $0x8011fa20,(%esp)
801019b7:	e8 a4 31 00 00       	call   80104b60 <release>
    if(r == 1){
801019bc:	83 c4 10             	add    $0x10,%esp
801019bf:	83 fe 01             	cmp    $0x1,%esi
801019c2:	75 a6                	jne    8010196a <iput+0x2a>
801019c4:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
801019ca:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801019cd:	8d 73 5c             	lea    0x5c(%ebx),%esi
801019d0:	89 cf                	mov    %ecx,%edi
801019d2:	eb 0b                	jmp    801019df <iput+0x9f>
801019d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801019d8:	83 c6 04             	add    $0x4,%esi
801019db:	39 fe                	cmp    %edi,%esi
801019dd:	74 19                	je     801019f8 <iput+0xb8>
    if(ip->addrs[i]){
801019df:	8b 16                	mov    (%esi),%edx
801019e1:	85 d2                	test   %edx,%edx
801019e3:	74 f3                	je     801019d8 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
801019e5:	8b 03                	mov    (%ebx),%eax
801019e7:	e8 74 f8 ff ff       	call   80101260 <bfree>
      ip->addrs[i] = 0;
801019ec:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801019f2:	eb e4                	jmp    801019d8 <iput+0x98>
801019f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801019f8:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801019fe:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a01:	85 c0                	test   %eax,%eax
80101a03:	75 33                	jne    80101a38 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101a05:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101a08:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101a0f:	53                   	push   %ebx
80101a10:	e8 3b fd ff ff       	call   80101750 <iupdate>
      ip->type = 0;
80101a15:	31 c0                	xor    %eax,%eax
80101a17:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101a1b:	89 1c 24             	mov    %ebx,(%esp)
80101a1e:	e8 2d fd ff ff       	call   80101750 <iupdate>
      ip->valid = 0;
80101a23:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101a2a:	83 c4 10             	add    $0x10,%esp
80101a2d:	e9 38 ff ff ff       	jmp    8010196a <iput+0x2a>
80101a32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101a38:	83 ec 08             	sub    $0x8,%esp
80101a3b:	50                   	push   %eax
80101a3c:	ff 33                	pushl  (%ebx)
80101a3e:	e8 8d e6 ff ff       	call   801000d0 <bread>
80101a43:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a46:	83 c4 10             	add    $0x10,%esp
80101a49:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101a4f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101a52:	8d 70 5c             	lea    0x5c(%eax),%esi
80101a55:	89 cf                	mov    %ecx,%edi
80101a57:	eb 0e                	jmp    80101a67 <iput+0x127>
80101a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a60:	83 c6 04             	add    $0x4,%esi
80101a63:	39 f7                	cmp    %esi,%edi
80101a65:	74 19                	je     80101a80 <iput+0x140>
      if(a[j])
80101a67:	8b 16                	mov    (%esi),%edx
80101a69:	85 d2                	test   %edx,%edx
80101a6b:	74 f3                	je     80101a60 <iput+0x120>
        bfree(ip->dev, a[j]);
80101a6d:	8b 03                	mov    (%ebx),%eax
80101a6f:	e8 ec f7 ff ff       	call   80101260 <bfree>
80101a74:	eb ea                	jmp    80101a60 <iput+0x120>
80101a76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a7d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101a80:	83 ec 0c             	sub    $0xc,%esp
80101a83:	ff 75 e4             	pushl  -0x1c(%ebp)
80101a86:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a89:	e8 62 e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a8e:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101a94:	8b 03                	mov    (%ebx),%eax
80101a96:	e8 c5 f7 ff ff       	call   80101260 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a9b:	83 c4 10             	add    $0x10,%esp
80101a9e:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101aa5:	00 00 00 
80101aa8:	e9 58 ff ff ff       	jmp    80101a05 <iput+0xc5>
80101aad:	8d 76 00             	lea    0x0(%esi),%esi

80101ab0 <iunlockput>:
{
80101ab0:	f3 0f 1e fb          	endbr32 
80101ab4:	55                   	push   %ebp
80101ab5:	89 e5                	mov    %esp,%ebp
80101ab7:	53                   	push   %ebx
80101ab8:	83 ec 10             	sub    $0x10,%esp
80101abb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101abe:	53                   	push   %ebx
80101abf:	e8 2c fe ff ff       	call   801018f0 <iunlock>
  iput(ip);
80101ac4:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101ac7:	83 c4 10             	add    $0x10,%esp
}
80101aca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101acd:	c9                   	leave  
  iput(ip);
80101ace:	e9 6d fe ff ff       	jmp    80101940 <iput>
80101ad3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101ae0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101ae0:	f3 0f 1e fb          	endbr32 
80101ae4:	55                   	push   %ebp
80101ae5:	89 e5                	mov    %esp,%ebp
80101ae7:	8b 55 08             	mov    0x8(%ebp),%edx
80101aea:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101aed:	8b 0a                	mov    (%edx),%ecx
80101aef:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101af2:	8b 4a 04             	mov    0x4(%edx),%ecx
80101af5:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101af8:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101afc:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101aff:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101b03:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101b07:	8b 52 58             	mov    0x58(%edx),%edx
80101b0a:	89 50 10             	mov    %edx,0x10(%eax)
}
80101b0d:	5d                   	pop    %ebp
80101b0e:	c3                   	ret    
80101b0f:	90                   	nop

80101b10 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101b10:	f3 0f 1e fb          	endbr32 
80101b14:	55                   	push   %ebp
80101b15:	89 e5                	mov    %esp,%ebp
80101b17:	57                   	push   %edi
80101b18:	56                   	push   %esi
80101b19:	53                   	push   %ebx
80101b1a:	83 ec 1c             	sub    $0x1c,%esp
80101b1d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101b20:	8b 45 08             	mov    0x8(%ebp),%eax
80101b23:	8b 75 10             	mov    0x10(%ebp),%esi
80101b26:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101b29:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b2c:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b31:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b34:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101b37:	0f 84 a3 00 00 00    	je     80101be0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101b3d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b40:	8b 40 58             	mov    0x58(%eax),%eax
80101b43:	39 c6                	cmp    %eax,%esi
80101b45:	0f 87 b6 00 00 00    	ja     80101c01 <readi+0xf1>
80101b4b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b4e:	31 c9                	xor    %ecx,%ecx
80101b50:	89 da                	mov    %ebx,%edx
80101b52:	01 f2                	add    %esi,%edx
80101b54:	0f 92 c1             	setb   %cl
80101b57:	89 cf                	mov    %ecx,%edi
80101b59:	0f 82 a2 00 00 00    	jb     80101c01 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101b5f:	89 c1                	mov    %eax,%ecx
80101b61:	29 f1                	sub    %esi,%ecx
80101b63:	39 d0                	cmp    %edx,%eax
80101b65:	0f 43 cb             	cmovae %ebx,%ecx
80101b68:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b6b:	85 c9                	test   %ecx,%ecx
80101b6d:	74 63                	je     80101bd2 <readi+0xc2>
80101b6f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b70:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b73:	89 f2                	mov    %esi,%edx
80101b75:	c1 ea 09             	shr    $0x9,%edx
80101b78:	89 d8                	mov    %ebx,%eax
80101b7a:	e8 61 f9 ff ff       	call   801014e0 <bmap>
80101b7f:	83 ec 08             	sub    $0x8,%esp
80101b82:	50                   	push   %eax
80101b83:	ff 33                	pushl  (%ebx)
80101b85:	e8 46 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b8a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b8d:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b92:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b95:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b97:	89 f0                	mov    %esi,%eax
80101b99:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b9e:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101ba0:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101ba3:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101ba5:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101ba9:	39 d9                	cmp    %ebx,%ecx
80101bab:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101bae:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101baf:	01 df                	add    %ebx,%edi
80101bb1:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101bb3:	50                   	push   %eax
80101bb4:	ff 75 e0             	pushl  -0x20(%ebp)
80101bb7:	e8 94 30 00 00       	call   80104c50 <memmove>
    brelse(bp);
80101bbc:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101bbf:	89 14 24             	mov    %edx,(%esp)
80101bc2:	e8 29 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bc7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101bca:	83 c4 10             	add    $0x10,%esp
80101bcd:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101bd0:	77 9e                	ja     80101b70 <readi+0x60>
  }
  return n;
80101bd2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101bd5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bd8:	5b                   	pop    %ebx
80101bd9:	5e                   	pop    %esi
80101bda:	5f                   	pop    %edi
80101bdb:	5d                   	pop    %ebp
80101bdc:	c3                   	ret    
80101bdd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101be0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101be4:	66 83 f8 09          	cmp    $0x9,%ax
80101be8:	77 17                	ja     80101c01 <readi+0xf1>
80101bea:	8b 04 c5 a0 f9 11 80 	mov    -0x7fee0660(,%eax,8),%eax
80101bf1:	85 c0                	test   %eax,%eax
80101bf3:	74 0c                	je     80101c01 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101bf5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101bf8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bfb:	5b                   	pop    %ebx
80101bfc:	5e                   	pop    %esi
80101bfd:	5f                   	pop    %edi
80101bfe:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101bff:	ff e0                	jmp    *%eax
      return -1;
80101c01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c06:	eb cd                	jmp    80101bd5 <readi+0xc5>
80101c08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c0f:	90                   	nop

80101c10 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101c10:	f3 0f 1e fb          	endbr32 
80101c14:	55                   	push   %ebp
80101c15:	89 e5                	mov    %esp,%ebp
80101c17:	57                   	push   %edi
80101c18:	56                   	push   %esi
80101c19:	53                   	push   %ebx
80101c1a:	83 ec 1c             	sub    $0x1c,%esp
80101c1d:	8b 45 08             	mov    0x8(%ebp),%eax
80101c20:	8b 75 0c             	mov    0xc(%ebp),%esi
80101c23:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101c26:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101c2b:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101c2e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c31:	8b 75 10             	mov    0x10(%ebp),%esi
80101c34:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101c37:	0f 84 b3 00 00 00    	je     80101cf0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101c3d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c40:	39 70 58             	cmp    %esi,0x58(%eax)
80101c43:	0f 82 e3 00 00 00    	jb     80101d2c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101c49:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101c4c:	89 f8                	mov    %edi,%eax
80101c4e:	01 f0                	add    %esi,%eax
80101c50:	0f 82 d6 00 00 00    	jb     80101d2c <writei+0x11c>
80101c56:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101c5b:	0f 87 cb 00 00 00    	ja     80101d2c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c61:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101c68:	85 ff                	test   %edi,%edi
80101c6a:	74 75                	je     80101ce1 <writei+0xd1>
80101c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c70:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101c73:	89 f2                	mov    %esi,%edx
80101c75:	c1 ea 09             	shr    $0x9,%edx
80101c78:	89 f8                	mov    %edi,%eax
80101c7a:	e8 61 f8 ff ff       	call   801014e0 <bmap>
80101c7f:	83 ec 08             	sub    $0x8,%esp
80101c82:	50                   	push   %eax
80101c83:	ff 37                	pushl  (%edi)
80101c85:	e8 46 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c8a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c8f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c92:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c95:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c97:	89 f0                	mov    %esi,%eax
80101c99:	83 c4 0c             	add    $0xc,%esp
80101c9c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101ca1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101ca3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101ca7:	39 d9                	cmp    %ebx,%ecx
80101ca9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101cac:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101cad:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101caf:	ff 75 dc             	pushl  -0x24(%ebp)
80101cb2:	50                   	push   %eax
80101cb3:	e8 98 2f 00 00       	call   80104c50 <memmove>
    log_write(bp);
80101cb8:	89 3c 24             	mov    %edi,(%esp)
80101cbb:	e8 10 17 00 00       	call   801033d0 <log_write>
    brelse(bp);
80101cc0:	89 3c 24             	mov    %edi,(%esp)
80101cc3:	e8 28 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101cc8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101ccb:	83 c4 10             	add    $0x10,%esp
80101cce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101cd1:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101cd4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101cd7:	77 97                	ja     80101c70 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101cd9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101cdc:	3b 70 58             	cmp    0x58(%eax),%esi
80101cdf:	77 37                	ja     80101d18 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101ce1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101ce4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ce7:	5b                   	pop    %ebx
80101ce8:	5e                   	pop    %esi
80101ce9:	5f                   	pop    %edi
80101cea:	5d                   	pop    %ebp
80101ceb:	c3                   	ret    
80101cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101cf0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101cf4:	66 83 f8 09          	cmp    $0x9,%ax
80101cf8:	77 32                	ja     80101d2c <writei+0x11c>
80101cfa:	8b 04 c5 a4 f9 11 80 	mov    -0x7fee065c(,%eax,8),%eax
80101d01:	85 c0                	test   %eax,%eax
80101d03:	74 27                	je     80101d2c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101d05:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101d08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d0b:	5b                   	pop    %ebx
80101d0c:	5e                   	pop    %esi
80101d0d:	5f                   	pop    %edi
80101d0e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101d0f:	ff e0                	jmp    *%eax
80101d11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101d18:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101d1b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101d1e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101d21:	50                   	push   %eax
80101d22:	e8 29 fa ff ff       	call   80101750 <iupdate>
80101d27:	83 c4 10             	add    $0x10,%esp
80101d2a:	eb b5                	jmp    80101ce1 <writei+0xd1>
      return -1;
80101d2c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d31:	eb b1                	jmp    80101ce4 <writei+0xd4>
80101d33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101d40 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101d40:	f3 0f 1e fb          	endbr32 
80101d44:	55                   	push   %ebp
80101d45:	89 e5                	mov    %esp,%ebp
80101d47:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101d4a:	6a 0e                	push   $0xe
80101d4c:	ff 75 0c             	pushl  0xc(%ebp)
80101d4f:	ff 75 08             	pushl  0x8(%ebp)
80101d52:	e8 69 2f 00 00       	call   80104cc0 <strncmp>
}
80101d57:	c9                   	leave  
80101d58:	c3                   	ret    
80101d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d60 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101d60:	f3 0f 1e fb          	endbr32 
80101d64:	55                   	push   %ebp
80101d65:	89 e5                	mov    %esp,%ebp
80101d67:	57                   	push   %edi
80101d68:	56                   	push   %esi
80101d69:	53                   	push   %ebx
80101d6a:	83 ec 1c             	sub    $0x1c,%esp
80101d6d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101d70:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d75:	0f 85 89 00 00 00    	jne    80101e04 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d7b:	8b 53 58             	mov    0x58(%ebx),%edx
80101d7e:	31 ff                	xor    %edi,%edi
80101d80:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d83:	85 d2                	test   %edx,%edx
80101d85:	74 42                	je     80101dc9 <dirlookup+0x69>
80101d87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d8e:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d90:	6a 10                	push   $0x10
80101d92:	57                   	push   %edi
80101d93:	56                   	push   %esi
80101d94:	53                   	push   %ebx
80101d95:	e8 76 fd ff ff       	call   80101b10 <readi>
80101d9a:	83 c4 10             	add    $0x10,%esp
80101d9d:	83 f8 10             	cmp    $0x10,%eax
80101da0:	75 55                	jne    80101df7 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80101da2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101da7:	74 18                	je     80101dc1 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80101da9:	83 ec 04             	sub    $0x4,%esp
80101dac:	8d 45 da             	lea    -0x26(%ebp),%eax
80101daf:	6a 0e                	push   $0xe
80101db1:	50                   	push   %eax
80101db2:	ff 75 0c             	pushl  0xc(%ebp)
80101db5:	e8 06 2f 00 00       	call   80104cc0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101dba:	83 c4 10             	add    $0x10,%esp
80101dbd:	85 c0                	test   %eax,%eax
80101dbf:	74 17                	je     80101dd8 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101dc1:	83 c7 10             	add    $0x10,%edi
80101dc4:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101dc7:	72 c7                	jb     80101d90 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101dc9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101dcc:	31 c0                	xor    %eax,%eax
}
80101dce:	5b                   	pop    %ebx
80101dcf:	5e                   	pop    %esi
80101dd0:	5f                   	pop    %edi
80101dd1:	5d                   	pop    %ebp
80101dd2:	c3                   	ret    
80101dd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101dd7:	90                   	nop
      if(poff)
80101dd8:	8b 45 10             	mov    0x10(%ebp),%eax
80101ddb:	85 c0                	test   %eax,%eax
80101ddd:	74 05                	je     80101de4 <dirlookup+0x84>
        *poff = off;
80101ddf:	8b 45 10             	mov    0x10(%ebp),%eax
80101de2:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101de4:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101de8:	8b 03                	mov    (%ebx),%eax
80101dea:	e8 01 f6 ff ff       	call   801013f0 <iget>
}
80101def:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101df2:	5b                   	pop    %ebx
80101df3:	5e                   	pop    %esi
80101df4:	5f                   	pop    %edi
80101df5:	5d                   	pop    %ebp
80101df6:	c3                   	ret    
      panic("dirlookup read");
80101df7:	83 ec 0c             	sub    $0xc,%esp
80101dfa:	68 79 7b 10 80       	push   $0x80107b79
80101dff:	e8 8c e5 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101e04:	83 ec 0c             	sub    $0xc,%esp
80101e07:	68 67 7b 10 80       	push   $0x80107b67
80101e0c:	e8 7f e5 ff ff       	call   80100390 <panic>
80101e11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e1f:	90                   	nop

80101e20 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101e20:	55                   	push   %ebp
80101e21:	89 e5                	mov    %esp,%ebp
80101e23:	57                   	push   %edi
80101e24:	56                   	push   %esi
80101e25:	53                   	push   %ebx
80101e26:	89 c3                	mov    %eax,%ebx
80101e28:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101e2b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101e2e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101e31:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101e34:	0f 84 86 01 00 00    	je     80101fc0 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101e3a:	e8 11 20 00 00       	call   80103e50 <myproc>
  acquire(&icache.lock);
80101e3f:	83 ec 0c             	sub    $0xc,%esp
80101e42:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101e44:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101e47:	68 20 fa 11 80       	push   $0x8011fa20
80101e4c:	e8 4f 2c 00 00       	call   80104aa0 <acquire>
  ip->ref++;
80101e51:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101e55:	c7 04 24 20 fa 11 80 	movl   $0x8011fa20,(%esp)
80101e5c:	e8 ff 2c 00 00       	call   80104b60 <release>
80101e61:	83 c4 10             	add    $0x10,%esp
80101e64:	eb 0d                	jmp    80101e73 <namex+0x53>
80101e66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e6d:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80101e70:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101e73:	0f b6 07             	movzbl (%edi),%eax
80101e76:	3c 2f                	cmp    $0x2f,%al
80101e78:	74 f6                	je     80101e70 <namex+0x50>
  if(*path == 0)
80101e7a:	84 c0                	test   %al,%al
80101e7c:	0f 84 ee 00 00 00    	je     80101f70 <namex+0x150>
  while(*path != '/' && *path != 0)
80101e82:	0f b6 07             	movzbl (%edi),%eax
80101e85:	84 c0                	test   %al,%al
80101e87:	0f 84 fb 00 00 00    	je     80101f88 <namex+0x168>
80101e8d:	89 fb                	mov    %edi,%ebx
80101e8f:	3c 2f                	cmp    $0x2f,%al
80101e91:	0f 84 f1 00 00 00    	je     80101f88 <namex+0x168>
80101e97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e9e:	66 90                	xchg   %ax,%ax
80101ea0:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80101ea4:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80101ea7:	3c 2f                	cmp    $0x2f,%al
80101ea9:	74 04                	je     80101eaf <namex+0x8f>
80101eab:	84 c0                	test   %al,%al
80101ead:	75 f1                	jne    80101ea0 <namex+0x80>
  len = path - s;
80101eaf:	89 d8                	mov    %ebx,%eax
80101eb1:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80101eb3:	83 f8 0d             	cmp    $0xd,%eax
80101eb6:	0f 8e 84 00 00 00    	jle    80101f40 <namex+0x120>
    memmove(name, s, DIRSIZ);
80101ebc:	83 ec 04             	sub    $0x4,%esp
80101ebf:	6a 0e                	push   $0xe
80101ec1:	57                   	push   %edi
    path++;
80101ec2:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80101ec4:	ff 75 e4             	pushl  -0x1c(%ebp)
80101ec7:	e8 84 2d 00 00       	call   80104c50 <memmove>
80101ecc:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101ecf:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101ed2:	75 0c                	jne    80101ee0 <namex+0xc0>
80101ed4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101ed8:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101edb:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101ede:	74 f8                	je     80101ed8 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101ee0:	83 ec 0c             	sub    $0xc,%esp
80101ee3:	56                   	push   %esi
80101ee4:	e8 27 f9 ff ff       	call   80101810 <ilock>
    if(ip->type != T_DIR){
80101ee9:	83 c4 10             	add    $0x10,%esp
80101eec:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101ef1:	0f 85 a1 00 00 00    	jne    80101f98 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101ef7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101efa:	85 d2                	test   %edx,%edx
80101efc:	74 09                	je     80101f07 <namex+0xe7>
80101efe:	80 3f 00             	cmpb   $0x0,(%edi)
80101f01:	0f 84 d9 00 00 00    	je     80101fe0 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101f07:	83 ec 04             	sub    $0x4,%esp
80101f0a:	6a 00                	push   $0x0
80101f0c:	ff 75 e4             	pushl  -0x1c(%ebp)
80101f0f:	56                   	push   %esi
80101f10:	e8 4b fe ff ff       	call   80101d60 <dirlookup>
80101f15:	83 c4 10             	add    $0x10,%esp
80101f18:	89 c3                	mov    %eax,%ebx
80101f1a:	85 c0                	test   %eax,%eax
80101f1c:	74 7a                	je     80101f98 <namex+0x178>
  iunlock(ip);
80101f1e:	83 ec 0c             	sub    $0xc,%esp
80101f21:	56                   	push   %esi
80101f22:	e8 c9 f9 ff ff       	call   801018f0 <iunlock>
  iput(ip);
80101f27:	89 34 24             	mov    %esi,(%esp)
80101f2a:	89 de                	mov    %ebx,%esi
80101f2c:	e8 0f fa ff ff       	call   80101940 <iput>
80101f31:	83 c4 10             	add    $0x10,%esp
80101f34:	e9 3a ff ff ff       	jmp    80101e73 <namex+0x53>
80101f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f40:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f43:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101f46:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80101f49:	83 ec 04             	sub    $0x4,%esp
80101f4c:	50                   	push   %eax
80101f4d:	57                   	push   %edi
    name[len] = 0;
80101f4e:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80101f50:	ff 75 e4             	pushl  -0x1c(%ebp)
80101f53:	e8 f8 2c 00 00       	call   80104c50 <memmove>
    name[len] = 0;
80101f58:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f5b:	83 c4 10             	add    $0x10,%esp
80101f5e:	c6 00 00             	movb   $0x0,(%eax)
80101f61:	e9 69 ff ff ff       	jmp    80101ecf <namex+0xaf>
80101f66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f6d:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101f70:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101f73:	85 c0                	test   %eax,%eax
80101f75:	0f 85 85 00 00 00    	jne    80102000 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f7e:	89 f0                	mov    %esi,%eax
80101f80:	5b                   	pop    %ebx
80101f81:	5e                   	pop    %esi
80101f82:	5f                   	pop    %edi
80101f83:	5d                   	pop    %ebp
80101f84:	c3                   	ret    
80101f85:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80101f88:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101f8b:	89 fb                	mov    %edi,%ebx
80101f8d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101f90:	31 c0                	xor    %eax,%eax
80101f92:	eb b5                	jmp    80101f49 <namex+0x129>
80101f94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101f98:	83 ec 0c             	sub    $0xc,%esp
80101f9b:	56                   	push   %esi
80101f9c:	e8 4f f9 ff ff       	call   801018f0 <iunlock>
  iput(ip);
80101fa1:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101fa4:	31 f6                	xor    %esi,%esi
  iput(ip);
80101fa6:	e8 95 f9 ff ff       	call   80101940 <iput>
      return 0;
80101fab:	83 c4 10             	add    $0x10,%esp
}
80101fae:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fb1:	89 f0                	mov    %esi,%eax
80101fb3:	5b                   	pop    %ebx
80101fb4:	5e                   	pop    %esi
80101fb5:	5f                   	pop    %edi
80101fb6:	5d                   	pop    %ebp
80101fb7:	c3                   	ret    
80101fb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101fbf:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80101fc0:	ba 01 00 00 00       	mov    $0x1,%edx
80101fc5:	b8 01 00 00 00       	mov    $0x1,%eax
80101fca:	89 df                	mov    %ebx,%edi
80101fcc:	e8 1f f4 ff ff       	call   801013f0 <iget>
80101fd1:	89 c6                	mov    %eax,%esi
80101fd3:	e9 9b fe ff ff       	jmp    80101e73 <namex+0x53>
80101fd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101fdf:	90                   	nop
      iunlock(ip);
80101fe0:	83 ec 0c             	sub    $0xc,%esp
80101fe3:	56                   	push   %esi
80101fe4:	e8 07 f9 ff ff       	call   801018f0 <iunlock>
      return ip;
80101fe9:	83 c4 10             	add    $0x10,%esp
}
80101fec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fef:	89 f0                	mov    %esi,%eax
80101ff1:	5b                   	pop    %ebx
80101ff2:	5e                   	pop    %esi
80101ff3:	5f                   	pop    %edi
80101ff4:	5d                   	pop    %ebp
80101ff5:	c3                   	ret    
80101ff6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ffd:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80102000:	83 ec 0c             	sub    $0xc,%esp
80102003:	56                   	push   %esi
    return 0;
80102004:	31 f6                	xor    %esi,%esi
    iput(ip);
80102006:	e8 35 f9 ff ff       	call   80101940 <iput>
    return 0;
8010200b:	83 c4 10             	add    $0x10,%esp
8010200e:	e9 68 ff ff ff       	jmp    80101f7b <namex+0x15b>
80102013:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010201a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102020 <dirlink>:
{
80102020:	f3 0f 1e fb          	endbr32 
80102024:	55                   	push   %ebp
80102025:	89 e5                	mov    %esp,%ebp
80102027:	57                   	push   %edi
80102028:	56                   	push   %esi
80102029:	53                   	push   %ebx
8010202a:	83 ec 20             	sub    $0x20,%esp
8010202d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80102030:	6a 00                	push   $0x0
80102032:	ff 75 0c             	pushl  0xc(%ebp)
80102035:	53                   	push   %ebx
80102036:	e8 25 fd ff ff       	call   80101d60 <dirlookup>
8010203b:	83 c4 10             	add    $0x10,%esp
8010203e:	85 c0                	test   %eax,%eax
80102040:	75 6b                	jne    801020ad <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102042:	8b 7b 58             	mov    0x58(%ebx),%edi
80102045:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102048:	85 ff                	test   %edi,%edi
8010204a:	74 2d                	je     80102079 <dirlink+0x59>
8010204c:	31 ff                	xor    %edi,%edi
8010204e:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102051:	eb 0d                	jmp    80102060 <dirlink+0x40>
80102053:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102057:	90                   	nop
80102058:	83 c7 10             	add    $0x10,%edi
8010205b:	3b 7b 58             	cmp    0x58(%ebx),%edi
8010205e:	73 19                	jae    80102079 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102060:	6a 10                	push   $0x10
80102062:	57                   	push   %edi
80102063:	56                   	push   %esi
80102064:	53                   	push   %ebx
80102065:	e8 a6 fa ff ff       	call   80101b10 <readi>
8010206a:	83 c4 10             	add    $0x10,%esp
8010206d:	83 f8 10             	cmp    $0x10,%eax
80102070:	75 4e                	jne    801020c0 <dirlink+0xa0>
    if(de.inum == 0)
80102072:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80102077:	75 df                	jne    80102058 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80102079:	83 ec 04             	sub    $0x4,%esp
8010207c:	8d 45 da             	lea    -0x26(%ebp),%eax
8010207f:	6a 0e                	push   $0xe
80102081:	ff 75 0c             	pushl  0xc(%ebp)
80102084:	50                   	push   %eax
80102085:	e8 86 2c 00 00       	call   80104d10 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010208a:	6a 10                	push   $0x10
  de.inum = inum;
8010208c:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010208f:	57                   	push   %edi
80102090:	56                   	push   %esi
80102091:	53                   	push   %ebx
  de.inum = inum;
80102092:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102096:	e8 75 fb ff ff       	call   80101c10 <writei>
8010209b:	83 c4 20             	add    $0x20,%esp
8010209e:	83 f8 10             	cmp    $0x10,%eax
801020a1:	75 2a                	jne    801020cd <dirlink+0xad>
  return 0;
801020a3:	31 c0                	xor    %eax,%eax
}
801020a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020a8:	5b                   	pop    %ebx
801020a9:	5e                   	pop    %esi
801020aa:	5f                   	pop    %edi
801020ab:	5d                   	pop    %ebp
801020ac:	c3                   	ret    
    iput(ip);
801020ad:	83 ec 0c             	sub    $0xc,%esp
801020b0:	50                   	push   %eax
801020b1:	e8 8a f8 ff ff       	call   80101940 <iput>
    return -1;
801020b6:	83 c4 10             	add    $0x10,%esp
801020b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020be:	eb e5                	jmp    801020a5 <dirlink+0x85>
      panic("dirlink read");
801020c0:	83 ec 0c             	sub    $0xc,%esp
801020c3:	68 88 7b 10 80       	push   $0x80107b88
801020c8:	e8 c3 e2 ff ff       	call   80100390 <panic>
    panic("dirlink");
801020cd:	83 ec 0c             	sub    $0xc,%esp
801020d0:	68 f1 81 10 80       	push   $0x801081f1
801020d5:	e8 b6 e2 ff ff       	call   80100390 <panic>
801020da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801020e0 <namei>:

struct inode*
namei(char *path)
{
801020e0:	f3 0f 1e fb          	endbr32 
801020e4:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801020e5:	31 d2                	xor    %edx,%edx
{
801020e7:	89 e5                	mov    %esp,%ebp
801020e9:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801020ec:	8b 45 08             	mov    0x8(%ebp),%eax
801020ef:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020f2:	e8 29 fd ff ff       	call   80101e20 <namex>
}
801020f7:	c9                   	leave  
801020f8:	c3                   	ret    
801020f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102100 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102100:	f3 0f 1e fb          	endbr32 
80102104:	55                   	push   %ebp
  return namex(path, 1, name);
80102105:	ba 01 00 00 00       	mov    $0x1,%edx
{
8010210a:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
8010210c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010210f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102112:	5d                   	pop    %ebp
  return namex(path, 1, name);
80102113:	e9 08 fd ff ff       	jmp    80101e20 <namex>
80102118:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010211f:	90                   	nop

80102120 <itoa>:

#include "fcntl.h"
#define DIGITS 14

char* itoa(int i, char b[]){
80102120:	f3 0f 1e fb          	endbr32 
80102124:	55                   	push   %ebp
    char const digit[] = "0123456789";
80102125:	b8 38 39 00 00       	mov    $0x3938,%eax
char* itoa(int i, char b[]){
8010212a:	89 e5                	mov    %esp,%ebp
8010212c:	57                   	push   %edi
8010212d:	56                   	push   %esi
8010212e:	53                   	push   %ebx
8010212f:	83 ec 10             	sub    $0x10,%esp
80102132:	8b 7d 0c             	mov    0xc(%ebp),%edi
80102135:	8b 4d 08             	mov    0x8(%ebp),%ecx
    char const digit[] = "0123456789";
80102138:	c7 45 e9 30 31 32 33 	movl   $0x33323130,-0x17(%ebp)
8010213f:	c7 45 ed 34 35 36 37 	movl   $0x37363534,-0x13(%ebp)
80102146:	66 89 45 f1          	mov    %ax,-0xf(%ebp)
8010214a:	89 fb                	mov    %edi,%ebx
8010214c:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
    char* p = b;
    if(i<0){
80102150:	85 c9                	test   %ecx,%ecx
80102152:	79 08                	jns    8010215c <itoa+0x3c>
        *p++ = '-';
80102154:	c6 07 2d             	movb   $0x2d,(%edi)
80102157:	8d 5f 01             	lea    0x1(%edi),%ebx
        i *= -1;
8010215a:	f7 d9                	neg    %ecx
    }
    int shifter = i;
8010215c:	89 ca                	mov    %ecx,%edx
    do{ //Move to where representation ends
        ++p;
        shifter = shifter/10;
8010215e:	be cd cc cc cc       	mov    $0xcccccccd,%esi
80102163:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102167:	90                   	nop
80102168:	89 d0                	mov    %edx,%eax
        ++p;
8010216a:	83 c3 01             	add    $0x1,%ebx
        shifter = shifter/10;
8010216d:	f7 e6                	mul    %esi
    }while(shifter);
8010216f:	c1 ea 03             	shr    $0x3,%edx
80102172:	75 f4                	jne    80102168 <itoa+0x48>
    *p = '\0';
80102174:	c6 03 00             	movb   $0x0,(%ebx)
    do{ //Move back, inserting digits as u go
        *--p = digit[i%10];
80102177:	be cd cc cc cc       	mov    $0xcccccccd,%esi
8010217c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102180:	89 c8                	mov    %ecx,%eax
80102182:	83 eb 01             	sub    $0x1,%ebx
80102185:	f7 e6                	mul    %esi
80102187:	c1 ea 03             	shr    $0x3,%edx
8010218a:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010218d:	01 c0                	add    %eax,%eax
8010218f:	29 c1                	sub    %eax,%ecx
80102191:	0f b6 44 0d e9       	movzbl -0x17(%ebp,%ecx,1),%eax
        i = i/10;
80102196:	89 d1                	mov    %edx,%ecx
        *--p = digit[i%10];
80102198:	88 03                	mov    %al,(%ebx)
    }while(i);
8010219a:	85 d2                	test   %edx,%edx
8010219c:	75 e2                	jne    80102180 <itoa+0x60>
    return b;
}
8010219e:	83 c4 10             	add    $0x10,%esp
801021a1:	89 f8                	mov    %edi,%eax
801021a3:	5b                   	pop    %ebx
801021a4:	5e                   	pop    %esi
801021a5:	5f                   	pop    %edi
801021a6:	5d                   	pop    %ebp
801021a7:	c3                   	ret    
801021a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021af:	90                   	nop

801021b0 <removeSwapFile>:
//remove swap file of proc p;
int
removeSwapFile(struct proc* p)
{
801021b0:	f3 0f 1e fb          	endbr32 
801021b4:	55                   	push   %ebp
801021b5:	89 e5                	mov    %esp,%ebp
801021b7:	57                   	push   %edi
801021b8:	56                   	push   %esi
  //path of proccess
  char path[DIGITS];
  memmove(path,"/.swap", 6);
801021b9:	8d 75 bc             	lea    -0x44(%ebp),%esi
{
801021bc:	53                   	push   %ebx
801021bd:	83 ec 40             	sub    $0x40,%esp
801021c0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
801021c3:	6a 06                	push   $0x6
801021c5:	68 95 7b 10 80       	push   $0x80107b95
801021ca:	56                   	push   %esi
801021cb:	e8 80 2a 00 00       	call   80104c50 <memmove>
  itoa(p->pid, path+ 6);
801021d0:	58                   	pop    %eax
801021d1:	8d 45 c2             	lea    -0x3e(%ebp),%eax
801021d4:	5a                   	pop    %edx
801021d5:	50                   	push   %eax
801021d6:	ff 73 10             	pushl  0x10(%ebx)
801021d9:	e8 42 ff ff ff       	call   80102120 <itoa>
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ];
  uint off;

  if(0 == p->swapFile)
801021de:	8b 43 7c             	mov    0x7c(%ebx),%eax
801021e1:	83 c4 10             	add    $0x10,%esp
801021e4:	85 c0                	test   %eax,%eax
801021e6:	0f 84 7a 01 00 00    	je     80102366 <removeSwapFile+0x1b6>
  {
    return -1;
  }
  fileclose(p->swapFile);
801021ec:	83 ec 0c             	sub    $0xc,%esp
  return namex(path, 1, name);
801021ef:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  fileclose(p->swapFile);
801021f2:	50                   	push   %eax
801021f3:	e8 78 ed ff ff       	call   80100f70 <fileclose>

  begin_op();
801021f8:	e8 f3 0f 00 00       	call   801031f0 <begin_op>
  return namex(path, 1, name);
801021fd:	89 f0                	mov    %esi,%eax
801021ff:	89 d9                	mov    %ebx,%ecx
80102201:	ba 01 00 00 00       	mov    $0x1,%edx
80102206:	e8 15 fc ff ff       	call   80101e20 <namex>
  if((dp = nameiparent(path, name)) == 0)
8010220b:	83 c4 10             	add    $0x10,%esp
  return namex(path, 1, name);
8010220e:	89 c6                	mov    %eax,%esi
  if((dp = nameiparent(path, name)) == 0)
80102210:	85 c0                	test   %eax,%eax
80102212:	0f 84 55 01 00 00    	je     8010236d <removeSwapFile+0x1bd>
  {
    end_op();
    return -1;
  }

  ilock(dp);
80102218:	83 ec 0c             	sub    $0xc,%esp
8010221b:	50                   	push   %eax
8010221c:	e8 ef f5 ff ff       	call   80101810 <ilock>
  return strncmp(s, t, DIRSIZ);
80102221:	83 c4 0c             	add    $0xc,%esp
80102224:	6a 0e                	push   $0xe
80102226:	68 9d 7b 10 80       	push   $0x80107b9d
8010222b:	53                   	push   %ebx
8010222c:	e8 8f 2a 00 00       	call   80104cc0 <strncmp>

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80102231:	83 c4 10             	add    $0x10,%esp
80102234:	85 c0                	test   %eax,%eax
80102236:	0f 84 f4 00 00 00    	je     80102330 <removeSwapFile+0x180>
  return strncmp(s, t, DIRSIZ);
8010223c:	83 ec 04             	sub    $0x4,%esp
8010223f:	6a 0e                	push   $0xe
80102241:	68 9c 7b 10 80       	push   $0x80107b9c
80102246:	53                   	push   %ebx
80102247:	e8 74 2a 00 00       	call   80104cc0 <strncmp>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010224c:	83 c4 10             	add    $0x10,%esp
8010224f:	85 c0                	test   %eax,%eax
80102251:	0f 84 d9 00 00 00    	je     80102330 <removeSwapFile+0x180>
     goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80102257:	83 ec 04             	sub    $0x4,%esp
8010225a:	8d 45 b8             	lea    -0x48(%ebp),%eax
8010225d:	50                   	push   %eax
8010225e:	53                   	push   %ebx
8010225f:	56                   	push   %esi
80102260:	e8 fb fa ff ff       	call   80101d60 <dirlookup>
80102265:	83 c4 10             	add    $0x10,%esp
80102268:	89 c3                	mov    %eax,%ebx
8010226a:	85 c0                	test   %eax,%eax
8010226c:	0f 84 be 00 00 00    	je     80102330 <removeSwapFile+0x180>
    goto bad;
  ilock(ip);
80102272:	83 ec 0c             	sub    $0xc,%esp
80102275:	50                   	push   %eax
80102276:	e8 95 f5 ff ff       	call   80101810 <ilock>

  if(ip->nlink < 1)
8010227b:	83 c4 10             	add    $0x10,%esp
8010227e:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80102283:	0f 8e 00 01 00 00    	jle    80102389 <removeSwapFile+0x1d9>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80102289:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010228e:	74 78                	je     80102308 <removeSwapFile+0x158>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80102290:	83 ec 04             	sub    $0x4,%esp
80102293:	8d 7d d8             	lea    -0x28(%ebp),%edi
80102296:	6a 10                	push   $0x10
80102298:	6a 00                	push   $0x0
8010229a:	57                   	push   %edi
8010229b:	e8 10 29 00 00       	call   80104bb0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801022a0:	6a 10                	push   $0x10
801022a2:	ff 75 b8             	pushl  -0x48(%ebp)
801022a5:	57                   	push   %edi
801022a6:	56                   	push   %esi
801022a7:	e8 64 f9 ff ff       	call   80101c10 <writei>
801022ac:	83 c4 20             	add    $0x20,%esp
801022af:	83 f8 10             	cmp    $0x10,%eax
801022b2:	0f 85 c4 00 00 00    	jne    8010237c <removeSwapFile+0x1cc>
    panic("unlink: writei");
  if(ip->type == T_DIR){
801022b8:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801022bd:	0f 84 8d 00 00 00    	je     80102350 <removeSwapFile+0x1a0>
  iunlock(ip);
801022c3:	83 ec 0c             	sub    $0xc,%esp
801022c6:	56                   	push   %esi
801022c7:	e8 24 f6 ff ff       	call   801018f0 <iunlock>
  iput(ip);
801022cc:	89 34 24             	mov    %esi,(%esp)
801022cf:	e8 6c f6 ff ff       	call   80101940 <iput>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);

  ip->nlink--;
801022d4:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801022d9:	89 1c 24             	mov    %ebx,(%esp)
801022dc:	e8 6f f4 ff ff       	call   80101750 <iupdate>
  iunlock(ip);
801022e1:	89 1c 24             	mov    %ebx,(%esp)
801022e4:	e8 07 f6 ff ff       	call   801018f0 <iunlock>
  iput(ip);
801022e9:	89 1c 24             	mov    %ebx,(%esp)
801022ec:	e8 4f f6 ff ff       	call   80101940 <iput>
  iunlockput(ip);

  end_op();
801022f1:	e8 6a 0f 00 00       	call   80103260 <end_op>

  return 0;
801022f6:	83 c4 10             	add    $0x10,%esp
801022f9:	31 c0                	xor    %eax,%eax
  bad:
    iunlockput(dp);
    end_op();
    return -1;

}
801022fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022fe:	5b                   	pop    %ebx
801022ff:	5e                   	pop    %esi
80102300:	5f                   	pop    %edi
80102301:	5d                   	pop    %ebp
80102302:	c3                   	ret    
80102303:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102307:	90                   	nop
  if(ip->type == T_DIR && !isdirempty(ip)){
80102308:	83 ec 0c             	sub    $0xc,%esp
8010230b:	53                   	push   %ebx
8010230c:	e8 6f 30 00 00       	call   80105380 <isdirempty>
80102311:	83 c4 10             	add    $0x10,%esp
80102314:	85 c0                	test   %eax,%eax
80102316:	0f 85 74 ff ff ff    	jne    80102290 <removeSwapFile+0xe0>
  iunlock(ip);
8010231c:	83 ec 0c             	sub    $0xc,%esp
8010231f:	53                   	push   %ebx
80102320:	e8 cb f5 ff ff       	call   801018f0 <iunlock>
  iput(ip);
80102325:	89 1c 24             	mov    %ebx,(%esp)
80102328:	e8 13 f6 ff ff       	call   80101940 <iput>
    goto bad;
8010232d:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80102330:	83 ec 0c             	sub    $0xc,%esp
80102333:	56                   	push   %esi
80102334:	e8 b7 f5 ff ff       	call   801018f0 <iunlock>
  iput(ip);
80102339:	89 34 24             	mov    %esi,(%esp)
8010233c:	e8 ff f5 ff ff       	call   80101940 <iput>
    end_op();
80102341:	e8 1a 0f 00 00       	call   80103260 <end_op>
    return -1;
80102346:	83 c4 10             	add    $0x10,%esp
80102349:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010234e:	eb ab                	jmp    801022fb <removeSwapFile+0x14b>
    iupdate(dp);
80102350:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80102353:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80102358:	56                   	push   %esi
80102359:	e8 f2 f3 ff ff       	call   80101750 <iupdate>
8010235e:	83 c4 10             	add    $0x10,%esp
80102361:	e9 5d ff ff ff       	jmp    801022c3 <removeSwapFile+0x113>
    return -1;
80102366:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010236b:	eb 8e                	jmp    801022fb <removeSwapFile+0x14b>
    end_op();
8010236d:	e8 ee 0e 00 00       	call   80103260 <end_op>
    return -1;
80102372:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102377:	e9 7f ff ff ff       	jmp    801022fb <removeSwapFile+0x14b>
    panic("unlink: writei");
8010237c:	83 ec 0c             	sub    $0xc,%esp
8010237f:	68 b1 7b 10 80       	push   $0x80107bb1
80102384:	e8 07 e0 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80102389:	83 ec 0c             	sub    $0xc,%esp
8010238c:	68 9f 7b 10 80       	push   $0x80107b9f
80102391:	e8 fa df ff ff       	call   80100390 <panic>
80102396:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010239d:	8d 76 00             	lea    0x0(%esi),%esi

801023a0 <createSwapFile>:


//return 0 on success
int
createSwapFile(struct proc* p)
{
801023a0:	f3 0f 1e fb          	endbr32 
801023a4:	55                   	push   %ebp
801023a5:	89 e5                	mov    %esp,%ebp
801023a7:	56                   	push   %esi
801023a8:	53                   	push   %ebx

  char path[DIGITS];
  memmove(path,"/.swap", 6);
801023a9:	8d 75 ea             	lea    -0x16(%ebp),%esi
{
801023ac:	83 ec 14             	sub    $0x14,%esp
801023af:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
801023b2:	6a 06                	push   $0x6
801023b4:	68 95 7b 10 80       	push   $0x80107b95
801023b9:	56                   	push   %esi
801023ba:	e8 91 28 00 00       	call   80104c50 <memmove>
  itoa(p->pid, path+ 6);
801023bf:	58                   	pop    %eax
801023c0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801023c3:	5a                   	pop    %edx
801023c4:	50                   	push   %eax
801023c5:	ff 73 10             	pushl  0x10(%ebx)
801023c8:	e8 53 fd ff ff       	call   80102120 <itoa>

    begin_op();
801023cd:	e8 1e 0e 00 00       	call   801031f0 <begin_op>
    struct inode * in = create(path, T_FILE, 0, 0);
801023d2:	6a 00                	push   $0x0
801023d4:	6a 00                	push   $0x0
801023d6:	6a 02                	push   $0x2
801023d8:	56                   	push   %esi
801023d9:	e8 c2 31 00 00       	call   801055a0 <create>
  iunlock(in);
801023de:	83 c4 14             	add    $0x14,%esp
801023e1:	50                   	push   %eax
    struct inode * in = create(path, T_FILE, 0, 0);
801023e2:	89 c6                	mov    %eax,%esi
  iunlock(in);
801023e4:	e8 07 f5 ff ff       	call   801018f0 <iunlock>

  p->swapFile = filealloc();
801023e9:	e8 c2 ea ff ff       	call   80100eb0 <filealloc>
  if (p->swapFile == 0)
801023ee:	83 c4 10             	add    $0x10,%esp
  p->swapFile = filealloc();
801023f1:	89 43 7c             	mov    %eax,0x7c(%ebx)
  if (p->swapFile == 0)
801023f4:	85 c0                	test   %eax,%eax
801023f6:	74 32                	je     8010242a <createSwapFile+0x8a>
    panic("no slot for files on /store");

  p->swapFile->ip = in;
801023f8:	89 70 10             	mov    %esi,0x10(%eax)
  p->swapFile->type = FD_INODE;
801023fb:	8b 43 7c             	mov    0x7c(%ebx),%eax
801023fe:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  p->swapFile->off = 0;
80102404:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102407:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  p->swapFile->readable = O_WRONLY;
8010240e:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102411:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  p->swapFile->writable = O_RDWR;
80102415:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102418:	c6 40 09 02          	movb   $0x2,0x9(%eax)
    end_op();
8010241c:	e8 3f 0e 00 00       	call   80103260 <end_op>

    return 0;
}
80102421:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102424:	31 c0                	xor    %eax,%eax
80102426:	5b                   	pop    %ebx
80102427:	5e                   	pop    %esi
80102428:	5d                   	pop    %ebp
80102429:	c3                   	ret    
    panic("no slot for files on /store");
8010242a:	83 ec 0c             	sub    $0xc,%esp
8010242d:	68 c0 7b 10 80       	push   $0x80107bc0
80102432:	e8 59 df ff ff       	call   80100390 <panic>
80102437:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010243e:	66 90                	xchg   %ax,%ax

80102440 <writeToSwapFile>:

//return as sys_write (-1 when error)
int
writeToSwapFile(struct proc* p, char* buffer, uint placeOnFile, uint size)
{
80102440:	f3 0f 1e fb          	endbr32 
80102444:	55                   	push   %ebp
80102445:	89 e5                	mov    %esp,%ebp
80102447:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
8010244a:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010244d:	8b 50 7c             	mov    0x7c(%eax),%edx
80102450:	89 4a 14             	mov    %ecx,0x14(%edx)

  return filewrite(p->swapFile, buffer, size);
80102453:	8b 55 14             	mov    0x14(%ebp),%edx
80102456:	89 55 10             	mov    %edx,0x10(%ebp)
80102459:	8b 40 7c             	mov    0x7c(%eax),%eax
8010245c:	89 45 08             	mov    %eax,0x8(%ebp)

}
8010245f:	5d                   	pop    %ebp
  return filewrite(p->swapFile, buffer, size);
80102460:	e9 db ec ff ff       	jmp    80101140 <filewrite>
80102465:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010246c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102470 <readFromSwapFile>:

//return as sys_read (-1 when error)
int
readFromSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
80102470:	f3 0f 1e fb          	endbr32 
80102474:	55                   	push   %ebp
80102475:	89 e5                	mov    %esp,%ebp
80102477:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
8010247a:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010247d:	8b 50 7c             	mov    0x7c(%eax),%edx
80102480:	89 4a 14             	mov    %ecx,0x14(%edx)

  return fileread(p->swapFile, buffer,  size);
80102483:	8b 55 14             	mov    0x14(%ebp),%edx
80102486:	89 55 10             	mov    %edx,0x10(%ebp)
80102489:	8b 40 7c             	mov    0x7c(%eax),%eax
8010248c:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010248f:	5d                   	pop    %ebp
  return fileread(p->swapFile, buffer,  size);
80102490:	e9 0b ec ff ff       	jmp    801010a0 <fileread>
80102495:	66 90                	xchg   %ax,%ax
80102497:	66 90                	xchg   %ax,%ax
80102499:	66 90                	xchg   %ax,%ax
8010249b:	66 90                	xchg   %ax,%ax
8010249d:	66 90                	xchg   %ax,%ax
8010249f:	90                   	nop

801024a0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801024a0:	55                   	push   %ebp
801024a1:	89 e5                	mov    %esp,%ebp
801024a3:	57                   	push   %edi
801024a4:	56                   	push   %esi
801024a5:	53                   	push   %ebx
801024a6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801024a9:	85 c0                	test   %eax,%eax
801024ab:	0f 84 b4 00 00 00    	je     80102565 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801024b1:	8b 70 08             	mov    0x8(%eax),%esi
801024b4:	89 c3                	mov    %eax,%ebx
801024b6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801024bc:	0f 87 96 00 00 00    	ja     80102558 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024c2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801024c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801024ce:	66 90                	xchg   %ax,%ax
801024d0:	89 ca                	mov    %ecx,%edx
801024d2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801024d3:	83 e0 c0             	and    $0xffffffc0,%eax
801024d6:	3c 40                	cmp    $0x40,%al
801024d8:	75 f6                	jne    801024d0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801024da:	31 ff                	xor    %edi,%edi
801024dc:	ba f6 03 00 00       	mov    $0x3f6,%edx
801024e1:	89 f8                	mov    %edi,%eax
801024e3:	ee                   	out    %al,(%dx)
801024e4:	b8 01 00 00 00       	mov    $0x1,%eax
801024e9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801024ee:	ee                   	out    %al,(%dx)
801024ef:	ba f3 01 00 00       	mov    $0x1f3,%edx
801024f4:	89 f0                	mov    %esi,%eax
801024f6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801024f7:	89 f0                	mov    %esi,%eax
801024f9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801024fe:	c1 f8 08             	sar    $0x8,%eax
80102501:	ee                   	out    %al,(%dx)
80102502:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102507:	89 f8                	mov    %edi,%eax
80102509:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010250a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010250e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102513:	c1 e0 04             	shl    $0x4,%eax
80102516:	83 e0 10             	and    $0x10,%eax
80102519:	83 c8 e0             	or     $0xffffffe0,%eax
8010251c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010251d:	f6 03 04             	testb  $0x4,(%ebx)
80102520:	75 16                	jne    80102538 <idestart+0x98>
80102522:	b8 20 00 00 00       	mov    $0x20,%eax
80102527:	89 ca                	mov    %ecx,%edx
80102529:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010252a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010252d:	5b                   	pop    %ebx
8010252e:	5e                   	pop    %esi
8010252f:	5f                   	pop    %edi
80102530:	5d                   	pop    %ebp
80102531:	c3                   	ret    
80102532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102538:	b8 30 00 00 00       	mov    $0x30,%eax
8010253d:	89 ca                	mov    %ecx,%edx
8010253f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102540:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102545:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102548:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010254d:	fc                   	cld    
8010254e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102550:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102553:	5b                   	pop    %ebx
80102554:	5e                   	pop    %esi
80102555:	5f                   	pop    %edi
80102556:	5d                   	pop    %ebp
80102557:	c3                   	ret    
    panic("incorrect blockno");
80102558:	83 ec 0c             	sub    $0xc,%esp
8010255b:	68 38 7c 10 80       	push   $0x80107c38
80102560:	e8 2b de ff ff       	call   80100390 <panic>
    panic("idestart");
80102565:	83 ec 0c             	sub    $0xc,%esp
80102568:	68 2f 7c 10 80       	push   $0x80107c2f
8010256d:	e8 1e de ff ff       	call   80100390 <panic>
80102572:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102580 <ideinit>:
{
80102580:	f3 0f 1e fb          	endbr32 
80102584:	55                   	push   %ebp
80102585:	89 e5                	mov    %esp,%ebp
80102587:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
8010258a:	68 4a 7c 10 80       	push   $0x80107c4a
8010258f:	68 80 b5 10 80       	push   $0x8010b580
80102594:	e8 87 23 00 00       	call   80104920 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102599:	58                   	pop    %eax
8010259a:	a1 80 1d 12 80       	mov    0x80121d80,%eax
8010259f:	5a                   	pop    %edx
801025a0:	83 e8 01             	sub    $0x1,%eax
801025a3:	50                   	push   %eax
801025a4:	6a 0e                	push   $0xe
801025a6:	e8 b5 02 00 00       	call   80102860 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801025ab:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025ae:	ba f7 01 00 00       	mov    $0x1f7,%edx
801025b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025b7:	90                   	nop
801025b8:	ec                   	in     (%dx),%al
801025b9:	83 e0 c0             	and    $0xffffffc0,%eax
801025bc:	3c 40                	cmp    $0x40,%al
801025be:	75 f8                	jne    801025b8 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025c0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801025c5:	ba f6 01 00 00       	mov    $0x1f6,%edx
801025ca:	ee                   	out    %al,(%dx)
801025cb:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025d0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801025d5:	eb 0e                	jmp    801025e5 <ideinit+0x65>
801025d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025de:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
801025e0:	83 e9 01             	sub    $0x1,%ecx
801025e3:	74 0f                	je     801025f4 <ideinit+0x74>
801025e5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801025e6:	84 c0                	test   %al,%al
801025e8:	74 f6                	je     801025e0 <ideinit+0x60>
      havedisk1 = 1;
801025ea:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
801025f1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025f4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801025f9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801025fe:	ee                   	out    %al,(%dx)
}
801025ff:	c9                   	leave  
80102600:	c3                   	ret    
80102601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102608:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010260f:	90                   	nop

80102610 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102610:	f3 0f 1e fb          	endbr32 
80102614:	55                   	push   %ebp
80102615:	89 e5                	mov    %esp,%ebp
80102617:	57                   	push   %edi
80102618:	56                   	push   %esi
80102619:	53                   	push   %ebx
8010261a:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
8010261d:	68 80 b5 10 80       	push   $0x8010b580
80102622:	e8 79 24 00 00       	call   80104aa0 <acquire>

  if((b = idequeue) == 0){
80102627:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
8010262d:	83 c4 10             	add    $0x10,%esp
80102630:	85 db                	test   %ebx,%ebx
80102632:	74 5f                	je     80102693 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102634:	8b 43 58             	mov    0x58(%ebx),%eax
80102637:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010263c:	8b 33                	mov    (%ebx),%esi
8010263e:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102644:	75 2b                	jne    80102671 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102646:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010264b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010264f:	90                   	nop
80102650:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102651:	89 c1                	mov    %eax,%ecx
80102653:	83 e1 c0             	and    $0xffffffc0,%ecx
80102656:	80 f9 40             	cmp    $0x40,%cl
80102659:	75 f5                	jne    80102650 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010265b:	a8 21                	test   $0x21,%al
8010265d:	75 12                	jne    80102671 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010265f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102662:	b9 80 00 00 00       	mov    $0x80,%ecx
80102667:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010266c:	fc                   	cld    
8010266d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010266f:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102671:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102674:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102677:	83 ce 02             	or     $0x2,%esi
8010267a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010267c:	53                   	push   %ebx
8010267d:	e8 7e 1f 00 00       	call   80104600 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102682:	a1 64 b5 10 80       	mov    0x8010b564,%eax
80102687:	83 c4 10             	add    $0x10,%esp
8010268a:	85 c0                	test   %eax,%eax
8010268c:	74 05                	je     80102693 <ideintr+0x83>
    idestart(idequeue);
8010268e:	e8 0d fe ff ff       	call   801024a0 <idestart>
    release(&idelock);
80102693:	83 ec 0c             	sub    $0xc,%esp
80102696:	68 80 b5 10 80       	push   $0x8010b580
8010269b:	e8 c0 24 00 00       	call   80104b60 <release>

  release(&idelock);
}
801026a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801026a3:	5b                   	pop    %ebx
801026a4:	5e                   	pop    %esi
801026a5:	5f                   	pop    %edi
801026a6:	5d                   	pop    %ebp
801026a7:	c3                   	ret    
801026a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026af:	90                   	nop

801026b0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801026b0:	f3 0f 1e fb          	endbr32 
801026b4:	55                   	push   %ebp
801026b5:	89 e5                	mov    %esp,%ebp
801026b7:	53                   	push   %ebx
801026b8:	83 ec 10             	sub    $0x10,%esp
801026bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801026be:	8d 43 0c             	lea    0xc(%ebx),%eax
801026c1:	50                   	push   %eax
801026c2:	e8 f9 21 00 00       	call   801048c0 <holdingsleep>
801026c7:	83 c4 10             	add    $0x10,%esp
801026ca:	85 c0                	test   %eax,%eax
801026cc:	0f 84 cf 00 00 00    	je     801027a1 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801026d2:	8b 03                	mov    (%ebx),%eax
801026d4:	83 e0 06             	and    $0x6,%eax
801026d7:	83 f8 02             	cmp    $0x2,%eax
801026da:	0f 84 b4 00 00 00    	je     80102794 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801026e0:	8b 53 04             	mov    0x4(%ebx),%edx
801026e3:	85 d2                	test   %edx,%edx
801026e5:	74 0d                	je     801026f4 <iderw+0x44>
801026e7:	a1 60 b5 10 80       	mov    0x8010b560,%eax
801026ec:	85 c0                	test   %eax,%eax
801026ee:	0f 84 93 00 00 00    	je     80102787 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801026f4:	83 ec 0c             	sub    $0xc,%esp
801026f7:	68 80 b5 10 80       	push   $0x8010b580
801026fc:	e8 9f 23 00 00       	call   80104aa0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102701:	a1 64 b5 10 80       	mov    0x8010b564,%eax
  b->qnext = 0;
80102706:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010270d:	83 c4 10             	add    $0x10,%esp
80102710:	85 c0                	test   %eax,%eax
80102712:	74 6c                	je     80102780 <iderw+0xd0>
80102714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102718:	89 c2                	mov    %eax,%edx
8010271a:	8b 40 58             	mov    0x58(%eax),%eax
8010271d:	85 c0                	test   %eax,%eax
8010271f:	75 f7                	jne    80102718 <iderw+0x68>
80102721:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102724:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102726:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
8010272c:	74 42                	je     80102770 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010272e:	8b 03                	mov    (%ebx),%eax
80102730:	83 e0 06             	and    $0x6,%eax
80102733:	83 f8 02             	cmp    $0x2,%eax
80102736:	74 23                	je     8010275b <iderw+0xab>
80102738:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010273f:	90                   	nop
    sleep(b, &idelock);
80102740:	83 ec 08             	sub    $0x8,%esp
80102743:	68 80 b5 10 80       	push   $0x8010b580
80102748:	53                   	push   %ebx
80102749:	e8 f2 1c 00 00       	call   80104440 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010274e:	8b 03                	mov    (%ebx),%eax
80102750:	83 c4 10             	add    $0x10,%esp
80102753:	83 e0 06             	and    $0x6,%eax
80102756:	83 f8 02             	cmp    $0x2,%eax
80102759:	75 e5                	jne    80102740 <iderw+0x90>
  }


  release(&idelock);
8010275b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102762:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102765:	c9                   	leave  
  release(&idelock);
80102766:	e9 f5 23 00 00       	jmp    80104b60 <release>
8010276b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010276f:	90                   	nop
    idestart(b);
80102770:	89 d8                	mov    %ebx,%eax
80102772:	e8 29 fd ff ff       	call   801024a0 <idestart>
80102777:	eb b5                	jmp    8010272e <iderw+0x7e>
80102779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102780:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102785:	eb 9d                	jmp    80102724 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102787:	83 ec 0c             	sub    $0xc,%esp
8010278a:	68 79 7c 10 80       	push   $0x80107c79
8010278f:	e8 fc db ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102794:	83 ec 0c             	sub    $0xc,%esp
80102797:	68 64 7c 10 80       	push   $0x80107c64
8010279c:	e8 ef db ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
801027a1:	83 ec 0c             	sub    $0xc,%esp
801027a4:	68 4e 7c 10 80       	push   $0x80107c4e
801027a9:	e8 e2 db ff ff       	call   80100390 <panic>
801027ae:	66 90                	xchg   %ax,%ax

801027b0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801027b0:	f3 0f 1e fb          	endbr32 
801027b4:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801027b5:	c7 05 74 16 12 80 00 	movl   $0xfec00000,0x80121674
801027bc:	00 c0 fe 
{
801027bf:	89 e5                	mov    %esp,%ebp
801027c1:	56                   	push   %esi
801027c2:	53                   	push   %ebx
  ioapic->reg = reg;
801027c3:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801027ca:	00 00 00 
  return ioapic->data;
801027cd:	8b 15 74 16 12 80    	mov    0x80121674,%edx
801027d3:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801027d6:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801027dc:	8b 0d 74 16 12 80    	mov    0x80121674,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801027e2:	0f b6 15 e0 17 12 80 	movzbl 0x801217e0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801027e9:	c1 ee 10             	shr    $0x10,%esi
801027ec:	89 f0                	mov    %esi,%eax
801027ee:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801027f1:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
801027f4:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801027f7:	39 c2                	cmp    %eax,%edx
801027f9:	74 16                	je     80102811 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801027fb:	83 ec 0c             	sub    $0xc,%esp
801027fe:	68 98 7c 10 80       	push   $0x80107c98
80102803:	e8 a8 de ff ff       	call   801006b0 <cprintf>
80102808:	8b 0d 74 16 12 80    	mov    0x80121674,%ecx
8010280e:	83 c4 10             	add    $0x10,%esp
80102811:	83 c6 21             	add    $0x21,%esi
{
80102814:	ba 10 00 00 00       	mov    $0x10,%edx
80102819:	b8 20 00 00 00       	mov    $0x20,%eax
8010281e:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
80102820:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102822:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102824:	8b 0d 74 16 12 80    	mov    0x80121674,%ecx
8010282a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010282d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102833:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102836:	8d 5a 01             	lea    0x1(%edx),%ebx
80102839:	83 c2 02             	add    $0x2,%edx
8010283c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010283e:	8b 0d 74 16 12 80    	mov    0x80121674,%ecx
80102844:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010284b:	39 f0                	cmp    %esi,%eax
8010284d:	75 d1                	jne    80102820 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010284f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102852:	5b                   	pop    %ebx
80102853:	5e                   	pop    %esi
80102854:	5d                   	pop    %ebp
80102855:	c3                   	ret    
80102856:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010285d:	8d 76 00             	lea    0x0(%esi),%esi

80102860 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102860:	f3 0f 1e fb          	endbr32 
80102864:	55                   	push   %ebp
  ioapic->reg = reg;
80102865:	8b 0d 74 16 12 80    	mov    0x80121674,%ecx
{
8010286b:	89 e5                	mov    %esp,%ebp
8010286d:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102870:	8d 50 20             	lea    0x20(%eax),%edx
80102873:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102877:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102879:	8b 0d 74 16 12 80    	mov    0x80121674,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010287f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102882:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102885:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102888:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010288a:	a1 74 16 12 80       	mov    0x80121674,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010288f:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102892:	89 50 10             	mov    %edx,0x10(%eax)
}
80102895:	5d                   	pop    %ebp
80102896:	c3                   	ret    
80102897:	66 90                	xchg   %ax,%ax
80102899:	66 90                	xchg   %ax,%ax
8010289b:	66 90                	xchg   %ax,%ax
8010289d:	66 90                	xchg   %ax,%ax
8010289f:	90                   	nop

801028a0 <init_cow>:



struct spinlock r_cow_lock;

void init_cow(){
801028a0:	f3 0f 1e fb          	endbr32 
801028a4:	55                   	push   %ebp
801028a5:	89 e5                	mov    %esp,%ebp
801028a7:	83 ec 14             	sub    $0x14,%esp
  cprintf("initing cow\n");
801028aa:	68 ca 7c 10 80       	push   $0x80107cca
801028af:	e8 fc dd ff ff       	call   801006b0 <cprintf>
  memset((void*)pg_ref_counts, 0, sizeof(pg_ref_counts));
801028b4:	83 c4 0c             	add    $0xc,%esp
801028b7:	68 00 e0 00 00       	push   $0xe000
801028bc:	6a 00                	push   $0x0
801028be:	68 40 0f 11 80       	push   $0x80110f40
801028c3:	e8 e8 22 00 00       	call   80104bb0 <memset>
  initlock(&r_cow_lock, "cow lock");
801028c8:	58                   	pop    %eax
801028c9:	5a                   	pop    %edx
801028ca:	68 d7 7c 10 80       	push   $0x80107cd7
801028cf:	68 c0 16 12 80       	push   $0x801216c0
801028d4:	e8 47 20 00 00       	call   80104920 <initlock>
  cow_lock = &r_cow_lock;
  cprintf("initing cow end\n");
801028d9:	c7 04 24 e0 7c 10 80 	movl   $0x80107ce0,(%esp)
  cow_lock = &r_cow_lock;
801028e0:	c7 05 40 ef 11 80 c0 	movl   $0x801216c0,0x8011ef40
801028e7:	16 12 80 
  cprintf("initing cow end\n");
801028ea:	e8 c1 dd ff ff       	call   801006b0 <cprintf>
}
801028ef:	83 c4 10             	add    $0x10,%esp
801028f2:	c9                   	leave  
801028f3:	c3                   	ret    
801028f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028ff:	90                   	nop

80102900 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102900:	f3 0f 1e fb          	endbr32 
80102904:	55                   	push   %ebp
80102905:	89 e5                	mov    %esp,%ebp
80102907:	53                   	push   %ebx
80102908:	83 ec 04             	sub    $0x4,%esp
8010290b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010290e:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102914:	75 7a                	jne    80102990 <kfree+0x90>
80102916:	81 fb 28 1a 13 80    	cmp    $0x80131a28,%ebx
8010291c:	72 72                	jb     80102990 <kfree+0x90>
8010291e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102924:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102929:	77 65                	ja     80102990 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
8010292b:	83 ec 04             	sub    $0x4,%esp
8010292e:	68 00 10 00 00       	push   $0x1000
80102933:	6a 01                	push   $0x1
80102935:	53                   	push   %ebx
80102936:	e8 75 22 00 00       	call   80104bb0 <memset>

  if(kmem.use_lock)
8010293b:	8b 15 b4 16 12 80    	mov    0x801216b4,%edx
80102941:	83 c4 10             	add    $0x10,%esp
80102944:	85 d2                	test   %edx,%edx
80102946:	75 20                	jne    80102968 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102948:	a1 b8 16 12 80       	mov    0x801216b8,%eax
8010294d:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010294f:	a1 b4 16 12 80       	mov    0x801216b4,%eax
  kmem.freelist = r;
80102954:	89 1d b8 16 12 80    	mov    %ebx,0x801216b8
  if(kmem.use_lock)
8010295a:	85 c0                	test   %eax,%eax
8010295c:	75 22                	jne    80102980 <kfree+0x80>
    release(&kmem.lock);
}
8010295e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102961:	c9                   	leave  
80102962:	c3                   	ret    
80102963:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102967:	90                   	nop
    acquire(&kmem.lock);
80102968:	83 ec 0c             	sub    $0xc,%esp
8010296b:	68 80 16 12 80       	push   $0x80121680
80102970:	e8 2b 21 00 00       	call   80104aa0 <acquire>
80102975:	83 c4 10             	add    $0x10,%esp
80102978:	eb ce                	jmp    80102948 <kfree+0x48>
8010297a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102980:	c7 45 08 80 16 12 80 	movl   $0x80121680,0x8(%ebp)
}
80102987:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010298a:	c9                   	leave  
    release(&kmem.lock);
8010298b:	e9 d0 21 00 00       	jmp    80104b60 <release>
    panic("kfree");
80102990:	83 ec 0c             	sub    $0xc,%esp
80102993:	68 7d 84 10 80       	push   $0x8010847d
80102998:	e8 f3 d9 ff ff       	call   80100390 <panic>
8010299d:	8d 76 00             	lea    0x0(%esi),%esi

801029a0 <freerange>:
{
801029a0:	f3 0f 1e fb          	endbr32 
801029a4:	55                   	push   %ebp
801029a5:	89 e5                	mov    %esp,%ebp
801029a7:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801029a8:	8b 45 08             	mov    0x8(%ebp),%eax
{
801029ab:	8b 75 0c             	mov    0xc(%ebp),%esi
801029ae:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801029af:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801029b5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801029bb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801029c1:	39 de                	cmp    %ebx,%esi
801029c3:	72 2f                	jb     801029f4 <freerange+0x54>
801029c5:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
801029c8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801029ce:	83 ec 0c             	sub    $0xc,%esp
801029d1:	50                   	push   %eax
801029d2:	e8 29 ff ff ff       	call   80102900 <kfree>
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
801029d7:	8d 83 00 f0 ff 7f    	lea    0x7ffff000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801029dd:	83 c4 10             	add    $0x10,%esp
801029e0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
801029e6:	c1 e8 0c             	shr    $0xc,%eax
801029e9:	c6 80 40 0f 11 80 00 	movb   $0x0,-0x7feef0c0(%eax)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801029f0:	39 f3                	cmp    %esi,%ebx
801029f2:	76 d4                	jbe    801029c8 <freerange+0x28>
}
801029f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801029f7:	5b                   	pop    %ebx
801029f8:	5e                   	pop    %esi
801029f9:	5d                   	pop    %ebp
801029fa:	c3                   	ret    
801029fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801029ff:	90                   	nop

80102a00 <kinit1>:
{
80102a00:	f3 0f 1e fb          	endbr32 
80102a04:	55                   	push   %ebp
80102a05:	89 e5                	mov    %esp,%ebp
80102a07:	56                   	push   %esi
80102a08:	53                   	push   %ebx
80102a09:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102a0c:	83 ec 08             	sub    $0x8,%esp
80102a0f:	68 f1 7c 10 80       	push   $0x80107cf1
80102a14:	68 80 16 12 80       	push   $0x80121680
80102a19:	e8 02 1f 00 00       	call   80104920 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102a21:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102a24:	c7 05 b4 16 12 80 00 	movl   $0x0,0x801216b4
80102a2b:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80102a2e:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102a34:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102a3a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102a40:	39 de                	cmp    %ebx,%esi
80102a42:	72 30                	jb     80102a74 <kinit1+0x74>
80102a44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102a48:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102a4e:	83 ec 0c             	sub    $0xc,%esp
80102a51:	50                   	push   %eax
80102a52:	e8 a9 fe ff ff       	call   80102900 <kfree>
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
80102a57:	8d 83 00 f0 ff 7f    	lea    0x7ffff000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102a5d:	83 c4 10             	add    $0x10,%esp
80102a60:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
80102a66:	c1 e8 0c             	shr    $0xc,%eax
80102a69:	c6 80 40 0f 11 80 00 	movb   $0x0,-0x7feef0c0(%eax)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102a70:	39 de                	cmp    %ebx,%esi
80102a72:	73 d4                	jae    80102a48 <kinit1+0x48>
}
80102a74:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102a77:	5b                   	pop    %ebx
80102a78:	5e                   	pop    %esi
80102a79:	5d                   	pop    %ebp
80102a7a:	c3                   	ret    
80102a7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a7f:	90                   	nop

80102a80 <kinit2>:
{
80102a80:	f3 0f 1e fb          	endbr32 
80102a84:	55                   	push   %ebp
80102a85:	89 e5                	mov    %esp,%ebp
80102a87:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102a88:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102a8b:	8b 75 0c             	mov    0xc(%ebp),%esi
80102a8e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102a8f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102a95:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102a9b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102aa1:	39 de                	cmp    %ebx,%esi
80102aa3:	72 2f                	jb     80102ad4 <kinit2+0x54>
80102aa5:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102aa8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102aae:	83 ec 0c             	sub    $0xc,%esp
80102ab1:	50                   	push   %eax
80102ab2:	e8 49 fe ff ff       	call   80102900 <kfree>
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
80102ab7:	8d 83 00 f0 ff 7f    	lea    0x7ffff000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102abd:	83 c4 10             	add    $0x10,%esp
80102ac0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    pg_ref_counts[PGROUNDDOWN(V2P(p)) / PGSIZE] = 0;
80102ac6:	c1 e8 0c             	shr    $0xc,%eax
80102ac9:	c6 80 40 0f 11 80 00 	movb   $0x0,-0x7feef0c0(%eax)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102ad0:	39 de                	cmp    %ebx,%esi
80102ad2:	73 d4                	jae    80102aa8 <kinit2+0x28>
  kmem.use_lock = 1;
80102ad4:	c7 05 b4 16 12 80 01 	movl   $0x1,0x801216b4
80102adb:	00 00 00 
}
80102ade:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102ae1:	5b                   	pop    %ebx
80102ae2:	5e                   	pop    %esi
80102ae3:	5d                   	pop    %ebp
80102ae4:	c3                   	ret    
80102ae5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102af0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102af0:	f3 0f 1e fb          	endbr32 
  struct run *r;
  if(kmem.use_lock)
80102af4:	a1 b4 16 12 80       	mov    0x801216b4,%eax
80102af9:	85 c0                	test   %eax,%eax
80102afb:	75 1b                	jne    80102b18 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102afd:	a1 b8 16 12 80       	mov    0x801216b8,%eax
  if(r)
80102b02:	85 c0                	test   %eax,%eax
80102b04:	74 0a                	je     80102b10 <kalloc+0x20>
    kmem.freelist = r->next;
80102b06:	8b 10                	mov    (%eax),%edx
80102b08:	89 15 b8 16 12 80    	mov    %edx,0x801216b8
  if(kmem.use_lock)
80102b0e:	c3                   	ret    
80102b0f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102b10:	c3                   	ret    
80102b11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102b18:	55                   	push   %ebp
80102b19:	89 e5                	mov    %esp,%ebp
80102b1b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
80102b1e:	68 80 16 12 80       	push   $0x80121680
80102b23:	e8 78 1f 00 00       	call   80104aa0 <acquire>
  r = kmem.freelist;
80102b28:	a1 b8 16 12 80       	mov    0x801216b8,%eax
  if(r)
80102b2d:	8b 15 b4 16 12 80    	mov    0x801216b4,%edx
80102b33:	83 c4 10             	add    $0x10,%esp
80102b36:	85 c0                	test   %eax,%eax
80102b38:	74 08                	je     80102b42 <kalloc+0x52>
    kmem.freelist = r->next;
80102b3a:	8b 08                	mov    (%eax),%ecx
80102b3c:	89 0d b8 16 12 80    	mov    %ecx,0x801216b8
  if(kmem.use_lock)
80102b42:	85 d2                	test   %edx,%edx
80102b44:	74 16                	je     80102b5c <kalloc+0x6c>
    release(&kmem.lock);
80102b46:	83 ec 0c             	sub    $0xc,%esp
80102b49:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102b4c:	68 80 16 12 80       	push   $0x80121680
80102b51:	e8 0a 20 00 00       	call   80104b60 <release>
  return (char*)r;
80102b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102b59:	83 c4 10             	add    $0x10,%esp
}
80102b5c:	c9                   	leave  
80102b5d:	c3                   	ret    
80102b5e:	66 90                	xchg   %ax,%ax

80102b60 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102b60:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b64:	ba 64 00 00 00       	mov    $0x64,%edx
80102b69:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102b6a:	a8 01                	test   $0x1,%al
80102b6c:	0f 84 be 00 00 00    	je     80102c30 <kbdgetc+0xd0>
{
80102b72:	55                   	push   %ebp
80102b73:	ba 60 00 00 00       	mov    $0x60,%edx
80102b78:	89 e5                	mov    %esp,%ebp
80102b7a:	53                   	push   %ebx
80102b7b:	ec                   	in     (%dx),%al
  return data;
80102b7c:	8b 1d b4 b5 10 80    	mov    0x8010b5b4,%ebx
    return -1;
  data = inb(KBDATAP);
80102b82:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80102b85:	3c e0                	cmp    $0xe0,%al
80102b87:	74 57                	je     80102be0 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102b89:	89 d9                	mov    %ebx,%ecx
80102b8b:	83 e1 40             	and    $0x40,%ecx
80102b8e:	84 c0                	test   %al,%al
80102b90:	78 5e                	js     80102bf0 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102b92:	85 c9                	test   %ecx,%ecx
80102b94:	74 09                	je     80102b9f <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102b96:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102b99:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102b9c:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102b9f:	0f b6 8a 20 7e 10 80 	movzbl -0x7fef81e0(%edx),%ecx
  shift ^= togglecode[data];
80102ba6:	0f b6 82 20 7d 10 80 	movzbl -0x7fef82e0(%edx),%eax
  shift |= shiftcode[data];
80102bad:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
80102baf:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102bb1:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102bb3:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102bb9:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102bbc:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102bbf:	8b 04 85 00 7d 10 80 	mov    -0x7fef8300(,%eax,4),%eax
80102bc6:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102bca:	74 0b                	je     80102bd7 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
80102bcc:	8d 50 9f             	lea    -0x61(%eax),%edx
80102bcf:	83 fa 19             	cmp    $0x19,%edx
80102bd2:	77 44                	ja     80102c18 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102bd4:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102bd7:	5b                   	pop    %ebx
80102bd8:	5d                   	pop    %ebp
80102bd9:	c3                   	ret    
80102bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102be0:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102be3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102be5:	89 1d b4 b5 10 80    	mov    %ebx,0x8010b5b4
}
80102beb:	5b                   	pop    %ebx
80102bec:	5d                   	pop    %ebp
80102bed:	c3                   	ret    
80102bee:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102bf0:	83 e0 7f             	and    $0x7f,%eax
80102bf3:	85 c9                	test   %ecx,%ecx
80102bf5:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102bf8:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102bfa:	0f b6 8a 20 7e 10 80 	movzbl -0x7fef81e0(%edx),%ecx
80102c01:	83 c9 40             	or     $0x40,%ecx
80102c04:	0f b6 c9             	movzbl %cl,%ecx
80102c07:	f7 d1                	not    %ecx
80102c09:	21 d9                	and    %ebx,%ecx
}
80102c0b:	5b                   	pop    %ebx
80102c0c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
80102c0d:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
80102c13:	c3                   	ret    
80102c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102c18:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102c1b:	8d 50 20             	lea    0x20(%eax),%edx
}
80102c1e:	5b                   	pop    %ebx
80102c1f:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102c20:	83 f9 1a             	cmp    $0x1a,%ecx
80102c23:	0f 42 c2             	cmovb  %edx,%eax
}
80102c26:	c3                   	ret    
80102c27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c2e:	66 90                	xchg   %ax,%ax
    return -1;
80102c30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102c35:	c3                   	ret    
80102c36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c3d:	8d 76 00             	lea    0x0(%esi),%esi

80102c40 <kbdintr>:

void
kbdintr(void)
{
80102c40:	f3 0f 1e fb          	endbr32 
80102c44:	55                   	push   %ebp
80102c45:	89 e5                	mov    %esp,%ebp
80102c47:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102c4a:	68 60 2b 10 80       	push   $0x80102b60
80102c4f:	e8 0c dc ff ff       	call   80100860 <consoleintr>
}
80102c54:	83 c4 10             	add    $0x10,%esp
80102c57:	c9                   	leave  
80102c58:	c3                   	ret    
80102c59:	66 90                	xchg   %ax,%ax
80102c5b:	66 90                	xchg   %ax,%ax
80102c5d:	66 90                	xchg   %ax,%ax
80102c5f:	90                   	nop

80102c60 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102c60:	f3 0f 1e fb          	endbr32 
  if(!lapic)
80102c64:	a1 f4 16 12 80       	mov    0x801216f4,%eax
80102c69:	85 c0                	test   %eax,%eax
80102c6b:	0f 84 c7 00 00 00    	je     80102d38 <lapicinit+0xd8>
  lapic[index] = value;
80102c71:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102c78:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c7b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c7e:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102c85:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c88:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c8b:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102c92:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102c95:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c98:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102c9f:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102ca2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ca5:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102cac:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102caf:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cb2:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102cb9:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102cbc:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102cbf:	8b 50 30             	mov    0x30(%eax),%edx
80102cc2:	c1 ea 10             	shr    $0x10,%edx
80102cc5:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102ccb:	75 73                	jne    80102d40 <lapicinit+0xe0>
  lapic[index] = value;
80102ccd:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102cd4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102cd7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cda:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102ce1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ce4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ce7:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102cee:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102cf1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cf4:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102cfb:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102cfe:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d01:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102d08:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d0b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d0e:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102d15:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102d18:	8b 50 20             	mov    0x20(%eax),%edx
80102d1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d1f:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102d20:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102d26:	80 e6 10             	and    $0x10,%dh
80102d29:	75 f5                	jne    80102d20 <lapicinit+0xc0>
  lapic[index] = value;
80102d2b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102d32:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d35:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102d38:	c3                   	ret    
80102d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102d40:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102d47:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102d4a:	8b 50 20             	mov    0x20(%eax),%edx
}
80102d4d:	e9 7b ff ff ff       	jmp    80102ccd <lapicinit+0x6d>
80102d52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102d60 <lapicid>:

int
lapicid(void)
{
80102d60:	f3 0f 1e fb          	endbr32 
  if (!lapic)
80102d64:	a1 f4 16 12 80       	mov    0x801216f4,%eax
80102d69:	85 c0                	test   %eax,%eax
80102d6b:	74 0b                	je     80102d78 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
80102d6d:	8b 40 20             	mov    0x20(%eax),%eax
80102d70:	c1 e8 18             	shr    $0x18,%eax
80102d73:	c3                   	ret    
80102d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80102d78:	31 c0                	xor    %eax,%eax
}
80102d7a:	c3                   	ret    
80102d7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d7f:	90                   	nop

80102d80 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102d80:	f3 0f 1e fb          	endbr32 
  if(lapic)
80102d84:	a1 f4 16 12 80       	mov    0x801216f4,%eax
80102d89:	85 c0                	test   %eax,%eax
80102d8b:	74 0d                	je     80102d9a <lapiceoi+0x1a>
  lapic[index] = value;
80102d8d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102d94:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d97:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102d9a:	c3                   	ret    
80102d9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d9f:	90                   	nop

80102da0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102da0:	f3 0f 1e fb          	endbr32 
}
80102da4:	c3                   	ret    
80102da5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102db0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102db0:	f3 0f 1e fb          	endbr32 
80102db4:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102db5:	b8 0f 00 00 00       	mov    $0xf,%eax
80102dba:	ba 70 00 00 00       	mov    $0x70,%edx
80102dbf:	89 e5                	mov    %esp,%ebp
80102dc1:	53                   	push   %ebx
80102dc2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102dc5:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102dc8:	ee                   	out    %al,(%dx)
80102dc9:	b8 0a 00 00 00       	mov    $0xa,%eax
80102dce:	ba 71 00 00 00       	mov    $0x71,%edx
80102dd3:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102dd4:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102dd6:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102dd9:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102ddf:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102de1:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102de4:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102de6:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102de9:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102dec:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102df2:	a1 f4 16 12 80       	mov    0x801216f4,%eax
80102df7:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102dfd:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e00:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102e07:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e0a:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e0d:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102e14:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e17:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e1a:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e20:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e23:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e29:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e2c:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e32:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e35:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
80102e3b:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
80102e3c:	8b 40 20             	mov    0x20(%eax),%eax
}
80102e3f:	5d                   	pop    %ebp
80102e40:	c3                   	ret    
80102e41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e4f:	90                   	nop

80102e50 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102e50:	f3 0f 1e fb          	endbr32 
80102e54:	55                   	push   %ebp
80102e55:	b8 0b 00 00 00       	mov    $0xb,%eax
80102e5a:	ba 70 00 00 00       	mov    $0x70,%edx
80102e5f:	89 e5                	mov    %esp,%ebp
80102e61:	57                   	push   %edi
80102e62:	56                   	push   %esi
80102e63:	53                   	push   %ebx
80102e64:	83 ec 4c             	sub    $0x4c,%esp
80102e67:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e68:	ba 71 00 00 00       	mov    $0x71,%edx
80102e6d:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102e6e:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e71:	bb 70 00 00 00       	mov    $0x70,%ebx
80102e76:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e80:	31 c0                	xor    %eax,%eax
80102e82:	89 da                	mov    %ebx,%edx
80102e84:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e85:	b9 71 00 00 00       	mov    $0x71,%ecx
80102e8a:	89 ca                	mov    %ecx,%edx
80102e8c:	ec                   	in     (%dx),%al
80102e8d:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e90:	89 da                	mov    %ebx,%edx
80102e92:	b8 02 00 00 00       	mov    $0x2,%eax
80102e97:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e98:	89 ca                	mov    %ecx,%edx
80102e9a:	ec                   	in     (%dx),%al
80102e9b:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e9e:	89 da                	mov    %ebx,%edx
80102ea0:	b8 04 00 00 00       	mov    $0x4,%eax
80102ea5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ea6:	89 ca                	mov    %ecx,%edx
80102ea8:	ec                   	in     (%dx),%al
80102ea9:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102eac:	89 da                	mov    %ebx,%edx
80102eae:	b8 07 00 00 00       	mov    $0x7,%eax
80102eb3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102eb4:	89 ca                	mov    %ecx,%edx
80102eb6:	ec                   	in     (%dx),%al
80102eb7:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102eba:	89 da                	mov    %ebx,%edx
80102ebc:	b8 08 00 00 00       	mov    $0x8,%eax
80102ec1:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ec2:	89 ca                	mov    %ecx,%edx
80102ec4:	ec                   	in     (%dx),%al
80102ec5:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ec7:	89 da                	mov    %ebx,%edx
80102ec9:	b8 09 00 00 00       	mov    $0x9,%eax
80102ece:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ecf:	89 ca                	mov    %ecx,%edx
80102ed1:	ec                   	in     (%dx),%al
80102ed2:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ed4:	89 da                	mov    %ebx,%edx
80102ed6:	b8 0a 00 00 00       	mov    $0xa,%eax
80102edb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102edc:	89 ca                	mov    %ecx,%edx
80102ede:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102edf:	84 c0                	test   %al,%al
80102ee1:	78 9d                	js     80102e80 <cmostime+0x30>
  return inb(CMOS_RETURN);
80102ee3:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102ee7:	89 fa                	mov    %edi,%edx
80102ee9:	0f b6 fa             	movzbl %dl,%edi
80102eec:	89 f2                	mov    %esi,%edx
80102eee:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102ef1:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102ef5:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ef8:	89 da                	mov    %ebx,%edx
80102efa:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102efd:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102f00:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102f04:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102f07:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102f0a:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102f0e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102f11:	31 c0                	xor    %eax,%eax
80102f13:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f14:	89 ca                	mov    %ecx,%edx
80102f16:	ec                   	in     (%dx),%al
80102f17:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f1a:	89 da                	mov    %ebx,%edx
80102f1c:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102f1f:	b8 02 00 00 00       	mov    $0x2,%eax
80102f24:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f25:	89 ca                	mov    %ecx,%edx
80102f27:	ec                   	in     (%dx),%al
80102f28:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f2b:	89 da                	mov    %ebx,%edx
80102f2d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102f30:	b8 04 00 00 00       	mov    $0x4,%eax
80102f35:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f36:	89 ca                	mov    %ecx,%edx
80102f38:	ec                   	in     (%dx),%al
80102f39:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f3c:	89 da                	mov    %ebx,%edx
80102f3e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102f41:	b8 07 00 00 00       	mov    $0x7,%eax
80102f46:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f47:	89 ca                	mov    %ecx,%edx
80102f49:	ec                   	in     (%dx),%al
80102f4a:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f4d:	89 da                	mov    %ebx,%edx
80102f4f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102f52:	b8 08 00 00 00       	mov    $0x8,%eax
80102f57:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f58:	89 ca                	mov    %ecx,%edx
80102f5a:	ec                   	in     (%dx),%al
80102f5b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f5e:	89 da                	mov    %ebx,%edx
80102f60:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102f63:	b8 09 00 00 00       	mov    $0x9,%eax
80102f68:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f69:	89 ca                	mov    %ecx,%edx
80102f6b:	ec                   	in     (%dx),%al
80102f6c:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102f6f:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102f72:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102f75:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102f78:	6a 18                	push   $0x18
80102f7a:	50                   	push   %eax
80102f7b:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102f7e:	50                   	push   %eax
80102f7f:	e8 7c 1c 00 00       	call   80104c00 <memcmp>
80102f84:	83 c4 10             	add    $0x10,%esp
80102f87:	85 c0                	test   %eax,%eax
80102f89:	0f 85 f1 fe ff ff    	jne    80102e80 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102f8f:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102f93:	75 78                	jne    8010300d <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102f95:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102f98:	89 c2                	mov    %eax,%edx
80102f9a:	83 e0 0f             	and    $0xf,%eax
80102f9d:	c1 ea 04             	shr    $0x4,%edx
80102fa0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102fa3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102fa6:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102fa9:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102fac:	89 c2                	mov    %eax,%edx
80102fae:	83 e0 0f             	and    $0xf,%eax
80102fb1:	c1 ea 04             	shr    $0x4,%edx
80102fb4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102fb7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102fba:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102fbd:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102fc0:	89 c2                	mov    %eax,%edx
80102fc2:	83 e0 0f             	and    $0xf,%eax
80102fc5:	c1 ea 04             	shr    $0x4,%edx
80102fc8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102fcb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102fce:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102fd1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102fd4:	89 c2                	mov    %eax,%edx
80102fd6:	83 e0 0f             	and    $0xf,%eax
80102fd9:	c1 ea 04             	shr    $0x4,%edx
80102fdc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102fdf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102fe2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102fe5:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102fe8:	89 c2                	mov    %eax,%edx
80102fea:	83 e0 0f             	and    $0xf,%eax
80102fed:	c1 ea 04             	shr    $0x4,%edx
80102ff0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ff3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ff6:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102ff9:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ffc:	89 c2                	mov    %eax,%edx
80102ffe:	83 e0 0f             	and    $0xf,%eax
80103001:	c1 ea 04             	shr    $0x4,%edx
80103004:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103007:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010300a:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
8010300d:	8b 75 08             	mov    0x8(%ebp),%esi
80103010:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103013:	89 06                	mov    %eax,(%esi)
80103015:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103018:	89 46 04             	mov    %eax,0x4(%esi)
8010301b:	8b 45 c0             	mov    -0x40(%ebp),%eax
8010301e:	89 46 08             	mov    %eax,0x8(%esi)
80103021:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103024:	89 46 0c             	mov    %eax,0xc(%esi)
80103027:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010302a:	89 46 10             	mov    %eax,0x10(%esi)
8010302d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103030:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80103033:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
8010303a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010303d:	5b                   	pop    %ebx
8010303e:	5e                   	pop    %esi
8010303f:	5f                   	pop    %edi
80103040:	5d                   	pop    %ebp
80103041:	c3                   	ret    
80103042:	66 90                	xchg   %ax,%ax
80103044:	66 90                	xchg   %ax,%ax
80103046:	66 90                	xchg   %ax,%ax
80103048:	66 90                	xchg   %ax,%ax
8010304a:	66 90                	xchg   %ax,%ax
8010304c:	66 90                	xchg   %ax,%ax
8010304e:	66 90                	xchg   %ax,%ax

80103050 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103050:	8b 0d 48 17 12 80    	mov    0x80121748,%ecx
80103056:	85 c9                	test   %ecx,%ecx
80103058:	0f 8e 8a 00 00 00    	jle    801030e8 <install_trans+0x98>
{
8010305e:	55                   	push   %ebp
8010305f:	89 e5                	mov    %esp,%ebp
80103061:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80103062:	31 ff                	xor    %edi,%edi
{
80103064:	56                   	push   %esi
80103065:	53                   	push   %ebx
80103066:	83 ec 0c             	sub    $0xc,%esp
80103069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103070:	a1 34 17 12 80       	mov    0x80121734,%eax
80103075:	83 ec 08             	sub    $0x8,%esp
80103078:	01 f8                	add    %edi,%eax
8010307a:	83 c0 01             	add    $0x1,%eax
8010307d:	50                   	push   %eax
8010307e:	ff 35 44 17 12 80    	pushl  0x80121744
80103084:	e8 47 d0 ff ff       	call   801000d0 <bread>
80103089:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010308b:	58                   	pop    %eax
8010308c:	5a                   	pop    %edx
8010308d:	ff 34 bd 4c 17 12 80 	pushl  -0x7fede8b4(,%edi,4)
80103094:	ff 35 44 17 12 80    	pushl  0x80121744
  for (tail = 0; tail < log.lh.n; tail++) {
8010309a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010309d:	e8 2e d0 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801030a2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801030a5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801030a7:	8d 46 5c             	lea    0x5c(%esi),%eax
801030aa:	68 00 02 00 00       	push   $0x200
801030af:	50                   	push   %eax
801030b0:	8d 43 5c             	lea    0x5c(%ebx),%eax
801030b3:	50                   	push   %eax
801030b4:	e8 97 1b 00 00       	call   80104c50 <memmove>
    bwrite(dbuf);  // write dst to disk
801030b9:	89 1c 24             	mov    %ebx,(%esp)
801030bc:	e8 ef d0 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
801030c1:	89 34 24             	mov    %esi,(%esp)
801030c4:	e8 27 d1 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
801030c9:	89 1c 24             	mov    %ebx,(%esp)
801030cc:	e8 1f d1 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801030d1:	83 c4 10             	add    $0x10,%esp
801030d4:	39 3d 48 17 12 80    	cmp    %edi,0x80121748
801030da:	7f 94                	jg     80103070 <install_trans+0x20>
  }
}
801030dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030df:	5b                   	pop    %ebx
801030e0:	5e                   	pop    %esi
801030e1:	5f                   	pop    %edi
801030e2:	5d                   	pop    %ebp
801030e3:	c3                   	ret    
801030e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801030e8:	c3                   	ret    
801030e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801030f0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801030f0:	55                   	push   %ebp
801030f1:	89 e5                	mov    %esp,%ebp
801030f3:	53                   	push   %ebx
801030f4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
801030f7:	ff 35 34 17 12 80    	pushl  0x80121734
801030fd:	ff 35 44 17 12 80    	pushl  0x80121744
80103103:	e8 c8 cf ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103108:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
8010310b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
8010310d:	a1 48 17 12 80       	mov    0x80121748,%eax
80103112:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80103115:	85 c0                	test   %eax,%eax
80103117:	7e 19                	jle    80103132 <write_head+0x42>
80103119:	31 d2                	xor    %edx,%edx
8010311b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010311f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80103120:	8b 0c 95 4c 17 12 80 	mov    -0x7fede8b4(,%edx,4),%ecx
80103127:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010312b:	83 c2 01             	add    $0x1,%edx
8010312e:	39 d0                	cmp    %edx,%eax
80103130:	75 ee                	jne    80103120 <write_head+0x30>
  }
  bwrite(buf);
80103132:	83 ec 0c             	sub    $0xc,%esp
80103135:	53                   	push   %ebx
80103136:	e8 75 d0 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
8010313b:	89 1c 24             	mov    %ebx,(%esp)
8010313e:	e8 ad d0 ff ff       	call   801001f0 <brelse>
}
80103143:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103146:	83 c4 10             	add    $0x10,%esp
80103149:	c9                   	leave  
8010314a:	c3                   	ret    
8010314b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010314f:	90                   	nop

80103150 <initlog>:
{
80103150:	f3 0f 1e fb          	endbr32 
80103154:	55                   	push   %ebp
80103155:	89 e5                	mov    %esp,%ebp
80103157:	53                   	push   %ebx
80103158:	83 ec 2c             	sub    $0x2c,%esp
8010315b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010315e:	68 20 7f 10 80       	push   $0x80107f20
80103163:	68 00 17 12 80       	push   $0x80121700
80103168:	e8 b3 17 00 00       	call   80104920 <initlock>
  readsb(dev, &sb);
8010316d:	58                   	pop    %eax
8010316e:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103171:	5a                   	pop    %edx
80103172:	50                   	push   %eax
80103173:	53                   	push   %ebx
80103174:	e8 37 e4 ff ff       	call   801015b0 <readsb>
  log.start = sb.logstart;
80103179:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
8010317c:	59                   	pop    %ecx
  log.dev = dev;
8010317d:	89 1d 44 17 12 80    	mov    %ebx,0x80121744
  log.size = sb.nlog;
80103183:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103186:	a3 34 17 12 80       	mov    %eax,0x80121734
  log.size = sb.nlog;
8010318b:	89 15 38 17 12 80    	mov    %edx,0x80121738
  struct buf *buf = bread(log.dev, log.start);
80103191:	5a                   	pop    %edx
80103192:	50                   	push   %eax
80103193:	53                   	push   %ebx
80103194:	e8 37 cf ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80103199:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
8010319c:	8b 48 5c             	mov    0x5c(%eax),%ecx
8010319f:	89 0d 48 17 12 80    	mov    %ecx,0x80121748
  for (i = 0; i < log.lh.n; i++) {
801031a5:	85 c9                	test   %ecx,%ecx
801031a7:	7e 19                	jle    801031c2 <initlog+0x72>
801031a9:	31 d2                	xor    %edx,%edx
801031ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801031af:	90                   	nop
    log.lh.block[i] = lh->block[i];
801031b0:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
801031b4:	89 1c 95 4c 17 12 80 	mov    %ebx,-0x7fede8b4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801031bb:	83 c2 01             	add    $0x1,%edx
801031be:	39 d1                	cmp    %edx,%ecx
801031c0:	75 ee                	jne    801031b0 <initlog+0x60>
  brelse(buf);
801031c2:	83 ec 0c             	sub    $0xc,%esp
801031c5:	50                   	push   %eax
801031c6:	e8 25 d0 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
801031cb:	e8 80 fe ff ff       	call   80103050 <install_trans>
  log.lh.n = 0;
801031d0:	c7 05 48 17 12 80 00 	movl   $0x0,0x80121748
801031d7:	00 00 00 
  write_head(); // clear the log
801031da:	e8 11 ff ff ff       	call   801030f0 <write_head>
}
801031df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801031e2:	83 c4 10             	add    $0x10,%esp
801031e5:	c9                   	leave  
801031e6:	c3                   	ret    
801031e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031ee:	66 90                	xchg   %ax,%ax

801031f0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
801031f0:	f3 0f 1e fb          	endbr32 
801031f4:	55                   	push   %ebp
801031f5:	89 e5                	mov    %esp,%ebp
801031f7:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
801031fa:	68 00 17 12 80       	push   $0x80121700
801031ff:	e8 9c 18 00 00       	call   80104aa0 <acquire>
80103204:	83 c4 10             	add    $0x10,%esp
80103207:	eb 1c                	jmp    80103225 <begin_op+0x35>
80103209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103210:	83 ec 08             	sub    $0x8,%esp
80103213:	68 00 17 12 80       	push   $0x80121700
80103218:	68 00 17 12 80       	push   $0x80121700
8010321d:	e8 1e 12 00 00       	call   80104440 <sleep>
80103222:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80103225:	a1 40 17 12 80       	mov    0x80121740,%eax
8010322a:	85 c0                	test   %eax,%eax
8010322c:	75 e2                	jne    80103210 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
8010322e:	a1 3c 17 12 80       	mov    0x8012173c,%eax
80103233:	8b 15 48 17 12 80    	mov    0x80121748,%edx
80103239:	83 c0 01             	add    $0x1,%eax
8010323c:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
8010323f:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80103242:	83 fa 1e             	cmp    $0x1e,%edx
80103245:	7f c9                	jg     80103210 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80103247:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
8010324a:	a3 3c 17 12 80       	mov    %eax,0x8012173c
      release(&log.lock);
8010324f:	68 00 17 12 80       	push   $0x80121700
80103254:	e8 07 19 00 00       	call   80104b60 <release>
      break;
    }
  }
}
80103259:	83 c4 10             	add    $0x10,%esp
8010325c:	c9                   	leave  
8010325d:	c3                   	ret    
8010325e:	66 90                	xchg   %ax,%ax

80103260 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103260:	f3 0f 1e fb          	endbr32 
80103264:	55                   	push   %ebp
80103265:	89 e5                	mov    %esp,%ebp
80103267:	57                   	push   %edi
80103268:	56                   	push   %esi
80103269:	53                   	push   %ebx
8010326a:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
8010326d:	68 00 17 12 80       	push   $0x80121700
80103272:	e8 29 18 00 00       	call   80104aa0 <acquire>
  log.outstanding -= 1;
80103277:	a1 3c 17 12 80       	mov    0x8012173c,%eax
  if(log.committing)
8010327c:	8b 35 40 17 12 80    	mov    0x80121740,%esi
80103282:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103285:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103288:	89 1d 3c 17 12 80    	mov    %ebx,0x8012173c
  if(log.committing)
8010328e:	85 f6                	test   %esi,%esi
80103290:	0f 85 1e 01 00 00    	jne    801033b4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80103296:	85 db                	test   %ebx,%ebx
80103298:	0f 85 f2 00 00 00    	jne    80103390 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
8010329e:	c7 05 40 17 12 80 01 	movl   $0x1,0x80121740
801032a5:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
801032a8:	83 ec 0c             	sub    $0xc,%esp
801032ab:	68 00 17 12 80       	push   $0x80121700
801032b0:	e8 ab 18 00 00       	call   80104b60 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
801032b5:	8b 0d 48 17 12 80    	mov    0x80121748,%ecx
801032bb:	83 c4 10             	add    $0x10,%esp
801032be:	85 c9                	test   %ecx,%ecx
801032c0:	7f 3e                	jg     80103300 <end_op+0xa0>
    acquire(&log.lock);
801032c2:	83 ec 0c             	sub    $0xc,%esp
801032c5:	68 00 17 12 80       	push   $0x80121700
801032ca:	e8 d1 17 00 00       	call   80104aa0 <acquire>
    wakeup(&log);
801032cf:	c7 04 24 00 17 12 80 	movl   $0x80121700,(%esp)
    log.committing = 0;
801032d6:	c7 05 40 17 12 80 00 	movl   $0x0,0x80121740
801032dd:	00 00 00 
    wakeup(&log);
801032e0:	e8 1b 13 00 00       	call   80104600 <wakeup>
    release(&log.lock);
801032e5:	c7 04 24 00 17 12 80 	movl   $0x80121700,(%esp)
801032ec:	e8 6f 18 00 00       	call   80104b60 <release>
801032f1:	83 c4 10             	add    $0x10,%esp
}
801032f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032f7:	5b                   	pop    %ebx
801032f8:	5e                   	pop    %esi
801032f9:	5f                   	pop    %edi
801032fa:	5d                   	pop    %ebp
801032fb:	c3                   	ret    
801032fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103300:	a1 34 17 12 80       	mov    0x80121734,%eax
80103305:	83 ec 08             	sub    $0x8,%esp
80103308:	01 d8                	add    %ebx,%eax
8010330a:	83 c0 01             	add    $0x1,%eax
8010330d:	50                   	push   %eax
8010330e:	ff 35 44 17 12 80    	pushl  0x80121744
80103314:	e8 b7 cd ff ff       	call   801000d0 <bread>
80103319:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010331b:	58                   	pop    %eax
8010331c:	5a                   	pop    %edx
8010331d:	ff 34 9d 4c 17 12 80 	pushl  -0x7fede8b4(,%ebx,4)
80103324:	ff 35 44 17 12 80    	pushl  0x80121744
  for (tail = 0; tail < log.lh.n; tail++) {
8010332a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010332d:	e8 9e cd ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103332:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103335:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103337:	8d 40 5c             	lea    0x5c(%eax),%eax
8010333a:	68 00 02 00 00       	push   $0x200
8010333f:	50                   	push   %eax
80103340:	8d 46 5c             	lea    0x5c(%esi),%eax
80103343:	50                   	push   %eax
80103344:	e8 07 19 00 00       	call   80104c50 <memmove>
    bwrite(to);  // write the log
80103349:	89 34 24             	mov    %esi,(%esp)
8010334c:	e8 5f ce ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103351:	89 3c 24             	mov    %edi,(%esp)
80103354:	e8 97 ce ff ff       	call   801001f0 <brelse>
    brelse(to);
80103359:	89 34 24             	mov    %esi,(%esp)
8010335c:	e8 8f ce ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103361:	83 c4 10             	add    $0x10,%esp
80103364:	3b 1d 48 17 12 80    	cmp    0x80121748,%ebx
8010336a:	7c 94                	jl     80103300 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010336c:	e8 7f fd ff ff       	call   801030f0 <write_head>
    install_trans(); // Now install writes to home locations
80103371:	e8 da fc ff ff       	call   80103050 <install_trans>
    log.lh.n = 0;
80103376:	c7 05 48 17 12 80 00 	movl   $0x0,0x80121748
8010337d:	00 00 00 
    write_head();    // Erase the transaction from the log
80103380:	e8 6b fd ff ff       	call   801030f0 <write_head>
80103385:	e9 38 ff ff ff       	jmp    801032c2 <end_op+0x62>
8010338a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103390:	83 ec 0c             	sub    $0xc,%esp
80103393:	68 00 17 12 80       	push   $0x80121700
80103398:	e8 63 12 00 00       	call   80104600 <wakeup>
  release(&log.lock);
8010339d:	c7 04 24 00 17 12 80 	movl   $0x80121700,(%esp)
801033a4:	e8 b7 17 00 00       	call   80104b60 <release>
801033a9:	83 c4 10             	add    $0x10,%esp
}
801033ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033af:	5b                   	pop    %ebx
801033b0:	5e                   	pop    %esi
801033b1:	5f                   	pop    %edi
801033b2:	5d                   	pop    %ebp
801033b3:	c3                   	ret    
    panic("log.committing");
801033b4:	83 ec 0c             	sub    $0xc,%esp
801033b7:	68 24 7f 10 80       	push   $0x80107f24
801033bc:	e8 cf cf ff ff       	call   80100390 <panic>
801033c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033cf:	90                   	nop

801033d0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801033d0:	f3 0f 1e fb          	endbr32 
801033d4:	55                   	push   %ebp
801033d5:	89 e5                	mov    %esp,%ebp
801033d7:	53                   	push   %ebx
801033d8:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801033db:	8b 15 48 17 12 80    	mov    0x80121748,%edx
{
801033e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801033e4:	83 fa 1d             	cmp    $0x1d,%edx
801033e7:	0f 8f 91 00 00 00    	jg     8010347e <log_write+0xae>
801033ed:	a1 38 17 12 80       	mov    0x80121738,%eax
801033f2:	83 e8 01             	sub    $0x1,%eax
801033f5:	39 c2                	cmp    %eax,%edx
801033f7:	0f 8d 81 00 00 00    	jge    8010347e <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
801033fd:	a1 3c 17 12 80       	mov    0x8012173c,%eax
80103402:	85 c0                	test   %eax,%eax
80103404:	0f 8e 81 00 00 00    	jle    8010348b <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010340a:	83 ec 0c             	sub    $0xc,%esp
8010340d:	68 00 17 12 80       	push   $0x80121700
80103412:	e8 89 16 00 00       	call   80104aa0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103417:	8b 15 48 17 12 80    	mov    0x80121748,%edx
8010341d:	83 c4 10             	add    $0x10,%esp
80103420:	85 d2                	test   %edx,%edx
80103422:	7e 4e                	jle    80103472 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103424:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80103427:	31 c0                	xor    %eax,%eax
80103429:	eb 0c                	jmp    80103437 <log_write+0x67>
8010342b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010342f:	90                   	nop
80103430:	83 c0 01             	add    $0x1,%eax
80103433:	39 c2                	cmp    %eax,%edx
80103435:	74 29                	je     80103460 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103437:	39 0c 85 4c 17 12 80 	cmp    %ecx,-0x7fede8b4(,%eax,4)
8010343e:	75 f0                	jne    80103430 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103440:	89 0c 85 4c 17 12 80 	mov    %ecx,-0x7fede8b4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103447:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010344a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010344d:	c7 45 08 00 17 12 80 	movl   $0x80121700,0x8(%ebp)
}
80103454:	c9                   	leave  
  release(&log.lock);
80103455:	e9 06 17 00 00       	jmp    80104b60 <release>
8010345a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103460:	89 0c 95 4c 17 12 80 	mov    %ecx,-0x7fede8b4(,%edx,4)
    log.lh.n++;
80103467:	83 c2 01             	add    $0x1,%edx
8010346a:	89 15 48 17 12 80    	mov    %edx,0x80121748
80103470:	eb d5                	jmp    80103447 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80103472:	8b 43 08             	mov    0x8(%ebx),%eax
80103475:	a3 4c 17 12 80       	mov    %eax,0x8012174c
  if (i == log.lh.n)
8010347a:	75 cb                	jne    80103447 <log_write+0x77>
8010347c:	eb e9                	jmp    80103467 <log_write+0x97>
    panic("too big a transaction");
8010347e:	83 ec 0c             	sub    $0xc,%esp
80103481:	68 33 7f 10 80       	push   $0x80107f33
80103486:	e8 05 cf ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
8010348b:	83 ec 0c             	sub    $0xc,%esp
8010348e:	68 49 7f 10 80       	push   $0x80107f49
80103493:	e8 f8 ce ff ff       	call   80100390 <panic>
80103498:	66 90                	xchg   %ax,%ax
8010349a:	66 90                	xchg   %ax,%ax
8010349c:	66 90                	xchg   %ax,%ax
8010349e:	66 90                	xchg   %ax,%ax

801034a0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801034a0:	55                   	push   %ebp
801034a1:	89 e5                	mov    %esp,%ebp
801034a3:	53                   	push   %ebx
801034a4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801034a7:	e8 84 09 00 00       	call   80103e30 <cpuid>
801034ac:	89 c3                	mov    %eax,%ebx
801034ae:	e8 7d 09 00 00       	call   80103e30 <cpuid>
801034b3:	83 ec 04             	sub    $0x4,%esp
801034b6:	53                   	push   %ebx
801034b7:	50                   	push   %eax
801034b8:	68 64 7f 10 80       	push   $0x80107f64
801034bd:	e8 ee d1 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
801034c2:	e8 b9 29 00 00       	call   80105e80 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801034c7:	e8 e4 08 00 00       	call   80103db0 <mycpu>
801034cc:	89 c2                	mov    %eax,%edx
  asm volatile("lock; xchgl %0, %1" :
801034ce:	b8 01 00 00 00       	mov    $0x1,%eax
801034d3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801034da:	e8 71 0c 00 00       	call   80104150 <scheduler>
801034df:	90                   	nop

801034e0 <mpenter>:
{
801034e0:	f3 0f 1e fb          	endbr32 
801034e4:	55                   	push   %ebp
801034e5:	89 e5                	mov    %esp,%ebp
801034e7:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801034ea:	e8 61 3d 00 00       	call   80107250 <switchkvm>
  seginit();
801034ef:	e8 ac 3c 00 00       	call   801071a0 <seginit>
  lapicinit();
801034f4:	e8 67 f7 ff ff       	call   80102c60 <lapicinit>
  mpmain();
801034f9:	e8 a2 ff ff ff       	call   801034a0 <mpmain>
801034fe:	66 90                	xchg   %ax,%ax

80103500 <main>:
{
80103500:	f3 0f 1e fb          	endbr32 
80103504:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103508:	83 e4 f0             	and    $0xfffffff0,%esp
8010350b:	ff 71 fc             	pushl  -0x4(%ecx)
8010350e:	55                   	push   %ebp
8010350f:	89 e5                	mov    %esp,%ebp
80103511:	53                   	push   %ebx
80103512:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103513:	83 ec 08             	sub    $0x8,%esp
80103516:	68 00 00 40 80       	push   $0x80400000
8010351b:	68 28 1a 13 80       	push   $0x80131a28
80103520:	e8 db f4 ff ff       	call   80102a00 <kinit1>
  kvmalloc();      // kernel page table
80103525:	e8 06 42 00 00       	call   80107730 <kvmalloc>
  mpinit();        // detect other processors
8010352a:	e8 91 01 00 00       	call   801036c0 <mpinit>
  lapicinit();     // interrupt controller
8010352f:	e8 2c f7 ff ff       	call   80102c60 <lapicinit>
  init_cow();
80103534:	e8 67 f3 ff ff       	call   801028a0 <init_cow>
  seginit();       // segment descriptors
80103539:	e8 62 3c 00 00       	call   801071a0 <seginit>
  picinit();       // disable pic
8010353e:	e8 5d 03 00 00       	call   801038a0 <picinit>
  ioapicinit();    // another interrupt controller
80103543:	e8 68 f2 ff ff       	call   801027b0 <ioapicinit>
  consoleinit();   // console hardware
80103548:	e8 e3 d4 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
8010354d:	e8 7e 2d 00 00       	call   801062d0 <uartinit>
  pinit();         // process table
80103552:	e8 39 08 00 00       	call   80103d90 <pinit>
  tvinit();        // trap vectors
80103557:	e8 a4 28 00 00       	call   80105e00 <tvinit>
  binit();         // buffer cache
8010355c:	e8 df ca ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103561:	e8 2a d9 ff ff       	call   80100e90 <fileinit>
  ideinit();       // disk 
80103566:	e8 15 f0 ff ff       	call   80102580 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
8010356b:	83 c4 0c             	add    $0xc,%esp
8010356e:	68 8a 00 00 00       	push   $0x8a
80103573:	68 8c b4 10 80       	push   $0x8010b48c
80103578:	68 00 70 00 80       	push   $0x80007000
8010357d:	e8 ce 16 00 00       	call   80104c50 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103582:	83 c4 10             	add    $0x10,%esp
80103585:	69 05 80 1d 12 80 b0 	imul   $0xb0,0x80121d80,%eax
8010358c:	00 00 00 
8010358f:	05 00 18 12 80       	add    $0x80121800,%eax
80103594:	3d 00 18 12 80       	cmp    $0x80121800,%eax
80103599:	76 7d                	jbe    80103618 <main+0x118>
8010359b:	bb 00 18 12 80       	mov    $0x80121800,%ebx
801035a0:	eb 1f                	jmp    801035c1 <main+0xc1>
801035a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801035a8:	69 05 80 1d 12 80 b0 	imul   $0xb0,0x80121d80,%eax
801035af:	00 00 00 
801035b2:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801035b8:	05 00 18 12 80       	add    $0x80121800,%eax
801035bd:	39 c3                	cmp    %eax,%ebx
801035bf:	73 57                	jae    80103618 <main+0x118>
    if(c == mycpu())  // We've started already.
801035c1:	e8 ea 07 00 00       	call   80103db0 <mycpu>
801035c6:	39 c3                	cmp    %eax,%ebx
801035c8:	74 de                	je     801035a8 <main+0xa8>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = cow_kalloc();
801035ca:	e8 41 39 00 00       	call   80106f10 <cow_kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801035cf:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
801035d2:	c7 05 f8 6f 00 80 e0 	movl   $0x801034e0,0x80006ff8
801035d9:	34 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801035dc:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
801035e3:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801035e6:	05 00 10 00 00       	add    $0x1000,%eax
801035eb:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801035f0:	0f b6 03             	movzbl (%ebx),%eax
801035f3:	68 00 70 00 00       	push   $0x7000
801035f8:	50                   	push   %eax
801035f9:	e8 b2 f7 ff ff       	call   80102db0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801035fe:	83 c4 10             	add    $0x10,%esp
80103601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103608:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
8010360e:	85 c0                	test   %eax,%eax
80103610:	74 f6                	je     80103608 <main+0x108>
80103612:	eb 94                	jmp    801035a8 <main+0xa8>
80103614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103618:	83 ec 08             	sub    $0x8,%esp
8010361b:	68 00 00 00 8e       	push   $0x8e000000
80103620:	68 00 00 40 80       	push   $0x80400000
80103625:	e8 56 f4 ff ff       	call   80102a80 <kinit2>
  userinit();      // first user process
8010362a:	e8 51 08 00 00       	call   80103e80 <userinit>
  mpmain();        // finish this processor's setup
8010362f:	e8 6c fe ff ff       	call   801034a0 <mpmain>
80103634:	66 90                	xchg   %ax,%ax
80103636:	66 90                	xchg   %ax,%ax
80103638:	66 90                	xchg   %ax,%ax
8010363a:	66 90                	xchg   %ax,%ax
8010363c:	66 90                	xchg   %ax,%ax
8010363e:	66 90                	xchg   %ax,%ax

80103640 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103640:	55                   	push   %ebp
80103641:	89 e5                	mov    %esp,%ebp
80103643:	57                   	push   %edi
80103644:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103645:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010364b:	53                   	push   %ebx
  e = addr+len;
8010364c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010364f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103652:	39 de                	cmp    %ebx,%esi
80103654:	72 10                	jb     80103666 <mpsearch1+0x26>
80103656:	eb 50                	jmp    801036a8 <mpsearch1+0x68>
80103658:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010365f:	90                   	nop
80103660:	89 fe                	mov    %edi,%esi
80103662:	39 fb                	cmp    %edi,%ebx
80103664:	76 42                	jbe    801036a8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103666:	83 ec 04             	sub    $0x4,%esp
80103669:	8d 7e 10             	lea    0x10(%esi),%edi
8010366c:	6a 04                	push   $0x4
8010366e:	68 78 7f 10 80       	push   $0x80107f78
80103673:	56                   	push   %esi
80103674:	e8 87 15 00 00       	call   80104c00 <memcmp>
80103679:	83 c4 10             	add    $0x10,%esp
8010367c:	85 c0                	test   %eax,%eax
8010367e:	75 e0                	jne    80103660 <mpsearch1+0x20>
80103680:	89 f2                	mov    %esi,%edx
80103682:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103688:	0f b6 0a             	movzbl (%edx),%ecx
8010368b:	83 c2 01             	add    $0x1,%edx
8010368e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103690:	39 fa                	cmp    %edi,%edx
80103692:	75 f4                	jne    80103688 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103694:	84 c0                	test   %al,%al
80103696:	75 c8                	jne    80103660 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103698:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010369b:	89 f0                	mov    %esi,%eax
8010369d:	5b                   	pop    %ebx
8010369e:	5e                   	pop    %esi
8010369f:	5f                   	pop    %edi
801036a0:	5d                   	pop    %ebp
801036a1:	c3                   	ret    
801036a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801036a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801036ab:	31 f6                	xor    %esi,%esi
}
801036ad:	5b                   	pop    %ebx
801036ae:	89 f0                	mov    %esi,%eax
801036b0:	5e                   	pop    %esi
801036b1:	5f                   	pop    %edi
801036b2:	5d                   	pop    %ebp
801036b3:	c3                   	ret    
801036b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801036bf:	90                   	nop

801036c0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801036c0:	f3 0f 1e fb          	endbr32 
801036c4:	55                   	push   %ebp
801036c5:	89 e5                	mov    %esp,%ebp
801036c7:	57                   	push   %edi
801036c8:	56                   	push   %esi
801036c9:	53                   	push   %ebx
801036ca:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801036cd:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801036d4:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801036db:	c1 e0 08             	shl    $0x8,%eax
801036de:	09 d0                	or     %edx,%eax
801036e0:	c1 e0 04             	shl    $0x4,%eax
801036e3:	75 1b                	jne    80103700 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801036e5:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801036ec:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801036f3:	c1 e0 08             	shl    $0x8,%eax
801036f6:	09 d0                	or     %edx,%eax
801036f8:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801036fb:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103700:	ba 00 04 00 00       	mov    $0x400,%edx
80103705:	e8 36 ff ff ff       	call   80103640 <mpsearch1>
8010370a:	89 c6                	mov    %eax,%esi
8010370c:	85 c0                	test   %eax,%eax
8010370e:	0f 84 4c 01 00 00    	je     80103860 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103714:	8b 5e 04             	mov    0x4(%esi),%ebx
80103717:	85 db                	test   %ebx,%ebx
80103719:	0f 84 61 01 00 00    	je     80103880 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
8010371f:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103722:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103728:	6a 04                	push   $0x4
8010372a:	68 7d 7f 10 80       	push   $0x80107f7d
8010372f:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103730:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103733:	e8 c8 14 00 00       	call   80104c00 <memcmp>
80103738:	83 c4 10             	add    $0x10,%esp
8010373b:	85 c0                	test   %eax,%eax
8010373d:	0f 85 3d 01 00 00    	jne    80103880 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
80103743:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
8010374a:	3c 01                	cmp    $0x1,%al
8010374c:	74 08                	je     80103756 <mpinit+0x96>
8010374e:	3c 04                	cmp    $0x4,%al
80103750:	0f 85 2a 01 00 00    	jne    80103880 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
80103756:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
8010375d:	66 85 d2             	test   %dx,%dx
80103760:	74 26                	je     80103788 <mpinit+0xc8>
80103762:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
80103765:	89 d8                	mov    %ebx,%eax
  sum = 0;
80103767:	31 d2                	xor    %edx,%edx
80103769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103770:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
80103777:	83 c0 01             	add    $0x1,%eax
8010377a:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
8010377c:	39 f8                	cmp    %edi,%eax
8010377e:	75 f0                	jne    80103770 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
80103780:	84 d2                	test   %dl,%dl
80103782:	0f 85 f8 00 00 00    	jne    80103880 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103788:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
8010378e:	a3 f4 16 12 80       	mov    %eax,0x801216f4
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103793:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80103799:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
801037a0:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801037a5:	03 55 e4             	add    -0x1c(%ebp),%edx
801037a8:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801037ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037af:	90                   	nop
801037b0:	39 c2                	cmp    %eax,%edx
801037b2:	76 15                	jbe    801037c9 <mpinit+0x109>
    switch(*p){
801037b4:	0f b6 08             	movzbl (%eax),%ecx
801037b7:	80 f9 02             	cmp    $0x2,%cl
801037ba:	74 5c                	je     80103818 <mpinit+0x158>
801037bc:	77 42                	ja     80103800 <mpinit+0x140>
801037be:	84 c9                	test   %cl,%cl
801037c0:	74 6e                	je     80103830 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801037c2:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801037c5:	39 c2                	cmp    %eax,%edx
801037c7:	77 eb                	ja     801037b4 <mpinit+0xf4>
801037c9:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801037cc:	85 db                	test   %ebx,%ebx
801037ce:	0f 84 b9 00 00 00    	je     8010388d <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801037d4:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
801037d8:	74 15                	je     801037ef <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801037da:	b8 70 00 00 00       	mov    $0x70,%eax
801037df:	ba 22 00 00 00       	mov    $0x22,%edx
801037e4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801037e5:	ba 23 00 00 00       	mov    $0x23,%edx
801037ea:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801037eb:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801037ee:	ee                   	out    %al,(%dx)
  }
}
801037ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037f2:	5b                   	pop    %ebx
801037f3:	5e                   	pop    %esi
801037f4:	5f                   	pop    %edi
801037f5:	5d                   	pop    %ebp
801037f6:	c3                   	ret    
801037f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037fe:	66 90                	xchg   %ax,%ax
    switch(*p){
80103800:	83 e9 03             	sub    $0x3,%ecx
80103803:	80 f9 01             	cmp    $0x1,%cl
80103806:	76 ba                	jbe    801037c2 <mpinit+0x102>
80103808:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010380f:	eb 9f                	jmp    801037b0 <mpinit+0xf0>
80103811:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103818:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
8010381c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010381f:	88 0d e0 17 12 80    	mov    %cl,0x801217e0
      continue;
80103825:	eb 89                	jmp    801037b0 <mpinit+0xf0>
80103827:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010382e:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103830:	8b 0d 80 1d 12 80    	mov    0x80121d80,%ecx
80103836:	83 f9 07             	cmp    $0x7,%ecx
80103839:	7f 19                	jg     80103854 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010383b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103841:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103845:	83 c1 01             	add    $0x1,%ecx
80103848:	89 0d 80 1d 12 80    	mov    %ecx,0x80121d80
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010384e:	88 9f 00 18 12 80    	mov    %bl,-0x7fede800(%edi)
      p += sizeof(struct mpproc);
80103854:	83 c0 14             	add    $0x14,%eax
      continue;
80103857:	e9 54 ff ff ff       	jmp    801037b0 <mpinit+0xf0>
8010385c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
80103860:	ba 00 00 01 00       	mov    $0x10000,%edx
80103865:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010386a:	e8 d1 fd ff ff       	call   80103640 <mpsearch1>
8010386f:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103871:	85 c0                	test   %eax,%eax
80103873:	0f 85 9b fe ff ff    	jne    80103714 <mpinit+0x54>
80103879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103880:	83 ec 0c             	sub    $0xc,%esp
80103883:	68 82 7f 10 80       	push   $0x80107f82
80103888:	e8 03 cb ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010388d:	83 ec 0c             	sub    $0xc,%esp
80103890:	68 9c 7f 10 80       	push   $0x80107f9c
80103895:	e8 f6 ca ff ff       	call   80100390 <panic>
8010389a:	66 90                	xchg   %ax,%ax
8010389c:	66 90                	xchg   %ax,%ax
8010389e:	66 90                	xchg   %ax,%ax

801038a0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801038a0:	f3 0f 1e fb          	endbr32 
801038a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801038a9:	ba 21 00 00 00       	mov    $0x21,%edx
801038ae:	ee                   	out    %al,(%dx)
801038af:	ba a1 00 00 00       	mov    $0xa1,%edx
801038b4:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801038b5:	c3                   	ret    
801038b6:	66 90                	xchg   %ax,%ax
801038b8:	66 90                	xchg   %ax,%ax
801038ba:	66 90                	xchg   %ax,%ax
801038bc:	66 90                	xchg   %ax,%ax
801038be:	66 90                	xchg   %ax,%ax

801038c0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801038c0:	f3 0f 1e fb          	endbr32 
801038c4:	55                   	push   %ebp
801038c5:	89 e5                	mov    %esp,%ebp
801038c7:	57                   	push   %edi
801038c8:	56                   	push   %esi
801038c9:	53                   	push   %ebx
801038ca:	83 ec 0c             	sub    $0xc,%esp
801038cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
801038d0:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801038d3:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801038d9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801038df:	e8 cc d5 ff ff       	call   80100eb0 <filealloc>
801038e4:	89 03                	mov    %eax,(%ebx)
801038e6:	85 c0                	test   %eax,%eax
801038e8:	0f 84 ac 00 00 00    	je     8010399a <pipealloc+0xda>
801038ee:	e8 bd d5 ff ff       	call   80100eb0 <filealloc>
801038f3:	89 06                	mov    %eax,(%esi)
801038f5:	85 c0                	test   %eax,%eax
801038f7:	0f 84 8b 00 00 00    	je     80103988 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)cow_kalloc()) == 0)
801038fd:	e8 0e 36 00 00       	call   80106f10 <cow_kalloc>
80103902:	89 c7                	mov    %eax,%edi
80103904:	85 c0                	test   %eax,%eax
80103906:	0f 84 b4 00 00 00    	je     801039c0 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
8010390c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103913:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103916:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103919:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103920:	00 00 00 
  p->nwrite = 0;
80103923:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010392a:	00 00 00 
  p->nread = 0;
8010392d:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103934:	00 00 00 
  initlock(&p->lock, "pipe");
80103937:	68 bb 7f 10 80       	push   $0x80107fbb
8010393c:	50                   	push   %eax
8010393d:	e8 de 0f 00 00       	call   80104920 <initlock>
  (*f0)->type = FD_PIPE;
80103942:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103944:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103947:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
8010394d:	8b 03                	mov    (%ebx),%eax
8010394f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103953:	8b 03                	mov    (%ebx),%eax
80103955:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103959:	8b 03                	mov    (%ebx),%eax
8010395b:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010395e:	8b 06                	mov    (%esi),%eax
80103960:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103966:	8b 06                	mov    (%esi),%eax
80103968:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
8010396c:	8b 06                	mov    (%esi),%eax
8010396e:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103972:	8b 06                	mov    (%esi),%eax
80103974:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103977:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010397a:	31 c0                	xor    %eax,%eax
}
8010397c:	5b                   	pop    %ebx
8010397d:	5e                   	pop    %esi
8010397e:	5f                   	pop    %edi
8010397f:	5d                   	pop    %ebp
80103980:	c3                   	ret    
80103981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103988:	8b 03                	mov    (%ebx),%eax
8010398a:	85 c0                	test   %eax,%eax
8010398c:	74 1e                	je     801039ac <pipealloc+0xec>
    fileclose(*f0);
8010398e:	83 ec 0c             	sub    $0xc,%esp
80103991:	50                   	push   %eax
80103992:	e8 d9 d5 ff ff       	call   80100f70 <fileclose>
80103997:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010399a:	8b 06                	mov    (%esi),%eax
8010399c:	85 c0                	test   %eax,%eax
8010399e:	74 0c                	je     801039ac <pipealloc+0xec>
    fileclose(*f1);
801039a0:	83 ec 0c             	sub    $0xc,%esp
801039a3:	50                   	push   %eax
801039a4:	e8 c7 d5 ff ff       	call   80100f70 <fileclose>
801039a9:	83 c4 10             	add    $0x10,%esp
}
801039ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801039af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801039b4:	5b                   	pop    %ebx
801039b5:	5e                   	pop    %esi
801039b6:	5f                   	pop    %edi
801039b7:	5d                   	pop    %ebp
801039b8:	c3                   	ret    
801039b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801039c0:	8b 03                	mov    (%ebx),%eax
801039c2:	85 c0                	test   %eax,%eax
801039c4:	75 c8                	jne    8010398e <pipealloc+0xce>
801039c6:	eb d2                	jmp    8010399a <pipealloc+0xda>
801039c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039cf:	90                   	nop

801039d0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801039d0:	f3 0f 1e fb          	endbr32 
801039d4:	55                   	push   %ebp
801039d5:	89 e5                	mov    %esp,%ebp
801039d7:	56                   	push   %esi
801039d8:	53                   	push   %ebx
801039d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801039dc:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801039df:	83 ec 0c             	sub    $0xc,%esp
801039e2:	53                   	push   %ebx
801039e3:	e8 b8 10 00 00       	call   80104aa0 <acquire>
  if(writable){
801039e8:	83 c4 10             	add    $0x10,%esp
801039eb:	85 f6                	test   %esi,%esi
801039ed:	74 41                	je     80103a30 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801039ef:	83 ec 0c             	sub    $0xc,%esp
801039f2:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
801039f8:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801039ff:	00 00 00 
    wakeup(&p->nread);
80103a02:	50                   	push   %eax
80103a03:	e8 f8 0b 00 00       	call   80104600 <wakeup>
80103a08:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103a0b:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103a11:	85 d2                	test   %edx,%edx
80103a13:	75 0a                	jne    80103a1f <pipeclose+0x4f>
80103a15:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103a1b:	85 c0                	test   %eax,%eax
80103a1d:	74 31                	je     80103a50 <pipeclose+0x80>
    release(&p->lock);
    cow_kfree((char*)p);
  } else
    release(&p->lock);
80103a1f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103a22:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a25:	5b                   	pop    %ebx
80103a26:	5e                   	pop    %esi
80103a27:	5d                   	pop    %ebp
    release(&p->lock);
80103a28:	e9 33 11 00 00       	jmp    80104b60 <release>
80103a2d:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103a30:	83 ec 0c             	sub    $0xc,%esp
80103a33:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103a39:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103a40:	00 00 00 
    wakeup(&p->nwrite);
80103a43:	50                   	push   %eax
80103a44:	e8 b7 0b 00 00       	call   80104600 <wakeup>
80103a49:	83 c4 10             	add    $0x10,%esp
80103a4c:	eb bd                	jmp    80103a0b <pipeclose+0x3b>
80103a4e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103a50:	83 ec 0c             	sub    $0xc,%esp
80103a53:	53                   	push   %ebx
80103a54:	e8 07 11 00 00       	call   80104b60 <release>
    cow_kfree((char*)p);
80103a59:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103a5c:	83 c4 10             	add    $0x10,%esp
}
80103a5f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a62:	5b                   	pop    %ebx
80103a63:	5e                   	pop    %esi
80103a64:	5d                   	pop    %ebp
    cow_kfree((char*)p);
80103a65:	e9 e6 33 00 00       	jmp    80106e50 <cow_kfree>
80103a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a70 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103a70:	f3 0f 1e fb          	endbr32 
80103a74:	55                   	push   %ebp
80103a75:	89 e5                	mov    %esp,%ebp
80103a77:	57                   	push   %edi
80103a78:	56                   	push   %esi
80103a79:	53                   	push   %ebx
80103a7a:	83 ec 28             	sub    $0x28,%esp
80103a7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103a80:	53                   	push   %ebx
80103a81:	e8 1a 10 00 00       	call   80104aa0 <acquire>
  for(i = 0; i < n; i++){
80103a86:	8b 45 10             	mov    0x10(%ebp),%eax
80103a89:	83 c4 10             	add    $0x10,%esp
80103a8c:	85 c0                	test   %eax,%eax
80103a8e:	0f 8e bc 00 00 00    	jle    80103b50 <pipewrite+0xe0>
80103a94:	8b 45 0c             	mov    0xc(%ebp),%eax
80103a97:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103a9d:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103aa3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103aa6:	03 45 10             	add    0x10(%ebp),%eax
80103aa9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103aac:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103ab2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103ab8:	89 ca                	mov    %ecx,%edx
80103aba:	05 00 02 00 00       	add    $0x200,%eax
80103abf:	39 c1                	cmp    %eax,%ecx
80103ac1:	74 3b                	je     80103afe <pipewrite+0x8e>
80103ac3:	eb 63                	jmp    80103b28 <pipewrite+0xb8>
80103ac5:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103ac8:	e8 83 03 00 00       	call   80103e50 <myproc>
80103acd:	8b 48 24             	mov    0x24(%eax),%ecx
80103ad0:	85 c9                	test   %ecx,%ecx
80103ad2:	75 34                	jne    80103b08 <pipewrite+0x98>
      wakeup(&p->nread);
80103ad4:	83 ec 0c             	sub    $0xc,%esp
80103ad7:	57                   	push   %edi
80103ad8:	e8 23 0b 00 00       	call   80104600 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103add:	58                   	pop    %eax
80103ade:	5a                   	pop    %edx
80103adf:	53                   	push   %ebx
80103ae0:	56                   	push   %esi
80103ae1:	e8 5a 09 00 00       	call   80104440 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103ae6:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103aec:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103af2:	83 c4 10             	add    $0x10,%esp
80103af5:	05 00 02 00 00       	add    $0x200,%eax
80103afa:	39 c2                	cmp    %eax,%edx
80103afc:	75 2a                	jne    80103b28 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
80103afe:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103b04:	85 c0                	test   %eax,%eax
80103b06:	75 c0                	jne    80103ac8 <pipewrite+0x58>
        release(&p->lock);
80103b08:	83 ec 0c             	sub    $0xc,%esp
80103b0b:	53                   	push   %ebx
80103b0c:	e8 4f 10 00 00       	call   80104b60 <release>
        return -1;
80103b11:	83 c4 10             	add    $0x10,%esp
80103b14:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103b19:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b1c:	5b                   	pop    %ebx
80103b1d:	5e                   	pop    %esi
80103b1e:	5f                   	pop    %edi
80103b1f:	5d                   	pop    %ebp
80103b20:	c3                   	ret    
80103b21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103b28:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103b2b:	8d 4a 01             	lea    0x1(%edx),%ecx
80103b2e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103b34:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
80103b3a:	0f b6 06             	movzbl (%esi),%eax
80103b3d:	83 c6 01             	add    $0x1,%esi
80103b40:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103b43:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103b47:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103b4a:	0f 85 5c ff ff ff    	jne    80103aac <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103b50:	83 ec 0c             	sub    $0xc,%esp
80103b53:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103b59:	50                   	push   %eax
80103b5a:	e8 a1 0a 00 00       	call   80104600 <wakeup>
  release(&p->lock);
80103b5f:	89 1c 24             	mov    %ebx,(%esp)
80103b62:	e8 f9 0f 00 00       	call   80104b60 <release>
  return n;
80103b67:	8b 45 10             	mov    0x10(%ebp),%eax
80103b6a:	83 c4 10             	add    $0x10,%esp
80103b6d:	eb aa                	jmp    80103b19 <pipewrite+0xa9>
80103b6f:	90                   	nop

80103b70 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103b70:	f3 0f 1e fb          	endbr32 
80103b74:	55                   	push   %ebp
80103b75:	89 e5                	mov    %esp,%ebp
80103b77:	57                   	push   %edi
80103b78:	56                   	push   %esi
80103b79:	53                   	push   %ebx
80103b7a:	83 ec 18             	sub    $0x18,%esp
80103b7d:	8b 75 08             	mov    0x8(%ebp),%esi
80103b80:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103b83:	56                   	push   %esi
80103b84:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103b8a:	e8 11 0f 00 00       	call   80104aa0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103b8f:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103b95:	83 c4 10             	add    $0x10,%esp
80103b98:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
80103b9e:	74 33                	je     80103bd3 <piperead+0x63>
80103ba0:	eb 3b                	jmp    80103bdd <piperead+0x6d>
80103ba2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
80103ba8:	e8 a3 02 00 00       	call   80103e50 <myproc>
80103bad:	8b 48 24             	mov    0x24(%eax),%ecx
80103bb0:	85 c9                	test   %ecx,%ecx
80103bb2:	0f 85 88 00 00 00    	jne    80103c40 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103bb8:	83 ec 08             	sub    $0x8,%esp
80103bbb:	56                   	push   %esi
80103bbc:	53                   	push   %ebx
80103bbd:	e8 7e 08 00 00       	call   80104440 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103bc2:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103bc8:	83 c4 10             	add    $0x10,%esp
80103bcb:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103bd1:	75 0a                	jne    80103bdd <piperead+0x6d>
80103bd3:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103bd9:	85 c0                	test   %eax,%eax
80103bdb:	75 cb                	jne    80103ba8 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103bdd:	8b 55 10             	mov    0x10(%ebp),%edx
80103be0:	31 db                	xor    %ebx,%ebx
80103be2:	85 d2                	test   %edx,%edx
80103be4:	7f 28                	jg     80103c0e <piperead+0x9e>
80103be6:	eb 34                	jmp    80103c1c <piperead+0xac>
80103be8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bef:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103bf0:	8d 48 01             	lea    0x1(%eax),%ecx
80103bf3:	25 ff 01 00 00       	and    $0x1ff,%eax
80103bf8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80103bfe:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103c03:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103c06:	83 c3 01             	add    $0x1,%ebx
80103c09:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103c0c:	74 0e                	je     80103c1c <piperead+0xac>
    if(p->nread == p->nwrite)
80103c0e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103c14:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103c1a:	75 d4                	jne    80103bf0 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103c1c:	83 ec 0c             	sub    $0xc,%esp
80103c1f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103c25:	50                   	push   %eax
80103c26:	e8 d5 09 00 00       	call   80104600 <wakeup>
  release(&p->lock);
80103c2b:	89 34 24             	mov    %esi,(%esp)
80103c2e:	e8 2d 0f 00 00       	call   80104b60 <release>
  return i;
80103c33:	83 c4 10             	add    $0x10,%esp
}
80103c36:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c39:	89 d8                	mov    %ebx,%eax
80103c3b:	5b                   	pop    %ebx
80103c3c:	5e                   	pop    %esi
80103c3d:	5f                   	pop    %edi
80103c3e:	5d                   	pop    %ebp
80103c3f:	c3                   	ret    
      release(&p->lock);
80103c40:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103c43:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103c48:	56                   	push   %esi
80103c49:	e8 12 0f 00 00       	call   80104b60 <release>
      return -1;
80103c4e:	83 c4 10             	add    $0x10,%esp
}
80103c51:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c54:	89 d8                	mov    %ebx,%eax
80103c56:	5b                   	pop    %ebx
80103c57:	5e                   	pop    %esi
80103c58:	5f                   	pop    %edi
80103c59:	5d                   	pop    %ebp
80103c5a:	c3                   	ret    
80103c5b:	66 90                	xchg   %ax,%ax
80103c5d:	66 90                	xchg   %ax,%ax
80103c5f:	90                   	nop

80103c60 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103c60:	55                   	push   %ebp
80103c61:	89 e5                	mov    %esp,%ebp
80103c63:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c64:	bb d4 1d 12 80       	mov    $0x80121dd4,%ebx
{
80103c69:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103c6c:	68 a0 1d 12 80       	push   $0x80121da0
80103c71:	e8 2a 0e 00 00       	call   80104aa0 <acquire>
80103c76:	83 c4 10             	add    $0x10,%esp
80103c79:	eb 13                	jmp    80103c8e <allocproc+0x2e>
80103c7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c7f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c80:	81 c3 d0 03 00 00    	add    $0x3d0,%ebx
80103c86:	81 fb d4 11 13 80    	cmp    $0x801311d4,%ebx
80103c8c:	74 7a                	je     80103d08 <allocproc+0xa8>
    if(p->state == UNUSED)
80103c8e:	8b 43 0c             	mov    0xc(%ebx),%eax
80103c91:	85 c0                	test   %eax,%eax
80103c93:	75 eb                	jne    80103c80 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103c95:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80103c9a:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103c9d:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103ca4:	89 43 10             	mov    %eax,0x10(%ebx)
80103ca7:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103caa:	68 a0 1d 12 80       	push   $0x80121da0
  p->pid = nextpid++;
80103caf:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103cb5:	e8 a6 0e 00 00       	call   80104b60 <release>

  // Allocate kernel stack.
  if((p->kstack = cow_kalloc()) == 0){
80103cba:	e8 51 32 00 00       	call   80106f10 <cow_kalloc>
80103cbf:	83 c4 10             	add    $0x10,%esp
80103cc2:	89 43 08             	mov    %eax,0x8(%ebx)
80103cc5:	85 c0                	test   %eax,%eax
80103cc7:	74 58                	je     80103d21 <allocproc+0xc1>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103cc9:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103ccf:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103cd2:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103cd7:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103cda:	c7 40 14 f1 5d 10 80 	movl   $0x80105df1,0x14(%eax)
  p->context = (struct context*)sp;
80103ce1:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103ce4:	6a 14                	push   $0x14
80103ce6:	6a 00                	push   $0x0
80103ce8:	50                   	push   %eax
80103ce9:	e8 c2 0e 00 00       	call   80104bb0 <memset>
  p->context->eip = (uint)forkret;
80103cee:	8b 43 1c             	mov    0x1c(%ebx),%eax
      p->advance_queue[i] = -1;
      #endif
    }
 }
 #endif
  return p;
80103cf1:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103cf4:	c7 40 10 40 3d 10 80 	movl   $0x80103d40,0x10(%eax)
}
80103cfb:	89 d8                	mov    %ebx,%eax
80103cfd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d00:	c9                   	leave  
80103d01:	c3                   	ret    
80103d02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103d08:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103d0b:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103d0d:	68 a0 1d 12 80       	push   $0x80121da0
80103d12:	e8 49 0e 00 00       	call   80104b60 <release>
}
80103d17:	89 d8                	mov    %ebx,%eax
  return 0;
80103d19:	83 c4 10             	add    $0x10,%esp
}
80103d1c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d1f:	c9                   	leave  
80103d20:	c3                   	ret    
    p->state = UNUSED;
80103d21:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103d28:	31 db                	xor    %ebx,%ebx
}
80103d2a:	89 d8                	mov    %ebx,%eax
80103d2c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d2f:	c9                   	leave  
80103d30:	c3                   	ret    
80103d31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d3f:	90                   	nop

80103d40 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103d40:	f3 0f 1e fb          	endbr32 
80103d44:	55                   	push   %ebp
80103d45:	89 e5                	mov    %esp,%ebp
80103d47:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103d4a:	68 a0 1d 12 80       	push   $0x80121da0
80103d4f:	e8 0c 0e 00 00       	call   80104b60 <release>

  if (first) {
80103d54:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103d59:	83 c4 10             	add    $0x10,%esp
80103d5c:	85 c0                	test   %eax,%eax
80103d5e:	75 08                	jne    80103d68 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103d60:	c9                   	leave  
80103d61:	c3                   	ret    
80103d62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
80103d68:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103d6f:	00 00 00 
    iinit(ROOTDEV);
80103d72:	83 ec 0c             	sub    $0xc,%esp
80103d75:	6a 01                	push   $0x1
80103d77:	e8 74 d8 ff ff       	call   801015f0 <iinit>
    initlog(ROOTDEV);
80103d7c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103d83:	e8 c8 f3 ff ff       	call   80103150 <initlog>
}
80103d88:	83 c4 10             	add    $0x10,%esp
80103d8b:	c9                   	leave  
80103d8c:	c3                   	ret    
80103d8d:	8d 76 00             	lea    0x0(%esi),%esi

80103d90 <pinit>:
{
80103d90:	f3 0f 1e fb          	endbr32 
80103d94:	55                   	push   %ebp
80103d95:	89 e5                	mov    %esp,%ebp
80103d97:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103d9a:	68 c0 7f 10 80       	push   $0x80107fc0
80103d9f:	68 a0 1d 12 80       	push   $0x80121da0
80103da4:	e8 77 0b 00 00       	call   80104920 <initlock>
}
80103da9:	83 c4 10             	add    $0x10,%esp
80103dac:	c9                   	leave  
80103dad:	c3                   	ret    
80103dae:	66 90                	xchg   %ax,%ax

80103db0 <mycpu>:
{
80103db0:	f3 0f 1e fb          	endbr32 
80103db4:	55                   	push   %ebp
80103db5:	89 e5                	mov    %esp,%ebp
80103db7:	56                   	push   %esi
80103db8:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103db9:	9c                   	pushf  
80103dba:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103dbb:	f6 c4 02             	test   $0x2,%ah
80103dbe:	75 57                	jne    80103e17 <mycpu+0x67>
  apicid = lapicid();
80103dc0:	e8 9b ef ff ff       	call   80102d60 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103dc5:	8b 35 80 1d 12 80    	mov    0x80121d80,%esi
  apicid = lapicid();
80103dcb:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
80103dcd:	85 f6                	test   %esi,%esi
80103dcf:	7e 2c                	jle    80103dfd <mycpu+0x4d>
80103dd1:	31 d2                	xor    %edx,%edx
80103dd3:	eb 0a                	jmp    80103ddf <mycpu+0x2f>
80103dd5:	8d 76 00             	lea    0x0(%esi),%esi
80103dd8:	83 c2 01             	add    $0x1,%edx
80103ddb:	39 f2                	cmp    %esi,%edx
80103ddd:	74 1e                	je     80103dfd <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
80103ddf:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103de5:	0f b6 81 00 18 12 80 	movzbl -0x7fede800(%ecx),%eax
80103dec:	39 d8                	cmp    %ebx,%eax
80103dee:	75 e8                	jne    80103dd8 <mycpu+0x28>
}
80103df0:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103df3:	8d 81 00 18 12 80    	lea    -0x7fede800(%ecx),%eax
}
80103df9:	5b                   	pop    %ebx
80103dfa:	5e                   	pop    %esi
80103dfb:	5d                   	pop    %ebp
80103dfc:	c3                   	ret    
  cprintf("The unknown apicid is %d\n", apicid);
80103dfd:	83 ec 08             	sub    $0x8,%esp
80103e00:	53                   	push   %ebx
80103e01:	68 c7 7f 10 80       	push   $0x80107fc7
80103e06:	e8 a5 c8 ff ff       	call   801006b0 <cprintf>
  panic("unknown apicid\n");
80103e0b:	c7 04 24 e1 7f 10 80 	movl   $0x80107fe1,(%esp)
80103e12:	e8 79 c5 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103e17:	83 ec 0c             	sub    $0xc,%esp
80103e1a:	68 c0 80 10 80       	push   $0x801080c0
80103e1f:	e8 6c c5 ff ff       	call   80100390 <panic>
80103e24:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e2f:	90                   	nop

80103e30 <cpuid>:
cpuid() {
80103e30:	f3 0f 1e fb          	endbr32 
80103e34:	55                   	push   %ebp
80103e35:	89 e5                	mov    %esp,%ebp
80103e37:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103e3a:	e8 71 ff ff ff       	call   80103db0 <mycpu>
}
80103e3f:	c9                   	leave  
  return mycpu()-cpus;
80103e40:	2d 00 18 12 80       	sub    $0x80121800,%eax
80103e45:	c1 f8 04             	sar    $0x4,%eax
80103e48:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103e4e:	c3                   	ret    
80103e4f:	90                   	nop

80103e50 <myproc>:
myproc(void) {
80103e50:	f3 0f 1e fb          	endbr32 
80103e54:	55                   	push   %ebp
80103e55:	89 e5                	mov    %esp,%ebp
80103e57:	53                   	push   %ebx
80103e58:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103e5b:	e8 40 0b 00 00       	call   801049a0 <pushcli>
  c = mycpu();
80103e60:	e8 4b ff ff ff       	call   80103db0 <mycpu>
  p = c->proc;
80103e65:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e6b:	e8 80 0b 00 00       	call   801049f0 <popcli>
}
80103e70:	83 c4 04             	add    $0x4,%esp
80103e73:	89 d8                	mov    %ebx,%eax
80103e75:	5b                   	pop    %ebx
80103e76:	5d                   	pop    %ebp
80103e77:	c3                   	ret    
80103e78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e7f:	90                   	nop

80103e80 <userinit>:
{
80103e80:	f3 0f 1e fb          	endbr32 
80103e84:	55                   	push   %ebp
80103e85:	89 e5                	mov    %esp,%ebp
80103e87:	53                   	push   %ebx
80103e88:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103e8b:	e8 d0 fd ff ff       	call   80103c60 <allocproc>
80103e90:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103e92:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80103e97:	e8 14 38 00 00       	call   801076b0 <setupkvm>
80103e9c:	89 43 04             	mov    %eax,0x4(%ebx)
80103e9f:	85 c0                	test   %eax,%eax
80103ea1:	0f 84 bd 00 00 00    	je     80103f64 <userinit+0xe4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103ea7:	83 ec 04             	sub    $0x4,%esp
80103eaa:	68 2c 00 00 00       	push   $0x2c
80103eaf:	68 60 b4 10 80       	push   $0x8010b460
80103eb4:	50                   	push   %eax
80103eb5:	e8 c6 34 00 00       	call   80107380 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103eba:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103ebd:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103ec3:	6a 4c                	push   $0x4c
80103ec5:	6a 00                	push   $0x0
80103ec7:	ff 73 18             	pushl  0x18(%ebx)
80103eca:	e8 e1 0c 00 00       	call   80104bb0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103ecf:	8b 43 18             	mov    0x18(%ebx),%eax
80103ed2:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103ed7:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103eda:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103edf:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103ee3:	8b 43 18             	mov    0x18(%ebx),%eax
80103ee6:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103eea:	8b 43 18             	mov    0x18(%ebx),%eax
80103eed:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103ef1:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103ef5:	8b 43 18             	mov    0x18(%ebx),%eax
80103ef8:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103efc:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103f00:	8b 43 18             	mov    0x18(%ebx),%eax
80103f03:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103f0a:	8b 43 18             	mov    0x18(%ebx),%eax
80103f0d:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103f14:	8b 43 18             	mov    0x18(%ebx),%eax
80103f17:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103f1e:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103f21:	6a 10                	push   $0x10
80103f23:	68 0a 80 10 80       	push   $0x8010800a
80103f28:	50                   	push   %eax
80103f29:	e8 42 0e 00 00       	call   80104d70 <safestrcpy>
  p->cwd = namei("/");
80103f2e:	c7 04 24 13 80 10 80 	movl   $0x80108013,(%esp)
80103f35:	e8 a6 e1 ff ff       	call   801020e0 <namei>
80103f3a:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103f3d:	c7 04 24 a0 1d 12 80 	movl   $0x80121da0,(%esp)
80103f44:	e8 57 0b 00 00       	call   80104aa0 <acquire>
  p->state = RUNNABLE;
80103f49:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103f50:	c7 04 24 a0 1d 12 80 	movl   $0x80121da0,(%esp)
80103f57:	e8 04 0c 00 00       	call   80104b60 <release>
}
80103f5c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f5f:	83 c4 10             	add    $0x10,%esp
80103f62:	c9                   	leave  
80103f63:	c3                   	ret    
    panic("userinit: out of memory?");
80103f64:	83 ec 0c             	sub    $0xc,%esp
80103f67:	68 f1 7f 10 80       	push   $0x80107ff1
80103f6c:	e8 1f c4 ff ff       	call   80100390 <panic>
80103f71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f7f:	90                   	nop

80103f80 <growproc>:
{
80103f80:	f3 0f 1e fb          	endbr32 
80103f84:	55                   	push   %ebp
80103f85:	89 e5                	mov    %esp,%ebp
80103f87:	56                   	push   %esi
80103f88:	53                   	push   %ebx
80103f89:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103f8c:	e8 0f 0a 00 00       	call   801049a0 <pushcli>
  c = mycpu();
80103f91:	e8 1a fe ff ff       	call   80103db0 <mycpu>
  p = c->proc;
80103f96:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f9c:	e8 4f 0a 00 00       	call   801049f0 <popcli>
  sz = curproc->sz;
80103fa1:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103fa3:	85 f6                	test   %esi,%esi
80103fa5:	7f 19                	jg     80103fc0 <growproc+0x40>
  } else if(n < 0){
80103fa7:	75 37                	jne    80103fe0 <growproc+0x60>
  switchuvm(curproc);
80103fa9:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103fac:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103fae:	53                   	push   %ebx
80103faf:	e8 bc 32 00 00       	call   80107270 <switchuvm>
  return 0;
80103fb4:	83 c4 10             	add    $0x10,%esp
80103fb7:	31 c0                	xor    %eax,%eax
}
80103fb9:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103fbc:	5b                   	pop    %ebx
80103fbd:	5e                   	pop    %esi
80103fbe:	5d                   	pop    %ebp
80103fbf:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103fc0:	83 ec 04             	sub    $0x4,%esp
80103fc3:	01 c6                	add    %eax,%esi
80103fc5:	56                   	push   %esi
80103fc6:	50                   	push   %eax
80103fc7:	ff 73 04             	pushl  0x4(%ebx)
80103fca:	e8 01 35 00 00       	call   801074d0 <allocuvm>
80103fcf:	83 c4 10             	add    $0x10,%esp
80103fd2:	85 c0                	test   %eax,%eax
80103fd4:	75 d3                	jne    80103fa9 <growproc+0x29>
      return -1;
80103fd6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103fdb:	eb dc                	jmp    80103fb9 <growproc+0x39>
80103fdd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103fe0:	83 ec 04             	sub    $0x4,%esp
80103fe3:	01 c6                	add    %eax,%esi
80103fe5:	56                   	push   %esi
80103fe6:	50                   	push   %eax
80103fe7:	ff 73 04             	pushl  0x4(%ebx)
80103fea:	e8 11 36 00 00       	call   80107600 <deallocuvm>
80103fef:	83 c4 10             	add    $0x10,%esp
80103ff2:	85 c0                	test   %eax,%eax
80103ff4:	75 b3                	jne    80103fa9 <growproc+0x29>
80103ff6:	eb de                	jmp    80103fd6 <growproc+0x56>
80103ff8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fff:	90                   	nop

80104000 <sys_get_number_of_free_pages_impl>:
int sys_get_number_of_free_pages_impl(void){
80104000:	f3 0f 1e fb          	endbr32 
  for (int i = 0; i < PHYSTOP / PGSIZE; i++){
80104004:	31 c0                	xor    %eax,%eax
  int count = 0;
80104006:	31 d2                	xor    %edx,%edx
80104008:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010400f:	90                   	nop
      count++;
80104010:	80 b8 40 0f 11 80 01 	cmpb   $0x1,-0x7feef0c0(%eax)
80104017:	83 da ff             	sbb    $0xffffffff,%edx
  for (int i = 0; i < PHYSTOP / PGSIZE; i++){
8010401a:	83 c0 01             	add    $0x1,%eax
8010401d:	3d 00 e0 00 00       	cmp    $0xe000,%eax
80104022:	75 ec                	jne    80104010 <sys_get_number_of_free_pages_impl+0x10>
  return (PHYSTOP/PGSIZE) - count;
80104024:	29 d0                	sub    %edx,%eax
}
80104026:	c3                   	ret    
80104027:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010402e:	66 90                	xchg   %ax,%ax

80104030 <fork>:
{
80104030:	f3 0f 1e fb          	endbr32 
80104034:	55                   	push   %ebp
80104035:	89 e5                	mov    %esp,%ebp
80104037:	57                   	push   %edi
80104038:	56                   	push   %esi
80104039:	53                   	push   %ebx
8010403a:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
8010403d:	e8 5e 09 00 00       	call   801049a0 <pushcli>
  c = mycpu();
80104042:	e8 69 fd ff ff       	call   80103db0 <mycpu>
  p = c->proc;
80104047:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010404d:	e8 9e 09 00 00       	call   801049f0 <popcli>
  if((np = allocproc()) == 0){
80104052:	e8 09 fc ff ff       	call   80103c60 <allocproc>
80104057:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010405a:	85 c0                	test   %eax,%eax
8010405c:	0f 84 bb 00 00 00    	je     8010411d <fork+0xed>
  if((np->pgdir = cow_copyuvm(curproc->pgdir, curproc->sz)) == 0){ // (np->pid > 2 ? cow_copyuvm : copyuvm)
80104062:	83 ec 08             	sub    $0x8,%esp
80104065:	ff 33                	pushl  (%ebx)
80104067:	89 c7                	mov    %eax,%edi
80104069:	ff 73 04             	pushl  0x4(%ebx)
8010406c:	e8 0f 37 00 00       	call   80107780 <cow_copyuvm>
80104071:	83 c4 10             	add    $0x10,%esp
80104074:	89 47 04             	mov    %eax,0x4(%edi)
80104077:	85 c0                	test   %eax,%eax
80104079:	0f 84 a5 00 00 00    	je     80104124 <fork+0xf4>
  np->sz = curproc->sz;
8010407f:	8b 03                	mov    (%ebx),%eax
80104081:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104084:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80104086:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80104089:	89 c8                	mov    %ecx,%eax
8010408b:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
8010408e:	b9 13 00 00 00       	mov    $0x13,%ecx
80104093:	8b 73 18             	mov    0x18(%ebx),%esi
80104096:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80104098:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
8010409a:	8b 40 18             	mov    0x18(%eax),%eax
8010409d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
801040a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
801040a8:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801040ac:	85 c0                	test   %eax,%eax
801040ae:	74 13                	je     801040c3 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
801040b0:	83 ec 0c             	sub    $0xc,%esp
801040b3:	50                   	push   %eax
801040b4:	e8 67 ce ff ff       	call   80100f20 <filedup>
801040b9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801040bc:	83 c4 10             	add    $0x10,%esp
801040bf:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
801040c3:	83 c6 01             	add    $0x1,%esi
801040c6:	83 fe 10             	cmp    $0x10,%esi
801040c9:	75 dd                	jne    801040a8 <fork+0x78>
  np->cwd = idup(curproc->cwd);
801040cb:	83 ec 0c             	sub    $0xc,%esp
801040ce:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801040d1:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
801040d4:	e8 07 d7 ff ff       	call   801017e0 <idup>
801040d9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801040dc:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
801040df:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801040e2:	8d 47 6c             	lea    0x6c(%edi),%eax
801040e5:	6a 10                	push   $0x10
801040e7:	53                   	push   %ebx
801040e8:	50                   	push   %eax
801040e9:	e8 82 0c 00 00       	call   80104d70 <safestrcpy>
  pid = np->pid;
801040ee:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
801040f1:	c7 04 24 a0 1d 12 80 	movl   $0x80121da0,(%esp)
801040f8:	e8 a3 09 00 00       	call   80104aa0 <acquire>
  np->state = RUNNABLE;
801040fd:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80104104:	c7 04 24 a0 1d 12 80 	movl   $0x80121da0,(%esp)
8010410b:	e8 50 0a 00 00       	call   80104b60 <release>
  return pid;
80104110:	83 c4 10             	add    $0x10,%esp
}
80104113:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104116:	89 d8                	mov    %ebx,%eax
80104118:	5b                   	pop    %ebx
80104119:	5e                   	pop    %esi
8010411a:	5f                   	pop    %edi
8010411b:	5d                   	pop    %ebp
8010411c:	c3                   	ret    
    return -1;
8010411d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104122:	eb ef                	jmp    80104113 <fork+0xe3>
    cow_kfree(np->kstack);
80104124:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80104127:	83 ec 0c             	sub    $0xc,%esp
8010412a:	ff 73 08             	pushl  0x8(%ebx)
8010412d:	e8 1e 2d 00 00       	call   80106e50 <cow_kfree>
    np->kstack = 0;
80104132:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80104139:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
8010413c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80104143:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104148:	eb c9                	jmp    80104113 <fork+0xe3>
8010414a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104150 <scheduler>:
{
80104150:	f3 0f 1e fb          	endbr32 
80104154:	55                   	push   %ebp
80104155:	89 e5                	mov    %esp,%ebp
80104157:	57                   	push   %edi
80104158:	56                   	push   %esi
80104159:	53                   	push   %ebx
8010415a:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
8010415d:	e8 4e fc ff ff       	call   80103db0 <mycpu>
  c->proc = 0;
80104162:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104169:	00 00 00 
  struct cpu *c = mycpu();
8010416c:	89 c6                	mov    %eax,%esi
  c->proc = 0;
8010416e:	8d 78 04             	lea    0x4(%eax),%edi
80104171:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80104178:	fb                   	sti    
    acquire(&ptable.lock);
80104179:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010417c:	bb d4 1d 12 80       	mov    $0x80121dd4,%ebx
    acquire(&ptable.lock);
80104181:	68 a0 1d 12 80       	push   $0x80121da0
80104186:	e8 15 09 00 00       	call   80104aa0 <acquire>
8010418b:	83 c4 10             	add    $0x10,%esp
8010418e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80104190:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104194:	75 33                	jne    801041c9 <scheduler+0x79>
      switchuvm(p);
80104196:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104199:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010419f:	53                   	push   %ebx
801041a0:	e8 cb 30 00 00       	call   80107270 <switchuvm>
      swtch(&(c->scheduler), p->context);
801041a5:	58                   	pop    %eax
801041a6:	5a                   	pop    %edx
801041a7:	ff 73 1c             	pushl  0x1c(%ebx)
801041aa:	57                   	push   %edi
      p->state = RUNNING;
801041ab:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
801041b2:	e8 1c 0c 00 00       	call   80104dd3 <swtch>
      switchkvm();
801041b7:	e8 94 30 00 00       	call   80107250 <switchkvm>
      c->proc = 0;
801041bc:	83 c4 10             	add    $0x10,%esp
801041bf:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801041c6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041c9:	81 c3 d0 03 00 00    	add    $0x3d0,%ebx
801041cf:	81 fb d4 11 13 80    	cmp    $0x801311d4,%ebx
801041d5:	75 b9                	jne    80104190 <scheduler+0x40>
    release(&ptable.lock);
801041d7:	83 ec 0c             	sub    $0xc,%esp
801041da:	68 a0 1d 12 80       	push   $0x80121da0
801041df:	e8 7c 09 00 00       	call   80104b60 <release>
    sti();
801041e4:	83 c4 10             	add    $0x10,%esp
801041e7:	eb 8f                	jmp    80104178 <scheduler+0x28>
801041e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801041f0 <sched>:
{
801041f0:	f3 0f 1e fb          	endbr32 
801041f4:	55                   	push   %ebp
801041f5:	89 e5                	mov    %esp,%ebp
801041f7:	56                   	push   %esi
801041f8:	53                   	push   %ebx
  pushcli();
801041f9:	e8 a2 07 00 00       	call   801049a0 <pushcli>
  c = mycpu();
801041fe:	e8 ad fb ff ff       	call   80103db0 <mycpu>
  p = c->proc;
80104203:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104209:	e8 e2 07 00 00       	call   801049f0 <popcli>
  if(!holding(&ptable.lock))
8010420e:	83 ec 0c             	sub    $0xc,%esp
80104211:	68 a0 1d 12 80       	push   $0x80121da0
80104216:	e8 35 08 00 00       	call   80104a50 <holding>
8010421b:	83 c4 10             	add    $0x10,%esp
8010421e:	85 c0                	test   %eax,%eax
80104220:	74 4f                	je     80104271 <sched+0x81>
  if(mycpu()->ncli != 1)
80104222:	e8 89 fb ff ff       	call   80103db0 <mycpu>
80104227:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010422e:	75 68                	jne    80104298 <sched+0xa8>
  if(p->state == RUNNING)
80104230:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104234:	74 55                	je     8010428b <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104236:	9c                   	pushf  
80104237:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104238:	f6 c4 02             	test   $0x2,%ah
8010423b:	75 41                	jne    8010427e <sched+0x8e>
  intena = mycpu()->intena;
8010423d:	e8 6e fb ff ff       	call   80103db0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80104242:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104245:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
8010424b:	e8 60 fb ff ff       	call   80103db0 <mycpu>
80104250:	83 ec 08             	sub    $0x8,%esp
80104253:	ff 70 04             	pushl  0x4(%eax)
80104256:	53                   	push   %ebx
80104257:	e8 77 0b 00 00       	call   80104dd3 <swtch>
  mycpu()->intena = intena;
8010425c:	e8 4f fb ff ff       	call   80103db0 <mycpu>
}
80104261:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104264:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
8010426a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010426d:	5b                   	pop    %ebx
8010426e:	5e                   	pop    %esi
8010426f:	5d                   	pop    %ebp
80104270:	c3                   	ret    
    panic("sched ptable.lock");
80104271:	83 ec 0c             	sub    $0xc,%esp
80104274:	68 15 80 10 80       	push   $0x80108015
80104279:	e8 12 c1 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010427e:	83 ec 0c             	sub    $0xc,%esp
80104281:	68 41 80 10 80       	push   $0x80108041
80104286:	e8 05 c1 ff ff       	call   80100390 <panic>
    panic("sched running");
8010428b:	83 ec 0c             	sub    $0xc,%esp
8010428e:	68 33 80 10 80       	push   $0x80108033
80104293:	e8 f8 c0 ff ff       	call   80100390 <panic>
    panic("sched locks");
80104298:	83 ec 0c             	sub    $0xc,%esp
8010429b:	68 27 80 10 80       	push   $0x80108027
801042a0:	e8 eb c0 ff ff       	call   80100390 <panic>
801042a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801042b0 <exit>:
{
801042b0:	f3 0f 1e fb          	endbr32 
801042b4:	55                   	push   %ebp
801042b5:	89 e5                	mov    %esp,%ebp
801042b7:	57                   	push   %edi
801042b8:	56                   	push   %esi
801042b9:	53                   	push   %ebx
801042ba:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
801042bd:	e8 de 06 00 00       	call   801049a0 <pushcli>
  c = mycpu();
801042c2:	e8 e9 fa ff ff       	call   80103db0 <mycpu>
  p = c->proc;
801042c7:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801042cd:	e8 1e 07 00 00       	call   801049f0 <popcli>
  if(curproc == initproc)
801042d2:	8d 5e 28             	lea    0x28(%esi),%ebx
801042d5:	8d 7e 68             	lea    0x68(%esi),%edi
801042d8:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
801042de:	0f 84 fd 00 00 00    	je     801043e1 <exit+0x131>
801042e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
801042e8:	8b 03                	mov    (%ebx),%eax
801042ea:	85 c0                	test   %eax,%eax
801042ec:	74 12                	je     80104300 <exit+0x50>
      fileclose(curproc->ofile[fd]);
801042ee:	83 ec 0c             	sub    $0xc,%esp
801042f1:	50                   	push   %eax
801042f2:	e8 79 cc ff ff       	call   80100f70 <fileclose>
      curproc->ofile[fd] = 0;
801042f7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801042fd:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104300:	83 c3 04             	add    $0x4,%ebx
80104303:	39 df                	cmp    %ebx,%edi
80104305:	75 e1                	jne    801042e8 <exit+0x38>
  begin_op();
80104307:	e8 e4 ee ff ff       	call   801031f0 <begin_op>
  iput(curproc->cwd);
8010430c:	83 ec 0c             	sub    $0xc,%esp
8010430f:	ff 76 68             	pushl  0x68(%esi)
80104312:	e8 29 d6 ff ff       	call   80101940 <iput>
  end_op();
80104317:	e8 44 ef ff ff       	call   80103260 <end_op>
  curproc->cwd = 0;
8010431c:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80104323:	c7 04 24 a0 1d 12 80 	movl   $0x80121da0,(%esp)
8010432a:	e8 71 07 00 00       	call   80104aa0 <acquire>
  wakeup1(curproc->parent);
8010432f:	8b 56 14             	mov    0x14(%esi),%edx
80104332:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104335:	b8 d4 1d 12 80       	mov    $0x80121dd4,%eax
8010433a:	eb 10                	jmp    8010434c <exit+0x9c>
8010433c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104340:	05 d0 03 00 00       	add    $0x3d0,%eax
80104345:	3d d4 11 13 80       	cmp    $0x801311d4,%eax
8010434a:	74 1e                	je     8010436a <exit+0xba>
    if(p->state == SLEEPING && p->chan == chan)
8010434c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104350:	75 ee                	jne    80104340 <exit+0x90>
80104352:	3b 50 20             	cmp    0x20(%eax),%edx
80104355:	75 e9                	jne    80104340 <exit+0x90>
      p->state = RUNNABLE;
80104357:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010435e:	05 d0 03 00 00       	add    $0x3d0,%eax
80104363:	3d d4 11 13 80       	cmp    $0x801311d4,%eax
80104368:	75 e2                	jne    8010434c <exit+0x9c>
      p->parent = initproc;
8010436a:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104370:	ba d4 1d 12 80       	mov    $0x80121dd4,%edx
80104375:	eb 17                	jmp    8010438e <exit+0xde>
80104377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010437e:	66 90                	xchg   %ax,%ax
80104380:	81 c2 d0 03 00 00    	add    $0x3d0,%edx
80104386:	81 fa d4 11 13 80    	cmp    $0x801311d4,%edx
8010438c:	74 3a                	je     801043c8 <exit+0x118>
    if(p->parent == curproc){
8010438e:	39 72 14             	cmp    %esi,0x14(%edx)
80104391:	75 ed                	jne    80104380 <exit+0xd0>
      if(p->state == ZOMBIE)
80104393:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104397:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010439a:	75 e4                	jne    80104380 <exit+0xd0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010439c:	b8 d4 1d 12 80       	mov    $0x80121dd4,%eax
801043a1:	eb 11                	jmp    801043b4 <exit+0x104>
801043a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043a7:	90                   	nop
801043a8:	05 d0 03 00 00       	add    $0x3d0,%eax
801043ad:	3d d4 11 13 80       	cmp    $0x801311d4,%eax
801043b2:	74 cc                	je     80104380 <exit+0xd0>
    if(p->state == SLEEPING && p->chan == chan)
801043b4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801043b8:	75 ee                	jne    801043a8 <exit+0xf8>
801043ba:	3b 48 20             	cmp    0x20(%eax),%ecx
801043bd:	75 e9                	jne    801043a8 <exit+0xf8>
      p->state = RUNNABLE;
801043bf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801043c6:	eb e0                	jmp    801043a8 <exit+0xf8>
  curproc->state = ZOMBIE;
801043c8:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
801043cf:	e8 1c fe ff ff       	call   801041f0 <sched>
  panic("zombie exit");
801043d4:	83 ec 0c             	sub    $0xc,%esp
801043d7:	68 62 80 10 80       	push   $0x80108062
801043dc:	e8 af bf ff ff       	call   80100390 <panic>
    panic("init exiting");
801043e1:	83 ec 0c             	sub    $0xc,%esp
801043e4:	68 55 80 10 80       	push   $0x80108055
801043e9:	e8 a2 bf ff ff       	call   80100390 <panic>
801043ee:	66 90                	xchg   %ax,%ax

801043f0 <yield>:
{
801043f0:	f3 0f 1e fb          	endbr32 
801043f4:	55                   	push   %ebp
801043f5:	89 e5                	mov    %esp,%ebp
801043f7:	53                   	push   %ebx
801043f8:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801043fb:	68 a0 1d 12 80       	push   $0x80121da0
80104400:	e8 9b 06 00 00       	call   80104aa0 <acquire>
  pushcli();
80104405:	e8 96 05 00 00       	call   801049a0 <pushcli>
  c = mycpu();
8010440a:	e8 a1 f9 ff ff       	call   80103db0 <mycpu>
  p = c->proc;
8010440f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104415:	e8 d6 05 00 00       	call   801049f0 <popcli>
  myproc()->state = RUNNABLE;
8010441a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80104421:	e8 ca fd ff ff       	call   801041f0 <sched>
  release(&ptable.lock);
80104426:	c7 04 24 a0 1d 12 80 	movl   $0x80121da0,(%esp)
8010442d:	e8 2e 07 00 00       	call   80104b60 <release>
}
80104432:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104435:	83 c4 10             	add    $0x10,%esp
80104438:	c9                   	leave  
80104439:	c3                   	ret    
8010443a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104440 <sleep>:
{
80104440:	f3 0f 1e fb          	endbr32 
80104444:	55                   	push   %ebp
80104445:	89 e5                	mov    %esp,%ebp
80104447:	57                   	push   %edi
80104448:	56                   	push   %esi
80104449:	53                   	push   %ebx
8010444a:	83 ec 0c             	sub    $0xc,%esp
8010444d:	8b 7d 08             	mov    0x8(%ebp),%edi
80104450:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104453:	e8 48 05 00 00       	call   801049a0 <pushcli>
  c = mycpu();
80104458:	e8 53 f9 ff ff       	call   80103db0 <mycpu>
  p = c->proc;
8010445d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104463:	e8 88 05 00 00       	call   801049f0 <popcli>
  if(p == 0)
80104468:	85 db                	test   %ebx,%ebx
8010446a:	0f 84 83 00 00 00    	je     801044f3 <sleep+0xb3>
  if(lk == 0)
80104470:	85 f6                	test   %esi,%esi
80104472:	74 72                	je     801044e6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104474:	81 fe a0 1d 12 80    	cmp    $0x80121da0,%esi
8010447a:	74 4c                	je     801044c8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
8010447c:	83 ec 0c             	sub    $0xc,%esp
8010447f:	68 a0 1d 12 80       	push   $0x80121da0
80104484:	e8 17 06 00 00       	call   80104aa0 <acquire>
    release(lk);
80104489:	89 34 24             	mov    %esi,(%esp)
8010448c:	e8 cf 06 00 00       	call   80104b60 <release>
  p->chan = chan;
80104491:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104494:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010449b:	e8 50 fd ff ff       	call   801041f0 <sched>
  p->chan = 0;
801044a0:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801044a7:	c7 04 24 a0 1d 12 80 	movl   $0x80121da0,(%esp)
801044ae:	e8 ad 06 00 00       	call   80104b60 <release>
    acquire(lk);
801044b3:	89 75 08             	mov    %esi,0x8(%ebp)
801044b6:	83 c4 10             	add    $0x10,%esp
}
801044b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044bc:	5b                   	pop    %ebx
801044bd:	5e                   	pop    %esi
801044be:	5f                   	pop    %edi
801044bf:	5d                   	pop    %ebp
    acquire(lk);
801044c0:	e9 db 05 00 00       	jmp    80104aa0 <acquire>
801044c5:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
801044c8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801044cb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801044d2:	e8 19 fd ff ff       	call   801041f0 <sched>
  p->chan = 0;
801044d7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801044de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044e1:	5b                   	pop    %ebx
801044e2:	5e                   	pop    %esi
801044e3:	5f                   	pop    %edi
801044e4:	5d                   	pop    %ebp
801044e5:	c3                   	ret    
    panic("sleep without lk");
801044e6:	83 ec 0c             	sub    $0xc,%esp
801044e9:	68 74 80 10 80       	push   $0x80108074
801044ee:	e8 9d be ff ff       	call   80100390 <panic>
    panic("sleep");
801044f3:	83 ec 0c             	sub    $0xc,%esp
801044f6:	68 6e 80 10 80       	push   $0x8010806e
801044fb:	e8 90 be ff ff       	call   80100390 <panic>

80104500 <wait>:
{
80104500:	f3 0f 1e fb          	endbr32 
80104504:	55                   	push   %ebp
80104505:	89 e5                	mov    %esp,%ebp
80104507:	56                   	push   %esi
80104508:	53                   	push   %ebx
  pushcli();
80104509:	e8 92 04 00 00       	call   801049a0 <pushcli>
  c = mycpu();
8010450e:	e8 9d f8 ff ff       	call   80103db0 <mycpu>
  p = c->proc;
80104513:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104519:	e8 d2 04 00 00       	call   801049f0 <popcli>
  acquire(&ptable.lock);
8010451e:	83 ec 0c             	sub    $0xc,%esp
80104521:	68 a0 1d 12 80       	push   $0x80121da0
80104526:	e8 75 05 00 00       	call   80104aa0 <acquire>
8010452b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010452e:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104530:	bb d4 1d 12 80       	mov    $0x80121dd4,%ebx
80104535:	eb 17                	jmp    8010454e <wait+0x4e>
80104537:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010453e:	66 90                	xchg   %ax,%ax
80104540:	81 c3 d0 03 00 00    	add    $0x3d0,%ebx
80104546:	81 fb d4 11 13 80    	cmp    $0x801311d4,%ebx
8010454c:	74 1e                	je     8010456c <wait+0x6c>
      if(p->parent != curproc)
8010454e:	39 73 14             	cmp    %esi,0x14(%ebx)
80104551:	75 ed                	jne    80104540 <wait+0x40>
      if(p->state == ZOMBIE){
80104553:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104557:	74 37                	je     80104590 <wait+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104559:	81 c3 d0 03 00 00    	add    $0x3d0,%ebx
      havekids = 1;
8010455f:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104564:	81 fb d4 11 13 80    	cmp    $0x801311d4,%ebx
8010456a:	75 e2                	jne    8010454e <wait+0x4e>
    if(!havekids || curproc->killed){
8010456c:	85 c0                	test   %eax,%eax
8010456e:	74 76                	je     801045e6 <wait+0xe6>
80104570:	8b 46 24             	mov    0x24(%esi),%eax
80104573:	85 c0                	test   %eax,%eax
80104575:	75 6f                	jne    801045e6 <wait+0xe6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104577:	83 ec 08             	sub    $0x8,%esp
8010457a:	68 a0 1d 12 80       	push   $0x80121da0
8010457f:	56                   	push   %esi
80104580:	e8 bb fe ff ff       	call   80104440 <sleep>
    havekids = 0;
80104585:	83 c4 10             	add    $0x10,%esp
80104588:	eb a4                	jmp    8010452e <wait+0x2e>
8010458a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        cow_kfree(p->kstack);
80104590:	83 ec 0c             	sub    $0xc,%esp
80104593:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104596:	8b 73 10             	mov    0x10(%ebx),%esi
        cow_kfree(p->kstack);
80104599:	e8 b2 28 00 00       	call   80106e50 <cow_kfree>
        freevm(p->pgdir);
8010459e:	5a                   	pop    %edx
8010459f:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
801045a2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801045a9:	e8 82 30 00 00       	call   80107630 <freevm>
        release(&ptable.lock);
801045ae:	c7 04 24 a0 1d 12 80 	movl   $0x80121da0,(%esp)
        p->pid = 0;
801045b5:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801045bc:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801045c3:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801045c7:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801045ce:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801045d5:	e8 86 05 00 00       	call   80104b60 <release>
        return pid;
801045da:	83 c4 10             	add    $0x10,%esp
}
801045dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045e0:	89 f0                	mov    %esi,%eax
801045e2:	5b                   	pop    %ebx
801045e3:	5e                   	pop    %esi
801045e4:	5d                   	pop    %ebp
801045e5:	c3                   	ret    
      release(&ptable.lock);
801045e6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801045e9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801045ee:	68 a0 1d 12 80       	push   $0x80121da0
801045f3:	e8 68 05 00 00       	call   80104b60 <release>
      return -1;
801045f8:	83 c4 10             	add    $0x10,%esp
801045fb:	eb e0                	jmp    801045dd <wait+0xdd>
801045fd:	8d 76 00             	lea    0x0(%esi),%esi

80104600 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104600:	f3 0f 1e fb          	endbr32 
80104604:	55                   	push   %ebp
80104605:	89 e5                	mov    %esp,%ebp
80104607:	53                   	push   %ebx
80104608:	83 ec 10             	sub    $0x10,%esp
8010460b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010460e:	68 a0 1d 12 80       	push   $0x80121da0
80104613:	e8 88 04 00 00       	call   80104aa0 <acquire>
80104618:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010461b:	b8 d4 1d 12 80       	mov    $0x80121dd4,%eax
80104620:	eb 12                	jmp    80104634 <wakeup+0x34>
80104622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104628:	05 d0 03 00 00       	add    $0x3d0,%eax
8010462d:	3d d4 11 13 80       	cmp    $0x801311d4,%eax
80104632:	74 1e                	je     80104652 <wakeup+0x52>
    if(p->state == SLEEPING && p->chan == chan)
80104634:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104638:	75 ee                	jne    80104628 <wakeup+0x28>
8010463a:	3b 58 20             	cmp    0x20(%eax),%ebx
8010463d:	75 e9                	jne    80104628 <wakeup+0x28>
      p->state = RUNNABLE;
8010463f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104646:	05 d0 03 00 00       	add    $0x3d0,%eax
8010464b:	3d d4 11 13 80       	cmp    $0x801311d4,%eax
80104650:	75 e2                	jne    80104634 <wakeup+0x34>
  wakeup1(chan);
  release(&ptable.lock);
80104652:	c7 45 08 a0 1d 12 80 	movl   $0x80121da0,0x8(%ebp)
}
80104659:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010465c:	c9                   	leave  
  release(&ptable.lock);
8010465d:	e9 fe 04 00 00       	jmp    80104b60 <release>
80104662:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104670 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104670:	f3 0f 1e fb          	endbr32 
80104674:	55                   	push   %ebp
80104675:	89 e5                	mov    %esp,%ebp
80104677:	53                   	push   %ebx
80104678:	83 ec 10             	sub    $0x10,%esp
8010467b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010467e:	68 a0 1d 12 80       	push   $0x80121da0
80104683:	e8 18 04 00 00       	call   80104aa0 <acquire>
80104688:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010468b:	b8 d4 1d 12 80       	mov    $0x80121dd4,%eax
80104690:	eb 12                	jmp    801046a4 <kill+0x34>
80104692:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104698:	05 d0 03 00 00       	add    $0x3d0,%eax
8010469d:	3d d4 11 13 80       	cmp    $0x801311d4,%eax
801046a2:	74 34                	je     801046d8 <kill+0x68>
    if(p->pid == pid){
801046a4:	39 58 10             	cmp    %ebx,0x10(%eax)
801046a7:	75 ef                	jne    80104698 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801046a9:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801046ad:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801046b4:	75 07                	jne    801046bd <kill+0x4d>
        p->state = RUNNABLE;
801046b6:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801046bd:	83 ec 0c             	sub    $0xc,%esp
801046c0:	68 a0 1d 12 80       	push   $0x80121da0
801046c5:	e8 96 04 00 00       	call   80104b60 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801046ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801046cd:	83 c4 10             	add    $0x10,%esp
801046d0:	31 c0                	xor    %eax,%eax
}
801046d2:	c9                   	leave  
801046d3:	c3                   	ret    
801046d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
801046d8:	83 ec 0c             	sub    $0xc,%esp
801046db:	68 a0 1d 12 80       	push   $0x80121da0
801046e0:	e8 7b 04 00 00       	call   80104b60 <release>
}
801046e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801046e8:	83 c4 10             	add    $0x10,%esp
801046eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801046f0:	c9                   	leave  
801046f1:	c3                   	ret    
801046f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104700 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104700:	f3 0f 1e fb          	endbr32 
80104704:	55                   	push   %ebp
80104705:	89 e5                	mov    %esp,%ebp
80104707:	57                   	push   %edi
80104708:	56                   	push   %esi
80104709:	8d 75 e8             	lea    -0x18(%ebp),%esi
8010470c:	53                   	push   %ebx
8010470d:	bb 40 1e 12 80       	mov    $0x80121e40,%ebx
80104712:	83 ec 3c             	sub    $0x3c,%esp
80104715:	eb 2b                	jmp    80104742 <procdump+0x42>
80104717:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010471e:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104720:	83 ec 0c             	sub    $0xc,%esp
80104723:	68 2c 85 10 80       	push   $0x8010852c
80104728:	e8 83 bf ff ff       	call   801006b0 <cprintf>
8010472d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104730:	81 c3 d0 03 00 00    	add    $0x3d0,%ebx
80104736:	81 fb 40 12 13 80    	cmp    $0x80131240,%ebx
8010473c:	0f 84 8e 00 00 00    	je     801047d0 <procdump+0xd0>
    if(p->state == UNUSED)
80104742:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104745:	85 c0                	test   %eax,%eax
80104747:	74 e7                	je     80104730 <procdump+0x30>
      state = "???";
80104749:	ba 85 80 10 80       	mov    $0x80108085,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010474e:	83 f8 05             	cmp    $0x5,%eax
80104751:	77 11                	ja     80104764 <procdump+0x64>
80104753:	8b 14 85 e8 80 10 80 	mov    -0x7fef7f18(,%eax,4),%edx
      state = "???";
8010475a:	b8 85 80 10 80       	mov    $0x80108085,%eax
8010475f:	85 d2                	test   %edx,%edx
80104761:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s ", p->pid, state, p->name);
80104764:	53                   	push   %ebx
80104765:	52                   	push   %edx
80104766:	ff 73 a4             	pushl  -0x5c(%ebx)
80104769:	68 89 80 10 80       	push   $0x80108089
8010476e:	e8 3d bf ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
80104773:	83 c4 10             	add    $0x10,%esp
80104776:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010477a:	75 a4                	jne    80104720 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
8010477c:	83 ec 08             	sub    $0x8,%esp
8010477f:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104782:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104785:	50                   	push   %eax
80104786:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104789:	8b 40 0c             	mov    0xc(%eax),%eax
8010478c:	83 c0 08             	add    $0x8,%eax
8010478f:	50                   	push   %eax
80104790:	e8 ab 01 00 00       	call   80104940 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104795:	83 c4 10             	add    $0x10,%esp
80104798:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010479f:	90                   	nop
801047a0:	8b 17                	mov    (%edi),%edx
801047a2:	85 d2                	test   %edx,%edx
801047a4:	0f 84 76 ff ff ff    	je     80104720 <procdump+0x20>
        cprintf(" %p", pc[i]);
801047aa:	83 ec 08             	sub    $0x8,%esp
801047ad:	83 c7 04             	add    $0x4,%edi
801047b0:	52                   	push   %edx
801047b1:	68 61 7a 10 80       	push   $0x80107a61
801047b6:	e8 f5 be ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801047bb:	83 c4 10             	add    $0x10,%esp
801047be:	39 fe                	cmp    %edi,%esi
801047c0:	75 de                	jne    801047a0 <procdump+0xa0>
801047c2:	e9 59 ff ff ff       	jmp    80104720 <procdump+0x20>
801047c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047ce:	66 90                	xchg   %ax,%ax
  #if SELECTION != NONE
  int currentFree = sys_get_number_of_free_pages_impl();
  int totalFree = (PHYSTOP-EXTMEM) / PGSIZE ;///verify
  cprintf("%d / %d free page frames in the system\n", currentFree, totalFree);
  #endif
}
801047d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801047d3:	5b                   	pop    %ebx
801047d4:	5e                   	pop    %esi
801047d5:	5f                   	pop    %edi
801047d6:	5d                   	pop    %ebp
801047d7:	c3                   	ret    
801047d8:	66 90                	xchg   %ax,%ax
801047da:	66 90                	xchg   %ax,%ax
801047dc:	66 90                	xchg   %ax,%ax
801047de:	66 90                	xchg   %ax,%ax

801047e0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801047e0:	f3 0f 1e fb          	endbr32 
801047e4:	55                   	push   %ebp
801047e5:	89 e5                	mov    %esp,%ebp
801047e7:	53                   	push   %ebx
801047e8:	83 ec 0c             	sub    $0xc,%esp
801047eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801047ee:	68 00 81 10 80       	push   $0x80108100
801047f3:	8d 43 04             	lea    0x4(%ebx),%eax
801047f6:	50                   	push   %eax
801047f7:	e8 24 01 00 00       	call   80104920 <initlock>
  lk->name = name;
801047fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801047ff:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104805:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104808:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010480f:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104812:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104815:	c9                   	leave  
80104816:	c3                   	ret    
80104817:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010481e:	66 90                	xchg   %ax,%ax

80104820 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104820:	f3 0f 1e fb          	endbr32 
80104824:	55                   	push   %ebp
80104825:	89 e5                	mov    %esp,%ebp
80104827:	56                   	push   %esi
80104828:	53                   	push   %ebx
80104829:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010482c:	8d 73 04             	lea    0x4(%ebx),%esi
8010482f:	83 ec 0c             	sub    $0xc,%esp
80104832:	56                   	push   %esi
80104833:	e8 68 02 00 00       	call   80104aa0 <acquire>
  while (lk->locked) {
80104838:	8b 13                	mov    (%ebx),%edx
8010483a:	83 c4 10             	add    $0x10,%esp
8010483d:	85 d2                	test   %edx,%edx
8010483f:	74 1a                	je     8010485b <acquiresleep+0x3b>
80104841:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104848:	83 ec 08             	sub    $0x8,%esp
8010484b:	56                   	push   %esi
8010484c:	53                   	push   %ebx
8010484d:	e8 ee fb ff ff       	call   80104440 <sleep>
  while (lk->locked) {
80104852:	8b 03                	mov    (%ebx),%eax
80104854:	83 c4 10             	add    $0x10,%esp
80104857:	85 c0                	test   %eax,%eax
80104859:	75 ed                	jne    80104848 <acquiresleep+0x28>
  }
  lk->locked = 1;
8010485b:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104861:	e8 ea f5 ff ff       	call   80103e50 <myproc>
80104866:	8b 40 10             	mov    0x10(%eax),%eax
80104869:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
8010486c:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010486f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104872:	5b                   	pop    %ebx
80104873:	5e                   	pop    %esi
80104874:	5d                   	pop    %ebp
  release(&lk->lk);
80104875:	e9 e6 02 00 00       	jmp    80104b60 <release>
8010487a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104880 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104880:	f3 0f 1e fb          	endbr32 
80104884:	55                   	push   %ebp
80104885:	89 e5                	mov    %esp,%ebp
80104887:	56                   	push   %esi
80104888:	53                   	push   %ebx
80104889:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010488c:	8d 73 04             	lea    0x4(%ebx),%esi
8010488f:	83 ec 0c             	sub    $0xc,%esp
80104892:	56                   	push   %esi
80104893:	e8 08 02 00 00       	call   80104aa0 <acquire>
  lk->locked = 0;
80104898:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010489e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801048a5:	89 1c 24             	mov    %ebx,(%esp)
801048a8:	e8 53 fd ff ff       	call   80104600 <wakeup>
  release(&lk->lk);
801048ad:	89 75 08             	mov    %esi,0x8(%ebp)
801048b0:	83 c4 10             	add    $0x10,%esp
}
801048b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048b6:	5b                   	pop    %ebx
801048b7:	5e                   	pop    %esi
801048b8:	5d                   	pop    %ebp
  release(&lk->lk);
801048b9:	e9 a2 02 00 00       	jmp    80104b60 <release>
801048be:	66 90                	xchg   %ax,%ax

801048c0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801048c0:	f3 0f 1e fb          	endbr32 
801048c4:	55                   	push   %ebp
801048c5:	89 e5                	mov    %esp,%ebp
801048c7:	57                   	push   %edi
801048c8:	31 ff                	xor    %edi,%edi
801048ca:	56                   	push   %esi
801048cb:	53                   	push   %ebx
801048cc:	83 ec 18             	sub    $0x18,%esp
801048cf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801048d2:	8d 73 04             	lea    0x4(%ebx),%esi
801048d5:	56                   	push   %esi
801048d6:	e8 c5 01 00 00       	call   80104aa0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801048db:	8b 03                	mov    (%ebx),%eax
801048dd:	83 c4 10             	add    $0x10,%esp
801048e0:	85 c0                	test   %eax,%eax
801048e2:	75 1c                	jne    80104900 <holdingsleep+0x40>
  release(&lk->lk);
801048e4:	83 ec 0c             	sub    $0xc,%esp
801048e7:	56                   	push   %esi
801048e8:	e8 73 02 00 00       	call   80104b60 <release>
  return r;
}
801048ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048f0:	89 f8                	mov    %edi,%eax
801048f2:	5b                   	pop    %ebx
801048f3:	5e                   	pop    %esi
801048f4:	5f                   	pop    %edi
801048f5:	5d                   	pop    %ebp
801048f6:	c3                   	ret    
801048f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048fe:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104900:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104903:	e8 48 f5 ff ff       	call   80103e50 <myproc>
80104908:	39 58 10             	cmp    %ebx,0x10(%eax)
8010490b:	0f 94 c0             	sete   %al
8010490e:	0f b6 c0             	movzbl %al,%eax
80104911:	89 c7                	mov    %eax,%edi
80104913:	eb cf                	jmp    801048e4 <holdingsleep+0x24>
80104915:	66 90                	xchg   %ax,%ax
80104917:	66 90                	xchg   %ax,%ax
80104919:	66 90                	xchg   %ax,%ax
8010491b:	66 90                	xchg   %ax,%ax
8010491d:	66 90                	xchg   %ax,%ax
8010491f:	90                   	nop

80104920 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104920:	f3 0f 1e fb          	endbr32 
80104924:	55                   	push   %ebp
80104925:	89 e5                	mov    %esp,%ebp
80104927:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
8010492a:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
8010492d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104933:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104936:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010493d:	5d                   	pop    %ebp
8010493e:	c3                   	ret    
8010493f:	90                   	nop

80104940 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104940:	f3 0f 1e fb          	endbr32 
80104944:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104945:	31 d2                	xor    %edx,%edx
{
80104947:	89 e5                	mov    %esp,%ebp
80104949:	53                   	push   %ebx
  ebp = (uint*)v - 2;
8010494a:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010494d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104950:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104953:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104957:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104958:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010495e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104964:	77 1a                	ja     80104980 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104966:	8b 58 04             	mov    0x4(%eax),%ebx
80104969:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
8010496c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
8010496f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104971:	83 fa 0a             	cmp    $0xa,%edx
80104974:	75 e2                	jne    80104958 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104976:	5b                   	pop    %ebx
80104977:	5d                   	pop    %ebp
80104978:	c3                   	ret    
80104979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104980:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104983:	8d 51 28             	lea    0x28(%ecx),%edx
80104986:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010498d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104990:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104996:	83 c0 04             	add    $0x4,%eax
80104999:	39 d0                	cmp    %edx,%eax
8010499b:	75 f3                	jne    80104990 <getcallerpcs+0x50>
}
8010499d:	5b                   	pop    %ebx
8010499e:	5d                   	pop    %ebp
8010499f:	c3                   	ret    

801049a0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801049a0:	f3 0f 1e fb          	endbr32 
801049a4:	55                   	push   %ebp
801049a5:	89 e5                	mov    %esp,%ebp
801049a7:	53                   	push   %ebx
801049a8:	83 ec 04             	sub    $0x4,%esp
801049ab:	9c                   	pushf  
801049ac:	5b                   	pop    %ebx
  asm volatile("cli");
801049ad:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801049ae:	e8 fd f3 ff ff       	call   80103db0 <mycpu>
801049b3:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801049b9:	85 c0                	test   %eax,%eax
801049bb:	74 13                	je     801049d0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801049bd:	e8 ee f3 ff ff       	call   80103db0 <mycpu>
801049c2:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801049c9:	83 c4 04             	add    $0x4,%esp
801049cc:	5b                   	pop    %ebx
801049cd:	5d                   	pop    %ebp
801049ce:	c3                   	ret    
801049cf:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
801049d0:	e8 db f3 ff ff       	call   80103db0 <mycpu>
801049d5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801049db:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801049e1:	eb da                	jmp    801049bd <pushcli+0x1d>
801049e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801049f0 <popcli>:

void
popcli(void)
{
801049f0:	f3 0f 1e fb          	endbr32 
801049f4:	55                   	push   %ebp
801049f5:	89 e5                	mov    %esp,%ebp
801049f7:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801049fa:	9c                   	pushf  
801049fb:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801049fc:	f6 c4 02             	test   $0x2,%ah
801049ff:	75 31                	jne    80104a32 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104a01:	e8 aa f3 ff ff       	call   80103db0 <mycpu>
80104a06:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104a0d:	78 30                	js     80104a3f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104a0f:	e8 9c f3 ff ff       	call   80103db0 <mycpu>
80104a14:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104a1a:	85 d2                	test   %edx,%edx
80104a1c:	74 02                	je     80104a20 <popcli+0x30>
    sti();
}
80104a1e:	c9                   	leave  
80104a1f:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104a20:	e8 8b f3 ff ff       	call   80103db0 <mycpu>
80104a25:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104a2b:	85 c0                	test   %eax,%eax
80104a2d:	74 ef                	je     80104a1e <popcli+0x2e>
  asm volatile("sti");
80104a2f:	fb                   	sti    
}
80104a30:	c9                   	leave  
80104a31:	c3                   	ret    
    panic("popcli - interruptible");
80104a32:	83 ec 0c             	sub    $0xc,%esp
80104a35:	68 0b 81 10 80       	push   $0x8010810b
80104a3a:	e8 51 b9 ff ff       	call   80100390 <panic>
    panic("popcli");
80104a3f:	83 ec 0c             	sub    $0xc,%esp
80104a42:	68 22 81 10 80       	push   $0x80108122
80104a47:	e8 44 b9 ff ff       	call   80100390 <panic>
80104a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a50 <holding>:
{
80104a50:	f3 0f 1e fb          	endbr32 
80104a54:	55                   	push   %ebp
80104a55:	89 e5                	mov    %esp,%ebp
80104a57:	56                   	push   %esi
80104a58:	53                   	push   %ebx
80104a59:	8b 75 08             	mov    0x8(%ebp),%esi
80104a5c:	31 db                	xor    %ebx,%ebx
  pushcli();
80104a5e:	e8 3d ff ff ff       	call   801049a0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104a63:	8b 06                	mov    (%esi),%eax
80104a65:	85 c0                	test   %eax,%eax
80104a67:	75 0f                	jne    80104a78 <holding+0x28>
  popcli();
80104a69:	e8 82 ff ff ff       	call   801049f0 <popcli>
}
80104a6e:	89 d8                	mov    %ebx,%eax
80104a70:	5b                   	pop    %ebx
80104a71:	5e                   	pop    %esi
80104a72:	5d                   	pop    %ebp
80104a73:	c3                   	ret    
80104a74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104a78:	8b 5e 08             	mov    0x8(%esi),%ebx
80104a7b:	e8 30 f3 ff ff       	call   80103db0 <mycpu>
80104a80:	39 c3                	cmp    %eax,%ebx
80104a82:	0f 94 c3             	sete   %bl
  popcli();
80104a85:	e8 66 ff ff ff       	call   801049f0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104a8a:	0f b6 db             	movzbl %bl,%ebx
}
80104a8d:	89 d8                	mov    %ebx,%eax
80104a8f:	5b                   	pop    %ebx
80104a90:	5e                   	pop    %esi
80104a91:	5d                   	pop    %ebp
80104a92:	c3                   	ret    
80104a93:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104aa0 <acquire>:
{
80104aa0:	f3 0f 1e fb          	endbr32 
80104aa4:	55                   	push   %ebp
80104aa5:	89 e5                	mov    %esp,%ebp
80104aa7:	56                   	push   %esi
80104aa8:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104aa9:	e8 f2 fe ff ff       	call   801049a0 <pushcli>
  if(holding(lk))
80104aae:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104ab1:	83 ec 0c             	sub    $0xc,%esp
80104ab4:	53                   	push   %ebx
80104ab5:	e8 96 ff ff ff       	call   80104a50 <holding>
80104aba:	83 c4 10             	add    $0x10,%esp
80104abd:	85 c0                	test   %eax,%eax
80104abf:	0f 85 7f 00 00 00    	jne    80104b44 <acquire+0xa4>
80104ac5:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104ac7:	ba 01 00 00 00       	mov    $0x1,%edx
80104acc:	eb 05                	jmp    80104ad3 <acquire+0x33>
80104ace:	66 90                	xchg   %ax,%ax
80104ad0:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104ad3:	89 d0                	mov    %edx,%eax
80104ad5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104ad8:	85 c0                	test   %eax,%eax
80104ada:	75 f4                	jne    80104ad0 <acquire+0x30>
  __sync_synchronize();
80104adc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104ae1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104ae4:	e8 c7 f2 ff ff       	call   80103db0 <mycpu>
80104ae9:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104aec:	89 e8                	mov    %ebp,%eax
80104aee:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104af0:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104af6:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
80104afc:	77 22                	ja     80104b20 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104afe:	8b 50 04             	mov    0x4(%eax),%edx
80104b01:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80104b05:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104b08:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104b0a:	83 fe 0a             	cmp    $0xa,%esi
80104b0d:	75 e1                	jne    80104af0 <acquire+0x50>
}
80104b0f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b12:	5b                   	pop    %ebx
80104b13:	5e                   	pop    %esi
80104b14:	5d                   	pop    %ebp
80104b15:	c3                   	ret    
80104b16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b1d:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104b20:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104b24:	83 c3 34             	add    $0x34,%ebx
80104b27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b2e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104b30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104b36:	83 c0 04             	add    $0x4,%eax
80104b39:	39 d8                	cmp    %ebx,%eax
80104b3b:	75 f3                	jne    80104b30 <acquire+0x90>
}
80104b3d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b40:	5b                   	pop    %ebx
80104b41:	5e                   	pop    %esi
80104b42:	5d                   	pop    %ebp
80104b43:	c3                   	ret    
    panic("acquire");
80104b44:	83 ec 0c             	sub    $0xc,%esp
80104b47:	68 29 81 10 80       	push   $0x80108129
80104b4c:	e8 3f b8 ff ff       	call   80100390 <panic>
80104b51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b5f:	90                   	nop

80104b60 <release>:
{
80104b60:	f3 0f 1e fb          	endbr32 
80104b64:	55                   	push   %ebp
80104b65:	89 e5                	mov    %esp,%ebp
80104b67:	53                   	push   %ebx
80104b68:	83 ec 10             	sub    $0x10,%esp
80104b6b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104b6e:	53                   	push   %ebx
80104b6f:	e8 dc fe ff ff       	call   80104a50 <holding>
80104b74:	83 c4 10             	add    $0x10,%esp
80104b77:	85 c0                	test   %eax,%eax
80104b79:	74 22                	je     80104b9d <release+0x3d>
  lk->pcs[0] = 0;
80104b7b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104b82:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104b89:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104b8e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104b94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b97:	c9                   	leave  
  popcli();
80104b98:	e9 53 fe ff ff       	jmp    801049f0 <popcli>
    panic("release");
80104b9d:	83 ec 0c             	sub    $0xc,%esp
80104ba0:	68 31 81 10 80       	push   $0x80108131
80104ba5:	e8 e6 b7 ff ff       	call   80100390 <panic>
80104baa:	66 90                	xchg   %ax,%ax
80104bac:	66 90                	xchg   %ax,%ax
80104bae:	66 90                	xchg   %ax,%ax

80104bb0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104bb0:	f3 0f 1e fb          	endbr32 
80104bb4:	55                   	push   %ebp
80104bb5:	89 e5                	mov    %esp,%ebp
80104bb7:	57                   	push   %edi
80104bb8:	8b 55 08             	mov    0x8(%ebp),%edx
80104bbb:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104bbe:	53                   	push   %ebx
80104bbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104bc2:	89 d7                	mov    %edx,%edi
80104bc4:	09 cf                	or     %ecx,%edi
80104bc6:	83 e7 03             	and    $0x3,%edi
80104bc9:	75 25                	jne    80104bf0 <memset+0x40>
    c &= 0xFF;
80104bcb:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104bce:	c1 e0 18             	shl    $0x18,%eax
80104bd1:	89 fb                	mov    %edi,%ebx
80104bd3:	c1 e9 02             	shr    $0x2,%ecx
80104bd6:	c1 e3 10             	shl    $0x10,%ebx
80104bd9:	09 d8                	or     %ebx,%eax
80104bdb:	09 f8                	or     %edi,%eax
80104bdd:	c1 e7 08             	shl    $0x8,%edi
80104be0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104be2:	89 d7                	mov    %edx,%edi
80104be4:	fc                   	cld    
80104be5:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104be7:	5b                   	pop    %ebx
80104be8:	89 d0                	mov    %edx,%eax
80104bea:	5f                   	pop    %edi
80104beb:	5d                   	pop    %ebp
80104bec:	c3                   	ret    
80104bed:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80104bf0:	89 d7                	mov    %edx,%edi
80104bf2:	fc                   	cld    
80104bf3:	f3 aa                	rep stos %al,%es:(%edi)
80104bf5:	5b                   	pop    %ebx
80104bf6:	89 d0                	mov    %edx,%eax
80104bf8:	5f                   	pop    %edi
80104bf9:	5d                   	pop    %ebp
80104bfa:	c3                   	ret    
80104bfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bff:	90                   	nop

80104c00 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104c00:	f3 0f 1e fb          	endbr32 
80104c04:	55                   	push   %ebp
80104c05:	89 e5                	mov    %esp,%ebp
80104c07:	56                   	push   %esi
80104c08:	8b 75 10             	mov    0x10(%ebp),%esi
80104c0b:	8b 55 08             	mov    0x8(%ebp),%edx
80104c0e:	53                   	push   %ebx
80104c0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104c12:	85 f6                	test   %esi,%esi
80104c14:	74 2a                	je     80104c40 <memcmp+0x40>
80104c16:	01 c6                	add    %eax,%esi
80104c18:	eb 10                	jmp    80104c2a <memcmp+0x2a>
80104c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104c20:	83 c0 01             	add    $0x1,%eax
80104c23:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104c26:	39 f0                	cmp    %esi,%eax
80104c28:	74 16                	je     80104c40 <memcmp+0x40>
    if(*s1 != *s2)
80104c2a:	0f b6 0a             	movzbl (%edx),%ecx
80104c2d:	0f b6 18             	movzbl (%eax),%ebx
80104c30:	38 d9                	cmp    %bl,%cl
80104c32:	74 ec                	je     80104c20 <memcmp+0x20>
      return *s1 - *s2;
80104c34:	0f b6 c1             	movzbl %cl,%eax
80104c37:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104c39:	5b                   	pop    %ebx
80104c3a:	5e                   	pop    %esi
80104c3b:	5d                   	pop    %ebp
80104c3c:	c3                   	ret    
80104c3d:	8d 76 00             	lea    0x0(%esi),%esi
80104c40:	5b                   	pop    %ebx
  return 0;
80104c41:	31 c0                	xor    %eax,%eax
}
80104c43:	5e                   	pop    %esi
80104c44:	5d                   	pop    %ebp
80104c45:	c3                   	ret    
80104c46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c4d:	8d 76 00             	lea    0x0(%esi),%esi

80104c50 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104c50:	f3 0f 1e fb          	endbr32 
80104c54:	55                   	push   %ebp
80104c55:	89 e5                	mov    %esp,%ebp
80104c57:	57                   	push   %edi
80104c58:	8b 55 08             	mov    0x8(%ebp),%edx
80104c5b:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104c5e:	56                   	push   %esi
80104c5f:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104c62:	39 d6                	cmp    %edx,%esi
80104c64:	73 2a                	jae    80104c90 <memmove+0x40>
80104c66:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104c69:	39 fa                	cmp    %edi,%edx
80104c6b:	73 23                	jae    80104c90 <memmove+0x40>
80104c6d:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104c70:	85 c9                	test   %ecx,%ecx
80104c72:	74 13                	je     80104c87 <memmove+0x37>
80104c74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104c78:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104c7c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104c7f:	83 e8 01             	sub    $0x1,%eax
80104c82:	83 f8 ff             	cmp    $0xffffffff,%eax
80104c85:	75 f1                	jne    80104c78 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104c87:	5e                   	pop    %esi
80104c88:	89 d0                	mov    %edx,%eax
80104c8a:	5f                   	pop    %edi
80104c8b:	5d                   	pop    %ebp
80104c8c:	c3                   	ret    
80104c8d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80104c90:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104c93:	89 d7                	mov    %edx,%edi
80104c95:	85 c9                	test   %ecx,%ecx
80104c97:	74 ee                	je     80104c87 <memmove+0x37>
80104c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104ca0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104ca1:	39 f0                	cmp    %esi,%eax
80104ca3:	75 fb                	jne    80104ca0 <memmove+0x50>
}
80104ca5:	5e                   	pop    %esi
80104ca6:	89 d0                	mov    %edx,%eax
80104ca8:	5f                   	pop    %edi
80104ca9:	5d                   	pop    %ebp
80104caa:	c3                   	ret    
80104cab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104caf:	90                   	nop

80104cb0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104cb0:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80104cb4:	eb 9a                	jmp    80104c50 <memmove>
80104cb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cbd:	8d 76 00             	lea    0x0(%esi),%esi

80104cc0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104cc0:	f3 0f 1e fb          	endbr32 
80104cc4:	55                   	push   %ebp
80104cc5:	89 e5                	mov    %esp,%ebp
80104cc7:	56                   	push   %esi
80104cc8:	8b 75 10             	mov    0x10(%ebp),%esi
80104ccb:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104cce:	53                   	push   %ebx
80104ccf:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80104cd2:	85 f6                	test   %esi,%esi
80104cd4:	74 32                	je     80104d08 <strncmp+0x48>
80104cd6:	01 c6                	add    %eax,%esi
80104cd8:	eb 14                	jmp    80104cee <strncmp+0x2e>
80104cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ce0:	38 da                	cmp    %bl,%dl
80104ce2:	75 14                	jne    80104cf8 <strncmp+0x38>
    n--, p++, q++;
80104ce4:	83 c0 01             	add    $0x1,%eax
80104ce7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104cea:	39 f0                	cmp    %esi,%eax
80104cec:	74 1a                	je     80104d08 <strncmp+0x48>
80104cee:	0f b6 11             	movzbl (%ecx),%edx
80104cf1:	0f b6 18             	movzbl (%eax),%ebx
80104cf4:	84 d2                	test   %dl,%dl
80104cf6:	75 e8                	jne    80104ce0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104cf8:	0f b6 c2             	movzbl %dl,%eax
80104cfb:	29 d8                	sub    %ebx,%eax
}
80104cfd:	5b                   	pop    %ebx
80104cfe:	5e                   	pop    %esi
80104cff:	5d                   	pop    %ebp
80104d00:	c3                   	ret    
80104d01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d08:	5b                   	pop    %ebx
    return 0;
80104d09:	31 c0                	xor    %eax,%eax
}
80104d0b:	5e                   	pop    %esi
80104d0c:	5d                   	pop    %ebp
80104d0d:	c3                   	ret    
80104d0e:	66 90                	xchg   %ax,%ax

80104d10 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104d10:	f3 0f 1e fb          	endbr32 
80104d14:	55                   	push   %ebp
80104d15:	89 e5                	mov    %esp,%ebp
80104d17:	57                   	push   %edi
80104d18:	56                   	push   %esi
80104d19:	8b 75 08             	mov    0x8(%ebp),%esi
80104d1c:	53                   	push   %ebx
80104d1d:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104d20:	89 f2                	mov    %esi,%edx
80104d22:	eb 1b                	jmp    80104d3f <strncpy+0x2f>
80104d24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d28:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104d2c:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104d2f:	83 c2 01             	add    $0x1,%edx
80104d32:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80104d36:	89 f9                	mov    %edi,%ecx
80104d38:	88 4a ff             	mov    %cl,-0x1(%edx)
80104d3b:	84 c9                	test   %cl,%cl
80104d3d:	74 09                	je     80104d48 <strncpy+0x38>
80104d3f:	89 c3                	mov    %eax,%ebx
80104d41:	83 e8 01             	sub    $0x1,%eax
80104d44:	85 db                	test   %ebx,%ebx
80104d46:	7f e0                	jg     80104d28 <strncpy+0x18>
    ;
  while(n-- > 0)
80104d48:	89 d1                	mov    %edx,%ecx
80104d4a:	85 c0                	test   %eax,%eax
80104d4c:	7e 15                	jle    80104d63 <strncpy+0x53>
80104d4e:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80104d50:	83 c1 01             	add    $0x1,%ecx
80104d53:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80104d57:	89 c8                	mov    %ecx,%eax
80104d59:	f7 d0                	not    %eax
80104d5b:	01 d0                	add    %edx,%eax
80104d5d:	01 d8                	add    %ebx,%eax
80104d5f:	85 c0                	test   %eax,%eax
80104d61:	7f ed                	jg     80104d50 <strncpy+0x40>
  return os;
}
80104d63:	5b                   	pop    %ebx
80104d64:	89 f0                	mov    %esi,%eax
80104d66:	5e                   	pop    %esi
80104d67:	5f                   	pop    %edi
80104d68:	5d                   	pop    %ebp
80104d69:	c3                   	ret    
80104d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104d70 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104d70:	f3 0f 1e fb          	endbr32 
80104d74:	55                   	push   %ebp
80104d75:	89 e5                	mov    %esp,%ebp
80104d77:	56                   	push   %esi
80104d78:	8b 55 10             	mov    0x10(%ebp),%edx
80104d7b:	8b 75 08             	mov    0x8(%ebp),%esi
80104d7e:	53                   	push   %ebx
80104d7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104d82:	85 d2                	test   %edx,%edx
80104d84:	7e 21                	jle    80104da7 <safestrcpy+0x37>
80104d86:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104d8a:	89 f2                	mov    %esi,%edx
80104d8c:	eb 12                	jmp    80104da0 <safestrcpy+0x30>
80104d8e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104d90:	0f b6 08             	movzbl (%eax),%ecx
80104d93:	83 c0 01             	add    $0x1,%eax
80104d96:	83 c2 01             	add    $0x1,%edx
80104d99:	88 4a ff             	mov    %cl,-0x1(%edx)
80104d9c:	84 c9                	test   %cl,%cl
80104d9e:	74 04                	je     80104da4 <safestrcpy+0x34>
80104da0:	39 d8                	cmp    %ebx,%eax
80104da2:	75 ec                	jne    80104d90 <safestrcpy+0x20>
    ;
  *s = 0;
80104da4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104da7:	89 f0                	mov    %esi,%eax
80104da9:	5b                   	pop    %ebx
80104daa:	5e                   	pop    %esi
80104dab:	5d                   	pop    %ebp
80104dac:	c3                   	ret    
80104dad:	8d 76 00             	lea    0x0(%esi),%esi

80104db0 <strlen>:

int
strlen(const char *s)
{
80104db0:	f3 0f 1e fb          	endbr32 
80104db4:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104db5:	31 c0                	xor    %eax,%eax
{
80104db7:	89 e5                	mov    %esp,%ebp
80104db9:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104dbc:	80 3a 00             	cmpb   $0x0,(%edx)
80104dbf:	74 10                	je     80104dd1 <strlen+0x21>
80104dc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dc8:	83 c0 01             	add    $0x1,%eax
80104dcb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104dcf:	75 f7                	jne    80104dc8 <strlen+0x18>
    ;
  return n;
}
80104dd1:	5d                   	pop    %ebp
80104dd2:	c3                   	ret    

80104dd3 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104dd3:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104dd7:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104ddb:	55                   	push   %ebp
  pushl %ebx
80104ddc:	53                   	push   %ebx
  pushl %esi
80104ddd:	56                   	push   %esi
  pushl %edi
80104dde:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104ddf:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104de1:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104de3:	5f                   	pop    %edi
  popl %esi
80104de4:	5e                   	pop    %esi
  popl %ebx
80104de5:	5b                   	pop    %ebx
  popl %ebp
80104de6:	5d                   	pop    %ebp
  ret
80104de7:	c3                   	ret    
80104de8:	66 90                	xchg   %ax,%ax
80104dea:	66 90                	xchg   %ax,%ax
80104dec:	66 90                	xchg   %ax,%ax
80104dee:	66 90                	xchg   %ax,%ax

80104df0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104df0:	f3 0f 1e fb          	endbr32 
80104df4:	55                   	push   %ebp
80104df5:	89 e5                	mov    %esp,%ebp
80104df7:	53                   	push   %ebx
80104df8:	83 ec 04             	sub    $0x4,%esp
80104dfb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104dfe:	e8 4d f0 ff ff       	call   80103e50 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104e03:	8b 00                	mov    (%eax),%eax
80104e05:	39 d8                	cmp    %ebx,%eax
80104e07:	76 17                	jbe    80104e20 <fetchint+0x30>
80104e09:	8d 53 04             	lea    0x4(%ebx),%edx
80104e0c:	39 d0                	cmp    %edx,%eax
80104e0e:	72 10                	jb     80104e20 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104e10:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e13:	8b 13                	mov    (%ebx),%edx
80104e15:	89 10                	mov    %edx,(%eax)
  return 0;
80104e17:	31 c0                	xor    %eax,%eax
}
80104e19:	83 c4 04             	add    $0x4,%esp
80104e1c:	5b                   	pop    %ebx
80104e1d:	5d                   	pop    %ebp
80104e1e:	c3                   	ret    
80104e1f:	90                   	nop
    return -1;
80104e20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e25:	eb f2                	jmp    80104e19 <fetchint+0x29>
80104e27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e2e:	66 90                	xchg   %ax,%ax

80104e30 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104e30:	f3 0f 1e fb          	endbr32 
80104e34:	55                   	push   %ebp
80104e35:	89 e5                	mov    %esp,%ebp
80104e37:	53                   	push   %ebx
80104e38:	83 ec 04             	sub    $0x4,%esp
80104e3b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104e3e:	e8 0d f0 ff ff       	call   80103e50 <myproc>

  if(addr >= curproc->sz)
80104e43:	39 18                	cmp    %ebx,(%eax)
80104e45:	76 31                	jbe    80104e78 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80104e47:	8b 55 0c             	mov    0xc(%ebp),%edx
80104e4a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104e4c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104e4e:	39 d3                	cmp    %edx,%ebx
80104e50:	73 26                	jae    80104e78 <fetchstr+0x48>
80104e52:	89 d8                	mov    %ebx,%eax
80104e54:	eb 11                	jmp    80104e67 <fetchstr+0x37>
80104e56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e5d:	8d 76 00             	lea    0x0(%esi),%esi
80104e60:	83 c0 01             	add    $0x1,%eax
80104e63:	39 c2                	cmp    %eax,%edx
80104e65:	76 11                	jbe    80104e78 <fetchstr+0x48>
    if(*s == 0)
80104e67:	80 38 00             	cmpb   $0x0,(%eax)
80104e6a:	75 f4                	jne    80104e60 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
80104e6c:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
80104e6f:	29 d8                	sub    %ebx,%eax
}
80104e71:	5b                   	pop    %ebx
80104e72:	5d                   	pop    %ebp
80104e73:	c3                   	ret    
80104e74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e78:	83 c4 04             	add    $0x4,%esp
    return -1;
80104e7b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e80:	5b                   	pop    %ebx
80104e81:	5d                   	pop    %ebp
80104e82:	c3                   	ret    
80104e83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104e90 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104e90:	f3 0f 1e fb          	endbr32 
80104e94:	55                   	push   %ebp
80104e95:	89 e5                	mov    %esp,%ebp
80104e97:	56                   	push   %esi
80104e98:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e99:	e8 b2 ef ff ff       	call   80103e50 <myproc>
80104e9e:	8b 55 08             	mov    0x8(%ebp),%edx
80104ea1:	8b 40 18             	mov    0x18(%eax),%eax
80104ea4:	8b 40 44             	mov    0x44(%eax),%eax
80104ea7:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104eaa:	e8 a1 ef ff ff       	call   80103e50 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104eaf:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104eb2:	8b 00                	mov    (%eax),%eax
80104eb4:	39 c6                	cmp    %eax,%esi
80104eb6:	73 18                	jae    80104ed0 <argint+0x40>
80104eb8:	8d 53 08             	lea    0x8(%ebx),%edx
80104ebb:	39 d0                	cmp    %edx,%eax
80104ebd:	72 11                	jb     80104ed0 <argint+0x40>
  *ip = *(int*)(addr);
80104ebf:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ec2:	8b 53 04             	mov    0x4(%ebx),%edx
80104ec5:	89 10                	mov    %edx,(%eax)
  return 0;
80104ec7:	31 c0                	xor    %eax,%eax
}
80104ec9:	5b                   	pop    %ebx
80104eca:	5e                   	pop    %esi
80104ecb:	5d                   	pop    %ebp
80104ecc:	c3                   	ret    
80104ecd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104ed0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ed5:	eb f2                	jmp    80104ec9 <argint+0x39>
80104ed7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ede:	66 90                	xchg   %ax,%ax

80104ee0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104ee0:	f3 0f 1e fb          	endbr32 
80104ee4:	55                   	push   %ebp
80104ee5:	89 e5                	mov    %esp,%ebp
80104ee7:	56                   	push   %esi
80104ee8:	53                   	push   %ebx
80104ee9:	83 ec 10             	sub    $0x10,%esp
80104eec:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104eef:	e8 5c ef ff ff       	call   80103e50 <myproc>
 
  if(argint(n, &i) < 0)
80104ef4:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80104ef7:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80104ef9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104efc:	50                   	push   %eax
80104efd:	ff 75 08             	pushl  0x8(%ebp)
80104f00:	e8 8b ff ff ff       	call   80104e90 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104f05:	83 c4 10             	add    $0x10,%esp
80104f08:	85 c0                	test   %eax,%eax
80104f0a:	78 24                	js     80104f30 <argptr+0x50>
80104f0c:	85 db                	test   %ebx,%ebx
80104f0e:	78 20                	js     80104f30 <argptr+0x50>
80104f10:	8b 16                	mov    (%esi),%edx
80104f12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f15:	39 c2                	cmp    %eax,%edx
80104f17:	76 17                	jbe    80104f30 <argptr+0x50>
80104f19:	01 c3                	add    %eax,%ebx
80104f1b:	39 da                	cmp    %ebx,%edx
80104f1d:	72 11                	jb     80104f30 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104f1f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104f22:	89 02                	mov    %eax,(%edx)
  return 0;
80104f24:	31 c0                	xor    %eax,%eax
}
80104f26:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f29:	5b                   	pop    %ebx
80104f2a:	5e                   	pop    %esi
80104f2b:	5d                   	pop    %ebp
80104f2c:	c3                   	ret    
80104f2d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104f30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f35:	eb ef                	jmp    80104f26 <argptr+0x46>
80104f37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f3e:	66 90                	xchg   %ax,%ax

80104f40 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104f40:	f3 0f 1e fb          	endbr32 
80104f44:	55                   	push   %ebp
80104f45:	89 e5                	mov    %esp,%ebp
80104f47:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104f4a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f4d:	50                   	push   %eax
80104f4e:	ff 75 08             	pushl  0x8(%ebp)
80104f51:	e8 3a ff ff ff       	call   80104e90 <argint>
80104f56:	83 c4 10             	add    $0x10,%esp
80104f59:	85 c0                	test   %eax,%eax
80104f5b:	78 13                	js     80104f70 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104f5d:	83 ec 08             	sub    $0x8,%esp
80104f60:	ff 75 0c             	pushl  0xc(%ebp)
80104f63:	ff 75 f4             	pushl  -0xc(%ebp)
80104f66:	e8 c5 fe ff ff       	call   80104e30 <fetchstr>
80104f6b:	83 c4 10             	add    $0x10,%esp
}
80104f6e:	c9                   	leave  
80104f6f:	c3                   	ret    
80104f70:	c9                   	leave  
    return -1;
80104f71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f76:	c3                   	ret    
80104f77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f7e:	66 90                	xchg   %ax,%ax

80104f80 <syscall>:
[SYS_get_number_of_free_pages] sys_get_number_of_free_pages
};

void
syscall(void)
{
80104f80:	f3 0f 1e fb          	endbr32 
80104f84:	55                   	push   %ebp
80104f85:	89 e5                	mov    %esp,%ebp
80104f87:	53                   	push   %ebx
80104f88:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104f8b:	e8 c0 ee ff ff       	call   80103e50 <myproc>
80104f90:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104f92:	8b 40 18             	mov    0x18(%eax),%eax
80104f95:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104f98:	8d 50 ff             	lea    -0x1(%eax),%edx
80104f9b:	83 fa 15             	cmp    $0x15,%edx
80104f9e:	77 20                	ja     80104fc0 <syscall+0x40>
80104fa0:	8b 14 85 60 81 10 80 	mov    -0x7fef7ea0(,%eax,4),%edx
80104fa7:	85 d2                	test   %edx,%edx
80104fa9:	74 15                	je     80104fc0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104fab:	ff d2                	call   *%edx
80104fad:	89 c2                	mov    %eax,%edx
80104faf:	8b 43 18             	mov    0x18(%ebx),%eax
80104fb2:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104fb5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104fb8:	c9                   	leave  
80104fb9:	c3                   	ret    
80104fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104fc0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104fc1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104fc4:	50                   	push   %eax
80104fc5:	ff 73 10             	pushl  0x10(%ebx)
80104fc8:	68 39 81 10 80       	push   $0x80108139
80104fcd:	e8 de b6 ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80104fd2:	8b 43 18             	mov    0x18(%ebx),%eax
80104fd5:	83 c4 10             	add    $0x10,%esp
80104fd8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104fdf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104fe2:	c9                   	leave  
80104fe3:	c3                   	ret    
80104fe4:	66 90                	xchg   %ax,%ax
80104fe6:	66 90                	xchg   %ax,%ax
80104fe8:	66 90                	xchg   %ax,%ax
80104fea:	66 90                	xchg   %ax,%ax
80104fec:	66 90                	xchg   %ax,%ax
80104fee:	66 90                	xchg   %ax,%ax

80104ff0 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104ff0:	55                   	push   %ebp
80104ff1:	89 e5                	mov    %esp,%ebp
80104ff3:	56                   	push   %esi
80104ff4:	89 d6                	mov    %edx,%esi
80104ff6:	53                   	push   %ebx
80104ff7:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104ff9:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104ffc:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104fff:	50                   	push   %eax
80105000:	6a 00                	push   $0x0
80105002:	e8 89 fe ff ff       	call   80104e90 <argint>
80105007:	83 c4 10             	add    $0x10,%esp
8010500a:	85 c0                	test   %eax,%eax
8010500c:	78 2a                	js     80105038 <argfd.constprop.0+0x48>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010500e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105012:	77 24                	ja     80105038 <argfd.constprop.0+0x48>
80105014:	e8 37 ee ff ff       	call   80103e50 <myproc>
80105019:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010501c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105020:	85 c0                	test   %eax,%eax
80105022:	74 14                	je     80105038 <argfd.constprop.0+0x48>
    return -1;
  if(pfd)
80105024:	85 db                	test   %ebx,%ebx
80105026:	74 02                	je     8010502a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105028:	89 13                	mov    %edx,(%ebx)
  if(pf)
    *pf = f;
8010502a:	89 06                	mov    %eax,(%esi)
  return 0;
8010502c:	31 c0                	xor    %eax,%eax
}
8010502e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105031:	5b                   	pop    %ebx
80105032:	5e                   	pop    %esi
80105033:	5d                   	pop    %ebp
80105034:	c3                   	ret    
80105035:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105038:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010503d:	eb ef                	jmp    8010502e <argfd.constprop.0+0x3e>
8010503f:	90                   	nop

80105040 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80105040:	f3 0f 1e fb          	endbr32 
80105044:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105045:	31 c0                	xor    %eax,%eax
{
80105047:	89 e5                	mov    %esp,%ebp
80105049:	56                   	push   %esi
8010504a:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
8010504b:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010504e:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80105051:	e8 9a ff ff ff       	call   80104ff0 <argfd.constprop.0>
80105056:	85 c0                	test   %eax,%eax
80105058:	78 1e                	js     80105078 <sys_dup+0x38>
    return -1;
  if((fd=fdalloc(f)) < 0)
8010505a:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
8010505d:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010505f:	e8 ec ed ff ff       	call   80103e50 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105068:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
8010506c:	85 d2                	test   %edx,%edx
8010506e:	74 20                	je     80105090 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80105070:	83 c3 01             	add    $0x1,%ebx
80105073:	83 fb 10             	cmp    $0x10,%ebx
80105076:	75 f0                	jne    80105068 <sys_dup+0x28>
    return -1;
  filedup(f);
  return fd;
}
80105078:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010507b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105080:	89 d8                	mov    %ebx,%eax
80105082:	5b                   	pop    %ebx
80105083:	5e                   	pop    %esi
80105084:	5d                   	pop    %ebp
80105085:	c3                   	ret    
80105086:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010508d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105090:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105094:	83 ec 0c             	sub    $0xc,%esp
80105097:	ff 75 f4             	pushl  -0xc(%ebp)
8010509a:	e8 81 be ff ff       	call   80100f20 <filedup>
  return fd;
8010509f:	83 c4 10             	add    $0x10,%esp
}
801050a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050a5:	89 d8                	mov    %ebx,%eax
801050a7:	5b                   	pop    %ebx
801050a8:	5e                   	pop    %esi
801050a9:	5d                   	pop    %ebp
801050aa:	c3                   	ret    
801050ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801050af:	90                   	nop

801050b0 <sys_read>:

int
sys_read(void)
{
801050b0:	f3 0f 1e fb          	endbr32 
801050b4:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801050b5:	31 c0                	xor    %eax,%eax
{
801050b7:	89 e5                	mov    %esp,%ebp
801050b9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801050bc:	8d 55 ec             	lea    -0x14(%ebp),%edx
801050bf:	e8 2c ff ff ff       	call   80104ff0 <argfd.constprop.0>
801050c4:	85 c0                	test   %eax,%eax
801050c6:	78 48                	js     80105110 <sys_read+0x60>
801050c8:	83 ec 08             	sub    $0x8,%esp
801050cb:	8d 45 f0             	lea    -0x10(%ebp),%eax
801050ce:	50                   	push   %eax
801050cf:	6a 02                	push   $0x2
801050d1:	e8 ba fd ff ff       	call   80104e90 <argint>
801050d6:	83 c4 10             	add    $0x10,%esp
801050d9:	85 c0                	test   %eax,%eax
801050db:	78 33                	js     80105110 <sys_read+0x60>
801050dd:	83 ec 04             	sub    $0x4,%esp
801050e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050e3:	ff 75 f0             	pushl  -0x10(%ebp)
801050e6:	50                   	push   %eax
801050e7:	6a 01                	push   $0x1
801050e9:	e8 f2 fd ff ff       	call   80104ee0 <argptr>
801050ee:	83 c4 10             	add    $0x10,%esp
801050f1:	85 c0                	test   %eax,%eax
801050f3:	78 1b                	js     80105110 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
801050f5:	83 ec 04             	sub    $0x4,%esp
801050f8:	ff 75 f0             	pushl  -0x10(%ebp)
801050fb:	ff 75 f4             	pushl  -0xc(%ebp)
801050fe:	ff 75 ec             	pushl  -0x14(%ebp)
80105101:	e8 9a bf ff ff       	call   801010a0 <fileread>
80105106:	83 c4 10             	add    $0x10,%esp
}
80105109:	c9                   	leave  
8010510a:	c3                   	ret    
8010510b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010510f:	90                   	nop
80105110:	c9                   	leave  
    return -1;
80105111:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105116:	c3                   	ret    
80105117:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010511e:	66 90                	xchg   %ax,%ax

80105120 <sys_write>:

int
sys_write(void)
{
80105120:	f3 0f 1e fb          	endbr32 
80105124:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105125:	31 c0                	xor    %eax,%eax
{
80105127:	89 e5                	mov    %esp,%ebp
80105129:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010512c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010512f:	e8 bc fe ff ff       	call   80104ff0 <argfd.constprop.0>
80105134:	85 c0                	test   %eax,%eax
80105136:	78 48                	js     80105180 <sys_write+0x60>
80105138:	83 ec 08             	sub    $0x8,%esp
8010513b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010513e:	50                   	push   %eax
8010513f:	6a 02                	push   $0x2
80105141:	e8 4a fd ff ff       	call   80104e90 <argint>
80105146:	83 c4 10             	add    $0x10,%esp
80105149:	85 c0                	test   %eax,%eax
8010514b:	78 33                	js     80105180 <sys_write+0x60>
8010514d:	83 ec 04             	sub    $0x4,%esp
80105150:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105153:	ff 75 f0             	pushl  -0x10(%ebp)
80105156:	50                   	push   %eax
80105157:	6a 01                	push   $0x1
80105159:	e8 82 fd ff ff       	call   80104ee0 <argptr>
8010515e:	83 c4 10             	add    $0x10,%esp
80105161:	85 c0                	test   %eax,%eax
80105163:	78 1b                	js     80105180 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80105165:	83 ec 04             	sub    $0x4,%esp
80105168:	ff 75 f0             	pushl  -0x10(%ebp)
8010516b:	ff 75 f4             	pushl  -0xc(%ebp)
8010516e:	ff 75 ec             	pushl  -0x14(%ebp)
80105171:	e8 ca bf ff ff       	call   80101140 <filewrite>
80105176:	83 c4 10             	add    $0x10,%esp
}
80105179:	c9                   	leave  
8010517a:	c3                   	ret    
8010517b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010517f:	90                   	nop
80105180:	c9                   	leave  
    return -1;
80105181:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105186:	c3                   	ret    
80105187:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010518e:	66 90                	xchg   %ax,%ax

80105190 <sys_close>:

int
sys_close(void)
{
80105190:	f3 0f 1e fb          	endbr32 
80105194:	55                   	push   %ebp
80105195:	89 e5                	mov    %esp,%ebp
80105197:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
8010519a:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010519d:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051a0:	e8 4b fe ff ff       	call   80104ff0 <argfd.constprop.0>
801051a5:	85 c0                	test   %eax,%eax
801051a7:	78 27                	js     801051d0 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
801051a9:	e8 a2 ec ff ff       	call   80103e50 <myproc>
801051ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801051b1:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801051b4:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801051bb:	00 
  fileclose(f);
801051bc:	ff 75 f4             	pushl  -0xc(%ebp)
801051bf:	e8 ac bd ff ff       	call   80100f70 <fileclose>
  return 0;
801051c4:	83 c4 10             	add    $0x10,%esp
801051c7:	31 c0                	xor    %eax,%eax
}
801051c9:	c9                   	leave  
801051ca:	c3                   	ret    
801051cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051cf:	90                   	nop
801051d0:	c9                   	leave  
    return -1;
801051d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051d6:	c3                   	ret    
801051d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051de:	66 90                	xchg   %ax,%ax

801051e0 <sys_fstat>:

int
sys_fstat(void)
{
801051e0:	f3 0f 1e fb          	endbr32 
801051e4:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801051e5:	31 c0                	xor    %eax,%eax
{
801051e7:	89 e5                	mov    %esp,%ebp
801051e9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801051ec:	8d 55 f0             	lea    -0x10(%ebp),%edx
801051ef:	e8 fc fd ff ff       	call   80104ff0 <argfd.constprop.0>
801051f4:	85 c0                	test   %eax,%eax
801051f6:	78 30                	js     80105228 <sys_fstat+0x48>
801051f8:	83 ec 04             	sub    $0x4,%esp
801051fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051fe:	6a 14                	push   $0x14
80105200:	50                   	push   %eax
80105201:	6a 01                	push   $0x1
80105203:	e8 d8 fc ff ff       	call   80104ee0 <argptr>
80105208:	83 c4 10             	add    $0x10,%esp
8010520b:	85 c0                	test   %eax,%eax
8010520d:	78 19                	js     80105228 <sys_fstat+0x48>
    return -1;
  return filestat(f, st);
8010520f:	83 ec 08             	sub    $0x8,%esp
80105212:	ff 75 f4             	pushl  -0xc(%ebp)
80105215:	ff 75 f0             	pushl  -0x10(%ebp)
80105218:	e8 33 be ff ff       	call   80101050 <filestat>
8010521d:	83 c4 10             	add    $0x10,%esp
}
80105220:	c9                   	leave  
80105221:	c3                   	ret    
80105222:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105228:	c9                   	leave  
    return -1;
80105229:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010522e:	c3                   	ret    
8010522f:	90                   	nop

80105230 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105230:	f3 0f 1e fb          	endbr32 
80105234:	55                   	push   %ebp
80105235:	89 e5                	mov    %esp,%ebp
80105237:	57                   	push   %edi
80105238:	56                   	push   %esi
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105239:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
8010523c:	53                   	push   %ebx
8010523d:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105240:	50                   	push   %eax
80105241:	6a 00                	push   $0x0
80105243:	e8 f8 fc ff ff       	call   80104f40 <argstr>
80105248:	83 c4 10             	add    $0x10,%esp
8010524b:	85 c0                	test   %eax,%eax
8010524d:	0f 88 ff 00 00 00    	js     80105352 <sys_link+0x122>
80105253:	83 ec 08             	sub    $0x8,%esp
80105256:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105259:	50                   	push   %eax
8010525a:	6a 01                	push   $0x1
8010525c:	e8 df fc ff ff       	call   80104f40 <argstr>
80105261:	83 c4 10             	add    $0x10,%esp
80105264:	85 c0                	test   %eax,%eax
80105266:	0f 88 e6 00 00 00    	js     80105352 <sys_link+0x122>
    return -1;

  begin_op();
8010526c:	e8 7f df ff ff       	call   801031f0 <begin_op>
  if((ip = namei(old)) == 0){
80105271:	83 ec 0c             	sub    $0xc,%esp
80105274:	ff 75 d4             	pushl  -0x2c(%ebp)
80105277:	e8 64 ce ff ff       	call   801020e0 <namei>
8010527c:	83 c4 10             	add    $0x10,%esp
8010527f:	89 c3                	mov    %eax,%ebx
80105281:	85 c0                	test   %eax,%eax
80105283:	0f 84 e8 00 00 00    	je     80105371 <sys_link+0x141>
    end_op();
    return -1;
  }

  ilock(ip);
80105289:	83 ec 0c             	sub    $0xc,%esp
8010528c:	50                   	push   %eax
8010528d:	e8 7e c5 ff ff       	call   80101810 <ilock>
  if(ip->type == T_DIR){
80105292:	83 c4 10             	add    $0x10,%esp
80105295:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010529a:	0f 84 b9 00 00 00    	je     80105359 <sys_link+0x129>
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
801052a0:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801052a3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
801052a8:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801052ab:	53                   	push   %ebx
801052ac:	e8 9f c4 ff ff       	call   80101750 <iupdate>
  iunlock(ip);
801052b1:	89 1c 24             	mov    %ebx,(%esp)
801052b4:	e8 37 c6 ff ff       	call   801018f0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801052b9:	58                   	pop    %eax
801052ba:	5a                   	pop    %edx
801052bb:	57                   	push   %edi
801052bc:	ff 75 d0             	pushl  -0x30(%ebp)
801052bf:	e8 3c ce ff ff       	call   80102100 <nameiparent>
801052c4:	83 c4 10             	add    $0x10,%esp
801052c7:	89 c6                	mov    %eax,%esi
801052c9:	85 c0                	test   %eax,%eax
801052cb:	74 5f                	je     8010532c <sys_link+0xfc>
    goto bad;
  ilock(dp);
801052cd:	83 ec 0c             	sub    $0xc,%esp
801052d0:	50                   	push   %eax
801052d1:	e8 3a c5 ff ff       	call   80101810 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801052d6:	8b 03                	mov    (%ebx),%eax
801052d8:	83 c4 10             	add    $0x10,%esp
801052db:	39 06                	cmp    %eax,(%esi)
801052dd:	75 41                	jne    80105320 <sys_link+0xf0>
801052df:	83 ec 04             	sub    $0x4,%esp
801052e2:	ff 73 04             	pushl  0x4(%ebx)
801052e5:	57                   	push   %edi
801052e6:	56                   	push   %esi
801052e7:	e8 34 cd ff ff       	call   80102020 <dirlink>
801052ec:	83 c4 10             	add    $0x10,%esp
801052ef:	85 c0                	test   %eax,%eax
801052f1:	78 2d                	js     80105320 <sys_link+0xf0>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
801052f3:	83 ec 0c             	sub    $0xc,%esp
801052f6:	56                   	push   %esi
801052f7:	e8 b4 c7 ff ff       	call   80101ab0 <iunlockput>
  iput(ip);
801052fc:	89 1c 24             	mov    %ebx,(%esp)
801052ff:	e8 3c c6 ff ff       	call   80101940 <iput>

  end_op();
80105304:	e8 57 df ff ff       	call   80103260 <end_op>

  return 0;
80105309:	83 c4 10             	add    $0x10,%esp
8010530c:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
8010530e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105311:	5b                   	pop    %ebx
80105312:	5e                   	pop    %esi
80105313:	5f                   	pop    %edi
80105314:	5d                   	pop    %ebp
80105315:	c3                   	ret    
80105316:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010531d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80105320:	83 ec 0c             	sub    $0xc,%esp
80105323:	56                   	push   %esi
80105324:	e8 87 c7 ff ff       	call   80101ab0 <iunlockput>
    goto bad;
80105329:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
8010532c:	83 ec 0c             	sub    $0xc,%esp
8010532f:	53                   	push   %ebx
80105330:	e8 db c4 ff ff       	call   80101810 <ilock>
  ip->nlink--;
80105335:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010533a:	89 1c 24             	mov    %ebx,(%esp)
8010533d:	e8 0e c4 ff ff       	call   80101750 <iupdate>
  iunlockput(ip);
80105342:	89 1c 24             	mov    %ebx,(%esp)
80105345:	e8 66 c7 ff ff       	call   80101ab0 <iunlockput>
  end_op();
8010534a:	e8 11 df ff ff       	call   80103260 <end_op>
  return -1;
8010534f:	83 c4 10             	add    $0x10,%esp
80105352:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105357:	eb b5                	jmp    8010530e <sys_link+0xde>
    iunlockput(ip);
80105359:	83 ec 0c             	sub    $0xc,%esp
8010535c:	53                   	push   %ebx
8010535d:	e8 4e c7 ff ff       	call   80101ab0 <iunlockput>
    end_op();
80105362:	e8 f9 de ff ff       	call   80103260 <end_op>
    return -1;
80105367:	83 c4 10             	add    $0x10,%esp
8010536a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010536f:	eb 9d                	jmp    8010530e <sys_link+0xde>
    end_op();
80105371:	e8 ea de ff ff       	call   80103260 <end_op>
    return -1;
80105376:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010537b:	eb 91                	jmp    8010530e <sys_link+0xde>
8010537d:	8d 76 00             	lea    0x0(%esi),%esi

80105380 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
80105380:	f3 0f 1e fb          	endbr32 
80105384:	55                   	push   %ebp
80105385:	89 e5                	mov    %esp,%ebp
80105387:	57                   	push   %edi
80105388:	56                   	push   %esi
80105389:	8d 7d d8             	lea    -0x28(%ebp),%edi
8010538c:	53                   	push   %ebx
8010538d:	bb 20 00 00 00       	mov    $0x20,%ebx
80105392:	83 ec 1c             	sub    $0x1c,%esp
80105395:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105398:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
8010539c:	77 0a                	ja     801053a8 <isdirempty+0x28>
8010539e:	eb 30                	jmp    801053d0 <isdirempty+0x50>
801053a0:	83 c3 10             	add    $0x10,%ebx
801053a3:	39 5e 58             	cmp    %ebx,0x58(%esi)
801053a6:	76 28                	jbe    801053d0 <isdirempty+0x50>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801053a8:	6a 10                	push   $0x10
801053aa:	53                   	push   %ebx
801053ab:	57                   	push   %edi
801053ac:	56                   	push   %esi
801053ad:	e8 5e c7 ff ff       	call   80101b10 <readi>
801053b2:	83 c4 10             	add    $0x10,%esp
801053b5:	83 f8 10             	cmp    $0x10,%eax
801053b8:	75 23                	jne    801053dd <isdirempty+0x5d>
      panic("isdirempty: readi");
    if(de.inum != 0)
801053ba:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801053bf:	74 df                	je     801053a0 <isdirempty+0x20>
      return 0;
  }
  return 1;
}
801053c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801053c4:	31 c0                	xor    %eax,%eax
}
801053c6:	5b                   	pop    %ebx
801053c7:	5e                   	pop    %esi
801053c8:	5f                   	pop    %edi
801053c9:	5d                   	pop    %ebp
801053ca:	c3                   	ret    
801053cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053cf:	90                   	nop
801053d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 1;
801053d3:	b8 01 00 00 00       	mov    $0x1,%eax
}
801053d8:	5b                   	pop    %ebx
801053d9:	5e                   	pop    %esi
801053da:	5f                   	pop    %edi
801053db:	5d                   	pop    %ebp
801053dc:	c3                   	ret    
      panic("isdirempty: readi");
801053dd:	83 ec 0c             	sub    $0xc,%esp
801053e0:	68 bc 81 10 80       	push   $0x801081bc
801053e5:	e8 a6 af ff ff       	call   80100390 <panic>
801053ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801053f0 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
801053f0:	f3 0f 1e fb          	endbr32 
801053f4:	55                   	push   %ebp
801053f5:	89 e5                	mov    %esp,%ebp
801053f7:	57                   	push   %edi
801053f8:	56                   	push   %esi
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801053f9:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801053fc:	53                   	push   %ebx
801053fd:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
80105400:	50                   	push   %eax
80105401:	6a 00                	push   $0x0
80105403:	e8 38 fb ff ff       	call   80104f40 <argstr>
80105408:	83 c4 10             	add    $0x10,%esp
8010540b:	85 c0                	test   %eax,%eax
8010540d:	0f 88 5d 01 00 00    	js     80105570 <sys_unlink+0x180>
    return -1;

  begin_op();
80105413:	e8 d8 dd ff ff       	call   801031f0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105418:	8d 5d ca             	lea    -0x36(%ebp),%ebx
8010541b:	83 ec 08             	sub    $0x8,%esp
8010541e:	53                   	push   %ebx
8010541f:	ff 75 c0             	pushl  -0x40(%ebp)
80105422:	e8 d9 cc ff ff       	call   80102100 <nameiparent>
80105427:	83 c4 10             	add    $0x10,%esp
8010542a:	89 c6                	mov    %eax,%esi
8010542c:	85 c0                	test   %eax,%eax
8010542e:	0f 84 43 01 00 00    	je     80105577 <sys_unlink+0x187>
    end_op();
    return -1;
  }

  ilock(dp);
80105434:	83 ec 0c             	sub    $0xc,%esp
80105437:	50                   	push   %eax
80105438:	e8 d3 c3 ff ff       	call   80101810 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010543d:	58                   	pop    %eax
8010543e:	5a                   	pop    %edx
8010543f:	68 9d 7b 10 80       	push   $0x80107b9d
80105444:	53                   	push   %ebx
80105445:	e8 f6 c8 ff ff       	call   80101d40 <namecmp>
8010544a:	83 c4 10             	add    $0x10,%esp
8010544d:	85 c0                	test   %eax,%eax
8010544f:	0f 84 db 00 00 00    	je     80105530 <sys_unlink+0x140>
80105455:	83 ec 08             	sub    $0x8,%esp
80105458:	68 9c 7b 10 80       	push   $0x80107b9c
8010545d:	53                   	push   %ebx
8010545e:	e8 dd c8 ff ff       	call   80101d40 <namecmp>
80105463:	83 c4 10             	add    $0x10,%esp
80105466:	85 c0                	test   %eax,%eax
80105468:	0f 84 c2 00 00 00    	je     80105530 <sys_unlink+0x140>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010546e:	83 ec 04             	sub    $0x4,%esp
80105471:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105474:	50                   	push   %eax
80105475:	53                   	push   %ebx
80105476:	56                   	push   %esi
80105477:	e8 e4 c8 ff ff       	call   80101d60 <dirlookup>
8010547c:	83 c4 10             	add    $0x10,%esp
8010547f:	89 c3                	mov    %eax,%ebx
80105481:	85 c0                	test   %eax,%eax
80105483:	0f 84 a7 00 00 00    	je     80105530 <sys_unlink+0x140>
    goto bad;
  ilock(ip);
80105489:	83 ec 0c             	sub    $0xc,%esp
8010548c:	50                   	push   %eax
8010548d:	e8 7e c3 ff ff       	call   80101810 <ilock>

  if(ip->nlink < 1)
80105492:	83 c4 10             	add    $0x10,%esp
80105495:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010549a:	0f 8e f3 00 00 00    	jle    80105593 <sys_unlink+0x1a3>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
801054a0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801054a5:	74 69                	je     80105510 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
801054a7:	83 ec 04             	sub    $0x4,%esp
801054aa:	8d 7d d8             	lea    -0x28(%ebp),%edi
801054ad:	6a 10                	push   $0x10
801054af:	6a 00                	push   $0x0
801054b1:	57                   	push   %edi
801054b2:	e8 f9 f6 ff ff       	call   80104bb0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801054b7:	6a 10                	push   $0x10
801054b9:	ff 75 c4             	pushl  -0x3c(%ebp)
801054bc:	57                   	push   %edi
801054bd:	56                   	push   %esi
801054be:	e8 4d c7 ff ff       	call   80101c10 <writei>
801054c3:	83 c4 20             	add    $0x20,%esp
801054c6:	83 f8 10             	cmp    $0x10,%eax
801054c9:	0f 85 b7 00 00 00    	jne    80105586 <sys_unlink+0x196>
    panic("unlink: writei");
  if(ip->type == T_DIR){
801054cf:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801054d4:	74 7a                	je     80105550 <sys_unlink+0x160>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
801054d6:	83 ec 0c             	sub    $0xc,%esp
801054d9:	56                   	push   %esi
801054da:	e8 d1 c5 ff ff       	call   80101ab0 <iunlockput>

  ip->nlink--;
801054df:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801054e4:	89 1c 24             	mov    %ebx,(%esp)
801054e7:	e8 64 c2 ff ff       	call   80101750 <iupdate>
  iunlockput(ip);
801054ec:	89 1c 24             	mov    %ebx,(%esp)
801054ef:	e8 bc c5 ff ff       	call   80101ab0 <iunlockput>

  end_op();
801054f4:	e8 67 dd ff ff       	call   80103260 <end_op>

  return 0;
801054f9:	83 c4 10             	add    $0x10,%esp
801054fc:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
801054fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105501:	5b                   	pop    %ebx
80105502:	5e                   	pop    %esi
80105503:	5f                   	pop    %edi
80105504:	5d                   	pop    %ebp
80105505:	c3                   	ret    
80105506:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010550d:	8d 76 00             	lea    0x0(%esi),%esi
  if(ip->type == T_DIR && !isdirempty(ip)){
80105510:	83 ec 0c             	sub    $0xc,%esp
80105513:	53                   	push   %ebx
80105514:	e8 67 fe ff ff       	call   80105380 <isdirempty>
80105519:	83 c4 10             	add    $0x10,%esp
8010551c:	85 c0                	test   %eax,%eax
8010551e:	75 87                	jne    801054a7 <sys_unlink+0xb7>
    iunlockput(ip);
80105520:	83 ec 0c             	sub    $0xc,%esp
80105523:	53                   	push   %ebx
80105524:	e8 87 c5 ff ff       	call   80101ab0 <iunlockput>
    goto bad;
80105529:	83 c4 10             	add    $0x10,%esp
8010552c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
80105530:	83 ec 0c             	sub    $0xc,%esp
80105533:	56                   	push   %esi
80105534:	e8 77 c5 ff ff       	call   80101ab0 <iunlockput>
  end_op();
80105539:	e8 22 dd ff ff       	call   80103260 <end_op>
  return -1;
8010553e:	83 c4 10             	add    $0x10,%esp
80105541:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105546:	eb b6                	jmp    801054fe <sys_unlink+0x10e>
80105548:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010554f:	90                   	nop
    iupdate(dp);
80105550:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105553:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105558:	56                   	push   %esi
80105559:	e8 f2 c1 ff ff       	call   80101750 <iupdate>
8010555e:	83 c4 10             	add    $0x10,%esp
80105561:	e9 70 ff ff ff       	jmp    801054d6 <sys_unlink+0xe6>
80105566:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010556d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105570:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105575:	eb 87                	jmp    801054fe <sys_unlink+0x10e>
    end_op();
80105577:	e8 e4 dc ff ff       	call   80103260 <end_op>
    return -1;
8010557c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105581:	e9 78 ff ff ff       	jmp    801054fe <sys_unlink+0x10e>
    panic("unlink: writei");
80105586:	83 ec 0c             	sub    $0xc,%esp
80105589:	68 b1 7b 10 80       	push   $0x80107bb1
8010558e:	e8 fd ad ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105593:	83 ec 0c             	sub    $0xc,%esp
80105596:	68 9f 7b 10 80       	push   $0x80107b9f
8010559b:	e8 f0 ad ff ff       	call   80100390 <panic>

801055a0 <create>:

struct inode*
create(char *path, short type, short major, short minor)
{
801055a0:	f3 0f 1e fb          	endbr32 
801055a4:	55                   	push   %ebp
801055a5:	89 e5                	mov    %esp,%ebp
801055a7:	57                   	push   %edi
801055a8:	56                   	push   %esi
801055a9:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801055aa:	8d 5d da             	lea    -0x26(%ebp),%ebx
{
801055ad:	83 ec 34             	sub    $0x34,%esp
801055b0:	8b 45 0c             	mov    0xc(%ebp),%eax
801055b3:	8b 55 10             	mov    0x10(%ebp),%edx
  if((dp = nameiparent(path, name)) == 0)
801055b6:	53                   	push   %ebx
{
801055b7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
801055ba:	ff 75 08             	pushl  0x8(%ebp)
{
801055bd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801055c0:	89 55 d0             	mov    %edx,-0x30(%ebp)
801055c3:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801055c6:	e8 35 cb ff ff       	call   80102100 <nameiparent>
801055cb:	83 c4 10             	add    $0x10,%esp
801055ce:	85 c0                	test   %eax,%eax
801055d0:	0f 84 3a 01 00 00    	je     80105710 <create+0x170>
    return 0;
  ilock(dp);
801055d6:	83 ec 0c             	sub    $0xc,%esp
801055d9:	89 c6                	mov    %eax,%esi
801055db:	50                   	push   %eax
801055dc:	e8 2f c2 ff ff       	call   80101810 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
801055e1:	83 c4 0c             	add    $0xc,%esp
801055e4:	6a 00                	push   $0x0
801055e6:	53                   	push   %ebx
801055e7:	56                   	push   %esi
801055e8:	e8 73 c7 ff ff       	call   80101d60 <dirlookup>
801055ed:	83 c4 10             	add    $0x10,%esp
801055f0:	89 c7                	mov    %eax,%edi
801055f2:	85 c0                	test   %eax,%eax
801055f4:	74 4a                	je     80105640 <create+0xa0>
    iunlockput(dp);
801055f6:	83 ec 0c             	sub    $0xc,%esp
801055f9:	56                   	push   %esi
801055fa:	e8 b1 c4 ff ff       	call   80101ab0 <iunlockput>
    ilock(ip);
801055ff:	89 3c 24             	mov    %edi,(%esp)
80105602:	e8 09 c2 ff ff       	call   80101810 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105607:	83 c4 10             	add    $0x10,%esp
8010560a:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
8010560f:	75 17                	jne    80105628 <create+0x88>
80105611:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80105616:	75 10                	jne    80105628 <create+0x88>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105618:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010561b:	89 f8                	mov    %edi,%eax
8010561d:	5b                   	pop    %ebx
8010561e:	5e                   	pop    %esi
8010561f:	5f                   	pop    %edi
80105620:	5d                   	pop    %ebp
80105621:	c3                   	ret    
80105622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105628:	83 ec 0c             	sub    $0xc,%esp
8010562b:	57                   	push   %edi
    return 0;
8010562c:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
8010562e:	e8 7d c4 ff ff       	call   80101ab0 <iunlockput>
    return 0;
80105633:	83 c4 10             	add    $0x10,%esp
}
80105636:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105639:	89 f8                	mov    %edi,%eax
8010563b:	5b                   	pop    %ebx
8010563c:	5e                   	pop    %esi
8010563d:	5f                   	pop    %edi
8010563e:	5d                   	pop    %ebp
8010563f:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80105640:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105644:	83 ec 08             	sub    $0x8,%esp
80105647:	50                   	push   %eax
80105648:	ff 36                	pushl  (%esi)
8010564a:	e8 41 c0 ff ff       	call   80101690 <ialloc>
8010564f:	83 c4 10             	add    $0x10,%esp
80105652:	89 c7                	mov    %eax,%edi
80105654:	85 c0                	test   %eax,%eax
80105656:	0f 84 cd 00 00 00    	je     80105729 <create+0x189>
  ilock(ip);
8010565c:	83 ec 0c             	sub    $0xc,%esp
8010565f:	50                   	push   %eax
80105660:	e8 ab c1 ff ff       	call   80101810 <ilock>
  ip->major = major;
80105665:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105669:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
8010566d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105671:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105675:	b8 01 00 00 00       	mov    $0x1,%eax
8010567a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
8010567e:	89 3c 24             	mov    %edi,(%esp)
80105681:	e8 ca c0 ff ff       	call   80101750 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105686:	83 c4 10             	add    $0x10,%esp
80105689:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010568e:	74 30                	je     801056c0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105690:	83 ec 04             	sub    $0x4,%esp
80105693:	ff 77 04             	pushl  0x4(%edi)
80105696:	53                   	push   %ebx
80105697:	56                   	push   %esi
80105698:	e8 83 c9 ff ff       	call   80102020 <dirlink>
8010569d:	83 c4 10             	add    $0x10,%esp
801056a0:	85 c0                	test   %eax,%eax
801056a2:	78 78                	js     8010571c <create+0x17c>
  iunlockput(dp);
801056a4:	83 ec 0c             	sub    $0xc,%esp
801056a7:	56                   	push   %esi
801056a8:	e8 03 c4 ff ff       	call   80101ab0 <iunlockput>
  return ip;
801056ad:	83 c4 10             	add    $0x10,%esp
}
801056b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056b3:	89 f8                	mov    %edi,%eax
801056b5:	5b                   	pop    %ebx
801056b6:	5e                   	pop    %esi
801056b7:	5f                   	pop    %edi
801056b8:	5d                   	pop    %ebp
801056b9:	c3                   	ret    
801056ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
801056c0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
801056c3:	66 83 46 56 01       	addw   $0x1,0x56(%esi)
    iupdate(dp);
801056c8:	56                   	push   %esi
801056c9:	e8 82 c0 ff ff       	call   80101750 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801056ce:	83 c4 0c             	add    $0xc,%esp
801056d1:	ff 77 04             	pushl  0x4(%edi)
801056d4:	68 9d 7b 10 80       	push   $0x80107b9d
801056d9:	57                   	push   %edi
801056da:	e8 41 c9 ff ff       	call   80102020 <dirlink>
801056df:	83 c4 10             	add    $0x10,%esp
801056e2:	85 c0                	test   %eax,%eax
801056e4:	78 18                	js     801056fe <create+0x15e>
801056e6:	83 ec 04             	sub    $0x4,%esp
801056e9:	ff 76 04             	pushl  0x4(%esi)
801056ec:	68 9c 7b 10 80       	push   $0x80107b9c
801056f1:	57                   	push   %edi
801056f2:	e8 29 c9 ff ff       	call   80102020 <dirlink>
801056f7:	83 c4 10             	add    $0x10,%esp
801056fa:	85 c0                	test   %eax,%eax
801056fc:	79 92                	jns    80105690 <create+0xf0>
      panic("create dots");
801056fe:	83 ec 0c             	sub    $0xc,%esp
80105701:	68 dd 81 10 80       	push   $0x801081dd
80105706:	e8 85 ac ff ff       	call   80100390 <panic>
8010570b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010570f:	90                   	nop
}
80105710:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105713:	31 ff                	xor    %edi,%edi
}
80105715:	5b                   	pop    %ebx
80105716:	89 f8                	mov    %edi,%eax
80105718:	5e                   	pop    %esi
80105719:	5f                   	pop    %edi
8010571a:	5d                   	pop    %ebp
8010571b:	c3                   	ret    
    panic("create: dirlink");
8010571c:	83 ec 0c             	sub    $0xc,%esp
8010571f:	68 e9 81 10 80       	push   $0x801081e9
80105724:	e8 67 ac ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105729:	83 ec 0c             	sub    $0xc,%esp
8010572c:	68 ce 81 10 80       	push   $0x801081ce
80105731:	e8 5a ac ff ff       	call   80100390 <panic>
80105736:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010573d:	8d 76 00             	lea    0x0(%esi),%esi

80105740 <sys_open>:

int
sys_open(void)
{
80105740:	f3 0f 1e fb          	endbr32 
80105744:	55                   	push   %ebp
80105745:	89 e5                	mov    %esp,%ebp
80105747:	57                   	push   %edi
80105748:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105749:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
8010574c:	53                   	push   %ebx
8010574d:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105750:	50                   	push   %eax
80105751:	6a 00                	push   $0x0
80105753:	e8 e8 f7 ff ff       	call   80104f40 <argstr>
80105758:	83 c4 10             	add    $0x10,%esp
8010575b:	85 c0                	test   %eax,%eax
8010575d:	0f 88 8a 00 00 00    	js     801057ed <sys_open+0xad>
80105763:	83 ec 08             	sub    $0x8,%esp
80105766:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105769:	50                   	push   %eax
8010576a:	6a 01                	push   $0x1
8010576c:	e8 1f f7 ff ff       	call   80104e90 <argint>
80105771:	83 c4 10             	add    $0x10,%esp
80105774:	85 c0                	test   %eax,%eax
80105776:	78 75                	js     801057ed <sys_open+0xad>
    return -1;

  begin_op();
80105778:	e8 73 da ff ff       	call   801031f0 <begin_op>

  if(omode & O_CREATE){
8010577d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105781:	75 75                	jne    801057f8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105783:	83 ec 0c             	sub    $0xc,%esp
80105786:	ff 75 e0             	pushl  -0x20(%ebp)
80105789:	e8 52 c9 ff ff       	call   801020e0 <namei>
8010578e:	83 c4 10             	add    $0x10,%esp
80105791:	89 c6                	mov    %eax,%esi
80105793:	85 c0                	test   %eax,%eax
80105795:	74 78                	je     8010580f <sys_open+0xcf>
      end_op();
      return -1;
    }
    ilock(ip);
80105797:	83 ec 0c             	sub    $0xc,%esp
8010579a:	50                   	push   %eax
8010579b:	e8 70 c0 ff ff       	call   80101810 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801057a0:	83 c4 10             	add    $0x10,%esp
801057a3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801057a8:	0f 84 ba 00 00 00    	je     80105868 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801057ae:	e8 fd b6 ff ff       	call   80100eb0 <filealloc>
801057b3:	89 c7                	mov    %eax,%edi
801057b5:	85 c0                	test   %eax,%eax
801057b7:	74 23                	je     801057dc <sys_open+0x9c>
  struct proc *curproc = myproc();
801057b9:	e8 92 e6 ff ff       	call   80103e50 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801057be:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801057c0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801057c4:	85 d2                	test   %edx,%edx
801057c6:	74 58                	je     80105820 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
801057c8:	83 c3 01             	add    $0x1,%ebx
801057cb:	83 fb 10             	cmp    $0x10,%ebx
801057ce:	75 f0                	jne    801057c0 <sys_open+0x80>
    if(f)
      fileclose(f);
801057d0:	83 ec 0c             	sub    $0xc,%esp
801057d3:	57                   	push   %edi
801057d4:	e8 97 b7 ff ff       	call   80100f70 <fileclose>
801057d9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801057dc:	83 ec 0c             	sub    $0xc,%esp
801057df:	56                   	push   %esi
801057e0:	e8 cb c2 ff ff       	call   80101ab0 <iunlockput>
    end_op();
801057e5:	e8 76 da ff ff       	call   80103260 <end_op>
    return -1;
801057ea:	83 c4 10             	add    $0x10,%esp
801057ed:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801057f2:	eb 65                	jmp    80105859 <sys_open+0x119>
801057f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801057f8:	6a 00                	push   $0x0
801057fa:	6a 00                	push   $0x0
801057fc:	6a 02                	push   $0x2
801057fe:	ff 75 e0             	pushl  -0x20(%ebp)
80105801:	e8 9a fd ff ff       	call   801055a0 <create>
    if(ip == 0){
80105806:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105809:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010580b:	85 c0                	test   %eax,%eax
8010580d:	75 9f                	jne    801057ae <sys_open+0x6e>
      end_op();
8010580f:	e8 4c da ff ff       	call   80103260 <end_op>
      return -1;
80105814:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105819:	eb 3e                	jmp    80105859 <sys_open+0x119>
8010581b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010581f:	90                   	nop
  }
  iunlock(ip);
80105820:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105823:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105827:	56                   	push   %esi
80105828:	e8 c3 c0 ff ff       	call   801018f0 <iunlock>
  end_op();
8010582d:	e8 2e da ff ff       	call   80103260 <end_op>

  f->type = FD_INODE;
80105832:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105838:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010583b:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
8010583e:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105841:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105843:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010584a:	f7 d0                	not    %eax
8010584c:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010584f:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105852:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105855:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105859:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010585c:	89 d8                	mov    %ebx,%eax
8010585e:	5b                   	pop    %ebx
8010585f:	5e                   	pop    %esi
80105860:	5f                   	pop    %edi
80105861:	5d                   	pop    %ebp
80105862:	c3                   	ret    
80105863:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105867:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105868:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010586b:	85 c9                	test   %ecx,%ecx
8010586d:	0f 84 3b ff ff ff    	je     801057ae <sys_open+0x6e>
80105873:	e9 64 ff ff ff       	jmp    801057dc <sys_open+0x9c>
80105878:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010587f:	90                   	nop

80105880 <sys_mkdir>:

int
sys_mkdir(void)
{
80105880:	f3 0f 1e fb          	endbr32 
80105884:	55                   	push   %ebp
80105885:	89 e5                	mov    %esp,%ebp
80105887:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010588a:	e8 61 d9 ff ff       	call   801031f0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010588f:	83 ec 08             	sub    $0x8,%esp
80105892:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105895:	50                   	push   %eax
80105896:	6a 00                	push   $0x0
80105898:	e8 a3 f6 ff ff       	call   80104f40 <argstr>
8010589d:	83 c4 10             	add    $0x10,%esp
801058a0:	85 c0                	test   %eax,%eax
801058a2:	78 2c                	js     801058d0 <sys_mkdir+0x50>
801058a4:	6a 00                	push   $0x0
801058a6:	6a 00                	push   $0x0
801058a8:	6a 01                	push   $0x1
801058aa:	ff 75 f4             	pushl  -0xc(%ebp)
801058ad:	e8 ee fc ff ff       	call   801055a0 <create>
801058b2:	83 c4 10             	add    $0x10,%esp
801058b5:	85 c0                	test   %eax,%eax
801058b7:	74 17                	je     801058d0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801058b9:	83 ec 0c             	sub    $0xc,%esp
801058bc:	50                   	push   %eax
801058bd:	e8 ee c1 ff ff       	call   80101ab0 <iunlockput>
  end_op();
801058c2:	e8 99 d9 ff ff       	call   80103260 <end_op>
  return 0;
801058c7:	83 c4 10             	add    $0x10,%esp
801058ca:	31 c0                	xor    %eax,%eax
}
801058cc:	c9                   	leave  
801058cd:	c3                   	ret    
801058ce:	66 90                	xchg   %ax,%ax
    end_op();
801058d0:	e8 8b d9 ff ff       	call   80103260 <end_op>
    return -1;
801058d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058da:	c9                   	leave  
801058db:	c3                   	ret    
801058dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058e0 <sys_mknod>:

int
sys_mknod(void)
{
801058e0:	f3 0f 1e fb          	endbr32 
801058e4:	55                   	push   %ebp
801058e5:	89 e5                	mov    %esp,%ebp
801058e7:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801058ea:	e8 01 d9 ff ff       	call   801031f0 <begin_op>
  if((argstr(0, &path)) < 0 ||
801058ef:	83 ec 08             	sub    $0x8,%esp
801058f2:	8d 45 ec             	lea    -0x14(%ebp),%eax
801058f5:	50                   	push   %eax
801058f6:	6a 00                	push   $0x0
801058f8:	e8 43 f6 ff ff       	call   80104f40 <argstr>
801058fd:	83 c4 10             	add    $0x10,%esp
80105900:	85 c0                	test   %eax,%eax
80105902:	78 5c                	js     80105960 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105904:	83 ec 08             	sub    $0x8,%esp
80105907:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010590a:	50                   	push   %eax
8010590b:	6a 01                	push   $0x1
8010590d:	e8 7e f5 ff ff       	call   80104e90 <argint>
  if((argstr(0, &path)) < 0 ||
80105912:	83 c4 10             	add    $0x10,%esp
80105915:	85 c0                	test   %eax,%eax
80105917:	78 47                	js     80105960 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105919:	83 ec 08             	sub    $0x8,%esp
8010591c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010591f:	50                   	push   %eax
80105920:	6a 02                	push   $0x2
80105922:	e8 69 f5 ff ff       	call   80104e90 <argint>
     argint(1, &major) < 0 ||
80105927:	83 c4 10             	add    $0x10,%esp
8010592a:	85 c0                	test   %eax,%eax
8010592c:	78 32                	js     80105960 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010592e:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105932:	50                   	push   %eax
80105933:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
80105937:	50                   	push   %eax
80105938:	6a 03                	push   $0x3
8010593a:	ff 75 ec             	pushl  -0x14(%ebp)
8010593d:	e8 5e fc ff ff       	call   801055a0 <create>
     argint(2, &minor) < 0 ||
80105942:	83 c4 10             	add    $0x10,%esp
80105945:	85 c0                	test   %eax,%eax
80105947:	74 17                	je     80105960 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105949:	83 ec 0c             	sub    $0xc,%esp
8010594c:	50                   	push   %eax
8010594d:	e8 5e c1 ff ff       	call   80101ab0 <iunlockput>
  end_op();
80105952:	e8 09 d9 ff ff       	call   80103260 <end_op>
  return 0;
80105957:	83 c4 10             	add    $0x10,%esp
8010595a:	31 c0                	xor    %eax,%eax
}
8010595c:	c9                   	leave  
8010595d:	c3                   	ret    
8010595e:	66 90                	xchg   %ax,%ax
    end_op();
80105960:	e8 fb d8 ff ff       	call   80103260 <end_op>
    return -1;
80105965:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010596a:	c9                   	leave  
8010596b:	c3                   	ret    
8010596c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105970 <sys_chdir>:

int
sys_chdir(void)
{
80105970:	f3 0f 1e fb          	endbr32 
80105974:	55                   	push   %ebp
80105975:	89 e5                	mov    %esp,%ebp
80105977:	56                   	push   %esi
80105978:	53                   	push   %ebx
80105979:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
8010597c:	e8 cf e4 ff ff       	call   80103e50 <myproc>
80105981:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105983:	e8 68 d8 ff ff       	call   801031f0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105988:	83 ec 08             	sub    $0x8,%esp
8010598b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010598e:	50                   	push   %eax
8010598f:	6a 00                	push   $0x0
80105991:	e8 aa f5 ff ff       	call   80104f40 <argstr>
80105996:	83 c4 10             	add    $0x10,%esp
80105999:	85 c0                	test   %eax,%eax
8010599b:	78 73                	js     80105a10 <sys_chdir+0xa0>
8010599d:	83 ec 0c             	sub    $0xc,%esp
801059a0:	ff 75 f4             	pushl  -0xc(%ebp)
801059a3:	e8 38 c7 ff ff       	call   801020e0 <namei>
801059a8:	83 c4 10             	add    $0x10,%esp
801059ab:	89 c3                	mov    %eax,%ebx
801059ad:	85 c0                	test   %eax,%eax
801059af:	74 5f                	je     80105a10 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801059b1:	83 ec 0c             	sub    $0xc,%esp
801059b4:	50                   	push   %eax
801059b5:	e8 56 be ff ff       	call   80101810 <ilock>
  if(ip->type != T_DIR){
801059ba:	83 c4 10             	add    $0x10,%esp
801059bd:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801059c2:	75 2c                	jne    801059f0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801059c4:	83 ec 0c             	sub    $0xc,%esp
801059c7:	53                   	push   %ebx
801059c8:	e8 23 bf ff ff       	call   801018f0 <iunlock>
  iput(curproc->cwd);
801059cd:	58                   	pop    %eax
801059ce:	ff 76 68             	pushl  0x68(%esi)
801059d1:	e8 6a bf ff ff       	call   80101940 <iput>
  end_op();
801059d6:	e8 85 d8 ff ff       	call   80103260 <end_op>
  curproc->cwd = ip;
801059db:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801059de:	83 c4 10             	add    $0x10,%esp
801059e1:	31 c0                	xor    %eax,%eax
}
801059e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801059e6:	5b                   	pop    %ebx
801059e7:	5e                   	pop    %esi
801059e8:	5d                   	pop    %ebp
801059e9:	c3                   	ret    
801059ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
801059f0:	83 ec 0c             	sub    $0xc,%esp
801059f3:	53                   	push   %ebx
801059f4:	e8 b7 c0 ff ff       	call   80101ab0 <iunlockput>
    end_op();
801059f9:	e8 62 d8 ff ff       	call   80103260 <end_op>
    return -1;
801059fe:	83 c4 10             	add    $0x10,%esp
80105a01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a06:	eb db                	jmp    801059e3 <sys_chdir+0x73>
80105a08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a0f:	90                   	nop
    end_op();
80105a10:	e8 4b d8 ff ff       	call   80103260 <end_op>
    return -1;
80105a15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a1a:	eb c7                	jmp    801059e3 <sys_chdir+0x73>
80105a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a20 <sys_exec>:

int
sys_exec(void)
{
80105a20:	f3 0f 1e fb          	endbr32 
80105a24:	55                   	push   %ebp
80105a25:	89 e5                	mov    %esp,%ebp
80105a27:	57                   	push   %edi
80105a28:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105a29:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105a2f:	53                   	push   %ebx
80105a30:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105a36:	50                   	push   %eax
80105a37:	6a 00                	push   $0x0
80105a39:	e8 02 f5 ff ff       	call   80104f40 <argstr>
80105a3e:	83 c4 10             	add    $0x10,%esp
80105a41:	85 c0                	test   %eax,%eax
80105a43:	0f 88 8b 00 00 00    	js     80105ad4 <sys_exec+0xb4>
80105a49:	83 ec 08             	sub    $0x8,%esp
80105a4c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105a52:	50                   	push   %eax
80105a53:	6a 01                	push   $0x1
80105a55:	e8 36 f4 ff ff       	call   80104e90 <argint>
80105a5a:	83 c4 10             	add    $0x10,%esp
80105a5d:	85 c0                	test   %eax,%eax
80105a5f:	78 73                	js     80105ad4 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105a61:	83 ec 04             	sub    $0x4,%esp
80105a64:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
80105a6a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105a6c:	68 80 00 00 00       	push   $0x80
80105a71:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105a77:	6a 00                	push   $0x0
80105a79:	50                   	push   %eax
80105a7a:	e8 31 f1 ff ff       	call   80104bb0 <memset>
80105a7f:	83 c4 10             	add    $0x10,%esp
80105a82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105a88:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105a8e:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105a95:	83 ec 08             	sub    $0x8,%esp
80105a98:	57                   	push   %edi
80105a99:	01 f0                	add    %esi,%eax
80105a9b:	50                   	push   %eax
80105a9c:	e8 4f f3 ff ff       	call   80104df0 <fetchint>
80105aa1:	83 c4 10             	add    $0x10,%esp
80105aa4:	85 c0                	test   %eax,%eax
80105aa6:	78 2c                	js     80105ad4 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80105aa8:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105aae:	85 c0                	test   %eax,%eax
80105ab0:	74 36                	je     80105ae8 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105ab2:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105ab8:	83 ec 08             	sub    $0x8,%esp
80105abb:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105abe:	52                   	push   %edx
80105abf:	50                   	push   %eax
80105ac0:	e8 6b f3 ff ff       	call   80104e30 <fetchstr>
80105ac5:	83 c4 10             	add    $0x10,%esp
80105ac8:	85 c0                	test   %eax,%eax
80105aca:	78 08                	js     80105ad4 <sys_exec+0xb4>
  for(i=0;; i++){
80105acc:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105acf:	83 fb 20             	cmp    $0x20,%ebx
80105ad2:	75 b4                	jne    80105a88 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80105ad4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105ad7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105adc:	5b                   	pop    %ebx
80105add:	5e                   	pop    %esi
80105ade:	5f                   	pop    %edi
80105adf:	5d                   	pop    %ebp
80105ae0:	c3                   	ret    
80105ae1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105ae8:	83 ec 08             	sub    $0x8,%esp
80105aeb:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105af1:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105af8:	00 00 00 00 
  return exec(path, argv);
80105afc:	50                   	push   %eax
80105afd:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105b03:	e8 18 b0 ff ff       	call   80100b20 <exec>
80105b08:	83 c4 10             	add    $0x10,%esp
}
80105b0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b0e:	5b                   	pop    %ebx
80105b0f:	5e                   	pop    %esi
80105b10:	5f                   	pop    %edi
80105b11:	5d                   	pop    %ebp
80105b12:	c3                   	ret    
80105b13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105b20 <sys_pipe>:

int
sys_pipe(void)
{
80105b20:	f3 0f 1e fb          	endbr32 
80105b24:	55                   	push   %ebp
80105b25:	89 e5                	mov    %esp,%ebp
80105b27:	57                   	push   %edi
80105b28:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105b29:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105b2c:	53                   	push   %ebx
80105b2d:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105b30:	6a 08                	push   $0x8
80105b32:	50                   	push   %eax
80105b33:	6a 00                	push   $0x0
80105b35:	e8 a6 f3 ff ff       	call   80104ee0 <argptr>
80105b3a:	83 c4 10             	add    $0x10,%esp
80105b3d:	85 c0                	test   %eax,%eax
80105b3f:	78 4e                	js     80105b8f <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105b41:	83 ec 08             	sub    $0x8,%esp
80105b44:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105b47:	50                   	push   %eax
80105b48:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105b4b:	50                   	push   %eax
80105b4c:	e8 6f dd ff ff       	call   801038c0 <pipealloc>
80105b51:	83 c4 10             	add    $0x10,%esp
80105b54:	85 c0                	test   %eax,%eax
80105b56:	78 37                	js     80105b8f <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105b58:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105b5b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105b5d:	e8 ee e2 ff ff       	call   80103e50 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105b62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105b68:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105b6c:	85 f6                	test   %esi,%esi
80105b6e:	74 30                	je     80105ba0 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80105b70:	83 c3 01             	add    $0x1,%ebx
80105b73:	83 fb 10             	cmp    $0x10,%ebx
80105b76:	75 f0                	jne    80105b68 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105b78:	83 ec 0c             	sub    $0xc,%esp
80105b7b:	ff 75 e0             	pushl  -0x20(%ebp)
80105b7e:	e8 ed b3 ff ff       	call   80100f70 <fileclose>
    fileclose(wf);
80105b83:	58                   	pop    %eax
80105b84:	ff 75 e4             	pushl  -0x1c(%ebp)
80105b87:	e8 e4 b3 ff ff       	call   80100f70 <fileclose>
    return -1;
80105b8c:	83 c4 10             	add    $0x10,%esp
80105b8f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b94:	eb 5b                	jmp    80105bf1 <sys_pipe+0xd1>
80105b96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b9d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105ba0:	8d 73 08             	lea    0x8(%ebx),%esi
80105ba3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105ba7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105baa:	e8 a1 e2 ff ff       	call   80103e50 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105baf:	31 d2                	xor    %edx,%edx
80105bb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105bb8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105bbc:	85 c9                	test   %ecx,%ecx
80105bbe:	74 20                	je     80105be0 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105bc0:	83 c2 01             	add    $0x1,%edx
80105bc3:	83 fa 10             	cmp    $0x10,%edx
80105bc6:	75 f0                	jne    80105bb8 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105bc8:	e8 83 e2 ff ff       	call   80103e50 <myproc>
80105bcd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105bd4:	00 
80105bd5:	eb a1                	jmp    80105b78 <sys_pipe+0x58>
80105bd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bde:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105be0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105be4:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105be7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105be9:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105bec:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105bef:	31 c0                	xor    %eax,%eax
}
80105bf1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bf4:	5b                   	pop    %ebx
80105bf5:	5e                   	pop    %esi
80105bf6:	5f                   	pop    %edi
80105bf7:	5d                   	pop    %ebp
80105bf8:	c3                   	ret    
80105bf9:	66 90                	xchg   %ax,%ax
80105bfb:	66 90                	xchg   %ax,%ax
80105bfd:	66 90                	xchg   %ax,%ax
80105bff:	90                   	nop

80105c00 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105c00:	f3 0f 1e fb          	endbr32 
  return fork();
80105c04:	e9 27 e4 ff ff       	jmp    80104030 <fork>
80105c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105c10 <sys_exit>:
}

int
sys_exit(void)
{
80105c10:	f3 0f 1e fb          	endbr32 
80105c14:	55                   	push   %ebp
80105c15:	89 e5                	mov    %esp,%ebp
80105c17:	83 ec 08             	sub    $0x8,%esp
  exit();
80105c1a:	e8 91 e6 ff ff       	call   801042b0 <exit>
  return 0;  // not reached
}
80105c1f:	31 c0                	xor    %eax,%eax
80105c21:	c9                   	leave  
80105c22:	c3                   	ret    
80105c23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105c30 <sys_wait>:

int
sys_wait(void)
{
80105c30:	f3 0f 1e fb          	endbr32 
  return wait();
80105c34:	e9 c7 e8 ff ff       	jmp    80104500 <wait>
80105c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105c40 <sys_kill>:
}

int
sys_kill(void)
{
80105c40:	f3 0f 1e fb          	endbr32 
80105c44:	55                   	push   %ebp
80105c45:	89 e5                	mov    %esp,%ebp
80105c47:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105c4a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c4d:	50                   	push   %eax
80105c4e:	6a 00                	push   $0x0
80105c50:	e8 3b f2 ff ff       	call   80104e90 <argint>
80105c55:	83 c4 10             	add    $0x10,%esp
80105c58:	85 c0                	test   %eax,%eax
80105c5a:	78 14                	js     80105c70 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105c5c:	83 ec 0c             	sub    $0xc,%esp
80105c5f:	ff 75 f4             	pushl  -0xc(%ebp)
80105c62:	e8 09 ea ff ff       	call   80104670 <kill>
80105c67:	83 c4 10             	add    $0x10,%esp
}
80105c6a:	c9                   	leave  
80105c6b:	c3                   	ret    
80105c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c70:	c9                   	leave  
    return -1;
80105c71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c76:	c3                   	ret    
80105c77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c7e:	66 90                	xchg   %ax,%ax

80105c80 <sys_getpid>:

int
sys_getpid(void)
{
80105c80:	f3 0f 1e fb          	endbr32 
80105c84:	55                   	push   %ebp
80105c85:	89 e5                	mov    %esp,%ebp
80105c87:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105c8a:	e8 c1 e1 ff ff       	call   80103e50 <myproc>
80105c8f:	8b 40 10             	mov    0x10(%eax),%eax
}
80105c92:	c9                   	leave  
80105c93:	c3                   	ret    
80105c94:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c9f:	90                   	nop

80105ca0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105ca0:	f3 0f 1e fb          	endbr32 
80105ca4:	55                   	push   %ebp
80105ca5:	89 e5                	mov    %esp,%ebp
80105ca7:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105ca8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105cab:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105cae:	50                   	push   %eax
80105caf:	6a 00                	push   $0x0
80105cb1:	e8 da f1 ff ff       	call   80104e90 <argint>
80105cb6:	83 c4 10             	add    $0x10,%esp
80105cb9:	85 c0                	test   %eax,%eax
80105cbb:	78 23                	js     80105ce0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105cbd:	e8 8e e1 ff ff       	call   80103e50 <myproc>
  if(growproc(n) < 0)
80105cc2:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105cc5:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105cc7:	ff 75 f4             	pushl  -0xc(%ebp)
80105cca:	e8 b1 e2 ff ff       	call   80103f80 <growproc>
80105ccf:	83 c4 10             	add    $0x10,%esp
80105cd2:	85 c0                	test   %eax,%eax
80105cd4:	78 0a                	js     80105ce0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105cd6:	89 d8                	mov    %ebx,%eax
80105cd8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105cdb:	c9                   	leave  
80105cdc:	c3                   	ret    
80105cdd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105ce0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105ce5:	eb ef                	jmp    80105cd6 <sys_sbrk+0x36>
80105ce7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cee:	66 90                	xchg   %ax,%ax

80105cf0 <sys_sleep>:

int
sys_sleep(void)
{
80105cf0:	f3 0f 1e fb          	endbr32 
80105cf4:	55                   	push   %ebp
80105cf5:	89 e5                	mov    %esp,%ebp
80105cf7:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105cf8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105cfb:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105cfe:	50                   	push   %eax
80105cff:	6a 00                	push   $0x0
80105d01:	e8 8a f1 ff ff       	call   80104e90 <argint>
80105d06:	83 c4 10             	add    $0x10,%esp
80105d09:	85 c0                	test   %eax,%eax
80105d0b:	0f 88 86 00 00 00    	js     80105d97 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105d11:	83 ec 0c             	sub    $0xc,%esp
80105d14:	68 e0 11 13 80       	push   $0x801311e0
80105d19:	e8 82 ed ff ff       	call   80104aa0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105d1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105d21:	8b 1d 20 1a 13 80    	mov    0x80131a20,%ebx
  while(ticks - ticks0 < n){
80105d27:	83 c4 10             	add    $0x10,%esp
80105d2a:	85 d2                	test   %edx,%edx
80105d2c:	75 23                	jne    80105d51 <sys_sleep+0x61>
80105d2e:	eb 50                	jmp    80105d80 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105d30:	83 ec 08             	sub    $0x8,%esp
80105d33:	68 e0 11 13 80       	push   $0x801311e0
80105d38:	68 20 1a 13 80       	push   $0x80131a20
80105d3d:	e8 fe e6 ff ff       	call   80104440 <sleep>
  while(ticks - ticks0 < n){
80105d42:	a1 20 1a 13 80       	mov    0x80131a20,%eax
80105d47:	83 c4 10             	add    $0x10,%esp
80105d4a:	29 d8                	sub    %ebx,%eax
80105d4c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105d4f:	73 2f                	jae    80105d80 <sys_sleep+0x90>
    if(myproc()->killed){
80105d51:	e8 fa e0 ff ff       	call   80103e50 <myproc>
80105d56:	8b 40 24             	mov    0x24(%eax),%eax
80105d59:	85 c0                	test   %eax,%eax
80105d5b:	74 d3                	je     80105d30 <sys_sleep+0x40>
      release(&tickslock);
80105d5d:	83 ec 0c             	sub    $0xc,%esp
80105d60:	68 e0 11 13 80       	push   $0x801311e0
80105d65:	e8 f6 ed ff ff       	call   80104b60 <release>
  }
  release(&tickslock);
  return 0;
}
80105d6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105d6d:	83 c4 10             	add    $0x10,%esp
80105d70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d75:	c9                   	leave  
80105d76:	c3                   	ret    
80105d77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d7e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105d80:	83 ec 0c             	sub    $0xc,%esp
80105d83:	68 e0 11 13 80       	push   $0x801311e0
80105d88:	e8 d3 ed ff ff       	call   80104b60 <release>
  return 0;
80105d8d:	83 c4 10             	add    $0x10,%esp
80105d90:	31 c0                	xor    %eax,%eax
}
80105d92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d95:	c9                   	leave  
80105d96:	c3                   	ret    
    return -1;
80105d97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d9c:	eb f4                	jmp    80105d92 <sys_sleep+0xa2>
80105d9e:	66 90                	xchg   %ax,%ax

80105da0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105da0:	f3 0f 1e fb          	endbr32 
80105da4:	55                   	push   %ebp
80105da5:	89 e5                	mov    %esp,%ebp
80105da7:	53                   	push   %ebx
80105da8:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105dab:	68 e0 11 13 80       	push   $0x801311e0
80105db0:	e8 eb ec ff ff       	call   80104aa0 <acquire>
  xticks = ticks;
80105db5:	8b 1d 20 1a 13 80    	mov    0x80131a20,%ebx
  release(&tickslock);
80105dbb:	c7 04 24 e0 11 13 80 	movl   $0x801311e0,(%esp)
80105dc2:	e8 99 ed ff ff       	call   80104b60 <release>
  return xticks;
}
80105dc7:	89 d8                	mov    %ebx,%eax
80105dc9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105dcc:	c9                   	leave  
80105dcd:	c3                   	ret    
80105dce:	66 90                	xchg   %ax,%ax

80105dd0 <sys_get_number_of_free_pages>:

int sys_get_number_of_free_pages(void){
80105dd0:	f3 0f 1e fb          	endbr32 
  return sys_get_number_of_free_pages_impl();
80105dd4:	e9 27 e2 ff ff       	jmp    80104000 <sys_get_number_of_free_pages_impl>

80105dd9 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105dd9:	1e                   	push   %ds
  pushl %es
80105dda:	06                   	push   %es
  pushl %fs
80105ddb:	0f a0                	push   %fs
  pushl %gs
80105ddd:	0f a8                	push   %gs
  pushal
80105ddf:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105de0:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105de4:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105de6:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105de8:	54                   	push   %esp
  call trap
80105de9:	e8 c2 00 00 00       	call   80105eb0 <trap>
  addl $4, %esp
80105dee:	83 c4 04             	add    $0x4,%esp

80105df1 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105df1:	61                   	popa   
  popl %gs
80105df2:	0f a9                	pop    %gs
  popl %fs
80105df4:	0f a1                	pop    %fs
  popl %es
80105df6:	07                   	pop    %es
  popl %ds
80105df7:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105df8:	83 c4 08             	add    $0x8,%esp
  iret
80105dfb:	cf                   	iret   
80105dfc:	66 90                	xchg   %ax,%ax
80105dfe:	66 90                	xchg   %ax,%ax

80105e00 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105e00:	f3 0f 1e fb          	endbr32 
80105e04:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105e05:	31 c0                	xor    %eax,%eax
{
80105e07:	89 e5                	mov    %esp,%ebp
80105e09:	83 ec 08             	sub    $0x8,%esp
80105e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105e10:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105e17:	c7 04 c5 22 12 13 80 	movl   $0x8e000008,-0x7fecedde(,%eax,8)
80105e1e:	08 00 00 8e 
80105e22:	66 89 14 c5 20 12 13 	mov    %dx,-0x7fecede0(,%eax,8)
80105e29:	80 
80105e2a:	c1 ea 10             	shr    $0x10,%edx
80105e2d:	66 89 14 c5 26 12 13 	mov    %dx,-0x7fecedda(,%eax,8)
80105e34:	80 
  for(i = 0; i < 256; i++)
80105e35:	83 c0 01             	add    $0x1,%eax
80105e38:	3d 00 01 00 00       	cmp    $0x100,%eax
80105e3d:	75 d1                	jne    80105e10 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105e3f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105e42:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105e47:	c7 05 22 14 13 80 08 	movl   $0xef000008,0x80131422
80105e4e:	00 00 ef 
  initlock(&tickslock, "time");
80105e51:	68 f9 81 10 80       	push   $0x801081f9
80105e56:	68 e0 11 13 80       	push   $0x801311e0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105e5b:	66 a3 20 14 13 80    	mov    %ax,0x80131420
80105e61:	c1 e8 10             	shr    $0x10,%eax
80105e64:	66 a3 26 14 13 80    	mov    %ax,0x80131426
  initlock(&tickslock, "time");
80105e6a:	e8 b1 ea ff ff       	call   80104920 <initlock>
}
80105e6f:	83 c4 10             	add    $0x10,%esp
80105e72:	c9                   	leave  
80105e73:	c3                   	ret    
80105e74:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e7f:	90                   	nop

80105e80 <idtinit>:

void
idtinit(void)
{
80105e80:	f3 0f 1e fb          	endbr32 
80105e84:	55                   	push   %ebp
  pd[0] = size-1;
80105e85:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105e8a:	89 e5                	mov    %esp,%ebp
80105e8c:	83 ec 10             	sub    $0x10,%esp
80105e8f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105e93:	b8 20 12 13 80       	mov    $0x80131220,%eax
80105e98:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105e9c:	c1 e8 10             	shr    $0x10,%eax
80105e9f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105ea3:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105ea6:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105ea9:	c9                   	leave  
80105eaa:	c3                   	ret    
80105eab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105eaf:	90                   	nop

80105eb0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105eb0:	f3 0f 1e fb          	endbr32 
80105eb4:	55                   	push   %ebp
80105eb5:	89 e5                	mov    %esp,%ebp
80105eb7:	57                   	push   %edi
80105eb8:	56                   	push   %esi
80105eb9:	53                   	push   %ebx
80105eba:	83 ec 2c             	sub    $0x2c,%esp
80105ebd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105ec0:	8b 43 30             	mov    0x30(%ebx),%eax
80105ec3:	83 f8 40             	cmp    $0x40,%eax
80105ec6:	0f 84 94 02 00 00    	je     80106160 <trap+0x2b0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105ecc:	83 e8 0e             	sub    $0xe,%eax
80105ecf:	83 f8 31             	cmp    $0x31,%eax
80105ed2:	0f 87 96 00 00 00    	ja     80105f6e <trap+0xbe>
80105ed8:	3e ff 24 85 20 83 10 	notrack jmp *-0x7fef7ce0(,%eax,4)
80105edf:	80 
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105ee0:	0f 20 d6             	mov    %cr2,%esi
    break;

  case T_PGFLT:
  ;//verify none includes cow
    uint faulting_addr = rcr2();
    struct proc* p = myproc();
80105ee3:	e8 68 df ff ff       	call   80103e50 <myproc>
    pte_t* pte_ptr = public_walkpgdir(p->pgdir, (void *)faulting_addr, 0);
80105ee8:	83 ec 04             	sub    $0x4,%esp
80105eeb:	6a 00                	push   $0x0
    struct proc* p = myproc();
80105eed:	89 c7                	mov    %eax,%edi
    pte_t* pte_ptr = public_walkpgdir(p->pgdir, (void *)faulting_addr, 0);
80105eef:	56                   	push   %esi
80105ef0:	ff 70 04             	pushl  0x4(%eax)
80105ef3:	e8 38 13 00 00       	call   80107230 <public_walkpgdir>
      }
      p->num_of_pagefaults_occurs++;
      return;
    }
    #endif
    if (!(pte_ptr == 0) && *pte_ptr & PTE_COW){
80105ef8:	83 c4 10             	add    $0x10,%esp
    pte_t* pte_ptr = public_walkpgdir(p->pgdir, (void *)faulting_addr, 0);
80105efb:	89 c6                	mov    %eax,%esi
    if (!(pte_ptr == 0) && *pte_ptr & PTE_COW){
80105efd:	85 c0                	test   %eax,%eax
80105eff:	0f 84 e3 02 00 00    	je     801061e8 <trap+0x338>
80105f05:	8b 00                	mov    (%eax),%eax
80105f07:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105f0a:	f6 c4 08             	test   $0x8,%ah
80105f0d:	0f 85 dd 01 00 00    	jne    801060f0 <trap+0x240>
      }
      else{
        panic("ref count to page is 0 but it was reffed");
      }
    }
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f13:	8b 4f 10             	mov    0x10(%edi),%ecx
80105f16:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80105f19:	0f 20 d2             	mov    %cr2,%edx
80105f1c:	8b 43 38             	mov    0x38(%ebx),%eax
80105f1f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105f22:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105f25:	e8 06 df ff ff       	call   80103e30 <cpuid>
80105f2a:	8b 53 34             	mov    0x34(%ebx),%edx
80105f2d:	8b 73 30             	mov    0x30(%ebx),%esi
80105f30:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105f33:	89 55 d8             	mov    %edx,-0x28(%ebp)
            "eip 0x%x addr 0x%x pte %x pid %d --kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105f36:	e8 15 df ff ff       	call   80103e50 <myproc>
80105f3b:	89 c7                	mov    %eax,%edi
80105f3d:	e8 0e df ff ff       	call   80103e50 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f42:	8b 4d d0             	mov    -0x30(%ebp),%ecx
80105f45:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80105f48:	83 ec 08             	sub    $0x8,%esp
80105f4b:	51                   	push   %ecx
80105f4c:	ff 75 e4             	pushl  -0x1c(%ebp)
80105f4f:	52                   	push   %edx
80105f50:	ff 75 e0             	pushl  -0x20(%ebp)
80105f53:	ff 75 dc             	pushl  -0x24(%ebp)
80105f56:	ff 75 d8             	pushl  -0x28(%ebp)
80105f59:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105f5a:	8d 77 6c             	lea    0x6c(%edi),%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f5d:	56                   	push   %esi
80105f5e:	ff 70 10             	pushl  0x10(%eax)
80105f61:	68 54 82 10 80       	push   $0x80108254
80105f66:	e8 45 a7 ff ff       	call   801006b0 <cprintf>
80105f6b:	83 c4 30             	add    $0x30,%esp
            tf->err, cpuid(), tf->eip, rcr2(), *pte_ptr, p->pid);
  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105f6e:	e8 dd de ff ff       	call   80103e50 <myproc>
80105f73:	8b 7b 38             	mov    0x38(%ebx),%edi
80105f76:	85 c0                	test   %eax,%eax
80105f78:	0f 84 93 02 00 00    	je     80106211 <trap+0x361>
80105f7e:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105f82:	0f 84 89 02 00 00    	je     80106211 <trap+0x361>
80105f88:	0f 20 d1             	mov    %cr2,%ecx
80105f8b:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f8e:	e8 9d de ff ff       	call   80103e30 <cpuid>
80105f93:	8b 73 30             	mov    0x30(%ebx),%esi
80105f96:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105f99:	8b 43 34             	mov    0x34(%ebx),%eax
80105f9c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105f9f:	e8 ac de ff ff       	call   80103e50 <myproc>
80105fa4:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105fa7:	e8 a4 de ff ff       	call   80103e50 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105fac:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105faf:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105fb2:	51                   	push   %ecx
80105fb3:	57                   	push   %edi
80105fb4:	52                   	push   %edx
80105fb5:	ff 75 e4             	pushl  -0x1c(%ebp)
80105fb8:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105fb9:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105fbc:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105fbf:	56                   	push   %esi
80105fc0:	ff 70 10             	pushl  0x10(%eax)
80105fc3:	68 dc 82 10 80       	push   $0x801082dc
80105fc8:	e8 e3 a6 ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105fcd:	83 c4 20             	add    $0x20,%esp
80105fd0:	e8 7b de ff ff       	call   80103e50 <myproc>
80105fd5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105fdc:	e8 6f de ff ff       	call   80103e50 <myproc>
80105fe1:	85 c0                	test   %eax,%eax
80105fe3:	74 1d                	je     80106002 <trap+0x152>
80105fe5:	e8 66 de ff ff       	call   80103e50 <myproc>
80105fea:	8b 50 24             	mov    0x24(%eax),%edx
80105fed:	85 d2                	test   %edx,%edx
80105fef:	74 11                	je     80106002 <trap+0x152>
80105ff1:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105ff5:	83 e0 03             	and    $0x3,%eax
80105ff8:	66 83 f8 03          	cmp    $0x3,%ax
80105ffc:	0f 84 8e 01 00 00    	je     80106190 <trap+0x2e0>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER){
80106002:	e8 49 de ff ff       	call   80103e50 <myproc>
80106007:	85 c0                	test   %eax,%eax
80106009:	74 0f                	je     8010601a <trap+0x16a>
8010600b:	e8 40 de ff ff       	call   80103e50 <myproc>
80106010:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106014:	0f 84 be 00 00 00    	je     801060d8 <trap+0x228>
      yield();
    }
    

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010601a:	e8 31 de ff ff       	call   80103e50 <myproc>
8010601f:	85 c0                	test   %eax,%eax
80106021:	74 1d                	je     80106040 <trap+0x190>
80106023:	e8 28 de ff ff       	call   80103e50 <myproc>
80106028:	8b 40 24             	mov    0x24(%eax),%eax
8010602b:	85 c0                	test   %eax,%eax
8010602d:	74 11                	je     80106040 <trap+0x190>
8010602f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106033:	83 e0 03             	and    $0x3,%eax
80106036:	66 83 f8 03          	cmp    $0x3,%ax
8010603a:	0f 84 12 01 00 00    	je     80106152 <trap+0x2a2>
    exit();
}
80106040:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106043:	5b                   	pop    %ebx
80106044:	5e                   	pop    %esi
80106045:	5f                   	pop    %edi
80106046:	5d                   	pop    %ebp
80106047:	c3                   	ret    
    if(cpuid() == 0){
80106048:	e8 e3 dd ff ff       	call   80103e30 <cpuid>
8010604d:	85 c0                	test   %eax,%eax
8010604f:	0f 84 5b 01 00 00    	je     801061b0 <trap+0x300>
    lapiceoi();
80106055:	e8 26 cd ff ff       	call   80102d80 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010605a:	e8 f1 dd ff ff       	call   80103e50 <myproc>
8010605f:	85 c0                	test   %eax,%eax
80106061:	75 82                	jne    80105fe5 <trap+0x135>
80106063:	eb 9d                	jmp    80106002 <trap+0x152>
    kbdintr();
80106065:	e8 d6 cb ff ff       	call   80102c40 <kbdintr>
    lapiceoi();
8010606a:	e8 11 cd ff ff       	call   80102d80 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010606f:	e8 dc dd ff ff       	call   80103e50 <myproc>
80106074:	85 c0                	test   %eax,%eax
80106076:	0f 85 69 ff ff ff    	jne    80105fe5 <trap+0x135>
8010607c:	eb 84                	jmp    80106002 <trap+0x152>
    uartintr();
8010607e:	e8 3d 03 00 00       	call   801063c0 <uartintr>
    lapiceoi();
80106083:	e8 f8 cc ff ff       	call   80102d80 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106088:	e8 c3 dd ff ff       	call   80103e50 <myproc>
8010608d:	85 c0                	test   %eax,%eax
8010608f:	0f 85 50 ff ff ff    	jne    80105fe5 <trap+0x135>
80106095:	e9 68 ff ff ff       	jmp    80106002 <trap+0x152>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010609a:	8b 7b 38             	mov    0x38(%ebx),%edi
8010609d:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801060a1:	e8 8a dd ff ff       	call   80103e30 <cpuid>
801060a6:	57                   	push   %edi
801060a7:	56                   	push   %esi
801060a8:	50                   	push   %eax
801060a9:	68 04 82 10 80       	push   $0x80108204
801060ae:	e8 fd a5 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
801060b3:	e8 c8 cc ff ff       	call   80102d80 <lapiceoi>
    break;
801060b8:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801060bb:	e8 90 dd ff ff       	call   80103e50 <myproc>
801060c0:	85 c0                	test   %eax,%eax
801060c2:	0f 85 1d ff ff ff    	jne    80105fe5 <trap+0x135>
801060c8:	e9 35 ff ff ff       	jmp    80106002 <trap+0x152>
    ideintr();
801060cd:	e8 3e c5 ff ff       	call   80102610 <ideintr>
801060d2:	eb 81                	jmp    80106055 <trap+0x1a5>
801060d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER){
801060d8:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801060dc:	0f 85 38 ff ff ff    	jne    8010601a <trap+0x16a>
      yield();
801060e2:	e8 09 e3 ff ff       	call   801043f0 <yield>
801060e7:	e9 2e ff ff ff       	jmp    8010601a <trap+0x16a>
801060ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      acquire(cow_lock);
801060f0:	83 ec 0c             	sub    $0xc,%esp
801060f3:	ff 35 40 ef 11 80    	pushl  0x8011ef40
801060f9:	e8 a2 e9 ff ff       	call   80104aa0 <acquire>
      char* ref_count = &(pg_ref_counts[PGROUNDDOWN(PTE_ADDR(*pte_ptr)) / PGSIZE]);
801060fe:	8b 1e                	mov    (%esi),%ebx
      if (*ref_count == 1){
80106100:	83 c4 10             	add    $0x10,%esp
      char* ref_count = &(pg_ref_counts[PGROUNDDOWN(PTE_ADDR(*pte_ptr)) / PGSIZE]);
80106103:	89 d9                	mov    %ebx,%ecx
80106105:	c1 e9 0c             	shr    $0xc,%ecx
      if (*ref_count == 1){
80106108:	0f b6 81 40 0f 11 80 	movzbl -0x7feef0c0(%ecx),%eax
8010610f:	3c 01                	cmp    $0x1,%al
80106111:	0f 84 de 00 00 00    	je     801061f5 <trap+0x345>
      else if (*ref_count > 1){
80106117:	0f 8e 1c 01 00 00    	jle    80106239 <trap+0x389>
        int result = copy_page(p->pgdir, pte_ptr);
8010611d:	83 ec 08             	sub    $0x8,%esp
        (*ref_count)--;
80106120:	83 e8 01             	sub    $0x1,%eax
        int result = copy_page(p->pgdir, pte_ptr);
80106123:	56                   	push   %esi
        (*ref_count)--;
80106124:	88 81 40 0f 11 80    	mov    %al,-0x7feef0c0(%ecx)
        int result = copy_page(p->pgdir, pte_ptr);
8010612a:	ff 77 04             	pushl  0x4(%edi)
8010612d:	e8 6e 18 00 00       	call   801079a0 <copy_page>
        release(cow_lock);
80106132:	59                   	pop    %ecx
80106133:	ff 35 40 ef 11 80    	pushl  0x8011ef40
        int result = copy_page(p->pgdir, pte_ptr);
80106139:	89 c3                	mov    %eax,%ebx
        release(cow_lock);
8010613b:	e8 20 ea ff ff       	call   80104b60 <release>
        if (result < 0){
80106140:	83 c4 10             	add    $0x10,%esp
80106143:	85 db                	test   %ebx,%ebx
80106145:	0f 89 f5 fe ff ff    	jns    80106040 <trap+0x190>
          p->killed = 1;
8010614b:	c7 47 24 01 00 00 00 	movl   $0x1,0x24(%edi)
}
80106152:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106155:	5b                   	pop    %ebx
80106156:	5e                   	pop    %esi
80106157:	5f                   	pop    %edi
80106158:	5d                   	pop    %ebp
          exit();
80106159:	e9 52 e1 ff ff       	jmp    801042b0 <exit>
8010615e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed)
80106160:	e8 eb dc ff ff       	call   80103e50 <myproc>
80106165:	8b 70 24             	mov    0x24(%eax),%esi
80106168:	85 f6                	test   %esi,%esi
8010616a:	75 34                	jne    801061a0 <trap+0x2f0>
    myproc()->tf = tf;
8010616c:	e8 df dc ff ff       	call   80103e50 <myproc>
80106171:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106174:	e8 07 ee ff ff       	call   80104f80 <syscall>
    if(myproc()->killed)
80106179:	e8 d2 dc ff ff       	call   80103e50 <myproc>
8010617e:	8b 58 24             	mov    0x24(%eax),%ebx
80106181:	85 db                	test   %ebx,%ebx
80106183:	0f 84 b7 fe ff ff    	je     80106040 <trap+0x190>
80106189:	eb c7                	jmp    80106152 <trap+0x2a2>
8010618b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010618f:	90                   	nop
    exit();
80106190:	e8 1b e1 ff ff       	call   801042b0 <exit>
80106195:	e9 68 fe ff ff       	jmp    80106002 <trap+0x152>
8010619a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
801061a0:	e8 0b e1 ff ff       	call   801042b0 <exit>
801061a5:	eb c5                	jmp    8010616c <trap+0x2bc>
801061a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061ae:	66 90                	xchg   %ax,%ax
      acquire(&tickslock);
801061b0:	83 ec 0c             	sub    $0xc,%esp
801061b3:	68 e0 11 13 80       	push   $0x801311e0
801061b8:	e8 e3 e8 ff ff       	call   80104aa0 <acquire>
      wakeup(&ticks);
801061bd:	c7 04 24 20 1a 13 80 	movl   $0x80131a20,(%esp)
      ticks++;
801061c4:	83 05 20 1a 13 80 01 	addl   $0x1,0x80131a20
      wakeup(&ticks);
801061cb:	e8 30 e4 ff ff       	call   80104600 <wakeup>
      release(&tickslock);
801061d0:	c7 04 24 e0 11 13 80 	movl   $0x801311e0,(%esp)
801061d7:	e8 84 e9 ff ff       	call   80104b60 <release>
801061dc:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
801061df:	e9 71 fe ff ff       	jmp    80106055 <trap+0x1a5>
801061e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801061e8:	a1 00 00 00 00       	mov    0x0,%eax
801061ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801061f0:	e9 1e fd ff ff       	jmp    80105f13 <trap+0x63>
        *pte_ptr &= (~PTE_COW);
801061f5:	80 e7 f7             	and    $0xf7,%bh
801061f8:	83 cb 02             	or     $0x2,%ebx
801061fb:	89 1e                	mov    %ebx,(%esi)
        release(cow_lock);
801061fd:	a1 40 ef 11 80       	mov    0x8011ef40,%eax
80106202:	89 45 08             	mov    %eax,0x8(%ebp)
}
80106205:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106208:	5b                   	pop    %ebx
80106209:	5e                   	pop    %esi
8010620a:	5f                   	pop    %edi
8010620b:	5d                   	pop    %ebp
        release(cow_lock);
8010620c:	e9 4f e9 ff ff       	jmp    80104b60 <release>
80106211:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106214:	e8 17 dc ff ff       	call   80103e30 <cpuid>
80106219:	83 ec 0c             	sub    $0xc,%esp
8010621c:	56                   	push   %esi
8010621d:	57                   	push   %edi
8010621e:	50                   	push   %eax
8010621f:	ff 73 30             	pushl  0x30(%ebx)
80106222:	68 a8 82 10 80       	push   $0x801082a8
80106227:	e8 84 a4 ff ff       	call   801006b0 <cprintf>
      panic("trap");
8010622c:	83 c4 14             	add    $0x14,%esp
8010622f:	68 fe 81 10 80       	push   $0x801081fe
80106234:	e8 57 a1 ff ff       	call   80100390 <panic>
        panic("ref count to page is 0 but it was reffed");
80106239:	83 ec 0c             	sub    $0xc,%esp
8010623c:	68 28 82 10 80       	push   $0x80108228
80106241:	e8 4a a1 ff ff       	call   80100390 <panic>
80106246:	66 90                	xchg   %ax,%ax
80106248:	66 90                	xchg   %ax,%ax
8010624a:	66 90                	xchg   %ax,%ax
8010624c:	66 90                	xchg   %ax,%ax
8010624e:	66 90                	xchg   %ax,%ax

80106250 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106250:	f3 0f 1e fb          	endbr32 
  if(!uart)
80106254:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
80106259:	85 c0                	test   %eax,%eax
8010625b:	74 1b                	je     80106278 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010625d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106262:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106263:	a8 01                	test   $0x1,%al
80106265:	74 11                	je     80106278 <uartgetc+0x28>
80106267:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010626c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010626d:	0f b6 c0             	movzbl %al,%eax
80106270:	c3                   	ret    
80106271:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106278:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010627d:	c3                   	ret    
8010627e:	66 90                	xchg   %ax,%ax

80106280 <uartputc.part.0>:
uartputc(int c)
80106280:	55                   	push   %ebp
80106281:	89 e5                	mov    %esp,%ebp
80106283:	57                   	push   %edi
80106284:	89 c7                	mov    %eax,%edi
80106286:	56                   	push   %esi
80106287:	be fd 03 00 00       	mov    $0x3fd,%esi
8010628c:	53                   	push   %ebx
8010628d:	bb 80 00 00 00       	mov    $0x80,%ebx
80106292:	83 ec 0c             	sub    $0xc,%esp
80106295:	eb 1b                	jmp    801062b2 <uartputc.part.0+0x32>
80106297:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010629e:	66 90                	xchg   %ax,%ax
    microdelay(10);
801062a0:	83 ec 0c             	sub    $0xc,%esp
801062a3:	6a 0a                	push   $0xa
801062a5:	e8 f6 ca ff ff       	call   80102da0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801062aa:	83 c4 10             	add    $0x10,%esp
801062ad:	83 eb 01             	sub    $0x1,%ebx
801062b0:	74 07                	je     801062b9 <uartputc.part.0+0x39>
801062b2:	89 f2                	mov    %esi,%edx
801062b4:	ec                   	in     (%dx),%al
801062b5:	a8 20                	test   $0x20,%al
801062b7:	74 e7                	je     801062a0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801062b9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801062be:	89 f8                	mov    %edi,%eax
801062c0:	ee                   	out    %al,(%dx)
}
801062c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062c4:	5b                   	pop    %ebx
801062c5:	5e                   	pop    %esi
801062c6:	5f                   	pop    %edi
801062c7:	5d                   	pop    %ebp
801062c8:	c3                   	ret    
801062c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801062d0 <uartinit>:
{
801062d0:	f3 0f 1e fb          	endbr32 
801062d4:	55                   	push   %ebp
801062d5:	31 c9                	xor    %ecx,%ecx
801062d7:	89 c8                	mov    %ecx,%eax
801062d9:	89 e5                	mov    %esp,%ebp
801062db:	57                   	push   %edi
801062dc:	56                   	push   %esi
801062dd:	53                   	push   %ebx
801062de:	bb fa 03 00 00       	mov    $0x3fa,%ebx
801062e3:	89 da                	mov    %ebx,%edx
801062e5:	83 ec 0c             	sub    $0xc,%esp
801062e8:	ee                   	out    %al,(%dx)
801062e9:	bf fb 03 00 00       	mov    $0x3fb,%edi
801062ee:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801062f3:	89 fa                	mov    %edi,%edx
801062f5:	ee                   	out    %al,(%dx)
801062f6:	b8 0c 00 00 00       	mov    $0xc,%eax
801062fb:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106300:	ee                   	out    %al,(%dx)
80106301:	be f9 03 00 00       	mov    $0x3f9,%esi
80106306:	89 c8                	mov    %ecx,%eax
80106308:	89 f2                	mov    %esi,%edx
8010630a:	ee                   	out    %al,(%dx)
8010630b:	b8 03 00 00 00       	mov    $0x3,%eax
80106310:	89 fa                	mov    %edi,%edx
80106312:	ee                   	out    %al,(%dx)
80106313:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106318:	89 c8                	mov    %ecx,%eax
8010631a:	ee                   	out    %al,(%dx)
8010631b:	b8 01 00 00 00       	mov    $0x1,%eax
80106320:	89 f2                	mov    %esi,%edx
80106322:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106323:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106328:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106329:	3c ff                	cmp    $0xff,%al
8010632b:	74 52                	je     8010637f <uartinit+0xaf>
  uart = 1;
8010632d:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80106334:	00 00 00 
80106337:	89 da                	mov    %ebx,%edx
80106339:	ec                   	in     (%dx),%al
8010633a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010633f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106340:	83 ec 08             	sub    $0x8,%esp
80106343:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80106348:	bb e8 83 10 80       	mov    $0x801083e8,%ebx
  ioapicenable(IRQ_COM1, 0);
8010634d:	6a 00                	push   $0x0
8010634f:	6a 04                	push   $0x4
80106351:	e8 0a c5 ff ff       	call   80102860 <ioapicenable>
80106356:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106359:	b8 78 00 00 00       	mov    $0x78,%eax
8010635e:	eb 04                	jmp    80106364 <uartinit+0x94>
80106360:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80106364:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
8010636a:	85 d2                	test   %edx,%edx
8010636c:	74 08                	je     80106376 <uartinit+0xa6>
    uartputc(*p);
8010636e:	0f be c0             	movsbl %al,%eax
80106371:	e8 0a ff ff ff       	call   80106280 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80106376:	89 f0                	mov    %esi,%eax
80106378:	83 c3 01             	add    $0x1,%ebx
8010637b:	84 c0                	test   %al,%al
8010637d:	75 e1                	jne    80106360 <uartinit+0x90>
}
8010637f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106382:	5b                   	pop    %ebx
80106383:	5e                   	pop    %esi
80106384:	5f                   	pop    %edi
80106385:	5d                   	pop    %ebp
80106386:	c3                   	ret    
80106387:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010638e:	66 90                	xchg   %ax,%ax

80106390 <uartputc>:
{
80106390:	f3 0f 1e fb          	endbr32 
80106394:	55                   	push   %ebp
  if(!uart)
80106395:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
8010639b:	89 e5                	mov    %esp,%ebp
8010639d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801063a0:	85 d2                	test   %edx,%edx
801063a2:	74 0c                	je     801063b0 <uartputc+0x20>
}
801063a4:	5d                   	pop    %ebp
801063a5:	e9 d6 fe ff ff       	jmp    80106280 <uartputc.part.0>
801063aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801063b0:	5d                   	pop    %ebp
801063b1:	c3                   	ret    
801063b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801063c0 <uartintr>:

void
uartintr(void)
{
801063c0:	f3 0f 1e fb          	endbr32 
801063c4:	55                   	push   %ebp
801063c5:	89 e5                	mov    %esp,%ebp
801063c7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801063ca:	68 50 62 10 80       	push   $0x80106250
801063cf:	e8 8c a4 ff ff       	call   80100860 <consoleintr>
}
801063d4:	83 c4 10             	add    $0x10,%esp
801063d7:	c9                   	leave  
801063d8:	c3                   	ret    

801063d9 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801063d9:	6a 00                	push   $0x0
  pushl $0
801063db:	6a 00                	push   $0x0
  jmp alltraps
801063dd:	e9 f7 f9 ff ff       	jmp    80105dd9 <alltraps>

801063e2 <vector1>:
.globl vector1
vector1:
  pushl $0
801063e2:	6a 00                	push   $0x0
  pushl $1
801063e4:	6a 01                	push   $0x1
  jmp alltraps
801063e6:	e9 ee f9 ff ff       	jmp    80105dd9 <alltraps>

801063eb <vector2>:
.globl vector2
vector2:
  pushl $0
801063eb:	6a 00                	push   $0x0
  pushl $2
801063ed:	6a 02                	push   $0x2
  jmp alltraps
801063ef:	e9 e5 f9 ff ff       	jmp    80105dd9 <alltraps>

801063f4 <vector3>:
.globl vector3
vector3:
  pushl $0
801063f4:	6a 00                	push   $0x0
  pushl $3
801063f6:	6a 03                	push   $0x3
  jmp alltraps
801063f8:	e9 dc f9 ff ff       	jmp    80105dd9 <alltraps>

801063fd <vector4>:
.globl vector4
vector4:
  pushl $0
801063fd:	6a 00                	push   $0x0
  pushl $4
801063ff:	6a 04                	push   $0x4
  jmp alltraps
80106401:	e9 d3 f9 ff ff       	jmp    80105dd9 <alltraps>

80106406 <vector5>:
.globl vector5
vector5:
  pushl $0
80106406:	6a 00                	push   $0x0
  pushl $5
80106408:	6a 05                	push   $0x5
  jmp alltraps
8010640a:	e9 ca f9 ff ff       	jmp    80105dd9 <alltraps>

8010640f <vector6>:
.globl vector6
vector6:
  pushl $0
8010640f:	6a 00                	push   $0x0
  pushl $6
80106411:	6a 06                	push   $0x6
  jmp alltraps
80106413:	e9 c1 f9 ff ff       	jmp    80105dd9 <alltraps>

80106418 <vector7>:
.globl vector7
vector7:
  pushl $0
80106418:	6a 00                	push   $0x0
  pushl $7
8010641a:	6a 07                	push   $0x7
  jmp alltraps
8010641c:	e9 b8 f9 ff ff       	jmp    80105dd9 <alltraps>

80106421 <vector8>:
.globl vector8
vector8:
  pushl $8
80106421:	6a 08                	push   $0x8
  jmp alltraps
80106423:	e9 b1 f9 ff ff       	jmp    80105dd9 <alltraps>

80106428 <vector9>:
.globl vector9
vector9:
  pushl $0
80106428:	6a 00                	push   $0x0
  pushl $9
8010642a:	6a 09                	push   $0x9
  jmp alltraps
8010642c:	e9 a8 f9 ff ff       	jmp    80105dd9 <alltraps>

80106431 <vector10>:
.globl vector10
vector10:
  pushl $10
80106431:	6a 0a                	push   $0xa
  jmp alltraps
80106433:	e9 a1 f9 ff ff       	jmp    80105dd9 <alltraps>

80106438 <vector11>:
.globl vector11
vector11:
  pushl $11
80106438:	6a 0b                	push   $0xb
  jmp alltraps
8010643a:	e9 9a f9 ff ff       	jmp    80105dd9 <alltraps>

8010643f <vector12>:
.globl vector12
vector12:
  pushl $12
8010643f:	6a 0c                	push   $0xc
  jmp alltraps
80106441:	e9 93 f9 ff ff       	jmp    80105dd9 <alltraps>

80106446 <vector13>:
.globl vector13
vector13:
  pushl $13
80106446:	6a 0d                	push   $0xd
  jmp alltraps
80106448:	e9 8c f9 ff ff       	jmp    80105dd9 <alltraps>

8010644d <vector14>:
.globl vector14
vector14:
  pushl $14
8010644d:	6a 0e                	push   $0xe
  jmp alltraps
8010644f:	e9 85 f9 ff ff       	jmp    80105dd9 <alltraps>

80106454 <vector15>:
.globl vector15
vector15:
  pushl $0
80106454:	6a 00                	push   $0x0
  pushl $15
80106456:	6a 0f                	push   $0xf
  jmp alltraps
80106458:	e9 7c f9 ff ff       	jmp    80105dd9 <alltraps>

8010645d <vector16>:
.globl vector16
vector16:
  pushl $0
8010645d:	6a 00                	push   $0x0
  pushl $16
8010645f:	6a 10                	push   $0x10
  jmp alltraps
80106461:	e9 73 f9 ff ff       	jmp    80105dd9 <alltraps>

80106466 <vector17>:
.globl vector17
vector17:
  pushl $17
80106466:	6a 11                	push   $0x11
  jmp alltraps
80106468:	e9 6c f9 ff ff       	jmp    80105dd9 <alltraps>

8010646d <vector18>:
.globl vector18
vector18:
  pushl $0
8010646d:	6a 00                	push   $0x0
  pushl $18
8010646f:	6a 12                	push   $0x12
  jmp alltraps
80106471:	e9 63 f9 ff ff       	jmp    80105dd9 <alltraps>

80106476 <vector19>:
.globl vector19
vector19:
  pushl $0
80106476:	6a 00                	push   $0x0
  pushl $19
80106478:	6a 13                	push   $0x13
  jmp alltraps
8010647a:	e9 5a f9 ff ff       	jmp    80105dd9 <alltraps>

8010647f <vector20>:
.globl vector20
vector20:
  pushl $0
8010647f:	6a 00                	push   $0x0
  pushl $20
80106481:	6a 14                	push   $0x14
  jmp alltraps
80106483:	e9 51 f9 ff ff       	jmp    80105dd9 <alltraps>

80106488 <vector21>:
.globl vector21
vector21:
  pushl $0
80106488:	6a 00                	push   $0x0
  pushl $21
8010648a:	6a 15                	push   $0x15
  jmp alltraps
8010648c:	e9 48 f9 ff ff       	jmp    80105dd9 <alltraps>

80106491 <vector22>:
.globl vector22
vector22:
  pushl $0
80106491:	6a 00                	push   $0x0
  pushl $22
80106493:	6a 16                	push   $0x16
  jmp alltraps
80106495:	e9 3f f9 ff ff       	jmp    80105dd9 <alltraps>

8010649a <vector23>:
.globl vector23
vector23:
  pushl $0
8010649a:	6a 00                	push   $0x0
  pushl $23
8010649c:	6a 17                	push   $0x17
  jmp alltraps
8010649e:	e9 36 f9 ff ff       	jmp    80105dd9 <alltraps>

801064a3 <vector24>:
.globl vector24
vector24:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $24
801064a5:	6a 18                	push   $0x18
  jmp alltraps
801064a7:	e9 2d f9 ff ff       	jmp    80105dd9 <alltraps>

801064ac <vector25>:
.globl vector25
vector25:
  pushl $0
801064ac:	6a 00                	push   $0x0
  pushl $25
801064ae:	6a 19                	push   $0x19
  jmp alltraps
801064b0:	e9 24 f9 ff ff       	jmp    80105dd9 <alltraps>

801064b5 <vector26>:
.globl vector26
vector26:
  pushl $0
801064b5:	6a 00                	push   $0x0
  pushl $26
801064b7:	6a 1a                	push   $0x1a
  jmp alltraps
801064b9:	e9 1b f9 ff ff       	jmp    80105dd9 <alltraps>

801064be <vector27>:
.globl vector27
vector27:
  pushl $0
801064be:	6a 00                	push   $0x0
  pushl $27
801064c0:	6a 1b                	push   $0x1b
  jmp alltraps
801064c2:	e9 12 f9 ff ff       	jmp    80105dd9 <alltraps>

801064c7 <vector28>:
.globl vector28
vector28:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $28
801064c9:	6a 1c                	push   $0x1c
  jmp alltraps
801064cb:	e9 09 f9 ff ff       	jmp    80105dd9 <alltraps>

801064d0 <vector29>:
.globl vector29
vector29:
  pushl $0
801064d0:	6a 00                	push   $0x0
  pushl $29
801064d2:	6a 1d                	push   $0x1d
  jmp alltraps
801064d4:	e9 00 f9 ff ff       	jmp    80105dd9 <alltraps>

801064d9 <vector30>:
.globl vector30
vector30:
  pushl $0
801064d9:	6a 00                	push   $0x0
  pushl $30
801064db:	6a 1e                	push   $0x1e
  jmp alltraps
801064dd:	e9 f7 f8 ff ff       	jmp    80105dd9 <alltraps>

801064e2 <vector31>:
.globl vector31
vector31:
  pushl $0
801064e2:	6a 00                	push   $0x0
  pushl $31
801064e4:	6a 1f                	push   $0x1f
  jmp alltraps
801064e6:	e9 ee f8 ff ff       	jmp    80105dd9 <alltraps>

801064eb <vector32>:
.globl vector32
vector32:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $32
801064ed:	6a 20                	push   $0x20
  jmp alltraps
801064ef:	e9 e5 f8 ff ff       	jmp    80105dd9 <alltraps>

801064f4 <vector33>:
.globl vector33
vector33:
  pushl $0
801064f4:	6a 00                	push   $0x0
  pushl $33
801064f6:	6a 21                	push   $0x21
  jmp alltraps
801064f8:	e9 dc f8 ff ff       	jmp    80105dd9 <alltraps>

801064fd <vector34>:
.globl vector34
vector34:
  pushl $0
801064fd:	6a 00                	push   $0x0
  pushl $34
801064ff:	6a 22                	push   $0x22
  jmp alltraps
80106501:	e9 d3 f8 ff ff       	jmp    80105dd9 <alltraps>

80106506 <vector35>:
.globl vector35
vector35:
  pushl $0
80106506:	6a 00                	push   $0x0
  pushl $35
80106508:	6a 23                	push   $0x23
  jmp alltraps
8010650a:	e9 ca f8 ff ff       	jmp    80105dd9 <alltraps>

8010650f <vector36>:
.globl vector36
vector36:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $36
80106511:	6a 24                	push   $0x24
  jmp alltraps
80106513:	e9 c1 f8 ff ff       	jmp    80105dd9 <alltraps>

80106518 <vector37>:
.globl vector37
vector37:
  pushl $0
80106518:	6a 00                	push   $0x0
  pushl $37
8010651a:	6a 25                	push   $0x25
  jmp alltraps
8010651c:	e9 b8 f8 ff ff       	jmp    80105dd9 <alltraps>

80106521 <vector38>:
.globl vector38
vector38:
  pushl $0
80106521:	6a 00                	push   $0x0
  pushl $38
80106523:	6a 26                	push   $0x26
  jmp alltraps
80106525:	e9 af f8 ff ff       	jmp    80105dd9 <alltraps>

8010652a <vector39>:
.globl vector39
vector39:
  pushl $0
8010652a:	6a 00                	push   $0x0
  pushl $39
8010652c:	6a 27                	push   $0x27
  jmp alltraps
8010652e:	e9 a6 f8 ff ff       	jmp    80105dd9 <alltraps>

80106533 <vector40>:
.globl vector40
vector40:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $40
80106535:	6a 28                	push   $0x28
  jmp alltraps
80106537:	e9 9d f8 ff ff       	jmp    80105dd9 <alltraps>

8010653c <vector41>:
.globl vector41
vector41:
  pushl $0
8010653c:	6a 00                	push   $0x0
  pushl $41
8010653e:	6a 29                	push   $0x29
  jmp alltraps
80106540:	e9 94 f8 ff ff       	jmp    80105dd9 <alltraps>

80106545 <vector42>:
.globl vector42
vector42:
  pushl $0
80106545:	6a 00                	push   $0x0
  pushl $42
80106547:	6a 2a                	push   $0x2a
  jmp alltraps
80106549:	e9 8b f8 ff ff       	jmp    80105dd9 <alltraps>

8010654e <vector43>:
.globl vector43
vector43:
  pushl $0
8010654e:	6a 00                	push   $0x0
  pushl $43
80106550:	6a 2b                	push   $0x2b
  jmp alltraps
80106552:	e9 82 f8 ff ff       	jmp    80105dd9 <alltraps>

80106557 <vector44>:
.globl vector44
vector44:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $44
80106559:	6a 2c                	push   $0x2c
  jmp alltraps
8010655b:	e9 79 f8 ff ff       	jmp    80105dd9 <alltraps>

80106560 <vector45>:
.globl vector45
vector45:
  pushl $0
80106560:	6a 00                	push   $0x0
  pushl $45
80106562:	6a 2d                	push   $0x2d
  jmp alltraps
80106564:	e9 70 f8 ff ff       	jmp    80105dd9 <alltraps>

80106569 <vector46>:
.globl vector46
vector46:
  pushl $0
80106569:	6a 00                	push   $0x0
  pushl $46
8010656b:	6a 2e                	push   $0x2e
  jmp alltraps
8010656d:	e9 67 f8 ff ff       	jmp    80105dd9 <alltraps>

80106572 <vector47>:
.globl vector47
vector47:
  pushl $0
80106572:	6a 00                	push   $0x0
  pushl $47
80106574:	6a 2f                	push   $0x2f
  jmp alltraps
80106576:	e9 5e f8 ff ff       	jmp    80105dd9 <alltraps>

8010657b <vector48>:
.globl vector48
vector48:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $48
8010657d:	6a 30                	push   $0x30
  jmp alltraps
8010657f:	e9 55 f8 ff ff       	jmp    80105dd9 <alltraps>

80106584 <vector49>:
.globl vector49
vector49:
  pushl $0
80106584:	6a 00                	push   $0x0
  pushl $49
80106586:	6a 31                	push   $0x31
  jmp alltraps
80106588:	e9 4c f8 ff ff       	jmp    80105dd9 <alltraps>

8010658d <vector50>:
.globl vector50
vector50:
  pushl $0
8010658d:	6a 00                	push   $0x0
  pushl $50
8010658f:	6a 32                	push   $0x32
  jmp alltraps
80106591:	e9 43 f8 ff ff       	jmp    80105dd9 <alltraps>

80106596 <vector51>:
.globl vector51
vector51:
  pushl $0
80106596:	6a 00                	push   $0x0
  pushl $51
80106598:	6a 33                	push   $0x33
  jmp alltraps
8010659a:	e9 3a f8 ff ff       	jmp    80105dd9 <alltraps>

8010659f <vector52>:
.globl vector52
vector52:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $52
801065a1:	6a 34                	push   $0x34
  jmp alltraps
801065a3:	e9 31 f8 ff ff       	jmp    80105dd9 <alltraps>

801065a8 <vector53>:
.globl vector53
vector53:
  pushl $0
801065a8:	6a 00                	push   $0x0
  pushl $53
801065aa:	6a 35                	push   $0x35
  jmp alltraps
801065ac:	e9 28 f8 ff ff       	jmp    80105dd9 <alltraps>

801065b1 <vector54>:
.globl vector54
vector54:
  pushl $0
801065b1:	6a 00                	push   $0x0
  pushl $54
801065b3:	6a 36                	push   $0x36
  jmp alltraps
801065b5:	e9 1f f8 ff ff       	jmp    80105dd9 <alltraps>

801065ba <vector55>:
.globl vector55
vector55:
  pushl $0
801065ba:	6a 00                	push   $0x0
  pushl $55
801065bc:	6a 37                	push   $0x37
  jmp alltraps
801065be:	e9 16 f8 ff ff       	jmp    80105dd9 <alltraps>

801065c3 <vector56>:
.globl vector56
vector56:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $56
801065c5:	6a 38                	push   $0x38
  jmp alltraps
801065c7:	e9 0d f8 ff ff       	jmp    80105dd9 <alltraps>

801065cc <vector57>:
.globl vector57
vector57:
  pushl $0
801065cc:	6a 00                	push   $0x0
  pushl $57
801065ce:	6a 39                	push   $0x39
  jmp alltraps
801065d0:	e9 04 f8 ff ff       	jmp    80105dd9 <alltraps>

801065d5 <vector58>:
.globl vector58
vector58:
  pushl $0
801065d5:	6a 00                	push   $0x0
  pushl $58
801065d7:	6a 3a                	push   $0x3a
  jmp alltraps
801065d9:	e9 fb f7 ff ff       	jmp    80105dd9 <alltraps>

801065de <vector59>:
.globl vector59
vector59:
  pushl $0
801065de:	6a 00                	push   $0x0
  pushl $59
801065e0:	6a 3b                	push   $0x3b
  jmp alltraps
801065e2:	e9 f2 f7 ff ff       	jmp    80105dd9 <alltraps>

801065e7 <vector60>:
.globl vector60
vector60:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $60
801065e9:	6a 3c                	push   $0x3c
  jmp alltraps
801065eb:	e9 e9 f7 ff ff       	jmp    80105dd9 <alltraps>

801065f0 <vector61>:
.globl vector61
vector61:
  pushl $0
801065f0:	6a 00                	push   $0x0
  pushl $61
801065f2:	6a 3d                	push   $0x3d
  jmp alltraps
801065f4:	e9 e0 f7 ff ff       	jmp    80105dd9 <alltraps>

801065f9 <vector62>:
.globl vector62
vector62:
  pushl $0
801065f9:	6a 00                	push   $0x0
  pushl $62
801065fb:	6a 3e                	push   $0x3e
  jmp alltraps
801065fd:	e9 d7 f7 ff ff       	jmp    80105dd9 <alltraps>

80106602 <vector63>:
.globl vector63
vector63:
  pushl $0
80106602:	6a 00                	push   $0x0
  pushl $63
80106604:	6a 3f                	push   $0x3f
  jmp alltraps
80106606:	e9 ce f7 ff ff       	jmp    80105dd9 <alltraps>

8010660b <vector64>:
.globl vector64
vector64:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $64
8010660d:	6a 40                	push   $0x40
  jmp alltraps
8010660f:	e9 c5 f7 ff ff       	jmp    80105dd9 <alltraps>

80106614 <vector65>:
.globl vector65
vector65:
  pushl $0
80106614:	6a 00                	push   $0x0
  pushl $65
80106616:	6a 41                	push   $0x41
  jmp alltraps
80106618:	e9 bc f7 ff ff       	jmp    80105dd9 <alltraps>

8010661d <vector66>:
.globl vector66
vector66:
  pushl $0
8010661d:	6a 00                	push   $0x0
  pushl $66
8010661f:	6a 42                	push   $0x42
  jmp alltraps
80106621:	e9 b3 f7 ff ff       	jmp    80105dd9 <alltraps>

80106626 <vector67>:
.globl vector67
vector67:
  pushl $0
80106626:	6a 00                	push   $0x0
  pushl $67
80106628:	6a 43                	push   $0x43
  jmp alltraps
8010662a:	e9 aa f7 ff ff       	jmp    80105dd9 <alltraps>

8010662f <vector68>:
.globl vector68
vector68:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $68
80106631:	6a 44                	push   $0x44
  jmp alltraps
80106633:	e9 a1 f7 ff ff       	jmp    80105dd9 <alltraps>

80106638 <vector69>:
.globl vector69
vector69:
  pushl $0
80106638:	6a 00                	push   $0x0
  pushl $69
8010663a:	6a 45                	push   $0x45
  jmp alltraps
8010663c:	e9 98 f7 ff ff       	jmp    80105dd9 <alltraps>

80106641 <vector70>:
.globl vector70
vector70:
  pushl $0
80106641:	6a 00                	push   $0x0
  pushl $70
80106643:	6a 46                	push   $0x46
  jmp alltraps
80106645:	e9 8f f7 ff ff       	jmp    80105dd9 <alltraps>

8010664a <vector71>:
.globl vector71
vector71:
  pushl $0
8010664a:	6a 00                	push   $0x0
  pushl $71
8010664c:	6a 47                	push   $0x47
  jmp alltraps
8010664e:	e9 86 f7 ff ff       	jmp    80105dd9 <alltraps>

80106653 <vector72>:
.globl vector72
vector72:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $72
80106655:	6a 48                	push   $0x48
  jmp alltraps
80106657:	e9 7d f7 ff ff       	jmp    80105dd9 <alltraps>

8010665c <vector73>:
.globl vector73
vector73:
  pushl $0
8010665c:	6a 00                	push   $0x0
  pushl $73
8010665e:	6a 49                	push   $0x49
  jmp alltraps
80106660:	e9 74 f7 ff ff       	jmp    80105dd9 <alltraps>

80106665 <vector74>:
.globl vector74
vector74:
  pushl $0
80106665:	6a 00                	push   $0x0
  pushl $74
80106667:	6a 4a                	push   $0x4a
  jmp alltraps
80106669:	e9 6b f7 ff ff       	jmp    80105dd9 <alltraps>

8010666e <vector75>:
.globl vector75
vector75:
  pushl $0
8010666e:	6a 00                	push   $0x0
  pushl $75
80106670:	6a 4b                	push   $0x4b
  jmp alltraps
80106672:	e9 62 f7 ff ff       	jmp    80105dd9 <alltraps>

80106677 <vector76>:
.globl vector76
vector76:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $76
80106679:	6a 4c                	push   $0x4c
  jmp alltraps
8010667b:	e9 59 f7 ff ff       	jmp    80105dd9 <alltraps>

80106680 <vector77>:
.globl vector77
vector77:
  pushl $0
80106680:	6a 00                	push   $0x0
  pushl $77
80106682:	6a 4d                	push   $0x4d
  jmp alltraps
80106684:	e9 50 f7 ff ff       	jmp    80105dd9 <alltraps>

80106689 <vector78>:
.globl vector78
vector78:
  pushl $0
80106689:	6a 00                	push   $0x0
  pushl $78
8010668b:	6a 4e                	push   $0x4e
  jmp alltraps
8010668d:	e9 47 f7 ff ff       	jmp    80105dd9 <alltraps>

80106692 <vector79>:
.globl vector79
vector79:
  pushl $0
80106692:	6a 00                	push   $0x0
  pushl $79
80106694:	6a 4f                	push   $0x4f
  jmp alltraps
80106696:	e9 3e f7 ff ff       	jmp    80105dd9 <alltraps>

8010669b <vector80>:
.globl vector80
vector80:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $80
8010669d:	6a 50                	push   $0x50
  jmp alltraps
8010669f:	e9 35 f7 ff ff       	jmp    80105dd9 <alltraps>

801066a4 <vector81>:
.globl vector81
vector81:
  pushl $0
801066a4:	6a 00                	push   $0x0
  pushl $81
801066a6:	6a 51                	push   $0x51
  jmp alltraps
801066a8:	e9 2c f7 ff ff       	jmp    80105dd9 <alltraps>

801066ad <vector82>:
.globl vector82
vector82:
  pushl $0
801066ad:	6a 00                	push   $0x0
  pushl $82
801066af:	6a 52                	push   $0x52
  jmp alltraps
801066b1:	e9 23 f7 ff ff       	jmp    80105dd9 <alltraps>

801066b6 <vector83>:
.globl vector83
vector83:
  pushl $0
801066b6:	6a 00                	push   $0x0
  pushl $83
801066b8:	6a 53                	push   $0x53
  jmp alltraps
801066ba:	e9 1a f7 ff ff       	jmp    80105dd9 <alltraps>

801066bf <vector84>:
.globl vector84
vector84:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $84
801066c1:	6a 54                	push   $0x54
  jmp alltraps
801066c3:	e9 11 f7 ff ff       	jmp    80105dd9 <alltraps>

801066c8 <vector85>:
.globl vector85
vector85:
  pushl $0
801066c8:	6a 00                	push   $0x0
  pushl $85
801066ca:	6a 55                	push   $0x55
  jmp alltraps
801066cc:	e9 08 f7 ff ff       	jmp    80105dd9 <alltraps>

801066d1 <vector86>:
.globl vector86
vector86:
  pushl $0
801066d1:	6a 00                	push   $0x0
  pushl $86
801066d3:	6a 56                	push   $0x56
  jmp alltraps
801066d5:	e9 ff f6 ff ff       	jmp    80105dd9 <alltraps>

801066da <vector87>:
.globl vector87
vector87:
  pushl $0
801066da:	6a 00                	push   $0x0
  pushl $87
801066dc:	6a 57                	push   $0x57
  jmp alltraps
801066de:	e9 f6 f6 ff ff       	jmp    80105dd9 <alltraps>

801066e3 <vector88>:
.globl vector88
vector88:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $88
801066e5:	6a 58                	push   $0x58
  jmp alltraps
801066e7:	e9 ed f6 ff ff       	jmp    80105dd9 <alltraps>

801066ec <vector89>:
.globl vector89
vector89:
  pushl $0
801066ec:	6a 00                	push   $0x0
  pushl $89
801066ee:	6a 59                	push   $0x59
  jmp alltraps
801066f0:	e9 e4 f6 ff ff       	jmp    80105dd9 <alltraps>

801066f5 <vector90>:
.globl vector90
vector90:
  pushl $0
801066f5:	6a 00                	push   $0x0
  pushl $90
801066f7:	6a 5a                	push   $0x5a
  jmp alltraps
801066f9:	e9 db f6 ff ff       	jmp    80105dd9 <alltraps>

801066fe <vector91>:
.globl vector91
vector91:
  pushl $0
801066fe:	6a 00                	push   $0x0
  pushl $91
80106700:	6a 5b                	push   $0x5b
  jmp alltraps
80106702:	e9 d2 f6 ff ff       	jmp    80105dd9 <alltraps>

80106707 <vector92>:
.globl vector92
vector92:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $92
80106709:	6a 5c                	push   $0x5c
  jmp alltraps
8010670b:	e9 c9 f6 ff ff       	jmp    80105dd9 <alltraps>

80106710 <vector93>:
.globl vector93
vector93:
  pushl $0
80106710:	6a 00                	push   $0x0
  pushl $93
80106712:	6a 5d                	push   $0x5d
  jmp alltraps
80106714:	e9 c0 f6 ff ff       	jmp    80105dd9 <alltraps>

80106719 <vector94>:
.globl vector94
vector94:
  pushl $0
80106719:	6a 00                	push   $0x0
  pushl $94
8010671b:	6a 5e                	push   $0x5e
  jmp alltraps
8010671d:	e9 b7 f6 ff ff       	jmp    80105dd9 <alltraps>

80106722 <vector95>:
.globl vector95
vector95:
  pushl $0
80106722:	6a 00                	push   $0x0
  pushl $95
80106724:	6a 5f                	push   $0x5f
  jmp alltraps
80106726:	e9 ae f6 ff ff       	jmp    80105dd9 <alltraps>

8010672b <vector96>:
.globl vector96
vector96:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $96
8010672d:	6a 60                	push   $0x60
  jmp alltraps
8010672f:	e9 a5 f6 ff ff       	jmp    80105dd9 <alltraps>

80106734 <vector97>:
.globl vector97
vector97:
  pushl $0
80106734:	6a 00                	push   $0x0
  pushl $97
80106736:	6a 61                	push   $0x61
  jmp alltraps
80106738:	e9 9c f6 ff ff       	jmp    80105dd9 <alltraps>

8010673d <vector98>:
.globl vector98
vector98:
  pushl $0
8010673d:	6a 00                	push   $0x0
  pushl $98
8010673f:	6a 62                	push   $0x62
  jmp alltraps
80106741:	e9 93 f6 ff ff       	jmp    80105dd9 <alltraps>

80106746 <vector99>:
.globl vector99
vector99:
  pushl $0
80106746:	6a 00                	push   $0x0
  pushl $99
80106748:	6a 63                	push   $0x63
  jmp alltraps
8010674a:	e9 8a f6 ff ff       	jmp    80105dd9 <alltraps>

8010674f <vector100>:
.globl vector100
vector100:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $100
80106751:	6a 64                	push   $0x64
  jmp alltraps
80106753:	e9 81 f6 ff ff       	jmp    80105dd9 <alltraps>

80106758 <vector101>:
.globl vector101
vector101:
  pushl $0
80106758:	6a 00                	push   $0x0
  pushl $101
8010675a:	6a 65                	push   $0x65
  jmp alltraps
8010675c:	e9 78 f6 ff ff       	jmp    80105dd9 <alltraps>

80106761 <vector102>:
.globl vector102
vector102:
  pushl $0
80106761:	6a 00                	push   $0x0
  pushl $102
80106763:	6a 66                	push   $0x66
  jmp alltraps
80106765:	e9 6f f6 ff ff       	jmp    80105dd9 <alltraps>

8010676a <vector103>:
.globl vector103
vector103:
  pushl $0
8010676a:	6a 00                	push   $0x0
  pushl $103
8010676c:	6a 67                	push   $0x67
  jmp alltraps
8010676e:	e9 66 f6 ff ff       	jmp    80105dd9 <alltraps>

80106773 <vector104>:
.globl vector104
vector104:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $104
80106775:	6a 68                	push   $0x68
  jmp alltraps
80106777:	e9 5d f6 ff ff       	jmp    80105dd9 <alltraps>

8010677c <vector105>:
.globl vector105
vector105:
  pushl $0
8010677c:	6a 00                	push   $0x0
  pushl $105
8010677e:	6a 69                	push   $0x69
  jmp alltraps
80106780:	e9 54 f6 ff ff       	jmp    80105dd9 <alltraps>

80106785 <vector106>:
.globl vector106
vector106:
  pushl $0
80106785:	6a 00                	push   $0x0
  pushl $106
80106787:	6a 6a                	push   $0x6a
  jmp alltraps
80106789:	e9 4b f6 ff ff       	jmp    80105dd9 <alltraps>

8010678e <vector107>:
.globl vector107
vector107:
  pushl $0
8010678e:	6a 00                	push   $0x0
  pushl $107
80106790:	6a 6b                	push   $0x6b
  jmp alltraps
80106792:	e9 42 f6 ff ff       	jmp    80105dd9 <alltraps>

80106797 <vector108>:
.globl vector108
vector108:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $108
80106799:	6a 6c                	push   $0x6c
  jmp alltraps
8010679b:	e9 39 f6 ff ff       	jmp    80105dd9 <alltraps>

801067a0 <vector109>:
.globl vector109
vector109:
  pushl $0
801067a0:	6a 00                	push   $0x0
  pushl $109
801067a2:	6a 6d                	push   $0x6d
  jmp alltraps
801067a4:	e9 30 f6 ff ff       	jmp    80105dd9 <alltraps>

801067a9 <vector110>:
.globl vector110
vector110:
  pushl $0
801067a9:	6a 00                	push   $0x0
  pushl $110
801067ab:	6a 6e                	push   $0x6e
  jmp alltraps
801067ad:	e9 27 f6 ff ff       	jmp    80105dd9 <alltraps>

801067b2 <vector111>:
.globl vector111
vector111:
  pushl $0
801067b2:	6a 00                	push   $0x0
  pushl $111
801067b4:	6a 6f                	push   $0x6f
  jmp alltraps
801067b6:	e9 1e f6 ff ff       	jmp    80105dd9 <alltraps>

801067bb <vector112>:
.globl vector112
vector112:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $112
801067bd:	6a 70                	push   $0x70
  jmp alltraps
801067bf:	e9 15 f6 ff ff       	jmp    80105dd9 <alltraps>

801067c4 <vector113>:
.globl vector113
vector113:
  pushl $0
801067c4:	6a 00                	push   $0x0
  pushl $113
801067c6:	6a 71                	push   $0x71
  jmp alltraps
801067c8:	e9 0c f6 ff ff       	jmp    80105dd9 <alltraps>

801067cd <vector114>:
.globl vector114
vector114:
  pushl $0
801067cd:	6a 00                	push   $0x0
  pushl $114
801067cf:	6a 72                	push   $0x72
  jmp alltraps
801067d1:	e9 03 f6 ff ff       	jmp    80105dd9 <alltraps>

801067d6 <vector115>:
.globl vector115
vector115:
  pushl $0
801067d6:	6a 00                	push   $0x0
  pushl $115
801067d8:	6a 73                	push   $0x73
  jmp alltraps
801067da:	e9 fa f5 ff ff       	jmp    80105dd9 <alltraps>

801067df <vector116>:
.globl vector116
vector116:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $116
801067e1:	6a 74                	push   $0x74
  jmp alltraps
801067e3:	e9 f1 f5 ff ff       	jmp    80105dd9 <alltraps>

801067e8 <vector117>:
.globl vector117
vector117:
  pushl $0
801067e8:	6a 00                	push   $0x0
  pushl $117
801067ea:	6a 75                	push   $0x75
  jmp alltraps
801067ec:	e9 e8 f5 ff ff       	jmp    80105dd9 <alltraps>

801067f1 <vector118>:
.globl vector118
vector118:
  pushl $0
801067f1:	6a 00                	push   $0x0
  pushl $118
801067f3:	6a 76                	push   $0x76
  jmp alltraps
801067f5:	e9 df f5 ff ff       	jmp    80105dd9 <alltraps>

801067fa <vector119>:
.globl vector119
vector119:
  pushl $0
801067fa:	6a 00                	push   $0x0
  pushl $119
801067fc:	6a 77                	push   $0x77
  jmp alltraps
801067fe:	e9 d6 f5 ff ff       	jmp    80105dd9 <alltraps>

80106803 <vector120>:
.globl vector120
vector120:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $120
80106805:	6a 78                	push   $0x78
  jmp alltraps
80106807:	e9 cd f5 ff ff       	jmp    80105dd9 <alltraps>

8010680c <vector121>:
.globl vector121
vector121:
  pushl $0
8010680c:	6a 00                	push   $0x0
  pushl $121
8010680e:	6a 79                	push   $0x79
  jmp alltraps
80106810:	e9 c4 f5 ff ff       	jmp    80105dd9 <alltraps>

80106815 <vector122>:
.globl vector122
vector122:
  pushl $0
80106815:	6a 00                	push   $0x0
  pushl $122
80106817:	6a 7a                	push   $0x7a
  jmp alltraps
80106819:	e9 bb f5 ff ff       	jmp    80105dd9 <alltraps>

8010681e <vector123>:
.globl vector123
vector123:
  pushl $0
8010681e:	6a 00                	push   $0x0
  pushl $123
80106820:	6a 7b                	push   $0x7b
  jmp alltraps
80106822:	e9 b2 f5 ff ff       	jmp    80105dd9 <alltraps>

80106827 <vector124>:
.globl vector124
vector124:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $124
80106829:	6a 7c                	push   $0x7c
  jmp alltraps
8010682b:	e9 a9 f5 ff ff       	jmp    80105dd9 <alltraps>

80106830 <vector125>:
.globl vector125
vector125:
  pushl $0
80106830:	6a 00                	push   $0x0
  pushl $125
80106832:	6a 7d                	push   $0x7d
  jmp alltraps
80106834:	e9 a0 f5 ff ff       	jmp    80105dd9 <alltraps>

80106839 <vector126>:
.globl vector126
vector126:
  pushl $0
80106839:	6a 00                	push   $0x0
  pushl $126
8010683b:	6a 7e                	push   $0x7e
  jmp alltraps
8010683d:	e9 97 f5 ff ff       	jmp    80105dd9 <alltraps>

80106842 <vector127>:
.globl vector127
vector127:
  pushl $0
80106842:	6a 00                	push   $0x0
  pushl $127
80106844:	6a 7f                	push   $0x7f
  jmp alltraps
80106846:	e9 8e f5 ff ff       	jmp    80105dd9 <alltraps>

8010684b <vector128>:
.globl vector128
vector128:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $128
8010684d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106852:	e9 82 f5 ff ff       	jmp    80105dd9 <alltraps>

80106857 <vector129>:
.globl vector129
vector129:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $129
80106859:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010685e:	e9 76 f5 ff ff       	jmp    80105dd9 <alltraps>

80106863 <vector130>:
.globl vector130
vector130:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $130
80106865:	68 82 00 00 00       	push   $0x82
  jmp alltraps
8010686a:	e9 6a f5 ff ff       	jmp    80105dd9 <alltraps>

8010686f <vector131>:
.globl vector131
vector131:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $131
80106871:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106876:	e9 5e f5 ff ff       	jmp    80105dd9 <alltraps>

8010687b <vector132>:
.globl vector132
vector132:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $132
8010687d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106882:	e9 52 f5 ff ff       	jmp    80105dd9 <alltraps>

80106887 <vector133>:
.globl vector133
vector133:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $133
80106889:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010688e:	e9 46 f5 ff ff       	jmp    80105dd9 <alltraps>

80106893 <vector134>:
.globl vector134
vector134:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $134
80106895:	68 86 00 00 00       	push   $0x86
  jmp alltraps
8010689a:	e9 3a f5 ff ff       	jmp    80105dd9 <alltraps>

8010689f <vector135>:
.globl vector135
vector135:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $135
801068a1:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801068a6:	e9 2e f5 ff ff       	jmp    80105dd9 <alltraps>

801068ab <vector136>:
.globl vector136
vector136:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $136
801068ad:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801068b2:	e9 22 f5 ff ff       	jmp    80105dd9 <alltraps>

801068b7 <vector137>:
.globl vector137
vector137:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $137
801068b9:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801068be:	e9 16 f5 ff ff       	jmp    80105dd9 <alltraps>

801068c3 <vector138>:
.globl vector138
vector138:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $138
801068c5:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801068ca:	e9 0a f5 ff ff       	jmp    80105dd9 <alltraps>

801068cf <vector139>:
.globl vector139
vector139:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $139
801068d1:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801068d6:	e9 fe f4 ff ff       	jmp    80105dd9 <alltraps>

801068db <vector140>:
.globl vector140
vector140:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $140
801068dd:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801068e2:	e9 f2 f4 ff ff       	jmp    80105dd9 <alltraps>

801068e7 <vector141>:
.globl vector141
vector141:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $141
801068e9:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801068ee:	e9 e6 f4 ff ff       	jmp    80105dd9 <alltraps>

801068f3 <vector142>:
.globl vector142
vector142:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $142
801068f5:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801068fa:	e9 da f4 ff ff       	jmp    80105dd9 <alltraps>

801068ff <vector143>:
.globl vector143
vector143:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $143
80106901:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106906:	e9 ce f4 ff ff       	jmp    80105dd9 <alltraps>

8010690b <vector144>:
.globl vector144
vector144:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $144
8010690d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106912:	e9 c2 f4 ff ff       	jmp    80105dd9 <alltraps>

80106917 <vector145>:
.globl vector145
vector145:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $145
80106919:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010691e:	e9 b6 f4 ff ff       	jmp    80105dd9 <alltraps>

80106923 <vector146>:
.globl vector146
vector146:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $146
80106925:	68 92 00 00 00       	push   $0x92
  jmp alltraps
8010692a:	e9 aa f4 ff ff       	jmp    80105dd9 <alltraps>

8010692f <vector147>:
.globl vector147
vector147:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $147
80106931:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106936:	e9 9e f4 ff ff       	jmp    80105dd9 <alltraps>

8010693b <vector148>:
.globl vector148
vector148:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $148
8010693d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106942:	e9 92 f4 ff ff       	jmp    80105dd9 <alltraps>

80106947 <vector149>:
.globl vector149
vector149:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $149
80106949:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010694e:	e9 86 f4 ff ff       	jmp    80105dd9 <alltraps>

80106953 <vector150>:
.globl vector150
vector150:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $150
80106955:	68 96 00 00 00       	push   $0x96
  jmp alltraps
8010695a:	e9 7a f4 ff ff       	jmp    80105dd9 <alltraps>

8010695f <vector151>:
.globl vector151
vector151:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $151
80106961:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106966:	e9 6e f4 ff ff       	jmp    80105dd9 <alltraps>

8010696b <vector152>:
.globl vector152
vector152:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $152
8010696d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106972:	e9 62 f4 ff ff       	jmp    80105dd9 <alltraps>

80106977 <vector153>:
.globl vector153
vector153:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $153
80106979:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010697e:	e9 56 f4 ff ff       	jmp    80105dd9 <alltraps>

80106983 <vector154>:
.globl vector154
vector154:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $154
80106985:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
8010698a:	e9 4a f4 ff ff       	jmp    80105dd9 <alltraps>

8010698f <vector155>:
.globl vector155
vector155:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $155
80106991:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106996:	e9 3e f4 ff ff       	jmp    80105dd9 <alltraps>

8010699b <vector156>:
.globl vector156
vector156:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $156
8010699d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801069a2:	e9 32 f4 ff ff       	jmp    80105dd9 <alltraps>

801069a7 <vector157>:
.globl vector157
vector157:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $157
801069a9:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801069ae:	e9 26 f4 ff ff       	jmp    80105dd9 <alltraps>

801069b3 <vector158>:
.globl vector158
vector158:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $158
801069b5:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801069ba:	e9 1a f4 ff ff       	jmp    80105dd9 <alltraps>

801069bf <vector159>:
.globl vector159
vector159:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $159
801069c1:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801069c6:	e9 0e f4 ff ff       	jmp    80105dd9 <alltraps>

801069cb <vector160>:
.globl vector160
vector160:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $160
801069cd:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801069d2:	e9 02 f4 ff ff       	jmp    80105dd9 <alltraps>

801069d7 <vector161>:
.globl vector161
vector161:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $161
801069d9:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801069de:	e9 f6 f3 ff ff       	jmp    80105dd9 <alltraps>

801069e3 <vector162>:
.globl vector162
vector162:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $162
801069e5:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801069ea:	e9 ea f3 ff ff       	jmp    80105dd9 <alltraps>

801069ef <vector163>:
.globl vector163
vector163:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $163
801069f1:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801069f6:	e9 de f3 ff ff       	jmp    80105dd9 <alltraps>

801069fb <vector164>:
.globl vector164
vector164:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $164
801069fd:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106a02:	e9 d2 f3 ff ff       	jmp    80105dd9 <alltraps>

80106a07 <vector165>:
.globl vector165
vector165:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $165
80106a09:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106a0e:	e9 c6 f3 ff ff       	jmp    80105dd9 <alltraps>

80106a13 <vector166>:
.globl vector166
vector166:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $166
80106a15:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106a1a:	e9 ba f3 ff ff       	jmp    80105dd9 <alltraps>

80106a1f <vector167>:
.globl vector167
vector167:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $167
80106a21:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106a26:	e9 ae f3 ff ff       	jmp    80105dd9 <alltraps>

80106a2b <vector168>:
.globl vector168
vector168:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $168
80106a2d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106a32:	e9 a2 f3 ff ff       	jmp    80105dd9 <alltraps>

80106a37 <vector169>:
.globl vector169
vector169:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $169
80106a39:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106a3e:	e9 96 f3 ff ff       	jmp    80105dd9 <alltraps>

80106a43 <vector170>:
.globl vector170
vector170:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $170
80106a45:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106a4a:	e9 8a f3 ff ff       	jmp    80105dd9 <alltraps>

80106a4f <vector171>:
.globl vector171
vector171:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $171
80106a51:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106a56:	e9 7e f3 ff ff       	jmp    80105dd9 <alltraps>

80106a5b <vector172>:
.globl vector172
vector172:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $172
80106a5d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106a62:	e9 72 f3 ff ff       	jmp    80105dd9 <alltraps>

80106a67 <vector173>:
.globl vector173
vector173:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $173
80106a69:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106a6e:	e9 66 f3 ff ff       	jmp    80105dd9 <alltraps>

80106a73 <vector174>:
.globl vector174
vector174:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $174
80106a75:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106a7a:	e9 5a f3 ff ff       	jmp    80105dd9 <alltraps>

80106a7f <vector175>:
.globl vector175
vector175:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $175
80106a81:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106a86:	e9 4e f3 ff ff       	jmp    80105dd9 <alltraps>

80106a8b <vector176>:
.globl vector176
vector176:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $176
80106a8d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106a92:	e9 42 f3 ff ff       	jmp    80105dd9 <alltraps>

80106a97 <vector177>:
.globl vector177
vector177:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $177
80106a99:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106a9e:	e9 36 f3 ff ff       	jmp    80105dd9 <alltraps>

80106aa3 <vector178>:
.globl vector178
vector178:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $178
80106aa5:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106aaa:	e9 2a f3 ff ff       	jmp    80105dd9 <alltraps>

80106aaf <vector179>:
.globl vector179
vector179:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $179
80106ab1:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106ab6:	e9 1e f3 ff ff       	jmp    80105dd9 <alltraps>

80106abb <vector180>:
.globl vector180
vector180:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $180
80106abd:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106ac2:	e9 12 f3 ff ff       	jmp    80105dd9 <alltraps>

80106ac7 <vector181>:
.globl vector181
vector181:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $181
80106ac9:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106ace:	e9 06 f3 ff ff       	jmp    80105dd9 <alltraps>

80106ad3 <vector182>:
.globl vector182
vector182:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $182
80106ad5:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106ada:	e9 fa f2 ff ff       	jmp    80105dd9 <alltraps>

80106adf <vector183>:
.globl vector183
vector183:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $183
80106ae1:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106ae6:	e9 ee f2 ff ff       	jmp    80105dd9 <alltraps>

80106aeb <vector184>:
.globl vector184
vector184:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $184
80106aed:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106af2:	e9 e2 f2 ff ff       	jmp    80105dd9 <alltraps>

80106af7 <vector185>:
.globl vector185
vector185:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $185
80106af9:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106afe:	e9 d6 f2 ff ff       	jmp    80105dd9 <alltraps>

80106b03 <vector186>:
.globl vector186
vector186:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $186
80106b05:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106b0a:	e9 ca f2 ff ff       	jmp    80105dd9 <alltraps>

80106b0f <vector187>:
.globl vector187
vector187:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $187
80106b11:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106b16:	e9 be f2 ff ff       	jmp    80105dd9 <alltraps>

80106b1b <vector188>:
.globl vector188
vector188:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $188
80106b1d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106b22:	e9 b2 f2 ff ff       	jmp    80105dd9 <alltraps>

80106b27 <vector189>:
.globl vector189
vector189:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $189
80106b29:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106b2e:	e9 a6 f2 ff ff       	jmp    80105dd9 <alltraps>

80106b33 <vector190>:
.globl vector190
vector190:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $190
80106b35:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106b3a:	e9 9a f2 ff ff       	jmp    80105dd9 <alltraps>

80106b3f <vector191>:
.globl vector191
vector191:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $191
80106b41:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106b46:	e9 8e f2 ff ff       	jmp    80105dd9 <alltraps>

80106b4b <vector192>:
.globl vector192
vector192:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $192
80106b4d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106b52:	e9 82 f2 ff ff       	jmp    80105dd9 <alltraps>

80106b57 <vector193>:
.globl vector193
vector193:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $193
80106b59:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106b5e:	e9 76 f2 ff ff       	jmp    80105dd9 <alltraps>

80106b63 <vector194>:
.globl vector194
vector194:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $194
80106b65:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106b6a:	e9 6a f2 ff ff       	jmp    80105dd9 <alltraps>

80106b6f <vector195>:
.globl vector195
vector195:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $195
80106b71:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106b76:	e9 5e f2 ff ff       	jmp    80105dd9 <alltraps>

80106b7b <vector196>:
.globl vector196
vector196:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $196
80106b7d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106b82:	e9 52 f2 ff ff       	jmp    80105dd9 <alltraps>

80106b87 <vector197>:
.globl vector197
vector197:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $197
80106b89:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106b8e:	e9 46 f2 ff ff       	jmp    80105dd9 <alltraps>

80106b93 <vector198>:
.globl vector198
vector198:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $198
80106b95:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106b9a:	e9 3a f2 ff ff       	jmp    80105dd9 <alltraps>

80106b9f <vector199>:
.globl vector199
vector199:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $199
80106ba1:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106ba6:	e9 2e f2 ff ff       	jmp    80105dd9 <alltraps>

80106bab <vector200>:
.globl vector200
vector200:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $200
80106bad:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106bb2:	e9 22 f2 ff ff       	jmp    80105dd9 <alltraps>

80106bb7 <vector201>:
.globl vector201
vector201:
  pushl $0
80106bb7:	6a 00                	push   $0x0
  pushl $201
80106bb9:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106bbe:	e9 16 f2 ff ff       	jmp    80105dd9 <alltraps>

80106bc3 <vector202>:
.globl vector202
vector202:
  pushl $0
80106bc3:	6a 00                	push   $0x0
  pushl $202
80106bc5:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106bca:	e9 0a f2 ff ff       	jmp    80105dd9 <alltraps>

80106bcf <vector203>:
.globl vector203
vector203:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $203
80106bd1:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106bd6:	e9 fe f1 ff ff       	jmp    80105dd9 <alltraps>

80106bdb <vector204>:
.globl vector204
vector204:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $204
80106bdd:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106be2:	e9 f2 f1 ff ff       	jmp    80105dd9 <alltraps>

80106be7 <vector205>:
.globl vector205
vector205:
  pushl $0
80106be7:	6a 00                	push   $0x0
  pushl $205
80106be9:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106bee:	e9 e6 f1 ff ff       	jmp    80105dd9 <alltraps>

80106bf3 <vector206>:
.globl vector206
vector206:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $206
80106bf5:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106bfa:	e9 da f1 ff ff       	jmp    80105dd9 <alltraps>

80106bff <vector207>:
.globl vector207
vector207:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $207
80106c01:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106c06:	e9 ce f1 ff ff       	jmp    80105dd9 <alltraps>

80106c0b <vector208>:
.globl vector208
vector208:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $208
80106c0d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106c12:	e9 c2 f1 ff ff       	jmp    80105dd9 <alltraps>

80106c17 <vector209>:
.globl vector209
vector209:
  pushl $0
80106c17:	6a 00                	push   $0x0
  pushl $209
80106c19:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106c1e:	e9 b6 f1 ff ff       	jmp    80105dd9 <alltraps>

80106c23 <vector210>:
.globl vector210
vector210:
  pushl $0
80106c23:	6a 00                	push   $0x0
  pushl $210
80106c25:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106c2a:	e9 aa f1 ff ff       	jmp    80105dd9 <alltraps>

80106c2f <vector211>:
.globl vector211
vector211:
  pushl $0
80106c2f:	6a 00                	push   $0x0
  pushl $211
80106c31:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106c36:	e9 9e f1 ff ff       	jmp    80105dd9 <alltraps>

80106c3b <vector212>:
.globl vector212
vector212:
  pushl $0
80106c3b:	6a 00                	push   $0x0
  pushl $212
80106c3d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106c42:	e9 92 f1 ff ff       	jmp    80105dd9 <alltraps>

80106c47 <vector213>:
.globl vector213
vector213:
  pushl $0
80106c47:	6a 00                	push   $0x0
  pushl $213
80106c49:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106c4e:	e9 86 f1 ff ff       	jmp    80105dd9 <alltraps>

80106c53 <vector214>:
.globl vector214
vector214:
  pushl $0
80106c53:	6a 00                	push   $0x0
  pushl $214
80106c55:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106c5a:	e9 7a f1 ff ff       	jmp    80105dd9 <alltraps>

80106c5f <vector215>:
.globl vector215
vector215:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $215
80106c61:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106c66:	e9 6e f1 ff ff       	jmp    80105dd9 <alltraps>

80106c6b <vector216>:
.globl vector216
vector216:
  pushl $0
80106c6b:	6a 00                	push   $0x0
  pushl $216
80106c6d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106c72:	e9 62 f1 ff ff       	jmp    80105dd9 <alltraps>

80106c77 <vector217>:
.globl vector217
vector217:
  pushl $0
80106c77:	6a 00                	push   $0x0
  pushl $217
80106c79:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106c7e:	e9 56 f1 ff ff       	jmp    80105dd9 <alltraps>

80106c83 <vector218>:
.globl vector218
vector218:
  pushl $0
80106c83:	6a 00                	push   $0x0
  pushl $218
80106c85:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106c8a:	e9 4a f1 ff ff       	jmp    80105dd9 <alltraps>

80106c8f <vector219>:
.globl vector219
vector219:
  pushl $0
80106c8f:	6a 00                	push   $0x0
  pushl $219
80106c91:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106c96:	e9 3e f1 ff ff       	jmp    80105dd9 <alltraps>

80106c9b <vector220>:
.globl vector220
vector220:
  pushl $0
80106c9b:	6a 00                	push   $0x0
  pushl $220
80106c9d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106ca2:	e9 32 f1 ff ff       	jmp    80105dd9 <alltraps>

80106ca7 <vector221>:
.globl vector221
vector221:
  pushl $0
80106ca7:	6a 00                	push   $0x0
  pushl $221
80106ca9:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106cae:	e9 26 f1 ff ff       	jmp    80105dd9 <alltraps>

80106cb3 <vector222>:
.globl vector222
vector222:
  pushl $0
80106cb3:	6a 00                	push   $0x0
  pushl $222
80106cb5:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106cba:	e9 1a f1 ff ff       	jmp    80105dd9 <alltraps>

80106cbf <vector223>:
.globl vector223
vector223:
  pushl $0
80106cbf:	6a 00                	push   $0x0
  pushl $223
80106cc1:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106cc6:	e9 0e f1 ff ff       	jmp    80105dd9 <alltraps>

80106ccb <vector224>:
.globl vector224
vector224:
  pushl $0
80106ccb:	6a 00                	push   $0x0
  pushl $224
80106ccd:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106cd2:	e9 02 f1 ff ff       	jmp    80105dd9 <alltraps>

80106cd7 <vector225>:
.globl vector225
vector225:
  pushl $0
80106cd7:	6a 00                	push   $0x0
  pushl $225
80106cd9:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106cde:	e9 f6 f0 ff ff       	jmp    80105dd9 <alltraps>

80106ce3 <vector226>:
.globl vector226
vector226:
  pushl $0
80106ce3:	6a 00                	push   $0x0
  pushl $226
80106ce5:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106cea:	e9 ea f0 ff ff       	jmp    80105dd9 <alltraps>

80106cef <vector227>:
.globl vector227
vector227:
  pushl $0
80106cef:	6a 00                	push   $0x0
  pushl $227
80106cf1:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106cf6:	e9 de f0 ff ff       	jmp    80105dd9 <alltraps>

80106cfb <vector228>:
.globl vector228
vector228:
  pushl $0
80106cfb:	6a 00                	push   $0x0
  pushl $228
80106cfd:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106d02:	e9 d2 f0 ff ff       	jmp    80105dd9 <alltraps>

80106d07 <vector229>:
.globl vector229
vector229:
  pushl $0
80106d07:	6a 00                	push   $0x0
  pushl $229
80106d09:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106d0e:	e9 c6 f0 ff ff       	jmp    80105dd9 <alltraps>

80106d13 <vector230>:
.globl vector230
vector230:
  pushl $0
80106d13:	6a 00                	push   $0x0
  pushl $230
80106d15:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106d1a:	e9 ba f0 ff ff       	jmp    80105dd9 <alltraps>

80106d1f <vector231>:
.globl vector231
vector231:
  pushl $0
80106d1f:	6a 00                	push   $0x0
  pushl $231
80106d21:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106d26:	e9 ae f0 ff ff       	jmp    80105dd9 <alltraps>

80106d2b <vector232>:
.globl vector232
vector232:
  pushl $0
80106d2b:	6a 00                	push   $0x0
  pushl $232
80106d2d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106d32:	e9 a2 f0 ff ff       	jmp    80105dd9 <alltraps>

80106d37 <vector233>:
.globl vector233
vector233:
  pushl $0
80106d37:	6a 00                	push   $0x0
  pushl $233
80106d39:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106d3e:	e9 96 f0 ff ff       	jmp    80105dd9 <alltraps>

80106d43 <vector234>:
.globl vector234
vector234:
  pushl $0
80106d43:	6a 00                	push   $0x0
  pushl $234
80106d45:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106d4a:	e9 8a f0 ff ff       	jmp    80105dd9 <alltraps>

80106d4f <vector235>:
.globl vector235
vector235:
  pushl $0
80106d4f:	6a 00                	push   $0x0
  pushl $235
80106d51:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106d56:	e9 7e f0 ff ff       	jmp    80105dd9 <alltraps>

80106d5b <vector236>:
.globl vector236
vector236:
  pushl $0
80106d5b:	6a 00                	push   $0x0
  pushl $236
80106d5d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106d62:	e9 72 f0 ff ff       	jmp    80105dd9 <alltraps>

80106d67 <vector237>:
.globl vector237
vector237:
  pushl $0
80106d67:	6a 00                	push   $0x0
  pushl $237
80106d69:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106d6e:	e9 66 f0 ff ff       	jmp    80105dd9 <alltraps>

80106d73 <vector238>:
.globl vector238
vector238:
  pushl $0
80106d73:	6a 00                	push   $0x0
  pushl $238
80106d75:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106d7a:	e9 5a f0 ff ff       	jmp    80105dd9 <alltraps>

80106d7f <vector239>:
.globl vector239
vector239:
  pushl $0
80106d7f:	6a 00                	push   $0x0
  pushl $239
80106d81:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106d86:	e9 4e f0 ff ff       	jmp    80105dd9 <alltraps>

80106d8b <vector240>:
.globl vector240
vector240:
  pushl $0
80106d8b:	6a 00                	push   $0x0
  pushl $240
80106d8d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106d92:	e9 42 f0 ff ff       	jmp    80105dd9 <alltraps>

80106d97 <vector241>:
.globl vector241
vector241:
  pushl $0
80106d97:	6a 00                	push   $0x0
  pushl $241
80106d99:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106d9e:	e9 36 f0 ff ff       	jmp    80105dd9 <alltraps>

80106da3 <vector242>:
.globl vector242
vector242:
  pushl $0
80106da3:	6a 00                	push   $0x0
  pushl $242
80106da5:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106daa:	e9 2a f0 ff ff       	jmp    80105dd9 <alltraps>

80106daf <vector243>:
.globl vector243
vector243:
  pushl $0
80106daf:	6a 00                	push   $0x0
  pushl $243
80106db1:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106db6:	e9 1e f0 ff ff       	jmp    80105dd9 <alltraps>

80106dbb <vector244>:
.globl vector244
vector244:
  pushl $0
80106dbb:	6a 00                	push   $0x0
  pushl $244
80106dbd:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106dc2:	e9 12 f0 ff ff       	jmp    80105dd9 <alltraps>

80106dc7 <vector245>:
.globl vector245
vector245:
  pushl $0
80106dc7:	6a 00                	push   $0x0
  pushl $245
80106dc9:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106dce:	e9 06 f0 ff ff       	jmp    80105dd9 <alltraps>

80106dd3 <vector246>:
.globl vector246
vector246:
  pushl $0
80106dd3:	6a 00                	push   $0x0
  pushl $246
80106dd5:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106dda:	e9 fa ef ff ff       	jmp    80105dd9 <alltraps>

80106ddf <vector247>:
.globl vector247
vector247:
  pushl $0
80106ddf:	6a 00                	push   $0x0
  pushl $247
80106de1:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106de6:	e9 ee ef ff ff       	jmp    80105dd9 <alltraps>

80106deb <vector248>:
.globl vector248
vector248:
  pushl $0
80106deb:	6a 00                	push   $0x0
  pushl $248
80106ded:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106df2:	e9 e2 ef ff ff       	jmp    80105dd9 <alltraps>

80106df7 <vector249>:
.globl vector249
vector249:
  pushl $0
80106df7:	6a 00                	push   $0x0
  pushl $249
80106df9:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106dfe:	e9 d6 ef ff ff       	jmp    80105dd9 <alltraps>

80106e03 <vector250>:
.globl vector250
vector250:
  pushl $0
80106e03:	6a 00                	push   $0x0
  pushl $250
80106e05:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106e0a:	e9 ca ef ff ff       	jmp    80105dd9 <alltraps>

80106e0f <vector251>:
.globl vector251
vector251:
  pushl $0
80106e0f:	6a 00                	push   $0x0
  pushl $251
80106e11:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106e16:	e9 be ef ff ff       	jmp    80105dd9 <alltraps>

80106e1b <vector252>:
.globl vector252
vector252:
  pushl $0
80106e1b:	6a 00                	push   $0x0
  pushl $252
80106e1d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106e22:	e9 b2 ef ff ff       	jmp    80105dd9 <alltraps>

80106e27 <vector253>:
.globl vector253
vector253:
  pushl $0
80106e27:	6a 00                	push   $0x0
  pushl $253
80106e29:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106e2e:	e9 a6 ef ff ff       	jmp    80105dd9 <alltraps>

80106e33 <vector254>:
.globl vector254
vector254:
  pushl $0
80106e33:	6a 00                	push   $0x0
  pushl $254
80106e35:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106e3a:	e9 9a ef ff ff       	jmp    80105dd9 <alltraps>

80106e3f <vector255>:
.globl vector255
vector255:
  pushl $0
80106e3f:	6a 00                	push   $0x0
  pushl $255
80106e41:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106e46:	e9 8e ef ff ff       	jmp    80105dd9 <alltraps>
80106e4b:	66 90                	xchg   %ax,%ax
80106e4d:	66 90                	xchg   %ax,%ax
80106e4f:	90                   	nop

80106e50 <cow_kfree>:
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc);
int swap_in(struct proc* p, struct pageinfo* pi);
void swap_out(struct proc* p, struct pageinfo* page_to_swap, void* buffer, pde_t* pgdir);

void cow_kfree(char* to_free_kva){
80106e50:	f3 0f 1e fb          	endbr32 
80106e54:	55                   	push   %ebp
80106e55:	89 e5                	mov    %esp,%ebp
80106e57:	56                   	push   %esi
80106e58:	53                   	push   %ebx
80106e59:	8b 75 08             	mov    0x8(%ebp),%esi
80106e5c:	8d 9e 00 00 00 80    	lea    -0x80000000(%esi),%ebx
  char count;
  int acq = 0;
  if (lapicid() != 0 && !holding(cow_lock)){
80106e62:	e8 f9 be ff ff       	call   80102d60 <lapicid>
80106e67:	c1 eb 0c             	shr    $0xc,%ebx
80106e6a:	85 c0                	test   %eax,%eax
80106e6c:	75 1a                	jne    80106e88 <cow_kfree+0x38>
    acquire(cow_lock);
  }
  // struct proc* p = myproc();
  // if (p != 0 ){ // && p->pid > 2
  count = --pg_ref_counts[PGROUNDDOWN(V2P(to_free_kva)) / PGSIZE];
  if (count != 0){
80106e6e:	80 ab 40 0f 11 80 01 	subb   $0x1,-0x7feef0c0(%ebx)
80106e75:	75 71                	jne    80106ee8 <cow_kfree+0x98>
  // possible bug
  if (acq){
    // cprintf("rel kfree %d\n", myproc()->pid);
    release(cow_lock);
  }
  kfree(to_free_kva);
80106e77:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106e7a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106e7d:	5b                   	pop    %ebx
80106e7e:	5e                   	pop    %esi
80106e7f:	5d                   	pop    %ebp
  kfree(to_free_kva);
80106e80:	e9 7b ba ff ff       	jmp    80102900 <kfree>
80106e85:	8d 76 00             	lea    0x0(%esi),%esi
  if (lapicid() != 0 && !holding(cow_lock)){
80106e88:	83 ec 0c             	sub    $0xc,%esp
80106e8b:	ff 35 40 ef 11 80    	pushl  0x8011ef40
80106e91:	e8 ba db ff ff       	call   80104a50 <holding>
80106e96:	83 c4 10             	add    $0x10,%esp
80106e99:	85 c0                	test   %eax,%eax
80106e9b:	75 d1                	jne    80106e6e <cow_kfree+0x1e>
    acquire(cow_lock);
80106e9d:	83 ec 0c             	sub    $0xc,%esp
80106ea0:	ff 35 40 ef 11 80    	pushl  0x8011ef40
80106ea6:	e8 f5 db ff ff       	call   80104aa0 <acquire>
  count = --pg_ref_counts[PGROUNDDOWN(V2P(to_free_kva)) / PGSIZE];
80106eab:	0f b6 83 40 0f 11 80 	movzbl -0x7feef0c0(%ebx),%eax
  if (count != 0){
80106eb2:	83 c4 10             	add    $0x10,%esp
  count = --pg_ref_counts[PGROUNDDOWN(V2P(to_free_kva)) / PGSIZE];
80106eb5:	83 e8 01             	sub    $0x1,%eax
80106eb8:	88 83 40 0f 11 80    	mov    %al,-0x7feef0c0(%ebx)
  if (count != 0){
80106ebe:	84 c0                	test   %al,%al
80106ec0:	75 2e                	jne    80106ef0 <cow_kfree+0xa0>
    release(cow_lock);
80106ec2:	83 ec 0c             	sub    $0xc,%esp
80106ec5:	ff 35 40 ef 11 80    	pushl  0x8011ef40
80106ecb:	e8 90 dc ff ff       	call   80104b60 <release>
  kfree(to_free_kva);
80106ed0:	89 75 08             	mov    %esi,0x8(%ebp)
    release(cow_lock);
80106ed3:	83 c4 10             	add    $0x10,%esp
}
80106ed6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106ed9:	5b                   	pop    %ebx
80106eda:	5e                   	pop    %esi
80106edb:	5d                   	pop    %ebp
  kfree(to_free_kva);
80106edc:	e9 1f ba ff ff       	jmp    80102900 <kfree>
80106ee1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80106ee8:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106eeb:	5b                   	pop    %ebx
80106eec:	5e                   	pop    %esi
80106eed:	5d                   	pop    %ebp
80106eee:	c3                   	ret    
80106eef:	90                   	nop
      release(cow_lock);
80106ef0:	a1 40 ef 11 80       	mov    0x8011ef40,%eax
80106ef5:	89 45 08             	mov    %eax,0x8(%ebp)
}
80106ef8:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106efb:	5b                   	pop    %ebx
80106efc:	5e                   	pop    %esi
80106efd:	5d                   	pop    %ebp
      release(cow_lock);
80106efe:	e9 5d dc ff ff       	jmp    80104b60 <release>
80106f03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106f10 <cow_kalloc>:

char* cow_kalloc(){
80106f10:	f3 0f 1e fb          	endbr32 
80106f14:	55                   	push   %ebp
80106f15:	89 e5                	mov    %esp,%ebp
80106f17:	57                   	push   %edi
80106f18:	56                   	push   %esi
80106f19:	53                   	push   %ebx
80106f1a:	83 ec 0c             	sub    $0xc,%esp
  char* r = kalloc();
80106f1d:	e8 ce bb ff ff       	call   80102af0 <kalloc>
80106f22:	89 c3                	mov    %eax,%ebx
  if (r == 0){
80106f24:	85 c0                	test   %eax,%eax
80106f26:	74 28                	je     80106f50 <cow_kalloc+0x40>
    return r;
  }
  int acq = 0;
  // cprintf("kalloc \n");
  if (lapicid() != 0 && !holding(cow_lock)){
80106f28:	e8 33 be ff ff       	call   80102d60 <lapicid>
80106f2d:	8d bb 00 00 00 80    	lea    -0x80000000(%ebx),%edi
80106f33:	89 fe                	mov    %edi,%esi
80106f35:	c1 ee 0c             	shr    $0xc,%esi
80106f38:	85 c0                	test   %eax,%eax
80106f3a:	75 24                	jne    80106f60 <cow_kalloc+0x50>
    acq = 1;
    // cprintf("kalloc %d\n", myproc()->pid);
    acquire(cow_lock);
  }
  if (pg_ref_counts[PGROUNDDOWN(V2P(r)) / PGSIZE]++ != 0){ 
80106f3c:	0f b6 86 40 0f 11 80 	movzbl -0x7feef0c0(%esi),%eax
80106f43:	8d 50 01             	lea    0x1(%eax),%edx
80106f46:	88 96 40 0f 11 80    	mov    %dl,-0x7feef0c0(%esi)
80106f4c:	84 c0                	test   %al,%al
80106f4e:	75 65                	jne    80106fb5 <cow_kalloc+0xa5>
  }
  if (acq){
    release(cow_lock);
  }
  return r;
}
80106f50:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f53:	89 d8                	mov    %ebx,%eax
80106f55:	5b                   	pop    %ebx
80106f56:	5e                   	pop    %esi
80106f57:	5f                   	pop    %edi
80106f58:	5d                   	pop    %ebp
80106f59:	c3                   	ret    
80106f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if (lapicid() != 0 && !holding(cow_lock)){
80106f60:	83 ec 0c             	sub    $0xc,%esp
80106f63:	ff 35 40 ef 11 80    	pushl  0x8011ef40
80106f69:	e8 e2 da ff ff       	call   80104a50 <holding>
80106f6e:	83 c4 10             	add    $0x10,%esp
80106f71:	85 c0                	test   %eax,%eax
80106f73:	75 c7                	jne    80106f3c <cow_kalloc+0x2c>
    acquire(cow_lock);
80106f75:	83 ec 0c             	sub    $0xc,%esp
80106f78:	ff 35 40 ef 11 80    	pushl  0x8011ef40
80106f7e:	e8 1d db ff ff       	call   80104aa0 <acquire>
  if (pg_ref_counts[PGROUNDDOWN(V2P(r)) / PGSIZE]++ != 0){ 
80106f83:	0f b6 86 40 0f 11 80 	movzbl -0x7feef0c0(%esi),%eax
80106f8a:	83 c4 10             	add    $0x10,%esp
80106f8d:	8d 50 01             	lea    0x1(%eax),%edx
80106f90:	88 96 40 0f 11 80    	mov    %dl,-0x7feef0c0(%esi)
80106f96:	84 c0                	test   %al,%al
80106f98:	75 1b                	jne    80106fb5 <cow_kalloc+0xa5>
    release(cow_lock);
80106f9a:	83 ec 0c             	sub    $0xc,%esp
80106f9d:	ff 35 40 ef 11 80    	pushl  0x8011ef40
80106fa3:	e8 b8 db ff ff       	call   80104b60 <release>
80106fa8:	83 c4 10             	add    $0x10,%esp
}
80106fab:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fae:	89 d8                	mov    %ebx,%eax
80106fb0:	5b                   	pop    %ebx
80106fb1:	5e                   	pop    %esi
80106fb2:	5f                   	pop    %edi
80106fb3:	5d                   	pop    %ebp
80106fb4:	c3                   	ret    
    cprintf("actual ref count = %d, pg index = %x, pg pa = %x\n", pg_ref_counts[PGROUNDDOWN(V2P(r)) / PGSIZE] - 1, PGROUNDDOWN(V2P(r)) / PGSIZE, V2P(r));
80106fb5:	0f be c2             	movsbl %dl,%eax
80106fb8:	57                   	push   %edi
80106fb9:	83 e8 01             	sub    $0x1,%eax
80106fbc:	56                   	push   %esi
80106fbd:	50                   	push   %eax
80106fbe:	68 f0 83 10 80       	push   $0x801083f0
80106fc3:	e8 e8 96 ff ff       	call   801006b0 <cprintf>
    panic("kalloc allocated something with a reference");
80106fc8:	c7 04 24 24 84 10 80 	movl   $0x80108424,(%esp)
80106fcf:	e8 bc 93 ff ff       	call   80100390 <panic>
80106fd4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106fdf:	90                   	nop

80106fe0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106fe0:	55                   	push   %ebp
80106fe1:	89 e5                	mov    %esp,%ebp
80106fe3:	57                   	push   %edi
80106fe4:	56                   	push   %esi
80106fe5:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106fe7:	c1 ea 16             	shr    $0x16,%edx
{
80106fea:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
80106feb:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
80106fee:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106ff1:	8b 1f                	mov    (%edi),%ebx
80106ff3:	f6 c3 01             	test   $0x1,%bl
80106ff6:	74 28                	je     80107020 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106ff8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106ffe:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107004:	89 f0                	mov    %esi,%eax
}
80107006:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80107009:	c1 e8 0a             	shr    $0xa,%eax
8010700c:	25 fc 0f 00 00       	and    $0xffc,%eax
80107011:	01 d8                	add    %ebx,%eax
}
80107013:	5b                   	pop    %ebx
80107014:	5e                   	pop    %esi
80107015:	5f                   	pop    %edi
80107016:	5d                   	pop    %ebp
80107017:	c3                   	ret    
80107018:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010701f:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)cow_kalloc()) == 0)
80107020:	85 c9                	test   %ecx,%ecx
80107022:	74 2c                	je     80107050 <walkpgdir+0x70>
80107024:	e8 e7 fe ff ff       	call   80106f10 <cow_kalloc>
80107029:	89 c3                	mov    %eax,%ebx
8010702b:	85 c0                	test   %eax,%eax
8010702d:	74 21                	je     80107050 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010702f:	83 ec 04             	sub    $0x4,%esp
80107032:	68 00 10 00 00       	push   $0x1000
80107037:	6a 00                	push   $0x0
80107039:	50                   	push   %eax
8010703a:	e8 71 db ff ff       	call   80104bb0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010703f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107045:	83 c4 10             	add    $0x10,%esp
80107048:	83 c8 07             	or     $0x7,%eax
8010704b:	89 07                	mov    %eax,(%edi)
8010704d:	eb b5                	jmp    80107004 <walkpgdir+0x24>
8010704f:	90                   	nop
}
80107050:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107053:	31 c0                	xor    %eax,%eax
}
80107055:	5b                   	pop    %ebx
80107056:	5e                   	pop    %esi
80107057:	5f                   	pop    %edi
80107058:	5d                   	pop    %ebp
80107059:	c3                   	ret    
8010705a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107060 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107060:	55                   	push   %ebp
80107061:	89 e5                	mov    %esp,%ebp
80107063:	57                   	push   %edi
80107064:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107066:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
8010706a:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010706b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80107070:	89 d6                	mov    %edx,%esi
{
80107072:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107073:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80107079:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010707c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010707f:	8b 45 08             	mov    0x8(%ebp),%eax
80107082:	29 f0                	sub    %esi,%eax
80107084:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107087:	eb 1f                	jmp    801070a8 <mappages+0x48>
80107089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  // cprintf("mappages start: %x end: %x \n", a, last);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80107090:	f6 00 01             	testb  $0x1,(%eax)
80107093:	75 45                	jne    801070da <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80107095:	0b 5d 0c             	or     0xc(%ebp),%ebx
80107098:	83 cb 01             	or     $0x1,%ebx
8010709b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
8010709d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801070a0:	74 2e                	je     801070d0 <mappages+0x70>
      break;
    a += PGSIZE;
801070a2:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
801070a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801070ab:	b9 01 00 00 00       	mov    $0x1,%ecx
801070b0:	89 f2                	mov    %esi,%edx
801070b2:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
801070b5:	89 f8                	mov    %edi,%eax
801070b7:	e8 24 ff ff ff       	call   80106fe0 <walkpgdir>
801070bc:	85 c0                	test   %eax,%eax
801070be:	75 d0                	jne    80107090 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
801070c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801070c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801070c8:	5b                   	pop    %ebx
801070c9:	5e                   	pop    %esi
801070ca:	5f                   	pop    %edi
801070cb:	5d                   	pop    %ebp
801070cc:	c3                   	ret    
801070cd:	8d 76 00             	lea    0x0(%esi),%esi
801070d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801070d3:	31 c0                	xor    %eax,%eax
}
801070d5:	5b                   	pop    %ebx
801070d6:	5e                   	pop    %esi
801070d7:	5f                   	pop    %edi
801070d8:	5d                   	pop    %ebp
801070d9:	c3                   	ret    
      panic("remap");
801070da:	83 ec 0c             	sub    $0xc,%esp
801070dd:	68 73 84 10 80       	push   $0x80108473
801070e2:	e8 a9 92 ff ff       	call   80100390 <panic>
801070e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070ee:	66 90                	xchg   %ax,%ax

801070f0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801070f0:	55                   	push   %ebp
801070f1:	89 e5                	mov    %esp,%ebp
801070f3:	57                   	push   %edi
801070f4:	56                   	push   %esi
801070f5:	89 c6                	mov    %eax,%esi
801070f7:	53                   	push   %ebx
801070f8:	89 d3                	mov    %edx,%ebx
  #endif
  
  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801070fa:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
80107100:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107106:	83 ec 1c             	sub    $0x1c,%esp
80107109:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010710c:	39 da                	cmp    %ebx,%edx
8010710e:	73 5b                	jae    8010716b <deallocuvm.part.0+0x7b>
80107110:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80107113:	89 d7                	mov    %edx,%edi
80107115:	eb 14                	jmp    8010712b <deallocuvm.part.0+0x3b>
80107117:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010711e:	66 90                	xchg   %ax,%ax
80107120:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107126:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80107129:	76 40                	jbe    8010716b <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010712b:	31 c9                	xor    %ecx,%ecx
8010712d:	89 fa                	mov    %edi,%edx
8010712f:	89 f0                	mov    %esi,%eax
80107131:	e8 aa fe ff ff       	call   80106fe0 <walkpgdir>
80107136:	89 c3                	mov    %eax,%ebx
    if(!pte)
80107138:	85 c0                	test   %eax,%eax
8010713a:	74 44                	je     80107180 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if ((*pte & PTE_P) != 0){
8010713c:	8b 00                	mov    (%eax),%eax
8010713e:	a8 01                	test   $0x1,%al
80107140:	74 de                	je     80107120 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80107142:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107147:	74 47                	je     80107190 <deallocuvm.part.0+0xa0>
        panic("cow_kfree");
      char *v = P2V(pa);
      cow_kfree(v);
80107149:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010714c:	05 00 00 00 80       	add    $0x80000000,%eax
80107151:	81 c7 00 10 00 00    	add    $0x1000,%edi
      cow_kfree(v);
80107157:	50                   	push   %eax
80107158:	e8 f3 fc ff ff       	call   80106e50 <cow_kfree>
            break;
          }
        }
      }
      #endif
      *pte = 0;
8010715d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80107163:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
80107166:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80107169:	77 c0                	ja     8010712b <deallocuvm.part.0+0x3b>
    }
  }

  return newsz;
}
8010716b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010716e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107171:	5b                   	pop    %ebx
80107172:	5e                   	pop    %esi
80107173:	5f                   	pop    %edi
80107174:	5d                   	pop    %ebp
80107175:	c3                   	ret    
80107176:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010717d:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107180:	89 fa                	mov    %edi,%edx
80107182:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80107188:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
8010718e:	eb 96                	jmp    80107126 <deallocuvm.part.0+0x36>
        panic("cow_kfree");
80107190:	83 ec 0c             	sub    $0xc,%esp
80107193:	68 79 84 10 80       	push   $0x80108479
80107198:	e8 f3 91 ff ff       	call   80100390 <panic>
8010719d:	8d 76 00             	lea    0x0(%esi),%esi

801071a0 <seginit>:
{
801071a0:	f3 0f 1e fb          	endbr32 
801071a4:	55                   	push   %ebp
801071a5:	89 e5                	mov    %esp,%ebp
801071a7:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801071aa:	e8 81 cc ff ff       	call   80103e30 <cpuid>
  pd[0] = size-1;
801071af:	ba 2f 00 00 00       	mov    $0x2f,%edx
801071b4:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801071ba:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801071be:	c7 80 78 18 12 80 ff 	movl   $0xffff,-0x7fede788(%eax)
801071c5:	ff 00 00 
801071c8:	c7 80 7c 18 12 80 00 	movl   $0xcf9a00,-0x7fede784(%eax)
801071cf:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801071d2:	c7 80 80 18 12 80 ff 	movl   $0xffff,-0x7fede780(%eax)
801071d9:	ff 00 00 
801071dc:	c7 80 84 18 12 80 00 	movl   $0xcf9200,-0x7fede77c(%eax)
801071e3:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801071e6:	c7 80 88 18 12 80 ff 	movl   $0xffff,-0x7fede778(%eax)
801071ed:	ff 00 00 
801071f0:	c7 80 8c 18 12 80 00 	movl   $0xcffa00,-0x7fede774(%eax)
801071f7:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801071fa:	c7 80 90 18 12 80 ff 	movl   $0xffff,-0x7fede770(%eax)
80107201:	ff 00 00 
80107204:	c7 80 94 18 12 80 00 	movl   $0xcff200,-0x7fede76c(%eax)
8010720b:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010720e:	05 70 18 12 80       	add    $0x80121870,%eax
  pd[1] = (uint)p;
80107213:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107217:	c1 e8 10             	shr    $0x10,%eax
8010721a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010721e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107221:	0f 01 10             	lgdtl  (%eax)
}
80107224:	c9                   	leave  
80107225:	c3                   	ret    
80107226:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010722d:	8d 76 00             	lea    0x0(%esi),%esi

80107230 <public_walkpgdir>:
public_walkpgdir(pde_t *pgdir, const void *va, int alloc){
80107230:	f3 0f 1e fb          	endbr32 
80107234:	55                   	push   %ebp
80107235:	89 e5                	mov    %esp,%ebp
  return walkpgdir(pgdir, va, alloc);
80107237:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010723a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010723d:	8b 45 08             	mov    0x8(%ebp),%eax
}
80107240:	5d                   	pop    %ebp
  return walkpgdir(pgdir, va, alloc);
80107241:	e9 9a fd ff ff       	jmp    80106fe0 <walkpgdir>
80107246:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010724d:	8d 76 00             	lea    0x0(%esi),%esi

80107250 <switchkvm>:
{
80107250:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107254:	a1 24 1a 13 80       	mov    0x80131a24,%eax
80107259:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010725e:	0f 22 d8             	mov    %eax,%cr3
}
80107261:	c3                   	ret    
80107262:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107270 <switchuvm>:
{
80107270:	f3 0f 1e fb          	endbr32 
80107274:	55                   	push   %ebp
80107275:	89 e5                	mov    %esp,%ebp
80107277:	57                   	push   %edi
80107278:	56                   	push   %esi
80107279:	53                   	push   %ebx
8010727a:	83 ec 1c             	sub    $0x1c,%esp
8010727d:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80107280:	85 f6                	test   %esi,%esi
80107282:	0f 84 cb 00 00 00    	je     80107353 <switchuvm+0xe3>
  if(p->kstack == 0)
80107288:	8b 46 08             	mov    0x8(%esi),%eax
8010728b:	85 c0                	test   %eax,%eax
8010728d:	0f 84 da 00 00 00    	je     8010736d <switchuvm+0xfd>
  if(p->pgdir == 0)
80107293:	8b 46 04             	mov    0x4(%esi),%eax
80107296:	85 c0                	test   %eax,%eax
80107298:	0f 84 c2 00 00 00    	je     80107360 <switchuvm+0xf0>
  pushcli();
8010729e:	e8 fd d6 ff ff       	call   801049a0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801072a3:	e8 08 cb ff ff       	call   80103db0 <mycpu>
801072a8:	89 c3                	mov    %eax,%ebx
801072aa:	e8 01 cb ff ff       	call   80103db0 <mycpu>
801072af:	89 c7                	mov    %eax,%edi
801072b1:	e8 fa ca ff ff       	call   80103db0 <mycpu>
801072b6:	83 c7 08             	add    $0x8,%edi
801072b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801072bc:	e8 ef ca ff ff       	call   80103db0 <mycpu>
801072c1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801072c4:	ba 67 00 00 00       	mov    $0x67,%edx
801072c9:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801072d0:	83 c0 08             	add    $0x8,%eax
801072d3:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801072da:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801072df:	83 c1 08             	add    $0x8,%ecx
801072e2:	c1 e8 18             	shr    $0x18,%eax
801072e5:	c1 e9 10             	shr    $0x10,%ecx
801072e8:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
801072ee:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801072f4:	b9 99 40 00 00       	mov    $0x4099,%ecx
801072f9:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107300:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107305:	e8 a6 ca ff ff       	call   80103db0 <mycpu>
8010730a:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107311:	e8 9a ca ff ff       	call   80103db0 <mycpu>
80107316:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
8010731a:	8b 5e 08             	mov    0x8(%esi),%ebx
8010731d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107323:	e8 88 ca ff ff       	call   80103db0 <mycpu>
80107328:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010732b:	e8 80 ca ff ff       	call   80103db0 <mycpu>
80107330:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107334:	b8 28 00 00 00       	mov    $0x28,%eax
80107339:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010733c:	8b 46 04             	mov    0x4(%esi),%eax
8010733f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107344:	0f 22 d8             	mov    %eax,%cr3
}
80107347:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010734a:	5b                   	pop    %ebx
8010734b:	5e                   	pop    %esi
8010734c:	5f                   	pop    %edi
8010734d:	5d                   	pop    %ebp
  popcli();
8010734e:	e9 9d d6 ff ff       	jmp    801049f0 <popcli>
    panic("switchuvm: no process");
80107353:	83 ec 0c             	sub    $0xc,%esp
80107356:	68 83 84 10 80       	push   $0x80108483
8010735b:	e8 30 90 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107360:	83 ec 0c             	sub    $0xc,%esp
80107363:	68 ae 84 10 80       	push   $0x801084ae
80107368:	e8 23 90 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
8010736d:	83 ec 0c             	sub    $0xc,%esp
80107370:	68 99 84 10 80       	push   $0x80108499
80107375:	e8 16 90 ff ff       	call   80100390 <panic>
8010737a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107380 <inituvm>:
{
80107380:	f3 0f 1e fb          	endbr32 
80107384:	55                   	push   %ebp
80107385:	89 e5                	mov    %esp,%ebp
80107387:	57                   	push   %edi
80107388:	56                   	push   %esi
80107389:	53                   	push   %ebx
8010738a:	83 ec 1c             	sub    $0x1c,%esp
8010738d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107390:	8b 75 10             	mov    0x10(%ebp),%esi
80107393:	8b 7d 08             	mov    0x8(%ebp),%edi
80107396:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107399:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010739f:	77 4b                	ja     801073ec <inituvm+0x6c>
  mem = cow_kalloc();
801073a1:	e8 6a fb ff ff       	call   80106f10 <cow_kalloc>
  memset(mem, 0, PGSIZE);
801073a6:	83 ec 04             	sub    $0x4,%esp
801073a9:	68 00 10 00 00       	push   $0x1000
  mem = cow_kalloc();
801073ae:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801073b0:	6a 00                	push   $0x0
801073b2:	50                   	push   %eax
801073b3:	e8 f8 d7 ff ff       	call   80104bb0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801073b8:	58                   	pop    %eax
801073b9:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801073bf:	5a                   	pop    %edx
801073c0:	6a 06                	push   $0x6
801073c2:	b9 00 10 00 00       	mov    $0x1000,%ecx
801073c7:	31 d2                	xor    %edx,%edx
801073c9:	50                   	push   %eax
801073ca:	89 f8                	mov    %edi,%eax
801073cc:	e8 8f fc ff ff       	call   80107060 <mappages>
  memmove(mem, init, sz);
801073d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801073d4:	89 75 10             	mov    %esi,0x10(%ebp)
801073d7:	83 c4 10             	add    $0x10,%esp
801073da:	89 5d 08             	mov    %ebx,0x8(%ebp)
801073dd:	89 45 0c             	mov    %eax,0xc(%ebp)
}
801073e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073e3:	5b                   	pop    %ebx
801073e4:	5e                   	pop    %esi
801073e5:	5f                   	pop    %edi
801073e6:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801073e7:	e9 64 d8 ff ff       	jmp    80104c50 <memmove>
    panic("inituvm: more than a page");
801073ec:	83 ec 0c             	sub    $0xc,%esp
801073ef:	68 c2 84 10 80       	push   $0x801084c2
801073f4:	e8 97 8f ff ff       	call   80100390 <panic>
801073f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107400 <loaduvm>:
{
80107400:	f3 0f 1e fb          	endbr32 
80107404:	55                   	push   %ebp
80107405:	89 e5                	mov    %esp,%ebp
80107407:	57                   	push   %edi
80107408:	56                   	push   %esi
80107409:	53                   	push   %ebx
8010740a:	83 ec 1c             	sub    $0x1c,%esp
8010740d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107410:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80107413:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107418:	0f 85 99 00 00 00    	jne    801074b7 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
8010741e:	01 f0                	add    %esi,%eax
80107420:	89 f3                	mov    %esi,%ebx
80107422:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107425:	8b 45 14             	mov    0x14(%ebp),%eax
80107428:	01 f0                	add    %esi,%eax
8010742a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
8010742d:	85 f6                	test   %esi,%esi
8010742f:	75 15                	jne    80107446 <loaduvm+0x46>
80107431:	eb 6d                	jmp    801074a0 <loaduvm+0xa0>
80107433:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107437:	90                   	nop
80107438:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
8010743e:	89 f0                	mov    %esi,%eax
80107440:	29 d8                	sub    %ebx,%eax
80107442:	39 c6                	cmp    %eax,%esi
80107444:	76 5a                	jbe    801074a0 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107446:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107449:	8b 45 08             	mov    0x8(%ebp),%eax
8010744c:	31 c9                	xor    %ecx,%ecx
8010744e:	29 da                	sub    %ebx,%edx
80107450:	e8 8b fb ff ff       	call   80106fe0 <walkpgdir>
80107455:	85 c0                	test   %eax,%eax
80107457:	74 51                	je     801074aa <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80107459:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010745b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010745e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107463:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107468:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010746e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107471:	29 d9                	sub    %ebx,%ecx
80107473:	05 00 00 00 80       	add    $0x80000000,%eax
80107478:	57                   	push   %edi
80107479:	51                   	push   %ecx
8010747a:	50                   	push   %eax
8010747b:	ff 75 10             	pushl  0x10(%ebp)
8010747e:	e8 8d a6 ff ff       	call   80101b10 <readi>
80107483:	83 c4 10             	add    $0x10,%esp
80107486:	39 f8                	cmp    %edi,%eax
80107488:	74 ae                	je     80107438 <loaduvm+0x38>
}
8010748a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010748d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107492:	5b                   	pop    %ebx
80107493:	5e                   	pop    %esi
80107494:	5f                   	pop    %edi
80107495:	5d                   	pop    %ebp
80107496:	c3                   	ret    
80107497:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010749e:	66 90                	xchg   %ax,%ax
801074a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801074a3:	31 c0                	xor    %eax,%eax
}
801074a5:	5b                   	pop    %ebx
801074a6:	5e                   	pop    %esi
801074a7:	5f                   	pop    %edi
801074a8:	5d                   	pop    %ebp
801074a9:	c3                   	ret    
      panic("loaduvm: address should exist");
801074aa:	83 ec 0c             	sub    $0xc,%esp
801074ad:	68 dc 84 10 80       	push   $0x801084dc
801074b2:	e8 d9 8e ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
801074b7:	83 ec 0c             	sub    $0xc,%esp
801074ba:	68 50 84 10 80       	push   $0x80108450
801074bf:	e8 cc 8e ff ff       	call   80100390 <panic>
801074c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801074cf:	90                   	nop

801074d0 <allocuvm>:
{
801074d0:	f3 0f 1e fb          	endbr32 
801074d4:	55                   	push   %ebp
801074d5:	89 e5                	mov    %esp,%ebp
801074d7:	57                   	push   %edi
801074d8:	56                   	push   %esi
801074d9:	53                   	push   %ebx
801074da:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801074dd:	8b 45 10             	mov    0x10(%ebp),%eax
{
801074e0:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
801074e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801074e6:	85 c0                	test   %eax,%eax
801074e8:	0f 88 b2 00 00 00    	js     801075a0 <allocuvm+0xd0>
  if(newsz < oldsz)
801074ee:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
801074f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
801074f4:	0f 82 96 00 00 00    	jb     80107590 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
801074fa:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107500:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107506:	39 75 10             	cmp    %esi,0x10(%ebp)
80107509:	77 40                	ja     8010754b <allocuvm+0x7b>
8010750b:	e9 83 00 00 00       	jmp    80107593 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
80107510:	83 ec 04             	sub    $0x4,%esp
80107513:	68 00 10 00 00       	push   $0x1000
80107518:	6a 00                	push   $0x0
8010751a:	50                   	push   %eax
8010751b:	e8 90 d6 ff ff       	call   80104bb0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0){
80107520:	58                   	pop    %eax
80107521:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107527:	5a                   	pop    %edx
80107528:	6a 06                	push   $0x6
8010752a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010752f:	89 f2                	mov    %esi,%edx
80107531:	50                   	push   %eax
80107532:	89 f8                	mov    %edi,%eax
80107534:	e8 27 fb ff ff       	call   80107060 <mappages>
80107539:	83 c4 10             	add    $0x10,%esp
8010753c:	85 c0                	test   %eax,%eax
8010753e:	78 78                	js     801075b8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107540:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107546:	39 75 10             	cmp    %esi,0x10(%ebp)
80107549:	76 48                	jbe    80107593 <allocuvm+0xc3>
    mem = cow_kalloc();
8010754b:	e8 c0 f9 ff ff       	call   80106f10 <cow_kalloc>
80107550:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107552:	85 c0                	test   %eax,%eax
80107554:	75 ba                	jne    80107510 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107556:	83 ec 0c             	sub    $0xc,%esp
80107559:	68 fa 84 10 80       	push   $0x801084fa
8010755e:	e8 4d 91 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80107563:	8b 45 0c             	mov    0xc(%ebp),%eax
80107566:	83 c4 10             	add    $0x10,%esp
80107569:	39 45 10             	cmp    %eax,0x10(%ebp)
8010756c:	74 32                	je     801075a0 <allocuvm+0xd0>
8010756e:	8b 55 10             	mov    0x10(%ebp),%edx
80107571:	89 c1                	mov    %eax,%ecx
80107573:	89 f8                	mov    %edi,%eax
80107575:	e8 76 fb ff ff       	call   801070f0 <deallocuvm.part.0>
      return 0;
8010757a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107581:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107584:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107587:	5b                   	pop    %ebx
80107588:	5e                   	pop    %esi
80107589:	5f                   	pop    %edi
8010758a:	5d                   	pop    %ebp
8010758b:	c3                   	ret    
8010758c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107590:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107593:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107596:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107599:	5b                   	pop    %ebx
8010759a:	5e                   	pop    %esi
8010759b:	5f                   	pop    %edi
8010759c:	5d                   	pop    %ebp
8010759d:	c3                   	ret    
8010759e:	66 90                	xchg   %ax,%ax
    return 0;
801075a0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801075a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801075aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075ad:	5b                   	pop    %ebx
801075ae:	5e                   	pop    %esi
801075af:	5f                   	pop    %edi
801075b0:	5d                   	pop    %ebp
801075b1:	c3                   	ret    
801075b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801075b8:	83 ec 0c             	sub    $0xc,%esp
801075bb:	68 12 85 10 80       	push   $0x80108512
801075c0:	e8 eb 90 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
801075c5:	8b 45 0c             	mov    0xc(%ebp),%eax
801075c8:	83 c4 10             	add    $0x10,%esp
801075cb:	39 45 10             	cmp    %eax,0x10(%ebp)
801075ce:	74 0c                	je     801075dc <allocuvm+0x10c>
801075d0:	8b 55 10             	mov    0x10(%ebp),%edx
801075d3:	89 c1                	mov    %eax,%ecx
801075d5:	89 f8                	mov    %edi,%eax
801075d7:	e8 14 fb ff ff       	call   801070f0 <deallocuvm.part.0>
      cow_kfree(mem);
801075dc:	83 ec 0c             	sub    $0xc,%esp
801075df:	53                   	push   %ebx
801075e0:	e8 6b f8 ff ff       	call   80106e50 <cow_kfree>
      return 0;
801075e5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801075ec:	83 c4 10             	add    $0x10,%esp
}
801075ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801075f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075f5:	5b                   	pop    %ebx
801075f6:	5e                   	pop    %esi
801075f7:	5f                   	pop    %edi
801075f8:	5d                   	pop    %ebp
801075f9:	c3                   	ret    
801075fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107600 <deallocuvm>:
{
80107600:	f3 0f 1e fb          	endbr32 
80107604:	55                   	push   %ebp
80107605:	89 e5                	mov    %esp,%ebp
80107607:	8b 55 0c             	mov    0xc(%ebp),%edx
8010760a:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010760d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107610:	39 d1                	cmp    %edx,%ecx
80107612:	73 0c                	jae    80107620 <deallocuvm+0x20>
}
80107614:	5d                   	pop    %ebp
80107615:	e9 d6 fa ff ff       	jmp    801070f0 <deallocuvm.part.0>
8010761a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107620:	89 d0                	mov    %edx,%eax
80107622:	5d                   	pop    %ebp
80107623:	c3                   	ret    
80107624:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010762b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010762f:	90                   	nop

80107630 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107630:	f3 0f 1e fb          	endbr32 
80107634:	55                   	push   %ebp
80107635:	89 e5                	mov    %esp,%ebp
80107637:	57                   	push   %edi
80107638:	56                   	push   %esi
80107639:	53                   	push   %ebx
8010763a:	83 ec 0c             	sub    $0xc,%esp
8010763d:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;
  
  if(pgdir == 0)
80107640:	85 f6                	test   %esi,%esi
80107642:	74 55                	je     80107699 <freevm+0x69>
  if(newsz >= oldsz)
80107644:	31 c9                	xor    %ecx,%ecx
80107646:	ba 00 00 00 80       	mov    $0x80000000,%edx
8010764b:	89 f0                	mov    %esi,%eax
8010764d:	89 f3                	mov    %esi,%ebx
8010764f:	e8 9c fa ff ff       	call   801070f0 <deallocuvm.part.0>
      p->ram_pages[i].swap_file_offset = p->swapped_out_pages[i].swap_file_offset = 0;
      p->ram_pages[i].va = p->swapped_out_pages[i].va = 0;
    }
  }
  #endif
  for(i = 0; i < NPDENTRIES; i++){
80107654:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
8010765a:	eb 0b                	jmp    80107667 <freevm+0x37>
8010765c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107660:	83 c3 04             	add    $0x4,%ebx
80107663:	39 df                	cmp    %ebx,%edi
80107665:	74 23                	je     8010768a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107667:	8b 03                	mov    (%ebx),%eax
80107669:	a8 01                	test   $0x1,%al
8010766b:	74 f3                	je     80107660 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010766d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      cow_kfree(v);
80107672:	83 ec 0c             	sub    $0xc,%esp
80107675:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107678:	05 00 00 00 80       	add    $0x80000000,%eax
      cow_kfree(v);
8010767d:	50                   	push   %eax
8010767e:	e8 cd f7 ff ff       	call   80106e50 <cow_kfree>
80107683:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107686:	39 df                	cmp    %ebx,%edi
80107688:	75 dd                	jne    80107667 <freevm+0x37>
    }
  }
   cow_kfree((char*)pgdir);
8010768a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010768d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107690:	5b                   	pop    %ebx
80107691:	5e                   	pop    %esi
80107692:	5f                   	pop    %edi
80107693:	5d                   	pop    %ebp
   cow_kfree((char*)pgdir);
80107694:	e9 b7 f7 ff ff       	jmp    80106e50 <cow_kfree>
    panic("freevm: no pgdir");
80107699:	83 ec 0c             	sub    $0xc,%esp
8010769c:	68 2e 85 10 80       	push   $0x8010852e
801076a1:	e8 ea 8c ff ff       	call   80100390 <panic>
801076a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076ad:	8d 76 00             	lea    0x0(%esi),%esi

801076b0 <setupkvm>:
{
801076b0:	f3 0f 1e fb          	endbr32 
801076b4:	55                   	push   %ebp
801076b5:	89 e5                	mov    %esp,%ebp
801076b7:	56                   	push   %esi
801076b8:	53                   	push   %ebx
  if((pgdir = (pde_t*)cow_kalloc()) == 0)
801076b9:	e8 52 f8 ff ff       	call   80106f10 <cow_kalloc>
801076be:	89 c6                	mov    %eax,%esi
801076c0:	85 c0                	test   %eax,%eax
801076c2:	74 42                	je     80107706 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
801076c4:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++){
801076c7:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801076cc:	68 00 10 00 00       	push   $0x1000
801076d1:	6a 00                	push   $0x0
801076d3:	50                   	push   %eax
801076d4:	e8 d7 d4 ff ff       	call   80104bb0 <memset>
801076d9:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801076dc:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801076df:	83 ec 08             	sub    $0x8,%esp
801076e2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801076e5:	ff 73 0c             	pushl  0xc(%ebx)
801076e8:	8b 13                	mov    (%ebx),%edx
801076ea:	50                   	push   %eax
801076eb:	29 c1                	sub    %eax,%ecx
801076ed:	89 f0                	mov    %esi,%eax
801076ef:	e8 6c f9 ff ff       	call   80107060 <mappages>
801076f4:	83 c4 10             	add    $0x10,%esp
801076f7:	85 c0                	test   %eax,%eax
801076f9:	78 15                	js     80107710 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++){
801076fb:	83 c3 10             	add    $0x10,%ebx
801076fe:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107704:	75 d6                	jne    801076dc <setupkvm+0x2c>
}
80107706:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107709:	89 f0                	mov    %esi,%eax
8010770b:	5b                   	pop    %ebx
8010770c:	5e                   	pop    %esi
8010770d:	5d                   	pop    %ebp
8010770e:	c3                   	ret    
8010770f:	90                   	nop
      freevm(pgdir);
80107710:	83 ec 0c             	sub    $0xc,%esp
80107713:	56                   	push   %esi
      return 0;
80107714:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107716:	e8 15 ff ff ff       	call   80107630 <freevm>
      return 0;
8010771b:	83 c4 10             	add    $0x10,%esp
}
8010771e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107721:	89 f0                	mov    %esi,%eax
80107723:	5b                   	pop    %ebx
80107724:	5e                   	pop    %esi
80107725:	5d                   	pop    %ebp
80107726:	c3                   	ret    
80107727:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010772e:	66 90                	xchg   %ax,%ax

80107730 <kvmalloc>:
{
80107730:	f3 0f 1e fb          	endbr32 
80107734:	55                   	push   %ebp
80107735:	89 e5                	mov    %esp,%ebp
80107737:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010773a:	e8 71 ff ff ff       	call   801076b0 <setupkvm>
8010773f:	a3 24 1a 13 80       	mov    %eax,0x80131a24
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107744:	05 00 00 00 80       	add    $0x80000000,%eax
80107749:	0f 22 d8             	mov    %eax,%cr3
}
8010774c:	c9                   	leave  
8010774d:	c3                   	ret    
8010774e:	66 90                	xchg   %ax,%ax

80107750 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107750:	f3 0f 1e fb          	endbr32 
80107754:	55                   	push   %ebp
  pte_t *pte;
  pte = walkpgdir(pgdir, uva, 0);
80107755:	31 c9                	xor    %ecx,%ecx
{
80107757:	89 e5                	mov    %esp,%ebp
80107759:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
8010775c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010775f:	8b 45 08             	mov    0x8(%ebp),%eax
80107762:	e8 79 f8 ff ff       	call   80106fe0 <walkpgdir>
  if(pte == 0)
80107767:	85 c0                	test   %eax,%eax
80107769:	74 05                	je     80107770 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
8010776b:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010776e:	c9                   	leave  
8010776f:	c3                   	ret    
    panic("clearpteu");
80107770:	83 ec 0c             	sub    $0xc,%esp
80107773:	68 3f 85 10 80       	push   $0x8010853f
80107778:	e8 13 8c ff ff       	call   80100390 <panic>
8010777d:	8d 76 00             	lea    0x0(%esi),%esi

80107780 <cow_copyuvm>:

pde_t*
cow_copyuvm(pde_t *pgdir, uint sz)
{
80107780:	f3 0f 1e fb          	endbr32 
80107784:	55                   	push   %ebp
80107785:	89 e5                	mov    %esp,%ebp
80107787:	57                   	push   %edi
80107788:	56                   	push   %esi
80107789:	53                   	push   %ebx
8010778a:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags, newflags;
  if((d = setupkvm()) == 0)
8010778d:	e8 1e ff ff ff       	call   801076b0 <setupkvm>
80107792:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107795:	85 c0                	test   %eax,%eax
80107797:	0f 84 d1 00 00 00    	je     8010786e <cow_copyuvm+0xee>
    return 0;
  //cprintf("cow : pages = %d\n", 57344 - sys_get_number_of_free_pages_impl());

  // cprintf("cow_copyuvm : pages = %d\n", 57344 - sys_get_number_of_free_pages_impl());
  for(i = 0; i < sz; i += PGSIZE){
8010779d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801077a0:	85 db                	test   %ebx,%ebx
801077a2:	0f 84 d8 00 00 00    	je     80107880 <cow_copyuvm+0x100>
801077a8:	31 ff                	xor    %edi,%edi
801077aa:	eb 23                	jmp    801077cf <cow_copyuvm+0x4f>
801077ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      // cprintf("cow2");
      goto bad;
    }
    // cprintf("cow2");
    // update parents flags
    *pte |= PTE_FLAGS((PTE_W & flags ? PTE_COW : 0));
801077b0:	c1 e3 0a             	shl    $0xa,%ebx
  for(i = 0; i < sz; i += PGSIZE){
801077b3:	81 c7 00 10 00 00    	add    $0x1000,%edi
    *pte |= PTE_FLAGS((PTE_W & flags ? PTE_COW : 0));
801077b9:	81 e3 00 08 00 00    	and    $0x800,%ebx
801077bf:	0b 1e                	or     (%esi),%ebx
    *pte &= ~PTE_W;
801077c1:	83 e3 fd             	and    $0xfffffffd,%ebx
801077c4:	89 1e                	mov    %ebx,(%esi)
  for(i = 0; i < sz; i += PGSIZE){
801077c6:	39 7d 0c             	cmp    %edi,0xc(%ebp)
801077c9:	0f 86 b1 00 00 00    	jbe    80107880 <cow_copyuvm+0x100>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801077cf:	8b 45 08             	mov    0x8(%ebp),%eax
801077d2:	31 c9                	xor    %ecx,%ecx
801077d4:	89 fa                	mov    %edi,%edx
801077d6:	e8 05 f8 ff ff       	call   80106fe0 <walkpgdir>
801077db:	89 c6                	mov    %eax,%esi
801077dd:	85 c0                	test   %eax,%eax
801077df:	0f 84 db 00 00 00    	je     801078c0 <cow_copyuvm+0x140>
    if(!(*pte & PTE_P))
801077e5:	8b 18                	mov    (%eax),%ebx
801077e7:	f6 c3 01             	test   $0x1,%bl
801077ea:	0f 84 c3 00 00 00    	je     801078b3 <cow_copyuvm+0x133>
    pa = PTE_ADDR(*pte);
801077f0:	89 d8                	mov    %ebx,%eax
801077f2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801077f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    newflags = flags & (~PTE_W);
801077fa:	89 d8                	mov    %ebx,%eax
801077fc:	25 fd 0f 00 00       	and    $0xffd,%eax
      newflags |= PTE_COW;
80107801:	89 c2                	mov    %eax,%edx
80107803:	80 ce 08             	or     $0x8,%dh
80107806:	f6 c3 02             	test   $0x2,%bl
80107809:	0f 45 c2             	cmovne %edx,%eax
    acquire(cow_lock);
8010780c:	83 ec 0c             	sub    $0xc,%esp
8010780f:	ff 35 40 ef 11 80    	pushl  0x8011ef40
      newflags |= PTE_COW;
80107815:	89 45 e0             	mov    %eax,-0x20(%ebp)
    acquire(cow_lock);
80107818:	e8 83 d2 ff ff       	call   80104aa0 <acquire>
    release(cow_lock);
8010781d:	58                   	pop    %eax
    pg_ref_counts[PGROUNDDOWN(pa)/PGSIZE]++;
8010781e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    release(cow_lock);
80107821:	ff 35 40 ef 11 80    	pushl  0x8011ef40
    pg_ref_counts[PGROUNDDOWN(pa)/PGSIZE]++;
80107827:	c1 ea 0c             	shr    $0xc,%edx
8010782a:	80 82 40 0f 11 80 01 	addb   $0x1,-0x7feef0c0(%edx)
    release(cow_lock);
80107831:	e8 2a d3 ff ff       	call   80104b60 <release>
    if(mappages(d, (void*)i, PGSIZE, pa, newflags) < 0) {
80107836:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107839:	5a                   	pop    %edx
8010783a:	89 fa                	mov    %edi,%edx
8010783c:	59                   	pop    %ecx
8010783d:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107842:	50                   	push   %eax
80107843:	8b 45 dc             	mov    -0x24(%ebp),%eax
80107846:	ff 75 e4             	pushl  -0x1c(%ebp)
80107849:	e8 12 f8 ff ff       	call   80107060 <mappages>
8010784e:	83 c4 10             	add    $0x10,%esp
80107851:	85 c0                	test   %eax,%eax
80107853:	0f 89 57 ff ff ff    	jns    801077b0 <cow_copyuvm+0x30>
  lcr3(V2P(pgdir));
  return d;

bad:
  // release(cow_lock);
  freevm(d);
80107859:	83 ec 0c             	sub    $0xc,%esp
8010785c:	ff 75 dc             	pushl  -0x24(%ebp)
8010785f:	e8 cc fd ff ff       	call   80107630 <freevm>
  return 0;
80107864:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
8010786b:	83 c4 10             	add    $0x10,%esp
}
8010786e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80107871:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107874:	5b                   	pop    %ebx
80107875:	5e                   	pop    %esi
80107876:	5f                   	pop    %edi
80107877:	5d                   	pop    %ebp
80107878:	c3                   	ret    
80107879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("movl %%cr3,%0" : "=r" (val));
80107880:	0f 20 d8             	mov    %cr3,%eax
  if (rcr3() != V2P(pgdir)){
80107883:	8b 4d 08             	mov    0x8(%ebp),%ecx
80107886:	8d 99 00 00 00 80    	lea    -0x80000000(%ecx),%ebx
8010788c:	39 c3                	cmp    %eax,%ebx
8010788e:	74 15                	je     801078a5 <cow_copyuvm+0x125>
80107890:	0f 20 d8             	mov    %cr3,%eax
    cprintf("old %x new %x\n", rcr3(), V2P(pgdir));
80107893:	83 ec 04             	sub    $0x4,%esp
80107896:	53                   	push   %ebx
80107897:	50                   	push   %eax
80107898:	68 7d 85 10 80       	push   $0x8010857d
8010789d:	e8 0e 8e ff ff       	call   801006b0 <cprintf>
801078a2:	83 c4 10             	add    $0x10,%esp
  asm volatile("movl %0,%%cr3" : : "r" (val));
801078a5:	0f 22 db             	mov    %ebx,%cr3
}
801078a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
801078ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078ae:	5b                   	pop    %ebx
801078af:	5e                   	pop    %esi
801078b0:	5f                   	pop    %edi
801078b1:	5d                   	pop    %ebp
801078b2:	c3                   	ret    
      panic("copyuvm: page not present");
801078b3:	83 ec 0c             	sub    $0xc,%esp
801078b6:	68 63 85 10 80       	push   $0x80108563
801078bb:	e8 d0 8a ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
801078c0:	83 ec 0c             	sub    $0xc,%esp
801078c3:	68 49 85 10 80       	push   $0x80108549
801078c8:	e8 c3 8a ff ff       	call   80100390 <panic>
801078cd:	8d 76 00             	lea    0x0(%esi),%esi

801078d0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801078d0:	f3 0f 1e fb          	endbr32 
801078d4:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801078d5:	31 c9                	xor    %ecx,%ecx
{
801078d7:	89 e5                	mov    %esp,%ebp
801078d9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801078dc:	8b 55 0c             	mov    0xc(%ebp),%edx
801078df:	8b 45 08             	mov    0x8(%ebp),%eax
801078e2:	e8 f9 f6 ff ff       	call   80106fe0 <walkpgdir>
  if((*pte & PTE_P) == 0)
801078e7:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801078e9:	c9                   	leave  
  if((*pte & PTE_U) == 0)
801078ea:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801078ec:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801078f1:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801078f4:	05 00 00 00 80       	add    $0x80000000,%eax
801078f9:	83 fa 05             	cmp    $0x5,%edx
801078fc:	ba 00 00 00 00       	mov    $0x0,%edx
80107901:	0f 45 c2             	cmovne %edx,%eax
}
80107904:	c3                   	ret    
80107905:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010790c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107910 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107910:	f3 0f 1e fb          	endbr32 
80107914:	55                   	push   %ebp
80107915:	89 e5                	mov    %esp,%ebp
80107917:	57                   	push   %edi
80107918:	56                   	push   %esi
80107919:	53                   	push   %ebx
8010791a:	83 ec 0c             	sub    $0xc,%esp
8010791d:	8b 75 14             	mov    0x14(%ebp),%esi
80107920:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107923:	85 f6                	test   %esi,%esi
80107925:	75 3c                	jne    80107963 <copyout+0x53>
80107927:	eb 67                	jmp    80107990 <copyout+0x80>
80107929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107930:	8b 55 0c             	mov    0xc(%ebp),%edx
80107933:	89 fb                	mov    %edi,%ebx
80107935:	29 d3                	sub    %edx,%ebx
80107937:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010793d:	39 f3                	cmp    %esi,%ebx
8010793f:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107942:	29 fa                	sub    %edi,%edx
80107944:	83 ec 04             	sub    $0x4,%esp
80107947:	01 c2                	add    %eax,%edx
80107949:	53                   	push   %ebx
8010794a:	ff 75 10             	pushl  0x10(%ebp)
8010794d:	52                   	push   %edx
8010794e:	e8 fd d2 ff ff       	call   80104c50 <memmove>
    len -= n;
    buf += n;
80107953:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80107956:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
8010795c:	83 c4 10             	add    $0x10,%esp
8010795f:	29 de                	sub    %ebx,%esi
80107961:	74 2d                	je     80107990 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80107963:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107965:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107968:	89 55 0c             	mov    %edx,0xc(%ebp)
8010796b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107971:	57                   	push   %edi
80107972:	ff 75 08             	pushl  0x8(%ebp)
80107975:	e8 56 ff ff ff       	call   801078d0 <uva2ka>
    if(pa0 == 0)
8010797a:	83 c4 10             	add    $0x10,%esp
8010797d:	85 c0                	test   %eax,%eax
8010797f:	75 af                	jne    80107930 <copyout+0x20>
  }
  return 0;
}
80107981:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107984:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107989:	5b                   	pop    %ebx
8010798a:	5e                   	pop    %esi
8010798b:	5f                   	pop    %edi
8010798c:	5d                   	pop    %ebp
8010798d:	c3                   	ret    
8010798e:	66 90                	xchg   %ax,%ax
80107990:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107993:	31 c0                	xor    %eax,%eax
}
80107995:	5b                   	pop    %ebx
80107996:	5e                   	pop    %esi
80107997:	5f                   	pop    %edi
80107998:	5d                   	pop    %ebp
80107999:	c3                   	ret    
8010799a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801079a0 <copy_page>:
    cprintf("PGFAULT C\n");
    swap_in(p, pi_to_swapin);
  }
}
#endif
int copy_page(pde_t* pgdir, pte_t* pte_ptr){
801079a0:	f3 0f 1e fb          	endbr32 
801079a4:	55                   	push   %ebp
801079a5:	89 e5                	mov    %esp,%ebp
801079a7:	57                   	push   %edi
801079a8:	56                   	push   %esi
801079a9:	53                   	push   %ebx
801079aa:	83 ec 0c             	sub    $0xc,%esp
801079ad:	8b 7d 0c             	mov    0xc(%ebp),%edi
  
  uint pa = PTE_ADDR(*pte_ptr);
801079b0:	8b 37                	mov    (%edi),%esi
801079b2:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  // release(cow_lock);
  char* mem = cow_kalloc();
801079b8:	e8 53 f5 ff ff       	call   80106f10 <cow_kalloc>
  // acquire(cow_lock);
  if (mem == 0){
801079bd:	85 c0                	test   %eax,%eax
801079bf:	74 3e                	je     801079ff <copy_page+0x5f>
    return -1;
  }

  // cprintf("copying page old pa %x new pa %x\n", pa, V2P(mem));

  memmove(mem, P2V(pa), PGSIZE);
801079c1:	83 ec 04             	sub    $0x4,%esp
801079c4:	81 c6 00 00 00 80    	add    $0x80000000,%esi
801079ca:	89 c3                	mov    %eax,%ebx
801079cc:	68 00 10 00 00       	push   $0x1000

  // *pte_ptr = PTE_ADDR(P2V(mem)) | PTE_U | PTE_W | PTE_P;
  *pte_ptr = PTE_ADDR(V2P(mem)) | PTE_FLAGS(*pte_ptr) | PTE_W | PTE_P | PTE_U;
801079d1:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
  memmove(mem, P2V(pa), PGSIZE);
801079d7:	56                   	push   %esi
  *pte_ptr = PTE_ADDR(V2P(mem)) | PTE_FLAGS(*pte_ptr) | PTE_W | PTE_P | PTE_U;
801079d8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  memmove(mem, P2V(pa), PGSIZE);
801079de:	50                   	push   %eax
801079df:	e8 6c d2 ff ff       	call   80104c50 <memmove>
  *pte_ptr = PTE_ADDR(V2P(mem)) | PTE_FLAGS(*pte_ptr) | PTE_W | PTE_P | PTE_U;
801079e4:	8b 07                	mov    (%edi),%eax
  return 0;
801079e6:	83 c4 10             	add    $0x10,%esp
  *pte_ptr = PTE_ADDR(V2P(mem)) | PTE_FLAGS(*pte_ptr) | PTE_W | PTE_P | PTE_U;
801079e9:	25 ff 0f 00 00       	and    $0xfff,%eax
801079ee:	09 c3                	or     %eax,%ebx
  return 0;
801079f0:	31 c0                	xor    %eax,%eax
  *pte_ptr = PTE_ADDR(V2P(mem)) | PTE_FLAGS(*pte_ptr) | PTE_W | PTE_P | PTE_U;
801079f2:	83 cb 07             	or     $0x7,%ebx
801079f5:	89 1f                	mov    %ebx,(%edi)
}
801079f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801079fa:	5b                   	pop    %ebx
801079fb:	5e                   	pop    %esi
801079fc:	5f                   	pop    %edi
801079fd:	5d                   	pop    %ebp
801079fe:	c3                   	ret    
    return -1;
801079ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107a04:	eb f1                	jmp    801079f7 <copy_page+0x57>
